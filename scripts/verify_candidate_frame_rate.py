#!/usr/bin/env python3
"""Verify bounded API 36 Candidate expansion/collapse frame-rate requests."""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HELPER = "Lcom/google/android/inputmethod/pinyin/ViewFrameRateCompat;"
CALL = f"{HELPER}->requestHigh(Landroid/view/View;Z)V"
DIRECT_API = "Landroid/view/View;->setRequestedFrameRate(F)V"


def require_count(text: str, value: str, expected: int, label: str) -> None:
    actual = text.count(value)
    if actual != expected:
        raise RuntimeError(
            f"{label}: expected {expected} occurrences of {value!r}, found {actual}"
        )


def verify_sources() -> None:
    helper = (ROOT / "patches/smali/ViewFrameRateCompat.smali").read_text(
        encoding="utf-8"
    )
    for value in (
        "SDK_INT:I",
        "const/16 v1, 0x24",
        'const-string v1, "setRequestedFrameRate"',
        "Ljava/lang/Class;->getMethod",
        "Ljava/lang/reflect/Method;->invoke",
        "-0x3f800000",
        "-0x40800000",
        ".catch Ljava/lang/Exception;",
    ):
        if value not in helper:
            raise RuntimeError(f"API-isolated helper is missing {value!r}")
    if DIRECT_API in helper:
        raise RuntimeError("helper directly references the API 36-only View method")

    patcher = (ROOT / "scripts/apply_patches.py").read_text(encoding="utf-8")
    require_count(patcher, 'expand_listener = decoded / "smali/ass.smali"', 1,
                  "expansion listener patch")
    require_count(patcher, 'collapse_listener = decoded / "smali/ast.smali"', 1,
                  "collapse listener patch")
    require_count(patcher, "ViewFrameRateCompat;->requestHigh", 4,
                  "bounded start/end injections")


def verify_decoded(decoded: Path) -> None:
    helper_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/ViewFrameRateCompat.smali"
    )
    if not helper_path.is_file():
        raise RuntimeError(f"missing generated helper: {helper_path}")
    helper = helper_path.read_text(encoding="utf-8")
    if DIRECT_API in helper:
        raise RuntimeError("decoded helper directly resolves an API 36-only method")

    for name in ("ass.smali", "ast.smali"):
        text = (decoded / "smali" / name).read_text(encoding="utf-8")
        require_count(text, CALL, 2, f"{name} animation lifecycle")
        require_count(text, "const/4 v1, 0x1", 1, f"{name} high request")
        if "onAnimationStart(Landroid/animation/Animator;)V" not in text:
            raise RuntimeError(f"{name} no longer has the native animation start seam")
        if "onAnimationEnd(Landroid/animation/Animator;)V" not in text:
            raise RuntimeError(f"{name} no longer has the native animation end seam")

    # Only the legacy primary DEX is loaded on API 17-34. Compose's separately
    # gated modern DEX may use its own SDK-specific implementation classes.
    direct_refs = []
    for path in (decoded / "smali").rglob("*.smali"):
        if DIRECT_API in path.read_text(encoding="utf-8"):
            direct_refs.append(str(path))
    if direct_refs:
        raise RuntimeError(
            f"direct API 36 View method references found in primary DEX: {direct_refs}"
        )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, nargs="?")
    args = parser.parse_args()
    verify_sources()
    if args.decoded is not None:
        verify_decoded(args.decoded)
    print("Candidate animation frame-rate contract verified")


if __name__ == "__main__":
    main()
