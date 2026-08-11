#!/usr/bin/env python3
"""Verify the API 30 Inline Autofill request, remote host, and old-ART boundary."""

from __future__ import annotations

import argparse
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JAVA_HELPER = ROOT / "patches/java/com/google/android/inputmethod/pinyin/InlineAutofillCompat.java"
JAVA_HOST = ROOT / "patches/java/com/google/android/inputmethod/pinyin/InlineAutofillClipHost.java"
SMALI_HELPER = ROOT / "patches/smali/InlineAutofillCompat.smali"
SMALI_HOST = ROOT / "patches/smali/InlineAutofillClipHost.smali"
ANDROID_NS = "http://schemas.android.com/apk/res/android"
API_TYPES = (
    "Landroid/view/inputmethod/InlineSuggestion;",
    "Landroid/view/inputmethod/InlineSuggestionsRequest;",
    "Landroid/view/inputmethod/InlineSuggestionsResponse;",
    "Landroid/widget/inline/InlineContentView;",
    "Landroid/widget/inline/InlinePresentationSpec;",
)


def require_all(text: str, values: tuple[str, ...], label: str) -> None:
    missing = [value for value in values if value not in text]
    if missing:
        raise RuntimeError(f"{label} is missing required contracts: {missing}")


def verify_sources(android_jar: Path, jdk: Path) -> None:
    helper = JAVA_HELPER.read_text(encoding="utf-8")
    host = JAVA_HOST.read_text(encoding="utf-8")
    require_all(
        helper,
        (
            "Build.VERSION.SDK_INT < API_R",
            "HEADER_HEIGHT_RES_ID = 0x7f0d00a9",
            "PRESENTATION_COUNT = 3",
            "INFLATION_TIMEOUT_MS = 1200L",
            "new InlinePresentationSpec.Builder(minSize, maxSize).build()",
            ".setMaxSuggestionCount(PRESENTATION_COUNT)",
            "response.getInlineSuggestions()",
            ".inflate(",
            "new WeakReference<InlineAutofillClipHost>(host)",
            "callbackGeneration == generation",
            "host.isAvailable()",
            "publishPartial(callbackGeneration",
            "InlineAutofillClipHost.clearAllHosts()",
        ),
        "Inline Autofill controller",
    )
    require_all(
        host,
        (
            "extends FrameLayout",
            "HorizontalScrollView",
            "onCandidates(List<?> candidates)",
            "nativeCandidatesActive",
            "setInlineViews(List<? extends View> views)",
            "InlineAutofillCompat.applyRemoteClip(child, new Rect(childRect))",
            "getGlobalVisibleRect(hostRect)",
            "removeOnScrollChangedListener(this)",
            "IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS",
        ),
        "Inline Autofill ClipHost",
    )
    for forbidden in (
        "getInfo(",
        "commitText(",
        "ClipboardManager",
        "android.util.Log",
        "getText(",
        "getAutofillValue(",
    ):
        if forbidden in helper:
            raise RuntimeError(f"Inline controller must not inspect Autofill payloads: {forbidden}")

    helper_smali = SMALI_HELPER.read_text(encoding="utf-8")
    host_smali = SMALI_HOST.read_text(encoding="utf-8")
    require_all(
        helper_smali,
        (
            ".field private static final PRESENTATION_COUNT:I = 0x3",
            ".field private static final INFLATION_TIMEOUT_MS:J = 0x4b0L",
            "InlinePresentationSpec$Builder;-><init>",
            "InlineSuggestionsRequest$Builder;->setMaxSuggestionCount(I)",
            "InlineSuggestionsResponse;->getInlineSuggestions()Ljava/util/List;",
            "InlineSuggestion;->inflate",
            "InlineAutofillClipHost;->setInlineViews(Ljava/util/List;)V",
            "View;->setClipBounds(Landroid/graphics/Rect;)V",
        ),
        "Inline Autofill smali controller",
    )
    require_all(
        host_smali,
        (
            "Landroid/widget/HorizontalScrollView;",
            "InlineAutofillCompat;->applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V",
            "->getGlobalVisibleRect(Landroid/graphics/Rect;)Z",
            "InlineAutofillClipHost;->nativeCandidatesActive:Z",
        ),
        "Inline Autofill smali ClipHost",
    )
    if any(api_type in host_smali for api_type in API_TYPES):
        raise RuntimeError("API-neutral ClipHost directly resolves API 30 Inline classes")
    if "View;->setClipBounds" in host_smali:
        raise RuntimeError("API-neutral ClipHost directly invokes post-minSdk clipping APIs")

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
                str(JAVA_HOST),
                str(JAVA_HELPER),
            ],
            check=True,
        )


def verify_method_metadata(decoded: Path) -> None:
    phone_methods: list[tuple[int, Path]] = []
    for method_path in (decoded / "res").glob("xml*/method.xml"):
        qualifier = method_path.parent.name
        if "television" not in qualifier:
            version = 0
            for item in qualifier.split("-"):
                if item.startswith("v") and item[1:].isdigit():
                    version = int(item[1:])
            if version <= 30:
                phone_methods.append((version, method_path))
        method = ET.parse(method_path).getroot()
        if method.get(
            f"{{{ANDROID_NS}}}supportsInlineSuggestionsWithTouchExploration"
        ) is not None:
            raise RuntimeError(
                f"Touch-exploration Inline Suggestions must remain undeclared: {method_path}"
            )
    if not phone_methods:
        raise RuntimeError("No phone input-method resource is available for API 30")
    effective_version, effective_path = max(phone_methods)
    method = ET.parse(effective_path).getroot()
    if method.get(f"{{{ANDROID_NS}}}supportsInlineSuggestions") != "true":
        raise RuntimeError(
            "Effective API 30 phone input method does not declare "
            f"supportsInlineSuggestions=true: v{effective_version} {effective_path}"
        )


def verify_decoded(decoded: Path) -> None:
    verify_method_metadata(decoded)
    pinyin_path = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
    helper_path = decoded / "smali/com/google/android/inputmethod/pinyin/InlineAutofillCompat.smali"
    host_path = decoded / "smali/com/google/android/inputmethod/pinyin/InlineAutofillClipHost.smali"
    input_bundle_path = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/InputBundle.smali"
    )
    for path in (pinyin_path, helper_path, host_path, input_bundle_path):
        if not path.exists():
            raise FileNotFoundError(path)
    pinyin = pinyin_path.read_text(encoding="utf-8")
    helper = helper_path.read_text(encoding="utf-8")
    controller = "\n".join(
        path.read_text(encoding="utf-8")
        for path in helper_path.parent.glob("InlineAutofillCompat*.smali")
    )
    host = host_path.read_text(encoding="utf-8")
    input_bundle = input_bundle_path.read_text(encoding="utf-8")
    require_all(
        pinyin,
        (
            ".method public onCreateInlineSuggestionsRequest(Landroid/os/Bundle;)Landroid/view/inputmethod/InlineSuggestionsRequest;",
            ".method public onInlineSuggestionsResponse(Landroid/view/inputmethod/InlineSuggestionsResponse;)Z",
            "InlineAutofillCompat;->createRequest",
            "InlineAutofillCompat;->handleResponse",
            ".method public onStartInput(Landroid/view/inputmethod/EditorInfo;Z)V",
            ".method public onFinishInput()V",
            ".method public onWindowHidden()V",
            "InlineAutofillCompat;->startInputSession()V",
        ),
        "PinyinIME Inline Autofill bridge",
    )
    if pinyin.count("const/16 v1, 0x1e") < 8 or pinyin.count(
        "InlineAutofillCompat;->clear()V"
    ) != 4 or pinyin.count("InlineAutofillCompat;->startInputSession()V") != 2:
        raise RuntimeError("PinyinIME Inline Autofill lifecycle paths are not fully API-gated")
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

    require_all(controller, API_TYPES, "final Inline Autofill controller")
    require_all(
        controller,
        (
            "InlineSuggestionsResponse;->getInlineSuggestions()Ljava/util/List;",
            "InlineSuggestion;->inflate",
            "InlineAutofillClipHost;->setInlineViews(Ljava/util/List;)V",
        ),
        "final Inline Autofill rendering path",
    )
    if any(api_type in host for api_type in API_TYPES):
        raise RuntimeError("Final API-neutral ClipHost resolves API 30 Inline classes")
    require_all(
        input_bundle,
        (
            "InlineAutofillClipHost;->onCandidates(Ljava/util/List;)V",
            "InlineAutofillClipHost;->onCandidatesCleared()V",
        ),
        "native Candidate priority bridge",
    )

    layouts = (
        decoded / "res/layout/keyboard_candidates_header_inner.xml",
        decoded / "res/layout/keyboard_candidates_header_inner_no_deletable_label.xml",
    )
    for layout in layouts:
        text = layout.read_text(encoding="utf-8")
        require_all(
            text,
            (
                "com.google.android.inputmethod.pinyin.InlineAutofillClipHost",
                'android:tag="compat_inline_autofill_host"',
                'android:visibility="gone"',
            ),
            str(layout),
        )

    allowed = {pinyin_path.resolve()}
    offenders: list[str] = []
    for path in (decoded / "smali").rglob("*.smali"):
        text = path.read_text(encoding="utf-8")
        if any(api_type in text for api_type in API_TYPES):
            relative = path.relative_to(decoded).as_posix()
            if path.resolve() not in allowed and "/InlineAutofillCompat" not in relative:
                offenders.append(relative)
    if offenders:
        raise RuntimeError(f"API 30 Inline classes escaped the narrow controller: {offenders}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    args = parser.parse_args()
    verify_sources(args.android_jar.resolve(), args.jdk.resolve())
    verify_decoded(args.decoded.resolve())
    print(
        "Inline Autofill stage-B verified: bounded request/inflation, ordered remote host, "
        "native Candidate priority, explicit clipping, stale rejection, and old-ART isolation"
    )


if __name__ == "__main__":
    main()
