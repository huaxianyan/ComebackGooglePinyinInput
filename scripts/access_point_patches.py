"""悬浮键盘的快捷入口。

原生 `init_access_points` 数组里每一项是一个 style，`GoogleInputMethodService`
启动时遍历它、把每项解析成入口定义并注册。入口定义由 6 个属性描述：
`apStringId`（id 字符串）、`apIcon`、`apCloseIcon`、`apLabel`、`apHighlighted`、
`apContentDescription`。

所以新增入口不需要改 smali：加一个 style、把它写进数组即可，剩下的注册、
排序、渲染、无障碍全部走原生。点击处理另外接，见该模块的 Handler 部分。

图标用自带矢量而不是主题属性：主题属性要求每一个主题都定义同名值，漏一个
就会解析成空。固定 drawable 不受主题影响，代价是不随主题变色。
"""

from pathlib import Path

STRING_ID = "id_access_point_floating"
STRING_LABEL = "label_access_point_floating"
STRING_DESC = "access_point_floating_content_desc"
STYLE = "FloatingAccessPoint"
DRAWABLE = "ic_access_point_floating"

NL = chr(10)

# 悬浮小窗：外框实线，里面一块实心小方，右下角一条横线表示把手。
VECTOR = """<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#FFFFFFFF"
        android:pathData="M3,4h18v13H3zM5,6v9h14V6z" />
    <path
        android:fillColor="#FFFFFFFF"
        android:pathData="M8,8h8v5H8z" />
    <path
        android:fillColor="#FFFFFFFF"
        android:pathData="M11,19h2v3h-2z" />
</vector>
"""


def apply_floating_access_point(decoded: Path) -> None:
    """Adds the floating-keyboard entry to the stock access point list."""
    values = decoded / "res/values"

    _add_strings(values / "strings.xml")
    _add_style(values / "styles.xml")
    _add_to_init_array(values / "arrays.xml")
    _add_drawable(decoded)


def _add_strings(path: Path) -> None:
    source = path.read_text(encoding="utf-8")
    anchor = '    <string name="id_access_point_one_handed">access_point_one_handed</string>' + NL
    if STRING_ID in source:
        return
    addition = (
        anchor
        + f'    <string name="{STRING_ID}">access_point_floating</string>' + NL
        + f'    <string name="{STRING_LABEL}">悬浮</string>' + NL
        + f'    <string name="{STRING_DESC}">悬浮键盘</string>' + NL
    )
    if anchor not in source:
        raise SystemExit("strings.xml: id_access_point_one_handed anchor missing")
    path.write_text(source.replace(anchor, addition, 1), encoding="utf-8")


def _add_style(path: Path) -> None:
    source = path.read_text(encoding="utf-8")
    if f'name="{STYLE}"' in source:
        return
    anchor = '    <style name="MoreAccessPoints">' + NL
    if anchor not in source:
        raise SystemExit("styles.xml: MoreAccessPoints anchor missing")
    style = (
        f'    <style name="{STYLE}">' + NL
        + f'        <item name="apStringId">@string/{STRING_ID}</item>' + NL
        + f'        <item name="apIcon">@drawable/{DRAWABLE}</item>' + NL
        + f'        <item name="apLabel">@string/{STRING_LABEL}</item>' + NL
        + f'        <item name="apContentDescription">@string/{STRING_DESC}</item>' + NL
        + "    </style>" + NL
        + anchor
    )
    path.write_text(source.replace(anchor, style, 1), encoding="utf-8")


def _add_to_init_array(path: Path) -> None:
    source = path.read_text(encoding="utf-8")
    if f"@style/{STYLE}" in source:
        return
    anchor = (
        "    <array name=\"init_access_points\">" + NL
        + "        <item>@style/MoreAccessPoints</item>" + NL
    )
    if anchor not in source:
        raise SystemExit("arrays.xml: init_access_points anchor missing")
    addition = anchor + f"        <item>@style/{STYLE}</item>" + NL
    path.write_text(source.replace(anchor, addition, 1), encoding="utf-8")


def _add_drawable(decoded: Path) -> None:
    target = decoded / "res/drawable" / f"{DRAWABLE}.xml"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(VECTOR, encoding="utf-8")
