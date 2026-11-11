#!/usr/bin/env python3
"""Compile the research probes into Smali.

These probes drive the original import pipeline and damage or swap the dictionary file to answer
questions about the native implementation. They must never ship: `apply_patches.py` deploys this
Smali only when it is asked for with `--research`, and release builds never ask.

The sources depend on nothing but the platform jar, so no contract stubs are involved.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "patches/research/java/com/google/android/inputmethod/pinyin"
OUTPUT_DIR = ROOT / "patches/research/smali/com/google/android/inputmethod/pinyin"


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
    sources = sorted(SOURCE_DIR.glob("*.java"))
    for path in (android_jar, javac, jar, d8, apktool, *sources):
        if not path.exists():
            raise FileNotFoundError(path)
    if not sources:
        raise RuntimeError("Research probe sources are missing")

    environment = os.environ.copy()
    environment["JAVA_HOME"] = str(jdk)
    environment["PATH"] = str(jdk / "bin") + os.pathsep + environment.get("PATH", "")

    with tempfile.TemporaryDirectory(prefix="research-probe-smali-") as temporary:
        root = Path(temporary)
        classes = root / "classes"
        dex = root / "dex"
        decoded = root / "decoded"
        classes.mkdir()
        dex.mkdir()
        subprocess.run(
            [str(javac), "-encoding", "UTF-8", "-source", "8", "-target", "8",
             "-bootclasspath", str(android_jar), "-d", str(classes),
             *[str(path) for path in sources]],
            check=True,
            env=environment,
        )
        compiled = root / "research-probe.jar"
        subprocess.run(
            [str(jar), "cf", str(compiled), "-C", str(classes),
             "com/google/android/inputmethod/pinyin"],
            check=True,
            env=environment,
        )
        subprocess.run(
            [str(d8), "--min-api", "23", "--lib", str(android_jar),
             "--output", str(dex), str(compiled)],
            check=True,
            env=environment,
        )
        tiny_apk = root / "research-probe.apk"
        with zipfile.ZipFile(tiny_apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run(
            [str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
             str(tiny_apk), "-o", str(decoded)],
            check=True,
            env=environment,
        )
        generated = decoded / "smali/com/google/android/inputmethod/pinyin"
        generated_files = sorted(generated.glob("Native*.smali"))
        if not generated_files:
            raise RuntimeError("Research probe Smali was not generated")
        if OUTPUT_DIR.exists():
            shutil.rmtree(OUTPUT_DIR)
        OUTPUT_DIR.mkdir(parents=True)
        for path in generated_files:
            shutil.copyfile(path, OUTPUT_DIR / path.name)
            print(path.relative_to(decoded))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
