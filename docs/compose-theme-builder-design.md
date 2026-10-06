# 自定义主题构建器的 Compose 化

本文件记录阶段 2 第 6 条最后一块缺口的落地：把**自定义主题的创建与编辑**从旧
`ThemeBuilderActivity` / `ThemeEditorActivity` 换成 Compose。

这是「主题选择页 Compose 化」里唯一还留给用户旧界面的一处。清单页、槽位、预览、
快捷入口都早已收口（见 [主题预览设计](compose-theme-preview-design.md)），但点「新建主题」
或弹层里的「编辑」时，接下来那个裁剪页与亮度页仍然是旧活动的页面，与维护者
2026-10-06 定下的验收标准「展现给用户的不是旧的，交互的界面不是旧的」不符。

## 一、这一刀为什么可以只改界面

先确认了旧向导到底在做什么，结论是**它收集的信息少得惊人**：

| 页 | 用户输入 | 落进模型的东西 |
| --- | --- | --- |
| 裁剪页 | 缩放、拖动 | 一个裁剪矩形（左右上下四个 int） |
| 亮度页 | 一个 0–100 的滑块 | 一个 0.0–1.0 的透明度 |

其余全是引擎的活：按编码头算出降采样系数、解码位图、按矩形裁出键盘背景条与缩略图、
生成样式表、打包 zip。这些都在主 DEX 里，以单字母混淆名存在于默认包，本模块无法编译期
引用。

所以「补口子」不是重写一个主题包生成器，而是**重画两个页面，把两个值按同样的单位交给
同一个模型对象**。写出来的包就是旧向导会写出来的那个包——格式没有被复制，也没有被猜。

## 二、裁剪页的几何

这是唯一需要精确复刻的部分，因为它决定图片的哪一块进包。复刻错了不会崩，只会得到一个
**能正常用、但取景与旧向导不同**的主题——这类错误在真机上看不出来，所以把它单独抽成
`ThemeCropGeometry`，不依赖 `android.graphics`，可脱离设备核对。

窗口就是键盘的形状：

```text
cropW = containerWidth * previewRatio
cropH = cropW * keyboardAspect          // keyboardAspect = 键盘高 / 键盘宽
窗口居中于容器
minScale = max(cropW / bitmapW, cropH / bitmapH)
```

`previewRatio` 取自资源 `keyboard_preview_size_ratio_in_percent`（竖屏 80、横屏 65），
不是常量——横屏用不同值，而旧页的裁剪窗宽就是从它推出来的。键盘高来自 `ats`，是
`headerHeight + bodyHeight * scale`，与预览渲染器同一个来源。

图片放置约定：`viewX = centre.x + (bitmapX - bitmapW / 2) * scale`。三处由它派生：

- **开图取景**：`initialScale = max(minScale, fitScale)`，`fitScale` 是整图装进容器的比例。
- **钳制**：`centre.x ∈ [window.right - bitmapW*s/2, window.left + bitmapW*s/2]`，纵轴同理。
  拖动后必定回钳，所以图片永远盖满窗口、不会露出底色。
- **反投影**（按「下一步」时）：

  ```text
  left/right/top/bottom = window.left/right/top/bottom / s - centre/s + bitmapW/H / 2
  ```

  取整用**截断**（`.toInt()`）而不是四舍五入，因为旧页写的就是 int，而它随后存的
  centre 正是从这些 int 算出来的——用四舍五入会让「存进去再读出来」差一个像素。

写入模型时：

```kotlin
bai.b = scale / previewRatio            // 裁剪比例以 previewRatio 为单位
bai.c = (left + right) / 2              // 裁剪中心 x
bai.d = (top + bottom) / 2              // 裁剪中心 y
bai.a(Rect(left, 0, right, bottom),     // 背景条：顶边钉在图片自身顶边
      Rect(left, top, right, bottom))   // 缩略图：真实裁剪
```

两个 `Rect` 共享三个边，只差顶边——所以桥接里是两个参数而不是一个。**第一个 Rect 的
`top` 被钉为 0** 是旧页的行为，不是笔误。

**手势**：缩放绕手势焦点（`centroid`）做，然后统一过 `clampCenter`；拖动是 `centre -= pan`。
`minScale` 是缩放下限。

**重新播种的时机**：`onGeometry` 只在 `geometry == null || 窗口尺寸变了` 时播种。每次布局
都播种会把用户刚调好的取景冲掉；而本活动自己处理配置变更（见下），旋转后容器尺寸会变，
那时必须重播。

**编辑已有主题时**：用存下来的三个样式键反推初始取景，否则重新编辑会静默丢掉用户上次
选的裁剪与亮度，从整图重新开始：

```text
scale  = max(minScale, storedScale * previewRatio)
centre = 容器中心 - (storedCentre - bitmapSize/2) * scale
```

即 `sourceRect` 的逆运算。这是 `ThemeCropGeometry.seed`，单测里有往返用例。

## 三、亮度页

旧页把透明度叫「亮度」，因为叠一层更暗的遮罩看起来就是键盘更暗。滑块 0–100 映射到
`t = progress / 100`，写 `bai.a = t`（旧 setter 带 0..1 断言，所以桥接里 `coerceIn`，
避免手势把它推出去触发断言）。

预览的两条黑带就是应用后的真实结果，不是近似：候选栏 `alpha = 1 - 0.7t`，键区
`alpha = 1 - t`，与包写进样式表的值一致。预览图直接 `drawImage` 裁出的矩形，不做二次
编码。

## 四、一个活动同时替代旧的两个

`ModernThemeBuilderActivity` 既是「新建」也是「编辑」，因为旧的两个活动本来就是同一个
向导，差别只在图片从哪来、以及回报什么：

| | 图片来源 | 回报 |
| --- | --- | --- |
| 无 `target` extra | `GetContent` 取图 | 写出的包名 |
| 有 `target` extra | 打开该包取原图 | 写出的包名 **+** 被删的包名 |

**结果 extra 的名字沿用旧活动的**（`intent_extra_key_new_theme_file_name` /
`intent_extra_key_deleted_theme_file_name` / `target_user_image_theme_file_name`）：
它们是本活动与 `SystemAutoThemeCompat` 之间的契约，后者靠这一对做槽位改写，不是本模块
可以改名的东西。

几处刻意的行为：

- **取图取消 = 向导取消**：直接结束活动、不报结果，而不是停在一个空页面上。
- **被删包名只在文件真的删掉之后才报**：`SystemAutoThemeCompat` 会按这个名字把槽位改指
  别处，报一个还有包在背后的名字会让主题列表出现同一主题的两项。这条规则是从旧编辑器
  抄的。
- **编辑时取原图而不是裁后图**：包里同时存着键盘背景条与整张原图，重新编辑要后者——
  从前者裁只会越裁越小。
- **图片字节不预先解码就交给模型**：模型自己按编码头算降采样系数，这正是旧向导走过的
  路径，省掉一次重新编码，也保住了原始质量。
- **`configChanges` 自己声明**：裁剪页是全屏手势面，旋转重建会丢掉取景，所以 manifest 里
  该活动声明 `orientation|screenSize|screenLayout|smallestScreenSize|keyboardHidden|uiMode`。
  这也是 `onGeometry` 需要在窗口尺寸变化时重播的原因。

## 五、反射桥接的两条硬规则

`ThemeBuilderBridge` 反射旧引擎（`bai` 模型、`cac` 字节源、`gc` 工具、`bbl` 包读取器、
`ats` 度量），有两条规则是必须的，不是风格问题：

- **查字段要同时匹配名字与类型**。`bai` 的 `a` 声明了 7 次，分别是透明度、采样尺寸、
  源位图、矩形、字节源、弱引用、标题。按名字取是七分之一的概率。
- **查方法要同时匹配名字、参数与返回类型**。`ats` 有 `a(Context)` 两个重载，一个返回
  缩放系数（float）、一个返回宽度（int），只差返回类型。

取错的后果不是崩溃：结果 cast 失败，异常被 `runCatching` 吞掉，**表现为永远读到默认值**。
这个坑项目里已经踩过一次（`gc.c(Context)` 的两个重载导致按键边框开关恒 false），
`verify_theme_preview_bridge.py` 的 `RETURN_TYPE_LOOKUPS` 一直在盯同类问题。

桥接的所有方法都返回 null 或兜底值而不抛异常：引擎缺失（apktool-only 的审计构建）应当
退化成「这个页面打不开」，而不是进来就崩。

## 六、门禁

- `scripts/verify_modern_settings_runtime.py`：新增三段源码断言（活动、向导页、桥接的
  关键调用与样式键常量），manifest 断言新增 `ModernThemeBuilderActivity`，并**反向断言**
  `ThemeBuilderActivity` / `ThemeEditorActivity` 不得再出现在本模块的 Kotlin 里。
- `src/test/kotlin/.../ThemeCropGeometryTest.kt`：7 个用例（窗口尺寸、最小与初始 scale、
  开图取景、窗口宽高比、拖动钳制、`seed` 往返、小图放大覆盖）。
  **注意**：本机跑不了 `:compose-runtime:test`（`kotlin-test-junit` 不在离线缓存），
  这些用例从未在本机执行过，不能当作「测试通过」。

## 七、遗留

- 单测无法在本机执行（见上）。逻辑核对靠人工 + 门禁脚本覆盖。
- **真机验收尚未完成**：远程调试通道地址变更后连接被立即重置，通道恢复前无法上机。
  裁剪几何与「编辑已有主题」的往返是验收重点——前者错了只会取景不同、不会崩，
  后者错了会静默丢掉用户上次的裁剪与亮度，两者都必须在真机上看一眼。
