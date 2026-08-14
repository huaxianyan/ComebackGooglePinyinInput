# 简繁 Header 快捷切换设计与验收

## 目标

在明确支持的普通中文软键盘 Header 中提供简体/繁体中文快速切换，同时保留原生候选、学习、词典、语音输入、收起键、Access Points、语言标签、Clipboard 和 Inline Autofill 语义。

用户可在「键盘 → 按键」中关闭该额外入口。设置项紧跟「显示语音输入按钮」，但不依赖语音功能是否可用。

## 设置契约

```text
key=show_simplified_traditional_header_toggle
default=true
```

该设置只控制 Header 快捷按钮的可见性：

- 不改变当前简繁模式
- 不直接修改 `enable_sc_tc_conversion`
- 不改变原「繁体中文」设置的 key、默认值或存储类型
- API 17–34 使用 legacy Preference
- API 35+ 使用 Compose Material 3 设置
- 设置和 IME 处于同一应用进程时通过 `SharedPreferences` listener 即时更新，View 重新 attach 时也会重新读取。

## 支持范围

首版只接入已经具有原生中文 HMM 简繁状态能力的三个普通中文软键盘：

```text
keyboard_zh_cn_pinyin_qwerty
keyboard_zh_cn_pinyin_9key
keyboard_zh_cn_stroke
```

以下路径保持不变且不显示快捷按钮：

- 英文 QWERTY 和英文 9 键
- 手写
- 符号、Emoji 和 Dashboard
- text/Web/visible password
- number、PIN、phone、date/time
- hard 和 floating-hard keyboard。

未知键盘不会获得该入口。

## 原生状态机

按钮是原生 `SoftKeyView`，不是 Candidate、Header Platform remote Surface 或透明 Overlay。两个显示状态复用原始 SoftKey 事件：

```text
当前简体：显示“简”
点击：KEYBOARD_STATE_ON + ENABLE_SC_TC_CONVERSION

当前繁体：显示“繁”
点击：KEYBOARD_STATE_OFF + ENABLE_SC_TC_CONVERSION
```

事件继续进入 `AbstractHmmChineseDecodeProcessor.onKeyboardStateChanged()`，由原实现统一处理：

- keyboard state
- `enable_sc_tc_conversion`持久化
- HMM 转换模式
- 当前 composition 和 Candidate 刷新
- 设置页「繁体中文」状态同步。

快捷按钮实现不调用 `commitText()`，不读输入、Candidate、Clipboard 或 Autofill 内容，也不自行实现简繁转换。

## Header 布局与可见性

中文键盘使用专属 prime Header 资源。右侧原生顺序为：

```text
[简/繁] [voice 或 hide-keyboard]
```

现有映射保持：

```text
default       → softkey_voice
NO_MICROPHONE → softkey_hide_keyboard
```

按钮满足三个条件时才显示：

1. 用户设置开启
2. 当前 Header 中原生槽位空间充足
3. Access Points 未展开。

空间检查只使用中文 Header 专属布局中的明确 ID 和同一 `headerInner`局部坐标系：

```text
key_pos_header_access_points_menu
key_pos_header_lang_1
key_pos_header_lang_2
key_pos_header_voice
```

不使用屏幕/全局坐标，不遍历任意 sibling，不缩小、覆盖或替换既有触摸目标。空间不足时快捷按钮为 `GONE`。

### Access Points 仲裁

原生 `AccessPointsBar`在展开动画开始时把：

```text
access_points_overlay_view
```

设为 `INVISIBLE`，使「中/EN」语言槽隐藏；收起动画结束时恢复 `VISIBLE`。

简繁按钮复用同一个可见性信号：

```text
access_points_overlay_view == VISIBLE
→ 可以显示简繁按钮

access_points_overlay_view != VISIBLE
→ 隐藏简繁按钮
```

因此 Access Points 展开时，简繁按钮与「中/EN」同步隐藏，第四个 Access Point 不会与其重叠；语音/收起键继续保留。

## 可访问性

按钮文案表示当前输出模式，并同时说明点击动作：

```text
简：简体中文，切换到繁体中文
繁：繁体中文，切换到简体中文
```

设置开关提供独立标题和说明，英文、简体中文、繁体中文（台湾、香港）均有资源。

## 静态和构建验证

专项门禁：

```text
scripts/verify_simplified_traditional_header_toggle.py
```

覆盖：

- Preference key 和三处默认值一致
- legacy 与 Compose 设置位置
- 三个且仅三个支持键盘
- ON/OFF 原生状态事件
- voice/hide-keyboard 映射保留
- Access Points 展开状态同步
- 局部坐标空间检查
- 禁止 `commitText()`、直接 Preference 写入和全局坐标
- Java 生成 Smali 契约
- 最终 APK 资源与 DEX 存在性。

Release workflow 已执行该门禁。最终隔离审计包继续通过：

- 从原 APK 完整重建
- Compose Material 3 runtime
- API 31、33、34、35、36 门禁
- Universal Header
- Header Platform
- Inline Autofill
- sensitive Clipboard
- 6,633 个 legacy 资源 ID
- non-debuggable
- APK v1/v2/v3 签名
- 16 KiB ZIP alignment。

## 真机验收

设备：

```text
Pixel 10 Pro
Android 16 / API 36
```

最终审计实现：

```text
package=com.google.android.inputmethod.pinyin.sctcaudit3
versionName=2.0.4-sc-tc-audit3
versionCode=4520394
SHA-256=cdc77c43e726fc101d453fc2126c0089fbdbfeb7125d03f298849a4266c868a1
```

用户确认：

- 点击可快速切换简体和繁体
- 实际中文输入和 Candidate 随模式变化
- 设置页原「繁体中文」开关同步变化
- 新增显示开关符合预期
- Candidate、Clipboard 和 Inline Autofill 运行正常
- voice/hide-keyboard 状态和位置正确
- Access Points 展开时简繁按钮与「中/EN」同步隐藏
- 第四个 Access Point 不再重叠
- Access Points 收起后按钮正确恢复
- 最终主观结论：无问题。

验收后已恢复正式输入法：

```text
com.google.android.inputmethod.pinyin.compat/com.google.android.inputmethod.pinyin.PinyinIME
```

Bitwarden Autofill 保持不变，`audit2`和`audit3`审计包均已卸载。
