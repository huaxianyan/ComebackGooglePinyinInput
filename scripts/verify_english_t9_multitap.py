#!/usr/bin/env python3
"""Verify the optional multi-tap letter selection of the English 9-key keyboard.

Multi-tap is an option of the single English 9-key keyboard, not a separate
layout. The 9-key IME definition keeps its string id, keyboard group and label,
and only its IME class is redirected to a compat subclass. With the option off
that subclass delegates every entry point to the original English9KeyIme, so the
stock keyboard definition, soft keys and behaviour are preserved and the native
keyboard-layout dashboard keeps listing the same English entries.
"""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IME_CLASS = "com.google.android.inputmethod.pinyin.EnglishT9MultiTapIme"
ORIGINAL_IME_CLASS = (
    "com.google.android.apps.inputmethod.libs.english.ime.English9KeyIme"
)
PREF_KEY = "en_t9_multitap_interval_ms"
ENABLED_KEY = "en_t9_multitap_enabled"
INTERVAL_VALUES = ("300", "400", "500", "600", "800", "1000")
LOCALES = ("values", "values-zh", "values-zh-rTW", "values-zh-rHK")
ADDITIVE_IME_RESOURCE = "ime_en_t9_multitap"
ADDITIVE_KEYBOARD_RESOURCE = "keyboard_en_t9_multitap"


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
            # With the option off every entry point must fall back to the stock
            # English 9-key implementation.
            "Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "English9KeyIme;->handle(Lcom/google/android/apps/inputmethod/libs/"
            "framework/core/Event;)Z",
            "if-eqz v3, :compat_delegate",
            "Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "English9KeyIme;->computeShouldShowSuggestions("
            "Landroid/view/inputmethod/EditorInfo;)Z",
            "Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "EnglishIme;->computeShouldEnableAutoCorrection("
            "Landroid/view/inputmethod/EditorInfo;)Z",
            "Lcom/google/android/apps/inputmethod/libs/english/ime/"
            "English9KeyIme;->requestCandidates(I)V",
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
            '"en_t9_multitap_enabled"',
            ".method private enabled()Z",
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
        "English 9-key multi-tap Smali",
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

    # The separate multi-tap layout must stay deleted.
    for name in (ADDITIVE_IME_RESOURCE, ADDITIVE_KEYBOARD_RESOURCE):
        if (ROOT / f"patches/res/xml/{name}.xml").exists():
            raise RuntimeError(f"a separate multi-tap layout is back: {name}.xml")

    values = (ROOT / "patches/res/values/en_t9_multitap.xml").read_text(
        encoding="utf-8"
    )
    require_all(
        values,
        (
            f'<string name="pref_key_en_t9_multitap_interval_ms">{PREF_KEY}</string>',
            '<string name="pref_def_value_en_t9_multitap_interval_ms">600</string>',
            f'<string name="pref_key_en_t9_multitap_enabled">{ENABLED_KEY}</string>',
            '<bool name="pref_def_value_en_t9_multitap_enabled">false</bool>',
            '<string-array name="entries_en_t9_multitap_interval_ms">',
            '<string-array name="values_en_t9_multitap_interval_ms">',
            *(f"<item>{value}</item>" for value in INTERVAL_VALUES),
        ),
        "multi-tap preference resources",
    )
    for forbidden in ("english_t9_multitap_ime_label", "keyboard_en_t9_multitap"):
        if forbidden in values:
            raise RuntimeError(
                f"multi-tap resources still declare a separate layout: {forbidden}"
            )

    for qualifier in LOCALES:
        localized = (ROOT / "patches/res" / qualifier / "en_t9_multitap.xml").read_text(
            encoding="utf-8"
        )
        require_all(
            localized,
            (
                'name="setting_en_t9_multitap_enabled_title"',
                'name="setting_en_t9_multitap_enabled_summary"',
                'name="setting_en_t9_multitap_interval_title"',
                'name="setting_en_t9_multitap_interval_summary"',
            ),
            f"multi-tap strings in {qualifier}",
        )

    apply_patches = (ROOT / "scripts/apply_patches.py").read_text(encoding="utf-8")
    require_all(
        apply_patches,
        (
            '"EnglishT9MultiTapIme.smali",',
            # Only the IME class of the 9-key definition is redirected.
            f'class="{ORIGINAL_IME_CLASS}"',
            f'class="{IME_CLASS}"',
            'android:key="@string/pref_key_en_t9_multitap_interval_ms"',
            'android:dependency="@string/pref_key_en_t9_multitap_enabled"',
            'android:key="@string/pref_key_en_t9_multitap_enabled"',
            'android:defaultValue="@bool/pref_def_value_en_t9_multitap_enabled"',
            'android:entries="@array/entries_en_t9_multitap_interval_ms"',
            'android:entryValues="@array/values_en_t9_multitap_interval_ms"',
            'android:defaultValue="@string/pref_def_value_en_t9_multitap_interval_ms"',
        ),
        "multi-tap patch wiring",
    )
    for forbidden in (
        ADDITIVE_IME_RESOURCE,
        ADDITIVE_KEYBOARD_RESOURCE,
        # The English software-keyboard framework list must keep only the
        # original two entries.
        "framework_english_soft.xml",
        "keyboard_en_9key.xml",
        "softkeys_9key.xml",
    ):
        if forbidden in apply_patches:
            raise RuntimeError(
                f"multi-tap patch still touches a separate keyboard: {forbidden}"
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
    booleans = (compose / "BooleanSettingContracts.kt").read_text(encoding="utf-8")
    require_all(
        booleans,
        (
            "val enT9MultitapEnabled = BooleanSettingContract(",
            f'key = "{ENABLED_KEY}"',
            "defaultValue = false,",
            "val englishMultiTapBatch = listOf(",
            "englishMultiTapBatch +",
        ),
        "Compose multi-tap switch contract",
    )
    repository = (compose / "LegacySettingsRepository.kt").read_text(encoding="utf-8")
    require_all(
        repository,
        (
            "ListSettingContracts.englishT9MultitapInterval",
            "BooleanSettingContracts.enT9MultitapEnabled",
            "fun setEnglishT9MultitapIntervalIndex(index: Int): SettingsSnapshot",
            "require(readBoolean(BooleanSettingContracts.enT9MultitapEnabled).value)",
            "val englishT9MultitapEnabled: BooleanSettingState",
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
            '"setting_en_t9_multitap_enabled_title"',
            "BooleanSettingContracts.enT9MultitapEnabled",
            '"setting_en_t9_multitap_interval_title"',
            "snapshot.englishT9MultitapIntervalIndex",
            "snapshot.englishT9MultitapIntervalLabels",
            "actions.onEnglishT9MultitapIntervalChange",
            # The window row must hang off the switch.
            "enabled = snapshot.englishT9MultitapEnabled.value,",
        ),
        "Compose multi-tap English screen",
    )
    switch_row = screen.index("englishT9MultitapEnabled")
    interval_row = screen.index("englishT9MultitapIntervalIndex")
    correction_row = screen.index('"setting_spell_correction_title"')
    if switch_row >= interval_row:
        raise RuntimeError("Compose multi-tap switch is not above the interval row")
    if interval_row >= correction_row:
        raise RuntimeError("Compose multi-tap rows are not the first English rows")
    for qualifier in LOCALES:
        strings = (root / "res" / qualifier / "strings.xml").read_text(
            encoding="utf-8"
        )
        require_all(
            strings,
            (
                'name="modern_settings_english_t9_multitap_enabled_title"',
                'name="modern_settings_english_t9_multitap_enabled_summary"',
                'name="modern_settings_english_t9_multitap_interval_title"',
            ),
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
        ),
        "English software-keyboard framework list",
    )
    if ADDITIVE_IME_RESOURCE in framework:
        raise RuntimeError("the keyboard dashboard still lists a separate layout")

    # The 9-key IME keeps its identity and only changes class.
    original_ime = (resources / "xml/ime_en_9key.xml").read_text(encoding="utf-8")
    require_all(
        original_ime,
        (
            f'class="{IME_CLASS}"',
            'string_id="en_9key"',
            'def="@xml/keyboard_en_9key"',
            'label="@string/english_9key_ime_label"',
        ),
        "English 9-key IME definition",
    )
    if ORIGINAL_IME_CLASS in original_ime:
        raise RuntimeError("English 9-key IME class was not redirected")

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
        "English 9-key keyboard",
    )
    if ADDITIVE_KEYBOARD_RESOURCE in original_keyboard:
        raise RuntimeError("English 9-key keyboard was rewritten")

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
        "English 9-key soft keys",
    )

    for name in (ADDITIVE_IME_RESOURCE, ADDITIVE_KEYBOARD_RESOURCE):
        if (resources / "xml" / f"{name}.xml").exists():
            raise RuntimeError(f"packaged a separate multi-tap layout: {name}.xml")

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
            'android:dependency="@string/pref_key_en_t9_multitap_enabled"',
            'android:key="@string/pref_key_en_t9_multitap_enabled"',
            'android:defaultValue="@bool/pref_def_value_en_t9_multitap_enabled"',
            'android:entries="@array/entries_en_t9_multitap_interval_ms"',
            'android:entryValues="@array/values_en_t9_multitap_interval_ms"',
            'android:defaultValue="@string/pref_def_value_en_t9_multitap_interval_ms"',
        ),
        "legacy multi-tap preferences",
    )
    english_category = setting.index('android:key="@string/setting_english_input_key"')
    switch = setting.index('android:key="@string/pref_key_en_t9_multitap_enabled"')
    interval = setting.index(
        'android:key="@string/pref_key_en_t9_multitap_interval_ms"'
    )
    if switch <= english_category:
        raise RuntimeError("multi-tap switch is not inside the English input category")
    if switch >= interval:
        raise RuntimeError("multi-tap switch is not above the interval preference")

    packaged_values = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (resources / "values").glob("*.xml")
    )
    require_all(
        packaged_values,
        (
            f'<string name="pref_key_en_t9_multitap_interval_ms">{PREF_KEY}</string>',
            '<string name="pref_def_value_en_t9_multitap_interval_ms">600</string>',
            f'<string name="pref_key_en_t9_multitap_enabled">{ENABLED_KEY}</string>',
            '<bool name="pref_def_value_en_t9_multitap_enabled">false</bool>',
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
    print("English 9-key multi-tap option contracts verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
