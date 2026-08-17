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
    require(
        keyboard.get("class") in (".keyboard.PrimeKeyboard", ".keyboard.DialKeyboard"),
        f"Header keyboard is not candidate-capable: {path}",
    )
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
        "Password body does not use its editor-aware SoftKeyboardView subclass",
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
        '@layout/keyboard_qwerty_input_area' in password_body_text
        and '@layout/keyboard_prime_bottom' in password_body_text
        and 'android:layout_weight="750.0"' in password_body_text
        and 'android:layout_weight="250.0"' in password_body_text,
        "Password QWERTY and bottom rows do not preserve their accepted geometry",
    )
    candidate_body_include = '@layout/keyboard_candidates_body_inner_no_deletable_label'
    for body_layout in (
        password_body_layout,
        decoded / "res/layout/keyboard_number_body.xml",
        decoded / "res/layout/keyboard_number_password_body.xml",
    ):
        require(
            candidate_body_include in body_layout.read_text(encoding="utf-8"),
            f"Prime candidate controller has no pageable body holder: {body_layout}",
        )
    require(
        "keyboard_password_body_height" not in password_body_text,
        "Password Body bypasses the accepted post-scaling expansion contract",
    )
    helper = decoded / "smali/com/google/android/inputmethod/pinyin/PasswordBodyView.smali"
    helper_text = helper.read_text(encoding="utf-8")
    for contract in (
        ".field private static passwordEditor:Z",
        ".method public static setEditorInfo(Landroid/view/inputmethod/EditorInfo;)V",
        ".method private static isPasswordEditor(Landroid/view/inputmethod/EditorInfo;)Z",
        ".method private updateHeight()V",
        ".method protected onAttachedToWindow()V",
        ".method protected onDetachedFromWindow()V",
        ".method protected onVisibilityChanged(Landroid/view/View;I)V",
        ".method protected onWindowVisibilityChanged(I)V",
        "const/16 v2, 0x80",
        "const/16 v2, 0x90",
        "const/16 v2, 0xe0",
        "const/16 v2, 0x10",
        "->isShown()Z",
        "->getWindowVisibility()I",
        "->collapse()V",
        "Resources;->getDimensionPixelSize(I)I",
        "ViewGroup$LayoutParams;->height:I",
        "->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V",
    ):
        require(contract in helper_text,
                f"Editor-aware password height contract is missing: {contract}")
    require(
        "onMeasure(II)V" not in helper_text
        and "scaleFrameworkHeight" not in helper_text,
        "Password Body retains an experimental height formula",
    )
    pinyin_ime = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
    pinyin_text = pinyin_ime.read_text(encoding="utf-8")
    set_editor_info = (
        "Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->setEditorInfo("
        "Landroid/view/inputmethod/EditorInfo;)V"
    )
    require(
        pinyin_text.count(set_editor_info) == 2,
        "Password height state is not bounded by start/finish input",
    )
    start_input = pinyin_text.split(
        ".method public onStartInput(Landroid/view/inputmethod/EditorInfo;Z)V", 1
    )[1].split(".end method", 1)[0]
    start_publish = f"invoke-static {{p1}}, {set_editor_info}"
    require(
        start_input.count(start_publish) == 1
        and start_input.index(start_publish) < start_input.index("Labp;->onStartInput"),
        "Password editor state is not published before framework keyboard selection",
    )
    finish_input = pinyin_text.split(
        ".method public onFinishInput()V", 1
    )[1].split(".end method", 1)[0]
    finish_clear = f"invoke-static {{v0}}, {set_editor_info}"
    require(
        finish_input.count(finish_clear) == 1
        and "const/4 v0, 0x0" in finish_input
        and finish_input.index("const/4 v0, 0x0")
        < finish_input.index(finish_clear)
        < finish_input.index("Labp;->onFinishInput"),
        "Password editor state is not cleared before finishing input",
    )

    for variants in HEADERLESS_KEYBOARDS:
        verify_keyboard(
            resolve_variant(decoded, variants), "@layout/keyboard_universal_header"
        )
    dial_keyboard = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/"
        "DialKeyboard.smali"
    )
    prime_keyboard = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/"
        "PrimeKeyboard.smali"
    )
    dial_text = dial_keyboard.read_text(encoding="utf-8")
    prime_text = prime_keyboard.read_text(encoding="utf-8")
    require(
        ".method protected a(JJ)V" in prime_text
        and ".method protected final a(JJ)V" not in prime_text,
        "PrimeKeyboard state callback is still final",
    )
    require(
        ".super Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "PrimeKeyboard;" in dial_text
        and "PrimeKeyboard;-><init>()V" in dial_text,
        "DialKeyboard does not preserve phone behavior on a candidate-capable base",
    )
    require(
        ".method protected final a(JJ)V" in dial_text,
        "DialKeyboard phone-state callback is missing",
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
