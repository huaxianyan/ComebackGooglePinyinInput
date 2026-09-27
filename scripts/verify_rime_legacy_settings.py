#!/usr/bin/env python3
"""Verify the Rime synchronization contract on the legacy dictionary page.

The legacy page is the only entrance for API 17-34 users, so its wiring has to
survive every later resource merge and Smali regeneration. The checks below pin
the injection points, the request code, the resource coverage and the listener
lifecycle that the Compose page keeps in Kotlin.
"""

from __future__ import annotations

import argparse
import io
import re
from pathlib import Path

FRAGMENT = (
    "smali/com/google/android/apps/inputmethod/pinyin/preference/"
    "DictionarySettingsFragment.smali"
)
RIME_PACKAGE = "smali/com/google/android/inputmethod/pinyin/rimesync"
FACADE = "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat"
RIME_OUTER = f"{RIME_PACKAGE}/RimeSyncLegacySettingsCompat.smali"
RIME_CONTROLLER = f"{RIME_PACKAGE}/RimeSyncLegacySettingsCompat$Controller.smali"
AUTO_BACKUP = (
    "smali/com/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat.smali"
)
SETTING_XML = "res/xml/setting_dictionary.xml"
LOCALIZED_STRINGS = (
    "res/values/rime_legacy_settings.xml",
    "res/values-zh/rime_legacy_settings.xml",
)
SOURCE = (
    "patches/java/com/google/android/inputmethod/pinyin/rimesync/"
    "RimeSyncLegacySettingsCompat.java"
)

EXPECTED_KEYS = {
    "rime_sync_current_status",
    "rime_sync_auto_enabled",
    "rime_sync_auto_interval_hours",
    "rime_sync_root",
    "rime_sync_device",
    "rime_sync_snapshot_file",
    "rime_sync_now",
    "rime_sync_reset",
}
EXPECTED_CALLS = {
    "bind",
    "handleActivityResult",
    "handleRequestPermissionsResult",
    "refresh",
    "unbind",
}
REQUEST_TREE_RIME = 0x6B02
REQUEST_TREE_AUTO_BACKUP = 0x6B01
RESOURCE_NAME = re.compile(r'<(?:string|string-array|integer-array) name="(rime_sync_[a-z_]+)"')
XML_REFERENCE = re.compile(r'@(?:string|array)/(rime_sync_[a-z_]+)')
JAVA_RESOURCE = re.compile(r'"(rime_sync_[a-z_]+)"')


def read(path: Path) -> str:
    return io.open(path, encoding="utf-8", errors="replace").read()


def smali_field(text: str, name: str) -> int:
    match = re.search(rf"\.field [^\n]*\b{name}:I = (0x[0-9a-fA-F]+)", text)
    if match is None:
        raise RuntimeError(f"Smali field {name} is missing")
    return int(match.group(1), 16)


def smali_body(text: str, signature: str) -> str:
    match = re.search(
        rf"\.method\s+[^\n]*{re.escape(signature)}\([^\n]*\n(.*?)\.end method",
        text,
        re.S,
    )
    if match is None:
        raise RuntimeError(f"Smali method {signature} is missing")
    return match.group(1)


def verify_injection(decoded: Path) -> None:
    xml = read(decoded / SETTING_XML)
    keys = set(re.findall(r'android:key="(rime_sync_[a-z_]+)"', xml))
    if keys != EXPECTED_KEYS:
        raise RuntimeError(
            "Legacy dictionary page must declare exactly the eight Rime entries: "
            f"missing={sorted(EXPECTED_KEYS - keys)} extra={sorted(keys - EXPECTED_KEYS)}"
        )

    fragment = read(decoded / FRAGMENT)
    calls = re.findall(
        r"Lcom/google/android/inputmethod/pinyin/rimesync/"
        r"RimeSyncLegacySettingsCompat;->([A-Za-z]+)\(",
        fragment,
    )
    if sorted(calls) != sorted(EXPECTED_CALLS):
        raise RuntimeError(
            "DictionarySettingsFragment must bridge all five lifecycle calls: "
            f"actual={sorted(calls)}"
        )


def verify_request_code(decoded: Path) -> None:
    rime = smali_field(read(decoded / RIME_OUTER), "REQUEST_TREE")
    auto_backup = smali_field(read(decoded / AUTO_BACKUP), "REQUEST_TREE")
    if rime != REQUEST_TREE_RIME:
        raise RuntimeError(f"Rime tree picker must use 0x{REQUEST_TREE_RIME:04x}, got 0x{rime:04x}")
    if auto_backup != REQUEST_TREE_AUTO_BACKUP:
        raise RuntimeError(
            "Dictionary auto-backup tree picker must keep 0x"
            f"{REQUEST_TREE_AUTO_BACKUP:04x}, got 0x{auto_backup:04x}"
        )
    if rime == auto_backup:
        raise RuntimeError("Both tree pickers would answer the same request code")


def verify_unconfigured_guard(project: Path) -> None:
    source = project / SOURCE
    if not source.is_file():
        raise RuntimeError(f"Legacy Rime facade source is missing: {source}")
    java = read(source)

    invocations = java.count("synchronizeAsync(")
    if invocations != 1:
        raise RuntimeError(
            f"A manual synchronization must have a single call site, found {invocations}"
        )
    synchronize_body = java.find("private void synchronize()")
    if synchronize_body < 0 or java.find("synchronizeAsync(") < synchronize_body:
        raise RuntimeError("synchronizeAsync must only be called from synchronize()")

    request_body = java.find("private void requestSynchronization()")
    if request_body < 0:
        raise RuntimeError("requestSynchronization() is missing")
    guard = java[request_body:synchronize_body]
    if "compatibilityAccepted" not in guard:
        raise RuntimeError("The manual synchronization entry must confirm the rule first")

    apply_state = java.find("void applyState()")
    if apply_state < 0 or not re.search(
        r"synchronizePreference\.setEnabled\(\s*complete\b", java[apply_state:]
    ):
        raise RuntimeError(
            "An unconfigured page must disable the manual synchronization entry"
        )


def verify_localized_resources(decoded: Path, project: Path) -> None:
    declared: dict[str, set[str]] = {}
    for relative in LOCALIZED_STRINGS:
        path = decoded / relative
        if not path.is_file():
            raise RuntimeError(f"Localized Rime resources are missing: {relative}")
        declared[relative] = set(RESOURCE_NAME.findall(read(path)))

    default = declared[LOCALIZED_STRINGS[0]]
    if not default:
        raise RuntimeError("The default locale declares no Rime resource")
    for relative, names in declared.items():
        if names != default:
            raise RuntimeError(
                f"{relative} does not mirror the default locale: "
                f"missing={sorted(default - names)} extra={sorted(names - default)}"
            )

    referenced = set(XML_REFERENCE.findall(read(decoded / SETTING_XML)))
    java = read(project / SOURCE)
    referenced |= set(JAVA_RESOURCE.findall(java))
    referenced -= EXPECTED_KEYS
    missing = sorted(referenced - default)
    if missing:
        raise RuntimeError(f"Referenced Rime resources are not declared: {missing}")


def verify_listener_lifecycle(decoded: Path) -> None:
    subscribe = f"{FACADE};->addStateListener("
    unsubscribe = f"{FACADE};->removeStateListener("
    controller = read(decoded / RIME_CONTROLLER)
    if subscribe not in smali_body(controller, "bind"):
        raise RuntimeError("The controller must subscribe to state updates while bound")
    if unsubscribe not in smali_body(controller, "destroy"):
        raise RuntimeError("destroy() must unsubscribe from state updates")

    outer = read(decoded / RIME_OUTER)
    if "destroy()V" not in smali_body(outer, "unbind"):
        raise RuntimeError("unbind() must release the controller through destroy()")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    parser.add_argument(
        "--project",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="repository root holding the patch sources",
    )
    args = parser.parse_args()
    decoded = args.decoded.resolve()
    project = args.project.resolve()

    verify_injection(decoded)
    verify_request_code(decoded)
    verify_unconfigured_guard(project)
    verify_localized_resources(decoded, project)
    verify_listener_lifecycle(decoded)

    print(
        "Legacy Rime settings verified: eight entries injected, lifecycle bridged, "
        "tree request code isolated, manual synchronization gated and localized "
        "resources complete"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
