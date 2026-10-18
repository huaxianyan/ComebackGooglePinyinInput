"""Fixed-APK evidence for the direct mapping export, not a runtime decoder test."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "research/native-rewrite/tools"))
from extract_data_bundles import (
    analyze_direct_mapping_lookup, direct_mapping_position, unpack_lsb_bits,
)


class DirectMappingExportTest(unittest.TestCase):
    def test_unpack_values_crossing_byte_boundaries(self):
        self.assertEqual(unpack_lsb_bits(bytes.fromhex("41 0c"), 3, 5), [1, 2, 3])

    def test_lookup_english_ranges_preserves_native_gaps_and_input_mask(self):
        # Range boundaries and low-21-bit masking come from 0x19cfac.
        for query, expected in [(65, 0), (90, 25), (91, None), (96, None),
                                (97, 26), (122, 51), (123, None), (0x800061, 26)]:
            with self.subTest(query=query):
                self.assertEqual(direct_mapping_position(
                    query, [65, 97, 122], [0, 26, 51]
                ), expected)

    def test_indirect_entry_uses_count_byte_then_decodes_target_score(self):
        result = analyze_direct_mapping_lookup(
            [48, 49], [0, 1], [0x80000002, 0x08800031, 0x08800030], [1, 255, 1]
        )
        self.assertEqual(result["records"], [
            {"source_key_id": 48, "base_position": 0, "target_start": 2,
             "targets": [{"target_token_id": 0x08800030, "score_code": 1,
                          "score_float32": -0.0784313753247261}]},
            {"source_key_id": 49, "base_position": 1, "target_start": 1,
             "targets": [{"target_token_id": 0x08800031, "score_code": 255,
                          "score_float32": -20.0}]},
        ])

    def test_export_original_apk_recovers_layouts_and_reconversion_token_targets(self):
        work = ROOT / "work/native-rewrite"
        work.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="direct-mapping-test-", dir=work) as tmp:
            manifest = Path(tmp) / "manifest.json"
            subprocess.run([
                sys.executable,
                str(ROOT / "research/native-rewrite/tools/extract_data_bundles.py"),
                "--apk", str(ROOT / "original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk"),
                "--output-dir", str(Path(tmp) / "blobs"),
                "--manifest", str(manifest),
            ], cwd=ROOT, check=True)
            result = json.loads(manifest.read_text(encoding="utf-8"))

        blobs = {
            b["name"]: b for library in result["libraries"] for b in library["blobs"]
            if b["classification"] == "direct_mapping_token_expander"
        }
        # Independently recorded byte offsets/counts from the original blob inspection.
        english = [(48, 3, 7), (64, 3, 6), (80, 52, 32), (296, 52, 8)]
        expected = {
            "en_reconversion_expansion": english,
            "english_reconversion_expansion": english,
            "digits_reconversion_expansion": [(48, 2, 6), (64, 2, 4), (80, 10, 32), (128, 10, 8)],
            "pinyin_reconversion_expansion": [(48, 1736, 18), (3968, 1736, 15), (7232, 27701, 32), (118048, 27701, 8)],
        }
        self.assertEqual(set(blobs), set(expected))
        order = ("key_ids", "start_positions", "target_words", "score_bytes")
        for name, layout in expected.items():
            with self.subTest(blob=name):
                container = blobs[name]["native_container"]
                tables = container["tables"]
                self.assertEqual([
                    (tables[k]["offset"], tables[k]["count"], tables[k]["bit_width"])
                    for k in order
                ], layout)
                self.assertEqual(tables["score_bytes"]["aligned_end"], blobs[name]["size"])
                self.assertTrue(container["fully_consumed"])
        en = blobs["en_reconversion_expansion"]["native_container"]["tables"]
        self.assertEqual(en["key_ids"]["values"], [65, 97, 122])
        self.assertEqual(en["start_positions"]["values"], [0, 26, 51])
        digits = blobs["digits_reconversion_expansion"]["native_container"]["tables"]
        self.assertEqual(digits["key_ids"]["values"], [48, 57])
        self.assertEqual(digits["start_positions"]["values"], [0, 9])
        pinyin = blobs["pinyin_reconversion_expansion"]["native_container"]["tables"]
        self.assertEqual(pinyin["target_words"]["high_byte_counts"], {"0": 26570, "2": 8, "128": 1123})
        self.assertEqual(pinyin["score_bytes"]["unique_count"], 138)
        for name in ("en_reconversion_expansion", "english_reconversion_expansion"):
            records = blobs[name]["native_container"]["lookup_analysis"]["records"]
            self.assertEqual([row["source_key_id"] for row in records],
                             list(range(65, 91)) + list(range(97, 123)))
            self.assertEqual(records[0]["targets"][0]["target_token_id"], 0x800061)
            self.assertEqual(records[-1]["targets"][0]["target_token_id"], 0x80007A)
        digits_container = blobs["digits_reconversion_expansion"]["native_container"]
        self.assertEqual(digits_container["lookup_analysis"]["source_count"], 10)
        self.assertEqual(digits_container["token_reference"]["unique_target_token_id_count"], 10)
        container = blobs["pinyin_reconversion_expansion"]["native_container"]
        analysis = container["lookup_analysis"]
        self.assertEqual(analysis["source_count"], 25379)
        self.assertEqual(analysis["target_count"], 26578)
        self.assertEqual(analysis["target_count_histogram"], {"1": 24256, "2": 1056, "3": 58, "4": 9})
        self.assertEqual(analysis["indirect_position_count"], 1123)
        self.assertEqual(analysis["unreferenced_word_count"], 0)
        self.assertEqual(analysis["count_and_score_position_overlap"], 0)
        self.assertEqual(container["token_reference"]["unique_target_token_id_count"], 421)
        self.assertEqual(container["token_reference"]["unresolved_target_token_ids"], [])
        # Raw sample IDs/codes were read independently from the blob before implementation.
        records = {row["source_key_id"]: row for row in analysis["records"]}
        self.assertEqual(records[0x91CD]["targets"], [
            {"target_token_id": 0x80E029, "target_key": "chong", "score_code": 11,
             "score_float32": -0.8627451062202454},
            {"target_token_id": 0x80E1A2, "target_key": "zhong", "score_code": 7,
             "score_float32": -0.5490196347236633},
        ])


if __name__ == "__main__":
    unittest.main()
