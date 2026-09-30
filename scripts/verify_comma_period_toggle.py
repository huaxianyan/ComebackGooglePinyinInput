#!/usr/bin/env python3
"""Verify the comma and period bottom-row visibility switches.

Each switch hides one punctuation slot of the prime keyboard's bottom row by
mapping that slot to an empty soft key and letting the slot leave the layout, so
the space bar takes the freed width. The slots must keep their stock keys by
default, the URI and e-mail variants must stay dominant inside their input
types, the emoji long-press merge must not re-light a hidden slot, and no other
keyboard may be touched.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

STATES = {
    "SHOW_COMMA_KEY": "0x80000000000000",
    "SHOW_PERIOD_KEY": "0x400000000000000",
}
PREFERENCE_KEYS = ("show_comma_key", "show_period_key")
BOTTOM_SYMBOL_FILES = {
    "res/xml/keymapping_bottom_zh_cn_symbol.xml": (
        "@id/softkey_bottom_comma_zh_popup_settings",
        "@id/softkey_bottom_sentence_zh_popup_punctuation",
    ),
    "res/xml/keymapping_bottom_en_symbol.xml": (
        "@id/softkey_bottom_comma_popup_settings",
        "@id/softkey_bottom_sentence_popup_punctuation",
    ),
}
PRIME_BOTTOM_LAYOUTS = (
    "res/layout/keyboard_prime_bottom.xml",
    "res/layout-sw600dp-v13/keyboard_prime_bottom.xml",
)
EMOJI_MERGES = (
    "res/xml/keymapping_bottom_symbol_1_popup_switch_to_emoji.xml",
    "res/xml/keymapping_bottom_symbol_1_popup_switch_to_emoji_no_hint_icon.xml",
)
UNTOUCHED_KEYMAP_IDS = (
    "@id/softkey_sentence",
    "@id/softkey_comma",
    "@id/softkey_period",
    "@id/key_pos_punctuation_1",
    "@id/key_pos_punctuation_2",
)


def fail(message: str) -> None:
    raise SystemExit(f"comma/period toggle contract violated: {message}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded: Path = args.decoded.resolve()

    # 1. The two state bits exist, carry the agreed values, and the reflection
    #    mask that gates them has been widened to cover bit 58. The framework
    #    runs two checks on each registered value: it must be a subset of the
    #    mask, and it must not be owned by another state already in the shared
    #    Lkm table. Bit 56 passes the mask check but collides with
    #    abs.STATE_SINGLE_CHARACTER_CANDIDATE, which crashes the IME on launch,
    #    so the period switch lives on bit 58 instead. Bit 55 (comma) is free in
    #    the original APK; bit 58 is the next free bit that abs and bdx do not
    #    own.
    state_table = decoded / "smali/aku.smali"
    if not state_table.is_file():
        fail(f"missing state table: {state_table}")
    state_text = state_table.read_text(encoding="utf-8")
    for name, value in STATES.items():
        field = f".field public static final STATE_{name}:J = {value}L"
        if state_text.count(field) != 1:
            fail(f"{name} is not declared exactly once as {value}")
    if "const-wide v2, 0x7ffffffffffffffL" not in state_text:
        fail("the reflection mask does not cover bit 58 for the period switch")
    if "const-wide v2, 0x1ffffffffffffffL" in state_text:
        fail("the previous one-bit mask is still in place")
    if "const-wide v2, 0xffffffffffffffL" in state_text:
        fail("the original reflection mask is still in place")

    # 1b. The chosen bits must not be owned by any other state class. abs and
    #     bdx declare their own STATE_* fields in the same shared table, and a
    #     duplicate value crashes the IME. This is the check that the mask alone
    #     does not catch.
    for other in ("abs", "bdx"):
        other_path = decoded / f"smali/{other}.smali"
        if not other_path.is_file():
            fail(f"missing state owner class: {other_path}")
        other_text = other_path.read_text(encoding="utf-8")
        for name, value in STATES.items():
            if f"J = {value}L" in other_text:
                fail(f"{other} already owns {value}, which {name} is trying to use")

    # 2. The keyboard state reader consults both switches by name and only sets
    #    a span when the switch is on, so "off" leaves the slot on its stock key.
    keyboard = (
        decoded
        / "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/Keyboard.smali"
    )
    if not keyboard.is_file():
        fail(f"missing keyboard state source: {keyboard}")
    keyboard_text = keyboard.read_text(encoding="utf-8")
    for key in PREFERENCE_KEYS:
        if f'const-string v3, "{key}"' not in keyboard_text:
            fail(f"the keyboard state reader does not read {key}")
    for name, value in STATES.items():
        if f"const-wide/high16 v2, 0x{value[2:].upper()}L".replace("0X", "0x") not in keyboard_text:
            fail(f"the keyboard state reader never sets {name}")

    # 3. Each bottom-row symbol file keeps its stock mappings and adds one
    #    empty mapping per slot, guarded by the "show" state and kept out of the
    #    URI and e-mail input types.
    for relative, (comma_key, period_key) in BOTTOM_SYMBOL_FILES.items():
        source = decoded / relative
        if not source.is_file():
            fail(f"missing bottom symbol mapping: {source}")
        text = source.read_text(encoding="utf-8")
        for stock_key in (comma_key, period_key):
            if text.count(f'key_id="{stock_key}"') != 1:
                fail(f"{relative} no longer maps exactly one stock key {stock_key}")
        for name, view_id in (
            ("SHOW_COMMA_KEY", "@id/key_pos_bottom_symbol_1"),
            ("SHOW_PERIOD_KEY", "@id/key_pos_bottom_symbol_2"),
        ):
            pattern = re.compile(
                r'<key_mapping state="'
                + name
                + r'" exclude_state="INPUT_TYPE_URI,INPUT_TYPE_EMAIL_ADDRESS">\s*'
                r'<mapping view_id="'
                + re.escape(view_id)
                + r'" key_id="@id/softkey_empty" />\s*</key_mapping>'
            )
            if not pattern.search(text):
                fail(f"{relative} does not hide {view_id} when {name} is unset")
        # The empty mappings must follow the stock ones so they win the slot.
        first_hidden = text.index('state="SHOW_COMMA_KEY"')
        for stock_key in (comma_key, period_key):
            if text.index(f'key_id="{stock_key}"') > first_hidden:
                fail(f"{relative} hides a slot before its stock key can apply")

    # 4. Both bottom-row layouts declare the slots gone, which is what the
    #    framework restores when an empty soft key removes them from the row.
    for relative in PRIME_BOTTOM_LAYOUTS:
        source = decoded / relative
        if not source.is_file():
            fail(f"missing prime bottom layout: {source}")
        text = source.read_text(encoding="utf-8")
        for view_id in ("@id/key_pos_bottom_symbol_1", "@id/key_pos_bottom_symbol_2"):
            pattern = re.compile(
                r'android:id="' + re.escape(view_id) + r'" android:visibility="gone"'
            )
            if not pattern.search(text):
                fail(f"{relative} does not declare {view_id} gone")

    # 5. The emoji long-press merge excludes the comma state, or the merge would
    #    re-apply a long-press key to a slot that is meant to be gone.
    for relative in EMOJI_MERGES:
        source = decoded / relative
        if not source.is_file():
            fail(f"missing emoji merge: {source}")
        text = source.read_text(encoding="utf-8")
        for line in re.findall(r'<merge_key_mapping[^>]*>', text):
            if "SHOW_EMOJI_SWITCH_KEY" in line and "SHOW_COMMA_KEY" not in line:
                fail(f"{relative} keeps an emoji merge that ignores SHOW_COMMA_KEY")

    # 6. No other keyboard gains an empty mapping for these slots: the number,
    #    phone, handwriting, symbol and password keyboards keep their own
    #    punctuation keys untouched.
    for other in decoded.glob("res/xml/keymapping_*.xml"):
        if other.name in (
            "keymapping_bottom_zh_cn_symbol.xml",
            "keymapping_bottom_en_symbol.xml",
        ):
            continue
        text = other.read_text(encoding="utf-8")
        if "softkey_empty" in text and (
            "@id/key_pos_bottom_symbol_1" in text or "@id/key_pos_bottom_symbol_2" in text
        ):
            fail(f"{other.name} was unexpectedly changed to hide a bottom-row slot")

    # 7. The freed slot must widen the space bar, which no static layout can
    #    express, so exactly one bottom-row slot carries the reweighting view.
    #    It is only the comma slot, so the arithmetic runs once per keyboard.
    for relative in PRIME_BOTTOM_LAYOUTS:
        text = (decoded / relative).read_text(encoding="utf-8")
        owners = re.findall(
            r'<com\.google\.android\.inputmethod\.pinyin\.CommaPeriodToggleKeyView'
            r'[^>]*android:id="@id/([a-z_0-9]+)"',
            text,
        )
        if owners != ["key_pos_bottom_symbol_1"]:
            fail(f"{relative} does not give the reweighting view exactly one slot")

    # 8. The reweighting view reads both switches and moves the freed weight
    #    onto the space bar, leaving the container so every other key keeps its
    #    declared width.
    reweight_view = (
        decoded
        / "smali/com/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView.smali"
    )
    if not reweight_view.is_file():
        fail(f"missing reweighting view: {reweight_view}")
    reweight_text = reweight_view.read_text(encoding="utf-8")
    if not reweight_text.startswith(
        ".class public final Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;\n"
        ".super Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;"
    ):
        fail("the reweighting view does not build on SoftKeyView")
    for key in PREFERENCE_KEYS:
        if f'"{key}"' not in reweight_text:
            fail(f"the reweighting view does not read {key}")
    if '"key_pos_space"' not in reweight_text:
        fail("the reweighting view does not target the space bar")
    if "Landroid/widget/LinearLayout$LayoutParams;->weight:F" not in reweight_text:
        fail("the reweighting view never rewrites a layout weight")

    print("comma and period bottom-row toggle contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
