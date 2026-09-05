"""Pin independently inspected ARM64 evidence through the APK export entry."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]


class DirectMappingNativeTest(unittest.TestCase):
    def test_export_original_apk_contains_lookup_indirection_and_metadata_branches(self):
        work = ROOT / "work/native-rewrite"
        work.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="direct-native-test-", dir=work) as tmp:
            output = Path(tmp) / "evidence.json"
            subprocess.run([
                sys.executable,
                str(ROOT / "research/native-rewrite/tools/disassemble_direct_mapping.py"),
                "--apk", str(ROOT / "original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk"),
                "--output", str(output),
            ], cwd=ROOT, check=True)
            evidence = json.loads(output.read_text(encoding="utf-8"))
        instructions = {
            ins["address"]: (ins["mnemonic"], ins["operands"])
            for region in evidence["regions"].values() for ins in region["instructions"]
        }
        # Literal observations from the initial independent disassembly.
        expected = {
            0x19CFE0: ("and", "w19, w1, #0x1fffff"),
            0x19D00C: ("b.hs", "#0x19d01c"),
            0x19D088: ("b.lo", "#0x19d0bc"),
            0x19CC04: ("tbz", "w3, #0x1f, #0x19cc20"),
            0x19CC0C: ("and", "x3, x3, #0x7fffffff"),
            0x19CC10: ("ldrb", "w0, [x0, x4]"),
            0x19CC14: ("str", "w0, [x2]"),
            0x19CC20: ("mov", "w0, #1"),
            0x19CD54: ("fneg", "s0, s0"),
            0x19D27C: ("cbz", "w0, #0x19d42c"),
            0x19D438: ("add", "x0, x0, #0x4d0"),
        }
        for address, instruction in expected.items():
            with self.subTest(address=hex(address)):
                self.assertEqual(instructions[address], instruction)
        self.assertIn("meta data table", evidence["diagnostics"]["0x32c4d0"])


if __name__ == "__main__":
    unittest.main()
