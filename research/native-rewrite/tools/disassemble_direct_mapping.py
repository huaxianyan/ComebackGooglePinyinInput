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
    "resolve_indirection": (0x19CBF8, 0x19CC2C),
    "read_target_and_score": (0x19CC2C, 0x19CC5C),
    "iterator_current": (0x19CC8C, 0x19CD88),
    "lookup_range": (0x19CFAC, 0x19D0F0),
    "read_container": (0x19D1CC, 0x19D484),
}
DIAGNOSTICS = {
    0x32C3CB: "[DirectMappingTokenExpander] Failed to load the key ids table.",
    0x32C40A: "[DirectMappingTokenExpander] Failed to load the start position table.",
    0x32C450: "[DirectMappingTokenExpander] Failed to load target id table.",
    0x32C48D: "[DirectMappingTokenExpander] Failed to load expansion score table.",
    0x32C4D0: "[DirectMappingTokenExpander] Failed to load the meta data table.",
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
    for address, text in DIAGNOSTICS.items():
        actual = bytes(binary.get_content_from_virtual_address(address, len(text) + 1))
        if actual != text.encode() + b"\0":
            raise ValueError(f"fixed-APK diagnostic mismatch at {address:#x}")
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
    result = {
        "library_entry": entry,
        "library_sha256": hashlib.sha256(content).hexdigest(),
        "address_space": "ELF virtual address, before runtime relocation",
        "labels": "research annotations, not recovered C++ symbol names",
        "diagnostics": {hex(address): text for address, text in DIAGNOSTICS.items()},
        "regions": regions,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"exported {len(regions)} ARM64 regions to {args.output}")


if __name__ == "__main__":
    main()
