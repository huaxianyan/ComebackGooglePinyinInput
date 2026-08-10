#!/usr/bin/env python3
"""Verify the shared candidate/header host on keyboards that lacked one upstream."""

from __future__ import annotations

import argparse
from pathlib import Path
import xml.etree.ElementTree as ET


SOFT_KEYBOARD_VIEW = (
    "com.google.android.apps.inputmethod.libs.framework.keyboard.SoftKeyboardView"
)
PASSWORD_BODY_VIEW = "com.google.android.inputmethod.pinyin.PasswordBodyView"

HEADERLESS_KEYBOARDS = (
    ("res/xml/keyboard_number.xml",),
    ("res/xml/keyboard_number_password.xml",),
    ("res/xml/keyboard_phone_number.xml",),
    ("res/xml/keyboard_date_time.xml",),
    ("res/xml-sw600dp-v13/keyboard_number.xml", "res/xml-sw600dp/keyboard_number.xml"),
    (
        "res/xml-sw600dp-v13/keyboard_phone_number.xml",
        "res/xml-sw600dp/keyboard_phone_number.xml",
    ),
    (
        "res/xml-sw600dp-v13/keyboard_date_time.xml",
        "res/xml-sw600dp/keyboard_date_time.xml",
    ),
)

PASSWORD_KEYBOARDS = (
    ("res/xml/keyboard_password.xml",),
    ("res/xml-sw600dp-v13/keyboard_password.xml", "res/xml-sw600dp/keyboard_password.xml"),
)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def resolve_variant(decoded: Path, variants: tuple[str, ...]) -> Path:
    for relative in variants:
        path = decoded / relative
        if path.is_file():
            return path
    raise RuntimeError(f"Missing keyboard variant: {', '.join(variants)}")


def verify_keyboard(path: Path, expected_layout: str) -> None:
    root = ET.parse(path).getroot()
    keyboard = root.find("keyboard")
    require(keyboard is not None, f"Missing keyboard definition: {path}")
    views = keyboard.findall("view")
    require(len(views) >= 2, f"Header/body pair missing: {path}")
    header = views[0]
    require(header.get("type") == "header", f"Header must precede body: {path}")
    require(header.get("layout") == expected_layout, f"Unexpected header layout: {path}")
    require(header.get("scalable") == "false", f"Header must be non-scalable: {path}")
    require(
        any(child.get("href") == "@xml/softkeys_header_candidates" for child in header),
        f"Candidate softkeys missing: {path}",
    )
    require(
        any(child.get("href") == "@xml/keymapping_header_candidates" for child in header),
        f"Candidate key mapping missing: {path}",
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    decoded = args.decoded.resolve()

    universal_layout = decoded / "res/layout/keyboard_universal_header.xml"
    universal_root = ET.parse(universal_layout).getroot()
    require(universal_root.tag == SOFT_KEYBOARD_VIEW, "Universal header root is not SoftKeyboardView")
    universal_text = universal_layout.read_text(encoding="utf-8")
    require(
        '@layout/keyboard_candidates_header_inner_no_deletable_label' in universal_text,
        "Universal header has no candidate host",
    )

    password_body_layout = decoded / "res/layout/keyboard_password_body.xml"
    password_body_root = ET.parse(password_body_layout).getroot()
    require(
        password_body_root.tag == PASSWORD_BODY_VIEW,
        "Password body does not use the height-preserving SoftKeyboardView subclass",
    )
    password_body_text = password_body_layout.read_text(encoding="utf-8")
    for digit in range(10):
        require(
            f"@id/key_pos_password_header_number_{digit}" in password_body_text,
            f"Password digit {digit} was not migrated into the body",
        )
    require(
        'android:layout_height="@dimen/keyboard_header_height"' in password_body_text,
        "Password digit row does not preserve the original header height",
    )
    require(
        'android:layout_weight="750.0"' in password_body_text
        and 'android:layout_weight="250.0"' in password_body_text,
        "Password QWERTY and bottom rows do not preserve their original proportions",
    )
    helper = decoded / "smali/com/google/android/inputmethod/pinyin/PasswordBodyView.smali"
    helper_text = helper.read_text(encoding="utf-8")
    require(
        "0x7f0d00a9" in helper_text
        and "getDimensionPixelSize(I)I" in helper_text,
        "Password body height helper does not add the qualified header height",
    )

    for variants in HEADERLESS_KEYBOARDS:
        verify_keyboard(
            resolve_variant(decoded, variants), "@layout/keyboard_universal_header"
        )
    for variants in PASSWORD_KEYBOARDS:
        path = resolve_variant(decoded, variants)
        verify_keyboard(path, "@layout/keyboard_universal_header")
        root = ET.parse(path).getroot()
        body = root.find("keyboard").findall("view")[1]
        require(
            any(child.get("href") == "@xml/softkeys_header_password" for child in body),
            f"Password digit softkeys were not migrated into the body: {path}",
        )
        require(
            any(child.get("href") == "@xml/keymapping_header_password" for child in body),
            f"Password digit mappings were not migrated into the body: {path}",
        )

    print("universal keyboard header contracts verified")


if __name__ == "__main__":
    main()
