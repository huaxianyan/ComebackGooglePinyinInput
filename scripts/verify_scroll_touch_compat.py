#!/usr/bin/env python3
"""Verify child pager events stay intact while outer key handling is canceled."""

from __future__ import annotations

import argparse
from pathlib import Path


def require_in_order(text: str, tokens: tuple[str, ...], message: str) -> None:
    position = -1
    for token in tokens:
        position = text.find(token, position + 1)
        if position < 0:
            raise RuntimeError(message)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    aws_path = decoded / "smali/aws.smali"
    helper_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/ScrollTouchCompat.smali"
    )
    soft_keyboard_path = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/"
        "SoftKeyboardView.smali"
    )
    for path in (aws_path, helper_path, soft_keyboard_path):
        if not path.is_file():
            raise RuntimeError(f"Missing scroll touch source: {path}")

    aws = aws_path.read_text(encoding="utf-8")
    mark_call = "ScrollTouchCompat;->markScrolling()V"
    if aws.count(mark_call) != 2:
        raise RuntimeError("Pager MOVE and UP must both report confirmed scrolling")
    if "Landroid/view/MotionEvent;->setAction(I)V" in aws:
        raise RuntimeError("Pager detection must not mutate the child MotionEvent")

    helper = helper_path.read_text(encoding="utf-8")
    method_start = helper.find(
        ".method public static cancelOuterKeyEvent(Landroid/view/MotionEvent;)V"
    )
    method_end = helper.find(".end method", method_start)
    if method_start < 0 or method_end < 0:
        raise RuntimeError("Missing outer key cancellation method")
    method = helper[method_start:method_end]
    if method.count("Landroid/view/MotionEvent;->setAction(I)V") != 2:
        raise RuntimeError("Outer MOVE and UP must each have one CANCEL path")
    require_in_order(
        method,
        (
            "if-nez v0, :check_move",
            "ScrollTouchCompat;->reset()V",
            ":check_move",
            "if-ne v0, v1, :check_up",
            "sget-boolean v1, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->scrolling:Z",
            "Landroid/view/MotionEvent;->setAction(I)V",
            ":check_up",
            "if-ne v0, v1, :check_cancel",
            "Landroid/view/MotionEvent;->setAction(I)V",
            ":check_cancel",
            ":reset",
            "sput-boolean v0, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->scrolling:Z",
        ),
        "Outer key cancellation lifecycle is incomplete or reordered",
    )

    soft_keyboard = soft_keyboard_path.read_text(encoding="utf-8")
    branch_start = soft_keyboard.find("    .line 99\n    :cond_4")
    branch_end = soft_keyboard.find("    .line 100", branch_start)
    if branch_start < 0 or branch_end < 0:
        raise RuntimeError("Missing standard SoftKeyboardView dispatch branch")
    branch = soft_keyboard[branch_start:branch_end]
    require_in_order(
        branch,
        (
            "FrameLayout;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z",
            "ScrollTouchCompat;->cancelOuterKeyEvent(Landroid/view/MotionEvent;)V",
        ),
        "Child dispatch must finish before the outer key event is canceled",
    )

    print(
        "Scroll touch contracts verified: child pager events remain intact and "
        "confirmed drags cancel only the outer key pipeline"
    )


if __name__ == "__main__":
    main()
