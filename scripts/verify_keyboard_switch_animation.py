#!/usr/bin/env python3
"""Verify zero-size safety for the legacy keyboard switch animator."""

from __future__ import annotations

import argparse
from pathlib import Path
import re


METHOD = (
    ".method private final a(Landroid/view/View;Landroid/graphics/Rect;"
    "Landroid/graphics/Rect;Ljava/lang/Runnable;)Z"
)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()

    animator_path = args.decoded.resolve() / "smali/aso.smali"
    animator_text = animator_path.read_text(encoding="utf-8")
    require(animator_text.count(METHOD) == 1, "Keyboard switch animator method is missing")
    method = animator_text.split(METHOD, 1)[1].split(".end method", 1)[0]

    width = "invoke-virtual {p1}, Landroid/view/View;->getWidth()I"
    height = "invoke-virtual {p1}, Landroid/view/View;->getHeight()I"
    callback = "Ljava/lang/Runnable;->run()V"
    scale = "invoke-virtual {p1}, Landroid/view/View;->getScaleX()F"
    guard = re.compile(
        re.escape(width)
        + r"\s+move-result v0"
        + r"\s+if-gtz v0, (?P<height_label>:\w+)"
        + r"\s+(?P<unmeasured_label>:\w+)"
        + r"\s+if-eqz p4, (?P<callback_done>:\w+)"
        + r"\s+invoke-interface/range \{p4 \.\. p4\}, "
        + re.escape(callback)
        + r"\s+(?P=callback_done)"
        + r"\s+const/4 v0, 0x1"
        + r"\s+goto/16 :goto_0"
        + r"\s+(?P=height_label)"
        + r"\s+"
        + re.escape(height)
        + r"\s+move-result v0"
        + r"\s+if-lez v0, (?P=unmeasured_label)"
        + r"\s+"
        + re.escape(scale)
    )
    require(
        guard.search(method) is not None,
        "Keyboard switch zero-size guard does not complete before scale calculations",
    )
    require(
        method.count(callback) == 1,
        "Unmeasured keyboard switch completion callback must run at most once",
    )

    print("Keyboard switch zero-size animation contract verified")


if __name__ == "__main__":
    main()
