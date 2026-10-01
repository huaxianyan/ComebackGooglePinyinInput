#!/usr/bin/env python3
"""Stage A gate: the Java and Python StyleSheet recoloring must agree byte for byte.

The device-verified probe recolored the style sheet in Python. The shipped
implementation recolors it in Java. If the two ever diverge, the package that
ships is not the package that was verified, so this script compiles the Java
rewriter, runs it against the real templates, runs the Python rewriter on the
same inputs, and compares the SHA-256 of both outputs.

It also asserts that every slot named in the Java mapping actually exists in the
template. A mapping entry that matches no rule would be silently dead.

Two things keep this runnable from a clean checkout:

* The Python reference below is a verbatim copy of
  ``work/dynamic-color-probe/style_sheet_tool.py``. ``work/`` is not tracked, so
  a copy is the only way CI can run this gate. When the probe *is* present the
  script cross-checks the two and fails if they have drifted apart.
* Templates come from a decoded tree when one exists and straight out of the
  original APK otherwise, so no decode step is required.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java"
PROBE = ROOT / "work/dynamic-color-probe"
PROBE_TOOL = PROBE / "style_sheet_tool.py"
TEMPLATES = ("style_sheet_material_light.binarypb", "style_sheet_material_dark.binarypb")
ASSET_PREFIX = "assets/theme/"

# A decoded tree is a build artifact and gets recreated under different names,
# so search the known locations instead of pinning one that may have been
# rebuilt since.
TEMPLATE_CANDIDATES = (
    "work/decoded/assets/theme",
    "work/dyn-host/decoded/assets/theme",
    "work/decoded-dyn/assets/theme",
    "work/decoded-fresh/assets/theme",
    "work/decoded-verify/assets/theme",
)

# Keyboard style slot -> system color resource name. Mirrors the mapping the
# device probe used, so the measured colors can be replayed without importing
# the probe module.
PROBE_MAPPING = {
    "color_base": "system_surface_light",
    "color_header": "system_surface_container_light",
    "color_popup_background": "system_surface_container_high_light",
    "color_access_points_menu_background": "system_surface_light",
    "color_access_point_panel_item_background": "system_surface_light",
    "color_label": "system_on_surface_light",
    "color_label_header_active": "system_on_surface_light",
    "color_popup_label": "system_on_surface_light",
    "color_icon": "system_on_surface_variant_light",
    "color_state_action": "system_primary_light",
    "color_state_action_pressed": "system_primary_container_light",
    "color_action_default": "system_primary_light",
    "color_label_dynamic": "system_primary_light",
    "color_keyboard_editing_button": "system_primary_light",
    "color_keyboard_editing_button_background": "system_primary_container_light",
    "color_key_paging_scrollbar": "system_primary_light",
    "color_notice_text": "system_primary_light",
    "color_state_popup_item_pressed": "system_primary_container_light",
    "color_generic_extension_background_activated": "system_secondary_container_light",
    "color_keyboard_separator": "system_outline_variant_light",
}

HARNESS = """
import com.google.android.inputmethod.pinyin.SystemAutoThemeCompat;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

public final class RewriteHarness {
    public static void main(String[] args) throws Exception {
        byte[] source = read(new File(args[0]));
        Map<String, Integer> colors = new HashMap<String, Integer>();
        String[] pairs = args[1].split(",");
        for (int index = 0; index < pairs.length; index++) {
            String pair = pairs[index];
            if (pair.length() == 0) {
                continue;
            }
            int equals = pair.indexOf('=');
            colors.put(
                    pair.substring(0, equals),
                    Integer.valueOf((int) Long.parseLong(pair.substring(equals + 1), 16)));
        }
        byte[] result = SystemAutoThemeCompat.rewriteStyleSheetColors(source, colors);
        if (result == null) {
            throw new IllegalStateException("rewriteStyleSheetColors returned null");
        }
        FileOutputStream output = new FileOutputStream(args[2]);
        output.write(result);
        output.close();
    }

    private static byte[] read(File file) throws Exception {
        FileInputStream input = new FileInputStream(file);
        byte[] buffer = new byte[(int) file.length()];
        int offset = 0;
        while (offset < buffer.length) {
            int read = input.read(buffer, offset, buffer.length - offset);
            if (read <= 0) {
                break;
            }
            offset += read;
        }
        input.close();
        return buffer;
    }
}
"""

# --------------------------------------------------------------------------
# Verbatim copy of work/dynamic-color-probe/style_sheet_tool.py.
# Keep byte-compatible with the probe; the cross-check below enforces it.
# --------------------------------------------------------------------------


def read_varint(buf, pos):
    value = 0
    shift = 0
    while True:
        b = buf[pos]
        pos += 1
        value |= (b & 0x7F) << shift
        if not (b & 0x80):
            break
        shift += 7
    return value, pos


def write_varint(value):
    out = bytearray()
    while True:
        b = value & 0x7F
        value >>= 7
        if value:
            out.append(b | 0x80)
        else:
            out.append(b)
            break
    return bytes(out)


def parse_rules(data):
    """Return list of (name, color_or_None, offset_span)."""
    rules = []
    pos = 0
    total = len(data)

    while pos < total:
        tag = data[pos]
        if tag != 0x12:
            break
        pos += 1
        length, pos = read_varint(data, pos)
        rule_start = pos
        rule_end = pos + length

        name = None
        color = None

        rp = rule_start
        while rp < rule_end:
            ftag = data[rp]
            rp += 1
            if ftag == 0x0A:
                nlen, rp = read_varint(data, rp)
                name = data[rp:rp + nlen].decode("utf-8", "replace")
                rp += nlen
            elif ftag == 0x12:
                vlen, rp = read_varint(data, rp)
                vstart = rp
                vend = rp + vlen
                if vstart < vend and data[vstart] == 0x08:
                    cp = vstart + 1
                    color, cp = read_varint(data, cp)
                rp = vend
            elif ftag == 0x1A:
                _, rp = read_varint(data, rp)
            else:
                rp = rule_end

        rules.append({"name": name, "color": color, "span": (rule_start, rule_end)})
        pos = rule_end

    return rules


def rebuild_with_colors(data, color_map):
    """Rebuild data, replacing colors for names present in color_map."""
    rules = parse_rules(data)
    out = bytearray()
    changed = []

    for rule in rules:
        start, end = rule["span"]
        name = rule["name"]
        rule_body = bytearray(data[start:end])

        if name in color_map and rule["color"] is not None:
            new_color = color_map[name] & 0xFFFFFFFF
            new_body = bytearray()

            nb = name.encode("utf-8")
            new_body.append(0x0A)
            new_body += write_varint(len(nb))
            new_body += nb

            inner = bytes([0x08]) + write_varint(new_color)
            new_body.append(0x12)
            new_body += write_varint(len(inner))
            new_body += inner

            sp = 0
            while sp < len(rule_body):
                if rule_body[sp] == 0x1A:
                    sp += 1
                    val, sp2 = read_varint(rule_body, sp)
                    new_body.append(0x1A)
                    new_body += write_varint(val)
                    sp = sp2
                    break
                else:
                    break

            out.append(0x12)
            out += write_varint(len(new_body))
            out += new_body
            changed.append((name, rule["color"], new_color))
        else:
            out.append(0x12)
            out += write_varint(len(rule_body))
            out += rule_body

    return bytes(out), changed


# --------------------------------------------------------------------------


def java_slot_names(source: str) -> list[str]:
    """Read the slot list out of the shipped Java so the gate cannot drift from it."""
    block = re.search(r"DYNAMIC_SLOT_NAMES\s*=\s*\{(.*?)\};", source, re.DOTALL)
    if not block:
        raise RuntimeError("DYNAMIC_SLOT_NAMES not found in " + str(SOURCE))
    names = re.findall(r'"([^"]+)"', block.group(1))
    if not names:
        raise RuntimeError("DYNAMIC_SLOT_NAMES is empty")
    return names


def load_templates(template_dir: Path | None, apk: Path | None) -> tuple[dict[str, bytes], str]:
    """Return the templates plus a note about where they came from."""
    if template_dir is not None:
        missing = [name for name in TEMPLATES if not (template_dir / name).is_file()]
        if missing:
            raise FileNotFoundError(f"{template_dir} is missing {missing}")
        return (
            {name: (template_dir / name).read_bytes() for name in TEMPLATES},
            str(template_dir),
        )

    for candidate in TEMPLATE_CANDIDATES:
        path = ROOT / candidate
        if all((path / name).is_file() for name in TEMPLATES):
            return ({name: (path / name).read_bytes() for name in TEMPLATES}, str(path))

    if apk is not None:
        with ZipFile(apk) as archive:
            available = set(archive.namelist())
            missing = [n for n in TEMPLATES if ASSET_PREFIX + n not in available]
            if missing:
                raise FileNotFoundError(f"{apk} is missing assets/theme/{missing}")
            return (
                {name: archive.read(ASSET_PREFIX + name) for name in TEMPLATES},
                f"{apk}!{ASSET_PREFIX}",
            )

    raise FileNotFoundError(
        "no decoded assets/theme found and no --apk given; decode the original APK "
        "or pass --template-dir/--apk"
    )


def synthetic_map(slots: list[str]) -> dict[str, int]:
    """Deterministic, distinct, fully opaque colors so every slot is exercised."""
    return {
        name: 0xFF000000 | ((index * 0x00070301) & 0xFFFFFF)
        for index, name in enumerate(slots)
    }


def device_map(slots: list[str]) -> dict[str, int] | None:
    """The colors actually measured on the device, when that evidence is present."""
    colors_path = PROBE / "system_colors.json"
    if not colors_path.is_file():
        return None
    raw = json.loads(colors_path.read_text(encoding="utf-8"))

    def resolve(name: str) -> int | None:
        value = raw.get(name)
        if value is None:
            return None
        if isinstance(value, str):
            return int(value.lstrip("#").lstrip("0x"), 16) & 0xFFFFFFFF
        return int(value) & 0xFFFFFFFF

    resolved: dict[str, int] = {}
    for slot in slots:
        resource = PROBE_MAPPING.get(slot)
        if resource is None:
            continue
        value = resolve(resource)
        if value is not None:
            resolved[slot] = value
    return resolved or None


def probe_cross_check(template: bytes, color_map: dict[str, int]) -> str | None:
    """Compare the embedded reference with the on-disk probe, when it exists.

    Returns a failure message, or None when they agree or the probe is absent.
    """
    if not PROBE_TOOL.is_file():
        return None
    sys.path.insert(0, str(PROBE))
    from style_sheet_tool import rebuild_with_colors as probe_rebuild

    embedded, _ = rebuild_with_colors(template, color_map)
    reference, _ = probe_rebuild(template, color_map)
    if embedded != reference:
        return "embedded reference has drifted from work/dynamic-color-probe/style_sheet_tool.py"
    return None


def digest(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--android-jar", type=Path, required=True)
    parser.add_argument("--jdk", type=Path, required=True)
    parser.add_argument("--template-dir", type=Path)
    parser.add_argument("--apk", type=Path)
    args = parser.parse_args()

    android_jar = args.android_jar.resolve()
    jdk = args.jdk.resolve()
    javac = jdk / "bin/javac.exe"
    java = jdk / "bin/java.exe"
    for path in (SOURCE, javac, java, android_jar):
        if not path.exists():
            raise FileNotFoundError(path)

    templates, origin = load_templates(args.template_dir, args.apk)
    print(f"templates: {origin}")

    slots = java_slot_names(SOURCE.read_text(encoding="utf-8"))
    print(f"Java mapping declares {len(slots)} slots")

    maps: list[tuple[str, dict[str, int]]] = [("synthetic", synthetic_map(slots))]
    measured = device_map(slots)
    if measured is not None:
        maps.append(("device-measured", measured))
    else:
        print("note: system_colors.json absent, only the synthetic map is checked")

    failures: list[str] = []
    drift = probe_cross_check(templates[TEMPLATES[0]], maps[0][1])
    print(f"probe cross-check: {'skipped (probe absent)' if drift is None and not PROBE_TOOL.is_file() else ('FAILED' if drift else 'agree')}")
    if drift:
        failures.append(drift)

    with tempfile.TemporaryDirectory(prefix="dynamic-rewrite-gate-") as temporary:
        work = Path(temporary)
        (work / "RewriteHarness.java").write_text(HARNESS, encoding="utf-8")
        classes = work / "classes"
        classes.mkdir()
        subprocess.run(
            [str(javac), "-source", "7", "-target", "7",
             "-bootclasspath", str(android_jar),
             "-d", str(classes), str(SOURCE), str(work / "RewriteHarness.java")],
            check=True,
        )

        for template_name in TEMPLATES:
            data = templates[template_name]
            print(f"\n{template_name}  {len(data)} bytes")
            source_file = work / "template.bin"
            source_file.write_bytes(data)
            for label, color_map in maps:
                encoded = ",".join(f"{k}={v & 0xFFFFFFFF:08x}" for k, v in color_map.items())
                java_out = work / "java.bin"
                subprocess.run(
                    [str(java), "-cp", f"{classes}{os.pathsep}{android_jar}",
                     "RewriteHarness", str(source_file), encoded, str(java_out)],
                    check=True,
                )
                java_bytes = java_out.read_bytes()
                python_bytes, changed = rebuild_with_colors(data, color_map)
                rewritten = len(changed)

                java_digest = digest(java_bytes)
                python_digest = digest(python_bytes)
                same = java_digest == python_digest
                print(
                    f"  {label:<16} rules rewritten={rewritten:<3} "
                    f"java={len(java_bytes)}B python={len(python_bytes)}B "
                    f"{'MATCH' if same else 'MISMATCH'}"
                )
                if not same:
                    failures.append(
                        f"{template_name}/{label}: {java_digest} != {python_digest}"
                    )

    # Coverage: a slot that matches no rule would be a silently dead mapping entry.
    present = {rule["name"] for rule in parse_rules(templates[TEMPLATES[0]])}
    absent = [slot for slot in slots if slot not in present]
    print(f"\ncoverage: {len(slots) - len(absent)}/{len(slots)} slots present in the template")
    if absent:
        failures.append("mapping slots absent from the template: " + ", ".join(absent))

    if failures:
        print("\nFAILED")
        for failure in failures:
            print("  -", failure)
        return 1
    print("\nAll recoloring outputs match byte for byte.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
