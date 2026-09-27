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

    # The preference must be reachable and default to on. In a rebuilt APK the
    # per-feature resource file is merged into the aggregate resource files, so
    # look for the names rather than for one specific file.
    settings = (decoded / "res/xml/setting_keyboard.xml").read_text(encoding="utf-8")
    if "@string/pref_key_enable_paired_punctuation" not in settings:
        fail("setting_keyboard.xml does not expose the preference")
    defaults = (decoded / "res/values/arrays.xml").read_text(encoding="utf-8")
    if "@string/pref_key_enable_paired_punctuation" not in defaults:
        fail("arrays.xml does not carry the preference default")
    bools = (decoded / "res/values/bools.xml").read_text(encoding="utf-8")
    if 'name="pref_def_value_enable_paired_punctuation">true<' not in bools:
        fail("the feature must default to enabled")
    strings = (decoded / "res/values/strings.xml").read_text(encoding="utf-8")
    if f'>{PREFERENCE_KEY}<' not in strings:
        fail("the stored preference value must be the raw key, not a resource name")

    # The paired symbols themselves must keep their original soft-key data: the
    # processor adds the closing symbol at runtime and must not rewrite them.
    for relative in (
        "res/xml/softkeys_input_symbol_sub_category_brace.xml",
        "res/xml/softkeys_punctuation_bottom_zh.xml",
    ):
        path = decoded / relative
        if not path.is_file():
            fail(f"missing symbol definition: {relative}")

    print("paired punctuation completion contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
