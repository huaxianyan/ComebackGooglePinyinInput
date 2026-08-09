#!/usr/bin/env python3
"""Verify the isolated single-page first-run and MD3 settings foundation."""

from __future__ import annotations

import argparse
from pathlib import Path
import xml.etree.ElementTree as ET


def require(text: str, fragments: tuple[str, ...], label: str) -> None:
    missing = [fragment for fragment in fragments if fragment not in text]
    if missing:
        raise RuntimeError(f"{label} is incomplete: {missing}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded

    arrays = ET.parse(decoded / "res/values/arrays.xml").getroot()
    expected = "@layout/first_run_single_page"
    for name in ("activation_pages", "first_run_pages", "first_run_pages_without_permission"):
        node = arrays.find(f"./array[@name='{name}']")
        items = [item.text for item in node.findall("item")] if node is not None else []
        if items != [expected]:
            raise RuntimeError(f"{name} must contain only {expected}, found {items}")

    shell_path = decoded / "res/layout/first_run.xml"
    shell = shell_path.read_text(encoding="utf-8")
    require(shell, ("NonSwipeableFirstRunViewPager",), "first-run shell")
    shell_root = ET.parse(shell_path).getroot()
    pager = next((node for node in shell_root.iter() if node.tag.endswith("NonSwipeableFirstRunViewPager")), None)
    padding_bottom = None if pager is None else pager.attrib.get("{http://schemas.android.com/apk/res/android}paddingBottom")
    if padding_bottom not in ("0dp", "0.0dip"):
        raise RuntimeError(f"first-run shell bottom padding must be zero, found {padding_bottom!r}")
    if "first_run_page_footer" in shell or "navi_next" in shell or "navi_skip" in shell:
        raise RuntimeError("Single-page first run must not retain pager navigation controls")

    page = (decoded / "res/layout/first_run_single_page.xml").read_text(encoding="utf-8")
    require(
        page,
        (
            "FirstRunSinglePage",
            "first_run_single_enable_action",
            "first_run_single_enable_done",
            "first_run_single_select_action",
            "first_run_single_select_done",
            "first_run_single_finish",
        ),
        "single first-run page",
    )

    page_logic = (
        decoded
        / "smali/com/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage.smali"
    ).read_text(encoding="utf-8")
    require(
        page_logic,
        (
            'const-string v1, "android.settings.INPUT_METHOD_SETTINGS"',
            "InputMethodManager;->showInputMethodPicker()V",
            "Lajy;->a()Z",
            "Lajy;->b()Z",
            "PinyinFirstRunActivity;->completeGuide()V",
        ),
        "single first-run page logic",
    )

    insets = (
        decoded
        / "smali/com/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener.smali"
    ).read_text(encoding="utf-8")
    require(
        insets,
        (
            ".class public final Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;",
            ".method public constructor <init>(Landroid/view/View;)V",
            "WindowInsets$Type;->systemBars()I",
            "WindowInsets$Type;->displayCutout()I",
            "Landroid/view/View;->setPadding(IIII)V",
        ),
        "single first-run system-bar insets",
    )

    state = (
        decoded
        / "smali/com/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat.smali"
    ).read_text(encoding="utf-8")
    require(
        state,
        (
            'const-string v1, "guide_complete"',
            'const-string v1, "legacy_migration_checked"',
            'const-string v3, "HAD_FIRST_RUN"',
            "SharedPreferences;->contains(Ljava/lang/String;)Z",
            "SharedPreferences$Editor;->commit()Z",
        ),
        "completion and one-time legacy migration state",
    )

    dynamic_colors = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (decoded / "res/values-v35").glob("*.xml")
    )
    require(
        dynamic_colors,
        (
            "@android:color/system_accent1_600",
            "@android:color/system_accent1_100",
            "@android:color/system_neutral2_10",
            "@android:color/system_neutral2_50",
        ),
        "API-35 dynamic MD3 first-run roles",
    )
    if not any(
        value in dynamic_colors
        for value in (
            '<item name="android:layout_height">40dp</item>',
            '<item name="android:layout_height">40.0dip</item>',
        )
    ):
        raise RuntimeError("API-35 first-run buttons must use the MD3 40dp height")
    if not any(
        value in dynamic_colors
        for value in (
            '<item name="android:elevation">0dp</item>',
            '<item name="android:elevation">0.0dip</item>',
        )
    ):
        raise RuntimeError("API-35 first-run buttons must not add legacy elevation")
    step_styles = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (decoded / "res/values").glob("*.xml")
    )
    require(
        step_styles,
        (
            "@drawable/bg_first_run_md3_tonal_button",
            "@color/first_run_md3_tonal_button_text",
        ),
        "tonal first-run step actions",
    )

    settings = (
        decoded / "smali/com/google/android/inputmethod/pinyin/Md3SettingsCompat.smali"
    ).read_text(encoding="utf-8")
    require(
        settings,
        (
            'const-string v3, "md3_preference"',
            'const-string v4, "md3_preference_category"',
            'const-string v4, "android.preference."',
            'const-string v4, "md3_switch_widget"',
            'const-string v5, "md3_switch_preference_widget"',
            "instance-of v4, v2, Landroid/preference/SwitchPreference;",
            "instance-of v4, v2, Landroid/preference/CheckBoxPreference;",
            "instance-of v4, v2, Landroid/preference/ListPreference;",
            "instance-of v4, v2, Landroid/preference/DialogPreference;",
            "Preference;->setLayoutResource(I)V",
            "Preference;->setWidgetLayoutResource(I)V",
            "Preference;->setRecycleEnabled(Z)V",
            "decorateGroup(Landroid/preference/PreferenceGroup;IIII)V",
        ),
        "MD3 settings decorator",
    )
    legacy_switch_conversion = (decoded / "smali/gc.smali").read_text(
        encoding="utf-8"
    )
    require(
        legacy_switch_conversion,
        (
            "a(Landroid/preference/PreferenceGroup;)V",
            "instance-of v1, v0, Landroid/preference/CheckBoxPreference;",
            "new-instance v1, Landroid/preference/SwitchPreference;",
        ),
        "legacy CheckBoxPreference-to-SwitchPreference conversion",
    )

    preference_layout = (decoded / "res/layout-v35/md3_preference.xml").read_text(
        encoding="utf-8"
    )
    if 'android:focusable="false"' not in preference_layout:
        raise RuntimeError("MD3 Preference rows must delegate row clicks to ListView")
    row_background = (
        decoded / "res/drawable-v35/bg_settings_md3_preference_row.xml"
    ).read_text(encoding="utf-8")
    if 'android:color="@color/settings_md3_state_layer"' not in row_background:
        raise RuntimeError("MD3 Preference ripple must use the neutral state layer")
    if "settings_md3_primary_container" in row_background:
        raise RuntimeError("MD3 Preference ripple must not retain the blue container")

    for relative in (
        "res/layout-v35/md3_preference.xml",
        "res/layout-v35/md3_preference_category.xml",
        "res/layout-v35/md3_switch_widget.xml",
        "res/layout-v35/md3_switch_preference_widget.xml",
        "smali/com/google/android/inputmethod/pinyin/Md3SwitchView.smali",
        "smali/com/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener.smali",
        "res/xml-v35/settings.xml",
    ):
        if not (decoded / relative).is_file():
            raise RuntimeError(f"Missing MD3 settings resource: {relative}")
    for directory in ("res/values-v35", "res/values-night-v35"):
        values_dir = decoded / directory
        values_text = "\n".join(
            path.read_text(encoding="utf-8") for path in values_dir.glob("*.xml")
        )
        if "settings_md3_on_surface_variant" not in values_text:
            raise RuntimeError(f"Missing MD3 settings values in {directory}")

    checkbox_widget = (decoded / "res/layout-v35/md3_switch_widget.xml").read_text(
        encoding="utf-8"
    )
    switch_widget = (
        decoded / "res/layout-v35/md3_switch_preference_widget.xml"
    ).read_text(encoding="utf-8")
    for widget, binding_id in (
        (checkbox_widget, "@android:id/checkbox"),
        (switch_widget, "@android:id/switch_widget"),
    ):
        require(
            widget,
            (
                "com.google.android.inputmethod.pinyin.Md3SwitchView",
                f'android:id="{binding_id}"',
                'android:clickable="false"',
                'android:focusable="false"',
                'android:importantForAccessibility="no"',
            ),
            f"row-owned MD3 switch widget {binding_id}",
        )
        widget_root = ET.fromstring(widget)
        width = widget_root.attrib.get("{http://schemas.android.com/apk/res/android}layout_width")
        height = widget_root.attrib.get("{http://schemas.android.com/apk/res/android}layout_height")
        if width not in ("52dp", "52.0dip") or height not in ("48dp", "48.0dip"):
            raise RuntimeError(f"MD3 switch geometry changed: {width} x {height}")
    switch_view = (
        decoded / "smali/com/google/android/inputmethod/pinyin/Md3SwitchView.smali"
    ).read_text(encoding="utf-8")
    require(
        switch_view,
        (
            ".implements Landroid/widget/Checkable;",
            "Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V",
            "Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V",
            'const/high16 v3, 0x42000000    # 32.0f',
            'const/high16 v7, 0x41800000    # 16.0f',
            'const/high16 v7, 0x41000000    # 8.0f',
            'const/high16 v10, 0x40800000    # 4.0f',
            'const-string v0, "settings_md3_on_surface_variant"',
            'const-string v0, "settings_md3_surface"',
            'const-string v0, "settings_md3_outline"',
            "Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;",
            "const-wide/16 v2, 0xc8",
            "Landroid/view/animation/DecelerateInterpolator;",
            "Md3SwitchView$AnimatorUpdateListener;",
            "isLaidOut()Z",
            "isAttachedToWindow()Z",
        ),
        "platform-independent MD3 switch rendering",
    )
    switch_listener = (
        decoded
        / "smali/com/google/android/inputmethod/pinyin/"
        "Md3SwitchView$AnimatorUpdateListener.smali"
    ).read_text(encoding="utf-8")
    require(
        switch_listener,
        (
            "ValueAnimator$AnimatorUpdateListener;",
            "ValueAnimator;->getAnimatedValue()Ljava/lang/Object;",
            "Md3SwitchView;->updatePosition",
        ),
        "MD3 switch animation listener",
    )

    android = "{http://schemas.android.com/apk/res/android}"
    header_root = ET.parse(decoded / "res/xml-v35/settings.xml").getroot()
    expected_headers = (
        ("@string/setting_input", "@drawable/ic_settings_md3_input", "setting_input", "com.google.android.apps.inputmethod.libs.framework.preference.CommonPreferenceFragment"),
        ("@string/setting_keyboard", "@drawable/ic_settings_md3_keyboard", "setting_keyboard", "com.google.android.apps.inputmethod.libs.framework.preference.CommonPreferenceFragment"),
        ("@string/setting_handwriting_input", "@drawable/ic_settings_md3_handwriting", "setting_handwriting_input", "com.google.android.apps.inputmethod.libs.framework.preference.CommonPreferenceFragment"),
        ("@string/setting_dictionary", "@drawable/ic_settings_md3_dictionary", "setting_dictionary", "com.google.android.apps.inputmethod.pinyin.preference.DictionarySettingsFragment"),
        ("@string/setting_other", "@drawable/ic_settings_md3_other", "setting_other", "com.google.android.apps.inputmethod.libs.framework.preference.CommonPreferenceFragment"),
    )
    headers = header_root.findall("header")
    if len(headers) != len(expected_headers):
        raise RuntimeError(f"MD3 settings header count changed: {len(headers)}")
    for header, (title, icon, value, fragment) in zip(headers, expected_headers):
        extras = header.findall("extra")
        actual = (
            header.get(android + "title"),
            header.get(android + "icon"),
            extras[0].get(android + "value") if len(extras) == 1 else None,
            header.get(android + "fragment"),
            extras[0].get(android + "name") if len(extras) == 1 else None,
        )
        expected_header = (title, icon, value, fragment, "PREFERENCE_FRAGMENT")
        if actual != expected_header:
            raise RuntimeError(f"MD3 settings header routing changed: {actual!r}")
        drawable = icon.removeprefix("@drawable/") + ".xml"
        drawable_candidates = (
            decoded / "res/drawable-v35" / drawable,
            decoded / "res/drawable-anydpi-v35" / drawable,
        )
        drawable_path = next((path for path in drawable_candidates if path.is_file()), None)
        if drawable_path is None:
            raise RuntimeError(f"Missing MD3 settings header icon: {drawable}")
        drawable_text = drawable_path.read_text(encoding="utf-8").replace("#ffffffff", "#FFFFFFFF")
        require(
            drawable_text,
            (
                'android:tint="@color/settings_md3_on_surface_variant"',
                'android:fillColor="#00000000"',
                'android:strokeColor="#FFFFFFFF"',
                'android:strokeWidth="1.8"',
            ),
            f"neutral outline settings header icon {drawable}",
        )

    print(
        "MD3 foundation verified: single-page setup, framework Preference "
        "semantics and five icon-bearing settings header routes retained"
    )


if __name__ == "__main__":
    main()
