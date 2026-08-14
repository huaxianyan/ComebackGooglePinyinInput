#!/usr/bin/env python3
"""Verify scoped symbol/emoji/emoticon pager frame-rate requests."""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PAGER = "Lcom/google/android/inputmethod/pinyin/PagerFrameRateCompat;"
CALL = f"{PAGER}->requestForMotion(Landroid/view/View;Z)V"
TARGET = (
    "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
    "PageableRecentSubCategorySoftKeyListHolderView;"
)
VIEW_CALL = (
    "Lcom/google/android/inputmethod/pinyin/ViewFrameRateCompat;"
    "->requestHigh(Landroid/view/View;Z)V"
)


def require_count(text: str, value: str, expected: int, label: str) -> None:
    actual = text.count(value)
    if actual != expected:
        raise RuntimeError(
            f"{label}: expected {expected} occurrences of {value!r}, found {actual}"
        )


def verify_sources() -> None:
    helper = (ROOT / "patches/smali/PagerFrameRateCompat.smali").read_text(
        encoding="utf-8"
    )
    require_count(helper, f"instance-of v0, p0, {TARGET}", 1, "exact pager gate")
    require_count(helper, VIEW_CALL, 1, "shared API-neutral View bridge")

    patcher = (ROOT / "scripts/apply_patches.py").read_text(encoding="utf-8")
    require_count(patcher, CALL.removeprefix("Lcom/google/android/inputmethod/pinyin/"),
                  6, "drag/settle/release lifecycle injections")
    require_count(
        patcher,
        "instance-of v7, p0, Lcom/google/android/apps/inputmethod/libs/framework/",
        1,
        "validated V34 fling scope",
    )
    for forbidden in ("preferredRefreshRate", "setFrameRateBoostOnTouchEnabled", "120.0f"):
        if forbidden in helper:
            raise RuntimeError(f"pager helper must not use {forbidden}")


def verify_decoded(decoded: Path) -> None:
    helper_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/PagerFrameRateCompat.smali"
    )
    if not helper_path.is_file():
        raise RuntimeError(f"missing pager helper: {helper_path}")
    helper = helper_path.read_text(encoding="utf-8")
    require_count(helper, f"instance-of v0, p0, {TARGET}", 1, "decoded exact gate")
    require_count(helper, VIEW_CALL, 1, "decoded shared bridge")

    pager = (decoded / "smali/lk.smali").read_text(encoding="utf-8")
    holder = (decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
        "PageableSoftKeyListHolderView.smali"
    )).read_text(encoding="utf-8")
    require_count(pager, CALL, 4, "native drag/Scroller lifecycle")
    require_count(holder, CALL, 2, "visibility/detach cleanup")
    require_count(pager, f"instance-of v7, p0, {TARGET}", 1,
                  "decoded V34 fling scope")
    for seam in (
        "Landroid/widget/Scroller;->startScroll(IIIII)V",
        ".method public computeScroll()V",
        ".method public onTouchEvent(Landroid/view/MotionEvent;)Z",
    ):
        if seam not in pager:
            raise RuntimeError(f"native pager lifecycle seam is missing: {seam}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, nargs="?")
    args = parser.parse_args()
    verify_sources()
    if args.decoded is not None:
        verify_decoded(args.decoded)
    print("Symbol/emoji/emoticon pager frame-rate contract verified")


if __name__ == "__main__":
    main()
