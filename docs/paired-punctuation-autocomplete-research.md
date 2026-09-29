# 成对标点自动补全方案调研

## 状态

已实现。分支 `feat/paired-punctuation-autocomplete`，实现提交 `51bca8c`，设置页接线与中文文案随后补齐，英文侧的缺陷修复为 `0fa0ca0`，英文九键符号候选路径为尚未提交的工作区改动。**中文、英文按键、英文九键候选三条路径均已完成真机运行时验证**，见「实现进度」一节。

配对删除（按一次退格删掉整对符号）与「后一半已在光标之后时不重复补全」两项已完成实现，分支 `feat/paired-punctuation-delete-and-skip`，工作区改动尚未提交。**中文处理器链、英文按键路径、英文九键候选条路径各三条场景已全部通过真机验收**，见「已实施」一节。调查结论与实现现状见「配对删除的可行性调查」一节。

本版补充了三项用户指定的结论：候选期间输入符号的现状、自动空格的完整运作逻辑、删除与跳过的处理原则。

## 需求

输入成对标点的左半部分时，自动补上右半部分，并把光标移到两者之间。例如输入 `（` 得到 `（|）`，光标位于中间。

## 结论摘要

可行，框架已提供全部所需能力，不需要自行操作 `InputConnection`。

三项关键结论：

1. **候选期间输入符号不会被自动补全逻辑碰到**，因为标点软键的意图是 `COMMIT` 而不是 `DECODE`，根本不进入解码器。唯一的例外是中文九键左侧的引号键，它自带交替机制，本项目不介入，见「配对表」一节末尾的例外说明
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

补全后的状态是 `（|）`，光标位于两个符号之间。逐项核对：

1. **自动空格本身不会插入多余空格**。它的字符判定 `c(int)` 要求 codepoint `< 0x7F` 且为字母，括号不满足
2. **暂挂状态的一致性校验会自然阻止它**。它依赖缓冲与光标前文本一致才提交空格，补全插入两个字符后两者不一致
3. **补全引起的光标变化不会被当成用户操作**。上面已核实 `offsetSelection` 上报的是 `Reason.IME`，而自动空格只在原因**不是** `IME` 时才清理暂挂状态

因此冲突可控，甚至可以说几乎不存在。仍建议最小验证时顺便观察一次实际行为，作为实证。

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

其中「补全后按退格只删除左半边」这一条**已被后续需求重新审议**：用户希望按一次退格删掉整对符号，包括用户自己手敲的符号对。该目标的可行性调查见「配对删除的可行性调查」一节，实施排在本功能全部验收通过之后，单开分支进行。上表其余两行仍然有效。

## 框架提供的机制

### ProcessMessage 与两个关键工厂

| 工厂 | 消息类型 | 用途 |
| --- | --- | --- |
| `a(CharSequence, ProcessMessage$a, Object)` | `REPLACE_TEXT` | 替换文本 |
| `a(int, int, Object)` | `OFFSET_SELECTION` | 按偏移移动光标 |

`REPLACE_TEXT` 写入字段 `f`（起）、`g`（止）、`a(CharSequence)`（新文本）、`a(ProcessMessage$a)`（动作）；两个工厂都把 `f`、`g` 分别置为 1 和 0。

`OFFSET_SELECTION` 把两个整数写入字段 `h`、`i`。

### 落地点（已逐行核实）

`OutputProcessor.doProcess` 用 `packed-switch` 从 `ordinal 0x3` 开始分派。与文本、光标相关的分支：

| ordinal | 枚举 | 参数来源 | 调用 |
| --- | --- | --- | --- |
| 21 | `REPLACE_TEXT` | `f`、`g`、`a` | `replaceText(int, int, CharSequence, boolean)` |
| 26 | `OFFSET_SELECTION` | `h`、`i` | `offsetSelection(int, int)` |

`REPLACE_TEXT` 分支里还做了一件事：布尔参数取 `a(ProcessMessage$a) != NONE`。也就是说，`ProcessMessage$a` 的三个值（`CONVERTED`、`NONE`、`ORIGINAL`）在这里只用作「是否为 `NONE`」的布尔判断，只有 `NONE` 为 false，其余两个都为 true。

处理器不接触 `InputConnection`，由框架完成实际写入。

### 消息分发顺序

`ProcessorBasedIme.handle(Event)` 把事件包成 `ProcessMessage`，交给 `ard.processMessage`。`ard` 按 `ordinal()` 从 `SparseArray` 取出该消息类型的处理者数组，**顺序调用**每个处理器的 `doProcess`，任一返回 true 即短路，随后回收消息。

`ard` 里还有一个值得注意的细节：若某处理器正是消息的 payload 对象，则跳过它，避免自己处理自己发出的消息。

### 事件拦截时机

`ProcessorBasedIme.shouldHandle(Event)` 遍历所有处理器，任一 `shouldHandle` 返回 true 即认为该事件可被 IME 处理。这是识别「左半括号按键」的入口。

### offsetSelection 的语义（已逐行核实）

`GoogleInputMethodService.offsetSelection(int, int)` 的实际实现：

1. 若 `InputConnection` 为空，直接返回，不做任何事
2. 从 `SelectionChangeTracker` 取当前选区起止位置
3. 把两个参数当作**相对偏移**分别加到起止位置上，并用 `Math.max(0, …)` 保证不为负
4. 若相加后起大于止，则交换两者，保证传入 `setSelection` 时起小于止
5. 通过 `SelectionChangeTracker.a(Reason.IME, …)` 上报这次变化，**原因为 `IME`**
6. 调用 `InputConnection.setSelection(start, end)`

对本功能的意义：

- 补全 `（|）` 时，可用偏移 `(-1, -1)` 把光标从右半边之后移到两符号之间，不需要自己计算绝对位置
- 负偏移**可用**，底层会做非负钳位
- 光标变化会被标记为 `IME` 原因，因此不会触发自动空格处理器在 `SELECTION_CHANGED` 分支里的清理逻辑
- `InputConnection` 为空时静默无操作，不会抛异常，但也不会完成光标移动，属于需要验证的边界

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

## 实现进度

分支 `feat/paired-punctuation-autocomplete`，已推送到远端。实现提交为 `51bca8c`。

### 已完成

新增文件：

- `patches/smali/pairauto/PairedPunctuationProcessor.smali`：中文处理器本体，并对外提供两语共用的配对表
- `patches/smali/pairauto/PairedPunctuationHook.smali`：英文侧调用的补全步骤，与处理器共用配对表和开关
- `patches/smali/PairedPunctuationEnglishIme.smali`：英文 QWERTY 的 IME 子类，只在 `handle()` 里插补全
- `patches/res/values/paired_punctuation.xml`：开关文案、默认值与处理器 id
- `patches/res/values-zh/paired_punctuation.xml`、`values-zh-rHK`、`values-zh-rTW` 同名文件：开关的中文文案
- `scripts/verify_paired_punctuation.py`：契约门禁，已接入发布流程

修改文件：

- `scripts/apply_patches.py`：复制 Smali、注册处理器到 4 个中文 IME 定义、把英文 QWERTY 的 IME class 指向新子类、插入设置项与默认值
- `modern-settings/compose-runtime/…/BooleanSettingContracts.kt`：新增 `pairedPunctuation` 契约并纳入 `writable`
- `modern-settings/compose-runtime/…/LegacySettingsRepository.kt`：读入该开关并加入 `SettingsSnapshot`
- `modern-settings/compose-runtime/…/InputSettingsScreens.kt`：在「输入设置 → 常规输入」渲染该开关
- `modern-settings/compose-runtime/src/main/res/values*/strings.xml`：四种语言的开关文案
- `scripts/verify_modern_settings_runtime.py`：把契约与界面接线纳入既有清单，并钉死两颗开关的前后顺序
- `scripts/verify_paired_punctuation.py`：除配对表外，新增英文 IME 接线与开关位置的断言

实现要点：

- 处理器响应 `HANDLE_EVENT`，不靠 `shouldHandle`，因此不依赖处理器顺序
- 只处理 `COMMIT` 意图的单字符字符串按键，`DECODE` 意图的按键完全不受影响。中文九键左侧引号键就是 `DECODE`，它连同名的半角直引号一起被挡在处理器之外
- 覆盖 31 对符号，完整清单见下节「配对表」
- 先提交左右两个符号，再用偏移 `(-1, -1)` 把光标移到中间
- 提交完成即结束，不保留任何状态
- 中文走处理器链，英文在 IME 自身的 `handle()` 里补全；两条路径共用同一个配对表与同一个开关，因此一开全开、一关全关
- 开关位于「输入设置 → 常规输入」，紧跟双击空格键，旧设置页与现代设置页各有一处，默认开启；关闭后两条路径都不再介入

### 配对表

中英两条路径共用 `PairedPunctuationProcessor.a(String)String` 这一张表：按 `String.equals` 精确匹配单个字符，命中就返回右半边，否则返回 `null`。共 31 对：

| 开符 | 闭符 | 码位 | 归类 |
| --- | --- | --- | --- |
| `(` | `)` | U+0028 / U+0029 | 半角括号 |
| `[` | `]` | U+005B / U+005D | 半角括号 |
| `{` | `}` | U+007B / U+007D | 半角括号 |
| `<` | `>` | U+003C / U+003E | 半角括号 |
| `（` | `）` | U+FF08 / U+FF09 | 全角括号 |
| `［` | `］` | U+FF3B / U+FF3D | 全角括号 |
| `｛` | `｝` | U+FF5B / U+FF5D | 全角括号 |
| `〈` | `〉` | U+3008 / U+3009 | 书名号 |
| `《` | `》` | U+300A / U+300B | 书名号 |
| `【` | `】` | U+3010 / U+3011 | 书名号 |
| `〔` | `〕` | U+3014 / U+3015 | 书名号 |
| `‘` | `’` | U+2018 / U+2019 | 引号 |
| `“` | `”` | U+201C / U+201D | 引号 |
| `「` | `」` | U+300C / U+300D | 引号 |
| `『` | `』` | U+300E / U+300F | 引号 |
| `"` | `"` | U+0022 | 半角引号 |
| `«` | `»` | U+00AB / U+00BB | 法俄语引号 |
| `‹` | `›` | U+2039 / U+203A | 法俄语引号 |
| `❛` | `❜` | U+275B / U+275C | 装饰引号 |
| `❝` | `❞` | U+275D / U+275E | 装饰引号 |
| `❨` | `❩` | U+2768 / U+2769 | 装饰圆括号 |
| `❲` | `❳` | U+2772 / U+2773 | 装饰方括号 |
| `❴` | `❵` | U+2774 / U+2775 | 装饰花括号 |
| `〘` | `〙` | U+3018 / U+3019 | 装饰方头括号 |
| `︵` | `︶` | U+FE35 / U+FE36 | 竖排圆括号 |
| `︷` | `︸` | U+FE37 / U+FE38 | 竖排花括号 |
| `︹` | `︺` | U+FE39 / U+FE3A | 竖排方头括号 |
| `︻` | `︼` | U+FE3B / U+FE3C | 竖排实心方头括号 |
| `︽` | `︾` | U+FE3D / U+FE3E | 竖排书名号 |
| `︿` | `﹀` | U+FE3F / U+FE40 | 竖排尖括号 |
| `﹁` | `﹂` | U+FE41 / U+FE42 | 竖排直角引号 |

后 16 对是第二轮补上的。前 15 对是中文与英文的常用标点；补充的这批全部来自符号键盘的「括号」页与「收藏」页——`❛❝❨❲❴〘` 与 `︵` 到 `﹁` 这七对竖排形式就排在「括号」页同一屏及其翻页里，`«»` `‹›` 在「收藏」页。用户在输入框里点得到它们，点得到就该成对，否则同一页上只有一部分符号会补全，反而费解。`'` 仍然不在表里：它在英文里同时是撇号，`don't` 会被补成 `don''t`。

表外的字符一律不介入。由此带来几条明确的行为边界：

- 闭符不触发。`)`、`]`、`}`、`>`、`”`、`❩` 等落在表外，按下只落一个字符。
- 英文九键符号面板里只有 `(`、`[`、`{`、`"` 四个开符会补全，其余格子的字符都不在表里。
- 不判断上下文。后面已经跟着闭符时再按开符仍会补一对，不做跳过；也不区分代码、字符串、转义等场景。
- 只认两类输入：COMMIT 意图且长度为 1 的按键，以及文本候选上屏。解码意图的按键不碰，多字符的按键数据与候选也不碰。

### 一个例外：中文九键左侧的引号键

`softkeys_punctuation_zh_left_panel.xml` 里的 `softkey_quote` 是全树**唯一**意图为 `DECODE` 的标点软键（`press_data="&quot;"`，全树只有这一处 `press_intention="DECODE"` 的标点定义）。按一次得左弯引号 `“`，再按一次得右弯引号 `”`，交替进行。这个行为不是本项目加的，来自 Google 自带的中文标点转换。

链路是：`HmmPinyinT9DecodeProcessor.onHandleEvent` 认不出这个键 → 转给 `AbstractHmmPinyinDecodeProcessor.onHandleEvent` → `isAcceptedByEngine` 为假时落到末尾的兜底段 → `AbstractHmmChineseDecodeProcessor.a(KeyData)`（第 1398 行）做实际转换：

1. `Labt.a(I)I` 把码位映射成中文标点。先查特例表（`$`→`￥`、`.`→`。`、`<`→`《`、`>`→`》`、`\`→`、`、`^`→`…`），未命中再走 `Laiy.a` 的 ASCII→全角表，`0x22` 映射为 `0x201C`
2. 拿映射结果去查 `Lanf.a` 的翻转表，这张表只有 4 对：`‘’`、`“”`、`「」`、`『』`
3. 命中左半边时看状态槽 `Lanf.a[0]`：若上次输出的就是它，改输出后半段，否则输出左半边，随后把状态更新为本次输出
4. 转换结果与原串不同才提交，所以按键必有输出，不会静默吞掉

**本项目不介入这个键。** 交替机制本身已经能成对，而补全会在光标已落在一对中间时，把「后半段」插到光标处，两者直接打架。它与英文单引号 `'` 同属特例：`'` 因为兼作撇号不加，这个键因为自带交替不加。

一处容易踩的坑：这个键的 `press_data` 恰好是半角 `"`（U+0022），与配对表里那条直引号是同一个字符。但它走 `DECODE`，永远进不了处理器。若哪天想让补全接管它，必须先改意图，而那样会同时关掉中文全角转换与交替——不要动。

增删一对只改 `PairedPunctuationProcessor.smali` 里的 `a(String)String` 一处，但 `scripts/verify_paired_punctuation.py` 里钉着同一份 31 对清单，改动必须同步，否则门禁会报缺少某一对。清单是按 Smali 字面量比对的，直引号以 `\"` 的形式参与比对，所以门禁里用一个转义函数把字符还原成 Smali 的写法。

### 已通过的验证

- 从原始 APK 完整重建：apktool 解码 → 应用补丁 → 重新打包 → 再次反编译，均成功
- 6,633 个旧公开资源 ID 全部保留，无缺失、无改变
- 9 个现有静态门禁全部通过（target 31/33/34/35/36、MD3、统一 Header、简繁开关、英文 9 键）
- 新增契约门禁通过，并已钉死 31 对符号、英文 QWERTY 的 class 指向、两个英文 IME 都调用共用 helper、helper 复用同一张配对表与同一个开关 key
- 开关位置也被钉死：旧页必须在「双击空格键」之后且不再出现在键盘设置页，Compose 侧必须在 `InputSettingsScreens.kt` 且按同一顺序
- Compose 模块 `:compose-runtime:testDebugUnitTest` 通过，设置页接线与四种语言的文案均可编译

### 真机运行时验证

体验包 `com.google.android.inputmethod.pinyin.pairauto`（`2.1.1-pairauto`，27.7 MB，正式签名、非 Debug）已装机并设为默认输入法，在系统设置的搜索框里实测。

已通过：

1. 输入 `(` 得到 `()`，右半边自动补上
2. 补全后接着输入 `*` 得到 `(*)`，确认光标落在两个符号之间
3. `()` 后不动光标按退格，只剩 `)`，退格只删左半边
4. `()` 后手动点 `)` 得到 `())`，重复符合既定取舍
5. 中文状态下补全均正常（用户实测）
6. 补上直角引号后重新构建并覆盖安装，用户复测通过

首轮遗漏并已修复：

- `「」` 与 `『』`（直角引号）不在配对表里，中文状态下同样不补全。已补进 Smali，并把 15 对符号钉进契约门禁。`〈〉`（单书名号）本来就在表里，实测正常。

英文原本不补全，且这件事**不能靠处理器链解决**：处理器只注册在 4 个 `processors_zh_cn_*.xml` 上，而 `EnglishIme` 继承 `LatinIme`、`LatinIme` 继承 `AbstractIme`。全 APK 里只有 `ProcessorBasedIme` 会读 IME 定义的 `<processors>` 元素，`LatinIme` 对 `ProcessorBasedIme` 的引用数为 0。给英文 `<ime>` 加 `<include href="@xml/processors_*" />` 会被静默忽略。

改用 IME 自身的入口做补全：

- 新增 `PairedPunctuationEnglishIme`（继承 `EnglishIme`，只覆盖 `handle`，其余全部继承），`ime_en_qwerty.xml` 的 class 指向它，string id、键盘组与标签都不动
- 英文 9 键的 `EnglishT9MultiTapIme` 已在覆写 `handle`，在既有方法开头调同一个 helper
- 补全逻辑集中在 `PairedPunctuationHook`，配对表仍是处理器里的那一份（改成 `public static` 后共用），所以两语不可能漂移
- 命中后 `commitText` 提交左右两个符号，再 `offsetSelection(-1, -1)` 把光标移到中间，与中文处理器的语义一致

英文侧曾有两个互相叠加的缺陷，都靠真机日志定位：

1. **`mContext` 在英文路径上是 null**。`AbstractIme.mContext` 只有 `initialize()` 一处赋值，英文继承链 `EnglishIme → LatinIme → AbstractIme` 落到该字段的时机晚于 `handle()`。中文侧不受影响，因为 `ProcessorBasedIme` 是把**它自己 `initialize` 收到的参数**透传给处理器，从来没读这个字段。修法是让两个英文 IME 各自覆盖 `initialize()`，把框架给的 Context 交给 helper 保存成静态字段。
2. **helper 里 11 处守卫的条件极性全写反**。`if-nez` 处应为 `if-eqz`、`if-gtz` 处应为 `if-lez`，其余同类。极性错的反向结构要求「条件不满足才失败」，写成「条件满足才失败」后，`handle()` 对**任何**事件都直接走失败分支，连修好的 Context 都用不上。

另外，框架在键盘就绪时会派发一个软键事件，**该事件没有任何 intent**（`KeyData.a` 为 null）。守卫把「值缺失」当作普通拒绝处理，不对它调用任何方法。

已通过：

1. 英文 QWERTY（`ime_en_qwerty.xml` → `PairedPunctuationEnglishIme`）：点符号页的 `(` 得到 `()`，日志为 `qwerty-handle → hit`
2. 英文 9 键（`ime_en_9key.xml` → `EnglishT9MultiTapIme`）：同样得到 `()`，日志为 `t9-handle → hit`
3. 补全后按一次退格，`9()` 变成 `9)`，只删左半边，说明光标确实落在两个符号之间
4. 共享开关：把 `enable_paired_punctuation_completion` 置为关闭后重新拉起输入法，日志为 `exit:pref-off`，输入框只落下 `(`，与中文侧一致

尚未覆盖：

- 密码、数字等受限输入类型是否需要额外屏蔽

代码审阅中曾发现自己写反两处分支条件（字符长度判定误用 `if-ne`），已修正。

### 英文九键的符号候选：第三条路径

用户真机反馈：英文九键按数字键出现的符号候选，点候选上屏时不会补全。这第三种入口**尚未提交**，只存在于工作区改动中。

原因：候选点击**不经过 `IIme.handle(Event)`**，既有的两条路径（中文处理器链、英文 `handle` 里的 helper）都拦不到。

完整链路：

| 阶段 | 行为 |
| --- | --- |
| 按数字键 | `English9KeyIme.handle` 置候选标志并请求候选，内容取自 `clinit` 里的 32 个符号 |
| 点候选 | `InputBundle` 的 `sswitch_0` 分支以 `p2 = true` 调 `IIme.selectTextCandidate(candidate, true)` |
| 提交 | `English9KeyIme.selectTextCandidate` 内部走 `beginBatchEdit`、`finishComposingText`、`commitText`、`endBatchEdit` |

关键细节：真正点候选走的是 `InputBundle.a(Event)Z` 的 `sswitch_0` 分支。它在行 250 用 `const/4 v2, 0x1` 置好局部量，行 290 拿它调 `IIme.selectTextCandidate(candidate, v2)`，所以这条路径的 `p2` 恒为 true，真机日志 `p2=1` 也确认了。`InputBundle` 另有 `selectTextCandidate(Candidate, Z)`（行 4855），行 4942 以 `const/4 v3, 0x0` 转发给 `IIme`，但符号条点击不走那里。

实现方式：

- `PairedPunctuationHook` 增加 `public static a(Ljava/lang/CharSequence;)Ljava/lang/String;`：读静态 Context 下的开关、查共用配对表、返回右半边或 null
- `EnglishT9MultiTapIme` 覆盖 `public selectTextCandidate(Candidate;Z)V`：多击开启或候选不配对时原样交父类，否则**先 `invoke-super`**，再在 `p2 != 0` 时补右半边并把光标移回中间

先跑父类的理由是候选条收尾、内部计数与命中统计都属于原实现，必须保持原样。多击开关**不参与**这条路径的判定：多击是字母键的属性，符号候选条与它无关，门禁已把这一点钉死。

真机验证（已在设备上跑通）：

- 环境：隔离包 `com.google.android.inputmethod.pinyin.pairauto`，9 键英文，`enable_paired_punctuation_completion` 为 true
- 配对符号：展开符号候选面板后点 `(`，输入框得到 `()`，光标停在两者之间（按一次退格删掉的是 `(`，剩下 `)`）
- 非配对符号：点 `%` 得到 `%`，光标落在符号之后（按一次退格删掉 `%`，剩下为空）
- 表内其他开符：`[` 得 `[]`，`{` 得 `{}`
- 从原始 APK 完整重建，v1/v2/v3 签名与既有门禁通过
- 包内 `classes.dex` 确认 `EnglishT9MultiTapIme` 出现 `selectTextCandidate`
- 门禁新增断言：九键类要有该覆盖、覆盖里要调共用 helper、要有 `offsetSelection(II)V`、分支极性必须是「空值交父类」；hook 侧要求候选入口方法存在。该断言已用旧极性文件反证过会拒绝

未覆盖：候选条在受限输入类型（如纯数字框）下的行为。

#### 分支极性写反过一次

第一版的判据是 `if-nez v1, :compat_stock_candidate`，于是「右半边非空」时反而跳去父类、空值时反而落进配对分支。用户报的两个现象都由此而来：

| 现象 | 成因 |
| --- | --- |
| 点 `(` 只得到 `(` | 右半边 `)` 非空，直接跳去父类，补全分支从未执行 |
| 点任意非配对符号，光标往前跳一格 | 右半边为空，落进配对分支，`commitText(null)` 只提交空串，而 `offsetSelection(-1, -1)` 照常执行，把光标退回一格 |

定位过程：日志一度只能证明 hook 返回了正确的右半边，看不出控制流走向，反而出现「点 `(` 没打 `closer`、点 `%` 却打了」的假矛盾。在关键位置逐点加标记后（`stock-branch`、`after-super`、`closer`，外加把候选文案与 `mImeDelegate` 一起打出来），走向才清楚。Dalvik 的约定是 `if-eqz v` 在「v 等于 0」时跳、`if-nez v` 在「v 不等于 0」时跳。

踩坑记录：`English9KeyIme.b:Z` 是 `private`，子类（不同包）读不到，`a(ZZ)V` 也不在本类。因此「完全自己实现提交」不可行，只能「先跑父类再补」。

### 为何用 Smali 而不是 Java

项目的主流做法是写 Java、再用 `generate_*_smali.py` 编译成 Smali。本功能**不能用这条路**：

`ProcessMessage` 和 `Event` 都有大量**同名不同类型的字段**。`ProcessMessage` 的字段 `a` 有 13 种类型（`I`、`J`、`CharSequence`、`Event`、`Candidate`、`List`、`Z` 等），`b` 有 4 种，`c`、`d`、`e` 各有多于一种。Java 语言不允许同一类里存在同名不同类型的字段，`javac` 无法编译这种类。

`patches/smali/pairauto/` 采用手写 Smali，像 `patches/smali/androidx-inline/` 一样直接复制进解码树。

### 已确认的控制流

`InputBundle.a(Event)Z` 是软键事件的入口，700 多行，控制流已逐段核实：

1. 先做一系列状态判定，结果存入局部寄存器
2. 行 265 判定后，若可以交给 IME，则调 `IIme.handle(Event)`（行 271）
3. 若 `handle` 返回 true，跳到 `:goto_6`，**跳过 `sendKeyData`**
4. `sendKeyData` 在行 676，位于 `:cond_18` 分支，只有当 `handle` 未处理该事件时才会执行

关键结论：**处理器返回 true 就能阻止原始提交**。这是整个方案的基础。

另需注意：`ProcessorBasedIme` 实现的是自有接口 `IIme`，不直接实现处理器的 `shouldHandle`；`shouldHandle(Event)` 是 `IIme` 上的方法，内部遍历处理器数组。

### 消息工厂的真实映射

逐一核实了 `ProcessMessage` 的静态工厂，之前文档里的猜测需要修正：

| 工厂签名 | 真实消息类型 |
| --- | --- |
| `a(int, int, Object)` | `OFFSET_SELECTION` |
| `a(CharSequence, ProcessMessage$a, Object)` | `REPLACE_TEXT` |
| `a(CharSequence, ProcessMessage$a, boolean, int, Object)` | `COMMIT_TEXT` |
| `a(CharSequence, int, Object)` | `SET_COMPOSING` |
| `a(Object)` | `IME_CLOSE` |

全仓库只有三处构造这三类消息：

- `COMMIT_TEXT`：`AbstractAutoSpaceProcessor`、`BaseDecodeProcessor`
- `REPLACE_TEXT`：`AbstractDoubleSpaceProcessor`
- `OFFSET_SELECTION`：`ScrubMoveProcessor`

可直接照搬 `ScrubMoveProcessor` 的 `OFFSET_SELECTION` 构造方式。

### 处理器顺序的来源

`ProcessorBasedIme.initialize` 从 `ImeDef` 的处理器列表逐个实例化，同时填充两张表：

- `ard.a[..]`：按 XML 声明顺序的全部处理器
- `SparseArray`：消息类型 → 处理者数组，由 `message_order` 定义决定

`processors_*.xml` 里只有平铺的 `<processor>` 节点，没有 `message_order`，因此顺序回退为声明顺序。

这带来一个重要约束：**`OutputProcessor` 声明在最后，对 `COMMIT_TEXT` 等消息返回 true 并短路**。因此如果走 `doProcess` 路线，新处理器必须声明在 `OutputProcessor` 之前；如果走 `shouldHandle` 路线（本方案），则不受这个顺序影响。

### 已定方案

结合以上事实，采用 `shouldHandle` 拦截：

1. 在 `shouldHandle(Event)` 里识别「单字符、且是成对标点左半边」的按键
2. 返回 true，阻止原始提交
3. 提交左右两个符号，再用偏移 `(-1, -1)` 把光标移到中间

好处是不依赖处理器顺序，也不与 `OutputProcessor` 的短路逻辑交互。

### 待验证

以下要等隔离包实机验证，不能只看代码就当成立：

1. `shouldHandle` 返回 true 后，`InputBundle` 是否确实跳过 `sendKeyData`（控制流上成立，需实测）
2. 处理器自发的 `COMMIT_TEXT` 与 `OFFSET_SELECTION` 消息是否会被 `ImeDef` 的掩码过滤
3. 密码输入框是否会自动禁用该功能（预计需要，尚未确认）

## 配对删除的可行性调查

本节记录「按一次退格删掉补全出来的整对符号」的调查结论与实现现状，实现落在分支 `feat/paired-punctuation-delete-and-skip`。

### 目标行为

补全后状态为 `（|）`，光标夹在中间。用户按一次退格时删除整对，而不是只删左半边。

用户已明确一项取舍：**不区分符号对的来源**。用户自己手敲出 `（）` 再把光标移进中间，退格同样删掉整对。这一决定消除了对来源判断的需求，因此判据比预想简单，详见「判据」一节。

### 删除键不经过输入法的写入 API

这是本条需求的根本约束，已逐行核实：

- 退格是 `KEYCODE_DEL`（`0x43`，十进制 67），**不带 payload**
- `GoogleInputMethodService.sendKeyData(KeyData, I)` 在处理标点这类「带 `CharSequence` payload 的字符键」时，最终落到 `aqi.sendKeyData` 里的 `InputConnection.commitText(text, length)`（`aqi.smali` 第 79 行）
- 退格不走这条路。它在同一个 `sendKeyData` 里被判为「不是字符键」，改用 `Lajx.a(InputConnection, III)`（`GoogleInputMethodService.smali` 第 1253 至 1254 行，`:cond_6` / `:cond_7` 分支）。该方法的实现是构造一对 `KeyEvent` 并调用 `InputConnection.sendKeyEvent`

也就是说，退格是**作为平台 KeyEvent 转发给应用去执行**的。推论：

- 输入法拿不到「应用删了几个字符」的返回值
- 输入法不能用「拦下按键再删两次」的方式实现，因为删除动作不在自己手里
- 要实现成对删除，必须在**转发这个决定的时刻**介入，不再转发 DEL，改为自己发起一次删除

### 拦截点只有一个

先前曾判断中文与英文需要两个入口，该判断有误，已更正。核查结果：

- `Lajx.a(InputConnection, III)` 的调用点**全部位于 `GoogleInputMethodService.sendKeyData`**，该方法按 keycode 分支，DEL 落在第 1253 至 1254 行
- `sendKeyData` 本身是 `InputBundleDelegate` 契约的实现，而 `InputBundle` 只在 `IIme.handle(Event)` 返回 false 时才调用它

因此中文、英文、九键、全键盘的退格转发都汇到 `sendKeyData` 这一处。**一个拦截点即可覆盖全部语言与键盘布局。**

### 判据：为何不需要来源记录

用户最初倾向于用 `SelectionChangeTracker` 的记录作为判据，理由是「成本高但更稳定」。核查后需要修正这个前提：

- `A（ajx）` 的 `b(II)`（即 `getTextAfterCursor`）实现就是对 `InputConnection.getTextAfterCursor(p1, p2)` 的直接转调（`ajx.smali` 第 64 行），**中间没有任何缓存**
- 因此 `SelectionChangeTracker` 路线并不比直接回读更可靠，两者读的是同一个 `InputConnection`，在 WebView 或远程连接下同样可能返回 null

`SelectionChangeTracker` 真正提供的是**来源与时序**，不是文本可靠性：

- `Reason` 只有三态，`IME`、`DELETE`、`OTHER`（`SelectionChangeTracker$Reason.smali`）
- `DELETE` 的产生点是 `A.a(IC, III)` 里 `if-ne p2, 0x43`，即「输入法正在转发退格」
- `Reason.IME` 由 `Lajx.a(CharSequence, I)` 上报，正是补全把光标移进中间所走的路径

由于用户已选择不区分来源，判据退化为**纯文本检查**：「光标夹在一对配对符号之间，且两者之间没有内容」。不需要知道这对符号是谁写的，也就不需要这份记录，更不必改动框架内部结构。

### 建议判据与守卫

全部满足才命中：

- 开关开启
- 光标是折叠态，没有选区
- 不处于组合态（中文拼音输入过程中）
- 光标前后各取一字符，分别构成配对表的右半与左半，且属于同一对
- 不在受限输入类型（密码、数字等）

命中后不转发 DEL，改为发起一次成对删除。任一条件不满足即原样转发，行为与现在完全一致。

### 参考实现

仓库内已有一个官方模板可循：`AbstractDoubleSpaceProcessor`（双击空格出句号）。

- 它的 `a()Z` 读 `IImeContextDelegate.getTextBeforeCursor(3, 0)`，再逐 codepoint 判定，确认光标前是「一个空格加一个字母」
- 确认后用 `ProcessMessage.a(CharSequence, ProcessMessage$a, Object)` 构造 `REPLACE_TEXT` 消息改写文本
- 它同样通过 `res/xml/processors_*.xml` 注册，而本功能已经在这批 XML 上打过补丁

即「读光标周围文本，再改写文本」这条路，Google 自己已在同版本 APK 里发布并可用。

### 成对删除的消息表达

成对删除应表达为一条 `replaceText(1, 1, "", false)` 语义的消息，即替换光标前后各一格。

需要留意：现成的 `REPLACE_TEXT` 工厂 `ProcessMessage.a(CharSequence, ProcessMessage$a, Object)` 只预设 `f=1`、`g=0`（双击空格正是用它把光标前一格替换成句号）。要拿到 `g=1` 需手工写 `ProcessMessage` 的 public 字段。

字段是 public，操作可行，但**偏移符号约定尚未核实**。实施时应先对着 `GoogleInputMethodService.replaceText` 逐行确认，或直接真机验证，不要凭推断。

### 现有实现是否需要推翻

**不需要。删除方向是纯追加，现有补全代码无需改动。**

| 现有产物 | 删除方向是否复用 |
| --- | --- |
| `PairedPunctuationProcessor`（413 行） | 复用，配对表 `a(String)String` 正是删除方向要查的那张表 |
| `PairedPunctuationHook` | 复用，静态 Context 捕获与守卫结构继续沿用 |
| `PairedPunctuationEnglishIme` | 复用 |
| `EnglishT9MultiTapIme` 的 `handle`、`initialize`、`selectTextCandidate` | 复用，DEL 分支只是再加一处判断 |
| 开关、资源、`apply_patches.py` 接线、静态门禁 | 全部复用 |
| 15 对符号表 | 两个方向共用，仍是唯一一份 |

之所以不必推翻，关键在于**用户选择的取舍与既有设计一致**。本文档原先明确放弃「补全状态机」，理由是那需要记录「哪些字符是自己插的」。选择不区分来源后，就不需要这份记录，只读当前文本状态即可。这个选择实际上让删除方向比预想的便宜。

### 待验证

1. **中文组合态的退格归属**：中文输入拼音时，退格由 HMM 引擎的 `deleteLastInput` 消费（`AbstractHmmChineseDecodeProcessor` 的 `:pswitch_0`）。需确认组合期间的退格在到达 `sendKeyData` 之前就被短路，否则会误吞。
2. **偏移符号约定**：见「成对删除的消息表达」。
3. **受限输入框行为**：WebView 与其他远程 `InputConnection` 下前后文读取可能返回 null，需确认退化为原样转发而非异常。

### 已实施

分支 `feat/paired-punctuation-delete-and-skip`，四个文件，`+299 / -3`：

| 文件 | 改动 |
| --- | --- |
| `patches/smali/pairauto/PairedPunctuationProcessor.smali` | 实现 `IImeActionProcessor` 与 `IImeContextAwareProcessor`，取得 `replaceText` 与前后文读取；DEL 分支、智能跳过分支 |
| `patches/smali/pairauto/PairedPunctuationHook.smali` | `.locals 5` 提到 8；DEL 分支（读前后文、查配对表，命中则 `replaceText(1,1,"",false)` 并消费事件）；COMMIT 分支补前进守卫 |
| `patches/smali/EnglishT9MultiTapIme.smali` | `selectTextCandidate` 内智能跳过：光标后已是右半边时交还原生路径 |
| `scripts/verify_paired_punctuation.py` | 新增断言：两个 aware 接口与两个 set 方法必须存在、必须读 `getTextAfterCursor`、必须识别 `const/16 vX, 0x43`、必须调 `replaceText` |

两条路径的分工沿用既有约定：中文走处理器链，英文在 IME 的 `handle` 与 `selectTextCandidate` 里调共用 helper，配对表仍只有一份。

**真机验收已完成（2026-09-29）。** 分支构建 `dist/pairauto-diag.apk`（sha256 `53cab546…`，`dexdump` 核对含 `getTextBeforeCursor`×1、`getTextAfterCursor`×2）装到 Pixel 10 Pro，中英两侧各三条路径全部通过：

| 侧 | 场景 | 期望 | 实测 |
| --- | --- | --- | --- |
| 中文（处理器链） | 符号页点 `(` | `()` | `()` ✓ |
| 中文 | `()` 中间按退格 | 空 | 空 ✓ |
| 中文 | `()` 中间再点 `(` | `(()` | `(()` ✓ |
| 英文（`handle` 路径） | 长按字母键小字出 `(` | `()` | `()` ✓ |
| 英文 | `()` 中间按退格 | 空 | 空 ✓ |
| 英文 | `()` 中间再出 `(` | `(()` | `(()` ✓ |

英文侧验的是 QWERTY 布局（`PairedPunctuationEnglishIme`）。

**英文九键的候选条路径（`EnglishT9MultiTapIme.selectTextCandidate`）已于同日补齐验收**，三条场景全部通过：

| 侧 | 场景 | 期望 | 实测 |
| --- | --- | --- | --- |
| 英文（九键候选条路径） | 符号页点 `(` | `()` | `()` ✓ |
| 英文（九键候选条路径） | `()` 中间按退格 | 空 | 空 ✓ |
| 英文（九键候选条路径） | `()` 中间再点 `(` | `(()` | `(()` ✓ |

证据在 `work/en9key-verify/`（`26-box.png`、`27-del.png`、`29-box.png`）。符号页点 `(` 正是这条路径：`res/xml/ime_en_9key.xml` 的符号候选不经 `handle()`，而是走 `selectTextCandidate()` 提交，所以符号页的一次点击就构成候选条路径的完整用例。

切换方式不是偏好项 `ACTIVE_IME.SOFT.en`，而是键盘上方的 IME 选择条（`中` / `En` 两个标签）选到「En」后，再从键盘选择弹窗右侧选英文 9 键。偏好项那条路看不出实际作用的原因待查，但不影响验收。

### 一处 adb 注入陷阱（复现时必读）

`adb shell input tap` 对这套自绘键盘（IMESurface）的注入成功率约一半，丢失时表现为「点了没反应」。本轮一度按这个假象判定「第一次点击被吞」「配对删除未生效」，改用 `adb shell input swipe x y x y 60` 后点击 100% 可靠，三条场景一次通过。

因此**任何靠 `input tap` 得出的「某次按键无效」的结论都不可信**，必须换 `input swipe` 复测。本文档 652 节记录的「符号后第一次退格被吞」当时用的是专用脚本（`symtest.py`）并带重试，其逐字符图谱有区分度（`!` `&` `*` `(` `)` `=` 被吞而 `@` `#` `$` `%` `^` 正常），不属于这类随机丢失，结论仍然成立。本节补录陷阱只为避免后续复现时重蹈。

### 实施边界

该功能引入了与现有三条路径**性质不同**的入口：前三条在「写文本」时拦截，这条在「转发按键」时拦截，并需要独立状态与独立的真机矩阵（中英双语、双英文布局、组合态、有选区、WebView、密码框）。

因此**单独开分支**，不混入 `feat/paired-punctuation-autocomplete`，验收阶段也独立。

## 符号后第一次退格被吞：一处既有行为

真机验收配对补全时观察到：英文九键符号页输入 `&`、`*`、`=` 后，第一次退格没有反应，第二次才删掉。逐层收窄范围后确认，**这既不是配对补全引入的，也不是配对删除引入的，正式发布包 v2.1.2 在同等设置下行为完全一致。**

### 逐字符图谱

英文九键符号页第一页，关闭「复古 9 键」，逐键点击后按一次退格：

| 符号 | 一次退格后 | 判定 |
| --- | --- | --- |
| `!` `&` `*` `(` `)` `=` | 字符仍在 | 被吞 |
| `@` `#` `$` `%` `^` | 已清空 | 正常 |

换成硬件 `KEYCODE_DEL` 结果相同，被吞的位置不在键盘视图的软键管线里。把 `enable_paired_punctuation_completion` 关掉结果也不变，与补全开关无关。

中文九键符号页上同样复现（`(` 与 `)` 都要按两次），英文 QWERTY 上同样复现，所以这不是某一种键盘布局特有的。

换一条提交路径就能看出分界：用 `input text ")"` 提交的 `)` 一次退格就删掉，`input text "x"` 提交的普通字母同样一次就删。只有软键点出来的符号会吃掉第一次退格。

### 只由设置决定

第一轮用「两种构建 × 两组设置」对照，两种构建在同样的设置组合下逐字符结果完全一致，说明差异全部来自设置而不是代码：

| 构建 | 复古 9 键 | 下一词预测 | 结果 |
| --- | --- | --- | --- |
| v2.1.2 正式包（不含任何配对补全代码） | 关 | 开 | 被吞 |
| v2.1.2 正式包 | 关 | 关 | 正常 |
| v2.1.2 正式包 | 开 | 关 | 正常 |
| master（已含配对补全） | 关 | 开 | 被吞 |
| master | 关 | 关 | 正常 |
| master | 开 | 开 | 正常 |

第二轮换成单变量控制，只动 `en_t9_multitap_enabled` 一项，构建与其余设置都不变，行为直接翻转：

| 构建 | `en_t9_multitap_enabled` | `)` 后一次退格 |
| --- | --- | --- |
| v2.1.2 正式包 | `true`（日常包取值） | 已清空 |
| pairauto master（符号补全那一轮） | 缺省，等同 `false` | 字符仍在 |
| pairauto 分支（本轮） | 缺省，等同 `false` | 字符仍在 |
| pairauto 分支 | 显式 `true` | 已清空 |
| pairauto 分支 | 显式 `false` | 字符仍在 |

后三行是同一次装机、同一个构建，只有这一个偏好不同。**这一项单独就足以决定结果**，`next_word_prediction` 并非必要条件。两轮合起来把范围收在「偏好」这一层，与本轮及上一轮的配对补全代码都无关。

### 机制

1. `res/xml/ime_en_9key.xml` 声明了 `<item id="@id/extra_value_latin_enable_suspend_prediction_on_backspace" value="true" />`，同一文件里 `extra_value_latin_update_suggestion_on_activate` 为 `false`
2. `LatinIme.initialize` 把前者读进 `LatinIme.b:Z`（资源 id `0x7f0f002b`），`LatinIme.a(EditorInfo)` 再抄进解码器配置 `Lcgp.h:Z`
3. 解码器的按键入口 `adw.a(JLchw;)Z` 里比较常量 `v2 = 0x8`，即退格：当这次按键的解码结果既没有 `Lcfk.a:Lchk` 也没有 `Lcfk.a:Lchh`（既无候选也无标点输出）时，读 `Lcgp.h` 与联想状态 `Layx->a:Lazh.a()`，命中挂起分支就 `goto :goto_0`，**丢弃本次按键的解码结果**

这同时解释了设置为何能决定结果：「复古 9 键」开启时 `EnglishT9MultiTapIme.computeShouldShowSuggestions` 与 `computeShouldEnableAutoCorrection` 都返回 false，联想不活跃；`next_word_prediction` 为 false 时下一词预测不启用。任一成立就不会被吞，其中前者单独就够（见上一节的单变量表）。隔离测试包的默认组合恰好两条都不满足（`en_t9_multitap_enabled` 缺省 false，`next_word_prediction` 为 true），日常包则两条都满足。

这条链路取自英文九键的解码器。本轮在中文九键符号页与英文 QWERTY 上也观察到同一个开关依赖，说明它牵动的是一处更通用的联想状态，究竟落在哪个类里尚未逐层核实。

后续的专项调研补齐了这两处，并修正了本节给出的修改建议，见 [英文符号引发后续建议与首次退格被吞的调研](symbol-backspace-swallow-research.md)。结论是差异来自各语言的 `symbols_word_separators` 词分隔符集合，哪些符号被吞由它精确决定，与符号自身无关。改动方向应是收窄该集合，而不是本节原先建议的开关。

### 复现方式

设备侧脚本在 `.workbuddy/tmp/`：`edit_prefs.py` 按基线与逐键覆盖写偏好并重启进程，`symtest.py` 跑「点符号 → 退格 → 再退格」并给出判定，`sd.py` 负责具体操作与稳定读数，`rowscan.py` 与 `kgrid.py` 用来从截图里量真实键位。`edit_prefs.py` 首次写入任一包前会把原文件备份到 `tmp/<pkg>-prefs-backup.xml`，用 `restore` 还原。

两个必须注意的坑。写偏好与 `kill -9` 之间有窗口，输入法进程若在这期间回写偏好，改动会被覆盖；判断开关是否真的生效要看行为（例如 `(` 是否变成 `()`），不能只看写入成功。另一个是键盘页面会自行漂移：字母页与符号页的切换键占同一个位置，靠截图判断当前页面在两个方向上都会出错，误判一次就把键盘切到反方向。`symtest.py` 因此不再判页面，改为按结果重试——点符号键后没产出该符号，就切换页面再来一次。

### 是否处理

未处理。本节原先建议「把这四处改成 `false` 即可」，该建议经逐字节复核后**不成立**：`adw.a(JLchw;)Z` 里 `cgp.h == false` 会**无条件**进入挂起分支，改成 `false` 会让候选缺失的退格全部被吞，问题加重。`ime_en_floating_hard_qwerty.xml` 与 `ime_en_hard_qwerty.xml` 正因缺省该条目而处于这一档，可作为旁证。

正确的改动方向是收窄各语言的 `symbols_word_separators`，见 [英文符号引发后续建议与首次退格被吞的调研](symbol-backspace-swallow-research.md)。

### 教训

第一轮对照实验是错的：拿正式包自身的设置测出「干净」，就得出「只有加了补全代码的包才有问题」。两个包的偏好本身相差十余项，其中 `en_t9_multitap_enabled` 恰好是决定这项行为的那一项。

中间还绕过一次弯路：「把补全开关关掉也复现」曾被当作「与补全代码无关」的证据，但那次关的是 `enable_paired_punctuation_completion`，与真正起作用的 `en_t9_multitap_enabled` 是两个不同的开关。关掉一个不在嫌疑链路上的开关不构成排除，只是又做了一次没有对齐的对照。

结论有两条：对照必须一次只动一个变量；「关掉某个开关仍然复现」只有在那个开关确实位于嫌疑链路上时才算证据。

## 待确认问题

1. 处理器应继承现有基类还是直接实现 `IImeProcessor`
2. 需要注册到哪些 processors 文件（中文拼音、手写、笔画、英文）
3. 成对符号的覆盖范围，是否包含罕见符号
4. 补全后是否需要主动清理自动空格的暂挂状态，还是依赖一致性校验自然阻止

已解决的两项（原为未验证）：

- `ProcessMessage$a` 在 `REPLACE_TEXT` 下只用作 `!= NONE` 的布尔判断，见上一节
- `OFFSET_SELECTION` 参数确实为相对偏移，见下一节

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
