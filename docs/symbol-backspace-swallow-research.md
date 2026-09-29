# 英文符号引发后续建议与首次退格被吞的调研

## 状态

调研完成，结论已定位到具体资源与代码路径，尚未实施改动。

本文回答三个问题：

1. 英文输入状态下，为什么部分符号会引发后续建议，按退格要先退一次建议状态
2. 具体是哪些符号
3. 若要让所有符号都不再引发建议，应该改哪里

## 现象

输入法在中文或英文下开启联想或后续建议时，输入完成后候选区仍保留候选。此时按一次退格会先退出这个联想或建议状态，恢复到普通输入状态，这是正常行为。

但在英文状态下，部分符号也会制造出这个状态。例如输入 `(` 时配对补全给出 `()`，此时按退格需要两次，第一次退掉建议状态，第二次才删掉字符。

`docs/paired-punctuation-autocomplete-research.md` 的「符号后第一次退格被吞」一节已经观察到这个现象，并把它定位到 `extra_value_latin_enable_suspend_prediction_on_backspace` 与 `en_t9_multitap_enabled` 两个开关。该节明确留下两处未解：哪些符号会触发、以及它究竟落在哪一层类里。本文补齐这两处，并修正该节给出的修改建议。

## 结论摘要

1. **差异不由符号本身决定，由语言学配置决定。** 每个语言有一份标点语法（源码里名为 `PG`），其中的 `symbols_word_separators`（词分隔符集合）决定哪些符号会结束一个词。会结束词的符号，其后的第一次退格会被解码器挂起并丢弃
2. **触发符号可以被精确列出。** 英文 `values-en` 的分隔符集合与实测结果 11/11 完全吻合，见「触发符号清单」一节
3. **不要改那四个英文 IME 定义里的开关。** 上一份文档建议把 `extra_value_latin_enable_suspend_prediction_on_backspace` 改成 `false`，逐字节复核后确认这会让行为**更严重**，见「修改建议与反例」一节
4. **`next_word_prediction` 是一根只作用于下一词预测的独立开关**，与自动空格、自动大写的启用条件不共用。关掉它可以让符号不再被吞，且不影响自动空格与自动大写，代价是普通输入时也不再预测下一词。详见「只影响下一词预测」一节
5. **「只让符号不引发预测」在现有钩子里做不成**。清空联想容器的 `azh.b()V` 是私有方法，框架侧可达的 `textCandidatesUpdated` 与 `finishComposingText` 都只是向外通知，回收不了解码器内部状态。要保留「符号之外的下一词预测」，得改解码判据本身或让英文路径的符号也走一次解码，属于新的实现任务。详见「补全钩子能否清掉预测状态」一节

## 一、完整链路

### 词分隔符从哪里来

标点语法由 `aze`（源码注释 `PG`）在构造时从字符串资源读出，写入 `chs` 对象。`chs` 是一个 protobuf 模型，最终序列化后交给原生解码器。

关键资源与 protobuf 字段的对应关系（逐字节核对 `aze.smali` 与 `chs.smali`）：

| 资源 | 资源 id | `chs` 字段 | protobuf tag | 英文取值 |
| --- | --- | --- | --- | --- |
| `suggested_punctuations` | `0x7f1103f5` | `c` | 3 | 空 |
| `symbols_followed_by_space` | `0x7f110400` | `e` | 5 | `.,;:!?)]}&»”` |
| `symbols_preceded_by_space` | `0x7f110402` | `d` | 4 | `([{&«ℎ“` |
| `symbols_special_word_connectors` | `0x7f110404` | `i` | 9 | `#@&._*` |
| `symbols_word_connectors` | `0x7f110405` | `h` | 8 | `"'-"` |
| `symbols_word_separators` | `0x7f110406` | `g` | **7** | 见下 |
| `symbols_sentence_terminators` | `0x7f110403` | `k` | 11 | `".?!` |
| `symbols_clustering_together` | `0x7f1103ff` | `f` | 6 | 空 |

`chs.smali` 的 `a()` 方法在按 protobuf tag 拼装消息长度时，用 `const/4 v1, 0x7` 处理 `g` 字段（第 417 行），确认 tag 7 就是 `symbols_word_separators`。

`adz` 会为每个启用的语言各建一个 `chs`，所以英文输入法读的是 `values-en`，中文输入法读的是基目录 `values`。

### 退格为什么被吞

英文 IME 的按键入口 `LatinIme.handle` 把按键换算成 `chw`（触摸数据）后，交给 `adw.a(JLchw;)Z`（`decodeTouch`）。符号键的数据是单码位字符串，它的键码 `chw.d` 就是符号的码位（`LatinIme.smali` 第 571 至 572 行 `Character.codePointAt`）。退格键的 `chw.d` 才等于 `0x8`。

`adw.a(JLchw;)Z` 对 `chw.d == 0x8` 的分支（`adw.smali` 第 2501 至 2567 行）逻辑如下：

```text
若 keycode != 0x8            → 正常处理
若解码结果含候选 chk(tag 2)   → 正常处理
若解码结果含标点 chh(tag 3)   → 正常处理
否则：
    若 cgp.h == false        → 挂起分支，丢弃本次退格
    若联想状态 azh.a() == false → 正常处理
    否则（联想列表非空）        → 挂起分支，丢弃本次退格
```

`cgp.h` 就是 `extra_value_latin_enable_suspend_prediction_on_backspace`（`LatinIme.smali` 第 4820 至 4826 行读取，第 1012 至 1014 行抄进 `cgp.h`）。`azh.a()Z` 的返回值是「当前联想列表非空」（`azh.smali` 第 567 至 603 行，`!list.isEmpty()`）。

四个英文 IME 定义都把这个开关写成 `true`（`ime_en_qwerty.xml`、`ime_en_hard_12keys.xml`、`ime_en_floating_hard_12keys.xml`、`ime_en_9key.xml` 第 12 行一致），所以实测设备（英文 9 键）走的是上表第二、三行。

于是可以读出真正的判据：

> **一次退格，如果它的解码结果既没有候选也没有标点，且当前联想列表非空（或挂起开关被关掉），就会被挂起并丢弃。**

普通字母之后按退格，解码器能解出候选 `chk`（缩进后的词形），所以走正常分支，一次删掉。符号是词分隔符时，符号之后的退格没有可解码的内容，但候选区仍保留着联想列表，于是落进挂起分支，被丢弃。这与真机现象一致，也正是用户描述的「第一次退格退出建议状态」。

### 与两个开关的关系

上一份文档用单变量实验确认 `en_t9_multitap_enabled` 单独就足以翻转结果。这与本节结论相容：「复古 9 键」开启后联想不再活跃，`azh.a()` 恒为假，那条链路整体不再产生联想状态，退格自然不再被吞。它并没有改变退格判据本身，只是让判据的上游条件不成立。

## 二、触发符号清单

英文 `values-en/strings.xml` 的 `symbols_word_separators` 原文（含转义）：

```text
" \u0009
 ()[]{}*&amp; &lt; > += |., ;:!?/\"、：；（）〜…。？！"
```

展开为码位集合：

```text
空格 \t \n NBSP
( ) [ ] { } * & < > + = | . , ; : ! ? / "
、 ： ； （ ） 〜 … 。 ？ ！
```

中文基目录 `values/strings.xml` 的同名字段：

```text
" \u0009
 ()[]{}*&amp;&lt;>+=|.,;:!?/\""
```

即 `空格 \t \n ( ) [ ] { } * & < > + = | . , ; : ! ? / "`，只含 ASCII，不含中文标点。

### 实测与配置的吻合

上一份文档在英文九键符号页逐键测得：

| 符号 | 一次退格后 | 是否在英文分隔符集合 |
| --- | --- | --- |
| `!` | 被吞 | 是 |
| `&` | 被吞 | 是 |
| `*` | 被吞 | 是 |
| `(` | 被吞 | 是 |
| `)` | 被吞 | 是 |
| `=` | 被吞 | 是 |
| `@` | 正常 | 否 |
| `#` | 正常 | 否 |
| `$` | 正常 | 否 |
| `%` | 正常 | 否 |
| `^` | 正常 | 否 |

11/11 吻合。被吞的 6 个全部在集合内，正常的 5 个全部不在集合内。这证明差异来自 `symbols_word_separators`，而不是符号本身的某种编码特性。

### 英文下完整触发清单

按同一判据推得，英文输入状态下以下符号会引发后续建议、并吞掉第一次退格：

- 半角：`! ? , . ; : / " ( ) [ ] { } * & < > + = |`
- 全角与中文标点：`、 ： ； （ ） 〜 … 。 ？ ！`

不在清单内、退格正常的符号，例如 `@ # $ % ^ \` ~ ° ± × ÷` 以及形状与数字类，都不触发。

同一份符号页上的 `( )` 落在清单内，这正是用户遇到配对补全后要按两次退格的原因。

中文输入状态下的触发集合更小，只有 ASCII 的那一组（中文标点不在基目录集合里）。但中文键 `k` `l` 下滑输出的全角 `（` `）` 等是否触发，取决于当时走的是哪个语言的语法配置，建议真机复核。

## 三、修改建议与反例

### 先排除一个看似直接的改法

上一份文档在「是否处理」一节建议：「若产品上要消除，把这四处改成 `false` 即可」。逐字节复核后确认**这个建议是错的**。

`adw.smali` 第 2525 至 2540 行的分支是：

```text
iget-boolean v1, v1, Lcgp;->h:Z
if-eqz v1, :cond_3          # cgp.h == false 就无条件跳到挂起分支
... azh.a() ...
if-nez v1, :cond_5          # azh.a() == false（联想为空）才走正常分支
:cond_3                     # 挂起，丢弃
```

也就是 `cgp.h == false` 时**无条件**进入挂起分支。把四个英文 IME 定义里的开关改成 `false`，会让候选缺失的退格**全部**被吞，问题加重而不是消失。

旁证：`ime_en_floating_hard_qwerty.xml` 与 `ime_en_hard_qwerty.xml` 这两个定义本来就没有该条目，`LatinIme.initialize` 传入的默认值是 `v10 = 0`，即 `cgp.h = false`。它们正是「无条件挂起」的那一档。这个默认值取自 `LatinIme.smali` 第 4636 行 `const/4 v10, 0x0`。

所以这条开关不能动。

### 收窄 `symbols_word_separators` 的代价

判据是「退格的解码结果无候选」。符号被当作词分隔符，是解码结果为空的原因。把标点从分隔符集合里移除，符号之后就不再结束词，退格的解码结果回到有候选的路径，一次删除即可恢复。

这是最小改动，但代价是**连带改变多个功能**。分隔符集合是喂给原生解码器的，解码器用它同时判断词边界、自动空格、自动大写与句末标点。移除符号等于把这些行为一起改掉。

关于「只影响下一词预测」这个问题，逐字形核对后的答案是：

**可以，而且 `next_word_prediction` 正是一根只作用于下一词预测的独立开关，但它是全局用户设置，没有办法只对符号生效。**

依据如下，`LatinIme.a(EditorInfo)Lcgp;` 把每个偏好写进**独立的**解码器配置字段，互不共用：

| 偏好或资源 | `cgp` 字段 | protobuf tag | 作用 |
| --- | --- | --- | --- |
| `next_word_prediction` | `c` | 3 | 下一词预测（含 `_enable_auto_compounding`） |
| `extra_value_latin_enable_suspend_prediction_on_backspace` | `h` | 11 | 退格挂起 |
| `shouldEnableAutoCorrection()` | `a` | 1 | 自动纠错 |
| `pref_key_enable_auto_capitalization`（`0x7f110242`） | `f` | 6 | 自动大写 |

`next_word_prediction` 在整套 smali 里只被读一次（`LatinIme.smali` 第 913 至 923 行），赋值给 `cgp.c`，再序列化为 tag 3 交给解码器，用于 `auto_compounding`。它不参与自动空格的启用条件，也不参与自动大写。

自动空格另有一条独立判据。`AbstractAutoSpaceProcessor` 的启用要求 `pref_key_english_prediction`（`0x7f11026b`）与 `pref_key_auto_space_smart_punctuation`（`0x7f110244`），中文再要求 `pref_key_enable_auto_space`（`0x7f110251`）。这三个键都不含 `next_word_prediction`。

所以两根杠杆的覆盖面不同：

- **关 `next_word_prediction`**：只停下一词预测，自动空格与自动大写的启用条件不变。但它是全局设置，关掉后普通输入时也不再预测下一词。
- **收窄 `symbols_word_separators`**：改动在解码器的词边界层面，同时影响下一词预测、自动空格、自动大写与智能标点。

### 现有实现没有「只对符号关预测」的开关

逐字核对 `aze`、`chs`、`cgp`、`LatinIme` 后确认，没有任何一处按「当前输入的是符号」来单独关闭预测。词边界由分隔符集合统一决定，退格的挂起由 `cgp.h` 与联想状态 `azh.a()` 共同决定，二者都不区分「预测因符号产生」还是「预测因字母产生」。

因此要让「只有符号不引发预测、自动空格与自动大写照常」，必须落在「符号」这一层，而不是改资源或开关。下一节核实这条路的可行性。

### 三个可选项的对比

| 方案 | 触发符号不再被吞 | 自动空格 | 自动大写 | 普通输入的下一词预测 | 改动面 |
| --- | --- | --- | --- | --- | --- |
| 关 `next_word_prediction` | 是 | 保留 | 保留 | 一并停用 | 改一个默认值或让用户自关 |
| 收窄 `symbols_word_separators` | 是 | 受影响 | 受影响 | 保留 | 改两个字符串资源 |
| 在补全钩子里清预测状态 | 是 | 保留 | 保留 | 保留 | 改 `PairedPunctuationHook` 与中文处理器链 |

前两项都是全局取舍，只有第三项理论上能精确落在「符号」这一层。第三项经核实行不通，理由见下一节。修正后的对比：

### 补全钩子能否清掉预测状态（已核实）

结论：**现有钩子拿不到清空预测状态的 API，这条路要先改框架层才能走通。**

逐一核对可达面：

| 候选 API | 归属 | 实际作用 | 能否让 `azh.a()` 变假 |
| --- | --- | --- | --- |
| `azh.b()V` | 解码侧联想容器 | `list.clear()`，真正的清空 | 能，但是 `private`，钩子不可达 |
| `azh.a()V` | 同上 | 只把读取游标 `a:I` 置 0，不动列表 | 不能 |
| `Layx.a()V` | 解码器 | 只是 post 一个 `Layz`，最终调用 `Layv.a()` | 不能 |
| `Layv.a()V` | 解码器到框架的桥 | 只调 `textCandidatesUpdated(false)` | 不能 |
| `IImeDelegate.textCandidatesUpdated(Z)` | 框架 | 向外通知候选区，方向是「出」 | 不能 |
| `IImeDelegate.finishComposingText()` | 框架 | 作用于编辑器的 InputConnection | 不能 |

钩子能拿到的是 `IImeDelegate`（`PairedPunctuationHook` 的 `p1`、`PairedPunctuationProcessor` 的 `a:IImeActionDelegate`/`a:IImeContextDelegate`）。`azh` 挂在解码器侧的 `Layx.a`，没有暴露给 `IImeDelegate`。`textCandidatesUpdated` 与 `finishComposingText` 都是向外通知，不回收解码器内部状态。

联想列表只有在解码结果 `cfk` 带标点字段 `chh`（tag 3）时，才由 `Layx.a(Lcfk;...)` 重新灌入（`ayx.smali` 第 1995 至 1999 行），也就是只有解码器自己的下一次解码能改写它。钩子直接 `commitText` 绕开了 `handle()`，等于跳过了这次解码，于是上一轮的联想列表原样留在 `azh` 里，这正是英文路径下符号之后仍显示建议的原因。

因此若要保留「符号之外的下一词预测」，需要改的是 `adw.a(JLchw;)Z` 的判据本身，或让英文路径的符号也走一次解码；两者都超出「只改资源/开关」的范围，属于新的实现任务。

### 只删成对符号的范围更小

如果只修配对补全引入的痛点，可以把 31 对成对符号里属于 ASCII 的左右半边从 `symbols_word_separators` 移除，例如 `( ) [ ] { } < > " '`。这仍会改变这些符号的自动空格与自动大写行为，只是范围更小。

### 不建议的改法

- 在 `PairedPunctuationHook` 里拦截退格再补发一次删除。这会让补全代码承担与它无关的职责，破坏「提交完成即结束，不维护补全状态」的既定设计，也会影响中文处理器链
- 把四个英文 IME 定义的 `extra_value_latin_enable_suspend_prediction_on_backspace` 改成 `false`。理由见上一节，会让问题加重

## 四、证据位置

- 反编译产物：`work/decoded/`（原始 APK 解码），关键类 `adw`、`cgp`、`aze`、`chs`、`azd`、`azh`、`ayx`、`LatinIme`
- 交叉核对脚本：`work/pairauto/symbol_separator_scan.py`，扫全部符号页并对照英文分隔符集合
- 相关文档：[成对标点自动补全方案调研](paired-punctuation-autocomplete-research.md) 的「符号后第一次退格被吞」一节
- 真机复现脚本（设备侧）见上一份文档记录的 `.workbuddy/tmp/`

## 五、待确认问题

1. 中文输入法读的是基目录 `values`，还是按输入法语言另有覆盖，需要核对中文符号页的全角符号是否触发
2. 若采用「关 `next_word_prediction`」，是否接受普通输入时也失去下一词预测
3. 若要保留「符号之外的下一词预测」，是否接受改动解码判据 `adw.a(JLchw;)Z`，或让英文路径的符号也走一次解码。两者都超出资源与开关的范围
4. 目标范围待定：修配对补全的痛点、只让符号不引发预测，还是让所有符号都不引发建议
