# 英文九键多击选字设计

## 目标

英文 9 键键盘增加一个可选的「复古 9 键」模式：打开后，在同一数字键上连续点击，按点击次数选择该键分组的第 N 个字母，单击 `2` 出 `a`，时间窗内再点出 `b`、`c`，超过字母数后循环回第一个字母。等待窗口没结束前，刚输入的字母保持 composing 状态，由编辑器绘制下划线，窗口结束后下划线消失而字母保留。

该开关默认关闭。关闭时键盘完全保持原版英文 9 键的行为，键盘选择页也不新增任何布局。

## 与原版英文 9 键的关系

不新增键盘布局。原生键盘选择页里英文仍然只有「英文 26 键」和「英文 9 键」两个条目；`res/xml/ime_en_9key.xml` 的 `string_id`、键盘组和标签都不变，只把 IME 类指向兼容类：

```text
res/xml/ime_en_9key.xml  class 改为
com.google.android.inputmethod.pinyin.EnglishT9MultiTapIme
```

兼容类继承 `English9KeyIme`，开关关闭时每个入口都交回原实现：

```text
handle(Event)                          → English9KeyIme.handle(event)
computeShouldShowSuggestions(EditorInfo)  → English9KeyIme...
computeShouldEnableAutoCorrection(EditorInfo) → EnglishIme...
requestCandidates(I)                   → English9KeyIme...
```

因此关闭状态下联想、自动纠错、标点候选，以及原版键盘定义和软键都保持不变；打开后才接管数字键。

原版 `English9KeyIme.handle()` 已经把数字键的 keycode 映射为该键分组的第一个字母，再把改写后的 KeyData 交给 `EnglishIme`：

```text
KEYCODE_2 + DECODE
→ Event 拷贝
→ KeyData(KEYCODE_A, DECODE, "a")
→ EnglishIme.handle()
```

多击模式沿用这条经过验证的字母分组与大小写规则，只把「固定取第一个字母」扩展为「按连击次数取第 N 个字母」。待定字母通过原生 `IImeActionDelegate.setComposingText()` 写入，不自行操作 `InputConnection`；`English9KeyIme`、`EnglishIme` 和 `LatinIme` 在各自的组合路径上也调用同一个接口。

分组顺序与原版软键一致：`abc`、`def`、`ghi`、`jkl`、`mno`、`pqrs`、`tuv`、`wxyz`。

## 多击状态机

兼容类 `com.google.android.inputmethod.pinyin.EnglishT9MultiTapIme` 继承 `English9KeyIme`，只覆盖必要的方法：

- `enabled()`：读取 `en_t9_multitap_enabled`，缺省 false。
- `handle(Event)`：先看开关，关闭时直接走 `:compat_delegate` 交给父类；打开时仅拦截 keycode 为 `KEYCODE_2..KEYCODE_9` 且 intention 为 `DECODE` 的事件。同键且在窗口内则连击计数加一，否则重置为 1，按 `(计数 - 1) % 字母数` 取字母。
- 新的一轮连击开始时先 `finishRun()` 提交上一轮的待定字母；同一键的后续连击直接用 `mImeDelegate.setComposingText()` 替换 composing 区域里的字母，因此不需要 `KEYCODE_DEL`，也不依赖「光标未移动」这一前提。
- `run()` 由主线程 `Handler` 在窗口到期时执行 `finishRun()`，把 composing 字母落定，编辑器随之去掉下划线。
- `intervalMs()`：读取 `en_t9_multitap_interval_ms`，缺省 `600`，并收敛到 100 至 2000 ms。钳位分支必须在取值已合法时跳过赋值，下限用 `if-ge`、上限用 `if-le`；写成 `if-lt`／`if-gt` 会把任何取值都钳成 2000 ms，静态门禁已锁定这两个助记符。
- `onDeactivate()` 与 `onActivate()` 都结束未完成的连击，避免切换输入会话后遗留 composing 状态。
- `computeShouldShowSuggestions()` 与 `computeShouldEnableAutoCorrection()` 在开关打开时返回 false，关闭时交回父类。
- `requestCandidates(I)` 在开关打开时不追加任何候选，关闭时交回父类。
- `onKeyboardStateChanged(JJ)` 用键盘状态的 shift 位记录大小写。

键音与振动由触摸管线在事件到达 IME 之前触发，兼容类只改写待定字母，不自行播放反馈。

## 设置项

```text
pref_key_en_t9_multitap_enabled      Boolean 默认 false
pref_key_en_t9_multitap_interval_ms  String  默认 600，依赖上面的开关
取值 300 / 400 / 500 / 600 / 800 / 1000 ms
```

- 旧 Preference：在 `res/xml/setting_input.xml` 的英文分类顶部新增「复古 9 键」`CheckBoxPreference`，以及用 `android:dependency` 挂在它下面的 `ListPreference`。
- API 35+ Compose：在英文输入页顶部新增同一开关和同名单选项，key、类型与默认值一致，通过 `BooleanSettingContracts`、`ListSettingContracts`、`LegacySettingsRepository` 与 `SettingsController` 复用同一 SharedPreferences。
- 两种界面都遵循项目现有的依赖项约定：开关关闭时只置灰、不清除已选值，重新打开后恢复；仓库层同样拒绝在开关关闭时写入间隔。

## 边界与取舍

- 只影响英文 9 键。英文 26 键、中文九宫格、全键盘、手写与密码键盘不受影响。
- 打开后该键盘不联想，所以英文 T9 词组联想只保留在关闭状态下。
- 开关默认关闭，全新安装或升级后英文 9 键就是原版行为；要用多击需要先到「输入设置 → 英文」打开「复古 9 键」。
- 连击超过分组字母数时循环回第一个字母。
- 换键或超过窗口即结束本轮，`tapCount` 重置。
- 下划线由编辑器对 composing 区域绘制。少数不支持 composing 的输入框可能不显示下划线，此时字母仍按同样时机落定。

## 验证

静态门禁 `scripts/verify_english_t9_multitap.py` 检查：

- 兼容类的父类、`Runnable` 实现、开关读取，以及关闭时对 `handle`、联想、自动纠错、标点候选四个入口的 `invoke-super` 回退
- 打开时的 composing 组合路径、窗口定时器、字母分组顺序和间隔钳位方向
- 键盘选择页不再有独立多击布局；`ime_en_9key.xml` 只改 IME 类，`string_id`、键盘组和标签保留
- `keyboard_en_9key.xml` 与 `softkeys_9key.xml` 未被改写
- 旧设置页与 Compose 使用同一 key、同一默认值、同一组取值和同一父子关系

仍需在真机确认：打开「复古 9 键」后英文 9 键按 a→b→c 循环、等待窗口内字母带 composing 下划线且窗口结束或换键后消失、4 字母键 `7` 与 `9`、大小写、关闭后联想与候选完全回到原版，以及中文九宫格和中英文候选的回归。

## 当前限制

已完成从原始 APK 开始的完整本地重建和静态门禁，产物是隔离审计包。下划线依赖编辑器对 composing 区域的绘制，不支持 composing 的输入框可能不显示下划线，此时字母仍按同样时机落定。
