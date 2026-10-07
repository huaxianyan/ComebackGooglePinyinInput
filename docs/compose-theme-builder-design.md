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

**这里有一个必须写下来的陷阱：窗口高不含导航栏。** 真机上（1080 宽）窗口是 864×592，
比例 1.4595，正是键盘自身内容区 1080:740 的比例，所以图片进键盘不会被拉伸。而旧页画给
用户看的白框是 **864×692**——它比真实裁剪区高 100 px。原因是那个白框根本是另一个视图：
`bcp.onCreate` 用 `ats.b(...) + stableNavigationHeightOr(navInset)` 给它设 LayoutParams，
量的是键盘在屏幕上的整块占地；真正算裁剪的 `bcp.a()` 只用 `ats.b(...)`，没有导航栏那一段。

```smali
# bcp.onCreate —— 预览视图（白框），含导航栏
height = (int) ((width / widthPixels) * (ats.b(context, {HEADER, BODY}) + navInset))

# bcp.a() —— 裁剪窗，不含导航栏
aspect = ats.b(context, {HEADER, BODY}) / (float) ats.a(context)
windowHeight = (int) ((g * previewRatio) * aspect)
```

**结论是跟 `a()`，不跟白框。** 旧页的白框比它实际裁掉的区域大，用户框进去的最上面
100 px 会被丢掉。从设备上拉回来的主题包证实了这一点而不是白框：包内裁剪矩形是源图
409×281 像素，409/281 = 1.4555（对应 592 高的窗口），若是 692 高的窗口该是 1.2470。

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

包里还有一个**名字**。旧新建页在解码出位图之后，用应用自己的 `user_theme_name_format`
（`主题 (%1$d)，创建日期：%2$s`，日期是 `DateFormat.MEDIUM`）生成一个名字，序号取
「现有包里还没人用过的第一个」，从 1 数到 1000；旧编辑器则把打开的那个包的名字原样
抄给新模型。名字**没有任何界面读它**——主题网格不显示、预览弹层不显示，`bbl` 连一个
返回 String 的方法都没有——所以漏掉它不会有人立刻发现，但包的内容就与旧向导的不一致了。
真机验收时对比包内 `metadata.binarypb` 才看出来：旧包 70 字节（含标题字段），我的 24 字节。
现在补上了：新建走 `defaultTitle`，编辑走 `packageTitle` 转抄。

**手势**：缩放绕手势焦点（`centroid`）做，然后统一过 `clampCenter`；拖动是
`centre += pan`，即图片跟着手指走。**符号容易反**：旧页写的是 `centre -= distanceX`，
但 `GestureDetector` 的 `distanceX` 是 `last - current`，与 Compose 的 `pan`（手指位移）
方向相反，两边一负一正指的是同一件事。写成 `-= pan` 会让图片朝手指的反方向跑，
而且只有真机能发现。

**算术必须留在持有取景的那一层，手势回调只转交原始手势。** 这是真机上踩到的第二个坑，
而且比符号坑更隐蔽：`pointerInput` 里的变换处理器**只在 key 变化时重建**，所以它只能看见
安装那一刻的 `scale` / `centre`。如果裁剪页把这两个值当参数传给画布、又在处理器里读，
处理器拿到的就是页面刚打开时那份取景——每次事件都从初始位置重算，只剩最后一个事件的
位移。实测表现是 600 px 的滑动只让图片挪 4 px，看上去像「手势没生效」。
现在 `CropStep` 的 `onGesture` 只转交 `(centroid, pan, zoom)`，加减与钳制都在
`CustomThemeBuilderScreen` 里做——那里的 lambda 闭包持有的是状态对象本身，读到的永远是
当前值。

画布必须自己裁剪（`clipRect`）。Compose 的绘制作用域直接画在窗口的 canvas 上，不按
布局边界裁剪；图片为了盖满窗口本来就比容器大，不裁就会溢到上面的说明文字与下面的
按钮上——真机上实测图片顶边落在画布上方 341 px 处。旧页没这个问题，它的图片活在
一个会裁子视图的 ViewGroup 里。

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
  其中三条是真机踩出来的，写在断言旁边：
  - `windowInsetsPadding(WindowInsets.safeDrawing)`——不消费 insets 时说明文字压状态栏、
    「下一步」被导航栏盖住。
  - `clipRect {`——不裁剪时图片溢到画布外。
  - `onGesture = { centroid, pan, zoom ->` 与 `onGesture(centroid, pan, zoom)`——算术必须
    在持有取景的那一层，并且**反向断言** `onTransform(nextScale, nextCenter)` 这类写法不得
    回来。
  - `Surface(modifier = Modifier.fillMaxSize()) { content() }`——共享主题必须铺自己的底色，
    否则宿主会露出框架 Light 主题的白色窗口底（见第七节）。断言放在活动那一段，因为它盯的
    是 `ModernSettingsTheme`，不是向导页。
- `src/test/kotlin/.../ThemeCropGeometryTest.kt`：7 个用例（窗口尺寸、最小与初始 scale、
  开图取景、窗口宽高比、拖动钳制、`seed` 往返、小图放大覆盖）。**这些用例在本机跑得起来**：
  `modern-settings/` 下 `./gradlew :compose-runtime:test --offline`，约 3 分钟，94 个用例。
  （此前记录的「`kotlin-test-junit` 不在离线缓存」已不成立，jar 现在在缓存里。）
  首轮跑出 1 个失败：`aPictureSmallerThanTheWindowIsScaledUpToCoverIt` 断言
  `initialScale == 8`，而实现与第二节写的都是 `max(minScale, fitScale)`，该用例是 `100 x 100`
  的图，`fitScale = 10` 大于 `minScale = 8`，所以开图取景是 10。断言写错了（它自写下起
  从未执行过），已改正。

## 七、深浅色：底色归共享主题管

深色模式下向导页「整体偏亮」，而设置首页正常。两者的配色判断是同一个
`ModernSettingsTheme`，所以差别不在判断上：

- 向导页活动自己的 `CurrentConfiguration` 里确实带 `night`，`enableEdgeToEdge()` 也按
  深色处理：状态栏图标是白的，导航栏压的是深色 scrim 而不是浅色底。说明文字
  `(172, 170, 173)` 与按钮的浅色 `primary` 也都取自动态深色那一套。
- 但**页面底色是 `(250, 250, 250)`**，正好是 `Theme.Material.Light` 的 `windowBackground`
  （`#FAFAFA`）。三个 Compose 宿主在清单里都是
  `@android:style/Theme.Material.Light.NoActionBar`，固定 Light，窗口底色与夜间模式无关。

所以**配色是对的，缺的是底色**。设置首页之所以没事，只是因为它用了 `Scaffold`，默认
`containerColor` 会铺满整页。向导页的 `Column` 只加了 `windowInsetsPadding`，深色那套浅色
文字就直接压在框架主题的白色窗口底上，观感正是「深色模式但界面发亮」。

修法放在共享主题里，而不是补在向导页上：

```kotlin
MaterialTheme(colorScheme = colors) {
    Surface(modifier = Modifier.fillMaxSize()) { content() }
}
```

三个宿主（设置页、首次运行、向导）一次都盖到，下一个忘记铺底的宿主也不会再踩。真机复核：
向导页的页面底色、状态栏带、导航栏带三处现在与设置首页、主题清单页逐像素同值，分别是
`(14, 14, 15)`、`(18, 19, 19)`、`(31, 31, 32)`。

### 启动那一帧

上面这条修的是首帧之后。从活动启动到 Compose 画出第一帧之间，系统画的是主题的
`android:windowBackground`，而三个宿主原本声明的是固定 Light 的
`@android:style/Theme.Material.Light.NoActionBar`，窗口底色 `#FAFAFA` 与夜间模式无关。
深色模式下这一段同样发白，是同一个根因的另一半。

修法是把宿主主题换成自己定义的 `ModernSettingsHostTheme`，浅色与深色各一份：

| 限定符 | 父主题 | `windowBackground` 与 `colorBackground` |
| --- | --- | --- |
| `values` | `@android:style/Theme.Material.Light.NoActionBar` | `#FFFEF7FF` |
| `values-night` | `@android:style/Theme.Material.NoActionBar` | `#FF141218` |

四个要点：

- **页面配色不在这里配**。这份主题只有窗口底色，页面颜色仍然全部由共享的
  `ModernSettingsTheme` 解析：API 31+ 走动态色，以下走静态方案。新加的宿主不需要任何配色
  工作，也不需要知道这份主题存在。
- **窗口底色用不了动态色**。它在应用进程起来之前就由系统解析完，那时没有 Compose，也没有
  动态调色板，只能落成静态资源。两个色值取自 material3 1.4.0 自己的 surface token，是从
  AAR 字节码里读出来的：`ColorLightTokens.Surface` 是 `PaletteTokens.Neutral98`，即
  `rgb(254, 247, 255)`；`ColorDarkTokens.Surface` 是 `PaletteTokens.Neutral6`，即
  `rgb(20, 18, 24)`。它们是回落配色的 surface，与真机动态色差几级，所以页面仍要自己铺底。
- **两个属性一起写**。框架的 `Theme.Material` 与 `Theme.Material.Light` 里
  `windowBackground` 就是 `?attr/colorBackground`，两者同值，所以某个窗口读的是哪一个从
  外面分辨不出来，成对设置才与框架自己的写法一致。
- **只声明一次**。脚本把宿主活动收进 `host_activities`，再统一设主题，新增宿主自动继承。
  门禁另有反向断言，禁止任何活动单独声明主题。

真机复核。这一帧只存在到 Compose 画出第一帧为止，直接截屏基本抓不到，得先把它固定住。
`am set-debug-app -w` 对本包无效（`flags=0x0`，不是 debuggable），把应用降级成纯解释执行
也拉不长首帧；`wrap.<包名>` 能把进程启动本身拖住，但生效不稳定，同一个脚本在两次运行里
一次留住了窗口、一次直接落到了页面上。

可靠的固定办法是让页面自己画不出来：向导在编辑目标读不出来时只置失败标志、不调
`setContent`，窗口上就只剩主题的 `windowBackground`，而且会一直留着。用不存在的编辑目标
启动它，量到的就是这一帧：

| 量的是哪一层 | 改动前（夜间） | 改动后（夜间） | 改动后（浅色） |
| --- | --- | --- | --- |
| 窗口底色 | `(250, 250, 250)` | `(20, 18, 24)` | `(254, 247, 255)` |
| 启动闪屏 | `(250, 250, 250)` | `(0, 0, 0)` | `(255, 255, 255)` |

窗口底色那一行是本次要修的东西，两列正好是表里声明的两个色值。八个探针点全部同值，
说明量到的是纯窗口底而不是页面。改动前那一列来自未改动的旧包，它的清单里三个宿主直接挂
`@android:style/Theme.Material.Light.NoActionBar`（`0x01030241`），同场次、同设备、夜间
模式不变。导航栏带也跟着走：夜间从 `(138, 138, 139)`（深色 scrim 压在白底上）变成
`(24, 23, 27)`（scrim 压在 `#141218` 上）。改动前那一帧的状态栏图标是白的，压在同样白的
窗口底上，等于看不见；换成深色父主题之后这一帧的图标与底色终于是一对。

启动闪屏是系统在活动窗口之前画的另一层（应用图标压在底色上），它读的不是本主题的窗口底色。
框架里 `windowSplashScreenBackground` 是 `@color/transparent`，实测结果跟着父主题的明暗走：
浅色父主题给 `#FAFAFA`，深色父主题给纯黑。**纯黑不是我们设的值**，具体取值没有归因出来，
本次也没有为它单独加配置。

## 八、真机验收（2026-10-06，Pixel 10 Pro / Android 16 / 1080×2410）

创建与编辑两条流程都走通了，下面每一条都有像素或包内容作证：

| 项 | 证据 |
| --- | --- |
| 安全区 | `取消` / `下一步` / `保存` 的 bounds 都在导航栏之上，说明文字不被状态栏压 |
| 画布裁剪 | 顶部三条带（状态栏 / 说明行上方 / 说明行）的亮像素占比从 0–2% 变成 96–99% |
| 拖动 | 向下滑 400 px，图片下移 396 px（差的 4 px 是触摸 slop）；反向再滑 400 px 回到原位（净 19 px） |
| 缩放 | 双指捏合后窗口内容明显放大 |
| 编辑往返 | 打开旧包时裁剪与亮度（40%）都被还原；保存后旧包被删、新包写出 |
| 包几何 | 新包裁剪矩形 409×281，与旧包的 409×281 同形（位置不同是因为拖动过） |
| 深色底色 | 页面底色从 `(250, 250, 250)` 变成 `(14, 14, 15)`，与设置首页、主题清单页同值 |
| 启动底色 | 让向导画不出页面（编辑目标不存在）后逐像素：改前夜间 `(250, 250, 250)`，改后夜间 `(20, 18, 24)`、浅色 `(254, 247, 255)`，八个探针点同值（见第七节） |
| 手势未回归 | 共享主题新包了 `Surface`，重测：编辑路径短滑 100 px 图片下移 78 px（差的 22 px 是 `detectTransformGestures` 的触摸 slop）。同一路径长滑撞在 214 px 的竖直钳制上，与上表创建路径的 396 px 不矛盾，两次的取景余量本来就不同 |

**验收里修掉的两个 bug 都不是「看起来不对」那一类**，而是功能性的：手势只走最后一个事件、
图片画到画布外。前者在旧实现下每次手势只挪几像素，很容易被当成「模拟器手势不准」放过去。

## 九、遗留

- 单测能在本机执行，但**没有接进任何门禁**：`./gradlew :compose-runtime:test --offline` 要手动跑
  （见第六节）。`ThemeCropGeometryTest.kt` 里那条写错的断言就是这么留下来的。
- 弹层预览在切系统深浅色时不刷新（记录、不修、不作为验收障碍）。
- `ThemeCropGeometryTest.kt` 里没有覆盖「手势处理器不得自己算取景」这一条，它是架构约束
  而不是几何约束，靠门禁的反向断言盯着。
- 启动闪屏（系统画的、带应用图标那一层）没有单独配置，深色下实测是纯黑而不是本主题的
  `#141218`。它跟着父主题的明暗走，见第七节。要让它与页面严格同色，得在 `values-v31` 与
  `values-night-v31` 里各再写一份带 `windowSplashScreenBackground` 的样式，本次没做。
- `ModernThemeBuilderActivity` 在编辑目标读不出来时只置了失败标志、没有调用 `setContent`，
  窗口上什么都不画（`reopen()` 返回 null 那条分支）。第七节的启动底色就是借这个状态量到的，
  但它本身是个缺陷：用户拿到一个读不出来的包时只会看到一片空白，另行处理。
