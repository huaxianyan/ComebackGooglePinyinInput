#!/usr/bin/env python3
"""Prepare the patched legacy manifest for the Compose settings host.

The reconstructed IME now shares the Compose/AndroidX floor: minSdk 23, the same
level those libraries declare, so no library min-SDK override is needed any more.
Every AndroidX auto-start component is still removed, so an old process cannot
load modern classes during Application startup.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import xml.etree.ElementTree as ET

ANDROID = "http://schemas.android.com/apk/res/android"
TOOLS = "http://schemas.android.com/tools"
A = f"{{{ANDROID}}}"
T = f"{{{TOOLS}}}"

ACTIVITY = (
    "com.google.android.inputmethod.pinyin.modernsettings.compose."
    "ModernSettingsActivity"
)
FIRST_RUN_ACTIVITY = (
    "com.google.android.inputmethod.pinyin.modernsettings.compose."
    "ModernFirstRunActivity"
)
THEME_BUILDER_ACTIVITY = (
    "com.google.android.inputmethod.pinyin.modernsettings.compose."
    "ModernThemeBuilderActivity"
)
LEGACY_LAUNCHER_ACTIVITY = (
    "com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity"
)
IME_SERVICE = "com.google.android.inputmethod.pinyin.PinyinIME"
FORMAL_APPLICATION_ID = "com.google.android.inputmethod.pinyin.compat"

# The theme the Compose hosts are declared with, defined below in both a day and
# a night variant. See the generated XML for why it exists.
HOST_THEME = "ModernSettingsHostTheme"
# The day variant keeps the framework Light theme the hosts used to be declared
# with. The night variant takes its dark twin instead, so that the status and
# navigation bar icon defaults agree with the window background for the instant
# the system draws before the activity exists; enableEdgeToEdge() re-derives both
# from the configuration a moment later.
HOST_THEME_DAY_PARENT = "@android:style/Theme.Material.Light.NoActionBar"
HOST_THEME_NIGHT_PARENT = "@android:style/Theme.Material.NoActionBar"
# material3 1.4.0's own surface tokens: ColorLightTokens.Surface is
# PaletteTokens.Neutral98, ColorDarkTokens.Surface is PaletteTokens.Neutral6, and
# Background is the same value in both. Read from the artifact, not from memory.
HOST_THEME_DAY_BACKGROUND = "#FFFEF7FF"
HOST_THEME_NIGHT_BACKGROUND = "#FF141218"


def remove_component(application: ET.Element, tag: str, name: str) -> None:
    marker = ET.SubElement(application, tag)
    marker.set(A + "name", name)
    marker.set(T + "node", "remove")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    parser.add_argument("--package", required=True, dest="package_name")
    parser.add_argument("--audit-launcher", action="store_true")
    parser.add_argument("--launcher-label")
    parser.add_argument("--ime-label")
    args = parser.parse_args()
    if args.launcher_label and args.package_name == FORMAL_APPLICATION_ID:
        raise RuntimeError("A custom launcher label is forbidden for the formal application ID")
    if args.ime_label and args.package_name == FORMAL_APPLICATION_ID:
        raise RuntimeError("A custom IME label is forbidden for the formal application ID")

    manifest = args.decoded / "AndroidManifest.xml"
    tree = ET.parse(manifest)
    root = tree.getroot()
    if root.attrib.get("package") != args.package_name:
        raise RuntimeError(
            f"manifest package is {root.attrib.get('package')!r}, expected {args.package_name!r}"
        )
    # AGP 9 takes the package from applicationId/namespace and rejects the
    # historical manifest package attribute.
    root.attrib.pop("package")

    # AGP 9 takes the SDK levels from the Gradle DSL, and the app now shares the
    # Compose/AndroidX floor of 23, so this element has nothing left to carry:
    # no level to declare and no library exception to grant. Removing it is
    # clearer than leaving an empty element that reads as though something were
    # still being configured here.
    uses_sdk = root.find("uses-sdk")
    if uses_sdk is not None:
        root.remove(uses_sdk)

    application = root.find("application")
    if application is None:
        raise RuntimeError("legacy manifest has no application")

    # targetSdk 30+ package visibility otherwise hides enabled IMEs from the
    # settings-side InputMethodManager queries inherited from the target-28 app.
    # Declare only the service intent the app actually needs; never request the
    # broad QUERY_ALL_PACKAGES permission.
    queries = root.find("queries")
    if queries is None:
        queries = ET.Element("queries")
        root.insert(list(root).index(application), queries)
    has_input_method_query = any(
        action.attrib.get(A + "name") == "android.view.InputMethod"
        for intent in queries.findall("intent")
        for action in intent.findall("action")
    )
    if not has_input_method_query:
        intent = ET.SubElement(queries, "intent")
        action = ET.SubElement(intent, "action")
        action.set(A + "name", "android.view.InputMethod")

    application.set(T + "remove", "android:appComponentFactory")

    if args.launcher_label:
        legacy_launchers = [
            candidate
            for candidate in application.findall("activity")
            if candidate.attrib.get(A + "name") == LEGACY_LAUNCHER_ACTIVITY
        ]
        if len(legacy_launchers) != 1:
            raise RuntimeError(
                f"expected one legacy launcher activity, found {len(legacy_launchers)}"
            )
        legacy_launchers[0].set(A + "label", args.launcher_label)

    if args.ime_label:
        ime_services = [
            candidate
            for candidate in application.findall("service")
            if candidate.attrib.get(A + "name") == IME_SERVICE
        ]
        if len(ime_services) != 1:
            raise RuntimeError(f"expected one IME service, found {len(ime_services)}")
        ime_services[0].set(A + "label", args.ime_label)

    # Every Compose host. The launch theme is applied to all of them in one
    # place further down, so a host added here cannot miss it.
    host_activities = []

    activity = ET.SubElement(application, "activity")
    activity.set(A + "name", ACTIVITY)
    activity.set(A + "exported", "true" if args.audit_launcher else "false")
    host_activities.append(activity)
    if args.audit_launcher:
        activity.set(A + "label", "Material 3 设置审计")
        intent_filter = ET.SubElement(activity, "intent-filter")
        action = ET.SubElement(intent_filter, "action")
        action.set(A + "name", "android.intent.action.MAIN")
        category = ET.SubElement(intent_filter, "category")
        category.set(A + "name", "android.intent.category.LAUNCHER")

    # The Compose first-run guide. Not exported and not launched by the system:
    # the legacy first-run activity names it explicitly on the API levels it
    # serves, which is also why it needs no intent filter of its own.
    first_run_activity = ET.SubElement(application, "activity")
    first_run_activity.set(A + "name", FIRST_RUN_ACTIVITY)
    first_run_activity.set(A + "exported", "false")
    host_activities.append(first_run_activity)

    # The Compose custom-theme wizard. Not exported and not launched by the
    # system either: the settings page names it, for both halves of what the
    # legacy builder and editor activities used to do.
    theme_builder_activity = ET.SubElement(application, "activity")
    theme_builder_activity.set(A + "name", THEME_BUILDER_ACTIVITY)
    theme_builder_activity.set(A + "exported", "false")
    theme_builder_activity.set(
        A + "configChanges",
        "orientation|screenSize|screenLayout|smallestScreenSize|keyboardHidden|uiMode",
    )
    host_activities.append(theme_builder_activity)

    # Page colour is not configured here at all: every host draws with the shared
    # ModernSettingsTheme, which resolves the dynamic scheme for whichever page
    # is on screen. The theme below is only the window background, the frame the
    # system paints before the app runs and therefore before any of that can be
    # resolved. It still belongs to every host, so it is declared once, for all
    # of them, rather than repeated per activity.
    for host in host_activities:
        host.set(A + "theme", "@style/" + HOST_THEME)

    # The hosts used to be registered as disabled below API 35 through a bool
    # resource with a matching qualifier directory to turn them back on. The
    # settings route now starts at the app's own minSdk, so there is no level
    # left where a host must stay off: the resource and its qualifier directory
    # are gone rather than left behind as a switch that is always on.
    values = args.decoded / "res/values"
    values_night = args.decoded / "res/values-night"
    values.mkdir(parents=True, exist_ok=True)
    values_night.mkdir(parents=True, exist_ok=True)

    # The host theme. It exists for one thing: the window background, i.e. the
    # frame the system draws from the launch until Compose's first frame.
    # Compose paints the page surface itself, so this is only ever visible for
    # that first frame, but a fixed Light framework theme made it #FAFAFA in
    # every night mode - a white flash on a dark-mode launch, and a page that
    # stayed white when the dark scheme's own text was drawn over it. It cannot
    # be the dynamic colour Compose paints, because a window background is
    # resolved before the app runs, so both halves use the surface of the scheme
    # this app falls back to without dynamic colour. windowBackground and
    # colorBackground are both set because in the framework parents they are the
    # same value - windowBackground is ?attr/colorBackground - so which of the
    # two a given window reads cannot be told apart from the outside.
    for theme_dir, parent, background in (
        (values, HOST_THEME_DAY_PARENT, HOST_THEME_DAY_BACKGROUND),
        (values_night, HOST_THEME_NIGHT_PARENT, HOST_THEME_NIGHT_BACKGROUND),
    ):
        (theme_dir / "modern_settings_host_theme.xml").write_text(
            '<?xml version="1.0" encoding="utf-8"?>\n'
            "<resources>\n"
            f'    <style name="{HOST_THEME}" parent="{parent}">\n'
            f'        <item name="android:windowBackground">{background}</item>\n'
            f'        <item name="android:colorBackground">{background}</item>\n'
            "    </style>\n"
            "</resources>\n",
            encoding="utf-8",
        )

    remove_component(application, "provider", "androidx.startup.InitializationProvider")
    remove_component(application, "receiver", "androidx.profileinstaller.ProfileInstallReceiver")

    ET.register_namespace("android", ANDROID)
    ET.register_namespace("tools", TOOLS)
    tree.write(manifest, encoding="utf-8", xml_declaration=True)
    print(f"prepared Compose host manifest at {manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
