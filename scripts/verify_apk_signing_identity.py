#!/usr/bin/env python3
"""Verify the effective APK signing identity across Android signature generations."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import subprocess

from build_modern_settings_host import BUILD_TOOLS_VERSION, ROOT


def effective_signers(output: str, minimum: int, maximum: int) -> set[str]:
    result = set()
    for line in output.splitlines():
        plain = re.fullmatch(r"Signer #\d+ certificate SHA-256 digest: ([0-9a-fA-F]{64})", line)
        ranged = re.fullmatch(
            r"Signer \(minSdkVersion=(\d+), maxSdkVersion=(\d+)\) certificate SHA-256 digest: ([0-9a-fA-F]{64})",
            line,
        )
        if plain:
            result.add(plain[1].lower())
        elif ranged and int(ranged[1]) <= maximum and int(ranged[2]) >= minimum:
            result.add(ranged[3].lower())
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("apk", type=Path)
    parser.add_argument("--sdk", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--target-sdk", type=int, required=True)
    parser.add_argument("--expected-legacy-sha256", required=True)
    parser.add_argument("--expected-rotated-sha256")
    args = parser.parse_args()
    legacy = args.expected_legacy_sha256.replace(":", "").lower()
    minimum_sdk = 23
    ranges = [(minimum_sdk, args.target_sdk, legacy)]
    if args.expected_rotated_sha256:
        config = json.loads((ROOT / "signing/signing-materials.json").read_text(encoding="utf-8"))
        rotation = config["rotationMinSdk"]
        rotated = args.expected_rotated_sha256.replace(":", "").lower()
        # API 28 introduces v3. Check the legacy and v3 selectors separately from v3.1.
        ranges = [(minimum_sdk, 27, legacy), (28, rotation - 1, legacy),
                  (rotation, args.target_sdk, rotated)]
    java = args.jdk / "bin" / ("java.exe" if os.name == "nt" else "java")
    jar = args.sdk / "build-tools" / BUILD_TOOLS_VERSION / "lib/apksigner.jar"
    for minimum, maximum, expected in ranges:
        if minimum > maximum:
            continue
        command = [str(java), "-jar", str(jar), "verify", "--print-certs",
                   "--min-sdk-version", str(minimum), "--max-sdk-version", str(maximum), str(args.apk)]
        result = subprocess.run(command, capture_output=True, text=True, encoding="utf-8", timeout=60)
        if result.returncode:
            raise RuntimeError(f"APK verification failed for SDK {minimum}..{maximum}: {result.stderr}")
        actual = effective_signers(result.stdout, minimum, maximum)
        if actual != {expected}:
            raise RuntimeError(f"SDK {minimum}..{maximum}: expected {expected}, got {sorted(actual)}")
        print(f"PASS SDK {minimum}..{maximum}: {expected}")


if __name__ == "__main__":
    main()
