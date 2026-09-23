# 成对标点自动补全方案调研

## 状态

调研阶段，**尚未开分支、尚未实现**。开发等用户查看本文件后再决定是否启动。

## 需求

输入成对标点的左半部分时，自动补上右半部分，并把光标移到两者之间。例如输入 `（` 得到 `（|）`，光标位于中间。

成对标点指配对出现的符号，例如各种括号与引号，不含逗号、句号这类单侧标点。

## 结论摘要

可行，而且框架已经提供了所需的全部能力，不需要自行操作 `InputConnection`。

需要三件事：

1. 一个 `IImeProcessor`，在提交左半符号时补上右半符号
2. 一个 `OFFSET_SELECTION` 消息，把光标左移一位
3. 在 `res/xml/processors_*.xml` 中注册这个处理器

框架里**没有**任何现成的括号自动补全实现。检索 `Bracket`、`Parenthesis`、`AutoPair`、`autocomplete` 等命名，只命中 AndroidX 的 `SearchAutoComplete`，与本需求无关。所以这是全新功能，需要自己实现，但有完整的同类基础设施可以复用。

## 核心机制：ProcessMessage 与消息类型

处理器不直接操作输入连接，而是构造 `ProcessMessage` 交给框架执行。这是本方案的关键设计，也是现有处理器统一采用的模式。

`ProcessMessage$b` 是消息类型枚举，共 27 项，其中与文本和光标直接相关的：

| 枚举 | 作用 |
| --- | --- |
| `COMMIT_TEXT` | 提交文本 |
| `SET_COMPOSING` | 设置组合文本 |
| `FINISH_COMPOSING` | 结束组合 |
| `REPLACE_TEXT` | 替换文本 |
| `OFFSET_SELECTION` | 按偏移移动光标 |
| `SET_COMPOSING_REGION` | 设置组合区间 |

注意枚举的声明顺序与 `clinit` 中的赋值顺序不同，两者都不能当作 ordinal 依据，实现时应通过 `ordinal()` 或直接比较枚举常量。

### 两个关键工厂方法

**补全并替换文本**：

```text
ProcessMessage.a(CharSequence text, ProcessMessage$a action, Object payload)
    -> ProcessMessage.b.REPLACE_TEXT
    字段 f = 1
    字段 g = 0
    字段 a(CharSequence) = text
    字段 a(ProcessMessage$a) = action
```

**移动光标**：

```text
ProcessMessage.a(int start, int end, Object payload)
    -> ProcessMessage.b.OFFSET_SELECTION
    字段 h = start
    字段 i = end
```

`OFFSET_SELECTION` 接收两个整数，语义与 `InputBundle.offsetSelection(int, int)` 对应。

`ProcessMessage$a` 是与文本替换相关的动作枚举，共三个值：`CONVERTED`、`NONE`、`ORIGINAL`。双空格处理器使用 `NONE`。这三个值具体如何影响 `REPLACE_TEXT` 的语义尚未验证清楚，属于待调研项。

### 落地位置

`OutputProcessor.doProcess` 负责把消息分派到 `IImeActionDelegate`，已确认的分派目标包括：

```text
commitText(CharSequence, boolean, int)
replaceText(int, int, CharSequence, boolean)
setComposingText(CharSequence, int)
setComposingRegion(int, int)
offsetSelection(int, int)
finishComposingText()
changeKeyboardState(long, boolean)
sendEvent(Event)
```

也就是说，构造好的 `OFFSET_SELECTION` 或 `REPLACE_TEXT` 消息最终会由框架调用对应的输入连接方法，处理器自身不接触 `InputConnection`。

`OutputProcessor` 是消息分派者，不是待扩展的处理器。新增功能应新增一个处理器，而不是改它。

## 同类先例一：双空格补句号

`AbstractDoubleSpaceProcessor` 是最贴近本需求的现成实现，完整流程：

1. `shouldHandle(Event)` 判断事件是否为空格键（keycode `0x3e`）
2. `doProcess` 中检查功能开关与当前输入框是否适用
3. 用 `System.currentTimeMillis()` 与上次时间比较，判断是否为连续两次
4. 调用 `getTextBeforeCursor(3, 0)` 读取光标前最多 3 个字符
5. 判断倒数第一个字符是否为空格（`0x20`），再用 `Character.codePointBefore` 取空格之前的 codepoint
6. 交给子类实现的 `a(int)` 判断该字符是否属于目标语言
7. 条件满足时构造 `ProcessMessage.a(CharSequence, ProcessMessage$a.NONE, this)` 并调用 `IImeProcessorDelegate.processMessage`

中文侧子类 `ChineseDoubleSpaceProcessor` 决定「哪些字符之后可以补句号」，它的 `a(I)Z` 只做一件事：

```text
Character.isLetterOrDigit(codepoint) || ann.a(codepoint)
```

即字母、数字，或 `ann.a` 认定的某种字符类别。骨架很小，本功能可以照这个形态实现自己的判定方法。

要点：替换文本来自处理器自己持有的字段，通过 `ProcessMessage` 交给框架执行。

## 同类先例二：句尾自动空格

`AbstractAutoSpaceProcessor` 与子类 `ChineseAutoSpaceProcessor` 处理中英文边界自动加空格，结构一致。它额外演示了：

- 用 `SelectionChangeTracker.Reason` 区分光标变化是 IME 引起还是用户引起
- 抽象方法 `a(EditorInfo, Lamx)` 决定该语言是否启用

这个「区分光标变化来源」的机制对本功能有直接价值，见下文难点。

## 处理器注册

处理器在 `res/xml/processors_*.xml` 中声明，例如 `processors_zh_cn_pinyin_qwerty.xml`：

```xml
<processor id="@id/ime_double_space_processor"
    class="com.google.android.apps.inputmethod.libs.chinese.ime.hmm.ChineseDoubleSpaceProcessor" />
<processor id="@id/ime_auto_space_processor"
    class="com.google.android.apps.inputmethod.libs.chinese.ime.hmm.ChineseAutoSpaceProcessor" />
<processor id="@id/ime_output_processor"
    class="com.google.android.apps.inputmethod.libs.framework.ime.OutputProcessor" />
```

`IImeProcessor` 接口只有三个方法：

```text
doProcess(ProcessMessage): boolean
initialize(Context, IImeProcessorDelegate, ImeDef): void
shouldHandle(Event): boolean
```

`apply_patches.py` 已有直接修改 `res/xml` 文件的先例（`setting_keyboard.xml`、`ime_en_9key.xml`、`setting_input.xml`），因此向 processors 文件插入节点属于既有能力范围。

## 成对标点的分布

成对标点集中在符号键盘 `res/xml/softkeys_input_symbol_sub_category_brace.xml`，按顺序成对排列：

```text
( )   [ ]   { }   （ ）   ［ ］   ｛ ｝
❨ ❩   ❲ ❳   ❴ ❵
‘ ’   “ ”   ❛ ❜   ❝ ❞
< >   〈 〉   《 》   〔 〕   【 】
```

拼音键盘的 `k`、`l` 键下滑分别输出 `（` 和 `）`；`softkeys_input_symbol_basic_symbols.xml` 有 `[` `]`。

「成对且相邻」的结构对实现有利：可以按配对表判断，不必依赖定义顺序。

## 关键难点

### 1. 提交时机与组合文本

中文输入存在 composing 区。拼音未上屏时补全会与解码流程冲突。需要明确是只在非组合状态下补全，还是允许在组合提交后补全。

双空格处理器只处理空格键事件且检查状态，不介入解码，这个边界值得沿用。

### 2. 光标移位的实际效果

需要真机验证：

- `offsetSelection` 在普通文本、密码、多行、Web 输入框中的表现
- 输入框不支持时是否静默失败，是否会留下只有左半边的中间状态
- 与 `SelectionChangeTracker` 的交互，避免被判定为用户移动光标而触发其他逻辑

### 3. 与自动空格的相互影响

`AbstractAutoSpaceProcessor` 会在中英文边界插入空格。补全右半符号后，光标位于左右符号之间，可能被自动空格逻辑判定为边界而插入多余空格。需要确认两者作用顺序。

### 4. 删除、跳过与撤销

需要定义：

- 补全后立刻删除，是删除右半边，还是同时删除两半
- 用户手动输入右半边时，是跳过已补的右半边，还是输入重复字符
- 插入两个字符后的撤销行为

这三项在原生输入法里通常有约定俗成的做法，但需要确认是否纳入本次范围。

### 5. 成对符号的范围

中文全角、英文半角，以及 `❨❩❲❳❴❵❛❜❝❞` 这类罕见符号是否覆盖。范围越大，误触发风险越高，且这些符号在多数输入框中并不常见。

## 待调研的具体问题

1. `ProcessMessage$a` 各枚举值的语义，确认 `REPLACE_TEXT` 用哪个值
2. `OFFSET_SELECTION` 的两个整数参数语义，是否支持负偏移、是否受当前选择状态影响
3. 补全时机挂在哪类事件上：`shouldHandle` 判定的按键事件，还是提交后的回调
4. 是否需要配合 `SelectionChangeTracker`，避免补全后的光标变化被当作外部操作
5. 处理器应继承现有基类还是直接实现 `IImeProcessor`
6. 新处理器是否需要同时注册到英文、手写、笔画等 processors 文件

## 建议的调研顺序

1. 先确认 `ProcessMessage$a` 语义与 `offsetSelection` 参数，这是可行性基础
2. 完整读 `ChineseDoubleSpaceProcessor` 与 `ChineseAutoSpaceProcessor`，整理可复用的骨架
3. 在隔离审计包做最小验证：输入 `（` 得到 `（|）`，暂不覆盖全部符号
4. 最小验证通过后，再设计完整配对表与开关
5. 最后处理删除、跳过、撤销等边界

## 与逗号句号显示开关的关系

两者相互独立，不共享改动点：

- 逗号句号开关改布局权重与 `Keyboard` 状态位
- 本功能新增 IME 处理器与标点配对逻辑

如果同时进行，需在同一个 `apply_patches.py` 与静态门禁体系下协调，避免互相干扰。逗号句号开关的调研见 [逗号与句号显示开关方案调研](comma-period-toggle-research.md)。

## 证据位置

调研用的解码产物与检索脚本在 `work/pairauto/`，`work/decoded/` 为原始 APK 解码结果。本文件只记录结论与依据，不含用户数据。
