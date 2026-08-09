#!/usr/bin/env python3
"""Prepare the patched legacy manifest for an API-35+ Compose settings host.

Compose/AndroidX has minSdk 23, while the reconstructed IME intentionally retains
minSdk 17. The modern activity is never routed to below API 35. Library min-SDK
overrides are therefore explicit, and every AndroidX auto-start component is
removed so old processes cannot load modern classes during Application startup.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import xml.etree.ElementTree as ET

ANDROID = "http://schemas.android.com/apk/res/android"
TOOLS = "http://schemas.android.com/tools"
A = f"{{{ANDROID}}}"
T = f"{{{TOOLS}}}"

OVERRIDE_LIBRARIES = (
    "androidx.activity",
    "androidx.activity.compose",
    "androidx.activity.ktx",
    "androidx.annotation.experimental",
    "androidx.compose.animation",
    "androidx.compose.animation.core",
    "androidx.compose.foundation",
    "androidx.compose.foundation.layout",
    "androidx.compose.material.icons",
    "androidx.compose.material.ripple",
    "androidx.compose.material3",
    "androidx.compose.runtime",
    "androidx.compose.runtime.annotation",
    "androidx.compose.runtime.retain",
    "androidx.compose.runtime.saveable",
    "androidx.compose.ui",
    "androidx.compose.ui.geometry",
    "androidx.compose.ui.graphics",
    "androidx.compose.ui.text",
    "androidx.compose.ui.tooling.preview",
    "androidx.compose.ui.unit",
    "androidx.compose.ui.util",
    "androidx.core",
    "androidx.core.ktx",
    "androidx.core.viewtree",
    "androidx.graphics.path",
    "androidx.lifecycle.ktx",
    "androidx.lifecycle.livedata",
    "androidx.lifecycle.livedata.core",
    "androidx.lifecycle.livedata.core.ktx",
    "androidx.lifecycle.process",
    "androidx.lifecycle.runtime",
    "androidx.lifecycle.runtime.compose",
    "androidx.lifecycle.viewmodel",
    "androidx.lifecycle.lifecycle.viewmodel.anchor",
    "androidx.lifecycle.viewmodel.ktx",
    "androidx.lifecycle.viewmodel.savedstate",
    "androidx.navigationevent",
    "androidx.navigationevent.compose",
    "androidx.profileinstaller",
    "androidx.savedstate",
    "androidx.savedstate.compose",
    "androidx.savedstate.ktx",
    "androidx.transition",
    "androidx.window",
    "androidx.window.core",
    "com.google.android.inputmethod.pinyin.modernsettings.compose",
)

ACTIVITY = (
    "com.google.android.inputmethod.pinyin.modernsettings.compose."
    "ModernSettingsActivity"
)


def remove_component(application: ET.Element, tag: str, name: str) -> None:
    marker = ET.SubElement(application, tag)
    marker.set(A + "name", name)
    marker.set(T + "node", "remove")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    parser.add_argument("--package", required=True, dest="package_name")
    parser.add_argument("--audit-launcher", action="store_true")
    args = parser.parse_args()

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

    uses_sdk = root.find("uses-sdk")
    if uses_sdk is None:
        uses_sdk = ET.Element("uses-sdk")
        root.insert(0, uses_sdk)
    # AGP 9 requires SDK levels in Gradle DSL; the manifest keeps only the
    # guarded-library exception.
    uses_sdk.attrib.pop(A + "minSdkVersion", None)
    uses_sdk.attrib.pop(A + "targetSdkVersion", None)
    uses_sdk.set(T + "overrideLibrary", ",".join(OVERRIDE_LIBRARIES))

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

    activity = ET.SubElement(application, "activity")
    activity.set(A + "name", ACTIVITY)
    activity.set(A + "exported", "true" if args.audit_launcher else "false")
    activity.set(A + "enabled", "@bool/modern_settings_runtime_enabled")
    activity.set(A + "theme", "@android:style/Theme.Material.Light.NoActionBar")
    if args.audit_launcher:
        activity.set(A + "label", "Material 3 设置审计")
        intent_filter = ET.SubElement(activity, "intent-filter")
        action = ET.SubElement(intent_filter, "action")
        action.set(A + "name", "android.intent.action.MAIN")
        category = ET.SubElement(intent_filter, "category")
        category.set(A + "name", "android.intent.category.LAUNCHER")

    values = args.decoded / "res/values"
    values_v35 = args.decoded / "res/values-v35"
    values.mkdir(parents=True, exist_ok=True)
    values_v35.mkdir(parents=True, exist_ok=True)
    (values / "modern_settings_runtime.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<resources><bool name="modern_settings_runtime_enabled">false</bool></resources>\n',
        encoding="utf-8",
    )
    (values_v35 / "modern_settings_runtime.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<resources><bool name="modern_settings_runtime_enabled">true</bool></resources>\n',
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
