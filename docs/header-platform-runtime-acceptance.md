# Header Platform 与 Inline Autofill 运行时验收

## 状态

`feat/header-platform` 已在隔离、release-like、非 debuggable 包中完成当前范围内的静态、构建和 Pixel 10 Pro / Android 16 运行时验收。

这不等于已经合并、发布或替换正式包。正式基线仍是：

```text
package=com.google.android.inputmethod.pinyin.compat
version=v2.0.2
```

当前最终组合验收包：

```text
file=work/header-platform-compose-diag-v53/header-platform-compose-diag53.apk
package=com.google.android.inputmethod.pinyin.headerplatformcomposeaudit
versionName=2.0.2-header-platform-compose-diag53
versionCode=4520477
minSdkVersion=17
targetSdkVersion=36
debuggable=false
SHA-256=7a170a21ba09d536323984a2a9be6d077289769e2e7d2435e7aa99fa93881170
```

## 已确认实现

### 平台边界

- 每个可承载 Candidate 的通用 Header 只有一个 `HeaderPlatformHostView`。
- Clipboard、Inline Autofill 和未来的本地 Action 通过统一模块、会话、仲裁、renderer、theme、placement 和 cleanup 合约接入。
- 平台统一接入协议，不统一数据模型：

  ```text
  Clipboard       -> 真实 NATIVE_CANDIDATE
  Inline Autofill -> Framework REMOTE_SURFACE
  project action  -> NATIVE_ACTION
  ```

- Clipboard 继续走原生 Candidate 的提交、关闭、脱敏和完整 payload 路径。
- Inline Autofill 继续托管 `InlineSuggestion` / `InlineContentView`，不读取 Provider 正文、`AutofillValue`、Dataset ID 或凭据，不转换为 Candidate，也不调用 `commitText()`。
- Header chrome 来自原生 Candidate factory 和运行时 show-more divider，不使用手工取色、近似 Drawable、假 Candidate 或 Provider/设备偏移。

### 仲裁

最终优先级为：

```text
普通原生 Candidate
> Clipboard quick-paste Candidate
> Inline Autofill
> idle Header
```

Clipboard Candidate 出现时，Inline contribution 保持有效但不可见、不可交互；Clipboard 被提交或关闭后，仍属于当前 editor/Header/session 的 Inline contribution 自动恢复。仲裁不检查 Clipboard 正文，也不猜测 TOTP。

### Inline Surface 生命周期

- editor session、Header identity 和 render generation 分离并单调递增。
- 晚到的 response、inflate callback 和 render plan 必须同时匹配当前 editor、Header 和 generation。
- `InlineSuggestion.inflate()` 使用 `WRAP_CONTENT x WRAP_CONTENT`，避免主题/方向切换后不可变 request 尺寸冲突。
- 异步 inflate 保留 Provider 顺序、1.2 秒有界聚合，并允许发布按原索引排列的有效部分结果。
- 只有当前 Surface 可见、可点击、可聚焦并参与无障碍。其他 Surface 保持 mounted 但 invisible、clipped、disabled、non-focusable 且不提供无障碍 action。
- IME Window 暂时隐藏不是 editor session 结束，不会仅因 `onFinishInputView()` 或 `onWindowHidden()` 清除仍有效 editor 的 Inline 状态。真正的 `onFinishInput()`、新 editor、Header 替换和 service 销毁负责最终失效。
- 嵌入 Surface 的裁剪使用 View ancestry 的局部坐标转换：

  ```java
  content.offsetRectIntoDescendantCoords(child, childRect);
  childRect.intersect(0, 0, child.getWidth(), child.getHeight());
  ```

  不混用 `getLocationOnScreen()` 与普通 View global rect。

### 主题策略

request foreground 来自真实原生 Candidate 渲染链：

```text
PinyinIME.a()
-> fresh IKeyboardTheme
-> applyToContext(isolated)
-> native bbc LayoutInflater
-> inflate softkey_candidate
-> label.getCurrentTextColor()
```

该颜色只用于构造新的 AndroidX Inline Style Bundle，不用于辨认 response，也不直接重绘 Provider remote View。

Android 公共 API 没有提供把返回 Surface 可靠关联到原主题 request 的 identity。`diag40`–`diag42` 证明精确颜色和 `IKeyboardTheme.getViewStyleCacheKey()` 都会把有效 response 误判为过期。因此最终实现不做 theme-response identity rejection。Framework 复用旧不可变 request 时，remote Surface 可能暂时保留旧主题前景色；这是已接受的低概率视觉限制，优先级低于 Autofill 可用性。

### Rails

- 所有非空 Inline contribution 都保留左右 rails。一项建议时，两侧保持 mounted 但 disabled、不可点击、不可聚焦且无无障碍 action。
- Clipboard 和 Autofill rails 共用真实运行时 show-more Candidate divider 的 Drawable、有效 alpha、padding、scale type 和 ancestor alpha 补偿。
- 源 divider 尚未测量时，Clipboard rails 先 `INVISIBLE`，通过一次性 `OnPreDrawListener` 在有效尺寸后同步并显示，避免主题/方向切换后的 `1 x 1` 「两个小点」。

### 密码键盘高度

最终没有保留 `diag49`–`diag51` 的实验缩放路径。密码几何直接恢复正式版 `v2.0.2` 已验收实现，以下文件与 `v2.0.2` Tag 字节一致：

```text
patches/java/com/google/android/inputmethod/pinyin/PasswordBodyView.java
patches/smali/PasswordBodyView.smali
patches/res/layout/keyboard_password_body.xml
```

标准为：

```text
ordinary total = fixed universal Header + scaled ordinary Body
password total = fixed universal Header + scaled ordinary Body + fixed Header-sized digit row
```

原生 Header 不参与用户键盘高度比例缩放，方向和设备资源 qualifier 仍可选择不同的 Header 基准高度。密码数字行迁入 Body 后，由 `PasswordBodyView` 在 framework 已缩放普通 Body 后增加一个固定 Header 高度。没有 `onMeasure()` 覆盖、实验 dimension 或 `KeyboardViewHelper.scaleFrameworkHeight()` 注入。

## 诊断版本结论

```text
diag42:
  theme cache-key gate 仍拒绝有效 response；失败

diag43:
  移除不可实现的 theme-response rejection；Autofill 和字段切换通过

diag44:
  Clipboard Candidate 优先于 Inline，关闭/提交后恢复 Inline；通过

diag45:
  Clipboard divider 几何与 Autofill 对齐；主题颜色仍不同

diag46:
  Clipboard divider 改用运行时 show-more snapshot；首次布局出现 1x1 点
diag47:
  OnPreDraw 延迟同步修复首次布局；主题/方向 rails 通过

diag48:
  仅内容无关的密码几何诊断，确认普通/密码底行有 3 px 差异
diag49:
  onMeasure + theme resource 高度压缩整个密码键盘；失败并移除
diag50:
  完整复用 qwerty inner 后默认高度接近，非默认高度仍有差异
diag51:
  framework 缩放公式数学等价，但不是正式版同一路径
diag52:
  恢复 v2.0.2 原始密码实现；Header/Clipboard/Autofill 与配置矩阵通过
diag53:
  在 diag52 当前补丁基础上加入完整 Compose Material 3/AndroidX；
  设置与主 DEX IME 最终组合运行时通过
diag54:
  “其他 → 关于”增加公开 GitHub 仓库入口；显示、ACTION_VIEW 跳转和返回通过
```

## `diag52` 运行时验收

设备：

```text
Pixel 10 Pro
Android 16 / API 36
```

维护者确认通过：

- 普通与密码键盘在非默认及另一高度档位的行几何
- 密码键盘仅比普通键盘多一个固定数字/Header 行
- 图片主题、浅/深主题、横竖屏和当前导航模式
- Header 替换、中文/英文/密码/手写路径
- Clipboard 样式、首次布局、原生优先级和 dismiss-to-Inline 恢复
- Inline Autofill 单项/多项、字段切换、跨网页 session 隔离及 Framework click
- Bitwarden 已解锁、认证 Activity 返回与取消
- 旧 Surface 不跨 editor/Header/session 残留。

数字/电话键盘本轮没有重新找到 App 场景触发，不能记为本轮运行时通过。其 Body、key mapping 和触摸语义未被 Header Platform 修改，静态契约和既有正式版验收继续通过，因此分类为「继承既有验收、低风险、非阻塞」。

运行证据：

```text
work/header-platform-diag-v52/runtime-core-acceptance/
work/header-platform-diag-v52/runtime-editor-session-acceptance/
work/header-platform-diag-v52/runtime-bitwarden-activity-acceptance/
work/header-platform-diag-v52/runtime-configuration-acceptance/
```

## `diag53` 完整 Compose 组合验收

构建和产物门禁：

- official Compose Material 3 runtime verifier 通过
- Compose JVM 单元测试通过
- release-like、非 debuggable
- API 31/33/34/35/36 门禁通过
- 6,633 个旧公开资源 ID 全部保持
- `classes.dex` 保留 patched legacy IME，Compose/AndroidX 位于 `classes2.dex` 和 `classes3.dex`
- primary DEX 只以字符串和 Manifest 查询路由 `ModernSettingsActivity`
- AndroidX Startup、ProfileInstaller 和 `appComponentFactory` 自动入口不存在
- `res/raw/main_en_d3_20160715.gzip` 和 `res/raw/metadata.json` 保持 `ZIP_STORED`
- Header、Clipboard、Inline Autofill 最终 DEX 门禁通过
- v1/v2/v3 签名与 `zipalign -P 16` 通过。

API 36 运行时确认：

- Compose Material 3 首页、四个顶层页面和嵌套路由
- Toolbar Back、系统 Back、对话框和无破坏性 Slider
- 词典页面仅只读检查，未执行清除
- 浅/深色与横竖屏
- 同包主 DEX IME 的中文 Candidate/翻页、英文、密码几何
- Inline Autofill、Clipboard 接管/恢复、rails、IME 隐藏/重显和方向切换
- 无 `FATAL EXCEPTION`、`VerifyError`、`NoClassDefFoundError`、`IllegalAccessError`、`ClassNotFoundException` 或 `Resources$NotFoundException`。

运行证据：

```text
work/header-platform-compose-diag-v53/runtime-compose-settings-acceptance/
work/header-platform-compose-diag-v53/runtime-integrated-ime-acceptance/
```

## Inline Autofill 六项建议补充验收

在 `v2.0.3` 发布后的独立修复分支中，将 Inline Autofill 的 presentation spec 数量与建议总上限拆分：

```text
presentation specs = 3
max suggestion count = 6
```

Android 会对超出 spec 列表的建议复用最后一个 spec，因此无需为六项建议创建六套重复规格。请求值 `6` 是当前 Bitwarden 行为下获得完整 Inline 集合的最小值：最多五个凭据建议，加一个 Provider 保留的 Vault 入口；请求更大的值不会增加 Bitwarden 的凭据上限。

Pixel 10 Pro / Android 16 上使用 Bitwarden `2026.7.0` 和具有七条匹配记录的网站完成运行时验收：Header 可按 Provider 顺序浏览五个凭据建议和一个 Vault 入口，维护者随机点击其中一个凭据后由 Framework/Bitwarden 正常完成填充。此次修复不改变单项可见 carousel、Framework-owned click、Provider 顺序、Clipboard 仲裁、Surface 裁剪、过期 callback 拒绝或隐私边界。

验收包为隔离、release-like、非 debuggable 包：

```text
package=com.google.android.inputmethod.pinyin.inlinesixaudit
versionName=2.0.3-inline-six-audit1
versionCode=4520389
targetSdkVersion=36
SHA-256=aca5d5e5a250b27a6c76ddb5be5e00dffe9bf5f9d08411ea47a636a6859ebfa1
```

该包通过从原始 APK 开始的 apktool/Compose 完整重建、6,633 个旧资源 ID、legacy primary DEX、API 31/33/34/35/36、Header/Clipboard/Inline、v1/v2/v3 签名和 16 KiB ZIP alignment 门禁。验收结束后已恢复测试前默认输入法并卸载隔离包，Bitwarden Autofill Provider 保持不变。

## API 与上游边界

- API 35+ Compose 路由已在 API 36 真机运行时通过。
- API 17–34 继续使用旧 Preference 设置，最终 APK 的 primary DEX、Manifest gate 和 class-reference 隔离已静态通过。
- 既有 API 34 translated ARM64 环境已验证同一 Compose Host 模型可启动旧 `SettingsActivity`，但本轮 `diag53` 未重新执行该模拟器运行测试。
- API 17–20 没有 arm64 应用 ABI，API 17 只能作为静态门禁。
- API 23 x86_64 环境没有 ARM translation，ARM64 Emulator 又受当前 x86_64 主机限制，旧 ART 真机覆盖仍为环境阻塞，不能描述成运行时通过。
- `supportsInlineSuggestionsWithTouchExploration` 继续不声明，等待独立 TalkBack 验收。
- App/Provider/Framework 行为若可用 Gboard 复现，不增加 IME workaround。包括部分闪烁、旧 Autofill session 不刷新、填充删除后 Dataset 消失及 Bitwarden task-stack 行为。

## 提交前清理

`diag36`–`diag42` 使用的 `HeaderThemeDiagnostics` 只用于比较 request 与原生 Candidate 的颜色类别。最终策略已明确不以颜色或 theme cache key 识别 response，因此提交前已删除该类、Java/Smali 调用和对应 verifier 要求。生产路径继续使用真实 Candidate foreground 构造新 request 的 Style Bundle，但不保留颜色比较日志或 process-global 诊断状态。

现代设置「其他 → 关于」新增公开仓库入口：

```text
https://github.com/huaxianyan/comeback-google-pinyin-input
```

中英文标题分别为「GitHub 仓库」与「GitHub repository」，副标题显示完整 URL，点击使用标准 `ACTION_VIEW`。该入口不读写 Preference、不增加权限，且只属于 API 35+ Compose 设置页面。`diag54` 已在 Pixel 10 Pro / API 36 验证显示、浏览器跳转和返回设置页。

## 发布边界

当前结果支持进入代码审查和提交整理，但不自动授权：

- commit
- merge
- push
- Tag
- GitHub Release
- 正式包覆盖安装或发布。

上述操作仍需维护者明确授权。
