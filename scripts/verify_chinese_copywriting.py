#!/usr/bin/env python3
"""Verify the project's stable Chinese copywriting rules.

The checker intentionally covers deterministic typography only. Sentence rhythm,
terminology, quotation nesting, and justified semicolon use still require review.
"""

from __future__ import annotations

import html
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CJK = r"\u3400-\u9fff"
CJK_RE = re.compile(f"[{CJK}]")
TIGHT_CJK_LATIN_RE = re.compile(
    f"(?:[{CJK}](?:[A-Za-z0-9])|(?:[A-Za-z0-9])[{CJK}])"
)
TIGHT_UNIT_RE = re.compile(
    r"(?<![A-Za-z0-9])\d+(?:\.\d+)?(?:ms|fps|Hz|kHz|MHz|GHz|px|dp|sp|KiB|MiB|GiB|KB|MB|GB|TB|Gbps)\b"
)
CURVED_QUOTES_RE = re.compile(r"[“”‘’]")
REPEATED_PUNCTUATION_RE = re.compile(r"[！？?!]{2,}")
ASCII_PUNCTUATION_RE = re.compile(f"(?:[{CJK}][!?]|[!?][{CJK}])")
SINGLE_ELLIPSIS_RE = re.compile(r"(?<!…)…(?!…)")
FULLWIDTH_ALNUM_RE = re.compile(r"[Ａ-Ｚａ-ｚ０-９]")
LINK_LEFT_RE = re.compile(rf"[{CJK}]!?\[[^\]]+\]\([^)]+\)")
LINK_RIGHT_RE = re.compile(rf"\]\([^)]+\)[{CJK}]")
LIST_RE = re.compile(r"^\s*(?:[-*+] |\d+[.)] )")
INLINE_CODE_RE = re.compile(r"`[^`]*`")
MARKDOWN_TARGET_RE = re.compile(r"\]\([^)]+\)")
HTML_TAG_RE = re.compile(r"<[^>]+>")
XML_TEXT_RE = re.compile(r">([^<]+)<")

TEXT_EXTENSIONS = {
    ".md",
    ".xml",
    ".java",
    ".kt",
    ".smali",
    ".py",
    ".yml",
    ".yaml",
    ".properties",
}


def tracked_files() -> list[Path]:
    output = subprocess.check_output(
        ["git", "ls-files"], cwd=ROOT, text=True, encoding="utf-8"
    )
    return [ROOT / name for name in output.splitlines()]


def mask_markdown_syntax(line: str) -> str:
    line = INLINE_CODE_RE.sub(" ", line)
    line = MARKDOWN_TARGET_RE.sub("] ", line)
    return HTML_TAG_RE.sub(" ", line)


def has_tight_inline_code(line: str) -> bool:
    for match in INLINE_CODE_RE.finditer(line):
        left = line[match.start() - 1] if match.start() > 0 else ""
        right = line[match.end()] if match.end() < len(line) else ""
        if CJK_RE.fullmatch(left) or CJK_RE.fullmatch(right):
            return True
    return False


def prose_segments(path: Path, line: str, fenced: bool) -> list[str]:
    if path.suffix == ".md":
        return [] if fenced else [mask_markdown_syntax(line)]
    if path.suffix == ".xml":
        return [html.unescape(part) for part in XML_TEXT_RE.findall(line)]
    return [line]


def add_error(errors: list[str], path: Path, line_number: int, message: str) -> None:
    errors.append(f"{path.relative_to(ROOT)}:{line_number}: {message}")


def main() -> int:
    errors: list[str] = []
    checked = 0

    for path in tracked_files():
        if path.suffix not in TEXT_EXTENSIONS or not path.is_file():
            continue
        try:
            lines = path.read_text(encoding="utf-8").splitlines()
        except UnicodeDecodeError:
            continue
        if not any(CJK_RE.search(line) for line in lines):
            continue

        checked += 1
        fenced = False
        for line_number, line in enumerate(lines, 1):
            if path.suffix == ".md" and re.match(r"^\s*(```|~~~)", line):
                fenced = not fenced
                continue

            segments = prose_segments(path, line, fenced)
            for segment in segments:
                if not CJK_RE.search(segment):
                    continue
                if CURVED_QUOTES_RE.search(segment):
                    add_error(errors, path, line_number, "简体中文应使用直角引号「」或『』")
                if REPEATED_PUNCTUATION_RE.search(segment):
                    add_error(errors, path, line_number, "不要重复使用问号或感叹号")
                if ASCII_PUNCTUATION_RE.search(segment):
                    add_error(errors, path, line_number, "中文语句应使用全角问号或感叹号")
                if SINGLE_ELLIPSIS_RE.search(segment):
                    add_error(errors, path, line_number, "中文省略号应使用六点形式……")
                if FULLWIDTH_ALNUM_RE.search(segment):
                    add_error(errors, path, line_number, "正文数字和拉丁字母应使用半角字符")

                # Spacing checks are limited to prose-aware Markdown and XML text.
                if path.suffix in {".md", ".xml"}:
                    if TIGHT_CJK_LATIN_RE.search(segment):
                        add_error(errors, path, line_number, "中文与英文或数字之间需要空格")
                    if TIGHT_UNIT_RE.search(segment):
                        add_error(errors, path, line_number, "数字与单位之间需要空格")

            if path.suffix == ".md" and not fenced:
                if has_tight_inline_code(line):
                    add_error(errors, path, line_number, "中文与行内代码之间需要空格")
                if LIST_RE.match(line) and line.rstrip().endswith("；"):
                    add_error(errors, path, line_number, "列表项末尾不应机械使用分号")
                if LINK_LEFT_RE.search(line) or LINK_RIGHT_RE.search(line):
                    add_error(errors, path, line_number, "中文正文中的超链接前后需要空格")
                if path.parts[-2:-1] == ("releases",) and "；" in line:
                    add_error(errors, path, line_number, "Release 中文文案应避免分号并重新组织句子")
                if path.name == "README.md" and "；" in line:
                    add_error(errors, path, line_number, "README 面向用户的中文文案应避免分号")

    if errors:
        print("Chinese copywriting verification failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print(f"Chinese copywriting contract verified across {checked} tracked files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
