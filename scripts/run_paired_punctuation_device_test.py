#!/usr/bin/env python3
"""Build a fixture and test composing backspace with an isolated audit IME.

Requires an already built audit APK. Formal package data, user dictionaries,
clipboard and existing app contents are not accessed. Screenshots are off by
default; --capture-on-failure requires explicit authorization for that run.
"""
from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import subprocess
import sys
from zipfile import ZipFile
import uuid

ROOT = Path(__file__).resolve().parents[1]
AUDIT = "com.google.android.inputmethod.pinyin.pairdeleteaudit"
FIXTURE = "com.google.android.inputmethod.pinyin.pairdeletefixture"
TEST = FIXTURE + ".PairedPunctuationDeviceTest"
SERVICE = AUDIT + "/com.google.android.inputmethod.pinyin.PinyinIME"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sdk", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--audit-apk", type=Path, required=True)
    parser.add_argument("--keystore", type=Path, required=True)
    parser.add_argument("--key-alias", required=True)
    parser.add_argument("--password-env", default="MODERN_SETTINGS_KS_PASS")
    parser.add_argument("--serial", required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--capture-on-failure", type=Path,
                        help="explicitly authorized fixture screenshot destination under work/device")
    args = parser.parse_args()
    if args.capture_on_failure:
        args.capture_on_failure = args.capture_on_failure.resolve()
        if not args.capture_on_failure.is_relative_to(ROOT / "work/device"):
            raise RuntimeError("fixture screenshots must stay under work/device")
    device_capture = f"/sdcard/pair-delete-fixture-{uuid.uuid4().hex}.png" if args.capture_on_failure else None
    work = args.work.resolve()
    work.mkdir(parents=True, exist_ok=True)
    tools = args.sdk.resolve() / "build-tools/36.0.0"
    java = args.jdk.resolve() / "bin/java.exe"
    android = args.sdk.resolve() / "platforms/android-36/android.jar"
    env = os.environ.copy()
    env.pop("ADB_SERVER_SOCKET", None)
    if args.password_env not in env:
        raise RuntimeError("isolated signing password environment is not set")

    def run(command: list[str], timeout: int = 60) -> str:
        result = subprocess.run(command, env=env, text=True, encoding="utf-8", errors="replace",
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
        if result.returncode:
            raise RuntimeError(f"{Path(command[0]).name} failed ({result.returncode}): {result.stdout}")
        return result.stdout

    def adb(*command: str, timeout: int = 30) -> str:
        return run([str(args.sdk.resolve() / "platform-tools/adb.exe"), "-s", args.serial,
                    *command], timeout)

    badging = run([str(tools / "aapt.exe"), "dump", "badging", str(args.audit_apk.resolve())])
    if f"package: name='{AUDIT}'" not in badging:
        raise RuntimeError("this test requires the dedicated paired-delete audit ID")
    metadata = [line for line in badging.splitlines()
                if line.startswith(("package:", "sdkVersion:", "targetSdkVersion:", "application-debuggable"))]
    metadata.append("sha256=" + hashlib.sha256(args.audit_apk.read_bytes()).hexdigest())
    (work / "audit-metadata.txt").write_text("\n".join(metadata), encoding="utf-8")
    print("\n".join(metadata))
    if adb("get-state").strip() != "device":
        raise RuntimeError("selected device is not ready")
    for package in (AUDIT, FIXTURE):
        if f"package:{package}" in adb("shell", "pm", "list", "packages", package).splitlines():
            raise RuntimeError(f"refusing to replace an existing test package: {package}")
    old_ime = adb("shell", "settings", "get", "secure", "default_input_method").strip()
    if not old_ime or old_ime == "null":
        raise RuntimeError("cannot preserve the initial default IME")

    manifest = work / "AndroidManifest.xml"
    manifest.write_text(f'''<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="{FIXTURE}">
  <uses-sdk android:minSdkVersion="23" android:targetSdkVersion="36" />
  <application android:theme="@android:style/Theme.Material.Light.NoActionBar" android:label="Pair Delete Fixture">
    <activity android:name="{TEST}$Editor" android:exported="true" android:windowSoftInputMode="stateAlwaysVisible|adjustResize" />
  </application>
  <instrumentation android:name="{TEST}" android:targetPackage="{FIXTURE}" />
</manifest>''', encoding="utf-8")
    classes, dex = work / "classes", work / "dex"
    classes.mkdir(exist_ok=True)
    dex.mkdir(exist_ok=True)
    source = ROOT / "scripts/device-tests/paired-punctuation/PairedPunctuationDeviceTest.java"
    run([str(args.jdk.resolve() / "bin/javac.exe"), "-encoding", "UTF-8", "-source", "8", "-target", "8",
         "-classpath", str(android), "-d", str(classes), str(source)])
    run([str(java), "-cp", str(tools / "lib/d8.jar"), "com.android.tools.r8.D8", "--min-api", "23",
         "--lib", str(android), "--output", str(dex), *map(str, classes.rglob("*.class"))])
    unsigned, aligned, signed = work / "fixture-unsigned.apk", work / "fixture-aligned.apk", work / "fixture.apk"
    run([str(tools / "aapt.exe"), "package", "-f", "-M", str(manifest), "-I", str(android), "-F", str(unsigned)])
    with ZipFile(unsigned, "a") as archive:
        archive.write(dex / "classes.dex", "classes.dex")
    run([str(tools / "zipalign.exe"), "-f", "4", str(unsigned), str(aligned)])
    signer = [str(java), "-jar", str(tools / "lib/apksigner.jar")]
    run([*signer, "sign", "--ks", str(args.keystore.resolve()), "--ks-key-alias", args.key_alias,
         "--ks-pass", "env:" + args.password_env, "--key-pass", "env:" + args.password_env,
         "--out", str(signed), str(aligned)])
    run([*signer, "verify", str(signed)])
    installed: list[str] = []
    try:
        for package, apk in ((AUDIT, args.audit_apk.resolve()), (FIXTURE, signed)):
            print(adb("install", str(apk), timeout=60).strip())
            installed.append(package)
        adb("shell", "ime", "enable", SERVICE)
        adb("shell", "ime", "set", SERVICE)
        capture_args = ["-e", "capture_path", device_capture] if device_capture else []
        result = adb("shell", "am", "instrument", "-w", "-r", *capture_args, f"{FIXTURE}/{TEST}", timeout=180)
        (work / "device-result.txt").write_text(result, encoding="utf-8")
        print(result)
        if args.capture_on_failure and "capture=OK" in result:
            args.capture_on_failure.parent.mkdir(parents=True, exist_ok=True)
            adb("pull", device_capture, str(args.capture_on_failure))
            print(f"Captured dedicated fixture: {args.capture_on_failure}")
        if "paired_delete=PASS" not in result or "INSTRUMENTATION_CODE: -1" not in result:
            raise RuntimeError("paired punctuation device regression did not pass")
    finally:
        errors: list[str] = []
        commands = [("shell", "rm", "-f", device_capture)] if device_capture else []
        commands += [("shell", "ime", "set", old_ime), ("shell", "ime", "disable", SERVICE)]
        commands += [("uninstall", package) for package in reversed(installed)]
        commands.append(("shell", "input", "keyevent", "KEYCODE_HOME"))
        for command in commands:
            try:
                adb(*command, timeout=45)
            except RuntimeError as error:
                errors.append(str(error))
        if errors:
            raise RuntimeError("device restoration incomplete: " + "\n".join(errors))
        print("Restored original default IME and removed this run's isolated packages")


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    main()
