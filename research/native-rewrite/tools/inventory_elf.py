#!/usr/bin/env python3
"""Build a deterministic ELF/JNI inventory for native libraries in an APK."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import tempfile
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import lief

ASCII_STRING = re.compile(rb"[ -~]{4,}")
NATIVE_DECLARATION = re.compile(
    r"\bnative\s+[\w$<>\[\].?]+\s+(?P<method>\w+)\s*\("
)
PACKAGE_DECLARATION = re.compile(r"^package\s+(?P<package>[\w.]+);", re.MULTILINE)
CLASS_DECLARATION = re.compile(
    r"\b(?:class|interface|enum)\s+(?P<class_name>[A-Za-z_$][\w$]*)"
)
STORAGE_CLASS_NAMES = {
    "ClassBigramModel",
    "ClassNGramModel",
    "ClassNGramModelReader",
    "DirectMappingTokenExpander",
    "DirectTokenDictionary",
    "ForwardTokenDictionary",
    "GenericDataModelCreator",
    "InMemoryTokenExpander",
    "MarisaTrie",
}


@dataclass(frozen=True)
class JavaNativeMethod:
    class_name: str
    method_name: str


def enum_name(value: Any) -> str:
    text = str(value)
    return text.rsplit(".", 1)[-1]


def function_names(functions: Any) -> list[str]:
    return sorted({function.name for function in functions if function.name})


def extract_ascii_strings(data: bytes) -> set[str]:
    return {match.group().decode("ascii") for match in ASCII_STRING.finditer(data)}


def read_java_native_methods(root: Path | None) -> list[JavaNativeMethod]:
    if root is None:
        return []

    methods: list[JavaNativeMethod] = []
    for path in root.rglob("*.java"):
        text = path.read_text(encoding="utf-8", errors="replace")
        package_match = PACKAGE_DECLARATION.search(text)
        class_match = CLASS_DECLARATION.search(text)
        if class_match is None:
            continue
        package_name = package_match.group("package") if package_match else ""
        simple_name = class_match.group("class_name")
        class_name = f"{package_name}.{simple_name}" if package_name else simple_name
        for declaration in NATIVE_DECLARATION.finditer(text):
            methods.append(JavaNativeMethod(class_name, declaration.group("method")))
    return sorted(methods, key=lambda item: (item.class_name, item.method_name))


def segment_record(segment: Any) -> dict[str, Any]:
    return {
        "type": enum_name(segment.type),
        "flags": enum_name(segment.flags),
        "file_offset": segment.file_offset,
        "virtual_address": segment.virtual_address,
        "physical_size": segment.physical_size,
        "virtual_size": segment.virtual_size,
        "alignment": segment.alignment,
    }


def section_record(section: Any) -> dict[str, Any]:
    return {
        "name": section.name,
        "type": enum_name(section.type),
        "flags": int(section.flags),
        "offset": section.offset,
        "virtual_address": section.virtual_address,
        "size": section.size,
        "alignment": section.alignment,
    }


def symbol_record(symbol: Any) -> dict[str, Any]:
    return {
        "name": symbol.name,
        "type": enum_name(symbol.type),
        "binding": enum_name(symbol.binding),
        "visibility": enum_name(symbol.visibility),
        "value": symbol.value,
        "size": symbol.size,
    }


def analyze_library(
    path: Path,
    archive_path: str,
    java_methods: list[JavaNativeMethod],
) -> dict[str, Any]:
    data = path.read_bytes()
    strings = extract_ascii_strings(data)
    binary = lief.ELF.parse(str(path))
    if binary is None:
        raise RuntimeError(f"LIEF could not parse {archive_path}")

    exports = function_names(binary.exported_functions)
    imports = function_names(binary.imported_functions)
    jni_exports = [
        name for name in exports if name == "JNI_OnLoad" or name.startswith("Java_")
    ]
    register_natives_strings = sorted(
        value for value in strings if "RegisterNatives" in value
    )
    storage_reader_evidence = sorted(
        value
        for value in strings
        if value in STORAGE_CLASS_NAMES
        or value.startswith("[ForwardTokenDictionary]")
        or value.startswith("[InMemoryTokenExpander]")
        or value.startswith("[DirectMappingTokenExpander]")
        or "i18n/input/engine/hmm/internal/storage/" in value
        or "i18n_input.engine.hmm.proto." in value
    )
    defined_dynamic_symbols = sorted(
        (
            symbol_record(symbol)
            for symbol in binary.dynamic_symbols
            if symbol.name and not symbol.imported and symbol.value != 0
        ),
        key=lambda symbol: (symbol["value"], symbol["name"]),
    )

    matched_classes = sorted(
        {
            method.class_name
            for method in java_methods
            if method.class_name.replace(".", "/") in strings
        }
    )
    matched_methods = sorted(
        {
            f"{method.class_name}#{method.method_name}"
            for method in java_methods
            if method.method_name in strings
        }
    )

    return {
        "archive_path": archive_path,
        "file_name": path.name,
        "size": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
        "header": {
            "machine": enum_name(binary.header.machine_type),
            "file_type": enum_name(binary.header.file_type),
            "class": enum_name(binary.header.identity_class),
            "endianness": enum_name(binary.header.identity_data),
            "entrypoint": binary.entrypoint,
        },
        "needed_libraries": sorted(binary.libraries),
        "counts": {
            "sections": len(binary.sections),
            "segments": len(binary.segments),
            "dynamic_symbols": len(binary.dynamic_symbols),
            "symbols": len(binary.symbols),
            "relocations": len(binary.relocations),
            "exported_functions": len(exports),
            "imported_functions": len(imports),
            "ascii_strings": len(strings),
        },
        "segments": [segment_record(segment) for segment in binary.segments],
        "sections": [section_record(section) for section in binary.sections],
        "exported_functions": exports,
        "imported_functions": imports,
        "defined_dynamic_symbols": defined_dynamic_symbols,
        "storage_reader_evidence": storage_reader_evidence,
        "jni": {
            "exports": jni_exports,
            "register_natives_strings": register_natives_strings,
            "java_classes_present_as_strings": matched_classes,
            "java_native_methods_present_as_strings": matched_methods,
        },
    }


def build_inventory(
    apk: Path,
    java_sources: Path | None,
) -> dict[str, Any]:
    java_methods = read_java_native_methods(java_sources)
    libraries: list[dict[str, Any]] = []

    with tempfile.TemporaryDirectory(prefix="native-rewrite-elf-") as temp_dir:
        temp_root = Path(temp_dir)
        with zipfile.ZipFile(apk) as archive:
            native_entries = sorted(
                name for name in archive.namelist() if name.endswith(".so")
            )
            for archive_path in native_entries:
                output = temp_root / Path(archive_path).name
                output.write_bytes(archive.read(archive_path))
                libraries.append(
                    analyze_library(output, archive_path, java_methods)
                )

    return {
        "schema_version": 1,
        "apk": {
            "path": apk.as_posix(),
            "size": apk.stat().st_size,
            "sha256": hashlib.sha256(apk.read_bytes()).hexdigest(),
        },
        "java_native_declarations": {
            "count": len(java_methods),
            "unique_class_and_method_names": len(
                {(method.class_name, method.method_name) for method in java_methods}
            ),
            "classes": sorted({method.class_name for method in java_methods}),
        },
        "libraries": libraries,
        "interpretation_warning": (
            "Java class and method string matches identify registration candidates only; "
            "they do not prove that a library implements or registers the method."
        ),
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", type=Path, required=True)
    parser.add_argument("--java-sources", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    inventory = build_inventory(args.apk.resolve(), args.java_sources)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(inventory, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        f"inventoried {len(inventory['libraries'])} ELF libraries and "
        f"{inventory['java_native_declarations']['count']} Java native declarations"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
