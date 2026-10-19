"""Pin independently inspected ARM64 evidence through the APK export entry."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]


class DirectMappingNativeTest(unittest.TestCase):
    def test_export_original_apk_exposes_inspected_decoder_and_learning_paths(self):
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
            0x18C578: ("fmadd", "s0, s0, s1, s2"),
            0x18C60C: ("fmadd", "s1, s3, s0, s1"),
            0x18C628: ("ldr", "x2, [x1, #0x18]"),
            0x18C638: ("b.ne", "#0x18c650"),
            0x18D170: ("fadd", "s1, s1, s8"),
            0x18D1A4: ("add", "x4, x4, #0x28"),
            0x18D210: ("eor", "w6, w0, #1"),
            0x18D4C0: ("fsub", "s0, s0, s8"),
            0x18D4CC: ("b.mi", "#0x18d57c"),
            0x111FE0: ("ldr", "x7, [x0, #0x70]"),
            0x18A738: ("bl", "#0x18e380"),
            0x18A8A8: ("scvtf", "s0, w26"),
            0x18A8C0: ("fmul", "s0, s0, s1"),
            0x18A8D0: ("fcvtzs", "w5, s0"),
            0x18A8D8: ("csinc", "w5, w5, wzr, gt"),
            0x18A8DC: ("bl", "#0x1a1d9c"),
            0x1A1DF8: ("bl", "#0x1a1894"),
            0x1A1E2C: ("bl", "#0x1a1bb4"),
            0x1A1944: ("add", "w20, w20, w0"),
            0x1A1964: ("csel", "w19, w19, w1, le"),
            0x1A1CE8: ("ldr", "x8, [x1, #0x18]"),
            0x1A1D38: ("blr", "x7"),
            0x1A0CC4: ("subs", "x1, x2, w1, sxtw"),
            0x1A0CCC: ("csel", "x1, x1, xzr, pl"),
            0x1A0D00: ("sdiv", "x0, x0, x1"),
            0x1A08A0: ("strh", "w5, [sp, #0x4e]"),
            0x1A08E4: ("ubfiz", "w20, w20, #0x1c, #2"),
            0x1A08F0: ("csel", "w21, w21, w0, ls"),
            0x1A0664: ("and", "w0, w0, #0x7ffffff"),
            0x1A077C: ("and", "w0, w0, #0x3fffffff"),
            0x1A07B8: ("csel", "w0, wzr, w0, ne"),
            0x1C5F5C: ("mov", "w7, #1"),
            0x1C6048: ("mov", "w7, #2"),
            0x1A2270: ("mov", "w0, #3"),
            0x1A227C: ("mov", "w0, #1"),
            0x1A22C8: ("mov", "x1, #0x10"),
            0x1C3A04: ("and", "w0, w1, #0x1ff"),
            0x1C3A14: ("lsr", "w1, w1, #9"),
            0x1C438C: ("orr", "w3, w3, w4, lsl #9"),
            0x1C3A70: ("mov", "x0, #4"),
            0x1C8138: ("mov", "x0, #8"),
            0x1C3BF8: ("cmp", "w1, w24"),
            0x1C808C: ("cmp", "w25, w0"),
            0x1E3F54: ("orr", "w20, w20, #0x80000000"),
            0x1E3FAC: ("and", "w0, w1, #0x7fffffff"),
            0x1E407C: ("and", "w3, w3, #3"),
            0x1E40B4: ("ubfx", "x1, x1, #2, #0x1d"),
            0x1E4564: ("orr", "w1, w1, w3, lsl #2"),
            0x1E3C28: ("str", "w1, [x0, #4]"),
            0x1E3C30: ("str", "w1, [x0]"),
            0x1E3C38: ("str", "wzr, [x0, #4]"),
            0x1E4AD8: ("ldr", "x0, [x19]"),
            0x1E4AE0: ("str", "w4, [x19, #4]"),
            0x1E4AE8: ("asr", "x0, x0, #0x20"),
            0x1E4AF0: ("sub", "x0, x0, x4"),
            0x1E4C24: ("add", "w19, w19, w21, lsl #1"),
            0x1E4C28: ("fmov", "d1, #1.25000000"),
            0x1E4C40: ("add", "w19, w19, w0"),
            0x1E4C60: ("str", "x0, [x20, #0x10]"),
            0x1E4CA8: ("str", "w0, [x28, #4]"),
            0x1E4CC8: ("bl", "#0x1e3f18"),
            0x1FA6D4: ("cmp", "w0, #1"),
            0x1FA718: ("mov", "w3, #1"),
            0x1FA780: ("mov", "w2, #0"),
            0x1FA880: ("str", "x1, [x0]"),
            0x1FA888: ("str", "x3, [x0, #0x10]"),
            0x1FA8D0: ("cbz", "x2, #0x1fa914"),
            0x1D521C: ("mov", "x1, #0x218"),
            0x1D52B8: ("strb", "w2, [x0, #0x114]"),
            0x1D52C4: ("strb", "w1, [x0, #0x14]"),
            0x1D51CC: ("bl", "#0x1d5128"),
            0x1D51D4: ("str", "w20, [x19, #0xc]"),
            0x1D5428: ("str", "w2, [x0, #4]"),
            0x1D542C: ("str", "w2, [x3, x4]"),
            0x1D5604: ("ldrb", "w0, [x0, #0x14]"),
            0x1D562C: ("str", "w0, [x22, w4, sxtw #2]"),
            0x1D4EA8: ("add", "w22, w21, #0x100"),
            0x1D4EB8: ("b.lt", "#0x1d4f48"),
            0x1D4EC4: ("fmov", "d1, #1.25000000"),
            0x1D4F18: ("mov", "w1, #0xff"),
            0x1D4FB0: ("str", "w22, [x26, #0xc]"),
            0x1D50A8: ("tbz", "w0, #0x1f, #0x1d50bc"),
            0x1D50E4: ("b.hs", "#0x1d50f0"),
            0x1D5140: ("str", "w0, [x3, #4]"),
            0x1D5150: ("str", "w1, [x2, x0]"),
            0x1D4C18: ("ldrb", "w0, [x0, #0x114]"),
            0x1D4E24: ("mov", "w3, #1"),
            0x1D4DA0: ("add", "w3, w6, w3"),
            0x1D4DB4: ("cmp", "w1, w19"),
            0x1D54E4: ("cset", "w3, le"),
            0x1D56A8: ("cmp", "w0, w20"),
            0x1D597C: ("str", "w23, [x20, x0]"),
            0x1DEBA0: ("blr", "x23"),
            0x1DEBC0: ("cmp", "x0, #4"),
            0x1DEBE4: ("str", "w21, [x0]"),
            0x1DECD0: ("cmp", "x0, #4"),
            0x1DECF4: ("ldr", "w1, [x0]"),
            0x1DED1C: ("cmp", "x0, x1"),
            0x1DED4C: ("bl", "#0x1f5ca4"),
            0x1DEC38: ("blr", "x4"),
            0x1DEC54: ("bl", "#0x1deb4c"),
            0x1C5294: ("bl", "#0x1e4870"),
            0x1E48C4: ("str", "w2, [x20, #4]"),
            0x1E49CC: ("str", "w0, [x20]"),
            0x1E49DC: ("str", "w0, [x20, #4]"),
            0x1E49E4: ("bl", "#0x1e47e4"),
            0x1E4A00: ("cset", "w0, le"),
            0x1C5484: ("str", "w2, [x1, #0x34]"),
            0x1C5488: ("orr", "w3, w3, #0x10"),
            0x1C5150: ("ldr", "x24, [x0, #0x58]"),
            0x1C5178: ("blr", "x24"),
            0x1C5198: ("bl", "#0x1e4dd4"),
            0x1C51A4: ("bl", "#0x1e4e3c"),
            0x1E4F10: ("bl", "#0x1e47e4"),
            0x1E4F30: ("b.ge", "#0x1e4f80"),
            0x1E4F8C: ("bl", "#0x1e4b44"),
            0x1E4FD4: ("bl", "#0x1e3f18"),
            0x1F31A4: ("cmp", "x2, x4"),
            0x1F3210: ("str", "w0, [x19, #0xc]"),
            0x1F321C: ("str", "x0, [x19, #0x20]"),
            0x1F3228: ("sub", "x0, x0, x1"),
            0x1F313C: ("ucvtf", "d0, x0"),
            0x1F314C: ("fcvtzu", "x1, d0"),
            0x1FA690: ("mov", "w1, #0"),
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
        self.assertEqual(evidence["dictionary_header_crc"], {
            "address": 0x34EC50, "low": 0xB9E50C1D, "high": 0, "degree": 32,
        })
        math = evidence["score_math"]
        self.assertEqual(math["table_address"], 0x3A2FC0)
        self.assertEqual(math["constants"]["Ln2"]["bits"], 0x3F317218)
        self.assertEqual(math["constants"]["ExpBias"]["bits"], 0x43BF8000)
        self.assertEqual(math["normalization_cutoff"]["bits"], 0xC0133333)
        self.assertEqual(math["tables"]["LogMantissa"]["words"][0], 0)
        self.assertEqual(math["tables"]["ExpResidual"]["words"][0], 0x3F800000)
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
