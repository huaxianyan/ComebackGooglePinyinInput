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
| float | `0.5f` |

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
).newInstance(bbbContext, theme, atsA, 0.5f)

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
- `bundleXmlId` 与 `layoutName` 建议反射读 `amx`，或退一步用
  `resources.getIdentifier("ime_zh_cn_pinyin_qwerty", "xml", packageName)`。
  两者都比硬编码 `0x7f080036` 稳妥。

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
2. ~~**`bundleXmlId` 与 `layoutName` 的读取方式。**~~ 已定：直接读默认共享偏好。
   两个键名是 `R.string.pref_key_preview_*` 的值，`amx` 读的也是同一个文件，
   所以不必反射它，也不必用 `getIdentifier` 反查资源 id。见第九节。
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

1. **两个偏好键直接读共享偏好，不反射 `amx`。** 键名就是 `R.string` 的值，
   `amx` 读的也是同一个默认偏好文件。少一层反射，也少一处会失效的签名。
2. **渲染器每次新建**，与旧页一致。`Latp` 的缓存语义仍未确认，见第八节第 1 条。
3. **主线程发起**，回调里再 `post` 一次到主线程，因为 `InputBundleManager`
   的回调线程没有保证。
4. **失败静默降级**：`render` 用 `runCatching` 包住。预览是装饰，不能把设置页带崩。
5. **不可用时整块不渲染**，不给「预览不可用」留空位。

门禁 `scripts/verify_theme_preview_bridge.py` 断言三件事：

- 桥接里的 8 个类名常量都能在解码产物里找到对应的 smali 文件；
- 7 条成员签名仍然存在，含 `baq.a(Context, String)`、`bck.<init>`、`ats.a`、
  渲染器构造、`a(int, String, receiver)`、`cancelRequest`、`onKeyboardPreviewReady`；
- 两个偏好键名与 `strings.xml` 一致，且仍出现在 `preferences_pinyin_forced_values` 里。

反向验证做了两次：把 `DESCRIPTOR_CLASS` 改成 `baqx`，把 `PREVIEW_LAYOUT_KEY`
改成 `preview_layout_wrong`，门禁都如期失败。

验证结果：`:compose-runtime:testDebugUnitTest` **83 通过 / 0 失败**；
`verify_theme_preview_bridge.py`、`verify_modern_settings_runtime.py`、
`verify_chinese_copywriting.py` 全绿。

**仍未做：真机验证。** 要确认四件事：渲染是否成功、预览与键盘实际外观是否一致、
连续切换两个主题的耗时（用来回答 `Latp` 缓存问题）、
自定义主题（`files:` 前缀）能否走通同一条路。
