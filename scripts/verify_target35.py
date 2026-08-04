#!/usr/bin/env python3
"""Verify Android 15 edge-to-edge and TextView audit invariants.

Activities keep narrow inset handling. The IME uses system-owned navigation-bar
avoidance through its Window, without padding or resizing the legacy InputView.
"""

from __future__ import annotations

import argparse
from pathlib import Path

FORBIDDEN_BASELINE_REFERENCES = {
    "windowOptOutEdgeToEdgeEnforcement": "temporary edge-to-edge opt-out",
    "elegantTextHeight": "speculative TextView height compensation",
    "fallbackLineSpacing": "speculative TextView line-spacing compensation",
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    apktool = (decoded / "apktool.yml").read_text(encoding="utf-8")
    if "targetSdkVersion: 35" not in apktool:
        raise RuntimeError("Android 15 verifier requires targetSdkVersion 35")

    findings: list[str] = []
    for base, pattern in ((decoded / "smali", "*.smali"), (decoded / "res", "*.xml")):
        for path in base.rglob(pattern):
            text = path.read_text(encoding="utf-8", errors="ignore")
            for token, description in FORBIDDEN_BASELINE_REFERENCES.items():
                if token in text:
                    findings.append(f"{path}: {description} ({token})")
    if findings:
        raise RuntimeError(
            "Target 35 must keep the platform behavior unmasked:\n"
            + "\n".join(findings)
        )

    # These pre-existing AppCompat layouts/listeners are part of the legacy UI,
    # not new target-35 compensation. Keep them present for an attributable
    # baseline rather than deleting framework inset behavior speculatively.
    toolbar = decoded / "res/layout-v26/abc_screen_toolbar.xml"
    if not toolbar.is_file() or 'android:fitsSystemWindows="true"' not in toolbar.read_text(
        encoding="utf-8"
    ):
        raise RuntimeError("Legacy AppCompat toolbar inset contract is missing")

    day = decoded / "res/values-v35"
    night = decoded / "res/values-night-v35"
    for directory, expected_light in ((day, "true"), (night, "false")):
        files = sorted(directory.glob("*.xml"))
        if not files:
            raise RuntimeError(f"Missing API 35 first-run style directory: {directory}")
        text = "\n".join(path.read_text(encoding="utf-8") for path in files)
        required = (
            'style name="AppThemeSelector.NoTitle"',
            "first_run_md3_surface",
            f'<item name="android:windowLightStatusBar">{expected_light}</item>',
            f'<item name="android:windowLightNavigationBar">{expected_light}</item>',
        )
        missing = [fragment for fragment in required if fragment not in text]
        if missing:
            raise RuntimeError(
                f"Incomplete API 35 first-run styles in {directory}: {missing}"
            )

    layout_v35 = decoded / "res/layout-v35"
    if layout_v35.exists() and any(layout_v35.rglob("*")):
        raise RuntimeError(
            "Unexpected target-35 layout override; native keyboard, candidate and "
            "pager geometry must remain unchanged"
        )

    helper = decoded / (
        "smali/com/google/android/inputmethod/pinyin/EdgeToEdgeCompat.smali"
    )
    listener = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat$BottomInsetsListener.smali"
    )
    if not helper.is_file() or not listener.is_file():
        raise RuntimeError("Missing narrow Android 15 bottom-inset helper")
    helper_text = helper.read_text(encoding="utf-8")
    listener_text = listener.read_text(encoding="utf-8")
    required_helper = (
        "attachFirstRun(Landroid/app/Activity;)V",
        "configureImeWindow(Landroid/inputmethodservice/InputMethodService;)V",
        "Landroid/view/Window;->setDecorFitsSystemWindows(Z)V",
        "Landroid/view/WindowManager$LayoutParams;->setFitInsetsSides(I)V",
        "Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V",
        "const/16 v2, 0xf",
        "const/16 v1, 0x23",
        "const/16 v1, 0x1e",
    )
    required_listener = (
        "Landroid/view/View$OnApplyWindowInsetsListener;",
        "Landroid/view/WindowInsets$Type;->navigationBars()I",
        "Landroid/view/WindowInsets;->getInsetsIgnoringVisibility(I)Landroid/graphics/Insets;",
        "Landroid/graphics/Insets;->bottom:I",
        "->setPadding(IIII)V",
        "Landroid/view/ViewGroup$LayoutParams;->height:I",
    )
    if "getSystemWindowInsetBottom()I" in listener_text:
        raise RuntimeError(
            "Broad system-window inset would include unrelated IME/content insets; "
            "use WindowInsets.Type.navigationBars() only"
        )
    if "Landroid/view/WindowInsets;->getInsets(I)" in listener_text:
        raise RuntimeError(
            "Visibility-sensitive navigation insets can collapse during keyboard-height "
            "reconfiguration; use getInsetsIgnoringVisibility() for a stable baseline"
        )
    missing = [item for item in required_helper if item not in helper_text]
    missing += [item for item in required_listener if item not in listener_text]
    if missing:
        raise RuntimeError(f"Incomplete Android 15 bottom-inset helper: {missing}")

    apy = (decoded / "smali/apy.smali").read_text(encoding="utf-8")
    pinyin_ime = (
        decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
    ).read_text(encoding="utf-8")
    input_view = (
        decoded
        / "smali/com/google/android/apps/inputmethod/libs/framework/core/InputView.smali"
    ).read_text(encoding="utf-8")
    if "EdgeToEdgeCompat;->attachFirstRun" not in apy:
        raise RuntimeError("First-run footer does not receive bottom insets")
    if "EdgeToEdgeCompat;->configureImeWindow" not in pinyin_ime:
        raise RuntimeError("IME lifecycle does not configure system-bar fitting")
    if "EdgeToEdgeCompat" in input_view or "->setPadding(IIII)V" in input_view:
        raise RuntimeError(
            "IME InputView must retain native padding and measurement behavior"
        )

    # setDecorFitsSystemWindows(true) is deliberately scoped to the IME helper.
    # It is not Android 15's manifest/theme opt-out: it selects Gboard's
    # non-covering IME-window mode while platform edge-to-edge remains enabled.
    decor_fit_sites: list[Path] = []
    for path in (decoded / "smali").rglob("*.smali"):
        if "setDecorFitsSystemWindows" in path.read_text(
            encoding="utf-8", errors="ignore"
        ):
            decor_fit_sites.append(path.resolve())
    if decor_fit_sites != [helper.resolve()]:
        raise RuntimeError(
            "setDecorFitsSystemWindows must be isolated to EdgeToEdgeCompat: "
            f"{decor_fit_sites}"
        )
    if "const/4 v1, 0x1" not in helper_text:
        raise RuntimeError("IME Window must use non-covering decor fitting")
    if "const/16 v2, 0xf" not in helper_text:
        raise RuntimeError(
            "IME fitInsetsSides must include LEFT|TOP|RIGHT|BOTTOM"
        )

    for relative in ("res/layout/ims_input_view.xml", "res/layout-v21/ims_input_view.xml"):
        text = (decoded / relative).read_text(encoding="utf-8")
        if text.count('android:background="?BgKeyboardArea"') != 1:
            raise RuntimeError(
                f"IME root background override or native keyboard-area loss: {relative}"
            )

    print(
        "Android 15 invariants verified: edge-to-edge is not opted out, first-run "
        "controls receive narrow insets, the IME Window owns system-bar avoidance, "
        "InputView geometry remains native, and no speculative TextView or "
        "keyboard-layout compensation was introduced"
    )


if __name__ == "__main__":
    main()
