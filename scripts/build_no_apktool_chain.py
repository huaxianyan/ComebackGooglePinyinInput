#!/usr/bin/env python3
"""Build the APK without apktool's rebuild step.

The decode still produces apktool's tree shape (the patch scripts and every
verifier are written against it), but nothing downstream calls `apktool b`:
the legacy DEX is assembled with the standalone smali toolchain, resources go
through aapt2 inside the Compose host build, and the package is assembled by
`assemble_compose_host_apk.py`. Native libraries come from the decoded tree,
which `apply_patches.py` has already re-laid out for 16 KiB pages.

Equivalent output to the regular pipeline is verified in
docs/no-apktool-build-evaluation.md; run the normal pipeline for releases
unless this chain is the agreed build path.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path
from urllib.request import urlopen

ROOT = Path(__file__).resolve().parents[1]

SMALI_ARTIFACTS = {
    "smali-2.5.2.jar": "org/smali/smali/2.5.2/smali-2.5.2.jar",
    "dexlib2-2.5.2.jar": "org/smali/dexlib2/2.5.2/dexlib2-2.5.2.jar",
    "util-2.5.2.jar": "org/smali/util/2.5.2/util-2.5.2.jar",
    "guava-31.0.1-jre.jar": "com/google/guava/guava/31.0.1-jre/guava-31.0.1-jre.jar",
    "jcommander-1.78.jar": "com/beust/jcommander/1.78/jcommander-1.78.jar",
    "antlr-runtime-3.5.2.jar": "org/antlr/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar",
}
MAVEN = "https://repo1.maven.org/maven2/"


def run(command: list[str], env: dict[str, str] | None = None) -> None:
    subprocess.run(command, check=True, env=env)


def ensure_smali_jars(cache: Path) -> str:
    cache.mkdir(parents=True, exist_ok=True)
    for name, artifact in SMALI_ARTIFACTS.items():
        target = cache / name
        if not target.exists():
            print(f"downloading {name}", flush=True)
            target.write_bytes(urlopen(MAVEN + artifact).read())
    return ";".join(str(cache / name) for name in SMALI_ARTIFACTS)


def swap_native_libraries(merged: Path, decoded: Path) -> int:
    """Replace the merge's copied libraries with the rewritten decoded ones.

    `assemble_compose_host_apk.py` copies everything except DEX, res and the
    manifest from the original package, so the re-laid-out libraries would be
    silently overwritten without this step.
    """
    replacements: dict[str, bytes] = {}
    for library in sorted((decoded / "lib").rglob("*.so")):
        replacements[library.relative_to(decoded).as_posix()] = library.read_bytes()
    temporary = merged.with_suffix(".libs.apk")
    swapped = 0
    with zipfile.ZipFile(merged) as source, \
            zipfile.ZipFile(temporary, "w") as target:
        for item in source.infolist():
            data = source.read(item.filename)
            if item.filename in replacements:
                data = replacements[item.filename]
                swapped += 1
            info = zipfile.ZipInfo(item.filename, date_time=item.date_time)
            info.compress_type = item.compress_type
            target.writestr(info, data)
    assert swapped == len(replacements), f"only swapped {swapped}/{len(replacements)} libraries"
    os.replace(temporary, merged)
    return swapped


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--original", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--application-id", required=True)
    parser.add_argument("--version-name", required=True)
    parser.add_argument("--version-code", type=int, required=True)
    parser.add_argument("--apktool", type=Path, required=True,
                        help="apktool jar, used for the decode step only")
    parser.add_argument("--apktool-framework", type=Path, required=True)
    parser.add_argument("--gradle", type=Path, required=True)
    parser.add_argument("--sdk", required=True)
    parser.add_argument("--jdk", required=True)
    parser.add_argument("--build-tools", required=True)
    parser.add_argument("--android-jar", required=True)
    parser.add_argument("--keystore", type=Path, required=True)
    parser.add_argument("--key-alias", required=True)
    parser.add_argument("--ks-pass-env", default="NO_APKTOOL_KS_PASS")
    parser.add_argument("--key-pass-env", default="NO_APKTOOL_KEY_PASS")
    args = parser.parse_args()

    sdk = Path(args.sdk)
    jdk = Path(args.jdk)
    build_tools = Path(args.build_tools)
    aapt2 = build_tools / "aapt2.exe"
    zipalign = build_tools / "zipalign.exe"
    apksigner = build_tools / "apksigner.bat"
    work = args.work.resolve()
    work.mkdir(parents=True, exist_ok=True)

    env = os.environ.copy()
    env["JAVA_HOME"] = str(jdk)
    # The machine convention keeps one warm Gradle cache; a private cache
    # would re-download the whole distribution.
    env["GRADLE_USER_HOME"] = str(ROOT / "work/modern-settings-gradle-home")
    env["ANDROID_HOME"] = str(sdk)

    java = jdk / "bin/java.exe"

    print("[1/7] decode", flush=True)
    decoded = work / "decoded"
    run([str(java), "-jar", str(args.apktool), "d", "-f", "-q",
         str(args.original), "-o", str(decoded)])

    print("[2/7] apply patches (also re-lays out native libraries)", flush=True)
    run([sys.executable, str(ROOT / "scripts/apply_patches.py"), str(decoded),
         "--application-id", args.application_id,
         "--version-name", args.version_name,
         "--version-code", str(args.version_code)])

    print("[3/7] prepare host resources and manifest", flush=True)
    run([sys.executable, str(ROOT / "scripts/prepare_legacy_resources_for_compose.py"), str(decoded)])
    run([sys.executable, str(ROOT / "scripts/prepare_compose_host_manifest.py"), str(decoded),
         "--package", args.application_id])
    stable_ids = decoded / "stable-ids.txt"
    run([sys.executable, str(ROOT / "scripts/generate_stable_resource_ids.py"),
         str(decoded / "res/values/public.xml"), str(stable_ids),
         "--package", args.application_id])

    print("[4/7] Compose host via gradle", flush=True)
    # The machine's global ANDROID_HOME may point elsewhere; the Gradle daemon
    # caches whichever SDK it started with, so pin the location on disk instead
    # of relying on the environment.
    local_properties = ROOT / "modern-settings/local.properties"
    # Java properties treat backslashes as escapes; use forward slashes.
    local_properties.write_text(
        "sdk.dir=" + sdk.as_posix() + chr(10), encoding="utf-8"
    )
    variant = "release"
    gradle_args = [
        "cmd", "/c", str(args.gradle), "-p", str(ROOT / "modern-settings"),
        ":reconstructed-host-prototype:assembleRelease",
        f"-PlegacyHostDir={decoded}",
        f"-PhostApplicationId={args.application_id}",
        f"-PhostVersionName={args.version_name}",
        f"-PhostVersionCode={args.version_code}",
        "-q",
    ]
    run(gradle_args, env=env)
    host_apk = (ROOT / "modern-settings/reconstructed-host-prototype/build/outputs/apk/"
                "release/reconstructed-host-prototype-release-unsigned.apk")

    print("[5/7] legacy DEX via standalone smali", flush=True)
    smali_classpath = ensure_smali_jars(work / "smali-tools")
    legacy_dex = work / "legacy.dex"
    run([sys.executable, str(ROOT / "scripts/build_no_apktool.py"),
         "--decoded", str(decoded), "--original", str(args.original),
         "--output", str(legacy_dex), "--android-jar", str(args.android_jar),
         "--aapt2", str(aapt2), "--smali-classpath", smali_classpath,
         "--stable-ids", str(stable_ids),
         "--manifest-package", args.application_id, "--dex-only"])

    print("[6/7] merge, swap libraries, align", flush=True)
    merged_unsigned = work / "merged-unsigned.apk"
    run([sys.executable, str(ROOT / "scripts/assemble_compose_host_apk.py"),
         "--host", str(host_apk), "--legacy-dex", str(legacy_dex),
         "--original", str(args.original), "--output", str(merged_unsigned)])
    swapped = swap_native_libraries(merged_unsigned, decoded)
    print(f"swapped {swapped} native libraries", flush=True)
    aligned = work / "merged-aligned.apk"
    run([str(zipalign), "-P", "16", "-f", "4", str(merged_unsigned), str(aligned)])

    print("[7/7] sign and audit", flush=True)
    store_pass = os.environ[args.ks_pass_env]
    key_pass = os.environ[args.key_pass_env]
    args.output.parent.mkdir(parents=True, exist_ok=True)
    run([str(apksigner), "sign", "--ks", str(args.keystore),
         "--ks-pass", f"pass:{store_pass}", "--ks-key-alias", args.key_alias,
         "--out", str(args.output), str(aligned)], env=env)
    run([str(apksigner), "verify", str(args.output)], env=env)
    run([sys.executable, str(ROOT / "scripts/audit_elf_page_size.py"), str(args.output)])
    print(f"built {args.output} ({args.output.stat().st_size} bytes)", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
