"""Export bounded ARM64 evidence from the original APK; labels are research names."""
import argparse
import hashlib
import json
from pathlib import Path
import zipfile

import lief
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

# Virtual addresses recovered from the fixed 4.5.2 ARM64 library, not exported symbols.
REGIONS = {
    "iterator_advance": (0x19C93C, 0x19C984),
    "iterator_exhausted": (0x19C984, 0x19C9A0),
    "iterator_constructor": (0x19CAE8, 0x19CB30),
    "create_iterator": (0x19CB30, 0x19CB7C),
    "expander_constructor": (0x19CB7C, 0x19CBD0),
    "resolve_indirection": (0x19CBF8, 0x19CC2C),
    "read_target_and_score": (0x19CC2C, 0x19CC5C),
    "iterator_current": (0x19CC8C, 0x19CD88),
    "lookup_range": (0x19CFAC, 0x19D0F0),
    "iterator_reset": (0x19D0F0, 0x19D1CC),
    "read_container": (0x19D1CC, 0x19D484),
    "load_container": (0x19D540, 0x19D670),
    "build_score_table": (0x1D1D80, 0x1D1E50),
    "default_score_table": (0x1D1E50, 0x1D1E74),
    "metadata_serialize": (0x19F518, 0x19F5D8),
    "metadata_type_name": (0x19F6C0, 0x19F714),
    "metadata_enum_validator": (0x19F79C, 0x19F7A8),
    "metadata_constructor": (0x19F7A8, 0x19F800),
    "metadata_parse": (0x19FA00, 0x19FC74),
    "get_expansion_category": (0x19C9C4, 0x19C9DC),
    "manager_apply_iterator": (0x196874, 0x196AF0),
    "manager_reset": (0x196AF0, 0x196BEC),
    "manager_register": (0x196D30, 0x196FF0),
    "manager_create_iterator": (0x197348, 0x1974A4),
}
RELOCATION_REGIONS = {
    "direct_iterator": (0x67A7B0, 0x67A7E8),
    "manager_iterator": (0x67A488, 0x67A4C8),
    "manager": (0x67A4D8, 0x67A500),
    "manager_typeinfo": (0x68AF28, 0x68AF58),
    "metadata": (0x68B278, 0x68B300),
}
STRING_ANCHORS = {
    0x32C3CB: "[DirectMappingTokenExpander] Failed to load the key ids table.",
    0x32C40A: "[DirectMappingTokenExpander] Failed to load the start position table.",
    0x32C450: "[DirectMappingTokenExpander] Failed to load target id table.",
    0x32C48D: "[DirectMappingTokenExpander] Failed to load expansion score table.",
    0x32C4D0: "[DirectMappingTokenExpander] Failed to load the meta data table.",
    0x32C89D: "i18n_input.engine.hmm.proto.TokenExpanderMetaData",
    0x34A9B0: "N10i18n_input6engine3hmm20TokenExpanderManagerE",
    0x34A9E0: "N10i18n_input6engine3hmm20TokenExpanderManager15ManagerIteratorE",
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    entry = "lib/arm64-v8a/libhmm_gesture_hwr_zh.so"
    with zipfile.ZipFile(args.apk) as archive:
        content = archive.read(entry)
    binary = lief.ELF.parse(list(content))
    if binary is None:
        raise ValueError("could not parse the core library")
    for address, text in STRING_ANCHORS.items():
        actual = bytes(binary.get_content_from_virtual_address(address, len(text) + 1))
        if actual != text.encode() + b"\0":
            raise ValueError(f"fixed-APK string anchor mismatch at {address:#x}")
    disassembler = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    regions = {}
    for label, (start, end) in REGIONS.items():
        data = bytes(binary.get_content_from_virtual_address(start, end - start))
        instructions = [
            {"address": ins.address, "mnemonic": ins.mnemonic, "operands": ins.op_str}
            for ins in disassembler.disasm(data, start)
        ]
        if len(instructions) * 4 != end - start:
            raise ValueError(f"incomplete ARM64 disassembly in {label}")
        regions[label] = {
            "start": start, "end": end,
            "sha256": hashlib.sha256(data).hexdigest(),
            "instructions": instructions,
        }
    relocations = sorted(binary.relocations, key=lambda item: item.address)
    result = {
        "library_entry": entry,
        "library_sha256": hashlib.sha256(content).hexdigest(),
        "address_space": "ELF virtual address, before runtime relocation",
        "labels": "research annotations, not recovered C++ symbol names",
        "string_anchors": {hex(address): text for address, text in STRING_ANCHORS.items()},
        "regions": regions,
        "relocation_regions": {
            label: [
                {"address": relocation.address, "type": str(relocation.type),
                 "target": relocation.addend}
                for relocation in relocations if start <= relocation.address < end
            ]
            for label, (start, end) in RELOCATION_REGIONS.items()
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"exported {len(regions)} ARM64 regions to {args.output}")


if __name__ == "__main__":
    main()
