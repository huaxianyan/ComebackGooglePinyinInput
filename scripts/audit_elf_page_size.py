#!/usr/bin/env python3
"""Audit Android APK native libraries for 16 KiB page-size readiness.

This dependency-free check reports APK storage/alignment and every ELF PT_LOAD
segment. It does not claim that changing p_align alone can repair an ELF file.
"""

from __future__ import annotations

import argparse
import struct
import sys
import zipfile
from dataclasses import dataclass
from pathlib import Path

PT_LOAD = 1
ELFCLASS64 = 2
ELFDATA2LSB = 1
EM_AARCH64 = 183
PAGE_16K = 16 * 1024


@dataclass(frozen=True)
class LoadSegment:
    index: int
    flags: int
    offset: int
    vaddr: int
    filesz: int
    memsz: int
    align: int


def parse_load_segments(data: bytes, name: str) -> tuple[int, list[LoadSegment]]:
    if len(data) < 64 or data[:4] != b"\x7fELF":
        raise ValueError(f"{name}: not an ELF file")
    if data[4] != ELFCLASS64 or data[5] != ELFDATA2LSB:
        raise ValueError(f"{name}: expected little-endian ELF64")

    machine = struct.unpack_from("<H", data, 18)[0]
    phoff = struct.unpack_from("<Q", data, 32)[0]
    phentsize = struct.unpack_from("<H", data, 54)[0]
    phnum = struct.unpack_from("<H", data, 56)[0]
    if phentsize < 56:
        raise ValueError(f"{name}: invalid program-header entry size {phentsize}")
    if phoff + phentsize * phnum > len(data):
        raise ValueError(f"{name}: program-header table exceeds file")

    loads: list[LoadSegment] = []
    for index in range(phnum):
        pos = phoff + index * phentsize
        p_type, p_flags, p_offset, p_vaddr, _p_paddr, p_filesz, p_memsz, p_align = (
            struct.unpack_from("<IIQQQQQQ", data, pos)
        )
        if p_type == PT_LOAD:
            loads.append(
                LoadSegment(index, p_flags, p_offset, p_vaddr, p_filesz, p_memsz, p_align)
            )
    if not loads:
        raise ValueError(f"{name}: no PT_LOAD segments")
    return machine, loads


def zip_data_offset(apk_bytes: bytes, info: zipfile.ZipInfo) -> int:
    # Local header: signature + fixed 26 bytes followed by name and extra.
    pos = info.header_offset
    if apk_bytes[pos : pos + 4] != b"PK\x03\x04":
        raise ValueError(f"{info.filename}: invalid local ZIP header")
    name_len, extra_len = struct.unpack_from("<HH", apk_bytes, pos + 26)
    return pos + 30 + name_len + extra_len


def flags_text(flags: int) -> str:
    return "".join(("R" if flags & 4 else "-", "W" if flags & 2 else "-", "X" if flags & 1 else "-"))


def audit(apk: Path) -> int:
    apk_bytes = apk.read_bytes()
    failures = 0
    with zipfile.ZipFile(apk) as zf:
        libraries = [i for i in zf.infolist() if i.filename.startswith("lib/") and i.filename.endswith(".so")]
        if not libraries:
            print("No native libraries found", file=sys.stderr)
            return 2

        print(f"APK: {apk}")
        print(f"16 KiB threshold: 0x{PAGE_16K:x}")
        for info in libraries:
            data = zf.read(info)
            machine, loads = parse_load_segments(data, info.filename)
            data_offset = zip_data_offset(apk_bytes, info)
            stored = info.compress_type == zipfile.ZIP_STORED
            elf_ready = all(seg.align >= PAGE_16K for seg in loads)
            header_congruent = all(
                seg.align > 0 and seg.offset % seg.align == seg.vaddr % seg.align
                for seg in loads
            )
            page_16k_congruent = all(
                seg.offset % PAGE_16K == seg.vaddr % PAGE_16K for seg in loads
            )
            zip_ready = (not stored) or data_offset % PAGE_16K == 0
            ready = (
                machine == EM_AARCH64
                and elf_ready
                and header_congruent
                and page_16k_congruent
                and zip_ready
            )
            if not ready:
                failures += 1

            print()
            print(info.filename)
            print(f"  machine={machine} ({'AArch64' if machine == EM_AARCH64 else 'unexpected'})")
            print(
                f"  zip={'stored' if stored else 'compressed'} data_offset=0x{data_offset:x} "
                f"offset_mod_16k=0x{data_offset % PAGE_16K:x} zip_ready={zip_ready}"
            )
            for seg in loads:
                header_match = (
                    seg.align > 0 and seg.offset % seg.align == seg.vaddr % seg.align
                )
                page_16k_match = (
                    seg.offset % PAGE_16K == seg.vaddr % PAGE_16K
                )
                print(
                    f"  LOAD[{seg.index}] {flags_text(seg.flags)} "
                    f"off=0x{seg.offset:x} vaddr=0x{seg.vaddr:x} "
                    f"filesz=0x{seg.filesz:x} memsz=0x{seg.memsz:x} "
                    f"align=0x{seg.align:x} header_congruent={header_match} "
                    f"congruent_16k={page_16k_match}"
                )
            print(
                f"  ELF_16K_READY="
                f"{elf_ready and header_congruent and page_16k_congruent}"
            )
            print(f"  OVERALL_STATIC_READY={ready}")

    print()
    print(f"SUMMARY libraries={len(libraries)} failures={failures}")
    return 1 if failures else 0


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("apk", type=Path)
    args = parser.parse_args()
    raise SystemExit(audit(args.apk))


if __name__ == "__main__":
    main()
