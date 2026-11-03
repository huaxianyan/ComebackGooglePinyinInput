#!/usr/bin/env python3
"""Assemble an APK from a decoded tree without apktool's build step.

The decoded tree keeps the shape apktool produces, so the existing patch scripts
still work. What changes is the rebuild: smali is assembled with the standalone
smali jars, resources go through aapt2, and the package is assembled here instead
of by `apktool b`.

Every entry that is not rebuilt is copied from the original APK together with its
original compression type, so the packaging rules only have to be declared for
what this script produces.
"""

from __future__ import annotations

import argparse
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

SIGNATURE_SUFFIXES = (".SF", ".RSA", ".DSA", ".EC")
COMPRESSION_STORE = zipfile.ZIP_STORED
COMPRESSION_DEFLATE = zipfile.ZIP_DEFLATED


def read_apktool_yml(path: Path) -> dict[str, object]:
    """Read the few fields the rebuild needs. The file is flat enough for this."""
    text = path.read_text(encoding="utf-8")
    fields: dict[str, object] = {}
    for key in ("minSdkVersion", "targetSdkVersion", "versionCode", "versionName"):
        match = re.search(rf"^\s*{key}:\s*(\S+)\s*$", text, re.MULTILINE)
        if match:
            fields[key] = match.group(1).strip('"')
    block = re.search(r"^doNotCompress:\s*$\n((?:^-\s*\S+\s*$\n?)+)", text, re.MULTILINE)
    patterns: list[str] = []
    if block:
        patterns = [line[1:].strip() for line in block.group(1).splitlines()]
    fields["doNotCompress"] = patterns
    return fields


def smali_directories(decoded: Path) -> list[Path]:
    """The directories apktool would assemble, in its own order."""
    directories = [decoded / "smali"]
    index = 2
    while (decoded / f"smali_classes{index}").is_dir():
        directories.append(decoded / f"smali_classes{index}")
        index += 1
    return [directory for directory in directories if directory.is_dir()]


def assemble_dex(args: argparse.Namespace, decoded: Path, work: Path) -> list[Path]:
    outputs: list[Path] = []
    for position, directory in enumerate(smali_directories(decoded)):
        name = "classes.dex" if position == 0 else f"classes{position + 1}.dex"
        target = work / name
        subprocess.run(
            [args.java, "-cp", args.smali_classpath, "org.jf.smali.Main", "assemble",
             "-o", str(target), str(directory)],
            check=True,
        )
        outputs.append(target)
    if not outputs:
        raise SystemExit(f"no smali directory under {decoded}")
    return outputs


def compile_resources(args: argparse.Namespace, decoded: Path, work: Path) -> Path:
    flat = work / "resources.zip"
    subprocess.run(
        [args.aapt2, "compile", "--dir", str(decoded / "res"), "-o", str(flat)],
        check=True,
    )
    return flat


def link_resources(args: argparse.Namespace, decoded: Path, work: Path, flat: Path,
                   fields: dict[str, object]) -> Path:
    linked = work / "linked.apk"
    command = [
        args.aapt2, "link", "-o", str(linked),
        "-I", str(args.android_jar),
        "--manifest", str(decoded / "AndroidManifest.xml"),
        "--min-sdk-version", str(fields.get("minSdkVersion", "17")),
        "--target-sdk-version", str(fields.get("targetSdkVersion", "26")),
        str(flat),
    ]
    # aapt2 takes these as link arguments; apktool keeps them in its own metadata file.
    if "versionCode" in fields:
        command += ["--version-code", str(fields["versionCode"])]
    if "versionName" in fields:
        command += ["--version-name", str(fields["versionName"])]
    subprocess.run(command, check=True)
    return linked


def is_stored(name: str, patterns: list[str]) -> bool:
    """The decoded tree's doNotCompress holds extensions and whole paths."""
    for pattern in patterns:
        if name == pattern or name.endswith("/" + pattern) or name.endswith("." + pattern):
            return True
    return False


def package_apk(args: argparse.Namespace, linked: Path, dexes: list[Path],
                fields: dict[str, object]) -> Path:
    patterns = [str(pattern) for pattern in fields.get("doNotCompress", [])]
    rebuilt: dict[str, bytes] = {}
    with zipfile.ZipFile(linked) as archive:
        for name in archive.namelist():
            if name == "AndroidManifest.xml" or name == "resources.arsc" or name.startswith("res/"):
                rebuilt[name] = archive.read(name)
    for position, dex in enumerate(dexes):
        name = "classes.dex" if position == 0 else f"classes{position + 1}.dex"
        rebuilt[name] = dex.read_bytes()

    with zipfile.ZipFile(args.original) as original, \
            zipfile.ZipFile(args.output, "w") as output:
        written: set[str] = set()
        for item in original.infolist():
            name = item.filename
            if name.startswith("META-INF/") and name.endswith(SIGNATURE_SUFFIXES):
                continue
            if name.startswith("META-INF/") and name == "META-INF/MANIFEST.MF":
                continue
            if name in rebuilt:
                continue
            if name.startswith("res/") or re.fullmatch(r"classes\d*\.dex", name):
                continue
            info = zipfile.ZipInfo(name, date_time=item.date_time)
            info.compress_type = item.compress_type
            output.writestr(info, original.read(name))
            written.add(name)
        for name, data in sorted(rebuilt.items()):
            if name in written:
                continue
            is_dex = bool(re.fullmatch(r"classes\d*\.dex", name))
            stored = (not is_dex) and (name.endswith(".arsc") or is_stored(name, patterns))
            info = zipfile.ZipInfo(name, date_time=(2009, 1, 1, 0, 0, 0))
            info.compress_type = COMPRESSION_STORE if stored else COMPRESSION_DEFLATE
            output.writestr(info, data)
    return args.output


def dex_counts(path: Path) -> tuple[int, int]:
    data = path.read_bytes()
    return struct.unpack_from("<I", data, 0x60)[0], struct.unpack_from("<I", data, 0x58)[0]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--decoded", type=Path, required=True)
    parser.add_argument("--original", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--aapt2", required=True)
    parser.add_argument("--smali-classpath", required=True)
    parser.add_argument("--java", default="java")
    args = parser.parse_args()

    fields = read_apktool_yml(args.decoded / "apktool.yml")
    with tempfile.TemporaryDirectory(prefix="no-apktool-") as temporary:
        work = Path(temporary)
        dexes = assemble_dex(args, args.decoded, work)
        for dex in dexes:
            classes, methods = dex_counts(dex)
            print(f"{dex.name}: {classes} classes, {methods} methods")
        flat = compile_resources(args, args.decoded, work)
        linked = link_resources(args, args.decoded, work, flat, fields)
        package_apk(args, linked, dexes, fields)
    print(f"wrote {args.output} ({args.output.stat().st_size} bytes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
