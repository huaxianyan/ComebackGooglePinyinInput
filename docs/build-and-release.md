# 构建、GitHub Actions 与发布流程

## 构建模型

正式构建从固定原始 APK 开始：

```text
原始 APK
→ apktool decode
→ scripts/apply_patches.py
→ patched legacy classes.dex
→ AAPT2 stable resource IDs
→ Compose Material 3 host
→ legacy classes.dex + Compose/AndroidX classes2.dex+
→ zipalign -P 16
→ 正式签名
→ 最终 APK 门禁
```

关键不变量：

- 全部 6,633 个旧公开资源 ID 保持
- patched legacy IME 保持在 `classes.dex`
- Compose/AndroidX 只位于 `classes2.dex` 及以后
- API 17–34 启动不解析现代设置类
- API 35+ 才路由 Compose Material 3 设置
- 默认构建为 release-like、非 debuggable
- 正式 application ID 禁止 Debug
- 原始 native、assets 和英文模型载荷保持
- APK 通过 v1/v2/v3 签名和 16 KiB ZIP alignment。

## 本地工具

需要：

- Python 3.12 或兼容版本
- JDK 17
- Android SDK Platform 36
- Android Build Tools 36.0.0
- apktool 2.12.1
- 与目标安装身份对应的 PKCS#12/JKS keystore。

### 完整 Compose Host 构建

```powershell
$env:MODERN_SETTINGS_KS_PASS = "<store password>"
$env:MODERN_SETTINGS_KEY_PASS = "<key password>"

python scripts/build_modern_settings_host.py `
  --original original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk `
  --work work/local-release-build `
  --output dist/ComebackGooglePinyinInput-arm64-v8a-<version>.apk `
  --application-id com.google.android.inputmethod.pinyin.compat `
  --version-name <version> `
  --version-code <code> `
  --apktool work/tools/apktool.jar `
  --apktool-framework work/apktool-framework `
  --gradle modern-settings/gradlew.bat `
  --sdk <android-sdk> `
  --jdk <jdk-17> `
  --keystore <keystore> `
  --key-alias <alias>
```

不要把密码写入项目文件或命令脚本。正式密钥必须保存在仓库外或 GitHub Actions Secrets 中。

## 静态与最终 APK 门禁

主要脚本：

```text
scripts/verify_modern_settings_runtime.py
scripts/verify_target31.py
scripts/verify_target33.py
scripts/verify_target34.py
scripts/verify_target35.py
scripts/verify_target36.py
scripts/verify_universal_keyboard_header.py
scripts/verify_keyboard_switch_animation.py
scripts/verify_inline_autofill.py
scripts/test_header_platform.py
scripts/test_sensitive_clipboard_compat.py
scripts/generate_rime_sync_smali.py
scripts/test_rime_sync_protocol.py
scripts/verify_stable_resource_ids.py
```

代码变化后至少应执行：

```text
git diff --check
对应专项 verifier/test
从原始 APK 开始的完整重建
最终签名 APK 解码检查
apksigner verify --verbose --print-certs
zipalign -c -P 16 4
```

## GitHub Actions

正式工作流：

```text
.github/workflows/build-release.yml
```

触发规则：

- push 到 `master`：构建、签名、验证并上传 30 天 Artifact
- `workflow_dispatch`：按指定 ref 手动构建，可使用隔离 application ID
- push 与 `version.properties` 匹配的 `v*` Tag：执行全部门禁并创建 GitHub Release。

### Secrets

| Secret | 内容 |
| --- | --- |
| `ANDROID_SIGNING_KEYSTORE_BASE64` | 正式 keystore 的完整 Base64 |
| `ANDROID_SIGNING_STORE_PASSWORD` | keystore 密码 |
| `ANDROID_SIGNING_KEY_PASSWORD` | 私钥密码 |

### Variables

| Variable | 用途 |
| --- | --- |
| `ANDROID_SIGNING_KEY_ALIAS` | 正式 key alias |
| `ANDROID_SIGNING_CERT_SHA256` | 预期正式证书 SHA-256 |
| `ANDROID_APPLICATION_ID` | 正式 application ID |

工作流会在构建前读取 keystore 证书并核对 SHA-256。配置缺失、密码错误、alias 错误、证书不一致、包名错误、Debug 正式包或版本不匹配都会停止发布。

## 分支验证

功能分支应先 push，并使用隔离 ID 触发手动工作流，例如：

```powershell
gh workflow run build-release.yml `
  --ref feat/example `
  -f application_id=com.google.android.inputmethod.pinyin.exampleaudit `
  -f artifact_name=example-audit `
  -f audit_label="Google 拼音功能审计" `
  -f debuggable=false
```

分支 Actions 通过后，再用 `--no-ff` 合并到 `master`。不要把未验收审计包作为正式 Release。

## 版本更新

正式版本身份只在 `version.properties` 中定义：

```text
VERSION_NAME=<x.y.z>
VERSION_CODE=<monotonic integer>
TARGET_SDK=36
RELEASE_TITLE=<feature-first title without version prefix>
```

同时更新：

- `CHANGELOG.md`，包含完整实现、逐级验收记录和兼容边界
- README 中面向用户的当前能力（如有变化）
- `docs/releases/v$VERSION_NAME.md` 中的版本化 Release Notes

Tag 必须精确等于：

```text
v$VERSION_NAME
```

## 版本化 Release Notes 约定

Release 页面只保留开头概括、主要更新、版本身份和链接，不重复放使用说明、真机验收、构建与兼容范围。详细内容统一进入 `CHANGELOG.md`，仓库不再新增每版一个的详情文件。

`docs/releases/v$VERSION_NAME.md` 的结构：

1. 不写 `# Google 拼音输入法 X.X.X` 标题，直接以一段概括开头
2. `## 主要更新`，用少量要点说明用户能感受到的变化
3. 指向 `CHANGELOG.md` 对应条目及相关文档的链接，链接指向该版本标签
4. 非商业兼容维护声明的固定段末

版本身份只保留一份，不重复：

- 新版本不再手写「版本信息」，版本身份由发布工作流构建后追加的「构建信息」小节提供，此时 SHA-256 和源提交才是最终值
- `v1.0.0–v2.0.2` 的历史文件保留已有的「版本信息」，不回填工作流后来才追加的构建信息
- 静态门禁 `scripts/verify_release_notes.py` 会拒绝同一文件里同时出现两份身份小节

固定内容不需要每版重复：

- 跨版本不变的遗留边界（架构、旧 ART 隔离、Inline Autofill 依赖、TalkBack Inline Suggestions、16 KiB page size）统一记录在 [Android 16/17 兼容性记录](compatibility-notes.md)，每版不再重复
- 用户使用步骤写入 README，Release Notes 只链接过去
- 真机验收的详细记录写入 `CHANGELOG.md` 对应条目和各专项设计文档

发布前核对：

- `docs/releases/v$VERSION_NAME.md` 不以 `# ` 标题开头
- 不包含 `## 使用说明`、`## 真机验收`、`## 构建与兼容范围` 等冗长小节
- 至少有一个指向 `CHANGELOG.md` 对应条目的链接
- 静态门禁通过：`python scripts/verify_release_notes.py`

## 正式发布步骤

1. 功能分支 Actions 通过
2. `--no-ff` 合并到 `master`
3. push `master`，等待正式 Artifact 构建通过
4. 下载 Artifact，复核：
   - package/versionCode/versionName/target SDK
   - non-debuggable
   - 正式证书
   - APK SHA-256
   - v1/v2/v3
   - `zipalign -P 16`
   - 最终静态门禁
5. 创建 annotated Tag：

   ```powershell
   git tag -a v<x.y.z> -m "ComebackGooglePinyinInput <x.y.z>"
   git push origin v<x.y.z>
   ```

6. Tag workflow 使用 `v$VERSION_NAME - $RELEASE_TITLE` 创建功能优先标题，并上传 APK 与 `.sha256`。如同名 Release 已经存在，工作流必须失败，不得覆盖已发布资产
7. 按 [中文文案与排版规范](chinese-copywriting-style.md) 核对 Release 标题和版本化正文，再检查资产名称
8. 从 Release 页面重新下载资产，复核 SHA-256、签名和 alignment
9. 只有全部一致时，记录发布完成

不要手工复用本地未验证 APK 替代 Actions 产物。

## 发布资产

命名规则：

```text
ComebackGooglePinyinInput-arm64-v8a-<version>.apk
ComebackGooglePinyinInput-arm64-v8a-<version>.apk.sha256
```

Release 标题：

```text
v<version> - <主要功能>
```
