#!/usr/bin/env python3
"""Combine the AGP Compose host with the patched legacy DEX and APK payload.

The legacy DEX stays classes.dex so API 17-20 can start without AndroidX
MultiDex. Compose/AndroidX DEX files begin at classes2.dex and are only routed to
on API 35+. Resources and the manifest come from the stable-ID AGP host.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import re
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

DEX = re.compile(r"^classes(?:(\d+))?\.dex$")


def clone_info(source: ZipInfo, name: str) -> ZipInfo:
    target = ZipInfo(name, source.date_time)
    target.compress_type = source.compress_type
    target.comment = source.comment
    target.extra = source.extra
    target.create_system = source.create_system
    target.create_version = source.create_version
    target.extract_version = source.extract_version
    target.flag_bits = source.flag_bits
    target.external_attr = source.external_attr
    target.internal_attr = source.internal_attr
    return target


def modern_dex_name(name: str) -> str:
    match = DEX.fullmatch(name)
    if not match:
        raise ValueError(name)
    number = int(match.group(1) or "1") + 1
    return f"classes{number}.dex"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", type=Path, required=True)
    parser.add_argument("--legacy-dex", type=Path, required=True)
    parser.add_argument("--original", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    args.output.parent.mkdir(parents=True, exist_ok=True)
    written: set[str] = set()
    with ZipFile(args.output, "w") as output:
        with ZipFile(args.host) as host:
            dex_entries = sorted(
                (entry for entry in host.infolist() if DEX.fullmatch(entry.filename)),
                key=lambda entry: int(DEX.fullmatch(entry.filename).group(1) or "1"),
            )
            if not dex_entries:
                raise RuntimeError("AGP host contains no DEX")
            for entry in host.infolist():
                name = entry.filename
                if name.startswith("META-INF/") or DEX.fullmatch(name):
                    continue
                output.writestr(clone_info(entry, name), host.read(entry))
                written.add(name)

            legacy_info = ZipInfo("classes.dex", (1980, 1, 1, 0, 0, 0))
            legacy_info.compress_type = ZIP_DEFLATED
            output.writestr(legacy_info, args.legacy_dex.read_bytes())
            written.add("classes.dex")

            for entry in dex_entries:
                name = modern_dex_name(entry.filename)
                output.writestr(clone_info(entry, name), host.read(entry))
                written.add(name)

        with ZipFile(args.original) as original:
            for entry in original.infolist():
                name = entry.filename
                if (
                    name in written
                    or name == "AndroidManifest.xml"
                    or name == "resources.arsc"
                    or name == "classes.dex"
                    or name.startswith("META-INF/")
                    or name.startswith("res/")
                ):
                    continue
                output.writestr(clone_info(entry, name), original.read(entry))
                written.add(name)

    print(
        f"assembled {args.output} with legacy classes.dex and "
        f"{len(dex_entries)} modern DEX files"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
