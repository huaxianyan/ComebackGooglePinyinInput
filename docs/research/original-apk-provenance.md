# 原始 Google 拼音 APK 来源与完整性

## 用途

本仓库保存 Google 拼音输入法 4.5.2 的 `arm64-v8a` 原始 APK，用于软件保存、兼容性研究和可复现构建。正式兼容 APK 始终从该固定输入应用补丁，而不是以某次临时解码目录作为唯一源码。

## 原始版本

| 项目 | 内容 |
| --- | --- |
| 产品名称 | Google Pinyin Input / Google 拼音输入法 |
| 原始版本 | `4.5.2.193126728` |
| 原始包名 | `com.google.android.inputmethod.pinyin` |
| 架构 | `arm64-v8a` |
| 原始 target SDK | 26 |
| 文件 | `original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk` |
| APK SHA-256 | `980fd0f4695f683648e6f7ab9a15a24732e8957b5b14b25d49af931176574bd7` |
| 签名主体 | `OU=Google, Inc, O=Google, Inc, L=Mountain View, ST=CA, C=US` |
| 签名证书 SHA-256 | `3D:7A:12:23:01:9A:A3:9D:9E:A0:E3:43:6A:B7:C0:89:6B:FB:4F:B6:79:F4:DE:5F:E7:C2:3F:32:6C:8F:99:4A` |

Google 拼音输入法最初由 Google 发布，并曾通过 Google Play 等官方 Android 分发渠道提供。上述哈希和官方签名证书信息用于独立核对仓库中输入文件的完整性，不表示 Google 对本项目提供认可或支持。

## 校验

PowerShell：

```powershell
(Get-FileHash `
  original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk `
  -Algorithm SHA256
).Hash.ToLowerInvariant()
```

预期结果：

```text
980fd0f4695f683648e6f7ab9a15a24732e8957b5b14b25d49af931176574bd7
```

GitHub Actions 在每次构建前也会校验固定 SHA-256，不匹配时立即停止。

## 正式兼容包的身份边界

项目正式包使用：

```text
Application ID: com.google.android.inputmethod.pinyin.compat
```

它采用项目自己的签名证书，不能覆盖 Google 官方证书签名的原始包。二者可以并存。正式项目证书必须在后续版本中保持不变，否则 Android 不允许覆盖升级已有兼容版。

## 权利说明

原始程序、资源、词库、Google 名称、标志和相关商标的权利归 Google LLC、Google Inc. 或其各自权利人所有。原始 APK 保持其原有版权状态，本仓库收录它不改变任何权利归属。
