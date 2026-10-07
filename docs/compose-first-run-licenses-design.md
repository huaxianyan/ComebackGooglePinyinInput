# Compose 首次引导与许可证页

本文件记录阶段 2 第 8、9 条的落地：把许可证页与首次引导的用户界面换成 Compose。
两处的**行为契约都不变**，改的是界面归属。

## 一、许可证页

### 1.1 数据仍来自打包资源

APK 里本来就带着 Google licenses 库的两个 raw 文件：

```text
res/raw/third_party_license_metadata   <start>:<length> <名字>，30 行
res/raw/third_party_licenses           295 KB 正文，偏移由上面指过来
```

新页直接读这一对，不引入任何新数据源。**长度是字节数**，所以正文按 `ByteArray`
切片再按片解码，而不是先把整份文件当文本切开。读不到就返回空列表，页面显示一句
提示——许可证页不值得让整个设置页崩掉。

### 1.2 列表与正文是一个 destination 的两页

`LicensesScreen` 自己持有「打开了第几条」这个状态，正文页的返回键回列表而不是退出
设置层级。做成两个 route 会让返回键跳到设置页，而正文在语义上是某一行的展开。

选中的下标用 `rememberSaveable`，屏幕重建后能回到同一份正文。

### 1.3 入口改向

`SettingsRoute.Licenses` 是新的路由，挂在「其他 → 关于」的许可证行下。
`SettingsActions.onOpenLicenses` 与 `LegacySettingsNavigation.licensesIntent`
一并删掉：这个模块不再起 `UnquantumLicenseMenuActivity`。
旧类与旧资源都留着不删，只是不再有可达路径。

## 二、首次引导

### 2.1 为什么是第二个 Activity，而不是设置页的一条 route

首次引导不属于设置层级：

- 它在输入法还没启用时就要显示。
- 从它返回是回桌面，不是回某个设置页。
- 完成它是写标记后**另起**一个设置任务。

把它塞进 `SettingsRouteStack` 会在设置首页之上多出一页，而返回键还得跳过它。
所以 `ModernFirstRunActivity` 与 `ModernSettingsActivity` 平行，共用
`ModernSettingsTheme`（同一套动态配色与布局方向来源），但不共用路由栈。

### 2.2 门控、状态与启动权仍归旧侧

`PinyinFirstRunActivity`（smali 里的 `apy`）保留三件事，Compose 侧不复刻：

| 事项 | 位置 |
| --- | --- |
| 「是否该显示引导」的启动权 | `FirstRunStateCompat;->claimGuideLaunch` |
| 完成标记与 legacy 迁移 | `FirstRunStateCompat;->isComplete` / `complete` |
| 迟到的 singleTask intent 静默丢弃 | `PinyinFirstRunActivity;->onCreate` |

Compose 侧通过 `FirstRunStateBridge` 反射这四件事：`isComplete`、`activityCreated`、
`activityDestroyed`、`complete`。**方法名唯一、无重载**，但布尔那条仍显式校验返回类型——
这个类里有同参数、只差返回类型的重载，取错会抛 `ClassCastException` 被 `runCatching`
吞掉，表现为「永远读到默认值」。

### 2.3 重定向与启动权的交接

`FirstRunRoutingCompat;->redirectToModernGuide(Activity)` 在 `PinyinFirstRunActivity`
的 `onCreate` 里调用，位置是 `activityCreated()` 与 `invoke-super onCreate` **之后**：
它会启动另一个 Activity 并 finish 自己，提前返回会把 `super.onCreate` 落下
（`SuperNotCalledException`），也会在窗口尚未挂上时就 finish。条件三条：达到应用
的 `minSdkVersion`（现为 23）、**引导未完成**、且 `getActivityInfo` 能在包里解析到目标
活动（给不含 Compose 运行时的 apktool-only 审计构建留的逃生口）。命中就启动新 Activity
并 `finish()` 自己。

**分支方向是这个方法唯一会静默写反的地方，而它写反了两次。** 两处分支的目标都是
`:legacy_guide`（旧页）：

- **阈值那处**必须是 `if-lt`（低于阈值才去旧页）。写成 `if-ge` 一样能汇编、读起来也
  一样通顺，效果却是「阈值及以上全部留在旧页，只有更低版本才重定向」。
- **完成态那处**必须是 `if-nez`（已完成才去旧页，交给旧活动自己收尾）。写成 `if-eqz`
  表达的是「未完成就回旧页」，把重定向关得比阈值那处更死。

两处自 2026-10-06 建起就都写反了，直到 2026-10-07 下放时才被设备上的实测翻出来：
阈值降到等于 minSdk 后 `SDK_INT >= 阈值` 恒成立，加上第二个分支，重定向一次都发生
不了。门禁现在同时钉住阈值数值、阈值后那个分支的方向，以及完成态分支的方向，见
[高版本下放调研](high-min-sdk-settings-migration-research.md) 第十四节。

存在性检查也不能用 `queryIntentActivities`：它从 intent-filter 解析表里取答案，
看不见没有 `<intent-filter>` 的宿主，而 `ModernFirstRunActivity` 正是这样声明的
（旧活动用类名显式点名它）。那个查询对「已经声明了的构建」同样返回空，闸门会静默
判为未声明。`getActivityInfo(ComponentName, 0)` 加捕获 `NameNotFoundException` 问的
才是真正想问的问题。

**启动权的交接是这里唯一容易出错的地方。** 旧 Activity 被 finish 时，它的
`onDestroy` 会调 `activityDestroyed`，未完成就把启动权释放；而 Compose 侧刚在
`onCreate` 里拿到它。两者的先后顺序不确定，所以用一个静态标志把顺序问题消掉：

```text
redirectToModernGuide  →  sRedirected = true
PinyinFirstRunActivity.onDestroy  →  consumeRedirect() 为 true 时跳过 activityDestroyed
ModernFirstRunActivity.onDestroy  →  activityDestroyed（未完成则释放）
```

这样无论谁先跑，启动权在整段重定向期间都保持被持有，IME 启动不会排进第二个引导。

### 2.4 两个步骤的状态从框架读

- 启用 = 本包出现在 `InputMethodManager.getEnabledInputMethodList()` 里。
- 选择 = `Settings.Secure.DEFAULT_INPUT_METHOD` 等于本包 IME 的 id。

两者都是系统所有、都可能在本页退到后台时改变，所以**每次 `onResume` 重读**。
两个步骤按钮只打开系统界面（`ACTION_INPUT_METHOD_SETTINGS` 与
`showInputMethodPicker()`），框架不给结果，回来重读是唯一的同步方式。

完成按钮在两项都满足前不可用；第二步的按钮在第一步完成前不可用——选择器不会
列出系统里没启用的输入法。

### 2.5 图标不能走 `painterResource`

页面顶部的 logo 来自原版 APK 的 `ic_first_run_page_app_logo_alia`，它在包里是一个
`<bitmap>` XML 包装：

```xml
<bitmap android:src="@drawable/ic_first_run_page_app_logo" />
```

这对平台是合法 drawable——旧引导页一直正常显示它——但 Compose 的 `painterResource`
不接受：它读 XML，发现根节点既不是 `<vector>` 也不是图片文件，就抛
`IllegalArgumentException("Only VectorDrawables and rasterized asset types are supported
ex. PNG, JPG, WEBP")`。**这与 API 等级无关**，同一个调用在任何版本上都失败，所以这一页
第一次被真正打开时就崩了——路由修好之前它从没被打开过，崩溃也就一直没露面。

改法是绕开包装：用 `Context.getDrawable` 拿到 drawable，画进一张 `Bitmap`，再交给
`BitmapPainter`。这样对任何 drawable 类型都成立，将来把资源换成矢量也不会把这个崩溃
带回来。三档密度图是 108/144/216 px，即 hdpi/xhdpi/xxhdpi 下的 72 dp，与布局的
`Modifier.size(72.dp)` 一致，所以栅格化是 1:1，不重采样。

## 三、门禁

- `scripts/verify_modern_settings_runtime.py`：源码断言新增两个 Compose 页与
  bridge 的关键调用；manifest 断言新增 `ModernFirstRunActivity`；反向断言
  `UnquantumLicenseMenuActivity` 不得再出现在这个模块里；patch 脚本断言两条
  `FirstRunRoutingCompat` 调用与 helper 文件都在。
- `scripts/verify_md3.py`：断言重定向落在 `PinyinFirstRunActivity.smali` 里，
  且 `FirstRunRoutingCompat.smali` 带着类名字符串与包可见性查询。

## 四、当时仍未 Compose 化的部分（已补）

写这份文件时，自定义主题的创建与编辑还复用旧 `ThemeBuilderActivity` /
`ThemeEditorActivity`。按维护者 2026-10-06 的意见，只要**展现给用户的界面**不是旧的即可，
底层走旧实现不影响——而这两处的界面本身仍是旧活动的界面，所以当时记在这里。

**该口子已于同日补上**：`ModernThemeBuilderActivity` 同时替代了旧的两个活动，裁剪页与
亮度页都在 Compose 侧。旧引擎（`bai` / `cac` / `gc` / `bbl` / `ats`）仍被复用，但只经反射
调用，不再有旧活动出现在用户面前。细节见
[自定义主题构建器的 Compose 化](compose-theme-builder-design.md)。

至此阶段 2 第 6 条没有残留的旧界面。
