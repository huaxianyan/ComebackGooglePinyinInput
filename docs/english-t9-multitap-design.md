# 英文 T9 多击键盘设计

## 目标

在英文输入下新增一个可独立选择的键盘，用「同键连击次数」选字母：单击 `2` 出 `a`，在时间窗内再点出 `b`、`c`，超过该键字母数后循环回第一个字母。等待窗口没结束前，刚输入的字母保持 composing 状态，由编辑器绘制下划线，窗口结束后下划线消失而字母保留。该键盘不联想，按键音与振动保持原生行为。

现有键盘、设置和输入路径全部保持不变，本次改动是纯增量。

## 与原版英文 9 键的关系

原版 `English9KeyIme.handle()` 已经把数字键的 keycode 映射为该键分组的第一个字母，再把改写后的 KeyData 交给 `EnglishIme`：

```text
KEYCODE_2 + DECODE
→ Event 拷贝
→ KeyData(KEYCODE_A, DECODE, "a")
→ EnglishIme.handle()
```

新键盘沿用这条经过验证的字母分组与大小写规则，只把「固定取第一个字母」扩展为「按连击次数取第 N 个字母」。待定字母通过原生 `IImeActionDelegate.setComposingText()` 写入，不自行操作 `InputConnection`；`English9KeyIme`、`EnglishIme` 和 `LatinIme` 在各自的组合路径上也调用同一个接口。

分组顺序与原版软键一致：`abc`、`def`、`ghi`、`jkl`、`mno`、`pqrs`、`tuv`、`wxyz`。

## 键盘与注册方式

新键盘是一份新的 IME 定义，而不是修改原版英文 9 键：

```text
res/xml/ime_en_t9_multitap.xml      新 IME 定义，class 指向新兼容类
res/xml/keyboard_en_t9_multitap.xml 新键盘，复用原版 9 键软键与 keymapping
res/xml/framework_english_soft.xml  在原版清单中追加一项 include
```

原版英文软键盘清单只包含 `ime_en_qwerty` 与 `ime_en_9key`。新增一项 include 后，原生键盘布局 Dashboard 会把它作为第三个英文布局列出，因为它按 `IKeyboardDelegate.getEnabledInputBundlesByLanguage()` 生成条目。

新的键盘定义复用 `softkeys_input_en_9key`、`keymapping_body_en_9key` 和 `keyboard_9key_body_no_deletable_label`，所以视觉、软键定义与点按反馈和原版英文 9 键完全一致，只有 IME 类不同。

## 多击状态机

兼容类 `com.google.android.inputmethod.pinyin.EnglishT9MultiTapIme` 继承 `English9KeyIme`，只覆盖必要的方法：

- `handle(Event)`：仅拦截 keycode 为 `KEYCODE_2..KEYCODE_9` 且 intention 为 `DECODE` 的事件。同键且在窗口内则连击计数加一，否则重置为 1，按 `(计数 - 1) % 字母数` 取字母。
- 新的一轮连击开始时先 `finishRun()` 提交上一轮的待定字母；同一键的后续连击直接用 `mImeDelegate.setComposingText()` 替换 composing 区域里的字母，因此不需要 `KEYCODE_DEL`，也不依赖「光标未移动」这一前提。
- `run()` 由主线程 `Handler` 在窗口到期时执行 `finishRun()`，把 composing 字母落定，编辑器随之去掉下划线。
- `intervalMs()`：读取 `en_t9_multitap_interval_ms`，缺省 `600`，并收敛到 100 至 2000 ms。钳位分支必须在取值已合法时跳过赋值，下限用 `if-ge`、上限用 `if-le`；写成 `if-lt`／`if-gt` 会把任何取值都钳成 2000 ms，静态门禁已锁定这两个助记符。
- `onDeactivate()` 与 `onActivate()` 都结束未完成的连击，避免切换输入会话后遗留 composing 状态。
- `computeShouldShowSuggestions()` 与 `computeShouldEnableAutoCorrection()` 返回 false，关闭联想与自动纠错。
- `requestCandidates(I)` 覆盖为空实现，避免继承的英文 9 键把标点候选列表当作阅读文本候选追加进来。
- `onKeyboardStateChanged(JJ)` 用键盘状态的 shift 位记录大小写。

键音与振动由触摸管线在事件到达 IME 之前触发，兼容类只改写待定字母，不自行播放反馈。

## 设置项

```text
pref_key_en_t9_multitap_interval_ms  String  默认 600
取值 300 / 400 / 500 / 600 / 800 / 1000 ms
```

- 旧 Preference：在 `res/xml/setting_input.xml` 的英文分类顶部新增 `ListPreference`。
- API 35+ Compose：在英文输入页顶部新增同名单选项，key、类型与默认值一致，通过 `ListSettingContracts`、`LegacySettingsRepository` 与 `SettingsController` 复用同一 SharedPreferences。

## 边界与取舍

- 只对新键盘生效。原版英文 9 键、中文九宫格、全键盘、手写与密码键盘不受影响。
- 该键盘按设计不联想，因此英文 T9 词组联想只保留在原版英文 9 键上。
- 连击超过分组字母数时循环回第一个字母。
- 换键或超过窗口即结束本轮，`tapCount` 重置。
- 下划线由编辑器对 composing 区域绘制。少数不支持 composing 的输入框可能不显示下划线，此时字母仍按同样时机落定。

## 验证

静态门禁 `scripts/verify_english_t9_multitap.py` 检查：

- 新 Smali 的父类、`Runnable` 实现、字母分组顺序、`setComposingText` 与 `finishComposingText` 组合路径、窗口定时器和设置键名
- 新 IME 与键盘资源引用原版软键，不复制第二份软键定义
- 英文软键盘清单同时保留 `ime_en_qwerty`、`ime_en_9key` 并追加新 IME
- 原版 `ime_en_9key.xml`、`keyboard_en_9key.xml`、`softkeys_9key.xml` 未被改写
- 旧设置页与 Compose 使用同一 key、同一组取值与默认值 600

已在真机确认：键盘布局列表出现第三个英文布局，2 至 9 的逐键多击按 a→b→c 循环，等待窗口内字母带 composing 下划线，窗口结束或换键后下划线消失，并且「多击间隔」设置确实生效（此前钳位分支写反导致窗口恒为 2000 ms，已修复）。仍需确认：4 字母键 `7` 与 `9` 的循环、大小写、无英文候选、按键音与振动，以及原版英文 9 键和中文九宫格的回归。

## 当前限制

已完成从原始 APK 开始的完整本地重建、静态门禁和核心真机验收，产物是隔离审计包。下划线依赖编辑器对 composing 区域的绘制，不支持 composing 的输入框可能不显示下划线，此时字母仍按同样时机落定。
