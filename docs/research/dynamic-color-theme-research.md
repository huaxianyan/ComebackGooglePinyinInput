# 动态配色主题（Gboard Dynamic Color / Material You）：可行性调研

> 日期：2026-09-30
> 需求来源：用户希望拥有 Gboard 那样的**动态配色**主题（键盘配色随系统主题色 / 壁纸变化）
> 结论：**部分可做，难度高（需运行期生成主题包）。不是补丁级，属新子系统。**

## 一、先厘清：这不是「跟随深浅色」

项目**已经实现**「跟随系统深浅色」——见 [Gboard System Auto 主题研究](./gboard-system-auto-theme-research.md)。那套模型是**三槽位切换**：

```
followThemeEnabled + lightThemeSpec + darkThemeSpec + fixedThemeSpec
```

系统只决定「用浅色槽还是深色槽」，槽里存的是**用户预先选好的固定主题**。

**动态配色是另一回事**：主题的**颜色值本身**由系统或壁纸**实时计算**得出，用户没有「选一套主题」，而是主题跟着系统色走。两者不可混为一谈。

## 二、关键事实：原版完全没有动态配色能力

在 `work/decoded/smali/` 全量检索，**Dynamic Color / Material You / Monet / Hct / CorePalette / system_accent 全部零命中**。唯一命中的 `DynamicLm` 是「动态语言模型」，与配色无关。

资源层同样：`system_accent1_*` / `system_neutral*` 等 Android 12+ 系统动态色资源**零引用**。

**原因**：Google 拼音 4.5.2 是 2018 年前后的产物（Material Design 1/2 时代），动态配色（Material You）是 Android 12 才提出的概念。

## 三、颜色是怎么存的：固定 ARGB 整数

主题的完整数据模型（nano protobuf）：

| 类 | 路径 | 内容 |
| --- | --- | --- |
| `StyleSheetProto$StyleSheet` | `.../theme/proto/nano/` | 样式表根，含 `StyleRule[]` |
| `StyleSheetProto$StyleRule` | 同上 | `a:I`(选择器) + `a:StylePropertyValue` + 属性名 |
| `StyleSheetProto$StylePropertyValue` | 同上 | **`a:I` = 颜色（ARGB 整数）**、`a:[I`、`a:D`、`a:F`、`a:String` |
| `ThemePackageProto$ThemePackageMetadata` | 同上 | 版本、名称、flavor 列表 |

**加载链**：

```
主题字符串（assets: / files: / system:）
  → gc.a(Context, String)          解析前缀
  → bal / bbl / bck                三种包加载器
  → ThemePackage.getStyleSheet()   读 style_sheet.binarypb
  → bax / baw → StylePropertyFactory.create(SparseArray)
  → StyleProperty.apply(View)
  → bau                            a:I 经 Color.alpha() 转 ColorStateList
```

**关键点**：颜色是序列化在 proto 里的**固定 ARGB 整数**，加载期转成 `ColorStateList`。**没有运行期计算环节，也没有取色器。**

## 四、但有两个现成的有利条件

### 条件 1：主题包可以在运行期构造

`baj`（主题包写入器）结构：

```
.method public constructor <init>()V          ← 公开构造器
.method public final a(Ljava/lang/String;[B)Lbaj;   ← 写条目
.method public final a(Ljava/io/File;)Z             ← 落盘
```

`baj.a:StyleSheetProto$StyleSheet` 是**公开可变字段**。且写入时通过 `cim.a([B)` 序列化 proto。

**含义**：可以纯代码构造一个主题包，写进 `files:` 主题目录，再用正常的 `pref_key_keyboard_theme` 加载。**不需要改任何资源，不需要新增资源 id。**

### 条件 2：`files:` 主题是原版就支持的路径

`gc.a()` 支持三种前缀，其中 `files:` 走 `bbl`（读 zip 内 `metadata.binarypb`）。而且原版**用户自定义主题**走的就是这条路——`ThemeBuilderActivity` 用 `GET_CONTENT` + `image/*` 读用户图片，生成主题包后以 `files:` 形式加载。

**含义**：这是一条**已被原版验证、用户可见、可编辑可删除**的通路。

## 五、主要障碍

### 障碍 1：拿不到系统动态色（最硬）

Android 12+ 的系统动态色通过 `android.R.color.system_accent1_0` 这类资源暴露，但：

- 原版 APK 的资源表里**没有这些引用**，`getResources().getColor(android.R.color.system_accent1_0)` 需要平台资源 id，**在 API 17 的 minSdk 下不安全**（这些资源 API 31+ 才有）。
- 项目 `minSdk 17`、`targetSdk 36`，编译期无法静态引用，只能运行期按版本号取——**可行但要写版本分支**。

### 障碍 2：Monet / Hct 算法没有现成实现

Gboard 的动态配色用 Material Color Utilities（`Hct`、`CorePalette`、`Scheme`）从种子色推导出整套配色。**原版没有这个库**。

选项：
- 移植 Material Color Utilities（Java 版，约数千行，含 `Cam16`/`Hct`/`Quantizer`）→ **工作量大**
- 简化：只取系统 seed 色，按 HSL 手动推导几个亮度档 → **效果差，不像 Gboard**
- 从壁纸取样 → 需要自己写量化算法（原版 `ThemeBuilderActivity` 只是把图片**存进**主题包当背景，**并不取色**——已核实，无 `Palette`/`RGBToHSV` 调用）

### 障碍 3：主题必须整包重建，不能只改颜色

`StyleProperty.apply(View)` 是在**加载期**把颜色转成 `ColorStateList` 并应用到 View。运行期改颜色意味着：

- 要么**重建整个主题包**再触发重载
- 要么找到 `apply` 之后的 View 逐个改——**这正是本项目白屏事故的同类风险**

### 障碍 4：颜色刷新时机与 View 重建

系统主题色变化（用户换壁纸/改主题）时，IME 需要重新加载主题并重建 InputView。项目已有的 `SystemAutoThemeCompat` 在 `onConfigurationChanged` 里做了类似的事（三个槽位物化 + InputView 重建），**这部分可以复用**。

## 六、可行路径

### 路径 A：动态槽位（推荐，与现有架构同构）

在 `SystemAutoThemeCompat` 三槽模型上**增加一个「动态槽」**：

```
onCreate / onConfigurationChanged
  → 读系统 seed 色（按 SDK 版本分支取 system_accent1_*）
  → 用颜色推导算法生成浅色/深色两套 StyleSheet
  → 用 baj 构造主题包写入 files: 目录
  → 物化为活动主题（复用现有槽位机制）
```

**优点**：复用现有全部基础设施（槽位、重建、选择器桥接）
**难点**：颜色推导算法（障碍 2）

### 路径 B：壁纸取样（效果最接近 Gboard）

读系统壁纸 Bitmap → 量化提取主色 → 推导配色 → 同上。

**难点**：量化算法自研；壁纸读取需要 `READ_MEDIA_IMAGES` 或 `WallpaperManager`（后者可不申请权限）

### 路径 C：混合（务实）

只有**一组固定配色档**（如 6–8 个预设），用户选色相，其余亮度/饱和度自动推导。达不到 Gboard 的「自动跟壁纸」，但视觉上像动态配色。

## 七、工作量与风险

| 项 | 评估 |
| --- | --- |
| 主题包运行期构造 | **可行**，`baj` + proto 类公开可变 |
| `files:` 主题通路 | **已验证**，原版自定义主题走这条路 |
| 颜色推导算法 | **主要工作量**，需移植或自研 Material Color Utilities |
| 系统 seed 色获取 | 中等，需版本分支 |
| 主题重载与 View 重建 | **可复用**现有 `SystemAutoThemeCompat` 机制 |
| 设置界面 | 需在「外观与布局 → 主题背景」加动态主题入口 |
| **风险** | 白屏（本项目已发生一次）、主题包损坏致不可用、算法效果不达预期 |

**难度定级：高。** 比逗号句号开关高一个数量级，比 JSON 布局框架低——因为**不需要碰布局和状态位**，全部工作在主题数据层，且 `baj`/proto 提供了干净的构造接口。

## 八、最小验证建议（强烈建议先做）

在投入完整方案前，**先做一次「运行期构造主题包」的静态验证**：

1. 用硬编码的几个 ARGB 值，通过 `baj` 构造一个主题包，写入 `files:` 目录
2. 把 `pref_key_keyboard_theme` 指过去，确认**键盘能渲染出这个颜色**
3. 成功 → 通路打通，后续只是「颜色从哪来」的问题
4. 失败 → 及早止损

**这一步不需要任何颜色算法，只需验证「代码造的主题包能不能被加载」。** 它是整件事的地基。

## 九、不确定之处

- `ThemePackageMetadata.a:I` 各取值语义（`baj` 固定写 3）属推测
- `StylePropertyValue.a:D`（double 字段）用途未确认
- 未验证运行期重建主题包后，已存在的 View 是否需要强制重建才能刷新颜色
- 未验证 `files:` 主题在 IME 进程重启后能否正常恢复（原版自定义主题可以，但那是用户手动创建的路径）
- 未确认系统 seed 色在不同厂商 ROM 上的一致性

## 十、与原版边界的关系

本调研**不涉及**：

- 布局层（不碰 `keyboard_*.xml`、不新增状态位）
- 映射层（不动 keymapping）
- 跨 APK 资源（不需要独立 APK）

**这是一条相对干净的路径**——全部工作在原版已有的「主题包 + files: 加载」机制内部，属于**复用而非突破**。

## 十一、参考

- 项目已有：[Gboard System Auto 主题研究](./gboard-system-auto-theme-research.md)（三槽位模型，已实现并真机验收）
- 公开资料：Material Color Utilities（`Hct`、`CorePalette`、`Scheme`）、Android 12+ `system_accent1_*` 系统色
- 反编译证据：`work/decoded/smali/` 下 `baj.smali`、`gc.smali`、`bau.smali`、`bck.smali`、`ThemeBuilderActivity.smali`、`theme/proto/nano/*`
