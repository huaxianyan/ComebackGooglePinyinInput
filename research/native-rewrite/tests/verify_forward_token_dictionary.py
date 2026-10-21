#!/usr/bin/env python3
"""Drive the real C++ reader from original-resource wire-decoder expectations."""
import argparse
import json
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--executable", type=Path, required=True)
    parser.add_argument("--fixture", type=Path, required=True)
    args = parser.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    if manifest["schema_version"] != 3:
        raise ValueError("regenerate the manifest with native five-table schema 3")
    rows = []
    profiles = 0
    for library in manifest["libraries"]:
        for blob in library["blobs"]:
            container = blob.get("native_container") or {}
            if not container.get("packed_tables"):
                continue
            fields = {field["field_number"]: field["value"]
                      for field in container["token_config"]["config_fields"] if "value" in field}
            path = (args.manifest.parent / blob["output_file"]).resolve()
            for row in container["token_entries"]:
                # IDs and column values come from the independent Python integer
                # decoder and original bytes, not the C++ lookup/codec algorithm.
                rows.append("\t".join(str(value) for value in (
                    blob["name"], path, fields[1], fields[4], container["prefix_scores"]["count"],
                    row["marisa_key_id"], row["key"], row["token_id"], row.get("token_score", "-"),
                    row["token_meta"], row["token_code"], row["token_node_id"])))
            profiles += 1
    if profiles != 8:
        raise ValueError("expected the eight ordinary Forward resources in the fixed original APK")
    args.fixture.parent.mkdir(parents=True, exist_ok=True)
    args.fixture.write_text("\n".join(rows) + "\n", encoding="utf-8")
    subprocess.run([str(args.executable.resolve()), str(args.fixture.resolve())], check=True)


if __name__ == "__main__":
    main()
