#!/usr/bin/env python3
"""Reproducibly compile the private dictionary safety net's Java sources into patch Smali."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path

from rime_sync_build_support import write_stubs

ROOT = Path(__file__).resolve().parents[1]
PACKAGE_DIR = ROOT / "patches/java/com/google/android/inputmethod/pinyin"
SOURCE_DIR = PACKAGE_DIR / "dictsafety"
SHARED_SOURCE_DIR = PACKAGE_DIR / "rimesync"
OUTPUT_DIR = ROOT / "patches/smali/dictsafety"


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
    # The safety net calls the shared native bridge, so that source is compiled alongside. Only the
    # dictsafety package is written out; rimesync Smali keeps its own generator.
    sources = sorted(SOURCE_DIR.glob("*.java")) + sorted(SHARED_SOURCE_DIR.glob("*.java"))
    if not list(SOURCE_DIR.glob("*.java")):
        raise RuntimeError("Dictionary safety Java sources are missing")
    for path in (android_jar, javac, jar, d8, apktool, *sources):
        if not path.exists():
            raise FileNotFoundError(path)

    environment = os.environ.copy()
    environment["JAVA_HOME"] = str(jdk)
    environment["PATH"] = str(jdk / "bin") + os.pathsep + environment.get("PATH", "")

    with tempfile.TemporaryDirectory(prefix="dictsafety-smali-") as temporary:
        root = Path(temporary)
        stub_classes = root / "stub-classes"
        classes = root / "classes"
        dex = root / "dex"
        decoded = root / "decoded"
        for directory in (stub_classes, classes, dex):
            directory.mkdir()
        stub_sources = write_stubs(root / "stubs", include_android_context=False)
        subprocess.run(
            [str(javac), "-encoding", "UTF-8", "-source", "7", "-target", "7",
             "-bootclasspath", str(android_jar), "-d", str(stub_classes),
             *[str(path) for path in stub_sources]],
            check=True,
            env=environment,
        )
        stub_jar = root / "native-contracts.jar"
        subprocess.run(
            [str(jar), "cf", str(stub_jar), "-C", str(stub_classes), "."],
            check=True,
            env=environment,
        )
        subprocess.run(
            [str(javac), "-encoding", "UTF-8", "-source", "7", "-target", "7",
             "-bootclasspath", str(android_jar), "-classpath", str(stub_jar),
             "-d", str(classes), *[str(path) for path in sources]],
            check=True,
            env=environment,
        )
        compiled = root / "dictsafety.jar"
        subprocess.run(
            [str(jar), "cf", str(compiled), "-C", str(classes),
             "com/google/android/inputmethod/pinyin"],
            check=True,
            env=environment,
        )
        subprocess.run(
            [str(d8), "--min-api", "17", "--lib", str(android_jar),
             "--classpath", str(stub_jar), "--output", str(dex), str(compiled)],
            check=True,
            env=environment,
        )
        tiny_apk = root / "dictsafety.apk"
        with zipfile.ZipFile(tiny_apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run(
            [str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
             str(tiny_apk), "-o", str(decoded)],
            check=True,
            env=environment,
        )
        generated = decoded / "smali/com/google/android/inputmethod/pinyin/dictsafety"
        generated_files = sorted(generated.glob("*.smali"))
        if not generated_files:
            raise RuntimeError("Dictionary safety Smali was not generated")
        if OUTPUT_DIR.exists():
            shutil.rmtree(OUTPUT_DIR)
        shutil.copytree(generated, OUTPUT_DIR)
        for path in sorted(OUTPUT_DIR.glob("*.smali")):
            print(path.relative_to(ROOT))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
