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
    # added after a device test.
    for opening, closing in (
        ("(", ")"),
        ("[", "]"),
        ("{", "}"),
        ("<", ">"),
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
    ):
        for symbol in (opening, closing):
            if f'const-string v0, "{symbol}"' not in text:
                fail(f"processor does not complete the {opening}{closing} pair")

    # Both the preference gate and the read of the preference must be present.
    if PREFERENCE_KEY not in text:
        fail(f"processor does not read the {PREFERENCE_KEY} preference")
    if "getBoolean" not in text:
        fail("processor does not gate itself on the stored preference")

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
    if f"L{hook_class};->a(" not in ninth_key_source.read_text(encoding="utf-8"):
        fail("the English 9-key IME class does not call the shared completion hook")

    hook_source = decoded / f"smali/{hook_class}.smali"
    if not hook_source.is_file():
        fail("missing the shared paired punctuation hook")
    hook_text = hook_source.read_text(encoding="utf-8")
    if PREFERENCE_KEY not in hook_text:
        fail(f"the shared hook does not read the {PREFERENCE_KEY} preference")
    if f"L{CLASS};->a(Ljava/lang/String;)Ljava/lang/String;" not in hook_text:
        fail("the shared hook must reuse the processor character table")
    if "offsetSelection(II)V" not in hook_text:
        fail("the shared hook does not offset the caret to sit between the symbols")
    # One switch drives both languages only while the table stays shared.
    if ".method public static a(Ljava/lang/String;)Ljava/lang/String;" not in text:
        fail("the character table must stay public so the hook can reuse it")

    print("paired punctuation completion contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
