# Google 拼音 4.5.2 初始架构图

## 文档状态

本文档记录阶段 0 第二轮静态研究结果。它描述固定 APK 中已经确认的职责和数据流，不代表未来原生工程的模块设计。

证据来自：

- JADX 1.5.6 对固定 `classes.dex` 的反编译结果
- JADX 生成的静态 call graph
- `aapt dump xmltree` 对 Manifest、framework、IME、processor 和 keyboard XML 的解析
- 现有候选、Header、设置和词典研究文档

反编译代码只用于理解逻辑。JADX 恢复的变量名、控制流和类型可能不准确，不能把 Java 输出当成原始源码。

## DEX 概况

固定 APK 只有一个 `classes.dex`。JADX 处理结果：

| 项目 | 数量 |
| --- | ---: |
| JADX 报告的反编译进度单元 | 1,842 |
| 输出 Java 文件 | 2,953 |
| Java package | 111 |
| call graph 节点 | 16,130 |
| call graph 边 | 27,080 |
| Java `native` 方法声明 | 180 |
| 包含 `native` 声明的类 | 12 |

2,373 个 Java 文件位于 `defpackage`。这主要来自混淆后失去稳定 package 身份的类，说明未来不能只依赖 package 名完成职责划分。

JADX 报告 2 个方法无法完整反编译：

- `defpackage.bnr` 中一个 566 instruction unit 的方法
- `defpackage.xw` 中一个 411 instruction unit 的方法

`defpackage.bnr` 另有一个 IfRegionVisitor 错误。结合类引用和方法职责复核后，`bnr.handleMessage()` 属于 Google Play services API manager，`xw.run()` 属于旧 RecyclerView GapWorker。两者都不在核心输入路径，因此不阻塞当前输入引擎研究。

## 总体数据流

当前可以确认的主路径为：

```text
Android Framework
  → PinyinIME
  → GoogleInputMethodService
  → InputBundleManager
  → 当前 InputBundle
      ├─ ImeDef / KeyboardGroupDef
      ├─ IIme
      ├─ IKeyboard
      └─ InputConnection delegate
  → AsyncChineseProcessorBasedIme
  → processor chain
  → AbstractHmmPinyinDecodeProcessor
  → AbstractHmmChineseDecodeProcessor
  → HmmEngineWrapper
  → HmmEngineInterfaceImpl
  → JNI
  → libhmm_gesture_hwr_zh.so
  → libpinyin_data_bundle.so / mutable dictionaries
  → Candidate
  → InputBundle
  → active keyboard candidate controller
  → InputConnection composing / commit
```

该图中的 Java 层顺序已有静态代码和 XML 证据。native 内部如何从输入图生成候选，目前仍是黑盒。

## 1. 应用初始化

### PinyinApp

`PinyinApp` 继承通用 `AppBase`，负责拼音产品级初始化。

静态初始化调用：

```text
amd.a(
  "hmm_gesture_hwr_zh",
  "hmm",
  "gesture",
  "handwriting",
  "hwr_zh_model",
  "jni_delight4decoder"
)
```

这表明 APK 中的单个 `libhmm_gesture_hwr_zh.so` 向 Java 层提供多个逻辑库身份。`EngineFactory` 后续请求 `hmm`，gesture JniUtil 请求 `gesture`，Delight4 请求 `jni_delight4decoder`。具体别名和 JNI 注册如何建立，仍需分析 `amd` 及 ELF 初始化过程。

应用初始化还负责：

- 注册联系人、在线词典更新和账户同步的旧权限关系
- 初始化中英文 HMM engine factory
- 导入 Android 自定义短语
- 配置 `word_explanation` 和 `token_character` raw 资源
- 删除匹配 `UserHistory.*.dict` 的旧文件
- 写入各组 Preference 默认值和强制值

### PinyinIME

`PinyinIME` 通过混淆中间基类 `abp` 继承 `GoogleInputMethodService`。它负责：

- 启动首次引导
- 初始化中文 engine factory
- 注册原版在线新词更新、英文周期任务和可选 daily ping
- 输入开始时按需启动中英文词典保存任务
- Service 或输入法关闭时立即保存中英文词典
- 根据设备能力注册 soft、traditional hard 或 floating hard framework
- 创建主题和拼音专用 LayoutInflater
- 在输入视图启动后处理新词更新提示及 Dashboard 提示

Comeback 已移除或禁用在线更新、daily ping、统计和账户同步。原生版本需要保留本地初始化与保存语义，不能照搬失效任务。

## 2. XML 驱动的 framework

Google 拼音不是在 `PinyinIME` 中硬编码所有输入模式。Service 先加载 framework XML，再由 framework XML include 各个 IME 定义。

### 基础输入字段

```text
framework_basic.xml
  ├─ ime_number.xml
  ├─ ime_number_password.xml
  ├─ ime_phone_number.xml
  ├─ ime_date_time.xml
  ├─ ime_password.xml
  └─ ime_dashboard.xml
```

### 中文 soft keyboard

```text
framework_chinese_soft.xml
  ├─ ime_zh_cn_pinyin_qwerty.xml
  ├─ ime_zh_cn_pinyin_9key.xml
  ├─ ime_zh_cn_stroke.xml
  └─ ime_zh_cn_handwriting.xml
```

### 英文 soft keyboard

```text
framework_english_soft.xml
  ├─ ime_en_qwerty.xml
  └─ ime_en_9key.xml
```

### traditional hard keyboard

包含英文、拼音、密码、电话、数字和日期时间的 QWERTY 与 12 键变体。

### floating hard keyboard

同样包含英文、拼音、密码、电话、数字和日期时间的 QWERTY 与 12 键变体，但使用独立 floating 定义。

因此，输入字段分类、设备能力和 PrimeKeyboardType 先决定加载哪组 framework，再由 ImeDef 决定 IIme、键盘组和 processor。

## 3. InputBundle 的职责

`InputBundle` 同时实现：

- `IImeDelegate`
- `IKeyboardDelegate`
- `KeyboardGroupManager.Delegate`

每个 InputBundle 持有：

- 一个从 XML 构建的 `ImeDef`
- 当前 `IIme`
- 当前 `IKeyboard`
- 当前 keyboard group 和 keyboard type
- 键盘状态、候选状态和生命周期状态
- 对 `InputConnection`、View holder 和 Service 的 delegate

`InputBundle.a` builder 使用 `SimpleXmlParser` 构建 `ImeDef`。`IIme` 类名来自 XML，并通过 class loader 反射实例化。密码等受限场景可以改用 `DummyIme`，而不是创建正常解码器。

当前静态代码已经确认 InputBundle 负责：

- 激活和停用 IIme
- 激活 Prime、symbol、digit 等 keyboard type
- 将键盘 View 安装到 Service 提供的 holder
- 转发按键和候选事件
- 更新 composing、reading text 和 text candidates
- 完成、取消或中止 composing
- 调用最终 InputConnection 输出通道

这解释了为什么现有剪贴板和 Header 补丁必须尊重 InputBundle、Candidate 和 KeyboardViewHolder 的既有协议。

## 4. 中文 QWERTY 和九键

### QWERTY 资源链

```text
ime_zh_cn_pinyin_qwerty.xml
  → AsyncChineseProcessorBasedIme
  → keyboard_zh_cn_pinyin_qwerty.xml
  → processors_zh_cn_pinyin_qwerty.xml
```

IME 定义包含 Prime、digit、symbol、smiley 和 emoticon 键盘。processor 顺序为：

```text
HmmPinyinQwertyDecodeProcessor
ChineseDoubleSpaceProcessor
ChineseAutoSpaceProcessor
ScrubMoveProcessor
OutputProcessor
```

QWERTY keyboard 使用 `PrimeKeyboard`，Header 为 `keyboard_prime_header`，Body 为 `keyboard_qwerty_chinese_body`。它注册：

- `BasicMotionEventHandler`
- `SpatialModelMotionEventHandler`
- `PinyinGestureHandler`
- `PinyinKeyboardLayoutHandler`
- `ScrubMoveMotionEventHandler`

这表明触摸按键、空间模型、滑行输入、native keyboard layout 更新和空格滑动是相互独立的 handler。

### 九键资源链

九键外围 processor 与 QWERTY 相同，核心解码器为 `HmmPinyinT9DecodeProcessor`。

九键 keyboard 使用 `T9Keyboard`，注册：

- `BasicMotionEventHandler`
- `Pinyin9KeyGestureHandler`
- `Pinyin9KeyKeyboardLayoutHandler`
- `ScrubMoveMotionEventHandler`

QWERTY 与九键共享 InputBundle、Candidate、HMM wrapper、自动空格、双空格和输出协议，但使用不同 engine ID、decode processor、键盘类、手势 handler 和 layout handler。

## 5. 拼音 DecodeProcessor

`AbstractHmmPinyinDecodeProcessor` 是拼音专用适配层。已经确认它负责：

- 从 `bdt` 取得中文 HMM engine factory
- 激活和停用拼音特殊事件 handler
- 读取中英文混输设置
- 根据拼音方案改变键盘状态
- 判断按键是否交给 engine
- 处理 Backspace、Space、Enter、撇号和非 engine 字符
- 委托候选选择
- 重置拼音专用内部状态
- 连接中文和英文 mutable dictionary accessor

Microsoft 和紫光双拼会额外启用分号输入状态。其他方案的差异主要通过 token dictionary 和 keyboard mapping 表达，仍需逐方案确认。

## 6. HMM Java 包装层

### EngineFactory

`EngineFactory` 是 native engine factory 的 Java 所有者。静态初始化请求逻辑库 `hmm` 并调用 `initJNI()`。

它提供：

- `DataManager`
- `SettingManager`
- `HmmEngineInterface`
- `MutableDictionaryAccessorInterface`

所有对象都由 native pointer 表示，Java wrapper 负责生命周期和参数转换。

### HmmEngineInterfaceImpl

该类具有 69 个 `native` 方法，是当前最大的 JNI 接口。能力包括：

- append 单个或多个 scored input
- 添加 input edge
- 输入 touch bulk data
- 输入手写 lattice
- 生成普通、prediction 和 token candidate list
- 查询 candidate、segment、token 和 input unit
- 选择、取消选择和反转换
- 删除输入和候选
- 设置 separator 和 keyboard layout
- 重置、刷新数据和 user ID

由此可以确认 native engine 内部不是简单的「拼音字符串到候选列表」函数。它暴露顶点 Range、segment、token、input unit、候选高亮、转换状态和数据源。

### HmmEngineWrapper

`HmmEngineWrapper` 在 native engine 之上维护 Java 侧输入会话状态：

- composing 是否活动
- 当前候选和 token candidates
- highlighted candidate
- 已选择 token range 历史
- 已转换 segment range 历史
- text-before-cursor 及其 engine range
- 最近一次 bulk input range
- 用户词典 data ID 与 index

普通按键会被转换为 `ScoredInput(text, score)` 后 append 到 native engine。更新成功后，wrapper 重新读取 token candidates、普通 candidates 和 composing 结构，再通知 delegate。

composing 的结构不是单一字符串。wrapper 逐层读取：

```text
segment
  → token
      → input unit
```

每层都可能具有 Range、语言、normalized string、confident string、selected、targeted 和 converted 状态。未来行为规格和引擎接口必须能够表达部分选择和重新组词，不能只保存一个 `composingText`。

## 7. 数据 scheme 和 engine 身份

中文 factory 是混淆类 `bdt`，英文 factory 是 `agb`。

### 中文 engine

中文 factory 从 `libpinyin_data_bundle.so` 取得内置 data scheme 和 setting scheme。它声明四个 engine ID：

| 序号 | engine ID | 用途 |
| ---: | --- | --- |
| 0 | `zh-t-i0-pinyin-x-f0-delight` | 拼音 QWERTY |
| 1 | `zh-t-i0-pinyin-x-l0-t9key` | 拼音九键 |
| 2 | `zh-t-i0-handwriting` | 中文手写 |
| 3 | `zh-t-i0-stroke` | 中文笔画 |

对应 setting scheme：

```text
pinyin_qwerty_setting_scheme
pinyin_t9_setting_scheme
pinyin_handwriting_setting_scheme
stroke_setting_scheme
```

七种拼音方案通过不同 token dictionary 选择：

```text
zh_t_i0_pinyin_android_token_dictionary
zh_t_i0_shuangpin_abc_android_token_dictionary
zh_t_i0_shuangpin_flypy_android_token_dictionary
zh_t_i0_shuangpin_jiajia_android_token_dictionary
zh_t_i0_shuangpin_ms_android_token_dictionary
zh_t_i0_shuangpin_ziguang_android_token_dictionary
zh_t_i0_shuangpin_ziranma_android_token_dictionary
```

中英文混输、数字混输、Emoji 和 12 组模糊音同样通过向 setting scheme 追加对应 token dictionary、dictionary data 或 fuzzy expansion dictionary 实现。

setting 顶层结构、Preference 修改点和容器边界已经进一步确认：

- field 2 选择 token dictionary
- field 3 追加 fuzzy expansion
- field 4 和 field 5 装配 dictionary data
- field 10 保存 engine 参数
- field 15 保存 gesture module
- 每套双拼同时拥有普通 token trie 和 gesture token ID trie

完整 schema 证据见 `setting-and-container-formats.md`。全拼和六套双拼的 token ID、score、meta、code、node ID 和 prefix score 表边界已经恢复，数字词典则不含独立 node ID 和 prefix score。expansion token ID 也已对齐到相应 key，详见 `token-dictionary-auxiliary.md`。各类 score 和 meta 的量化语义仍未知。

### mutable dictionary

中文 factory 声明：

```text
system_optional_dict_3_3
contacts_dict_3_3
user_dict_3_3
shortcuts_dict_3_3
```

抽象 factory 将其解释为：

1. new words
2. contacts
3. user dictionary
4. shortcuts

代码常量给出：

```text
NEW_WORDS_DICTIONARY_CAPACITY = 10,000
USER_DICTIONARY_CAPACITY = 500,000
```

容量是原版静态约束，不自动成为未来实现要求。需要结合实际文件和行为确认其用户影响。

英文 factory 使用：

```text
contacts_dict_3_3_english
user_dict_3_3_english
shortcuts_dict_3_3_english
```

中文 factory 可以把英文 user、contacts 和 system dictionary 加入中文 engine setting，由此实现中英文混输。

## 8. 用户词典 JNI

`MutableDictionaryAccessorInterfaceImpl` 提供 25 个 native 方法，已经确认的操作包括：

- `addCount`
- `decreaseCount`
- `insertOrUpdate`
- 按 token 和 value 删除
- 按 value 删除
- 导出全部或已修改 entry
- clear、compact 和 duplicate
- persist
- get count、size 和 last sync time
- 标记 entry 为未修改

这些接口说明原版词典同时支持权重变化、修改状态和同步时间。它仍不能证明文件格式，也不能证明每次候选选择对应多少 count。后续动态实验必须直接测量调用和持久化差分。

## 9. 滑行和手写

### 滑行

`HmmGestureDecoder` 具有 9 个 native 方法，负责：

- 创建和释放 decoder
- 输入序列解码
- 结果过滤
- 设置 keyboard layout
- 数据或设置变化后的 reload
- profiling

QWERTY 与九键分别有拼音 gesture handler。英文另有独立 handler，并存在 Delight4 `Decoder`。当前不能只根据 handler 名称判断中英文滑行是否共享同一 native 模型。

### 手写

手写 keyboard 同时注册普通 soft key handler 和 handwriting motion handler。全屏手写另有独立 panel 及 fullscreen motion handler。

`WordRecognizerJNI` 提供 12 个 native 方法，包括：

- 初始化模型
- 开始识别
- 添加 stroke
- decode 和 finalize
- 获取 lattice
- 自定义字符限制
- 批量 recognize

手写识别结果可以通过 lattice 进入 HMM engine。画布、轨迹采样、识别器和 HMM 候选融合是四个不同职责，后续需要分别研究。

## 10. JNI 清单

12 个声明 native 方法的类如下：

| 类 | native 方法数 | 主要职责 |
| --- | ---: | --- |
| `HmmEngineInterfaceImpl` | 69 | HMM 输入图、候选、segment 和 token |
| `Decoder` | 26 | Delight4 英文解码和个性化 |
| `MutableDictionaryAccessorInterfaceImpl` | 25 | mutable dictionary 操作 |
| `DataManagerImpl` | 12 | data scheme 和数据载荷注册 |
| `WordRecognizerJNI` | 12 | 手写识别 |
| `DynamicLm` | 11 | Delight4 dynamic language model |
| `HmmGestureDecoder` | 9 | HMM 滑行解码 |
| `EngineFactory` | 8 | engine factory 和 wrapper 创建 |
| `SettingManagerImpl` | 3 | setting scheme 注册和读取 |
| HMM gesture `JniUtil` | 2 | gesture JNI 初始化和释放 |
| `LanguageIdentifier` | 2 | 语言识别 |
| Delight4 `JniUtil` | 1 | Delight4 JNI 初始化 |

这 180 个声明是 Java 侧接口清单，不等于 180 个独立 ELF export。ELF 分析已经确认统一库同时使用标准 `Java_...` export 和 `RegisterNatives` 风格的动态注册表，完整证据见 `native-boundary.md`。

## 11. 当前职责边界

### Java 层已经确认拥有

- Android Service 和 InputConnection 生命周期
- XML 解析、IME 选择和键盘组切换
- processor 顺序和事件分派
- Java 侧 composing 历史与候选对象转换
- Preference 到 engine setting scheme 的装配
- mutable dictionary 保存任务和导入、导出调度
- 键盘、候选、主题和 View 生命周期

### native 层已经确认拥有

- HMM input graph
- candidate、prediction 和 token candidate 生成
- segment、token 和 input unit 状态
- 拼音 QWERTY、九键、手写和笔画 engine
- gesture decode
- mutable dictionary 数据操作
- Delight4 decode 和 dynamic language model
- 手写识别及 lattice

### 仍无法确定

- 拼音 system dictionary 和 bigram 的内部索引及概率模型
- 候选最终分数如何组合
- 用户学习 count 的更新公式
- token score、meta、prefix score 和系统词典容器的内部字段语义
- 中文与英文滑行共享到什么程度
- 手写模型与拼音语言模型如何联合排序
- native 是否还有 Java 声明之外的内部模块

## 下一步

1. 将统一库动态注册表中的 method name、JNI signature 和函数地址建立精确映射
2. 追踪 DirectMappingTokenExpander 的迭代推进与 score 表构造，并独立分析笔画 ForwardTokenDictionary
3. 从 27,080 条 call graph 边中提取 Service、InputBundle、DecodeProcessor、HMM、词典、滑行和手写子图
4. 建立 XML include、class、layout、keymapping 和 processor 的机器可查询引用图
5. 运行时验证 `libhwrword.so` 是否被装载
6. 把 Comeback 补丁入口映射到本架构图和功能清单 ID
