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

---

## 十二、版式重做：Gboard 式缩略图网格（2026-10-03）

### 12.1 方向

此前那一版主题清单页只是**功能验证载体**（能出预览、能读偏好就算过关），
版式是「顶部大预览 + 一行一个主题的列表」。用户确认最终视觉效果对标 Gboard，
即**缩略图网格 + 大预览**，并选择先做版式、写入路径随后。

### 12.2 缩略图不必跑引擎渲染

直觉上「每格一张缩略图」会让人以为要逐格调引擎渲染，其实不用。旧页的格子
本来就不是贴图（见 2.1）：它是把真实键盘布局 inflate 进一个换过 Context 的容器，
靠主题属性着色。所以复用同一条路，成本是**每格一次 layout inflate**，
没有位图、没有栅格化、也没有引擎调用。

旧页的格子有三种，由 `bdc` 枚举区分，每种自带要 inflate 的布局 id
（字段 `layoutResourceId`）：

| `bdc` 常量 | 布局 | 用途 |
| --- | --- | --- |
| `BUILDER_LAUNCHER` | `theme_selector_candidate_builder_launcher` | 「我的图片」，无主题 |
| `CANDIDATE` | `theme_selector_candidate` | 一个内置或用户主题 |
| `EDITABLE_CANDIDATE` | `theme_selector_candidate_editable` | 可删除的用户主题 |

`BUILDER_LAUNCHER` 与 `CANDIDATE` 的差别只在布局：前者不套主题属性
（只用框架资源与自带 drawable），所以可以拿裸 Context 直接 inflate；
后者引用 `?BgSpaceTiny`、`?IconImeActionBack` 这类主题属性，必须换 Context。

### 12.3 格子顺序对齐旧页

旧页 `ThemeSelectorActivity.a()` 往列表里加的次序是：

```text
BUILDER_LAUNCHER                        （我的图片，第一个）
gc.a(Context)  → filesDir 下的主题      （用户主题，EDITABLE_CANDIDATE）
gc.c(Context)  → 额外主题目录            （正常设备上该资源为空，不产生格子）
内置数组 0x7f0a000e                     （内置主题）
```

Compose 侧按同样次序排：我的图片 → 自定义 → 内置。第四段在设备上恒为空，
所以不实现。第一段的「我的图片」当前**只占位、点击不动作**，
等写入路径那一阶段接图片选择器时再挂上。

### 12.4 选中态

旧页的格子根布局是 `CheckableFrameLayout`，`setChecked(Z)` 会切
`state_checked`，前景选择器随之显示打勾图标。

**这个勾是谁打的，第一版查错了。** 全仓 grep `setChecked` 在主题包里零命中，
于是当时结论是「没人调、勾不出现」。实际调用方在框架层：旧页网格是 `GridView`，
`ThemeSelectorActivity.c()` 调 `GridView.setItemChecked(i, true)`，
`AbsListView.updateOnScreenCheckedViews()` 再对 `Checkable` 子视图调
`setChecked()`。所以 grep 应用层代码永远找不到，但勾确实会出现，
打在**当前生效**的那个主题上（用 `baq.equals` 逐个比对得到下标）。

Compose 侧不是 `GridView`，没有这层机制，所以桥接新增
`markSelected(View, Boolean)`，`ThemeCard` 在 `update` 里调用。

打勾的目标有一处**有意的差异**：旧页打在当前生效的主题上，
Compose 页打在当前**正在预览**的主题上。两者在打开页面时重合
（初始预览值就是生效值），点过格子之后分开。写入路径落地后点击即应用，
两者会再次重合。

### 12.5 格子尺寸

格子尺寸取自 `@dimen/theme_selector_candidate_width`（128 dip）与
`_height`（92 dip），`@style/ThemeSelectorCandidate` 也用同一对值。
Compose 侧拿不到 dimen（多一次反射不值得），所以在
`ThemeCatalogScreen.kt` 里写成常量，由门禁比对，见 12.6。

### 12.6 门禁

`scripts/verify_theme_preview_bridge.py` 扩展为断言四件事：

- 桥接里的 **11 个类名常量**都能在解码产物里找到对应 smali。
- **15 条成员签名**仍然存在（新增 `bck` 的四参构造、`bdc` 的三个字段、
  `CheckableFrameLayout.setChecked(Z)V`）。其中 `bdc` 的常量名、
  `layoutResourceId` 字段名、`setChecked` 方法名都从桥接常量推导。
- **2 个强制偏好键**仍与 `strings.xml` 一致且仍在强制值数组里。
- **2 个格子尺寸**与 `dimens.xml` 一致。

反向验证做了三次：`THEME_CELL_WIDTH_DP` 由 128 改 130、`CARD_KIND_THEME`
改成 `CANDIDATEX`、`CARD_CHECK_METHOD` 改成 `setCheckedX`，门禁都如期失败。

### 12.7 仍未解决：没选过主题时顶部预览是空的

真机上新装包 `additional_keyboard_theme` 是空串，Compose 预览整块不渲染，
而**同一状态下旧页照常出图**（`work/shots/32-legacy-empty-theme.png`）：
浅色键盘 + 勾在浅色内置主题上。这说明引擎的**生效**主题不是空串，
`baq.a(Context)` 会沿 `keyboard_theme` 一路回退，最终落到浅色内置主题。

Compose 侧读的是**原始偏好值**而不是**生效值**，所以两边不一致。
正确做法是反射 `baq.a(Context)` 取字段 `b`（旧页初始渲染用的就是它），
而不是继续读 `additional_keyboard_theme`。这条要在版式重做时一并改掉。

### 12.8 版式方向被否：这不是 Gboard

12.1 到 12.6 做出来的东西**是旧主题选择页的复刻**，不是 Gboard。用户指出三处差距：

1. **没有按功能分区**。Gboard 把模式类主题（动态配色、浅色/深色模式主题）
   与内置主题、自定义主题分开成组；这一版是一整块连续网格。
2. **共用一个顶部预览区**。Gboard 是点击缩略图后**弹出**预览区域，
   弹层里带「应用」与「显示按键边框」开关；这一版把预览钉在页面顶部。
3. 因此点击的语义也不同：Gboard 的点击进入「预览 → 确认应用」，
   这一版点击只是换一下顶部预览。

12.2 至 12.6 的**技术结论仍然有效**（缩略图靠 inflate 而非引擎渲染、
`bdc` 三种格子、尺寸取值、门禁、选中态机制），可以继续用；
需要重做的是**页面结构**。

---

## 十三、最终版式：Gboard 骨架 + 保留四槽（2026-10-03）

### 13.1 规格

三区、三列、点击弹层。分区不是装饰，它是这次重做的全部要点：

| 分区 | 内容 | 说明 |
| --- | --- | --- |
| 我的主题 | `＋` 磁贴 + `filesDir` 下的自定义主题 | `＋` 暂不动作，等图片选择器 |
| 默认 | 动态颜色 + 系统自动 + 默认 + 默认深色 | 四格单选，带文字标签 |
| 颜色 | 17 套内置主题 | 标题右侧可折叠 |

三列对应旧页网格的列数，磁贴比例沿用
`theme_selector_candidate_width / _height`（128 : 92），
所以形状与旧页一致，只是间距由 Compose 的 `Arrangement` 给。

「系统自动」格用**左右对半**缩略图（左浅右深），这是 Gboard 的做法，
也是这一格唯一能自证语义的方式：单张主题图无法表达「跟着系统变」。
实现上把整张样本布局按格宽绘制，再 `clipToBounds` 裁掉一半，
所以每半读起来是键盘的切片，而不是被压扁的整张键盘。

### 13.2 四槽怎么落进没有槽位行的界面

本页最终要**取代**「主题背景」页（见 13.6），槽位行没有摆放位置。
用户定的规则：

- 固定颜色主题的弹层里给两个写入按钮：「设为浅色模式主题」「设为深色模式主题」。
- 从未设置过的用户，浅色槽与深色槽**预设为 `material_light` / `material_dark`**，
  这两个值就是引擎自己在无存储时的回退目标
  （`pref_entry_additional_keyboard_theme_material_light` / `_dark`），
  所以「跟随主题」对新用户也可用，不需要先手动指定一次。
- 「默认」区四格＝四种模式（动态颜色 / 系统自动 / 固定浅色 / 固定深色）单选。
  未设置过时浅色格视为选中，因为引擎此时画的就是浅色默认值。

### 13.3 「跟随主题」改名「系统自动」

用户要求对齐 Gboard 的叫法以降低理解成本。改的是**显示文案**：
`modern_settings_system_auto_theme_title` 由 `Follow theme` 改为 `Auto (system)`，
中文由「跟随主题」改为「系统自动」，繁体同步。
偏好键与槽位语义不变。

### 13.4 桥接新增三个方法

| 方法 | 反射目标 | 用途 |
| --- | --- | --- |
| `activeThemeValue(Context)` | `baq.a(Context)` 的字段 `b` | 取**生效**主题，解掉 12.7 |
| `keyBorderEnabled(Context)` | `gc.c(Context)` | 读按键边框的**生效**值 |
| `setKeyBorderEnabled(Context, Boolean)` | `amx.a(String, Boolean)` | 写按键边框偏好 |

前两个都刻意**不读偏好**：`keyboard_theme` 与 `additional_keyboard_theme`
都有回退链，按键边框偏好还有系统属性回退。读存储值会得到与画面不一致的答案，
所以统一走引擎自己的解析入口。第三个是纯偏好，没有槽位、没有强制值，
可以在主题写入路径之前独立落地。

（`gc.c(Context)` 这个解析入口后来出过一次事：`gc` 在同一名字和参数下还有一个
返回 `File` 的重载，`Class.getMethod` 取错了那一个。见 16.2。）

同时删掉了 `CARD_KIND_USER_IMAGE` 与 `inflateUserImageCard`：
「我的图片」格在新版式里是自绘的描边磁贴，不再借道 `BUILDER_LAUNCHER` 布局。

### 13.5 门禁

`scripts/verify_theme_preview_bridge.py` 现在断言六件事：

- **12 个类名常量**都能在解码产物里找到对应 smali（新增 `gc`）。
- **19 条成员签名**仍然存在。新增的有 `baq.a(Context)`、
  `baq.a(Context, String)`、`baq.b` 字段、`amx.a(String, Z)Z`、
  `amx.a(String, Z)V`、`gc.c(Context)Z`；`bdc` 去掉了 `image_kind`。
- **2 个强制偏好键**仍与 `strings.xml` 一致且仍在强制值数组里。
- **1 个按键边框偏好键**与 `strings.xml` 一致。它是唯一**不带强制值**的，
  所以只比对键名。
- **2 个格子尺寸**与 `dimens.xml` 一致。
- **2 个默认预设**（`LIGHT_PRESET_VALUE` / `DARK_PRESET_VALUE`）与
  `strings.xml` 里那两个 `pref_entry_*` 的值一致，取自 `ThemeCatalogScreen.kt`。

反向验证做了三次：`KEY_BORDER_KEY` 改成 `enable_key_borderX`、
`LIGHT_PRESET_VALUE` 改成 `..._lightX.binarypb`、`BORDER_STATE_CLASS` 改成 `gcX`，
门禁都如期失败。

### 13.6 本轮不做的事

- **写入路径**：弹层的「应用」「设为浅色模式主题」「设为深色模式主题」
  目前 `enabled = false`，是刻意的——宁可灰着，也不要看起来能点却没反应。
- **入口切换**：本页尚未取代「主题背景」页。写入路径没落地之前切入口，
  用户会失去换主题的能力，所以本轮两页并存。
- **`＋` 磁贴**：`onClick = {}`，等图片选择器。

---

## 十四、磁贴改成配色格，以及三处修正（2026-10-03）

第十三节落地后真机验收，用户提了四条。前三条是同一件事的三个侧面，第四条是取值错了。

### 14.1 磁贴不再是「键盘截了一角」

原来的磁贴直接 inflate 旧页的样本布局 `theme_selector_candidate`。
那是个**键盘的缩微版**：顶栏、键盘主体、空格条、动作键图标都在。
按 128×92 dip 画出来还行，铺到磁贴尺寸就成了一团看不清的按键，
用户的原话是「键盘实际预览的截了一点，很难看」。

Gboard 的磁贴其实是**三件套**（`work/shots/41a-gboard-colors-zoom.png` 放大可见）：

| 元素 | 来源 | 说明 |
| --- | --- | --- |
| 主体色块 | `?BgKeyboardBody` | 铺满整格，就是键盘底色 |
| 空格条 | `?BgSpaceTiny` | 底部居中的浅色胶囊 |
| 强调色圆点 | `?IconImeActionBack` | 右下角的小圆点 |

这三样样本布局里**本来就有**，只是被顶栏和按键细节淹没了。
所以改法是复用同一份布局，但只留这三样：

- 把 `.keyboard-body-area` 的背景搬到卡片根上 → 主体色铺满整格
- 隐藏 `.keyboard-header-area`（顶栏）
- 隐藏没有 tag 的那个占位 View（它是固定灰色 `@color/theme_selector_candidate_background_color`）
- 保留 `.space_bar`、`.background-icon.for-action-key.for-preview`
- 保留 `.keyboard-background.for-preview`：内置纯色主题上它是空的，
  但用户用图片生成的主题靠它显示缩略图，删了就只剩一块纯色

选择复用它而不是「解析属性取色再在 Compose 里画」，是因为取色这条路要么
拿到的是 `GradientDrawable`（拿不到颜色），要么得把 drawable 画进 1×1 位图再读像素；
而强调色根本没有对应属性，它就是个图标。复用布局则三样一起拿到，且对主题包自动生效。

**坑：样本布局的容器是写死尺寸的。** 它的根（`theme_selector_candidate_preview`）
写死 128×92 dip，和磁贴尺寸不一致。不动它的话，容器比磁贴大、右下溢出，
而**锚在它底部的空格条和强调色圆点就被推到磁贴外裁掉**——表现为胶囊和圆点
贴着下边缘、只剩半截。真机第一版就是这个样子，用户一眼看出来了。
修法：把容器（以及满幅的 `.keyboard-background.for-preview`）的
`LayoutParams` 改成 `MATCH_PARENT`，让它跟着磁贴走。

**坑：半格切片要在绘制阶段裁，不能靠布局盒子。**「系统自动」的两半是「按整格尺寸绘制再裁一半」。
第一版写成 `BoxWithConstraints` + `requiredWidth(整格宽)` + `offset(负半格)`，
真机上右半只画出了一半宽度。原因是 `BoxWithConstraints` 暴露的 `maxWidth` 与
`requiredWidth` 实际吃到的约束对不上（实测拿到的 `maxWidth` 是半格的一半），
偏移量因此只有应有的一半。

改成不依赖任何宽度推导的写法：两个整格色块**叠放**在同一个 `Box` 里，
各自用 `Modifier.drawWithContent { clipRect(...) }` 在绘制阶段裁掉一半。
这样布局盒子不变、尺寸不用推导，切片位置只由 `DrawScope.size.width` 决定。

### 14.2 动态颜色格不再假装能预览

`DynamicColorSetting.generatedPackageValue` = `files:dynamic_theme.zip`，
但这个包**在模式打开之前根本不存在**（真机 `files/` 下只有 `personal/`，
`compat_system_dynamic_color_theme` 偏好也没有）。
拿一个不存在的包去 inflate，得到的就是一格莫名其妙的深色。

改成 Gboard 的做法：这一格画**模式符号**——`surfaceVariant` 底 +
居中的圆形勾，不画色块。写入路径落地后，这一格改为点击即开启动态颜色，
届时再看要不要换成真实调色板。

### 14.3 默认区预设取错了两个值

`LIGHT_PRESET_VALUE` / `DARK_PRESET_VALUE` 原先指向 `material_light` /
`material_dark`，也就是内置列表的**第 1、2 个**。用户指出应该是**第 3、4 个**：

```text
1. material_light          2. material_dark
3. google_blue_light       4. google_blue_dark      ← 默认 / 默认深色
5. color_red  ...
```

核对 `entryvalues_builtin_additional_keyboard_theme` 的顺序后确认无误
（`work/decoded-fresh/res/values/arrays.xml`）。
这也解释了真机上那一格勾为什么落在 `google_blue_light` 上：
引擎无存储时的回退目标就是它。

### 14.4 弹层要按两次返回键

`rememberModalBottomSheetState()` 默认 `skipPartiallyExpanded = false`，
弹层先停在半开高度，第一次 BACK 只是从全开收到半开。
弹层里没有需要滚动的内容，半开状态没有意义，改为
`rememberModalBottomSheetState(skipPartiallyExpanded = true)`，一次 BACK 即关。

### 14.5 门禁

`scripts/verify_theme_preview_bridge.py` 增加两项：

- **4 个 tag**（`BODY_TAG` / `SPACE_TAG` / `ACTION_ICON_TAG` /
  `KEYBOARD_BACKGROUND_TAG`）必须仍出现在
  `res/layout/theme_selector_candidate_preview.xml` 或 `res/values/styles.xml` 里。
  注意 `BODY_TAG` 是写在 `@style/Body` 里的，只看布局文件会误报。
- `PRESET_VALUES` 的两个资源名同步换成 `..._google_blue_light` / `_dark`。

反向验证三次：`LIGHT_PRESET_VALUE` 换回 `material_light`、
`BODY_TAG` 改成 `.keyboard-body-areax`、`SPACE_TAG` 改成 `.space_barx`，都如期失败。

## 十五、动态颜色预览的陈旧：渲染器的快照缓存（2026-10-04）

### 15.1 现象

弹层里的大预览在**切换深浅色之后仍显示切换前的配色**；深色下打开「按键边框」
会把它换成另一份错误的图，关掉又恢复正常。真实键盘从头到尾都是对的，
所以问题只在预览这一路。

### 15.2 根因：缓存键里只有值，没有内容

`KeyboardPreviewRenderer` 会把栅格化好的键盘落盘，文件名
`keyboardsnapshotcache_<MD5>.png`，目录是**设备加密存储**
`/data/user_de/0/<pkg>/files/`。

键由 `preview_<resourceKey>_<viewStyleCacheKey>_t<types>_sp<w>_khp<h>_mp<On|Off>`
加方向后缀算出，而 `getViewStyleCacheKey()` = `resourceKey + "_" + 主题值`。

`syncDynamicTheme` 重建调色板时**原地重写同名文件** `files:dynamic_theme.zip`，
值字符串一个字符都没变 → 键不变 → 该值对应的快照永远命中旧图。
固定主题不会遇到这件事，因为 `assets:…` 恒指向同一份字节；
动态配色破坏的正是「值唯一确定内容」这条不变量。真实键盘不读这条缓存，所以一直正确。

### 15.3 按键边框为什么是不对称的

`bck.getResourceCacheKey()` 把 `_border` 算进了键，所以**边框开/关是两个独立条目**，
各自独立变陈旧。实测开关一次，目录里多一个文件
（`…_03a9f1b…` 边框关 64974 B / `…_4902e58…` 边框开 69167 B）。
修复前，「边框开」那一份的 mtime 停在 13:47，从未刷新过。

### 15.4 定位过程里最容易走错的一步

`/data/data/<pkg>` 是 `/data/user/0/<pkg>` 的符号路径，
**`find /data/data` 不会进入 `user_de`**。按那个目录去找，只会得到
「根本没有磁盘缓存」的结论，并顺着它编出「字面量有特判」「版本门控」
一整套错误理论。搜 `/data` 才命中真实文件。

### 15.5 修法：重建之后丢掉旧快照

`SystemAutoThemeCompat.invalidatePreviewSnapshots(Context)`，在
`syncDynamicTheme` 重建成功、写入签名之后调用，删除两个目录里所有
`keyboardsnapshotcache_*.png`：

- 两个目录是 `getFilesDir()` 和把路径里 `/user/` 换成 `/user_de/` 的那个。
  框架 `LoadedApk` 也是这样从 `dataDir` 推出加密目录的，所以不必用
  `createDeviceProtectedStorageContext()`，也不需要 API 守卫。
- 只删快照，不碰 `keyboard_def_cache_*`，也不碰 `files:dynamic_theme.zip` 本身。
- 渲染器实例上的 map 不用管：每次渲染都新建。
- 放在重建**之后**：包已经换好，此后请求的预览才会照新调色板重画。

### 15.6 真机验证

同一台设备、同一个 APK，四个组合全部正确（`work/shots/202`–`206`）。
文件侧证据：

| 动作 | 签名 | 快照 |
| --- | --- | --- |
| 浅色下进入清单页 | `dark@v3:…` → `light@v3:…` | 14 → 6，旧的全删、重新生成 |
| 切到深色 | 回到 `dark@v3:…` | 6 个 mtime 全部刷新 |

### 15.7 门禁

`scripts/verify_theme_preview_bridge.py` 增加三项断言，都从两侧读、不重复写：

- `SNAPSHOT_CACHE_PREFIX` / `SNAPSHOT_CACHE_SUFFIX` 的字面量从 Java 源读出，
  必须与注入 smali 里的字段声明一致；
- `.method private static invalidatePreviewSnapshots(Landroid/content/Context;)V` 必须存在；
- 该方法必须真的被调用，即 `->invalidatePreviewSnapshots(Landroid/content/Context;)V`
  出现在 smali 里。

反向验证三次（改调用名、改前缀字面量、删方法）都如期失败。

### 15.8 顺带清掉的诊断代码

上一轮为定位加的探针——`ThemeCatalogScreen` 里那 7 个 `probe` 和
`ThemePreviewBridge` 的 `diagnose` / `probe` / `sheetProbe` / `chainProbe` /
`rendererState` / `describe` / `palette` 等——每次打开清单页都会**额外跑一遍引擎渲染**，
还会在快照目录里留下垃圾。定案后整体删除（`ThemePreviewBridge` 958 → 514 行）。
`appliedContext` / `inflateCard` / `inflateCardIn` 是磁贴渲染要用的功能代码，保留。

### 15.9 没做的方案

「值随内容派生」（`files:dynamic_theme_<签名哈希>.zip`）能让键和内容重新一一对应，
比清快照更贴近引擎的不变量，但要迁移老值、改掉所有字面量比较，而且老值一旦指向
不存在的文件就会回退默认主题。本轮按最小改动落地，未采用。


---

## 十六、两处「预览与实际不符」（2026-10-04）

上一节收尾后用户又提两条，两条都不是渲染器的问题，而是**预览的输入取错了地方**。

### 16.1 系统自动：预览取的是打包预设，实际用的是槽位

「系统自动」模式真正的取值来自 light / dark 两个槽
（`compat_theme_{light,dark}_additional`），而 `ensureInitialized` 在首次启动时
把这两个槽初始化成

```text
compat_theme_light_additional = assets:theme_package_metadata_material_light.binarypb
compat_theme_dark_additional  = assets:theme_package_metadata_material_dark.binarypb
```

即 `pref_entry_additional_keyboard_theme_material_{light,dark}`，
也就是内置数组的第 0、1 项。

而清单页的「系统自动」磁贴和它的弹层一直在用
`LIGHT_PRESET_VALUE` / `DARK_PRESET_VALUE`，那是 **`google_blue_light` / `google_blue_dark`**，
内置数组的第 2、3 项。两者从第一天起就不是同一个主题，所以「预览和实际不符」
不是偶发，而是必然——用户没改过槽位时就已经不符。

**修法**：磁贴与弹层都改读槽位值，取不到（槽为空或值解析不出条目）才回落到预设。
`ThemeCatalogScreen` 里两个新变量：

```kotlin
val lightSlotValue = catalog.slots.firstOrNull { it.slot == ThemeSlotKey.Light }?.entry?.value
val darkSlotValue  = catalog.slots.firstOrNull { it.slot == ThemeSlotKey.Dark }?.entry?.value
```

`SplitThemeTile` 的两半与 `ThemePreviewSubject` 的两个值都从这里取，
`?: lightPreset.value` / `?: darkPreset.value` 兜底。

这样用户把任一槽改成别的主题后，磁贴和弹层跟着变，和键盘实际会用的那一对一致。

### 16.2 按键边框：开关读错了重载，一直报 false

现象（`work/shots/z1.png`）：弹层里「按键边框」开关是**关**的，
但旁边的预览画着**带边框**的键盘。

根因在反射：

```text
gc 同时声明了   c(Landroid/content/Context;)Ljava/io/File;     ← 文件 21778 行
                c(Landroid/content/Context;)Z                    ← 布尔 22032 行
```

`Class.getMethod("c", Context.class)` 只按名字和参数匹配，
**返回哪个由运行时列出的顺序决定**，结果是返回 `File` 那个。
桥接里 `as? Boolean` 失败抛 `ClassCastException`，被 `runCatching` 吞掉，
落到 `.getOrDefault(false)`——于是**开关永远是关的**，和偏好里存了什么无关。

渲染器一侧没有这个问题：`bck` 的三参构造里那句
`invoke-static {p1}, Lgc;->c(Landroid/content/Context;)Z` 是**编译期定死的调用**，
返回类型写死在指令里，所以它读到的永远是对的。开关错、预览对，两边就分家了。

同样的坑还有两处，只是暂时没发作：

| 位置 | 重载 | 结果 |
| --- | --- | --- |
| `amx.a(Ljava/lang/String;Z)` | `…Z`（getter，2522）/ `…V`（setter，2240） | `getMethod` 取到 setter，写入**碰巧是对的** |
| `amx.a(Landroid/content/Context;)` | `…Lamx`（204）/ `…Context`（252）/ `…V`（591） | 取到第一个 `Lamx`，**碰巧是对的** |

也就是说三处里两处靠声明顺序侥幸正确，一处已经错了。

**修法**：桥接新增 `engineMethod(className, methodName, returnType, vararg params)`，
按**名字 + 参数 + 返回类型**三者匹配，不再用 `getMethod`。
五处查找全部改走它（`gc.c`、`amx.a(Context)`、`amx.a(String,int)`、
`amx.a(String,String)`、`amx.a(String,boolean)`）。

同时把边框值**显式传给渲染器**：`render(context, themeValue, keyBorder, onReady)`
改用 `bck` 的四参构造 `(Context, baq, Z, Z)`，最后一位就是边框。
三参构造会自己调 `gc.c` 取，四参不会。这样开关成为预览的唯一输入，
两边不可能再各读一次而读岔。

`ThemePreview` 的 `renderKey: Any = Unit` 随之去掉——边框现在真的是渲染输入，
直接作 `LaunchedEffect(themeValue, keyBorder)` 的 key 更诚实。

### 16.3 门禁

`scripts/verify_theme_preview_bridge.py` 新增一组「返回类型重载」断言
（`RETURN_TYPE_LOOKUPS`，5 项）。对每一项：

1. 期望的那个重载必须仍在（名字 + 参数 + **返回类型**全对）；
2. 若该类在同一名字和参数下声明了**多于一个**方法（返回类型不同），
   桥接必须通过 `engineMethod(<类常量>, …)` 去取；
3. 桥接源码里不得出现 `getMethod(BORDER_STATE_METHOD` 或
   `getMethod(PREFERENCES_ACCESSOR`。

反向验证：把 `keyBorderEnabled` 改回 `getMethod`，门禁同时报两条——

```text
FAIL gc.c(Landroid/content/Context;) is declared 2 times over, differing only by
     return type, but the bridge does not look it up through engineMethod(…
FAIL the bridge resolves BORDER_STATE_METHOD with getMethod, …
```

这是本文件里第一条**管行为而不只是管名字**的断言：前面那些只能发现改名，
这一条能发现「名字没变但取错了那一个」。
