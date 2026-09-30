# 逗号与句号显示开关实施设计

> 配套调研：`comma-period-toggle-research.md`。本文件只记录实施口径，机制推导见调研文档。

## 已确认的四项决策

| 项 | 决定 |
| --- | --- |
| 开关范围 | 中文底部行与英文底部行都提供 |
| 全屏手写 | 不纳入 |
| 长按表情入口 | 当作预期，仅在设置项说明中提示风险 |
| 开关位置 | 键盘 → 按键，与表情切换键、语言切换键同组 |

## 处理器链与状态位机制（复现要点）

底部行的标点槽位不是由处理器决定显示与否，而是由 **键盘状态位驱动 keymapping** 决定。

状态位的定义与解析分两处：

- 常量定义在 `smali/aku.smali`，形如 `.field public static final STATE_XXX:J = 0x...L`。
- `aku` 的静态初始化用反射扫描自身所有以 `STATE_` 开头的 `static final long` 字段，去掉前缀后建立「名字 → 位值」映射。因此新增状态位只需新增一个字段，`state="XXX"` 即可在 keymapping 里使用。
- 反射收录时会**校验两点**，缺一不可：位值必须落在掩码内（`(~mask & value) == 0`），且不得与**已收录的位**冲突（同一个 `Laku;->a:Lkm` 表里已有该值时抛 `conflicts with`）。两个检查会分别抛出措辞不同的 `IllegalArgumentException`。

`Keyboard.a()J`（`smali/.../framework/keyboard/Keyboard.smali`，方法起始第 477 行）负责组装当前状态掩码。现有 `SHOW_EMOJI_SWITCH_KEY` 的写法可直接照搬：

```smali
iget-object v2, p0, ...Keyboard;->a:Lamx;
const v3, 0x7f110296              # pref_key_show_emoji_switch_key
...                                # 计算默认值到 v4
invoke-virtual {v2, v3, v4}, Lamx;->a(IZ)Z
move-result v2
if-eqz v2, :cond_x
or-long/2addr v0, v6              # v6 为该状态位掩码
```

## 状态位选型

位占用（**扫描全部声明 `STATE_*` 的类 `aku`、`abs`、`bdx`，加上四个 `Laku$a` 运行期分配段后确定**）：

| 区间 | 归属 |
| --- | --- |
| bit 0–18 | 固定标志 |
| bit 19–43 | `Laku$a` 运行期分配（四个段：`(4,0x13)`=19–22、`(5,0x17)`=23–27、`(6,0x1c)`=28–33、`(0xa,0x22)`=34–43） |
| bit 44–54 | 固定标志 |
| bit 55 | 空闲 |
| bit 56 | `abs.STATE_SINGLE_CHARACTER_CANDIDATE` |
| bit 57 | `abs.STATE_ENABLE_SC_TC_CONVERSION` |
| bit 58–59 | 空闲 |
| bit 60 | `bdx.STATE_SHUANGPIN_MS_ZIGUANG` |
| bit 61–63 | 空闲 |

**两条关键约束，都是实测发现，初期分析分别有误：**

1. **范围约束**：`aku.<clinit>` 里那句反射调用 `Laku;->a(Ljava/lang/Class;J)V` 传入的掩码原为 `0xffffffffffffff`，即只覆盖 bit 0–55。字段值必须是掩码子集，否则抛 `State XXX, value ... is not in the range.`
2. **冲突约束**：掩码内的位**不代表可用**。`abs` 与 `bdx` 各自声明状态位，注册到同一个 `Laku;->a:Lkm` 表。若位值已被占用，抛 `State XXX, value ... conflicts with YYY.`。这条约束与掩码无关，扩掩码只会让它暴露得更晚。

初期分析把可用位当成「bit 55–59」，忽略了约束 2，结果 `SHOW_PERIOD_KEY` 放在 bit 56 上，先触发约束 1（bit 56 在掩码外）；扩掩码到覆盖 bit 56 后又触发约束 2（与 `abs.STATE_SINGLE_CHARACTER_CANDIDATE` 冲突），两次都以启动崩溃收场。

**最终选位**：逗号取 bit 55（原版空闲），句号取 **bit 58**（跳过被 `abs` 占用的 56、57，取 55 之后最近的空闲位）。

- 掩码由 `0xffffffffffffff` 加宽到 **`0x7ffffffffffffff`**（bits 0–58），让两个新位都在范围内。加宽同时使 bit 56、57 合法，但这两个位属于 `abs`，由 `abs.<clinit>` 注册，而该掩码只约束 `aku.<clinit>` 自己扫的字段，因此无副作用。运行期分配段最高只到 bit 43，也不会与加宽的位冲突。
- `STATE_SHOW_COMMA_KEY = 0x80000000000000`（bit 55）
- `STATE_SHOW_PERIOD_KEY = 0x400000000000000`（bit 58）

语义是「显示」。缺省（用户开关关闭）时不置位，由 keymapping 映射到 `softkey_empty`。

## 空软键与可见性机制

`SoftKeyView.a(SoftKeyDef)Z`（`smali/.../keyboard/SoftKeyView.smali` 第 1309 行起）按传入定义分两支处理可见性：

- **映射到真实键**（`cond_5` 分支，第 1406 行）：无条件 `setVisibility(0)`，即 `VISIBLE`，**不看布局初值**。
- **映射到空或 `softkey_empty`**（`cond_1` 分支，第 1341-1343 行）：`iget v0, p0, ...->a:I` 取出构造时记录的布局初值，`setVisibility(v0)` 恢复它。

**推论**：槽位要在关闭状态下真正退出布局，布局里必须声明 `android:visibility="gone"`；开启状态下框架会用真实键把它强制置为可见，**不会因为布局声明了 `gone` 就永远不显示**。这与语言切换键槽位的现有写法完全一致，是原版自带的机制。

## 权重处理

`SoftKeyView` 完全没有读写 `layout_weight` 的代码（全文件无 `LayoutParams`／`weight` 字样）。因此权重只能来自静态布局，**没有任何框架钩子可以按状态改权重**。

### 语言切换键的既有做法

`keyboard_prime_bottom.xml` 里语言键与空格同处在一个 `layout_weight="500"` 的 `LinearLayout` 容器内，语言键自身 `visibility="gone"`、`weight="100"`。它 gone 后，`LinearLayout` 不计它的权重，容器内**只剩空格**，于是容器的全部宽度都归空格。这是「槽位与空格同容器，gone 后空间自然归空格」的结构约定，**不需要写一行代码**。

### 逗号与句号槽位的处境

两个标点槽位 `key_pos_bottom_symbol_1`、`key_pos_bottom_symbol_2` 是底部行的**顶层兄弟**，不与空格同容器。它们 gone 后，`LinearLayout` 把释放的宽度按各可见兄弟的权重比例**摊给所有兄弟**，而不是只给空格。

手机版实测换算（总权重 1000）：

| 状态 | 空格 | 符号键 | 右上标点 | 回车 |
| --- | --- | --- | --- | --- |
| 都开（原版几何） | 500 | 150 | 100 | 150 |
| 隐藏逗号 | 555.6 | 166.7 | 111.1 | 166.7 |
| 隐藏两个 | 625 | 187.5 | 125 | 187.5 |

空格确实变宽（这是「让出空间由空格延伸」的直观效果），但其余兄弟按比例一同微增。

### 取舍

要让空格**独占**释放的宽度，只有两条路：

1. **调整布局结构**，把标点槽位挪进空格所在的容器。代价是顶层权重和与容器内权重和同时改变，**默认状态的键宽比例全部偏移**，违背「默认与原版一致」。
2. **运行时改权重**，即新增一个 View 子类改写 `LinearLayout$LayoutParams.weight`。这正是本轮导致键盘白屏的做法，已判定为不可接受。

结论：采用**纯布局 + keymapping**的方案，接受「空格与其余兄弟按比例分摊」。核心效果（空格变宽、标点键消失）成立，且零 Smali 新增、与语言切换键同构，渲染风险最低。

**本节结论推翻**了上一版「新增 `CommaPeriodToggleKeyView` 重设权重」的设计，那条路已在真机上导致除手写外的全部键盘布局白屏。

### 两案完整对照（已出效果图给用户取舍，待答复）

手机版总权重 1000，槽位顺序为 `符号(150) / 逗号(100) / 容器(500) / 句号(100) / 回车(150)`：

| 状态 | 方案 B 空格 | 方案 B 符号/逗号/句号/回车 | 方案 A 空格 | 方案 A 符号/逗号/句号/回车 |
| --- | --- | --- | --- | --- |
| 都开 | 500 | 150 / 100 / 100 / 150 | 500 | 同左 |
| 隐藏逗号 | 555.6 | 166.7 / — / 111.1 / 166.7 | 600 | 150 / — / 100 / 150 |
| 隐藏句号 | 555.6 | 166.7 / 111.1 / — / 166.7 | 600 | 150 / 100 / — / 150 |
| 隐藏两个 | 625 | 187.5 / — / — / 187.5 | 700 | 150 / — / — / 150 |

平板版总权重 1100，槽位为 `左符号(100) / 逗号(100) / 容器(600) / 表情(100) / 句号(100) / 右符号(100)`：

| 状态 | 方案 B 空格 | 方案 B 其余四键 | 方案 A 空格 | 方案 A 其余四键 |
| --- | --- | --- | --- | --- |
| 都开 | 500 | 各 100 | 500 | 各 100 |
| 隐藏其中一个 | 555.6 | 各 111.1 | 600 | 各 100 |
| 隐藏两个 | 611.1 | 各 122.2 | 700 | 各 100 |

**当前推荐方案 B**。用户拍板前不实施代码改动。

## 需要改动的文件

### 资源

| 文件 | 改动 |
| --- | --- |
| `res/values/strings.xml` | 新增两个 `pref_key_*` 键名、两个标题、两个说明 |
| `res/values/bools.xml` | 新增两个默认值 `true`（若走 `pref_def_value_*` 约定） |
| `res/values/arrays.xml` | 把新键与默认值加入默认值表，若默认值表覆盖该组 |
| `res/values/public.xml` | 由构建流程重排，不手改 |
| `res/xml/setting_keyboard.xml` | 新增两个 `CheckBoxPreference`，置于表情切换键之前，并与语言切换键共享依赖 |
| `res/xml/keymapping_bottom_zh_cn_symbol.xml` | 逗号、句号槽位各加一条命中新状态的 `softkey_empty` 映射 |
| `res/xml/keymapping_bottom_en_symbol.xml` | 同上 |
| `res/xml/keymapping_bottom_symbol_1_popup_switch_to_emoji.xml` | merge 的 `exclude` 加入新逗号状态 |
| `res/xml/keymapping_bottom_symbol_1_popup_switch_to_emoji_no_hint_icon.xml` | 同上 |
| `res/layout/keyboard_prime_bottom.xml` | 两个标点槽位补 `android:visibility="gone"`，类名保持 `SoftKeyView` |
| `res/layout-sw600dp-v13/keyboard_prime_bottom.xml` | 同上 |

`keymapping_bottom_prime_symbol_inputtype.xml` 不修改。它在 `INPUT_TYPE_URI`、`INPUT_TYPE_EMAIL_ADDRESS` 下把槽位换成 `/`、`@`、`.com`，其映射声明了输入类型状态。需要确认状态匹配优先级，使输入类型状态下新状态不生效。

### smali

| 文件 | 改动 |
| --- | --- |
| `smali/aku.smali` | 新增 `STATE_SHOW_COMMA_KEY`、`STATE_SHOW_PERIOD_KEY` 两个静态字段 |
| `smali/.../framework/keyboard/Keyboard.smali` | 在 `a()J` 中读取两个偏好并按需置位 |

**不再新增任何 View 子类。** 两套底部行布局保持原有 `SoftKeyView` 类名不变，只补 `android:visibility="gone"`。这是与语言切换键完全同构的做法，也是本轮白屏后确定的方向。

## 静态门禁

`scripts/verify_comma_period_toggle.py` 覆盖以下条目：

1. 两个状态位各声明一次且值正确，且反射掩码已加宽到 `0x7ffffffffffffff`，同时两个位不被 `abs`、`bdx` 占用。
2. `Keyboard.smali` 按名读取两个偏好，并按需置位。
3. 两个 bottom symbol 文件保留各自 stock 映射，新增的 `softkey_empty` 映射带 `SHOW_*` 状态与 URI/EMAIL `exclude_state`，且位于 stock 映射之后。
4. 手机与平板两套底部行布局都声明 `android:visibility="gone"`。
5. 长按表情 merge 中带 `SHOW_EMOJI_SWITCH_KEY` 的行必须同时带 `SHOW_COMMA_KEY`。
6. 其他 `keymapping_*.xml` 不得出现「`softkey_empty` + `bottom_symbol`」组合。
7. 两套底部行布局里**不得出现任何自定义 View 类名**，两个标点槽位仍是 `SoftKeyView`。
8. `KeyView` 相关的新增 smali 文件不存在（防止旧方案残留）。

门禁已注册进 `.github/workflows/build-release.yml`，与其余 `verify_*.py` 并列。
