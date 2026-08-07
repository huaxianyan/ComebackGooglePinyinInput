#!/usr/bin/env python3
"""Verify that every legacy public resource keeps its embedded numeric ID."""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import xml.etree.ElementTree as ET

RESOURCE = re.compile(r"^\s*resource (0x[0-9a-fA-F]{8}) ([^/\s]+)/(.+?)\s*$")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("public_xml", type=Path)
    parser.add_argument("aapt2_dump", type=Path)
    args = parser.parse_args()

    expected = {
        (node.attrib["type"], node.attrib["name"]): int(node.attrib["id"], 16)
        for node in ET.parse(args.public_xml).getroot().findall("public")
    }
    actual: dict[tuple[str, str], int] = {}
    for line in args.aapt2_dump.read_text(encoding="utf-8").splitlines():
        match = RESOURCE.match(line)
        if match:
            actual[(match.group(2), match.group(3))] = int(match.group(1), 16)

    missing = sorted(set(expected) - set(actual))
    changed = sorted(
        (key, expected[key], actual[key])
        for key in expected.keys() & actual.keys()
        if expected[key] != actual[key]
    )
    if missing or changed:
        details = []
        if missing:
            details.append(f"missing={missing[:10]!r} ({len(missing)} total)")
        if changed:
            details.append(f"changed={changed[:10]!r} ({len(changed)} total)")
        raise RuntimeError("legacy resource ID verification failed: " + "; ".join(details))

    print(f"verified {len(expected)} legacy resource IDs")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
