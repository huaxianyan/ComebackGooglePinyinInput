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
JAVA_PLATFORM = ROOT / "patches/java/com/google/android/inputmethod/pinyin/headerplatform"
SMALI_HELPER = ROOT / "patches/smali/InlineAutofillCompat.smali"
SMALI_FEEDBACK = ROOT / "patches/smali/InlineAutofillFeedbackCompat.smali"
SMALI_PLATFORM = ROOT / "patches/smali/headerplatform"
ANDROIDX_JAR = ROOT / "work/inline-autofill-synthetic-provider/libs/classes.jar"
ANDROID_NS = "http://schemas.android.com/apk/res/android"
LEGACY_THEME_STUBS = {
    "com/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme.java": """
package com.google.android.apps.inputmethod.libs.framework.keyboard;
public interface IKeyboardTheme {
    void applyToContext(android.content.Context context);
    String getResourceCacheKey();
    String getViewStyleCacheKey();
}
""",
    "com/google/android/inputmethod/pinyin/PinyinIME.java": """
package com.google.android.inputmethod.pinyin;
public class PinyinIME extends android.inputmethodservice.InputMethodService {
    protected final com.google.android.apps.inputmethod.libs.framework.keyboard.IKeyboardTheme
            a() { return null; }
}
""",
    "com/google/android/inputmethod/pinyin/InlineAutofillFeedbackCompat.java": """
package com.google.android.inputmethod.pinyin;
public final class InlineAutofillFeedbackCompat {
    public static void perform(android.view.View view) {}
}
""",
}

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
    platform_sources = sorted(JAVA_PLATFORM.glob("*.java"))
    if not platform_sources:
        raise FileNotFoundError(JAVA_PLATFORM)
    platform = "\n".join(path.read_text(encoding="utf-8") for path in platform_sources)
    require_all(
        helper,
        (
            "Build.VERSION.SDK_INT < API_R",
            "HEADER_HEIGHT_RES_ID = 0x7f0d00a9",
            "PRESENTATION_SPEC_COUNT = 3",
            "MAX_SUGGESTION_COUNT = 6",
            "INFLATION_TIMEOUT_MS = 1200L",
            "inline request geometry orientation=",
            "resolveKeyboardThemeCandidateColor(",
            "((PinyinIME) context).a()",
            "keyboardTheme.applyToContext(isolated)",
            "isolated.getTheme().setTo(context.getTheme())",
            "LayoutInflater.from(isolated).inflate(",
            "((TextView) label).getCurrentTextColor()",
            "new InlinePresentationSpec.Builder(minSize, maxSize)",
            ".setStyle(styles)",
            "titleStyleBuilder.setTextColor(textColor)",
            "subtitleStyleBuilder.setTextColor(textColor)",
            "TextViewStyle titleStyle = titleStyleBuilder.build()",
            "TextViewStyle subtitleStyle = subtitleStyleBuilder.build()",
            "UiVersions.newStylesBuilder()",
            "InlineSuggestionUi.newStyleBuilder()",
            ".setMaxSuggestionCount(MAX_SUGGESTION_COUNT)",
            "Math.min(MAX_SUGGESTION_COUNT, suggestions.size())",
            "response.getInlineSuggestions()",
            "new Size(ViewGroup.LayoutParams.WRAP_CONTENT,",
            "ViewGroup.LayoutParams.WRAP_CONTENT)",
            ".inflate(",
            "new WeakReference<InlineAutofillHeaderModule>(module)",
            "callbackGeneration == generation",
            "module.isSessionAvailableFor(pendingSessionToken)",
            "pendingHeaderToken = module.getHeaderToken()",
            "module.getCurrentCandidateTextColor()",
            "if (nativeCandidateColor == null)",
            "activeRequestCandidateTextColor = nativeCandidateColor",
            "module.setRemoteViews(",
            "REMOTE_CLIPPER, activeRequestCandidateTextColor",
            "module.clearRemoteViews()",
            "HeaderPlatformOwners.find(context)",
            "if (pendingViews == null)",
            "published = false",
        ),
        "Inline Autofill protocol bridge",
    )
    require_all(
        platform,
        (
            "class InlineAutofillHeaderModule",
            "isSessionAvailableFor(long expectedSessionToken)",
            "publishIfReady();",
            "HeaderPresentationKind.REMOTE_SURFACE",
            "class InlineAutofillRemoteRenderer",
            "class InlineAutofillRemoteContent",
            "requestCandidateTextColor",
            "payload = null;",
            "chromeFactory.createCandidateChromeSlot()",
            "chromeFactory.createActionChromeSlot(HeaderActionKind.PREVIOUS)",
            "chromeFactory.createActionChromeSlot(HeaderActionKind.NEXT)",
            "showIndex(currentIndex - 1)",
            "showIndex(currentIndex + 1)",
            "InlineAutofillFeedbackCompat.perform(view)",
            "view.setOnClickListener(new View.OnClickListener()",
            "onRemoteSuggestionClick(clicked)",
            "views.get(currentIndex) != view",
            "view.setOnClickListener(null)",
            "view.setVisibility(current ? View.VISIBLE : View.INVISIBLE)",
            "candidateSlot.getSeparator().setVisibility(View.GONE)",
            "visualSlot.getRailSeparator()",
            "visualSlot.getRailSeparator().setVisibility(View.GONE)",
            "ImageView railSeparator = new ImageView(context)",
            "railSeparator.setScaleType(ImageView.ScaleType.FIT_XY)",
            "HeaderNativeChromeSnapshot",
            "captureNativeChrome(View candidateHolder)",
            "ID_SHOW_MORE_CANDIDATES = 0x7f0f0149",
            "findDivider(showMore)",
            "effectiveImageAlpha(dividerImage)",
            "image.getImageAlpha() / 255.0f",
            "float runtimeAlpha = resolveAlpha(context, ATTR_ICON_ALPHA)",
            "nextSlot.getRailWidth()",
            "previousSlot.getRoot().setVisibility(View.VISIBLE)",
            "nextSlot.getRoot().setVisibility(View.VISIBLE)",
            "previousSlot.setEnabled(currentIndex > 0)",
            "nextSlot.setEnabled(currentIndex + 1 < views.size())",
            "Temporary native Candidate ownership must not destroy prepared",
            "railParams(Gravity.END, trailingInset)",
            "ATTR_ICON_ALPHA = 0x7f010087",
            "ATTR_ICON_LEFT = 0x7f01008a",
            "ATTR_ICON_RIGHT = 0x7f01008b",
            "IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS",
            "content.offsetRectIntoDescendantCoords(child, childRect)",
            "childRect.intersect(0, 0, child.getWidth(), child.getHeight())",
            "inline layout index=",
            "clipper.applyClip(child, new Rect(childRect))",
            "icon.setAlpha(1.0f)",
            "icon.setImageAlpha(Math.round(chrome.getIconAlpha() * 255.0f))",
            "chrome.newActionIcon(root.getContext(), kind, enabled)",
        ),
        "Inline Autofill Header module/renderer",
    )
    for forbidden in (
        "getInfo(", "commitText(", "ClipboardManager",
        "getAutofillValue(", "InlineAutofillClipHost",
        "child.getLocationOnScreen(",
    ):
        if forbidden in helper or forbidden in platform:
            raise RuntimeError(f"Inline Autofill violates payload/platform boundaries: {forbidden}")
    for forbidden in (
        "InlineAutofillFeedbackHost",
        "InlineAutofillFeedbackCompat.perform(this)",
        "view.setSoundEffectsEnabled(false)",
    ):
        if forbidden in platform:
            raise RuntimeError(
                f"IME must not intercept or alter Provider remote Surface input: {forbidden}"
            )
    if platform.count("InlineAutofillFeedbackCompat.perform(view)") != 3:
        raise RuntimeError(
            "Autofill remote completion and both enabled rails must use native key feedback"
        )
    if ".setTextColor(" in platform:
        raise RuntimeError("Header platform must not recolor Provider remote Views")
    if helper.count(".setTextColor(") != 2:
        raise RuntimeError("Inline request must style title/subtitle only from native Candidate color")

    helper_smali = SMALI_HELPER.read_text(encoding="utf-8")
    feedback_smali = SMALI_FEEDBACK.read_text(encoding="utf-8")
    require_all(
        feedback_smali,
        (
            "new-instance v0, Laue;",
            "Laue;-><init>(Landroid/content/Context;)V",
            "Laue;->a(Landroid/view/View;Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;)V",
            "Laue;->a()V",
        ),
        "Inline Autofill native key feedback bridge",
    )
    for forbidden in ("GPAutoFeedback", "InlineAutofillFeedbackDiagnostics"):
        if forbidden in feedback_smali:
            raise RuntimeError(f"Formal Autofill feedback contains Debug diagnostics: {forbidden}")
    if "Landroid/util/Log;" in feedback_smali:
        raise RuntimeError("Formal Autofill feedback bridge must not log")
    platform_smali = "\n".join(
        path.read_text(encoding="utf-8") for path in SMALI_PLATFORM.glob("*.smali")
    )
    require_all(
        helper_smali,
        (
            ".field private static final PRESENTATION_SPEC_COUNT:I = 0x3",
            ".field private static final MAX_SUGGESTION_COUNT:I = 0x6",
            ".field private static final INFLATION_TIMEOUT_MS:J = 0x4b0L",
            "InlinePresentationSpec$Builder;-><init>",
            "InlineSuggestionsRequest$Builder;->setMaxSuggestionCount(I)",
            "InlineSuggestionsResponse;->getInlineSuggestions()Ljava/util/List;",
            "InlineSuggestion;->inflate",
            "IKeyboardTheme;->applyToContext(Landroid/content/Context;)V",
            "LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;",
            "TextView;->getCurrentTextColor()I",
            "InlineAutofillHeaderModule;->setRemoteViews",
            "View;->setClipBounds(Landroid/graphics/Rect;)V",
        ),
        "Inline Autofill Smali protocol bridge",
    )
    require_all(
        platform_smali,
        (
            "InlineAutofillRemoteRenderer;",
            "HeaderChromeFactory;->createCandidateChromeSlot",
            "HeaderChromeFactory;->createActionChromeSlot",
            "HeaderRemoteSurfaceClipper;->applyClip",
            "InlineAutofillFeedbackCompat;->perform(Landroid/view/View;)V",
        ),
        "Inline Autofill Smali platform renderer",
    )
    if "InlineAutofillFeedbackHost;" in platform_smali:
        raise RuntimeError("Generated Header platform must not wrap Provider remote input")
    if platform_smali.count(
        "InlineAutofillFeedbackCompat;->perform(Landroid/view/View;)V"
    ) != 3:
        raise RuntimeError(
            "Generated Autofill remote completion and rails must have three feedback calls"
        )
    if platform_smali.count(
        "View;->setOnClickListener(Landroid/view/View$OnClickListener;)V"
    ) < 4:
        raise RuntimeError("Generated remote Inline View must install and clear its click observer")
    if any(api_type in platform_smali for api_type in API_TYPES):
        raise RuntimeError("API-neutral Header platform directly resolves API 30 Inline classes")
    if "View;->setClipBounds" in platform_smali:
        raise RuntimeError("API-neutral Header platform directly invokes post-minSdk clipping")
    for forbidden in ("Laue;", "AudioManager;", "Vibrator;", "SharedPreferences;"):
        if forbidden in platform_smali:
            raise RuntimeError(
                f"Header platform must use the narrow native feedback bridge: {forbidden}"
            )

    javac = (jdk / "bin/javac.exe").resolve()
    for path in (android_jar, ANDROIDX_JAR, javac, JAVA_HELPER, *platform_sources):
        if not path.exists():
            raise FileNotFoundError(path)
    with tempfile.TemporaryDirectory(prefix="inline-autofill-compile-") as temporary:
        temporary_path = Path(temporary)
        stub_sources = []
        for relative, source in LEGACY_THEME_STUBS.items():
            stub = temporary_path / "stubs" / relative
            stub.parent.mkdir(parents=True, exist_ok=True)
            stub.write_text(source, encoding="utf-8")
            stub_sources.append(stub)
        subprocess.run(
            [str(javac), "-encoding", "UTF-8", "-source", "8", "-target", "8",
             "-bootclasspath", str(android_jar), "-classpath", str(ANDROIDX_JAR),
             "-d", temporary,
             str(JAVA_HELPER), *[str(path) for path in platform_sources],
             *[str(path) for path in stub_sources]],
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
    feedback_path = decoded / "smali/com/google/android/inputmethod/pinyin/InlineAutofillFeedbackCompat.smali"
    platform_path = decoded / "smali/com/google/android/inputmethod/pinyin/headerplatform"
    input_bundle_path = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/InputBundle.smali"
    )
    for path in (pinyin_path, helper_path, feedback_path, platform_path, input_bundle_path):
        if not path.exists():
            raise FileNotFoundError(path)
    pinyin = pinyin_path.read_text(encoding="utf-8")
    helper = helper_path.read_text(encoding="utf-8")
    controller = "\n".join(
        path.read_text(encoding="utf-8")
        for path in helper_path.parent.glob("InlineAutofillCompat*.smali")
    )
    platform = "\n".join(
        path.read_text(encoding="utf-8") for path in platform_path.glob("*.smali")
    )
    feedback = feedback_path.read_text(encoding="utf-8")
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
    if pinyin.count("const/16 v1, 0x1e") < 5 or pinyin.count(
        "InlineAutofillCompat;->clear()V"
    ) != 2 or pinyin.count("InlineAutofillCompat;->startInputSession()V") != 1:
        raise RuntimeError("PinyinIME Inline Autofill lifecycle paths are not fully API-gated")
    for signature in (
        ".method public onCreateInlineSuggestionsRequest",
        ".method public onInlineSuggestionsResponse",
    ):
        method_body = pinyin.split(signature, 1)[1].split(".end method", 1)[0]
        require_all(
            method_body,
            ("Build$VERSION;->SDK_INT:I", "const/16 v1, 0x1e", "if-ge"),
            signature,
        )

    require_all(controller, API_TYPES, "final Inline Autofill controller")
    require_all(
        controller,
        (
            "InlineSuggestionsResponse;->getInlineSuggestions()Ljava/util/List;",
            "InlineSuggestion;->inflate",
            "InlineAutofillHeaderModule;->setRemoteViews",
        ),
        "final Inline Autofill protocol path",
    )
    require_all(
        platform,
        (
            "InlineAutofillHeaderModule;",
            "InlineAutofillRemoteRenderer;",
            "HeaderChromeFactory;->createCandidateChromeSlot",
            "HeaderChromeFactory;->createActionChromeSlot",
            "HeaderRemoteSurfaceClipper;->applyClip",
            "InlineAutofillFeedbackCompat;->perform(Landroid/view/View;)V",
        ),
        "final Inline Autofill Header renderer",
    )
    require_all(
        feedback,
        (
            "new-instance v0, Laue;",
            "Laue;->a(Landroid/view/View;Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;)V",
            "Laue;->a()V",
        ),
        "final native key feedback bridge",
    )
    for forbidden in ("GPAutoFeedback", "InlineAutofillFeedbackDiagnostics"):
        if forbidden in feedback or forbidden in platform:
            raise RuntimeError(f"Final Autofill feedback contains Debug diagnostics: {forbidden}")
    if "Landroid/util/Log;" in feedback:
        raise RuntimeError("Final Autofill feedback bridge must not log")
    if "InlineAutofillFeedbackHost;" in platform:
        raise RuntimeError("Final Header platform must not wrap Provider remote input")
    if platform.count(
        "InlineAutofillFeedbackCompat;->perform(Landroid/view/View;)V"
    ) != 3:
        raise RuntimeError(
            "Final Autofill remote completion and rails must have three feedback calls"
        )
    if platform.count(
        "View;->setOnClickListener(Landroid/view/View$OnClickListener;)V"
    ) < 4:
        raise RuntimeError("Final remote Inline View must install and clear its click observer")
    if any(api_type in platform for api_type in API_TYPES):
        raise RuntimeError("API-neutral Header platform resolves API 30 Inline classes")
    if "InlineAutofillClipHost;->onCandidates" in input_bundle:
        raise RuntimeError("Legacy module-specific Candidate priority hook remains")
    fixed_holder = (decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
        "FixedSizeCandidatesHolderView.smali"
    )).read_text(encoding="utf-8")
    require_all(
        fixed_holder,
        (
            "HeaderNativeCandidateSource;",
            ".method public setHeaderNativeCandidateStateListener(",
            "->notifyHeaderPlatformCandidateState()V",
            "ClipboardCandidateCompat;->isInjected()Z",
            "->onNativeCandidateStateChanged(ZZ)V",
        ),
        "native Candidate platform source",
    )

    inner_layouts = (
        decoded / "res/layout/keyboard_candidates_header_inner.xml",
        decoded / "res/layout/keyboard_candidates_header_inner_no_deletable_label.xml",
    )
    for layout in inner_layouts:
        text = layout.read_text(encoding="utf-8")
        if "InlineAutofillClipHost" in text or "HeaderPlatformHostView" in text:
            raise RuntimeError(f"Module-specific or platform hosts remain inside Candidate layer: {layout}")

    platform_layouts = (
        "keyboard_prime_header.xml",
        "keyboard_prime_header_no_deletable_label.xml",
        "keyboard_handwriting_header.xml",
        "keyboard_hard_header.xml",
        "keyboard_hard_header_no_deletable_label.xml",
        "keyboard_universal_header.xml",
    )
    for name in platform_layouts:
        layout = decoded / "res/layout" / name
        text = layout.read_text(encoding="utf-8")
        if text.count("HeaderPlatformHostView") != 1:
            raise RuntimeError(f"Header must contain exactly one platform host: {layout}")
    for layout in (decoded / "res").rglob("*.xml"):
        if "InlineAutofillClipHost" in layout.read_text(encoding="utf-8"):
            raise RuntimeError(f"Legacy module-specific Inline host remains in layout: {layout}")
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
        "Inline Autofill Header module verified: bounded ordered inflation, native chrome, "
        "remote Surface carousel/clipping, stale rejection, and old-ART isolation"
    )


if __name__ == "__main__":
    main()
