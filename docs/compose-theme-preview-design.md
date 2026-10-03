# Compose 主题选择页的键盘预览：方案对比

只读主题清单页已经落地（见 `docs/high-min-sdk-settings-migration-research.md` 5.5 节）。
清单能告诉用户「哪个主题用在哪」，但看不到主题长什么样。这一份对比三种把预览补上的做法。

调研日期：2026-10-02。核实对象：`work/decoded-fresh/` 下的原版解码产物。

---

## 一、问题

旧主题选择页有预览：上方一张大图，下方主题网格。Compose 版目前只有文字列表。

要补的是「让用户看见主题」。难点不在画图，在于主题的样式表是二进制资源
（`style_sheet_default.binarypb` 等），Compose 侧没有解析它的现成代码。

因此真正要决定的是：预览图从哪来。

---

## 二、旧页怎么做的（逐行核实）

先纠正一个直觉误区：旧页不给每个网格格子渲染引擎预览图。格子和大图走两条完全不同的路。

### 2.1 网格格子靠「换 Context + inflate」

`bdb.getView` 里没有渲染调用，只有三步：

```smali
new-instance v1, Lbbb;                                   # ContextWrapper
new-instance v2, Lbck;                                   # IKeyboardTheme 实现
invoke-direct {v2, v1, v3, v4, v4}, Lbck;-><init>(Landroid/content/Context;Lbaq;ZZ)V
invoke-virtual {v2, v1}, Lbck;->applyToContext(Landroid/content/Context;)V
invoke-static {v1}, Landroid/view/LayoutInflater;->from(...)
# 然后 inflate(bdd.a.layoutResourceId, ...)
```

`bbb` 是 `ContextWrapper` 子类，唯一动作是把 `layout_inflater` 换成自定义的 `bbc`。
`bck.applyToContext` 遍历一个 `List<Integer>`（主题的 overlay 资源 id），逐个调 `Lgc.a(Context, int)`。

于是 inflate 出来的布局，其 drawable 和 color 自动带上该主题的样式。**格子预览就是布局本身**，
没有位图、没有渲染器、没有异步。

补充一条：`bdb.getItemViewType(i)` 返回 `i`，`getViewTypeCount()` 返回 `max(1, count)`。
每个格子都是独立 view type，GridView 无法复用 view，每次都要重新 inflate。原版不在乎这点开销。

### 2.2 大预览走引擎渲染

上方那张大图才是真渲染，由 `KeyboardPreviewRenderer` 产出。

`ThemeSelectorActivity.a(Lbaq)` 构造它，签名 `(Context, IKeyboardTheme, KeyboardViewDef$Type[], float)`：

| 参数 | 实参 |
| --- | --- |
| Context | `new bbb(activity)` |
| IKeyboardTheme | `new bck(activity, baq, false)` |
| Type[] | `ats.a`，固定为 `[HEADER, BODY]` |
| float | `0.5f`（缩放系数，见下） |

那个 `float` 是**位图缩放系数**。渲染时先按
`makeMeasureSpec(renderer.a:I, EXACTLY)` 与 `makeMeasureSpec(renderer.b:I, EXACTLY)`
测量键盘视图，再 `createBitmap(宽 × 系数, 高 × 系数)` 并 `canvas.scale(系数, 系数)` 绘制。
其中 `renderer.a:I` = `ats.a(Context)` = `DisplayMetrics.widthPixels`（屏幕宽），
`renderer.b:I` = `ats.a(Context, [HEADER, BODY])`（键盘高）。

所以旧页传 `0.5f` 是因为它的展示区只有半宽；**系数要跟着展示尺寸走**，
不是固定值。本项目最终取 `1.0f`，理由见第十节。

随后分两步：

1. 先贴占位图。构造 `LayerDrawable`，一层是全透明 `ShapeDrawable`（尺寸按 renderer 的
   `a`/`b` 字段乘缩放系数），一层是 `0x7f010036` 的 drawable。占位先显示，避免空白。
2. 再发渲染请求 `renderer.a(bundleXmlId, layoutName, receiver)`，返回
   `KeyboardPreviewRequestCanceler` 或 `null`（缓存命中时同步回调，返回 `null`）。

回调 `onKeyboardPreviewReady(String, Drawable)` 把结果贴到 `ThemeSelector` 里的大 `ImageView`。

三点要注意：

- 该方法第 23 行调 `Lany.a()`，实现是「断言在主线程」，违反时抛
  `IllegalThreadStateException`。必须在主线程发起。
- 渲染走 `new InputBundleManager(...)`，是独立实例，不依赖 IME 是否在前台。
  这正是它能在设置 Activity 里工作的原因。
- 取消靠 `KeyboardPreviewRequestCanceler.cancelRequest()`。

### 2.3 触发时机

`a(Lbaq)` 有两个调用点，都发生在用户改动之后：

- `onThemeSelected(int)`：选中了新主题。
- `onKeyBorderOptionChanged(ZZ)`：按键边框开关变化，且第二个参数为真时。

也就是「用户改一次，渲染一次」，不是滚动时逐格渲染。

### 2.4 两个前置偏好键已有强制值

渲染请求需要两个值，缺失会抛 `IllegalStateException`。实测二者都有强制值，不会抛：

| 键 | 值来源 |
| --- | --- |
| `preview_input_bundles_xml_id` | `@xml/ime_zh_cn_pinyin_qwerty`（`0x7f080036`） |
| `preview_keyboard_layout` | 字符串 `zh_cn_pinyin_qwerty` |

强制值写在 `res/values/arrays.xml` 的 `preferences_pinyin_forced_values`（`0x7f0a0030`）里，
由 `PinyinApp.a(Lamx)` 调 `amx.c(0x7f0a0030)` 在应用启动时写入。

注意这里的「写入」**不是写盘**。`amx.c(int)` 把值塞进 `amx` 的 `ConcurrentHashMap`
（`Lamx->a:Ljava/util/concurrent/ConcurrentHashMap;`），而 `amx.a(String,int)` 与
`amx.a(String,String)` 都是「先查这张表，查不到才落到 `SharedPreferences`」。
所以这两个键在设备上的偏好 XML 里**根本不存在**（正式版 `compat` 与测试包都验证过），
直接读 `SharedPreferences` 只会拿到 0 与空串。要拿值必须过 `amx`。
旧页 `ThemeSelectorActivity` 也是这么读的（`amx.a(0x7f110291)` / `amx.a(0x7f110292)`）。

顺带一条简化：`baq.a(Context)` 这个静态方法已经处理完 `additional_keyboard_theme` 与
`keyboard_theme` 的优先级，也处理了「跟随系统」分支。Compose 侧不必自己读偏好键，
直接调它就能拿到与引擎一致的当前主题描述符。

---

## 三、候选 A：反射引擎渲染

复用 `KeyboardPreviewRenderer`，只把调用方式从 smali 改成反射。视觉与旧页完全一致。

### 3.1 调用链

```kotlin
// 1. 当前主题描述符
val baq = baqClass.getMethod("a", Context::class.java).invoke(null, context)

// 2. 包成 IKeyboardTheme
val theme = bckClass
    .getConstructor(Context::class.java, baqClass, Boolean::class.javaPrimitiveType)
    .newInstance(context, baq, false)

// 3. 构造渲染器
val renderer = kprClass.getConstructor(
    Context::class.java, iktClass, typesArrayClass, Float::class.javaPrimitiveType,
).newInstance(bbbContext, theme, atsA, scale)

// 4. 请求（主线程）
val canceler = kprClass
    .getMethod("a", Int::class.javaPrimitiveType, String::class.java, receiverClass)
    .invoke(renderer, bundleXmlId, layoutName, proxyReceiver)
```

回调接口 `KeyboardPreviewReceiver` 只有一个方法，可以用 `java.lang.reflect.Proxy` 实现，
无需新增 Java 源码。

`typesArrayClass` 不能写 `Array<Any>::class.java`，要用
`java.lang.reflect.Array.newInstance(typeElementClass, 0).javaClass` 拿到精确的数组类。

### 3.2 成本

- 反射约 30 到 50 行，集中在一个 `ThemePreviewRenderer` 里。
- 需要新增一个 Compose 组件承载大图与占位状态。
- 需要处理取消：`DisposableEffect` 里调 `cancelRequest()`。
- `bundleXmlId` 与 `layoutName` 必须反射 `amx` 读（见 2.4：值只在内存里）。
  退一步的 `resources.getIdentifier("ime_zh_cn_pinyin_qwerty", "xml", packageName)`
  只能解决 `bundleXmlId`，`layoutName` 仍无来源，所以不作为主路径。

### 3.3 风险

| 风险 | 说明 | 缓解 |
| --- | --- | --- |
| 混淆名耦合 | 反射依赖 `baq`/`bck`/`bbb`/`ats` 等类名 | 本项目即上游，名字稳定。加一条门禁断言这些类与方法签名存在 |
| 主线程要求 | 必须主线程发起 | Compose 侧本就在主线程 |
| 异步回调与生命周期 | 页面销毁后回调可能落到已回收的 state | `DisposableEffect` 取消 + 弱引用状态 |
| 首次渲染有延迟 | 要加载 bundle xml | 先贴占位图，与旧页一致 |
| 缓存语义未确认 | `Latp` 在 `<init>` 里 `new`，每次新建渲染器可能丢缓存 | 见第八节待确认项 |

---

## 四、候选 B：样式表驱动自绘

不复用引擎，自己在 Compose 里画一个键盘示意图，颜色从主题样式表取。

思路是复刻 2.1 的语义：解析 `style_sheet_default.binarypb`，用 `bbn` 那套
`SparseArray` 固定映射把颜色键映射到按键背景、按键文字、候选栏等元素，再画出来。

成本明显更高：

- 要完整理解样式表的 protobuf 结构（`ThemePackageMetadata` 只是外层，样式表是另一层）。
- 要复刻 `bbn` 的映射表，且内置 17 套主题各有差异。
- 视觉必然与真实键盘有出入，字体、间距、圆角都对不上。
- 用户改一个主题，看到的是「示意图」，不是「实际效果」。

好处是不引入反射、无异步、纯 Compose，测试面干净。

---

## 五、候选 C：暂不做预览

沿用已落地的清单形式：主题名 + 槽位标注。

代价是「主题背景」页仍然只能看名字。对 17 套内置主题来说，中文名
（`黑色主题`、`浅色主题` 等）已经能表达大部分信息，可接受度不低。

这条路把决策推迟到写入路径做完之后。届时如果能直接从 `bck` 取到已解析的样式，
候选 B 的成本会下降。

---

## 六、对比

| 对比项 | A 反射引擎 | B 样式表自绘 | C 不做 |
| --- | --- | --- | --- |
| 视觉一致性 | 与旧页完全相同 | 有可见差异 | 无预览 |
| 实现量 | 中（反射封装 + 组件） | 高（解析 + 映射 + 绘制） | 零 |
| 新增门禁 | 类与方法签名存在性 | 样式表解析结果 | 无 |
| 依赖混淆名 | 是 | 否 | 否 |
| 异步与生命周期 | 需处理 | 无 | 无 |
| 可测试性 | 反射层难单测 | 纯逻辑可单测 | 不适用 |
| 后续维护 | 上游类改名即失效 | 自主可控 | 无 |

---

## 七、建议

**选 A。**

理由有两条。一是它复用唯一的真实渲染路径，用户看到的与最终生效的主题必然一致，
不存在「预览和实际不一样」这类难解释的问题。二是前置条件已经查实满足，
两个强制值都在，不需要额外注入任何东西。

候选 B 的成本被低估的风险较大。样式表是二进制格式，内置主题 17 套，
要画到「看起来像」的程度，工作量可能超过整个只读切片。

如果担心反射耦合，可以在阶段 2 先落 A，同时加一条门禁：
断言 `baq`、`bck`、`bbb`、`ats` 与 `KeyboardPreviewRenderer` 的类名、构造签名、
`a(int, String, receiver)` 方法签名都能在解码产物里找到。这样上游一旦变动，构建期就会失败，
不会变成运行期崩溃。

---

## 八、待确认项

1. **`Latp` 缓存是否跨渲染器共享。** 构造器里是 `new-instance v0, Latp;`，看起来每实例一份。
   若确实如此，每次渲染都要重新加载 bundle，需要自己缓存渲染器实例或结果位图。
   做法：在真机上连续切换两个主题，看第二次是否明显更快。也可以直接读 `Latp` 的实现。
2. ~~**`bundleXmlId` 与 `layoutName` 的读取方式。**~~ 已定，且**第一版定错了**：
   以为直接读默认共享偏好即可，实测两者都拿不到。正确做法是反射 `amx`。见第十节。
3. **自定义主题能否走同一条路。** `baq.a(Context)` 对 `files:` 前缀的取值应同样有效，
   但用户主题目录尚未在真机验证。这条要等写入路径做完才能确认。
4. **是否需要为每个槽位各渲染一张。** 旧页只渲染当前选中主题。清单页若要展示
   浅色槽与深色槽各自的预览，渲染次数从 1 次变成 4 次，需要评估耗时。

---

## 九、已落地（2026-10-02）

按候选 A 实现。**未做真机验证。**

| 文件 | 内容 |
| --- | --- |
| `compose/ThemePreviewBridge.kt` | 反射桥接：加载 8 个类、构造渲染器、发请求、包装取消 |
| `compose/ThemePreview.kt` | Compose 组件：承载 `ImageView`，换主题时取消上一次请求 |
| `compose/ThemeCatalogScreen.kt` | 顶部固定预览，点主题行切换；不可用时整块不占版面 |
| `compose/ThemeCatalog.kt` | 新增 `activeValue`，当前生效主题 |
| `compose/LegacySettingsRepository.kt` | 读 `additional_keyboard_theme` 填 `activeValue` |
| `scripts/verify_theme_preview_bridge.py` | 新增门禁 |

实现要点：

1. ~~**两个偏好键直接读共享偏好，不反射 `amx`。**~~ **这条是错的，见第十节。**
   已改为反射 `amx.a(String,int)` 与 `amx.a(String,String)`。
2. **渲染器每次新建**，与旧页一致。`Latp` 的缓存语义仍未确认，见第八节第 1 条。
3. **主线程发起**，回调里再 `post` 一次到主线程，因为 `InputBundleManager`
   的回调线程没有保证。
4. **失败静默降级**：`render` 用 `runCatching` 包住。预览是装饰，不能把设置页带崩。
5. **不可用时整块不渲染**，不给「预览不可用」留空位。

门禁 `scripts/verify_theme_preview_bridge.py` 断言三件事：

- 桥接里的 9 个类名常量都能在解码产物里找到对应的 smali 文件。
- 10 条成员签名仍然存在，含 `baq.a(Context, String)`、`bck.<init>`、`ats.a`、
  `amx.a(Context)` / `amx.a(String,int)` / `amx.a(String,String)`、
  渲染器构造、`a(int, String, receiver)`、`cancelRequest`、`onKeyboardPreviewReady`。
  其中 `amx` 的三条与渲染器的三条都从桥接的常量推导，改常量名会被抓到。
- 两个偏好键名与 `strings.xml` 一致，且仍出现在 `preferences_pinyin_forced_values` 里。

反向验证做了四次：把 `DESCRIPTOR_CLASS` 改成 `baqx`、把 `PREVIEW_LAYOUT_KEY`
改成 `preview_layout_wrong`、把 `PREFERENCES_CLASS` 改成 `amxq`、把
`PREFERENCES_ACCESSOR` 改成 `b`，门禁都如期失败。

验证结果：`:compose-runtime:testDebugUnitTest` **83 通过 / 0 失败**；
`verify_theme_preview_bridge.py`、`verify_modern_settings_runtime.py`、
`verify_chinese_copywriting.py` 全绿。

**仍未做：真机验证。** 要确认四件事：渲染是否成功、预览与键盘实际外观是否一致、
连续切换两个主题的耗时（用来回答 `Latp` 缓存问题）、
自定义主题（`files:` 前缀）能否走通同一条路。

---

## 十、真机第一轮：预览没出现，根因是读偏好的方式（2026-10-02）

测试包 `dist/pinyin-dev-preview.apk`（`...pinyin.dev`）装到 Pixel 10 Pro / API 36。
设置页能进，主题清单页能出，但**顶部没有预览**，且连占位高度都没有。

### 10.1 定位

`ThemePreview` 有两个提前返回：`!available` 与 `themeValue.isEmpty()`。
两者都不占版面，从截图分不出来，于是分别验证。

- **`themeValue` 确实是空的**：`additional_keyboard_theme` 在设备上是空串（新装包没选过主题）。
  这只是次要原因。
- **`available` 为 false 才是主因**：`isAvailable()` 要求两个偏好键有值，而设备上的
  `com.google.android.inputmethod.pinyin.dev_preferences.xml` 里**这两个键根本不存在**，
  `theme_array_id`、`bordered_theme_array_id` 等其它强制键也都不存在。

### 10.2 为什么不存在

`amx.c(int)` 走 `amx.a(int, Writer)`，把强制值塞进
`Lamx->a:Ljava/util/concurrent/ConcurrentHashMap;`；而读取侧

```text
amx.a(String key, int def)     先 map.get(key)，命中就返回；否则 SharedPreferences.getInt
amx.a(String key, String def)  同上，字符串版本
```

即**强制值只活在内存里，从不落盘**。所以 `SharedPreferences` 里没有它们，
而第一版桥接恰好直接读 `SharedPreferences`，于是 `isAvailable()` 恒为 false。

对照实验（决定性）：把两个键从设备偏好文件里清掉，直接启动旧页
`ThemeSelectorActivity`，它的预览**照常渲染**（截图 `work/shots/07-legacy-selector.png`）。
旧页读的正是 `amx.a(0x7f110291)` / `amx.a(0x7f110292)`，证明值确实在内存表里。
同一实验也排除了「强制值机制在本构建里失效」这一可能。

另一条对照：正式版 `compat`（长期作为默认输入法）的偏好文件里同样没有这两个键，
说明这是全局行为，不是测试包特有。

### 10.3 修复

`ThemePreviewBridge` 改为反射 `amx`：

```text
amx.a(Context)                        → 门面实例（静态）
facade.a(String key, int def): int    → bundleXmlId
facade.a(String key, String def)      → layoutName
```

键名仍用桥接里已有的 `preview_input_bundles_xml_id` 与 `preview_keyboard_layout`
（`amx` 的这两个重载本来就是按**键名**取值的），所以不需要 `R.string` 的 id，
也不需要 `getIdentifier`。门禁新增 `amx` 类与这三条签名。

### 10.4 同一轮顺带确认的

- 渲染链路本身是通的：手工把两个键写进设备偏好后，Compose 预览正常出图，
  画的是 `material_dark`，与旧页预览同一套键位（截图 `work/shots/06-preview-after-inject.png`）。
- 修好读偏好之后，`themeValue` 为空仍是问题：新装包 `additional_keyboard_theme` 是空串。
  需要决定空值时显示什么（当前是不渲染）。

### 10.5 仍未验证

渲染与键盘实际外观的一致性、连续切换两个主题的耗时（`Latp` 缓存）、
自定义主题（`files:` 前缀）、快速连点时的取消行为。这四条要等修复后的包重新构建。

---

## 十一、真机第二轮：预览细线与真实键盘不一致（2026-10-02）

修复读偏好之后预览能出了，但细线（键位分隔线、数字行下的那条线）与真实键盘对不上。

### 11.1 原因：缩放系数照抄了旧页

第一版把 `PREVIEW_SCALE` 照抄成旧页的 `0.5f`，但两边的展示尺寸完全不同：

| | 位图宽度 | 展示宽度 | 结果 |
| --- | --- | --- | --- |
| 旧页 | `1080 × 0.5` = 540 px | 540 px（原尺寸） | 1:1，清晰 |
| 第一版 | 540 px | 984 px（`fillMaxWidth`） | 1.82 倍放大，细线糊掉 |

`canvas.scale(0.5)` 是**真下采样**：1 px 的线在 0.5 倍下只有半个像素，
栅格化后已经变淡或消失，再放大 1.82 倍只会把损失摊开。真实键盘按 1.0 绘制，
所以两边必然不同。

### 11.2 修复

`PREVIEW_SCALE` 改为 `1.0f`。这样位图尺寸正好是
`widthPixels × 键盘高度`，即真实键盘在屏幕上的占位；展示时是 984/1080 ≈ 0.91
的单次降采样，细线能保住。

若要做到**零重采样**，需要让位图宽度等于展示宽度，
即 `scale = 展示宽度 / widthPixels`，代价是要等测量完成再渲染。
当前先不做，等最终版式定下来再决定是否值得。
