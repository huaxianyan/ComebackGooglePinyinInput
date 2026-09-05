# 原生重写研究基线与方法

## 文档状态

这是阶段 0 的首轮静态盘点，只确认固定原始 APK 的外部结构、Manifest、资源入口和当前兼容版基线。DEX 控制流、JNI 协议、native 数据格式和运行时行为尚未在本轮确认。

## 基准身份

### Google 拼音原版

| 项目 | 结果 | 证据 |
| --- | --- | --- |
| 产品 | Google 拼音输入法 | APK label |
| 版本 | `4.5.2.193126728-arm64-v8a` | APK Manifest |
| versionCode | `4520313` | APK Manifest |
| 包名 | `com.google.android.inputmethod.pinyin` | APK Manifest |
| min SDK | 17 | APK Manifest |
| target SDK | 26 | APK Manifest |
| ABI | `arm64-v8a` | APK native-code |
| APK 大小 | 19,148,368 bytes | 本地文件 |
| APK SHA-256 | `980fd0f4695f683648e6f7ab9a15a24732e8957b5b14b25d49af931176574bd7` | 本地重新计算，与 `docs/original-apk-provenance.md` 一致 |

固定输入文件：

```text
original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk
```

### Comeback 兼容版

研究 worktree 初始基线：

```text
branch: research/native-rewrite
commit: 1e8fb9276acd3ef666536222dd394170427ff033
release: v2.0.10
```

Rime 双向同步正在独立 worktree 的 `feat/rime-dictionary-sync` 开发。本研究不读取其未提交内容。该能力合并后再以最终提交更新基线。

## 本轮研究方法

本轮使用 Android SDK Build Tools 36.0.0 的 `aapt` 直接读取 APK，没有修改或重新打包 APK：

```text
aapt dump badging <apk>
aapt dump permissions <apk>
aapt dump xmltree <apk> AndroidManifest.xml
aapt dump xmltree <apk> <resource.xml>
aapt dump resources <apk>
```

同时使用 Python `zipfile` 读取 ZIP central directory，记录每个 entry 的路径、原始大小、压缩大小、压缩方式和 CRC-32。

临时证据位于：

```text
work/native-rewrite/original-apk/
```

该目录受 `.gitignore` 的 `work/` 规则排除，不进入仓库。长期文档只保留结论、必要数值和复现方法。

## APK 结构

APK 共 2,099 个 entry。顶层结构如下：

| 顶层路径 | 数量 | 当前判断 |
| --- | ---: | --- |
| `res/` | 2,009 | Android 布局、键盘定义、设置、图片、字符串和模型相关 raw 资源 |
| `assets/` | 76 | 75 个主题 `binarypb` 文件和 1 个许可证页面 |
| `lib/` | 5 | ARM64 native 库 |
| `META-INF/` | 4 | APK 签名元数据 |
| `AndroidManifest.xml` | 1 | 编译后的应用清单 |
| `classes.dex` | 1 | Java/Dalvik 主程序，未使用 multidex |
| `resources.arsc` | 1 | 编译后的资源表 |
| 其他根文件 | 2 | `android-support-multidex.version.txt` 和 `build-data.properties` |

关键文件大小：

| 文件 | 未压缩大小 |
| --- | ---: |
| `classes.dex` | 3,088,184 bytes |
| `resources.arsc` | 3,848,020 bytes |

资源目录中已经确认：

- 409 个编译 XML，包括手机、平板、电视、API 19 和 API 25 变体
- 406 个 layout，包括手机、平板、电视、横屏和 API 版本变体
- 15 个 raw 资源
- 8 个应用图标位图
- 多套密度、平板、电视、横屏和 RTL 资源变体

这些数量只说明资源存在，不能单独证明对应功能在目标设备上可达或正常运行。

## Android 组件

### 核心组件

| 类型 | 类 | 静态职责 |
| --- | --- | --- |
| Application | `com.google.android.apps.inputmethod.pinyin.PinyinApp` | 应用初始化入口 |
| Service | `com.google.android.inputmethod.pinyin.PinyinIME` | 绑定 `android.view.InputMethod` 的输入法服务，`directBootAware=true` |
| Activity | `com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity` | 手机和 Leanback 启动入口 |
| Activity | `com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity` | 输入法设置入口 |
| Activity | `com.google.android.apps.inputmethod.pinyin.firstrun.PinyinFirstRunActivity` | 首次引导入口 |
| Activity | `com.google.android.apps.inputmethod.pinyin.firstrun.PinyinFeatureActivity` | 功能介绍入口 |
| Activity | `com.google.android.apps.inputmethod.libs.framework.core.PermissionsActivity` | 旧权限入口 |
| Receiver | `com.google.android.apps.inputmethod.libs.framework.core.LauncherIconVisibilityInitializer` | 开机和覆盖安装后的启动器图标状态初始化 |
| BackupAgent | `com.google.android.apps.inputmethod.libs.framework.core.BackupAgent` | Android 备份和恢复入口 |

### 设置、主题和电视

Manifest 还声明：

- `ThemeSelectorActivity`
- `ThemeBuilderActivity`
- `ThemeEditorActivity`
- `TVSettingsActivity`
- `MiniBrowserActivity`
- `BlankActivity`
- `UnquantumLicenseMenuActivity`
- `UnquantumLicenseActivity`

电视资源包含独立 framework、IME、键盘、候选和设置定义。是否把 Android TV 作为原生重写目标尚未决定，已进入功能清单等待产品决策。

### 已失效或已从 Comeback 移除的组件组

原版 Manifest 包含：

- Google 账户词典 `SyncService`
- 用户词典 `StubProvider`
- `AndroidAccountActivity`
- Google Sign-In Activity 和撤销 Service
- Firebase Instance ID Receiver 和 Service
- Firebase JobDispatcher Receiver
- Google User Feedback Activity 和发送 Service
- Primes 调试 Activity

当前兼容版已经移除 Google 账户同步、Firebase、反馈上传、统计和失效在线词典更新入口。原生重写不默认恢复这些组件，但功能清单仍记录其历史身份和替代决定。

## 权限基线

原版显式申请 15 项权限：

```text
android.permission.VIBRATE
android.permission.INTERNET
android.permission.READ_USER_DICTIONARY
android.permission.WRITE_USER_DICTIONARY
android.permission.READ_CONTACTS
android.permission.ACCESS_NETWORK_STATE
android.permission.USE_CREDENTIALS
android.permission.GET_ACCOUNTS
android.permission.MANAGE_ACCOUNTS
android.permission.RECEIVE_BOOT_COMPLETED
android.permission.READ_SYNC_SETTINGS
android.permission.WRITE_SYNC_SETTINGS
android.permission.WRITE_EXTERNAL_STORAGE
android.permission.GET_PACKAGE_SIZE
com.google.android.providers.gsf.permission.READ_GSERVICES
```

`aapt dump badging` 另列出由 `WRITE_EXTERNAL_STORAGE` 推导的 `READ_EXTERNAL_STORAGE`。

这份权限表只代表原版声明。未来研究需要把每项权限映射到调用方、用户能力和 Comeback 最终状态。原生重写应从实际能力推导最小权限，不复制原版权限集合。

## IME 声明和输入模式

API 19 资源 `res/xml-v19/method.xml` 静态确认：

- 设置 Activity 为原版 `SettingsActivity`
- 支持系统「切换到下一个输入法」协议
- 声明一个 `zh_CN`、mode=`keyboard` 的 subtype
- subtype 同时标记 `AsciiCapable` 和 `EmojiCapable`
- subtype 的 `isAsciiCapable=true`

IME 并非通过多个 Android subtype 表达内部模式。中文、英文、专用字段和符号等模式由应用内部 framework/IME/keyboard XML 组合管理。

已确认的主要 IME 定义包括：

- 中文拼音 QWERTY
- 中文拼音九键
- 中文手写
- 中文笔画
- 英文 QWERTY
- 英文九键
- 密码和数字密码
- 数字、电话和日期时间
- 浮动实体键盘及 12 键、QWERTY 变体
- Dashboard
- 符号、Emoji 和颜文字
- 电视拼音、英文、密码和符号

中文拼音 QWERTY 的静态组合为：

```text
AsyncChineseProcessorBasedIme
→ HmmPinyinQwertyDecodeProcessor
→ ChineseDoubleSpaceProcessor
→ ChineseAutoSpaceProcessor
→ ScrubMoveProcessor
→ OutputProcessor
```

九键使用同一外围处理链，但核心解码器替换为 `HmmPinyinT9DecodeProcessor`。这证明 QWERTY 与九键共享部分框架能力，但尚不能证明两个 native 解码协议完全一致。

## native 和数据载荷

### native 库

| 文件 | 未压缩大小 | 当前证据边界 |
| --- | ---: | --- |
| `libhmm_gesture_hwr_zh.so` | 6,926,712 bytes | 通过逻辑别名同时提供 HMM、gesture、中文手写和 Delight4 JNI；包含动态注册表证据 |
| `libpinyin_data_bundle.so` | 10,077,424 bytes | 以 start/end dynamic symbol 划分拼音词典、bigram、双拼、模糊音、笔画和 setting scheme 数据 |
| `libhwrword.so` | 2,373,728 bytes | 导出单字和词手写 JNI，但当前 DEX 没有直接装载引用，实际可达性待运行时确认 |
| `liben_data_bundle.so` | 9,456 bytes | 以 start/end dynamic symbol 提供英文 token、setting 和 accessor scheme |
| `libgnustl_shared.so` | 1,095,984 bytes | `libhwrword.so` 的 GNU C++ 运行时依赖，统一核心库没有声明依赖它 |

完整 ELF 和 JNI 边界见 `native-boundary.md`，63 个命名载荷的导出与格式分类见 `data-bundle-formats.md`，setting schema 和 Marisa 区间见 `setting-and-container-formats.md`，token auxiliary 与 native reader 证据见 `token-dictionary-auxiliary.md`。只有 `libhmm_gesture_hwr_zh.so` 的 `PT_LOAD` alignment 为 4 KiB，其余四个库均为 64 KiB。

### raw 数据

与输入能力直接相关的候选文件包括：

| 文件 | 未压缩大小 | 当前判断 |
| --- | ---: | --- |
| `main_en_d3_20160715.gzip` | 1,138,246 bytes | 既有项目已确认是英文模型载荷 |
| `metadata.json` | 2,349 bytes | 既有项目已确认英文模型通过 `openRawResourceFd()` 读取该未压缩资源 |
| `sc2tc_bigram.jpg` | 68,776 bytes | 简体到繁体转换数据，格式待确认 |
| `sc2tc_unigram.jpg` | 9,672 bytes | 简体到繁体转换数据，格式待确认 |
| `tc2sc_bigram_index.jpg` | 17,194 bytes | 繁体到简体索引数据，格式待确认 |
| `tc2sc_unigram_index.jpg` | 4,836 bytes | 繁体到简体索引数据，格式待确认 |
| `token_character` | 12,132 bytes | token 或字符数据，职责待确认 |
| `word_explanation` | 184,248 bytes | 词语解释数据，入口和用途待确认 |

`.jpg` 后缀不能证明这些文件是普通图片。后续需要根据读取代码、文件头和数据访问模式判断真实格式。

### 主题 assets

75 个 `assets/theme/*.binarypb` 文件构成内置主题 metadata、stylesheet、色彩规则和不同屏幕宽度覆盖。未来研究需要区分：

- 主题状态和布局规则
- 可以重新定义的设计 token
- 不能直接移植的原版资源

## 设置入口

原版 `res/xml/settings.xml` 静态确认五个顶层页面：

1. 输入设置
2. 键盘
3. 手写输入
4. 词典
5. 其他

`docs/modern-settings-preference-inventory.md` 已经对原始 Preference key、默认值、依赖、能力门控和 Compose 迁移作了详细盘点。原生重写研究直接引用该文档作为设置契约证据，不重复建立第二份 Preference 真值表。

## DEX 反编译基线

本轮使用 JADX 1.5.6 反编译固定 `classes.dex`，并生成静态 call graph。工具 ZIP 来自 JADX GitHub Release `v1.5.6`，本地校验 SHA-256 为：

```text
545ea2be9c242511bc145755cf4bda2485ade42966e096f8b4d3da2a230e8974
```

结果包括：

- 1,842 个 JADX 反编译进度单元
- 2,953 个 Java 输出文件
- 111 个 Java package
- 16,130 个 call graph 节点和 27,080 条边
- 12 个类中的 180 个 Java `native` 方法声明
- 2 个未能完整反编译的方法

反编译命令关闭了 method 和 anonymous class inline，也不使用 source name 替换原始 class name，以便尽量保留 DEX 边界。完整选项和架构结论见 `architecture-map.md`。

JADX 输出和工具位于被忽略的 `work/` 与 `tools/`，不进入仓库。Java 输出不是原始源码，涉及失败方法、可疑控制流或精确常量时必须回到 Smali 验证。

## 当前可确认的资源级能力

资源名称和 XML 引用已经提供以下强静态证据：

- QWERTY、九键、笔画和手写拥有独立 IME、keyboard、keymapping 与 processor 定义
- 候选存在固定、分页、reading text、浮动和不同设备布局
- 符号包含数字、数学、括号、箭头、形状、常用及中文变体
- Emoji 包含人物、动物、食物、活动、旅行、对象、符号和旗帜分类
- 颜文字包含笑、惊讶、悲伤、不满和流汗分类
- 存在文本编辑面板、方向移动、复制、剪切、粘贴等相关资源
- 存在单手模式、键盘移动、恢复位置和横屏布局
- 存在滑行输入、incognito、语音入口和输入法切换相关资源
- 存在手机、平板、电视、横屏和实体键盘配置

上述结论证明能力有静态组成部分，不等同于运行时已经验收。

## 尚未完成

阶段 0 仍需补充：

1. 统一库动态注册表中的 method name、signature 和函数地址映射
2. 27,080 条 call graph 边中的核心路径子图
3. 409 个 XML 的完整引用图，目前只确认 framework、IME、processor 和主要 keyboard 链路
4. token score、meta 与 prefix score 的量化语义及笔画容器边界，DirectMapping 后续工作见 [native 查找研究](direct-mapping-native.md#验证与限制)
5. `libhwrword.so` 实际装载与可达性的运行时验证
6. Preference、资源和实际运行能力之间的映射
7. Comeback 补丁到用户功能的完整追踪
8. 原版运行时入口和不可达历史组件的区分
9. Rime 双向同步合并后的最终能力基线
10. Android TV 是否纳入最终产品范围的决定

在这些工作完成前，`feature-inventory.md` 只是一份初始范围账本，不能宣称功能盘点已经完整。
