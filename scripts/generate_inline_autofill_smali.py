#!/usr/bin/env python3
"""Compile the API 30 Inline bridge against platform contracts and refresh its patch Smali."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INLINE_SOURCE = ROOT / "patches/java/com/google/android/inputmethod/pinyin/InlineAutofillCompat.java"
PLATFORM_SOURCES = ROOT / "patches/java/com/google/android/inputmethod/pinyin/headerplatform"
OUTPUT_DIR = ROOT / "patches/smali"
ANDROIDX_JAR = ROOT / "work/inline-autofill-synthetic-provider/libs/classes.jar"

LEGACY_THEME_STUBS = {
    "com/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme.java": r"""
package com.google.android.apps.inputmethod.libs.framework.keyboard;
public interface IKeyboardTheme {
    void applyToContext(android.content.Context context);
    String getResourceCacheKey();
    String getViewStyleCacheKey();
}
""",
    "com/google/android/inputmethod/pinyin/PinyinIME.java": r"""
package com.google.android.inputmethod.pinyin;
public class PinyinIME extends android.inputmethodservice.InputMethodService {
    protected final com.google.android.apps.inputmethod.libs.framework.keyboard.IKeyboardTheme
            a() { return null; }
}
""",
}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--build-tools", type=Path, required=True)
    parser.add_argument("--apktool", type=Path, required=True)
    args = parser.parse_args()
    android_jar = args.android_jar.resolve()
    jdk = args.jdk.resolve()
    javac = jdk / "bin/javac.exe"
    jar = jdk / "bin/jar.exe"
    d8 = args.build_tools.resolve() / "d8.bat"
    apktool = args.apktool.resolve()
    platform_sources = sorted(
        path for path in PLATFORM_SOURCES.glob("*.java")
        if path.name != "ClipboardHeaderModule.java"
    )
    for path in [INLINE_SOURCE, ANDROIDX_JAR, android_jar, javac, jar, d8, apktool,
                 *platform_sources]:
        if not path.exists(): raise FileNotFoundError(path)
    environment = os.environ.copy()
    environment["JAVA_HOME"] = str(jdk)
    environment["PATH"] = str(jdk / "bin") + os.pathsep + environment.get("PATH", "")

    with tempfile.TemporaryDirectory(prefix="inline-autofill-smali-") as temporary:
        root = Path(temporary)
        classes = root / "classes"
        dex = root / "dex"
        decoded = root / "decoded"
        classes.mkdir(); dex.mkdir()
        stub_sources = []
        for relative, source in LEGACY_THEME_STUBS.items():
            stub = root / "stubs" / relative
            stub.parent.mkdir(parents=True, exist_ok=True)
            stub.write_text(source, encoding="utf-8")
            stub_sources.append(stub)
        subprocess.run(
            [str(javac), "-source", "8", "-target", "8", "-bootclasspath",
             str(android_jar), "-classpath", str(ANDROIDX_JAR),
             "-d", str(classes), str(INLINE_SOURCE),
             *[str(path) for path in platform_sources],
             *[str(path) for path in stub_sources]],
            check=True, env=environment,
        )
        compiled = root / "inline.jar"
        subprocess.run([str(jar), "cf", str(compiled), "-C", str(classes), "."],
                       check=True, env=environment)
        subprocess.run(
            [str(d8), "--min-api", "30", "--lib", str(android_jar),
             "--classpath", str(ANDROIDX_JAR), "--output", str(dex), str(compiled)],
            check=True, env=environment,
        )
        apk = root / "inline.apk"
        with zipfile.ZipFile(apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run(
            [str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
             str(apk), "-o", str(decoded)], check=True, env=environment,
        )
        generated = decoded / "smali/com/google/android/inputmethod/pinyin"
        files = sorted(generated.glob("InlineAutofillCompat*.smali"))
        if not files: raise RuntimeError("InlineAutofillCompat Smali was not generated")
        for old in OUTPUT_DIR.glob("InlineAutofillCompat*.smali"):
            old.unlink()
        for source in files:
            shutil.copyfile(source, OUTPUT_DIR / source.name)
    print(f"Generated {len(files)} Inline Autofill bridge Smali files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
