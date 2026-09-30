# 动态配色真机实测②③：主题包构造与加载

> 设备：Pixel 10 Pro（`blazer`，`59271FDCH002F9`），Android 16 / API 36
> 接入：`ADB_SERVER_SOCKET=tcp:10.77.7.79:15037`（server 模式，见实测①文末）
> 承接：[实测①：系统动态色读取](./dynamic-color-device-test-1.md) ｜
> [定向验证报告](./dynamic-color-theme-verification.md)

## 结论摘要

| 问题 | 结论 |
| --- | --- |
| 代码造的主题包能被加载渲染吗？ | **能**（实测②，键盘区 96.6% 像素为探针色） |
| 主题从哪个 prefs 键生效？ | **`additional_keyboard_theme`**，不是 `keyboard_theme` |
| 值需要什么形式？ | 必须以 `assets:` / `files:` / `system:` 开头 |
| 主题包 metadata 怎么造？ | 照抄内置主题的 `ThemePackageMetadata` 字节最稳 |
| 系统动态色能直接进键盘吗？ | **能**（实测③，`color_base` = `system_surface_light` 精确匹配） |
| 需要移植 Material Color Utilities 吗？ | **不需要**（见实测①） |

**实测状态：✅ 实测② 已通过（2026-09-30，干净 2.1.3 基线）。**

**结论：代码造的主题包能够被加载并真实渲染。** 键盘区 96.6% 像素精确为 `#FF00FF`。

---

## 〇、实测② 最终结论（2026-09-30）

### 0.1 关键机制纠正：主题由 `additional_keyboard_theme` 决定，不是 `keyboard_theme`

这是本轮**最重要的发现**，此前理解完全错误。

`baq.a(Context)` 的真实逻辑（`baq.smali:30-160`）：

```text
if (ais.g(ctx)):                                  // 首次/特殊状态
    return baq("material_dark_theme", "")
v1 = prefs[keyboard_theme]                        // 0x7f110282  主主题
v0 = prefs[additional_keyboard_theme]             // 0x7f11023a  附加主题
if (!isEmpty(v0)):                                // ★ 附加非空 → 短路
    return baq("pref_entry_base_keyboard_theme", v0)
if (!isEmpty(v1)):
    // 仅当 v1 是 material_dark / material_light 时映射到内置，否则也映射内置
    return baq(base, "pref_entry_additional_keyboard_theme_material_{dark|light}")
return baq.b(ctx)                                 // 系统主题目录
```

再经 `PinyinIME.a()`（`PinyinIME.smali:201-238`）：

```text
v0 = baq.a(ctx)
v1 = v0.b                                         // 实际生效的主题字符串
v2 = isEmpty(v1) ? true : gc.b(ctx, v1)           // 校验
if (!v2): v0 = baq.b(ctx)                         // 校验失败 → 退回默认
return new bck(ctx, v0, oneHanded)
```

**推论（全部经真机验证）**：

1. **`additional_keyboard_theme` 非空时，`keyboard_theme` 被完全忽略。**
   这就是前两轮「改了 4 处 prefs 仍无效果」的真正原因——检查过 prefs 里
   `additional_keyboard_theme` 一直是 `assets:...google_blue_light...`。
2. **只写 `keyboard_theme` 永远无法自定义主题**：即使非空，
   `gc.b(ctx, "material_light_theme")` 也会返回 `false`（无 `assets:`/`files:` 前缀
   → 落到 `gc.smali` `:cond_8` 返回 0），随即退回内置。
3. **唯一可用入口是 `additional_keyboard_theme`**，且值必须以
   `assets:` / `files:` / `system:` 开头才能通过 `gc.b` 校验。

### 0.2 主题包 metadata 真实结构（纠正）

`ThemePackageMetadata` 的正确字段映射：

| field | wire | 类型 | 含义 |
| --- | --- | --- | --- |
| 1 | 0x08 | int | 版本号，**可省略**（内置省略 → 0） |
| 2 | 0x12 | repeated string | **主 style_sheet 文件名列表** |
| 3 | 0x1a | message | 嵌套 `{ field1=int 版本, field2=repeated string border 文件名列表 }` |

内置 `theme_package_metadata_material_light.binarypb` 实测（315 字节）：

```text
field2 × 5 = style_sheet_color_common / _material_light / _color_gif_light /
             _color_rules / _material_rules
field3(131B) = { field1=1, field2 × 3 = _material_light_border /
                 _color_rules_border / _material_rules_border }
```

**此前误用**：`field2=主题名`、`field3=单个文件名` —— 错误，会导致
`bbl.a(File)Z` 校验失败。

校验链（`bbl.smali:311`、`bbl.smali:459`）：

```text
bbl.a(File)Z  =  bbl.a(File)[metadata] != null
                 && metadata.a(field1) <= 3
```

### 0.3 `files:` 通路确认可用

```text
additional_keyboard_theme = "files:user_theme_000000000000001_00.zip"
→ gc.a(ctx, str)  substring(6) → new File(getFilesDir(), name) → bbl.a(File)
→ ZipFile.getEntry("metadata.binarypb") 精确匹配
→ ThemePackageMetadata.parseFrom(bytes)
→ metadata.field1(0) <= 3  ✓
→ 渲染生效
```

### 0.4 真机验证记录（devdbg，2.1.3）

| 步骤 | 结果 |
| --- | --- |
| 探针包 | `work/dynamic-color-probe/out/probe_theme_v3.zip`，10805 B，9 条目全 STORED |
| metadata | 315 B，**与内置字节一致**（照抄，保证文件列表自洽） |
| 样式表 | `style_sheet_material_light.binarypb` 51 条规则**全部** → `#FF00FF` |
| 落位 | `files/user_theme_000000000000001_00.zip` |
| prefs | `additional_keyboard_theme = files:user_theme_...zip` |
| 截图采样 | **键盘区 96.6% 像素 = `#FF00FF`** ✓ |
| 单键验证 | 仅改 `additional_keyboard_theme`、`keyboard_theme` 保持 `material_light_theme` → 同样 96.6% ✓ |

截图：`work/dynamic-color-probe/shots/probe_v3_additional.png`、
`probe_v3_single_key.png`

**副作用说明**：按键字符不可见 —— 因为 51 条规则全被改成同一颜色，
文字色与背景色相同。这是探针的预期行为（证明规则全部生效），非缺陷。

---

## 〇-旧、重要前置：原实测载体被污染

**首轮实测②使用的设备包是 `2.2.0` 失败产物，结论作废，须在干净基线（2.1.3）上重跑。**

核实过程：

| 项 | 值 |
| --- | --- |
| 设备包名 | `com.google.android.inputmethod.pinyin.pairauto` |
| base.apk sha256 | `55d78bfba9a252a94a233074f8a3598b8622ba0c134e6fe5de8043b5fc8591cf` |
| 对应本地产物 | `dist-audit/google-pinyin-4.5.2-audit-v2-aligned-signed.apk`（字节一致） |
| versionName / versionCode | **2.2.0 / 4520500** |
| git / CHANGELOG / memory 记录 | **全部无** → 孤儿手工构建 |

用户确认：2.2.0 是**之前开发失败**的产物，对应功能需求已定性为**暂时不做**。

**污染影响范围**：

- 实测①（系统动态色读取）——**不受影响**。探针是独立应用，测的是系统
  framework 资源，与客户端版本无关。结论有效。
- 实测②（自造主题包加载渲染）——**受影响**。观察到的是 2.2.0 的
  `KeyboardThemeProvider` / `SystemAutoTheme` 行为。**已在 2.1.3 重跑通过
  （见〇节）。**

**旁证**：`SystemAutoThemeCompat` 的 `debugLog` 仅在
`ApplicationInfo.flags & 0x2`（FLAG_DEBUGGABLE）时才输出 —— 故 release-like 包
无 `SystemAutoTheme` 日志属正常，**不能作为「类未被调用」的证据**。
调用链已确认存在：`PinyinIME` → `Labp` → `GoogleInputMethodService.onCreate()` →
`SystemAutoThemeCompat.applyOnCreate(ctx)`（`GoogleInputMethodService.smali:5983`）。

**清理动作（已完成）**：设备卸载 `pairauto`，默认输入法切回正式包 `compat`；
磁盘清空 `dist/ build/ dist-audit/ build-audit/`（约 239 MB）。

---

## 一、实测② 第一轮已完成的部分（机制知识，与版本无关，全部保留）

以下成果来自**反编译原始 4.5.2 APK**（`original/`），不是从 2.2.0 读出来的，
**结论有效，可直接复用**。

### 1.1 StyleSheetProto 二进制线格式（核心突破）

完整线格式（纯手工逆向，无 protobuf 库）：

```text
StyleSheet            field 2 (0x12) = repeated StyleRule
StyleRule             field 1 (0x0a) = string 属性名
                      field 2 (0x12) = StylePropertyValue
                      field 3 (0x1a) = int selector
StylePropertyValue    field 1 (0x08) = int ARGB 颜色（varint）  ← 要替换的
                      field 2 (0x12) = repeated int
ThemePackageMetadata  field 1 (0x08) = int 版本（可省略，默认 0）
                      field 2 (0x12) = repeated string 主 style_sheet 文件名
                      field 3 (0x1a) = message { field1 版本, field2 repeated string border 文件名 }
```

> ⚠️ `ThemePackageMetadata` 的字段含义曾误判（把 field2 当名称、field3 当单文件列表），
> **已纠正，详见〇.2 节。**

**颜色是 varint 编码的 ARGB**，例：`e9 cf 93 ff 0f` → `0xFFE4E7E9`。

### 1.2 主题包 zip 结构

- 条目 `metadata.binarypb`：`ThemePackageMetadata` 序列化体
- 条目 `style_sheet*.binarypb`：metadata 中列出的各样式表
- **全部条目用 `setMethod(0)`（STORED）**，探针 v3 实测可行
- metadata 宜**照抄某个内置主题的字节**，保证文件列表与实际条目自洽

### 1.3 `files:` 主题通路闭环（完全打通）

```text
gc.a(Context, String)   判 "files:" 前缀                 [gc.smali:6843]
  → new File(getFilesDir(), name)                        [gc.smali:6862-6867]
  → bbl.a(File)          ZipFile 读 metadata.binarypb
枚举过滤：gc.a(Context) 用 Lbbe 过滤器 listFiles()
bbe.accept(File,String) 只判 name.startsWith("user_theme_")
```

**→ 文件名必须以 `user_theme_` 开头才能被主题列表发现。**
原版命名规则：`user_theme_%015d_%02d.zip`（时间戳 15 位 + 序号 2 位，循环 100 次找空位）。

### 1.4 内置主题是散件

`work/decoded/assets/theme/` 下 **75 个独立 `.binarypb`**
（`style_sheet_*.binarypb` + `theme_package_metadata_*.binarypb`），运行时组装。
`material_light` 有 **51 条规则**。

---

## 二、已完成的工具（可复用，与版本无关）

| 文件 | 作用 |
| --- | --- |
| `work/dynamic-color-probe/style_sheet_tool.py` | 纯 Python 的 StyleSheetProto 解析/改写器 |
| `work/dynamic-color-probe/build_probe_theme.py` | 以 `material_light` 为模板造探针主题包 |
| `work/dynamic-color-probe/build_probe.py` | 构建独立探针 APK |

`style_sheet_tool.py` 提供：`read_varint` / `write_varint` / `varint_size` /
`parse_rules(data)` → `[{name, color, span}]` /
`rebuild_with_colors(data, color_map)`（按名替换颜色并重算长度，保留 field3 selector）。

**本地自检已通过**：`rules: 51 / magenta: 34 / green: 17 / other: 0`。

`build_probe_theme.py` 输出 `out/probe_theme.zip`（875 字节，2 条目），
把 51 条颜色全替换（label/icon/text 槽 → 绿 `0xFF00FF00`，其余 → 洋红 `0xFFFF00FF`）。
metadata 十六进制 `08 03 12 11 ...`（版本 3 + 名称 + 文件名列表）。

---

## 三、重跑记录（干净 2.1.3 基线）

### 实测② ✅ 已完成：代码造的主题包能被加载渲染

**基线**：`com.google.android.inputmethod.pinyin.devdbg`（2.1.3 / debuggable，可用 `run-as`）

**做法**：

1. 取内置 `theme_package_metadata_material_light.binarypb` 的**原始字节**作 metadata；
2. 把 metadata 列出的 5 个主样式表 + 3 个 border 样式表一并打进 zip（STORED）；
3. 其中 `style_sheet_material_light.binarypb` 的 51 条规则颜色全改为 `#FF00FF`
   （`style_sheet_tool.py` 的 `rebuild_with_colors`）；
4. 推到 `files/user_theme_000000000000001_00.zip`；
5. prefs 写 `additional_keyboard_theme = files:user_theme_000000000000001_00.zip`；
6. 重启输入法 → 唤起键盘 → 截图采样。

**结果**：键盘区 **96.6% 像素 = `#FF00FF`**；仅改 `additional_keyboard_theme`
单个键同样生效（`keyboard_theme` 保持 `material_light_theme` 未受影响）。

**产出**：

- 造包脚本：`work/dynamic-color-probe/build_probe_v3.py`
- 探针包：`work/dynamic-color-probe/out/probe_theme_v3.zip`（10805 B）
- 截图：`work/dynamic-color-probe/shots/probe_v3_additional.png`、
  `probe_v3_single_key.png`

**踩坑（重要）**：

- `ThemeSelectorActivity` 未导出，无法直接 `am start`。
  但**不需要它** —— 直接改 prefs 即可，输入法下次启动就会读取。
- `am force-stop <ime>` 后系统会把默认输入法**回退到 LatinIME**，
  必须重新 `ime set` 才能继续测试，否则抓到的日志/截图全是 LatinIME 的。
- Git Bash 下 `adb push` 到 `/data/local/tmp/` 会被路径转换破坏，
  需 `export MSYS_NO_PATHCONV=1`。
- `run-as` **无法写 `/data/local/tmp`**，改写应用私有 prefs 要在
  `shared_prefs/` 目录内用临时文件中转。

### 实测③ ✅ 已完成：系统动态色 → 主题包 → 渲染（全链路打通）

**做法**：把实测①（按资源名读系统色）与实测②（自造包可渲染）合流。

1. 探针 APK 读系统语义色（`SEMANTIC` 扩到 40 项，**40/40 命中**），
   导出到 `work/dynamic-color-probe/system_colors.json`；
2. `build_probe_dynamic.py` 按映射表把 20 个键盘样式槽指向系统色；
3. 打包 → 推 `files/` → 写 `additional_keyboard_theme` → 重启输入法 → 截图。

**映射表（部分）**：

| 键盘样式槽 | 系统色资源 |
| --- | --- |
| `color_base` | `system_surface_light` |
| `color_header` | `system_surface_container_light` |
| `color_label` / `color_popup_label` / `color_label_header_active` | `system_on_surface_light` |
| `color_icon` | `system_on_surface_variant_light` |
| `color_state_action` / `color_action_default` / `color_label_dynamic` / `color_notice_text` | `system_primary_light` |
| `color_state_action_pressed` / `color_keyboard_editing_button_background` / `color_state_popup_item_pressed` | `system_primary_container_light` |
| `color_popup_background` | `system_surface_container_high_light` |
| `color_keyboard_separator` | `system_outline_variant_light` |
| `color_generic_extension_background_activated` | `system_secondary_container_light` |

**真机结果（采样精确匹配）**：

| 采样点 | 实测值 | 期望系统色 | 结论 |
| --- | --- | --- | --- |
| 键盘底色 | `#FCF8F9` | `system_surface_light` | ✓ |
| 按键区上部（header） | `#F0EDEF` | `system_surface_container_light` | ✓ |
| 回车键 | `#5A5E6C` | `system_primary_light` | ✓ |

**对比**：默认 `material_light` 底色是 `#ECEFF1`（中性灰），
动态包底色变为 `#FCF8F9`（随系统主题带淡紫调）→ **配色确实跟随系统**。

截图：`work/dynamic-color-probe/shots/probe_dynamic.png`

**产出**：

- `work/dynamic-color-probe/build_probe_dynamic.py` —— 系统色 → 样式槽映射与打包
- `work/dynamic-color-probe/system_colors.json` —— 设备实测系统色快照（40 项）
- `work/dynamic-color-probe/out/probe_theme_dynamic.zip`（10787 B，20/51 槽被替换）
- 探针源码扩充：`ProbeActivity.java` 的 `SEMANTIC` 由 18 项 → 40 项

**结论**：**动态配色功能的最小可行链路已完整验证**。
运行期读系统色（实测①）→ 映射进样式表 → 造包（实测②）→ 写
`additional_keyboard_theme` → 渲染生效（实测③）。
剩余工作是**接入 `SystemAutoThemeCompat` 第四槽 `SLOT_DYNAMIC`**，
把这条手工链路变成产品内的自动流程。

---

## 四、设备接入踩坑（沿用实测①结论）

- 转发器 `10.77.7.79:15037` 暴露的是**整个 ADB server**。
- 正确：`adb -H 10.77.7.79 -P 15037 devices` 或
  `ADB_SERVER_SOCKET=tcp:10.77.7.79:15037`。
- **错误**：`adb connect 10.77.7.79:15037` → 永远 `offline`（语义错配）。

---

## 五、参考

- [实测①：系统动态色读取](./dynamic-color-device-test-1.md)
- [可行性调研](./dynamic-color-theme-research.md)
- [定向验证报告](./dynamic-color-theme-verification.md)
- [Gboard System Auto 主题研究](./gboard-system-auto-theme-research.md)
- 反编译证据：`baj.smali`、`bbe.smali`、`gc.smali`、`bbl.smali`、
  `theme/proto/nano/StyleSheetProto$*.smali`
