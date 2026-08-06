#!/usr/bin/env python3
"""Re-layout Google Pinyin's legacy native libraries for 16 KiB pages.

This is a deliberately narrow, dependency-free binary transformation for four
exact libraries shipped in Google Pinyin 4.5.2.193126728. It does not pretend
that changing ELF p_align alone is sufficient.

The HMM library has a writable PT_LOAD whose file offset and virtual address
are not congruent modulo 16 KiB. Four libraries also place writable .data/.bss
in the 16 KiB page to which PT_GNU_RELRO rounds up. The transformation therefore:

1. fixes the HMM library's writable PT_LOAD file offset and alignment;
2. moves post-RELRO .data/.bss to the next 16 KiB virtual page;
3. updates section/symbol/relocation addresses and AArch64 ADRP references;
4. preserves every original PT_GNU_RELRO range instead of weakening it.

Exact input/output hashes and structural counts make the operation fail closed
if the source binary or expected layout changes.
"""
from __future__ import annotations

import argparse
import hashlib
import struct
import tempfile
from dataclasses import dataclass
from pathlib import Path

PT_LOAD = 1
PT_GNU_RELRO = 0x6474E552
SHT_SYMTAB = 2
SHT_RELA = 4
SHT_DYNSYM = 11
SHF_EXECINSTR = 4
R_AARCH64_RELATIVE = 1027
PAGE_16K = 0x4000

SECOND_LOAD_OFFSET = 0x6767F0
SECOND_LOAD_VADDR = 0x6777F0
FILE_PADDING = 0x1000


@dataclass(frozen=True)
class LibrarySpec:
    input_sha256: str
    output_sha256: str
    input_size: int
    output_size: int
    move_vaddr: int
    move_padding: int
    patch_counts: tuple[int, int, int, int]
    pad_load_offset: bool = False


LIBRARY_SPECS = {
    "liben_data_bundle.so": LibrarySpec(
        "c96feea4652afcf1ae5f89d2bc2aa3542c02e78d690f0ed8f4bd75ac727a7d72",
        "cd1eab5650dca5886c829a1c1f7e007ae336484d3606d4091b369b81c0cfcfa2",
        0x24F0, 0x44F0, 0x12000, 0x2000, (2, 1, 0, 0),
    ),
    "libgnustl_shared.so": LibrarySpec(
        "dd5b244c523dc6f25a9ec985bc4d2d79a7af3fc7a0ac2cbf9f63ebd18abb0607",
        "13cf67db74ee9cb1ef11206e372e7be939bbe803c2704bc95c9d0f739b7b9f03",
        0x10B930, 0x10C930, 0x11B000, 0x1000, (167, 112, 92, 137),
    ),
    "libhmm_gesture_hwr_zh.so": LibrarySpec(
        "273c69c25124fbdbdc80a44acfd74b057494dcb91e563e5df511986566deadcf",
        "6a1c28be99ce3c43ef9bcc295089af020f3fc8303e5ef0b6f943a3e07c0c2fea",
        0x69B178, 0x69E178, 0x69A000, 0x2000, (2312, 10, 738, 123), True,
    ),
    "libhwrword.so": LibrarySpec(
        "2e83a783516bed796e4700cb9587433330b287c53005de830f11783d6922544f",
        "557ae6f6dca2d5d9cf33bb70629be3272954ee78d86749304b5f175999202158",
        0x243860, 0x244860, 0x253000, 0x1000, (1764, 4, 12, 50),
    ),
}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def elf_layout(data: bytes) -> tuple[int, int, int, int, int, int]:
    if len(data) < 64 or data[:6] != b"\x7fELF\x02\x01":
        raise RuntimeError("Expected a little-endian ELF64 library")
    phoff = struct.unpack_from("<Q", data, 32)[0]
    shoff = struct.unpack_from("<Q", data, 40)[0]
    phentsize, phnum = struct.unpack_from("<HH", data, 54)
    shentsize, shnum = struct.unpack_from("<HH", data, 58)
    if phentsize < 56 or shentsize < 64:
        raise RuntimeError("Unexpected ELF header entry size")
    if phoff + phentsize * phnum > len(data) or shoff + shentsize * shnum > len(data):
        raise RuntimeError("ELF header table exceeds the file")
    return phoff, shoff, phentsize, phnum, shentsize, shnum


def read_program_headers(data: bytes) -> list[list[int]]:
    phoff, _shoff, phentsize, phnum, _shentsize, _shnum = elf_layout(data)
    return [
        list(struct.unpack_from("<IIQQQQQQ", data, phoff + i * phentsize))
        for i in range(phnum)
    ]


def read_section_headers(data: bytes) -> list[list[int]]:
    _phoff, shoff, _phentsize, _phnum, shentsize, shnum = elf_layout(data)
    return [
        list(struct.unpack_from("<IIQQQQIIQQ", data, shoff + i * shentsize))
        for i in range(shnum)
    ]


def pad_writable_load(original: bytes) -> bytes:
    phoff, shoff, phentsize, phnum, shentsize, shnum = elf_layout(original)
    phdrs = read_program_headers(original)
    loads = [(i, p) for i, p in enumerate(phdrs) if p[0] == PT_LOAD]
    if len(loads) != 2:
        raise RuntimeError(f"Expected exactly two PT_LOAD segments, found {len(loads)}")
    _first_index, first = loads[0]
    _second_index, second = loads[1]
    if (first[2], first[3], first[7]) != (0, 0, 0x1000):
        raise RuntimeError("Unexpected first PT_LOAD layout")
    if (second[2], second[3], second[7]) != (
        SECOND_LOAD_OFFSET,
        SECOND_LOAD_VADDR,
        0x1000,
    ):
        raise RuntimeError("Unexpected writable PT_LOAD layout")
    if (SECOND_LOAD_OFFSET + FILE_PADDING) % PAGE_16K != SECOND_LOAD_VADDR % PAGE_16K:
        raise RuntimeError("Configured padding does not make the writable PT_LOAD congruent")

    sections = read_section_headers(original)
    output = bytearray(
        original[:SECOND_LOAD_OFFSET]
        + b"\0" * FILE_PADDING
        + original[SECOND_LOAD_OFFSET:]
    )
    new_shoff = shoff + FILE_PADDING if shoff >= SECOND_LOAD_OFFSET else shoff
    struct.pack_into("<Q", output, 40, new_shoff)

    for i, p in enumerate(phdrs):
        if p[2] >= SECOND_LOAD_OFFSET and (p[5] or p[2]):
            p[2] += FILE_PADDING
        if p[0] == PT_LOAD:
            p[7] = max(p[7], PAGE_16K)
        struct.pack_into("<IIQQQQQQ", output, phoff + i * phentsize, *p)

    for i, s in enumerate(sections):
        if s[4] >= SECOND_LOAD_OFFSET and s[4]:
            s[4] += FILE_PADDING
        struct.pack_into("<IIQQQQIIQQ", output, new_shoff + i * shentsize, *s)
    return bytes(output)


def sign_extend(value: int, bits: int) -> int:
    sign = 1 << (bits - 1)
    return (value ^ sign) - sign


def decode_adrp_target(instruction: int, pc: int) -> int | None:
    if instruction & 0x9F000000 != 0x90000000:
        return None
    immlo = (instruction >> 29) & 3
    immhi = (instruction >> 5) & 0x7FFFF
    immediate = sign_extend((immhi << 2) | immlo, 21) << 12
    return (pc & ~0xFFF) + immediate


def encode_adrp_target(instruction: int, pc: int, target: int) -> int:
    page_delta = (target - (pc & ~0xFFF)) >> 12
    if not -(1 << 20) <= page_delta < (1 << 20):
        raise RuntimeError(f"ADRP target out of range: pc={pc:#x}, target={target:#x}")
    encoded = page_delta & ((1 << 21) - 1)
    return (
        instruction & ~((3 << 29) | (0x7FFFF << 5))
    ) | ((encoded & 3) << 29) | ((encoded >> 2) << 5)


def move_post_relro_data(original: bytes, spec: LibrarySpec) -> bytes:
    move_vaddr = spec.move_vaddr
    move_padding = spec.move_padding
    phoff, shoff, phentsize, phnum, shentsize, shnum = elf_layout(original)
    phdrs = read_program_headers(original)
    sections = read_section_headers(original)
    containing = [
        p
        for p in phdrs
        if p[0] == PT_LOAD and p[3] <= move_vaddr <= p[3] + p[6]
    ]
    if len(containing) != 1:
        raise RuntimeError("Move boundary is not inside exactly one PT_LOAD segment")
    writable_load = containing[0]
    insert_offset = writable_load[2] + (move_vaddr - writable_load[3])
    if (move_vaddr + move_padding) % PAGE_16K:
        raise RuntimeError("Moved writable data would not start on a 16 KiB page")
    old_mem_end = writable_load[3] + writable_load[6]

    relro = [p for p in phdrs if p[0] == PT_GNU_RELRO]
    if len(relro) != 1 or relro[0][3] + relro[0][6] != move_vaddr:
        raise RuntimeError("Expected the move boundary to equal the original RELRO end")

    output = bytearray(
        original[:insert_offset] + b"\0" * move_padding + original[insert_offset:]
    )
    new_shoff = shoff + move_padding if shoff >= insert_offset else shoff
    struct.pack_into("<Q", output, 40, new_shoff)

    for i, p in enumerate(phdrs):
        start = p[2]
        end = p[2] + p[5]
        if p[2] >= insert_offset and (p[5] or p[2]):
            p[2] += move_padding
        elif start < insert_offset < end or (p[0] == PT_LOAD and p is writable_load):
            p[5] += move_padding
            p[6] += move_padding
        struct.pack_into("<IIQQQQQQ", output, phoff + i * phentsize, *p)

    adjusted_sections: list[list[int]] = []
    for i, section in enumerate(sections):
        adjusted = section.copy()
        if adjusted[3] >= move_vaddr and adjusted[3] != 0:
            adjusted[3] += move_padding
        if adjusted[4] >= insert_offset and adjusted[4]:
            adjusted[4] += move_padding
        adjusted_sections.append(adjusted)
        struct.pack_into(
            "<IIQQQQIIQQ", output, new_shoff + i * shentsize, *adjusted
        )

    adrp_count = 0
    for old, new in zip(sections, adjusted_sections):
        if not (old[2] & SHF_EXECINSTR) or old[5] < 4:
            continue
        for relative in range(0, old[5] - 3, 4):
            instruction = struct.unpack_from("<I", original, old[4] + relative)[0]
            pc = old[3] + relative
            target = decode_adrp_target(instruction, pc)
            if target is not None and move_vaddr <= target < old_mem_end:
                patched = encode_adrp_target(
                    instruction, pc, target + move_padding
                )
                struct.pack_into("<I", output, new[4] + relative, patched)
                adrp_count += 1

    symbol_count = 0
    relocation_offset_count = 0
    relocation_addend_count = 0
    for old, new in zip(sections, adjusted_sections):
        old_offset, new_offset = old[4], new[4]
        size, entry_size, section_type = old[5], old[9], old[1]
        if section_type in (SHT_SYMTAB, SHT_DYNSYM) and entry_size >= 24:
            for relative in range(0, size, entry_size):
                value = struct.unpack_from("<Q", original, old_offset + relative + 8)[0]
                if move_vaddr <= value < old_mem_end:
                    struct.pack_into(
                        "<Q", output, new_offset + relative + 8, value + move_padding
                    )
                    symbol_count += 1
        elif section_type == SHT_RELA and entry_size >= 24:
            for relative in range(0, size, entry_size):
                r_offset, r_info, addend = struct.unpack_from(
                    "<QQq", original, old_offset + relative
                )
                if move_vaddr <= r_offset < old_mem_end:
                    struct.pack_into(
                        "<Q", output, new_offset + relative, r_offset + move_padding
                    )
                    relocation_offset_count += 1
                if (
                    (r_info & 0xFFFFFFFF) == R_AARCH64_RELATIVE
                    and move_vaddr <= addend < old_mem_end
                ):
                    struct.pack_into(
                        "<q", output, new_offset + relative + 16, addend + move_padding
                    )
                    relocation_addend_count += 1

    actual_counts = (
        adrp_count,
        symbol_count,
        relocation_offset_count,
        relocation_addend_count,
    )
    expected_counts = spec.patch_counts
    if actual_counts != expected_counts:
        raise RuntimeError(
            f"Unexpected ELF reference patch counts: {actual_counts}, expected {expected_counts}"
        )
    return bytes(output)


def transform(library_name: str, data: bytes) -> bytes:
    try:
        spec = LIBRARY_SPECS[library_name]
    except KeyError as error:
        raise RuntimeError(f"No 16 KiB layout specification for {library_name}") from error
    digest = sha256(data)
    if digest == spec.output_sha256:
        return data
    if digest != spec.input_sha256 or len(data) != spec.input_size:
        raise RuntimeError(
            f"Unsupported {library_name}: size={len(data)}, sha256={digest}"
        )
    intermediate = pad_writable_load(data) if spec.pad_load_offset else data
    output = move_post_relro_data(intermediate, spec)
    output_digest = sha256(output)
    if len(output) != spec.output_size or output_digest != spec.output_sha256:
        raise RuntimeError(
            f"16 KiB transformation of {library_name} was not reproducible: "
            f"size={len(output)}, sha256={output_digest}"
        )
    return output


def write_atomic(destination: Path, data: bytes) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=destination.parent, delete=False) as temporary:
        temporary.write(data)
        temporary_path = Path(temporary.name)
    temporary_path.replace(destination)


def rewrite_native_libraries(library_directory: Path) -> None:
    for library_name in sorted(LIBRARY_SPECS):
        path = library_directory / library_name
        source = path.read_bytes()
        output = transform(library_name, source)
        if output != source:
            write_atomic(path, output)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path, nargs="?")
    args = parser.parse_args()
    destination = args.destination or args.source
    output = transform(args.source.name, args.source.read_bytes())
    write_atomic(destination, output)
    print(f"{destination}: size={len(output)}, sha256={sha256(output)}")


if __name__ == "__main__":
    main()
