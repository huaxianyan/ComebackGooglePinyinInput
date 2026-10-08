#!/usr/bin/env python3
"""Check native sheet rewriting and fixed role/state fixtures from a clean checkout."""
from __future__ import annotations

import argparse
import os
import re
import subprocess
import tempfile
from pathlib import Path
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java'
TEMPLATES = tuple(f'style_sheet_material_{mode}{border}.binarypb'
                  for mode in ('light', 'dark') for border in ('', '_border'))

HARNESS = r'''
import com.google.android.inputmethod.pinyin.SystemAutoThemeCompat;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

public final class RewriteHarness {
    public static void main(String[] args) throws Exception {
        if (args[0].equals("roles")) {
            Map<String, Integer> roles = parse("base=ff19191b,surface=ff0e0e0f,letter=ff2b2c2f,"
                + "high=ff232428,highest=ff36373a,on_surface=ffe7e5e8,function=ff3a3b41,"
                + "on_function=ffbfbfc5,primary=ffc2c6d6,primary_container=ff44495e,outline=ff46484d");
            java.lang.reflect.Method method = SystemAutoThemeCompat.class.getDeclaredMethod(
                "dynamicStyleColors", Map.class, boolean.class, boolean.class);
            method.setAccessible(true);
            emit("dark-border", (Map<String, Integer>)method.invoke(null, roles, true, true));
            emit("dark-plain", (Map<String, Integer>)method.invoke(null, roles, true, false));
            emit("light-border", (Map<String, Integer>)method.invoke(null, roles, false, true));
        } else {
            byte[] result = SystemAutoThemeCompat.rewriteStyleSheetColors(
                Files.readAllBytes(Paths.get(args[0])), parse(args[1]));
            Files.write(Paths.get(args[2]), result);
        }
    }
    private static Map<String, Integer> parse(String input) {
        Map<String, Integer> colors = new HashMap<String, Integer>();
        for (String pair : input.split(",")) {
            String[] parts = pair.split("=");
            colors.put(parts[0], Integer.valueOf((int)Long.parseLong(parts[1], 16)));
        }
        return colors;
    }
    private static void emit(String label, Map<String, Integer> values) {
        for (Map.Entry<String, Integer> entry : new TreeMap<String, Integer>(values).entrySet()) {
            System.out.println(label + ":" + entry.getKey() + "=" + Integer.toHexString(entry.getValue()));
        }
    }
}
'''


def varint(data: bytes, pos: int) -> tuple[int, int]:
    result = shift = 0
    while True:
        byte = data[pos]
        pos += 1
        result |= (byte & 127) << shift
        if byte < 128:
            return result, pos
        shift += 7


def encode(value: int) -> bytes:
    result = bytearray()
    while value > 127:
        result.append((value & 127) | 128)
        value >>= 7
    result.append(value)
    return bytes(result)


def field_bytes(tag: int, payload: bytes) -> bytes:
    return bytes([tag]) + encode(len(payload)) + payload


def fields(data: bytes):
    pos = 0
    while pos < len(data):
        start = pos
        tag, pos = varint(data, pos)
        if tag & 7 == 2:
            size, pos = varint(data, pos)
            value = data[pos:pos + size]
            pos += size
        elif tag & 7 == 0:
            value, pos = varint(data, pos)
        else:
            raise ValueError(f'Unexpected sheet wire type {tag & 7}')
        yield tag, value, data[start:pos]


def sheet_values(data: bytes) -> dict[str, int]:
    values = {}
    for tag, body, _ in fields(data):
        if tag != 18:
            continue
        parts = {t: v for t, v, _ in fields(body)}
        value_parts = dict((t, v) for t, v, _ in fields(parts[18]))
        if 8 in value_parts:
            values[parts[10].decode()] = value_parts[8]
    return values


def reference_rewrite(data: bytes, colors: dict[str, int]) -> bytes:
    """Independent wire-level reference; preserve existing field order and selectors."""
    output = bytearray()
    present = set()
    for tag, body, raw in fields(data):
        if tag != 18:
            output += raw
            continue
        parts = list(fields(body))
        name = next(v.decode() for t, v, _ in parts if t == 10)
        present.add(name)
        replacement = colors.get(name)
        if replacement is None:
            output += raw
            continue
        encoded_body = bytearray()
        for inner_tag, value, original in parts:
            if inner_tag == 18:
                encoded_body += field_bytes(18, b'\x08' + encode(replacement))
            else:
                encoded_body += original
        output += field_bytes(18, encoded_body)
    for name in sorted(colors.keys() - present):
        body = field_bytes(10, name.encode()) + field_bytes(18, b'\x08' + encode(colors[name]))
        output += field_bytes(18, body)
    return bytes(output)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--android-jar', type=Path, required=True)
    parser.add_argument('--jdk', type=Path, required=True)
    parser.add_argument('--template-dir', type=Path)
    parser.add_argument('--apk', type=Path)
    args = parser.parse_args()
    if args.template_dir:
        templates = {name: (args.template_dir / name).read_bytes() for name in TEMPLATES}
    else:
        apk = args.apk or ROOT / 'original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk'
        with ZipFile(apk) as archive:
            templates = {name: archive.read('assets/theme/' + name) for name in TEMPLATES}

    source = SOURCE.read_text(encoding='utf-8')
    table = re.search(r'DYNAMIC_STYLE_ROLES\s*=\s*\{(.*?)\};', source, re.S).group(1)
    names = re.findall(r'\{"([^"]+)"', table)
    names += re.findall(r'colors\.put\("([^"]+)"', source)
    names = sorted(set(names))
    # Arbitrary externally assigned inputs, not expected values derived from the role resolver.
    colors = {name: 0xff123400 + index for index, name in enumerate(names)}
    encoded = ','.join(f'{name}={value:08x}' for name, value in colors.items())
    with tempfile.TemporaryDirectory(prefix='dynamic-rewrite-') as temporary:
        work = Path(temporary)
        harness = work / 'RewriteHarness.java'
        harness.write_text(HARNESS, encoding='utf-8')
        classes = work / 'classes'
        classes.mkdir()
        subprocess.run([str(args.jdk / 'bin/javac.exe'), '-source', '7', '-target', '7',
                        '-classpath', str(args.android_jar), '-d', str(classes), str(SOURCE), str(harness)],
                       check=True, timeout=30)
        command = [str(args.jdk / 'bin/java.exe'), '-cp', f'{classes}{os.pathsep}{args.android_jar}',
                   'RewriteHarness']
        result = subprocess.run(command + ['roles'], check=True, capture_output=True,
                                text=True, timeout=10)
        actual = dict(line.split('=', 1) for line in result.stdout.splitlines())
        expected = {
            'dark-border:color_state_border_key_action': 'ff3a3b41',
            'dark-border:color_icon_action': 'ffbfbfc5',
            'dark-border:color_icon': 'ffbfbfc5',
            'dark-border:color_state_key_dark_pressed': 'ff47484e',
            'dark-border:color_state_key_pressed': 'ff3d3e41',
            'dark-plain:color_base': 'ff19191b',
            'dark-plain:color_icon': 'ffe7e5e8',
            'dark-plain:color_state_action': 'ff3a3b41',
            'light-border:color_state_key_pressed': 'ff36373a',
        }
        for name, value in expected.items():
            assert actual.get(name) == value, (name, value, actual.get(name))
        print('Action foreground, key contrast and pressed roles: PASS')
        for name, data in templates.items():
            src, dst = work / 'source.pb', work / 'result.pb'
            src.write_bytes(data)
            subprocess.run(command + [str(src), encoded, str(dst)], check=True, timeout=10)
            output = dst.read_bytes()
            assert output == reference_rewrite(data, colors), name + ': wire output differs'
            values = sheet_values(output)
            assert all(values.get(key) == value for key, value in colors.items()), name
            print(f'{name}: MATCH, {len(colors)} assigned colors present')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
