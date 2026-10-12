# Android 17 / API 37 适配前调查

设备于 2026-10-12 升级到 Android 17，target 36 已验收并发布为 `v2.1.6`，计划中「等待 target 36 与 Android 17 真机环境」的前置条件解除。

本文只做**适配前调查**：归集官方行为变更、对现有实现做静态审计、列出需要真机实测的项目与下一步。**不提升 target，不改动任何代码。**

## 调查基线

- 当前正式基线 `v2.1.6`，`targetSdkVersion=36`、`minSdkVersion=23`。
- 本机 SDK 已安装 `android-37.2` 平台。该平台 `build.prop` 为 `ro.build.version.sdk=37`、`sdk_full=37.2`、`release=17`。**平台目录名带次版本号**，`compileSdk` 与 `targetSdk` 是否要写成 `37.2` 需单独确认，不能照抄目录名。
- 静态审计基于本次生成的原始 APK 干净解码树 `work/a17-audit/decoded/`（`apktool d -f`，3264 个 smali 文件，无任何补丁）。
- **结论边界**：以下判定全部来自静态审计，没有在 API 37 设备上运行过。标注「需实测」的项目必须真机确认后才能写进验收记录。

## 一、官方行为变更归集

来源：

- [行为变更：以 Android 17 或更高版本为目标的应用](https://developer.android.com/about/versions/17/behavior-changes-17)
- [行为变更：所有应用](https://developer.android.com/about/versions/17/behavior-changes-all)

### 1.1 仅影响 target 37 及以上的应用

| 变更 | 一句话说明 | 本项目判定 |
| --- | --- | --- |
| `MessageQueue` 无锁实现 | 反射访问 `MessageQueue` 私有字段和方法的代码会被破坏 | 不涉及。全树只用公开的 `MessageQueue.addIdleHandler()` |
| `static final` 字段不可修改 | 反射改 `static final` 抛 `IllegalAccessException`，JNI 改会导致崩溃 | 未发现同类用法，见 2.4 |
| CJKV IME 无障碍支持 | 新增 `TextAttribute.Builder.setTextSuggestionSelected()` 与 `AccessibilityEvent.setTextChangeTypes()` | 可选增强，不构成阻断，见 3.1 |
| ECH 默认启用 | TLS 连接默认启用加密客户端问候 | 不涉及。应用无自有 TLS 连接 |
| `ACCESS_LOCAL_NETWORK` | 局域网访问需要新的运行时权限 | 不涉及。全树无套接字使用 |
| 物理设备隐藏密码 | `show_passwords_physical` 对外接键盘生效 | 不涉及。没有密码输入框 |
| 标准短信 OTP 保护 | 短信验证码延迟 3 小时 | 不涉及。不读短信 |
| Activity 安全性加固 | 后台 Activity 启动限制扩展到 `IntentSender`，需从 `MODE_BACKGROUND_ACTIVITY_START_ALLOWED` 迁移 | 低风险。`IntentSender` 只出现在 GMS 的 `GoogleApiActivity`，Google 账户同步已移除，该路径不可达 |
| 证书透明度默认启用 | TLS 默认要求证书透明度 | 不涉及。同 ECH |
| 更安全的原生动态代码加载 | `System.load()` 加载的原生文件必须只读，否则抛 `UnsatisfiedLinkError` | **需处理**，见 2.1 |
| CP2 限制 PII 字段 | `ContactsContract.Data` 数据视图移除 `ACCOUNT_NAME`、`ACCOUNT_TYPE`、`ACCOUNT_TYPE_AND_DATA_SET` | 不涉及。见 2.5 |
| CP2 严格 SQL 检查 | 无 `READ_CONTACTS` 时查 `Data` 会拒绝不兼容查询 | 不涉及。已声明 `READ_CONTACTS`，且不查 `Data` |
| 后台音频强化 | 后台调用音频 API 静默失败，target 37 要求更严 | **需实测**，见 2.2 |
| 大屏忽略方向限制 | sw ≥ 600 dp 上忽略方向、可调整大小与宽高比限制，退出选项取消 | 不涉及。清单里没有任何 `screenOrientation` |
| RFCOMM `read()` 返回 -1 | 蓝牙套接字读到流末尾返回 `-1` 而不是抛异常 | 不涉及。无蓝牙 |

### 1.2 影响所有运行在 Android 17 上的应用

| 变更 | 一句话说明 | 本项目判定 |
| --- | --- | --- |
| 应用内存限制 | 按设备总 RAM 施加内存上限，超限退出原因记 `REASON_OTHER` 并带 `MemoryLimiter:AnonSwap` | **需实测**，见 2.3 |
| 动态短信密码保护 | WebOTP 格式短信延迟 3 小时 | 不涉及 |
| `usesClearTraffic` 弃用计划 | 未来版本弃用该清单属性 | 不涉及。清单已是 `usesCleartextTraffic="false"` |
| 限制隐式 URI 授权 | Android 18 起不再自动授予 `ACTION_SEND` 等 intent 的 URI 权限 | 不涉及。没有此类 intent |
| 每个应用的密钥库限制 | 单应用密钥数量上限 | 不涉及。不使用 Keystore |
| 阻止跨资料环回流量 | 跨资料回环流量默认被阻断 | 不涉及。没有回环连接 |
| 旋转后恢复默认 IME 可见性 | 应用未处理配置变更时，系统不再恢复 IME 可见性 | **需确认**，见 2.6 |
| 触控板指针捕获 | 指针捕获期间触控板默认传递相对事件 | 不涉及。没有 `requestPointerCapture` |
| 后台音频安全加固 | 同 1.1 对应项 | 同 1.1 |
| 蓝牙自主重新配对 | 配对上下文与 intent 时机变化 | 不涉及 |

## 二、静态审计

### 2.1 `System.load()` 与 DCL-C：唯一明确需要改动的点

原始 APK 的原生库加载器（混淆名 `amd`）是一条三级回退链：

1. `System.loadLibrary(name)`。
2. 失败后尝试 `System.load(<filesDir>/temp_lib_<versionCode>/lib<name>.so)`，读上一次留下的解压产物。
3. 再失败则清掉旧的 `temp_lib_*` 目录，从 `ApplicationInfo.sourceDir` 的 `lib/<CPU_ABI>/lib<name>.so` 用 `ZipFile` 解压到该目录，再 `System.load(<path>)`。

第三步写出的文件由 `FileOutputStream` 直接创建，属主可写。Android 17 要求 target 37 应用经 `System.load()` 加载的原生文件必须是只读，否则抛 `UnsatisfiedLinkError`。

关键判断：**正常路径下 `loadLibrary` 就会成功**。本项目刻意设置 `packaging.jniLibs.useLegacyPackaging = true`，安装时由包管理器解压 `.so`，因此第一级就命中，回退链不会走到第三步。这是**潜在**风险而非当前故障，只有回退被触发时才暴露。

调用方共 10 处，覆盖拼音引擎、英文引擎、HMM 手写与手势、delight4 等模块。

处置方向有两个：给解压产物补 `setReadOnly()`，或者删掉这条回退。倾向后者，但需要先确认没有设备真的会走到它。

### 2.2 按键音

按键音走 `AudioManager.playSoundEffect(int, float)`，调用点在按键音效模块与音量预览控件。键盘可见时进程处于有效生命周期，预期不受后台音频限制影响。**需真机确认按键音与音量预览音仍然发声。**

### 2.3 内存

没有实测数据。输入法进程常驻，运行期加载 5 个原生库与中英文词典、联系人词典。需要采集空载与长时间输入后的 PSS，并检查 `ApplicationExitInfo` 是否出现 `MemoryLimiter:AnonSwap`。

### 2.4 已排除的模式

以下检查全部在干净解码树上做过，结论为「未发现」：

- 无 `sun.misc.Unsafe` 引用，排除基于 Unsafe 的字段写入。
- 无 `Socket`、`ServerSocket`、`InetAddress` 引用，排除局域网与回环。
- `MessageQueue` 只调用公开的 `addIdleHandler`，没有私有字段反射。
- 所有 `java.lang.reflect.Field->set` 调用点都落在**实例字段**：旧 MultiDex 安装器写 `BaseDexClassLoader` 的 `mPaths` / `mFiles`，Guava `Finalizer` 写自己的私有字段，另有反射助手只做 `get`。没有针对平台静态类的反射。
- 清单里没有 `screenOrientation`、没有 `windowSoftInputMode`。
- 没有密码输入框，没有 `ACTION_SEND` / `ACTION_IMAGE_CAPTURE`。
- 权限清单里没有局域网、蓝牙、短信相关项。

### 2.5 联系人查询

联系人词典的投影是 `display_name`、`starred`、`times_contacted`、`last_time_contacted`、`in_visible_group`，查询目标是 `ContactsContract.Contacts.CONTENT_URI`，不是 `ContactsContract.Data`。

因此 CP2 的两项变更都不适用：投影里没有 PII 列，走的也不是 `Data` 表，且应用已经声明 `READ_CONTACTS`。

### 2.6 旋转后恢复 IME 可见性

清单里没有 `windowSoftInputMode`。该变更只影响「应用自己没处理配置变更、又依赖系统恢复键盘」的场景。需要确认设置页是否存在依赖系统恢复软键盘的输入框，如果没有就不适用。

## 三、需要真机实测的项目

### 3.1 CJKV IME 无障碍支持（可选增强）

Android 17 为中日韩越输入法新增了两个 API：输入法在设置合成文本时可用 `TextAttribute.Builder.setTextSuggestionSelected()` 说明是否已选中转换候选，无障碍服务再通过 `AccessibilityEvent.getTextChangeTypes()` 读取。目标 37 且使用标准 `TextView` 的应用默认启用。

这对屏幕阅读器朗读候选选择有帮助，但属于**新增能力**而不是兼容性修复。按项目约定，这类改动要满足「默认关闭、关闭时逐入口交回原实现、不新增键盘布局、不改既有按键与候选语义、静态门禁锁定回退入口、真机验收确认原有行为不变」，并且用独立分支。本轮只登记，不实施。

### 3.2 真机基线待采集

设备当前未连接，以下基线全部待补：

- API 级别、build 号、页大小（`getconf PAGESIZE`）。
- 导航模式与键盘几何。
- 默认输入法与正式包版本。
- 按键音、内存、`ApplicationExitInfo`。

## 四、下一步

1. 恢复设备连接，采集 API 37 基线。
2. 确认 `compileSdk` 与 `targetSdk` 在 `android-37.2` 次版本号下的写法。
3. 从 `master` 创建 `feat/target-sdk-37`，先做**纯 target 提升**，不预置猜测性补丁，观察 DCL-C 回退链是否真的触发。
4. 新增 `scripts/verify_target37.py`，固定 target 37、只读原生库加载、以及 1.1 中已判定「不涉及」的清单项。
5. 按 target 29–36 的既有完成条件走构建、静态门禁、真机 ART 与功能回归。

## 相关文档

- [target SDK 分阶段现代化计划](target-sdk-modernization-plan.md)
- [兼容性说明](compatibility-notes.md)
