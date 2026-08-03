#!/usr/bin/env python3
"""Verify Android 14 dynamic-receiver and dynamic-code audit invariants."""

from __future__ import annotations

import argparse
from pathlib import Path

GSERVICES_ACTION = "com.google.gservices.intent.action.GSERVICES_CHANGED"
TWO_ARG_REGISTER = (
    "->registerReceiver(Landroid/content/BroadcastReceiver;"
    "Landroid/content/IntentFilter;)Landroid/content/Intent;"
)
FLAGS_REGISTER = (
    "->registerReceiver(Landroid/content/BroadcastReceiver;"
    "Landroid/content/IntentFilter;I)Landroid/content/Intent;"
)
EXPECTED_TWO_ARG_COUNTS = {
    "acz.smali": 2,  # ACTION_POWER_CONNECTED and sticky BATTERY_CHANGED
    "anw.smali": 1,  # USER_UNLOCKED
    "bfl.smali": 1,  # PACKAGE_ADDED
    "btp.smali": 1,  # pre-API-33 GServices compatibility path
    "bwk.smali": 1,  # SCREEN_ON/OFF
    "com/google/firebase/iid/FirebaseInstanceIdService.smali": 1,
    "com/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService.smali": 2,
    "qn.smali": 1,  # locale/time system broadcasts
}


def relative_smali(path: Path, smali: Path) -> str:
    return path.relative_to(smali).as_posix()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()
    smali = decoded / "smali"

    actual_two_arg: dict[str, int] = {}
    flags_sites: list[str] = []
    for path in smali.rglob("*.smali"):
        text = path.read_text(encoding="utf-8", errors="ignore")
        relative = relative_smali(path, smali)
        count = text.count(TWO_ARG_REGISTER)
        if count:
            actual_two_arg[relative] = count
        if FLAGS_REGISTER in text:
            flags_sites.extend([relative] * text.count(FLAGS_REGISTER))

    if actual_two_arg != EXPECTED_TWO_ARG_COUNTS:
        raise RuntimeError(
            "Unexpected two-argument dynamic receiver sites. "
            f"Expected {EXPECTED_TWO_ARG_COUNTS}, got {actual_two_arg}"
        )
    if flags_sites != ["btp.smali"]:
        raise RuntimeError(
            "Expected exactly one flagged dynamic receiver in btp.smali; "
            f"got {flags_sites}"
        )

    btp = (smali / "btp.smali").read_text(encoding="utf-8")
    required = (
        GSERVICES_ACTION,
        "Landroid/os/Build$VERSION;->SDK_INT:I",
        "const/16 v6, 0x21",
        ":register_gservices_legacy",
        "const/4 v5, 0x2",  # Context.RECEIVER_EXPORTED
        FLAGS_REGISTER,
    )
    missing = [fragment for fragment in required if fragment not in btp]
    if missing:
        raise RuntimeError(
            "GServices receiver compatibility patch is incomplete: "
            + ", ".join(missing)
        )

    # The only raw DexFile.loadDex call is the bundled legacy multidex
    # installer. It is used only on pre-Lollipop devices, not the API 34 path.
    dynamic_loader_sites: list[str] = []
    dex_load_sites: list[str] = []
    for path in smali.rglob("*.smali"):
        text = path.read_text(encoding="utf-8", errors="ignore")
        relative = relative_smali(path, smali)
        if "Ldalvik/system/DexClassLoader;-><init>" in text:
            dynamic_loader_sites.append(relative)
        if "Ldalvik/system/DexFile;->loadDex" in text:
            dex_load_sites.extend([relative] * text.count("Ldalvik/system/DexFile;->loadDex"))
    if dynamic_loader_sites:
        raise RuntimeError(
            "Unexpected DexClassLoader construction: " + ", ".join(dynamic_loader_sites)
        )
    if dex_load_sites != ["boe.smali"]:
        raise RuntimeError(
            "Unexpected DexFile.loadDex sites; expected only legacy multidex boe.smali, "
            f"got {dex_load_sites}"
        )

    print(
        "Android 14 invariants verified: GServices receiver uses "
        "RECEIVER_EXPORTED on API 33+ with a legacy fallback; all other "
        "dynamic receivers are system-broadcast sites; no API-34 dynamic "
        "DexClassLoader path was introduced"
    )


if __name__ == "__main__":
    main()
