# 隔离审计包 Debug 模式

## 目的

Target SDK 逐级审计需要同时保留两类证据：

1. **release-like 验收包**：默认、非 debuggable，用于判断真实 target 行为和正式版兼容性
2. **debug 诊断包**：显式启用，仅用于在同一 target 上通过 `run-as`、JDWP、Perfetto/heapprofd 和更完整的进程信息定位问题。

Debug 包不能替代 release-like 验收。`android:debuggable=true` 可能改变 JIT、调试器附加和部分运行时策略，因此每一级最终是否通过仍以默认非 debug 包为准。

## 安全边界

- Debug 模式默认关闭。
- `scripts/apply_patches.py --debuggable` 遇到正式 application ID `com.google.android.inputmethod.pinyin.compat` 时直接失败。
- GitHub Actions 同样拒绝「正式 application ID + debuggable」组合。
- 正式分支/tag 的普通构建不传入 debug 参数，Manifest 不包含 `android:debuggable="true"`。
- Debug 包继续使用隔离的 target 审计 application ID 和「Google 拼音输入法（测试版）」显示名称。
- 不把键入内容、候选文本、剪贴板内容、联系人内容或词典正文写入新增日志。
- 不默认启用 StrictMode `detectAll()`：旧应用会产生大量与 target 边界无关的噪声，也可能改变时序。需要时应单独实验并记录。

## 构建

本地构建增加 PowerShell switch：

```powershell
./scripts/build.ps1 `
  ... `
  -ApplicationId com.google.android.inputmethod.pinyin.target30audit `
  -Debuggable
```

直接应用补丁：

```text
python scripts/apply_patches.py work/decoded \
  --application-id com.google.android.inputmethod.pinyin.target30audit \
  --debuggable
```

GitHub Actions 手动构建：

- `application_id`: 隔离审计 ID
- `artifact_name`: 明确带 `debug`
- `debuggable`: `true`。

Workflow 会检查最终 Manifest 的 debuggable 状态，并在 Actions summary 中记录。

## 设备诊断采集

安装 debug 包并使进程运行后：

```powershell
./scripts/capture_audit_diagnostics.ps1 `
  -Package com.google.android.inputmethod.pinyin.target30audit
```

默认输出位于：

```text
work/device-diagnostics/<package>-<timestamp>/
```

默认采集：

- 包、版本、target SDK、权限和 AppOps
- 当前/已启用 IME 和 InputMethodManager 状态
- DropBox 中属于该包的 crash/ANR
- `run-as` 可见的私有文件名称、大小、时间和 SHA-256，不读取正文
- 进程内存、图形、线程、FD、native maps
- 当前进程 warning/error 日志。

默认不采集 verbose 日志。确有需要时可显式使用：

```powershell
./scripts/capture_audit_diagnostics.ps1 `
  -Package com.google.android.inputmethod.pinyin.target30audit `
  -IncludeVerboseLog
```

Verbose 日志在分享前必须人工检查。脚本不会自动生成完整 bugreport，也不会读取剪贴板、词典正文、联系人正文或 SharedPreferences 正文。

## 首次双模式构建记录

源提交：`d5e2e3c85b38b0eaaf969e48a3798d5a932f588a`

Release-like 基准验证：

- workflow：[`30782851827`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30782851827)
- artifact ID：`8844253668`
- artifact：`ComebackGooglePinyinInput-target-sdk-30-release-like-debug-infra-check`
- APK SHA-256：`82b6c289005b8837499bdd1d78d593be08161c479503707fc08f28c3daa2fe55`
- Manifest：没有 `android:debuggable="true"`

Debug V1:

- workflow：[`30782855073`](https://github.com/huaxianyan/comeback-google-pinyin-input/actions/runs/30782855073)
- artifact ID：`8844264204`
- artifact：`ComebackGooglePinyinInput-target-sdk-30-debug-v1`
- APK SHA-256：`fdff4030bc12e0aa7111804bdb6b2fff0d10a40b0a0980c544f29f705bbb9277`
- Manifest：包含 `android:debuggable="true"`

两者均通过 zipalign、v1/v2/v3 签名和证书检查。解码后排除 Manifest 与重新签名产生的 `META-INF` 文件，5571 个代码、资源、assets 和 native 文件的路径及 SHA-256 完全一致。新的默认 release-like 构建与已经验收的 target 30 V1 也有相同的 5571 个有效载荷文件哈希。因此 debug 变体没有夹带功能代码差异。

本地负向测试确认：

- 正式 application ID 加 `--debuggable` 会在修改输出前失败
- 正式 application ID 的默认构建仍不含 debuggable 属性
- PowerShell 诊断脚本通过语法解析。

真机验证（Pixel 10 Pro / Android 16）：

- Debug V1 以同 application ID、同签名覆盖安装 target 30 V1，安装后 APK SHA-256 与云端 artifact 一致
- 当前默认 IME 未改变，首次引导、设置、主题、联系人词典和备份配置数据均保留
- 升级前后私有文件哈希只有原应用启动时本来就会清理的 `UserHistory.en.dict` 消失，其相同内容仍保存在 `Personal.en.dict`，其余文件哈希不变
- `dumpsys package` 明确报告 `DEBUGGABLE`
- `run-as` 成功进入隔离 UID `u0_a456`
- 诊断脚本成功生成包、IME、权限/AppOps、DropBox、私有文件元数据/哈希、meminfo、gfxinfo、进程 maps/FD/线程及 warning/error 日志
- 未发现该包的 crash/ANR，采集时 warning/error 日志为空
- 设备上只保留 target 30 审计包，target 29 已卸载。

## 验收结论

维护者完成基础使用后，verbose 采集能够观察 IME/窗口生命周期、ART/GC、渲染、内存、线程、FD、native maps 和私有文件哈希变化，且没有泄露键入内容、候选、剪贴板、联系人或词典正文。没有发现 crash/ANR；唯一额外错误日志 `Invalid key code: SHOW_MORE_APPS` 来自原版遗留资源，不是 debug 或 target 30 引入。

基础 Debug 模式已验收并冻结。暂不加入 StrictMode 或大量内部事件埋点；后续正常 release-like 审计无法解释问题时，再构建同 target 的 debug 变体辅助定位。

## 分支策略

`feat/audit-debug-mode` 从已经验收的 `feat/target-sdk-30` 创建。Debug 能力通过验证后，后续 target 分支继承「可选构建能力」，但每一级首先构建和验收默认非 debug 包；只有需要深入诊断时才构建同 application ID、同签名的 debug 变体覆盖安装，保留该级测试数据。Target 31 从该已验收分支创建。
