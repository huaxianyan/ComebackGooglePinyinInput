# Gboard 字体大小控件研究

## 目的与边界

本研究只用于为 Google 拼音现代设置中的「按键音量」和「振动时长」确定信息架构。
只检查 Gboard 已安装 APK 的公开 Manifest、资源和 DEX，不读取 Gboard 私有目录、
SharedPreferences、用户输入、候选、词典或其他用户数据，也不复制其代码和资源。

## 当前设备样本

```text
package=com.google.android.inputmethod.latin
versionName=17.8.4.939743344-release-arm64-v8a
versionCode=175894542
targetSdk=37
base.apk SHA-256=0d64ae4a5e6d05628541263996b763e1e0ebe390b73f546af230152e94ca6572
base.apk size=88449796 bytes
```

本地审计证据位于未跟踪的 `work/research/gboard-current-public/`。仓库中已有的较旧
Gboard 样本呈现相同结构，因此这一结构不是当前单个版本的偶发现象。

## 已确认事实

`setting_preferences.xml` 将字体大小声明为：

```text
FontSizeSliderPreference
  -> SystemFontAwareSliderPreference
  -> com.android.settingslib.widget.SliderPreference
```

当前版本的 `SystemFontAwareSliderPreference` 使用布局资源 `0x7f0e06c6`。该布局按
以下顺序组织：

1. 标题
2. 当前状态摘要
3. 包含减小操作、Material Slider 和增大操作的水平控制行
4. 一个全宽 MaterialButton，用于「使用设备字体大小」。

`FontSizeSliderPreference` 为两端操作设置字体减小/增大的图标和无障碍描述。Slider
启用 accessibility live region，使档位变化可以被辅助功能及时感知。

系统字体感知基类以「持久化字符串是否为空」区分设备默认和自定义状态：

- 空值：摘要显示「与设备相同」，恢复设备默认按钮禁用
- 非空值：摘要显示对应 entries 标签，恢复设备默认按钮启用
- 点击恢复按钮后清除自定义值并重新跟随设备字体大小
- 系统 `font_scale` 变化由 ContentObserver 观察并刷新有效档位。

Gboard 能在「跟随设备」状态继续显示 Slider，是因为 Android 提供了可读取的系统
`font_scale`，它可以映射到最近档位。

## 与 Google 拼音音量/振动的关键差异

Google 拼音的两个状态契约是：

```text
sound_volume:
  key absent -> system/device default, effective fallback may be -1.0
  explicit 0.0 -> numeric zero
  explicit range -> 0.0..1.0, original control has 100 steps

vibration_duration:
  key absent -> system/device default, effective fallback may be -1 ms
  explicit 0 ms -> stored "0"
  explicit N ms -> stored (N + 1).toString()
  original control range -> 0..100 ms
```

负值只是「交给系统」的 sentinel，不是可呈现的实际音量或振动时长。与 `font_scale`
不同，应用无法从该 sentinel 推导出真实 Slider 位置。因此不能原样照搬 Gboard 在默认
状态下仍显示手柄的行为，也不能把手柄放在零档或任意中间档。

## 采用的设计方向

借鉴 Gboard 的信息层级和控制组合，但保持 Google 拼音契约：

### 系统默认状态

- 显示标题和「系统默认」摘要
- 不显示带虚假位置的 Slider
- 显示明确的「设置自定义值」操作
- 不因进入草稿调整状态而立即写入
- 系统默认与显式零继续是不同领域状态。

### 显式自定义状态

- 标题下显示当前百分比或毫秒值
- 使用官方 Compose Material 3 Slider
- Slider 两端提供减小/增大操作及完整无障碍描述
- 下方提供全宽「使用系统默认」按钮
- 按钮通过删除原 key 恢复 absent 状态，而不是写入负 sentinel
- 父开关关闭时，整个控制组保留当前值但进入禁用状态。

### 从系统默认进入自定义

系统默认没有真实数值起点。进入自定义时先建立未持久化草稿，只有用户明确选择数值
后才提交。不得仅因点击「自定义」就静默写入显式零或任意新默认值。具体草稿交互需在
写入实现前通过单元测试固定。

### 预览和提交

- 右侧值文本随拖动中的草稿即时更新
- SharedPreferences 只在确认的离散值变化结束后提交
- 音量预览沿用原 `AudioManager.playSoundEffect(5, volume)` 语义
- 振动预览沿用原「仅正时长才振动」的语义，并使用当前 Android 版本允许的公开 API
- 恢复系统默认不触发伪造的零值预览。

## 不采用的方案

- 不复制 Gboard 的布局、图标、资源或实现代码
- 不引入 SettingsLib 或 Material Components Views，以免与旧 AppCompat 资源命名空间冲突
- 不在系统默认状态伪造 Slider 手柄位置
- 不把 `-1` 传给 Slider 后依赖 clamp
- 不通过额外 Preference key 记忆「上一个自定义值」，因为这会改变公开存储契约
- 不在用户尚未选择数值时自动持久化零或任意中间值。
