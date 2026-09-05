"""Fixed-APK evidence for the direct mapping export, not a runtime decoder test."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "research/native-rewrite/tools"))
from extract_data_bundles import unpack_lsb_bits


class DirectMappingExportTest(unittest.TestCase):
    def test_unpack_values_crossing_byte_boundaries(self):
        self.assertEqual(unpack_lsb_bits(bytes.fromhex("41 0c"), 3, 5), [1, 2, 3])

    def test_export_original_apk_produces_four_complete_direct_mapping_layouts(self):
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


if __name__ == "__main__":
    unittest.main()
