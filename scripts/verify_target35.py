#!/usr/bin/env python3
"""Verify the clean Android 15 visual-boundary baseline.

Target 35 V1 intentionally enables platform edge-to-edge and TextView behavior
without an opt-out or speculative candidate measurement changes. Device visual
comparison determines whether any narrow follow-up is necessary.
"""

from __future__ import annotations

import argparse
from pathlib import Path

FORBIDDEN_BASELINE_REFERENCES = {
    "windowOptOutEdgeToEdgeEnforcement": "temporary edge-to-edge opt-out",
    "setDecorFitsSystemWindows": "programmatic edge-to-edge override",
    "elegantTextHeight": "speculative TextView height compensation",
    "fallbackLineSpacing": "speculative TextView line-spacing compensation",
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    apktool = (decoded / "apktool.yml").read_text(encoding="utf-8")
    if "targetSdkVersion: 35" not in apktool:
        raise RuntimeError("Android 15 verifier requires targetSdkVersion 35")

    findings: list[str] = []
    for base, pattern in ((decoded / "smali", "*.smali"), (decoded / "res", "*.xml")):
        for path in base.rglob(pattern):
            text = path.read_text(encoding="utf-8", errors="ignore")
            for token, description in FORBIDDEN_BASELINE_REFERENCES.items():
                if token in text:
                    findings.append(f"{path}: {description} ({token})")
    if findings:
        raise RuntimeError(
            "Target 35 V1 must remain an unmasked platform-behavior baseline:\n"
            + "\n".join(findings)
        )

    # These pre-existing AppCompat layouts/listeners are part of the legacy UI,
    # not new target-35 compensation. Keep them present for an attributable
    # baseline rather than deleting framework inset behavior speculatively.
    toolbar = decoded / "res/layout-v26/abc_screen_toolbar.xml"
    if not toolbar.is_file() or 'android:fitsSystemWindows="true"' not in toolbar.read_text(
        encoding="utf-8"
    ):
        raise RuntimeError("Legacy AppCompat toolbar inset contract is missing")

    day = decoded / "res/values-v35"
    night = decoded / "res/values-night-v35"
    for directory, expected_light in ((day, "true"), (night, "false")):
        files = sorted(directory.glob("*.xml"))
        if not files:
            raise RuntimeError(f"Missing API 35 first-run style directory: {directory}")
        text = "\n".join(path.read_text(encoding="utf-8") for path in files)
        required = (
            'style name="AppThemeSelector.NoTitle"',
            "first_run_md3_surface",
            f'<item name="android:windowLightStatusBar">{expected_light}</item>',
            f'<item name="android:windowLightNavigationBar">{expected_light}</item>',
        )
        missing = [fragment for fragment in required if fragment not in text]
        if missing:
            raise RuntimeError(
                f"Incomplete API 35 first-run styles in {directory}: {missing}"
            )

    layout_v35 = decoded / "res/layout-v35"
    if layout_v35.exists() and any(layout_v35.rglob("*")):
        raise RuntimeError(
            "Unexpected target-35 layout override; V1 must preserve native keyboard, "
            "candidate and pager geometry"
        )

    print(
        "Android 15 baseline verified: target 35, enforced edge-to-edge is not "
        "opted out, API-35 day/night first-run styles are present, and no "
        "speculative TextView or layout compensation was introduced"
    )


if __name__ == "__main__":
    main()
