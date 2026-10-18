"""Recover static Itanium C++ RTTI/base/vtable candidates from ARM64 ELF metadata.

Addresses describe the file before runtime relocation. No target code executes.
Names stay mangled unless an explicit external GNU demangler command is supplied.
"""
from __future__ import annotations

import argparse
from bisect import bisect_right
import json
from pathlib import Path
import struct
import subprocess
import zipfile

from map_jni_registration import ElfImage
from extract_data_bundles import read_varint
from disassemble_direct_mapping import decode_direct_branch


def unwind_function_ranges(image: ElfImage) -> list[dict]:
    """Read DWARF32 FDE ranges, validating the fixed ELF's pointer encodings."""
    string_index = struct.unpack_from("<H", image.data, 62)[0]
    strings = image.sections[string_index][4]
    section = next((item for item in image.sections
                    if image.file_string(strings + item[0]) == ".eh_frame_hdr"), None)
    if section is None:
        return []
    _, _, _, virtual, offset, _, _, _, _, _ = section
    if image.data[offset:offset + 4] != b"\x01\x1b\x03\x3b":
        raise ValueError("unsupported .eh_frame_hdr encoding; no function boundaries inferred")
    count = struct.unpack_from("<I", image.data, offset + 8)[0]
    cie_encodings = {}
    ranges = []
    for index in range(count):
        initial_delta, fde_delta = struct.unpack_from("<ii", image.data, offset + 12 + index * 8)
        initial, fde = virtual + initial_delta, virtual + fde_delta
        fde_offset = image.file_offset(fde)
        cie_delta = struct.unpack_from("<I", image.data, fde_offset + 4)[0]
        cie = fde + 4 - cie_delta
        if cie not in cie_encodings:
            cie_offset = image.file_offset(cie)
            version = image.data[cie_offset + 8]
            if version not in (1, 3):
                raise ValueError(f"unsupported CIE version {version} at {cie:#x}")
            augmentation = image.file_string(cie_offset + 9)
            cursor = cie_offset + 10 + len(augmentation)
            _, cursor = read_varint(image.data, cursor)  # code alignment
            _, cursor = read_varint(image.data, cursor)  # skip signed data-alignment bytes
            _, cursor = read_varint(image.data, cursor)  # return-address register
            encoding = 0
            if augmentation.startswith("z"):
                _, cursor = read_varint(image.data, cursor)
                for kind in augmentation[1:]:
                    if kind == "R":
                        encoding = image.data[cursor]
                        cursor += 1
                    elif kind == "L":
                        cursor += 1
                    elif kind == "P":
                        personality_encoding = image.data[cursor]
                        cursor += 1
                        widths = {0: 8, 2: 2, 3: 4, 4: 8, 10: 2, 11: 4, 12: 8}
                        width = widths.get(personality_encoding & 15)
                        if width is None:
                            raise ValueError(f"unsupported personality encoding {personality_encoding:#x}")
                        cursor += width
                    else:
                        raise ValueError(f"unsupported CIE augmentation {augmentation}")
            cie_encodings[cie] = encoding
        if cie_encodings[cie] != 0x1B:
            raise ValueError(f"unsupported FDE pointer encoding {cie_encodings[cie]:#x}")
        location, length = struct.unpack_from("<ii", image.data, fde_offset + 8)
        decoded_initial = fde + 8 + location
        if decoded_initial != initial:
            raise ValueError(f"FDE/header function-address disagreement at {fde:#x}")
        ranges.append({"start": initial, "end": initial + length, "fde_address": fde})
    return ranges


def direct_function_references(image: ElfImage, ranges: list[dict]) -> list[dict]:
    """Immediate B/BL references within FDE-covered code, not dynamic calls."""
    ordered = sorted(ranges, key=lambda item: item["start"])
    starts = [item["start"] for item in ordered]
    references = []
    for function in ordered:
        start, end = function["start"], function["end"]
        offset = image.file_offset(start)
        for index, (word,) in enumerate(struct.iter_unpack("<I", image.data[offset:offset + end - start])):
            branch = decode_direct_branch(word, start + index * 4)
            if branch is None or start <= branch["target"] < end:
                continue
            target_index = bisect_right(starts, branch["target"]) - 1
            target = ordered[target_index] if target_index >= 0 else None
            target_start = target["start"] if target and branch["target"] < target["end"] else None
            references.append({**branch, "source_function": start, "target_function": target_start})
    return references


def analyze_types(image: ElfImage) -> dict:
    runtime_vtables = {symbol["value"] + 16: symbol["name"] for symbol in image.symbols
                      if symbol["value"] and symbol["name"].startswith("_ZTVN10__cxxabiv1")}

    def typeinfo_kind(address):
        symbol = image.symbolic_pointers.get(address, {}).get("symbol")
        symbol = symbol or runtime_vtables.get(image.pointers.get(address))
        if not symbol:
            return None
        for kind in ("__vmi_class_type_info", "__si_class_type_info", "__class_type_info"):
            if kind in symbol:
                return kind
        return None

    records = {}
    for name_field, name_pointer in sorted(image.pointers.items()):
        address = name_field - 8
        kind = typeinfo_kind(address)
        if kind is None:
            continue
        mangled = image.string(name_pointer)
        if not mangled:
            continue
        record = {"typeinfo_address": address, "mangled_name": mangled,
                  "abi_kind": kind, "bases": []}
        if kind == "__si_class_type_info":
            base = image.pointers.get(address + 16)
            record["bases"].append({"typeinfo_address": base, "offset": 0, "virtual": False})
        elif kind == "__vmi_class_type_info":
            offset = image.file_offset(address + 16)
            flags, count = struct.unpack_from("<II", image.data, offset)
            record["hierarchy_flags"] = flags
            for index in range(count):
                entry = address + 24 + index * 16
                base = image.pointers.get(entry)
                offset_flags = struct.unpack_from("<q", image.data, image.file_offset(entry + 8))[0]
                record["bases"].append({"typeinfo_address": base, "offset": offset_flags >> 8,
                                        "virtual": bool(offset_flags & 1), "public": bool(offset_flags & 2)})
        records[address] = record
    for record in records.values():
        for base in record["bases"]:
            base["mangled_name"] = records.get(base["typeinfo_address"], {}).get("mangled_name")
    vtables = []
    for typeinfo_field, typeinfo in sorted(image.pointers.items()):
        if typeinfo not in records:
            continue
        slots = []
        address = typeinfo_field + 8
        while True:
            target = image.pointers.get(address)
            imported = image.symbolic_pointers.get(address, {}).get("symbol")
            if target is not None and image.executable(target):
                slots.append({"slot": len(slots), "address": address, "function_address": target})
            elif imported in ("__cxa_pure_virtual", "__cxa_deleted_virtual"):
                slots.append({"slot": len(slots), "address": address, "imported_function": imported})
            else:
                break
            address += 8
        if slots:
            header_offset = image.file_offset(typeinfo_field - 8)
            offset_to_top = struct.unpack_from("<q", image.data, header_offset)[0]
            vtables.append({"address_point": typeinfo_field + 8, "typeinfo_address": typeinfo,
                            "mangled_name": records[typeinfo]["mangled_name"],
                            "offset_to_top": offset_to_top, "slots": slots})
    return {"types": list(records.values()), "vtable_candidates": vtables,
            "limitations": ["static ABI metadata does not establish instantiated runtime types",
                            "only contiguous relocated function slots are enumerated",
                            "name decoding requires an explicitly selected external demangler",
                            "a virtual base offset indexes the vtable, not a fixed object offset"]}


def attach_demangled_names(result: dict, command: list[str]) -> None:
    names = list(dict.fromkeys(item["mangled_name"] for item in result["types"]))
    completed = subprocess.run(command, input="\n".join(name.removeprefix("*") for name in names) + "\n",
                               capture_output=True, text=True, encoding="utf-8", check=True, timeout=30)
    decoded = completed.stdout.splitlines()
    if len(decoded) != len(names):
        raise ValueError("demangler output does not match the input name count")
    mapping = dict(zip(names, decoded))
    result["demangler_command"] = command
    for item in result["types"] + result["vtable_candidates"]:
        name = item["mangled_name"]
        item["demangled_name"] = mapping[name]
        item["name_decoded"] = mapping[name] != name.removeprefix("*")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--library", default="lib/arm64-v8a/libhmm_gesture_hwr_zh.so")
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--demangler", nargs=argparse.REMAINDER,
                        help="external c++filt command, including arguments; place this option last")
    args = parser.parse_args()
    with zipfile.ZipFile(args.apk) as archive:
        image = ElfImage(archive.read(args.library))
    ranges = unwind_function_ranges(image)
    result = {"apk": str(args.apk), "library": args.library, **analyze_types(image),
              "unwind_function_ranges": ranges,
              "direct_function_references": direct_function_references(image, ranges)}
    if args.demangler:
        attach_demangled_names(result, args.demangler)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"{len(result['types'])} class typeinfo records; {len(result['vtable_candidates'])} vtable candidates; "
          f"{len(result['unwind_function_ranges'])} FDE function ranges")


if __name__ == "__main__":
    main()
