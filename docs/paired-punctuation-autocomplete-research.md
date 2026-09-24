# 成对标点自动补全方案调研

## 状态

调研阶段，**尚未开分支、尚未实现**。开发等用户查看本文件后再决定是否启动。

本版补充了三项用户指定的结论：候选期间输入符号的现状、自动空格的完整运作逻辑、删除与跳过的处理原则。

## 需求

输入成对标点的左半部分时，自动补上右半部分，并把光标移到两者之间。例如输入 `（` 得到 `（|）`，光标位于中间。

## 结论摘要

可行，框架已提供全部所需能力，不需要自行操作 `InputConnection`。

三项关键结论：

1. **候选期间输入符号不会被自动补全逻辑碰到**，因为标点软键的意图是 `COMMIT` 而不是 `DECODE`，根本不进入解码器
2. **自动空格确实会与补全冲突**，但它用的是「暂挂空格」策略，可以规避
3. **删除与跳过不需要特殊处理**：补全并移动光标后任务即结束，后续输入按正常状态处理

## 一、候选期间输入符号的现状

用户判断「输入上屏之前不太会输符号」，这个判断在框架层面是有保证的。

### 意图只有两种

`KeyData$a` 是按键意图枚举，只有两个值：

| 意图 | 含义 |
| --- | --- |
| `DECODE` | 交给解码引擎处理 |
| `COMMIT` | 直接提交文本 |

拼音键盘的字母键是 `DECODE`，标点软键是 `COMMIT`。例如中文底部逗号软键：

```xml
<action type="PRESS" keycode="PLAIN_TEXT" intention="COMMIT" data="，" />
```

### 判定依据

解码处理器用 `isAcceptedByEngine(KeyData)` 决定是否接管一个按键。拼音侧的实现在 `AbstractHmmPinyinDecodeProcessor`，它调用 `ace.a(KeyData)`；而 `ace.b(KeyData)` 的判据是：

```text
KeyData.a == KeyData$a.DECODE && KeyData.a(Object) instanceof String
```

也就是说：**只有 `DECODE` 意图的字符串按键才会被解码引擎接受**。标点的 `COMMIT` 意图不满足条件。

结果：候选期间按下逗号或句号，不会进入 HMM 解码流程，不会插入到拼音串，而是走提交路径把符号直接送出（或按当时的组合状态结束组合后送出）。

### 对自动补全设计的含义

自动补全要处理的是「用户按下左半括号」这个动作。由于标点是 `COMMIT` 意图，处理器在 `shouldHandle` 阶段就能通过意图和输出文本来识别它，不必担心与解码器争抢事件。

反过来也可以在 `shouldHandle` 里显式排除组合状态，作为第二道保险。

## 二、自动空格的完整运作逻辑

这一节是按用户要求逐行核对 `AbstractAutoSpaceProcessor` 与 `ChineseAutoSpaceProcessor` 后的结论，不是推测。

### 处理的消息类型

`AbstractAutoSpaceProcessor.doProcess` 用 `sparse-switch` 按 `ordinal()` 分派。枚举序号由 `clinit` 的构造顺序决定，实测对应关系：

| ordinal | 枚举 | 处理 |
| --- | --- | --- |
| 0 | `IME_ACTIVATE` | 读取设置，决定本输入框是否启用 |
| 2 | `HANDLE_EVENT` | 按键事件的暂挂判定 |
| 3 | `SET_COMPOSING` | 组合文本的暂挂判定 |
| 9 | `COMMIT_TEXT` | 提交后的暂挂判定 |
| 15 | `SELECTION_CHANGED` | 光标变化时的清理 |
| 23 | `IME_DEACTIVATE` | 清理状态 |

注意 `shouldHandle` 在这个基类里**直接返回 false**，空格键的识别走的是 `HANDLE_EVENT` 消息分支，不是拦截事件。

### 核心是「暂挂空格」而不是「插入空格」

处理器不立即插入空格，而是先记录下来，等下一次输入到达时再决定。

相关字段：

| 字段 | 作用 |
| --- | --- |
| `c` | 本输入框是否启用自动空格 |
| `d` | 是否有待处理的「前置空格」 |
| `e` | 是否有待处理的「后置空格」 |
| `a(StringBuilder)` | 已提交文本的缓冲，用于校验 |
| `b` | 由 `extra_value_auto_space_before_commit` 决定，与是否在提交前加空格有关 |

`c()` 是清理方法，把 `d`、`e` 置为 false 并清空缓冲。

### 启用的两个偏好

基类 `a(EditorInfo, Lamx)` 要求同时满足：

| 资源 | 偏好键 |
| --- | --- |
| `0x7f11026b` | `pref_key_english_prediction` |
| `0x7f110244` | `pref_key_auto_space_smart_punctuation` |

中文子类额外要求 `0x7f110251`（`pref_key_enable_auto_space`）为真。

### 具体判定流程

**收到 `COMMIT_TEXT`**：

1. 先检查 `c`、文本非空、`ProcessMessage$a` 为 `NONE`，任一不满足则清理并退出
2. 若 `e` 为真，检查刚提交文本的首个 codepoint 是否满足子类的 `b(int)`；满足则取 `getTextBeforeCursor` 与缓冲比对，一致时才真正提交一个空格
3. 若 `ProcessMessage$a` 为 `CONVERTED`，检查提交文本的末个 codepoint 是否满足子类的 `a(int)`

**收到 `SELECTION_CHANGED`**：若 `c` 为真且变化原因不是 `IME`（即用户自己移动了光标），清理暂挂状态。这一条正是「区分光标变化来源」的机制。

**收到 `SET_COMPOSING`**：`c` 为真、非空、`b` 为假时，若 `d` 为真且缓冲与光标前文本一致，则提交一个空格。

**收到 `HANDLE_EVENT`**：检查事件按键是否为字符类按键。判定用 `akd.a(int)`（键码是否为 `ALPHABET`、`PLAIN_TEXT`、`SHORT_TEXT`）或键码为正数，据此清理暂挂。

### 字符判定

中文子类 `ChineseAutoSpaceProcessor` 的三处判定最终都调用同一个私有静态方法：

```text
c(int codepoint):
    codepoint < 0x7f && Character.isLetter(codepoint)
```

即**只认 ASCII 范围内的字母**（`< 0x7F`）。中日韩汉字、全角标点都不满足。

它的启用条件 `a(EditorInfo, Lamx)` 需要三项同时成立：基类条件、偏好 `0x7f110251` 为真、以及中文输入法标识。

### 对本功能的影响与规避

补全后的状态是 `（|）`，光标位于两个符号之间。此时若触发提交事件：

- 提交文本（如后续输入的字符）会先走自动空格判定
- 由于括号不属于 ASCII 字母，`c(int)` 返回 false，不会插入空格

不过仍需注意两点：

1. **`SELECTION_CHANGED` 的清理**：补全后的光标移动若被判定为非 `IME` 原因，会清理暂挂状态。这是无害的（只是少插一个空格），但要确认不会反过来影响补全本身
2. **`d`/`e` 暂挂状态的时序**：自动空格依赖缓冲与光标前文本一致才提交空格。补全插入两个字符后，缓冲内容与实际文本会不一致，这会自然阻止空格的插入

结论：冲突存在但可控。建议实现时在补全后主动清理暂挂状态，或直接依赖上述一致性校验。

## 三、删除与跳过的处理原则

按用户指定的原则：**补全并移动光标完成后任务即结束**，无需关心后续输入。

具体行为：

| 场景 | 行为 |
| --- | --- |
| 补全后按退格 | 只删除左半边，右半边保留为普通字符 |
| 手动输入右半边 | 正常输入，产生重复的右半边，不跳过 |
| 撤销 | 按输入框自身规则处理，不做特殊干预 |

这意味着不需要维护「补全状态机」、不需要记录哪些字符是自己插入的、不需要拦截后续按键。实现复杂度显著降低。

代价是会出现 `（））` 这类结果，但这是用户明确接受的取舍。

## 框架提供的机制

### ProcessMessage 与两个关键工厂

| 工厂 | 消息类型 | 用途 |
| --- | --- | --- |
| `a(CharSequence, ProcessMessage$a, Object)` | `REPLACE_TEXT` | 替换文本 |
| `a(int, int, Object)` | `OFFSET_SELECTION` | 按偏移移动光标 |

`OFFSET_SELECTION` 把两个整数写入字段 `h`、`i`。

### 落地点

`OutputProcessor.doProcess` 把消息分派到 `IImeActionDelegate`，已确认的目标包括：

```text
commitText(CharSequence, boolean, int)
replaceText(int, int, CharSequence, boolean)
setComposingText(CharSequence, int)
setComposingRegion(int, int)
offsetSelection(int, int)
finishComposingText()
```

处理器不接触 `InputConnection`，由框架完成实际写入。

### 消息分发顺序

`ProcessorBasedIme.handle(Event)` 把事件包成 `ProcessMessage`，交给 `ard.processMessage`。`ard` 按 `ordinal()` 从 `SparseArray` 取出该消息类型的处理者数组，**顺序调用**每个处理器的 `doProcess`，任一返回 true 即短路，随后回收消息。

`ard` 里还有一个值得注意的细节：若某处理器正是消息的 payload 对象，则跳过它，避免自己处理自己发出的消息。

### 事件拦截时机

`ProcessorBasedIme.shouldHandle(Event)` 遍历所有处理器，任一 `shouldHandle` 返回 true 即认为该事件可被 IME 处理。这是识别「左半括号按键」的入口。

## 成对标点分布

符号键盘 `res/xml/softkeys_input_symbol_sub_category_brace.xml` 中成对且相邻：

```text
( )   [ ]   { }   （ ）   ［ ］   ｛ ｝
❨ ❩   ❲ ❳   ❴ ❵
‘ ’   “ ”   ❛ ❜   ❝ ❞
< >   〈 〉   《 》   〔 〕   【 】
```

拼音键盘 `k`、`l` 键下滑输出 `（`、`）`；`softkeys_input_symbol_basic_symbols.xml` 有 `[` `]`。

## 处理器注册

在 `res/xml/processors_*.xml` 中声明：

```xml
<processor id="@id/ime_auto_space_processor"
    class="com.google.android.apps.inputmethod.libs.chinese.ime.hmm.ChineseAutoSpaceProcessor" />
```

`IImeProcessor` 只有三个方法：

```text
doProcess(ProcessMessage): boolean
initialize(Context, IImeProcessorDelegate, ImeDef): void
shouldHandle(Event): boolean
```

`apply_patches.py` 已有直接修改 `res/xml` 文件的先例。

## 待确认问题

1. `ProcessMessage$a` 的 `CONVERTED`、`NONE`、`ORIGINAL` 在 `REPLACE_TEXT` 下的具体语义，尚未验证
2. `OFFSET_SELECTION` 两个整数的确切语义（是否可为负、是否受选区内影响），尚未验证
3. 补全应在 `shouldHandle` 阶段识别按键，还是在 `HANDLE_EVENT` 消息分支处理
4. 处理器应继承现有基类还是直接实现 `IImeProcessor`
5. 需要注册到哪些 processors 文件（中文拼音、手写、笔画、英文）
6. 成对符号的覆盖范围，是否包含罕见符号
7. 是否需要同时处理右半符号的输入（按用户原则不跳过，则不处理）

## 建议的调研顺序

1. 先验证待确认事项 1、2，这是可行性基础
2. 在隔离审计包做最小验证：输入 `（` 得到 `（|）`
3. 最小验证通过后，再设计配对表与开关
4. 最后确认与自动空格的实测交互

## 与逗号句号显示开关的关系

两者独立，不共享改动点。逗号句号开关改布局权重与 `Keyboard` 状态位，本功能新增 IME 处理器。若同时进行，需在 `apply_patches.py` 与静态门禁体系下协调。

逗号句号开关的调研见 [逗号与句号显示开关方案调研](comma-period-toggle-research.md)。

## 证据位置

解码产物与检索脚本在 `work/pairauto/`，`work/decoded/` 为原始 APK 解码结果。本文件只记录结论与依据，不含用户数据。
