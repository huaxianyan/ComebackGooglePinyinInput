# Gboard 系统虚拟导航键与导航栏研究

## 范围

本文中的「虚拟键」指 Android 屏幕底部的系统导航区域，包括三键导航按钮、手势导航条、导航栏背景、分隔线和图标明暗，不是输入法内部的 `SoftKeyView`。

研究样本仍为 Gboard `17.7.5.932364120-release-arm64-v8a`，重点类为：

- `qgw`：IME 导航栏状态协调器
- `qgs`：根据 API、编辑器、键盘 surface 和主题生成并应用状态
- `qgu` / `qgv`：导航栏状态 builder/model
- `qgt`：由 IME/InputView 实现的底部 frame 与系统 UI 桥
- `bmx` / `bmy` / `bmz`：不同 Android API 的 system bar appearance 兼容层
- `eht`：Gboard IME 生命周期和 InputView 侧协调逻辑。

## Gboard 的状态模型

Gboard 不把导航栏适配简化成「浅色主题写一个颜色、深色主题写另一个颜色」。`qgv` 明确保存五类状态：

1. navigation bar color
2. navigation bar divider color
3. 可选的 bottom frame color
4. 可选的另一个输入视图边缘/frame color
5. `isLightNavBar`，即是否使用深色系统导航图标。

`qgu` builder 要求颜色、divider 和 icon appearance 都已提供，否则拒绝生成状态。这说明 Gboard 将系统栏视为键盘 surface 的一部分，而不是一次性的 Window 修补。

## 颜色来源

Gboard 的正常路径从当前 `SoftKeyboardView`/stylesheet context 取得实际颜色 token，再传给 `qgs`：

- 优先读取当前键盘 surface 对应的 `ColorStateList`
- 只接受 alpha 为 255 的最终导航栏颜色
- 透明或不存在的 token 会进入当前 surface、浮动键盘和 API 版本对应的 fallback
- Android 28 有单独兼容分支，可使用白色导航栏和约 `#FFE0E0E0` divider
- Android 29+ 使用当前键盘 surface 的真实主题色，而不是根据主题名称猜测
- 浮动模式可选择透明导航栏，并同步处理底部 frame。

这和 Gboard chip 研究得到的结论一致：颜色来自键盘 stylesheet 的最终 surface token，不来自系统 `uiMode`，也不依靠名字包含 `light`/`dark`。

## 图标明暗兼容

Gboard 为不同 API 选择不同实现：

- 旧 API 使用 `decorView.systemUiVisibility`
- Android 30+ 使用 `WindowInsetsController.setSystemBarsAppearance()`
- Android 35+ 走单独实现，但 appearance bit 仍明确按 mask 设置
- 在应用 Window 状态后，还会把兼容 system UI flag 同步给 InputView 侧。

导航栏图标和背景颜色属于同一个 model，避免出现浅背景配浅色按钮或深背景配深色按钮。

## 三键导航、手势导航和可见性

Gboard 还处理以下状态，而当前 Google 拼音补丁没有覆盖：

- `FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS` 的启用/撤销
- API 34+ 通过 `WindowInsetsController` 显示或隐藏 navigation bars
- 浮动键盘是否使用透明导航栏
- `setNavigationBarContrastEnforced()` 与 InputView/edge-to-edge 状态联动
- 键盘 bottom frame 与系统导航区域颜色同步
- `com.android.systemui` 编辑器和 Android 28 的特殊兼容分支
- Window、EditorInfo、InputView 或 theme surface 变化后重新计算 model，而不是盲目重复写常量。

## Google 拼音原始实现

Google 拼音 4.5.2 的 `GoogleInputMethodService` 在 header/body/extension 可见性变化时执行以下逻辑：

1. 首次记录 Window 原有的 navigation bar color 到字段 `d`
2. 根据键盘区域是否可见，在原色和透明色 `0` 之间切换
3. 不管理 divider
4. 不管理浅色导航图标
5. 不理解现代手势导航、contrast enforcement 或 WindowInsetsController。

在 targetSdk 28 + Android 16 上，旧框架写入透明色后会出现黑色导航区域，这是早期兼容补丁要解决的直接问题。

## 当前 `NavigationBarCompat` 评估

### 已正确解决的部分

- 在 `onStartInputView()` 后重新设置导航栏
- 在旧框架候选/header 更新并改写导航栏后重新应用
- API 26+ 能同步浅色/深色导航图标
- API 28+ 同步 divider
- API 29+ 关闭系统强制对比度蒙层
- 内置 Material Light (`#FFECEFF1`) 和 Material Dark (`#FF263238`) 与原资源颜色一致
- 已在当前测试设备和内置浅/深主题下解决黑色导航栏问题。

### 基础层面的不足

1. **通过 cache key 名称猜主题。**
   当前代码查找 `light`、`white`、`dark`、`black`、`holo_blue`。Google 拼音还提供 red、pink、green、cyan、blue grey、deep purple、Google blue 等额外 stylesheet。比如 red theme 使用白色标签和红色 surface，但名称不含 `dark`，当前逻辑会错误设置浅灰导航栏和深色虚拟键。

2. **背景只有两个硬编码值。**
   额外彩色主题、bordered theme、无背景主题和未来动态 surface 都无法匹配。Gboard 使用当前 View stylesheet 的实际最终颜色。

3. **divider 被设置成与导航栏完全相同。**
   这能隐藏接缝，但不是 Gboard 的独立 divider model；亮色三键导航下可能需要轻微分隔色。

4. **只使用旧 `systemUiVisibility`。**
   Android 30+ 仍通常兼容该 flag，但 Gboard 已使用 `WindowInsetsController` 并按 mask 修改 appearance，现代实现更明确，也更不容易覆盖其他 system UI bit。

5. **无导航模式和浮动状态。**
   当前代码不区分三键导航、手势导航、浮动键盘和透明 bottom frame。

6. **无 bottom frame 同步。**
   只写 Window navigation bar，未将键盘底部实际 View surface 纳入同一个状态；在 edge-to-edge 或手势区域策略变化时可能出现接缝。

7. **无条件关闭 contrast enforcement。**
   当前设备上可避免系统灰黑蒙层，但 Gboard 会根据 InputView/edge-to-edge 状态动态决定。无条件关闭不是最稳妥的通用规则。

8. **更新机制是补写而非状态协调。**
   目前依赖 `onStartInputView` 和旧私有方法中的一个插桩点。主题、Window attach、导航模式或其他 surface 改变时没有统一的 model 和去重逻辑。

## 结论

当前补丁是一个针对 Pixel 10 Pro、Android 16 和内置 Material Light/Dark 的有效修复，但还不能评价为「已经按 Gboard 思路实现得很好」。它解决了已观察到的黑栏问题，却没有建立 Gboard 那种以实际键盘 surface 为来源的系统栏状态模型。最大的潜在未知问题是额外彩色主题会被错误分类。

## 建议的后续重构顺序

1. [V27 已实现第一阶段] 从当前已渲染 keyboard body View 解析**实际 surface color**；body 暂不可用时读取 keyboard area，并仅在两者都无法给出不透明颜色时回退到 cache key 名称
2. 用背景颜色亮度计算 `isLightNavBar`，并让图标 appearance 与颜色作为一个状态更新
3. 独立计算 divider color
4. API 30+ 改用 `WindowInsetsController.setSystemBarsAppearance()`，旧 API 保留 `systemUiVisibility` fallback
5. 识别三键/手势导航和浮动键盘，只在合适模式处理透明度与 contrast enforcement
6. 同步键盘 bottom frame，消除 Window 导航区和输入 View 之间的接缝
7. 将更新集中到一个有缓存、可重复调用的 state coordinator，并覆盖 input start、theme/surface 改变和旧框架可见性更新。

V27 的首次真机主题切换结果仍只出现两套兜底颜色。进一步确认 Google 拼音 stylesheet 不会直接改写 XML `GradientDrawable` 的 solid color，而是用自定义 `bam` Drawable 包装原背景，并将最终主题 tint 保存在其公开 `ColorStateList` 中。V27 未识别该包装类型，因此 body 和 keyboard area 都返回无效颜色，确实全部进入了名称 fallback。

V28 已优先读取 `bam` 当前 state 对应的最终颜色，之后才处理 Android 标准 Drawable；名称判断仍只作为真正的早期生命周期 fallback。当前仅替换颜色来源和图标亮度输入，divider、WindowInsets、导航模式与 contrast enforcement 尚未改变。

## Android 15 IME Window 与键盘高度的完整路径

进一步跟踪 `eht`、`obk`、`sbr` 和 Gboard `InputView` 后，可以把「Gboard 也设置了 InputView bottom padding」和 V2–V4 的失败区分开来：Gboard 的 padding 不是一个独立的 Insets listener 修补，而是受 **IME Window 覆盖模式**统一控制。

### Window 模式先于 InputView padding

`eht.ag` 表示 InputView 是否覆盖系统导航区域。API 30+ 每次开始输入时，`eht.u()` 都执行等价于：

```java
window.setDecorFitsSystemWindows(!coverNavigation);
```

随后 `eht.aD()` 才根据同一个布尔状态更新 InputView：

- `coverNavigation == false`：bottom padding 强制为 `0`，由 Window/system 负责把 IME 内容放在系统栏上方
- `coverNavigation == true`：bottom padding 使用统一 window-metrics 状态中的 stable bottom inset，让 InputView 主动延伸到导航区
- padding 变化后调用 Gboard `InputView.a()`，只负责启用 bottom-frame 绘制，不改变键盘 body 的高度来源。

因此，Gboard 的默认非覆盖路径不是「边到边以后总给 root 增加导航栏 padding」，而是明确选择 `setDecorFitsSystemWindows(true)` 并保持 root bottom padding 为零。只有产品状态明确要求覆盖导航区时，才同时切换 Window 模式和 bottom frame。

### Insets 不直接驱动键盘 root

Gboard 的 `obk`（`WindowMetricsHelper`）在 decor view 上监听 WindowInsets 和 layout change，但 listener 本身不修改 InputView。它在布局稳定后读取：

- `getWindowVisibleDisplayFrame()`
- `getRootWindowInsets()`
- API 30+ 的 `getInsetsIgnoringVisibility(...)`
- display rotation、真实 display metrics、cutout 和 density。

结果被发布为进程级 `sbr` window-metrics model。`eht.aD()`、键盘高度计算和 bottom-gap 计算都读取同一个 model，而不是各自监听一次 Insets 后写入自己的 View。这样高度设置变化、Window 重建和导航栏可见性变化不会产生多个互相竞争的几何基线。

### Bottom frame 是单独的绘制状态

Gboard `InputView` 有独立颜色字段 `d`。当 bottom padding 大于零且颜色有效时，`onDraw()` 只在 View 最底部 padding 对应的矩形中绘制 bottom-frame color。`qgw/qgs/qgv` 同时协调：

- Window navigation-bar color/divider
- 可选 bottom-frame colors
- light navigation icon appearance
- navigation bar show/hide
- `FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS` 和 contrast enforcement。

这说明 bottom frame 是「覆盖导航区」模式的显式 surface，不是给整个 InputView 设置背景后产生的大面积黑色填充。

### 对 Google 拼音 target 35 的结论

Google 拼音的旧 `InputView` 虽然和 Gboard 一样是 `FrameLayout + wrap_content`，但它没有 Gboard 的 window-metrics model、覆盖模式状态、专用 bottom-frame paint 和统一键盘高度管线。V2–V4 在构造函数中永久安装 Insets listener，并把导航高度直接写成 root padding；当 `keyboard_height_ratio` 触发旧框架重新创建/测量 keyboard holder 时，这个额外 root 几何不属于原生高度模型，因而出现下沉和超大背景面。

target 35 V5 应采用 Gboard 已存在的另一条完整路径：

1. 非浮动 Google 拼音 IME 选择 **non-covering Window mode**
2. API 30+ 在 `onStartInputView()` 生命周期调用 `Window.setDecorFitsSystemWindows(true)`
3. 删除 InputView Insets listener、root padding 和 root background 覆盖
4. 保持原生 `InputView.onMeasure()`、`KeyboardBodyHeight`、`keyboard_height_ratio` 和 `onComputeInsets()` 不变
5. 继续由 `NavigationBarCompat` 管理 navigation surface 颜色与图标，但不让它参与键盘高度
6. 首次引导 Activity 仍使用自己的窄 bottom-inset listener，因为 Activity footer 与 IME Window 是不同问题。

这不是 `windowOptOutEdgeToEdgeEnforcement`：没有设置 manifest/theme opt-out，也没有恢复旧 target 行为；它使用现代 Window API 明确声明 IME 内容不覆盖系统栏。若未来增加浮动/覆盖导航区模式，再同时引入 Gboard 式的 window-metrics model 和专用 bottom frame，不能重新采用孤立的 root-padding listener。

### V5 真机反证：InputMethodService 默认排除 BOTTOM side

V5 只调用 `setDecorFitsSystemWindows(true)` 后，黑色大 surface 消失，但键盘从第一次显示起仍位于三键导航区后方。现场 `dumpsys window` 给出了决定性信息：

```text
InputMethod ... EDGE_TO_EDGE_ENFORCED FIT_INSETS_CONTROLLED
fitTypes=statusBars navigationBars
fitSides=LEFT TOP RIGHT
```

也就是说，`setDecorFitsSystemWindows(true)` 已成功恢复 `statusBars navigationBars` 两种 fit type，但 `InputMethodService` 的 Window attrs 明确没有 `BOTTOM` side。对普通 Activity，「fits system windows」通常包含底边；对底部 IME Window，框架默认让它延伸到 navigation region，由 IME 自己提供 bottom frame。这解释了为什么 V5 不再有黑色 root，却仍能透过透明导航栏看到后面的键盘。

Google 拼音不具备 Gboard 的 cover-navigation/bottom-frame 管线，因此 non-covering 路径还必须显式调用 API 30+：

```java
WindowManager.LayoutParams attrs = window.getAttributes();
attrs.setFitInsetsSides(
    WindowInsets.Side.LEFT | WindowInsets.Side.TOP |
    WindowInsets.Side.RIGHT | WindowInsets.Side.BOTTOM);
window.setAttributes(attrs);
```

对应常量为 `0x0f`，不是任何设备像素。这样 system 在 Window layout 层把 bottom navigation inset 纳入 IME frame，而不是再次修改 InputView。V6 将以键盘首次显示即位于导航栏上方及 Window frame 无重叠作为首要验收条件。

V6 真机确认中，全 side 默认值未再以单独 `fitSides=` 行打印，但实际 frame 给出了更直接的证明：

```text
navigationBars frame=[0,2284][1080,2410]
ime frame=[0,1481][1080,2284]
ime visibleFrame=[0,1481][1080,2284]
mImeShowing=true mLastDrawn=true
```

IME 的 bottom 恰好等于 navigation bar 的 top，两个区域没有像素重叠。维护者在多个键盘高度间来回切换后，最下一行始终位于导航键上方，且 V5 已消失的黑色大 surface 没有恢复。这个结果只证明 `fitInsetsSides(BOTTOM)` 能稳定分离键盘 body 和导航栏，**不能证明完整 IME 协议正确**。

### V6 应用侧反证：IME source 不能在 navigation top 结束

进一步功能回归出现两个严重问题：

1. 底部输入区域不再随键盘正确上移，会被 IME 遮挡
2. navigation region 不属于 IME surface，透明导航栏显示应用内容，无法按键盘主题绘制。

现场目标应用使用 `ADJUST_NOTHING` 并依赖现代 WindowInsets。V6 发布的 IME source 是 `[0,1481][1080,2284]`，没有延伸到 display bottom `2410`。这会破坏应用所依赖的 bottom-anchored IME inset 语义。正确几何不能只是「键盘和导航栏不重叠」，而必须同时满足：

- IME Window/source 延伸到 display bottom，让应用收到完整 IME inset
- 实际 keyboard area 在 navigation top 结束
- navigation region 仍属于 IME surface，并由键盘主题绘制
- 导航区不进入 `keyboard_height_ratio` 的 body 高度。

因此 V7 改用 Gboard 的 covering 模型，而不是 V6 的 Window 裁切模型：Window fit sides 为 `LEFT|TOP|RIGHT`，明确不 fit `BOTTOM`；InputView 内新增专用 bottom frame。Insets coordinator 不修改 root padding，而把 navigation inset 同时写成 `keyboard_area.bottomMargin` 和 bottom-frame height。对 FrameLayout 而言，root 测量高度变成原生 keyboard area 加 bottom margin；键盘 body 上移而高度不变，bottom frame 只绘制最底部 navigation region。

预期三键导航几何为：

```text
ime/source bottom = display bottom
keyboard_area bottom = navigation bar top
bottom_frame = navigation bar frame
```

这也解释了为什么 V2–V4 的 root padding/background 方案不应恢复：root background 会绘制整个可能扩展的 IME surface，而专用 frame 只绘制 navigation inset；margin/spacer 是键盘 body 之外的兄弟几何，不污染 body 的高度设置。
