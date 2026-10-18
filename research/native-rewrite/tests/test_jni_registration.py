"""Real-APK JNI mapping through the two command-line entry points.

The baseline is the fixed 4.5.2 APK. Golden addresses are literal entries in
its relocation table; this is not an execution/equivalence test of the engine.
"""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[3]
TOOLS = ROOT / "research/native-rewrite/tools"


class JniRegistrationTest(unittest.TestCase):
    def test_fixed_apk_maps_candidate_and_dictionary_entry_points(self):
        apk = ROOT / "original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk"
        jar = ROOT / "work/tools/apktool.jar"
        java_home = os.environ.get("JAVA_HOME")
        java = str(Path(java_home) / "bin" / ("java.exe" if os.name == "nt" else "java")) if java_home else "java"
        work = ROOT / "work/native-rewrite"
        work.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="jni-test-", dir=work) as directory:
            folder = Path(directory)
            inventory, output = folder / "dex.tsv", folder / "jni.json"
            subprocess.run([java, "-cp", str(jar), str(TOOLS / "DexInventory.java"),
                            str(apk), str(inventory)], check=True, timeout=120)
            subprocess.run([sys.executable, str(TOOLS / "map_jni_registration.py"),
                            "--apk", str(apk), "--dex-inventory", str(inventory),
                            "--output", str(output)], check=True, timeout=120)
            result = json.loads(output.read_text(encoding="utf-8"))
        methods = {item["identity"]: item for item in result["native_methods"]}
        self.assertEqual(len(methods), 180)  # Established native-boundary baseline.
        self.assertTrue(all(item["bindings"] for item in methods.values()))
        hmm = "Lcom/google/android/apps/inputmethod/libs/hmm/HmmEngineInterfaceImpl;->"
        dictionary = "Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterfaceImpl;->"
        fill = methods[hmm + "nativeFillCandidateList(JLcom/google/android/apps/inputmethod/libs/hmm/Range;)Z"]
        self.assertEqual([(binding["table_slot"], binding["function_address"]) for binding in fill["bindings"]],
                         [(0x69A6A8, 0x10ED48)])
        self.assertEqual([binding["function_address"] for binding in methods[hmm + "nativeClose(J)V"]["bindings"]],
                         [0x10DDC8])
        self.assertEqual([binding["function_address"] for binding in methods[dictionary + "nativeClose(J)V"]["bindings"]],
                         [0x10E680])
        self.assertEqual([binding["function_address"] for binding in methods[hmm + "nativeReset(J)V"]["bindings"]],
                         [0x10DE94])


if __name__ == "__main__":
    unittest.main()
