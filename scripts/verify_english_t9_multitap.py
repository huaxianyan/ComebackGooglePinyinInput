#!/usr/bin/env python3
"""Verify the additive English T9 multi-tap keyboard contract.

This keyboard must be a pure addition: the original English 9-key IME, its
keyboard definition and its soft keys keep working exactly as before, and the
new IME only appears as one more English entry in the software-keyboard
framework list that the native keyboard-layout dashboard enumerates.
"""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IME_CLASS = "com.google.android.inputmethod.pinyin.EnglishT9MultiTapIme"
IME_STRING_ID = "en_t9_multitap"
IME_RESOURCE = "ime_en_t9_multitap"
KEYBOARD_RESOURCE = "keyboard_en_t9_multitap"
PREF_KEY = "en_t9_multitap_interval_ms"
INTERVAL_VALUES = ("300", "400", "500", "600", "800", "1000")
LOCALES = ("values", "values-zh", "values-zh-rTW", "values-zh-rHK")


def require_all(text: str, values: tuple[str, ...], label: str) -> None:
    missing = [value for value in values if value not in text]
    if missing:
        raise RuntimeError(f"{label} is incomplete: {missing}")


def verify_sources() -> None:
    smali = (ROOT / "patches/smali/EnglishT9MultiTapIme.smali").read_text(
        encoding="utf-8"
    )
    require_all(
        smali,
        (
            f".class public L{IME_CLASS.replace('.', '/')};",
            ".super Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "English9KeyIme;",
            ".implements Ljava/lang/Runnable;",
            "Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "English9KeyIme;-><init>()V",
            "Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "English9KeyIme;->handle(Lcom/google/android/apps/inputmethod/libs/"
            "framework/core/Event;)Z",
            'const-string v2, "abc"',
            'const-string v2, "def"',
            'const-string v2, "ghi"',
            'const-string v2, "jkl"',
            'const-string v2, "mno"',
            'const-string v2, "pqrs"',
            'const-string v2, "tuv"',
            'const-string v2, "wxyz"',
            "rem-int v15, v15, v14",
            '"en_t9_multitap_interval_ms"',
            ".method public requestCandidates(I)V",
            "Landroid/os/SystemClock;->uptimeMillis()J",
            # The pending letter must be composing text so the editor draws its
            # wait-window underline, and the run must be finished when the window
            # expires or another key takes over.
            "Lcom/google/android/apps/inputmethod/libs/framework/ime/"
            "AbstractIme;->mImeDelegate:Lcom/google/android/apps/inputmethod/libs/"
            "framework/core/IImeDelegate;",
            "Lcom/google/android/apps/inputmethod/libs/framework/core/"
            "IImeDelegate;->setComposingText(Ljava/lang/CharSequence;I)V",
            "Lcom/google/android/apps/inputmethod/libs/framework/core/"
            "IImeDelegate;->finishComposingText()V",
            "Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z",
            ".method public run()V",
            ".method private finishRun()V",
            # The 100..2000 ms clamp must skip the assignment while the parsed
            # value is already in range.
            "if-ge v0, v1, :compat_interval_low",
            "if-le v0, v1, :compat_interval_high",
        ),
        "English T9 multi-tap Smali",
    )
    # The keyboard must compose through the native IImeActionDelegate, exactly
    # like its English, Latin and 9-key parents, and never touch raw
    # InputConnection writes or the Chinese 9-key path.
    for forbidden in (
        "getCurrentInputConnection",
        "commitText(",
        "Pinyin9Key",
        "HmmPinyinT9",
        # These inverted clamp branches silently pinned every interval to 2000 ms.
        "if-lt v0, v1, :compat_interval_low",
        "if-gt v0, v1, :compat_interval_high",
    ):
        if forbidden in smali:
            raise RuntimeError(
                f"multi-tap IME leaves the audited composing path: {forbidden}"
            )
    # The letter table must stay aligned with the native digit order.
    if smali.index('"abc"') >= smali.index('"wxyz"'):
        raise RuntimeError("letter groups are not in digit order")

    ime = (ROOT / "patches/res/xml" / f"{IME_RESOURCE}.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        ime,
        (
            f'string_id="{IME_STRING_ID}"',
            f'class="{IME_CLASS}"',
            'language="en"',
            'label="@string/english_t9_multitap_ime_label"',
            f'<keyboard type="prime" def="@xml/{KEYBOARD_RESOURCE}" />',
            '<keyboard type="digit" def="@xml/keyboard_non_prime_digit" />',
            '<keyboard type="symbol" def="@xml/keyboard_non_prime_symbol" />',
        ),
        "multi-tap IME definition",
    )

    keyboard = (
        ROOT / "patches/res/xml" / f"{KEYBOARD_RESOURCE}.xml"
    ).read_text(encoding="utf-8")
    require_all(
        keyboard,
        (
            'id="@id/keyboard_en_t9_multitap"',
            'class=".keyboard.T9Keyboard"',
            'layout="@layout/keyboard_9key_body_no_deletable_label"',
            'type="header"',
            'type="body"',
            # Reuse the original English 9-key soft keys and key mappings
            # instead of duplicating a second copy of the key table.
            '<softkeys href="@xml/softkeys_input_en_9key" />',
            '<include href="@xml/keymapping_body_en_9key" />',
            '<include href="@xml/keymapping_bottom_en_9key" />',
            '<motion_event_handler class=".libs.framework.keyboard.handler.'
            'BasicMotionEventHandler" />',
        ),
        "multi-tap keyboard definition",
    )
    for forbidden in ("<softkey ", "<softkey_template "):
        if forbidden in keyboard:
            raise RuntimeError(
                f"multi-tap keyboard redefines soft keys instead of reusing them: "
                f"{forbidden}"
            )

    values = (ROOT / "patches/res/values/en_t9_multitap.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        values,
        (
            f'<string name="pref_key_en_t9_multitap_interval_ms">{PREF_KEY}</string>',
            '<string name="pref_def_value_en_t9_multitap_interval_ms">600</string>',
            '<string-array name="entries_en_t9_multitap_interval_ms">',
            '<string-array name="values_en_t9_multitap_interval_ms">',
            '<item type="id" name="keyboard_en_t9_multitap" />',
            *(f"<item>{value}</item>" for value in INTERVAL_VALUES),
        ),
        "multi-tap preference resources",
    )

    apply_patches = (ROOT / "scripts/apply_patches.py").read_text(encoding="utf-8")
    require_all(
        apply_patches,
        (
            '"EnglishT9MultiTapIme.smali",',
            '@xml/ime_en_9key"',
            f'<include href="@xml/{IME_RESOURCE}"',
            'android:key="@string/pref_key_en_t9_multitap_interval_ms"',
            'android:entries="@array/entries_en_t9_multitap_interval_ms"',
            'android:entryValues="@array/values_en_t9_multitap_interval_ms"',
            'android:defaultValue="@string/pref_def_value_en_t9_multitap_interval_ms"',
        ),
        "multi-tap patch wiring",
    )
    for forbidden in (
        "keyboard_en_9key.xml",
        "softkeys_9key.xml",
        "ime_en_9key.xml",
    ):
        if forbidden in apply_patches:
            raise RuntimeError(
                f"multi-tap patch modifies the original English 9-key: {forbidden}"
            )


def verify_compose() -> None:
    root = ROOT / "modern-settings/compose-runtime/src/main"
    compose = root / (
        "kotlin/com/google/android/inputmethod/pinyin/modernsettings/compose"
    )
    contracts = (compose / "ListSettingContracts.kt").read_text(encoding="utf-8")
    require_all(
        contracts,
        (
            "val englishT9MultitapInterval = EnumeratedListContract(",
            f'key = "{PREF_KEY}"',
            'defaultValue = "600"',
            'values = listOf("300", "400", "500", "600", "800", "1000")',
        ),
        "Compose multi-tap list contract",
    )
    repository = (compose / "LegacySettingsRepository.kt").read_text(encoding="utf-8")
    require_all(
        repository,
        (
            "ListSettingContracts.englishT9MultitapInterval",
            "fun setEnglishT9MultitapIntervalIndex(index: Int): SettingsSnapshot",
            "val englishT9MultitapIntervalIndex: Int",
            "val englishT9MultitapIntervalLabel: String",
            "val englishT9MultitapIntervalLabels: List<String>",
            '"entries_en_t9_multitap_interval_ms"',
        ),
        "Compose multi-tap repository contract",
    )
    controller = (compose / "SettingsController.kt").read_text(encoding="utf-8")
    require_all(
        controller,
        ("fun setEnglishT9MultitapIntervalIndex(index: Int): SettingsSnapshot",),
        "Compose multi-tap controller contract",
    )
    screen = (compose / "InputSettingsScreens.kt").read_text(encoding="utf-8")
    require_all(
        screen,
        (
            '"setting_en_t9_multitap_interval_title"',
            "snapshot.englishT9MultitapIntervalIndex",
            "snapshot.englishT9MultitapIntervalLabels",
            "actions.onEnglishT9MultitapIntervalChange",
        ),
        "Compose multi-tap English screen",
    )
    interval_row = screen.index("englishT9MultitapIntervalIndex")
    correction_row = screen.index('"setting_spell_correction_title"')
    if interval_row >= correction_row:
        raise RuntimeError("Compose multi-tap interval is not the first English row")
    for qualifier in LOCALES:
        strings = (root / "res" / qualifier / "strings.xml").read_text(
            encoding="utf-8"
        )
        require_all(
            strings,
            ('name="modern_settings_english_t9_multitap_interval_title"',),
            f"Compose multi-tap strings in {qualifier}",
        )


def verify_decoded(decoded: Path) -> None:
    resources = decoded / "res"

    framework = (resources / "xml/framework_english_soft.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        framework,
        (
            '<include href="@xml/ime_en_qwerty" />',
            '<include href="@xml/ime_en_9key" />',
            f'<include href="@xml/{IME_RESOURCE}" />',
        ),
        "English software-keyboard framework list",
    )
    if framework.index("@xml/ime_en_9key") >= framework.index(
        f"@xml/{IME_RESOURCE}"
    ):
        raise RuntimeError("multi-tap IME is not registered after the English 9-key IME")

    # The original English 9-key IME and keyboard must stay untouched.
    original_ime = (resources / "xml/ime_en_9key.xml").read_text(encoding="utf-8")
    require_all(
        original_ime,
        (
            "com.google.android.apps.inputmethod.libs.english.ime.English9KeyIme",
            'string_id="en_9key"',
            'def="@xml/keyboard_en_9key"',
        ),
        "original English 9-key IME",
    )
    if IME_CLASS in original_ime:
        raise RuntimeError("original English 9-key IME was rewritten")
    original_keyboard = (resources / "xml/keyboard_en_9key.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        original_keyboard,
        (
            'id="@id/keyboard_en_9key"',
            '<softkeys href="@xml/softkeys_input_en_9key" />',
            '<include href="@xml/keymapping_body_en_9key" />',
        ),
        "original English 9-key keyboard",
    )
    if "keyboard_en_t9_multitap" in original_keyboard:
        raise RuntimeError("original English 9-key keyboard was rewritten")
    original_softkeys = (resources / "xml/softkeys_9key.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        original_softkeys,
        (
            'keycode_press="KEYCODE_2"',
            'keycode_press="KEYCODE_9"',
            'key_text="abc"',
            'key_text="wxyz"',
        ),
        "original English 9-key soft keys",
    )

    new_ime = (resources / "xml" / f"{IME_RESOURCE}.xml").read_text(encoding="utf-8")
    require_all(
        new_ime,
        (f'class="{IME_CLASS}"', f'def="@xml/{KEYBOARD_RESOURCE}"'),
        "packaged multi-tap IME definition",
    )
    new_keyboard = (resources / "xml" / f"{KEYBOARD_RESOURCE}.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        new_keyboard,
        (
            'id="@id/keyboard_en_t9_multitap"',
            '<softkeys href="@xml/softkeys_input_en_9key" />',
        ),
        "packaged multi-tap keyboard definition",
    )

    packaged_smali = decoded / (
        "smali/com/google/android/inputmethod/pinyin/EnglishT9MultiTapIme.smali"
    )
    if not packaged_smali.is_file():
        raise FileNotFoundError(packaged_smali)

    setting = (resources / "xml/setting_input.xml").read_text(encoding="utf-8")
    require_all(
        setting,
        (
            'android:key="@string/pref_key_en_t9_multitap_interval_ms"',
            'android:entries="@array/entries_en_t9_multitap_interval_ms"',
            'android:entryValues="@array/values_en_t9_multitap_interval_ms"',
            'android:defaultValue="@string/pref_def_value_en_t9_multitap_interval_ms"',
        ),
        "legacy multi-tap interval preference",
    )
    english_category = setting.index('android:key="@string/setting_english_input_key"')
    interval = setting.index(
        'android:key="@string/pref_key_en_t9_multitap_interval_ms"'
    )
    if interval <= english_category:
        raise RuntimeError("multi-tap interval is not inside the English input category")

    packaged_values = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (resources / "values").glob("*.xml")
    )
    require_all(
        packaged_values,
        (
            f'<string name="pref_key_en_t9_multitap_interval_ms">{PREF_KEY}</string>',
            '<string name="pref_def_value_en_t9_multitap_interval_ms">600</string>',
        ),
        "packaged multi-tap preference resources",
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, nargs="?")
    args = parser.parse_args()
    verify_sources()
    verify_compose()
    if args.decoded is not None:
        verify_decoded(args.decoded.resolve())
    print("English T9 multi-tap keyboard contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
