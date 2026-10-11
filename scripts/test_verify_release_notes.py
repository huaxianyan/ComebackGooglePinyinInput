#!/usr/bin/env python3
"""发布说明分类门禁的回归测试，临时文件由 TemporaryDirectory 清理。"""

import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import verify_release_notes as verifier


LINK = "Details: https://github.com/o/r/blob/v1.0.0/CHANGELOG.md"
FEATURE = "## 新功能\n\n- **Export**: added.\n"
FIX = "## 问题修复\n\n- **Crash**: fixed.\n"


class ReleaseNotesTests(unittest.TestCase):
    def check_text(self, text, expected):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "v1.0.0.md"
            path.write_text(text, encoding="utf-8")
            errors = verifier.check(
                path, verifier.FEATURE_HEADINGS, verifier.FIX_HEADINGS,
                verifier.DEFAULT_FORBIDDEN_HEADINGS, verifier.IDENTITY_HEADINGS,
                re.compile(verifier.DEFAULT_LINK_PATTERN), verifier.DEFAULT_MAX_LINES)
        self.assertEqual(bool(errors), expected, errors)

    def test_valid_categories(self):
        for body in (FEATURE, FIX, FEATURE + "\n" + FIX,
                     FEATURE.replace("## 新功能", "## 新特性"),
                     FIX.replace("## 问题修复", "## Bug 修复")):
            with self.subTest(body=body):
                self.check_text("Summary.\n\n" + body + "\n" + LINK, False)

    def test_invalid_categories(self):
        bodies = (
            "## 主要更新\n\n- Mixed changes.\n",
            "## 新功能\n\n" + FIX,
            "## 新功能\n\n",
            "### 新功能\n\n- Added.\n",
            "#### 问题修复\n\n- Fixed.\n",
            "```md\n" + FEATURE + "```\n",
            "~~~md\n" + FEATURE + "~~~\n",
            "## 新功能\n\n```\n- Example only.\n```\n",
            FEATURE + "\n## 新特性\n\n",
        )
        for body in bodies:
            with self.subTest(body=body):
                self.check_text("Summary.\n\n" + body + "\n" + LINK, True)

    def test_subheading_and_continuation(self):
        self.check_text("Summary.\n\n## 新功能\n\n### Export\n\n"
                        "- **Export**: added.\n  More details.\n\n" + LINK, False)

    def test_existing_rules(self):
        valid = "Summary.\n\n" + FEATURE + "\n" + LINK
        for text in ("# Product\n" + valid,
                     valid.replace(LINK, "No link."),
                     valid + "\n## 使用说明\nInstructions.",
                     valid + "\n## 构建信息\nA\n## 版本信息\nB",
                     valid + "\n" * 50):
            with self.subTest(text=text):
                self.check_text(text, True)

    def test_cli_custom_headings_and_directory(self):
        script = str(Path(verifier.__file__).resolve())
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "v1.0.0.md"
            path.write_text("Summary.\n\n## Features\n\n- Export.\n\n"
                            "## Bug Fixes\n\n- Crash.\n\n" + LINK, encoding="utf-8")
            command = [sys.executable, script, "--tag", "v1.0.0", "--dir", directory]
            result = subprocess.run(command, capture_output=True)
            self.assertEqual(result.returncode, 1)
            result = subprocess.run(command + ["--feature-heading", "## Features",
                                               "--fix-heading", "## Bug Fixes"],
                                    capture_output=True)
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
