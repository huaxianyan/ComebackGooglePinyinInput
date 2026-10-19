#!/usr/bin/env python3
"""Verify the paired-punctuation completion contracts.

The processor appends the matching closing symbol after an opening symbol and
then offsets the caret so it lands between the two. It must never touch the
other symbol keys, and it must stay a no-op when the preference is off.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

CLASS = "com/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor"
# The stock implementation the English 9-key override falls back to.
STOCK_IME = "com/google/android/apps/inputmethod/libs/english/ime/English9KeyIme"
PROCESSOR_ID = "@id/ime_paired_punctuation_processor"
PREFERENCE_KEY = "enable_paired_punctuation_completion"
PROCESSOR_XML = (
    "res/xml/processors_zh_cn_pinyin_qwerty.xml",
    "res/xml/processors_zh_cn_pinyin_9key.xml",
    "res/xml/processors_zh_cn_handwriting.xml",
    "res/xml/processors_zh_cn_stroke.xml",
)


def fail(message: str) -> None:
    raise SystemExit(f"paired punctuation contract violated: {message}")


def smali_literal(value: str) -> str:
    """Escape a character the way the Smali assembler spells it in a literal.

    Only the straight double quote needs this: it is the one table entry whose
    Smali form differs from the character itself.
    """
    return value.replace("\\", "\\\\").replace('"', '\\"')


def unescape_smali_unicode(text: str) -> str:
    """Undo the \\uXXXX escaping a disassembler applies to non-ASCII literals.

    The source tree writes 「（」 directly; apktool hands it back as 「\\uff08」.
    Normalising the decoded text keeps this contract checkable against the final
    APK without weakening what it asserts.
    """
    return re.sub(
        r"(?<!\\)\\u([0-9a-fA-F]{4})",
        lambda match: chr(int(match.group(1), 16)),
        text,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded: Path = args.decoded.resolve()

    source = decoded / "smali" / f"{CLASS}.smali"
    if not source.is_file():
        fail(f"missing processor Smali: {source}")
    text = source.read_text(encoding="utf-8")

    # The processor must implement the processor contract the framework looks for.
    if (
        ".implements "
        "Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessor;" not in text
    ):
        fail("processor does not implement IImeProcessor")

    # Completion is driven by the HANDLE_EVENT message, not by intercepting
    # shouldHandle, so that it never depends on the processor order.
    if "ProcessMessage$b;->HANDLE_EVENT" not in text:
        fail("processor does not react to HANDLE_EVENT")
    # The CharSequence/action/boolean/int/payload factory is the COMMIT_TEXT
    # message; the message type is set inside the factory, not at the call site.
    if "Ljava/lang/CharSequence;Lcom/google/android/apps/inputmethod/libs/framework/ime/" \
       "ProcessMessage$a;ZILjava/lang/Object;" not in text:
        fail("processor does not commit the completed text")
    if "ProcessMessage;->a(IILjava/lang/Object;)" not in text:
        fail("processor does not offset the caret to sit between the symbols")

    # Only COMMIT-intent single-character presses may be completed; DECODE
    # presses belong to the decode engine and must be left alone.
    if "KeyData$a;->COMMIT" not in text:
        fail("processor does not restrict itself to COMMIT-intent key presses")
    if "KeyData$a;->DECODE" in text:
        fail("processor must not handle DECODE-intent key presses")

    # Pin the symbol table. Every pair below is reachable from the shipped symbol
    # keyboard, so dropping one is a user-visible regression. The vertical
    # quotation marks 「」 and 『』 were missing from the first cut and had to be
    # added after a device test; the decorative forms of the brace and favourite
    # pages followed the same route.
    decoded_text = unescape_smali_unicode(text)
    for opening, closing in (
        ("(", ")"),
        ("[", "]"),
        ("{", "}"),
        ("<", ">"),
        ('"', '"'),
        ("（", "）"),
        ("［", "］"),
        ("｛", "｝"),
        ("〈", "〉"),
        ("《", "》"),
        ("【", "】"),
        ("〔", "〕"),
        ("‘", "’"),
        ("“", "”"),
        ("「", "」"),
        ("『", "』"),
        ("«", "»"),
        ("‹", "›"),
        ("❛", "❜"),
        ("❝", "❞"),
        ("❨", "❩"),
        ("❲", "❳"),
        ("❴", "❵"),
        ("〘", "〙"),
        ("︵", "︶"),
        ("︷", "︸"),
        ("︹", "︺"),
        ("︻", "︼"),
        ("︽", "︾"),
        ("︿", "﹀"),
        ("﹁", "﹂"),
    ):
        for symbol in (opening, closing):
            # Let the register vary: the disassembler allocates its own, so
            # pinning v0 would fail on a rebuild that changes nothing.
            if (
                re.search(
                    r'const-string v\d+, "' + re.escape(smali_literal(symbol)) + r'"',
                    decoded_text,
                )
                is None
            ):
                fail(f"processor does not complete the {opening}{closing} pair")

    # Both the preference gate and the read of the preference must be present.
    if PREFERENCE_KEY not in text:
        fail(f"processor does not read the {PREFERENCE_KEY} preference")
    if "getBoolean" not in text:
        fail("processor does not gate itself on the stored preference")

    # The two aware interfaces are how the framework hands the processor what it
    # needs beyond the message itself: the context delegate reads the text around
    # the caret, the action delegate performs the paired deletion. ProcessorBasedIme
    # injects both right after initialize(), so dropping an interface would leave
    # the matching method unreachable and the behaviour silently gone.
    for aware in ("IImeActionProcessor", "IImeContextAwareProcessor"):
        if f"Lcom/google/android/apps/inputmethod/libs/framework/ime/{aware};" not in text:
            fail(f"processor does not implement {aware}")
    if (
        "setImeContextDelegate(Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/IImeContextDelegate;)V" not in text
    ):
        fail("processor does not accept the context delegate")
    if (
        "setImeActionDelegate(Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/IImeActionDelegate;)V" not in text
    ):
        fail("processor does not accept the action delegate")
    if (
        "IImeContextDelegate;->getTextAfterCursor(II)Ljava/lang/CharSequence;" not in text
    ):
        fail("processor never reads the text after the caret")
    # A DEL press carries no intent, so it has to be screened before the COMMIT
    # guard. Only a caret sitting between the halves of a pair is taken over, and
    # only then is the forwarded deletion replaced by one that removes both
    # halves. Unlike the completion steps this path consumes the event.
    if not re.search(r"const/16 v\d+, 0x43\b", text):
        fail("processor does not recognise the DEL key code")
    if "IImeActionDelegate;->replaceText(IILjava/lang/CharSequence;Z)V" not in text:
        fail("processor does not delete both halves on DEL")

    # Regression: backspace inside a completed pair used to delete the pair
    # before pending pinyin. Query the live decoder before reading editor text,
    # and decline DEL through the ordinary intent gate while it is composing.
    process = text.split(".method public doProcess(", 1)[1].split(".end method", 1)[0]
    composing = re.search(
        r"IImeDecodeProcessor;->isComposing\(\)Z\s+move-result (v\d+)\s+"
        r"if-nez \1, (:\w+)", process,
    )
    if composing is None or composing.start() > process.index("IImeContextDelegate;->getTextBeforeCursor"):
        fail("paired deletion must yield to pending decoder composition")
    target = re.search(r"^\s*" + re.escape(composing.group(2)) + r"\s*\n(.*)", process, re.M | re.S)
    if target is None or "KeyData$a;" not in target.group(1)[:300]:
        fail("composing DEL must continue through the native intent fallback")

    # Registration must be present and must precede the existing processors.
    for relative in PROCESSOR_XML:
        path = decoded / relative
        if not path.is_file():
            fail(f"missing processor definition: {relative}")
        body = path.read_text(encoding="utf-8")
        if PROCESSOR_ID not in body:
            fail(f"{relative} does not register the paired punctuation processor")
        ours = body.index(PROCESSOR_ID)
        for existing in (
            "@id/ime_decode_processor",
            "@id/ime_output_processor",
        ):
            if existing in body and body.index(existing) < ours:
                fail(f"{relative} places the paired punctuation processor after {existing}")

    # The switch is a general input option, so it belongs to the input-settings
    # screen right below "double-space period", and it must not stay on the
    # keyboard-settings screen. In a rebuilt APK the per-feature resource file is
    # merged into the aggregate resource files, so look for the names rather than
    # for one specific file.
    marker = "@string/pref_key_enable_paired_punctuation"
    settings = (decoded / "res/xml/setting_input.xml").read_text(encoding="utf-8")
    if marker not in settings:
        fail("setting_input.xml does not expose the preference")
    if settings.index(marker) < settings.index("@string/pref_key_enable_double_space_period"):
        fail("the paired punctuation switch must sit below the double-space switch")
    keyboard_settings = (decoded / "res/xml/setting_keyboard.xml").read_text(encoding="utf-8")
    if marker in keyboard_settings:
        fail("the paired punctuation switch must not stay in setting_keyboard.xml")
    defaults = (decoded / "res/values/arrays.xml").read_text(encoding="utf-8")
    if "@string/pref_key_enable_paired_punctuation" not in defaults:
        fail("arrays.xml does not carry the preference default")
    bools = (decoded / "res/values/bools.xml").read_text(encoding="utf-8")
    if 'name="pref_def_value_enable_paired_punctuation">true<' not in bools:
        fail("the feature must default to enabled")
    strings = (decoded / "res/values/strings.xml").read_text(encoding="utf-8")
    if f'>{PREFERENCE_KEY}<' not in strings:
        fail("the stored preference value must be the raw key, not a resource name")
    # The switch is user-facing, so every shipped Chinese locale must translate
    # it instead of falling back to the English label.
    for relative in (
        "res/values-zh/strings.xml",
        "res/values-zh-rHK/strings.xml",
        "res/values-zh-rTW/strings.xml",
    ):
        path = decoded / relative
        if not path.is_file():
            fail(f"missing localized resource file: {relative}")
        body = path.read_text(encoding="utf-8")
        if 'name="setting_paired_punctuation_title"' not in body:
            fail(f"{relative} does not translate the paired punctuation switch")

    # The paired symbols themselves must keep their original soft-key data: the
    # processor adds the closing symbol at runtime and must not rewrite them.
    for relative in (
        "res/xml/softkeys_input_symbol_sub_category_brace.xml",
        "res/xml/softkeys_punctuation_bottom_zh.xml",
    ):
        path = decoded / relative
        if not path.is_file():
            fail(f"missing symbol definition: {relative}")

    # English keyboards never read a processor chain: EnglishIme extends
    # LatinIme, and only ProcessorBasedIme reads the "<processors>" element. The
    # completion step therefore runs inside the IME, so the definition must point
    # at the subclass and both English IMEs must call the shared hook.
    hook_class = "com/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook"
    english_ime = (decoded / "res/xml/ime_en_qwerty.xml").read_text(encoding="utf-8")
    if (
        'class="com.google.android.inputmethod.pinyin.PairedPunctuationEnglishIme"'
        not in english_ime
    ):
        fail("ime_en_qwerty.xml does not use the paired punctuation IME class")
    if 'string_id="en_qwerty"' not in english_ime:
        fail("ime_en_qwerty.xml must keep its string id")

    english_ime_source = decoded / (
        "smali/com/google/android/inputmethod/pinyin/PairedPunctuationEnglishIme.smali"
    )
    if not english_ime_source.is_file():
        fail("missing the English paired punctuation IME class")
    english_text = english_ime_source.read_text(encoding="utf-8")
    if (
        "handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z"
        not in english_text
    ):
        fail("the English IME class does not override handle")
    if f"L{hook_class};->a(" not in english_text:
        fail("the English IME class does not call the shared completion hook")

    ninth_key_source = decoded / (
        "smali/com/google/android/inputmethod/pinyin/EnglishT9MultiTapIme.smali"
    )
    if not ninth_key_source.is_file():
        fail("missing the English 9-key IME class")
    ninth_text = ninth_key_source.read_text(encoding="utf-8")
    if f"L{hook_class};->a(" not in ninth_text:
        fail("the English 9-key IME class does not call the shared completion hook")
    # The symbol page of this keyboard does not push a key event: it commits a
    # chosen text candidate, which arrives through IIme.selectTextCandidate() and
    # never passes through handle(). Without an override there the symbols stay
    # unpaired, which is exactly what a device test reported.
    if (
        "selectTextCandidate(Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/Candidate;Z)V" not in ninth_text
    ):
        fail("the English 9-key IME class does not override selectTextCandidate")
    if f"L{hook_class};->a(Ljava/lang/CharSequence;)Ljava/lang/String;" not in ninth_text:
        fail("the English 9-key candidate path does not ask the shared hook")
    if "offsetSelection(II)V" not in ninth_text:
        fail("the English 9-key candidate path does not move the caret between the symbols")
    # The symbol strip offers its candidates whatever the multi-tap option says,
    # so the entry point must not consult that switch before appending the closing
    # half. It once did, and every symbol candidate stayed unpaired on a device.
    candidate_entry = ninth_text.split(
        ".method public selectTextCandidate(Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/Candidate;Z)V"
    )[-1].split(".end method")[0]
    if "enabled()" in candidate_entry:
        fail("the English 9-key candidate path is gated on the multi-tap switch")
    # Guard polarity: the stock branch is the one taken when the hook reports that
    # the candidate text has no closing half. It was written the other way round
    # once, which left every paired opener unpaired and made every unpaired symbol
    # step the caret back one character.
    after_hook = candidate_entry.split(
        f"L{hook_class};->a(Ljava/lang/CharSequence;)Ljava/lang/String;"
    )[-1]
    result_reg = re.search(r"move-result-object (v\d+)", after_hook)
    if not result_reg:
        fail("the candidate path discards the result of the shared hook")
    branch = re.search(rf"(if-\w+) {result_reg.group(1)}, (:[\w_]+)", after_hook)
    if not branch:
        fail(f"the candidate path never tests {result_reg.group(1)} from the shared hook")
    opcode, label = branch.group(1), branch.group(2)
    # The disassembler renames hand-written labels, so identify the fallback by
    # what it does rather than by the name the source tree gave it: the target
    # must be a bare super call, with none of the completion work attached.
    fallback = candidate_entry.split(f"\n    {label}\n", 1)[-1].split("\n    :", 1)[0]
    if (
        opcode != "if-eqz"
        or f"invoke-super {{p0, p1, p2}}, L{STOCK_IME};->selectTextCandidate" not in fallback
        or "commitText" in fallback
        or "offsetSelection" in fallback
    ):
        fail(
            f"the candidate path branches on a non-null closing half "
            f"({opcode} {result_reg.group(1)}, {label}); it must "
            "fall back to the stock implementation only when the hook returns null"
        )

    hook_source = decoded / f"smali/{hook_class}.smali"

    # The candidate path skips the completion for the same reason the key path
    # does: the closing half may already sit in front of the caret.
    if "getTextAfterCursor" not in candidate_entry:
        fail("the English 9-key candidate path never reads the text after the caret")
    if not hook_source.is_file():
        fail("missing the shared paired punctuation hook")
    hook_text = hook_source.read_text(encoding="utf-8")
    if PREFERENCE_KEY not in hook_text:
        fail(f"the shared hook does not read the {PREFERENCE_KEY} preference")
    if f"L{CLASS};->a(Ljava/lang/String;)Ljava/lang/String;" not in hook_text:
        fail("the shared hook must reuse the processor character table")
    if "offsetSelection(II)V" not in hook_text:
        fail("the shared hook does not offset the caret to sit between the symbols")
    # The candidate entry point keeps the switch and the table in this one place,
    # so the 9-key override cannot drift away from the key-event path.
    if (
        ".method public static a(Ljava/lang/CharSequence;)Ljava/lang/String;"
        not in hook_text
    ):
        fail("the shared hook does not offer the candidate-text entry point")
    # One switch drives both languages only while the table stays shared.
    if ".method public static a(Ljava/lang/String;)Ljava/lang/String;" not in text:
        fail("the character table must stay public so the hook can reuse it")

    # English keyboards run no processor chain, so the same two behaviours have to
    # be present in the shared hook they call from their own handle().
    if "IImeDelegate;->getTextAfterCursor(II)Ljava/lang/CharSequence;" not in hook_text:
        fail("the shared hook never reads the text after the caret")
    if not re.search(r"const/16 v\d+, 0x43\b", hook_text):
        fail("the shared hook does not recognise the DEL key code")
    if "IImeDelegate;->replaceText(IILjava/lang/CharSequence;Z)V" not in hook_text:
        fail("the shared hook does not delete both halves on DEL")

    # The context has to survive from initialize() to handle(). AbstractIme keeps
    # it in a field that is still null on the English path, so the hook holds its
    # own copy; without it every English event is declined and the feature is dead.
    if ".field public static a:Landroid/content/Context;" not in hook_text:
        fail("the shared hook does not keep the context from initialize()")
    if (
        "sput-object p0, " + "L" + hook_class + ";->a:Landroid/content/Context;"
        not in hook_text
    ):
        fail("the shared hook does not store the context it receives")
    for label, body in (
        ("English QWERTY", english_text),
        ("English 9-key", ninth_text),
    ):
        if (
            "initialize(Landroid/content/Context;"
            "Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/ImeDef;"
            "Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;)V"
            not in body
        ):
            fail(f"the {label} IME class does not override initialize")
        if f"L{hook_class};->a(Landroid/content/Context;)V" not in body:
            fail(f"the {label} IME class does not hand the context to the hook")
    # Development smoke markers must never reach a shipped build.
    for label, body in (
        ("shared hook", hook_text),
        ("English QWERTY", english_text),
        ("English 9-key", ninth_text),
    ):
        if "PairautoHook" in body:
            fail(f"the {label} still carries diagnostic logging")

    print("paired punctuation completion contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
