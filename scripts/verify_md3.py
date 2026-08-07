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

    shell = (decoded / "res/layout/first_run.xml").read_text(encoding="utf-8")
    require(shell, ("NonSwipeableFirstRunViewPager", 'android:paddingBottom="0dp"'), "first-run shell")
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
    require(state, ('const-string v1, "guide_complete"', "SharedPreferences$Editor;->commit()Z"), "completion state")

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
            "instance-of v4, v2, Laxf;",
            'const-string v2, "md3_inline_slider_preference"',
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
        "res/layout-v35/md3_inline_slider_preference.xml",
        "res/drawable-v35/bg_settings_md3_inline_action.xml",
        "res/color-v35/settings_md3_slider_title.xml",
        "res/color-v35/settings_md3_slider_supporting.xml",
        "res/color-night-v35/settings_md3_slider_title.xml",
        "res/color-night-v35/settings_md3_slider_supporting.xml",
        "smali/com/google/android/inputmethod/pinyin/Md3SwitchView.smali",
        "smali/com/google/android/inputmethod/pinyin/Md3SliderView.smali",
        "smali/com/google/android/inputmethod/pinyin/Md3SliderView$InteractionUpdateListener.smali",
        "smali/com/google/android/inputmethod/pinyin/Md3InlineSliderCompat.smali",
        "smali/com/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener.smali",
        "smali/com/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener.smali",
        "res/values-v35/md3_settings.xml",
        "res/values-night-v35/md3_settings.xml",
        "res/xml-v35/settings.xml",
    ):
        if not (decoded / relative).is_file():
            raise RuntimeError(f"Missing MD3 settings resource: {relative}")

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
                'android:layout_width="52dp"',
                'android:layout_height="48dp"',
            ),
            f"row-owned MD3 switch widget {binding_id}",
        )
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
    slider_layout = (
        decoded / "res/layout-v35/md3_inline_slider_preference.xml"
    ).read_text(encoding="utf-8")
    require(
        slider_layout,
        (
            "com.google.android.inputmethod.pinyin.Md3SliderView",
            'android:id="@id/seek_bar"',
            'android:id="@id/seek_bar_text_top"',
            'android:id="@id/seek_bar_text_left"',
            'android:id="@id/seek_bar_text_right"',
            'android:labelFor="@id/seek_bar"',
            'android:id="@id/md3_slider_reset"',
            'android:text="@string/button_default"',
            'android:textColor="@color/settings_md3_slider_supporting"',
            'android:textColor="@color/settings_md3_slider_title"',
            'android:background="@drawable/bg_settings_md3_inline_action"',
        ),
        "inline MD3 slider row",
    )
    slider_view = (
        decoded / "smali/com/google/android/inputmethod/pinyin/Md3SliderView.smali"
    ).read_text(encoding="utf-8")
    require(
        slider_view,
        (
            ".super Landroid/widget/SeekBar;",
            'const-string v0, "settings_md3_on_surface_variant"',
            'const-string v0, "settings_md3_outline_variant"',
            'const-string v0, "settings_md3_surface"',
            'const/high16 v4, 0x41000000    # 8.0f',
            'const/high16 v4, 0x41b00000    # 22.0f',
            "Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V",
            "Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;",
            "const-wide/16 v1, 0x96",
            "Md3SliderView$InteractionUpdateListener;",
            "Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V",
            "drawIndicators(Landroid/graphics/Canvas;FFF)V",
            "requestDisallowInterceptTouchEvent(Z)V",
            ".method public setEnabled(Z)V",
        ),
        "platform-independent MD3 slider rendering",
    )
    if "settings_md3_primary" in slider_view:
        raise RuntimeError("Inline MD3 sliders must use the accepted neutral palette")
    slider_base = (decoded / "smali/axf.smali").read_text(encoding="utf-8")
    require(
        slider_base,
        (
            ".method protected onBindView(Landroid/view/View;)V",
            ".method protected onClick()V",
            ".method public c(I)V",
            ".method public h(I)I",
            ".method public d()V",
            ".method public e(Landroid/view/View;)V",
            "const/16 v1, 0x23",
            "onBindDialogView(Landroid/view/View;)V",
            "Md3InlineSliderCompat;->bindReset",
        ),
        "API-35 inline slider lifecycle",
    )
    slider_listener = (decoded / "smali/axg.smali").read_text(encoding="utf-8")
    require(
        slider_listener,
        ("Laxf;->h(I)I", "Laxf;->b(I)V", "Laxf;->c(I)V"),
        "inline slider mapping, preview and commit",
    )
    reset_compat = (
        decoded / "smali/com/google/android/inputmethod/pinyin/Md3InlineSliderCompat.smali"
    ).read_text(encoding="utf-8")
    require(
        reset_compat,
        (
            "instance-of v1, p0, Laxh;",
            'const-string v1, "md3_slider_reset"',
            "Md3InlineSliderResetClickListener;",
        ),
        "inline slider default action",
    )
    for relative in (
        "smali/com/google/android/apps/inputmethod/libs/framework/preference/widget/SeekBarListPreference.smali",
        "smali/com/google/android/apps/inputmethod/libs/framework/preference/widget/VolumePreference.smali",
        "smali/com/google/android/apps/inputmethod/libs/framework/preference/widget/VibrationDurationPreference.smali",
        "smali/com/google/android/apps/inputmethod/libs/framework/preference/widget/LongPressDelayPreference.smali",
    ):
        text = (decoded / relative).read_text(encoding="utf-8")
        if ".method public c(I)V" not in text:
            raise RuntimeError(f"Inline slider persistence missing from {relative}")

    volume_slider = (
        decoded / "smali/com/google/android/apps/inputmethod/libs/framework/preference/widget/VolumePreference.smali"
    ).read_text(encoding="utf-8")
    vibration_slider = (
        decoded / "smali/com/google/android/apps/inputmethod/libs/framework/preference/widget/VibrationDurationPreference.smali"
    ).read_text(encoding="utf-8")
    for text, label, default_marker in (
        (volume_slider, "volume", "inline_system_default"),
        (vibration_slider, "vibration", "inline_vibration_default"),
    ):
        require(
            text,
            (
                ".method public h(I)I",
                "add-int/lit8 v0, p1, -0x1",
                "add-int/lit8 v1, v1, 0x1",
                default_marker,
            ),
            f"inline {label} system-default slot",
        )

    slider_xml = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (decoded / "res/xml").glob("*.xml")
    )
    slider_types = (
        "SeekBarListPreference",
        "VolumePreference",
        "VibrationDurationPreference",
        "LongPressDelayPreference",
    )
    slider_count = sum(slider_xml.count(name) for name in slider_types)
    if slider_count != 7:
        raise RuntimeError(f"Expected seven dialog-backed slider preferences, found {slider_count}")

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
        drawable_path = decoded / "res/drawable-v35" / drawable
        if not drawable_path.is_file():
            raise RuntimeError(f"Missing MD3 settings header icon: {drawable}")
        drawable_text = drawable_path.read_text(encoding="utf-8")
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
