#!/usr/bin/env python3
"""Compile the dictionary backup and import Java patches into patch Smali.

These classes were previously compiled outside the repository, which made their Smali
unreproducible. This script compiles the Java sources that live directly in the
`com.google.android.inputmethod.pinyin` package against the platform jar, a small stub for the
framework task listener, and the shared native-contract stubs.
"""

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
OUTPUT_DIR = ROOT / "patches/smali"

TARGETS = (
    "DictionaryAutoBackupCompat",
)

TASK_LISTENER_STUB = """
package com.google.android.apps.inputmethod.libs.framework.core;

public interface TaskListener {
    void onTaskStart();
    void onTaskProgress(int progress);
    void onTaskError(int error);
    void onTaskFinished(boolean success, Object result);
}
"""


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

    sources = []
    for name in TARGETS:
        path = PACKAGE_DIR / (name + ".java")
        if not path.exists():
            raise FileNotFoundError(path)
        sources.append(path)
    # Compiled for class resolution only: these packages and the health page keep their own
    # generators, so their Smali is never written from here.
    for dependency in ("DictionaryHealthStatusCompat", "DictionaryAutoBackupSettingsCompat",
                       "LocalBackupImportActivity"):
        sources.append(PACKAGE_DIR / (dependency + ".java"))
    for shared in ("rimesync", "dictsafety"):
        sources.extend(sorted((PACKAGE_DIR / shared).glob("*.java")))
    for path in (android_jar, javac, jar, d8, apktool):
        if not path.exists():
            raise FileNotFoundError(path)

    environment = os.environ.copy()
    environment["JAVA_HOME"] = str(jdk)
    environment["PATH"] = str(jdk / "bin") + os.pathsep + environment.get("PATH", "")

    with tempfile.TemporaryDirectory(prefix="dictionary-patch-smali-") as temporary:
        root = Path(temporary)
        stub_classes = root / "stub-classes"
        classes = root / "classes"
        dex = root / "dex"
        decoded = root / "decoded"
        for directory in (stub_classes, classes, dex):
            directory.mkdir()
        stub_sources = write_stubs(root / "stubs", include_android_context=False)
        listener = root / "stubs/com/google/android/apps/inputmethod/libs/framework/core/TaskListener.java"
        listener.parent.mkdir(parents=True, exist_ok=True)
        listener.write_text(TASK_LISTENER_STUB.strip() + "\n", encoding="utf-8")
        stub_sources.append(listener)
        subprocess.run(
            [str(javac), "-encoding", "UTF-8", "-source", "8", "-target", "8",
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
            [str(javac), "-encoding", "UTF-8", "-source", "8", "-target", "8",
             "-bootclasspath", str(android_jar), "-classpath", str(stub_jar),
             "-d", str(classes), *[str(path) for path in sources]],
            check=True,
            env=environment,
        )
        compiled = root / "dictionary-patches.jar"
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
        tiny_apk = root / "dictionary-patches.apk"
        with zipfile.ZipFile(tiny_apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run(
            [str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
             str(tiny_apk), "-o", str(decoded)],
            check=True,
            env=environment,
        )
        generated = decoded / "smali/com/google/android/inputmethod/pinyin"
        written = 0
        for path in sorted(generated.glob("*.smali")):
            if not any(path.name.split("$")[0] == name + ".smali" for name in TARGETS):
                continue
            target = OUTPUT_DIR / path.name
            payload = path.read_bytes()
            if target.exists() and target.read_bytes() == payload:
                continue
            shutil.copyfile(path, target)
            written += 1
            print(target.relative_to(ROOT))
        print("updated %d Smali files" % written)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
