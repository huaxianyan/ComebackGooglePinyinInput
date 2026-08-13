#!/usr/bin/env python3
"""Compile ClipboardHeaderModule against generated platform and legacy Clipboard Smali APIs."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "patches/java/com/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule.java"
PLATFORM_SOURCES = ROOT / "patches/java/com/google/android/inputmethod/pinyin/headerplatform"
OUTPUT = ROOT / "patches/smali/headerplatform/ClipboardHeaderModule.smali"

STUB = r"""
package com.google.android.apps.inputmethod.libs.framework.core;
public final class ClipboardCandidateCompat {
    public static boolean isInjected() { return false; }
}
"""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--build-tools", type=Path, required=True)
    parser.add_argument("--apktool", type=Path, required=True)
    args = parser.parse_args()
    android_jar = args.android_jar.resolve(); jdk = args.jdk.resolve()
    javac = jdk / "bin/javac.exe"; jar = jdk / "bin/jar.exe"
    d8 = args.build_tools.resolve() / "d8.bat"; apktool = args.apktool.resolve()
    platform = sorted(path for path in PLATFORM_SOURCES.glob("*.java") if path != SOURCE)
    environment = os.environ.copy(); environment["JAVA_HOME"] = str(jdk)
    environment["PATH"] = str(jdk / "bin") + os.pathsep + environment.get("PATH", "")
    with tempfile.TemporaryDirectory(prefix="clipboard-header-smali-") as temporary:
        root = Path(temporary); classes = root / "classes"; dex = root / "dex"; decoded = root / "decoded"
        classes.mkdir(); dex.mkdir()
        stub = root / "com/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat.java"
        stub.parent.mkdir(parents=True); stub.write_text(STUB, encoding="utf-8")
        subprocess.run([str(javac), "-source", "7", "-target", "7", "-bootclasspath",
                        str(android_jar), "-d", str(classes), str(SOURCE), str(stub),
                        *[str(path) for path in platform]], check=True, env=environment)
        compiled = root / "clipboard.jar"
        subprocess.run([str(jar), "cf", str(compiled), "-C", str(classes), "."], check=True, env=environment)
        subprocess.run([str(d8), "--min-api", "17", "--lib", str(android_jar),
                        "--output", str(dex), str(compiled)], check=True, env=environment)
        apk = root / "clipboard.apk"
        with zipfile.ZipFile(apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run([str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
                        str(apk), "-o", str(decoded)], check=True, env=environment)
        generated_dir = decoded / "smali/com/google/android/inputmethod/pinyin/headerplatform"
        generated = sorted(generated_dir.glob("ClipboardHeaderModule*.smali"))
        if not generated: raise RuntimeError("ClipboardHeaderModule Smali missing")
        OUTPUT.parent.mkdir(parents=True, exist_ok=True)
        for old in OUTPUT.parent.glob("ClipboardHeaderModule*.smali"): old.unlink()
        for source in generated: shutil.copyfile(source, OUTPUT.parent / source.name)
    print(f"Generated {len(generated)} ClipboardHeaderModule Smali files")
    return 0


if __name__ == "__main__": raise SystemExit(main())
