"""Pin independently inspected ARM64 evidence through the APK export entry."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]


class DirectMappingNativeTest(unittest.TestCase):
    def test_export_original_apk_recovers_manager_identity_and_category_requests(self):
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
            0x19C944: ("strb", "wzr, [x0, #0x48]"),
            0x19C964: ("sub", "w0, w0, #1"),
            0x19C970: ("add", "x0, x0, #1"),
            0x19C98C: ("cbnz", "w2, #0x19c998"),
            0x19C994: ("eor", "w1, w1, #1"),
            0x19CB60: ("add", "x2, x20, #0x68"),
            0x19CBCC: ("b", "#0x1d1e50"),
            0x1D1E54: ("mov", "w3, #1"),
            0x1D1E58: ("fmov", "s0, #20.00000000"),
            0x1D1E5C: ("mov", "w1, #8"),
            0x1D1E18: ("fdiv", "s1, s8, s1"),
            0x1D1E30: ("fmul", "s0, s1, s0"),
            0x19F534: ("ldr", "w1, [x19, #0x18]"),
            0x19F550: ("mov", "w0, #2"),
            0x19F568: ("mov", "w0, #3"),
            0x19F580: ("mov", "w0, #4"),
            0x19F79C: ("cmp", "w0, #4"),
            0x19FB24: ("str", "w24, [x20, #0x18]"),
            0x19FBA8: ("str", "w0, [x20, #0x1c]"),
            0x19FBDC: ("str", "w0, [x20, #0x20]"),
            0x19FC38: ("strb", "w0, [x20, #0x24]"),
            0x19D114: ("ubfx", "x3, x1, #0x1c, #3"),
            0x19D120: ("cmn", "w2, #1"),
            0x19D13C: ("cset", "w20, eq"),
            0x19D148: ("cmp", "w3, #0x1a"),
            0x19D178: ("ldrb", "w0, [x0, #0x34]"),
            0x196E4C: ("ldr", "x1, [x1, #0x38]"),
            0x196E58: ("cbnz", "w0, #0x196ea8"),
            0x196BAC: ("bl", "#0x196874"),
            0x196A2C: ("fadd", "s8, s0, s8"),
            0x196A84: ("b.mi", "#0x196ac8"),
            0x196AC8: ("str", "s8, [x1, #0x20]"),
            0x1966A8: ("ldrsh", "w5, [x0, #0x1c]"),
            0x1966B8: ("b.lt", "#0x1966f0"),
            0x1966C0: ("ldr", "w5, [x0, #0x18]"),
            0x1966D0: ("b.lo", "#0x1966f0"),
            0x1966E0: ("and", "w6, w0, #1"),
            0x1966E4: ("and", "w5, w2, #1"),
            0x18CAC4: ("mov", "w0, #3"),
            0x18CAF8: ("str", "x0, [x19, #0x10]"),
            0x18CB14: ("mov", "w0, #4"),
            0x18CB3C: ("str", "x0, [x19, #0x18]"),
            0x18CB58: ("mov", "w0, #1"),
            0x18CB80: ("str", "x0, [x19, #0x20]"),
            0x130170: ("mov", "w0, #2"),
        }
        for address, instruction in expected.items():
            with self.subTest(address=hex(address)):
                self.assertEqual(instructions[address], instruction)
        self.assertIn("meta data table", evidence["string_anchors"]["0x32c4d0"])
        self.assertEqual(evidence["string_anchors"]["0x32c89d"],
                         "i18n_input.engine.hmm.proto.TokenExpanderMetaData")
        relocations = {
            row["address"]: row["target"]
            for row in evidence["relocation_regions"]["direct_iterator"]
        }
        self.assertEqual(relocations, {
            0x67A7B0: 0x19D0F0,
            0x67A7B8: 0x19CC8C,
            0x67A7C0: 0x19C93C,
            0x67A7C8: 0x19C984,
            0x67A7D0: 0x19C9A0,
            0x67A7D8: 0x19CC5C,
            0x67A7E0: 0x19CC6C,
        })
        manager = {row["address"]: row["target"]
                   for row in evidence["relocation_regions"]["manager_iterator"]}
        self.assertEqual(manager[0x67A488], 0x68AF40)
        self.assertEqual(manager[0x67A490], 0x196AF0)
        typeinfo = {row["address"]: row["target"]
                    for row in evidence["relocation_regions"]["manager_typeinfo"]}
        self.assertEqual(typeinfo[0x68AF48], 0x34A9E0)
        self.assertEqual(evidence["decoder_category_table"]["u32_values"], [1, 2])
        decoder_type = {row["address"]: row["target"]
                        for row in evidence["relocation_regions"]["token_decoder_typeinfo"]}
        self.assertEqual(decoder_type[0x68AA98], 0x349CE0)
        branches = evidence["direct_branch_references"]
        self.assertEqual([row["address"] for row in branches["manager_create_iterator"]],
                         [0x13018C, 0x1752A4, 0x18CAF0, 0x18CB34, 0x18CB78])
        self.assertEqual({(row["kind"], row["target"])
                          for row in branches["manager_create_iterator"]},
                         {("bl", 0x197348)})
        self.assertEqual(branches["triple_category_client"], [
            {"address": 0x18BEBC, "target": 0x18CAA0, "kind": "b"},
            {"address": 0x18CBF4, "target": 0x18CAA0, "kind": "b"},
        ])


if __name__ == "__main__":
    unittest.main()
