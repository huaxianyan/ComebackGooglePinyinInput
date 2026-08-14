# Gboard Inline Autofill 实现原理与 Google 拼音接入边界

## 1. 目标与结论

本文研究 Android 11+ 的 Inline Suggestions / Autofill 协议、Gboard 当前公开 APK 的实现方式，以及如何将该能力接入本项目已经完成的统一键盘 Header。

核心结论：

1. **IME 不读取密码管理器数据库，也不请求账户、密码、TOTP seed 或银行卡正文。** IME 只向 Android Autofill Framework 声明自己能承载怎样的 Inline UI。
2. **IME 不会拿到建议正文。** Autofill 服务在其他进程中渲染建议，IME 得到的是由 `SurfaceControlViewHost.SurfacePackage` 承载的 `InlineContentView`。IME 可以读取 `source`、`type`、`isPinned` 和 `autofillHints` 等元数据，但不能遍历远端 View 树取得密码文本。
3. **IME 不负责提交 Autofill payload。** 用户点击远端建议后，Autofill Framework / Autofill 服务完成认证、字段填充或 action 启动；IME 附加的点击监听只用于本地 UI 收尾和统计，不应调用 `InputConnection.commitText()`。
4. **现有统一 Header 是正确入口，但 `FixedSizeCandidatesHolderView` 不是正确渲染器。** Autofill 返回的是任意 `InlineContentView`，不是 Google 拼音 `Candidate`。Header 中应增加独立、可裁剪的 Inline Autofill host 层，与原生 Candidate holder 互斥显示。
5. **API 30 以下不参与此协议。** API 17–29 继续走现有原生输入和系统旧式 Autofill 菜单；不得为旧系统引入启动期类解析风险。

适用边界：本文讨论 Android 标准 Inline Suggestions 协议，不讨论让输入法自行读取密码管理器、模拟密码管理器 UI、猜测验证码、解析网页凭据或实现自有账户同步。

> **实现状态更新：** 本文第 5–7 节保留了阶段 A/B 早期方案与研究推导，其中独立 process-global `InlineAutofillClipHost`、自由横向滚动和「Inline 优先于空闲 Clipboard」的提案已经被统一 Header Platform 取代。当前实现使用每个 Header 一个 `HeaderPlatformHostView`、`InlineAutofillHeaderModule`、remote-surface renderer、固定 previous/next rails 和集中仲裁；真实 Clipboard Candidate 优先于 Inline。最终契约与运行证据以 [`header-platform-design.md`](header-platform-design.md) 和 [`header-platform-runtime-acceptance.md`](header-platform-runtime-acceptance.md) 为准。

## 2. Android 官方协议

### 2.1 启用条件

Android 11 / API 30 开始支持 IME 内联展示 Autofill 建议。IME 的 input-method XML 必须声明：

```xml
<input-method
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:supportsInlineSuggestions="true" />
```

如果当前 IME 或当前 Autofill 服务任一方不支持 Inline Suggestions，平台回退到 Android 10 及更早版本的系统菜单展示方式。

Gboard 17.8.4 的公开 APK 也在 `res/xml/method.xml` 中声明了同一属性。它没有声明 `supportsInlineSuggestionsWithTouchExploration`，说明至少该样本没有承诺在 TalkBack touch exploration 开启时托管 Inline Suggestions。

### 2.2 完整时序

已确认的框架流程如下：

1. 用户聚焦支持 Autofill 的输入框，例如用户名、密码、信用卡或地址字段。
2. App 通过标准 `autofillHints`、输入类型和 View structure 向 Android Autofill Framework 描述字段；IME 不直接查询 App 字段或密码管理器。
3. 平台确认当前 IME 与用户选择的 Autofill 服务是否都支持 Inline Suggestions。
4. 在 `inputStarted` 之后，平台调用 IME：

   ```java
   InputMethodService.onCreateInlineSuggestionsRequest(Bundle uiExtras)
   ```

5. IME 返回 `InlineSuggestionsRequest`，其中包括：
   - 期望的最大建议数
   - 一个或多个 `InlinePresentationSpec`
   - 每个 spec 允许的最小/最大尺寸
   - 可选的样式 Bundle
   - 可选的受支持 Locale。
6. 平台把该 request 交给 Autofill 服务。服务按 request 生成 `Dataset` 和 `InlinePresentation`，但敏感正文不交给 IME。
7. 平台调用：

   ```java
   InputMethodService.onInlineSuggestionsResponse(
       InlineSuggestionsResponse response)
   ```

8. IME 读取 `response.getInlineSuggestions()`，对每个 `InlineSuggestion`调用一次：

   ```java
   suggestion.inflate(context, size, executor, callback)
   ```

9. inflate 异步返回 `InlineContentView`，IME 将其放入建议栏。点击后的认证、填充和 action 由远端 Autofill 链路执行。
10. 空 response、输入会话结束、Header 销毁、配置切换或更新 response 到来时，IME 清理旧 View 和异步状态。

### 2.3 Request 约束

`InlineSuggestionsRequest` 的关键规则：

- presentation spec 列表不能为空
- `maxSuggestionCount` 必须不少于 spec 数量
- spec 少于最大建议数时，最后一个 spec 用于余下建议
- AOSP 源码明确建议最大建议数实际不要超过 **5**，以控制性能成本
- `hostPackageName`、IME host input token 和 display ID 由系统设置，IME 不应伪造
- target SDK 31+ 未显式设置 Locale 时，默认是空 `LocaleList`
- style/extras 中的远程对象在跨进程前会被平台过滤。

### 2.4 Inflate 约束

`InlineSuggestion.inflate()` 的关键规则：

- 同一个 `InlineSuggestion`实例只能调用一次 `inflate()`；重复调用会抛出 `IllegalStateException`
- 请求尺寸的每个维度必须位于对应 spec 的 min/max 之间，或者使用 `WRAP_CONTENT`
- 回调可能异步返回 `null`
- `InlineContentView` 的实际 LayoutParams 由远端内容尺寸决定
- 远端进程通过 `SurfacePackage`提供内容，View attach/detach 后的 Surface 更新由框架内部管理
- IME 可以设置 `OnClickListener` / `OnLongClickListener` 接收远端点击通知，但这不是 payload 提交入口。

### 2.5 隐私与信任边界

Android 开发者文档明确指出，Inline Autofill 可能包含密码和信用卡等私密信息，因此内容在用户选择前对 IME 隐藏。AOSP 实现进一步证明：

```text
Autofill service / system server
        │
        │ SurfaceControlViewHost.SurfacePackage
        ▼
IME process: InlineContentView
```

IME 本地拥有的是远端 Surface 宿主，不是包含密码文本的本地 `TextView`。因此正确实现必须：

- 不截图、OCR 或像素分析 Inline Surface
- 不尝试遍历、反射或复制远端内容
- 不把 Inline UI 转换成 Candidate 文本
- 不记录 `toString()`、可见内容、账户标识或用户选择内容
- 不自行提交、保存、去重或持久化 Autofill payload
- 只记录允许的无内容诊断，例如 response 数量、inflate 成功/失败数、尺寸和会话序号。

`InlineSuggestionInfo`公开的元数据只有：

```text
source       android:autofill / android:platform
type         android:autofill:suggestion / android:autofill:action
isPinned     是否为固定 action
autofillHints 建议数据类别提示
presentationSpec
```

这些元数据不等于凭据正文。即使如此，本项目正式日志也不应记录完整 hints 数组，避免无必要地扩大诊断面。

## 3. Gboard 17.8.4 的当前实现

研究样本：

```text
package=com.google.android.inputmethod.latin
versionName=17.8.4.939743344-release-arm64-v8a
versionCode=175894542
compileSdk=37
```

本节结论来自本地公开 APK 静态解码。混淆类名只作为定位证据，不被视为稳定 API。

### 3.1 服务层只做协议转发

Gboard 主 `InputMethodService` 类 `oqp`直接覆盖两个 API 30 回调：

```text
onCreateInlineSuggestionsRequest(Bundle)
onInlineSuggestionsResponse(InlineSuggestionsResponse)
```

它没有把逻辑堆在 Service 里，而是通过 `orc`代理转发给可选实现 `opv`。没有已初始化实现时，request 返回 `null`、response 返回 `false`。这形成了清晰的「框架回调 → 生命周期代理 → Inline 组件」边界。

对本项目的启示：`PinyinIME`只应保留极窄回调桥，request 构造、异步 inflate、Header 仲裁和清理都放在独立 `InlineAutofillCompat` 中。

### 3.2 Request 构造

Gboard 当前 `fwk.b(Context)` 的已确认行为：

- 先检查内部组件初始化和产品级能力开关
- 使用 Header 高度、chip 高度、密度、内边距和主题值计算 min/max size
- 构造一个 `InlinePresentationSpec`
- style Bundle 使用 AndroidX Autofill Inline UI 版本协议，包含：

  ```text
  androidx.autofill.inline.ui.version:key
  ```

- 将同一 spec 加入 request **9 次**
- `setMaxSuggestionCount(9)`
- 设置当前主要语言和其他活动语言形成的 `LocaleList`。

旧样本中最大 chip 宽度资源为 `240dp`，高度来自当前 Header 主题属性；当前样本仍保留同一「Header 高度 + chip 尺寸 + theme style Bundle」计算结构。

需要明确：AOSP 现在建议最大建议数不超过 5，而 Gboard 请求 9 个是其产品架构选择，不应机械复制到本项目。Google 拼音当前只有单行 Header，首版更适合有界请求。

### 3.3 Response 处理

Gboard 当前 `fwk.y(Context, InlineSuggestionsResponse)` 的已确认行为：

- 空列表立即清空现有 Inline UI
- 在组件已激活且当前会话仍有效时才处理
- 为 response 创建与建议数相同的 View 数组和 `AtomicInteger`
- 读取每项 `InlineSuggestionInfo` 的 source、type、pinned、hints 和 presentation spec
- 对普通建议使用 `WRAP_CONTENT × WRAP_CONTENT`异步 inflate
- 对需要特殊布局的 pinned action 在 spec 范围内计算有界尺寸
- 每个异步回调按原索引写回数组，全部完成后才发布一组 UI，避免异步完成顺序改变建议顺序
- 对 `TYPE_ACTION`、pinned 项和特殊 hints 执行分类，但不读取建议正文
- 给返回的 `InlineContentView`附加点击/长按监听，用于本地状态、交互或指标收尾
- 最终将 View 集合交给独立的 Inline Suggestion Candidate 控制器，而不是将远端内容转换成文本候选
- 失活、替换或清空时主动撤销旧 UI 和引用。

当前样本还识别 `personalContextMotionEffectSuggestion` 等 Google 产品特定 hint。它不属于 Android Autofill 最小协议，本项目不应复制。

### 3.4 GMS 门禁不是标准协议要求

Gboard 当前实现会检查 GMS 版本，并可能因 GMS 过旧禁用其 Device Intelligence Inline 组件。这是 Gboard 自身产品栈的依赖，不是 Android Inline Autofill 协议要求。

本项目必须直接依赖 Android framework API，不得：

- 要求安装 GMS
- 向输入法授予 Google 账户
- 读取密码管理器私有接口
- 仿造 Gboard 的 Device Intelligence 或个人上下文 hints。

### 3.5 Surface 裁剪是必须处理的真实问题

`InlineContentView`内部承载远端 Surface。普通父 View 的裁剪不一定自动约束这个 Surface。HeliBoard 从 AOSP 衍生的实现专门提供 `InlineContentClipView`：每帧将宿主可见边界换算到各个 `InlineContentView`并调用 `setClipBounds()`，同时用透明、置顶 `SurfaceView`建立正确的 Surface 层级。

其源码注释明确指出：如果没有这一层，远端 Surface 可能覆盖宿主 App 中预期区域之外的内容。

这意味着本项目不能只在 Header 里放一个普通 `HorizontalScrollView`就宣称完成。必须在以下场景验证远端 Surface 不会越界：

- 横向滚动
- Header 左右 padding
- 展开候选
- 键盘/主题切换
- 三按钮和手势导航
- IME 隐藏、语音输入法往返
- 横屏、窄屏和 `sw600dp`
- Surface attach/detach 及快速切换输入框。

## 4. 其他开源 IME 的交叉证据

### 4.1 HeliBoard

HeliBoard：

- 使用官方 AndroidX Autofill Inline UI style Bundle
- 构造 3 个 presentation spec，最大请求 6 项
- 把建议异步 inflate 后放入横向滚动容器
- 使用专门的 `InlineContentClipView`裁剪远端 Surface
- response 到达后暂时让原单词建议退出显示。

其实现证明了「独立 Inline View 层 + 横向滚动 + Surface 裁剪」是传统 View IME 中的可行路径。

### 4.2 FlorisBoard

FlorisBoard：

- 使用异步 inflate
- 以递增 sequence ID 使旧 response 失效
- 设置 2 秒有界等待
- 所有回调完成后一次性发布 View 列表
- 清理时递增 sequence ID，阻止晚到回调重新显示旧建议
- 根据 `isPinned`整理显示顺序。

这验证了本项目必须建立 request/session generation，而不能让每个异步回调直接修改当前 Header。

### 4.3 AnySoftKeyboard

AnySoftKeyboard 也使用标准 request / response / inflate 流程，但其一个实现会把整个键盘主体替换成全屏建议列表，并在日志中输出 source、type 和 hints。该做法不符合本项目「Header 建议永不替换必需输入键」和最小诊断面的约束，只作为协议可运行性证据，不作为架构参考。

## 5. 映射到本项目

### 5.1 已具备的基础

`v2.0.2` 已经完成：

```text
Header
└─ SoftKeyboardView
   └─ FixedSizeCandidatesHolderView

Body
└─ 必需输入键 + 隐藏 PageableCandidatesHolderView
```

密码、PIN、普通数字、电话和日期时间键盘已经有稳定 Header，必需输入键全部保留在 Body。这解决了 Inline Autofill 接入前最重要的结构问题。

### 5.2 早期 Header 拓扑提案（已由 Header Platform 取代）

研究阶段曾建议扩展为：

```text
SoftKeyboardView Header
└─ HeaderInner.Candidates
   ├─ FixedSizeCandidatesHolderView        # 原生文字/剪贴板 Candidate
   ├─ CompatInlineAutofillClipHost          # API 30+ 远端 InlineContentView
   │  └─ HorizontalScrollView / row
   ├─ 原生 show-more key
   └─ 剪贴板 dismiss overlay
```

该阶段曾提出以下显示规则：

```text
原生输入候选存在
    > Inline Autofill response
    > 空闲剪贴板 Candidate
    > 空 Header
```

最终实现不采用这一 Clipboard 顺序。真实 Clipboard quick-paste 是有明确关闭操作、提交语义和最新用户复制意图的原生 Candidate，因此最终集中仲裁为：

```text
普通原生 Candidate
> Clipboard quick-paste Candidate
> Inline Autofill
> idle Header
```

其中：

- Inline host 显示时隐藏 Candidate holder、show-more key 和剪贴板关闭层
- 不清空原生候选控制器的数据，只做表现层互斥
- response 为空或会话失效后恢复由原生 Candidate 状态决定的 Header
- 任何时候都不隐藏或替换 Body 中的数字、QWERTY、符号、删除、空格和 action 键
- password/PIN 目的地继续禁止语言预测和学习；Header 存在不改变输入语义。

### 5.3 为什么不能复用 `FixedSizeCandidatesHolderView`

`FixedSizeCandidatesHolderView`管理 Google 拼音 `Candidate → SoftKeyView` 的原生模型。`InlineSuggestion.inflate()`返回的是已经完成远端渲染和安全隔离的 `InlineContentView`。

把后者转换成 Candidate 会造成：

- 需要读取或复制敏感显示内容，破坏安全模型
- 丢失远端 Surface 和系统点击链路
- 错误地让 IME 负责提交 payload
- 无法支持 Autofill 服务自带认证 action、图标和动态 UI
- 与平台回退、生命周期和无障碍协议不兼容。

因此「共用 Header」不等于「共用 Candidate 数据模型」。正确复用层级是 Header 空间和显示仲裁，而不是渲染对象。

### 5.4 Request 数量决策

首版采用以下保守假设：

- API：仅 API 30+
- `maxSuggestionCount`：首版为 3
- spec 数量：3 个相同 spec，以兼容部分密码管理器对多 spec 的实际依赖
- 高度：使用当前 qualified `keyboard_header_height`减去必要的垂直 inset，不写死设备像素
- min width：约一个可触达 chip 的最小宽度
- max width：以 Header 可用宽度和约 240 dp 的单 chip 上限取较小值
- inflate 尺寸：优先 `WRAP_CONTENT × exactHeaderContentHeight`
- Locale：当前主要输入语言加活动次要语言；如果无法可靠取得，使用空 LocaleList，而不是伪造系统语言
- style：优先评估官方 `androidx.autofill:inline` style Bundle 的可复现、资源 ID 稳定接入；不能复制 AndroidX 私有 Bundle 协议或手写 Gboard 内部样式。

后续真实 Bitwarden 多匹配项测试关闭了「3 个建议」的假设：本项目请求 3 项时，Bitwarden 按 `min(requestMax - 1, 5)` 只提供 2 个凭据，并用余下 1 项显示 Vault 入口；Gboard 请求 9 项时则得到 5 个凭据和 1 个入口。Bitwarden 公开 Android 源码也明确将 Inline 凭据限制为 5 项且不把 Vault 入口计入该上限。

因此当前决策是保留 3 个 presentation spec，但将总请求和本地 response 上限提升为 6。Android 会让超出 spec 列表的建议复用最后一个 spec；请求 6 是获得 Bitwarden 完整「5 个凭据 + 1 个 Vault 入口」的最小值，不复制 Gboard 的 9 项，也不使用无限上限。AOSP「实践中不超过 5」的性能建议已纳入风险评估：本项目一次只显示一个 Surface，并继续使用 1.2 秒有界聚合、null/异常处理和会话失效清理；6 项需要单独运行时回归。

### 5.5 生命周期状态机

最小状态：

```text
generation: int
activeInputSession: boolean
activeHeaderToken / currentHeaderView
pendingInflationCount
inflatedViews[]
currentInlineViews[]
```

每次以下事件都必须递增 generation 并清理当前 View：

- 新 response
- 空 response
- `onStartInput`切换 editor
- `onFinishInputView`
- `onFinishInput`
- IME window 隐藏
- Header / InputView 销毁或重建
- 配置、主题或键盘类型切换导致 host 变化。

异步 callback 只在以下条件全部成立时发布：

```text
callbackGeneration == currentGeneration
&& activeInputSession
&& currentHeader仍为同一实例
&& response尚未被替换
```

`inflate()`返回 `null`、部分建议失败或超时都必须有界结束；不能让一项永远不回调而永久阻塞整组显示。

### 5.6 API 17–29 边界

`InputMethodService`的两个回调在 API 30 引入。实现必须证明：

- API 17–29 仍能加载 `PinyinIME`和 primary DEX
- 旧系统不会在启动路径解析 `InlineSuggestion`、`InlineContentView`或 `InlinePresentationSpec`
- 所有 API 30 对象只在平台回调到达后创建
- 不在静态字段初始化、构造器、`onCreate()`或旧路径中直接触发 API 30 类型
- input-method XML 的新属性在旧系统上安全忽略
- API 17–29 继续由系统旧式 Autofill UI 处理，不增加自制 fallback strip。

标准 IME 可以在同一个 Service 类中覆盖 API 30 方法，但本项目仍需用 API 17 静态门禁和可用旧运行时做实际加载验证，不能只依据注解判断安全。

### 5.7 TalkBack 边界

首版不应声明：

```xml
android:supportsInlineSuggestionsWithTouchExploration="true"
```

除非已经证明：

- TalkBack 能正确聚焦远端 InlineContentView
- 建议的 provider 无障碍文本由远端安全提供
- 横向滚动、点击、返回和关闭不会困住焦点
- IME 不会把密码正文复制到本地 `contentDescription`
- 放大、switch access 和 touch exploration 下的 Surface 裁剪正确。

未声明时，应让平台在 touch exploration 场景使用自己的安全回退，而不是手写替代 UI。

## 6. 不应复制的 Gboard 行为

以下属于 Gboard 产品栈或当前实现细节，不是本项目需求：

- GMS 最低版本门禁
- Device Intelligence 模块和个人上下文建议
- 请求 9 项建议
- Gboard 内部类别枚举、指标协议和 candidate 发布总线
- swipe-space 选择 Inline Suggestion
- 从内部主题 token 复制受保护资源或样式
- 记录 provider 相关内容或建议元数据用于产品分析。

可以借鉴的是协议边界、异步聚合、pinned/action 区分、尺寸约束、生命周期清理和独立 View 控制器。

## 7. 实施阶段建议

### 阶段 A：最小协议与静态门禁

- [x] 在 input-method XML 声明 `supportsInlineSuggestions=true`，继续不声明 touch exploration 支持
- [x] 建立带 SDK 门控的 API 30 窄桥和独立 `InlineAutofillCompat`
- [x] 返回 3 个 presentation spec；首版最多 3 项，后续基于 Bitwarden 多匹配项证据将总请求上限修正为 6，尺寸继续使用当前 Header 高度和 `48dp..240dp`宽度范围
- [x] 在尚无 Surface host 时，response 不读取数量、元数据或正文，只推进 generation 并返回未处理
- [x] 在输入视图开始、结束和服务销毁时推进 generation，拒绝后续阶段复用旧会话结果
- [x] 增加源码编译、最终 DEX 窄桥、API 17–29 SDK 门控和隐私边界静态验证，并接入 Release workflow
- [ ] 在 API 30+ 设备上验证标准 Autofill 服务确实发起 request/response，并验证 API 17–29 旧 ART 启动；本项属于运行时验收，不由静态门禁替代。

### 阶段 B：隔离审计包的 Header 渲染（历史阶段，后续已平台化）

- [x] 阶段 B 曾增加 API 中立的独立 `InlineAutofillClipHost`；最终实现已删除该 process-global host，迁移到每个 Header 一个 `HeaderPlatformHostView`、固定 previous/next rails 和 remote-surface renderer，且始终不把远端 View 转换为 Candidate
- [x] 最多按 provider 原顺序异步 inflate 6 项，使用 generation、活动会话和 Header 实例身份拒绝迟到回调
- [x] 增加 1.2 秒有界超时、null/异常/重复 callback 处理，允许按原索引发布已完成的部分结果
- [x] 对每个远端 View 按 Header 全局可见矩形显式设置本地 clip bounds，并在 layout、scroll、attach/detach 时更新或释放
- [x] 完成原生 Candidate > Inline Autofill > 空闲剪贴板的表现层优先级；不清空原生 Candidate 或改变 Clipboard 数据模型
- [x] 补齐 editor 开始、输入视图结束、`onFinishInput()`、IME 隐藏、服务销毁和 Header detach 清理
- [x] 不改变任何 Body 键、密码预测/学习语义或 touch exploration 声明
- [ ] 使用只含合成测试数据的 Autofill 服务完成真机显示、点击、横向滚动、裁剪和快速切换验收，不使用真实密码做诊断。

### 阶段 C：密码管理器互操作

至少验证：

- Google Password Manager /系统 Autofill
- 一个符合标准的第三方密码管理器
- username、text password、Web password、PIN、普通文本
- 0、1、多项建议
- 普通 suggestion、pinned action、认证后填充
- provider 不支持 Inline 时的系统菜单回退
- 快速切换字段、App、输入法和屏幕方向。

### 阶段 D：视觉、无障碍和发布门禁

- 浅色、深色、图片和彩色主题
- 窄屏、横屏、`sw600dp`、字体缩放和多窗
- 三按钮/手势导航及 covering-IME 边界
- Surface 裁剪和滚动
- TalkBack 先验证回退，再决定是否声明 touch exploration 支持
- API 17–29 启动，API 30+ 协议，API 31/33/34/35/36 静态门禁
- 6,633 旧资源 ID、primary DEX、非 Debug、签名和可复现构建。

## 8. 按键反馈所有权边界

维护者发现 Inline Autofill 建议本体最初不会遵循 Google 拼音的按键音量和按键振动设置。隔离 Debug 包只记录宿主触摸阶段和反馈桥调用，不记录坐标、凭据、Provider 内容、输入文本或 SharedPreferences 正文。

第一轮实验在每个预挂载建议外增加本地触摸包装层。一次 Provider 建议操作产生约 50 条重复 `host_down`，但没有 `host_up`、`host_move`、`host_cancel` 或反馈桥调用。进一步隐藏非当前包装层后，本地宿主收到 0 条触摸事件。这证明此前的重复 DOWN 来自覆盖远端 Surface 的透明本地 sibling，不是当前 Provider 内容的点击。透明层拦截、Surface Z-order 调整和触摸合成都不是可接受方案。

AOSP `InlineContentView` 的安全模型解释了触摸结果：远端内容属于另一个安全域，通过默认位于宿主窗口上方的独立 Surface 接收输入。宿主不能读取内容、注入触摸或通过代码提交 Provider payload。不过，`InlineContentView` 本身仍是本地 View，Framework 会在远端 Surface 完成点击后调用直接注册在它上面的 `View.OnClickListener`。这个完成通知不提供建议正文，也不替代 Framework/Provider 的认证与填充。

对 Gboard 17.8.4 的进一步静态追踪确认了同一结构：`fwd` 在 `InlineSuggestion.inflate()` 完成后直接对 `InlineContentView` 设置 `fwi` 点击监听器，`fwi` 通过 `nrv` 调用全局 `pdk.g(view, 0)`，再执行 Gboard 自己的点击处理。实际实现 `pdm` 是 `PressEffectPlayerImpl`，它按 Gboard 设置调用 `AudioManager.playSoundEffect()` 和振动路径。因此 Gboard 没有拦截远端触摸，而是在 Framework 报告点击完成后补充本地输入法反馈。

本项目采用相同所有权边界：每个真实远端 View 直接注册点击完成监听器，只在当前、可见、启用且未释放的建议上调用 Google 拼音原生 `aue` 反馈控制器。监听器不读取 Provider 数据，不调用 `performClick()` 或 `commitText()`，不修改远端 View 的 sound-effect 状态，并在内容释放时清除。本地 previous/next rails 继续在自身有效 `onClick()` 中调用同一反馈桥，禁用 rail 不产生反馈。

Pixel 10 Pro / Android 16 的隔离 Debug v3 验证 Bitwarden 填充正常，远端建议按键音正常且存在振动。维护者在测试前主动调高 Google 拼音的按键音量和振动时长，实际反馈随修改后的配置变化，证明调用走的是原生 `aue` 设置链，而不是固定系统反馈。限定日志记录到 3 次彼此相隔约 23.5 秒和 15.2 秒的 `feedback_bridge_called`，没有单次操作内的突发重复调用。

以下方案仍被否决：

- 使用透明 View 拦截触摸后合成或转发事件
- 把远端 Surface 移到宿主窗口下方
- 调用本地 `performClick()` 伪造 Provider 点击
- 根据字段变化、Surface 消失或会话结束猜测用户完成了填充
- 读取 Provider 数据、Dataset ID、`AutofillValue` 或凭据内容判断点击。

专项门禁验证远端点击完成和两个本地 rails 共 3 个原生反馈调用点，正式 Header 不包含远端触摸包装层，不修改 Provider sound effect，不直接依赖 `aue`、`AudioManager`、`Vibrator` 或 SharedPreferences。Debug 诊断类和日志不进入正式实现。

## 9. 验收标准

实现只有同时满足以下条件才可视为完成：

1. 用户选择的 Autofill 服务能通过 Android 标准协议在统一 Header 展示建议
2. IME 不读取、不复制、不提交、不持久化建议正文
3. 建议点击由系统/Autofill 服务完成填充
4. 所有目标键盘 Body 必需输入键始终存在
5. 原生输入候选优先，Inline Autofill 次之，空闲剪贴板再次之
6. 空 response、会话结束和快速切换不会留下旧 Surface
7. 远端 Surface 不越过 Header 边界
8. API 17–29 不解析或执行 API 30 路径
9. provider 或 IME 不支持 Inline 时，系统回退仍有效
10. 正式日志和诊断不包含凭据、建议正文或用户选择内容。

## 10. 证据与参考

### Android 官方

- [Integrate autofill with IMEs and autofill services](https://developer.android.com/identity/autofill/ime-autofill)
- [InputMethodService](https://developer.android.com/reference/android/inputmethodservice/InputMethodService)
- [InlineSuggestionsRequest](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestionsRequest)
- [InlineSuggestionsResponse](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestionsResponse)
- [InlineSuggestion](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestion)
- [InlineSuggestionInfo](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestionInfo)
- [AOSP InputMethodService.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/inputmethodservice/InputMethodService.java)
- [AOSP InlineSuggestion.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/inputmethod/InlineSuggestion.java)
- [AOSP InlineContentView.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/core/java/android/widget/inline/InlineContentView.java)
- [AOSP InlineSuggestionsRequest.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/inputmethod/InlineSuggestionsRequest.java)

### Gboard 静态证据

```text
work/research/gboard-current-public/decoded-base/res/xml/method.xml
work/research/gboard-current-public/decoded-base/smali/oqp.smali
work/research/gboard-current-public/decoded-base/smali/orc.smali
work/research/gboard-current-public/decoded-base/smali/opv.smali
work/research/gboard-current-public/decoded-base/smali/fwk.smali
work/research/gboard-current-public/decoded-base/smali/fwn.smali
work/research/gboard-current-public/decoded-base/smali_classes2/fwd.smali
work/research/gboard-current-public/decoded-base/smali_classes2/fwi.smali
work/research/gboard-current-public/decoded-base/smali_classes2/fwe.smali
work/research/gboard-current-public/decoded-base/smali_classes2/nrv.smali
work/research/gboard-current-public/decoded-base/smali/pdi.smali
work/research/gboard-current-public/decoded-base/smali/pdk.smali
work/research/gboard-current-public/decoded-base/smali/pdm.smali
work/research/gboard-current-public/decoded-base/smali/ojk.smali
work/research/gboard-current-public/decoded-base/smali/com/google/android/libraries/inputmethod/inlinesuggestion/InlineSuggestionScrubSpaceMotionEventHandler.smali
```

### 开源交叉实现

- [HeliBoard `LatinIME`](https://github.com/HeliBorg/HeliBoard/blob/50d13c1bd6c3f4ee6d69644b3d422145cb928503/app/src/main/java/helium314/keyboard/latin/LatinIME.java)
- [HeliBoard `InlineAutofillUtils`](https://github.com/HeliBorg/HeliBoard/blob/50d13c1bd6c3f4ee6d69644b3d422145cb928503/app/src/main/java/helium314/keyboard/latin/utils/InlineAutofillUtils.java)
- [FlorisBoard `FlorisImeService`](https://github.com/florisboard/florisboard/blob/2a44855c7fcce943a2d3b2092fe45808037ad258/app/src/main/kotlin/dev/patrickgold/florisboard/FlorisImeService.kt)
- [FlorisBoard `NlpInlineAutofill`](https://github.com/florisboard/florisboard/blob/2a44855c7fcce943a2d3b2092fe45808037ad258/app/src/main/kotlin/dev/patrickgold/florisboard/ime/nlp/NlpInlineAutofill.kt)
- [AnySoftKeyboard Inline Suggestions 实现](https://github.com/AnySoftKeyboard/AnySoftKeyboard/blob/6643bda9d400c0ca3025e67ca46361e28ba5e441/ime/app/src/main/java/com/anysoftkeyboard/ime/AnySoftKeyboardInlineSuggestions.java)

## 11. 事实、推断与待验证项

### 已确认事实

- Android 11+ 通过 `InlineSuggestionsRequest` / `InlineSuggestionsResponse`在 IME 展示 Autofill
- 敏感正文对 IME 隐藏，内容由远端 Surface 提供
- Gboard 当前声明 `supportsInlineSuggestions=true`
- Gboard 当前 request 使用主题 style Bundle、9 个 spec、最大 9 项和 LocaleList
- Gboard 异步 inflate、区分 pinned/action、等待整组完成并管理失效状态
- Gboard 直接监听 `InlineContentView` 的点击完成通知，并通过 `PressEffectPlayerImpl` 播放输入法设置控制的声音和振动
- 普通 `FixedSizeCandidatesHolderView`不能直接承载 `InlineContentView`
- Surface 裁剪需要显式设计和验证。

### 基于事实的设计推断

- 本项目应在统一 Header 内增加独立 Inline host，而不是新增键盘外 fallback strip
- 首版请求 3 项是保守起点；真实 Bitwarden 多匹配项证据支持将当前总上限提升为 6，而不是复制 Gboard 的 9 项
- 原生候选应优先于 Inline Autofill，Inline Autofill 优先于空闲剪贴板
- API 30 回调应只在 `PinyinIME`保留窄桥，主体放入独立 Compat 类
- generation + 有界异步聚合是避免旧 Surface 回流的最低必要机制。

### 仍待验证或受环境限制

- Google Password Manager 与更多第三方 Provider 的完整交叉矩阵；当前已覆盖合成 Provider 和 Bitwarden
- Provider 返回 pinned action 的更多排列
- TalkBack 启用时平台具体回退行为；完成前继续不声明 touch-exploration Inline 支持
- API 17–29 旧 ART 运行时：最终 DEX 静态隔离已通过，但当前 ARM64 ABI/模拟环境无法完成该运行矩阵
- `sw600dp` 大屏上的最终 Header Platform 运行时覆盖。

以下原待验证项已经关闭：官方 AndroidX Inline Style Bundle 已在保持 6,633 个旧资源 ID、primary DEX 隔离和完整 Compose 组合的前提下构建及运行；Pixel 10 Pro 上 0/1/多项、局部坐标裁剪、快速重建、方向切换、隐藏/恢复和 stale callback 拒绝已经通过。
