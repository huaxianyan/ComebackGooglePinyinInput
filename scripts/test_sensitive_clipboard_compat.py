#!/usr/bin/env python3
"""Host-side contract tests for the old-ART sensitive clipboard helper."""

from __future__ import annotations

import argparse
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "patches/java/com/google/android/inputmethod/pinyin/SensitiveClipboardCompat.java"

HARNESS = r"""
import com.google.android.inputmethod.pinyin.SensitiveClipboardCompat;

public final class SensitiveClipboardCompatHostTest {
    public static void main(String[] args) {
        require(SensitiveClipboardCompat.isPasswordInputType(0x00000081));
        require(SensitiveClipboardCompat.isPasswordInputType(0x000000e1));
        require(SensitiveClipboardCompat.isPasswordInputType(0x00000012));
        require(!SensitiveClipboardCompat.isPasswordInputType(0x00000091));
        require(!SensitiveClipboardCompat.isPasswordInputType(0x00000002));
        require(!SensitiveClipboardCompat.isPasswordInputType(0x00000001));
        require(SensitiveClipboardCompat.mask("").equals(""));
        require(SensitiveClipboardCompat.mask("123456").equals("••••••"));
        require(SensitiveClipboardCompat.mask(
                "abcdefghijklmnopqrstuvwxyz0123456789").length() == 32);
        String key = SensitiveClipboardCompat.makeOpaqueKey(
                "Correct-Horse-Test-Only", 1234L);
        require(!key.contains("Correct-Horse-Test-Only"));
        require(key.endsWith("\u001f23\u001f1234"));
        require(key.equals(SensitiveClipboardCompat.makeOpaqueKey(
                "Correct-Horse-Test-Only", 1234L)));
        require(!key.equals(SensitiveClipboardCompat.makeOpaqueKey(
                "Different", 1234L)));
        System.out.println("sensitive clipboard host contracts verified");
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
    for path in (SOURCE, android_jar, javac, java):
        if not path.exists():
            raise FileNotFoundError(path)

    source_text = SOURCE.read_text(encoding="utf-8")
    required = (
        "Build.VERSION.SDK_INT < 24",
        'EXTRA_IS_SENSITIVE = "android.content.extra.IS_SENSITIVE"',
        "MAX_MASK_CODE_UNITS = 32",
        "variation == 0x80 || variation == 0xe0",
        "inputClass == 0x02 && variation == 0x10",
        'MessageDigest.getInstance("SHA-256")',
    )
    missing = [value for value in required if value not in source_text]
    if missing:
        raise RuntimeError(f"Sensitive clipboard source contract is incomplete: {missing}")

    candidate_source = (
        ROOT / "patches/smali/ClipboardCandidateCompat.smali"
    ).read_text(encoding="utf-8")
    candidate_required = (
        ".field private static candidateSensitive:Z",
        ".field private static candidatePayload:Ljava/lang/String;",
        ".field private final maskForEditor:Z",
        "SensitiveClipboardCompat;->isSourceSensitive",
        "SensitiveClipboardCompat;->isPasswordEditor",
        "SensitiveClipboardCompat;->mask",
        "SensitiveClipboardCompat;->makeOpaqueKey",
        'const-string v0, "compat_clipboard:sensitive"',
        "->candidatePayload:Ljava/lang/String;",
    )
    missing = [value for value in candidate_required if value not in candidate_source]
    if missing:
        raise RuntimeError(f"Sensitive clipboard candidate patch is incomplete: {missing}")
    if 'const-string v3, "粘贴敏感剪贴板内容"' not in candidate_source:
        raise RuntimeError("Sensitive clipboard accessibility text is missing")
    if "ClipDescription;->getExtras()" in candidate_source:
        raise RuntimeError("Clipboard candidate bypasses the API-gated sensitivity helper")

    if args.decoded is not None:
        decoded = args.decoded.resolve()
        candidate = decoded / (
            "smali/com/google/android/apps/inputmethod/libs/framework/core/"
            "ClipboardCandidateCompat.smali"
        )
        helper = decoded / (
            "smali/com/google/android/inputmethod/pinyin/"
            "SensitiveClipboardCompat.smali"
        )
        for path in (candidate, helper):
            if not path.exists():
                raise FileNotFoundError(path)
        candidate_text = candidate.read_text(encoding="utf-8")
        helper_text = helper.read_text(encoding="utf-8")
        for value in candidate_required:
            if value not in candidate_text:
                raise RuntimeError(f"Final clipboard candidate is missing: {value}")
        if (
            'const-string v3, "粘贴敏感剪贴板内容"' not in candidate_text
            and 'const-string v3, "\\u7c98\\u8d34\\u654f\\u611f\\u526a\\u8d34\\u677f\\u5185\\u5bb9"'
            not in candidate_text
        ):
            raise RuntimeError("Final sensitive accessibility text is missing")
        for value in (
            ".method public static isSourceSensitive(Landroid/content/ClipDescription;)Z",
            ".method public static isPasswordEditor(Landroid/view/inputmethod/EditorInfo;)Z",
            ".method public static isPasswordInputType(I)Z",
            ".method public static mask(Ljava/lang/String;)Ljava/lang/String;",
            ".method public static makeOpaqueKey(Ljava/lang/String;J)Ljava/lang/String;",
            '"android.content.extra.IS_SENSITIVE"',
            '"SHA-256"',
        ):
            if value not in helper_text:
                raise RuntimeError(f"Final sensitive clipboard helper is missing: {value}")

    with tempfile.TemporaryDirectory(prefix="sensitive-clipboard-test-") as temporary:
        directory = Path(temporary)
        classes = directory / "classes"
        classes.mkdir()
        harness = directory / "SensitiveClipboardCompatHostTest.java"
        harness.write_text(HARNESS, encoding="utf-8")
        subprocess.run(
            [
                str(javac),
                "-encoding", "UTF-8",
                "-source", "7",
                "-target", "7",
                "-bootclasspath", str(android_jar),
                "-d", str(classes),
                str(SOURCE),
            ],
            check=True,
        )
        classpath = f"{classes};{android_jar}"
        subprocess.run(
            [
                str(javac),
                "-encoding", "UTF-8",
                "-cp", classpath,
                "-d", str(classes),
                str(harness),
            ],
            check=True,
        )
        subprocess.run(
            [str(java), "-cp", classpath, "SensitiveClipboardCompatHostTest"],
            check=True,
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
