"""Finite scalar anchors for source rebuilt from the fixed ARM64 math routines.

Build score_math_probe with the documented source-only command before this test.
These anchors are static deductions from the original constants/table zero cells,
not an assertion that a full native execution/equivalence test has been completed.
"""
from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[3]


class RecoveredScoreMathTest(unittest.TestCase):
    def test_source_probe_adds_equal_scores_and_keeps_the_dominant_separated_score(self):
        linux_root = subprocess.check_output(
            ["wsl.exe", "-d", "Ubuntu", "--exec", "wslpath", "-u", str(ROOT)],
            text=True, encoding="utf-8", timeout=15).strip()
        command = ["wsl.exe", "-d", "Ubuntu", "--exec",
                   linux_root + "/work/native-rewrite/recovered-score/score_math_probe"]
        # Native ln(2) literal: 0x18c61c = 0x3f317218. exp(0) and log(2)
        # use zero-residual lookup cells. The separated cases take the 126 cutoff.
        cases = [
            ("0", "0", "3f317218"),
            ("-0x1.62e430p-1", "-0x1.62e430p-1", "00000000"),
            ("-3", "-100", "c0400000"),
            ("-100", "-3", "c0400000"),
        ]
        for left, right, expected in cases:
            with self.subTest(left=left, right=right):
                observed = subprocess.check_output(command + [left, right], text=True,
                                                   encoding="utf-8", timeout=15).strip()
                self.assertEqual(observed, expected)


if __name__ == "__main__":
    unittest.main()
