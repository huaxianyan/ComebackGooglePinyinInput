# 悬浮键盘编辑模式的视觉方案调查

2026-11-28。目的：解决编辑模式在浅色主题下「卡片太亮、四个角标和三个按钮看不清」的问题。
上一轮尝试过两条路（深色底板、深色整卡遮罩），都被否掉了，所以这次先查原生怎么做，再定方案。

结论先说：**这个包里本来就有一套完整的键盘编辑界面，用主题资源拼出来的**，不是我们该手绘的东西。

## 一、原生编辑界面的存在形式

| 部分 | 位置 | 说明 |
| --- | --- | --- |
| 驱动 | `KeyboardEditingViewHelper` | `public final` 类，构造器 `public (Context, Delegate, IMetrics)` |
| 控制器 | `OneHandedModeManager` | 调用 `helper.a(anchorView, topOffset)` 弹出界面 |
| 单手复用 | `OneHandedModeKeyboardViewHelper` | 实现 `KeyboardEditingViewHelper$Delegate` |
| 服务接线 | `GoogleInputMethodService` | 创建 helper，并把 `IPopupViewManager` 塞进 helper 的公共字段 |
| 布局 | `res/layout/keyboard_editing.xml`（资源 `0x7f04007b`） | 由 `IPopupViewManager.inflatePopupView` 加载 |
| 样式 | `res/values/styles.xml` 的 `KeyboardEditing*` 系列 | 颜色、透明度、尺寸全部来自主题属性 |

`Delegate` 只有四个回调：

```java
void updateKeyboardPosition(int x, int y);
void updateKeyboardScale(int x, int y, float factor);
void resetKeyboard();
void onExitEditingKeyboard();
```

也就是说，只要实现这四个回调，原生界面会自己处理多点触摸、按下反馈、按钮点击，我们不需要画任何东西。

## 二、原生视觉规格（像素级复刻的依据）

### 遮罩

`KeyboardEditingOverlay` 样式：

- `android:background = ?BgKeyboardEditingOverlayColor`
- `android:alpha = 0.9`

而 `BgKeyboardEditingOverlayColor` 在暗色主题里绑定到 `@color/keyboard_editing_overlay_dark_theme`，值为 **`#d2000000`**（黑 82%）。两者相乘，实际压暗约 **74%**。

这一条直接解释了之前的争议：原生确实是「整块压暗」，而且比我们试过的 45% 冲白重得多；但它压的是**一个独立覆盖层**，键盘机身本身仍是圆角机身加投影，不是把控件垫在黑板上。

### 描边与角标

- 水平/垂直描边：`bg_keyboard_editing_view_edge_horizon|vertical_*`，`alpha = 0.3`
- 四角：`?BgKeyboardEditingCorner`，是 **图片**，有 enabled/disabled 两态（`bg_keyboard_editing_view_edge_corner_*`）

### 三个按钮

以重置键为例（`keyboard_editing_view_reset_keyboard_button.xml`）：

```xml
<FrameLayout android:id="@id/reset_keyboard" style="@style/KeyboardEditingButton.Horizon.ResetButton">
    <ImageView android:alpha="0.2" style="@style/KeyboardEditingButtonOvalBackWithState" />
    <ImageView android:tag=".icon.keyboard_editing_button" android:src="?IconResetKeyboard" />
</FrameLayout>
```

- 椭圆底不是纯色圆盘，而是**主题图标** `?IconKeyboardEditingOvalBackWithState` 再乘 `alpha = 0.2`
- 图形是主题图标 `?IconResetKeyboard`（暗色主题绑定到 `@drawable/ic_key_reset_keyboard_material_dark_theme`，正是我们改过的那个）
- 另有一层 `IconKeyboardEditingOvalBackShadow`，初始 `alpha = 0`，按下时才亮起来

### 布局比例

`keyboard_editing.xml` 里按钮不是固定尺寸，而是按权重分宽：

- 描边权 `14`，空白权 `972`
- 左右扩展按钮权 `250`
- 底部按钮行：空白 `111`、重置 `165`、移动 `227`、退出 `165`、空白 `111`

### 主题属性的资源映射（暗色主题那一份）

| 属性 | 绑定 |
| --- | --- |
| `BgKeyboardEditingOverlayColor` | `@color/keyboard_editing_overlay_dark_theme`（`#d2000000`） |
| `IconResetKeyboard` | `@drawable/ic_key_reset_keyboard_material_dark_theme` |
| `IconExitEditingKeyboard` | `@drawable/ic_exit_editing_keyboard_material_dark_theme` |
| `IconKeyboardEditingOvalBack` | `@drawable/ic_key_keyboard_editing_oval_back_material_dark_theme` |
| `IconKeyboardEditingOvalBackShadow` | `@drawable/ic_key_keyboard_editing_oval_background_shadow_material_dark_theme` |
| `IconKeyboardEditingOvalBackWithState` | `@drawable/ic_key_keyboard_editing_oval_back_with_state_material_dark_theme` |
| `IconExpandKeyboardAlpha` | `0.4` |

浅色主题的同一批绑定在别处（同一份 `styles.xml` 里只有一套 `KeyboardEditing*` 且指向 `*_material_dark_theme`），**需要用浅色主题实测确认**，不能假定它一样。

## 三、为什么之前的做法都不对

| 尝试 | 问题 |
| --- | --- |
| 70% 黑圆盘底板 | 原生没有这种东西，控件底是主题图标乘 20% alpha，看起来像贴了黑胶布 |
| 45% 白冲淡 | 浅色主题下等于没压暗，强调色与底色对比只有 2.11:1 |
| 手绘弧线/对勾 | 原生用的是主题图片资源，手绘形状对不上 |

原生那套之所以在任何主题下都成立：遮罩和控件都从**主题属性**取值，主题换了值就跟着换，不需要我们猜颜色。

## 四、三条可选路线

### A. 直接复用原生 helper（推荐）

做法：

1. 在 `applyInsets(service, insets)` 的钩子里拿到 `GoogleInputMethodService`
2. `service.getPopupViewManager()` 取到 `IPopupViewManager`
3. `new KeyboardEditingViewHelper(context, delegate, (IMetrics) service)`，把 `IPopupViewManager` 写进 helper 的公共字段
4. 进入编辑时不再自己创建 `FloatingKeyboardEdit`，改为 `helper.a(anchorView, topOffset)`
5. 实现 `Delegate`：`updateKeyboardPosition` / `updateKeyboardScale` 映射到现有的 `applyScale` / `applyPosition`，`resetKeyboard` 与 `onExitEditingKeyboard` 复用现有逻辑

优点：像素级一致、自动跟主题、多点触摸和按钮反馈都是原生的。
风险：`IPopupViewManager` 与 `IMetrics` 由服务提供（`IMetrics` 由 `AppBase` 实现，服务本身满足）；anchor 在原生是 `KeyboardHolder`；inflate 出的弹窗主题是否与键盘当前主题一致**必须实测**。

### B. 自绘但按原生规格复刻

不动架构，只把画的东西换成原生数值：遮罩层 `#d2` 黑加视图 `alpha 0.9`（等价 74%）、描边 `alpha 0.3`、角标用 `?BgKeyboardEditingCorner` 的图片、三个按钮用 `IconKeyboardEditingOvalBackWithState` 乘 0.2 再叠主题图标、按权重排布。

优点：不依赖 `IPopupViewManager`，改动局限在一个类里。
缺点：主题属性的解析仍要自己搭（或退回取样），长期维护成本高。

### C. 不动遮罩，只提高控件可读性

给控件加描边/halo，或换主题图标，不再整卡压暗。
缺点：与原生差距最大，且浅色主题下「太亮」这个问题本身还在。

## 五、开工前必须验证的四件事

每条都写明怎么验，避免又靠猜：

1. **弹窗的主题解析**：用一次探针构建，`inflatePopupView(0x7f04007b)` 之后打印 `keyboard_editing_overlay` 的实际背景色与键盘底色，确认浅色主题下 `?BgKeyboardEditingOverlayColor` 解析成什么。原生单手模式跟着主题走是已知事实，但那是服务自己的上下文，我们的调用点需要复核。
2. **`a(View, I)` 第二个参数语义**：从 `OneHandedModeManager` 的调用点看是键盘的 `top` 偏移而不是「模式」，需要在探针里打印确认。
3. **`updateKeyboardScale(IIF)` 的 float 语义**：从 `OneHandedModeKeyboardViewHelper` 的实现看是相对倍数（`scale *= factor`），但要确认它给的是每次事件的增量还是相对于手势开始的比值，否则缩放会越拖越飞。
4. **anchor 类型要求**：原生传的是 `KeyboardHolder`，我们能否直接传当前 `area`（`FrameLayout`）需要实测，否则要向上找合适的容器。

## 六、外部对照

- FlorisBoard 的浮动窗口（PR #3174）把编辑控件做成主题 token：`window-move-handle`、`window-resize-handle`、`window-resize-action`、`window-resize-overlay-fixed`，并支持按 `windowmode`（`fixed` / `floating`）分别取值；句柄使用自定义 shape 并带投影。
  来源：https://github.com/florisboard/florisboard/pull/3174
- HeliBoard 的浮动键盘（PR #2501）涉及 `FloatingKeyboardUtils.kt` 与 `main_keyboard_frame.xml`，但公开页面没有给出遮罩与句柄的具体做法。
  来源：https://github.com/HeliBorg/HeliBoard/pull/2501

两家都是「控件外观走主题 token / 资源」，没有一家是靠手绘纯色圆盘解决对比度的，与原生的思路一致。

## 七、建议

先做路线 A 的一次探针构建：只把 helper 建起来、把布局弹到当前键盘上、把四个回调打成日志，不改现有逻辑。探针输出 `E:\Dev\ComebackGooglePinyinInput\work\` 下的日志与截图，确认第五节四条之后再替换 `FloatingKeyboardEdit`。

如果探针发现主题解析不对（比如浅色主题弹出来是深色遮罩），再退回路线 B，但那时至少知道要自己解析哪几个属性。
