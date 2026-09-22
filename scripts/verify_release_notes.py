"""Check the versioned release notes stay short and link to the full changelog.

The GitHub Release body is assembled from ``docs/releases/v<version>.md`` plus a
build-info section that the workflow appends. Those notes must stay short: a
summary, the main updates, and a link to the matching ``CHANGELOG.md`` entry.
Long usage, device-acceptance and build-scope sections belong in ``CHANGELOG.md``
and the design documents instead.

Version identity comes from either the ``## 版本信息`` section that earlier
releases wrote by hand, or the ``## 构建信息`` section that the release workflow
appends after building, when the final APK hash is known. Both are acceptable.
"""

import argparse
import re
import sys
from pathlib import Path

SUMMARY_HEADING = "## 主要更新"
FORBIDDEN_HEADINGS = (
    "## 使用说明",
    "## 真机验收",
    "## 构建与兼容范围",
    "## 兼容边界",
)
IDENTITY_HEADINGS = ("## 版本信息", "## 构建信息")
CHANGELOG_LINK = re.compile(r"CHANGELOG\.md#\d")
MAX_LINES = 40


def check(path: Path) -> list[str]:
    errors: list[str] = []
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    if not lines:
        return [f"{path}: 文件为空"]
    if lines[0].startswith("# "):
        errors.append(f"{path}: 不得以一级标题开头，去掉「# Google 拼音输入法 X.X.X」")
    for heading in FORBIDDEN_HEADINGS:
        if any(line.strip() == heading for line in lines):
            errors.append(f"{path}: 不应包含「{heading}」小节，完整内容写入 CHANGELOG.md")
    # 版本身份可以写在文件里，也可以由发布工作流追加，但两者不能重复。
    if sum(heading in text for heading in IDENTITY_HEADINGS) > 1:
        errors.append(f"{path}: 「版本信息」与「构建信息」只能保留一份")
    if SUMMARY_HEADING not in text:
        errors.append(f"{path}: 缺少「{SUMMARY_HEADING}」小节")
    if not CHANGELOG_LINK.search(text):
        errors.append(f"{path}: 缺少指向 CHANGELOG.md 对应条目的链接")
    if len(lines) > MAX_LINES:
        errors.append(f"{path}: 共 {len(lines)} 行，超过 {MAX_LINES} 行的简短约定")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("notes", nargs="*", help="release note files; defaults to docs/releases/*.md")
    args = parser.parse_args()

    paths = [Path(item) for item in args.notes]
    if not paths:
        paths = sorted(Path("docs/releases").glob("*.md"))
    if not paths:
        print("没有可检查的版本化 Release Notes", file=sys.stderr)
        return 1

    errors: list[str] = []
    for path in paths:
        errors.extend(check(path))
    if errors:
        print("发布说明格式检查未通过：", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(f"发布说明格式检查通过，共 {len(paths)} 个文件")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
