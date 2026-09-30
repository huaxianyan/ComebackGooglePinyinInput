# 键盘布局插件化可行性调研：独立 APK 提供布局供输入法读取

> 状态：**调研完成，结论为「部分可行，但存在硬边界」**。未动任何代码。
>
> 起因：用户提出——开关逗号句号归根到底是键盘布局的事，能否做一套键盘布局接口规范，供其他开发者以**独立 APK** 的形式安装到设备，由输入法读取并应用。

## 一、结论先行

| 维度 | 结论 |
| --- | --- |
| 输入法是否有「按包名解析外部资源」的现成机制 | **有**，且是原版自带，就是 `Lang`（`ang`）类 |
| 这套机制原本服务于什么 | 模块资源覆盖（`R` 类所在包名 ≠ 应用包名），**不是**为第三方插件设计的 |
| 第三方 APK 能否被输入法解析 | **不能直接解析**。跨包 `getIdentifier` 在 Android 上无法命中另一个 APK 的资源表 |
| 能否做到「独立 APK 安装、输入法读取」 | **技术上可以，但不是用资源解析**，必须走「APK 内嵌资源 + 解码到自有目录 + 运行时 inflate」的路，属于**要自己造**，不是复用 |
| 是否有现成的插件化先例可抄 | 有，但方向相反：主题包（theme）机制是**同包内资源覆盖**，不是跨 APK |
| 建议 | **不要做成通用插件接口**。需求能用更小的方式满足，见第五节 |

## 二、原版机制的全貌（已实证）

### 2.1 键盘是完全声明式的

一套键盘由多层 XML 声明，代码里**没有任何布局硬编码**：

```text
res/xml/keyboard_zh_cn_pinyin_qwerty.xml     键盘定义
  ├─ <view layout="@layout/keyboard_prime_header" type="header">
  │    ├─ <softkeys href="@xml/softkeys_header_prime" />
  │    └─ <include href="@xml/keymapping_header_zh_cn_pinyin_qwerty" />
  └─ <view layout="@layout/keyboard_qwerty_chinese_body" type="body">
       ├─ <softkeys href="@xml/softkeys_input_zh_cn_pinyin_qwerty" />
       └─ <include href="@xml/keymapping_bottom_zh_cn_pinyin_qwerty" />
```

- `keyboard_prime_bottom.xml` 在 smali 里**搜不到**，它只被 `keyboard_qwerty_body_inner.xml` 用 `<include layout="@layout/keyboard_prime_bottom" />` 引用。布局不是代码常量。
- 软键内容由 `softkeys_*.xml` 定义，带模板参数（`layout="$param_layout$"`），布局是**运行时替换的占位符**，不是编译期常量。
- 共 104 个 `keymapping_*.xml`，全在 `res/xml/`。

### 2.2 `Lang`（`ang`）是双包名回退的资源解析器

`ang.smali` 完整结构：

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| `a:Landroid/content/Context` | 私有 | application context，用于递归 delegate |
| `a:Landroid/content/res/Resources` | 私有 | 构造时取自 `context.getResources()` |
| **`a:Ljava/lang/String`** | **public** | **模块包名，可外部写入** |
| `b:Ljava/lang/String` | 私有 | 自身应用包名，构造时从 `context.getPackageName()` 取 |
| `a:Z` | 私有 | context 是否等于 application context |

解析逻辑（`ang.a(String name, String type)I`）三级回退：

```java
1. 若 a（模块包名）非空 → getIdentifier(name, type, a)
2. 若为 0            → getIdentifier(name, type, b)   // 自身包名
3. 若仍为 0 且 context 存在且非 application context
                     → Lang.a(applicationContext).a(name, type)  // 递归
```

**唯一写入点**：`PinyinApp.a()`（启动回调）第 116–132 行

```java
Lang lang = Lang.a(getApplicationContext());
String pkg = R.class.getPackage().getName();   // 模块包名
lang.a = pkg;
```

`R` 的包名是 `com.google.android.apps.inputmethod.pinyin`，**不等于**应用包名 `com.google.android.inputmethod.pinyin.compat`。所以这套机制的本质是：**同一个 APK 内，让模块包 `R` 与外壳包 `R` 互相兜底**。这是 Google 内部多模块合并的产物，不是插件扩展点。

### 2.3 `Lang` 确实用在 XML 资源名解析上

`awu.smali` 第 400–420 行是决定性证据：

```java
String s = ...;                      // 形如 "xxx.xml"
int i = s.indexOf(".xml");
String name = s.substring(0, i);     // 去掉 ".xml"
int id = Lang.a(context).a(name, "xml");   // 按 xml 类型查 id
if (id == 0) { /* 报错：找不到该资源 */ }
```

即键盘定义里 `href="@xml/xxx"` 这类引用，走的是**按名字动态解析**，会经过 `Lang` 的跨包回退。布局、软键、keymapping 因此都天然支持「包名切换即换资源」。

### 2.4 但 `Lang` 的能力边界是「包名」，不是「跨 APK」

`Resources.getIdentifier(name, type, packageName)` 的行为：只在**当前 Resources 对象所属的 APK** 的资源表里，按 `packageName` 分组查找。

`context.getResources()` 返回的是**本应用 APK 的资源表**。传入别人的包名，只会查不到（返回 0）。Android 没有给 `getIdentifier` 开跨 APK 的口子——这是 `Resources`（AssetManager 层）的安全边界，不是权限问题，加权限也绕不过。

结论：**`Lang` 只能在自己的 APK 内换包名，不能读另一个已安装 APK 的资源。**

## 三、那「独立 APK」到底能不能做

能，但必须放弃「复用 `Lang`」这条捷径，改走下面的路：

### 3.1 技术上可行的架构

```text
插件 APK（com.example.pinyin.layout.xxx）
  └─ 内含标准 Android 资源（layout/*.xml、xml/*.xml），或自定的打包格式
          ↓  谁读？
输入法 APK
  ├─ 方案①：插件包名写入 Lang.a  → 无效（见 2.4）
  ├─ 方案②：createPackageContext(插件包名, CONTEXT_IGNORE_SECURITY)
  │          → 拿到对方的 Resources 对象 → 用它的 getIdentifier / inflate
  │          → 可行，但有硬约束（见下）
  └─ 方案③：插件把布局导出成普通文件（如 XML/JSON）
             + 输入法用 LayoutInflater 的 cloneInContext / 自定义 Factory
             → 可行，工作量最大，但控制力最强
```

**方案② 的硬约束**：
- `createPackageContext` 需要对方包可见。Android 11+ 的包可见性收紧后，必须靠 `<queries>` 声明或 `QUERY_ALL_PACKAGES` 权限。
- 从对方 `Resources` 拿到的 `layout/*.xml`，inflate 出来的 `View` 是**按对方 APK 的样式与字体**解析的，输入法的自定义属性（`@attr/...`、主题 attr）全部取不到默认值，会崩或错位。键盘布局大量使用自有 attr（`PopupBubbleUnderlineOnDecodeLayout`、`LabelAlpha` 等），这条路**基本走不通**。
- 插件 APK 必须与输入法共享 `sharedUserId` 或用相同的资源包 id 分段（`aapt --package-id`），否则资源 id 冲突。

**方案③ 是唯一稳的路**：插件提供的是**数据**（键位表、权重、软键引用名），输入法负责**把它翻译成自己的资源**再 inflate。这等于：插件不能写 Android 布局 XML，只能写自定义 DSL。

### 3.2 与原版机制的落差

| 能力 | 原版 `Lang` | 独立 APK 插件 |
| --- | --- | --- |
| 换包名找资源 | 支持 | 不适用 |
| 跨 APK 读资源 | 不支持 | 需自行实现，且受包可见性限制 |
| 复用键盘自有 attr | 天然支持 | 方案② 不支持，方案③ 需要翻译层 |
| 开发者写 Android 布局 XML | 可以 | 方案③ 只能写自定义 DSL |
| 稳定性 | 框架原生 | 需自己承担全部渲染风险 |

## 四、还有一个更根本的问题：状态位不够分

即使把插件机制做出来，**布局能开放的部分也很有限**。

键盘布局的「显示/隐藏某键」不是布局自己说了算，而是由 `Keyboard.a()J` 算出的 64 位状态掩码驱动 keymapping。当前可用空闲位只有：

- bit 55、58–59、61–63（共 6 位，其中 55、58 已被本项目占用）

也就是只剩 **4 个空闲位**。第三方插件每要一个「按状态切换键位」的能力，就吃掉一个位。而状态位注册有两条硬约束（范围 + 冲突），且是**全局单表**（`Laku;->a:Lkm`）。这意味着：

- 插件数量与状态位容量存在**硬上限**，无法扩展；
- 多个插件若都想加状态位，会互相冲突，且冲突在**输入法启动时**才暴露（抛异常，即崩溃）。

这条约束单独就足以否掉「开放接口给任意第三方」的设计。

## 五、建议

### 5.1 需求本身不需要插件机制

「开关逗号句号」这类需求，本质是**在既有布局上做局部裁剪**。当前项目已经证明：纯布局 + keymapping 就能做到，零 Smali 新增。把它包装成「第三方布局规范」是**用大炮打蚊子**，且会引入三个新风险面（跨包资源、状态位耗尽、渲染失败）。

### 5.2 如果确实想对外开放，推荐的最小形态

不要做「插件 APK 提供布局」，改做**配置化布局**：

| 形态 | 内容 | 代价 |
| --- | --- | --- |
| 最小可用 | 输入法内置若干**布局预设**（保留逗号/隐藏逗号/隐藏句号/全隐藏），用户在设置里选 | 零新机制，就是多做几个开关组合 |
| 进一步 | 设置里导出/导入一份**布局配置 JSON**（哪些键显示、权重分配） | 需要一个解析器 + 校验，不碰跨包 |
| 再进一步 | 允许从文件系统/SAF 读入布局配置 | 仍然只是数据，不碰资源表 |

这条路的好处：

- 不触碰 `Resources` 跨包边界，无包可见性问题；
- 不消耗状态位（配置在布局层生效，不新增 `STATE_*`）；
- 开发者写的是**数据**，出错只影响自己那一份配置，不会让输入法白屏；
- 可以版本化、可以做 schema 校验，符合「接口规范」的诉求。

### 5.3 结论

**「独立 APK 提供键盘布局供输入法读取」在原版框架上不可直接实现**——`Lang` 的跨包回退只在单个 APK 内部换包名，Android 的 `Resources` 不提供跨 APK 资源读取能力。硬做需要自建插件容器（方案③），成本极高、约束极多，且状态位容量不足以支撑开放接口。

**推荐把诉求收敛为「布局配置规范」**：插件/开发者提供的是数据（JSON），输入法负责渲染。这满足「其他开发者能定制布局」的目标，且与现有「纯布局 + keymapping」方向一致，不引入新的渲染风险。

## 六、证据位置

- 解码产物：`work/decoded/`（`smali/ang.smali`、`smali/awu.smali`、`smali/aok.smali`、`smali/com/google/android/apps/inputmethod/pinyin/PinyinApp.smali`）
- 键盘定义与软键模板：`work/decoded/res/xml/keyboard_*.xml`、`softkey_templates_bottom_line.xml`、`softkeys_punctuation_bottom*.xml`
- 本文件只记结论与依据，不含用户数据。
