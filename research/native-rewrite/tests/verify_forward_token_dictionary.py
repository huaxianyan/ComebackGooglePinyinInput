#!/usr/bin/env python3
"""Drive the real C++ reader from original-resource wire-decoder expectations."""
import argparse
import json
from pathlib import Path
import subprocess


def token_setting_slice(content):
    # Fixed SettingScheme has only length-delimited top-level fields. Extract
    # field 2 independently; C++ parses the original nested message itself.
    offset = 0
    def varint():
        nonlocal offset
        value, shift = 0, 0
        while True:
            byte = content[offset]
            offset += 1
            value |= (byte & 127) << shift
            if byte < 128:
                return value
            shift += 7
    while offset < len(content):
        tag = varint()
        if tag & 7 != 2:
            raise ValueError("unexpected original SettingScheme field type")
        size = varint()
        value = content[offset:offset + size]
        offset += size
        if tag >> 3 == 2:
            return value
    raise ValueError("original SettingScheme has no token setting")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--executable", type=Path, required=True)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--case", choices=("source", "target", "manager"))
    args = parser.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    if manifest["schema_version"] != 3:
        raise ValueError("regenerate the manifest with native five-table schema 3")
    rows = []
    profiles = 0
    for library in manifest["libraries"]:
        for blob in library["blobs"]:
            container = blob.get("native_container") or {}
            path = (args.manifest.parent / blob["output_file"]).resolve()
            if not container.get("packed_tables"):
                continue
            profiles += 1
            if args.case == "manager":
                continue
            fields = {field["field_number"]: field["value"]
                      for field in container["token_config"]["config_fields"] if "value" in field}
            for row in container["token_entries"]:
                # IDs and column values come from the independent Python integer
                # decoder and original bytes, not the C++ lookup/codec algorithm.
                rows.append("\t".join(str(value) for value in (
                    blob["name"], path, fields[1], fields[4], container["prefix_scores"]["count"],
                    row["marisa_key_id"], row["key"], row["token_id"], row.get("token_score", "-"),
                    row["token_meta"], row["token_code"], row["token_node_id"])))
    if profiles != 8:
        raise ValueError("expected the eight ordinary Forward resources in the fixed original APK")
    args.fixture.parent.mkdir(parents=True, exist_ok=True)
    if args.case == "manager":
        for library in manifest["libraries"]:
            for blob in library["blobs"]:
                source = (args.manifest.parent / blob["output_file"]).resolve()
                rows.append(f"@blob:{library['file_name']}/{blob['name']}\t{source}")
                if blob["name"] in ("en_data_scheme", "data_scheme", "gesture_data_scheme"):
                    rows.append(f"@scheme:{blob['name']}\t{source}")
                if blob["name"] == "pinyin_qwerty_setting_scheme":
                    path = args.fixture.with_suffix(".setting.pb").resolve()
                    path.write_bytes(token_setting_slice(source.read_bytes()))
                    rows.append(f"@token_setting\t{path}")
    args.fixture.write_text("\n".join(rows) + "\n", encoding="utf-8")
    command = [str(args.executable.resolve()), str(args.fixture.resolve())]
    if args.case:
        command.append(args.case)
    subprocess.run(command, check=True)


if __name__ == "__main__":
    main()
