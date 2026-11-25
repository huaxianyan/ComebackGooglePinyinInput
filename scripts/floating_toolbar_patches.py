"""把快捷入口的开关和顺序接到原生实现上。

自建那一行已经废弃：原生 bar 的布局、点击和动画都更稳，改列表就够了。
`AccessPointsManager` 从 `access_points_order` 读出 id 列表，在方法收尾处交给
`AccessPointsOrder.apply` 原地过滤和重排，列表和配套的 set 一起更新。
"""

from pathlib import Path

COMPAT = "Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;"
MANAGER = (
    "smali/com/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager.smali"
)
# 读 access_points_order 的那个方法，私有且只有一处。
LOAD_SIGNATURE = ".method private final b(I)V"
# 正常路径和回收资源的分支都会落到这个标签上，从它后面插入才不会漏。
RETURN_LABEL = chr(10) + "    :cond_3" + chr(10)
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
MARKER = "AccessPointsOrder;->apply"

NL = chr(10)


def apply_floating_toolbar(decoded: Path) -> None:
    path = decoded / MANAGER
    source = path.read_text(encoding="utf-8")
    if MARKER in source:
        return

    start = source.index(LOAD_SIGNATURE)
    end = source.index(".end method", start)
    block = source[start:end]
    if block.count(RETURN_LABEL) != 1:
        raise RuntimeError("AccessPointsManager.b(I) 的结构和预期不一致")

    body = NL.join(
        [
            "",
            f"    iget-object v0, p0, {CONTEXT_FIELD}",
            "",
            f"    iget-object v1, p0, {LIST_FIELD}",
            "",
            f"    iget-object v2, p0, {SET_FIELD}",
            "",
            f"    invoke-static {{v0, v1, v2}}, {COMPAT}->"
            "apply(Landroid/content/Context;Ljava/util/List;Ljava/util/Set;)V",
            "",
        ]
    )
    block = block.replace(RETURN_LABEL, RETURN_LABEL + body, 1)
    path.write_text(source[:start] + block + source[end:], encoding="utf-8")
