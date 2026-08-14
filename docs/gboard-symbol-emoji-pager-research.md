# Gboard 与 Google 拼音全键盘符号/表情横向 Pager 手感研究

## 范围

本任务与 V32 的「滑动后取消误选」分离，只研究：

- Google 拼音全键盘符号、表情和颜文字的横向分页为何容易回弹
- 当前目标页、fling、touch slop 与速度判定
- Gboard 当前符号/表情容器的实现
- 是否存在不影响候选分页和点击稳定性的局部改进。

当前阶段只调查，不修改 pager 参数。

## Google 拼音实际界面路径

手机布局中的三个界面分别为：

- `keyboard_non_prime_symbol_body.xml`
- `keyboard_non_prime_smiley_body.xml`
- `keyboard_non_prime_emoticon_body.xml`。

三者都使用：

`PageableRecentSubCategorySoftKeyListHolderView`
→ `PageableSoftKeyListHolderView`
→ 混淆基类 `lk`
→ `ViewGroup`

`lk` 日志名称为 `FourDirectionalView`，本质是 Google 输入法旧框架中的多方向 ViewPager 实现。它负责手势拦截、拖动、VelocityTracker、目标页计算、Scroller 动画和 edge effect。

V32 修改的 `aws` 只在 `lk.onTouchEvent()` 完整处理事件之后运行。因此 V32 会取消外层按键释放，但不会改变 `lk` 已经计算出的目标页。

## 当前 `lk` 的手势参数

### 开始拖动

- 使用 `ViewConfiguration.getScaledPagingTouchSlop()`
- 水平位移必须大于 paging touch slop
- 水平位移还必须大于垂直位移
- 满足后 pager 才进入 dragging。

### 松手目标页

UP 时先使用 VelocityTracker 计算当前指针速度。

若同时满足：

1. 从初始触点到松手位置的绝对距离大于 `25dp`
2. 绝对速度大于系统 `getScaledMinimumFlingVelocity()`

则按速度方向切换到相邻页。

否则进入位置判定：

- 当前页偏移超过约 50% 才进入下一页
- 未超过 50% 就回弹到原页。

这与真机现象一致：慢速单指滑动如果没有越过半页，很容易回弹；只有明确、快速的 fling 才能用较短距离换页。

## 与候选展开列表的差异

展开候选列表「滑起来轻松」不能直接证明同一 pager 参数正常：

- 部分候选区域是连续 ScrollView/候选容器，不需要跨过整页 settle 阈值
- 即使使用 `PageableCandidatesHolderView`，页面尺寸、方向、内容布局和用户手势速度也不同
- 全键盘符号/表情每页接近整个输入区域宽度，50% 位置阈值在视觉和手指距离上更明显。

## Gboard 当前实现

### 表情分页

Gboard `PageableEmojiListHolderView` 不再使用旧 `FourDirectionalView`。它 inflate 的页面容器是：

`androidx.viewpager2.widget.ViewPager2`

布局明确设置水平 orientation，并配置：

- RecyclerView-backed pager
- offscreen page limit
- page margin
- AndroidX 的触摸、velocity、snap 和 child-CANCEL 管线。

因此现代 Gboard 表情分页手感来自 ViewPager2/RecyclerView 的整体实现，不是对旧 `lk` 单个常量的修改。

### Rich Symbols

现代 Gboard Rich Symbols 使用：

- `CategoryViewPager` 负责大类导航
- `RichSymbolRecyclerView` / BindingRecyclerView 展示符号网格
- 手机和 tablet 有独立 keyboard/controller 实现。

其内容浏览更多依赖 RecyclerView 与类别切换，不再等价于 Google 拼音「每屏固定网格、整页横向翻动」的旧模型。

### 旧候选 pager

Gboard 中仍保留的旧候选 pager `ckq` 可以看到与 `lk` 相同的：

- 25 dp fling distance
- 系统 minimum fling velocity
- 非 fling 时约 50% settle。

这说明不能以「Gboard 旧候选 pager 也使用 50%」推导出现代符号/表情仍应使用旧手感；Gboard 已经把真正的表情/富符号界面迁移到 RecyclerView/ViewPager2。

## 可选改进及风险

### 方案 A：直接降低 50% settle

例如仅对符号/表情改为 35%。

优点：慢速拖动更容易换页。

风险：

- 缺少 Gboard 对应常量证据
- 轻微横向移动更容易意外翻页
- 必须保证只作用于 `PageableRecentSubCategorySoftKeyListHolderView`，不能影响候选 pager
- `lk` 的目标页方法是 private，局部覆写不直接可用，需要在共享基类加入类型分支。

当前不建议首先采用。

### 方案 B：只改善 fling 判定

保留 50% 位置阈值，但让明确快速滑动更容易进入 velocity 路径，例如只针对符号/表情重新评估 25 dp 额外距离门槛。

优点：

- 慢速小位移仍回弹，不容易误翻
- 更接近 ViewPager2/RecyclerView 以 fling + snap 为主的交互
- 变更可限定在符号/表情 subclass。

风险：仍需确认真机失败手势究竟是速度不足、25 dp 距离不足，还是 pager 没有进入 dragging。没有诊断数据时直接改阈值仍属于猜测。

### 方案 C：迁移 ViewPager2/RecyclerView

最接近现代 Gboard，但对当前项目不是小补丁：

- 原 APK 没有现成 AndroidX ViewPager2 集成路径
- 需要重做 adapter、页面缓存、类别状态、最近使用项、SoftKeyView listener、无障碍和生命周期
- smali 层回归面过大
- 更适合 target API 与渲染框架现代化阶段。

当前不实施。

## 推荐下一步：先做诊断版

在不改变行为的前提下，只针对 `PageableRecentSubCategorySoftKeyListHolderView` 记录一次 UP 决策所需数据：

- 是否进入 dragging
- 总水平位移
- X velocity
- minimum fling velocity
- 当前页面偏移比例
- 最终目标页。

由维护者分别复现「成功翻页」和「回弹」手势，再根据数据决定：

- 若经常未进入 dragging：调查方向竞争和 paging touch slop
- 若位移超过 25 dp 但速度不足：不应降低 distance，应评估 velocity
- 若速度足够但距离不足：可考虑只移除符号/表情的 25 dp 双重门槛
- 若两者都不足且偏移常在 35%–50%：才考虑局部降低 settle 阈值。

这样可以避免凭手感猜常量，也避免影响已经通过 V32 验证的点击取消与候选分页。

## V33 诊断版

V33 已实现上述无行为修改的诊断：

- 只在 `lk` 的 UP 目标页计算路径插入只读调用
- `PagerDiagnosticsCompat` 通过 `instanceof PageableRecentSubCategorySoftKeyListHolderView` 排除候选 pager 和其他 `lk` 使用者
- 不修改任何 `lk` 字段、MotionEvent、阈值、velocity、target 或 Scroller 调用
- 日志 tag 为 `GPPagerDiag`
- 每次有效拖动松手记录 current、target、changed、offset、distance、25 dp threshold、velocity、minimum velocity、fling 与最终 page/snap_back。

APK 安装后已清空 Logcat。维护者随后完成了成功翻页与回弹复现。

## V33 采样结果

当前 Logcat 中可完整解析 30 次目标页决策：

- 成功翻页：9 次
- 回弹：21 次
- 进入 fling 分支：0 次
- 旧 pager 用于 25 dp 检查的 distance：30 次全部为 0
- 系统 minimum fling velocity：131 px/s
- 21 次回弹中有 16 次松手速度已经超过 minimum velocity
- 回弹样本绝对速度中位数约 3792 px/s，最高 11016 px/s
- 成功样本 offset 范围约 0.545–0.780
- 回弹样本 offset 范围约 0.167–0.424。

结论非常明确：pager 已经进入 dragging，VelocityTracker 也产生了远高于 minimum 的速度，但旧 `lk` 的额外 distance 条件始终失败，导致 fling 路径完全不可达。所有成功翻页都来自拖过 50% 后的位置 settle；所有未超过 50% 的快速 flick 仍然回弹。

这也解释了「需要用力拖过半屏」的手感。问题不在 paging touch slop，也不在 velocity 太低，而在旧实现把 final pointer position 与其内部基准 `c` 的差值作为额外 25 dp 门槛；在当前 Android 事件序列中该差值归零，不能代表整次手势总位移。

### 最小修正依据

现代 Gboard 的 ViewPager2 由 RecyclerView fling/snap 驱动：容器已经进入 dragging 后，主要使用 velocity threshold 决定 fling，不再叠加这个失效的旧 `lk` final-delta 25 dp 门槛。

建议仅对 `PageableRecentSubCategorySoftKeyListHolderView`：

- 保留 `getScaledPagingTouchSlop()` 与「水平位移大于垂直位移」的 dragging 判定
- 保留系统 minimum fling velocity
- 保留非 fling 时 50% settle
- 跳过失效的 25 dp final-delta 条件，让已确认 dragging 且 velocity 超过 minimum 的手势进入原有 fling 目标页逻辑
- 候选 pager 和其他 `lk` 使用者继续保留原逻辑。

这比猜测性降低 50% 阈值更有证据，也不会让慢速小幅拖动自动翻页。

## V34 局部修复

V34 已按诊断结论实现：

- 在共享 `lk` 的 fling 双重门槛处增加精确类型判断
- 仅 `PageableRecentSubCategorySoftKeyListHolderView` 跳过失效的 legacy final-delta 25 dp 条件
- 仍要求 pager 已通过原生 paging touch slop 和方向竞争进入 dragging
- 仍要求绝对 velocity 大于系统 minimum fling velocity
- velocity 不足时继续使用原生 50% settle
- 候选 pager 和其他 `lk` 使用者仍执行原来的 distance + velocity 双重条件
- V32 外层点击取消、页码、target clamp、Scroller 和动画均未修改。

V34 真机测试确认单指可以轻松左右翻页，点击、误选防护及其他已测路径未出现问题，局部 fling 修复通过。验证后制作 V35 正式版：删除 `PagerDiagnosticsCompat` 及 `lk` 中全部诊断调用，只保留经过验证的符号/表情类型分支。正式构建不再产生 `GPPagerDiag` 日志。

## API 36 高刷新率复核

### 正式版基线

在 Pixel 10 Pro / Android 16 上分别清空 `gfxinfo framestats`，由维护者在 Emoji、颜文字和标点/符号页面各完成 6 次单手横向滑动。采集只包含帧调度和呈现时间，不记录页面内容、触摸坐标或截图。

三个页面都被旧 IME Surface 稳定调度为约 60 fps：

- Emoji 实际呈现帧间隔中位数为 16.6775 ms
- 颜文字实际呈现帧间隔中位数为 16.6719 ms
- 标点/符号实际呈现帧间隔中位数为 16.6751 ms
- 三页合计只有 1 个活动间隔位于 7–10 ms，335 个位于 15–19 ms
- `Thermal Status=0`

App p95 为 5.035–5.673 ms，GPU p95 为 0.884–0.993 ms；三个页面分别有 114/120、116/120 和 117/120 帧在 8.33 ms 内完成。因此根因不是 CPU、GPU 或热节流，而是与 Candidate 动画相同的 60 Hz 内容分类。

### 生命周期方案

不恢复固定 120 Hz、Window touch boost 或定时器。高刷请求直接复用旧 `lk` 已有的运动状态机：

```text
确认进入 dragging       → HIGH
Scroller.startScroll()   → HIGH
Scroller 结束            → NO_PREFERENCE
新触摸中断旧 settle      → NO_PREFERENCE
View 隐藏或 detach       → NO_PREFERENCE
```

`PagerFrameRateCompat` 先执行精确 `instanceof PageableRecentSubCategorySoftKeyListHolderView`。因此共享 `lk` 和 `PageableSoftKeyListHolderView` 中的生命周期钩子只影响 Emoji、颜文字和标点/符号共用的 pager，不改变 Candidate pager 或其他 `lk` 使用者。

API 36 调用集中在 `ViewFrameRateCompat`，通过反射调用公开的 `View.setRequestedFrameRate(float)`。API 17–35 不直接解析该方法并保持无操作。Candidate 动画与 pager 共享 API 中立的 View 桥，但各自维护独立 View 和生命周期，不引入 Window 级全局状态或固定刷新率。

### 隔离审计结果

non-debuggable 隔离包在三页各完成 6 次单手滑动后：

- Emoji 实际呈现帧间隔中位数由 16.6775 ms 降为 8.3397 ms
- 颜文字由 16.6719 ms 降为 8.3390 ms
- 标点/符号由 16.6751 ms 降为 8.3448 ms
- 三页持续滑动和 settle 主体均进入约 120 Hz，少量 16.67 ms 帧位于触摸开始、页面停顿或动态刷新率切换边界
- 每页停止后 IME UID 高刷请求均消失，显示回到 60 Hz
- `Thermal Status=0`
- 维护者确认三页手感均有改善且点击、滑动未发现异常

V34 目标页算法保持不变。维护者额外做了 10 次快速短滑，其中 2 次回弹。这不足以证明新的结构性缺陷，不据此降低原生 50% settle 阈值。

临时布尔分支诊断包在二次重建后无法弹出键盘。最初筛选到的日志包含首次引导 Activity 被 Android 后台启动限制阻止，但后续从系统 DropBox 取得的完整记录确认直接故障是 4 次相同的 `ClassCastException`：临时包把某个键盘布局根视图构建成 `LinearLayout`，而 `GoogleInputMethodService.loadSoftKeyboardView()` 要求 `SoftKeyboardView`。异常发生在键盘视图加载阶段，尚未进入 pager 交互，不能作为 fling/settle 决策证据。故障后立即恢复正式 IME 并卸载临时包。正式实现不包含布尔诊断日志，也未采用该临时包的二次重建路径。
