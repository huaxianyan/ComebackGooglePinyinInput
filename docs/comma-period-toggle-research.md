# 逗号与句号显示开关方案调研

> **状态：已封存，尚未实施。**
>
> 方案选型已完成，倾向方案 A，但没有开启分支。
> 以下四项待确认问题仍未决定，实施前需要先定下来：
>
> 1. 开关范围是否只限中文底部行，英文底部行的半角 `,` `.` 是否同样提供
> 2. 全屏手写是否纳入
> 3. 关闭逗号后长按表情入口消失，是否就是最终预期，还是希望迁移到语言键位置
> 4. 开关放在「键盘 → 按键」还是别处
>
> 恢复这项工作的前置条件：按当前 `master` 基线新建分支，并先按「静态门禁需要覆盖」一节补齐验证项。

## 需求

给底部行的逗号键和句号键增加显示开关。关闭后该键让出空间，由空格键延伸占用，长按等既有入口按既定规则处理。

不是交换逗号和句号字符，而是隐藏这两个按钮。

## 底部行的槽位结构

底部行布局 `res/layout/keyboard_prime_bottom.xml`，手机资源：

```text
key_pos_switch_to_symbol        150   切换符号键盘
key_pos_bottom_symbol_1         100   逗号
key_pos_space 容器              500   ├ key_pos_switch_to_next_language  100（visibility=gone）
                                      └ key_pos_space                    400
key_pos_bottom_symbol_2         100   句号
key_pos_ime_action              150   回车或确认
```

`sw600dp` 有自己的独立布局 `res/layout-sw600dp-v13/keyboard_prime_bottom.xml`，权重不同，并多出一个 `key_pos_switch_to_smiley` 槽位：

```text
key_pos_switch_to_symbol        100
key_pos_bottom_symbol_1         100   逗号
key_pos_space 容器              600   ├ key_pos_switch_to_next_language  100（visibility=gone）
                                      └ key_pos_space                    500
key_pos_switch_to_smiley        100
key_pos_bottom_symbol_2         100   句号
key_pos_switch_to_symbol_right  100
```

权重合计 1100，手机为 1000。两套资源都要处理。

## 关键机制：softkey_empty 就是让出空间的既有实现

表情符号切换键和语言切换键**共用** `key_pos_switch_to_next_language` 槽位，由 `res/xml/keymapping_function_switch_language.xml` 决定内容：

```text
默认                              -> softkey_empty
state="SHOW_LANGUAGE_SWITCH_KEY"  -> softkey_switch_to_next_language
state="SHOW_EMOJI_SWITCH_KEY"     -> softkey_switch_to_emoji
```

这个槽位在布局里声明了 `android:visibility="gone"`。框架对 `softkey_empty` 有专门处理：`SoftKeyView.a(SoftKeyDef)Z` 中，当传入定义为空或 id 等于 `softkey_empty`（`0x7f0f0238`）时，会禁用按键、清空子 View，并把可见性恢复为构造时记录的初值，也就是 `GONE`。

于是槽位从布局中退出，其 `layout_weight` 不再参与分配，同一容器内的空格键自然占满剩余空间。**这正是现成的「让出空间给空格键延伸」机制**，不需要我们自己发明。

反过来，当映射到一个真实软键时，框架会 `setVisibility(0)` 恢复显示，所以默认行为不受影响。

## 权重分配的实际后果

需要留意一个容易误判的点：`LinearLayout` 按权重比例分配，某个槽位 `GONE` 后，空出的宽度会**按比例分给所有剩余槽位**，而不只给空格键。

以手机布局为例，去掉逗号的 100 权重后总权重从 1000 变为 900，符号键从 15% 变成 16.7%，确认键同理，都会轻微变宽。

要让空出的空间只给空格键、同时保持其他键宽度不变，需要把隐藏槽位的权重转移到空格容器上，让总权重保持 1000。手机布局的对应关系：

| 状态 | 容器权重 | 容器内 语言/表情 权重 | 容器内 空格 权重 | 结果 |
| --- | --- | --- | --- | --- |
| 默认 | 500 | 100 | 400 | 语言键 10%，空格 40% |
| 句号关闭 | 600 | 100 | 500 | 语言键 10%，空格 50% |
| 逗号关闭 | 600 | 100 | 500 | 语言键 10%，空格 50% |
| 逗号与句号都关闭 | 700 | 100 | 600 | 语言键 10%，空格 60% |

容器内语言键与空格的比例要同步调整，否则语言键会从 10% 涨到 12%，空出的空间不会完整给到空格键。

推导依据：总权重恒为 1000。符号键 150、确认键 150、句号 100、逗号 100 中隐藏的项转为容器权重，容器内语言键固定 100，空格吃掉剩余。

平板布局同理，总权重恒为 1100，默认容器 600、语言键 100、空格 500。

## 状态位的来源

状态在 `Keyboard` 的 `protected final a()J` 中计算，是 64 位掩码。相关两位：

| 位 | 值 | 含义 |
| --- | --- | --- |
| `STATE_SHOW_LANGUAGE_SWITCH_KEY` | `0x800` | 显示语言切换键 |
| `STATE_SHOW_EMOJI_SWITCH_KEY` | `0x10000000000000` | 显示表情切换键 |

方法末尾有一处互斥：

```text
if (shouldShowGlobeKey() && (state & STATE_SHOW_EMOJI_SWITCH_KEY) == 0) {
    state |= STATE_SHOW_LANGUAGE_SWITCH_KEY;
}
```

表情位一旦置位，语言位就不再置位。这与你的判断一致。

用户设置来自两个已存在的偏好，入口都在旧设置页 `res/xml/setting_keyboard.xml` 的「键盘 → 按键」：

- `pref_key_show_emoji_switch_key`，带 `disableDependentsState="true"`
- `pref_key_show_language_switch_key`，默认开启，用 `UncheckDisabledCheckBoxPreference`

两者已在 UI 层表达互斥，逗号开关应加入同一组依赖关系。

## 长按逗号进入表情的机制

`res/xml/keymapping_bottom_symbol_1_popup_switch_to_emoji_no_hint_icon.xml`：

```text
merge, state="EMOJI_AVAILABLE", exclude="INPUT_TYPE_EMAIL_ADDRESS,INPUT_TYPE_URI,SHOW_EMOJI_SWITCH_KEY"
    key_pos_bottom_symbol_1 -> softkey_fragment_bottom_popup_switch_to_emoji

merge, state="EMOTICON_AVAILABLE", exclude="INPUT_TYPE_EMAIL_ADDRESS,EMOJI_AVAILABLE"
    key_pos_bottom_symbol_1 -> softkey_fragment_bottom_popup_switch_to_emoticon
```

这是 `merge` 而非 `mapping`，意思是在逗号软键上**叠加**一个长按动作，不改主键位。表情键显示时 `SHOW_EMOJI_SWITCH_KEY` 进入状态，该 merge 被排除，长按逗号不再出表情，因为入口已经在语言键的位置上。

**实现时必须注意**：新增的逗号关闭状态也要加入这些 merge 的 `exclude_state`。否则逗号槽位虽然映射成空软键，merge 仍会按 `view_id` 把长按定义叠加上去，把槽位重新点亮，开关看起来失效。

## 组合枚举

设 E = 表情开关，L = 语言开关，C = 逗号开关，P = 句号开关。E 与 L 互斥，只有三种前置状态。

### 关闭逗号（C = 关）

| E | L | 逗号槽位 | 容器内语言/表情槽位 | 空格 | 是否与你描述一致 |
| --- | --- | --- | --- | --- | --- |
| 开 | 关（被禁止） | 空 | 表情键 | 延伸，吸收逗号与语言槽位两处共 20% | 一致。表情键随容器左移到逗号位置，空格延伸 |
| 关 | 开 | 空 | 语言键 | 同上 | 一致。语言键左移，长按表情入口消失 |
| 关 | 关 | 空 | 空 | 延伸，吸收逗号与语言槽位两处共 20% | 一致 |

「左移」不需要额外搬运软键。逗号槽位退出布局后，容器起点就是原来的逗号位置，容器内第一个子键（语言或表情键）自然出现在那里，视觉上即为左移。

### 关闭句号（P = 关）

与表情、语言无关，只有两种：

| P | 结果 |
| --- | --- |
| 开 | 句号槽位显示 `。` 或 `.` |
| 关 | 槽位退出布局，空出的 10% 转入空格容器 |

### 你未列出的情况

以下几点不改变上述主体结论，但实现时不能漏。

1. **网址与邮箱输入类型会占用这两个槽位**
   `keymapping_bottom_prime_symbol_inputtype.xml` 在 `INPUT_TYPE_URI` 下把逗号槽位换成 `/`、句号槽位换成 `.com`，在 `INPUT_TYPE_EMAIL_ADDRESS` 下换成 `@` 与 `.com`。此时两个开关应当无效，不能把 `/`、`@`、`.com` 一起隐藏。需要用 `exclude_state` 排除。

2. **只有颜文字可用时**
   长按逗号进入的是颜文字（`EMOTICON_AVAILABLE`）而不是表情。开关逻辑不受影响，但静态门禁要同时覆盖两个状态。

3. **符号键盘切换键在左侧**
   逗号左侧是 `key_pos_switch_to_symbol`，不属于本次范围。

4. **不影响其他键盘的逗号与句号**
   以下位置与此开关无关，实现时不应触碰：
   - 数字、电话、日期时间键盘的 `softkey_comma`、`softkey_sentence`
   - 手写键盘的 `key_pos_punctuation_1/2`
   - 符号键盘的 `softkey_comma`、`softkey_period`
   - 英文 QWERTY 的 `z` 上滑、`m` 下滑变体
   - 密码键盘

5. **平板布局差异**
   `sw600dp` 多出一个 `key_pos_switch_to_smiley` 槽位，权重体系也不同，必须单独验证，不能只测手机。

6. **全屏手写**
   全屏手写走 `keymapping_fullscreen_handwriting.xml`，不经过 `keyboard_prime_bottom.xml`，是否纳入范围需要你确认。

## 实现方案

### 方案 A：复用 softkey_empty 与状态位（推荐）

1. 新增偏好 `pref_key_show_comma_key`、`pref_key_show_period_key`，加入设置页并与现有的表情、语言开关共享依赖关系
2. 在 `Keyboard.a()J` 中追加两个状态位，读取上述偏好
3. 为逗号与句号槽位新增映射，命中新状态时指向 `softkey_empty`
4. 在两个底部行布局中给这两个槽位补上 `android:visibility="gone"`，使空状态能真正退出布局
5. 按上表把隐藏槽位的权重转入空格容器，并同步容器内比例
6. 把新状态位加入长按表情 merge 的 `exclude_state`

优点：

- 隐藏与空间让出完全复用框架现成机制，语言键与表情键就是这么工作的
- 长按、无障碍描述由框架统一处理
- 输入类型差异用现成的 `exclude_state` 表达

缺点：

- 需要改 `Keyboard` 的状态计算，属于框架核心，要仔细验证
- 权重需要按状态调整，静态 XML 表达不了，可能需要一个小的运行时代码路径

### 方案 B：自定义 SoftKeyView 子类直接改可见性与权重

沿用简繁切换按钮的思路，继承 `SoftKeyView`，读偏好后设置 `View.GONE` 并调整权重。

优点：

- 不改框架状态计算
- 项目已有同类先例

缺点：

- 可见性要自己管，等于重新实现一遍框架已有的 `softkey_empty` 逻辑
- 长按 merge 在状态层生效，View 层隐藏后状态位不变，两者会不一致
- 需要在多处布局声明，容易漏掉平板

### 方案 C：只改权重不隐藏

不可行。槽位仍占据宽度，会留下空白而不是给空格键。

## 建议

采用**方案 A**。理由是它复用的正是框架为语言键、表情键设计的机制，隐藏、空间让出和长按排除三者语义一致，不需要在 View 层另造一套。

## 关闭逗号键的风险提示

按你的意见，开关说明中提示风险即可，不必阻止用户。建议覆盖三点：

- 关闭逗号键后，长按进入表情符号的入口可能一并消失
- 需要该入口时，可改由语言切换键位置的表情符号键提供
- 逗号仍可通过符号键盘输入

具体措辞按界面语境再定。

## 静态门禁需要覆盖

1. 默认状态两个槽位仍映射到各自的全角标点软键
2. 关闭状态下两个槽位映射到 `softkey_empty`
3. `INPUT_TYPE_URI`、`INPUT_TYPE_EMAIL_ADDRESS` 下开关不生效
4. 长按表情 merge 的 `exclude_state` 已包含新增状态位
5. `softkey_bottom_sentence_zh_popup_punctuation` 的长按数据未被改写
6. 数字、电话、手写、符号、密码键盘的标点定义未被触碰
7. 手机与平板两套底部行布局的权重关系符合上表
8. 总权重在每种状态下保持恒定，符号键与确认键宽度不变

## 待确认

1. 开关范围是否只限中文底部行，英文底部行的半角 `,` `.` 是否同样提供
2. 全屏手写是否纳入
3. 关闭逗号后长按表情入口消失，是否就是最终预期，还是希望迁移到语言键位置
4. 开关放在「键盘 → 按键」还是别处

## 证据位置

调研用的解码产物与检索脚本在 `work/commaswap/`，`work/decoded/` 为原始 APK 解码结果。本文件只记录结论与依据，不含用户数据。
