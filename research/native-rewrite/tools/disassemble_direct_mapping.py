"""Export bounded ARM64 evidence from the original APK; labels are research names."""
import argparse
import hashlib
import json
import struct
from pathlib import Path
import zipfile


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
    "manager_compare_insert": (0x196684, 0x1967CC),
    "manager_current": (0x196074, 0x196224),
    "manager_advance": (0x196650, 0x196684),
    "triple_category_client": (0x18CAA0, 0x18CBAC),
    "token_decoder_constructor": (0x1751AC, 0x17522C),
    "decoder_configure_categories": (0x17522C, 0x1752F8),
    "fuzzy_client_prefix": (0x130044, 0x130190),
    "key_context_refresh": (0x18BE20, 0x18BF2C),
    "key_token_equal": (0x18C620, 0x18C658),
    "key_input_validate": (0x18CCB0, 0x18CE40),
    "key_collect_expansions": (0x18D07C, 0x18D258),
    "key_normalize_prune": (0x18D424, 0x18D5D4),
    "key_english_generation": (0x18E264, 0x18E380),
    "key_digit_expansion": (0x18E0E8, 0x18E264),
    "fast_exp": (0x18C56C, 0x18C5AC),
    "fast_log": (0x18C5D8, 0x18C61C),
    "log_score_add": (0x18C69C, 0x18C72C),
    "learning_jni_legacy": (0x111E14, 0x111F08),
    "learning_jni_add_count": (0x111F08, 0x112048),
    "learning_accessor_legacy": (0x189D94, 0x189E28),
    "learning_accessor_add_count": (0x18A68C, 0x18A91C),
    "learning_text_size_gate": (0x1896D4, 0x189704),
    "learning_shared_store": (0x189910, 0x189924),
    "learning_generate_keys": (0x18E380, 0x18EAE8),
    "learning_store_add": (0x1A1D9C, 0x1A1E54),
    "learning_store_lookup": (0x1A14B8, 0x1A153C),
    "learning_store_update_existing": (0x1A1894, 0x1A1A40),
    "learning_store_ensure_count": (0x1A1BB4, 0x1A1D9C),
    "learning_store_remove": (0x1A1A74, 0x1A1BB4),
    "learning_store_aggregate": (0x1A0CBC, 0x1A0CE0),
    "learning_store_day": (0x1A0CE0, 0x1A0D08),
    "payload_v21_encode": (0x1A0888, 0x1A09A4),
    "payload_v21_decode": (0x1A05C0, 0x1A06D8),
    "payload_v10_encode": (0x1A09A4, 0x1A0A98),
    "payload_v10_decode": (0x1A06D8, 0x1A07F4),
    "payload_read_bytes": (0x1F5BE8, 0x1F5C40),
    "payload_write_bytes": (0x1F5CA4, 0x1F5D00),
    "dictionary_initialize": (0x1A259C, 0x1A281C),
    "dictionary_load_payload": (0x1A2B38, 0x1A3130),
    "dictionary_accept_loaded": (0x1A3C9C, 0x1A3E04),
}
SCORE_TABLE_POINTER = 0x699358
SCORE_TABLE_SPANS = {
    "LogMantissa": (0x000, 128),
    "LogSlope": (0x200, 128),
    "ExpMantissa": (0x400, 128),
    "ExpResidual": (0x600, 256),
}
SCORE_CONSTANTS = {
    "Log2E": 0x18C5AC, "ExpBias": 0x18C5B0,
    "Ln2": 0x18C61C, "LogAddLimit": 0x18C730,
}
DECODER_CATEGORY_TABLE = (0x349D10, 0x349D18)
RELOCATION_REGIONS = {
    "direct_iterator": (0x67A7B0, 0x67A7E8),
    "manager_iterator": (0x67A488, 0x67A4C8),
    "manager": (0x67A4D8, 0x67A500),
    "manager_typeinfo": (0x68AF28, 0x68AF58),
    "metadata": (0x68B278, 0x68B300),
    "token_decoder_typeinfo": (0x68AA90, 0x68AAA8),
    "token_decoder_vtable": (0x68AAB8, 0x68AAF8),
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
    0x349CE0: "N10i18n_input6engine3hmm16TokenDecoderBaseE",
    0x32B90D: "i18n/input/engine/hmm/internal/storage/key_generator.cc",
    0x32B945: "The size of language_ids and source tokens are not equal.(",
    0x32B985: "Token dictionary manager contains multi dictionaries ",
    0x32B9BB: "but the source token language id is: UNKNOWN_LANGUAGE.",
}


def decode_direct_branch(word, address):
    """Decode an AArch64 immediate B/BL, using its signed instruction offset."""
    if word & 0x7C000000 != 0x14000000:
        return None
    immediate = word & 0x3FFFFFF
    if immediate & (1 << 25):
        immediate -= 1 << 26
    return {"address": address, "target": address + immediate * 4,
            "kind": "bl" if word & 0x80000000 else "b"}


def find_direct_branches(binary, targets):
    """List immediate B/BL references, not indirect calls or runtime reachability."""
    section = binary.get_section(".text")
    content = bytes(section.content)
    names = {address: name for name, address in targets.items()}
    result = {name: [] for name in targets}
    for offset, (word,) in enumerate(struct.iter_unpack("<I", content)):
        branch = decode_direct_branch(word, section.virtual_address + offset * 4)
        if branch is not None and branch["target"] in names:
            result[names[branch["target"]]].append(branch)
    return result


def capture_score_math(binary, pointer_address=SCORE_TABLE_POINTER):
    relocations = {item.address: item for item in binary.relocations}
    address = relocations[pointer_address].addend
    tables = {}
    for name, (offset, count) in SCORE_TABLE_SPANS.items():
        content = bytes(binary.get_content_from_virtual_address(address + offset, count * 4))
        tables[name] = {"address": address + offset,
                        "words": [word for (word,) in struct.iter_unpack("<I", content)],
                        "sha256": hashlib.sha256(content).hexdigest()}
    constants = {name: {"address": location, "bits": struct.unpack("<I", bytes(
        binary.get_content_from_virtual_address(location, 4)))[0]}
        for name, location in SCORE_CONSTANTS.items()}
    cutoff = bytes(binary.get_content_from_virtual_address(0x18D5D4, 4))
    return {"pointer_address": pointer_address, "table_address": address,
            "tables": tables, "constants": constants,
            "normalization_cutoff": {"address": 0x18D5D4, "bits": struct.unpack("<I", cutoff)[0]}}


def write_score_table_header(path, captured):
    lines = ["// Fixed Google Pinyin 4.5.2 ARM64 math data; regenerate with the research exporter.",
             "// Google-derived material remains subject to NOTICE, not a new MPL grant."]
    for name, item in captured["constants"].items():
        lines.append(f"constexpr std::uint32_t k{name}Bits = 0x{item['bits']:08x}u;")
    for name, item in captured["tables"].items():
        words = item["words"]
        lines.append(f"constexpr std::uint32_t k{name}Bits[] = {{")
        for offset in range(0, len(words), 8):
            lines.append("    " + ", ".join(f"0x{word:08x}u" for word in words[offset:offset+8]) + ",")
        lines.append("};")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    import lief
    from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--score-table-header", type=Path,
                        help="write checked-in C++ math constants; not part of the product build")
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
    start, end = DECODER_CATEGORY_TABLE
    category_bytes = bytes(binary.get_content_from_virtual_address(start, end - start))
    result = {
        "library_entry": entry,
        "library_sha256": hashlib.sha256(content).hexdigest(),
        "address_space": "ELF virtual address, before runtime relocation",
        "labels": "research annotations, not recovered C++ symbol names",
        "string_anchors": {hex(address): text for address, text in STRING_ANCHORS.items()},
        "regions": regions,
        "score_math": capture_score_math(binary),
        "decoder_category_table": {
            "address": start,
            "u32_values": list(struct.unpack("<II", category_bytes)),
            "sha256": hashlib.sha256(category_bytes).hexdigest(),
        },
        "direct_branch_references": find_direct_branches(binary, {
            name: REGIONS[name][0] for name in (
                "manager_create_iterator", "decoder_configure_categories",
                "triple_category_client",
            )
        }),
        "relocation_regions": {
            label: [
                {"address": relocation.address, "type": str(relocation.type),
                 "target": relocation.addend}
                for relocation in relocations if start <= relocation.address < end
            ]
            for label, (start, end) in RELOCATION_REGIONS.items()
        },
    }
    if args.score_table_header:
        write_score_table_header(args.score_table_header, result["score_math"])
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"exported {len(regions)} ARM64 regions to {args.output}")


if __name__ == "__main__":
    main()
