#!/usr/bin/env python3
"""Verify the narrow Android 16 target-SDK baseline.

The first API 36 candidate inherits the accepted API 35 edge-to-edge model and
explicitly freezes legacy Back dispatch. Predictive Back is intentionally a
later, separately attributable migration.
"""

from __future__ import annotations

import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    apktool = (decoded / "apktool.yml").read_text(encoding="utf-8")
    if "targetSdkVersion: 36" not in apktool:
        raise RuntimeError("Android 16 verifier requires targetSdkVersion 36")

    manifest = (decoded / "AndroidManifest.xml").read_text(encoding="utf-8")
    application_start = manifest.find("<application ")
    application_end = manifest.find(">", application_start)
    if application_start < 0 or application_end < 0:
        raise RuntimeError("AndroidManifest application element is missing")
    application_tag = manifest[application_start:application_end]
    if 'android:enableOnBackInvokedCallback="false"' not in application_tag:
        raise RuntimeError(
            "Initial target-36 baseline must explicitly preserve legacy Back dispatch"
        )
    if "windowOptOutEdgeToEdgeEnforcement" in manifest:
        raise RuntimeError("Android 16 must retain the real edge-to-edge implementation")

    # Keep predictive Back out of the first target-only candidate. Existing
    # onBackPressed behavior remains the accepted authority until a dedicated
    # migration adds and tests callbacks independently.
    patched_sources = [
        decoded
        / "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity.smali",
        decoded
        / "smali/com/google/android/apps/inputmethod/pinyin/preference/"
        "SettingsActivity.smali",
        decoded / "smali/com/google/android/inputmethod/pinyin/EdgeToEdgeCompat.smali",
    ]
    for path in patched_sources:
        if not path.is_file():
            raise RuntimeError(f"Missing target-36 audit source: {path}")
        text = path.read_text(encoding="utf-8")
        for token in ("OnBackInvokedDispatcher", "OnBackInvokedCallback"):
            if token in text:
                raise RuntimeError(
                    f"Predictive Back was mixed into the target-only baseline: {path}"
                )

    first_run = patched_sources[0].read_text(encoding="utf-8")
    if "onBackPressed()V" not in first_run or "exitGuide()V" not in first_run:
        raise RuntimeError("Accepted first-run Back semantics are missing")

    ime_listener_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat$ImeInsetsListener.smali"
    )
    if not ime_listener_path.is_file():
        raise RuntimeError("Missing IME Insets listener")
    ime_listener = ime_listener_path.read_text(encoding="utf-8")
    stable_navigation_geometry = (
        "Landroid/view/View;->isLaidOut()Z",
        "Landroid/view/View;->getBottom()I",
        "Landroid/view/View;->getWidth()I",
        "if-ge v2, v6, :use_remembered_height",
        "EdgeToEdgeCompat;->rememberStableNavigationHeight(I)V",
        "EdgeToEdgeCompat;->stableNavigationHeightOr(I)I",
        "Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I",
        'const-string v5, "ime-navigation-frame"',
        "Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V",
        "Landroid/view/View;->setClickable(Z)V",
        "Landroid/view/View;->setFocusable(Z)V",
    )
    missing = [
        token for token in stable_navigation_geometry if token not in ime_listener
    ]
    if missing:
        raise RuntimeError(
            "Incomplete InputView-owned navigation frame coordinator: " f"{missing}"
        )
    if "Landroid/view/View;->getParent()Landroid/view/ViewParent;" in ime_listener:
        raise RuntimeError("IME theme frame must not be reparented through framework decor")

    nav_color_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "ImeNavigationColorCompat.smali"
    )
    nav_color = nav_color_path.read_text(encoding="utf-8")
    if (
        'const-string v2, "ime-navigation-frame"' not in nav_color
        or "findViewWithTag(Ljava/lang/Object;)Landroid/view/View;" not in nav_color
        or ":candidate_loop" not in nav_color
        or "if-ne v5, v4, :next_candidate" not in nav_color
    ):
        raise RuntimeError("Platform navigation color must source the owned theme frame")

    print(
        "Android 16 baseline verified: targetSdkVersion 36, accepted edge-to-edge "
        "implementation retained, legacy Back dispatch explicitly frozen, and "
        "transitional navigation geometry rejected"
    )


if __name__ == "__main__":
    main()
