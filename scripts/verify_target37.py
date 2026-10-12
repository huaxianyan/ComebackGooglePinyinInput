#!/usr/bin/env python3
"""Verify the Android 17 / API 37 baseline.

Target 37 turns on DCL-C (native code reached through System.load() must be
read-only) and replaces the implicit ACCESS_LOCAL_NETWORK grant that INTERNET
used to confer. Both hold here by construction: jniLibs use legacy packaging,
so the package manager extracts the .so files into a read-only lib/ directory
and System.loadLibrary hits them before the writable fallback, and the tree
never opens a socket.

The remaining target-37 behaviour changes were judged "not applicable" in
docs/android-17-api-37-investigation.md. This gate pins those judgements so a
later change cannot quietly invalidate them.
"""

from __future__ import annotations

import argparse
from pathlib import Path


PERMISSION_PREFIX = 'uses-permission android:name="'

FORBIDDEN_PERMISSIONS = (
    "android.permission.ACCESS_LOCAL_NETWORK",
    "android.permission.READ_SMS",
    "android.permission.RECEIVE_SMS",
    "android.permission.SEND_SMS",
    "android.permission.BLUETOOTH",
    "android.permission.BLUETOOTH_CONNECT",
    "android.permission.BLUETOOTH_SCAN",
)

# 1.1 "not applicable" entries that reduce to "this tree never references it".
FORBIDDEN_SMALI = {
    "Ljava/net/Socket;": "no sockets (ACCESS_LOCAL_NETWORK, ECH, certificate transparency)",
    "Ljava/net/ServerSocket;": "no listening sockets",
    "Ljava/net/InetAddress;": "no address resolution",
    "Lsun/misc/Unsafe;": "no Unsafe-based field writes (static final hardening)",
}

HOST_BUILD_SCRIPT = Path("modern-settings/reconstructed-host-prototype/build.gradle.kts")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    apktool = (decoded / "apktool.yml").read_text(encoding="utf-8")
    if "targetSdkVersion: 37" not in apktool:
        raise RuntimeError("Android 17 verifier requires targetSdkVersion 37")

    manifest = (decoded / "AndroidManifest.xml").read_text(encoding="utf-8")

    declared = {
        chunk.split('"', 1)[0] for chunk in manifest.split(PERMISSION_PREFIX)[1:]
    }
    offending = sorted(declared.intersection(FORBIDDEN_PERMISSIONS))
    if offending:
        raise RuntimeError(
            f"target 37 must not declare these permissions: {offending}"
        )

    if "screenOrientation" in manifest:
        raise RuntimeError(
            "target 37 ignores orientation limits on large screens; the manifest "
            "must stay free of screenOrientation"
        )

    # Android 17 renders each input method's subtype icon as a small
    # monochrome mark in the switcher, so a colour app icon collapses into a
    # block. Every method.xml variant must point at the single-glyph drawable;
    # the resource is resolved per API level, so xml-v19 is the one a phone
    # actually loads and the television copies cover Android TV.
    method_files = sorted(decoded.glob("res/xml*/method.xml"))
    if not method_files:
        raise RuntimeError("missing input method definition under res/xml*")
    for method_xml in method_files:
        relative = method_xml.relative_to(decoded)
        method = method_xml.read_text(encoding="utf-8")
        if "@mipmap/app_icon" in method:
            raise RuntimeError(
                f"{relative} points the pinyin subtype at the colour app icon; "
                "the Android 17 switcher downscales and tints it into an "
                "unreadable block"
            )
        if "@drawable/ic_ime_subtype_pinyin" not in method:
            raise RuntimeError(
                f"{relative} must keep the single-glyph pinyin subtype icon"
            )

    smali_root = decoded / "smali"
    if not smali_root.is_dir():
        raise RuntimeError(f"missing smali tree: {smali_root}")

    hits: dict[str, list[str]] = {token: [] for token in FORBIDDEN_SMALI}
    for path in smali_root.rglob("*.smali"):
        text = path.read_text(encoding="utf-8", errors="ignore")
        for token in FORBIDDEN_SMALI:
            if token in text:
                hits[token].append(str(path.relative_to(decoded)))

    regressed = {token: found for token, found in hits.items() if found}
    if regressed:
        detail = "; ".join(
            f"{FORBIDDEN_SMALI[token]} -> {found[:3]}"
            for token, found in regressed.items()
        )
        raise RuntimeError(f"target 37 static audit regressed: {detail}")

    if not HOST_BUILD_SCRIPT.is_file():
        raise RuntimeError(f"missing Compose host build script: {HOST_BUILD_SCRIPT}")
    if "useLegacyPackaging = true" not in HOST_BUILD_SCRIPT.read_text(encoding="utf-8"):
        raise RuntimeError(
            "DCL-C depends on legacy jniLibs packaging: it makes the package "
            "manager extract read-only .so files so System.loadLibrary succeeds "
            "before the writable fallback path is reached"
        )

    print(
        "Android 17 baseline verified: targetSdkVersion 37, DCL-C read-only native "
        "loading anchored on legacy packaging, and the not-applicable target-37 "
        "changes (local network, Unsafe, orientation, SMS, Bluetooth) still absent"
    )


if __name__ == "__main__":
    main()
