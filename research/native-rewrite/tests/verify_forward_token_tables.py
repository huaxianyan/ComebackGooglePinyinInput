"""One real mapped-table corpus entry; existing offline decoder is the oracle.

Run with the original-APK extraction manifest and compiled C++ probe. No token
text is printed. The bigint offline parser predates the recovered word decoder;
C++ literal fixtures independently cover zero/full widths and word crossing.
"""
import argparse
import json
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--data-dir", required=True, type=Path)
    parser.add_argument("--probe", required=True, type=Path)
    args = parser.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    dictionaries = tables = values = 0
    for library in manifest["libraries"]:
        for blob in library["blobs"]:
            if blob["classification"] != "forward_token_dictionary":
                continue
            container = blob["native_container"]
            if container["second_header_u64"] != 0:
                continue  # Stroke's independent format is outside this component.
            dictionaries += 1
            for name, table in sorted(container["packed_tables"].items()):
                field = name[:-1] if name.endswith("s") else name
                expected = [row[field] for row in container["token_entries"]]
                result = subprocess.run(
                    [str(args.probe), str(args.data_dir / blob["output_file"]),
                     str(table["data_offset"]), str(table["count"]), str(table["bit_width"])],
                    check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                    universal_newlines=True)
                actual = [int(line) for line in result.stdout.splitlines()]
                if actual != expected:
                    raise AssertionError("Mapped table differs from offline corpus: {} / {}".format(blob["name"], name))
                tables += 1
                values += len(expected)
    if dictionaries != 8:
        raise AssertionError("Expected the eight original normal-format token dictionaries")
    print("PASS: {} real dictionaries, {} mapped tables, {} values match the pre-existing offline decoder".format(
        dictionaries, tables, values))


if __name__ == "__main__":
    main()
