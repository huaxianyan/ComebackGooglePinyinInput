# 动态配色真机实测②③：主题包构造与加载

> 设备：Pixel 10 Pro（`blazer`，`59271FDCH002F9`），Android 16 / API 36
> 接入：`ADB_SERVER_SOCKET=tcp:10.77.7.79:15037`（server 模式，见实测①文末）
> 承接：[实测①：系统动态色读取](./dynamic-color-device-test-1.md) ｜
> [定向验证报告](./dynamic-color-theme-verification.md)

**实测状态：机制已完全逆向清楚，渲染验证待重跑（原载体被污染）。**

---

## 〇、重要前置：原实测载体被污染

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
  `KeyboardThemeProvider` / `SystemAutoTheme` 行为。须重跑。

**旁证**：干净的 2.1.3 dev 包**没有** `KeyboardThemeProvider` / `SystemAutoTheme`
日志，而 2.2.0 有 → 这两个类是 2.2.0 特有的，即「System Auto 主题」方向的
失败实现痕迹。

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
ThemePackageMetadata  field 1 (0x08) = int 版本（固定 3）
                      field 2 (0x12) = string 名称
                      field 3 (0x1a) = repeated string 文件名列表
```

**颜色是 varint 编码的 ARGB**，例：`e9 cf 93 ff 0f` → `0xFFE4E7E9`。

### 1.2 主题包 zip 结构（`baj` 写入器）

- 条目 `metadata.binarypb`：版本固定 3、主题名、`["style_sheet.binarypb"]`
- 条目 `style_sheet.binarypb`：序列化后的样式表
- Map 内附加条目（图片等）：`setMethod(0)`（STORED），手工算 CRC32/size

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

## 三、待重跑（在干净 2.1.3 基线上）

### 实测② 重跑：代码造的主题包能否被加载渲染

**约束变化**：干净基线 `dev` 包是 **release-like（非 debuggable）**，
不能再用 `run-as` 往它私有目录塞文件。两条可选路径：

1. 重新构建 **debuggable** 的 dev 包（`build.ps1 -ApplicationId ...dev -Debuggable`），
   恢复 `run-as` 能力；
2. 或让**探针包自证**：探针应用自己 `baj` 造包 → 写自己 `files/` → 触发加载 → 截图确认。

**验证入口问题**：`ThemeSelectorActivity` 未导出，`am start` 报
`not exported from uid`。已确认它有内部启动方法
（`PinyinIME.a()Landroid/content/Intent;`，带 `MAIN` + `entry=access_point` extra），
但需从输入法内部路径触发。备选：抓 logcat 确认无主题解析错误 +
观察键盘实际渲染颜色。

### 实测③：最小可行样式表

从原版 `material_light` 的 `style_sheet.binarypb` 提取完整样式表作模板，
运行期只替换颜色值。`style_sheet_tool.py` 已支持这一操作。

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
