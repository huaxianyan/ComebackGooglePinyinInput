"""The plain shortcut takes the main-area color; bordered chrome stays native."""
from pathlib import Path
import tempfile
from theme_header_styles import patch_header_styles

# Frozen native wire records, not encoded with the implementation under test.
MENU = bytes.fromhex(
    '0a4c0a232e6261636b67726f756e642d69636f6e2e6163636573732d706f696e74732d6d656e75'
    '10022223636f6c6f725f6163636573735f706f696e74735f6d656e755f6261636b67726f756e64'
)
PLAIN_MENU = bytes.fromhex(
    '0a330a232e6261636b67726f756e642d69636f6e2e6163636573732d706f696e74732d6d656e75'
    '1002220a636f6c6f725f62617365'
)

def main():
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        directory = root / 'assets/theme'
        directory.mkdir(parents=True)
        (directory / 'style_sheet_color_rules.binarypb').write_bytes(MENU)
        (directory / 'style_sheet_color_rules_border.binarypb').write_bytes(b'')
        patch_header_styles(root)
        assert (directory / 'style_sheet_color_rules.binarypb').read_bytes() == PLAIN_MENU
        assert (directory / 'style_sheet_color_rules_border.binarypb').read_bytes() == MENU
    print('Plain menu matches main-area role; border retains native chrome: PASS')

if __name__ == '__main__':
    main()
