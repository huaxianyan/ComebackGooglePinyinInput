# 提升最低版本、弃用旧设置页与新主题选择页：先期调研

本文只做调研与前置工作拆解，不含实施。所有现状判断都标了证据来源，实测与推断分开写。

## 一、目标

三项改动，用户已明确：

1. **`minSdkVersion` 提到 23**（技术下限，实测见第三节）。
2. **弃用旧设置页**：用户在任何 Android 版本上、任何入口进去，**只会有新设置页**。
3. 旧设置页的**代码与资源不删除**，只是不再使用。

范围已确认包含：

- **首次引导一并 Compose 化**（当前是旧 Activity 重绘成 MD3 风格）。
- **自定义主题一并 Compose 化**（不拆阶段，实测已证明可行，见 5.2）。
- 主题选择页参考 Gboard 的形态。

### 1.1 「弃用」的具体含义

「让旧设置页不可达」有两种做法：

| 做法 | 说明 |
| --- | --- |
| 摘掉入口 | 从 `AndroidManifest.xml` 删掉旧活动的声明，系统无法启动它 |
| 保留入口但不路由 | 声明留着，点进去立刻跳转新页 |

用户要求「全程只有新页」，两种都能达到。**采用做法一（摘掉入口）**，更彻底，
旧页不再有任何可达路径。

**唯一例外**：IME 的 `settingsActivity` 声明必须仍指向一个可用活动，
否则系统设置里的齿轮会失效。处理方式是**删掉旧活动的对外声明，
把 `settingsActivity` 改指新活动**（详见 4.3 第 10 条）。

## 二、现状核实

### 2.1 版本与分流

| 项 | 值 | 来源 |
| --- | --- | --- |
| `minSdkVersion` | 17 | `scripts/apply_patches.py` 的 apktool.yml `sdkInfo` |
| `targetSdkVersion` | 36 | 同上，与 `version.properties` 一致 |
| Compose 库 minSdk | 23 | `scripts/prepare_compose_host_manifest.py` 注释 |

分流门禁**已启用**（`docs/modern-settings-preference-inventory.md` 的「Formal routing gate」）：

```text
API 17-34   旧 Preference 实现
API 35+     ModernSettingsActivity（按类名字符串路由）
```

Compose host 的 `AndroidManifest.xml` 里 `minSdkVersion` 与 `targetSdkVersion` 都被**移除**
（AGP 9 要求写在 Gradle DSL），只留 `overrideLibrary` 例外清单，
用来放行 Compose 库的 minSdk 23 高于应用 minSdk 17 这件事。

### 2.2 现代设置页的规模与覆盖

`modern-settings/compose-runtime/.../compose/` 下 **31 个 Kotlin 文件**，已确认的信息架构：

```text
首页
├─ 输入（通用 / 中文 / 英文，模糊拼音在中文下）
├─ 键盘（外观与布局 / 按键与切换 / 按键反馈 / 手写）
├─ 词典与备份
└─ 其他
```

### 2.3 仍依赖旧实现的入口

这些是「弃用旧设置页」真正要处理的清单，逐条来自偏好清单与导航文件：

| 入口 | 现状 | 来源 |
| --- | --- | --- |
| 主题选择 | 复用未导出的同包 `ThemeSelectorActivity`，三个槽共用 | `LegacySettingsNavigation.kt:12` |
| 词典破坏性操作 | 联系人建议、清空词典仍在旧 fragment | 偏好清单「Specialized pages」 |
| 快捷方式词典编辑器 | 走系统 `android.settings.USER_DICTIONARY_SETTINGS` | 同上 |
| 许可证页 | 旧 `UnquantumLicenseMenuActivity` | `LegacySettingsNavigation.kt:28` |
| 首次引导 | 旧 `PinyinFirstRunActivity`，但已重绘为 MD3 风格 | 原版 manifest + `apply_patches.py` |
| TV 设置 | 旧 `TVSettingsActivity` | 原版 manifest |

### 2.4 主题选择页现状（用户点名的部分）

来自 `docs/gboard-system-auto-theme-research.md` 的「原版主题选择器与自定义主题生命周期」：

- 浅色、深色、固定三个槽**复用同一个未导出的 `ThemeSelectorActivity`**。
- 进入前临时物化目标槽，返回时提交该槽，所以选一个槽不会覆盖另外两个。
- **不复制**主题列表、图片裁剪、编辑器或预览逻辑。
- 内置主题 **17 套**（`builtin_theme_package_name_to_theme_name_map` 共 34 条，两两一对）。
- 自定义主题被编辑或删除时，用原版编辑器已解析出的替代/回退主题对更新所有引用旧文件的槽位。

## 三、关键决策点：minSdk 定在哪一档

用户已明确否决 35，要求提到「新设置页最低可应用的版本」。那就先把这个版本查清楚。

### 3.1 下限由依赖库决定，实测为 API 23

解出各依赖 AAR 的 `AndroidManifest.xml`，逐个看真实声明：

| 依赖 | 声明的 minSdk |
| --- | --- |
| `androidx.compose.ui:ui` | **23** |
| `androidx.compose.runtime:runtime` | **23** |
| `androidx.compose.foundation:foundation` | **23** |
| `androidx.activity:activity-compose:1.13.0` | **23** |
| `androidx.compose.material3:material3` | 21 |

**结论：新设置页的真实下限是 API 23（Android 6.0）。**

Compose 代码本身没有更高的硬需求。全部版本门控只有三处，且都做了降级：

- `ModernSettingsActivity.kt:744-745`：`SDK_INT >= 31` 才用动态配色，否则回落到静态配色方案。
- `SettingsCapabilities.kt:44`：动态配色开关在 31 以下不显示。
- `SettingsCapabilities.kt:43`：表情切换键要求 19 以上。

`enableEdgeToEdge()` 与 `registerForActivityResult()` 都来自 AndroidX，
版本差异由库自己兜住，不需要应用侧判断。

### 3.2 提到 23 的附带收益

`scripts/prepare_compose_host_manifest.py` 里那份长长的 `OVERRIDE_LIBRARIES`
（`androidx.activity`、`androidx.activity.compose`、`androidx.compose.*` 等十余项），
存在的**唯一理由**就是让应用 minSdk 17 与库的 23 共存。
minSdk 提到 23 后，这份例外清单可以整个删掉，少一处脆弱的手工维护点。

### 3.3 但 23 是「能编译」，不是「已验证」

必须说清楚：**Compose 设置页从未在 35 以下运行过**。
现在「API 35+ 才路由」的阈值，反映的是验证范围，不是技术下限。

所以 23 是**技术下限**，不是**已验证下限**。中间这一段（23–34）需要补验证，
验证量随下限降低而增大：

| 候选 | 新增验证面 | 说明 |
| --- | --- | --- |
| **23** | 最大（12 个版本区间） | 技术下限，覆盖 Android 6.0+ |
| 26 | 中等 | 覆盖 Android 8.0+ |
| 31 | 较小 | 全区间都有动态配色，但仍是首次在 35 以下跑 Compose |
| 35 | 零 | 用户已否决 |

**建议 23**：既然要降到技术下限，就一次降到位，避免以后再降一次、
把验证面重做一遍。代价是验证工作量大，且**必须有 23–34 的真机或模拟器**。

### 3.4 无设备条件下的验证策略（已确认）

用户已确认找不到 23–34 的设备，接受以**门禁、模拟器、用户反馈**三者结合替代真机验收。

这意味着验收强度必须如实标注，不能写成「真机验收通过」。可行的组合：

| 手段 | 能覆盖 | 不能覆盖 |
| --- | --- | --- |
| 静态门禁 | 旧路径不可达、资源与清单一致性、minSdk 与库下限匹配 | 任何运行时行为 |
| 模拟器（API 23–34） | Compose 运行时、MD3 组件、Insets、Back 导航、布局 | 真实 IME 窗口交互、厂商 ROM 差异 |
| 用户反馈 | 真机上的实际问题 | 不可控，只能事后修 |

**必须在文档与发布说明里写清楚**：23–34 区间是模拟器加静态门禁的结论，
不是真机验收。这一点不能含糊，否则后续出问题时无法判断当初验到了什么程度。

建议把「优先用模拟器跑通 23、26、29、31、34 五个代表版本」列为阶段 1 的具体动作，
而不是只笼统说「模拟器验证」。

## 四、先期工作清单

按依赖排序，`→` 表示前置。

### 阶段 0：决策（阻塞全部）

1. **定 minSdk 目标值**（见第三节）。
2. **定「弃用」的落地形式**：旧设置类是从 manifest 摘掉入口，还是保留入口但不路由？
3. **定首次引导是否一并 Compose 化**，还是继续用已重绘的旧 Activity。

### 阶段 1：验证面确认（定完 minSdk 立刻做）

4. 确认目标区间有没有可用设备或模拟器。当前只有 Pixel 10 Pro / API 36。
   API 31–34 的 ARM64 模拟器或真机是**硬前置**，否则无法验收。
5. 在目标区间上跑一次 Compose 设置页，记录实际崩溃点。这是风险最高的一步。

### 阶段 2：补齐 Compose 侧缺口

6. **新主题选择页**（见第五节，独立专项）。
7. 词典破坏性操作入口的 Compose 化，或明确保留旧 fragment 并写清理由。
8. 许可证页的 Compose 化。
9. 首次引导（若阶段 0 决定一并做）。

### 阶段 3：弃用旧页的工程落地

10. **IME 的 `settingsActivity` 入口必须仍然可用**。系统的「输入法设置」齿轮走这个声明，
    现在指向旧 `SettingsActivity`：

    ```xml
    <!-- patches/res/xml/method.xml -->
    <input-method android:settingsActivity=
        "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity" />
    ```

    弃用旧页后，它要么保留为薄壳跳转，要么改指新活动。
    这一条**最容易漏**，漏了会导致系统设置里的入口点不进去。
    注意 `patches/res/xml/` 与 `patches/res/xml-v19/` 两份都要改，只改一份会漏掉一个版本区间。
11. 旧 Preference XML 与 smali 保留不动，但不再有可达路径。
12. 静态门禁确认旧路径不可达，并更新所有绑定 minSdk 17 与分流逻辑的断言。

### 阶段 4：文档与门禁

13. 更新 `docs/modern-settings-runtime-design.md` 的迁移边界。
14. 更新 `docs/modern-settings-preference-inventory.md` 的「Formal routing gate」。
15. 更新 `AGENTS.md` 的项目基线条目（当前写的是 `minSdkVersion=17`）。
16. 新增门禁：确认旧路径不可达、确认新路径在目标区间可路由。

## 五、主题选择页专项

### 5.1 新页需要覆盖的能力

从现有实现反推，新页至少要覆盖：

1. **17 套内置主题的列表与预览**。
2. **三个槽的语义**：浅色、深色、固定，各自独立持久化。
3. **动态配色槽**（本版本新增，与上面三个并列）。
4. **与「跟随主题」的互斥置灰**（已有规则在 `ThemeSettingRules.canSelect()`，新页必须复用同一函数）。
5. **自定义主题**：图片选择、裁剪、生成主题包。
6. **主题编辑与删除**，以及删除时对所有引用槽位的回退更新。

### 5.2 自定义主题：实测结论比预想简单

原以为这是最大的未知，因为它可能涉及「从图片提取主色并生成主题包」的算法。
**实测推翻了这一假设：原版根本不从图片提取颜色。**

证据：

1. `Bitmap;->getPixel` 与 `Bitmap;->getPixels` 在整个 smali 里**只出现在 `ant.smali`**，
   而 `ant` 有 `BreakIterator`、`TextPaint`、`Canvas` 字段，是**文本排版**类，与主题无关；
2. `ThemeBuilderActivity`（1186 行，主题包构造者）**不直接调用任何 `Bitmap` 方法**，
   唯一的图片处理是 `a(Bitmap)Lcac;`，而它只是把图片写进
   `TransientFileCleaner` 的**临时缓存文件**并返回字节流；
3. `ThemePackageMetadata` 的字段只有：版本 `int`、一个 `String`、一个 `boolean`、
   `ThemeFlavor[]`、以及样式表文件名 `String[]`。**没有任何颜色字段**；
4. `assets/theme/` 下 75 个文件是 `style_sheet_<名字>.binarypb` 与
   `style_sheet_<名字>_border.binarypb` 成对出现，另有 `style_sheet_default.binarypb`
   及其屏幕宽度变体。

**结论：自定义主题 = 用户图片作背景 + 默认样式表，没有取色与量化算法。**

`StyleSheetConverter` 那条链（`bbm` 是组合器，`bbn` 用 `SparseArray` 做固定颜色映射）
是**给内置主题做颜色替换**用的，不是给自定义主题做图片分析用的。

### 5.3 因此 Compose 化的实际工作量

需要覆盖：

1. 17 套内置主题的列表与预览。
2. 四个槽的语义：浅色、深色、固定、动态配色。
3. 与「跟随主题」的互斥置灰（复用 `ThemeSettingRules.canSelect()`）。
4. 图片选择（SAF）、裁剪、写入主题包目录。
5. 主题编辑与删除，以及删除时对所有引用槽位的回退更新。

其中第 4 项**不需要复现任何颜色算法**，只是「选图、裁剪、按既有目录格式落盘」。
主题包格式已由本项目的 `ThemePackageMetadata` 解析代码掌握。

剩余风险集中在**裁剪交互**与**目录格式的逐字节对齐**，不再是算法不可知的问题。

### 5.4 Gboard 参考

仓库已有 `docs/gboard-system-auto-theme-research.md`，记录了 Gboard 的
「System Auto」表达方式、浅色与深色两套规格、以及自动模式与解析结果是两个层次。
新主题选择页可以参考它的信息组织，但**主题包格式与持久化契约仍以本项目既有实现为准**，
不要按 Gboard 的内部结构去改。

## 六、风险

| 风险 | 说明 |
| --- | --- |
| Compose 在 35 以下未验证 | 选 31 或更低时最大，且需要设备才能验收 |
| 自定义主题需要复现主题包格式 | 独立且不小的工程量，建议拆阶段 |
| 系统「输入法设置」入口失效 | 若漏改 IME 的 `settingsActivity` 声明，用户从系统设置进不去 |
| 门禁大面积失效 | 现有断言深度绑定 minSdk 17 与分流逻辑，需成批更新 |
| 放弃低版本用户 | 提到 35 等于放弃 Android 14 及以下，属于产品决策，需要用户明确确认 |

## 七、建议的推进顺序

1. **定 minSdk**。技术下限实测为 **23**，建议一次降到位，避免以后再降一次、
   把验证面重做一遍。
2. **解决设备**。这是硬前置：23–34 区间没有设备就无法验收，不要先写代码后找设备。
3. 在目标区间上跑一次现有 Compose 设置页，记录真实崩溃点，再决定要不要补兼容分支。
4. 做阶段 2 的补齐，其中主题选择页按 5.2 的建议**先做只读部分**。
5. 做阶段 3 的弃用落地，**重点盯 IME `settingsActivity` 入口**。
6. 顺手删掉 `OVERRIDE_LIBRARIES` 例外清单。
7. 最后统一更新门禁与文档。

## 八、已确认的决策

用户已拍板，不再待议：

| 决策 | 结论 |
| --- | --- |
| `minSdkVersion` | **23**（依赖实测下限） |
| 旧设置页 | **摘掉入口，彻底不可达**，代码与资源保留不删 |
| 覆盖范围 | 所有 Android 版本，任何入口进去只有新设置页 |
| 首次引导 | **一并 Compose 化** |
| 自定义主题 | **一并 Compose 化，不拆阶段**（实测无取色算法，见 5.2） |
| 23–34 验收 | 无设备，以**门禁 + 模拟器 + 用户反馈**替代，验收强度如实标注 |

## 九、下一步

### 9.1 已确认的两项实施前提

| 项 | 结论 |
| --- | --- |
| 模拟器 | 用户授权助手自行寻找合适的模拟器并做自动化测试，不需再确认 |
| 实施顺序 | **先做中间态，再逐步改动**，哪里有问题就修哪里 |

中间态的含义：先完成「minSdk 提到 23 + 摘掉旧入口 + 改指 `settingsActivity`」，
拿到一个可独立验收的版本，再依次补主题选择页与首次引导。

### 9.2 当前优先级已变更

用户反馈 **2.1.4 的动态配色键盘在用户设备上不工作**，且无法取得该设备。
在继续本工程之前，先做一个**带诊断日志与导出功能的 debug 版本**，
用于从用户设备上取回现场信息。设计见
[动态配色诊断日志设计](dynamic-color-diagnostics-design.md)。
