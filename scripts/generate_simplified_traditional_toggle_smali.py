#!/usr/bin/env python3
"""Reproducibly compile the preference-aware native Simplified/Traditional key View."""

from __future__ import annotations

import argparse
import os
import subprocess
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / (
    "patches/java/com/google/android/inputmethod/pinyin/"
    "SimplifiedTraditionalToggleKeyView.java"
)
OUTPUT = ROOT / "patches/smali/SimplifiedTraditionalToggleKeyView.smali"
STUB = """package com.google.android.apps.inputmethod.libs.framework.keyboard;
import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;
public class SoftKeyView extends FrameLayout {
    public SoftKeyView(Context context) { super(context); }
    public SoftKeyView(Context context, AttributeSet attrs) { super(context, attrs); }
    public SoftKeyView(Context context, AttributeSet attrs, int style) {
        super(context, attrs, style);
    }
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
    for path in (SOURCE, android_jar, javac, jar, d8, apktool):
        if not path.exists():
            raise FileNotFoundError(path)

    env = os.environ.copy()
    env["JAVA_HOME"] = str(jdk)
    env["PATH"] = str(jdk / "bin") + os.pathsep + env.get("PATH", "")
    with tempfile.TemporaryDirectory(prefix="sc-tc-toggle-smali-") as temporary:
        root = Path(temporary)
        stub = root / (
            "src/com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView.java"
        )
        stub.parent.mkdir(parents=True)
        stub.write_text(STUB, encoding="utf-8")
        classes = root / "classes"
        dex = root / "dex"
        decoded = root / "decoded"
        classes.mkdir()
        dex.mkdir()
        subprocess.run(
            [str(javac), "-source", "7", "-target", "7", "-bootclasspath",
             str(android_jar), "-d", str(classes), str(stub), str(SOURCE)],
            check=True, env=env,
        )
        compiled = root / "toggle.jar"
        subprocess.run(
            [str(jar), "cf", str(compiled), "-C", str(classes),
             "com/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView.class"],
            check=True, env=env,
        )
        subprocess.run(
            [str(d8), "--min-api", "17", "--lib", str(android_jar),
             "--output", str(dex), str(compiled)],
            check=True, env=env,
        )
        tiny_apk = root / "toggle.apk"
        with zipfile.ZipFile(tiny_apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run(
            [str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
             str(tiny_apk), "-o", str(decoded)],
            check=True, env=env,
        )
        generated = decoded / (
            "smali/com/google/android/inputmethod/pinyin/"
            "SimplifiedTraditionalToggleKeyView.smali"
        )
        if not generated.is_file():
            raise FileNotFoundError(generated)
        OUTPUT.write_bytes(generated.read_bytes())

    print(f"Generated {OUTPUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
