# Material 3 Expressive 设置界面调研

## 状态与结论

本调研记录 API 35+ Compose 设置界面全面升级到 Material 3 Expressive 的可行性、范围和成本。该工作属于低优先级视觉与交互演进，不是输入法核心功能，当前不进入实现阶段。

结论如下：

- 现有 Compose Material 3 设置地基可以继续复用，不需要重写 Preference 业务层。
- 真正的全面升级不能只替换 Theme，还需要改造页面层级、共享设置组件、App Bar、导航动效、特殊状态、无障碍和响应式布局。
- 当前正式依赖尚不提供可直接调用的完整 Expressive 公开 API。可以在隔离分支制作原型，但不应为了提前发布而手绘或复制官方外观。
- 正式实现宜等待所需 API 至少进入 RC，再重新核对依赖、兼容边界和投入优先级。
- 在 API 稳定后，预计需要 18～28 人日，单人日历时间约为 4～6 周。

## 当前设置地基

仓库当前使用：

```text
Compose BOM 2026.06.01
Compose Material 3 1.4.0
API 35+：Compose Material 3 设置
API 17–34：旧 Preference 设置
```

API 35+ 设置源码位于：

```text
modern-settings/compose-runtime/src/main/kotlin/
```

截至本次调研，该目录包含 28 个 Kotlin 文件和约 4,700 行源码。主要界面规模为：

```text
设置路由：约 14 个
SettingsSwitchRow：35 处
SettingsNavigationRow：17 处
DiscreteSettingsSlider：6 处
主要 AlertDialog：4 处
```

共享设置行、Slider 和导航已经集中在 `SettingsComponents.kt`，Preference key、默认值、存储类型、依赖关系和业务回调由独立 Repository 与 contract 层管理。这意味着后续升级可以主要修改呈现层，不应改写已验收的业务语义。

## 官方 API 状态

本次核对了仓库实际解析的 Material 3 `1.4.0` Artifact，以及 Google Maven 提供的 `1.5.0-alpha24` 源码。

Material 3 `1.4.0` 已包含 Expressive motion、shape 和新版组件的部分内部实现，但 `MaterialExpressiveTheme` 在 Kotlin 源码中仍是 `internal`，项目不能把它作为正式公开 API 调用。

Material 3 `1.5.0-alpha24` 已公开以下相关能力：

- `MaterialExpressiveTheme`
- `MotionScheme.expressive()`
- `ButtonGroup`
- `MediumFlexibleTopAppBar`
- `LargeFlexibleTopAppBar`
- 其他 Expressive 组件和 motion token

部分新组件仍使用 `ExperimentalMaterial3ExpressiveApi`。Alpha 期间还可能发生 API、默认 token、行为和二进制体积变化，因此不适合直接成为本项目的长期正式基线。

官方资料：

- [Compose Material 3 Release Notes](https://developer.android.com/jetpack/androidx/releases/compose-material3)
- [Material 3 in Compose](https://developer.android.com/develop/ui/compose/designsystems/material3)
- [Google Maven Repository](https://maven.google.com/web/index.html#androidx.compose.material3:material3)

## 「全面升级」的范围

本调研中的全面升级只包括 API 35+ 设置界面，不包括首次引导，也不改变 API 17–34 旧设置。

需要覆盖的呈现范围包括：

1. Expressive Theme、motion scheme、shape、typography 和动态颜色
2. 设置首页的信息层级、容器和分组
3. Switch、导航、操作和枚举设置行
4. Slider、恢复默认和直接预览交互
5. App Bar、滚动行为和前进、返回动效
6. 词典健康、备份、导入、清除确认和进行中状态
7. 模糊拼音、手写、主题和关于页面
8. 浅色、深色、动态颜色、字体缩放和高对比度
9. TalkBack、RTL、横屏、窄屏、分屏和必要的多窗口场景
10. API 17–34 隔离、6,633 个旧资源 ID、DEX、签名和完整 APK 门禁

以下内容不属于本阶段：

- 修改 Preference key、默认值或存储类型
- 修改输入、Candidate、学习、词典、手写或主题业务语义
- 把 API 17–34 旧设置迁移到 Compose
- 把首次引导混入同一实现分支
- 手绘、仿制或复制尚未公开的 Expressive 组件
- 为第三方动态主题或插件预留接口

## 为什么不能只替换 Theme

现有设置已经使用动态颜色和官方 Material 3 组件，但部分关键交互仍由项目明确控制。例如页面导航采用固定的淡入、淡出和横向移动时长，共享设置行主要由 `Row`、`ListItem`、`clickable` 和 `toggleable` 组成。

只把顶层 `MaterialTheme` 替换为 `MaterialExpressiveTheme`，可以获得部分默认 motion 和 token 更新，但不会自动完成：

- 设置分组和容器层级
- Expressive 列表行的 shape 与按压反馈
- App Bar 的滚动与展开行为
- 项目自定义页面切换动效
- 特殊词典状态与对话框的信息层级
- 宽屏、横屏和多窗口布局调整

这种实现最多只能称为接入 Expressive Theme，不能称为全面升级。

## 工作量估算

在所需 API 稳定后，正式可发布实现预计为 18～28 人日：

| 阶段 | 内容 | 估算 |
| --- | --- | ---: |
| 技术原型 | 依赖升级、Expressive Theme、APK 组装和旧路径隔离 | 2～3 人日 |
| 设计地基 | motion、shape、间距、宽度、容器和分组规则 | 2～3 人日 |
| 共享组件 | Switch、导航、操作、枚举、Section 和 Slider | 3～5 人日 |
| 页面结构 | 首页、输入、键盘、手写、其他和关于 | 3～4 人日 |
| 特殊页面 | 词典状态、导入、清除确认和模糊拼音 | 3～5 人日 |
| 导航与适配 | App Bar、页面动效、横屏、窄屏、RTL 和多窗口 | 2～4 人日 |
| 无障碍与验收 | TalkBack、字体缩放、完整构建、真机和回归 | 3～4 人日 |

部分工作可以交叉进行，因此实际项目预算取 18～28 人日，建议另留约 20% 的风险空间。

如果在 Alpha 阶段直接完成全部实现，还要承担后续 API 迁移和重新验收，预计会增加到 24～38 人日。该额外成本与当前功能优先级不匹配。

如果把首次引导一并迁移，需要另增加约 5～8 人日，并建立独立分支与验收阶段。

## 建议的恢复条件

只有同时满足以下条件时，才重新评估实现：

1. 输入法核心兼容问题和已知缺陷没有更高优先级
2. 所需 Material 3 Expressive API 至少进入 RC
3. 仍能保持 API 35+ Compose 与 API 17–34 Preference 的现有隔离
4. 有 4～6 周连续开发和验收窗口
5. 维护者愿意承担完整视觉、动效和无障碍验收

## 建议的实施顺序

恢复工作后，先在独立原型分支投入 2～3 人日，只覆盖设置首页和「按键反馈」页面。这两个页面可以同时验证导航、设置行、Switch、Slider、按钮、动态颜色和 Expressive motion。

原型通过以下条件后再进入全面实现：

```text
官方公开 API 可编译
→ 固定原始 APK 可完整重建
→ 6,633 个旧资源 ID 保持
→ API 17–34 不解析新路径
→ Preference 契约和回调不变
→ 深浅色、字体缩放和 TalkBack 基础体验成立
→ 视觉收益足以覆盖完整迁移成本
```

正式扩展顺序建议为：

```text
Theme 与 motion
→ 共享设置组件
→ 首页与 App Bar
→ 普通设置页面
→ Slider 与枚举对话框
→ 词典特殊状态
→ 响应式布局与无障碍
→ 完整构建和真机验收
```

## 当前决定

Material 3 Expressive 设置升级暂缓，不新增实现代码、不升级依赖、不增加设置入口，也不改变现有 Compose Material 3 设置。本文只保留事实、成本和恢复条件，供后续有空闲余力时重新评估。
