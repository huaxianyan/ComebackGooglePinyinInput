#!/usr/bin/env python3
"""Verify the scoped symbol/emoji/emoticon pager settle target."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HELPER = "Lcom/google/android/inputmethod/pinyin/PagerSettleTargetCompat;"
CALL = f"{HELPER}->choose(Landroid/view/View;IF)I"
TARGET = (
    "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
    "PageableRecentSubCategorySoftKeyListHolderView;"
)


def require_count(text: str, value: str, expected: int, label: str) -> None:
    actual = text.count(value)
    if actual != expected:
        raise RuntimeError(
            f"{label}: expected {expected} occurrences of {value!r}, found {actual}"
        )


def verify_helper(helper: str, label: str) -> None:
    require_count(helper, "const/high16 v2, 0x3e000000", 1, f"{label} 12.5% threshold")
    require_count(helper, "iget v0, p0, Llk;->a:I", 1, f"{label} selected page")
    require_count(helper, "add-int/lit8 v0, v0, 0x1", 1, f"{label} next page")
    require_count(helper, "add-int/lit8 v0, v0, -0x1", 1, f"{label} previous page")
    for forbidden in ("Log;", "MotionEvent;", "VelocityTracker;"):
        if forbidden in helper:
            raise RuntimeError(f"{label} helper must not reference {forbidden}")


def verify_sources() -> None:
    helper = (ROOT / "patches/smali/PagerSettleTargetCompat.smali").read_text(
        encoding="utf-8"
    )
    verify_helper(helper, "source")
    patcher = (ROOT / "scripts/apply_patches.py").read_text(encoding="utf-8")
    require_count(
        patcher,
        "PagerSettleTargetCompat;->choose(Landroid/view/View;IF)I",
        1,
        "settle injection",
    )
    require_count(
        patcher,
        "if-eqz v7, :compat_original_settle",
        1,
        "exact-subclass fallback gate",
    )


def verify_decoded(decoded: Path) -> None:
    helper_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/PagerSettleTargetCompat.smali"
    )
    if not helper_path.is_file():
        raise RuntimeError(f"missing settle helper: {helper_path}")
    verify_helper(helper_path.read_text(encoding="utf-8"), "decoded")

    pager = (decoded / "smali/lk.smali").read_text(encoding="utf-8")
    require_count(pager, f"instance-of v7, p0, {TARGET}", 1, "exact pager identity")
    require_count(pager, CALL, 1, "decoded settle call")
    normalized_settle = re.compile(
        r"if-eqz v7, :[A-Za-z0-9_]+\s+"
        r"invoke-static \{p0, v1, v3\}, "
        r"Lcom/google/android/inputmethod/pinyin/PagerSettleTargetCompat;"
        r"->choose\(Landroid/view/View;IF\)I\s+"
        r"move-result v3\s+goto :goto_[A-Za-z0-9_]+\s+"
        r":[A-Za-z0-9_]+\s+int-to-float v0, v1\s+"
        r"add-float/2addr v0, v3\s+"
        r"const/high16 v1, 0x3f000000\s+# 0\.5f"
    )
    if len(normalized_settle.findall(pager)) != 1:
        raise RuntimeError(
            "decoded settle path must contain one exact-subclass gate and native 50% fallback"
        )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, nargs="?")
    args = parser.parse_args()
    verify_sources()
    if args.decoded is not None:
        verify_decoded(args.decoded)
    print("Symbol/emoji/emoticon pager settle contract verified")


if __name__ == "__main__":
    main()
