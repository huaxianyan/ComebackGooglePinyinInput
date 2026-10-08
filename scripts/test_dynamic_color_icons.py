#!/usr/bin/env python3
"""Build and run the checked-in Android mask fixture against an isolated audit APK."""
from __future__ import annotations

import argparse
import os
import subprocess
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'scripts/fixtures/dynamic_color/ColorProbe.java'
PACKAGE = 'com.example.dynamiccolorfixture'
COMPONENT = PACKAGE + '/.ColorProbe'


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sdk', type=Path, required=True)
    parser.add_argument('--jdk', type=Path, required=True)
    parser.add_argument('--serial', required=True)
    parser.add_argument('--keystore', type=Path, required=True)
    parser.add_argument('--key-alias', required=True)
    parser.add_argument('--target-package', default='com.google.android.inputmethod.pinyin.colorroleaudit')
    parser.add_argument('--work', type=Path, default=ROOT / 'work/dynamic-color-icon-fixture')
    args = parser.parse_args()
    if not args.target_package.endswith('.colorroleaudit'):
        parser.error('Only the isolated colorroleaudit target is supported')
    if not os.environ.get('STORE_PASSWORD') or not os.environ.get('KEY_PASSWORD'):
        parser.error('Set STORE_PASSWORD and KEY_PASSWORD through the signing environment')

    work = args.work.resolve()
    work.mkdir(parents=True, exist_ok=True)
    tools = args.sdk.resolve() / 'build-tools/36.0.0'
    android = args.sdk.resolve() / 'platforms/android-36/android.jar'
    jdk = args.jdk.resolve() / 'bin'
    env = os.environ.copy()
    env.pop('ADB_SERVER_SOCKET', None)
    env['JAVA_HOME'] = str(args.jdk.resolve())
    env['PATH'] = str(jdk) + os.pathsep + env.get('PATH', '')
    env['TEMP'] = env['TMP'] = str(work)

    def run(command: list[str], timeout: int = 30) -> str:
        output = subprocess.run(command, env=env, check=True, capture_output=True,
                                text=True, encoding='utf-8', errors='replace', timeout=timeout)
        return output.stdout

    classes, dex = work / 'classes', work / 'dex'
    classes.mkdir(exist_ok=True)
    dex.mkdir(exist_ok=True)
    run([str(jdk / 'javac.exe'), '-source', '7', '-target', '7', '-bootclasspath',
         str(android), '-d', str(classes), str(SOURCE)])
    jar = work / 'fixture.jar'
    run([str(jdk / 'jar.exe'), 'cf', str(jar), '-C', str(classes), '.'])
    run([str(tools / 'd8.bat'), '--min-api', '31', '--lib', str(android),
         '--output', str(dex), str(jar)])
    manifest = work / 'AndroidManifest.xml'
    manifest.write_text(
        '<manifest xmlns:android="http://schemas.android.com/apk/res/android" '
        f'package="{PACKAGE}"><uses-sdk android:minSdkVersion="31" '
        'android:targetSdkVersion="36"/><application android:label="Dynamic color fixture"/>'
        '<instrumentation android:name=".ColorProbe" '
        f'android:targetPackage="{args.target_package}"/></manifest>', encoding='utf-8')
    raw, aligned, signed = work / 'raw.apk', work / 'aligned.apk', work / 'fixture.apk'
    run([str(tools / 'aapt2.exe'), 'link', '-I', str(android), '--manifest',
         str(manifest), '-o', str(raw)])
    with zipfile.ZipFile(raw, 'a') as archive:
        archive.write(dex / 'classes.dex', 'classes.dex')
    run([str(tools / 'zipalign.exe'), '-f', '4', str(raw), str(aligned)])
    run([str(tools / 'apksigner.bat'), 'sign', '--ks', str(args.keystore.resolve()),
         '--ks-key-alias', args.key_alias, '--ks-pass', 'env:STORE_PASSWORD',
         '--key-pass', 'env:KEY_PASSWORD', '--out', str(signed), str(aligned)])
    adb = [str(args.sdk.resolve() / 'platform-tools/adb.exe'), '-s', args.serial]
    installed = False
    try:
        # No replacement: an existing package is outside this run's cleanup ownership.
        print(run(adb + ['install', str(signed)], timeout=60).strip())
        installed = True
        output = run(adb + ['shell', 'am', 'instrument', '-w', COMPONENT], timeout=60)
        (work / 'result.txt').write_text(output, encoding='utf-8')
        print(output.strip())
        if 'INSTRUMENTATION_RESULT: result=PASS' not in output:
            raise RuntimeError('Dynamic icon fixture failed; see result.txt')
    finally:
        if installed:
            print(run(adb + ['uninstall', PACKAGE]).strip())
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
