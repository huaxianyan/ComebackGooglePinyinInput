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

# These heading literals are matched against the note files, not printed as
# Chinese output, so the script keeps ASCII-only stdout for Windows runners.
SUMMARY_HEADING = "## \u4e3b\u8981\u66f4\u65b0"
FORBIDDEN_HEADINGS = (
    "## \u4f7f\u7528\u8bf4\u660e",
    "## \u771f\u673a\u9a8c\u6536",
    "## \u6784\u5efa\u4e0e\u517c\u5bb9\u8303\u56f4",
    "## \u517c\u5bb9\u8fb9\u754c",
)
IDENTITY_HEADINGS = ("## \u7248\u672c\u4fe1\u606f", "## \u6784\u5efa\u4fe1\u606f")
CHANGELOG_LINK = re.compile(r"CHANGELOG\.md#\d")
MAX_LINES = 40


def check(path: Path) -> list[str]:
    errors: list[str] = []
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    if not lines:
        return [f"{path}: file is empty"]
    if lines[0].startswith("# "):
        errors.append(
            f"{path}: must not start with an H1 heading; drop the product/version title line"
        )
    for heading in FORBIDDEN_HEADINGS:
        if any(line.strip() == heading for line in lines):
            errors.append(
                f"{path}: must not contain the section {heading!r}; full details belong in CHANGELOG.md"
            )
    # Version identity may be written inline or appended by the release workflow,
    # but the two must never appear together. Compare by heading position so the
    # check itself stays ASCII-only and encoding-safe on Windows consoles.
    identity_hits = [line.strip() for line in lines if line.strip() in IDENTITY_HEADINGS]
    if len(identity_hits) > 1:
        errors.append(
            f"{path}: keep only one version/build identity section, found {identity_hits!r}"
        )
    if SUMMARY_HEADING not in text:
        errors.append(f"{path}: missing the summary section {SUMMARY_HEADING!r}")
    if not CHANGELOG_LINK.search(text):
        errors.append(f"{path}: missing a link to the matching CHANGELOG.md entry")
    if len(lines) > MAX_LINES:
        errors.append(f"{path}: {len(lines)} lines exceeds the {MAX_LINES}-line brevity limit")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("notes", nargs="*", help="release note files; defaults to docs/releases/*.md")
    args = parser.parse_args()

    paths = [Path(item) for item in args.notes]
    if not paths:
        paths = sorted(Path("docs/releases").glob("*.md"))
    if not paths:
        print("no versioned release notes found to check", file=sys.stderr)
        return 1

    errors: list[str] = []
    for path in paths:
        errors.extend(check(path))
    if errors:
        print("release note format check failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(f"release note format contract verified across {len(paths)} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
