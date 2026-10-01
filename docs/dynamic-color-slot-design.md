# 动态配色第四槽：接入方案

> 日期：2026-09-30
> 状态：**全部决定已确认，方案定为丙（直接读 `assets/theme/`），已开分支进入实施**
> 唯一开放项：O-2 开关标题用词（属文案层，不阻塞实施，见 10.4）
> 前置：[实测②③（主题包构造与加载）](./dynamic-color-device-test-2.md)、
> [实测①（系统动态色读取）](./dynamic-color-device-test-1.md)、
> [定向验证报告](./dynamic-color-theme-verification.md)

## 〇、决定已全部确认（三项结构决定 + 三项设置交互）

| # | 问题 | 决定 |
| --- | --- | --- |
| 1 | 设置入口 | **要做**——在设置页加「动态配色」开关 |
| 2 | 模板存放方式 | **方案丙：运行期直接读 `assets/theme/`**<br>（零资源表改动、零构建改动） |
| 3 | ③ 主题色变更刷新 | **不做**——键盘弹出/收回足够频繁；另加 ③' 键盘弹出触发点 |
| 4 | 开关位置 | **「主题背景」页第一项，位于「跟随主题」上方** |
| 5 | 与其它主题模式的关系 | **单向压制**：动态配色开启 → 「跟随主题」开关置灰失效，浅色/深色/固定三个槽入口全部置灰失效 |
| 6 | 旧设置页（API 17–34） | **不做。只做新设置页（Compose）** |

> **第 2 点的确认依据（用户原话）**：
> "选丙，无需担心上游问题，因为**上游已经不维护了，我们就是上游**。"
>
> 这一句消除了方案丙唯一的顾虑（模板文件可能被上游改动）。
> **由此确立一条项目级长期约束**：本项目即事实上的上游，
> `assets/theme/` 下的 75 个模板文件由我们自己维护，
> 因此**运行期直接读取它们是稳定可靠的做法**，无需额外的复制或内嵌。

> **第 3 点的补充说明**：用户指出键盘弹出/收回很频繁，足够覆盖刷新需求。
> 这一点在实现上有额外价值——在 `applyOnCreate` 之外，
> **新增键盘弹出时的轻量签名检查**（见 3.5 节的触发点 ③'）。

> **第 4/5/6 点的确认依据（用户原话）**：
> 「放在跟随系统上面，并且开启后跟随系统开关变成灰色不可操作，意味着失效，
> 固定主题入口也失效无法选择。另外旧设置页面也要有对应的设置入口。」
>
> 这三句把设置交互完全定死。落地方案见 **5.3.2**（置灰规则与写入序列）。

> **第 6 点已撤销**（用户本轮决定）：
> 「算了，既然旧设置页没有就刚好不做了，只做新设置页，
> 因为后续我打算提升 API 版本来弃用旧设置页、全面接入新设置页了，
> 不过这个是这个做完后的需求。」
>
> **决定**：本轮**不碰旧设置页**，只改 `modern-settings/`（Compose）。
> 原 5.3.4（旧页面入口方案）**整体转为备查、不实施**。
> 依据有两条，且互相印证：
> 1. 旧页面根本没有「跟随主题」开关，"让跟随主题置灰"在旧页面上无处落地；
> 2. 用户后续计划提升 `minSdk` 弃用旧页面，此时投入旧页面属于**废工**。
>
> 这条也确立了本方案与后续需求的分工：
> **"提 API + 弃用旧设置页"是一条独立需求，在本方案完成后另做。**

## 一、目标与范围

把已验证通过的手工链路（系统动态色 → 样式表 → 主题包 → `additional_keyboard_theme` → 渲染）
接入产品，成为**用户可开关、自动运行**的第四槽。

| 项 | 内容 |
| --- | --- |
| 新增槽位 | `SLOT_DYNAMIC`（与 `light` / `dark` / `fixed` 并列） |
| 能力门控 | `SDK_INT >= 31`（Android 12），低版本完全不走新逻辑 |
| 触发时机 | ① 键盘进程启动时；② 系统深浅色切换时 |
| 实现方式 | Java 源码 + 编译注入（复用项目既有流程） |
| 影响范围 | 只加文件、只加分支、只在开关打开时改 `additional_keyboard_theme` |

**不做的事**：不移植 Material Color Utilities（实测①已证明系统语义色现成可用）；
不新增构建步骤；不动 `keyboard_theme`；不引入 AndroidX。

---

## 二、生效链路的最终确认（本次代码走查结论）

### 2.1 `baq.a(Context)` 的真实分支

读 `baq.smali:30-160`，逻辑如下（与实测②一致，此处补上完整分支）：

```text
if (ais.g(ctx)):                                       // 首次运行/特殊态
    return baq("material_dark_theme", "")
v1 = prefs[keyboard_theme]                             // 0x7f110282
v0 = prefs[additional_keyboard_theme]                  // 0x7f11023a
if (!TextUtils.isEmpty(v0)):                           // ★★ 短路分支
    return baq.a(ctx, v0)                              //     base=0x7f110226, additional=v0
if (!TextUtils.isEmpty(v1)):                           // 仅内置短名可达
    ...
    return baq(base, "assets:theme_package_metadata_material_{dark|light}.binarypb")
return baq.b(ctx)                                      // 系统主题目录兜底
```

`baq.a(Context,String)`（`baq.smali:146-156`）：

```java
public static baq a(Context ctx, String additional) {
    return new baq(ctx.getString(0x7f110226), additional);   // base 恒为 material_dark_theme
}
```

**两条硬约束**：

1. `additional_keyboard_theme` 非空 → **`keyboard_theme` 被完全忽略**。
   所以动态槽只需写一个键。
2. base 恒为 `pref_entry_base_keyboard_theme`（`= material_dark_theme`），
   由框架内部补齐，**我们不需要也不应该动它**。

### 2.2 `PinyinIME.a()` 的校验与回退

`PinyinIME.smali:201-238`：

```text
v0 = baq.a(ctx)
v1 = v0.b                                              // additional 值
v1_isEmpty = isEmpty(v1)
if (v1_isEmpty) { ok = true } else { ok = gc.b(ctx, v1) }
if (!ok) { v0 = baq.b(ctx) }                           // 校验失败 → 退回默认
return new bck(ctx, v0, oneHanded)
```

`gc.b(Context,String)` 只认三种前缀（`gc.smali:6843-6880`）：

| 前缀 | 处理 | 实现 |
| --- | --- | --- |
| `assets:` | `AssetManager` 打开 | `Lbal` |
| `files:` | `new File(getFilesDir(), substring(6))` | `Lbbl` |
| `system:` | `new File(systemThemeDir, substring(7))` | `Lbbl` |

其余前缀 → 落到 `:cond_8` 返回 `0` → 校验失败 → 退回默认主题。

### 2.3 `files:` 通路的完整闭环

```text
additional_keyboard_theme = "files:dynamic_theme.zip"
  → gc.b(ctx, str)                   前缀匹配 "files:"
  → substring(6) → "dynamic_theme.zip"
  → new File(ctx.getFilesDir(), "dynamic_theme.zip")
  → bbl.a(File)                      ZipFile.getEntry("metadata.binarypb")
  → ThemePackageMetadata.parseFrom(bytes)
  → bbl.a(File)Z : metadata != null && metadata.field1 <= 3
  → getStyleSheet() → 读 metadata.field2 列的 style_sheet 文件
  → bck 渲染
```

**关键推论**：主题包是 `getFilesDir()` 下的普通 zip，**文件名不受 `user_theme_` 前缀限制**
（该前缀只影响"用户主题列表"的枚举，不影响 `files:` 直接引用）。
我们用 `dynamic_theme.zip` 这种固定名，既避免被选择器列表发现，也便于覆盖更新。

---

## 三、设计

### 3.1 prefs 键设计

在 `SystemAutoThemeCompat` 现有键之外新增：

| 键 | 类型 | 含义 |
| --- | --- | --- |
| `compat_system_dynamic_color_theme` | boolean | 动态配色总开关（默认 **false**） |
| `compat_theme_dynamic_keyboard` | String | 动态槽 base（固定为 `material_dark_theme`） |
| `compat_theme_dynamic_additional` | String | 动态槽 additional（`files:dynamic_theme.zip`） |
| `compat_theme_dynamic_signature` | String | 上次造包时的输入签名，用于跳过重复造包 |

**签名设计**（避免每次启动都重写 zip）：

```text
signature = mode + ":" + <20 个槽位的 ARGB 十六进制，按固定顺序，取不到的留空>
```

> **实施修正（原设计是 6 个代表色）**：原稿写"深浅色 + 6 个代表色"，
> 理由是"5 次 `getColor` 更省"。实施时改为**覆盖全部 20 个槽位**，原因：
>
> - 签名的作用是**避免重新造包**。造包要读 13 个 assets + 改色 + 打 zip + 落盘，
>   才是真正的开销；解析配色只是几十次资源查找，代价可忽略。
> - 只取 6 个代表色会有**漏检**：若某个非代表色（如 `system_outline_variant`）
>   单独变化，签名不变 → 跳过造包 → 键盘仍用旧色。
>
> 结论：**20 个全进签名**，正确性优先，成本差异可忽略。
> 未取到的槽位在签名里留空，保持签名稳定。

### 3.2 文件布局

| 路径 | 内容 |
| --- | --- |
| `getFilesDir()/dynamic_theme.zip` | 运行期生成的主题包 |
| `getFilesDir()/dynamic_theme.tmp` | 写入中转（成功后再 rename，防半写） |

> **注意**：`File.renameTo` 在同一 `getFilesDir()` 内是原子替换，可用于防半写。
> 若 rename 失败则删除 tmp 并保留旧包（宁可用旧主题，不可用坏主题）。

### 3.3 主题包构成

照抄实测②验证过的结构（`build_probe_v3.py` / `build_probe_dynamic.py`）。
下表按**逻辑条目**列（浅/深各一份，所以实际是 13 个模板文件）：

| 条目 | 来源 | 说明 |
| --- | --- | --- |
| `metadata.binarypb` | **内置 `theme_package_metadata_material_{light,dark}.binarypb` 原始字节** | 照抄，保证文件列表自洽 |
| `style_sheet_color_common.binarypb` | 内置原始字节 | 不参与改色 |
| `style_sheet_material_{light,dark}.binarypb` | **按映射表改色后** | 主力样式表，51 条规则 |
| `style_sheet_color_gif_{light,dark}.binarypb` | 内置原始字节 | |
| `style_sheet_color_rules.binarypb` | 内置原始字节 | |
| `style_sheet_material_rules.binarypb` | 内置原始字节 | |
| `style_sheet_material_{light,dark}_border.binarypb` | 内置原始字节 | |
| `style_sheet_color_rules_border.binarypb` | 内置原始字节 | |
| `style_sheet_material_rules_border.binarypb` | 内置原始字节 | |

**为什么内嵌而不从 `assets/` 逐次读取**：IME 进程读自己的 `assets/theme/*` 需要
`AssetManager` 逐文件打开、手写 zip 解析，Java 侧代码量大。
把 13 个模板**作为资源内嵌**（`res/raw/`），运行期只做"改色 + 打 zip"，
逻辑最简单、失败面最小。

### 3.3.1 模板存放方式：**采用方案丙（已确认）**

**核心事实（本轮实测）**：`assets/theme/` 下 **75 个 `.binarypb` 本来就在 APK 里**
（`decoded/assets/theme/`，`apktool.yml` 确认会被重新打包）。
所以运行期可以直接 `getAssets().open("theme/xxx.binarypb")` 读到，
**一次复制都不需要，`public.xml` 一个 id 都不用加。**

| 方案 | 源码 | `public.xml` | `apply_patches` | 可 diff | 结论 |
| --- | --- | --- | --- | --- | --- |
| 甲：内嵌 `byte[]` | +4 万行 | 无改动 | 无改动 | 极差 | 不推荐 |
| 乙：复制到 `res/raw/` | +60 行 | +13 个 id | +1 步复制 | 好 | 可行 |
| **丙：直接读 `assets/`** | **+70 行** | **无改动** | **无改动** | 好 | **✅ 采用** |

**方案丙的实现**（约 70 行）：

```java
private static byte[] templateBytes(Context context, String name) {
    InputStream in = null;
    try {
        in = context.getAssets().open("theme/" + name);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        byte[] buf = new byte[4096];
        int n;
        while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
        return out.toByteArray();
    } catch (IOException e) {
        debugLog(context, "template read failed: " + name);
        return null;
    } finally { closeQuietly(in); }
}
```

`name` 用常量字符串（如 `"theme_package_metadata_material_light.binarypb"`），
**与 `assets/theme/` 下的真实文件名一一对应，可直接核对**。

**方案丙的取舍（已确认可接受）**：

- ✅ 零资源表改动 → 不碰 `public.xml` → `verify_stable_resource_ids.py` 天然通过
- ✅ `apply_patches.py` 一行不用改（模板本来就在）
- ✅ 模板是真实文件，可与 `assets/theme/` 直接 diff
- ✅ **上游风险不存在**——用户确认「上游已经不维护了，我们就是上游」，
  75 个模板文件由项目自己维护，运行时读取稳定可靠
- ⚠️ `assets` 是明文载体，理论上可被改；但主题包不含敏感信息，无实际风险

> **方案乙与甲不再采用，其细节保留在 3.3.2 仅作备查，实施时不必参考。**

### 3.3.2 备查：方案乙的资源表改动（**不实施**）

要存放的是 **13 个 `.binarypb`**，合计约 12 KB：

| 文件 | 字节 | 用途 |
| --- | --- | --- |
| `theme_package_metadata_material_{light,dark}.binarypb` | 315 / 312 | zip 的 `metadata.binarypb` 条目 |
| `style_sheet_material_{light,dark}.binarypb` | 1993 / 1594 | **主力样式表，改色对象** |
| `style_sheet_color_common.binarypb` | 1192 | 共用色 |
| `style_sheet_color_rules.binarypb` | 4590 | 规则色 |
| `style_sheet_color_gif_{light,dark}.binarypb` | 271 × 2 | |
| `style_sheet_material_rules.binarypb` | 310 | |
| `style_sheet_*_border.binarypb` × 4 | 257+257+397+134 | border 样式 |

**方案甲：内嵌 `byte[]` 常量**

| 项 | 评估 |
| --- | --- |
| 源码体积 | 12 KB 二进制 → 十六进制字面量，**约 4 万行**，`SystemAutoThemeCompat.java` 从 294 行膨胀到 4 万行 |
| 构建改动 | 零（不需要碰 `public.xml`） |
| 可维护性 | 极差。文件无法被 diff 阅读，改一个模板要重新生成整个类 |
| 编译成本 | javac 处理 4 万行常量池会明显变慢 |
| 结论 | **不采用** |

**方案乙：放 `res/raw/` 资源（用户确认采用）**

| 项 | 评估 |
| --- | --- |
| 源码体积 | 只增加约 60 行读取逻辑 |
| 构建改动 | `apply_patches.py` 增加一步：把 13 个文件从 `assets/theme/` 复制到 `res/raw/`（改名 `dyn_tpl_*`，避免与现有 raw 冲突） |
| 资源 id | **必须在 `public.xml` 显式分配 13 个 id**（见下方重要说明） |
| 读取方式 | `resources.openRawResource(id)` → `readAllBytes()` |
| 可维护性 | 好。模板是真实文件，可直接与 `assets/theme/` 对比 |
| 结论 | **采用** |

> **⚠️ 重要更正（对上一版方案的修正）**
>
> 上一版方案中说"用 `getIdentifier(name, "raw", pkg)` 反射取 id，**不改 `public.xml`**"
> —— **这是错的**，必须纠正。
>
> 原因：`scripts/generate_stable_resource_ids.py` 会把 `public.xml` 转换成
> **AAPT2 的 `--stable-ids` 映射**（该脚本 docstring 明确写了"reconstructed APK
> contains native and dex code with embedded 0x7f resource IDs"）。
> 这意味着**任何新增资源都必须显式进入 `public.xml` 并分配 id**，
> 否则 AAPT2 会按默认顺序分配，导致：
> - 构建产物里的 id 与源码中引用的 id 不一致；
> - `scripts/verify_stable_resource_ids.py` 校验失败。
>
> 反射 `getIdentifier` 本身能取到 id，但**取到的 id 必须是构建时确定的**，
> 所以"不改 `public.xml`"这个前提不成立。**方案乙必须包含 public.xml 改动。**

**实施方案乙的具体步骤**（补入第五节）：

1. `apply_patches.py` 在 apktool 解码后，把 13 个模板文件从
   `decoded/assets/theme/` 复制到 `decoded/res/raw/`，命名 `dyn_tpl_<原文件名去后缀>`；
2. 在 `decoded/res/values/public.xml` 的 `raw` 段落末尾追加 13 条
   `<public type="raw" name="dyn_tpl_..." id="0x7f09XXXX" />`，
   起始 id 取现有 raw 最大 id + 1（当前 raw 最后一个是 `0x7f09000X`，需实测确认）；
3. Java 侧用 `getResources().openRawResource(R.raw.dyn_tpl_x)` —— 但因为是编译注入，
   **`R` 类不可用**，需改用 `getResources().getIdentifier("dyn_tpl_x", "raw", pkg)`
   或直接把 id 写成常量（与项目 `PREF_KEY_*` 的既有做法一致，**推荐后者**）；
4. `verify_stable_resource_ids.py` 会自然覆盖这 13 个新 id。

> **id 硬编码的稳定性**：项目已有先例——`SystemAutoThemeCompat.java` 里的
> `PREF_KEY_KEYBOARD_THEME = 0x7f110282` 等 5 个 id 就是硬编码的。
> 新增 13 个 raw id 沿用同样做法，一致性最好。

### 3.4 颜色映射表（20 槽，实测③验证）

深浅两套，映射的是**系统语义色资源名**（按名取，实测①证实）：

| 键盘样式槽 | 浅色系统色 | 深色系统色 |
| --- | --- | --- |
| `color_base` | `system_surface_light` | `system_surface_dark` |
| `color_header` | `system_surface_container_light` | `system_surface_container_dark` |
| `color_popup_background` | `system_surface_container_high_light` | `system_surface_container_high_dark` |
| `color_access_points_menu_background` | `system_surface_light` | `system_surface_dark` |
| `color_access_point_panel_item_background` | `system_surface_light` | `system_surface_dark` |
| `color_label` | `system_on_surface_light` | `system_on_surface_dark` |
| `color_label_header_active` | `system_on_surface_light` | `system_on_surface_dark` |
| `color_popup_label` | `system_on_surface_light` | `system_on_surface_dark` |
| `color_icon` | `system_on_surface_variant_light` | `system_on_surface_variant_dark` |
| `color_state_action` | `system_primary_light` | `system_primary_dark` |
| `color_state_action_pressed` | `system_primary_container_light` | `system_primary_container_dark` |
| `color_action_default` | `system_primary_light` | `system_primary_dark` |
| `color_label_dynamic` | `system_primary_light` | `system_primary_dark` |
| `color_keyboard_editing_button` | `system_primary_light` | `system_primary_dark` |
| `color_keyboard_editing_button_background` | `system_primary_container_light` | `system_primary_container_dark` |
| `color_key_paging_scrollbar` | `system_primary_light` | `system_primary_dark` |
| `color_notice_text` | `system_primary_light` | `system_primary_dark` |
| `color_state_popup_item_pressed` | `system_primary_container_light` | `system_primary_container_dark` |
| `color_generic_extension_background_activated` | `system_secondary_container_light` | `system_secondary_container_dark` |
| `color_keyboard_separator` | `system_outline_variant_light` | `system_outline_variant_dark` |

**取色方式**（实测①结论，必须按名取）：

```java
Resources r = context.getResources();
int id = r.getIdentifier(name, "color", "android");
if (id == 0) continue;                    // 该 ROM 无此资源 → 跳过，保留模板原色
int argb = r.getColor(id, context.getTheme());
```

**逐槽回退语义**：某个系统色取不到时**保留模板原色**，而不是整体失败。
这比"整包回退"体验好得多。

> **实施实测（模板覆盖差异）**：20 个槽位在**浅色**模板
> `style_sheet_material_light.binarypb` 中**全部存在**（51 条规则，命中 20）。
> **深色**模板 `style_sheet_material_dark.binarypb` **只命中 18 条**，
> 缺 `color_access_point_panel_item_background` 与 `color_keyboard_separator`——
> 该模板本身就没有定义这两条规则。
>
> 这是**良性**的：映射项在缺规则的模板上自动成为 no-op，
> 不会写坏任何东西，也不需要为它加分支。
> 阶段 A 门禁会打印实际命中数，便于日后核对。

### 3.5 触发时机（用户已确认：只做前两个）

> **术语**：本文档中「自动主题」「跟随主题」指同一个功能——
> 即 `SystemAutoThemeCompat` 的三槽模型，其 UI 开关标题为「**跟随主题**」
> （位于现代设置 Compose 的主题背景页 `SettingsRoute.ThemeBackground`，
> 见 5.3.1）。
> 后文统一用「跟随主题」。

| # | 时机 | 注入点 | 行为 |
| --- | --- | --- | --- |
| ① | 键盘进程启动 | `GoogleInputMethodService.onCreate`（已有 `applyOnCreate` 注入点，`apply_patches.py:2856`） | 造包（若签名变化）→ 写 prefs |
| ② | 系统深浅色切换 | `onConfigurationChanged`（已有 `applyIfEnabled` 注入点，`apply_patches.py:2874`） | 同上，切到对应的深/浅套 |
| ③' | **键盘弹出时**（新增，回应第 3 点决定） | `GoogleInputMethodService.onStartInputView`（`GoogleInputMethodService.smali:8536`，`.line 541` 的 `invoke-super` 之后） | **只做签名比对**，变化才造包 |

**为什么加 ③'**：用户指出键盘弹出/收回非常频繁，足以覆盖刷新需求。
这是**成本极低的补充**——因为已有签名去重机制（3.1 节），
签名未变时 ③' **只做 5 次 `getColor` 读取 + 一次字符串比较**，
不写文件、不写 prefs，开销可忽略。

**注入位置**（`onStartInputView` 结构已确认）：

```smali
.method public onStartInputView(Landroid/view/inputmethod/EditorInfo;Z)V
    .locals 7
    .prologue
    ...
    .line 541
    invoke-super {p0, p1, p2}, Landroid/inputmethodservice/InputMethodService;->onStartInputView(...)V

    # ★ 在此插入
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/
        SystemAutoThemeCompat;->applyOnKeyboardShown(Landroid/content/Context;)Z
    move-result v6

    .line 542
```

**⚠️ 注意 `.locals 7`**：插入后用到 `v6` 是安全的（原方法已用 v6 存 `const/4 v6, 0x1`，
我们在其使用点之前插入，需实测确认不冲突；若冲突则改为 `loc_??` 局部标签或升 `.locals`）。

**③' 的返回语义**：返回 `true` 表示"签名变化、已重新造包并改了 prefs"，
此时**需要重建 InputView 才能看到新主题**——但键盘刚弹出，正在构建中，
所以这一次弹出仍用旧主题，**下次弹出生效**。这是可接受的（用户不会察觉，
因为换壁纸是低频操作）。

> **③ 不做（换壁纸后立即刷新）**：用户已确认不做。实际覆盖情况：
> 换壁纸 → 下次键盘弹出（③'）或深浅色切换（②）时刷新。
> 用户日常打字会立即触发，体验上无感。

### 3.6 `applyConfiguredTheme` 的分支改造

现状（`SystemAutoThemeCompat.java:180-192`）：

```java
private static boolean applyConfiguredTheme(Context context, Configuration configuration) {
    if (hasSelectionSession(context)) return false;
    if (isEnabled(context)) {
        boolean dark = isDark(configuration);
        return writeSlot(context, dark ? SLOT_DARK : SLOT_LIGHT, ...);
    }
    return writeSlot(context, SLOT_FIXED, "resolved target=fixed");
}
```

改为：

```java
private static boolean applyConfiguredTheme(Context context, Configuration configuration) {
    if (hasSelectionSession(context)) return false;                    // ★ 选择器期间全部暂停
    if (isDynamicEnabled(context)) {                                   // 新增，优先级最高
        boolean dark = isDark(configuration);
        if (syncDynamicTheme(context, dark)) {                         // 造包（若需）+ 返回"包是否可用"
            return writeSlot(context, SLOT_DYNAMIC,
                    dark ? "resolved target=dynamic-dark" : "resolved target=dynamic-light");
        }
        // 包不可用 → 向下穿透，正常解析旧三槽（见下方"造包失败"说明）
    }
    if (isEnabled(context)) { ... }                                    // 原逻辑不动
    return writeSlot(context, SLOT_FIXED, "resolved target=fixed");
}
```

> **造包失败时的兜底（实施时补强）**：`syncDynamicTheme` 的返回值语义是
> **"包是否可用"，不是"是否重建了"**。三种情况：
>
> | 情况 | 返回 | 理由 |
> | --- | --- | --- |
> | 签名未变且包在盘上 | `true` | 常见路径，不碰文件 |
> | 重建成功 | `true` | |
> | 重建失败但旧包仍在 | `true` | 稍旧的配色好过没有配色 |
> | 重建失败且盘上没有包 | **`false`** | 见下 |
>
> 早期实现不区分这几种情况，会在造包失败时**照样写入动态槽**，
> 于是 `additional_keyboard_theme` 指向一个不存在的文件 →
> `gc.b` 校验失败 → `PinyinIME.a()` 退回 `baq.b(ctx)` = **内置默认主题**。
> 这比"保留用户原来的主题"差得多。
>
> 现在返回 `false` 时**穿透到旧三槽逻辑**：因为 `setDynamicEnabled(true)`
> 已清掉 `AUTO_THEME_KEY`，会落到 fixed 槽，**恢复用户原来的固定主题**。
> 下一次配色变化（或键盘弹出）时重试造包。

**关键设计**：动态槽走**独立的开关**（`compat_system_dynamic_color_theme`），
不挤占 `AUTO_THEME_KEY`。这样：

- 关掉动态配色 → 直接回落到原有三槽逻辑，**原功能零回归**
- `hasSelectionSession` 是**第一道闸**，保证用户在选择器里操作时动态配色不插手

**互斥处理（对齐既有设计，不是新发明）**：
既有「跟随主题」开关与固定主题之间**已经互斥**，但实现方式是
**依赖规则**，不是文案：

1. `ThemeSettingRules.canSelect()` —— 「跟随主题」开启时固定槽不可选，
   关闭时浅/深槽不可选。**UI 的 `enabled` 与
   `LegacySettingsRepository.beginThemeSelection()` 的 `require` 共用这一个函数**。
2. 在 `ThemeSelectorActivity` 里真正选定主题会调
   `SystemAutoThemeCompat.disable(Context)`，**退出自动模式**。
   该调用由 `apply_patches.py` 注入（`ThemeSelectorActivity.smali` 的
   `.prologue` 与 `:cond_0` 两处），**不是靠文案承诺**。

动态配色与「跟随主题」在"深浅跟随"上职责重叠，
因此采用**单向压制**：动态配色开启 → 关闭「跟随主题」并置灰全部槽入口。
**详见 5.3.2**（该节取代本节早期写的"开一个自动关另一个"）。

> **⚠️ 已更正的错误引用（留档）**：本节早期版本曾把一条文案
> 「选择固定或自定义主题；选择后将关闭"跟随主题"」当作"既有互斥已实现"的证据。
> **该文案在代码库中并不存在**（全仓搜索零命中），是早期轮次凭印象写下的。
> 既有互斥确实存在，但证据是**上面两条代码事实**，不是文案。
> 详见 **10.2.2**。

**在选择器里选定固定主题时的处理**：
扩展现有的 `disable(Context)` 与 `captureFixedTheme(Context)` ——
除了清 `AUTO_THEME_KEY`，同时清 `compat_system_dynamic_color_theme`。
这与既有行为完全一致（"手动选主题 = 退出所有自动模式"）。

**注意**：关闭开关**不清除槽位内容**。
槽位保存的是用户对"浅色用哪个、深色用哪个"的选择，是持久化的用户意图，
关闭自动模式只是停止自动写入，再次开启时直接恢复原选择（见 10.3）。

### 3.7 `writeSlot` 与既有逻辑的兼容性

`writeSlot` 已按 slot 取 `baseKey`/`additionalKey`，只需在两者加 `SLOT_DYNAMIC` 分支：

```java
private static String baseKey(String slot) {
    if (SLOT_LIGHT.equals(slot)) return LIGHT_BASE_KEY;
    if (SLOT_DARK.equals(slot)) return DARK_BASE_KEY;
    if (SLOT_FIXED.equals(slot)) return FIXED_BASE_KEY;
    if (SLOT_DYNAMIC.equals(slot)) return DYNAMIC_BASE_KEY;     // 新增
    throw new IllegalArgumentException("Unknown theme slot");
}
```

`isValidSlot` 同步加 `SLOT_DYNAMIC`。

**注意 `isValidSlot` 被 `hasSelectionSession` 使用**：加 `SLOT_DYNAMIC` 后，
若有人把 `SELECTION_SLOT_KEY` 设成 `dynamic` 会误判为"正在选择中"。
**约束**：`beginSelection` 只允许三槽（保持现有 `isValidSlot` 语义），
所以需要**拆成两个校验函数**：

```java
private static boolean isSelectableSlot(String slot) {
    return SLOT_LIGHT.equals(slot) || SLOT_DARK.equals(slot) || SLOT_FIXED.equals(slot);
}
private static boolean isValidSlot(String slot) {
    return isSelectableSlot(slot) || SLOT_DYNAMIC.equals(slot);
}
```

`hasSelectionSession` 改用 `isSelectableSlot`。**这是方案里最容易被忽略的坑。**

### 3.8 `reconcileCustomThemeEdit` 的覆盖

`reconcileCustomThemeEdit` 目前遍历 `{LIGHT, DARK, FIXED}` 三槽，
**动态槽不应加入**——动态槽的 `additional` 恒为 `files:dynamic_theme.zip`，
不可能是 `files:user_theme_*`，加进去只是徒增分支。保持现状即可。

---

## 四、Java 源码改动清单

文件：`patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java`

| # | 改动 | 说明 |
| --- | --- | --- |
| 1 | 新增常量 `SLOT_DYNAMIC = "dynamic"` | public |
| 2 | 新增键 `DYNAMIC_ENABLED_KEY` / `DYNAMIC_BASE_KEY` / `DYNAMIC_ADDITIONAL_KEY` / `DYNAMIC_SIGNATURE_KEY` | private |
| 3 | 新增 `isDynamicEnabled` / `setDynamicEnabled` | 开关读写；`setDynamicEnabled(true)` 时**先关掉跟随主题**（单向压制，见 5.3.2），收尾调 `applyConfiguredTheme` |
| 4 | 新增 `supportsDynamicColor()` | `Build.VERSION.SDK_INT >= 31` |
| 5 | 新增 `syncDynamicTheme(Context, boolean dark)` | 算签名 → 需要则造包 → 写 `DYNAMIC_*_KEY` |
| 6 | 新增 `buildDynamicThemePackage(Context, boolean dark)` | 读模板 → 取系统色 → 改色 → 打 zip → 原子落盘 |
| 7 | 新增 `resolveSystemColor(Resources, Theme, String name)` | `getIdentifier` + `getColor`，取不到返回 0 |
| 8 | 新增 `rewriteStyleSheetColors(byte[] src, Map<String,Integer> cmap)` | 移植 `style_sheet_tool.py` 的 varint 解析/重建 |
| 9 | 新增 `templateBytes(Context, String name)` | **方案丙**：`getAssets().open("theme/" + name)` 直接读，**不用 `res/raw/`、不加资源 id** |
| 10 | 新增 **`applyOnKeyboardShown(Context)`** | ③' 键盘弹出触发点，只做签名比对 |
| 11 | 改 `applyConfiguredTheme` | 加动态分支（最高优先级） |
| 12 | 改 `baseKey` / `additionalKey` | 加 `SLOT_DYNAMIC` 分支 |
| 13 | 改 `isValidSlot` + 新增 `isSelectableSlot` | 见 3.7 |
| 14 | 改 `hasSelectionSession` | 改用 `isSelectableSlot` |
| 15 | 改 `ensureInitialized` | 初始化动态槽默认值（`material_dark_theme` + `files:dynamic_theme.zip`） |
| 16 | ~~新增 13 个 raw id 常量~~ | **方案丙下取消**（模板直接从 `assets/theme/` 按名读取） |
| 17 | 改 `disable` / `captureFixedTheme` | 除清 `AUTO_THEME_KEY` 外，**同时清 `DYNAMIC_ENABLED_KEY`**（手动选主题 = 退出所有自动模式） |

**预计规模**：+550 ~ 650 行（含 varint 工具、zip 写入、assets 读取），
文件从 294 行增至约 900 行。

> **实施实测**：改造后 **1023 行**，生成的 smali **3501 行**（原 1460 行）。

**~~另需新增一个 Java 类~~：`DynamicColorSettingsCompat.java` —— 已取消**

> **实施修正**：核实 `LegacySettingsRepository.kt:439` 的反射桥接常量
> `SYSTEM_AUTO_THEME_BRIDGE`，其值**就是**
> `com.google.android.inputmethod.pinyin.SystemAutoThemeCompat`。
>
> 所以 Compose 侧本来就在反射调用这个类。新增 `setDynamicEnabled` 直接加在
> 同一个类上即可，**不必新建第二个类**。
>
> 收益：少一个注入类、少一条 `apply_patches.py` 白名单、少一个 smali 产物。

### 4.1 `rewriteStyleSheetColors` 的实现要点

这是唯一有算法复杂度的部分，**必须与 `style_sheet_tool.py` 逐字节等价**：

```text
StyleSheet        field2(0x12) = repeated StyleRule
StyleRule         field1(0x0a) = string 名
                  field2(0x12) = StylePropertyValue   { field1(0x08)=ARGB varint }
                  field3(0x1a) = int selector
```

实现策略：**只替换 field2 的 varint 值，重算本规则长度，其余字节原样透传**。
不做完整 protobuf 解析（避免引入解析器），只做"扫描 + 定位 + 定长重写"。

**验证手段**：Java 实现的结果必须与 Python 版**逐字节相同**。
实施时用同一份模板 + 同一份映射，两边产物做 `sha256` 比对，**这是强验证点**。

> **实施修正 1（比较对象）**：原稿写"两边产物做 sha256 比对"。
> 实施时明确：**比较对象是改色后的 `style_sheet_material_{light,dark}.binarypb` 字节**，
> **不是整个 zip**。原因是 zip 容器由各自语言的标准库写出，
> 局部头、时间戳、额外字段的写法天然不同，要求 zip 逐字节一致既做不到也无意义。
> 真正需要等价的是**算法产物**，容器只要能被 `bbl` 正常读取即可。
>
> 落地为 `scripts/test_dynamic_color_rewrite.py`（编译 Java + 跑 Python + 比对）。

> **实施修正 2（field3 selector 的实际行为）**：
> 原稿说"保留 field3（selector）"。实测两份模板共 51 + 若干条规则，
> **没有任何一条带 selector**。
>
> Python 版 `style_sheet_tool.py` 那段保留逻辑实际是空操作
> （它从 `rule_body[0]` 开始判断是否为 `0x1A`，而 `rule_body[0]` 恒为 `0x0A`，
> 循环第一步就 break）。
>
> Java 版按**正确语义**实现（扫描整个规则体，存在 `0x1A` 才保留）。
> 由于当前模板无 selector，两者输出**完全一致**，阶段 A 门禁通过；
> 若将来模板引入 selector，Java 版行为正确，Python 版需要同步修正。

---

## 五、构建与注入改动

### 5.1 `apply_patches.py` 需新增

**方案丙下，模板相关改动全部取消**（不复制、不改 `public.xml`）。
只剩两个注入点：

| # | 改动 | 说明 |
| --- | --- | --- |
| 1 | `onStartInputView` 注入 | 插入 `applyOnKeyboardShown` 调用（见 3.5 ③'） |
| 2 | ~~设置页注入~~ | **不需要**——设置页走 Compose 侧反射调用 `SystemAutoThemeCompat.setDynamicEnabled` |
| 3 | ~~strings.xml 追加文案~~ | **不需要**——文案加在 `modern-settings/` 的 `strings.xml`（见 5.3.3） |
| 4 | ~~复制 `DynamicColorSettingsCompat.smali`~~ | **不需要**——不新建类；`SystemAutoThemeCompat.smali` 已在白名单中 |

> **结论**：`apply_patches.py` **只需一处改动**（`onStartInputView` 注入点），
> 且 `SystemAutoThemeCompat.smali` 的复制**沿用现有白名单**
> （`apply_patches.py:3079` 已包含该类），无需新增。

> **注意**：`SystemAutoThemeCompat.java` 的第四槽逻辑编译进
> `SystemAutoThemeCompat.smali` 后，**通过现有白名单自动复制**，
> 不需要新增注入点（该类已在 `apply_patches.py:3079` 的 helper 列表中）。

### 5.2 构建入口：**两条路径，别走错**

> **本轮重要更正**：上一版写"`build.ps1` 无需改"。这只对了一半——
> **本方案的改动横跨两条构建路径**，必须分别走对入口。

| 改动对象 | 构建入口 | 说明 |
| --- | --- | --- |
| **Java / smali 侧**（`SystemAutoThemeCompat.java`、新增 `DynamicColorSettingsCompat.java`） | `scripts/build.ps1` | 走 apktool 解码 → `apply_patches.py` → 重打包。**不改这个脚本本身** |
| **Compose 侧**（`modern-settings/` 下的 `.kt` 与 `strings.xml`） | `scripts/build_modern_settings_host.py` | 走 Gradle 编译 Compose 工程 + 与解码后的原版资源合并。见 `docs/build-and-release.md` 的「完整 Compose Host 构建」 |
| **两边都改了**（本方案就是） | **只跑后者** | `build_modern_settings_host.py` 内部已经包含"解码原版 APK → 跑 `apply_patches.py` → 合并 Compose 产物"的完整链路 |

> **结论**：本方案的**唯一正确构建命令是 `scripts/build_modern_settings_host.py`**。
> `build.ps1` 只覆盖到 smali 侧，用它构建会**丢掉 Compose 的全部改动**——
> 表现就是"设置页看不到动态配色开关"，而 smali 侧一切正常，极易误判为注入失败。

**Java → smali 的可复现性**：

> **已核实**：`patches/smali/SystemAutoThemeCompat.smali` **没有对应的生成脚本**
> （`scripts/generate_*.py` 里无引用，只有 `apply_patches.py` 与
> `verify_modern_settings_runtime.py` 提到该类名）。
> 说明现存的 1460 行 smali 是**手工 / 一次性生成**后入库的。
>
> **本次必须新建 `scripts/generate_system_auto_theme_smali.py`**，
> 否则第四槽的改动无法可复现地进入 smali。
> 结构照抄 `scripts/generate_simplified_traditional_toggle_smali.py`
> （javac `-source 7 -target 7` → jar → d8 → apktool d → 取 .smali）。
>
> 这也顺带修复了一个既有隐患：**当前 `SystemAutoThemeCompat` 的源码与 smali
> 之间缺少可复现的构建关系**，后续任何人改 Java 都不会反映到产物。

### 5.3 设置入口（用户已确认：**要做**）

#### 5.3.1 现状核实（本轮代码走查）

**⚠️ 重要更正**：上一版曾写"设置页没有主题分区""自动主题开关没有 UI"——
**这两条都是错的**，源于我只在 `patches/smali` 与 `res/xml` 范围内搜索。
正确情况如下。

**主题相关的两个界面**：

| 界面 | 位置 | 内容 |
| --- | --- | --- |
| **现代设置**（Compose） | `modern-settings/` 独立 Gradle 工程 → `ModernSettingsActivity` | **已含「跟随主题」开关**（自动主题） |
| **原版主题选择器** | 从设置页跳转 `ThemeSelectorActivity` | 主题候选列表 + 按键边框开关 |

**原版主题选择器的入口**（`res/xml/setting_keyboard.xml`）：

```xml
<Preference android:persistent="false" android:title="@string/setting_theme">
    <extra android:name="START_ACTIVITY"
           android:value="...theme.preference.ThemeSelectorActivity" />
</Preference>
```

**自动主题开关的真实实现**（`commit 4d3ef5f feat: follow system keyboard theme`）：

| 文件 | 作用 |
| --- | --- |
| `modern-settings/.../compose/SystemAutoThemeSetting.kt` | 契约对象：`preferenceKey = "compat_system_auto_keyboard_theme"`、`isDarkMode(uiMode)` |
| `modern-settings/.../compose/KeyboardSettingsScreens.kt` | 开关 UI：`SettingsSwitchRow`，绑定 `onSystemAutoThemeEnabledChange` |
| `modern-settings/.../compose/LegacySettingsRepository.kt` | 持久化桥接 → 调 `SystemAutoThemeCompat.setEnabled` |
| `modern-settings/.../compose/SystemAutoThemeSettingTest.kt` | 单元测试（含键名稳定性断言） |
| `scripts/apply_patches.py`（+102 行） | 注入 IME 侧的 `applyOnCreate` / `applyIfEnabled` 等钩子 |

**开关文案**（`modern-settings/compose-runtime/src/main/res/values-zh/strings.xml`，
**以下为实际值，已逐条核对**）：

| 资源名 | 简体中文实际值 |
| --- | --- |
| `modern_settings_theme_title` | 主题背景 |
| `modern_settings_theme_page_summary` | 跟随主题、浅色模式主题、深色模式主题和固定主题 |
| `modern_settings_system_auto_theme_title` | **跟随主题** |
| `modern_settings_system_auto_theme_summary` | 根据系统深浅色模式自动切换主题 |
| `modern_settings_light_mode_theme_summary` | 选择系统处于浅色模式时使用的主题 |
| `modern_settings_dark_mode_theme_summary` | 选择系统处于深色模式时使用的主题 |
| `modern_settings_fixed_theme_summary` | 选择关闭「跟随主题」时使用的主题 |
| `modern_settings_theme_requires_follow_enabled` | 开启「跟随主题」后可设置 |
| `modern_settings_theme_requires_follow_disabled` | 关闭「跟随主题」后可设置 |

> **⚠️ 开关标题是「跟随主题」，不是「跟随主题」**。
> 早期版本的本文档写成「跟随主题」并据此设计文案，是**错的**；
> 全仓搜索「跟随主题」零命中，实际资源值如上表。
> 用户口语中也称其为"跟随主题"（见 〇 节原话），两者指同一开关。
> **本文档统一使用实际文案「跟随主题」**，用户原话保持原样不改。

> **结论**：项目**已有**「跟随主题」开关，且**已经实现了与固定主题的互斥**
> ——但互斥由 `ThemeSettingRules` 的依赖规则与 `disable()` 注入实现，
> **不是由某条文案承诺**（早期版本引用过一条不存在的文案，见 10.2.2）。
> **上一版建议的"互斥"不是新设计，而是既有行为** —— 动态配色沿用同一套语义。

**上一版为什么判断错**：`setEnabled` 的调用方在 **Kotlin/Compose 侧**
（`modern-settings/` 是独立工程，经 Gradle 编译后与 APK 合成），
而我只在 `patches/smali/` 与 `apply_patches.py` 中 grep smali 字符串，
**搜索范围本身就漏掉了整个现代设置工程**。

**「跟随主题」所在的确切页面**（本轮补齐，之前只写到"键盘设置页"，不准确）：

```text
SettingsRoute.KeyboardAppearance（外观与布局）
  └─ item 1: 「主题背景」  → navigateTo(SettingsRoute.ThemeBackground)
SettingsRoute.ThemeBackground（主题背景）          ← 4 个主题 item 在这里
  ├─ item 1: 「跟随主题」  SettingsSwitchRow          checked = followTheme
  ├─ item 2: 「浅色模式主题」SettingsNavigationRow      enabled = followTheme
  ├─ item 3: 「深色模式主题」SettingsNavigationRow      enabled = followTheme
  └─ item 4: 「固定主题」   SettingsNavigationRow      enabled = !followTheme
```

对应代码 `KeyboardSettingsScreens.kt:92-183`：
`keyboardAppearanceSettingsItems()` 的**第一个** item 就是「主题背景」入口
（`KeyboardSettingsScreens.kt:97-106`），
`themeBackgroundSettingsItems()`（`:137-183`）承载上述 4 个 item。

**依赖规则收敛在单一纯函数**（`ThemeSettingRules.kt`）：

```kotlin
internal object ThemeSettingRules {
    fun canSelect(slot: ThemeSelectionSlot, followThemeEnabled: Boolean): Boolean =
        when (slot) {
            ThemeSelectionSlot.Light,
            ThemeSelectionSlot.Dark,   -> followThemeEnabled
            ThemeSelectionSlot.Fixed   -> !followThemeEnabled
        }
}
```

这个函数**同时被 UI（`enabled =`）与写入边界
（`LegacySettingsRepository.beginThemeSelection()` 的 `require`）调用**，
是"UI 显示"与"实际可写"唯一的共同来源。**新状态的置灰必须加在这里，
而不是只加在 Composable 里**，否则 UI 看起来禁用、写入却仍然放行。

#### 5.3.2 与现有主题模式的交互（**用户已确认，取代上一版的建议**）

> **用户原话**（本轮最终确认）：
> 「放在跟随系统上面，并且开启后跟随系统开关变成灰色不可操作，意味着失效，
> 固定主题入口也失效无法选择。另外旧设置页面也要有对应的设置入口。」
>
> 这一句把上一版留的"互斥方向"问题**全部定死**：
> 不是双向互斥，而是**单向压制**——动态配色一旦开启，
> 跟随主题与固定主题**两侧同时失效**。

**第三条模式，且是压制者**：

| 模式 | 管深浅跟随 | 取系统色 | 开启后其他入口 |
| --- | --- | --- | --- |
| 跟随主题（`followTheme`） | 是 | 否 | 浅/深槽可设，固定槽置灰 |
| 固定主题（`!followTheme`） | 否 | 否 | 固定槽可设，浅/深槽置灰 |
| **动态配色（新增）** | **是** | **是** | **跟随主题开关置灰＋浅/深/固定三槽入口全部置灰** |

（浅/深槽入口本来就是 `enabled = followTheme`，跟随主题开关一置灰，
这两个入口自然跟随失效——**不需要额外的条件**。真正需要显式处理的是
「跟随主题」开关本身与「固定主题」入口，因为它们的 `enabled` 表达式里
不含动态配色这一维。）

**开启动态配色后的完整失效清单**：

| # | 控件 | 现状表达式 | 新表达式 |
| --- | --- | --- | --- |
| 1 | 动态配色开关（新增，置顶） | — | `enabled = true`（始终可点） |
| 2 | 「跟随主题」开关 | `enabled = true`（省略） | `enabled = !dynamicColor` |
| 3 | 「浅色模式主题」 | `enabled = followTheme` | `enabled = followTheme && !dynamicColor` |
| 4 | 「深色模式主题」 | `enabled = followTheme` | `enabled = followTheme && !dynamicColor` |
| 5 | 「固定主题」 | `enabled = !followTheme` | `enabled = !followTheme && !dynamicColor` |

> **第 2 项是唯一需要改语义的**：它的 `enabled` 原本省略（恒真）。
> 被压制时摘要同步改为「已由动态配色接管」，让用户知道灰掉的原因
> （复用 `modern_settings_theme_requires_dynamic_disabled`）。
> **第 5 项必须显式加条件**：动态配色若在 `!followTheme` 状态下开启，
> 没有 `&& !dynamicColor` 的话固定主题入口仍可点，直接违反用户要求。
>
> **第 3、4 项本是 `enabled = followTheme`**。因为动态配色开启时
> `followTheme` 必为假（见下方写入序列第 2 步），这两个入口其实**已自动失效**。
> 表达式仍显式补上 `&& !dynamicColor`，好处是与第 5 项保持同构、
> 一眼能看出"动态配色管着全部四个入口"，而不用去追"跟随主题此时是假"这条链。

**「开启动态配色」这一刻的写入序列**（单向，不可逆推）：

```text
1. 写 compat_system_dynamic_color_theme = true
2. 调 SystemAutoThemeCompat.setEnabled(ctx, false)      // 关闭跟随主题
3. 调 SystemAutoThemeCompat.setDynamicEnabled(ctx, true) // 立即生效：造包 + 写 additional_keyboard_theme
4. 重读快照 → UI 重绘（跟随主题开关变灰、三槽入口变灰）
```

> **第 2 步是"单向压制"的关键**：动态配色开启时 `followTheme` 必须为假。
> 这样「浅/深槽入口」的既有表达式 `enabled = followTheme` 就自然失效，
> 不需要为它们单独写动态配色条件，也保证了
> `ThemeSettingRules.canSelect()` 里"槽位可写"与"UI 可点"一致。
>
> **反向不压制**：关掉动态配色**不会**自动重新打开跟随主题。
> 回到的是用户上次的选择——这正好落回 10.3 的项目级约束
> （槽位是持久化用户选择，关开关只停止自动写入）。

**四条写入路径仍都落 `additional_keyboard_theme`**（不变）：

| 场景 | 行为 | 依据 |
| --- | --- | --- |
| 打开主题选择器期间 | 动态配色暂停写入 | 复用 `beginSelection` / `hasSelectionSession` |
| 在选择器里选定固定主题 | 动态配色**自动关闭**，选择存入 fixed 槽 | 既有语义：`ThemeSelectorActivity` 注入点已调 `disable` |
| 动态配色开启时 | 跟随主题关闭＋全部入口置灰 | **本轮用户确认** |
| 动态配色关闭 | 不写任何东西，交回跟随主题 / fixed 槽 | 零回归 |

> **与 `ThemeSettingRules` 的衔接**：`canSelect()` 增加第三个参数后
> 变成 `canSelect(slot, followThemeEnabled, dynamicColorEnabled)`，
> `LegacySettingsRepository.beginThemeSelection()` 的 `require`
> 与 3 个 `SettingsNavigationRow` 的 `enabled =` 都改成调用它
> （「跟随主题」开关本身不对应槽位，走 `enabled = !dynamicColor`）。
> **单一来源，不再各写一份条件。**

#### 5.3.3 实施细节（现代设置 Compose 路线，**已定为唯一路线**）

> **路线已定**：不再并置"原版 smali 注入 `setting_keyboard.xml`"作为备选。
> 理由：`API 35+` 的正式设置界面就是 Compose 工程（见
> `docs/modern-settings-runtime-design.md` 的 Migration boundary），
> 而「跟随主题」开关本来就在 Compose 侧。
> **动态配色和它同类，放同一处才有统一语义。**

**改动文件清单**（`modern-settings/` 独立 Gradle 工程）：

| # | 文件 | 改动 |
| --- | --- | --- |
| 1 | `compose/ThemeSettingRules.kt` | `canSelect()` 增 `dynamicColorEnabled` 参数（**规则单一来源**） |
| 2 | **新增** `compose/DynamicColorSetting.kt` | 契约对象，照 `SystemAutoThemeSetting.kt` 形态：`preferenceKey = "compat_system_dynamic_color_theme"`、`minSdk = 31` |
| 3 | `compose/KeyboardSettingsScreens.kt` | `themeBackgroundSettingsItems()` 首部插入开关 item，并把 4 个既有 item 的 `enabled` 改为按 5.3.2 表格的表达式 |
| 4 | `compose/SettingsScreen.kt` | `SettingsActions` 增 `onDynamicColorEnabledChange: (Boolean) -> Unit`；`SettingsSnapshot` 增 `dynamicColorEnabled: Boolean` |
| 5 | `compose/LegacySettingsRepository.kt` | `readSnapshot()` 读新键；增 `setDynamicColorEnabled()`，内部按 5.3.2 的写入序列执行；`beginThemeSelection()` 的 `require` 改用三参 `canSelect` |
| 6 | `compose/ModernSettingsActivity.kt` | 在 `SettingsActions(...)` 里接线 `onDynamicColorEnabledChange = { snapshot = controller.setDynamicColorEnabled(it) }` |
| 7 | `compose/SettingsController.kt` | 透传一个 `setDynamicColorEnabled()`（与 `setSystemAutoThemeEnabled` 同形） |
| 8 | `res/values/strings.xml` + `values-zh/strings.xml` + `values-zh-rHK/strings.xml` | 新增 3 条文案（见下） |
| 9 | **新增** `test/.../DynamicColorSettingTest.kt` | 键名稳定性断言 + `ThemeSettingRules` 三态真值表 |
| 10 | `test/.../ThemeSettingRulesTest.kt` | 扩展为三参真值表（**既有 6 条断言全部保留并补第 3 维**） |

**`SettingsActions` / `SettingsSnapshot` 是 data class，已核实两处都需要显式加字段**
（`SettingsScreen.kt:70-72`、`LegacySettingsRepository.kt:477`）。

**新增文案（3 条，已加到三套语言）**：

| 资源名 | 简体中文（已实施） | English（已实施） | 繁中 HK（已实施） |
| --- | --- | --- | --- |
| `modern_settings_dynamic_color_title` | **动态配色** | Dynamic color | 動態配色 |
| `modern_settings_dynamic_color_summary` | 键盘配色取自系统主题色，随深浅色模式变化 | Take keyboard colors from the system theme colors and follow light or dark mode | 鍵盤配色取自系統主題色，隨深淺色模式變化 |
| `modern_settings_theme_requires_dynamic_disabled` | 关闭「动态配色」后可设置 | Turn off Dynamic color to configure this setting | 關閉「動態配色」後可設定 |

> **命名沿革**：早期版本建议的标题是「跟随主题配色」，
> 与既有的「跟随主题」在同一列表里相邻显示、只差两字，容易混淆。
> 最终定为「**动态配色**」，摘要说明它取自系统主题色。
> 这是**文案层的开放项**（见 10.4），日后改字符串资源即可，不影响结构。

**门控显示**：`SettingsCapabilities` 加 `dynamicColorVisible`
（`Build.VERSION.SDK_INT >= DynamicColorSetting.minSdk`，即 31），
与既有 `oneHandedModeVisible` 等同一套机制
（`KeyboardSettingsScreens.kt` 里 `if (snapshot.capabilities.oneHandedModeVisible)`
就是现成范式；动态配色用的是 `if (snapshot.capabilities.dynamicColorVisible)`）。

**门控的可见性语义**：`SDK_INT < 31` 时该开关**整项不渲染**（不是"显示但禁用"）。
这样 API 17–30 设备的主题页与改动前**逐项一致**，是最强的零回归保证。

**旧设置页（API 17–34）**：**本轮不做**，见 5.3.4。

#### 5.3.4 旧设置页（API 17–34）：**本轮不做**（用户已决定）

> **用户决定**：
> 「算了，既然旧设置页没有就刚好不做了，只做新设置页，
> 因为后续我打算提升 API 版本来弃用旧设置页、全面接入新设置页了。」

**决定**：动态配色**只改 `modern-settings/`（Compose）**，
不往 `res/xml/setting_keyboard.xml` 加任何 `Preference`，
不改 `apply_patches.py` 的旧页面注入段。

**依据**：

1. 「跟随主题」开关只存在于 Compose 侧，旧页面没有它。
   用户要的"动态配色开启 → 跟随主题置灰"在旧页面上**没有控件可以灰**，
   要买这条交互就得**先给旧页面补一个跟随主题开关**，属于把改动面翻倍。
2. 用户后续计划**提升 API 版本弃用旧设置页**，
   此时往旧页面投入属于**废工**。

**由此确立一条分工约束**：

> **"提升 API 版本 + 弃用旧设置页 + 全面接入新设置页"是一条独立需求，
> 在本方案完成之后另做**，不并入本方案。

**对旧页面的实际影响**：API 17–34 的设备**没有动态配色开关**，
其主题行为与改动前**完全一致**（零回归）。
这符合"低版本完全不走新逻辑"的既有能力门控（`SDK_INT >= 31`），
只是门控在低版本上的表现从"显示但不可用"变成"整项不显示"。

**备查：旧页面接入的完整要点**（若后续真要做，直接照此执行）

<details>
<summary>展开查看（本轮不实施）</summary>

本项目的设置界面随系统版本分流
（`docs/modern-settings-runtime-design.md` 的 Migration boundary）：

```text
API 17-34   原有 Preference 设置界面（res/xml/setting_keyboard.xml 等）
API 35+     Compose Material 3 设置界面（modern-settings/）
```

需要**同时补齐旧页面的两件事**：

| # | 内容 | 做法 |
| --- | --- | --- |
| 1 | 加「动态配色」`CheckBoxPreference` | 复用既有注范式（`apply_patches.py:322` 的简繁表头开关是先例） |
| 2 | **同时补一个「跟随主题」`CheckBoxPreference`** | 否则"开动态配色后跟随主题变灰"在旧页面上无从体现 |

实现要点：

| 项 | 内容 |
| --- | --- |
| 挂载位置 | `res/xml/setting_keyboard.xml`，沿用 `apply_patches.py:322-343` 的 `replace_once` 三处联动写法（`setting_keyboard.xml` + `arrays.xml` 的 `pref_key_*` + `pref_def_value_*`） |
| 键名 | 与 Compose 侧**共用同一键** `compat_system_dynamic_color_theme`、`compat_system_auto_keyboard_theme` |
| 依赖关系 | `android:dependency` 无法表达"我开启时让对方置灰"，需用 `DynamicColorSettingsCompat` 挂 `OnPreferenceChangeListener` 主动改对方 `isEnabled` |
| 门控 | API `< 31` 时 `removePreference` |
| 文案 | 复用 Compose 侧同一批字符串资源，避免两套文案漂移 |

**技术约束**：旧页面走 `PreferenceFragment`，
`Preference` 的 `enabled` **不是响应式的**，
置灰依赖需在 `onResume` 与 `OnPreferenceChangeListener` **两处都刷新**。

</details>
> 具体挂载点需实测确认（见 10.4）。



### 5.4 备查：raw id 分配做法（**方案丙下不实施**）

> 以下内容仅记录方案乙所需的资源表改动，**当前不实施**。

```python
# apply_patches.py 中新增
RAW_TEMPLATES = [
    "dyn_tpl_metadata_light", "dyn_tpl_metadata_dark",
    "dyn_tpl_material_light", "dyn_tpl_material_dark",
    "dyn_tpl_color_common", "dyn_tpl_color_rules",
    "dyn_tpl_gif_light", "dyn_tpl_gif_dark",
    "dyn_tpl_material_rules",
    "dyn_tpl_material_light_border", "dyn_tpl_material_dark_border",
    "dyn_tpl_color_rules_border", "dyn_tpl_material_rules_border",
]
```

1. 从 `assets/theme/` 复制并改名到 `res/raw/`。
2. 解析 `public.xml` 找 `type="raw"` 的当前最大 id，逐个 `+1` 追加。
3. Java 侧把分配到的 id 写死为常量（与 `PREF_KEY_*` 同做法）。

> **实施时必须实测确认**：现有 raw 的最大 id 是多少。若 raw 段后面还有其他
> 类型的资源占用了 `0x7f09` 段，则需换用空闲段。

**✅ 已完成实测（2026-09-30，干净 2.1.3 基线）**：

| 项 | 实测值 |
| --- | --- |
| `type="raw"` 条目数 | **15** |
| raw 段 id 范围 | `0x7f090000` ~ `0x7f09000e`（连续，**已用满至 `0x7f09000e`**） |
| `0x7f09` 段占用者 | **仅 `raw`**（无其他类型混入） |
| 下一段 `0x7f0a` | 属于 `array`，**不冲突** |

**结论：新增 13 个 raw id 从 `0x7f09000f` 开始顺序分配即可**：

```text
dyn_tpl_metadata_light       0x7f09000f
dyn_tpl_metadata_dark        0x7f090010
dyn_tpl_material_light       0x7f090011
dyn_tpl_material_dark        0x7f090012
dyn_tpl_color_common         0x7f090013
dyn_tpl_color_rules          0x7f090014
dyn_tpl_gif_light            0x7f090015
dyn_tpl_gif_dark             0x7f090016
dyn_tpl_material_rules       0x7f090017
dyn_tpl_material_light_border 0x7f090018
dyn_tpl_material_dark_border  0x7f090019
dyn_tpl_color_rules_border    0x7f09001a
dyn_tpl_material_rules_border 0x7f09001b
```

**风险已消除**：raw 段后面到 `0x7f0a` 之间没有空隙冲突，
13 个新 id 可安全落在 `0x7f09000f` ~ `0x7f09001b`。

---

## 六、回滚方式

| 层级 | 动作 | 效果 |
| --- | --- | --- |
| 用户级 | 关掉 `compat_system_dynamic_color_theme` | 回到三槽逻辑，`additional_keyboard_theme` 被重写成槽值 |
| 文件级 | 删 `getFilesDir()/dynamic_theme.zip` | 下次启动重建 |
| 代码级 | `apply_patches.py` 里注释掉动态分支注入 | 完全等同动态功能不存在 |
| 构建级 | 不传 `-Debuggable`、不启用开关 | 正式包默认关闭，**release 行为零变化** |

**最坏情况兜底**：若 `dynamic_theme.zip` 损坏导致 `gc.b` 校验失败，
`PinyinIME.a()` 会自动 `baq.b(ctx)` 退回默认主题——**键盘不会白屏**。
这是链路上自带的保险（实测②已间接验证：metadata 不对时校验失败并回退）。

---

## 七、测试计划

### 7.1 分阶段

| 阶段 | 内容 | 通过标准 |
| --- | --- | --- |
| A | Java 改色实现与 Python 产物比对 | 同模板同映射 → **改色后样式表 sha256 完全一致**（✅ 已通过，见下） |
| B | 构建 devdbg（`-Debuggable`，测试包名） | 构建成功，签名校验通过 |
| C | 真机开关打开，重启输入法 | 键盘渲染为系统配色（非 `#ECEFF1`） |
| D | 切换深/浅色 | 两套配色正确跟随 |
| E | 关闭开关 | 复原到之前的固定主题，**无残留** |
| F | 重复开关 5 次 + 换壁纸后重启 IME | 无崩溃、无白屏、zip 未损坏 |
| G | `SDK_INT < 31` 设备（若有） | 不崩溃，走旧逻辑 |

**阶段 A 已完成**（`scripts/test_dynamic_color_rewrite.py`）：

| 模板 | 映射 | 命中规则 | Java vs Python |
| --- | --- | --- | --- |
| `style_sheet_material_light.binarypb` | 合成（20 槽） | 20 | **MATCH** |
| `style_sheet_material_light.binarypb` | 实测系统色 | 20 | **MATCH** |
| `style_sheet_material_dark.binarypb` | 合成（20 槽） | 18 | **MATCH** |
| `style_sheet_material_dark.binarypb` | 实测系统色 | 18 | **MATCH** |

槽位覆盖：**20/20 在浅色模板中存在**；深色模板缺 2 条（见 3.4 的说明，良性）。

### 7.2 关键断言（真机）

```bash
# 1. 确认落盘
adb shell run-as <pkg> ls -l files/dynamic_theme.zip

# 2. 确认 prefs
adb shell run-as <pkg> cat shared_prefs/<pkg>_preferences.xml | grep -E "dynamic|additional"

# 3. 确认实际生效值（核心）
adb shell dumpsys input_method | grep -i "mCurImeId"

# 4. 截图采样：键盘底色应等于 system_surface_{light,dark}
adb exec-out screencap -p > shot.png
```

`SystemAutoThemeCompat` 的 `debugLog` 只在 debuggable 生效，
所以 devdbg 包应能看到标签 `SystemAutoTheme` 的
`resolved target=dynamic-light` / `dynamic-dark` / `dynamic theme pair committed` 日志。

### 7.3 回归检查（动态功能不得影响既有能力）

- 三槽自动切换（`light`/`dark`/`fixed`）行为不变
- 主题选择器打开/取消/选择流程不变
- 自定义主题创建/编辑/删除后的槽位修复不变
- `verify_stable_resource_ids.py` 通过

### 7.4 与既有主题模式的交互专项（**已按本轮确认的交互重写**）

**I-1 到 I-6 为跨模式行为，I-7 起为本轮新增的置灰/失效专项。**

| # | 场景 | 期望 |
| --- | --- | --- |
| I-1 | 动态配色开启时，打开主题选择器 | 动态配色暂停写入；选择器内看到的仍是当前动态主题 |
| I-2 | 在选择器里选定一个固定主题 | 动态配色**自动关闭**；键盘切到该固定主题 |
| I-3 | 取消退出选择器（未选主题） | 动态配色**保持开启**，主题不变（对齐现有"仅打开不改模式"语义） |
| I-4 | 关掉动态配色 | 回到「跟随主题」（若开）/ fixed 槽，与开启前完全一致 |
| I-5 | 关掉动态配色后再重开 | **槽位内容仍在**，恢复的是上次的选择，不是默认值 |
| I-6 | 动态配色开启期间删除自定义主题 | 不崩溃；动态槽不受影响（`reconcileCustomThemeEdit` 不处理动态槽） |
| **I-7** | 动态配色开启后的**同一屏**状态 | ①「跟随主题」开关**置灰不可点**；②浅色模式主题入口置灰；③深色模式主题入口置灰；④固定主题入口置灰。**五项控件里只有动态配色开关自己是可点的** |
| **I-8** | 置灰是否为"真禁用" | 置灰项**点击无任何反应**，且 `beginThemeSelection()` 的 `require` 同时拒绝——UI 与写入边界两侧一致（不能只灰不拦） |
| **I-9** | 开启动态配色前的既有状态 | 若「跟随主题」当时是开着的，开启动态配色后它变为**关闭且置灰**；关掉动态配色后它**不会自动恢复为开**（回到用户上次选择，符合 10.3） |
| **I-10** | 动态配色开关的**位置** | 在「主题背景」页**第一项**，位于「跟随主题」**上方**（用户明确要求） |
| **I-11** | `SDK_INT < 31` 设备 | 「动态配色」开关**整项不显示**；其余 4 项行为与改动前完全一致（零回归） |
| **I-12** | 旧设置页（API 17–34，**本轮不做**） | **无需验证**——API 17–34 设备上动态配色整项不显示，主题行为与改动前完全一致。真机上以 I-11 覆盖 |

> **I-7 / I-8 是本轮用户要求的两条硬断言**，必须在真机截图 + `prefs` 双向验证：
> 截图证"灰"，`prefs` 证"没写进去"。
>
> **I-11 是零回归的兜底断言**：本项目 `minSdkVersion=17`，
> 低版本设备走不到动态配色，必须确认整项消失而不是显示成不可用。

---

## 八、风险与对策

| 风险 | 等级 | 对策 |
| --- | --- | --- |
| Java 改色与 Python 不一致 | 中 | 阶段 A 的 sha256 强制比对 |
| `onStartInputView` 注入寄存器冲突 | 中 | 实施时实测；冲突则升 `.locals` 或改用局部标签 |
| 造包耗时阻塞键盘弹出 | 中 | ③' 只做签名比对（约 5 次 `getColor` + 1 次字符串比较）；造包仅在签名变化时 |
| 半写导致 zip 损坏 | 低 | tmp + `renameTo` 原子替换；失败保留旧包 |
| 某些 ROM 缺 `system_*` 色资源 | 低 | 逐槽回退模板原色（3.4 节） |
| 换壁纸后不立即刷新 | 低 | 已确认接受；换壁纸后**弹出键盘**（③'）即刷新 |
| 动态包被执行主题列表枚举 | 低 | 文件名 `dynamic_theme.zip` 不以 `user_theme_` 开头，天然不被枚举 |
| 新开关文案排版不合规 | 低 | 按项目中文规范写；有 lint 脚本可查 |

**已消除的风险**（方案丙的收益）：

- ~~新增 13 个 raw id 与现有资源冲突~~ → 不改 `public.xml`，风险归零
- ~~`res/raw` 复制步骤失败~~ → 无复制步骤
- ~~模板文件被上游改动~~ → 用户确认本项目即上游


---

## 九、实施顺序（**已全部完成，仅剩真机验收**）

| # | 步骤 | 产出/验证 | 状态 |
| --- | --- | --- | --- |
| 0 | ~~实测现有 raw 最大 id~~ | 方案丙下**不再需要**，仅作记录 | ✅ |
| 1 | 新建 `scripts/generate_system_auto_theme_smali.py` | 使 Java → smali 可复现；**已验证**：用现有 Java 生成的 smali 与原手工入库的 1460 行**语义等价**（仅 `.registers`/`.locals` 与标签命名差异）；**两次生成哈希一致**，可用于 CI 门禁 | ✅ |
| 2 | 改 `SystemAutoThemeCompat.java`（第四槽 + 造包器 + varint + assets 读取 + ③'） | 编译通过；1023 行 → smali 3531 行 | ✅ |
| 3 | ~~新建 `DynamicColorSettingsCompat.java`~~ | **取消**：桥接常量本就指向 `SystemAutoThemeCompat` | ✅ 取消 |
| 4 | 生成 smali → `patches/smali/` | 产物入库 | ✅ |
| 5 | 改 `apply_patches.py`（**只剩 `onStartInputView` 一处**，见 5.1） | 脚本可跑；隔离包构建通过 | ✅ |
| 6 | **改 `modern-settings/` 的 10 个文件**（见 5.3.3 清单） | `:compose-runtime:testDebugUnitTest` **73 用例全过** | ✅ |
| 7 | 阶段 A 比对（`scripts/test_dynamic_color_rewrite.py`） | **4/4 MATCH**，槽位覆盖 20/20 | ✅ |
| 8 | 构建隔离包（**Compose host 全链路**，见 5.2） | `dist/dyn-host-debug.apk`，v1/v2/v3 签名 + 16 KiB 对齐通过 | ✅ |
| 9 | `verify_modern_settings_runtime.py` 完整运行 | 对最终组装包解码后运行，输出 `official Compose Material 3 settings runtime verified` | ✅ |
| 10 | **真机阶段 C~G + 交互专项 I-7~I-12** | 见第七节 | ⬜ 待设备 |

**实施中已解决的实测点**：

- `onStartInputView` 的 `v6` 寄存器**不需要动**：刻意不取 `applyOnKeyboardShown`
  的返回值即可（与既有 `applyOnCreate` 注入忽略返回值同一做法），
  因此 `.locals 7` 保持不变。
- 构建入口确认：**Compose 侧必须走 `build_modern_settings_host.py`**，
  纯 smali 构建（`build.ps1` 路线）不含 Compose 宿主。

**新增门禁脚本**（本轮）：

| 脚本 | 作用 |
| --- | --- |
| `scripts/generate_system_auto_theme_smali.py` | Java → smali 可复现构建（已接入 CI） |
| `scripts/test_dynamic_color_rewrite.py` | 阶段 A：Java vs Python 改色逐字节等价 + 槽位覆盖检查 + 探针漂移交叉校验（已接入 CI） |

---

## 十、已确认的决定与项目级约束

### 10.1 结构决定（已确认）

| # | 问题 | 决定 | 位置 |
| --- | --- | --- | --- |
| 1 | 设置入口 | **要做** | 5.3 |
| 2 | 模板存放方式 | **方案丙：直接读 `assets/theme/`** | 3.3.1 |
| 3 | ③ 主题色变更刷新 | **不做** | 3.5（另加 ③' 键盘弹出触发点） |

### 10.1.1 设置交互决定点（第 4/5/6 点，**本轮已确认**）

| # | 问题 | 决定 | 依据 |
| --- | --- | --- | --- |
| 4 | 动态配色开关放哪 | **「主题背景」页第一项，位于「跟随主题」上方** | 用户原话「放在跟随系统上面」 |
| 5 | 动态配色与「跟随主题」是否互斥 | **单向压制**：动态配色开启 → 跟随主题开关置灰失效、浅/深/固定三个槽入口全部置灰失效 | 用户原话「开启后跟随系统开关变成灰色不可操作，意味着失效，固定主题入口也失效无法选择」 |
| 6 | 旧设置页面（API 17–34）是否要入口 | **不做**（**本轮已撤销**） | 用户原话「算了，既然旧设置页没有就刚好不做了……后续我打算提升 API 版本来弃用旧设置页」 |

> **第 5 点不是双向互斥**。上一版曾建议"互相排斥（开一个关另一个）"，
> 用户的实际要求是**单向**：动态配色是唯一的压制者，
> 它开启时另外两组入口一起失效；它关闭时不反向影响任何东西。
> 具体写入序列与置灰表达式见 5.3.2。

> **第 6 点已撤销**。旧页面**当前没有「跟随主题」开关**，
> 要落地"动态配色开启 → 跟随主题置灰"就得先给旧页面补这个开关，改动面翻倍。
> 加上用户后续计划**提升 API 版本弃用旧设置页**，此时投入旧页面是废工。
> 因此本轮**只改 Compose 侧**，旧页面保持原样（等于零回归）。
> 详见 **5.3.4**。
>
> **由此确立的分工**：**"提升 API 版本 + 弃用旧设置页 + 全面接入新设置页"
> 是独立需求，在本方案完成之后另做。**

### 10.2 本轮核实的重要事实

| 事实 | 说明 |
| --- | --- |
| **「跟随主题」开关已存在且实现完整** | `modern-settings/` 的 `SystemAutoThemeSetting.kt` + `KeyboardSettingsScreens.kt`，commit `4d3ef5f`，含单元测试 |
| **开关的实际文案** | 标题「**跟随主题**」（不是「跟随主题」）；摘要「根据系统深浅色模式自动切换主题」。逐条值见 5.3.1 的表 |
| **"固定主题与跟随主题互斥"已实现** | 由 `ThemeSettingRules.canSelect()` 的依赖规则 + `ThemeSelectorActivity` 处的 `disable()` 注入共同实现，**不是由文案承诺** |
| 主题选择器 | 从 `setting_keyboard.xml` 的 `<Preference>` 跳转到 `ThemeSelectorActivity`，内部有候选列表 + 按键边框开关 |
| 动态配色的定位 | 它是**第三种模式**：既跟随深浅（像「跟随主题」），又取系统色（独有），**并且是唯一能压制其他入口的模式** |
| 「跟随主题」的确切位置 | `SettingsRoute.ThemeBackground`（主题背景）页，**不是**「外观与布局」页本身——后者只是第一项跳转入口 |
| 依赖规则的单一来源 | `ThemeSettingRules.canSelect()`，**UI 的 `enabled` 与 `LegacySettingsRepository` 的 `require` 共用**，新状态的置灰必须加在这里 |
| 控件已支持置灰 | `SettingsSwitchRow`（`SettingsComponents.kt:275`）与 `SettingsNavigationRow`（`:64`）**都已有 `enabled` 参数**，`enabled = false` 即变灰且 `clickable(enabled = false)` 阻断点击 |
| 旧页面没有「跟随主题」开关 | 这原本是"旧页面也要入口"的障碍，**现已因"旧页面整体不做"而无关** |

### 10.2.1 一处已更正的错误判断（留档）

**错误**：本轮一度判断"自动主题没有 UI 入口，`setEnabled` 零调用方，是死代码"。

**错因**：只在 `patches/smali/` 与 `apply_patches.py` 中搜索 smali 字符串，
**漏掉了整个 `modern-settings/` Compose 工程**——
自动主题开关是 Kotlin/Compose 实现的（`KeyboardSettingsScreens.kt` 的 `SettingsSwitchRow`），
`setEnabled` 由 `LegacySettingsRepository.kt` 调用，经 Gradle 编译后合成进 APK，
**不在 smali 注入范围内**。

**教训**：本项目有**两条并行的设置实现路径**——原版 smali 注入 + 现代设置 Compose 工程。
搜索设置相关逻辑时**必须同时覆盖两处**，只查 smali 会得出错误结论。

### 10.2.2 两处被引用的文案其实并不存在（留档）

**错误**：早期版本的本文档把下面两条"文案"当作既有事实引用：

| 被引用的文案 | 实际状态 |
| --- | --- |
| 「选择固定或自定义主题；选择后将关闭"跟随主题"」 | **不存在** |
| 「浅色模式使用 Material 浅色主题，深色模式使用 Material 深色主题」 | **不存在** |

**核实方法**：对 `modern-settings/`、`patches/`、`docs/` 全量搜索
`选择后将关闭`、`Material 浅色`、`选择固定`，**零命中**；
唯一命中来源就是本文档自己。

**实际值**（见 5.3.1 的完整表）：

- `modern_settings_system_auto_theme_title` = **跟随主题**
- `modern_settings_system_auto_theme_summary` = **根据系统深浅色模式自动切换主题**
- `modern_settings_fixed_theme_summary` = 选择关闭「跟随主题」时使用的主题

**错因**：凭印象复述"我记得界面上有这么一句话"，**没有回到字符串资源核对**。
`modern-settings` 的文案都在 `compose-runtime/src/main/res/values*/strings.xml`，
一次 grep 就能验证，成本极低。

**教训（两条，都是本项目的高频陷阱）**：

1. **引用界面文案前必须回字符串资源核对**，不能凭印象。
   本项目已有两套字符串（原版 `res/values*/` 与现代设置的 `values*/strings.xml`），
   凭印象极容易把两边的说法混在一起或直接编造。
2. **"某行为由某文案承诺"是弱证据**。本例中互斥行为**确实存在**，
   但它由 `ThemeSettingRules.canSelect()` 与 `disable()` 注入实现，
   **与任何文案无关**。把行为归因到文案，会导致后续设计被一条不存在的约束牵着走。

> 影响范围已排查：正文 3.6、5.3.1、10.2 三处的引用已改为代码事实，
> 本次实施（`ThemeSettingRules` 三参、置灰表达式、`disable()` 清动态键）
> **不依赖这两条假文案**，因此实施不受影响。

### 10.3 项目级约束（用户本轮确立）

> **槽位是持久化的用户选择，不随开关关闭而消失。**
> 自动主题与动态配色的槽位值（浅色用哪个、深色用哪个）由用户分别选定并持久保存；
> **关闭开关只是停止自动写入，槽位内容仍然保留**，
> 下次重新开启时直接恢复原选择。

**含义**：

- 动态槽同样要遵守这一点：关闭动态配色**不删除**动态槽的值与已生成的 zip。
- 这与 `SystemAutoThemeCompat` 既有的"legacy 两键只是物化输出"设计一致。
- 测试 E（关闭开关后复原）应验证"恢复的是用户之前的固定主题"，而非"槽位被清空"。

> **本项目即事实上的上游。** 原 APK 已不维护，`assets/theme/` 下 75 个
> `.binarypb` 模板文件由本项目自己维护。

**含义**：运行期直接读取 `assets/theme/` 稳定可靠；新增/修改模板直接改
`decoded/assets/theme/` 即可。

### 10.4 剩余开放项与实施时需实测确认的技术点

**剩余开放项（只有 1 项，不阻塞实施）**：

| # | 开放项 | 选项 | 倾向 |
| --- | --- | --- | --- |
| O-2 | 动态配色开关的标题用词 | 「动态配色」/「跟随主题配色」/「动态取色」 | 「**动态配色**」— 已实施；与相邻的「跟随主题」两字之差即可（「跟随主题配色」在列表里太像） |

> ~~O-1 旧设置页处理方式~~ → **已关闭**：用户决定旧页面整体不做（见 5.3.4）。
> O-2 属文案层，可先用现定标题实施，日后改字符串资源即可，**不影响结构**。

**实施时需实测确认的技术点**：

- `onStartInputView` 插入后 `v6` 寄存器是否冲突（决定是否升 `.locals`）
- `modern-settings/` 改后如何构建合成进 APK：
  正式构建走 `scripts/build_modern_settings_host.py`
  （见 `docs/build-and-release.md` 的「完整 Compose Host 构建」），
  **不是** `scripts/build.ps1`——后者只跑 apktool 解码 + `apply_patches.py` + 重打包。
  **改 Compose 侧必须用前者，改 smali 侧才用后者**。
- `SettingsCapabilities` 增字段后 `verify_modern_settings_runtime.py`
  是否需要同步扩展（该门禁对 `SettingsCapabilities.kt` 有结构化断言，
  见 `:426-449`）

---

## 十一、参考

- [实测②③：主题包构造与加载](./dynamic-color-device-test-2.md)
- [实测①：系统动态色读取](./dynamic-color-device-test-1.md)
- [定向验证报告](./dynamic-color-theme-verification.md)
- [可行性调研](./dynamic-color-theme-research.md)
- [Gboard System Auto 主题研究](./gboard-system-auto-theme-research.md)
- 现有实现：`patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java`
- 注入点：`scripts/apply_patches.py:2856`（`applyOnCreate`）、`:2874`（`applyIfEnabled`）
- 造包参照：`work/dynamic-color-probe/build_probe_dynamic.py`、`style_sheet_tool.py`
- 反编译证据：`baq.smali`、`bck.smali`、`gc.smali`、`bbl.smali`、`PinyinIME.smali`
