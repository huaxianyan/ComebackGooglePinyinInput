#!/usr/bin/env python3
"""Host test for the private dictionary safety net's pure logic.

Covers the health policy and the snapshot text form only: no Android types, no engine.
Build and device behaviour are verified separately.
"""

from __future__ import annotations

import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [
    ROOT / "patches/java/com/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy.java",
    ROOT / "patches/java/com/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot.java",
]
TEST_SOURCE = ROOT / "work/safety-host-test/src/SafetyHostTest.java"
OUT = ROOT / "work/safety-host-test/classes"


def jdk_tool(name: str) -> Path:
    home = os.environ.get("JAVA_HOME")
    candidates = [Path(home) / "bin" / name] if home else []
    candidates += [
        Path("C:/Users/7inaBranford/scoop/apps/temurin17-jdk/current/bin") / name,
        Path("C:/Users/7inaBranford/scoop/apps/openjdk17/current/bin") / name,
    ]
    for candidate in candidates:
        if candidate.with_suffix(".exe").exists():
            return candidate.with_suffix(".exe")
        if candidate.exists():
            return candidate
    raise SystemExit("javac not found; set JAVA_HOME to a JDK 17")


def main() -> int:
    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir(parents=True)
    javac = jdk_tool("javac")
    java = jdk_tool("java")
    subprocess.run(
        [str(javac), "-encoding", "UTF-8", "-d", str(OUT)]
        + [str(source) for source in SOURCES]
        + [str(TEST_SOURCE)],
        cwd=ROOT,
        check=True,
    )
    return subprocess.run(
        [str(java), "-Dfile.encoding=UTF-8", "-cp", str(OUT), "SafetyHostTest"],
        cwd=ROOT,
    ).returncode


if __name__ == "__main__":
    sys.exit(main())
