# target SDK 分阶段现代化计划

## 目标

Google 拼音输入法 4.5.2 的原始 `targetSdkVersion` 为 26，当前正式版 `v1.0.3` 已提升到 28。后续目标是在不改变原生输入行为、候选逻辑、词典格式、学习权重、手写识别、主题和触摸路由的前提下，逐代处理 Android 的目标版本行为变更，最终稳定面向 Android 16（API 36），并为 Android 17（API 37）保留独立调查阶段。

Google Play 当前要求新应用和更新面向 Android 16（API 36）或更高版本，但本项目不以赶进度为目标。每一级 target 必须完成构建、静态检查、真机 ART 启动和相关功能回归后，才进入下一级：

- [Google Play target API requirements](https://developer.android.com/google/play/requirements/target-sdk)
- [Android 10 / API 29 target changes](https://developer.android.com/about/versions/10/behavior-changes-10)
- [Android 11 / API 30 target changes](https://developer.android.com/about/versions/11/behavior-changes-11)
- [Android 12 / API 31 target changes](https://developer.android.com/about/versions/12/behavior-changes-12)
- [Android 13 / API 33 target changes](https://developer.android.com/about/versions/13/behavior-changes-13)
- [Android 14 / API 34 target changes](https://developer.android.com/about/versions/14/behavior-changes-14)
- [Android 15 / API 35 target changes](https://developer.android.com/about/versions/15/behavior-changes-15)
- [Android 16 / API 36 target changes](https://developer.android.com/about/versions/16/behavior-changes-16)
- [Android 17 / API 37 target changes](https://developer.android.com/about/versions/17/behavior-changes-17)

## 分支和审计包规则

每个 target 使用一个长期保留的独立分支。后一级从已经验收的前一级分支创建，使修复按 API 顺序累积，同时保留每个行为边界的准确历史：

```text
master / v1.0.3（target 28）
  └─ feat/target-sdk-29
       └─ feat/target-sdk-30
            └─ feat/audit-debug-mode（不提升 target）
                 └─ feat/target-sdk-31
                 └─ feat/target-sdk-32
                      └─ feat/target-sdk-33
                           └─ feat/target-sdk-34
                                └─ feat/target-sdk-35
                                     └─ feat/target-sdk-36
                                          └─ feat/target-sdk-37
```

规则：

1. 前一级没有完成前，不创建后一级实现分支。
2. 每个分支记录该 API 新触发的问题、修复、构建和真机结论。
3. 已完成分支推送到远端后长期保留，不因创建后继分支而删除。
4. 中间审计版本不自动发布 GitHub Release；只产生 Actions artifact。
5. 风险测试使用独立 application ID，不覆盖正式包，也不接触正式包的用户词典：
   - API 29：`com.google.android.inputmethod.pinyin.target29audit`
   - 后续依次使用 `target30audit`、`target31audit` 等。
6. 所有非正式 application ID 的审计包统一显示为 `Google 拼音输入法（测试版）`，便于在 Launcher、应用列表和输入法选择器中与正式版区分；正式包显示名称不变。
7. 正式包仍保持 `com.google.android.inputmethod.pinyin.compat` 和现有签名身份。
8. 达到选定的正式里程碑前不合并 `master`；当前预期正式里程碑为 target 36。
9. 如果某一级发现与 target 无关、且正式版也需要的严重修复，单独建修复分支处理，再同步到 target 分支链，避免混淆归因。
10. 默认审计包保持非 debuggable，作为 target 验收依据；可选 debug 变体只用于诊断，禁止使用正式 application ID，详见 [`audit-debug-mode.md`](audit-debug-mode.md)。

## 每一级的共同完成条件

- apktool 从固定原始 APK 可复现重建；
- D8/smali 汇编、zipalign 和 v1/v2/v3 签名验证通过；
- application ID、versionName、versionCode、target SDK 和证书指纹符合预期；
- 真机 ART 可加载 IME，不出现 `VerifyError`、隐藏 API 拒绝或 native loader 崩溃；
- 安装、启用、选择输入法和打开设置正常；
- 相关 target 行为边界完成专项测试；
- 拼音、英文、手写、候选、符号/Emoji、剪贴板和主题至少完成基础回归；
- SAF 本地/Google Drive 备份和内置导入在涉及存储变化的阶段完成回归；
- 审计日志不出现新的高频异常；
- 分支文档记录结果并提交、推送；
- 维护者明确确认后才进入下一级。

功能、视觉和破坏性词典测试仍由维护者执行；编码代理负责补丁、构建、签名、安装、哈希和日志检查。

## 阶段计划

### target 29 / Android 10

分支：`feat/target-sdk-29`

状态：**已完成并验收**。

V1 只把 target 28 提升到 29，不预先加入猜测性兼容补丁。重点观察：

- 非 SDK/隐藏 API 限制；
- scoped storage 的第一阶段行为；
- 旧 Android Support/AppCompat 反射；
- native library 加载；
- 自定义主题图片的 `ACTION_GET_CONTENT` URI；
- IME 服务、设置和首次使用入口。

如发生故障，只在 target 29 分支修复并重新审计。

V1 构建记录：

- commit：`aeb8485e701becb15b4b76c6619fd783be674d97`
- workflow：[`30779142212`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30779142212)
- artifact ID：`8843056409`
- artifact：`ComebackGooglePinyinInput-target-sdk-29-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target29audit`
- versionName / versionCode：`1.0.3` / `4520384`
- target SDK：`29`
- APK SHA-256：`ca60e1a12cd62bf61f304e9c449407d4ee760707c530c5c6675e9556ebad1835`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- 旧 Google 账户同步权限和组件：保持移除
- GitHub Release：未发布（workflow tag 步骤按预期跳过）

真机验收记录（Pixel 10 Pro / Android 16）：

- 维护者完成首次引导、核心输入、候选、手写、剪贴板、主题、联系人和 SAF 备份测试，未发现回归；
- `guide_complete=true`，首次引导完成状态正确；
- IME 进程保持存活，系统已注册并可正常作为当前输入法运行；
- DropBox 中没有该包的 `data_app_crash` 或 `data_app_anr`；
- 进程日志没有 `VerifyError`、`FATAL EXCEPTION`、隐藏 API 拒绝或 native loader 错误；
- ART Dexopt 状态为 `verify` 且 oat 最新，没有类验证失败；
- 联系人权限成功授予，中文/英文联系人词典文件均正常生成；
- 自定义主题包正常生成并落盘；
- 中英文用户词典文件正常创建和保存；
- `READ_EXTERNAL_STORAGE`、`WRITE_EXTERNAL_STORAGE` 和 `LEGACY_STORAGE` 均为 `ignore`，但 SAF 仍在独立目录成功发布备份；
- 备份状态为“备份成功”，连续失败数为 0，并记录正式文档 URI 和 SHA-256；
- 未发现 target 29 新触发的功能、存储、ART 或 UI 问题。

结论：target 29 行为边界通过，可以从该分支创建 `feat/target-sdk-30`。以后审计包统一使用“测试版”显示名称，不需要为 target 29 重做功能测试。

### target 30 / Android 11

分支：`feat/target-sdk-30`

状态：**已完成并验收**。

V1 继续采用纯 target 边界策略：在已验收的 target 29 基础上只提升到 target 30，不预先加入 scoped storage、Toast 或 package visibility 猜测性补丁。

V1 构建记录：

- commit：`c10a53f07332c5c4a227014b02e2fd8761437c40`
- workflow：[`30781021822`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30781021822)
- artifact ID：`8843639468`
- artifact：`ComebackGooglePinyinInput-target-sdk-30-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target30audit`
- 显示名称：`Google 拼音输入法（测试版）`
- versionName / versionCode：`1.0.3` / `4520384`
- min / target SDK：`17` / `30`
- APK SHA-256：`08ce40d4d94d80607b953c540de7ddc091f3251742e6ec96848ad55fd1343d93`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- 设备安装后的 `base.apk` 哈希与 artifact 完全一致；
- 安装过程未启用或切换 target 30 IME，当前输入法仍是 target 29 审计包；
- GitHub Release：未发布。

真机验收记录（Pixel 10 Pro / Android 16）：

- 维护者完成首次引导、核心输入、手写、候选、剪贴板、主题、联系人、SAF 和 Google Drive 测试，未发现回归；
- 当前默认 IME 正确切换到 target 30，进程持续存活；
- DropBox 中没有该包的 `data_app_crash` 或 `data_app_anr`；
- 进程和系统日志没有属于该包的 `FATAL EXCEPTION`、`VerifyError`、隐藏 API 拒绝、`SecurityException` 或 native loader 错误；日志中的隐藏 API 拒绝来自 QQ，与本审计包无关；
- ART Dexopt 状态为 `verify` 且 oat 最新；
- `guide_complete=true`，首次引导状态正确；
- 联系人权限为 `allow`，中英文联系人词典正常生成，记录联系人 78 个；
- 自定义主题包正常生成并落盘；
- `READ_EXTERNAL_STORAGE`、`WRITE_EXTERNAL_STORAGE` 和 `LEGACY_STORAGE` 均为 `ignore`，没有发现传统存储权限依赖；
- Google Drive SAF 自动备份状态为“备份成功”，连续失败数为 0，并记录文档 URI 和 SHA-256；
- 手写/手势 native 库 `libhmm_gesture_hwr_zh.so` 已在运行进程中实际加载；
- 没有发现 `.partial`、`.unreadable` 或其他异常残留；
- target 29 旧审计包已卸载，当前只保留 target 30 审计包。

结论：target 30 行为边界通过。按维护者要求，暂不创建 target 31；先在独立分支引入可选调试构建和诊断采集能力，且不得让调试属性进入正式包或替代 release-like 验收。

重点：

- scoped storage 强制执行；
- 移除失效的 `WRITE_EXTERNAL_STORAGE` 依赖；
- package visibility；
- Toast 行为；
- SAF、Google Drive、VIEW/SEND 导入和主题图片。

### target 31 / Android 12

分支：`feat/target-sdk-31`

状态：**已完成并验收**。

V1 在已验收的 target 30 和基础 Debug 构建能力之上提升到 target 31，并只处理 Android 12 的已知硬边界：

- 七个 `PendingIntent` 创建点均保留原 `CANCEL_CURRENT`/`UPDATE_CURRENT` 语义并增加 `FLAG_IMMUTABLE`；这些 token 不使用 RemoteInput、bubble、fill-in 或位置回调，没有可变需求；
- Firebase IID 组件虽已从 Manifest 移除，其遗留不可达创建点仍补齐 immutable，避免未来代码路径恢复时失败；
- 五个带 intent-filter 的现存组件全部显式声明 `android:exported`；
- 新增 `scripts/verify_target31.py`，Actions 必须验证全部 intent-filter 组件和全部七个 PendingIntent 创建点；
- 默认构建保持非 debuggable；只有普通日志无法解释问题时才构建 debug 变体。

V1 构建记录：

- commit：`126632cfe70403f8c0b4e7f53f9da95e5134e39d`
- workflow：[`30785523255`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30785523255)
- artifact ID：`8845124346`
- artifact：`ComebackGooglePinyinInput-target-sdk-31-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target31audit`
- 显示名称：`Google 拼音输入法（测试版）`
- versionName / versionCode：`1.0.3` / `4520384`
- min / target SDK：`17` / `31`
- Debuggable：否（release-like）
- APK SHA-256：`1efd851ccf9b2a5dacc237a7ea1915bab6c43d024caed4ea742a57c5e7b76127`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- Actions 和最终 APK 复检：5 个 intent-filter 组件均显式 exported，7 个 PendingIntent 均显式 immutable；
- 设备安装后的 `base.apk` 哈希与 artifact 完全一致；
- 安装后未启动、启用或选择 target 31 IME，保留全新首次引导状态；
- 按维护者要求已卸载 target 30 旧测试包，系统当前临时回退到 LatinIME；
- GitHub Release：未发布。

真机验收记录（Pixel 10 Pro / Android 16）：

- 维护者完成首次引导、核心输入、手写、候选、剪贴板、主题、联系人、词典学习和 Google Drive SAF 备份测试，未发现回归；
- `guide_complete=true`，target 31 IME 已启用并曾正常运行；检查时用户已手动切回 LatinIME，不属于异常回退；
- DropBox 中没有 Java crash、ANR、native crash 或 tombstone，ApplicationExitInfo 和 events buffer 也没有该包异常退出记录；
- 日志中没有 `Targeting S+ requires FLAG_IMMUTABLE or FLAG_MUTABLE`、`VerifyError`、`SecurityException`、隐藏 API 拒绝或 native loader 错误；
- ART Dexopt 状态为 `verify` 且 oat 最新；
- 中英文用户词典及各自 `_bak` 均正常生成，主文件已产生新的学习数据；
- 中英文联系人词典、快捷词典和自定义主题包正常生成；
- Google Drive SAF 自动备份状态为“备份成功”，连续失败数为 0，并记录文档 URI 和 SHA-256；
- 传统外部存储 AppOps 仍为 `ignore`，联系人为 `allow`；
- `liben_data_bundle.so`、`libpinyin_data_bundle.so` 和 `libhmm_gesture_hwr_zh.so` 在运行进程中实际加载；
- 没有 `.partial`、`_tmp` 或 `_unreadable` 异常残留；
- 安装后的 `base.apk` SHA-256 再次确认与 Actions artifact 一致。

结论：target 31 的 PendingIntent mutability、component exported 和核心行为边界通过，可以在维护者确认后创建 target 32。

专项复核 BackupAgent、设备迁移和首次使用状态，不提前加入 API 34 receiver、API 35 edge-to-edge 或 API 36 Back 改动。

### target 32 / Android 12L

分支：`feat/target-sdk-32`

状态：**已完成并验收**。

没有已知独立硬阻塞。V1 从已验收的 target 31 分支创建，只把 target 提升到 32，保留已经通过的 PendingIntent、exported 和基础 Debug 构建能力，不加入 API 33+ 猜测性补丁。

重点检查：

- Android 12L 下 IME 服务、设置和首次引导启动；
- 大屏/折叠屏兼容行为是否意外影响普通手机布局；
- InputConnection、窗口 Insets、候选栏和主题 Activity；
- ART、native loader、词典、联系人和 SAF；
- 默认仍使用 release-like 非 Debug 包。

V1 构建记录：

- commit：`1e303f8c2f39c6764c0551eff6ab5e7139949835`
- workflow：[`30787151326`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30787151326)
- artifact ID：`8845645932`
- artifact：`ComebackGooglePinyinInput-target-sdk-32-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target32audit`
- 显示名称：`Google 拼音输入法（测试版）`
- versionName / versionCode：`1.0.3` / `4520384`
- min / target SDK：`17` / `32`
- Debuggable：否（release-like）
- APK SHA-256：`02faeb7033c0182487a42b3203efd18f93049a8b7ed017814e34f9d71d63ca13`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- Android 12 静态门禁：5 个 intent-filter 组件和 7 个 immutable PendingIntent 通过；
- 设备安装后的 `base.apk` 哈希与 artifact 完全一致；
- 安装后未启动、启用或选择 target 32 IME，首次引导保持全新；
- target 31 旧测试包已卸载，系统默认 IME 保持 LatinIME；
- GitHub Release：未发布。

真机验收记录（Pixel 10 Pro / Android 16）：

- 维护者完成首次引导、核心输入、手写、候选、剪贴板、主题、自定义背景、联系人、词典学习和 SAF 本地备份测试，未发现回归；
- Target 32 IME 已启用并作为当前默认输入法正常运行，进程持续存活；
- `guide_complete=true`，首次引导状态正确；
- DropBox 中没有 Java crash、ANR、native crash 或 tombstone，ApplicationExitInfo 也没有异常退出；
- 日志没有 `VerifyError`、`SecurityException`、隐藏 API 拒绝、PendingIntent mutability 或 native loader 错误；
- ART Dexopt 状态为 `verify` 且 oat 最新；
- 中英文用户词典及 `_bak`、中英文联系人词典、快捷词典和自定义主题包均正常生成；
- SAF 内部存储备份状态为“备份成功”，连续失败数为 0，并记录 document URI 和 SHA-256；
- 传统外部存储 AppOps 仍为 `ignore`，联系人权限为 `allow`；
- 手写 native 识别实际运行，日志记录 1–3 笔请求和完成耗时，`libhmm_gesture_hwr_zh.so` 已加载；
- 没有 `.partial`、`_tmp` 或 `_unreadable` 异常残留；
- 主题预览曾先尝试读取尚未生成的 `keyboardsnapshotcache_*.png`，随后同一流程成功生成对应缓存和主题包；这是原版的惰性缓存 miss 日志，没有造成 UI 或文件异常；
- RenderScript 在无 HIDL 服务时按设计使用 fallback path；少量资源 finalizer 警告没有持续重复、崩溃或可见问题；
- 安装后的 `base.apk` SHA-256 再次确认与 Actions artifact 一致。

结论：target 32 / Android 12L 行为边界通过，可以在维护者确认后创建 target 33。

### target 33 / Android 13

分支：`feat/target-sdk-33`

状态：**已完成并验收**。

V1 从已验收的 target 32 创建，只提升到 Android 13 / API 33，不加入无用途权限或后续 API 补丁。

重点：

- 不声明、不请求无用途的 `POST_NOTIFICATIONS`；本项目没有需要通知权限的用户功能；
- 不声明、不请求无用途的 `READ_MEDIA_*`，主题图片继续使用系统文件/照片选择器 URI；
- 复核 `RECEIVE_BOOT_COMPLETED`、联系人权限、WebView 和文件选择器行为；
- 复核剪贴板候选在 Android 13 隐私提示下仍只读取当前主剪贴项目，且不自行显示额外系统式提示；
- 默认使用 release-like 非 Debug 包；
- 不提前混入 API 34 动态 receiver、API 35 edge-to-edge 或 API 36 Back 改动。

V1 构建记录：

- commit：`7b7338f861867b0fe0c7c54045ec95482ad09481`
- workflow：[`30789350108`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30789350108)
- artifact ID：`8846454792`
- artifact：`ComebackGooglePinyinInput-target-sdk-33-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target33audit`
- 显示名称：`Google 拼音输入法（测试版）`
- versionName / versionCode：`1.0.3` / `4520384`
- min / target SDK：`17` / `33`
- Debuggable：否（release-like）
- APK SHA-256：`289e2bf7c77a0e1dda63f13d1e09926a54de1788377366e603f20063890210ae`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- Android 12 静态门禁：5 个 intent-filter 组件和 7 个 immutable PendingIntent 通过；
- Android 13 权限门禁：无 `POST_NOTIFICATIONS` 或 `READ_MEDIA_*` 声明/请求；
- 设备安装后的 `base.apk` 哈希与 artifact 完全一致；
- 安装后未启动、启用或选择 target 33 IME，首次引导保持全新；
- target 32 旧测试包已卸载，系统默认 IME 临时回退到 LatinIME；
- GitHub Release：未发布。

真机验收记录（Pixel 10 Pro / Android 16）：

- 维护者完成首次引导和视觉/功能回归，未发现用户可见异常；`guide_complete=true`，当前默认且已启用的 IME 为 target 33，进程持续存活；
- 首次引导及后续使用未请求 `POST_NOTIFICATIONS` 或任何 `READ_MEDIA_*` 权限；主题图片继续通过系统选择器 URI 工作，私有目录中已正常生成自定义主题包；
- 中英文输入、九键、候选与分页、英文、符号/Emoji、手写、剪贴板候选与关闭、主题、联系人词典、用户词典和返回/Insets 行为未发现 target 33 回归；
- Google Drive SAF 自动备份状态为“备份成功”，连续失败数为 0，持久目录授权、document URI 和备份 SHA-256 均已记录；
- 中英文用户词典、联系人词典、快捷词典和主题文件均正常存在，没有 `.partial`、`_tmp` 或 `_unreadable` 异常残留；
- DropBox 中没有 Java crash、ANR、native crash 或 tombstone，ApplicationExitInfo 没有该包异常退出记录；
- ART Dexopt 状态为 `verify` 且 oat 最新；运行进程实际加载了拼音、英文和 `libhmm_gesture_hwr_zh.so` 原生库；
- 运行日志未发现 `VerifyError`、`SecurityException`、`UnsatisfiedLinkError`、权限拒绝或隐藏 API 故障；IME/Insets/Back 日志符合正常窗口切换；
- `keyboardsnapshotcache_*.png` 在惰性缓存生成前的 `ENOENT` 与 target 32 已分类的原版缓存 miss 一致，没有崩溃或可见影响；
- 安装后的 `base.apk` SHA-256 再次确认与 Actions artifact 完全一致。

结论：target 33 / Android 13 行为边界通过，可以从该验收里程碑创建 target 34；无需构建 Debug 变体，也不发布 GitHub Release。

### target 34 / Android 14

分支：`feat/target-sdk-34`

状态：**已完成并验收**。

V1 从已验收的 target 33 创建，只提升到 Android 14 / API 34，并处理该级已经确认的动态 receiver 硬边界：

- `com.google.gservices.intent.action.GSERVICES_CHANGED` 来自其他 Google 包；为保持原有 GServices 缓存失效语义，在 API 33+ 使用 `Context.RECEIVER_EXPORTED`，API 17–32 继续使用旧两参数重载；
- 其他动态 receiver 只监听电源、电池、解锁、软件包、屏幕、网络、语言区域及时区等系统广播，保留 Android 的 system-broadcast 例外语义，不扩大导出面；
- 新增 `scripts/verify_target34.py`，固定全部动态 receiver 站点、GServices API 分支与 exported flag，并拒绝新引入的 `DexClassLoader` 路径；
- 原包唯一的 `DexFile.loadDex()` 位于旧 multidex 安装器，只用于 Android 5.0 以前设备，不是 Android 14 动态代码路径；
- 继续检查隐式 Intent 对未导出组件的限制，但不预先修改已通过的系统设置、SAF、WebView 或主题选择器 Intent；
- 保留 Android 12 exported/PendingIntent 和 Android 13 无通知/媒体权限静态门禁；
- 不提前混入 API 35 edge-to-edge/TextView 或 API 36 Back 改动。

V1 构建记录：

- implementation commit：`fda7ef2`
- redecoded-artifact verifier fix：`82a8a78`
- workflow：[`30791953489`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30791953489)
- artifact ID：`8847387026`
- artifact：`ComebackGooglePinyinInput-target-sdk-34-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target34audit`
- 显示名称：`Google 拼音输入法（测试版）`
- versionName / versionCode：`1.0.3` / `4520384`
- min / target SDK：`17` / `34`
- Debuggable：否（release-like）
- APK SHA-256：`3a69ad0f48989897088eadaf3d838f0d7c8fb2148bf6ef52da15d69094ae6abd`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- Android 12 exported/PendingIntent、Android 13 权限和 Android 14 receiver/动态代码门禁均通过；
- Actions 仅生成 artifact，tag Release 步骤按预期跳过，未发布 GitHub Release；
- 设备安装后的 `base.apk` SHA-256 与 artifact 完全一致；
- 安装后未启动、启用或选择 target 34 IME，首次引导保持全新；
- target 33 旧测试包已卸载，系统默认 IME 临时回退到 LatinIME。

真机验收记录（Pixel 10 Pro / Android 16）：

- 维护者完成首次引导和视觉/功能回归，未发现用户可见异常；`guide_complete=true`，当前默认且已启用的 IME 为 target 34，进程持续存活；
- 全键盘、九键、英文、候选与分页、符号/Emoji、剪贴板候选、主题、设置及 Back/Insets 行为未发现 target 34 回归；
- 中文手写实际执行 1–3 笔 native 识别并正常完成，`libhmm_gesture_hwr_zh.so` 与中英文数据库均已加载；
- 联系人权限为 `allow`，中英文联系人词典、用户词典、快捷词典和自定义主题包均正常生成；传统外部存储与无用途的通知/媒体 AppOps 保持 `ignore`；
- Google Drive SAF 自动备份状态为“备份成功”，连续失败数为 0，持久目录授权、document URI 和备份 SHA-256 均已记录；
- 没有 `.partial`、`_tmp` 或 `_unreadable` 异常残留；
- DropBox 中没有 Java crash、ANR、native crash 或 tombstone，ApplicationExitInfo 没有该包异常退出记录；
- ART Dexopt 状态为 `verify` 且 oat 最新；没有运行时 `DexClassLoader`/`DexFile` 故障；
- 运行日志没有动态 receiver `SecurityException`、`VerifyError`、`UnsatisfiedLinkError`、权限拒绝或隐藏 API 故障；活动 receiver 表中 target 34 当前注册项均为系统广播，已移除的统计网络路径没有注册 GServices receiver；
- `keyboardsnapshotcache_*.png` 惰性 miss、RenderScript fallback、少量资源 finalizer 警告和 `SHOW_MORE_APPS` 无效键码均为此前已分类的原版遗留日志，没有崩溃或可见影响；
- 安装后的 `base.apk` SHA-256 再次确认与 Actions artifact 完全一致；采集时 170 个 FD、48 个线程，没有资源失控迹象。

结论：target 34 / Android 14 行为边界通过。默认 release-like 包已提供充分证据，无需构建 Debug 变体；可以从该验收里程碑创建 target 35，但 target 35 是 edge-to-edge、TextView 测量和旧设置 UI 的独立视觉边界。

### target 35 / Android 15

状态：等待。

这是独立视觉边界，重点：

- Activity edge-to-edge；
- Settings、First Run、Theme 和备份导入 Activity 的 WindowInsets；
- `TextView` 新宽度测量对候选宽度和分页的影响；
- 字体行高、键盘尺寸、导航区和候选栏截图对比；
- 按键音和振动。

允许用临时 edge-to-edge opt-out 做故障隔离，但不能把它作为 target 36 的最终实现。

### target 36 / Android 16

状态：等待。

目标正式里程碑。重点：

- edge-to-edge opt-out 在 Android 16 上失效，必须完成真正的 Insets 适配；
- predictive back 默认启用，旧 `onBackPressed()` 不再自动调用；
- 首次使用、设置、主题和其他 Activity 的返回语义；
- 大屏自适应行为；
- 固定频率任务恢复行为；
- 完整核心功能和正式包升级哈希验证。

首次 target 36 可显式保留 legacy Back callback，以冻结已验收的 first-run 语义；预测返回迁移应单独审计。

### target 37 / Android 17

状态：前瞻调查，等待 target 36 和 Android 17 真机环境。

重点：

- CJKV IME 新 `TextAttribute`/AccessibilityEvent 辅助功能；
- static final 反射限制；
- `System.load()` 动态 native 文件必须只读；
- LAN 访问的新运行时权限（当前 SAF 云备份不需要）；
- 后台音频限制；
- ContactsProvider 行为；
- 16 KiB page-size native library。

## Native 16 KiB 独立风险

当前 ELF 静态检查结果：

| 文件 | `PT_LOAD` alignment |
|---|---:|
| `liben_data_bundle.so` | `0x10000` |
| `libgnustl_shared.so` | `0x10000` |
| `libhmm_gesture_hwr_zh.so` | `0x1000` |
| `libhwrword.so` | `0x10000` |
| `libpinyin_data_bundle.so` | `0x10000` |

只有 `libhmm_gesture_hwr_zh.so` 仍是 4 KiB 对齐。它承载手势和中文手写能力，不能通过删除规避。这个问题不等同于 target SDK，但必须在合适硬件上独立验证和解决。

## 当前里程碑

- [x] 正式版 `v1.0.3`：target 28 基线冻结；
- [x] 完成 API 29–37 初步静态调查；
- [x] 建立逐 target 独立分支策略；
- [x] target 29 V1 可复现构建；
- [x] target 29 隔离包安装与 ART 日志检查；
- [x] target 29 功能回归；
- [x] target 29 结论归档；
- [x] 从已验收的 target 29 创建 target 30 分支；
- [x] target 30 V1 可复现构建；
- [x] target 30 隔离包安装与 ART/存储日志检查；
- [x] target 30 功能和 scoped storage 回归；
- [x] 创建 `feat/audit-debug-mode`，不提升 target；
- [x] 加入仅限隔离审计包的可选 debug 构建开关和隐私受限诊断脚本；
- [x] 双模式云构建确认 debug 与 release-like 仅有 Manifest 调试属性和重签名元数据差异；
- [x] 验证默认 release-like 有效载荷与已验收 target 30 V1 完全一致，正式 ID 调试构建会被拒绝；
- [x] 真机覆盖安装 target 30 debug 变体，数据保留、`DEBUGGABLE`、`run-as` 和隐私受限诊断采集均通过；
- [x] 维护者确认保持基础 Debug，不预先增加重型埋点；
- [x] 从已验收的 Debug 基础分支创建 target 31；
- [x] target 31 V1 可复现构建和静态 Android 12 不变量检查；
- [x] target 31 release-like 隔离包安装后的首次引导、ART 和功能回归；
- [x] 从已验收的 target 31 创建 target 32；
- [x] target 32 V1 可复现 release-like 构建和静态检查；
- [x] target 32 隔离包首次引导、ART 和功能回归；
- [x] 从已验收的 target 32 创建 target 33；
- [x] target 33 V1 release-like 构建和权限静态检查；
- [ ] target 33 隔离包首次引导、ART 和功能回归。
