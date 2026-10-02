#!/usr/bin/env python3
"""Guards the theme-slot initialization contract that the 2.1.4 release broke.

The generated-palette slot shipped invisible on every upgrade because
`ensureInitialized` was gated by a single one-shot boolean flag. A device
initialized by an earlier release already had that flag set, so the routine
returned before writing the new slot's keys; only a fresh install received
them. Acceptance tested a fresh install and passed.

No runtime check in CI can replay an upgrade, so the contract is asserted
against the source that defines it:

1. every slot key is filled in by `ensureInitialized`;
2. initialization decides per key instead of short-circuiting on one flag;
3. `hasEverySlotKey` covers every slot key it claims to;
4. `writeSlot` refuses an empty pair instead of pointing the runtime at
   nothing.

The slot keys are read out of `baseKey` and `additionalKey` rather than
hardcoded, so adding a slot without extending initialization fails here.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java"

SLOT_KEY = re.compile(r"\b([A-Z][A-Z0-9_]*_KEY)\b")


def method_body(source: str, name: str) -> str | None:
    """Return the body of the declaration of `name`, ignoring call sites."""
    for match in re.finditer(re.escape(name) + r"\s*\(", source):
        head = match.start()
        while head > 0 and source[head - 1] in " \t":
            head -= 1
        # A call sits behind an operator or a dot; a declaration sits behind a
        # return type, so only the character before it separates the two.
        if head > 0 and source[head - 1] in "(,=!&|?:.":
            continue
        cursor = match.end()
        while cursor < len(source) and source[cursor] not in "{;":
            cursor += 1
        if cursor >= len(source) or source[cursor] != "{":
            continue
        depth = 0
        for index in range(cursor, len(source)):
            if source[index] == "{":
                depth += 1
            elif source[index] == "}":
                depth -= 1
                if depth == 0:
                    return source[cursor + 1 : index]
    return None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--source",
        type=Path,
        default=SOURCE,
        help="Java source to check; override to replay the contract against another revision",
    )
    args = parser.parse_args()
    source = args.source.read_text(encoding="utf-8")
    failures: list[str] = []

    slot_keys: list[str] = []
    for accessor in ("baseKey", "additionalKey"):
        body = method_body(source, accessor)
        if body is None:
            failures.append(f"{accessor} is missing, so the slot keys cannot be read")
            body = ""
        slot_keys.extend(SLOT_KEY.findall(body))
    slot_keys = sorted(set(slot_keys))
    if len(slot_keys) < 8:
        failures.append(f"only {len(slot_keys)} slot keys found: {slot_keys}")

    bodies: dict[str, str] = {}
    for name in ("ensureInitialized", "hasEverySlotKey", "writeSlot"):
        body = method_body(source, name)
        if body is None:
            failures.append(f"{name} is missing")
            body = ""
        bodies[name] = body
    initialized = bodies["ensureInitialized"]
    complete = bodies["hasEverySlotKey"]
    written = bodies["writeSlot"]

    for key in slot_keys:
        if key not in initialized:
            failures.append(f"ensureInitialized never fills {key}")
        if key not in complete:
            failures.append(f"hasEverySlotKey does not cover {key}")

    if "contains(" not in initialized:
        failures.append("ensureInitialized does not decide per key")
    if "getBoolean(" in initialized:
        failures.append(
            "ensureInitialized reads a boolean flag, which skips every key "
            "added after a device was first initialized"
        )

    if "isEmpty()" not in written:
        failures.append("writeSlot does not reject an empty slot pair")
    elif ".commit()" in written and written.index("isEmpty()") > written.index(".commit()"):
        failures.append("writeSlot commits before checking the slot pair is usable")

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print(
        f"theme-slot initialization contract verified "
        f"({len(slot_keys)} slot keys, no one-shot flag)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
