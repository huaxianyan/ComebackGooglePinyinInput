# Gboard “System Auto” 主题研究与兼容实现

## 目标

研究 Gboard 如何表达“跟随系统深浅色”的键盘主题，并在 Google 拼音兼容项目中加入长期可维护、不会覆盖用户模式选择的等价能力。

研究样本：

```text
package=com.google.android.inputmethod.latin
versionName=17.8.4.939743344-release-arm64-v8a
versionCode=175894542
```

本研究只分析公开安装包的结构和互操作语义，不复制 Gboard 的代码或受保护资源。

## 已确认事实

### 1. Gboard 将 System Auto 表达为“提供器”，不是一个固定主题名

公开包中存在以下文案：

```text
System Auto
Default auto theme
Appearance will follow system settings
```

`ThemeListingFragment` 在功能条件满足时把 System Auto 作为独立主题项加入主题列表。相关实现由以下混淆类型构成：

- `juo`：主题列表项的规格包装器；
- `jul`：可分别返回两套 `qub` 主题规格的提供器接口；
- `jun`：System Auto 提供器，持有 `Context`，分别提供浅色和深色规格；
- `juj`：锁定某一深浅模式的提供器；
- `jti`：从 `Bundle` 中按 provider type 重建提供器。

`jun` 序列化使用 provider type `2`，`juj` 使用 type `3`。这证明持久化对象包含“选择策略”，而不是只保存当前解析出的主题。

证据位置：

```text
work/research/gboard-current-public/decoded-base/smali_classes2/
  com/google/android/apps/inputmethod/libs/theme/listing/ThemeListingFragment.smali
  jul.smali
  jun.smali
  juj.smali
  juo.smali
  jti.smali
```

### 2. 自动模式拥有浅色和深色两套规格

`qub.A(context)` 与 `qub.B(context)` 分别解析默认浅色和默认深色规格，其中还会参与动态颜色和 Material 主题选择。资源中同时存在 Belka、Dynamic Color、Material 3 等成对的 light/dark 元数据。

因此 Gboard 的核心模型是：

```text
自动模式 = 浅色主题规格 + 深色主题规格 + 按系统配置选择的策略
```

而不是：

```text
系统切换 → 覆盖用户保存的固定主题 → 丢失自动模式身份
```

### 3. 自动模式和解析结果是两个层次

System Auto 的提供器在运行时根据当前环境取得浅色或深色规格。即使当前最终渲染的是某个具体主题，用户保存的仍然是自动策略。这使下一次系统模式变化仍可重新解析，不需要猜测用户是否曾选择自动模式。

## 当前 Google 拼音主题契约

原版 Google 拼音没有新版 Gboard 的主题提供器抽象。它通过两个字符串 Preference 表达当前主题：

```text
pref_key_keyboard_theme
pref_key_additional_keyboard_theme
```

原版 Material 主题对已经存在：

```text
基础主题：material_dark_theme
浅色元数据：assets:theme_package_metadata_material_light.binarypb
深色元数据：assets:theme_package_metadata_material_dark.binarypb
```

`baq.a(Lamx)` 会同时写入基础主题和附加主题。原版主题选择器、主题编辑器、图片裁剪和运行时加载链路继续拥有固定/自定义主题的业务实现。

## 采用的兼容设计

### 持久化模型

新增独立、默认不存在的模式键：

```text
compat_system_auto_keyboard_theme
```

含义：

- 键不存在：固定/自定义主题模式，完全沿用原版行为；
- `true`：自动模式；原版两个主题键只是当前系统模式的解析输出。

不把 `false` 作为长期状态保存；关闭自动模式时删除该键。这保留了明确的 absent/default 语义。

### 解析规则

```text
UI_MODE_NIGHT_YES → 原版 Material 深色主题
其他 night mode   → 原版 Material 浅色主题
```

实现不复制主题资源，也不新造渲染器，只选择原版已经验证的 Material light/dark 主题对。

### 生命周期

纯 Java、primary-DEX、AndroidX-free 的 `SystemAutoThemeCompat` 在以下时机解析：

1. IME `onCreate()`：保证进程重建后先得到正确主题，再创建主题和键盘对象；
2. IME `onConfigurationChanged(Configuration)`：先更新解析结果，再让原框架执行已有的配置差异处理和 InputView 重建；
3. 用户在现代设置中启用：原子写入自动模式和当前解析结果。

API 17–34 的正常启动路径不会解析 Compose/AndroidX 类型。

### 手动主题选择

- 仅打开后取消原版主题选择器：保留自动模式；
- 实际选择固定或自定义主题：先删除自动模式键，再执行原版写入；
- 新建并应用自定义主题：同样先退出自动模式。

这样避免“界面显示自动，运行时却被手动主题覆盖”的双重真相。

### API 35+ 设置呈现

“外观与布局”页新增官方 Compose Material 3 `Switch`：

```text
跟随系统
浅色模式使用 Material 浅色主题，深色模式使用 Material 深色主题
```

原“主题背景”入口仍打开未导出的同包 `ThemeSelectorActivity`，固定主题、自定义图片、编辑和裁剪能力不被复制或改写。

## 未采用方案

### 系统切换时只覆盖固定主题值

拒绝。该方案无法区分“用户主动选择当前主题”和“自动模式暂时解析为当前主题”，系统切换一次后就会丢失用户的自动选择身份。

### 复制或手绘 Gboard 主题

拒绝。目标是复用原版 Google 拼音主题对和渲染链路，而不是复制 Gboard 的代码、资源或外观。

### 为自定义图片自动推导深浅版本

拒绝。当前没有可靠、可验证的配对语义；自动模式明确使用原版 Material light/dark 主题对，避免猜测和破坏用户图片主题。

## 验收边界

必须验证：

1. 默认 absent 状态不改变任何既有用户主题；
2. 开启后立即按当前系统模式选择正确的原版 Material 主题；
3. IME 显示期间切换系统深浅模式不会崩溃，且键盘和底部视觉面一致切换；
4. 进程重建后自动模式仍生效；
5. 打开后取消主题选择器不关闭自动模式；
6. 实际选择固定/自定义主题会关闭自动模式；
7. API 17–34 旧设置与旧主题选择器仍可启动；
8. 6,633 个旧资源 ID、primary-DEX 边界、正式包非 Debug、v1/v2/v3 签名和 16 KiB ZIP alignment 保持不变。

## Pixel 10 Pro 验收

设备：Pixel 10 Pro，Android 16 / API 36，4 KiB page size。

Debug V3 只记录 `Configuration.uiMode`、解析目标、主题对提交和 InputView 重建事件，不记录 Preference key/value、输入、候选、剪贴板、联系人、词典或触摸数据。确认结果：

```text
深色：uiMode=33 → target=dark → committed
浅色：uiMode=17 → target=light → committed → rebuild InputView
反向：uiMode=33 → target=dark → committed → rebuild InputView
IME PID 全程不变
```

前两次视觉失败期间自动模式实际未开启；Debug 启动时只有 Configuration 事件，用户重新开启开关后才出现主题解析事件。因此失败不能归因于浅色资源、配置分发或主题写入。显式 InputView 重建仍作为确定性生命周期保证保留。

最终 release-like V4 完成深色 → 浅色真机切换：

```text
artifact=work/modern-settings-system-auto-theme-v4.apk
SHA-256=768f6337d2ac4c83133ffe92aa9d7e0aea73b195ab25720f1cb189e182fac6fa
size=27,542,108 bytes
debuggable=false
PID=26772 → 26772
result=dark passed, light passed, crash buffer empty
reproducible=byte-identical double build
```

测试结束后已恢复：

```text
system night mode=yes
default IME=com.google.android.inputmethod.pinyin.compat/com.google.android.inputmethod.pinyin.PinyinIME
```

设备仅保留正式包和本次 `themeaudit` 包；旧 `materialcomposehostaudit` 已卸载。

## 正式候选构建

提交 `4d3ef5f` 的手动 Actions 构建通过全部正式门禁，不创建 Tag 或 GitHub Release：

```text
run=31352617000
artifact=9049552834
package=com.google.android.inputmethod.pinyin.compat
versionName=2.0.1
versionCode=4520386
targetSdkVersion=36
debuggable=false
size=27,538,012 bytes
SHA-256=dbb040714db26157857d0852000fe0cdcf6bb7edd280c8d5df906600f5230cb3
certificate SHA-256=985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F
v1/v2/v3=true
16 KiB ZIP alignment=true
reproducible signed build=true
```

该正式候选包含最终设置首页标题和 System Auto 功能，但尚未覆盖安装；安装正式 application ID 仍须单独授权。
