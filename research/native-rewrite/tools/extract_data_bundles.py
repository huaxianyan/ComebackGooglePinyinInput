#!/usr/bin/env python3
"""Extract named payloads from Google Pinyin ELF data bundles.

The original APK stores input-engine data as ELF global symbols named
``_binary_<name>_start`` and ``_binary_<name>_end``. This tool pairs those
symbols, validates their ranges, exports each payload, and writes a
machine-readable format inventory.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import struct
import tempfile
import zipfile
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

import lief
import marisa_trie


DATA_BUNDLE_NAMES = (
    "liben_data_bundle.so",
    "libpinyin_data_bundle.so",
)
START_PREFIX = "_binary_"
START_SUFFIX = "_start"
END_SUFFIX = "_end"
SAFE_BLOB_NAME = re.compile(r"^[A-Za-z0-9_]+$")
FORMAT_MARKERS = (
    b"ClassNGramModel",
    b"ClassBigramModel",
    b"DirectMappingTokenExpander",
    b"DirectTokenDictionary",
    b"ForwardTokenDictionary",
    b"InMemoryTokenExpander",
    b"MarisaTrie",
    b"We love Marisa.",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", type=Path, required=True, help="Source APK")
    parser.add_argument(
        "--output-dir", type=Path, required=True, help="Directory for extracted blobs"
    )
    parser.add_argument(
        "--manifest", type=Path, required=True, help="Output JSON manifest"
    )
    return parser.parse_args()


def sha256_bytes(content: bytes) -> str:
    return hashlib.sha256(content).hexdigest()


def read_varint(content: bytes, offset: int) -> tuple[int, int]:
    value = 0
    shift = 0
    for _ in range(10):
        if offset >= len(content):
            raise ValueError("truncated varint")
        current = content[offset]
        offset += 1
        value |= (current & 0x7F) << shift
        if current < 0x80:
            return value, offset
        shift += 7
    raise ValueError("varint exceeds 10 bytes")


def parse_protobuf_wire(content: bytes) -> list[tuple[int, int, Any]]:
    """Parse a complete protobuf wire stream without requiring its schema."""
    fields: list[tuple[int, int, Any]] = []
    offset = 0
    while offset < len(content):
        tag, offset = read_varint(content, offset)
        field_number = tag >> 3
        wire_type = tag & 7
        if field_number == 0:
            raise ValueError("protobuf field number is zero")
        if wire_type == 0:
            value, offset = read_varint(content, offset)
        elif wire_type == 1:
            end = offset + 8
            if end > len(content):
                raise ValueError("truncated fixed64")
            value = content[offset:end]
            offset = end
        elif wire_type == 2:
            size, offset = read_varint(content, offset)
            end = offset + size
            if end > len(content):
                raise ValueError("truncated length-delimited field")
            value = content[offset:end]
            offset = end
        elif wire_type == 5:
            end = offset + 4
            if end > len(content):
                raise ValueError("truncated fixed32")
            value = content[offset:end]
            offset = end
        else:
            raise ValueError(f"unsupported protobuf wire type: {wire_type}")
        fields.append((field_number, wire_type, value))
    if not fields:
        raise ValueError("empty protobuf stream")
    return fields


def protobuf_summary(
    fields: list[tuple[int, int, Any]], content_size: int
) -> dict[str, Any]:
    counts: dict[int, Counter[int]] = defaultdict(Counter)
    for field_number, wire_type, _ in fields:
        counts[field_number][wire_type] += 1
    return {
        "valid_complete_wire_stream": True,
        "encoded_size": content_size,
        "fields": [
            {
                "field_number": field_number,
                "occurrences": sum(wire_types.values()),
                "wire_types": dict(sorted(wire_types.items())),
            }
            for field_number, wire_types in sorted(counts.items())
        ],
    }


def utf8_leaf_strings(content: bytes, depth: int = 0) -> list[str]:
    """Collect readable protobuf leaf strings for bounded schema exploration."""
    if depth > 8:
        return []
    try:
        text = content.decode("utf-8")
    except UnicodeDecodeError:
        text = ""
    if text and all(character.isprintable() for character in text):
        return [text]
    try:
        fields = parse_protobuf_wire(content)
    except ValueError:
        return []

    strings: list[str] = []
    for _, wire_type, value in fields:
        if wire_type == 2:
            strings.extend(utf8_leaf_strings(value, depth + 1))
    return strings


def decode_data_scheme(
    fields: list[tuple[int, int, Any]], known_blob_names: set[str]
) -> dict[str, Any] | None:
    """Decode the confirmed Data.DataScheme field layout from JADX evidence."""
    entries: list[dict[str, Any]] = []
    bundle_library: str | None = None
    for field_number, wire_type, value in fields:
        if field_number == 2 and wire_type == 2:
            try:
                bundle_library = value.decode("utf-8")
            except UnicodeDecodeError:
                return None
        elif field_number == 1 and wire_type == 2:
            try:
                nested = parse_protobuf_wire(value)
            except ValueError:
                return None
            values: dict[int, Any] = {}
            for nested_number, nested_wire_type, nested_value in nested:
                if nested_wire_type == 0:
                    values[nested_number] = nested_value
                elif nested_wire_type == 2:
                    try:
                        values[nested_number] = nested_value.decode("utf-8")
                    except UnicodeDecodeError:
                        return None
            if not all(number in values for number in (1, 2, 3, 4)):
                return None
            entries.append(
                {
                    "data_type": values[1],
                    "data_id": values[2],
                    "storage_type": values[3],
                    "blob_name": values[4],
                    "blob_exists": values[4] in known_blob_names,
                }
            )
        else:
            return None
    if not entries or bundle_library is None:
        return None
    return {"bundle_library": bundle_library, "entries": entries}


def marker_records(content: bytes) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for marker in FORMAT_MARKERS:
        offset = content.find(marker)
        if offset >= 0:
            records.append({"text": marker.decode("ascii"), "offset": offset})
    return sorted(records, key=lambda record: (record["offset"], record["text"]))


def classify_blob(
    content: bytes, protobuf_fields: list[tuple[int, int, Any]] | None
) -> str:
    if protobuf_fields is not None:
        return "protobuf_wire"
    markers = {record["text"] for record in marker_records(content)}
    if "ClassNGramModel" in markers:
        return "class_ngram_model"
    if "MarisaTrie" in markers:
        return "marisa_trie_dictionary"
    if "ForwardTokenDictionary" in markers:
        return "forward_token_dictionary"
    if "DirectTokenDictionary" in markers:
        return "direct_token_dictionary"
    if "InMemoryTokenExpander" in markers:
        return "in_memory_token_expander"
    if "DirectMappingTokenExpander" in markers:
        return "direct_mapping_token_expander"
    if "We love Marisa." in markers:
        return "marisa_container"
    return "unknown_binary"


def shannon_entropy(content: bytes) -> float:
    if not content:
        return 0.0
    counts = Counter(content)
    length = len(content)
    return round(
        -sum((count / length) * math.log2(count / length) for count in counts.values()),
        6,
    )


def align_up(value: int, alignment: int) -> int:
    return (value + alignment - 1) // alignment * alignment


def read_u32(content: bytes, offset: int) -> int:
    end = offset + 4
    if end > len(content):
        raise ValueError(f"truncated uint32 at {offset}")
    return int.from_bytes(content[offset:end], "little")


def read_u64(content: bytes, offset: int) -> int:
    end = offset + 8
    if end > len(content):
        raise ValueError(f"truncated uint64 at {offset}")
    return int.from_bytes(content[offset:end], "little")


def class_envelope(content: bytes) -> dict[str, Any]:
    name_size = read_u32(content, 0)
    name_end = 4 + name_size
    try:
        class_name = content[4:name_end].decode("ascii")
    except UnicodeDecodeError as error:
        raise ValueError("container class name is not ASCII") from error
    payload_offset = align_up(name_end, 8)
    if any(content[name_end:payload_offset]):
        raise ValueError("container class-name padding is not zero")
    return {
        "class_name": class_name,
        "class_name_size": name_size,
        "payload_offset": payload_offset,
    }


def scalar_wire_values(fields: list[tuple[int, int, Any]]) -> list[dict[str, Any]]:
    values: list[dict[str, Any]] = []
    for field_number, wire_type, value in fields:
        record: dict[str, Any] = {
            "field_number": field_number,
            "wire_type": wire_type,
        }
        if wire_type == 0:
            record["value"] = value
        elif wire_type == 5:
            record["uint32_bits"] = int.from_bytes(value, "little")
            record["float32"] = struct.unpack("<f", value)[0]
        elif wire_type == 1:
            record["uint64_bits"] = int.from_bytes(value, "little")
            record["float64"] = struct.unpack("<d", value)[0]
        else:
            record["size"] = len(value)
            try:
                text = value.decode("utf-8")
            except UnicodeDecodeError:
                text = ""
            if all(character.isprintable() for character in text):
                record["utf8"] = text
        values.append(record)
    return values


def marisa_region(content: bytes, offset: int, size: int | None = None) -> dict[str, Any]:
    source = content[offset:] if size is None else content[offset : offset + size]
    trie = marisa_trie.Trie().frombytes(source)
    canonical = trie.tobytes()
    if not source.startswith(canonical):
        raise ValueError(f"Marisa round trip differs at offset {offset}")
    if size is not None and len(canonical) != size:
        raise ValueError(
            f"Marisa size mismatch at {offset}: declared {size}, decoded {len(canonical)}"
        )
    return {
        "offset": offset,
        "serialized_size": len(canonical),
        "sha256": sha256_bytes(canonical),
        "key_count": len(trie),
        "round_trip_exact": True,
    }


def analyze_in_memory_expander(content: bytes) -> dict[str, Any]:
    envelope = class_envelope(content)
    config = analyze_length_prefixed_config(content, envelope["payload_offset"])
    record_count = read_u32(content, config["data_offset"])
    offset = config["data_offset"] + 4
    source_ids: list[int] = []
    target_ids: list[int] = []
    records: list[dict[str, Any]] = []
    target_count = 0
    score_bits: set[int] = set()
    for _ in range(record_count):
        source_id = read_u32(content, offset)
        item_count = read_u32(content, offset + 4)
        source_ids.append(source_id)
        offset += 8
        target_count += item_count
        targets = []
        for _ in range(item_count):
            target_id = read_u32(content, offset)
            score_value_bits = read_u32(content, offset + 4)
            target_ids.append(target_id)
            score_bits.add(score_value_bits)
            targets.append(
                {
                    "target_token_id": target_id,
                    "score_uint32_bits": score_value_bits,
                    "score_float32": struct.unpack(
                        "<f", score_value_bits.to_bytes(4, "little")
                    )[0],
                }
            )
            offset += 8
        records.append({"source_token_id": source_id, "targets": targets})
    trailer = content[offset:]
    if trailer != b"\x00\x00\x00\x00":
        raise ValueError(f"unexpected expander trailer: {trailer.hex()}")
    return {
        "envelope": envelope,
        "config_size": config["config_size"],
        "config_fields": config["config_fields"],
        "record_count": record_count,
        "unique_source_count": len(set(source_ids)),
        "source_token_ids": sorted(set(source_ids)),
        "target_count": target_count,
        "target_token_ids": sorted(set(target_ids)),
        "records": records,
        "expansion_score_uint32_bits": sorted(score_bits),
        "expansion_score_float32_values": [
            struct.unpack("<f", value.to_bytes(4, "little"))[0]
            for value in sorted(score_bits)
        ],
        "trailer_size": len(trailer),
        "fully_consumed": True,
    }


def analyze_length_prefixed_config(
    content: bytes, payload_offset: int
) -> dict[str, Any]:
    config_size = read_u32(content, payload_offset)
    config_start = payload_offset + 4
    config_end = config_start + config_size
    config = parse_protobuf_wire(content[config_start:config_end])
    data_offset = align_up(config_end, 8)
    if any(content[config_end:data_offset]):
        raise ValueError("container config padding is not zero")
    return {
        "config_size": config_size,
        "config_fields": scalar_wire_values(config),
        "data_offset": data_offset,
    }


def unpack_lsb_bits(content: bytes, count: int, bit_width: int) -> list[int]:
    if not 0 < bit_width <= 32:
        raise ValueError(f"invalid packed bit width: {bit_width}")
    required_size = (count * bit_width + 7) // 8
    if len(content) < required_size:
        raise ValueError(
            f"packed array needs {required_size} bytes, only {len(content)} available"
        )
    packed = int.from_bytes(content[:required_size], "little")
    mask = (1 << bit_width) - 1
    return [(packed >> (index * bit_width)) & mask for index in range(count)]


def packed_table(
    content: bytes,
    offset: int,
    count: int,
    bit_width: int,
    header_size: int,
) -> tuple[dict[str, Any], list[int], int]:
    data_offset = offset + header_size
    data_size = (count * bit_width + 7) // 8
    data_end = data_offset + data_size
    values = unpack_lsb_bits(content[data_offset:data_end], count, bit_width)
    aligned_end = align_up(data_end, 8)
    if any(content[data_end:aligned_end]):
        raise ValueError(f"packed table padding is not zero at {data_end}")
    return (
        {
            "offset": offset,
            "count": count,
            "bit_width": bit_width,
            "data_offset": data_offset,
            "data_size": data_size,
            "aligned_end": aligned_end,
            "sha256": sha256_bytes(content[data_offset:data_end]),
            "minimum": min(values) if values else None,
            "maximum": max(values) if values else None,
            "unique_count": len(set(values)),
        },
        values,
        aligned_end,
    )


def find_counted_packed_table(
    content: bytes, start: int, count: int, expected_bit_width: int
) -> tuple[dict[str, Any], list[int], int]:
    for offset in range(start, min(start + 8, len(content) - 8) + 1, 8):
        if any(content[start:offset]):
            continue
        if read_u32(content, offset) != count:
            continue
        bit_width = read_u32(content, offset + 4)
        if bit_width != expected_bit_width:
            continue
        return packed_table(content, offset, count, bit_width, 8)
    raise ValueError(
        f"no {expected_bit_width}-bit packed table for {count} items "
        f"after offset {start}"
    )


def analyze_forward_dictionary(content: bytes) -> dict[str, Any]:
    envelope = class_envelope(content)
    offset = envelope["payload_offset"]
    marisa_size = read_u64(content, offset)
    second_header_u64 = read_u64(content, offset + 8)
    marisa_offset = offset + 16
    region = marisa_region(content, marisa_offset, marisa_size)
    auxiliary_offset = marisa_offset + marisa_size
    result = {
        "envelope": envelope,
        "marisa": region,
        "second_header_u64": second_header_u64,
        "auxiliary_offset": auxiliary_offset,
        "auxiliary_size": len(content) - auxiliary_offset,
        "auxiliary_sha256": sha256_bytes(content[auxiliary_offset:]),
        "auxiliary_first_u32": (
            read_u32(content, auxiliary_offset)
            if auxiliary_offset + 4 <= len(content)
            else None
        ),
    }
    if second_header_u64 == 0:
        token_config = analyze_length_prefixed_config(content, auxiliary_offset)
        token_count = read_u32(content, token_config["data_offset"])
        metadata_offset = token_config["data_offset"] + 4
        result["token_config"] = token_config
        result["token_count"] = token_count
        result["token_count_matches_marisa_keys"] = token_count == region["key_count"]
        if not result["token_count_matches_marisa_keys"]:
            raise ValueError("token count does not match Marisa key count")
        result["token_metadata_offset"] = metadata_offset
        result["token_metadata_size"] = len(content) - metadata_offset
        result["token_metadata_sha256"] = sha256_bytes(content[metadata_offset:])

        first_width = read_u32(content, metadata_offset)
        expected_first_width = 28 if token_count == 10 else 26
        if first_width != expected_first_width:
            raise ValueError(f"unexpected token ID bit width: {first_width}")
        first_table, token_ids, table_end = packed_table(
            content, metadata_offset, token_count, first_width, 4
        )
        table_names = ["token_scores", "token_meta", "token_codes", "token_node_ids"]
        expected_widths = (
            [1, 6, 4]
            if token_count == 10
            else [8, 4, 16, 10 if token_count > 512 else 9]
        )
        table_records = {"token_ids": first_table}
        table_values = {"token_ids": token_ids}
        for table_name, expected_width in zip(table_names, expected_widths):
            table, values, table_end = find_counted_packed_table(
                content, table_end, token_count, expected_width
            )
            table_records[table_name] = table
            table_values[table_name] = values

        prefix_scores = None
        if token_count != 10:
            prefix_count_offset = table_end
            prefix_count = read_u32(content, prefix_count_offset)
            if not token_count <= prefix_count <= token_count + 32:
                raise ValueError(f"invalid prefix score count: {prefix_count}")
            if read_u32(content, prefix_count_offset + 4) != 0:
                raise ValueError("non-zero prefix score reserved word")
            score_offset = prefix_count_offset + 8
            score_end = score_offset + prefix_count
            if score_end > len(content) or any(content[score_end:]):
                raise ValueError("invalid prefix score payload or trailing padding")
            values = list(content[score_offset:score_end])
            prefix_scores = {
                "offset": prefix_count_offset,
                "count": prefix_count,
                "bit_width": 8,
                "data_offset": score_offset,
                "data_size": prefix_count,
                "sha256": sha256_bytes(content[score_offset:score_end]),
                "minimum": min(values) if values else None,
                "maximum": max(values) if values else None,
                "unique_count": len(set(values)),
                "trailing_zero_bytes": len(content) - score_end,
            }
        elif any(content[table_end:]):
            raise ValueError("non-zero digits token dictionary trailer")

        trie = marisa_trie.Trie().frombytes(
            content[marisa_offset : marisa_offset + marisa_size]
        )
        entries = []
        for key_id in range(token_count):
            entry = {
                "marisa_key_id": key_id,
                "key": trie.restore_key(key_id),
                "token_id": table_values["token_ids"][key_id],
            }
            for table_name in table_names:
                if table_name in table_values:
                    entry[table_name.removesuffix("s")] = table_values[table_name][key_id]
            entries.append(entry)
        result["packed_tables"] = table_records
        result["prefix_scores"] = prefix_scores
        result["token_entries"] = entries
    return result


def analyze_direct_mapping_expander(content: bytes) -> dict[str, Any]:
    """Recover stored arrays; native lookup evidence is documented separately."""
    envelope = class_envelope(content)
    config = analyze_length_prefixed_config(content, envelope["payload_offset"])
    offset = config["data_offset"]
    tables = {}
    for name in ("key_ids", "start_positions"):
        count = read_u32(content, offset)
        width = read_u32(content, offset + 4)
        table, values, offset = packed_table(content, offset, count, width, 8)
        table["values"] = values
        tables[name] = table

    for name, width in (("target_words", 32), ("score_bytes", 8)):
        byte_size = read_u64(content, offset)
        element_size = width // 8
        if byte_size % element_size:
            raise ValueError(f"unaligned {name} byte size: {byte_size}")
        table, values, offset = packed_table(
            content, offset, byte_size // element_size, width, 8
        )
        table["length_header_unit"] = "bytes"
        if name == "target_words":
            # Raw words include high-bit values; do not silently mask them into IDs.
            table["high_byte_counts"] = dict(sorted(Counter(
                value >> 24 for value in values
            ).items()))
            flagged = [value & 0x7FFFFFFF for value in values if value & 0x80000000]
            table["high_bit_low31_range"] = (
                [min(flagged), max(flagged)] if flagged else None
            )
        else:
            table["value_counts"] = dict(sorted(Counter(values).items()))
        tables[name] = table

    if offset != len(content):
        raise ValueError(f"unconsumed direct mapping bytes at {offset}")
    return {
        "envelope": envelope,
        **config,
        "data_size": len(content) - config["data_offset"],
        "data_first_u32": read_u32(content, config["data_offset"]),
        "tables": tables,
        "fully_consumed": True,
        "lookup_semantics": "not_evaluated_by_exporter",
        "metadata_location": "leading_length_prefixed_message",
    }


def analyze_native_container(content: bytes, classification: str) -> dict[str, Any] | None:
    if classification == "in_memory_token_expander":
        return analyze_in_memory_expander(content)
    if classification == "forward_token_dictionary":
        return analyze_forward_dictionary(content)
    if classification == "direct_mapping_token_expander":
        return analyze_direct_mapping_expander(content)

    if classification == "direct_token_dictionary":
        envelope = class_envelope(content)
        return {
            "envelope": envelope,
            "payload_size": len(content) - envelope["payload_offset"],
            "payload_u32_prefix": [
                read_u32(content, offset)
                for offset in range(
                    envelope["payload_offset"],
                    min(len(content), envelope["payload_offset"] + 32),
                    4,
                )
            ],
        }
    if classification == "marisa_container":
        marisa_size = read_u64(content, 40)
        region = marisa_region(content, 56, marisa_size)
        return {
            "preamble_u32": [read_u32(content, offset) for offset in range(0, 40, 4)],
            "header_u64_at_48": read_u64(content, 48),
            "marisa": region,
            "auxiliary_offset": 56 + marisa_size,
            "auxiliary_size": len(content) - 56 - marisa_size,
        }
    if classification == "marisa_trie_dictionary":
        envelope = class_envelope(content)
        marker_offset = content.find(b"We love Marisa.")
        if marker_offset < 0:
            raise ValueError("missing Marisa marker")
        region = marisa_region(content, marker_offset)
        return {
            "envelope": envelope,
            "prefix_size": marker_offset - envelope["payload_offset"],
            "marisa": region,
            "auxiliary_offset": marker_offset + region["serialized_size"],
            "auxiliary_size": len(content) - marker_offset - region["serialized_size"],
        }
    if classification == "class_ngram_model":
        offsets = [match.start() for match in re.finditer(b"We love Marisa\\.", content)]
        return {
            "class_ngram_model_offset": content.find(b"ClassNGramModel"),
            "class_bigram_model_offset": content.find(b"ClassBigramModel"),
            "marisa_regions": [marisa_region(content, offset) for offset in offsets],
        }
    return None


def containing_section(binary: Any, start: int, end: int) -> Any:
    matches = [
        section
        for section in binary.sections
        if start >= section.virtual_address
        and end <= section.virtual_address + section.size
    ]
    if len(matches) != 1:
        raise ValueError(
            f"expected one section for virtual range {start:#x}..{end:#x}, "
            f"found {len(matches)}"
        )
    return matches[0]


def collect_symbol_pairs(binary: Any) -> list[tuple[str, int, int]]:
    values = {
        symbol.name: symbol.value
        for symbol in binary.dynamic_symbols
        if symbol.name.startswith(START_PREFIX)
    }
    starts = {
        name[len(START_PREFIX) : -len(START_SUFFIX)]: value
        for name, value in values.items()
        if name.endswith(START_SUFFIX)
    }
    ends = {
        name[len(START_PREFIX) : -len(END_SUFFIX)]: value
        for name, value in values.items()
        if name.endswith(END_SUFFIX)
    }
    if starts.keys() != ends.keys():
        missing_end = sorted(starts.keys() - ends.keys())
        missing_start = sorted(ends.keys() - starts.keys())
        raise ValueError(
            f"unpaired symbols: missing_end={missing_end}, missing_start={missing_start}"
        )
    pairs = sorted(
        ((name, starts[name], ends[name]) for name in starts), key=lambda item: item[1]
    )
    previous_end = -1
    for name, start, end in pairs:
        if not SAFE_BLOB_NAME.fullmatch(name):
            raise ValueError(f"unsafe blob name: {name!r}")
        if start >= end:
            raise ValueError(f"invalid range for {name}: {start:#x}..{end:#x}")
        if start < previous_end:
            raise ValueError(f"overlapping range at {name}: {start:#x}")
        previous_end = end
    return pairs


def add_expansion_token_references(blobs: list[dict[str, Any]]) -> None:
    by_name = {blob["name"]: blob for blob in blobs}
    reference_names = {
        "digits_reverse_initial_token_expansion": "pinyin_digits_token_v_2",
        "pinyin_initial_token_expansion": "pinyin_token_v_2",
        "pinyin_reverse_initial_token_expansion": "pinyin_token_v_2",
    }
    for name in by_name:
        if name.startswith("pinyin_fuzzy_expansion_"):
            reference_names[name] = "pinyin_token_v_2"

    for expansion_name, dictionary_name in reference_names.items():
        expansion = by_name.get(expansion_name)
        dictionary = by_name.get(dictionary_name)
        if expansion is None or dictionary is None:
            continue
        entries = dictionary["native_container"].get("token_entries", [])
        token_to_key: dict[int, str] = {}
        duplicate_token_ids: set[int] = set()
        for entry in entries:
            token_id = entry["token_id"]
            if token_id in token_to_key:
                duplicate_token_ids.add(token_id)
            token_to_key[token_id] = entry["key"]
        container = expansion["native_container"]
        source_ids = container["source_token_ids"]
        target_ids = container["target_token_ids"]
        unresolved_source_ids = sorted(set(source_ids) - token_to_key.keys())
        unresolved_target_ids = sorted(set(target_ids) - token_to_key.keys())
        container["token_reference"] = {
            "dictionary_name": dictionary_name,
            "dictionary_token_id_count": len(token_to_key),
            "duplicate_dictionary_token_ids": sorted(duplicate_token_ids),
            "resolved_source_token_id_count": len(source_ids)
            - len(unresolved_source_ids),
            "resolved_target_token_id_count": len(target_ids)
            - len(unresolved_target_ids),
            "unresolved_source_token_ids": unresolved_source_ids,
            "unresolved_target_token_ids": unresolved_target_ids,
            "resolved_source_keys": sorted(
                token_to_key[token_id]
                for token_id in source_ids
                if token_id in token_to_key
            ),
            "resolved_target_keys": sorted(
                token_to_key[token_id]
                for token_id in target_ids
                if token_id in token_to_key
            ),
            "resolved_records": [
                {
                    "source_token_id": record["source_token_id"],
                    "source_key": token_to_key.get(record["source_token_id"]),
                    "targets": [
                        {
                            **target,
                            "target_key": token_to_key.get(target["target_token_id"]),
                        }
                        for target in record["targets"]
                    ],
                }
                for record in container["records"]
            ],
        }


def analyze_bundle(
    library_name: str, library_content: bytes, output_dir: Path
) -> dict[str, Any]:
    with tempfile.TemporaryDirectory(prefix="pinyin-data-bundle-") as temp_dir:
        library_path = Path(temp_dir) / library_name
        library_path.write_bytes(library_content)
        binary = lief.ELF.parse(str(library_path))
        if binary is None:
            raise ValueError(f"LIEF could not parse {library_name}")

        pairs = collect_symbol_pairs(binary)
        known_blob_names = {name for name, _, _ in pairs}
        library_output_dir = output_dir / library_name.removesuffix(".so")
        library_output_dir.mkdir(parents=True, exist_ok=True)
        blobs: list[dict[str, Any]] = []
        for name, start, end in pairs:
            size = end - start
            content = bytes(binary.get_content_from_virtual_address(start, size))
            if len(content) != size:
                raise ValueError(
                    f"short virtual read for {name}: expected {size}, got {len(content)}"
                )
            section = containing_section(binary, start, end)
            output_path = library_output_dir / f"{name}.bin"
            output_path.write_bytes(content)

            try:
                fields = parse_protobuf_wire(content)
            except ValueError:
                fields = None
            data_scheme = (
                decode_data_scheme(fields, known_blob_names) if fields is not None else None
            )
            strings = sorted(set(utf8_leaf_strings(content))) if fields is not None else []
            classification = classify_blob(content, fields)
            blobs.append(
                {
                    "name": name,
                    "start_symbol": f"{START_PREFIX}{name}{START_SUFFIX}",
                    "end_symbol": f"{START_PREFIX}{name}{END_SUFFIX}",
                    "virtual_address_start": start,
                    "virtual_address_end": end,
                    "file_offset_start": section.offset
                    + (start - section.virtual_address),
                    "size": size,
                    "section": section.name,
                    "sha256": sha256_bytes(content),
                    "head_hex": content[:32].hex(),
                    "shannon_entropy": shannon_entropy(content),
                    "classification": classification,
                    "recognized_markers": marker_records(content),
                    "native_container": analyze_native_container(content, classification),
                    "protobuf": (
                        protobuf_summary(fields, len(content))
                        if fields is not None
                        else None
                    ),
                    "protobuf_utf8_leaf_strings": strings,
                    "data_scheme": data_scheme,
                    "output_file": output_path.relative_to(output_dir).as_posix(),
                }
            )

        add_expansion_token_references(blobs)

    gaps = [
        current[1] - previous[2]
        for previous, current in zip(pairs, pairs[1:])
        if current[1] > previous[2]
    ]
    classifications = Counter(blob["classification"] for blob in blobs)
    return {
        "file_name": library_name,
        "size": len(library_content),
        "sha256": sha256_bytes(library_content),
        "blob_count": len(blobs),
        "named_payload_bytes": sum(blob["size"] for blob in blobs),
        "inter_blob_padding_bytes": sum(gaps),
        "classification_counts": dict(sorted(classifications.items())),
        "blobs": blobs,
    }


def main() -> None:
    args = parse_args()
    apk_content = args.apk.read_bytes()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    libraries: list[dict[str, Any]] = []
    with zipfile.ZipFile(args.apk) as archive:
        names = set(archive.namelist())
        for library_name in DATA_BUNDLE_NAMES:
            archive_name = f"lib/arm64-v8a/{library_name}"
            if archive_name not in names:
                raise ValueError(f"missing APK entry: {archive_name}")
            libraries.append(
                analyze_bundle(
                    library_name, archive.read(archive_name), args.output_dir
                )
            )

    manifest = {
        "schema_version": 2,
        "source_apk": {
            "path": args.apk.as_posix(),
            "size": len(apk_content),
            "sha256": sha256_bytes(apk_content),
        },
        "bundle_count": len(libraries),
        "blob_count": sum(library["blob_count"] for library in libraries),
        "libraries": libraries,
    }
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    args.manifest.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    print(
        f"extracted {manifest['blob_count']} blobs from "
        f"{manifest['bundle_count']} data bundles"
    )


if __name__ == "__main__":
    main()
