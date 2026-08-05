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
        ":no_stable_frame_parent",
    )
    missing = [
        token for token in stable_navigation_geometry if token not in ime_listener
    ]
    if missing:
        raise RuntimeError(
            "IME margin coordinator can accept transitional navigation geometry: "
            f"{missing}"
        )

    print(
        "Android 16 baseline verified: targetSdkVersion 36, accepted edge-to-edge "
        "implementation retained, legacy Back dispatch explicitly frozen, and "
        "transitional navigation geometry rejected"
    )


if __name__ == "__main__":
    main()
