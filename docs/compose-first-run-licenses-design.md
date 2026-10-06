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

- 它在输入法还没启用时就要显示；
- 从它返回是回桌面，不是回某个设置页；
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
（`SuperNotCalledException`），也会在窗口尚未挂上时就 finish。条件三条：API 35+、
未完成、且 `queryIntentActivities` 能解析到目标活动（给不含 Compose 运行时的
apktool-only 审计构建留的逃生口）。命中就启动新 Activity 并 `finish()` 自己。

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

- 启用 = 本包出现在 `InputMethodManager.getEnabledInputMethodList()` 里；
- 选择 = `Settings.Secure.DEFAULT_INPUT_METHOD` 等于本包 IME 的 id。

两者都是系统所有、都可能在本页退到后台时改变，所以**每次 `onResume` 重读**。
两个步骤按钮只打开系统界面（`ACTION_INPUT_METHOD_SETTINGS` 与
`showInputMethodPicker()`），框架不给结果，回来重读是唯一的同步方式。

完成按钮在两项都满足前不可用；第二步的按钮在第一步完成前不可用——选择器不会
列出系统里没启用的输入法。

## 三、门禁

- `scripts/verify_modern_settings_runtime.py`：源码断言新增两个 Compose 页与
  bridge 的关键调用；manifest 断言新增 `ModernFirstRunActivity`；反向断言
  `UnquantumLicenseMenuActivity` 不得再出现在这个模块里；patch 脚本断言两条
  `FirstRunRoutingCompat` 调用与 helper 文件都在。
- `scripts/verify_md3.py`：断言重定向落在 `PinyinFirstRunActivity.smali` 里，
  且 `FirstRunRoutingCompat.smali` 带着类名字符串与包可见性查询。

## 四、仍未 Compose 化的部分

自定义主题的创建与编辑仍复用旧 `ThemeBuilderActivity` / `ThemeEditorActivity`。
按维护者 2026-10-06 的意见，只要**展现给用户的界面**不是旧的即可，底层走旧实现不影响——
这两处的界面本身仍是旧活动的界面，所以它们不在本次范围内，但也不属于「已 Compose 化」。
