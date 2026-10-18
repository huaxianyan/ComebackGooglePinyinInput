"""Match DEX native prototypes to ELF JNI exports and relocated method triples.

This observes static tables and call sites, not successful runtime registration.
ELF header parsing is shared with the existing native patch tooling.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path
import struct
import sys
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "scripts"))
from rewrite_elf_16kb import decode_adrp_target, read_program_headers, read_section_headers, sign_extend
from disassemble_direct_mapping import decode_direct_branch

NATIVE_METHOD_SIZE = struct.calcsize("<QQQ")


class ElfImage:
    def __init__(self, data: bytes):
        self.data = data
        self.segments = read_program_headers(data)
        self.sections = read_section_headers(data)
        self.symbols = []
        self.pointers = {}
        self.symbolic_pointers = {}
        for section in self.sections:
            _, kind, _, _, offset, size, link, _, _, entry_size = section
            if kind != 11:  # SHT_DYNSYM
                continue
            strings = self.sections[link]
            for index in range(size // entry_size):
                name, info, _, _, value, length = struct.unpack_from("<IBBHQQ", data, offset + index * entry_size)
                self.symbols.append({
                    "name": self.file_string(strings[4] + name), "type": info & 15,
                    "value": value, "size": length,
                })
        for section in self.sections:
            _, kind, _, _, offset, size, _, _, _, entry_size = section
            if kind != 4:  # SHT_RELA
                continue
            for index in range(size // entry_size):
                address, info, addend = struct.unpack_from("<QQq", data, offset + index * entry_size)
                relocation_type = info & 0xFFFFFFFF
                if relocation_type == 1027:  # R_AARCH64_RELATIVE
                    self.pointers[address] = addend
                elif relocation_type in (257, 1025):  # R_AARCH64_ABS64 / GLOB_DAT
                    symbol = self.symbols[info >> 32]
                    self.symbolic_pointers[address] = {"symbol": symbol["name"], "addend": addend}
                    if relocation_type == 257 and symbol["value"]:
                        self.pointers[address] = symbol["value"] + addend

    def file_string(self, offset: int) -> str:
        end = self.data.find(b"\0", offset)
        if end == -1:
            raise ValueError(f"unterminated ELF string at file offset {offset:#x}")
        return self.data[offset:end].decode("utf-8", errors="replace")

    def file_offset(self, address: int) -> int | None:
        for kind, _, offset, virtual, _, file_size, _, _ in self.segments:
            if kind == 1 and virtual <= address < virtual + file_size:
                return offset + address - virtual
        return None

    def string(self, address: int) -> str | None:
        offset = self.file_offset(address)
        return self.file_string(offset) if offset is not None else None

    def executable(self, address: int) -> bool:
        return any(kind == 1 and flags & 1 and virtual <= address < virtual + size
                   for kind, flags, _, virtual, _, size, _, _ in self.segments)


def read_dex_inventory(path: Path):
    declarations = []
    callers = {}
    with path.open(encoding="utf-8", newline="") as source:
        for row in csv.reader(source, delimiter="\t"):
            if row[0] == "NATIVE":
                _, entry, owner, name, prototype, access = row
                declarations.append({"dex_entry": entry, "class": owner, "name": name,
                                     "prototype": prototype, "access_flags": int(access)})
            elif row[0] == "CALL":
                _, entry, caller, offset, opcode, target = row
                callers.setdefault(target, []).append({
                    "dex_entry": entry, "caller": caller, "code_unit_offset": int(offset), "opcode": opcode,
                })
    return declarations, callers


def jni_mangle(value: str) -> str:
    result = []
    for character in value:
        if character.isascii() and character.isalnum():
            result.append(character)
        elif character == "/":
            result.append("_")
        elif character in "_;[":
            result.append({"_": "_1", ";": "_2", "[": "_3"}[character])
        else:
            for offset in range(0, len(encoded := character.encode("utf-16-be")), 2):
                result.append(f"_0{int.from_bytes(encoded[offset:offset+2], 'big'):04x}")
    return "".join(result)


def registration_arguments(image: ElfImage, triples: list[dict], declarations: list[dict]) -> tuple[list[dict], list[dict]]:
    """Record literal class/table/count arguments in recognized initializer blocks.

    This is intentionally not a general disassembler or data-flow engine. Unknown
    instructions end constant tracking; it never guesses their register effects.
    """
    slots = {item["table_slot"]: item for item in triples}
    owners = {item["class"] for item in declarations}
    calls = []
    literal_calls = []
    for symbol in image.symbols:
        name, start, size = symbol["name"], symbol["value"], symbol["size"]
        if symbol["type"] != 2 or not size:
            continue
        if not (name == "JNI_OnLoad" or name.startswith("Java_") and name.endswith(("_initJNI", "_init"))):
            continue
        offset = image.file_offset(start)
        if offset is None:
            continue
        instructions = list(struct.iter_unpack("<I", image.data[offset:offset + size - size % 4]))
        incoming = set()
        for index, (word,) in enumerate(instructions):
            pc = start + index * 4
            branch = decode_direct_branch(word, pc)
            if branch is not None and branch["kind"] == "b":
                incoming.add(branch["target"])
            elif word & 0xFF000010 == 0x54000000 or word & 0x7E000000 == 0x34000000:
                incoming.add(pc + sign_extend((word >> 5) & 0x7FFFF, 19) * 4)
            elif word & 0x7E000000 == 0x36000000:
                incoming.add(pc + sign_extend((word >> 5) & 0x3FFF, 14) * 4)
        registers = {}
        loaded_offsets = {}
        for index, (word,) in enumerate(instructions):
            pc = start + index * 4
            if pc in incoming:
                registers.clear()
                loaded_offsets.clear()
            rd, rn = word & 31, (word >> 5) & 31
            page = decode_adrp_target(word, pc)
            branch = decode_direct_branch(word, pc)
            if page is not None:
                loaded_offsets.pop(rd, None)
                registers[rd] = page
            elif word & 0xFF000000 == 0x91000000:  # ADD Xd, Xn, #imm
                loaded_offsets.pop(rd, None)
                if rn in registers:
                    registers[rd] = registers[rn] + (((word >> 10) & 0xFFF) << (12 if word & (1 << 22) else 0))
                else:
                    registers.pop(rd, None)
            elif word & 0xFFC00000 == 0xF9400000:  # LDR Xd, [Xn, #unsigned offset]
                loaded_offsets[rd] = ((word >> 10) & 0xFFF) * 8
                location = registers.get(rn)
                if location is None:
                    registers.pop(rd, None)
                else:
                    location += ((word >> 10) & 0xFFF) * 8
                    if location in image.pointers:
                        registers[rd] = image.pointers[location]
                    else:
                        registers.pop(rd, None)
            elif word & 0x7F800000 == 0x52800000:  # MOVZ Wd/Xd, #imm
                loaded_offsets.pop(rd, None)
                registers[rd] = ((word >> 5) & 0xFFFF) << (((word >> 21) & 3) * 16)
            elif word & 0xFFE0FFE0 == 0xAA0003E0:  # MOV Xd, Xm (ORR alias)
                loaded_offsets.pop(rd, None)
                source = (word >> 16) & 31
                if source in registers:
                    registers[rd] = registers[source]
                else:
                    registers.pop(rd, None)
            elif word & 0x3B400000 == 0x29000000 and rn == 31:  # STP to the stack; preserves X registers
                pass
            elif (branch is not None and branch["kind"] == "bl") or word & 0xFFFFFC1F == 0xD63F0000:
                indirect = branch is None
                slot_offset = loaded_offsets.get((word >> 5) & 31) if indirect else None
                target = branch["target"] if branch else None
                literal_calls.append({"initializer": name, "call_address": pc, "target": target,
                                      "indirect_slot_offset": slot_offset,
                                      "literal_registers": {str(register): value for register, value in registers.items()}})
                owner = image.string(registers[1]) if 1 in registers else None
                owner = "L" + owner + ";" if owner else None
                table, count = registers.get(2), registers.get(3)
                if table in slots and count is not None and 0 < count <= len(declarations):
                    members = [slots.get(table + index * NATIVE_METHOD_SIZE) for index in range(count)]
                    if all(members):
                        candidates = set.intersection(*(set(item["candidate_classes"]) for item in members))
                        basis = "literal_class_argument"
                        # RegisterNatives is slot 215 of the frozen JNI interface.
                        if owner not in owners and indirect and slot_offset == 215 * 8 and len(candidates) == 1:
                            owner = next(iter(candidates))
                            basis = "unique_complete_prototype_set_at_jni_slot"
                        if owner in candidates:
                            calls.append({"initializer": name, "call_address": pc, "target": target,
                                          "class": owner, "table_address": table, "method_count": count,
                                          "owner_basis": basis, "indirect_slot_offset": slot_offset})
                registers = {register: value for register, value in registers.items() if register >= 19}
                loaded_offsets = {register: value for register, value in loaded_offsets.items() if register >= 19}
            else:
                registers.clear()
                loaded_offsets.clear()
    return calls, literal_calls


def map_library(entry: str, content: bytes, declarations: list[dict]) -> dict:
    image = ElfImage(content)
    pairs = {}
    for declaration in declarations:
        pair = (declaration["name"], declaration["prototype"])
        pairs.setdefault(pair, []).append(declaration["class"])
    function_symbols = {}
    for symbol in image.symbols:
        if symbol["type"] == 2 and symbol["value"]:
            function_symbols.setdefault(symbol["value"], []).append(symbol["name"])
    method_names = {pair[0] for pair in pairs}
    triples = []
    for address, pointer in sorted(image.pointers.items()):
        if address + 8 not in image.pointers or address + 16 not in image.pointers:
            continue
        name = image.string(pointer)
        if name not in method_names:
            continue
        prototype = image.string(image.pointers[address + 8])
        owners = pairs.get((name, prototype))
        function = image.pointers[address + 16]
        if owners and image.executable(function):
            triples.append({"table_slot": address, "name": name, "prototype": prototype,
                            "function_address": function, "function_symbols": sorted(function_symbols.get(function, [])),
                            "candidate_classes": sorted(set(owners))})
    registrations, literal_calls = registration_arguments(image, triples, declarations)
    slots = {item["table_slot"]: item for item in triples}
    owners = {item["class"] for item in declarations}
    descriptors = []
    for table_field, table in sorted(image.pointers.items()):
        if table not in slots:
            continue
        address = table_field - 8
        offset = image.file_offset(address)
        if offset is None:
            continue
        raw_class, _, count = struct.unpack_from("<QQQ", content, offset)
        class_pointer = image.pointers.get(address, raw_class)
        text = image.string(class_pointer) if class_pointer else None
        owner = "L" + text + ";" if text else None
        if not 0 < count <= len(declarations):
            continue
        members = [slots.get(table + index * NATIVE_METHOD_SIZE) for index in range(count)]
        if not all(members):
            continue
        candidates = set.intersection(*(set(item["candidate_classes"]) for item in members))
        basis = "relocated_class_table_count_descriptor"
        if owner not in owners and class_pointer == 0 and len(candidates) == 1:
            # The HMM initializer consumes a registry whose class-pointer words
            # are zero in the file. Keep this inference distinct from a literal.
            owner = next(iter(candidates))
            basis = "unique_complete_prototype_set_with_uninitialized_class_pointer"
        if owner in candidates:
            descriptors.append({"descriptor_address": address, "class": owner,
                                "class_pointer_in_file": class_pointer,
                                "table_address": table, "method_count": count,
                                "owner_basis": basis})
    for triple in triples:
        triple["registration_classes"] = sorted({
            call["class"] for call in registrations + descriptors
            if call["table_address"] <= triple["table_slot"] < call["table_address"] + call["method_count"] * NATIVE_METHOD_SIZE
        })
    exports = {symbol["name"]: symbol for symbol in image.symbols
               if symbol["type"] == 2 and symbol["value"] and symbol["name"].startswith("Java_")}
    static = []
    for declaration in declarations:
        short = "Java_" + jni_mangle(declaration["class"][1:-1]) + "_" + jni_mangle(declaration["name"])
        arguments = declaration["prototype"].split(")", 1)[0][1:]
        long = short + "__" + jni_mangle(arguments)
        for symbol_name in (short, long):
            if symbol_name in exports:
                symbol = exports[symbol_name]
                static.append({"class": declaration["class"], "name": declaration["name"],
                               "prototype": declaration["prototype"], "symbol": symbol_name,
                               "function_address": symbol["value"]})
    return {"entry": entry, "sha256": hashlib.sha256(content).hexdigest(),
            "method_triples": triples, "static_exports": static, "initializer_arguments": registrations,
            "initializer_literal_calls": literal_calls, "class_registration_descriptors": descriptors,
            "unsupported_relocation_section_types": sorted({section[1] for section in image.sections
                if section[1] in (9, 19, 0x60000001, 0x60000002, 0x6FFFFF00)})}


def build_map(apk: Path, dex_inventory: Path) -> dict:
    declarations, callers = read_dex_inventory(dex_inventory)
    with zipfile.ZipFile(apk) as archive:
        libraries = [map_library(entry, archive.read(entry), declarations)
                     for entry in sorted(archive.namelist()) if entry.startswith("lib/") and entry.endswith(".so")]
    methods = []
    for declaration in declarations:
        key = declaration["class"] + "->" + declaration["name"] + declaration["prototype"]
        bindings = []
        for library in libraries:
            for item in library["static_exports"]:
                if all(item[field] == declaration[field] for field in ("class", "name", "prototype")):
                    bindings.append({"kind": "static_export", "library": library["entry"], **item})
            for item in library["method_triples"]:
                if (declaration["name"], declaration["prototype"]) == (item["name"], item["prototype"]):
                    if item["registration_classes"] and declaration["class"] not in item["registration_classes"]:
                        continue
                    bindings.append({"kind": "relocated_method_triple", "library": library["entry"], **item})
        methods.append({**declaration, "identity": key, "bindings": bindings,
                        "direct_call_sites": callers.get(key, [])})
    return {"schema_version": 1, "apk": str(apk), "dex_inventory": str(dex_inventory),
            "address_space": "ELF virtual address, before runtime relocation",
            "limitations": ["method triples prove static data, not runtime registration",
                            "registry owners with zero class pointers are inferred from the complete prototype set",
                            "candidate classes sharing a name/prototype remain ambiguous unless stronger table evidence exists",
                            "static invoke sites do not establish runtime dispatch or reachability",
                            "initializer constant tracking recognizes only selected instructions; empty output is not absence evidence"],
            "libraries": libraries, "native_methods": methods}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--dex-inventory", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    result = build_map(args.apk, args.dex_inventory)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    methods = result["native_methods"]
    print(f"{len(methods)} native declarations; {sum(bool(item['bindings']) for item in methods)} with static binding evidence")
    for library in result["libraries"]:
        print(library["entry"], "triples:", len(library["method_triples"]), "exports:", len(library["static_exports"]))


if __name__ == "__main__":
    main()
