#!/usr/bin/env python3
"""Host-side contract tests for the API-neutral unified Header platform."""

from __future__ import annotations

import argparse
import os
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "patches/java/com/google/android/inputmethod/pinyin/headerplatform"

HARNESS = r"""
import com.google.android.inputmethod.pinyin.headerplatform.*;

public final class HeaderPlatformHostTest {
    private static final class Payload implements HeaderRendererPayload {}
    private static final class Module implements HeaderModule {
        private final String id;
        HeaderPlatformContext context;
        int starts;
        int finishes;
        Module(String id) { this.id = id; }
        public String getModuleId() { return id; }
        public int getDefaultPriority() { return 10; }
        public void onAttach(HeaderPlatformContext value) { context = value; }
        public void onStartInput(HeaderEditorContext editor, long token) { starts++; }
        public void onHeaderAvailable(HeaderHandle header) {}
        public void onHeaderUnavailable(long headerToken) {}
        public void onNativeCandidateStateChanged(boolean active) {}
        public void onThemeChanged(long token) {}
        public void onFinishInput(long token) { finishes++; }
        public void onDetach() { context = null; }
    }
    private static final class Listener implements HeaderRenderPlanListener {
        HeaderRenderPlan plan;
        int calls;
        public void onHeaderRenderPlanChanged(HeaderRenderPlan value) {
            plan = value;
            calls++;
        }
    }

    public static void main(String[] args) {
        verifyContributionValidation();
        verifyArbitration();
        verifyControllerLifecycle();
        System.out.println("header platform host contracts verified");
    }

    private static void verifyContributionValidation() {
        boolean failed = false;
        try {
            contribution("m", "bad", 1, 1, HeaderPresentationKind.REMOTE_SURFACE,
                    HeaderPlacement.TRAILING_ACTION, true);
        } catch (IllegalArgumentException expected) { failed = true; }
        require(failed);
    }

    private static void verifyArbitration() {
        java.util.List<HeaderContribution> values =
                new java.util.ArrayList<HeaderContribution>();
        values.add(contribution("low-priority", "content", 7, 10,
                HeaderPresentationKind.REMOTE_SURFACE,
                HeaderPlacement.CENTER_CONTENT, true));
        values.add(contribution("autofill", "content", 7, 20,
                HeaderPresentationKind.REMOTE_SURFACE,
                HeaderPlacement.CENTER_CONTENT, true));
        values.add(contribution("script", "toggle", 7, 5,
                HeaderPresentationKind.NATIVE_ACTION,
                HeaderPlacement.TRAILING_ACTION, false));
        HeaderArbiter arbiter = new HeaderArbiter();
        HeaderRenderPlan plan = arbiter.resolve(values, 7, 11, false, 3);
        require(plan.getCenter().getModuleId().equals("autofill"));
        require(plan.getTrailing().getModuleId().equals("script"));
        require(arbiter.resolve(values, 7, 11, true, 3).isNativeOwned());
        require(arbiter.resolve(values, 8, 11, false, 3).isIdle());
        require(arbiter.resolve(values, 7, 12, false, 3).isIdle());

        values.add(contribution("exclusive", "content", 7, 30,
                HeaderPresentationKind.REMOTE_SURFACE,
                HeaderPlacement.EXCLUSIVE_CONTENT, false));
        plan = arbiter.resolve(values, 7, 11, false, 3);
        require(plan.getCenter().getModuleId().equals("exclusive"));
        require(plan.getLeading() == null && plan.getTrailing() == null);
        values.add(contribution("clipboard", "native", 7, 100,
                HeaderPresentationKind.NATIVE_CANDIDATE,
                HeaderPlacement.CENTER_CONTENT, false));
        require(arbiter.resolve(values, 7, 11, true, 3).isNativeOwned());
        values.remove(values.size() - 1);
        require(arbiter.resolve(values, 7, 11, false, 4).getCenter()
                .getModuleId().equals("exclusive"));
    }

    private static void verifyControllerLifecycle() {
        HeaderPlatformController controller = new HeaderPlatformController();
        Module autofill = new Module("autofill");
        Module action = new Module("script-toggle-probe");
        Listener listener = new Listener();
        controller.register(autofill);
        controller.register(action);
        controller.initialize();
        long first = controller.startInput(null);
        HeaderHandle firstHeader = controller.bindHost(listener, Integer.valueOf(0x11223344));
        require(first > 0 && autofill.starts == 1);
        require(controller.getCurrentCandidateTextColor().intValue() == 0x11223344);
        HeaderContribution current = new HeaderContribution(
                "autofill", "content", first, firstHeader.getToken(), 20,
                HeaderPresentationKind.REMOTE_SURFACE,
                HeaderPlacement.CENTER_CONTENT, true, new Payload());
        require(controller.publish(current));
        require(listener.plan.getCenter() == current);
        HeaderNativeActionPayload actionPayload = new HeaderNativeActionPayload(
                HeaderActionKind.NEXT, "probe", true, new HeaderActionCallback() {
                    public void performAction() {}
                });
        HeaderContribution actionContribution = new HeaderContribution(
                "script-toggle-probe", "toggle", first, firstHeader.getToken(), 5,
                HeaderPresentationKind.NATIVE_ACTION, HeaderPlacement.TRAILING_ACTION,
                false, actionPayload);
        require(controller.publish(actionContribution));
        require(listener.plan.getTrailing() == actionContribution);
        long renderGeneration = listener.plan.getRenderGeneration();
        controller.onThemeChanged(9L);
        require(listener.plan.getRenderGeneration() > renderGeneration);
        controller.setNativeCandidatesActive(true);
        require(listener.plan.isNativeOwned());
        controller.setNativeCandidatesActive(false);
        require(listener.plan.getCenter() == current);
        controller.unbindHost(listener);
        require(listener.plan.isIdle());
        require(!controller.publish(current));
        HeaderHandle secondHeader = controller.bindHost(listener, Integer.valueOf(0x55667788));
        require(secondHeader.getToken() > firstHeader.getToken());
        controller.finishInput();
        require(listener.plan.isIdle() && autofill.finishes == 1);
        require(!controller.publish(current));
        long second = controller.startInput(null);
        require(second > first);
        require(!controller.publish(current));
        controller.destroy();
        require(autofill.finishes == 2 && autofill.context == null);
    }

    private static HeaderContribution contribution(String module, String stable,
            long session, int priority, HeaderPresentationKind kind,
            HeaderPlacement placement, boolean allowsActions) {
        return new HeaderContribution(module, stable, session, 11, priority, kind,
                placement, allowsActions, new Payload());
    }

    private static void require(boolean condition) {
        if (!condition) throw new AssertionError();
    }
}
"""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--decoded", type=Path)
    args = parser.parse_args()
    android_jar = args.android_jar.resolve()
    javac = (args.jdk / "bin/javac.exe").resolve()
    java = (args.jdk / "bin/java.exe").resolve()
    sources = sorted(
        path for path in SOURCE_DIR.glob("*.java")
        if path.name != "ClipboardHeaderModule.java"
    )
    if not sources:
        raise FileNotFoundError(SOURCE_DIR)
    for path in [android_jar, javac, java, *sources]:
        if not path.exists():
            raise FileNotFoundError(path)

    forbidden = (
        "android.service.autofill",
        "android.view.inputmethod.Inline",
        "androidx.autofill",
        "commitText(",
    )
    combined = "\n".join(path.read_text(encoding="utf-8") for path in sources)
    found = [value for value in forbidden if value in combined]
    if found:
        raise RuntimeError(f"API-neutral Header platform contains forbidden coupling: {found}")
    for value in (
        "((ViewGroup) contentParent).removeView(nativeContent)",
        "Drawable nativeBackground = nativeRoot.getBackground()",
        "nativeRoot.setBackground(null)",
        "neutralRoot.setBackground(nativeBackground)",
    ):
        if value not in combined:
            raise RuntimeError(f"Native chrome is not detached into a neutral touch shell: {value}")

    module_api = "\n".join(
        (SOURCE_DIR / name).read_text(encoding="utf-8")
        for name in ("HeaderModule.java", "HeaderPlatformContext.java",
                     "HeaderContribution.java", "HeaderPlatformController.java")
    )
    if "android.view.View" in module_api or "bringToFront(" in module_api:
        raise RuntimeError("Module-facing Header contracts expose or manipulate Views")

    generated_dir = ROOT / "patches/smali/headerplatform"
    generated = sorted(generated_dir.glob("*.smali"))
    required_smali = (
        "HeaderPlatformController.smali",
        "HeaderArbiter.smali",
        "HeaderContribution.smali",
        "HeaderSessionController.smali",
        "HeaderModule.smali",
        "ClipboardHeaderModule.smali",
        "ClipboardHeaderModule$1.smali",
    )
    missing = [name for name in required_smali if not (generated_dir / name).exists()]
    if missing:
        raise RuntimeError(f"Generated Header platform Smali is incomplete: {missing}")
    smali_text = "\n".join(path.read_text(encoding="utf-8") for path in generated)
    smali_forbidden = (
        "Landroid/service/autofill/",
        "Landroid/view/inputmethod/Inline",
        "Landroidx/autofill/",
        "->commitText(",
    )
    found_smali = [value for value in smali_forbidden if value in smali_text]
    if found_smali:
        raise RuntimeError(f"Header platform Smali contains forbidden coupling: {found_smali}")
    module_smali = "\n".join(
        (generated_dir / name).read_text(encoding="utf-8")
        for name in ("HeaderModule.smali", "HeaderPlatformContext.smali",
                     "HeaderContribution.smali", "HeaderPlatformController.smali")
    )
    if ("Landroid/view/View;" in module_smali or "->setVisibility(" in module_smali
            or "->bringToFront(" in module_smali):
        raise RuntimeError("Module-facing Header Smali exposes or manipulates Views")

    if args.decoded is not None:
        decoded = args.decoded.resolve()
        packaged = decoded / "smali/com/google/android/inputmethod/pinyin/headerplatform"
        for name in required_smali:
            if not (packaged / name).exists():
                raise FileNotFoundError(packaged / name)
        fixed_holder = (decoded / (
            "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
            "FixedSizeCandidatesHolderView.smali"
        )).read_text(encoding="utf-8")
        for value in (
            "HeaderChromeFactory;", "HeaderNativeCandidateSource;",
            ".method public createCandidateChromeSlot()Lcom/google/android/inputmethod/"
            "pinyin/headerplatform/HeaderVisualSlot;",
            ".method public createActionChromeSlot(",
            "SoftKeyDef$a;->b:I",
            ".method public setHeaderNativeCandidateStateListener(",
            "->notifyHeaderPlatformCandidateState()V",
            "ClipboardCandidateCompat;->isInjected()Z",
            "->onNativeCandidateStateChanged(ZZ)V",
        ):
            if value not in fixed_holder:
                raise RuntimeError(f"Native Header holder seam is incomplete: {value}")
        slot_method = fixed_holder.split(
            ".method public createCandidateChromeSlot()", 1
        )[1].split(".end method", 1)[0]
        if "framework/core/Candidate;" in slot_method or "ActionDef" in slot_method:
            raise RuntimeError("Native visual slot binds Candidate data or actions")
        pinyin = (decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali").read_text(
            encoding="utf-8"
        )
        for value in (
            "HeaderPlatformOwner;", "->getHeaderPlatformController()",
            "HeaderPlatformController;->startInput(",
            "HeaderPlatformController;->finishInput()V",
            "HeaderPlatformController;->destroy()V",
        ):
            if value not in pinyin:
                raise RuntimeError(f"IME Header platform lifecycle is incomplete: {value}")
        platform_layouts = (
            "keyboard_prime_header.xml", "keyboard_prime_header_no_deletable_label.xml",
            "keyboard_handwriting_header.xml", "keyboard_hard_header.xml",
            "keyboard_hard_header_no_deletable_label.xml", "keyboard_universal_header.xml",
        )
        for name in platform_layouts:
            text = (decoded / "res/layout" / name).read_text(encoding="utf-8")
            if text.count("HeaderPlatformHostView") != 1 or text.count(
                    'android:tag="header-platform-native-layer"') != 1:
                raise RuntimeError(f"Expected exactly one Header platform host in {name}")

    with tempfile.TemporaryDirectory(prefix="header-platform-") as temporary:
        root = Path(temporary)
        harness = root / "HeaderPlatformHostTest.java"
        harness.write_text(HARNESS, encoding="utf-8")
        subprocess.run(
            [str(javac), "-source", "7", "-target", "7",
             "-bootclasspath", str(android_jar), "-d", str(root),
             *[str(path) for path in sources], str(harness)],
            check=True,
        )
        subprocess.run(
            [str(java), "-cp", str(root) + os.pathsep + str(android_jar),
             "HeaderPlatformHostTest"],
            check=True,
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
