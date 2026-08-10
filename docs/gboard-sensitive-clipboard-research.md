# Gboard 敏感剪贴板候选研究

## 目标

研究 Gboard 如何在密码、PIN、TOTP/一次性验证码等场景继续提供剪贴板粘贴，同时避免在键盘候选栏以明文展示敏感内容；据此定义 Google 拼音兼容版下一阶段的安全边界。

本阶段只做研究和设计，不修改正式输入法行为。

## 样本与证据

Gboard 样本：

```text
package=com.google.android.inputmethod.latin
versionName=17.8.4.939743344-release-arm64-v8a
versionCode=175894542
target/compile SDK=37
```

本地证据：

```text
work/research/gboard-current-public/decoded-base/smali/fku.smali
work/research/gboard-current-public/decoded-base/smali/fjc.smali
work/research/gboard-current-public/decoded-base/smali/fje.smali
work/research/gboard-current-public/decoded-base/smali/fjf.smali
work/research/gboard-current-public/decoded-base/smali_classes2/fjd.smali
work/research/gboard-current-public/decoded-base/smali_classes2/fki.smali
work/research/gboard-current-public/decoded-base/smali_classes2/flk.smali
```

Android 官方指南：

```text
https://developer.android.com/privacy-and-security/risks/secure-clipboard-handling
```

## 已确认事实

### 1. Android 的敏感标记是来源应用提供的结构化信号

Android 官方建议复制密码、银行卡等敏感内容的应用在 `setPrimaryClip()` 前设置：

```text
ClipDescription.EXTRA_IS_SENSITIVE
```

其底层兼容键为：

```text
android.content.extra.IS_SENSITIVE
```

官方说明该信号用于对键盘 GUI 内的剪贴板内容预览进行视觉混淆，避免明文被旁观、截图或录屏获取。使用 API 33 SDK 时可引用公开常量；较低 compile SDK 可使用同一个字面键。

这个标记表达的是“内容来源认为它敏感”，与当前目标输入框是否为密码框是两条独立信号。

### 2. Gboard 不丢弃敏感 ClipData，而是把敏感状态写入模型

`fku.c(Context, ClipData, ClipDescription, boolean)` 读取第一项文本和时间戳，并在 SDK 33+ 检查：

```text
ClipDescription.getExtras()
  ["android.content.extra.IS_SENSITIVE"]
```

结果经 `fjd.c(boolean)` 写入 `fje` 剪贴板模型。该模型仍保留真实文本供点击提交；敏感布尔值只控制显示和可访问性呈现。

因此 Gboard 的基本模型是：

```text
Clipboard item = 完整提交值 + 显示值 + sensitive 状态 + 时间戳/类型
```

而不是：

```text
sensitive=true → 整条建议被删除
```

### 3. Gboard 同时考虑来源敏感标记和目标密码输入框

`fjc.b(...)` 根据 `EditorInfo.inputType` 判断目标是否为密码输入：

- `TYPE_TEXT_VARIATION_PASSWORD` (`0x80`)；
- `TYPE_TEXT_VARIATION_WEB_PASSWORD` (`0xe0`)；
- 数字密码（由其 `EditorInfo` helper 判断，平台 variation 为 `0x10`）。

密码输入时只取当前剪贴板列表的第一项，并强制按敏感样式创建 AutoPaste chip，即使来源应用没有设置敏感标记。

非密码输入时，只有模型自身 `sensitive=true` 才使用敏感样式。

可概括为：

```text
masked = sourceMarkedSensitive || destinationIsPassword
```

`TYPE_TEXT_VARIATION_VISIBLE_PASSWORD` (`0x90`) 没有进入上述 Gboard 强制密码掩码分支；如果来源本身标记敏感，仍应按来源信号脱敏。

### 4. Gboard 的视觉掩码是等长圆点，点击仍提交原文

完整剪贴板和 AutoPaste chip 两条渲染路径都会在敏感状态调用：

```text
flk.b(original)
```

该方法按 Java `String.length()` 重复 U+2022：

```text
•
```

也就是显示与 UTF-16 code unit 数量等长的圆点串。AutoPaste chip 的点击监听器仍持有原 `fje` 模型并提交完整内容，显示文本不是提交 payload。

Gboard 还为敏感 AutoPaste chip 设置通用 content description，而不是把原始文本交给 TalkBack。

### 5. TOTP 不是由剪贴板模块计算出来的

这里的“TOTP 支持”准确含义是：

- 用户已从认证器、密码管理器或其他应用复制一次性代码；
- Gboard 将该现有剪贴板文本作为可点击建议提交；
- 来源设置敏感标记，或目标是数字密码/PIN 输入框时，候选显示为掩码。

Gboard 的这条路径不读取 TOTP seed、不生成验证码，也不应与 Android Autofill、SMS OTP、SMS Retriever 或 Credential Manager 混为一谈。

单凭“4–8 位数字”猜测 TOTP 会误伤 PIN、金额、年份和普通数字，因此没有证据支持增加纯正则敏感分类。

## 当前 Google 拼音兼容版的差距

当前实现位于：

```text
patches/smali/ClipboardCandidateCompat.smali
```

现状：

1. `isEditorAllowed()` 直接拒绝文本密码、可见密码、Web 密码和数字密码输入框；
2. `refresh()` 检测到 `android.content.extra.IS_SENSITIVE=true` 后直接丢弃候选；
3. Candidate 的屏幕文本、可访问性描述和点击 payload 在创建时都由同一原文派生；
4. `candidateKey` / `dismissedKey` 当前包含 `text + timestamp`，允许敏感内容后不应继续把明文复制到长期静态去重键；
5. `ClipDescription.getExtras()` 在旧系统上的 API 可用性还需要显式版本门控，不能只依赖当前 target 36 构建成功。

所以目前不是“少一种样式”，而是模型边界不完整：它只能表达“显示并提交同一明文”或“不显示”，不能表达“掩码显示、完整提交”。

## 建议的兼容模型

### 1. 分离四个概念

```text
payloadText       完整提交值，只在点击时写入目标输入框
displayText       普通文本或脱敏占位符
accessibilityText 不包含敏感原文的通用说明
sensitive         来源标记或目标密码语义的解析结果
```

不得用掩码后的 `displayText` 作为提交值，也不得把完整 payload 拼进 content description、日志、诊断或 View tag。

### 2. 建议状态表

| 来源敏感 | 目标输入框 | 是否建议 | 显示 | 点击提交 |
|---|---|---:|---|---|
| 否 | 普通文本/数字 | 是 | 原文 | 完整原文 |
| 是 | 普通文本/数字 | 是 | 掩码 | 完整原文 |
| 否 | 文本/Web/数字密码 | 是 | 掩码 | 完整原文 |
| 是 | 文本/Web/数字密码 | 是 | 掩码 | 完整原文 |
| 任意 | `disableAutoPaste` | 否 | 无 | 无 |
| 任意 | 不支持的非文本 ClipData | 否 | 无 | 无 |

`TYPE_TEXT_VARIATION_VISIBLE_PASSWORD` 建议按平台语义处理：来源不敏感时可显示原文，来源敏感时仍脱敏。不要因为名称包含 password 就覆盖应用明确要求“visible”的编辑语义。

### 3. 掩码长度的安全取舍

Gboard 使用与 `String.length()` 等长的圆点，优点是行为一致、用户能区分短验证码和长密码；缺点是泄露密码长度，而且超长敏感内容会产生很长的掩码字符串。

Google 拼音兼容版有两个可选方案：

```text
A. Gboard 等价：min(original UTF-16 length, visual cap) 个圆点
B. 更少泄露：固定 6 个圆点，不暴露原始长度
```

从安全和旧候选栏布局稳定性出发，初步推荐 B：

```text
••••••
```

TOTP 常见长度也能自然匹配；无障碍描述使用“粘贴敏感剪贴板内容”，不朗读圆点数量或原文。是否必须与 Gboard 等长显示，需要在实现前由维护者确认。

### 4. 去重与内存边界

- `candidateKey` 和 `dismissedKey` 改为不含明文的有界标识，例如 `timestamp + length + process-local digest/hash`；
- Candidate 活动期间仍必须持有完整 payload 才能提交，但 `stop()`、点击完成、关闭建议和剪贴板更新时应立即清除引用；
- 不落盘、不进入 SharedPreferences、不进入备份、不进入日志；
- 不加入学习、词频或候选模型；
- 不自动清除系统剪贴板，因为所有权和生命周期属于来源应用/系统，关闭按钮仍只撤下本条建议。

### 5. API 兼容

- API 33+ 可使用公开敏感语义；实现仍用稳定字面键，避免 primary DEX 在旧 ART 解析新字段；
- 调用 `ClipDescription.getExtras()` 前必须按其真实 API floor 做版本门控；
- API 17–旧 floor 继续允许普通剪贴板文本，但不能调用不存在的 extras API；
- API 29+ 的系统剪贴板访问限制和默认 IME 特权保持由系统管理，不增加后台服务或常驻读取路径。

## 不采用的方案

### 直接继续过滤敏感内容

拒绝。它阻止用户在密码/PIN/TOTP 场景使用候选粘贴，与目标功能相反，也不同于 Gboard 的模型。

### 根据文本正则猜测密码或 TOTP

拒绝。纯数字、长度、字符复杂度都不足以可靠判断敏感性，会产生大量误判。优先信任来源 `EXTRA_IS_SENSITIVE` 和目标 `EditorInfo.inputType`。

### 只在密码框开放，但明文显示候选

拒绝。来源应用漏标敏感内容很常见；目标密码语义本身已经足以要求脱敏。

### 把掩码字符串写入输入框，再读取剪贴板二次替换

拒绝。点击必须一次性提交已持有的完整 payload，不能依赖点击时系统剪贴板仍未变化，也不能制造可见的中间错误状态。

## 建议实施顺序

1. 在独立分支建立纯模型测试，先验证 `sourceSensitive || destinationPassword` 规则；
2. 扩展 Candidate 创建为“显示/无障碍/payload”分离；
3. 对敏感标记读取增加旧 API 门控；
4. 允许文本、Web 和数字密码输入框，同时继续尊重 `disableAutoPaste`；
5. 把去重键改为不含原文；
6. 保留现有候选栏原生样式、关闭键、完整 payload 提交和普通候选让位状态机；
7. 在隔离 `clipboardaudit` 包上做受控、虚构数据测试，不使用真实密码、真实 TOTP seed 或真实账户验证码；
8. 通过后再决定是否覆盖正式包。

## 验收矩阵

至少使用明确标注为测试数据的样本：

```text
普通文本：example clipboard text
测试密码：Correct-Horse-Test-Only
测试 TOTP：123456
测试 PIN：482951
```

验证：

- 普通输入框 + 普通 Clip：明文显示、完整提交；
- 普通输入框 + sensitive Clip：掩码显示、完整提交；
- 文本密码框 + 未标 sensitive：掩码显示、完整提交；
- Web 密码框 + 未标 sensitive：掩码显示、完整提交；
- 数字密码框 + `123456`：掩码显示、提交 `123456`；
- 普通数字框 + 未标 sensitive 的 `123456`：按普通数字显示，不擅自猜测 TOTP；
- 普通数字框 + 标 sensitive 的 `123456`：掩码显示、提交 `123456`；
- `disableAutoPaste`：完全不显示；
- TalkBack：不朗读敏感原文；
- 点击、关闭、剪贴板变化、IME 隐藏、进程重建后不残留旧敏感候选；
- 中文、英文、手写、九键、横屏、三按钮/手势导航和主题切换不回归；
- crash/ANR/VerifyError 为 0，诊断日志不包含测试 payload。

真实账户密码、真实 TOTP 和真实私密剪贴板不用于开发诊断或日志采集。
