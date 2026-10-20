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
            0x1E3C68: ("mov", "w0, #0x40"),
            0x1E3CA4: ("mov", "x4, #8"),
            0x1E3CBC: ("ldr", "w4, [x22, #4]"),
            0x1F6C90: ("eor", "x2, x5, x2, lsr #8"),
            0x1F7458: ("str", "x2, [x1]"),
            0x1F974C: ("bl", "#0x1f8b88"),
            0x1F976C: ("str", "x2, [x1, #0x38]"),
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
            0x1D6EC0: ("cbz", "x20, #0x1d6ff8"),
            0x1D6F20: ("b.ne", "#0x1d6fe8"),
            0x1D6F84: ("bl", "#0x1d538c"),
            0x1D6F98: ("sub", "w1, w1, #1"),
            0x1D6F9C: ("str", "w1, [x0, #8]"),
            0x1D6FB8: ("bl", "#0x1d54f0"),
            0x1D6FCC: ("cmp", "w1, #1"),
            0x1D6FE0: ("bl", "#0x1d538c"),
            0x1D557C: ("cinc", "w3, w3, eq"),
            0x1D68D4: ("ldr", "x3, [x3, #0x68]"),
            0x1D6994: ("bl", "#0x1d66cc"),
            0x1D69E8: ("bl", "#0x1d4fe8"),
            0x1D6A14: ("str", "w23, [x0]"),
            0x1D6A24: ("str", "w0, [x27, #8]"),
            0x1D6A30: ("str", "s11, [x19, x6]"),
            0x1D6534: ("bl", "#0x1d5128"),
            0x1D65EC: ("str", "w24, [x7, #4]"),
            0x1D657C: ("bl", "#0x1d53e8"),
            0x1D6620: ("str", "w26, [x19, x0]"),
            0x1D6648: ("str", "w2, [x19, x0]"),
            0x1D666C: ("ldr", "x3, [x0, #0x20]"),
            0x1D679C: ("cmp", "w0, w26"),
            0x1D67A0: ("b.ge", "#0x1d67f0"),
            0x1D6824: ("mov", "w20, w0"),
            0x1D685C: ("str", "w20, [x19, #4]"),
            0x1C5558: ("ldr", "x4, [x1, #0x58]"),
            0x1C5624: ("mov", "w2, w23"),
            0x1C5630: ("bl", "#0x1c54ac"),
            0x1C5638: ("cbz", "w0, #0x1c5644"),
            0x1D63DC: ("bl", "#0x1d5654"),
            0x1DEB0C: ("bl", "#0x1de920"),
            0x1DE94C: ("cmp", "x0, #4"),
            0x1DE9C8: ("bl", "#0x73990"),
            0x1C54EC: ("bl", "#0x1c3b68"),
            0x1C5508: ("bl", "#0x1c51c4"),
            0x1D62F4: ("str", "w1, [x0]"),
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
            0x1DEC40: ("cbnz", "w0, #0x1dec88"),
            0x1DEC6C: ("mov", "x4, x24"),
            0x1DEC80: ("blr", "x6"),
            0x1DEE0C: ("b", "#0x1deca0"),
            0x1DEC38: ("blr", "x4"),
            0x1DEC54: ("bl", "#0x1deb4c"),
            0x1C5754: ("bl", "#0x1c54ac"),
            0x1C5774: ("bl", "#0x1c54ac"),
            0x1C577C: ("cbz", "w0, #0x1c57c8"),
            0x1C5798: ("bl", "#0x1c4348"),
            0x1C57C4: ("b", "#0x1c5974"),
            0x1C4564: ("mov", "w0, #0x10"),
            0x1C45B4: ("ldr", "x0, [sp, #0x60]"),
            0x1C45C0: ("strh", "w0, [x2, #-0x12]!"),
            0x1C45CC: ("bl", "#0x1c4348"),
            0x1C45D0: ("ldr", "x0, [x19, #0x18]"),
            0x1C57D4: ("cmp", "w0, #0x1fe"),
            0x1C57D8: ("b.hi", "#0x1c5930"),
            0x1C57E0: ("cmp", "w0, #0x1fe"),
            0x1C57E4: ("b.hi", "#0x1c5930"),
            0x1C591C: ("add", "w2, w2, #1"),
            0x1C5924: ("orr", "w3, w3, #0x10"),
            0x1C5934: ("cbnz", "w0, #0x1c5950"),
            0x1C5954: ("cbnz", "w20, #0x1c5738"),
            0x1C57C8: ("cmp", "w28, #1"),
            0x1C538C: ("cbz", "w0, #0x1c5358"),
            0x1C53CC: ("ldr", "x4, [x1, #8]"),
            0x1C53F8: ("ldr", "x3, [x1, #0x10]"),
            0x1C5434: ("cbz", "w1, #0x1c5474"),
            0x1C5484: ("str", "w2, [x1, #0x34]"),
            0x1C5488: ("orr", "w3, w3, #0x10"),
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
            0x1D395C: ("mov", "w0, #1"),
            0x1D3974: ("mov", "w0, #2"),
            0x1D398C: ("mov", "w0, #3"),
            0x1D3994: ("bl", "#0x2cb2d4"),
            0x1D39A4: ("mov", "w0, #4"),
            0x1D39AC: ("bl", "#0x2cb2d4"),
            0x1D39BC: ("mov", "w0, #5"),
            0x1D39D4: ("mov", "w0, #6"),
            0x1D3C18: ("stp", "xzr, xzr, [x0]"),
            0x2CB038: ("sxtw", "x1, w20"),
            0x1D5AE8: ("movk", "w0, #0x1fff, lsl #16"),
            0x1D5AF4: ("b.hi", "#0x1d5ab8"),
            0x1D5B54: ("mov", "x2, #0x218"),
            0x1D7A68: ("cmp", "w0, #0xff"),
            0x1D7AFC: ("bl", "#0x1d75cc"),
            0x1D7B10: ("bl", "#0x1d5434"),
            0x1D7B24: ("strb", "w0, [x25, #8]"),
            0x1D5480: ("b.hs", "#0x1d54b4"),
            0x1D77AC: ("cmp", "w25, #1"),
            0x1D7810: ("b.lo", "#0x1d7860"),
            0x1D78A8: ("b.lt", "#0x1d7904"),
            0x1F3034: ("mul", "w1, w2, w1"),
            0x1F30AC: ("stur", "x0, [x19, #0xc]"),
            0x1F30C4: ("str", "x1, [x19, #0x20]"),
            0x1F30CC: ("strb", "w0, [x19, #8]"),
            0x1F2D20: ("mov", "x1, #8"),
            0x1F2D60: ("mov", "x2, x20"),
            0x1F2EF4: ("ands", "x1, x0, #7"),
            0x1F2F04: ("add", "x0, x0, #8"),
            0x1F5E6C: ("cmp", "x19, x0"),
            0x1F5F0C: ("str", "x19, [x20]"),
            0x1F5F9C: ("add", "x1, x1, #0x7b0"),
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
        self.assertEqual(evidence["association_key_crc"], {
            "address": 0x34EAD0, "low": 0x9F18, "high": 0, "degree": 16,
        })
        self.assertEqual(evidence["table_crc64"], {
            "address": 0x34EF50, "low": 0xAB0547580DAAC74E, "high": 0, "degree": 64,
        })
        crc64 = {row["address"]: row["target"]
                 for row in evidence["relocation_regions"]["crc64"]}
        self.assertEqual({address: crc64[address] for address in (0x67E260, 0x67E268, 0x67E290)}, {
            0x67E260: 0x1F636C, 0x67E268: 0x1F6C44, 0x67E290: 0x1F96CC,
        })
        phrase = {row["address"]: row["target"]
                  for row in evidence["relocation_regions"]["fixed_phrase_table"]}
        self.assertEqual({address: phrase[address] for address in (0x67E100, 0x67E108, 0x67E110)}, {
            0x67E100: 0x1F3060, 0x67E108: 0x1F2D04, 0x67E110: 0x1F2EE0,
        })
        datrie = {row["address"]: row["target"]
                  for row in evidence["relocation_regions"]["datrie"]}
        self.assertEqual({address: datrie[address] for address in (0x67D5F8, 0x67D600, 0x67D608)}, {
            0x67D5F8: 0x1D7970, 0x67D600: 0x1D5A98, 0x67D608: 0x1D45F0,
        })
        metadata = {row["address"]: row["target"]
                    for row in evidence["relocation_regions"]["mutable_dictionary_metadata"]}
        self.assertEqual({address: metadata[address] for address in (0x68C9A0, 0x68C9E8, 0x68C9F8)}, {
            0x68C9A0: 0x1D3A2C, 0x68C9E8: 0x1D3F04, 0x68C9F8: 0x1D393C,
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
