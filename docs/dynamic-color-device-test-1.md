# 动态配色真机实测①：系统动态色读取

实测设备：Pixel 10 Pro（`blazer`，`59271FDCH002F9`），Android 16 / API 36。
接入方式（重要，见文末）：`ADB_SERVER_SOCKET=tcp:10.77.7.79:15037`。

**实测状态：已通过，100% 命中。**

---

## 〇、实测结果（应用进程内取色）

探针为独立 Activity（`com.example.dynamiccolorprobe`），在应用进程内执行
`Resources.getIdentifier(name, "color", "android")` + `getColor(id, theme)`。

| 测试组 | 结果 |
| --- | --- |
| A. 语义色 18 个（`system_primary_light` 等） | **18/18 命中** |
| B. 色阶色 `_dark`（10 个） | **10/10 命中** |
| B. 色阶色 `_light`（10 个） | **10/10 命中** |
| B. 色阶色裸名（10 个） | **10/10 命中** |
| C. 不带 Theme 的 `getColor(resId)` | **可读** |

实测输出节选：

```
sdk=36 release=16 pkg=com.example.dynamiccolorprobe
config.uiMode=0x21

--- A. semantic colors by resource name ---
system_primary_light                   = #FF5A5E6C  (id=0x1060060)
system_on_primary_light                = #FFF7F7FF  (id=0x1060061)
system_primary_container_light         = #FFDEE2F2  (id=0x106005e)
system_on_primary_container_light      = #FF4D515F  (id=0x106005f)
system_secondary_container_light       = #FFE2E2E9  (id=0x1060062)
system_background_light                = #FFFCF8F9  (id=0x106006a)
system_surface_light                   = #FFFCF8F9  (id=0x106006c)
system_surface_container_light         = #FFF0EDEF  (id=0x1060070)
system_surface_container_high_light    = #FFEAE7EA  (id=0x1060071)
system_surface_variant_light           = #FFE4E2E5  (id=0x1060075)
system_primary_dark                    = #FFC2C6D6  (id=0x106008b)
system_on_primary_dark                 = #FF3B404D  (id=0x106008c)
system_primary_container_dark          = #FF424754  (id=0x1060089)
system_on_primary_container_dark       = #FFCCD0E0  (id=0x106008a)
system_secondary_container_dark        = #FF3A3B41  (id=0x106008d)
system_background_dark                 = #FF0E0E0F  (id=0x1060095)
system_surface_dark                    = #FF0E0E0F  (id=0x1060097)
system_surface_container_dark          = #FF19191B  (id=0x106009b)
semantic hit=18/18

--- B. tone colors (bare / _dark / _light) ---
[bare]  system_accent1_100      = #FFDEE2F2  (id=0x106003a)
[dark]  system_accent1_100_dark = #FFDEE2F2  (id=0x10603be)
[light] system_accent1_100_light= #FFDEE2F2  (id=0x10603bf)
[bare]  system_neutral1_100     = #FFE5E2E2  (id=0x1060020)
[dark]  system_neutral1_100_dark= #FFE5E2E2  (id=0x1060435)
[light] system_neutral1_100_light=#FFE5E2E2  (id=0x1060436)
tone bare=10/10 dark=10/10 light=10/10

--- C. getColor(resId) without Theme ---
system_primary_light     (no theme) = #FF5A5E6C
system_neutral1_100_dark (no theme) = #FFE5E2E2
```

### 一个关键现象：裸名与 `_light` / `_dark` 同值

```
[bare]  system_accent1_100       = #FFDEE2F2  (id=0x106003a)
[dark]  system_accent1_100_dark  = #FFDEE2F2  (id=0x10603be)
[light] system_accent1_100_light = #FFDEE2F2  (id=0x10603bf)
```

三者数值相同（当前 `spritz` 预设色系下 accent1 深浅调色板一致），
但 **id 是三个不同的资源**。

**含义**：`_light` / `_dark` 是独立资源，可取指定的一套，**不依赖当前
`uiMode`**。这正好适配我们的「浅色槽 / 深色槽」双槽设计 —— 可以主动
指定要哪一套，而不必被动跟随系统深浅色。

### 探针实现要点（可复用）

- 独立 Activity 即可，**不需要 Instrumentation**（Instrumentation 要求与
  目标包同签名，会被 `SecurityException` 拒绝）。
- 工具链：`javac`（JDK 11，`-encoding UTF-8`）→ `d8 --min-api 23` →
  `aapt package` → `zip -j` 塞 dex → 签名 → `adb install` → `am start` → 收 logcat。
- **签名必须用 JDK 17**：JDK 11 读不了新版 PKCS12 keystore，报
  `NoSuchAlgorithmException: Algorithm HmacPBESHA256 not available`。
- `uber-apk-signer` 的 `-o` 与 `--overwrite` 不能同时用；用 `--overwrite`
  时是原地签名，文件路径不变。
- javac 默认按本地编码（GBK）读源文件，中文注释会报错；用
  `-encoding UTF-8`，或源码保持纯 ASCII。

---

## 一、结论速览

**实测推翻了此前验证文档的一个关键假设，但同时给出了更好的实现路径。**

| 项 | 此前调研结论 | 真机实测结论 |
| --- | --- | --- |
| 资源 id | 跨版本稳定，可硬编码 | **不成立**，真机 id 段与 android.jar 完全不同 |
| 资源形态 | 单一 `system_accent1_100` | **拆成 `_dark` / `_light` 两个独立资源** |
| 是否需自算配色 | 可能需移植 Material Color Utilities | **不需要**，系统已算好语义色 |

**新的实现路径：按资源名取色，且直接用系统的语义色（primary / surface / container 系列），无需自己做色阶推导。**

---

## 二、实测证据

### 2.1 设备动态配色能力

```
$ adb shell getprop ro.build.version.sdk
36

$ adb shell settings get secure theme_customization_overlay_packages
{"android.theme.customization.system_palette":"9A9EAD",
 "android.theme.customization.accent_color":"9A9EAD",
 "android.theme.customization.color_source":"preset",
 "android.theme.customization.theme_style":"SPRITZ"}

$ adb shell cmd overlay list | grep -iE "accent|neutral|dynamic"
[x] com.android.systemui:neutral
[x] com.android.systemui:accent
[x] com.android.systemui:dynamic
```

系统运行期已算出具体色值（种子色 `9A9EAD`），三个 overlay 全部启用。

### 2.2 资源 id 与调研记录不一致（关键）

```
此前记录：system_accent1_0 = 0x01060037
真机实测：0x01060037 不存在；accent1 实际起始于 0x010603ba
```

真机 id 布局：

| palette | overlay | id 段起点 | 映射条数 |
| --- | --- | --- | --- |
| accent1 | `com.android.systemui:accent` | `0x010603ba` | 78 |
| neutral1 | `com.android.systemui:neutral` | `0x01060431` | 78 |
| 语义色 | `com.android.systemui:dynamic` | `0x0106005e` | 176 |

**结论：android.jar 里的 id 是编译期符号表，真机 framework 资源表 id 是运行时分配的，两者不可等同。硬编码 id 的方案作废。**

### 2.3 资源形态：按深浅色拆分

```
0x010603ba -> color 0xffffffff (color/system_accent1_0_dark)
0x010603bb -> color 0xffffffff (color/system_accent1_0_light)
0x010603be -> color 0xffdee2f2 (color/system_accent1_100_dark)
0x010603bf -> color 0xffdee2f2 (color/system_accent1_100_light)
0x01060431 -> color 0xffffffff (color/system_neutral1_0_dark)
0x01060435 -> color 0xffe5e2e2 (color/system_neutral1_100_dark)
```

**好处：深浅色已经由系统分好，正好对应我们的「浅色槽 / 深色槽」，不需要自己按主题判断该取哪一档。**

### 2.4 系统语义色现成可用（最大利好）

`com.android.systemui:dynamic` overlay 提供完整的 Material You 语义色：

```
浅色：
  system_primary_light                     = 0xff5a5e6c
  system_on_primary_light                  = 0xfff7f7ff
  system_primary_container_light           = 0xffdee2f2
  system_on_primary_container_light        = 0xff4d515f
  system_secondary_container_light         = 0xffe2e2e9
  system_background_light                  = 0xfffcf8f9
  system_surface_light                     = 0xfffcf8f9
  system_surface_container_low_light       = 0xfff6f3f4
  system_surface_container_light           = 0xfff0edef
  system_surface_container_high_light      = 0xffeae7ea
  system_surface_container_highest_light   = 0xffe4e2e5
  system_surface_variant_light             = 0xffe4e2e5
  system_surface_dim_light                 = 0xffdbd9dd

深色：
  system_primary_dark                      = 0xffc2c6d6
  system_on_primary_dark                   = 0xff3b404d
  system_primary_container_dark            = 0xff424754
  system_on_primary_container_dark         = 0xffccd0e0
  system_secondary_container_dark          = 0xff3a3b41
```

**这意味着「色阶 → 键盘色槽」的映射工作量大减**：系统已经把 Material You 语义算完了，我们只需决定「键盘的哪个部位用哪个语义色」。

---

## 三、对方案的影响

### 3.1 作废的部分

- ❌ 硬编码 framework 资源 id（`0x01060037` 等）—— 真机 id 段不同
- ❌ 移植 Material Color Utilities 做色阶推导 —— 系统已算好

### 3.2 成立的部分

- ✅ 降级判据 `API >= 31` 不变（本机 36，走动态分支）
- ✅ `baj` 运行期造主题包 + `files:` 通路 —— 与本步无关，不受影响
- ✅ 架构上 `SLOT_DYNAMIC` 第四槽 —— 不变
- ✅ AndroidX-free 约束 —— 不变

### 3.3 新的取色路径（**已实测通过**）

按**资源名**取色，而非 id：

```java
// 平台 API，AndroidX-free
Resources r = context.getResources();
int id = r.getIdentifier("system_primary_light", "color", "android");
if (id != 0) {
    int color = r.getColor(id, context.getTheme());   // API 23+
}
```

`getIdentifier` 的开销可以用静态缓存规避（取一次存起来）。

**已实测确认**：语义色名与色阶色名在应用进程内均可取到，全部命中（见第〇节）。

---

## 四、遗留问题

1. **`color_source=preset`** —— 本机当前用的是「预设配色」而非「壁纸取色」。
   需验证切到壁纸取色后色值是否跟着变（确认真的动态）。
   *风险低：`_dark` / `_light` 资源由系统 overlay 提供，壁纸取色只是换 overlay 内容。*
2. **id 是否随版本/设备变化** —— 本机只有一个版本，无法跨版本对比。
   因此**方案必须走资源名，不能走 id**（本步已确认资源名可靠）。
3. **降级路径无法真机验证** —— 手头只有 Android 16 设备，`API < 31` 分支
   只能用静态审查 + 代码分支保证（用户已确认不作为验收障碍）。

---

## 五、下一步

实测②：**代码造的主题包能否被加载渲染**（地基，不需要颜色算法）。
计划做法：用 `baj` 构造一个最小主题包，颜色值直接取本步实测到的
`system_primary_light` 等，写入 `files:` 目录，验证键盘能否渲染出该颜色。

---

## 五、附：设备接入方式（踩坑记录）

**错误做法**（会导致设备永远 `offline`）：

```
adb connect 10.77.7.79:15037
```

`adb connect` 的语义是「连接一台设备」，而转发器暴露的是**一整个 ADB server**。两者语义不匹配，表现为 TCP 通、握手「成功」、设备却始终 `offline`。

**正确做法**：

```
adb -H 10.77.7.79 -P 15037 devices
# 或
export ADB_SERVER_SOCKET=tcp:10.77.7.79:15037
adb devices
```

改用正确方式后一次连通。
