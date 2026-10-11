#!/usr/bin/env python3
"""检查版本化的发布说明是否够短，并链接到详细记录。

GitHub Release 的正文由 ``docs/release-notes/v<版本>.md`` 加上工作流追加的
「## 构建信息」一节拼成。正文必须保持简短：一段概述、新功能与问题修复分节、
以及指向详细记录的链接。使用方式、真机验收和构建范围的细节属于 ``docs/architecture.md``
等长期文档，不写进发布说明。

新功能与问题修复必须分开描述，让读者一眼看出哪些是新东西、哪些是原有缺陷的修正。
至少要有其中一节，只有概述而没有分类会被拒绝。

用法：
    python verify_release_notes.py docs/release-notes/v0.2.0.md
    python verify_release_notes.py --tag v0.2.0
    python verify_release_notes.py --tag v0.2.0 --dir docs/releases --forbidden '## 迁移指南'

Python 3.7 以上，无第三方依赖。
"""

import argparse
import re
import sys
from pathlib import Path

# 新功能与问题修复分开描述，至少出现其中一节
FEATURE_HEADINGS = ("## 新功能", "## 新特性", "## 新增功能")
FIX_HEADINGS = ("## 问题修复", "## 修复", "## Bug 修复", "## 缺陷修复")
DEFAULT_FORBIDDEN_HEADINGS = (
    "## 使用说明",
    "## 真机验收",
    "## 构建与兼容范围",
    "## 兼容边界",
)
# 身份节至多出现一个，通常由工作流追加
IDENTITY_HEADINGS = ("## 版本信息", "## 构建信息")
# 指向仓库内某个标签下的文档，例如 /blob/v0.2.0/docs/architecture.md
DEFAULT_LINK_PATTERN = r"/blob/v[^/\s]+/"
DEFAULT_NOTES_DIR = "docs/releases"
DEFAULT_MAX_LINES = 40


def without_fenced_code(lines):
    """保留行号，排除围栏代码中的示例标题和条目。"""
    result = []
    fence_char = None
    fence_length = 0
    for line in lines:
        match = re.match(r"^ {0,3}(`{3,}|~{3,})(.*)$", line)
        if fence_char is None:
            if match:
                fence_char = match.group(1)[0]
                fence_length = len(match.group(1))
                result.append("")
            else:
                result.append(line)
        else:
            if (match and match.group(1)[0] == fence_char
                    and len(match.group(1)) >= fence_length
                    and not match.group(2).strip()):
                fence_char = None
            result.append("")
    return result


def section_body(lines, headings):
    """取第一个命中的节标题下面的正文行。找不到返回 None。"""
    for index, line in enumerate(lines):
        if line.strip() in headings:
            stripped = line.strip()
            level = len(stripped) - len(stripped.lstrip("#"))
            body = []
            for follow in lines[index + 1:]:
                stripped = follow.strip()
                if re.match(r"^#{1,6}\s", stripped):
                    heading_level = len(stripped) - len(stripped.lstrip("#"))
                    if heading_level <= level:
                        break
                    continue
                if stripped:
                    body.append(stripped)
            return body
    return None


def check(path, feature_headings, fix_headings, forbidden, identity, link_re, max_lines):
    errors = []
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as exc:
        return ["%s: cannot read (%s)" % (path, exc)]

    lines = text.splitlines()
    if not lines:
        return ["%s: file is empty" % path]

    line_count = len(lines)
    lines = without_fenced_code(lines)
    if lines[0].startswith("# "):
        errors.append(
            "%s: must not start with an H1 heading; drop the product/version title line" % path)
    for heading in forbidden:
        if any(line.strip() == heading for line in lines):
            errors.append(
                "%s: must not contain the section %r; details belong in docs/"
                % (path, heading))
    identity_hits = [line.strip() for line in lines if line.strip() in identity]
    if len(identity_hits) > 1:
        errors.append(
            "%s: keep only one version/build identity section, found %r"
            % (path, identity_hits))

    # 新功能与问题修复分开描述，至少出现其中一节
    feature_body = section_body(lines, feature_headings)
    fix_body = section_body(lines, fix_headings)
    if feature_body is None and fix_body is None:
        errors.append(
            "%s: missing both the feature section %r and the fix section %r; "
            "describe new features and bug fixes separately"
            % (path, feature_headings[0], fix_headings[0]))
    for headings in (feature_headings, fix_headings):
        # 检查每个出现的分类标题，避免只检查第一个而漏掉空节。
        for heading in headings:
            body = section_body(lines, (heading,))
            if body is not None and not any(
                    re.match(r"^[-*+]\s+\S", line) for line in body):
                errors.append("%s: section %r must contain an update list item"
                              % (path, heading))

    if not link_re.search(text):
        errors.append(
            "%s: missing a link to the detailed record (expected a /blob/v<tag>/ URL)" % path)
    if line_count > max_lines:
        errors.append(
            "%s: %d lines exceeds the %d-line brevity limit" % (path, line_count, max_lines))
    return errors


def main():
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description="check versioned release notes",
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("notes", nargs="*", help="release note files")
    parser.add_argument("--tag", help="release tag, for example v0.2.0")
    parser.add_argument("--dir", default=DEFAULT_NOTES_DIR,
                        help="release notes directory (default: %(default)s)")
    parser.add_argument("--max-lines", type=int, default=DEFAULT_MAX_LINES,
                        help="line limit (default: %(default)s)")
    parser.add_argument("--feature-heading", action="append", default=[],
                        help="extra feature section heading, repeatable "
                             "(defaults: %s)" % ", ".join(FEATURE_HEADINGS))
    parser.add_argument("--fix-heading", action="append", default=[],
                        help="extra fix section heading, repeatable "
                             "(defaults: %s)" % ", ".join(FIX_HEADINGS))
    parser.add_argument("--link-pattern", default=DEFAULT_LINK_PATTERN,
                        help="regex the detail link must match (default: %(default)s)")
    parser.add_argument("--forbidden", action="append", default=[],
                        help="extra forbidden section heading, repeatable")
    args = parser.parse_args()

    paths = [Path(item) for item in args.notes]
    if not paths and args.tag:
        paths = [Path(args.dir) / ("%s.md" % args.tag)]
    if not paths:
        paths = sorted(Path(args.dir).glob("*.md"))
    if not paths:
        print("no versioned release notes found", file=sys.stderr)
        return 2

    try:
        link_re = re.compile(args.link_pattern)
    except re.error as exc:
        print("invalid --link-pattern: %s" % exc, file=sys.stderr)
        return 2

    forbidden = list(DEFAULT_FORBIDDEN_HEADINGS)
    for item in args.forbidden:
        if item not in forbidden:
            forbidden.append(item)

    feature_headings = list(FEATURE_HEADINGS)
    for item in args.feature_heading:
        if item not in feature_headings:
            feature_headings.append(item)
    fix_headings = list(FIX_HEADINGS)
    for item in args.fix_heading:
        if item not in fix_headings:
            fix_headings.append(item)

    errors = []
    for path in paths:
        if not path.is_file():
            errors.append("%s: file does not exist" % path)
            continue
        errors.extend(check(path, feature_headings, fix_headings, forbidden,
                            IDENTITY_HEADINGS, link_re, args.max_lines))

    if errors:
        print("release note format check failed:", file=sys.stderr)
        for error in errors:
            print("- %s" % error, file=sys.stderr)
        return 1
    print("verified across %d file(s)" % len(paths))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
