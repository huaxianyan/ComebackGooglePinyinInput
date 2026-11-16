# 动态配色主题：定向验证报告

> 日期：2026-09-30
> 需求方向：**最终目标 A（真动态配色），但按系统能力降级** —— 只有符合要求的 Android 版本才启用动态主题，其余版本回退普通主题
> 承接：[动态配色主题可行性调研](./dynamic-color-theme-research.md)

> **⚠️ 真机实测后的修订（2026-09-30，见 [实测①](./dynamic-color-device-test-1.md)）**
>
> 本报告 1.2 节的「资源 id 跨版本稳定、可硬编码」结论**已被真机实测推翻**：
> android.jar 里的 id 是**编译期符号表**，真机 framework 资源 id 是**运行时分配**，
> 两者不等同（真机 accent1 起于 `0x010603ba`，非 `0x01060037`）。
> **正确做法：按资源名取色** `getIdentifier(name, "color", "android")` + `getColor(id, theme)`。
>
> 连带影响：**第四节的「直接取系统色做映射表」结论被强化**（实测①证明能按名取到
> 全部语义色），而「移植 Material Color Utilities」**确认不需要**——系统已算好语义色。

## 结论摘要

| 验证项 | 结论 | 证据强度 |
| --- | --- | --- |
| 系统动态色可获取 | ✅ **可行**，须**按资源名**取（id 不可硬编码） | 真机实测① |
| 降级判据 | ✅ **清晰**，`API >= 31` 单一条件 | 权威文档 |
| 主题包可运行期构造 | ✅ **可行**，接口完整且公开 | 反编译 |
| `files:` 主题加载通路 | ✅ **闭环确认**，格式完全对齐 | 反编译 |
| 颜色推导算法 | ✅ **不需要移植**，直接用系统语义色做映射表 | 真机实测① |

**难度定级：由「高」下调。** 颜色推导算法这一最大工作量项被实测①移除
（系统语义色现成可用），剩余工作集中在「系统色 → 键盘色槽」的映射表。
全部工作仍在原版既有机制内部，不碰布局、不碰状态位、不碰跨 APK 资源。

---

## 一、系统动态色：可用且 id 稳定（实测）

### 1.1 资源清单与命名规律

AOSP 定义 **5 种调色板 × 13 个色阶 = 65 个资源**：

| 调色板 | 用途 |
| --- | --- |
| `system_accent1_*` | 主色（Primary） |
| `system_accent2_*` | 辅色（Secondary） |
| `system_accent3_*` | 第三色（Tertiary） |
| `system_neutral1_*` | 中性色（Surface 基础） |
| `system_neutral2_*` | 中性变体（SurfaceVariant） |

色阶索引：`0, 10, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000`

### 1.2 关键实测：资源 id 是 framework id 且跨版本稳定

用 `javac -bootclasspath android.jar` 编译引用并反编译验证：

```
system_accent1_0    = 17170487 = 0x01060037
system_neutral1_200 = 17170465 = 0x01060021
```

**三点重要含义**：

1. **`0x01` 前缀 = framework 资源包**（对比本 APK 是 `0x7f`）。这说明它属于 Android 平台资源表，**不会随本 APK 资源表重排而失效**——这是一个巨大的优势。
2. **编译期被内联成字面量整数**。所以可以**直接硬编码数字，不依赖 `R` 类**，也不需要 `getIdentifier` 反射。
3. **跨版本完全稳定**（实测）：

   | android.jar 版本 | accent1_0 | accent3_1000 | 资源总数 |
   | --- | --- | --- | --- |
   | android-35 | `17170487` | `17170525` | 65 |
   | android-36 | `17170487` | `17170525` | 65 |
   | android-37.2 | `17170487` | `17170525` | 65 |

   **三个版本数值完全一致。**

### 1.3 降级判据（用户要求的方向）

```
API >= 31 (Android 12) → 动态配色可用
API <  31              → 回退到普通固定主题
```

判据单一、清晰。项目已有成熟的版本分支惯例（`sget v0, Landroid/os/Build$VERSION;->SDK_INT:I`，见 `patches/smali/EdgeToEdgeCompat.smali:45` 等多处）。

**AOSP 官方回退色**：当壁纸取色失败时，系统使用 `0xFF1B6EF3` 作为默认种子色。可作为我们自己的兜底值。

### 1.4 读取方式（待验证的细节）

虽然 id 可硬编码，但**运行期读取**需要确认：

```java
// 候选方式（需实测）
getResources().getColor(id, getTheme())   // API 23+
ContextCompat.getColor(ctx, id)           // 但 ContextCompat 来自 AndroidX
```

**注意**：项目要求 **primary-DEX、AndroidX-free**（见 `SystemAutoThemeCompat` 的设计约束），所以 **AndroidX 的 `ContextCompat` 不可用**。只能用平台 API：

- API 23+ 用 `getResources().getColor(int, Theme)`
- 或用 `getResources().getColorStateList(int, Theme)`
- 或反射调用（不必要）

**这是一个待实测风险点**（见第六节）。

---

## 二、主题包运行期构造：接口完整且公开

### 2.1 写入器 `baj` 接口（反编译确认）

```
.field public a:LStyleSheetProto$StyleSheet;   ← 公开可变，样式表
.field public a:Ljava/lang/String;             ← 公开，元数据
.field private a:Ljava/util/Map;               ← 额外条目（图片等）

.method public constructor <init>()V            ← 公开无参构造器
.method public final a(Ljava/lang/String;[B)Lbaj;   ← 加条目
.method public final a(Ljava/io/File;)Z             ← 落盘
```

**内部写入的 zip 条目**（已确认）：

| 条目名 | 来源 |
| --- | --- |
| `metadata.binarypb` | 字段 `a:String`（元数据序列化） |
| `style_sheet.binarypb` | 字段 `a:StyleSheet`（经 `cim.a([B)` 序列化） |
| Map 内的其他条目 | 图片等附加资源 |

### 2.2 样式表数据结构（可运行期构造）

| 类 | 关键字段 |
| --- | --- |
| `StyleSheetProto$StyleSheet` | `a:[StyleRule]` |
| `StyleSheetProto$StyleRule` | `a:I`(选择器)、`a:StylePropertyValue`、`a:String`(属性名) |
| `StyleSheetProto$StylePropertyValue` | **`a:I` = ARGB 颜色**、`a:[I`、`a:D`、`a:F`、`a:String` |

**全部是 public 字段，可直接赋值。** 颜色以 ARGB 整数存储。

### 2.3 加载通路闭环确认

```
pref_key_keyboard_theme = "files:xxx.zip"
  → gc.a(Context, String)       判断 "files:" 前缀          [gc.smali:6844]
  → new File(context.getFilesDir(), name)                    [gc.smali:6862-6867]
  → bbl.a(File)                                              [gc.smali:6869]
  → ZipFile 读 "metadata.binarypb"                           [bbl.smali:330]
    或 "metadata.json"                                       [bbl.smali:363]
  → ThemePackageMetadata.a([B)  反序列化
  → getStyleSheet(...) 读 "style_sheet.binarypb"
```

**关键点**：
- `files:` 主题就是 **`getFilesDir()` 下的一个普通 zip 文件**，路径最简单不过。
- **写入条目名（`baj`）与读取条目名（`bbl`）完全一致**，闭环成立。
- 原版用户自定义主题保存命名规则：`user_theme_%015d_%02d.zip`（时间戳 + 序号），保留 100 个槽位循环（`gc.b(Context)` 里循环 `0x64` 次找空位）。
- 保存调用链：`gc.b(Context)` 取文件 → `bai.a(File)` 安装（`ThemeBuilderActivity.smali:878`）。

### 2.4 可直接复用的原版能力

`bai`（主题安装器）有 `constructor <init>(Lcac;)` 和 `a(File)Z`，原版用于把用户自定义主题落盘并注册。**我们的动态主题可以直接走同一条路。**

---

## 三、架构建议：动态槽 + 版本门控

在现有 `SystemAutoThemeCompat` 三槽模型上扩展：

```
onCreate / onConfigurationChanged
  │
  ├─ API < 31 → 完全走现有三槽逻辑（不变）
  │
  └─ API >= 31 → 若用户启用「动态配色」
       ① 读系统 65 个色（硬编码 id，getResources 取）
       ② 颜色推导 → 生成浅色/深色两套 StyleSheet
       ③ 用 baj 构造主题包 → 写入 getFilesDir()
       ④ 物化为活动主题（复用现有 writeSlot + applyConfiguredTheme）
       ⑤ 系统主题色变化时重跑 ①-④
```

**优势**：
- 复用现有全部基础设施（槽位持久化、InputView 重建、选择器桥接）
- 版本门控天然隔离，低版本零改动、零风险
- 不新增状态位、不碰布局

**新增槽位建议**：`SLOT_DYNAMIC`，与 `light`/`dark`/`fixed` 并列。

---

## 四、主要工作量：颜色推导算法

这是**唯一的大块工作**。

| 方案 | 工作量 | 效果 |
| --- | --- | --- |
| 移植 Material Color Utilities（`Hct`/`Cam16`/`Quantizer`/`Scheme`） | 大（数千行） | 最接近 Gboard |
| 简化推导（从 seed 色按 HSL 算几档亮度） | 中 | 尚可，但不如原版精致 |
| 直接取系统 65 色，**不做推导** | **小** | **可能就是够用的** |

**第四种方案值得重点评估**：系统已经算好了 65 个色（`accent1_0` 到 `accent3_1000`、`neutral1/2`），键盘配色不需要自己从 seed 推导——**直接把这 65 个色映射到键盘的各个视觉槽位即可**。

这可能是最务实的路径：**不移植算法，只做「系统色 → 键盘色槽」的映射表。**

---

## 五、风险清单

| 风险 | 等级 | 应对 |
| --- | --- | --- |
| 主题包损坏致键盘不可用 | 高 | 写入前校验 + 失败回退固定主题 |
| 白屏（本项目已发生一次） | 高 | 主题包写完后立即验证可加载，不通过则回退 |
| 运行期读取系统色的 API 不可用 | 中 | **需实测**（见第六节） |
| 颜色映射效果不佳 | 中 | 先做静态预览，用户确认再固化 |
| 系统主题色变化时刷新时机 | 中 | 复用 `onConfigurationChanged` 机制 |
| 厂商 ROM 动态色差异 | 低 | 系统资源由 ROM 提供，不一致属预期 |

---

## 六、待实测的关键项（下一步）

地基逻辑已通过反编译确认，但**有三项必须真机实测**：

### 实测 1：运行期读取系统动态色

在 API 31+ 设备上验证：

```java
Resources r = context.getResources();
int c = r.getColor(0x01060037, context.getTheme());  // system_accent1_0
```

- ✅ 能取到合理颜色 → 通路打通
- ❌ 抛异常或返回错误值 → 需改用其他 API（`getColorStateList`、`getValue`）

**在 API < 31 设备上必须确认不崩溃**（这正是降级策略要覆盖的）。

### 实测 2：代码造的主题包能否被加载渲染

1. 硬编码几个 ARGB 值构造 `StyleSheet`
2. 用 `baj` 写入 `getFilesDir()/probe_theme.zip`
3. 把 `pref_key_keyboard_theme` 指过去
4. 看键盘是否渲染出该颜色

**这是整件事的地基。不需要任何颜色算法。**

### 实测 3：最小可行样式表

要确定「键盘渲染需要 `StyleSheet` 里有哪些属性」。可以从现有主题包解出一个完整 `StyleSheet` 作模板，只改颜色字段。

> 建议做法：**提取原版 Material Light/Dark 主题包的 `style_sheet.binarypb` 作为模板**，运行期只替换其中的颜色值。这样不需要理解全部属性语义。

---

## 七、与已实现功能的关系

| 现有能力 | 动态配色如何复用 |
| --- | --- |
| `SystemAutoThemeCompat` 三槽模型 | 加第四槽 `SLOT_DYNAMIC` |
| `applyConfiguredTheme` / `writeSlot` | 直接复用 |
| `onConfigurationChanged` 生命周期 | 直接复用 |
| 原版主题选择器桥接 | 动态主题不该进选择器（或只读） |
| `bai` 主题安装器 | 写盘后调用 |
| 自定义主题编辑/删除修复逻辑 | 需扩展以覆盖动态槽 |

---

## 八、参考

- 前置调研：[动态配色主题可行性调研](./dynamic-color-theme-research.md)
- 现有实现：[Gboard System Auto 主题研究](./gboard-system-auto-theme-research.md)
- AOSP 官方：[动态配色](https://source.android.google.cn/docs/core/display/dynamic-color)
- 反编译证据：`work/decoded/smali/` 下 `baj.smali`、`bbl.smali`、`bai.smali`、`gc.smali`、`ThemeBuilderActivity.smali`
- 实测环境：`android.jar` (API 35/36/37.2)，`javac` (OpenJDK 11.0.2)
