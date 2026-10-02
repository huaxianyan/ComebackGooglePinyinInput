#!/usr/bin/env python3
"""Guards the reflection bridge behind the Compose keyboard preview.

The Compose settings runtime cannot compile against the packaged APK, so the
preview is driven through reflection: obfuscated class names, a constructor
signature, and one request method are the only handles it has. None of that is
checked by the compiler, so an upstream rename would turn into a runtime
failure with a blank preview and no obvious cause.

This script asserts every symbol the bridge names still exists in the decoded
APK, and that the two preferences the renderer requires still carry forced
values. Both sides are read rather than duplicated:

* the class and method names come from `ThemePreviewBridge.kt`, so editing the
  bridge without editing this file still gets checked;
* the preference key names come from the bridge, and are matched against
  `strings.xml` and against the forced-value array.

Run it after decoding the APK. Without a decoded tree there is nothing to
compare against, so a missing tree is an error rather than a skip.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
BRIDGE = (
    ROOT
    / "modern-settings/compose-runtime/src/main/kotlin/com/google/android/inputmethod/pinyin"
    / "modernsettings/compose/ThemePreviewBridge.kt"
)
DECODED = ROOT / "work/decoded-fresh"
STRINGS = "res/values/strings.xml"
FORCED_VALUES_ARRAY = "res/values/arrays.xml"

STRING_CONST = re.compile(r'const val (\w+)\s*=\s*"([^"]*)"')

KEYBOARD_PACKAGE = "com.google.android.apps.inputmethod.libs.framework.keyboard"

# Every class the bridge loads, keyed by the constant that names it. The value
# is the list of declarations that must appear in that class.
REQUIRED_CLASSES = {
    "DESCRIPTOR_CLASS": ["baq"],
    "THEME_CLASS": ["bck"],
    "WRAPPED_CONTEXT_CLASS": ["bbb"],
    "VIEW_DEF_HOLDER_CLASS": ["ats"],
    "RENDERER_CLASS": [
        KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer",
    ],
    "THEME_INTERFACE": [
        KEYBOARD_PACKAGE + ".IKeyboardTheme",
    ],
    "CANCELER_INTERFACE": [
        KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer$KeyboardPreviewRequestCanceler",
    ],
    "RECEIVER_INTERFACE": [
        KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer$KeyboardPreviewReceiver",
    ],
}

REQUIRED_MEMBERS = {
    "baq": [
        ".method public static a(Landroid/content/Context;Ljava/lang/String;)Lbaq;",
    ],
    "bck": [
        ".method public constructor <init>(Landroid/content/Context;Lbaq;Z)V",
    ],
    "ats": [
        ".field public static final a:"
        "[Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/KeyboardViewDef$Type;",
    ],
    KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer": [
        ".method public constructor <init>(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme;"
        "[Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/KeyboardViewDef$Type;F)V",
        ".method public final a(ILjava/lang/String;"
        "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "KeyboardPreviewRenderer$KeyboardPreviewReceiver;)"
        "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "KeyboardPreviewRenderer$KeyboardPreviewRequestCanceler;",
    ],
    KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer$KeyboardPreviewRequestCanceler": [
        ".method public abstract cancelRequest()V",
    ],
    KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer$KeyboardPreviewReceiver": [
        ".method public abstract onKeyboardPreviewReady("
        "Ljava/lang/String;Landroid/graphics/drawable/Drawable;)V",
    ],
}

# Preference keys the renderer reads, named by the constants that hold them.
REQUIRED_PREFERENCES = {
    "PREVIEW_BUNDLES_KEY": "pref_key_preview_input_bundles_xml_id",
    "PREVIEW_LAYOUT_KEY": "pref_key_preview_keyboard_layout",
}


def smali_path(root: Path, class_name: str) -> Path:
    return root / "smali" / (class_name.replace(".", "/") + ".smali")


def string_constants(source: str) -> dict[str, str]:
    return {
        name: value.replace("\\$", "$")
        for name, value in STRING_CONST.findall(source)
    }


def read_legacy_string(root: Path, resource: str) -> str | None:
    """Return the value of a legacy `<string name="resource">` entry."""
    text = (root / STRINGS).read_text(encoding="utf-8")
    match = re.search(
        r'<string name="' + re.escape(resource) + r'">([^<]*)</string>',
        text,
    )
    return match.group(1) if match else None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--bridge",
        type=Path,
        default=BRIDGE,
        help="Compose-side reflection bridge to read the symbol names from",
    )
    parser.add_argument(
        "--decoded",
        type=Path,
        default=DECODED,
        help="Decoded APK tree holding the smali and the resource files",
    )
    args = parser.parse_args()

    failures: list[str] = []
    if not args.decoded.is_dir():
        print(f"FAIL no decoded tree at {args.decoded}", file=sys.stderr)
        return 1

    constants = string_constants(args.bridge.read_text(encoding="utf-8"))

    class_names: set[str] = set()
    for constant, expected in REQUIRED_CLASSES.items():
        actual = constants.get(constant)
        if actual is None:
            failures.append(f"the bridge declares no {constant}")
            continue
        if actual not in expected:
            failures.append(
                f"{constant} is {actual}, but the decoded APK was checked against "
                f"{', '.join(expected)}"
            )
            continue
        class_names.add(actual)

    for class_name in sorted(class_names):
        path = smali_path(args.decoded, class_name)
        if not path.is_file():
            failures.append(f"the decoded APK has no class {class_name}")
            continue
        text = path.read_text(encoding="utf-8")
        for member in REQUIRED_MEMBERS.get(class_name, []):
            if member not in text:
                failures.append(f"{class_name} no longer declares {member}")

    for constant, resource in REQUIRED_PREFERENCES.items():
        actual = constants.get(constant)
        if actual is None:
            failures.append(f"the bridge declares no {constant}")
            continue
        legacy = read_legacy_string(args.decoded, resource)
        if legacy is None:
            failures.append(f"strings.xml no longer declares {resource}")
        elif legacy != actual:
            failures.append(
                f"{constant} is {actual}, but {resource} resolves to {legacy}"
            )

    forced = (args.decoded / FORCED_VALUES_ARRAY).read_text(encoding="utf-8")
    for resource in REQUIRED_PREFERENCES.values():
        if f"@string/{resource}" not in forced:
            failures.append(
                f"the forced-value array no longer sets {resource}, so the "
                f"renderer would hit its guard instead of rendering"
            )

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print(
        f"theme preview bridge verified "
        f"({len(class_names)} classes, "
        f"{sum(len(v) for v in REQUIRED_MEMBERS.values())} member signatures, "
        f"{len(REQUIRED_PREFERENCES)} forced preferences)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
