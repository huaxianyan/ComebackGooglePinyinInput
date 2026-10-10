#!/usr/bin/env python3
"""Regression fixtures for branch checks on source and final DEX decoding."""
import unittest

from verify_modern_settings_runtime import require_branch_target, verify_opaque_predictive_transition


class BranchTargetTest(unittest.TestCase):
    def test_accepts_source_and_decoder_labels(self):
        for target in (":legacy_guide", ":cond_0"):
            with self.subTest(target=target):
                require_branch_target(
                    f"if-eqz v7, {target}\n\n{target}\nreturn-void",
                    r"if-eqz v7, ",
                    "fixture",
                )

    def test_rejects_inverted_condition_and_undefined_target(self):
        for text in (
            "if-nez v7, :cond_0\n:cond_0",
            "if-eqz v7, :missing\n:cond_0",
        ):
            with self.subTest(text=text), self.assertRaises(RuntimeError):
                require_branch_target(text, r"if-eqz v7, ", "fixture")


class PredictiveTransitionTest(unittest.TestCase):
    def test_keeps_preview_opaque_while_click_navigation_can_fade(self):
        preview = """
        if (backPhase != SettingsBackPhase.Idle) {
            slideInHorizontally(tween(300, easing = LinearEasing))
            slideOutHorizontally(tween(300, easing = LinearEasing))
            targetContentZIndex = if (returning) -1f else 1f
        } else {
            fadeIn(tween(220)) togetherWith fadeOut(tween(140))
        }
        """
        verify_opaque_predictive_transition(preview)
        with self.assertRaises(RuntimeError):
            verify_opaque_predictive_transition(
                preview.replace("slideInHorizontally", "fadeIn(tween(220)) + slideInHorizontally")
            )


if __name__ == "__main__":
    unittest.main()
