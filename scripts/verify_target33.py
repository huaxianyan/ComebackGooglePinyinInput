#!/usr/bin/env python3
"""Verify that the Android 13 audit does not add unused runtime permissions."""

from __future__ import annotations

import argparse
import xml.etree.ElementTree as ET
from pathlib import Path

ANDROID_NS = "http://schemas.android.com/apk/res/android"
FORBIDDEN_PERMISSIONS = {
    "android.permission.POST_NOTIFICATIONS",
    "android.permission.READ_MEDIA_IMAGES",
    "android.permission.READ_MEDIA_VIDEO",
    "android.permission.READ_MEDIA_AUDIO",
    "android.permission.READ_MEDIA_VISUAL_USER_SELECTED",
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    root = ET.parse(decoded / "AndroidManifest.xml").getroot()
    declared = {
        element.get(f"{{{ANDROID_NS}}}name")
        for element in root.findall("uses-permission")
    }
    forbidden_declared = sorted(FORBIDDEN_PERMISSIONS & declared)
    if forbidden_declared:
        raise RuntimeError(
            "Unused Android 13 permissions declared: "
            + ", ".join(forbidden_declared)
        )

    # Also reject hidden runtime requests introduced in smali or resources.
    references: list[str] = []
    for base, pattern in ((decoded / "smali", "*.smali"), (decoded / "res", "*.xml")):
        for path in base.rglob(pattern):
            text = path.read_text(encoding="utf-8", errors="ignore")
            for permission in FORBIDDEN_PERMISSIONS:
                if permission in text:
                    references.append(f"{path}: {permission}")
    if references:
        raise RuntimeError(
            "Unused Android 13 permission request/reference found:\n"
            + "\n".join(references)
        )

    print(
        "Android 13 permission invariants verified: no POST_NOTIFICATIONS or "
        "READ_MEDIA_* declarations/requests"
    )


if __name__ == "__main__":
    main()
