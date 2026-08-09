#!/usr/bin/env python3
"""Reproducibly build the isolated Compose settings host from the original APK."""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]


def run(command: list[str], *, env: dict[str, str] | None = None) -> None:
    print("+", " ".join(command), flush=True)
    subprocess.run(command, cwd=ROOT, env=env, check=True)


def executable(path: Path, arguments: list[str]) -> list[str]:
    if os.name == "nt" and path.suffix.lower() in (".bat", ".cmd"):
        return ["cmd.exe", "/d", "/c", str(path), *arguments]
    return [str(path), *arguments]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--original", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--application-id", required=True)
    parser.add_argument("--apktool", type=Path, required=True)
    parser.add_argument("--apktool-framework", type=Path, required=True)
    parser.add_argument("--gradle", type=Path, required=True)
    parser.add_argument("--sdk", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--keystore", type=Path, required=True)
    parser.add_argument("--key-alias", required=True)
    parser.add_argument("--ks-pass-env", default="MODERN_SETTINGS_KS_PASS")
    parser.add_argument("--key-pass-env", default="MODERN_SETTINGS_KEY_PASS")
    parser.add_argument(
        "--audit-launcher",
        action="store_true",
        help="add an API-35+-guarded launcher entry to an isolated audit package",
    )
    parser.add_argument(
        "--debuggable",
        action="store_true",
        help="build an isolated debug host; forbidden for the formal application ID",
    )
    args = parser.parse_args()

    formal_application_id = "com.google.android.inputmethod.pinyin.compat"
    if args.debuggable and args.application_id == formal_application_id:
        raise RuntimeError("Debug mode is forbidden for the formal application ID")

    for path in (args.original, args.apktool, args.gradle, args.keystore):
        if not path.resolve().exists():
            raise FileNotFoundError(path)
    if args.ks_pass_env not in os.environ or args.key_pass_env not in os.environ:
        raise RuntimeError("signing password environment variables are not set")

    work = args.work.resolve()
    decoded = work / "decoded"
    legacy_apk = work / "patched-legacy.apk"
    legacy_dex = work / "classes.dex"
    unaligned = work / "compose-host-unaligned.apk"
    aligned = work / "compose-host-aligned.apk"
    if work.exists():
        shutil.rmtree(work)
    work.mkdir(parents=True)

    java = args.jdk.resolve() / "bin" / ("java.exe" if os.name == "nt" else "java")
    python = sys.executable
    apktool_base = [str(java), "-jar", str(args.apktool.resolve())]
    framework = str(args.apktool_framework.resolve())

    run(apktool_base + ["d", "-f", "-p", framework, "-o", str(decoded), str(args.original.resolve())])
    run(
        [
            python,
            str(ROOT / "scripts/apply_patches.py"),
            str(decoded),
            "--application-id",
            args.application_id,
            *(["--debuggable"] if args.debuggable else []),
        ]
    )
    # Build once before AGP-specific normalization to obtain the patched legacy
    # DEX with the normal apktool source contract.
    run(apktool_base + ["b", "-p", framework, "-o", str(legacy_apk), str(decoded)])
    with ZipFile(legacy_apk) as archive:
        legacy_dex.write_bytes(archive.read("classes.dex"))

    run([python, str(ROOT / "scripts/prepare_legacy_resources_for_compose.py"), str(decoded)])
    stable_ids = decoded / "stable-ids.txt"
    run(
        [
            python,
            str(ROOT / "scripts/generate_stable_resource_ids.py"),
            str(decoded / "res/values/public.xml"),
            str(stable_ids),
            "--package",
            args.application_id,
        ]
    )
    manifest_command = [
        python,
        str(ROOT / "scripts/prepare_compose_host_manifest.py"),
        str(decoded),
        "--package",
        args.application_id,
    ]
    if args.audit_launcher:
        manifest_command.append("--audit-launcher")
    run(manifest_command)

    gradle_home = ROOT / "work/modern-settings-gradle-home"
    gradle_home.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["JAVA_HOME"] = str(args.jdk.resolve())
    env["ANDROID_HOME"] = str(args.sdk.resolve())
    env["ANDROID_SDK_ROOT"] = str(args.sdk.resolve())
    env["GRADLE_USER_HOME"] = str(gradle_home.resolve())
    variant = "debug" if args.debuggable else "release"
    gradle_task = "assembleDebug" if args.debuggable else "assembleRelease"
    gradle_args = [
        "-p",
        str(ROOT / "modern-settings"),
        ":reconstructed-host-prototype:clean",
        f":reconstructed-host-prototype:{gradle_task}",
        f"-PlegacyHostDir={decoded}",
        f"-PhostApplicationId={args.application_id}",
    ]
    run(executable(args.gradle.resolve(), gradle_args), env=env)

    if variant == "release":
        host_apk = ROOT / (
            "modern-settings/reconstructed-host-prototype/build/outputs/apk/release/"
            "reconstructed-host-prototype-release-unsigned.apk"
        )
    else:
        host_apk = ROOT / (
            "modern-settings/reconstructed-host-prototype/build/outputs/apk/debug/"
            "reconstructed-host-prototype-debug.apk"
        )
    run(
        [
            python,
            str(ROOT / "scripts/assemble_compose_host_apk.py"),
            "--host",
            str(host_apk),
            "--legacy-dex",
            str(legacy_dex),
            "--original",
            str(args.original.resolve()),
            "--output",
            str(unaligned),
        ]
    )

    build_tools = args.sdk.resolve() / "build-tools/36.0.0"
    zipalign = build_tools / ("zipalign.exe" if os.name == "nt" else "zipalign")
    apksigner = build_tools / ("apksigner.bat" if os.name == "nt" else "apksigner")
    run([str(zipalign), "-P", "16", "-f", "4", str(unaligned), str(aligned)])

    args.output.resolve().parent.mkdir(parents=True, exist_ok=True)
    sign_args = [
        "sign",
        "--ks",
        str(args.keystore.resolve()),
        "--ks-key-alias",
        args.key_alias,
        "--ks-pass",
        f"env:{args.ks_pass_env}",
        "--key-pass",
        f"env:{args.key_pass_env}",
        "--out",
        str(args.output.resolve()),
        str(aligned),
    ]
    run(executable(apksigner, sign_args), env=env)
    run(executable(apksigner, ["verify", "--verbose", str(args.output.resolve())]), env=env)
    run([str(zipalign), "-c", "-P", "16", "4", str(args.output.resolve())])
    print(f"built {args.output.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
