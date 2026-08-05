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
        "if-ge v2, v6,",
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
        or "if-ne v5, v4," not in nav_color
        or "add-int/lit8 v1, v1, -0x1" not in nav_color
        or "ImeSurfaceRendererCompat;->copyForPlatform" not in nav_color
    ):
        raise RuntimeError("Platform navigation color must source the owned theme frame")

    renderer_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat.smali"
    )
    slice_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable.smali"
    )
    if not renderer_path.is_file() or not slice_path.is_file():
        raise RuntimeError("Missing active-surface navigation renderer")
    renderer = renderer_path.read_text(encoding="utf-8")
    slice_drawable = slice_path.read_text(encoding="utf-8")
    renderer_tokens = (
        "const v3, 0x7f0f01a2",
        "if-nez v4,",
        "const v3, 0x7f0f0154",
        "0x7f0f0156",
        "ImeSurfaceSliceDrawable;-><init>",
        "Drawable;->getState()[I",
        "Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;->a:Landroid/view/View;",
        "0x7f0f0153",
        "add-int v6, v4, v2",
        "ImeNavigationColorCompat;->schedule",
    )
    missing = [token for token in renderer_tokens if token not in renderer]
    if missing:
        raise RuntimeError(f"Incomplete active-surface renderer: {missing}")
    forbidden_renderer_tokens = (
        "imageBottomWithOverlay",
        "PageableCandidatesHolderView",
        "Lavs;",
        "0x7f0f02bd",
        "overlay2:Landroid/graphics/drawable/Drawable;",
        "overlay3:Landroid/graphics/drawable/Drawable;",
    )
    present = [
        token
        for token in forbidden_renderer_tokens
        if token in renderer or token in slice_drawable
    ]
    if present:
        raise RuntimeError(f"Expanded-candidate renderer experiments remain: {present}")

    slice_tokens = (
        "Landroid/graphics/drawable/Drawable;",
        "Landroid/graphics/Canvas;->clipRect(IIII)Z",
        "Landroid/graphics/Canvas;->translate(FF)V",
        "offsetY:I",
        "overlay:Landroid/graphics/drawable/Drawable;",
        "totalHeight:I",
    )
    missing = [token for token in slice_tokens if token not in slice_drawable]
    if missing:
        raise RuntimeError(f"Incomplete shared-coordinate image slice: {missing}")

    candidate_controller = (decoded / "smali/asq.smali").read_text(encoding="utf-8")
    if "ImeSurfaceRendererCompat" in candidate_controller or "ImeThemeDiagnosticsCompat" in candidate_controller:
        raise RuntimeError("Candidate expansion must remain native and must not refresh navigation visuals")

    diagnostic_helpers = (
        decoded / "smali/com/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat.smali",
        decoded / "smali/com/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat$DumpRunnable.smali",
    )
    if any(path.exists() for path in diagnostic_helpers):
        raise RuntimeError("Temporary active-surface diagnostics remain in the artifact")

    crop_page = (decoded / "smali/bcp.smali").read_text(encoding="utf-8")
    crop_tokens = (
        "EdgeToEdgeCompat;->getNavigationBarBottomInset(Landroid/view/View;)I",
        "EdgeToEdgeCompat;->stableNavigationHeightOr(I)I",
        "add-int/2addr v4, v5",
    )
    missing = [token for token in crop_tokens if token not in crop_page]
    if missing:
        raise RuntimeError(
            f"Image crop viewport does not include dynamic navigation geometry: {missing}"
        )

    print(
        "Android 16 baseline verified: targetSdkVersion 36, accepted edge-to-edge "
        "implementation retained, legacy Back dispatch explicitly frozen, and "
        "transitional navigation geometry rejected"
    )


if __name__ == "__main__":
    main()
