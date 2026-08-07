#!/usr/bin/env python3
"""Convert apktool public.xml into an AAPT2 --stable-ids mapping.

The reconstructed APK contains native and dex code with embedded 0x7f resource IDs.
Any source-built AndroidX/Material host must therefore link every legacy resource at
its existing ID rather than relying on AAPT2's default ordering.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import xml.etree.ElementTree as ET


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("public_xml", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--package", required=True, dest="package_name")
    args = parser.parse_args()

    root = ET.parse(args.public_xml).getroot()
    entries: list[tuple[int, str, str]] = []
    seen_ids: set[int] = set()
    seen_names: set[tuple[str, str]] = set()
    for node in root.findall("public"):
        resource_type = node.attrib["type"]
        name = node.attrib["name"]
        resource_id = int(node.attrib["id"], 16)
        if resource_id >> 24 != 0x7F:
            raise ValueError(f"unexpected package ID: {resource_id:#010x}")
        if resource_id in seen_ids:
            raise ValueError(f"duplicate resource ID: {resource_id:#010x}")
        key = (resource_type, name)
        if key in seen_names:
            raise ValueError(f"duplicate resource name: {resource_type}/{name}")
        seen_ids.add(resource_id)
        seen_names.add(key)
        entries.append((resource_id, resource_type, name))

    entries.sort()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    body = "".join(
        f"{args.package_name}:{resource_type}/{name} = {resource_id:#010x}\n"
        for resource_id, resource_type, name in entries
    )
    args.output.write_text(body, encoding="utf-8", newline="\n")
    print(f"wrote {len(entries)} stable IDs to {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
