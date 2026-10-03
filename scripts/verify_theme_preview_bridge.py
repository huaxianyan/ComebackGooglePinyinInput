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
  `strings.xml` and against the forced-value array;
* the key-border preference the sheet writes comes from the bridge, and is
  matched against `strings.xml`; it carries no forced value, so it is the one
  preference checked on the key alone;
* the grid cell sizes come from `ThemeCatalogScreen.kt`, and are matched against
  the legacy dimensions they copy;
* the two Defaults presets come from the same screen, and are matched against
  the legacy strings the engine itself falls back to;
* the tags the tile swatch reads come from the bridge, and are matched against
  the legacy sample layout they name.

The forced values are the reason the bridge goes through the preference facade
instead of `SharedPreferences`: they are held in memory and never written to
disk, so a direct read finds nothing.

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
SCREEN = (
    ROOT
    / "modern-settings/compose-runtime/src/main/kotlin/com/google/android/inputmethod/pinyin"
    / "modernsettings/compose/ThemeCatalogScreen.kt"
)
STRINGS = "res/values/strings.xml"
FORCED_VALUES_ARRAY = "res/values/arrays.xml"
DIMENS = "res/values/dimens.xml"

STRING_CONST = re.compile(r'const val (\w+)\s*=\s*"([^"]*)"')
INT_CONST = re.compile(r'const val (\w+)\s*=\s*(\d+)')

# Grid cell sizes the screen hardcodes, and the legacy dimensions they copy.
# The screen cannot read the dimensions at runtime without another reflection
# hop, so the two are kept in step here instead.
CELL_SIZE = {
    "THEME_CELL_WIDTH_DP": "theme_selector_candidate_width",
    "THEME_CELL_HEIGHT_DP": "theme_selector_candidate_height",
}

KEYBOARD_PACKAGE = "com.google.android.apps.inputmethod.libs.framework.keyboard"

# Every class the bridge loads, keyed by the constant that names it. The value
# is the list of declarations that must appear in that class.
REQUIRED_CLASSES = {
    "DESCRIPTOR_CLASS": ["baq"],
    "THEME_CLASS": ["bck"],
    "WRAPPED_CONTEXT_CLASS": ["bbb"],
    "VIEW_DEF_HOLDER_CLASS": ["ats"],
    "PREFERENCES_CLASS": ["amx"],
    "CARD_KIND_CLASS": ["bdc"],
    "BORDER_STATE_CLASS": ["gc"],
    "CARD_CLASS": [
        "com.google.android.apps.inputmethod.libs.theme.preference.CheckableFrameLayout",
    ],
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

# Members that the bridge names through a constant, and so must be derived from
# it rather than spelled out again here. Renaming the constant in the bridge has
# to fail this gate; a hardcoded copy would silently keep passing.
RENDERER_CLASS = KEYBOARD_PACKAGE + ".KeyboardPreviewRenderer"
CANCELER_CLASS = RENDERER_CLASS + "$KeyboardPreviewRequestCanceler"
RECEIVER_CLASS = RENDERER_CLASS + "$KeyboardPreviewReceiver"


def required_members(constants: dict[str, str]) -> dict[str, list[str]]:
    accessor = constants.get("PREFERENCES_ACCESSOR", "a")
    request = constants.get("REQUEST_METHOD", "a")
    cancel = constants.get("CANCEL_METHOD", "cancelRequest")
    ready = constants.get("RECEIVER_METHOD", "onKeyboardPreviewReady")
    theme_kind = constants.get("CARD_KIND_THEME", "CANDIDATE")
    layout_field = constants.get("CARD_LAYOUT_FIELD", "layoutResourceId")
    check = constants.get("CARD_CHECK_METHOD", "setChecked")
    descriptor_factory = constants.get("DESCRIPTOR_FACTORY", "a")
    descriptor_field = constants.get("DESCRIPTOR_VALUE_FIELD", "b")
    border_method = constants.get("BORDER_STATE_METHOD", "c")
    return {
        "baq": [
            f".method public static {descriptor_factory}"
            "(Landroid/content/Context;)Lbaq;",
            f".method public static {descriptor_factory}"
            "(Landroid/content/Context;Ljava/lang/String;)Lbaq;",
            # The effective theme value: `a` is a legacy base-theme name, `b` is
            # the package value the renderer consumes.
            f".field public final {descriptor_field}:Ljava/lang/String;",
        ],
        "bck": [
            # Three arguments for the renderer, four for a grid cell: the extra
            # one is the key-border flag, and the grid passes false.
            ".method public constructor <init>(Landroid/content/Context;Lbaq;Z)V",
            ".method public constructor <init>(Landroid/content/Context;Lbaq;ZZ)V",
        ],
        "ats": [
            ".field public static final a:"
            "[Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/"
            "KeyboardViewDef$Type;",
        ],
        # The forced-value map lives behind these. Reading SharedPreferences
        # directly returns nothing, because the values are never written to disk.
        "amx": [
            f".method public static {accessor}(Landroid/content/Context;)Lamx;",
            f".method public final declared-synchronized {accessor}"
            "(Ljava/lang/String;I)I",
            f".method public final declared-synchronized {accessor}"
            "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
            # The key-border switch, which is a plain preference and so can be
            # written ahead of the theme write path.
            f".method public final declared-synchronized {accessor}"
            "(Ljava/lang/String;Z)Z",
            f".method public final {accessor}(Ljava/lang/String;Z)V",
        ],
        # The key-border state the renderer itself reads. Going through this
        # keeps the switch agreeing with the picture beside it, because the
        # preference behind it has a system-property fallback.
        "gc": [
            f".method public static {border_method}(Landroid/content/Context;)Z",
        ],
        # The grid cell kind. Each constant carries the layout it inflates.
        "bdc": [
            f".field public static final enum {theme_kind}:Lbdc;",
            f".field public final {layout_field}:I",
        ],
        "com.google.android.apps.inputmethod.libs.theme.preference.CheckableFrameLayout": [
            f".method public {check}(Z)V",
        ],
        RENDERER_CLASS: [
            ".method public constructor <init>(Landroid/content/Context;"
            "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme;"
            "[Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/"
            "KeyboardViewDef$Type;F)V",
            f".method public final {request}(ILjava/lang/String;"
            "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
            "KeyboardPreviewRenderer$KeyboardPreviewReceiver;)"
            "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
            "KeyboardPreviewRenderer$KeyboardPreviewRequestCanceler;",
        ],
        CANCELER_CLASS: [
            f".method public abstract {cancel}()V",
        ],
        RECEIVER_CLASS: [
            f".method public abstract {ready}("
            "Ljava/lang/String;Landroid/graphics/drawable/Drawable;)V",
        ],
    }

# Preference keys the renderer reads, named by the constants that hold them.
REQUIRED_PREFERENCES = {
    "PREVIEW_BUNDLES_KEY": "pref_key_preview_input_bundles_xml_id",
    "PREVIEW_LAYOUT_KEY": "pref_key_preview_keyboard_layout",
}

# The key-border preference the sheet writes. Unlike the two above it carries no
# forced value, so it is only checked against `strings.xml`.
KEY_BORDER_PREFERENCE = ("KEY_BORDER_KEY", "pref_key_enable_key_border")

# The two packaged presets the Defaults row offers, checked against the legacy
# strings the engine itself falls back to.
PRESET_VALUES = {
    "LIGHT_PRESET_VALUE": "pref_entry_additional_keyboard_theme_google_blue_light",
    "DARK_PRESET_VALUE": "pref_entry_additional_keyboard_theme_google_blue_dark",
}

# Tags the swatch looks for in the legacy sample layout, named by the constants
# that hold them. Some are written straight into the layout and some arrive
# through the styles it references, so both files are searched. The layout
# belongs to the upstream APK, so a rename there has to fail here rather than at
# runtime, where it would quietly turn every tile into a flat block with no
# accents on it.
SWATCH_TAGS = [
    "BODY_TAG",
    "SPACE_TAG",
    "ACTION_ICON_TAG",
    "KEYBOARD_BACKGROUND_TAG",
]
SAMPLE_LAYOUT = "res/layout/theme_selector_candidate_preview.xml"
SAMPLE_STYLES = "res/values/styles.xml"

# Method names the bridge reaches for. They feed the derived signatures above,
# so a rename has to be visible here rather than silently falling back.
REQUIRED_CONSTANTS = [
    "PREFERENCES_ACCESSOR",
    "REQUEST_METHOD",
    "CANCEL_METHOD",
    "RECEIVER_METHOD",
    "CARD_KIND_THEME",
    "CARD_LAYOUT_FIELD",
    "CARD_CHECK_METHOD",
    "BORDER_STATE_METHOD",
    "DESCRIPTOR_FACTORY",
    "DESCRIPTOR_VALUE_FIELD",
    "KEY_BORDER_KEY",
]


def smali_path(root: Path, class_name: str) -> Path:
    return root / "smali" / (class_name.replace(".", "/") + ".smali")


def string_constants(source: str) -> dict[str, str]:
    return {
        name: value.replace("\\$", "$")
        for name, value in STRING_CONST.findall(source)
    }


def int_constants(source: str) -> dict[str, int]:
    return {name: int(value) for name, value in INT_CONST.findall(source)}


def read_legacy_string(root: Path, resource: str) -> str | None:
    """Return the value of a legacy `<string name="resource">` entry."""
    text = (root / STRINGS).read_text(encoding="utf-8")
    match = re.search(
        r'<string name="' + re.escape(resource) + r'">([^<]*)</string>',
        text,
    )
    return match.group(1) if match else None


def read_legacy_dimen(root: Path, resource: str) -> float | None:
    """Return the numeric value of a legacy `<dimen name="resource">` entry.

    The unit is dropped on purpose: the screen writes plain `dp`, so only the
    magnitude is compared.
    """
    text = (root / DIMENS).read_text(encoding="utf-8")
    match = re.search(
        r'<dimen name="' + re.escape(resource) + r'">([\d.]+)',
        text,
    )
    return float(match.group(1)) if match else None


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
    parser.add_argument(
        "--screen",
        type=Path,
        default=SCREEN,
        help="Compose screen whose grid cell sizes are checked against dimens",
    )
    args = parser.parse_args()

    failures: list[str] = []
    if not args.decoded.is_dir():
        print(f"FAIL no decoded tree at {args.decoded}", file=sys.stderr)
        return 1

    constants = string_constants(args.bridge.read_text(encoding="utf-8"))
    members = required_members(constants)

    for constant in REQUIRED_CONSTANTS:
        if constant not in constants:
            failures.append(f"the bridge declares no {constant}")

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
        for member in members.get(class_name, []):
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

    # The key-border preference is a plain one, so the legacy side is the only
    # place its name is written down; the bridge and `strings.xml` have to agree.
    border_constant, border_resource = KEY_BORDER_PREFERENCE
    actual = constants.get(border_constant)
    if actual is None:
        failures.append(f"the bridge declares no {border_constant}")
    else:
        legacy = read_legacy_string(args.decoded, border_resource)
        if legacy is None:
            failures.append(f"strings.xml no longer declares {border_resource}")
        elif legacy != actual:
            failures.append(
                f"{border_constant} is {actual}, but {border_resource} resolves "
                f"to {legacy}"
            )

    forced = (args.decoded / FORCED_VALUES_ARRAY).read_text(encoding="utf-8")
    for resource in REQUIRED_PREFERENCES.values():
        if f"@string/{resource}" not in forced:
            failures.append(
                f"the forced-value array no longer sets {resource}, so neither "
                f"the legacy selector nor this bridge could read it"
            )

    screen = args.screen.read_text(encoding="utf-8")

    # The grid cell sizes are a copy of the legacy dimensions, not a runtime
    # read, so the copy has to be watched. A drift here would only show up as
    # cards that no longer line up with the legacy selector.
    cells = int_constants(screen)
    for constant, resource in CELL_SIZE.items():
        actual = cells.get(constant)
        if actual is None:
            failures.append(f"the screen declares no {constant}")
            continue
        legacy = read_legacy_dimen(args.decoded, resource)
        if legacy is None:
            failures.append(f"dimens.xml no longer declares {resource}")
        elif float(actual) != legacy:
            failures.append(
                f"{constant} is {actual}, but {resource} resolves to {legacy}"
            )

    # The Defaults row offers the same two packaged presets the engine falls back
    # to when no theme has been chosen, so both sides have to name the same
    # packages; a drift would offer a preset that does not exist.
    presets = string_constants(screen)
    for constant, resource in PRESET_VALUES.items():
        actual = presets.get(constant)
        if actual is None:
            failures.append(f"the screen declares no {constant}")
            continue
        legacy = read_legacy_string(args.decoded, resource)
        if legacy is None:
            failures.append(f"strings.xml no longer declares {resource}")
        elif legacy != actual:
            failures.append(
                f"{constant} is {actual}, but {resource} resolves to {legacy}"
            )

    # The swatch is built out of tagged parts of the legacy sample layout, so
    # every tag it names has to still be somewhere in that layout or in the
    # styles it pulls in.
    sources = [
        (SAMPLE_LAYOUT, (args.decoded / SAMPLE_LAYOUT).read_text(encoding="utf-8")),
        (SAMPLE_STYLES, (args.decoded / SAMPLE_STYLES).read_text(encoding="utf-8")),
    ]
    for constant in SWATCH_TAGS:
        actual = constants.get(constant)
        if actual is None:
            failures.append(f"the bridge declares no {constant}")
        elif not any(actual in text for _, text in sources):
            failures.append(
                f"{constant} is {actual}, but neither "
                f"{' nor '.join(name for name, _ in sources)} carries that tag"
            )

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print(
        f"theme preview bridge verified "
        f"({len(class_names)} classes, "
        f"{sum(len(v) for v in members.values())} member signatures, "
        f"{len(REQUIRED_PREFERENCES)} forced preferences, "
        f"{len(CELL_SIZE)} grid cell sizes, "
        f"{len(PRESET_VALUES)} default presets, "
        f"{len(SWATCH_TAGS)} swatch tags)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
