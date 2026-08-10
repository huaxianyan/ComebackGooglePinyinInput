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

最终模型保存一个模式标记和三套彼此独立的完整主题规格：

```text
followThemeEnabled
lightThemeSpec  = base + additional
darkThemeSpec   = base + additional
fixedThemeSpec  = base + additional
```

实际键包括：

```text
compat_system_auto_keyboard_theme
compat_theme_light_keyboard
compat_theme_light_additional
compat_theme_dark_keyboard
compat_theme_dark_additional
compat_theme_fixed_keyboard
compat_theme_fixed_additional
```

原版两个键：

```text
pref_key_keyboard_theme
pref_key_additional_keyboard_theme
```

只作为当前活动槽位的运行时物化结果。切换模式或系统深浅状态不会覆盖任何非活动槽位。不把 `false` 作为长期模式状态保存；关闭跟随时删除模式键，保留 absent/default 语义。

首次迁移规则：

```text
fixed = 用户迁移时的原版当前主题
light = 原版 Material Light
dark  = 原版 Material Dark
follow = 仅保留已经显式存在的旧自动模式状态，否则关闭
```

### 解析规则

```text
跟随关闭                 → fixedThemeSpec
跟随开启 + UI_MODE_NIGHT_YES → darkThemeSpec
跟随开启 + 其他 night mode   → lightThemeSpec
```

系统只决定使用浅色槽还是深色槽，不判断、重分类或限制用户选入槽位的主题。三个槽位都可以保存任意内置、图片或自定义主题。

### 生命周期

纯 Java、primary-DEX、AndroidX-free 的 `SystemAutoThemeCompat` 在以下时机物化主题：

1. IME `onCreate()`：清理中断的选择会话，并在创建主题和键盘对象前恢复活动槽；
2. IME `onConfigurationChanged(Configuration)`：跟随开启时先物化浅色/深色槽，再执行原框架 InputView 重建；
3. 用户切换跟随模式：立即物化新的活动槽；
4. 用户从原版选择器返回：捕获完整的 `base + additional` 主题对到本次目标槽，再恢复当前活动槽。

API 17–34 的正常启动路径不会解析 Compose/AndroidX 类型。

### 原版主题选择器与自定义主题生命周期

浅色、深色和固定槽均复用未导出的同包 `ThemeSelectorActivity`，不复制主题列表、图片裁剪、编辑器或预览逻辑。进入选择器前只临时物化目标槽，返回时再提交该槽；因此一个槽的选择不会覆盖另外两个槽。

用户主题被编辑或删除时，桥接层使用原版编辑器已经解析出的替代/回退主题对，更新所有仍引用旧文件的槽位。这样同一自定义主题被多个槽共享时不会留下失效引用，也不需要读取、分析或分类图片内容。

API 17–34 的普通原版主题选择仍保持兼容：实际选择会退出跟随模式并更新固定槽；仅打开后取消不会改变模式。

### API 35+ 设置呈现

“外观与布局”只保留一个“主题背景”导航入口，子页为：

```text
跟随主题
浅色模式主题
深色模式主题
固定主题
```

- 跟随开启：浅色和深色槽可编辑，固定槽禁用但保留；
- 跟随关闭：固定槽可编辑，浅色和深色槽禁用但保留；
- 禁用行明确说明需要开启或关闭“跟随主题”；
- UI 和 Repository 同时拒绝对禁用槽的写入。

## 未采用方案

### 系统切换时只覆盖固定主题值

拒绝。该方案无法区分“用户主动选择当前主题”和“自动模式暂时解析为当前主题”，系统切换一次后就会丢失用户的自动选择身份。

### 复制或手绘 Gboard 主题

拒绝。目标是复用原版 Google 拼音主题对和渲染链路，而不是复制 Gboard 的代码、资源或外观。

### 为用户主题自动推断“浅色”或“深色”类别

拒绝。系统只按 `uiMode` 选择用户保存的浅色槽或深色槽，不分析图片、颜色或主题元数据，也不替用户定义某个主题属于哪一类。

## 验收边界

必须验证：

1. 默认 absent 状态迁移为固定模式，并保留用户当前原版主题；
2. 三个槽都能进入完整原版选择器，并独立保留完整主题对；
3. 跟随开启时仅浅色/深色槽可写，关闭时仅固定槽可写；
4. IME 显示期间切换系统深浅模式不会崩溃，且键盘和底部视觉面一致切换；
5. 固定模式下切换系统深浅状态不会改变主题；
6. 重新开启跟随后恢复先前保存的浅色或深色槽，不覆盖固定槽；
7. 进程重建和中断的选择会话不会使运行时主题停留在错误槽；
8. 自定义主题编辑/删除会修复所有引用槽，不留下失效文件引用；
9. API 17–34 普通原版主题选择仍能退出跟随并更新固定槽；
10. 6,633 个旧资源 ID、primary-DEX 边界、正式包非 Debug、v1/v2/v3 签名和 16 KiB ZIP alignment 保持不变。

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

第二阶段 release-like V6 验证了独立槽位模型：

```text
artifact=work/modern-settings-theme-slots-v6.apk
SHA-256=c3fc6be534859e9d802910c36204cb49806c7b452569ef62803bed0af5f21742
size=27,550,300 bytes
debuggable=false
follow on + system dark  → saved dark slot
follow on + system light → saved light slot
follow off + system light → saved fixed slot
follow off + system dark  → fixed slot unchanged
follow on + system dark   → previously saved dark slot restored
IME PID=3992 throughout system light/dark transitions
crash/DropBox/VerifyError/IllegalAccessError=0
```

三个槽都能进入完整原版主题选择器。V5 曾错误地把选择器初始化时的 `onThemeSelected()` 当作用户点击而立即关闭；V6 删除了该假设，选择器保持原版生命周期，用户返回时才提交槽位。

包含共享自定义主题引用修复和旧设置编辑退出跟随语义的最终 V8 可复现审计构建：

```text
artifact=work/modern-settings-theme-slots-v8a.apk
SHA-256=ab144b3b28deae0945dcb2231ff0b6ba332a4b6427cf4a91c52b48864638f350
size=27,550,300 bytes
second build=work/modern-settings-theme-slots-v8b.apk
byte-identical=true
tests=64, failures=0, errors=0, skipped=0
legacy resource IDs=6633/6633
API gates=31/33/34/35/36 passed
signing=v1/v2/v3
16 KiB ZIP alignment=passed
ART launch=passed, VerifyError/IllegalAccessError=0
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
