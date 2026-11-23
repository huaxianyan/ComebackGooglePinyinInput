# 悬浮键盘（平板适配）方案

对应 issue [#13 请求支持悬浮模式](https://github.com/huaxianyan/ComebackGooglePinyinInput/issues/13)：
平板上默认键盘太大。目标是做到 Gboard 悬浮键盘的效果。

本文只做调研与方案，不含实现。

## 一、Gboard 的交互规格

按 Gboard 的实际行为整理，作为验收基线：

| 项 | 行为 |
| --- | --- |
| 进入 | 工具栏「更多」里的悬浮开关，横屏可自动进入（Gboard 13.6 起） |
| 默认位置 | 屏幕中部偏下，水平居中 |
| 默认尺寸 | 宽约屏宽 65%，高度按键盘原有宽高比等比缩小 |
| 拖动 | 底部一条拖动手柄，按住可拖到屏幕任意位置 |
| 缩放 | 右下角手柄拖动改宽高，保持键盘宽高比 |
| 闲置 | 长时间不动会淡化到约 50% 不透明度，避免挡住内容 |
| 返回 | 有一个「收回停靠」按钮，回到贴底全宽 |
| 内容 | 工具栏、候选栏、键盘本体一起缩放，不单独处理 |

用户能感知的核心是两点：**能变窄变小，能挪开不挡内容**。

## 二、技术约束

IME 不是普通窗口，几条硬约束决定了实现方式：

1. IME 窗口由 `InputMethodService` 的 `SoftInputWindow` 承载，位置和尺寸由系统按 IME 规则布局，应用侧改 `WindowManager.LayoutParams` 的 x/y 会被系统重新布局覆盖。所以**不能靠移动窗口做悬浮**。
2. 应用拿到的 IME insets 取决于 `onComputeInsets` 报告的 `contentTopInsets` / `visibleTopInsets` 与 `touchableInsets`。`contentTopInsets` 等于窗口高度时表示「不遮挡」。
3. `touchableInsets = TOUCHABLE_INSETS_REGION` 时，只有 `touchableRegion` 里的区域接收触摸，其余事件穿透给下面的应用。
4. 不能用 `SYSTEM_ALERT_WINDOW` 再开一个窗口。那要多一个权限，而且 IME 窗口与浮层的焦点、输入连接要另外处理，改动面远大于收益。
5. 项目既有约束：不做 `DecorView` reparent，不用 framework 内部类名与反射，不硬编码设备尺寸。

第 2、3 条合起来就是可行路线：**窗口撑成全屏但报告不遮挡，触摸区域只留卡片**。

## 三、现成可复用的东西

调研发现原生已经有大部分底座，这是本方案成本低的原因。

### 3.1 视图层级（`res/layout/ims_input_view.xml`）

```
InputView (FrameLayout, fill_parent 宽, wrap_content 高, elevation 8 dp)
└── FrameLayout @id/keyboard_area (layout_gravity=bottom, fill_parent 宽, wrap_content 高, 背景 ?BgKeyboardArea)
    ├── ShrinkableFrameView          背景层
    ├── include keyboard_left_side_view   单手模式左框架
    ├── include keyboard_right_side_view  单手模式右框架
    ├── KeyboardHolder @id/keyboard_holder (vertical)
    │   ├── header_group_view  扩展头 + 键盘头（工具栏、候选）
    │   └── body_group_view    键盘主体 + 扩展主体
    └── ShrinkableFrameView          顶部细分隔线
```

`keyboard_area` 本身就是一个带圆角背景的独立 `FrameLayout`，**它天然就是「卡片」**，不需要新建容器，也不需要把键盘视图搬来搬去。

### 3.2 单手模式（`OneHandedModeManager` + `KeyboardSideFrame`）

原生早有单手模式，且几何是完整的：

- `OneHandedModeManager`（1619 行 smali）管理宽度、位置、左右手切换，宽度存在
  `OrientationAwarePreferences` 里，横竖屏分别保存。
- `KeyboardSideFrame` 是贴左或贴右的框架，内含三个按钮：展开（`expand_keyboard`）、
  换手（`switch_one_hand`）、**编辑尺寸（`edit_keyboard`）**。
- `startEditingKeyboard()` 与 `KeyboardEditingViewHelper` 已经在处理「拖动调整键盘尺寸」。

也就是说：**缩窄、贴边、保存宽度、拖动调尺寸，这四件事原生都实现过一遍**，只是被限定成只能在左右两侧。悬浮模式等于把这套几何从「贴左/贴右」放开成「任意位置 + 任意尺寸」。

### 3.3 `onComputeInsets` 已有「不遮挡」分支

`GoogleInputMethodService.onComputeInsets` 当前逻辑：

1. 取 InputView 在窗口中的位置与尺寸。
2. `visibleTopInsets` = InputView 顶部。
3. 按键盘视图是否可见决定 `contentTopInsets`。
4. `touchableRegion` 先并上所有 enabled 且可见子视图的 global visible rect，**再并上整个 InputView 的 rect**。
5. `touchableInsets = 3`（`TOUCHABLE_INSETS_REGION`）。
6. 末尾有一段：`contentTopInsets == 0` 时改成 `rootView.getHeight()`，同时把 `visibleTopInsets` 也改成它。

第 6 条正是悬浮模式需要的效果。悬浮模式下只要让它走这个分支，再把第 4 步「并上整个 InputView」跳过，触摸区域就只剩卡片。

### 3.4 参照实现

同文输入法（Trime）在 2026-11 合入了悬浮键盘（PR #2226），思路与上面一致：

- `onConfigureWindow` 把窗口设成 `MATCH_PARENT × MATCH_PARENT`。
- `onComputeInsets` 在悬浮时报告 `contentTopInsets = visibleTopInsets = decorView.height`，
  注释写明「把卡片当作 overlay，报告不遮挡可以让应用在拖动卡片时不跟着平移」，
  并设 `touchableInsets = TOUCHABLE_INSETS_REGION`、`touchableRegion` 为卡片 bounds。
- 卡片在窗口内部用 `translation` 移动，不移动窗口。
- 几何计算抽成纯函数（缩放 20%~300%、拖动手柄 32 dp、位置以 0~1 分数持久化、边缘吸附）。

这是目前能找到的最贴近的先例，且同为 Android IME 的 Java/Kotlin 实现。

## 四、方案

分四步走，每步都能单独验收、单独回退。

### 阶段 0：可行性探针（必须先做，约半天）

在动手改产品代码之前，用一个临时探针把三个不确定点验证掉，避免做完才发现方向不通：

1. IME 窗口设成全屏后，`contentTopInsets = 窗口高度` 是否真能让应用不调整布局。
   验证样本：系统记事本、微信输入框、Chrome 地址栏。
2. `touchableRegion` 只留一个小矩形时，区域外的触摸是否确实穿透到应用（能点按钮、能滚动）。
3. 全屏 IME 窗口对这三件事有没有副作用：状态栏/导航栏遮挡、应用的 adjustResize 行为、
   键盘弹出动画。

探针只进隔离包，不进正式包，验证完删除。这一步的结论决定后面是否继续。

### 阶段 1：窄键盘卡片（解决 issue 的抱怨，约 1 到 2 天）

目标：平板上键盘不再占满宽度，缩成居中的卡片，高度按比例。

- 悬浮开启时：`InputView` 与 IME 窗口改为 `MATCH_PARENT`，背景透明。
- `keyboard_area` 的宽度改成 `屏宽 × 比例`（默认 70%），`layout_gravity` 保持底部居中。
- 高度：先取原生布局算出的自然高度，按宽度同比例缩小。宽度缩到 70% 时行高也缩到 70%，
  避免出现「窄而高」的畸形比例。缩放实现优先用 Container 的宽高 + 原生重排，
  退路是用 `setScaleX/Y` 做整体变换。
- `onComputeInsets` 增加悬浮分支：`contentTopInsets = visibleTopInsets = rootView.height`，
  `touchableRegion` 只取 `keyboard_area` 的 global visible rect。
- 触发条件：平板（`smallestScreenWidthDp >= 600`）默认开启，手机端默认关闭。
- 设置项放在「外观与布局」，与「单手模式」「键盘高度」并列。开启时与单手模式互斥。

这一阶段做完，issue 的核心诉求（太大）就解决了，Gboard 的默认态也是这个样子。

### 阶段 2：拖动与位置记忆（约 1 到 2 天）

- 卡片顶部或底部加一条拖动手柄，交互沿用 `KeyboardSideFrame` 现有按钮的样式与触摸处理。
- 拖动改写 `keyboard_area` 的 `translationX/Y`，限制在可用区域内（含系统栏 insets）。
- 位置以 0~1 分数保存，横竖屏各一份，重启输入法后恢复。
- 松手后按距离吸附到左、中、右三档，避免边框像素级对不齐。
- 拖到贴近底部时自动切回停靠（等同 Gboard 收回）。

### 阶段 3：缩放、淡化与停靠（约 2 天）

- 四角或右下角加缩放手柄，拖动改卡片宽高，保持宽高比，范围 40%~100% 屏宽。
- 尺寸与位置一起持久化。
- 闲置 5 秒淡化到 50%，触摸恢复。
- 卡片右上角加「停靠」按钮，回到贴底全宽，等同于关闭悬浮。
- 状态变化走 `requestLayout()`，让系统重新取 `touchableRegion`。

## 五、改动点预估

| 位置 | 改动 |
| --- | --- |
| `patches/java/.../floating/FloatingKeyboardCompat.java`（新增） | 模式状态、几何计算、持久化、触摸区域上报 |
| `patches/smali/.../GoogleInputMethodService` | `onComputeInsets` 增加悬浮分支，`onCreateInputView` 后挂接 |
| `patches/smali/.../InputView` | 悬浮时跳过 `onMeasure` 里的高度回溯逻辑 |
| `res/layout` 或代码构建 | 卡片容器与拖动手柄，尽量复用现有 `KeyboardSideFrame` 样式 |
| modern-settings | 新增开关与尺寸档位 |
| `res/values/strings.xml` | 新增文案 |

几何计算按 Trime 的做法写成纯函数并配 host 测试，覆盖：尺寸换算、拖动边界钳制、
位置分数与像素互转、横竖屏切换、与系统栏 insets 合并。

## 六、风险

1. **insets 行为是最大不确定点**。Trime 的注释只说明了 IMM 旧接口的效果，
   Android 11+ 应用多读 `WindowInsets`，而 insets 来源是 IME 窗口 frame。
   如果系统按全屏窗口算 insets，应用会被压到没有空间。阶段 0 必须先验证。
2. **全屏窗口与既有 edge-to-edge 逻辑冲突**。`EdgeToEdgeCompat`、`NavigationBarCompat`
   现在都按「窗口高度等于键盘高度」来算导航栏区域，窗口全屏后这些计算的输入变了，
   需要逐处核对。
3. **手势输入坐标**。`HmmGestureDecoder` 按键盘视图坐标解码滑动轨迹，卡片缩放后
   需要确认坐标换算仍然正确，否则滑动输入会错位。
4. **候选栏与 header 模块**。剪贴板、内联自动填充这些 Header 功能的 popup 位置
   依赖锚点，卡片移动后要跟着走。
5. **预测性返回**。悬浮模式下返回键先关卡片还是先退出输入，需要单独定义。
6. **平板分屏与多窗口**。分屏时可用区域变小，卡片尺寸计算要把 `WindowMetrics` 的
   实际可用区域算进去，不能用手写死的屏宽。

## 七、验收口径

- 平板（`sw600dp` 及以上）首次打开输入法即为窄卡片，不占满宽。
- 卡片可拖到屏幕任意位置，重启后位置与尺寸不变。
- 拖动、缩放过程中应用内容不跟着平移，区域外触摸能正常点到应用。
- 键盘、候选、工具栏、剪贴板弹窗位置一致，滑动输入不错位。
- 手机关闭该模式时行为与现在完全一致，不引入回归。
- 三按钮导航与手势导航、竖屏与横屏分别验证。
