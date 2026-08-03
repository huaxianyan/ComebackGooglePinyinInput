#!/usr/bin/env python3
"""Verify Android 12 component-export and PendingIntent invariants."""

from __future__ import annotations

import argparse
import re
import xml.etree.ElementTree as ET
from pathlib import Path

ANDROID_NS = "http://schemas.android.com/apk/res/android"
IMMUTABLE = 0x04000000
MUTABLE = 0x02000000
PENDING_CALL = re.compile(
    r"invoke-static \{([^}]+)\}, Landroid/app/PendingIntent;->"
    r"get(?:Activity|Broadcast|Service|ForegroundService)\("
)


def verify_exported(decoded: Path) -> int:
    root = ET.parse(decoded / "AndroidManifest.xml").getroot()
    app = root.find("application")
    if app is None:
        raise RuntimeError("Manifest has no application element")

    checked = 0
    failures: list[str] = []
    for component in app:
        if component.find("intent-filter") is None:
            continue
        checked += 1
        name = component.get(f"{{{ANDROID_NS}}}name", "<unnamed>")
        exported = component.get(f"{{{ANDROID_NS}}}exported")
        if exported not in {"true", "false"}:
            failures.append(f"{component.tag} {name}: missing explicit android:exported")
    if failures:
        raise RuntimeError("\n".join(failures))
    return checked


def parse_const(lines: list[str], call_index: int, register: str) -> int | None:
    pattern = re.compile(
        rf"^\s*const(?:/[a-z0-9]+)?\s+{re.escape(register)},\s+(-?0x[0-9a-f]+|-?[0-9]+)\s*$",
        re.IGNORECASE,
    )
    for line in reversed(lines[max(0, call_index - 16) : call_index]):
        match = pattern.match(line)
        if match:
            return int(match.group(1), 0)
    return None


def verify_pending_intents(decoded: Path) -> int:
    checked = 0
    failures: list[str] = []
    for path in (decoded / "smali").rglob("*.smali"):
        lines = path.read_text(encoding="utf-8").splitlines()
        for index, line in enumerate(lines):
            match = PENDING_CALL.search(line)
            if not match:
                continue
            checked += 1
            registers = [item.strip() for item in match.group(1).split(",")]
            if len(registers) != 4:
                failures.append(f"{path}:{index + 1}: unexpected PendingIntent registers")
                continue
            flag_register = registers[-1]
            flags = parse_const(lines, index, flag_register)
            if flags is None:
                failures.append(
                    f"{path}:{index + 1}: cannot resolve flags in {flag_register}"
                )
            elif not flags & (IMMUTABLE | MUTABLE):
                failures.append(
                    f"{path}:{index + 1}: missing explicit mutability in flags {flags:#x}"
                )
            elif flags & IMMUTABLE and flags & MUTABLE:
                failures.append(
                    f"{path}:{index + 1}: both mutability flags set in {flags:#x}"
                )
    if failures:
        raise RuntimeError("\n".join(failures))
    if checked != 7:
        raise RuntimeError(f"Expected 7 PendingIntent creation sites, found {checked}")
    return checked


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()
    exported = verify_exported(decoded)
    pending = verify_pending_intents(decoded)
    print(
        f"Android 12 invariants verified: {exported} intent-filter components "
        f"have android:exported; {pending} PendingIntents declare mutability"
    )


if __name__ == "__main__":
    main()
