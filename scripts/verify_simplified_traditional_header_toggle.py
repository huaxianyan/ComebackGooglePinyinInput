#!/usr/bin/env python3
"""Verify the native Simplified/Traditional Chinese Header shortcut contract."""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PREF_KEY = "show_simplified_traditional_header_toggle"
CHINESE_KEYBOARDS = (
    "keyboard_zh_cn_pinyin_qwerty.xml",
    "keyboard_zh_cn_pinyin_9key.xml",
    "keyboard_zh_cn_stroke.xml",
)


def require_all(text: str, values: tuple[str, ...], label: str) -> None:
    missing = [value for value in values if value not in text]
    if missing:
        raise RuntimeError(f"{label} is incomplete: {missing}")


def verify_sources() -> None:
    view = (ROOT / (
        "patches/java/com/google/android/inputmethod/pinyin/"
        "SimplifiedTraditionalToggleKeyView.java"
    )).read_text(encoding="utf-8")
    require_all(view, (
        f'PREFERENCE_KEY =\n            "{PREF_KEY}"',
        "PreferenceManager.getDefaultSharedPreferences(getContext())",
        "registerOnSharedPreferenceChangeListener(this)",
        "unregisterOnSharedPreferenceChangeListener(this)",
        "preferences.getBoolean(PREFERENCE_KEY, true)",
        "implements SharedPreferences.OnSharedPreferenceChangeListener,",
        "ViewTreeObserver.OnPreDrawListener",
        '"key_pos_header_access_points_menu"',
        '"key_pos_header_lang_1"',
        '"key_pos_header_lang_2"',
        'ACCESS_POINTS_OVERLAY_ID = "access_points_overlay_view"',
        'VOICE_SLOT_ID = "key_pos_header_voice"',
        "accessPointsOverlay.getVisibility() != View.VISIBLE",
        "voice.getParent() != rightSlots",
        "voiceRect.left - shortcutWidth >= occupiedRight",
        "root.offsetDescendantRectToMyCoords(descendant, rect)",
        "super.setVisibility(preferenceHidden || geometryHidden ? View.GONE : visibility)",
    ), "preference- and geometry-aware native key View")
    for forbidden in (
        "commitText(", "enable_sc_tc_conversion", ".edit()",
        "getLocationOnScreen", "getGlobalVisibleRect", "getRootView()",
    ):
        if forbidden in view:
            raise RuntimeError(f"shortcut View bypasses the native state machine: {forbidden}")

    smali = (ROOT / "patches/smali/SimplifiedTraditionalToggleKeyView.smali").read_text(
        encoding="utf-8"
    )
    require_all(smali, (
        f'.field public static final PREFERENCE_KEY:Ljava/lang/String; = "{PREF_KEY}"',
        "PreferenceManager;->getDefaultSharedPreferences",
        "SharedPreferences;->registerOnSharedPreferenceChangeListener",
        "SharedPreferences;->unregisterOnSharedPreferenceChangeListener",
        "SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z",
        "ViewTreeObserver;->addOnPreDrawListener",
        "ViewTreeObserver;->removeOnPreDrawListener",
        "ViewGroup;->offsetDescendantRectToMyCoords",
        "SoftKeyView;->setVisibility(I)V",
    ), "generated shortcut View Smali")

    softkeys = (ROOT / (
        "patches/res/xml/softkeys_header_simplified_traditional_toggle.xml"
    )).read_text(encoding="utf-8")
    require_all(softkeys, (
        'id="@id/softkey_header_simplified_mode"',
        'keycode="KEYBOARD_STATE_ON" data="ENABLE_SC_TC_CONVERSION"',
        'value="@string/label_simplified_chinese_mode"',
        'id="@id/softkey_header_traditional_mode"',
        'keycode="KEYBOARD_STATE_OFF" data="ENABLE_SC_TC_CONVERSION"',
        'value="@string/label_traditional_chinese_mode"',
    ), "native Simplified/Traditional soft keys")

    mapping = (ROOT / (
        "patches/res/xml/keymapping_header_simplified_traditional_toggle.xml"
    )).read_text(encoding="utf-8")
    require_all(mapping, (
        'view_id="@id/key_pos_header_sc_tc_toggle" '
        'key_id="@id/softkey_header_simplified_mode"',
        '<key_mapping state="ENABLE_SC_TC_CONVERSION">',
        'view_id="@id/key_pos_header_sc_tc_toggle" '
        'key_id="@id/softkey_header_traditional_mode"',
    ), "native keyboard-state mapping")

    layout = (ROOT / (
        "patches/res/layout/keyboard_prime_header_inner_chinese.xml"
    )).read_text(encoding="utf-8")
    toggle = layout.index("SimplifiedTraditionalToggleKeyView")
    voice = layout.index('android:id="@id/key_pos_header_voice"')
    if toggle >= voice:
        raise RuntimeError("Simplified/Traditional key is not left of voice/hide-keyboard")
    require_all(layout, (
        'android:id="@id/key_pos_header_access_points_menu"',
        'android:id="@id/key_pos_header_lang_1"',
        'android:id="@id/key_pos_header_lang_2"',
        'android:id="@id/key_pos_header_sc_tc_toggle"',
        'android:id="@id/key_pos_header_voice"',
    ), "Chinese idle Header layout")


def verify_decoded(decoded: Path) -> None:
    resources = decoded / "res"
    setting = (resources / "xml/setting_keyboard.xml").read_text(encoding="utf-8")
    voice = setting.index('android:key="@string/pref_key_enable_voice_input"')
    toggle = setting.index(
        'android:key="@string/pref_key_show_simplified_traditional_header_toggle"'
    )
    english = setting.index('android:key="@string/pref_key_show_english_keyboard"')
    if not voice < toggle < english:
        raise RuntimeError("legacy shortcut setting is not directly after voice input")

    values = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (resources / "values").glob("*.xml")
    )
    require_all(values, (
        f'<string name="pref_key_show_simplified_traditional_header_toggle">{PREF_KEY}</string>',
        '<bool name="pref_def_value_show_simplified_traditional_header_toggle">true</bool>',
    ), "legacy shortcut preference resources")

    references: list[str] = []
    for keyboard in (resources / "xml").glob("keyboard*.xml"):
        text = keyboard.read_text(encoding="utf-8")
        if "keymapping_header_simplified_traditional_toggle" in text:
            references.append(keyboard.name)
    if tuple(sorted(references)) != tuple(sorted(CHINESE_KEYBOARDS)):
        raise RuntimeError(f"unexpected shortcut keyboard scope: {references}")
    for name in CHINESE_KEYBOARDS:
        text = (resources / "xml" / name).read_text(encoding="utf-8")
        require_all(text, (
            'layout="@layout/keyboard_prime_header_chinese"',
            '<softkeys href="@xml/softkeys_header_simplified_traditional_toggle" />',
            '<include href="@xml/keymapping_header_simplified_traditional_toggle" />',
            '<softkeys href="@xml/softkeys_function_zh" />',
        ), f"Chinese keyboard {name}")

    original_voice_mapping = (resources / "xml/keymapping_header_zh_cn_prime.xml").read_text(
        encoding="utf-8"
    )
    require_all(original_voice_mapping, (
        'key_id="@id/softkey_voice"',
        'view_id="@id/key_pos_header_voice"',
        '<key_mapping state="NO_MICROPHONE">',
        'key_id="@id/softkey_hide_keyboard"',
    ), "original voice/hide-keyboard mapping")

    packaged_smali = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "SimplifiedTraditionalToggleKeyView.smali"
    )
    if not packaged_smali.is_file():
        raise FileNotFoundError(packaged_smali)


def verify_compose() -> None:
    root = ROOT / "modern-settings/compose-runtime/src/main"
    contracts = (root / (
        "kotlin/com/google/android/inputmethod/pinyin/modernsettings/compose/"
        "BooleanSettingContracts.kt"
    )).read_text(encoding="utf-8")
    repository = (root / (
        "kotlin/com/google/android/inputmethod/pinyin/modernsettings/compose/"
        "LegacySettingsRepository.kt"
    )).read_text(encoding="utf-8")
    screen = (root / (
        "kotlin/com/google/android/inputmethod/pinyin/modernsettings/compose/"
        "KeyboardSettingsScreens.kt"
    )).read_text(encoding="utf-8")
    require_all(contracts, (
        "val showSimplifiedTraditionalHeaderToggle = BooleanSettingContract(",
        f'key = "{PREF_KEY}"',
        "defaultValue = true",
        "headerShortcutBatch",
    ), "Compose Boolean contract")
    require_all(repository, (
        "showSimplifiedTraditionalHeaderToggle = readBoolean(",
        "BooleanSettingContracts.showSimplifiedTraditionalHeaderToggle",
        "val showSimplifiedTraditionalHeaderToggle: BooleanSettingState",
    ), "Compose repository contract")
    for qualifier in ("values", "values-zh", "values-zh-rTW", "values-zh-rHK"):
        strings = (root / "res" / qualifier / "strings.xml").read_text(encoding="utf-8")
        require_all(strings, (
            'name="modern_settings_show_simplified_traditional_header_toggle_title"',
            'name="modern_settings_show_simplified_traditional_header_toggle_summary"',
        ), f"Compose shortcut strings in {qualifier}")
    voice = screen.index('"setting_voice_input_title"')
    toggle = screen.index(
        "modern_settings_show_simplified_traditional_header_toggle_title"
    )
    english = screen.index('"setting_show_english_keyboard_title"')
    if not voice < toggle < english:
        raise RuntimeError("Compose shortcut setting is not after voice input")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, nargs="?")
    args = parser.parse_args()
    verify_sources()
    verify_compose()
    if args.decoded is not None:
        verify_decoded(args.decoded.resolve())
    print("Simplified/Traditional native Header shortcut contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
