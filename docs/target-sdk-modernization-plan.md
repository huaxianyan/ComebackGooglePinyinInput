# target SDK 分阶段现代化计划

## 目标

Google 拼音输入法 4.5.2 的原始 `targetSdkVersion` 为 26，正式 Release `v1.0.3` 为 target 28。API 29–36 已在不改变原生输入行为、候选逻辑、词典格式、学习权重、手写识别、主题和触摸路由的前提下逐代完成验收，并作为开发版本 `2.0.0` 合并到 `master`。Android 17（API 37）继续保留为独立调查阶段。

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
v1.0.3 历史基线（target 28）
  └─ feat/target-sdk-29
       └─ feat/target-sdk-30
            └─ feat/audit-debug-mode（不提升 target）
                 └─ feat/target-sdk-31
                 └─ feat/target-sdk-32
                      └─ feat/target-sdk-33
                           └─ feat/target-sdk-34
                                └─ feat/target-sdk-35
                                     └─ feat/target-sdk-36（已验收）
                                          └─ master / 2.0.0（target 36）
                                               ├─ Material You / MD3
                                               ├─ 16 KiB native 调查
                                               └─ feat/target-sdk-37（独立后续）
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

分支：`feat/target-sdk-35`

状态：**V3 复测发现导航栏可见性切换导致 inset 归零，V4 稳定 inset 修复已安装，等待复测**。

这是独立视觉边界。V1 从已验收的 target 34 创建，只提升到 Android 15 / API 35，刻意采用不掩盖平台行为的基线：

- 不设置 `windowOptOutEdgeToEdgeEnforcement`，让 Android 15 的 edge-to-edge target 行为真实生效；
- 不预先加入 `setDecorFitsSystemWindows()`、全局 padding 或猜测性的 WindowInsets 补偿；先分别观察 Settings、First Run、Theme 和备份导入 Activity，只有设备证据证明重叠时才做窄修复；
- 保留旧 AppCompat 自带的 `fitsSystemWindows`/insets 逻辑，不因 target 提升而推测性删除；
- 保留已经存在的 API 35 首次引导 day/night 样式和系统栏明暗图标配置；
- 不预先设置 `elegantTextHeight`、`fallbackLineSpacing` 或候选宽度补偿，直接审计 Android 15 `TextView` 变化对原生候选测量、分页、字体行高和截断的实际影响；
- 不新增 `layout-v35` 键盘覆盖，保持候选、分页、手写、符号/Emoji 和触摸几何原样；
- 新增 `scripts/verify_target35.py`，拒绝 edge-to-edge opt-out、推测性 TextView 补偿和 API 35 布局覆盖；
- 重点截图对比状态栏、导航区、键盘高度、候选栏、设置标题栏、主题编辑器、首次引导三页和备份导入页；
- 继续验证按键音、振动、剪贴板候选、手写和 Back，但不提前混入 API 36 predictive Back 改动。

如果 V1 发现重叠，可临时用 edge-to-edge opt-out 做因果隔离，但验收实现必须使用真实 WindowInsets 适配，因为该 opt-out 不能成为 target 36 的最终方案。

V1 构建记录：

- commit：`d528a1f`
- workflow：[`30795970181`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30795970181)
- artifact ID：`8848890150`
- artifact：`ComebackGooglePinyinInput-target-sdk-35-audit-v1`
- application ID：`com.google.android.inputmethod.pinyin.target35audit`
- 显示名称：`Google 拼音输入法（测试版）`
- versionName / versionCode：`1.0.3` / `4520384`
- min / target SDK：`17` / `35`
- Debuggable：否（release-like）
- APK SHA-256：`40a763ea6e46f3dabc097a8e5392473a8622fae0727319d2de5ca846c1141b45`
- zipalign：通过
- APK Signature Scheme：v1/v2/v3 通过
- 签名证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- Android 12、13、14 静态门禁及 Android 15 无掩盖视觉基线门禁均通过；
- `windowOptOutEdgeToEdgeEnforcement`、推测性 Insets/TextView 补偿和 `layout-v35` 键盘覆盖均不存在；
- 设备安装后的 `base.apk` SHA-256 与 artifact 完全一致；
- 安装后未启动、启用或选择 target 35 IME，首次引导保持全新；
- target 34 旧测试包已卸载，系统默认 IME 临时回退到 LatinIME；
- Actions 仅生成 artifact，未发布 GitHub Release。

V1 真机视觉结果：

- 首次引导顶部和设置页顶部未被状态栏遮挡，旧 AppCompat 顶部 inset 路径继续有效；
- 首次引导“上一步/下一步”页脚进入三键导航栏区域，按钮点击困难；
- IME 底部一行进入虚拟导航键区域，按钮无法交互，导致 Emoji、标点和符号入口无法测试；键盘整体体感也比 target 34 偏低；
- 中英文输入、剪贴板、手写、备份和导入未发现其他异常；
- 设置页底部显示纯黑三键导航栏，但内容未报告遮挡。Android 15 对三键导航默认使用约 80% 不透明背景，并在未应用 bottom inset 时让内容绘制到其后；先保留该非阻塞视觉现象，不用全局颜色覆盖掩盖因果。

V2 窄修复：

- 保持 edge-to-edge 强制行为开启，不使用 opt-out；
- 新增 `EdgeToEdgeCompat`，仅在 API 35+ 读取真实 bottom system-window inset；
- 首次引导页脚高度增加 bottom inset、页脚内部增加等量 bottom padding，并同步增加 pager bottom padding，使原 64dp 页脚完整位于导航栏上方；
- IME `InputView` 增加 bottom inset padding，使原生键盘 body 和全部底部按键整体上移，同时让 root 使用既有 `BgKeyboardArea` 绘制导航栏后的区域；
- 不改变键盘 body、候选、分页、Emoji/符号、手写或触摸布局尺寸，不加入 TextView 补偿；
- 设置和主题 Activity 暂不增加全局 padding，因为顶部正常且尚无底部控件被遮挡的证据。

V2 构建记录：

- commit：`a64b96a`
- workflow：[`30798882944`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30798882944)
- artifact ID：`8850012125`
- artifact：`ComebackGooglePinyinInput-target-sdk-35-audit-v2`
- application ID：`com.google.android.inputmethod.pinyin.target35audit`
- Debuggable：否（release-like）
- APK SHA-256：`c89fee4ebdee2f950f48d2bf4ff1c8a53079983bba147e983def6b4d4d0eb80d`
- zipalign、v1/v2/v3 签名、签名证书和 Android 12–15 全部门禁通过；
- tag Release 步骤按预期跳过，未发布 GitHub Release；
- 设备重连后已覆盖安装 V2；安装包 SHA-256 与 artifact 一致，首次安装时间保持不变；
- 覆盖安装前后 14 个私有词典、主题和 SharedPreferences 文件的路径及 SHA-256 完全一致，V1 测试数据未改变；
- 安装时用户当前使用正式包，V2 没有被助手切换为默认输入法；等待维护者手动选择 target 35 后复测 IME 底行。

V2 复测结果与 V3 修正：

- 默认键盘高度下，底部确实被抬起，但出现过大的黑色背景并覆盖键盘上方区域；
- 键盘高度设为最高时，最底行仍可能进入导航栏后方；
- 原因是 V2 使用旧 `getSystemWindowInsetBottom()`，它返回合并后的 broad system-window bottom inset；在特殊的 IME edge-to-edge 窗口中可能包含导航栏以外的 inset source，不适合作为键盘底部安全区；
- V3 改为 `WindowInsets.getInsets(WindowInsets.Type.navigationBars()).bottom`，只取设备当前三键导航栏的 126 px inset；首次引导和 IME 共用该精确值；
- 保留 V2 的原始 padding/高度基线算法与键盘背景，不改变用户键盘高度设置，避免重复累加或固定高度假设；
- 静态门禁新增禁止 `getSystemWindowInsetBottom()`，强制 navigationBars-only 查询。

V3 构建与安装记录：

- commit：`677afbe`
- workflow：[`30868815100`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30868815100)
- artifact ID：`8877113156`
- artifact：`ComebackGooglePinyinInput-target-sdk-35-audit-v3`
- APK SHA-256：`33457bea419d9de9e302b9d99c21ba0a08e942acc64f047cf41d35358ff5f9ad`
- zipalign、v1/v2/v3 签名、签名证书、重解码及 Android 12–15 全部门禁通过；
- 已覆盖安装，设备 `base.apk` SHA-256 与 artifact 一致；
- 覆盖安装前后私有词典、主题与 SharedPreferences 文件 SHA-256 完全一致；
- target 35 仍为当前默认 IME，进程已由系统正常重启，等待默认和最高键盘高度复测。

V3 复测结果与 V4 修正：

- V3 首次显示时能够预留虚拟键区域，但只要改变一次键盘高度，键盘就再次向下移动，黑色安全区同步缩小，底部保护不再稳定；
- 代码和静态调用审计没有发现旧键盘高度逻辑会直接覆盖 `InputView` padding；
- 原因是 V3 使用 visibility-sensitive 的 `getInsets(Type.navigationBars())`。调整键盘高度会触发 IME/Settings 窗口及系统栏可见性过渡，回调可能在导航栏暂时不可见时返回 bottom=0，并用该值重置原始 padding；
- V4 改为 `getInsetsIgnoringVisibility(Type.navigationBars())`，始终使用设备导航栏的稳定几何高度，不受设置页切换、IME 隐藏/显示或一次键盘高度调整影响；
- 仍然只查询 navigation bars，不混入 IME、状态栏或其他 inset source，也不写死像素值；
- 门禁同时拒绝旧 broad API 和 visibility-sensitive `getInsets()`。

V4 构建与安装记录：

- commit：`573c2a3`
- workflow：[`30870850802`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30870850802)
- artifact ID：`8877826072`
- artifact：`ComebackGooglePinyinInput-target-sdk-35-audit-v4`
- APK SHA-256：`2403969b27651d542661f894f17911e671d46141331cecb9fa0dd7f82639ae1d`
- zipalign、v1/v2/v3 签名、签名证书、重解码及 Android 12–15 全部门禁通过；
- 已覆盖安装，设备 `base.apk` 哈希一致，target 35 仍为默认 IME；
- 覆盖安装前后私有词典、主题和 SharedPreferences 哈希完全一致；
- 进程已正常重启，等待反复调整默认/最高键盘高度后的稳定性复测。

V4 复测与 V5 架构修正：

- V4 在调整键盘高度后仍然下沉，且大面积黑色 surface 在调整前后都存在；这推翻了“只因 navigation bar visibility 短暂变化”的 V3/V4 假设；
- Gboard 完整调用链表明，它先用 `Window.setDecorFitsSystemWindows(!coverNavigation)` 选择 IME Window 模式，再由同一状态决定是否给 InputView 增加 stable inset；默认 non-covering 模式使用 `setDecorFitsSystemWindows(true)` 且 InputView bottom padding 为零；
- Gboard 的 Insets listener 只更新统一 window-metrics model，不直接修改 InputView；覆盖导航区时还使用专用 bottom-frame paint 和颜色 model，而不是给整个 root 设置背景；
- Google 拼音没有这套统一 model。V2–V4 把一个孤立 listener 永久安装在旧 InputView 上，使导航高度进入 root 测量，却不进入 `KeyboardBodyHeight`/`keyboard_height_ratio` 的原生高度来源，所以高度设置重建后几何失配；
- V5 删除 IME InputView listener、bottom padding 和 root background 覆盖；API 30+ 在 `PinyinIME.onStartInputView()` 后调用 `Window.setDecorFitsSystemWindows(true)`，由 IME Window/system 在三键和手势模式下负责系统栏避让；
- `NavigationBarCompat` 继续只负责 navigation surface 颜色、divider、图标和 contrast，不参与键盘 body 高度；
- first-run Activity 保留 navigation-bars-only bottom inset，因为其固定 footer 是独立的 Activity edge-to-edge 问题；
- V5 不使用 `windowOptOutEdgeToEdgeEnforcement`，不写死 126 px，不改变 `InputView.onMeasure()`、`onComputeInsets()`、候选、手写、pager 或触摸区域；
- 本地 clean decode、完整补丁、target 31/33/34/35 静态门禁和 apktool rebuild 已通过；
- V5 implementation/docs commit：`ec0fca6`；
- workflow：[`30873616949`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30873616949)；
- artifact ID：`8878729543`；
- artifact：`ComebackGooglePinyinInput-ComebackGooglePinyinInput-target-sdk-35-audit-v5`；
- APK SHA-256：`5844da7a00f31bce45fd0385138f239d385c2e1ac087d36d9ccfc75cbd75c4ff`；
- 云端 build/sign、包与版本身份、target 31/33/34/35 门禁、zipalign 和 v1/v2/v3 签名全部通过，证书仍为 `985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`；
- 已覆盖安装到现有 `target35audit`；installed `base.apk` 与 artifact SHA-256 一致，默认 IME 保持不变；
- 覆盖安装前后 16 个词典、主题和 SharedPreferences 文件的路径及 SHA-256 完全一致；
- V5 真机结果：大面积黑色区域已消失，但键盘首次显示就进入三键导航区，透过透明导航栏可见后方按键；无需调整高度即可复现，因此 V5 不可验收；
- 现场 `dumpsys window` 显示调用已生效为 `fitTypes=statusBars navigationBars`，但 IME attrs 仍为 `fitSides=LEFT TOP RIGHT`，明确缺少 `BOTTOM`；
- 这证明 Android 的 `InputMethodService` Window 默认排除 bottom fit side，单独调用 `setDecorFitsSystemWindows(true)` 不足以建立 non-covering IME；
- V6 保留无 InputView padding/background 的 V5 基础，并显式设置 `WindowManager.LayoutParams.setFitInsetsSides(0x0f)`（LEFT|TOP|RIGHT|BOTTOM），再回写 Window attrs；该值是平台 side bitmask，不是设备尺寸；
- V6 首要静态/真机判据为 `fitSides=LEFT TOP RIGHT BOTTOM`，之后再按“默认 → 最高 → 默认 → 最低/中间 → 重复切换”复测键盘几何、底行和导航区；
- V6 implementation/research commit：`ed33f90`；
- workflow：[`30875607013`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30875607013)；
- artifact ID：`8879422879`；
- artifact：`ComebackGooglePinyinInput-ComebackGooglePinyinInput-target-sdk-35-audit-v6`；
- APK SHA-256：`74eb1608d90e492f1602c549588ab6f32bbc46e9b335150f4727b6d880b04515`；
- 云端全部门禁、zipalign、v1/v2/v3 签名和证书验证通过，未发布 Release；
- 已覆盖安装，默认 IME 保持 target 35，覆盖前后 16 个私有文件 SHA-256 完全一致；
- 维护者反复切换多个键盘高度后确认：最下一行始终位于三键导航键上方，未再出现下沉或黑色大 surface；
- 键盘保持可见时的现场 Window 证据：navigation bar frame 为 `[0,2284][1080,2410]`，IME frame/visibleFrame 为 `[0,1481][1080,2284]`，两者边界精确相接且不重叠；
- `mImeShowing=true`、`mLastDrawn=true`，IME Window surface on-screen；V5 的 `fitSides=LEFT TOP RIGHT` 不再出现（全 side 默认值在 dumpsys 中省略）；
- crash buffer 及 DropBox crash/ANR metadata 均无 target 35 命中；
- 随后的应用侧回归发现 V6 仍不可验收：IME source 在 navigation bar 顶边 `2284` 结束，应用收到的 IME inset 不再延伸到 display bottom；使用现代 Insets/`ADJUST_NOTHING` 的输入界面不会随键盘正确上移，底部编辑区会被遮挡；
- V6 同时让 navigation region 完全脱离 IME surface，系统透明导航栏显示应用内容，无法使用键盘主题绘制底部区域；
- 这两个问题共同证明正确模型必须是 Gboard 的 covering Window + dedicated bottom frame：IME source 延伸到屏幕底部以保留应用侧完整 inset，键盘 body 在 Window 内上移，navigation region 由独立主题 frame 绘制；
- V7 将 Window fit sides 恢复为 `LEFT|TOP|RIGHT (0x07)`，不 fit `BOTTOM`；不恢复 root padding/background，而是在两套 `ims_input_view.xml` 中加入独立 `ime_navigation_frame`；
- `ImeInsetsListener` 使用 `navigationBars` ignoring-visibility bottom inset，同时设置 `keyboard_area.bottomMargin` 和 bottom frame height。FrameLayout 总高度为“原生键盘高度 + 导航区”，键盘高度逻辑本身保持不变；
- V7 预期 frame：IME/source 到 display bottom，keyboard area 到 navigation top，底部 frame 只覆盖 navigation region；需同时验证应用编辑区上移、主题颜色、反复高度切换和手势导航零/小 inset。
- V7 implementation `138af07`；workflow `30878039751`，artifact ID `8880234263`，artifact `ComebackGooglePinyinInput-ComebackGooglePinyinInput-target-sdk-35-audit-v7`，APK SHA-256 `4aa24ef61241c0a2120aa41d198081d95a44732311118b283223e07714c4d79f`。
- V7 已通过 clean decode/patch、target 31/33/34/35 静态门禁、apktool rebuild、云端 build/sign、zipalign、v1/v2/v3 signature、证书和最终 APK re-decode；overlay 安装后的 APK hash 与 artifact 一致，16 个 private dictionary/theme/SharedPreferences 文件 hash 全部保持不变。
- V7 现场 frame 为 `ime=[0,1607][1080,2410]`、`navigationBars=[0,2284][1080,2410]`：应用输入区已正确上移，证明 bottom-anchored IME source 修复有效；但键盘 body 仍占满 803 px Window 并下沉到导航栏后，bottom frame 没有增加 Window 测量高度。
- 根因是旧 `InputView.onMeasure()` 在 `AT_MOST` 下会在 `FrameLayout.onMeasure()` 之后强制使用父 MeasureSpec size；因此 keyboard-area margin 与 bottom-frame child 虽已更新为 126 px，root 的 measured height 仍被压回 803 px。V7 不可验收。
- V8 保留 V7 正确的 Window/source 和独立 bottom-frame 模型，仅在旧 `InputView.onMeasure()` 尾部尝试令 API 35+ measured height 等于 `keyboard_area.measuredHeight + ime_navigation_frame.height`；现场仍失败，键盘最低行未回到导航栏上方。
- V8 可见状态再次确认 `ime=[0,1607][1080,2410]`、`navigationBars=[0,2284][1080,2410]`，Window/source 与应用侧上移保持正确；但 root measure 仍是 803 px。原因进一步收敛为：父级给 root 的 803 px 约束扣除 126 px margin 后，`keyboard_area.measuredHeight` 本身已被压成约 677 px，因此 V8 又计算回 803 px，形成闭环。
- V9 不从已被父级压缩的 `keyboard_area` 容器取 body 高度，改为读取其原生垂直内容 `header_group_view.measuredHeight + body_group_view.measuredHeight`，再加动态 bottom-frame height；现场最低行仍未回到导航栏上方，证明 `InputMethodService` 的父级 input frame 最终约束不会被 InputView 自报 measured height 改写。V8/V9 测量补偿全部判定无效并移除。
- 复核 Gboard `eht.aD()` 后确认 covering-navigation 模式确实会根据统一 `sbr` metrics 处理 navigation bottom，并在 InputView 外保持完整 Window/source；但本项目不能继续复制 V2–V4 已失败的 root-padding/background 组合。
- V10 改在 Android `InputMethodService.setInputView()` 创建的直接父级 input frame 处理：原生 InputView 自身不改 padding、measurement、keyboard-area margin 或 background，仅给 InputView 的父级 LayoutParams 设置动态 bottom margin；同一父级增加一个 bottom-gravity sibling frame，使用 keyboard-area drawable 的独立 ConstantState 副本绘制导航区。
- V10 三键导航现场确认：最低行位于导航栏上方、应用输入区域正确上移；Window 证据为 `InputView/content top=1481`、`navigationBars=[0,2284][1080,2410]`、`ime=[0,1481][1080,2410]`。这证明父级 bottom-margin 几何方案正确，V6 与 V7–V9 的两个互斥问题首次同时解决。
- V10 唯一剩余问题是导航区域没有显示键盘主题。即时 sibling frame 加在 `mInputFrame` 内，其绘制受该父级自身 bounds/clipping 约束，虽然 margin 参与了父级测量，frame 没有可靠绘制到系统导航区。
- V11 保留已确认的 InputView parent bottom margin，只把主题 bottom frame 提升到 IME Window 的 decor root；现场导航区仍未随主题绘制，而且反复切换主题会在“键盘上移/下沉”之间变化，V11 不可验收。
- 主题切换反证暴露了生命周期竞态：旧实现从 `InputView` XML 构造函数立即注册并 `requestApplyInsets()`，此时 `InputMethodService.setInputView()` 尚未把它加入 `mInputFrame`。首次/重建后 Insets 是否重新分发取决于当次 framework traversal，因此 margin 有时生效、有时不生效；bottom frame 的 decor root 和主题 drawable 时机也不稳定。
- V12 把 coordinator 安装点从 InputView 构造函数移到 `GoogleInputMethodService.c()` 中 `setInputView(view)` 返回之后。后续多次主题切换均保持最低行在导航栏上方，但刚安装后的第一次弹出仍出现一次下沉，说明首次创建时还存在 Window fit attributes 与首个 Insets request 的顺序窗口；应用输入区始终正确。
- V12 的 decor frame 已开始跟随主题，但颜色与候选栏/keyboard-area 外层一致，而非用户期望的主键盘 body。原因是背景源取自 `@id/keyboard_area` 的 `?BgKeyboardArea`；Google 拼音将候选/外围和主按键区分别用 `BgKeyboardArea`、`BgKeyboardBody` 着色。
- V13 在 helper 中保存当前已 attach 的 InputView，并在 `configureImeWindow()` 完成 Window attributes 后再次 `requestApplyInsets()`；主键盘 body 颜色修复已确认，后续主题切换/隐藏/重开也保持几何正常。但解锁后的第一次自动弹出仍下沉，说明同一主线程调用栈里的直接 request 仍可能早于首个 attach/layout traversal。
- V14 保留所有已确认的几何和主题逻辑，增加隐私安全、幂等的 post-layout `ApplyInsetsRunnable`；现场首次展开仍为 `ime=[0,1607][1080,2410]`，证明单纯 `requestApplyInsets()` 即使延后执行，在系统判断 Insets 状态未变化时仍可能不重新 dispatch listener。V14 不可验收。
- V15 的 deferred runnable 主动 dispatch root Insets；首次现场仍为 `ime=[0,1607][1080,2410]`。这证明首次 Window 尚未 attach 时 post runnable 会因 `isAttachedToWindow=false` 退出，且 InputView/root Insets 的 navigation bottom 还可能是 decor 消费后的 0；主题重建时 Window 已 attach，所以后续恢复。
- V16 同时增加 attach listener 和 WindowMetrics source，但首次仍下沉；在继续修改生命周期前必须确认是“callback 未执行”“metrics 为 0”“LayoutParams 不是 margin”还是“margin 写入后被 framework 覆盖”，停止无证据迭代。
- V17 是临时 release-like geometry diagnostic：仅记录 `onViewAttached`、runnable attached 状态、root Insets 是否存在、WindowMetrics navigation bottom、listener inset、margin before/applied 等整数/布尔元数据。固定 tag 为 `GooglePinyinImeGeometry`；禁止并且不采集输入文本、候选、剪贴板、联系人、词典、手写坐标或 SharedPreferences。定位后这些日志应移除，V17 不作为最终验收包。
- V16/V17 首次问题仍复现后，维护者明确要求隔离 Debug 深入诊断。V18 使用独立 `com.google.android.inputmethod.pinyin.target35debug`、`android:debuggable=true`，不能替代 release-like 验收包；新增的 layout listener 只记录 InputView layout top/bottom/height、window Y 和 LayoutParams bottomMargin，结合既有 callback/metrics 日志判断 margin 是未写入还是写入后被 framework 覆盖。仍不记录任何输入或用户内容。
- V18 首次展开日志只有两次 `configureImeWindow`，完全没有 `attachCalledAttached`、attach、runnable、metrics、listener 或 layout 事件；现场 `ime=[0,1670][1080,2410]`。根因由此确定：Android framework 首次创建 IME 时直接调用 `onCreateInputView()` 并自行安装返回值，不经过项目的 `GoogleInputMethodService.c()`；此前 post-`setInputView()` hook 只覆盖主题重建路径，所以切换主题后才永久恢复。
- V19 Debug 将唯一 coordinator hook 移入 `GoogleInputMethodService.onCreateInputView()` 的新视图返回路径。首次 framework 创建与 `c()` 主题重建都会调用这个方法；listener 可在 View 尚未 attach 时注册，一次性 attach callback 在 framework 随后安装 View 后执行。
- V19 首次展开已由用户确认正常。现场从 V18 的 `ime=[0,1670][1080,2410]` 修正为 `ime=[0,1544][1080,2410]`；导航栏仍为 `[0,2284][1080,2410]`，新增的 126 px 正好来自当次 WindowMetrics，而非硬编码。日志确认 `windowNavBottom=126`、`runnableAttached=1`、`rootInsetsPresent=1`、`layoutBottomMargin=126`，证明首次路径、动态 inset 和 parent margin 均生效且未被 framework 覆盖。随后移除固定 tag、全部 geometry log 和 layout diagnostics listener，只保留已验证的公开 API 实现与 `onCreateInputView()` hook。
- 干净的 release-like V20 首次展开也由用户确认正常；现场为 `navigationBars=[0,2284][1080,2410]`、`ime=[0,1481][1080,2410]`、`fitSides=LEFT TOP RIGHT`、`mImeShowing=true`。这同时确认应用获得延伸至屏幕底部的完整 IME source，而原生键盘 body 通过动态导航间距停在导航栏上方。V20 不可调试、无临时 geometry 日志，覆盖安装前后 16 个私有文件哈希保持一致。
- V20 功能回归正常，但手势导航下系统“收回键盘”和“切换输入法”控制被键盘 surface 挡住一部分。显示现场证明 `navigationBars.bottom=63`，而 `mandatorySystemGestures.bottom=84`；IME source 为 `[0,1544][1080,2410]`，Taskbar 明确同时提供这两个公开 Insets source。V20 只预留 63 px，因此关键系统控制区域上方 21 px 仍与可触摸键盘 body 重叠。V21 不使用固定差值，而从 WindowMetrics 对 `navigationBars() | mandatorySystemGestures()` 调用 `getInsetsIgnoringVisibility()`；Android 对组合 type 返回各边最大值。三键模式两者相同，不改变已验收几何；手势模式则动态预留完整 84 px 控制/强制手势区域。刻意不使用普通 `systemGestures()`，避免把左右返回手势带误作底部键盘间距。
- V21 中左右系统控件仍可交互但完全不可见，同时底部主题连续且应用 Insets 正确，这证明主要问题是绘制层级：decor-root 主题 frame 在创建和每次更新后调用 `bringToFront()`，覆盖了 framework/SystemUI 控件的可见像素，却不拥有其系统触摸处理。V22 将主题 frame 以 index 0 插入 decor root，并禁止 `bringToFront()`；InputView 已通过 bottom margin 结束在该 frame 上方，因此 frame 在底部仍可见，而 framework 后续/既有 decor children 和系统控制保持在它上层。
- V22 的系统控件完整可见且可交互，但用户确认主题 surface 出现异常，且与 target 28 对比底部空间明显过宽。这修正了此前把 `mandatorySystemGestures=84` 当作视觉控制 frame 的推断：现场 Taskbar 的实际 navigation window/frame 高度是 63 px，84 px 是不可由应用排除的强制手势识别区域，不要求所有视觉内容避让。V20 控件被遮挡的原因是 frame z-order，不是 63 px 导航高度不足。V23 因此保留 index-0 主题 frame、移除 `bringToFront()`，并恢复只按 `navigationBars()` 的 63 px 动态间距；系统控件完整可见且可交互，但底部仍为上半主题色、下半灰色，且键盘比 target 28 更低。
- 在两个包都使用最高高度档位和相同主题时，target 28 手势模式为 `ime=[0,1481][1080,2410]`，V23 为 `[0,1544][1080,2410]`，精确相差 63 px；两者的 `navigationBars=63`、`mandatorySystemGestures=84` 与 `fitSides=LEFT TOP RIGHT` 完全相同，排除了设置差异。V24/V25 使用隔离 Debug 包只记录 decor View 的类名、child index、整数 ID、上下边界、高度、translationY、clickable 和背景 Drawable 类名，以识别主题 frame、灰色 surface 与系统控件之间的真实层级；禁止读取文本、候选、剪贴板、Preferences 或字典，也不截图。
- V25 最终布局给出决定性结构：DecorView 高 2238；自定义主题 frame 在 direct child index 0、范围 `[2175,2238]`、高度 63；IME 内容容器在 index 1；framework 的 IME navigation container 在最后一个 direct child、范围 `[2112,2238]`、高度 126，内部依次包含导航 View/Inflater/View buttons。也就是说，即使外部手势 `navigationBars` source 只有 63 px，InputMethodService 自己为收回/切换控件保留的真实视觉容器仍是 126 px。V23 把 63 px frame 放在该 126 px 容器下面，必然造成上半主题、下半灰色，并使键盘比 target 28 低 63 px。
- V26 不引用 framework 内部类名、隐藏 ID或反射：通过公开 `ViewGroup` API取得 DecorView 最后一个 direct child，验证它是非空 ViewGroup 且已有正高度后，使用其实际 `getHeight()` 作为动态 bottom gap，并把主题 frame 以 index 0 插入这个容器内部；原有系统导航 View 保持在其上层。若结构不满足条件，则回退到公开 WindowMetrics 的 `navigationBars()`。V26 手势模式由用户确认垂直位置、主题和控件全部正常；三按钮模式几何同样正确（`navigationBars=126`、`ime=[0,1481][1080,2410]`），但出现 Android 15 三按钮导航的灰色 contrast surface。
- target 28 三按钮对照具有完全相同的 Insets source flags（两者都没有 `SUPPRESS_SCRIM`）、相同导航 frame 和相同 IME top，且 target 28 颜色正常，因此不能仅凭 dumpsys flags 判断 Window 的最终 contrast-enforcement 状态。`NavigationBarCompat` 虽已在主题/输入生命周期调用 `setNavigationBarContrastEnforced(false)`，target 35 的 edge-to-edge 导航容器在后续 Insets 重建时会覆盖时序。V27 在专用 IME Insets listener 完成 frame/theme 更新后重申该公开 Window 状态，但用户确认灰色遮罩完全没有变化，排除“只需延后 contrast false”的假设。
- V28 将 Window navigation surface 改为 target-35 covering 模型所需的透明承载层：主题颜色已经由 NavigationBarFrame 内部、位于系统控件下方的专用 frame 绘制，因此最终 Insets 回调同时执行 `setNavigationBarColor(Color.TRANSPARENT)` 与 `setNavigationBarContrastEnforced(false)`。用户确认三按钮灰色遮罩仍完全没有变化，说明灰色不是 Window color/contrast layer，而在 framework 导航 View 自身或更深层绘制。
- V29 隔离 Debug 将 decor tree 深度扩展到 8。三按钮现场显示最终 DecorView 的最后一个 direct child 已变成 `visibility=INVISIBLE` 的普通 ColorDrawable View，而不是 V25 手势现场的 navigation container；因此实验性 `setWillNotDraw()` 保护条件没有执行，不能解释灰色。更关键的是，V28 透明色和 V27 contrast false 都无变化，结合代码审查发现 late helper 通过 `InputView.getContext() instanceof InputMethodService` 取 Window；实际 InputView 可由包装 Context 创建，这条分支可以静默 no-op。
- V30 Debug 在 `configureImeWindow(InputMethodService)` 已取得真实 Window 时保存该公开 Window 引用，最终 Insets listener 直接用它重申 `setNavigationBarContrastEnforced(false)`；不再通过 View Context 猜测 Service，也撤销 V28 的透明色实验和 V29 的 `setWillNotDraw()` 实验。用户确认灰层仍无变化，彻底排除 contrast flag。
- V30 深层日志确认三按钮最终 DecorView 的主题 frame 已完整覆盖底部 126 px，InputView 正确结束在它上方；最后一个 direct child 是同样位于底部 126 px、带 ColorDrawable 但 `visibility=INVISIBLE` 的平台 navigation color View，导航按钮由外部 Taskbar surface 提供。target 28 的旧 decor 模型会显示这个平台颜色 View，而 target 35 edge-to-edge 将其隐藏，外部三按钮半透明层因而覆盖主题 frame形成灰色。V31 Debug 只在最后一个 direct child 是非 ViewGroup、正高度且隐藏时将其设为 VISIBLE；三按钮灰层随即消失且按钮仍正常，证明平台 color View 是正确承载层。手势模式最后一个 child 是导航 ViewGroup，结构条件不成立。
- V31 的平台 color View 颜色未随当前主题正确适配。V32 Debug 在 Insets listener 已取得稳定 body 后再次调用 `NavigationBarCompat.apply()`，但用户确认颜色仍不一致，说明 target-35 edge-to-edge 下 Window navigation color 不会再同步到被平台隐藏的 ColorDrawable。
- V33 Debug 在与 V31 相同的三按钮专属结构条件下，从已经显示正确的专用 theme frame 取得 background，优先通过 `ConstantState.newDrawable(resources).mutate()` 创建独立副本，并直接赋给平台 color View 后再显示；当前主题因此完全同步、按钮正常，但切换任何其他主题后不同步。根因是诊断入口仍受进程级 `dumpOnce` 门控，只在第一次 Insets 执行，后续主题 rebuild 虽更新 theme frame 却不再同步平台 View。
- V34 Debug 移除该一次性门控，让每次专用 IME Insets/theme callback 都 post 同一结构验证和 Drawable 同步。用户确认三按钮多主题和首次切到手势均正常，但手势再切回三按钮时曾出现平台 color View 覆盖全屏、三按钮消失；切走再回来后恢复几何但灰层复发。说明“最后一个非 ViewGroup 且正高度”在导航模式过渡帧中过宽，会把暂时全屏的 decor color View误判为稳定三按钮背景。
- V35 Debug 增加公开 WindowMetrics `WindowInsets.Type.tappableElement()` 判定：只有候选平台 View 的实际 height 精确等于正数 `tappableElement.bottom` 才同步/显示。V35 不再出现全屏白色，手势、几何和应用 Insets 正常，但切回三按钮后灰层仍在；说明所有 Insets callbacks 都发生在 decor 过渡结构阶段并被正确拒绝，而最终稳定的三按钮 color View 出现后没有新的 Insets callback。
- V36 Debug 在当前 DecorView 上安装一次普通 `OnLayoutChangeListener`，但用户确认三按钮灰层仍在，其他路径正常。持续 layout listener 与同步操作自身的 `setBackground/setVisibility` 会互相触发布局，既可能形成反馈，也不能保证回调恰好落在平台 color View 替换后的结构，因此不进入正式实现。
- V37 Debug 删除 layout listener，改为每次 Insets/theme callback 立即 post 一次、并对同一 Runnable 再 `postDelayed(300ms)` 一次。后续发现覆盖安装 Debug 时 Android 自动回退到了仍启用的 `target35audit`，所以此前 V35–V37“仍灰”的观察不是这些 Debug 版本的有效结果。
- V38 使用全新 `GooglePinyinImeSync` tag，只记录 schedule、候选是否 ViewGroup、候选高度和 tappable bottom 整数。重新显式选择 `target35debug` 后，日志证明过渡/手势结构为 `candidateGroup=1` 并被拒绝，稳定三按钮为 `candidateGroup=0, candidateHeight=126, tappableBottom=126` 并正确同步。用户确认首次正常、主题切换正常、三按钮→手势→三按钮多轮往返正常，无白屏、灰层、几何、控件或应用 Insets 回归。
- Release-like V39 将已证明的逻辑移入无日志的 `ImeNavigationColorCompat`：保留立即 post、300ms 有界重试、非 ViewGroup/正高度/等于正数 tappable bottom 的结构守卫，以及从专用 theme frame 克隆 Drawable 到平台 color View；删除 `ImeDecorDiagnosticsCompat`、tree dump 和全部 Debug tag。覆盖安装后显式恢复 `target35audit` 并卸载 Debug。用户在首次手势→三按钮时看到一次白屏，此后多轮导航、主题和高度切换均无法复现，其他路径正常；当前 Window、ART crash buffer 和 DropBox 均无本包异常。
- V38 的递归 tree dump/logging 在执行同步前引入了显著时序开销，而无日志 V39 的立即 Runnable 更早，可能在 View 仍保留旧 measured 126、但 framework 已请求下一次全屏布局的瞬间命中原守卫。V40 因此不依赖诊断延迟，增加公开稳定布局条件：root 与候选均 `!isLayoutRequested()`、候选 `isLaidOut()`、候选 bottom 等于 root height、宽度等于 root width；300ms 有界重试保留。这样旧测量值/待布局过渡帧被拒绝，稳定三按钮背景仍满足全部条件。
- V40 clean release-like（commit `79ed506`，workflow `30937645444`，artifact `8903797153`，APK SHA-256 `153f2ab453a35f1f565ffaf6d5057a99c62e30add7e5fb7118cc3a43e3985465`）覆盖安装前后 18 个持久私有文件 SHA-256 完全一致，签名/target/non-debug 和 target 31–35 静态门禁全部通过。用户完成首次手势→三按钮、至少五轮导航往返、主题、键盘高度、隐藏/重开及锁屏/解锁测试，确认无白屏、灰层、控件、几何或应用 Insets 回归。随后 release-like crash buffer、DropBox crash/ANR 和 ART verifier 检查均无本包命中。
- 获得明确授权后，仅删除隔离 `guide_complete` 和旧安装本地 `HAD_FIRST_RUN` 标记以复测升级环境中的首次引导；18 个持久文件中只有这两个 SharedPreferences 文件按预期变化，词典、主题和备份文件全部不变。用户确认三页引导弹出，左/右按钮完整位于三按钮导航栏上方，引导页和设置页均可正常交互且无阻挡；完成后 `guide_complete` 已重新写入、默认 IME 为 `target35audit`，crash buffer 与 DropBox 仍无本包命中。现有页面不再做视觉扩建，完整 MD3 重写按决定推迟到 target 36 适配完成之后。至此 target 35 的功能、首次引导、设置、双导航、首次/解锁显示、主题、高度、Insets、ART/Root/DropBox 和数据保留验收全部通过。

### target 36 / Android 16

状态：**V19 release-like 已完成并验收**。分支 `feat/target-sdk-36`，验收实现提交 `7581f42`，最终验收准备和门禁修正提交以后续分支 HEAD 为准。

V1 保留 target 35 已验收的 covering IME Window、双导航主题同步、首次引导和所有功能实现，不加入预测返回回调或 MD3 重写。Manifest 显式设置应用级 `android:enableOnBackInvokedCallback="false"`，先冻结普通 `onBackPressed()` 语义；新增 `scripts/verify_target36.py`，要求 target 36、真实 edge-to-edge、显式 legacy Back opt-out，并拒绝在首个 target-only 候选中混入 `OnBackInvokedCallback`。

V1 的首次引导、首次展开、核心输入、主题、高度和双导航均通过，但在“Google 语音输入 → `switchToLastInputMethod()` → Google 拼音”首次暴露了持久白框。现场无崩溃，IME Window 仍为 drawn/showing，Surface 覆盖 `y=172..2410`，但 IME Insets 在短暂正确报告 `top=1481` 后 3 ms 内变为 `[0,2410][1080,2410]`（0 高度）。根因是 `ImeInsetsListener` 在输入法切换过渡中可把临时全屏 ViewGroup 当作稳定导航容器，并将其高度写入 InputView bottom margin，从而压缩全部键盘内容。

V2 为 bottom-margin coordinator 加入与已验收导航颜色同步器同类的公开稳定几何守卫：根与候选无待处理布局、候选已布局、候选高度等于公开 WindowMetrics `navigationBars` bottom inset、候选位于根底部且全宽。过渡候选被拒绝时仅采用公开导航 Insets 作为 margin 安全回退，不创建或迁移主题 frame；不使用固定尺寸、隐藏 ID、内部类名或反射。V2 多轮语音往返不再出现白框，但三按钮导航不能跟随主题色：`onApplyWindowInsets()` 本身可能发生在布局请求期间，`isLayoutRequested()` 条件会持续拒绝已具有正确最终几何的稳定导航容器，导致主题 frame 无法进入真实导航容器。

V3 从 bottom-margin/frame-parent 判定中移除 `isLayoutRequested()`，保留候选已布局、高度严格等于公开 `navigationBars.bottom`、底部对齐和全宽守卫。这里即使候选保留旧的正确导航高度，写入的 margin 仍是公开安全值；真正危险的全屏过渡高度会被严格高度比较拒绝。导航颜色 Drawable 的同步仍保留 V40 的完整 `isLayoutRequested()` 守卫，因此不放宽平台颜色 View 的过渡写入条件。V3 仍未恢复三按钮主题跟随，因此转入 Debug 结构诊断。

Debug 现场证明稳定三按钮 DecorView 只有两个直属子项：`child0=LinearLayout`（全高、无背景）和 `child1=View`（`126 px`、底部全宽、`ColorDrawable`）；`themeFrame=null`。颜色同步器虽然多次达到 `sync-applied`，但因首子项背景为空，只能保持平台 View 可见，无法复制当前键盘主题。V2/V3 的共同问题是把“候选必须为 ViewGroup”作为稳定条件，因而从未在这个稳定的非 ViewGroup 平台导航 View 结构下创建直属 theme frame。V1 之所以能跟随，是旧逻辑在非 ViewGroup 分支保留 DecorView 作为 frame parent，但它同时会错误接受语音切换时的全屏 ViewGroup。

V4 Debug 将候选类型与几何稳定性分开：所有候选都必须已布局、高度严格等于公开 `navigationBars.bottom`、底部对齐且全宽；稳定非 ViewGroup 候选使用 DecorView 作为 theme-frame parent，稳定 ViewGroup 候选继续使用候选容器，任何全屏过渡候选仍被拒绝。三按钮下语音、主题和重复往返通过。

手势模式 Debug 现场进一步证明不能要求候选高度等于 `navigationBars.bottom`：系统公开 navigation bar 为 `63 px`，但 IME DecorView 的稳定末子项是一个底部全宽 ViewGroup，实际高度为 `126 px`；InputView 因 fallback margin 仅保留 `63 px`，高度变成 `2175 px`，键盘区域屏幕顶部变为 `1544`，同时 `themeFrame=null`，形成用户观察到的整体矮 `63 px` 和底部黑色断层。target 28/已验收几何的键盘顶部为 `1481`，差值正是被漏掉的 `63 px`。

V5 Debug 不再把系统 `navigationBars.bottom` 当作框架 IME 导航容器的视觉高度；它只作为没有稳定候选时的安全 fallback。稳定候选必须使用公开 View 几何满足：已布局、正高度、严格小于根高度、底部对齐且全宽。其真实高度动态成为 InputView margin 和 theme-frame 高度；候选为 ViewGroup 时 frame 放在容器内，普通 View 时 frame 放在 DecorView。语音切换时的全根临时容器因高度等于根高度而被拒绝，不需要固定 `63/126/2238 px`、隐藏 ID、内部类名或反射。

V5 从手势返回三按钮后又暴露一种稳定结构：DecorView 暂时或持续只有一个全高 LinearLayout，框架导航 ViewGroup 已随模式切换移除；InputView margin 和 IME top 已正确恢复为 `126 px`/`1481`，但原 theme frame 随旧 ViewGroup 一同被移除，后续无稳定末候选可用于重建，故 `themeFrame=null` 且主题跟随失效。

V6 Debug 在“无稳定末候选但公开 fallback inset 为正”时使用 DecorView 作为安全 theme-frame parent，同时始终从整个根树查找唯一 tagged frame。若后续出现稳定 ViewGroup/普通 View 结构，则通过公开 `View.getParent()`/`ViewGroup.removeView()` 将同一个 frame 重挂到正确 parent，而不是创建重复 frame；margin 仍只使用稳定候选真实高度或公开 fallback，绝不采用全根过渡高度。语音往返仍有概率故障，证明继续把自有 surface 绑定到 framework Decor 子项并不可靠。

V7 Debug 停止 DecorView add/remove/reparent 路线，完整采用 InputView-owned covering model：theme frame 永久作为 InputView 内部、不可点击且不可聚焦的底部 sibling；只给现有 keyboard area 写 bottom margin，保留其原生测量高度，不修改 InputView padding 或 `onMeasure()`。稳定 framework bottom candidate 只作为只读几何传感器：已布局、正高度、小于根高度、底部对齐且全宽时记录进程级 `lastStableNavigationHeight`；候选暂时消失或进入全根过渡时继续使用最后稳定值，公开 `navigationBars.bottom` 只作冷启动 fallback。V7 现场几何达到 `IME top=1481`，InputView 为 `2238 px`，内部 theme frame 和 keyboard area 分别为 `2112..2238` 与 `1309..2112`，两者 Drawable 均为当前 `bam`；但手势下 DecorView 同时存在位于 theme frame 上方的稳定普通 View 和最后的导航控件 ViewGroup。旧颜色同步器只检查最后一个 child，因其为 ViewGroup 而退出，前一个普通平台颜色 View 保留旧 tint，遮住正确的自有 frame。

V8 Debug 保持 V7 自有布局不变，仅重写平台颜色同步器：主题来源永远是 InputView 自有 tagged frame；从 DecorView 顶层末尾向前扫描，跳过所有 ViewGroup，只接受无 pending layout、已布局、高度严格等于自有 frame、底部对齐且全宽的普通 View。这样可更新位于尾部导航控件 ViewGroup 之前的平台颜色层，同时全屏/旧尺寸过渡层不能通过高度和稳定布局守卫。

V9–V17 以隐私受限 Debug 元数据继续识别正常键盘、图片主题和展开候选的实际 View/Drawable 层次。最终决定不让展开候选拥有导航视觉，也不复制候选页、候选行或候选按键背景。相关候选 toggle 注入、`PageableCandidatesHolderView`/`avs`/`avu` 访问、多余 overlay 和 `GooglePinyinImeSync` 诊断均已删除。V18 将 renderer 收窄为图片主题普通状态的共享坐标切片；V19 将内置主题来源修正为 `KeyboardViewHolder.a → SoftKeyboardView.background`，避免错误使用候选栏颜色。图片主题保留原生 body 阴影和动态导航高度裁剪；展开候选保持最后一个稳定普通状态视觉，不改变交互边界。

V19 release-like 验收包：

- 提交：`7581f42`；
- workflow：`31014197049`；
- artifact：`8933765304`；
- APK SHA-256：`668d36d3c671b9e1a18145d3baddfb6622ccd2a280a4cc9be8440c2ff893223d`；
- 证书 SHA-256：`985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`；
- 设备安装 APK 与 Actions artifact 逐字节一致；
- `PACKAGE_CRASHES=0`、`DROPBOX_PACKAGE_MATCHES=0`、`VERIFY_ERRORS=0`；
- release-like Manifest 无 debuggable 标记，包内无临时主题/候选诊断。

Pixel 10 Pro / Android 16 最终几何：

- 三按钮：IME Insets `[0,1481][1080,2410]`，navigationBars `[0,2284][1080,2410]`，IME touchable region `[0,1481][1080,2284]`，`mImeShowing=true`、`mLastDrawn=true`；
- 手势：IME Insets `[0,1481][1080,2410]`，navigationBars `[0,2347][1080,2410]`，mandatorySystemGestures `[0,2326][1080,2410]`，`mImeShowing=true`、`mLastDrawn=true`；
- 两种模式下 IME Window 均为 `[0,172][1080,2410]`、requested size `1080×2238`、`fitSides=LEFT|TOP|RIGHT`、Surface `shown/HAS_DRAWN`；
- 用户确认首次引导、核心输入、候选/剪贴板、手写、内置主题、图片主题、动态裁剪、键盘高度、备份/导入、锁屏、语音 IME 往返和双导航视觉正常。展开候选背景不延伸到导航区是最终明确边界，不再设计。

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
