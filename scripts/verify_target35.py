#!/usr/bin/env python3
"""Verify Android 15 edge-to-edge and TextView audit invariants.

The accepted direction keeps platform edge-to-edge enabled, forbids speculative
TextView/candidate changes, and requires the narrow bottom-inset fixes proven by
target 35 V1 device testing for first-run controls and the IME input view.
"""

from __future__ import annotations

import argparse
from pathlib import Path

FORBIDDEN_BASELINE_REFERENCES = {
    "windowOptOutEdgeToEdgeEnforcement": "temporary edge-to-edge opt-out",
    "setDecorFitsSystemWindows": "programmatic edge-to-edge override",
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
        "attachInputView(Landroid/view/View;)V",
        "const/16 v1, 0x23",
    )
    required_listener = (
        "Landroid/view/View$OnApplyWindowInsetsListener;",
        "getSystemWindowInsetBottom()I",
        "->setPadding(IIII)V",
        "Landroid/view/ViewGroup$LayoutParams;->height:I",
    )
    missing = [item for item in required_helper if item not in helper_text]
    missing += [item for item in required_listener if item not in listener_text]
    if missing:
        raise RuntimeError(f"Incomplete Android 15 bottom-inset helper: {missing}")

    apy = (decoded / "smali/apy.smali").read_text(encoding="utf-8")
    input_view = (
        decoded
        / "smali/com/google/android/apps/inputmethod/libs/framework/core/InputView.smali"
    ).read_text(encoding="utf-8")
    if "EdgeToEdgeCompat;->attachFirstRun" not in apy:
        raise RuntimeError("First-run footer does not receive bottom insets")
    if "EdgeToEdgeCompat;->attachInputView" not in input_view:
        raise RuntimeError("IME input root does not receive bottom insets")
    for relative in ("res/layout/ims_input_view.xml", "res/layout-v21/ims_input_view.xml"):
        text = (decoded / relative).read_text(encoding="utf-8")
        if 'android:background="?BgKeyboardArea"' not in text:
            raise RuntimeError(f"IME inset region has no keyboard background: {relative}")

    print(
        "Android 15 invariants verified: edge-to-edge is not opted out, the "
        "proven first-run/IME bottom insets are applied, API-35 day/night "
        "first-run styles remain present, and no speculative TextView or "
        "keyboard-layout compensation was introduced"
    )


if __name__ == "__main__":
    main()
