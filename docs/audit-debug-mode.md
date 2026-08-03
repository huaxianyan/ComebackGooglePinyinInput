# 隔离审计包 Debug 模式

## 目的

Target SDK 逐级审计需要同时保留两类证据：

1. **release-like 验收包**：默认、非 debuggable，用于判断真实 target 行为和正式版兼容性；
2. **debug 诊断包**：显式启用，仅用于在同一 target 上通过 `run-as`、JDWP、Perfetto/heapprofd 和更完整的进程信息定位问题。

Debug 包不能替代 release-like 验收。`android:debuggable=true` 可能改变 JIT、调试器附加和部分运行时策略，因此每一级最终是否通过仍以默认非 debug 包为准。

## 安全边界

- Debug 模式默认关闭。
- `scripts/apply_patches.py --debuggable` 遇到正式 application ID `com.google.android.inputmethod.pinyin.compat` 时直接失败。
- GitHub Actions 同样拒绝“正式 application ID + debuggable”组合。
- 正式分支/tag 的普通构建不传入 debug 参数，Manifest 不包含 `android:debuggable="true"`。
- Debug 包继续使用隔离的 target 审计 application ID 和“Google 拼音输入法（测试版）”显示名称。
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

- `application_id`: 隔离审计 ID；
- `artifact_name`: 明确带 `debug`；
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

- 包、版本、target SDK、权限和 AppOps；
- 当前/已启用 IME 和 InputMethodManager 状态；
- DropBox 中属于该包的 crash/ANR；
- `run-as` 可见的私有文件名称、大小、时间和 SHA-256，不读取正文；
- 进程内存、图形、线程、FD、native maps；
- 当前进程 warning/error 日志。

默认不采集 verbose 日志。确有需要时可显式使用：

```powershell
./scripts/capture_audit_diagnostics.ps1 `
  -Package com.google.android.inputmethod.pinyin.target30audit `
  -IncludeVerboseLog
```

Verbose 日志在分享前必须人工检查。脚本不会自动生成完整 bugreport，也不会读取剪贴板、词典正文、联系人正文或 SharedPreferences 正文。

## 分支策略

`feat/audit-debug-mode` 从已经验收的 `feat/target-sdk-30` 创建。Target 31 暂不创建。Debug 能力通过验证后，后续 target 分支继承“可选构建能力”，但每一级首先构建和验收默认非 debug 包；只有需要深入诊断时才构建同 application ID、同签名的 debug 变体覆盖安装，保留该级测试数据。
