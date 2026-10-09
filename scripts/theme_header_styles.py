"""Retarget the native plain-menu chrome while preserving the bordered rule."""
from pathlib import Path


def _varint(data, pos):
    value = shift = 0
    while True:
        byte = data[pos]
        pos += 1
        value |= (byte & 127) << shift
        if byte < 128:
            return value, pos
        shift += 7


def _encode(value):
    result = bytearray()
    while value > 127:
        result.append((value & 127) | 128)
        value >>= 7
    result.append(value)
    return bytes(result)


def _bytes(tag, payload):
    return _encode(tag) + _encode(len(payload)) + payload


def _fields(data):
    pos = 0
    while pos < len(data):
        start = pos
        tag, pos = _varint(data, pos)
        wire = tag & 7
        if wire == 0:
            value, pos = _varint(data, pos)
        elif wire == 2:
            size, pos = _varint(data, pos)
            value = data[pos:pos + size]
            pos += size
        elif wire in (1, 5):
            size = 8 if wire == 1 else 4
            value = data[pos:pos + size]
            pos += size
        else:
            raise ValueError(f'Unsupported theme wire type {wire}')
        yield tag, value, data[start:pos]


def patch_header_styles(decoded: Path):
    directory = decoded / 'assets/theme'
    plain = directory / 'style_sheet_color_rules.binarypb'
    border = directory / 'style_sheet_color_rules_border.binarypb'
    selector = b'.background-icon.access-points-menu'
    output = bytearray()
    original = None
    for tag, value, raw in _fields(plain.read_bytes()):
        if tag == 10 and any(t == 10 and v == selector for t, v, _ in _fields(value)):
            if original is not None:
                raise RuntimeError('Ambiguous native menu background rule')
            original = raw
            parts = list(_fields(value))
            reference = next(v for t, v, _ in parts if t == 34)
            if reference != b'color_access_points_menu_background':
                raise RuntimeError('Native menu background reference changed')
            output += _bytes(tag, b''.join(
                _bytes(t, b'color_base') if t == 34 else r for t, v, r in parts
            ))
        else:
            output += raw
    if original is None:
        raise RuntimeError('Native menu background rule missing')
    # The original border sheet has no menu override; keep its previous chrome.
    for tag, value, raw in _fields(border.read_bytes()):
        if tag == 10 and any(t == 10 and v == selector for t, v, _ in _fields(value)):
            raise RuntimeError('Native border already overrides menu background')
    plain.write_bytes(output)
    border.write_bytes(border.read_bytes() + original)
