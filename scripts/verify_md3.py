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
            "Preference;->setLayoutResource(I)V",
        ),
        "MD3 settings decorator",
    )
    preference_layout = (decoded / "res/layout-v35/md3_preference.xml").read_text(
        encoding="utf-8"
    )
    if 'android:focusable="false"' not in preference_layout:
        raise RuntimeError("MD3 Preference rows must delegate row clicks to ListView")

    for relative in (
        "res/layout-v35/md3_preference.xml",
        "res/layout-v35/md3_preference_category.xml",
        "res/values-v35/md3_settings.xml",
        "res/values-night-v35/md3_settings.xml",
    ):
        if not (decoded / relative).is_file():
            raise RuntimeError(f"Missing MD3 settings resource: {relative}")

    print(
        "MD3 foundation verified: single-page enable/select setup, gated finish, "
        "atomic completion path and framework Preference presentation retained"
    )


if __name__ == "__main__":
    main()
