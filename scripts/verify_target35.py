#!/usr/bin/env python3
"""Verify Android 15 edge-to-edge and TextView audit invariants.

Activities keep narrow inset handling. The IME Window covers the navigation
region, while a dedicated themed bottom frame reserves space below the untouched
legacy keyboard body and keeps the complete IME inset visible to applications.
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
    ime_listener = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat$ImeInsetsListener.smali"
    )
    if not ime_listener.is_file():
        raise RuntimeError("Missing dedicated IME bottom-frame inset listener")
    ime_listener_text = ime_listener.read_text(encoding="utf-8")
    apply_runnable = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat$ApplyInsetsRunnable.smali"
    )
    if not apply_runnable.is_file():
        raise RuntimeError("Missing deferred IME inset runnable")
    apply_runnable_text = apply_runnable.read_text(encoding="utf-8")
    required_helper = (
        "attachFirstRun(Landroid/app/Activity;)V",
        "attachInputView(Landroid/view/View;)V",
        "sput-object p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->inputView:Landroid/view/View;",
        "sget-object v0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->inputView:Landroid/view/View;",
        "logImeGeometry(Ljava/lang/String;I)V",
        'const-string p1, "GooglePinyinImeGeometry"',
        "getNavigationBarBottomInset(Landroid/view/View;)I",
        "Landroid/view/WindowManager;->getCurrentWindowMetrics()Landroid/view/WindowMetrics;",
        "Landroid/view/WindowMetrics;->getWindowInsets()Landroid/view/WindowInsets;",
        "getInsetsIgnoringVisibility(I)Landroid/graphics/Insets;",
        "scheduleApplyInsets(Landroid/view/View;)V",
        "Landroid/view/View;->post(Ljava/lang/Runnable;)Z",
        "Landroid/view/View;->addOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V",
        "configureImeWindow(Landroid/inputmethodservice/InputMethodService;)V",
        "Landroid/view/Window;->setDecorFitsSystemWindows(Z)V",
        "Landroid/view/WindowManager$LayoutParams;->setFitInsetsSides(I)V",
        "Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V",
        "const/4 v2, 0x7",
        "const/16 v1, 0x23",
        "const/16 v1, 0x1e",
    )
    diagnostic_text = helper_text + ime_listener_text + apply_runnable_text
    for forbidden in (
        "candidateText",
        "clipboard",
        "getText()",
        "SharedPreferences",
        "InputConnection",
    ):
        if forbidden in diagnostic_text:
            raise RuntimeError(f"Sensitive content in IME geometry diagnostics: {forbidden}")
    required_runnable = (
        "Ljava/lang/Runnable;",
        "Landroid/view/View;->isAttachedToWindow()Z",
        "Landroid/view/View;->getRootWindowInsets()Landroid/view/WindowInsets;",
        "Landroid/view/View;->dispatchApplyWindowInsets(Landroid/view/WindowInsets;)Landroid/view/WindowInsets;",
        "Landroid/view/View;->requestApplyInsets()V",
        "Landroid/view/View;->requestLayout()V",
    )
    missing = [item for item in required_runnable if item not in apply_runnable_text]
    if missing:
        raise RuntimeError(f"Incomplete deferred IME inset runnable: {missing}")
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
    google_ime = (
        decoded
        / "smali/com/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService.smali"
    ).read_text(encoding="utf-8")
    if "EdgeToEdgeCompat;->attachFirstRun" not in apy:
        raise RuntimeError("First-run footer does not receive bottom insets")
    if "EdgeToEdgeCompat;->configureImeWindow" not in pinyin_ime:
        raise RuntimeError("IME lifecycle does not configure system-bar fitting")
    if "EdgeToEdgeCompat;->attachInputView" in input_view:
        raise RuntimeError("Coordinator must not attach before InputView has a parent")
    if google_ime.count("EdgeToEdgeCompat;->attachInputView") != 1:
        raise RuntimeError("IME coordinator must attach exactly once after setInputView")
    set_input = google_ime.find("->setInputView(Landroid/view/View;)V")
    attach = google_ime.find("EdgeToEdgeCompat;->attachInputView")
    if set_input < 0 or attach < set_input:
        raise RuntimeError("IME coordinator attaches before setInputView")
    if "EdgeToEdgeCompat;->getInputViewMeasuredHeight" in input_view:
        raise RuntimeError("Rejected V8/V9 InputView measurement compensation remains")
    if input_view.count("->setMeasuredDimension(II)V") != 1:
        raise RuntimeError("Target-35 InputView measurement must remain original")
    if "->setPadding(IIII)V" in input_view:
        raise RuntimeError("IME InputView must retain native padding behavior")
    attach_listener = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat$InputViewAttachListener.smali"
    )
    if not attach_listener.is_file():
        raise RuntimeError("Missing initial InputView attach listener")
    attach_listener_text = attach_listener.read_text(encoding="utf-8")
    for item in (
        "Landroid/view/View$OnAttachStateChangeListener;",
        "onViewAttachedToWindow(Landroid/view/View;)V",
        "removeOnAttachStateChangeListener",
        "EdgeToEdgeCompat;->scheduleApplyInsets(Landroid/view/View;)V",
    ):
        if item not in attach_listener_text:
            raise RuntimeError(f"Incomplete initial InputView attach listener: {item}")
    required_ime_listener = (
        "EdgeToEdgeCompat;->getNavigationBarBottomInset(Landroid/view/View;)I",
        "Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I",
        "Landroid/view/View;->getRootView()Landroid/view/View;",
        "findViewWithTag(Ljava/lang/Object;)Landroid/view/View;",
        'const-string v5, "ime-navigation-frame"',
        "Landroid/view/View;->bringToFront()V",
        'const-string v2, ".keyboard-body-area"',
        "Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V",
        "Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V",
        "Landroid/view/ViewGroup$LayoutParams;->height:I",
        "const v2, 0x7f0f0153",
        "Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable",
    )
    missing = [item for item in required_ime_listener if item not in ime_listener_text]
    if missing:
        raise RuntimeError(f"Incomplete IME bottom-frame coordinator: {missing}")
    if "->setPadding(IIII)V" in ime_listener_text:
        raise RuntimeError("IME coordinator must not restore root-padding strategy")
    if "0x7f0f06eb" in ime_listener_text:
        raise RuntimeError("Rejected InputView-child bottom frame remains")

    # setDecorFitsSystemWindows(true) is deliberately scoped to the IME helper.
    # BOTTOM is then excluded explicitly so the Window/source covers navigation;
    # the attached input-frame coordinator reserves and paints that region.
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
    if "const/4 v2, 0x7" not in helper_text:
        raise RuntimeError(
            "Covering IME Window must fit LEFT|TOP|RIGHT and leave BOTTOM to its frame"
        )

    for relative in ("res/layout/ims_input_view.xml", "res/layout-v21/ims_input_view.xml"):
        text = (decoded / relative).read_text(encoding="utf-8")
        if text.count('android:background="?BgKeyboardArea"') != 1:
            raise RuntimeError(
                f"IME XML must retain only the native keyboard surface: {relative}"
            )
        if 'ime_navigation_frame' in text:
            raise RuntimeError(f"Rejected InputView-child bottom frame remains: {relative}")

    print(
        "Android 15 invariants verified: edge-to-edge is not opted out, first-run "
        "controls receive narrow insets, the IME owns a dedicated themed bottom frame, "
        "the keyboard body remains native, and no speculative TextView or "
        "keyboard-layout compensation was introduced"
    )


if __name__ == "__main__":
    main()
