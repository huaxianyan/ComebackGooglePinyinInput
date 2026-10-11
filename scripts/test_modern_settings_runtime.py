#!/usr/bin/env python3
"""Regression fixtures for final DEX branches and readable Back motion."""
import unittest
from verify_modern_settings_runtime import require_branch_target, verify_motion_timing


class BranchTargetTest(unittest.TestCase):
    def test_accepts_source_and_decoder_labels(self):
        for target in (":legacy_guide", ":cond_0"):
            with self.subTest(target=target):
                require_branch_target(
                    f"if-eqz v7, {target}\n\n{target}\nreturn-void", r"if-eqz v7, ", "fixture"
                )

    def test_rejects_inverted_condition_and_undefined_target(self):
        for text in ("if-nez v7, :cond_0\n:cond_0", "if-eqz v7, :missing\n:cond_0"):
            with self.subTest(text=text), self.assertRaises(RuntimeError):
                require_branch_target(text, r"if-eqz v7, ", "fixture")


class ReadableBackMotionTest(unittest.TestCase):
    def test_both_pages_remain_readable_halfway_through_back(self):
        valid = """<resources>
        <integer name="settings_motion_foreground_duration">300</integer>
        <integer name="settings_motion_fade_duration">90</integer>
        <integer name="settings_motion_foreground_fade_delay">210</integer>
        </resources>"""
        verify_motion_timing(valid)
        reported_gap = """<resources>
        <integer name="settings_motion_foreground_duration">300</integer>
        <integer name="settings_motion_fade_duration">220</integer>
        <integer name="settings_motion_foreground_fade_delay">60</integer>
        </resources>"""
        with self.assertRaises(RuntimeError):
            verify_motion_timing(reported_gap)


if __name__ == "__main__":
    unittest.main()
