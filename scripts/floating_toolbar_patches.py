"""悬浮键盘打开时同步工具栏入口。

文本编辑和单手模式这两个入口在悬浮键盘下没有意义：前者会退出卡片形态，
后者与悬浮互斥。把它们从快捷菜单里去掉，关掉悬浮时再放回去。
"""

from pathlib import Path

COMPAT = "Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;"
BAR = (
    "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
    "AccessPointsBar.smali"
)
LAYOUT_SIGNATURE = ".method protected onLayout(ZIIII)V"
# 普通键盘下 bar 是 gone 的，onLayout 永远不跑；条目是一次性灌进来的，这里才是展开的真实时机。
LIST_SIGNATURE = ".method public final a(Ljava/util/List;)I"
PROLOGUE = ".prologue"
SUPER_CALL = (
    "    invoke-super/range {p0 .. p5}, "
    "Landroid/widget/LinearLayout;->onLayout(ZIIII)V\n"
)


def apply_floating_toolbar(decoded: Path) -> None:
    path = decoded / BAR
    source = path.read_text(encoding="utf-8")
    if "syncFloatingToolbar" in source:
        return

    source = _hook_list_update(source)
    source = _hook_layout(source)
    path.write_text(source, encoding="utf-8")


def _hook_list_update(source: str) -> str:
    """条目被一次性灌进来时同步一次。

    bar 自己的 onLayout 只覆盖悬浮那种看得见的形态；普通键盘下它是 gone 的，不参与布局。
    """
    start = source.index(LIST_SIGNATURE)
    prologue = source.index(PROLOGUE, start)
    end = prologue + len(PROLOGUE)
    hook = PROLOGUE + f"\n\n    invoke-static {{p0}}, {COMPAT}->syncFloatingToolbar(Landroid/view/View;)V"
    return source[:prologue] + hook + source[end:]


def _hook_layout(source: str) -> str:
    start = source.index(LAYOUT_SIGNATURE)
    end = source.index(".end method", start)
    block = source[start:end]
    if block.count(SUPER_CALL) != 1:
        raise RuntimeError("AccessPointsBar.onLayout 的结构和预期不一致")

    hook = SUPER_CALL + (
        f"\n    invoke-static {{p0}}, {COMPAT}->"
        "syncFloatingToolbar(Landroid/view/View;)V\n"
    )
    return source[:start] + block.replace(SUPER_CALL, hook) + source[end:]
