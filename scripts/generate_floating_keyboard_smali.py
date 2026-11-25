#!/usr/bin/env python3
"""Reproducibly compile the floating keyboard bridge.

The class compiled here is a plain Android library helper: it only touches
framework types, so no application stubs are required. It is the source of
truth for `patches/smali/FloatingKeyboardCompat.smali`, which is injected into
the decoded application by `apply_patches.py`.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACKAGE_DIR = "com/google/android/inputmethod/pinyin"
SOURCES = [
    ROOT / f"patches/java/{PACKAGE_DIR}/FloatingKeyboardCompat.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/FloatingKeyboardHandle.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/FloatingKeyboardEdit.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/QuickBar.java",
]
OUTPUT_DIR = ROOT / "patches/smali"
# Anonymous and nested classes compile to their own files; copying only the top level class leaves
# the app crashing with ClassNotFoundException at runtime.
SMALI_PREFIXES = [
    "FloatingKeyboardCompat",
    "FloatingKeyboardHandle",
    "FloatingKeyboardEdit",
    "QuickBar",
]


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
    for path in (*SOURCES, android_jar, javac, jar, d8, apktool):
        if not path.exists():
            raise FileNotFoundError(path)

    env = os.environ.copy()
    env["JAVA_HOME"] = str(jdk)
    env["PATH"] = str(jdk / "bin") + os.pathsep + env.get("PATH", "")
    with tempfile.TemporaryDirectory(prefix="system-auto-theme-smali-") as temporary:
        root = Path(temporary)
        classes = root / "classes"
        dex = root / "dex"
        decoded = root / "decoded"
        classes.mkdir()
        dex.mkdir()
        subprocess.run(
            [str(javac), "-source", "7", "-target", "7", "-bootclasspath",
             str(android_jar), "-d", str(classes), *[str(source) for source in SOURCES]],
            check=True, env=env,
        )
        compiled = root / "system-auto-theme.jar"
        # Pack the whole output tree: jar on Windows rejects forward slashes in entry names.
        subprocess.run(
            [str(jar), "cf", str(compiled), "-C", str(classes), "."],
            check=True, env=env,
        )
        subprocess.run(
            [str(d8), "--min-api", "17", "--lib", str(android_jar),
             "--output", str(dex), str(compiled)],
            check=True, env=env,
        )
        tiny_apk = root / "system-auto-theme.apk"
        with zipfile.ZipFile(tiny_apk, "w", zipfile.ZIP_STORED) as archive:
            archive.write(dex / "classes.dex", "classes.dex")
        subprocess.run(
            [str(jdk / "bin/java.exe"), "-jar", str(apktool), "d", "-f",
             str(tiny_apk), "-o", str(decoded)],
            check=True, env=env,
        )
        generated_dir = decoded / "smali" / PACKAGE_DIR
        written = 0
        for generated in sorted(generated_dir.glob("*.smali")):
            if not any(
                generated.stem == prefix or generated.stem.startswith(prefix + "$")
                for prefix in SMALI_PREFIXES
            ):
                continue
            (OUTPUT_DIR / generated.name).write_bytes(generated.read_bytes())
            print(f"Generated {OUTPUT_DIR / generated.name}")
            written += 1
        if written == 0:
            raise FileNotFoundError(generated_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
