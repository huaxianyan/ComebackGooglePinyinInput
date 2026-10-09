#!/usr/bin/env python3
"""ZIP assembly fixture: changing source timestamps must not change output bytes."""
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from zipfile import ZipFile, ZipInfo, ZIP_STORED


class AssemblyTests(unittest.TestCase):
    def test_rebuilding_identical_payload_at_another_time_produces_identical_archive(self):
        scratch = Path(__file__).resolve().parents[1] / "work/tmp"
        scratch.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=scratch) as directory:
            root = Path(directory)
            host = root / "host.apk"
            with ZipFile(host, "w") as archive:
                archive.writestr("AndroidManifest.xml", b"host manifest fixture")
                archive.writestr("classes.dex", b"modern dex fixture")
            legacy = root / "classes.dex"
            legacy.write_bytes(b"legacy dex fixture")
            outputs = []
            for index, timestamp in enumerate([(2020, 1, 2, 3, 4, 6), (2026, 10, 9, 11, 12, 14)]):
                payload = root / f"payload-{index}.apk"
                with ZipFile(payload, "w") as archive:
                    info = ZipInfo("assets/theme/style_sheet_color_rules.binarypb", timestamp)
                    info.compress_type = ZIP_STORED
                    archive.writestr(info, b"patched stylesheet fixture")
                output = root / f"output-{index}.apk"
                subprocess.run([
                    sys.executable, str(Path(__file__).with_name("assemble_compose_host_apk.py")),
                    "--host", str(host), "--legacy-dex", str(legacy),
                    "--original", str(payload), "--output", str(output),
                ], check=True, stdout=subprocess.PIPE)
                outputs.append(output.read_bytes())
                with ZipFile(output) as archive:
                    self.assertEqual(archive.read("assets/theme/style_sheet_color_rules.binarypb"), b"patched stylesheet fixture")
                    self.assertEqual(archive.getinfo("assets/theme/style_sheet_color_rules.binarypb").date_time, (1980, 1, 1, 0, 0, 0))
            self.assertEqual(outputs[0], outputs[1])


if __name__ == "__main__":
    unittest.main()
