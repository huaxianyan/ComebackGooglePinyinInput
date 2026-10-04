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
  the legacy sample layout they name;
* the class that builds the generated palette package comes from the bridge,
  and its builder method is matched against the checked-in smali. That class is
  the one thing here this project adds rather than inherits, so its source of
  truth is `patches/smali/SystemAutoThemeCompat.smali` rather than the decoded
  tree: it is what `apply_patches.py` injects verbatim, and it stays current
  even when the decoded tree predates the last regeneration. Editing the Java
  without re-running `generate_system_auto_theme_smali.py` leaves the two out of
  step, and this is what notices.
* the snapshot-cache prefix the builder matches on, and the method that drops
  the renderer's snapshots, come from the same class. The renderer names each
  rasterised keyboard after the theme value it was drawn from, so a palette
  rebuilt in place leaves every snapshot showing the previous colours while the
  real keyboard is already correct; the drop is what closes that gap, and a
  rename that silently disables it would only show up as previews that are
  wrong whenever the palette has changed since they were drawn.
* the four lookups the bridge makes where the engine overloads by return type
  are made through a helper that names the return type. `Class.getMethod`
  matches on name and parameters alone, and several of these classes declare two
  methods that differ only in what they return, so a lookup that ignores it
  picks whichever the runtime lists first. Getting that wrong is not a crash:
  the cast fails inside the bridge's `runCatching` and the caller takes its
  fallback. The key-border switch read `false` for every setting that way, while
  the renderer - whose call the compiler resolves - drew borders, so the switch
  and the picture beside it disagreed. This is the one check here that guards
  behaviour rather than a name.

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

# The generated-palette builder. This project adds the class rather than
# inheriting it from the upstream APK, so it is checked against the smali the
# build injects rather than against the decoded tree, which may predate the last
# regeneration. The method name still comes from the bridge, so renaming the
# constant there fails here instead of at runtime, where a missing method is
# swallowed by the bridge's `runCatching` and the tile quietly loses its palette.
PALETTE_BUILDER_CLASS = "com.google.android.inputmethod.pinyin.SystemAutoThemeCompat"
PALETTE_BUILDER_SMALI = ROOT / "patches/smali/SystemAutoThemeCompat.smali"
PALETTE_BUILDER_JAVA = (
    ROOT
    / "patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java"
)

# The renderer's snapshot cache. It names each rasterised keyboard after the
# theme value it was drawn from and never after the package behind that value,
# so a palette rebuilt in place leaves every snapshot showing the previous
# colours while the real keyboard, which does not read this cache, is already
# correct. The builder drops them on every rebuild; the prefix it matches on and
# the method that does the dropping are both named here, so a rename that
# quietly stops the drop fails this gate instead of shipping stale previews.
SNAPSHOT_PREFIX_CONSTANT = "SNAPSHOT_CACHE_PREFIX"
SNAPSHOT_SUFFIX_CONSTANT = "SNAPSHOT_CACHE_SUFFIX"
SNAPSHOT_DROP_METHOD = "invalidatePreviewSnapshots"

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

# Lookups the bridge makes where the engine overloads by return type, so a
# lookup by name and parameters alone cannot name one method.
#
# `Class.getMethod` matches on name and parameters only. `gc` declares
# `c(Context)` returning a `File` *and* `c(Context)` returning a boolean, and
# the facade declares a boolean getter and a boolean setter under one name, so
# for these four the return type is part of the method's identity. Picking the
# wrong one is not a crash: the cast fails inside the caller's `runCatching` and
# the caller silently takes its fallback - which is how the key-border switch
# came to answer `false` for every setting while the renderer, whose call the
# compiler resolves, drew borders.
#
# Each entry is the bridge's class constant, the smali class, the bridge's
# method constant, the parameter list, and the return type that is wanted.
RETURN_TYPE_LOOKUPS = [
    (
        "PREFERENCES_CLASS",
        "amx",
        "PREFERENCES_ACCESSOR",
        "(Landroid/content/Context;)",
        "Lamx;",
    ),
    (
        "BORDER_STATE_CLASS",
        "gc",
        "BORDER_STATE_METHOD",
        "(Landroid/content/Context;)",
        "Z",
    ),
    (
        "PREFERENCES_CLASS",
        "amx",
        "PREFERENCES_ACCESSOR",
        "(Ljava/lang/String;I)",
        "I",
    ),
    (
        "PREFERENCES_CLASS",
        "amx",
        "PREFERENCES_ACCESSOR",
        "(Ljava/lang/String;Ljava/lang/String;)",
        "Ljava/lang/String;",
    ),
    (
        "PREFERENCES_CLASS",
        "amx",
        "PREFERENCES_ACCESSOR",
        "(Ljava/lang/String;Z)",
        "V",
    ),
]

# The helper that names the return type. The bridge has to route every lookup
# above through it; `getMethod` on its own is the mistake this guards.
RETURN_TYPE_HELPER = "engineMethod"

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

    # The return-type-ambiguous lookups. Each one is checked twice: the overload
    # the bridge wants has to still exist, and if the class declares more than
    # one method under that name and parameter list - which is what makes the
    # return type load-bearing - the bridge has to be resolving it through the
    # helper rather than through `getMethod`.
    bridge_source = args.bridge.read_text(encoding="utf-8")
    if f"fun {RETURN_TYPE_HELPER}(" not in bridge_source:
        failures.append(
            f"the bridge no longer declares {RETURN_TYPE_HELPER}, which is what "
            f"picks a method out of an overload set that differs only by return "
            f"type"
        )
    ambiguous = 0
    for (
        class_constant,
        class_name,
        method_constant,
        params,
        expected,
    ) in RETURN_TYPE_LOOKUPS:
        method_name = constants.get(method_constant)
        if method_name is None:
            failures.append(f"the bridge declares no {method_constant}")
            continue
        path = smali_path(args.decoded, class_name)
        if not path.is_file():
            failures.append(f"the decoded APK has no class {class_name}")
            continue
        text = path.read_text(encoding="utf-8")
        declared = re.findall(
            r"^\.method[^\n]*?\s"
            + re.escape(method_name + params)
            + r"(\S+)$",
            text,
            re.MULTILINE,
        )
        if expected not in declared:
            failures.append(
                f"{class_name} no longer declares "
                f"{method_name}{params}{expected}"
            )
        if len(declared) < 2:
            continue
        ambiguous += 1
        if not re.search(
            re.escape(RETURN_TYPE_HELPER) + r"\(\s*" + class_constant + r",",
            bridge_source,
        ):
            failures.append(
                f"{class_name}.{method_name}{params} is declared {len(declared)} "
                f"times over, differing only by return type, but the bridge does "
                f"not look it up through {RETURN_TYPE_HELPER}({class_constant}, "
                f"...); a lookup that ignores the return type picks whichever "
                f"overload the runtime lists first, and the wrong one fails "
                f"silently into the caller's fallback"
            )
    for method_constant in ("BORDER_STATE_METHOD", "PREFERENCES_ACCESSOR"):
        if re.search(r"getMethod\(\s*" + method_constant, bridge_source):
            failures.append(
                f"the bridge resolves {method_constant} with getMethod, which "
                f"cannot tell apart the overloads that differ only by return "
                f"type; use {RETURN_TYPE_HELPER} instead"
            )

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

    # The generated-palette builder is the one class the bridge loads that this
    # project adds rather than inherits. It is checked against the smali the
    # build injects, because that is the copy the bridge will actually reach at
    # runtime, and against the bridge's own constant so a rename cannot pass by
    # falling back to a default that no longer matches.
    builder_class = constants.get("DYNAMIC_PREPARE_CLASS")
    builder_method = constants.get("DYNAMIC_PREPARE_METHOD")
    if builder_class is None:
        failures.append("the bridge declares no DYNAMIC_PREPARE_CLASS")
    elif builder_class != PALETTE_BUILDER_CLASS:
        failures.append(
            f"DYNAMIC_PREPARE_CLASS is {builder_class}, but the injected class is "
            f"{PALETTE_BUILDER_CLASS}"
        )
    if builder_method is None:
        failures.append("the bridge declares no DYNAMIC_PREPARE_METHOD")
    elif builder_class == PALETTE_BUILDER_CLASS:
        if not PALETTE_BUILDER_SMALI.is_file():
            failures.append(f"no injected smali at {PALETTE_BUILDER_SMALI}")
        else:
            member = (
                f".method public static {builder_method}"
                "(Landroid/content/Context;)Ljava/lang/String;"
            )
            if member not in PALETTE_BUILDER_SMALI.read_text(encoding="utf-8"):
                failures.append(
                    f"{PALETTE_BUILDER_CLASS} no longer declares {member}; the "
                    f"Java source and the generated smali are out of step"
                )

    # The snapshot drop is the only thing between a rebuilt palette and previews
    # that keep drawing the old one. Both halves are checked: the prefix and
    # suffix the builder matches on come from its Java source, and the method
    # that runs the drop has to be present in the smali the build injects, which
    # is the copy `apply_patches.py` writes into the decoded tree.
    if not PALETTE_BUILDER_JAVA.is_file():
        failures.append(f"no builder source at {PALETTE_BUILDER_JAVA}")
    elif PALETTE_BUILDER_SMALI.is_file():
        builder_java = PALETTE_BUILDER_JAVA.read_text(encoding="utf-8")
        builder_smali = PALETTE_BUILDER_SMALI.read_text(encoding="utf-8")
        for constant in (SNAPSHOT_PREFIX_CONSTANT, SNAPSHOT_SUFFIX_CONSTANT):
            match = re.search(
                r"final String " + constant + r'\s*=\s*"([^"]*)"', builder_java
            )
            if match is None:
                failures.append(f"the builder source declares no {constant}")
                continue
            literal = match.group(1)
            field = (
                f".field private static final {constant}:"
                f'Ljava/lang/String; = "{literal}"'
            )
            if field not in builder_smali:
                failures.append(
                    f"the builder source sets {constant} to {literal}, but the "
                    f"injected smali does not; the Java and the generated smali "
                    f"are out of step"
                )
        declaration = (
            f".method private static {SNAPSHOT_DROP_METHOD}"
            "(Landroid/content/Context;)V"
        )
        if declaration not in builder_smali:
            failures.append(
                f"{PALETTE_BUILDER_CLASS} no longer declares {declaration}"
            )
        elif (
            f"->{SNAPSHOT_DROP_METHOD}(Landroid/content/Context;)V"
            not in builder_smali
        ):
            failures.append(
                f"{PALETTE_BUILDER_CLASS} never calls {SNAPSHOT_DROP_METHOD}, so a "
                f"rebuilt palette would leave its previous previews in place"
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
        f"{len(SWATCH_TAGS)} swatch tags, "
        f"{ambiguous} return-type overloads, "
        f"1 injected palette builder, "
        f"1 snapshot drop)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
