# Gboard 剪贴板建议实现研究

## 样本

- 设备：Pixel 10 Pro
- 包名：`com.google.android.inputmethod.latin`
- versionName：`17.7.5.932364120-release-arm64-v8a`
- versionCode：`175871638`
- targetSdk：37
- 提取方式：从设备的 `base.apk` 和 4 个 split APK 直接 `adb pull`
- 本地研究目录：`work/research/gboard/`（不纳入仓库）
- 反编译工具：apktool 2.12.1

## 核心结论

Gboard 的剪贴板建议**不是向 IME 根视图或键盘区域临时添加覆盖层**。它把剪贴板内容转换成标准的 suggestion model，再交给候选/建议栏自己的宿主渲染。因此位置、触摸分发、主题、动画、可访问性和生命周期都由已有候选栏体系处理。

这解释了 v21/v22 方案为什么方向不对：即使把自建 `TextView` 从 `InputView` 移到 `keyboard_area`，它仍然是候选系统之外的覆盖层，不能可靠继承候选栏的布局坐标、IME touchable region 和键盘 stylesheet。

## 关键类

由于 release APK 经过混淆，类名同时记录反编译名和日志中保留的原始源码名：

- `ewb`：`ClipboardDataHandler`
  - 实现 `ClipboardManager.OnPrimaryClipChangedListener`。
  - 负责监听系统剪贴板、读取和规范化 `ClipData`、维护最近内容及通知建议 helper。
- `eui`：`AutoPasteSuggestionHelper`
  - 负责输入框过滤、内容分类、chip View 创建、建议 model 创建、显示/隐藏及点击处理。
- `euh`：AutoPasteSuggestionHelper 的延迟/状态协调器。
- `ppm`：候选/建议栏统一消费的 suggestion model。
- `ppk`：`ppm` builder。
- `Leuk`：一条结构化剪贴板记录，包含显示文本、提交文本、时间和内容类型。

## 数据与生命周期

1. `ClipboardDataHandler` 在模块启动时异步注册 `OnPrimaryClipChangedListener`。
2. 模块结束时移除监听器，并清理 AutoPasteSuggestionHelper、EditorInfo 和输入会话对象。
3. `onPrimaryClipChanged()` 不直接操作 View，而是刷新结构化的剪贴板数据集合。
4. 只有设置项 `enable_auto_paste_chips` 开启时才创建 `AutoPasteSuggestionHelper`。
5. helper 保存当前 `EditorInfo`、输入会话和候选宿主接口；输入会话结束时统一撤下 suggestion model。
6. 最近项目通过时间戳去重；AutoPasteSuggestionHelper 内还定义了 2 分钟的有效期，并记录最后点击 chip 的时间戳。

## 安全和输入框过滤

Gboard 在创建 suggestion model 前执行多层过滤，而不是只检查几种 password variation：

- 根据 `EditorInfo.inputType` 选择不同的内容过滤器；
- 对密码、数字、电话、邮箱等输入类型采用不同允许类型集合；
- 检查应用通过 EditorInfo private options 提供的 `disableAutoPaste`；
- 检查全局 feature gate 和用户设置；
- 图片建议还检查当前编辑器支持的 MIME type；
- 无可用输入会话、EditorInfo 或候选宿主时不创建建议。

## View 创建方式

`AutoPasteSuggestionHelper.createProactiveSuggestions()` 最多处理 5 项。它不是手写一个全宽 TextView，而是：

1. 根据建议栏 surface 类型选择专用布局；
2. 用 `LayoutInflater` inflate chip；
3. 设置文本、内容类型图标、contentDescription 和 ellipsize；
4. 给整个 chip 根 View 设置 OnClickListener；
5. 把 View 列表放进统一 suggestion model；
6. model 的 source 明确设置为 `clipboard`，category 设置为建议栏支持的类别；
7. 由建议栏宿主决定实际位置、可见性、切换动画和点击区域。

文本 chip 的两个主要布局为：

- `res/layout/APKTOOL_DUMMYVAL_0x7f0e0063.xml`：紧凑候选栏样式，`wrap_content`，图标 + 单行文本；
- `res/layout/APKTOOL_DUMMYVAL_0x7f0e0118.xml`：另一种 suggestion surface，36dp 高，包含主题分隔线和 8dp 垂直 padding。

## 主题处理

Gboard 不读取系统 `Configuration.uiMode`，也不在 Java/smali 中根据系统深浅模式硬编码两套颜色。

- chip 通过 XML style 创建；
- 文本色、图标 tint、背景、ripple、高度和边距使用键盘主题 attr；
- 某些 surface 使用 `ContextThemeWrapper`；
- View tag（例如 `.chip-item-suggestion-text`、`.item-ripple.on-surface.bg-chip-item-suggestion`）会被 Gboard stylesheet 系统继续处理。

进一步解析主题二进制规则后确认：

- chip XML 背景是以纯白、1000dp 圆角 shape 作为 background/mask 的 ripple；
- 默认规则将 `.bg-chip-item-suggestion` 映射到 `default_chip_background_color`；
- 默认亮色规则再将该颜色映射到 `default_bordered_key_color`，基础值约为 `#4CFFFFFF`，即在键盘表面叠加约 30% 白色，而不是用深色文字生成半透明黑色背景；
- 默认暗色 chip 基础值约为 `#1AFFFFFF`；
- Material 3 动态色规则最终映射到 surface/container token；
- 紧凑 AutoPaste chip 使用约 34dp 高度、14sp 文本、20dp 图标、12dp 水平间距和完全胶囊圆角。

因此 chip 自动跟随当前键盘主题，而不是跟随系统主题。兼容版没有 Gboard stylesheet 引擎，需要根据当前候选文字亮度选择上述亮/暗 surface 叠加值，而不能直接把文字 RGB 当作 chip 背景。

## 点击提交

- 点击监听器设置在 chip 的根 View 上，而不是只有内部 TextView 可点；
- 文本点击经输入会话/候选框架提交，不直接依赖一个可能已过期的 service 引用；
- 点击后记录对应剪贴板项目时间戳并撤下 suggestion model；
- 图片内容走 MIME/URI commitContent 路径，文本走文本提交路径；
- 可访问性描述与屏幕显示文本分开设置。

## 对 Google 拼音兼容版的启示

下一版不应继续调整自建 overlay 的 gravity、margin 或硬编码颜色。正确方向是先找出 Google 拼音 4.5.2 中可复用的候选栏入口：

1. 定位 `KeyboardHeaderViewHolder` / 候选键盘的真实宿主和更新接口；
2. 确认是否能以标准候选项、临时候选页或 header extension 的形式注入一个剪贴板项；
3. 使用现有候选布局/style/soft-key 体系，让主题和触摸由框架处理；
4. 点击走框架已有的候选/soft-key action，再由输入法提交文本；
5. 如果旧框架没有 model API，优先在候选栏 XML 内预留受框架管理的容器，而不是挂到 `InputView` 或 `keyboard_area` 顶层。

在完成上述宿主定位和真机坐标/触摸验证前，不再实现新的剪贴板浮层。

## Google 拼音原生候选视觉修订（2026-07-25）

后续真机使用表明，Gboard chip 依赖更高的建议栏；把相同的圆角框、描边、阴影和图标压入 Google 拼音较矮的候选栏会显得局促。因此兼容版不再照搬 Gboard 的视觉表面，但继续保留已经验证的 model/候选管线、隐私过滤、时效、完整 payload 提交和回收清理。

修订后的呈现原则：

1. 剪贴板文本继续作为原生 `Candidate`，保持候选栏中央对齐；
2. 移除圆角背景、描边、elevation、额外高度、缩小字号和剪贴板前置图标；
3. 恢复 Google 拼音原生候选字号、文字颜色、透明 key surface 和 padding；
4. 在该候选左右显示 `SoftKeyCandidateSeparator` 同源分隔线，普通候选布局不变；
5. 在候选栏原展开箭头的固定右侧位置显示关闭按钮，使用相同主题文字色和候选栏分隔线；
6. 关闭只屏蔽当前 `text + timestamp` 对应的建议，不清空系统剪贴板；同一个剪贴板不会在当前进程中反复出现，新复制内容仍可正常生成建议；
7. 关闭按钮作为原展开 SoftKeyView 上方的普通可点击 sibling，避免篡改 `TOGGLE_SHOW_MORE_CANDIDATES` 的原生 SoftKeyDef；建议消失后恢复原展开箭头及其触摸语义；
8. 无障碍描述独立设为“关闭剪贴板建议”。

第一份 `clipboardaudit` APK 在 ART 类验证阶段暴露了 smali 寄存器类型合流错误：旧 chip 不可达指令与新分隔线路径复用 `v4`，使 Android 报出 `VerifyError: tried to get class from non-reference register v4 (type=Boolean)`。修正版完全删除旧 chip 指令，并在简化后的 `decorateView()` 中为资源、View、payload 和布尔结果使用不产生冲突的寄存器生命周期。apktool/D8 构建成功不能替代真机 ART 验证。

该修订仍需通过修正版独立 `clipboardaudit` 包验证 ART 加载、视觉密度、关闭触摸、展开箭头恢复、普通候选和多候选场景。

## 空闲候选状态与对称边界修订（2026-07-25）

真机验证进一步确认，剪贴板不应作为正常拼音候选的第一项持续混排。最终状态机改为：

- 无输入候选时显示剪贴板；
- 任意非剪贴板候选批次到达后，立即让位并标记正常候选活动；
- 候选更新后延迟 100 ms 检查，若没有新的正常候选批次，才认定输入已完成或取消并恢复剪贴板；
- 输入过程中发生剪贴板变化只更新保留的数据，不清空或替换当前引擎候选。

视觉边界保留候选 holder 左右各一个原生展开按钮宽度（45dp）的对称布局预算：右侧是关闭按钮，左侧是不可点击的空白预留位。但分隔线不再固定在这两个外侧边界，而是放回 wrap-sized 候选 View 的左右两边，因此短验证码的分隔线会紧跟文字，且不会与外侧分隔线重叠而加深颜色。可见标签上限收窄为 200dp，并把 `AutoSizeTextView` 的最小横向 scale 固定为 1.0，保持原生 21sp 字号；完整规范化文本交给 View 在该宽度内执行 `END` 省略，不再按固定字符数手工拼接 `...`。关闭符号的 `ColorStateList` 直接复制当前已渲染的原生候选文字，因此跟随键盘主题而不是系统深浅模式或静态 XML 解析结果。

关闭按钮不再使用独立的通用 View 反馈。点击时临时接入原生 `aue` 按键反馈控制器，以同一份键盘偏好执行按键音、音量、振动开关和振动时长；反馈完成后立即注销其偏好监听器，避免额外生命周期泄漏。

V5 真机暴露了两个布局细节：复用 `SoftKeyCandidateSeparator` 的左分隔符看起来比此前 header 分隔符更深，而原生 holder 会在 `decorateView()` 返回后再次按“末列候选”规则隐藏右分隔符；仅依赖候选装饰时序并不可靠。修订版因此在候选布局内增加左右两个独立兼容分隔符，并在 holder 完成全部末列装饰后的 `centerSingleClipboardCandidate()` 中再次强制它们可见、强制原生 `candidate_separator` 隐藏，避免叠色或丢线。

后续真机又证明，仅给新增 ImageView 套用原生 style 仍不足以进入旧版键盘的所有动态主题路径。最终方案不再猜测主题 attr：每轮候选完成原生装饰后，以隐藏前的真实 `candidate_separator` 为源，克隆其已解析的 Drawable，并同步 `imageTintList`、image alpha、View alpha 和 drawable state 到左右兼容分隔符。因此颜色来自当前实际渲染的键盘主题，而非系统深浅模式或静态 XML 默认值。

关闭容器的位置同样改为以真实原生 View 为准。显示 `×` 前读取同一位置的 `key_pos_show_more_candidates` 实际 measured width，并写入关闭 overlay 的 LayoutParams；该外宽包含原生分隔列和 45dp host，比仅固定 45dp 更准确。

V7 真机仍显示两个间接推断不足：注入候选中的原生 ID 分隔符本身未必经过完整实时主题路径，而候选栏右边缘也不等于下方 1.5 权重退格键的中心。后续几何对齐改用窗口坐标：优先读取当前可见 `key_pos_del` 的中心；九键布局回退到 `key_pos_move_cursor`；再回退到 `key_pos_header_voice`。将全局中心换算成候选 header 父容器的局部 leftMargin 后定位关闭 overlay，从而不再假定右侧列宽或边缘 inset；真机确认该位置符合预期。

跨层级复制 show-more divider 的 Drawable/tint/filter 仍会叠加源 View 与 Candidate 父层不同的透明度语义，结果在浅色主题很淡、深色和彩色主题几乎不可见。最终不再自绘右线：在 holder 完成“末列隐藏”后重新显示剪贴板 Candidate 自己的真实 `candidate_separator`，它天然与普通候选处于同一布局、主题和父级 alpha 层。左线只在同一 Candidate 内从这条右线克隆最终外观，因此两边既一致，也不会受到跨层级 alpha 乘算。

英文模式还暴露了 `textCandidatesUpdated(true)` 的 preserve 语义差异：刷新剪贴板时旧兼容行可能保留，随后 singleton append 形成两个相同粘贴项，holder 因可见 child 数大于一而恢复左对齐。刷新路径现统一调用 `textCandidatesUpdated(false)` 明确清空旧空闲周期，再只追加一个新剪贴板 Candidate；正常输入活动时仍由 `normalCandidatesActive` 门控，不会被该清理打断。真机确认英文模式恢复单项和居中。

右侧真实原生 divider 正常后，左侧克隆线仍偏淡，说明把源 Drawable 的 ConstantState、tint、filter、image alpha 和 View alpha 分项重建会重复旧 ImageView 的部分透明度语义。最终左线先清除自身静态 tint/filter，再直接共享右侧原生 divider 已完成主题处理的同一个 Drawable，只同步 View alpha，不再二次解释 Drawable 内部状态。该 Drawable 是静态 1dp 分隔线；主题/候选重建时会重新绑定，因此共享 callback 不影响其实际绘制。

同时移除此前为了视觉对称添加的左侧 45dp reserve 和 holder 双侧 margin。剪贴板标签已经限制在 200dp，关闭键又按真实右列中心独立定位，在支持的手机宽度上不会重叠；holder 保持全宽居中本身就会在短文本两侧产生自然、相等的空白，不需要额外占位 View。真机确认 V10 的布局、主题分隔线、关闭键和中英文功能符合预期。

最终识别细节参考 Gboard 的“图标 + 剪贴板内容”语义，但不提取或复制 Gboard 私有素材。原 Google 拼音 APK 已自带公开 AppCompat 风格的 `abc_ic_menu_paste_mtrl_am_alpha` 24dp alpha glyph，以候选标签 `getCurrentTextColor()` 和 `SRC_IN` 着色，因此随当前键盘候选文字主题变化。Candidate 文本和独立完整 payload 均不添加符号，点击仍只提交原剪贴板内容。

首版尝试使用 TextView start compound drawable，构建与 ART 均无异常但真机完全不显示。根因是旧 `avk`/`AutoSizeTextView.onDraw()` 不调用 `TextView.onDraw()`，而是自行缩放 Canvas 并直接 `drawText()`；系统 compound drawable 绘制路径因此不可达。修订版改为 `softkey_candidate.xml` 内真实的 18dp sibling `ImageView`，放在 start candidate padding 处；剪贴板标签额外增加 24dp start padding（18dp 图标 + 6dp 间距），使图标与文字作为一个视觉组合居中并共同受 200dp 最大宽度约束。候选回收时先隐藏 ImageView、恢复原生标签 padding，避免普通候选残留。

V12 的 sibling View 方案在 smali、D8、签名阶段通过，但 Android 16 ART 拒绝 `decorateView()`：`[0xB4] instance-of on non-reference in v7`。根因是右兼容分隔符存在时 `v7` 被写成 visibility 整数，而该 View 不存在的跳转路径越过了后续图标引用赋值，直接在合流标签把 `v7` 当 ImageView 检查。修订版增加 `.locals 9`，把 `v8` 专用于图标 View 引用，并把两条分支统一导向 `find_clipboard_icon` 后才进入候选检查；颜色、尺寸等整数仍只使用 `v3/v4/v7`，不再让引用寄存器跨类型复用。V13 真机确认 ART、图标和全部剪贴板功能正常。

最后的光学调整把图标距左分隔符从原生 6dp candidate padding 增加到 10dp；相应地，标签 start reserve 从 24dp 增至 28dp（4dp 呼吸空间 + 18dp 图标 + 6dp 文字间距）。这样只增加分隔符与图标之间的留白，不改变图标—文字间距；额外宽度继续计入 200dp 上限，因此组合仍居中且不会向关闭键溢出。
