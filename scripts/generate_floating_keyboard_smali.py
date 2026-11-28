#!/usr/bin/env python3
"""Reproducibly compile the floating keyboard bridge.

Most of the classes compiled here only touch framework types. The access point
handler also implements an interface from the application's own framework
package, so that one contract is stubbed for javac and never packaged. These
files are the source of truth for `patches/smali/*.smali`, which
`apply_patches.py` injects into the decoded application.
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
    ROOT / f"patches/java/{PACKAGE_DIR}/FloatingKeyboardEditView.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/FloatingCardShadow.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/ClipboardDismissAlign.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/AccessPointsOrder.java",
    ROOT / f"patches/java/{PACKAGE_DIR}/FloatingAccessPointHandler.java",
]
OUTPUT_DIR = ROOT / "patches/smali"
# Anonymous and nested classes compile to their own files; copying only the top level class leaves
# the app crashing with ClassNotFoundException at runtime.
SMALI_PREFIXES = [
    "FloatingKeyboardCompat",
    "FloatingKeyboardHandle",
    "FloatingKeyboardEditView",
    "FloatingCardShadow",
    "ClipboardDismissAlign",
    "AccessPointsOrder",
    "FloatingAccessPointHandler",
]

# Only the contract the handler implements: enough for javac, never packaged.
ACCESS_POINTS_STUB = """
package com.google.android.apps.inputmethod.libs.framework.core;

import java.util.Map;

public class AccessPointsManager {
    public interface IAccessPointFeatureHandler {
        boolean closeFeature(String id);
        boolean launchFeature(String id, Map<String, Object> args);
    }

    public void a(IAccessPointFeatureHandler handler) {
    }

    public void collapseAccessPoints() {
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
        stub_classes = root / "stub-classes"
        stub_classes.mkdir()
        stub = root / "stubs/AccessPointsManager.java"
        stub.parent.mkdir(parents=True, exist_ok=True)
        stub.write_text(ACCESS_POINTS_STUB.strip() + chr(10), encoding="utf-8")
        subprocess.run(
            [str(javac), "-source", "7", "-target", "7", "-bootclasspath",
             str(android_jar), "-d", str(stub_classes), str(stub)],
            check=True, env=env,
        )
        contract = root / "native-contracts.jar"
        subprocess.run(
            [str(jar), "cf", str(contract), "-C", str(stub_classes), "."],
            check=True, env=env,
        )
        subprocess.run(
            [str(javac), "-source", "7", "-target", "7", "-bootclasspath",
             str(android_jar), "-classpath", str(contract),
             "-d", str(classes), *[str(source) for source in SOURCES]],
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
