"""Check real fixed-APK metadata against frozen Itanium ABI records."""
import sys
from pathlib import Path
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "research/native-rewrite/tools"))
from map_cpp_types import analyze_types, direct_function_references, unwind_function_ranges
from map_jni_registration import ElfImage


class CppTypesTest(unittest.TestCase):
    def test_dictionary_accessor_metadata_exposes_both_base_offsets(self):
        apk = ROOT / "original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk"
        with zipfile.ZipFile(apk) as archive:
            image = ElfImage(archive.read("lib/arm64-v8a/libhmm_gesture_hwr_zh.so"))
        result = analyze_types(image)
        types = {item["mangled_name"]: item for item in result["types"]}
        decoder = types["N10i18n_input6engine3hmm16TokenDecoderBaseE"]
        self.assertEqual(decoder["typeinfo_address"], 0x68AA90)
        accessor = types["N10i18n_input6engine3hmm25MutableDictionaryAccessorE"]
        self.assertEqual([(base["mangled_name"], base["offset"], base["public"]) for base in accessor["bases"]], [
            ("N10i18n_input6engine3hmm34MutableDictionaryAccessorInterfaceE", 0, True),
            ("N10i18n_input6engine3hmm15SettingDelegateE", 8, True),
        ])
        primary = next(table for table in result["vtable_candidates"]
                       if table["mangled_name"] == accessor["mangled_name"] and table["offset_to_top"] == 0)
        self.assertEqual(primary["address_point"], 0x67A060)

    def test_expander_callers_have_exact_unwind_function_ranges(self):
        apk = ROOT / "original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk"
        with zipfile.ZipFile(apk) as archive:
            image = ElfImage(archive.read("lib/arm64-v8a/libhmm_gesture_hwr_zh.so"))
        ranges = unwind_function_ranges(image)
        client = next(item for item in ranges if item["start"] == 0x18CAA0)
        self.assertEqual((client["start"], client["end"]), (0x18CAA0, 0x18CBAC))
        references = direct_function_references(image, ranges)
        callers = [(item["address"], item["source_function"]) for item in references if item["target"] == 0x18CAA0]
        self.assertEqual(callers, [(0x18BEBC, 0x18BE20), (0x18CBF4, 0x18CBAC)])


if __name__ == "__main__":
    unittest.main()
