# Gboard Inline Autofill 实现原理与 Google 拼音接入边界

## 1. 目标与结论

本文研究 Android 11+ 的 Inline Suggestions / Autofill 协议、Gboard 当前公开 APK 的实现方式，以及如何将该能力接入本项目已经完成的统一键盘 Header。

核心结论：

1. **IME 不读取密码管理器数据库，也不请求账户、密码、TOTP seed 或银行卡正文。** IME只向 Android Autofill Framework声明自己能承载怎样的 Inline UI。
2. **IME不会拿到建议正文。** Autofill 服务在其他进程中渲染建议，IME得到的是由 `SurfaceControlViewHost.SurfacePackage` 承载的 `InlineContentView`。IME可以读取 `source`、`type`、`isPinned` 和 `autofillHints` 等元数据，但不能遍历远端 View 树取得密码文本。
3. **IME不负责提交 Autofill payload。** 用户点击远端建议后，Autofill Framework / Autofill 服务完成认证、字段填充或 action 启动；IME附加的点击监听只用于本地 UI 收尾和统计，不应调用 `InputConnection.commitText()`。
4. **现有统一 Header 是正确入口，但 `FixedSizeCandidatesHolderView` 不是正确渲染器。** Autofill 返回的是任意 `InlineContentView`，不是 Google 拼音 `Candidate`。Header 中应增加独立、可裁剪的 Inline Autofill host 层，与原生 Candidate holder互斥显示。
5. **API 30 以下不参与此协议。** API 17–29继续走现有原生输入和系统旧式 Autofill 菜单；不得为旧系统引入启动期类解析风险。

适用边界：本文讨论 Android 标准 Inline Suggestions 协议，不讨论让输入法自行读取密码管理器、模拟密码管理器 UI、猜测验证码、解析网页凭据或实现自有账户同步。

## 2. Android 官方协议

### 2.1 启用条件

Android 11 / API 30开始支持 IME 内联展示 Autofill 建议。IME的 input-method XML必须声明：

```xml
<input-method
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:supportsInlineSuggestions="true" />
```

如果当前 IME 或当前 Autofill 服务任一方不支持 Inline Suggestions，平台回退到 Android 10及更早版本的系统菜单展示方式。

Gboard 17.8.4 的公开 APK也在 `res/xml/method.xml` 中声明了同一属性。它没有声明 `supportsInlineSuggestionsWithTouchExploration`，说明至少该样本没有承诺在 TalkBack touch exploration 开启时托管 Inline Suggestions。

### 2.2 完整时序

已确认的框架流程如下：

1. 用户聚焦支持 Autofill 的输入框，例如用户名、密码、信用卡或地址字段。
2. App通过标准 `autofillHints`、输入类型和 View structure向 Android Autofill Framework描述字段；IME不直接查询 App字段或密码管理器。
3. 平台确认当前 IME与用户选择的 Autofill 服务是否都支持 Inline Suggestions。
4. 在 `inputStarted` 之后，平台调用 IME：

   ```java
   InputMethodService.onCreateInlineSuggestionsRequest(Bundle uiExtras)
   ```

5. IME返回 `InlineSuggestionsRequest`，其中包括：
   - 期望的最大建议数；
   - 一个或多个 `InlinePresentationSpec`；
   - 每个 spec允许的最小/最大尺寸；
   - 可选的样式 Bundle；
   - 可选的受支持 Locale。
6. 平台把该 request交给 Autofill 服务。服务按 request生成 `Dataset` 和 `InlinePresentation`，但敏感正文不交给 IME。
7. 平台调用：

   ```java
   InputMethodService.onInlineSuggestionsResponse(
       InlineSuggestionsResponse response)
   ```

8. IME读取 `response.getInlineSuggestions()`，对每个 `InlineSuggestion`调用一次：

   ```java
   suggestion.inflate(context, size, executor, callback)
   ```

9. inflate异步返回 `InlineContentView`，IME将其放入建议栏。点击后的认证、填充和 action由远端 Autofill链路执行。
10. 空 response、输入会话结束、Header销毁、配置切换或更新 response到来时，IME清理旧 View和异步状态。

### 2.3 Request约束

`InlineSuggestionsRequest` 的关键规则：

- presentation spec列表不能为空；
- `maxSuggestionCount` 必须不少于 spec数量；
- spec少于最大建议数时，最后一个 spec用于余下建议；
- AOSP源码明确建议最大建议数实际不要超过 **5**，以控制性能成本；
- `hostPackageName`、IME host input token和display ID由系统设置，IME不应伪造；
- target SDK 31+未显式设置 Locale时，默认是空 `LocaleList`；
- style/extras中的远程对象在跨进程前会被平台过滤。

### 2.4 Inflate约束

`InlineSuggestion.inflate()` 的关键规则：

- 同一个 `InlineSuggestion`实例只能调用一次 `inflate()`；重复调用会抛出 `IllegalStateException`；
- 请求尺寸的每个维度必须位于对应 spec的 min/max之间，或者使用 `WRAP_CONTENT`；
- 回调可能异步返回 `null`；
- `InlineContentView` 的实际 LayoutParams由远端内容尺寸决定；
- 远端进程通过 `SurfacePackage`提供内容，View attach/detach后的 Surface更新由框架内部管理；
- IME可以设置 `OnClickListener` / `OnLongClickListener` 接收远端点击通知，但这不是 payload提交入口。

### 2.5 隐私与信任边界

Android开发者文档明确指出，Inline Autofill可能包含密码和信用卡等私密信息，因此内容在用户选择前对 IME隐藏。AOSP实现进一步证明：

```text
Autofill service / system server
        │
        │ SurfaceControlViewHost.SurfacePackage
        ▼
IME process: InlineContentView
```

IME本地拥有的是远端 Surface宿主，不是包含密码文本的本地 `TextView`。因此正确实现必须：

- 不截图、OCR或像素分析 Inline Surface；
- 不尝试遍历、反射或复制远端内容；
- 不把 Inline UI转换成 Candidate文本；
- 不记录 `toString()`、可见内容、账户标识或用户选择内容；
- 不自行提交、保存、去重或持久化 Autofill payload；
- 只记录允许的无内容诊断，例如 response数量、inflate成功/失败数、尺寸和会话序号。

`InlineSuggestionInfo`公开的元数据只有：

```text
source       android:autofill / android:platform
type         android:autofill:suggestion / android:autofill:action
isPinned     是否为固定 action
autofillHints 建议数据类别提示
presentationSpec
```

这些元数据不等于凭据正文。即使如此，本项目正式日志也不应记录完整 hints数组，避免无必要地扩大诊断面。

## 3. Gboard 17.8.4 的当前实现

研究样本：

```text
package=com.google.android.inputmethod.latin
versionName=17.8.4.939743344-release-arm64-v8a
versionCode=175894542
compileSdk=37
```

本节结论来自本地公开 APK静态解码。混淆类名只作为定位证据，不被视为稳定 API。

### 3.1 服务层只做协议转发

Gboard主 `InputMethodService` 类 `oqp`直接覆盖两个 API 30回调：

```text
onCreateInlineSuggestionsRequest(Bundle)
onInlineSuggestionsResponse(InlineSuggestionsResponse)
```

它没有把逻辑堆在 Service里，而是通过 `orc`代理转发给可选实现 `opv`。没有已初始化实现时，request返回 `null`、response返回 `false`。这形成了清晰的“框架回调 → 生命周期代理 → Inline组件”边界。

对本项目的启示：`PinyinIME`只应保留极窄回调桥，request构造、异步 inflate、Header仲裁和清理都放在独立 `InlineAutofillCompat` 中。

### 3.2 Request构造

Gboard当前 `fwk.b(Context)` 的已确认行为：

- 先检查内部组件初始化和产品级能力开关；
- 使用 Header高度、chip高度、密度、内边距和主题值计算 min/max size；
- 构造一个 `InlinePresentationSpec`；
- style Bundle使用 AndroidX Autofill Inline UI版本协议，包含：

  ```text
  androidx.autofill.inline.ui.version:key
  ```

- 将同一 spec加入 request **9次**；
- `setMaxSuggestionCount(9)`；
- 设置当前主要语言和其他活动语言形成的 `LocaleList`。

旧样本中最大 chip宽度资源为 `240dp`，高度来自当前 Header主题属性；当前样本仍保留同一“Header高度 + chip尺寸 + theme style Bundle”计算结构。

需要明确：AOSP现在建议最大建议数不超过5，而Gboard请求9个是其产品架构选择，不应机械复制到本项目。Google拼音当前只有单行 Header，首版更适合有界请求。

### 3.3 Response处理

Gboard当前 `fwk.y(Context, InlineSuggestionsResponse)` 的已确认行为：

- 空列表立即清空现有 Inline UI；
- 在组件已激活且当前会话仍有效时才处理；
- 为 response创建与建议数相同的 View数组和 `AtomicInteger`；
- 读取每项 `InlineSuggestionInfo` 的 source、type、pinned、hints和presentation spec；
- 对普通建议使用 `WRAP_CONTENT × WRAP_CONTENT`异步 inflate；
- 对需要特殊布局的 pinned action在 spec范围内计算有界尺寸；
- 每个异步回调按原索引写回数组，全部完成后才发布一组 UI，避免异步完成顺序改变建议顺序；
- 对 `TYPE_ACTION`、pinned项和特殊 hints执行分类，但不读取建议正文；
- 给返回的 `InlineContentView`附加点击/长按监听，用于本地状态、交互或指标收尾；
- 最终将 View集合交给独立的 Inline Suggestion Candidate控制器，而不是将远端内容转换成文本候选；
- 失活、替换或清空时主动撤销旧 UI和引用。

当前样本还识别 `personalContextMotionEffectSuggestion` 等 Google产品特定 hint。它不属于 Android Autofill最小协议，本项目不应复制。

### 3.4 GMS门禁不是标准协议要求

Gboard当前实现会检查 GMS版本，并可能因 GMS过旧禁用其 Device Intelligence Inline组件。这是 Gboard自身产品栈的依赖，不是 Android Inline Autofill协议要求。

本项目必须直接依赖 Android framework API，不得：

- 要求安装 GMS；
- 向输入法授予 Google账户；
- 读取密码管理器私有接口；
- 仿造 Gboard的 Device Intelligence或个人上下文 hints。

### 3.5 Surface裁剪是必须处理的真实问题

`InlineContentView`内部承载远端 Surface。普通父 View的裁剪不一定自动约束这个 Surface。HeliBoard从 AOSP衍生的实现专门提供 `InlineContentClipView`：每帧将宿主可见边界换算到各个 `InlineContentView`并调用 `setClipBounds()`，同时用透明、置顶 `SurfaceView`建立正确的 Surface层级。

其源码注释明确指出：如果没有这一层，远端 Surface可能覆盖宿主 App中预期区域之外的内容。

这意味着本项目不能只在 Header里放一个普通 `HorizontalScrollView`就宣称完成。必须在以下场景验证远端 Surface不会越界：

- 横向滚动；
- Header左右 padding；
- 展开候选；
- 键盘/主题切换；
- 三按钮和手势导航；
- IME隐藏、语音输入法往返；
- 横屏、窄屏和 `sw600dp`；
- Surface attach/detach及快速切换输入框。

## 4. 其他开源 IME的交叉证据

### 4.1 HeliBoard

HeliBoard：

- 使用官方 AndroidX Autofill Inline UI style Bundle；
- 构造3个 presentation spec，最大请求6项；
- 把建议异步 inflate后放入横向滚动容器；
- 使用专门的 `InlineContentClipView`裁剪远端 Surface；
- response到达后暂时让原单词建议退出显示。

其实现证明了“独立 Inline View层 + 横向滚动 + Surface裁剪”是传统 View IME中的可行路径。

### 4.2 FlorisBoard

FlorisBoard：

- 使用异步 inflate；
- 以递增 sequence ID使旧 response失效；
- 设置2秒有界等待；
- 所有回调完成后一次性发布 View列表；
- 清理时递增 sequence ID，阻止晚到回调重新显示旧建议；
- 根据 `isPinned`整理显示顺序。

这验证了本项目必须建立 request/session generation，而不能让每个异步回调直接修改当前 Header。

### 4.3 AnySoftKeyboard

AnySoftKeyboard也使用标准 request / response / inflate流程，但其一个实现会把整个键盘主体替换成全屏建议列表，并在日志中输出 source、type和hints。该做法不符合本项目“Header建议永不替换必需输入键”和最小诊断面的约束，只作为协议可运行性证据，不作为架构参考。

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

密码、PIN、普通数字、电话和日期时间键盘已经有稳定 Header，必需输入键全部保留在 Body。这解决了 Inline Autofill接入前最重要的结构问题。

### 5.2 正确的 Header拓扑

建议扩展为：

```text
SoftKeyboardView Header
└─ HeaderInner.Candidates
   ├─ FixedSizeCandidatesHolderView        # 原生文字/剪贴板 Candidate
   ├─ CompatInlineAutofillClipHost          # API 30+ 远端 InlineContentView
   │  └─ HorizontalScrollView / row
   ├─ 原生 show-more key
   └─ 剪贴板 dismiss overlay
```

显示规则：

```text
原生输入候选存在
    > Inline Autofill response
    > 空闲剪贴板 Candidate
    > 空 Header
```

其中：

- Inline host显示时隐藏 Candidate holder、show-more key和剪贴板关闭层；
- 不清空原生候选控制器的数据，只做表现层互斥；
- response为空或会话失效后恢复由原生 Candidate状态决定的 Header；
- 任何时候都不隐藏或替换 Body中的数字、QWERTY、符号、删除、空格和 action键；
- password/PIN目的地继续禁止语言预测和学习；Header存在不改变输入语义。

### 5.3 为什么不能复用 `FixedSizeCandidatesHolderView`

`FixedSizeCandidatesHolderView`管理 Google拼音 `Candidate → SoftKeyView` 的原生模型。`InlineSuggestion.inflate()`返回的是已经完成远端渲染和安全隔离的 `InlineContentView`。

把后者转换成 Candidate会造成：

- 需要读取或复制敏感显示内容，破坏安全模型；
- 丢失远端 Surface和系统点击链路；
- 错误地让 IME负责提交 payload；
- 无法支持 Autofill服务自带认证 action、图标和动态 UI；
- 与平台回退、生命周期和无障碍协议不兼容。

因此“共用 Header”不等于“共用 Candidate数据模型”。正确复用层级是 Header空间和显示仲裁，而不是渲染对象。

### 5.4 首版 Request建议

以下是实施假设，尚需原型测量验证：

- API：仅 API 30+；
- `maxSuggestionCount`：首版建议3，且不超过AOSP建议的5；
- spec数量：至少3个相同 spec，以兼容部分密码管理器对多 spec的实际依赖；
- 高度：使用当前 qualified `keyboard_header_height`减去必要的垂直 inset，不写死设备像素；
- min width：约一个可触达 chip的最小宽度；
- max width：以 Header可用宽度和约240dp的单 chip上限取较小值；
- inflate尺寸：优先 `WRAP_CONTENT × exactHeaderContentHeight`；
- Locale：当前主要输入语言加活动次要语言；如果无法可靠取得，使用空 LocaleList，而不是伪造系统语言；
- style：优先评估官方 `androidx.autofill:inline` style Bundle的可复现、资源 ID稳定接入；不能复制 AndroidX私有 Bundle协议或手写 Gboard内部样式。

“3个 spec / 3个建议”需要真实密码管理器交叉测试后才能定案。Gboard的9个和HeliBoard的6个都不应被当作平台要求。

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

每次以下事件都必须递增 generation并清理当前 View：

- 新 response；
- 空 response；
- `onStartInput`切换 editor；
- `onFinishInputView`；
- `onFinishInput`；
- IME window隐藏；
- Header / InputView销毁或重建；
- 配置、主题或键盘类型切换导致 host变化。

异步 callback只在以下条件全部成立时发布：

```text
callbackGeneration == currentGeneration
&& activeInputSession
&& currentHeader仍为同一实例
&& response尚未被替换
```

`inflate()`返回 `null`、部分建议失败或超时都必须有界结束；不能让一项永远不回调而永久阻塞整组显示。

### 5.6 API 17–29边界

`InputMethodService`的两个回调在 API 30引入。实现必须证明：

- API 17–29仍能加载 `PinyinIME`和 primary DEX；
- 旧系统不会在启动路径解析 `InlineSuggestion`、`InlineContentView`或 `InlinePresentationSpec`；
- 所有 API 30对象只在平台回调到达后创建；
- 不在静态字段初始化、构造器、`onCreate()`或旧路径中直接触发 API 30类型；
- input-method XML的新属性在旧系统上安全忽略；
- API 17–29继续由系统旧式 Autofill UI处理，不增加自制 fallback strip。

标准 IME可以在同一个 Service类中覆盖 API 30方法，但本项目仍需用 API 17静态门禁和可用旧运行时做实际加载验证，不能只依据注解判断安全。

### 5.7 TalkBack边界

首版不应声明：

```xml
android:supportsInlineSuggestionsWithTouchExploration="true"
```

除非已经证明：

- TalkBack能正确聚焦远端 InlineContentView；
- 建议的 provider无障碍文本由远端安全提供；
- 横向滚动、点击、返回和关闭不会困住焦点；
- IME不会把密码正文复制到本地 `contentDescription`；
- 放大、switch access和touch exploration下的 Surface裁剪正确。

未声明时，应让平台在 touch exploration场景使用自己的安全回退，而不是手写替代 UI。

## 6. 不应复制的 Gboard行为

以下属于 Gboard产品栈或当前实现细节，不是本项目需求：

- GMS最低版本门禁；
- Device Intelligence模块和个人上下文建议；
- 请求9项建议；
- Gboard内部类别枚举、指标协议和 candidate发布总线；
- swipe-space选择 Inline Suggestion；
- 从内部主题 token复制受保护资源或样式；
- 记录 provider相关内容或建议元数据用于产品分析。

可以借鉴的是协议边界、异步聚合、pinned/action区分、尺寸约束、生命周期清理和独立 View控制器。

## 7. 实施阶段建议

### 阶段 A：最小协议与静态门禁

- [x] 在 input-method XML声明 `supportsInlineSuggestions=true`，继续不声明 touch exploration支持；
- [x] 建立带 SDK门控的 API 30窄桥和独立 `InlineAutofillCompat`；
- [x] 返回 3个 presentation spec、最多3项建议的有界 request，尺寸使用当前 Header高度和 `48dp..240dp`宽度范围；
- [x] 在尚无 Surface host时，response不读取数量、元数据或正文，只推进 generation并返回未处理；
- [x] 在输入视图开始、结束和服务销毁时推进 generation，拒绝后续阶段复用旧会话结果；
- [x] 增加源码编译、最终 DEX窄桥、API 17–29 SDK门控和隐私边界静态验证，并接入 Release workflow；
- [ ] 在 API 30+设备上验证标准 Autofill服务确实发起 request/response，并验证 API 17–29旧 ART启动；本项属于运行时验收，不由静态门禁替代。

### 阶段 B：隔离审计包的 Header渲染

- 增加独立 ClipHost；
- 异步 inflate并按 generation发布；
- 完成 Candidate / Autofill / Clipboard优先级；
- 不改变任何 Body键或密码输入语义；
- 使用只含合成测试数据的 Autofill服务验证，不使用真实密码做诊断。

### 阶段 C：密码管理器互操作

至少验证：

- Google Password Manager /系统 Autofill；
- 一个符合标准的第三方密码管理器；
- username、text password、Web password、PIN、普通文本；
- 0、1、多项建议；
- 普通 suggestion、pinned action、认证后填充；
- provider不支持 Inline时的系统菜单回退；
- 快速切换字段、App、输入法和屏幕方向。

### 阶段 D：视觉、无障碍和发布门禁

- 浅色、深色、图片和彩色主题；
- 窄屏、横屏、`sw600dp`、字体缩放和多窗；
- 三按钮/手势导航及 covering-IME边界；
- Surface裁剪和滚动；
- TalkBack先验证回退，再决定是否声明 touch exploration支持；
- API 17–29启动，API 30+协议，API 31/33/34/35/36静态门禁；
- 6,633旧资源 ID、primary DEX、非 Debug、签名和可复现构建。

## 8. 验收标准

实现只有同时满足以下条件才可视为完成：

1. 用户选择的 Autofill服务能通过 Android标准协议在统一 Header展示建议；
2. IME不读取、不复制、不提交、不持久化建议正文；
3. 建议点击由系统/Autofill服务完成填充；
4. 所有目标键盘 Body必需输入键始终存在；
5. 原生输入候选优先，Inline Autofill次之，空闲剪贴板再次之；
6. 空 response、会话结束和快速切换不会留下旧 Surface；
7. 远端 Surface不越过 Header边界；
8. API 17–29不解析或执行 API 30路径；
9. provider或 IME不支持 Inline时，系统回退仍有效；
10. 正式日志和诊断不包含凭据、建议正文或用户选择内容。

## 9. 证据与参考

### Android官方

- [Integrate autofill with IMEs and autofill services](https://developer.android.com/identity/autofill/ime-autofill)
- [InputMethodService](https://developer.android.com/reference/android/inputmethodservice/InputMethodService)
- [InlineSuggestionsRequest](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestionsRequest)
- [InlineSuggestionsResponse](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestionsResponse)
- [InlineSuggestion](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestion)
- [InlineSuggestionInfo](https://developer.android.com/reference/android/view/inputmethod/InlineSuggestionInfo)
- [AOSP InputMethodService.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/inputmethodservice/InputMethodService.java)
- [AOSP InlineSuggestion.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/inputmethod/InlineSuggestion.java)
- [AOSP InlineSuggestionsRequest.java](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/inputmethod/InlineSuggestionsRequest.java)

### Gboard静态证据

```text
work/research/gboard-current-public/decoded-base/res/xml/method.xml
work/research/gboard-current-public/decoded-base/smali/oqp.smali
work/research/gboard-current-public/decoded-base/smali/orc.smali
work/research/gboard-current-public/decoded-base/smali/opv.smali
work/research/gboard-current-public/decoded-base/smali/fwk.smali
work/research/gboard-current-public/decoded-base/smali/fwn.smali
work/research/gboard-current-public/decoded-base/smali/ojk.smali
work/research/gboard-current-public/decoded-base/smali/com/google/android/libraries/inputmethod/inlinesuggestion/InlineSuggestionScrubSpaceMotionEventHandler.smali
```

### 开源交叉实现

- [HeliBoard `LatinIME`](https://github.com/HeliBorg/HeliBoard/blob/50d13c1bd6c3f4ee6d69644b3d422145cb928503/app/src/main/java/helium314/keyboard/latin/LatinIME.java)
- [HeliBoard `InlineAutofillUtils`](https://github.com/HeliBorg/HeliBoard/blob/50d13c1bd6c3f4ee6d69644b3d422145cb928503/app/src/main/java/helium314/keyboard/latin/utils/InlineAutofillUtils.java)
- [FlorisBoard `FlorisImeService`](https://github.com/florisboard/florisboard/blob/2a44855c7fcce943a2d3b2092fe45808037ad258/app/src/main/kotlin/dev/patrickgold/florisboard/FlorisImeService.kt)
- [FlorisBoard `NlpInlineAutofill`](https://github.com/florisboard/florisboard/blob/2a44855c7fcce943a2d3b2092fe45808037ad258/app/src/main/kotlin/dev/patrickgold/florisboard/ime/nlp/NlpInlineAutofill.kt)
- [AnySoftKeyboard Inline Suggestions实现](https://github.com/AnySoftKeyboard/AnySoftKeyboard/blob/6643bda9d400c0ca3025e67ca46361e28ba5e441/ime/app/src/main/java/com/anysoftkeyboard/ime/AnySoftKeyboardInlineSuggestions.java)

## 10. 事实、推断与待验证项

### 已确认事实

- Android 11+通过 `InlineSuggestionsRequest` / `InlineSuggestionsResponse`在 IME展示 Autofill；
- 敏感正文对 IME隐藏，内容由远端 Surface提供；
- Gboard当前声明 `supportsInlineSuggestions=true`；
- Gboard当前 request使用主题 style Bundle、9个 spec、最大9项和 LocaleList；
- Gboard异步 inflate、区分 pinned/action、等待整组完成并管理失效状态；
- 普通 `FixedSizeCandidatesHolderView`不能直接承载 `InlineContentView`；
- Surface裁剪需要显式设计和验证。

### 基于事实的设计推断

- 本项目应在统一 Header内增加独立 Inline host，而不是新增键盘外 fallback strip；
- 首版应请求3项而不是复制 Gboard的9项；
- 原生候选应优先于 Inline Autofill，Inline Autofill优先于空闲剪贴板；
- API 30回调应只在 `PinyinIME`保留窄桥，主体放入独立 Compat类；
- generation + 有界异步聚合是避免旧 Surface回流的最低必要机制。

### 尚待原型或真机验证

- Google拼音 Header最合适的 min/max chip尺寸；
- AndroidX Autofill Inline UI style Bundle能否在保持6,633旧资源 ID和旧 ART隔离的前提下可复现合并；
- Pixel 10 Pro当前 Password Manager对 spec数量和尺寸的实际要求；
- Google Password Manager及第三方 provider返回 pinned action的排列；
- TalkBack启用时平台具体回退行为；
- API 17–29加载含 API 30 override的 `PinyinIME`是否在本 APK/ART组合下完全安全；
- 快速滚动、重建和隐藏时远端 Surface释放的实际时序。
