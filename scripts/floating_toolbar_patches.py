"""把快捷入口的开关和顺序接到原生实现上。

自建那一行已经废弃：原生 bar 的布局、点击和动画都更稳，改列表就够了。

`AccessPointsManager` 用三份状态描述入口：
`->a:Ljava/util/List;` 是顺序，`->a:Ljava/util/Set;` 是已注册的 id，`->a:Lkx;` 是 id 到条目的映射。
`a(Laon;)V` 在注册新入口时会往列表末尾追加，所以只在初始化时排一次会被覆盖
（实测重排后的三个 id 又变回六个）。

两个挂点：

- `a(Z)V` 是渲染前的整理，按顺序过滤后交给 bar，在这里重排兜底；
- `a(Event;Z)V` 是展开和收起，渲染那次刷新只在切换键盘时发生，挂在这里改完设置才会立刻生效。
"""

from pathlib import Path

COMPAT = "Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;"
MANAGER = (
    "smali/com/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager.smali"
)
REFRESH_SIGNATURE = ".method final a(Z)V"
TOGGLE_SIGNATURE = (
    ".method final a(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;Z)V"
)
MARKER = "AccessPointsOrder;->apply"
CONTEXT_FIELD = (
    "Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;"
    "->a:Landroid/content/Context;"
)
LIST_FIELD = (
    "Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;"
    "->a:Ljava/util/List;"
)
SET_FIELD = (
    "Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;"
    "->a:Ljava/util/Set;"
)
PROLOGUE = ".prologue"
# 两个方法里紧跟 prologue 的常量初始化，钩子插在它们后面，原位置不再重复。
REFRESH_CONSTANTS = ("    const/4 v6, 0x0", "    const/4 v5, 0x1")
TOGGLE_CONSTANTS = ("    const/4 v5, 0x1", "    const/4 v4, 0x0")

NL = chr(10)


def apply_floating_toolbar(decoded: Path) -> None:
    path = decoded / MANAGER
    source = path.read_text(encoding="utf-8")
    if source.count(MARKER) >= 2:
        return

    source = _hook(source, REFRESH_SIGNATURE, REFRESH_CONSTANTS)
    source = _hook(source, TOGGLE_SIGNATURE, TOGGLE_CONSTANTS)
    path.write_text(source, encoding="utf-8")


def _hook(source: str, signature: str, constants) -> str:
    start = source.index(signature)
    prologue = source.index(PROLOGUE, start)
    end = prologue + len(PROLOGUE)

    hook = NL.join(
        [
            PROLOGUE,
            "",
            constants[0],
            "",
            constants[1],
            "",
            f"    iget-object v0, p0, {CONTEXT_FIELD}",
            "",
            f"    iget-object v1, p0, {LIST_FIELD}",
            "",
            f"    iget-object v2, p0, {SET_FIELD}",
            "",
            f"    invoke-static {{v0, v1, v2}}, {COMPAT}->"
            "apply(Landroid/content/Context;Ljava/util/List;Ljava/util/Set;)V",
        ]
    )

    tail = source[end:]
    dup = NL.join(["", constants[0], "", constants[1]])
    if tail.startswith(dup):
        tail = tail[len(dup):]
    return source[:prologue] + hook + tail
