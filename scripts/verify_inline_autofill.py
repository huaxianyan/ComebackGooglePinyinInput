#!/usr/bin/env python3
"""Verify the API 30 Inline Autofill stage-A protocol and old-ART boundary."""

from __future__ import annotations

import argparse
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JAVA_SOURCE = ROOT / "patches/java/com/google/android/inputmethod/pinyin/InlineAutofillCompat.java"
SMALI_SOURCE = ROOT / "patches/smali/InlineAutofillCompat.smali"
ANDROID_NS = "http://schemas.android.com/apk/res/android"
API_TYPES = (
    "Landroid/view/inputmethod/InlineSuggestionsRequest;",
    "Landroid/view/inputmethod/InlineSuggestionsResponse;",
    "Landroid/widget/inline/InlinePresentationSpec;",
)


def require_all(text: str, values: tuple[str, ...], label: str) -> None:
    missing = [value for value in values if value not in text]
    if missing:
        raise RuntimeError(f"{label} is missing required contracts: {missing}")


def verify_sources(android_jar: Path, jdk: Path) -> None:
    java_text = JAVA_SOURCE.read_text(encoding="utf-8")
    require_all(
        java_text,
        (
            "Build.VERSION.SDK_INT < API_R",
            "HEADER_HEIGHT_RES_ID = 0x7f0d00a9",
            "PRESENTATION_COUNT = 3",
            "MIN_CHIP_WIDTH_DP = 48.0f",
            "MAX_CHIP_WIDTH_DP = 240.0f",
            "new InlinePresentationSpec.Builder(minSize, maxSize).build()",
            ".setMaxSuggestionCount(PRESENTATION_COUNT)",
            "boolean handleResponse(InlineSuggestionsResponse response)",
            "return false;",
        ),
        "Inline Autofill Java helper",
    )
    for forbidden in (
        "InlineSuggestion.inflate",
        "getInlineSuggestions(",
        "getInfo(",
        "commitText(",
        "ClipboardManager",
        "Candidate",
        "android.util.Log",
    ):
        if forbidden in java_text:
            raise RuntimeError(f"Stage A must not inspect or render Autofill data: {forbidden}")

    smali_text = SMALI_SOURCE.read_text(encoding="utf-8")
    require_all(
        smali_text,
        (
            ".field private static final PRESENTATION_COUNT:I = 0x3",
            "const v2, 0x7f0d00a9",
            "InlinePresentationSpec$Builder;-><init>",
            "InlineSuggestionsRequest$Builder;->setMaxSuggestionCount(I)",
            ".method public static declared-synchronized handleResponse",
            "const/4 p0, 0x0",
        ),
        "Inline Autofill smali helper",
    )
    handle_response = smali_text.split(
        ".method public static declared-synchronized handleResponse", 1
    )[1].split(".end method", 1)[0]
    if "InlineSuggestionsResponse;->" in handle_response:
        raise RuntimeError("Stage-A response handler reads suggestion data")

    javac = (jdk / "bin/javac.exe").resolve()
    for path in (android_jar, javac):
        if not path.exists():
            raise FileNotFoundError(path)
    with tempfile.TemporaryDirectory(prefix="inline-autofill-compile-") as temporary:
        subprocess.run(
            [
                str(javac),
                "-encoding", "UTF-8",
                "-source", "7",
                "-target", "7",
                "-bootclasspath", str(android_jar),
                "-d", temporary,
                str(JAVA_SOURCE),
            ],
            check=True,
        )


def verify_decoded(decoded: Path) -> None:
    phone_methods: list[tuple[int, Path]] = []
    for method_path in (decoded / "res").glob("xml*/method.xml"):
        qualifier = method_path.parent.name
        if "television" in qualifier:
            continue
        version = 0
        for item in qualifier.split("-"):
            if item.startswith("v") and item[1:].isdigit():
                version = int(item[1:])
        if version <= 30:
            phone_methods.append((version, method_path))
    if not phone_methods:
        raise RuntimeError("No phone input-method resource is available for API 30")
    effective_version, effective_method_path = max(phone_methods)
    effective_method = ET.parse(effective_method_path).getroot()
    if effective_method.get(f"{{{ANDROID_NS}}}supportsInlineSuggestions") != "true":
        raise RuntimeError(
            "Effective API 30 phone input method does not declare "
            f"supportsInlineSuggestions=true: v{effective_version} {effective_method_path}"
        )
    for method_path in (decoded / "res").glob("xml*/method.xml"):
        method = ET.parse(method_path).getroot()
        if method.get(
            f"{{{ANDROID_NS}}}supportsInlineSuggestionsWithTouchExploration"
        ) is not None:
            raise RuntimeError(
                f"Touch-exploration Inline Suggestions must remain undeclared: {method_path}"
            )

    pinyin_path = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
    helper_path = decoded / (
        "smali/com/google/android/inputmethod/pinyin/InlineAutofillCompat.smali"
    )
    for path in (pinyin_path, helper_path):
        if not path.exists():
            raise FileNotFoundError(path)
    pinyin = pinyin_path.read_text(encoding="utf-8")
    helper = helper_path.read_text(encoding="utf-8")
    require_all(
        pinyin,
        (
            ".method public onCreateInlineSuggestionsRequest(Landroid/os/Bundle;)Landroid/view/inputmethod/InlineSuggestionsRequest;",
            ".method public onInlineSuggestionsResponse(Landroid/view/inputmethod/InlineSuggestionsResponse;)Z",
            "InlineAutofillCompat;->createRequest",
            "InlineAutofillCompat;->handleResponse",
        ),
        "PinyinIME Inline Autofill bridge",
    )
    if pinyin.count("const/16 v1, 0x1e") < 5 or pinyin.count(
        "InlineAutofillCompat;->clear()V"
    ) != 3:
        raise RuntimeError("Not every PinyinIME Inline Autofill entry/lifecycle path is API-gated")
    for signature in (
        ".method public onCreateInlineSuggestionsRequest",
        ".method public onInlineSuggestionsResponse",
    ):
        method_body = pinyin.split(signature, 1)[1].split(".end method", 1)[0]
        require_all(
            method_body,
            ("Build$VERSION;->SDK_INT:I", "const/16 v1, 0x1e", "if-lt"),
            signature,
        )

    require_all(helper, API_TYPES, "final Inline Autofill helper")
    handle_response = helper.split(
        ".method public static declared-synchronized handleResponse", 1
    )[1].split(".end method", 1)[0]
    if "InlineSuggestionsResponse;->" in handle_response:
        raise RuntimeError("Final stage-A response handler reads suggestion data")

    allowed = {pinyin_path.resolve(), helper_path.resolve()}
    offenders: list[str] = []
    for path in (decoded / "smali").rglob("*.smali"):
        text = path.read_text(encoding="utf-8")
        if any(api_type in text for api_type in API_TYPES) and path.resolve() not in allowed:
            offenders.append(str(path.relative_to(decoded)))
    if offenders:
        raise RuntimeError(f"API 30 Inline classes escaped the narrow bridge: {offenders}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    args = parser.parse_args()
    verify_sources(args.android_jar.resolve(), args.jdk.resolve())
    verify_decoded(args.decoded.resolve())
    print(
        "Inline Autofill stage-A verified: API 30 bridge, 3 bounded specs, "
        "no rendering/data access, and API 17-29 guarded lifecycle"
    )


if __name__ == "__main__":
    main()
