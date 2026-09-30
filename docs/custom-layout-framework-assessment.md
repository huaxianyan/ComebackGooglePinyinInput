# 自定义键盘布局框架（JSON 导入）：技术评估

> 承接 [自定义布局边界纠正](./custom-layout-boundary-correction.md)。用户提出：加一层框架，支持导入 JSON 定义布局，并在设置里做布局管理（启用/隐藏/删除）。
> 状态：**评估完成，含关键可行性验证。未动代码。**

## 一、结论摘要

| 项 | 评估 |
| --- | --- |
| 技术上是否可行 | **可行**，且比预想的容易——框架里已有现成的拦截点与 XmlPullParser inflate 能力 |
| 工程量 | **大**，属于「新建一个子系统」，不是「打补丁」 |
| 主要风险 | 键盘不是普通 View 树，靠软键 id / keymapping 工作。自建布局要**同时**产出视图树与映射关系，两套东西必须对齐 |
| 建议 | 分三期做，第一期先打通「JSON → 视图树」，验证渲染与点击都正常，再谈管理 UI |

## 二、关键可行性验证（本轮新发现）

### 2.1 已有现成的 LayoutInflater 拦截点

`PinyinIME.a()`（第 179 行）：

```java
protected LayoutInflater a() {
    LayoutInflater base = super.a();
    return new bbc(base);          // ← 输入法自己包装的 inflater
}
```

`bbc` 是 `bar` 的子类（`bar` 继承 `LayoutInflater`），**重写了 inflate 系列方法**：

```java
// bbc.inflate(int resId, ViewGroup parent, boolean attach)
public final View inflate(int id, ViewGroup parent, boolean attach) {
    View v = super.inflate(id, parent, attach);   // 委托真实 inflater
    a(v);                                          // ← 后处理钩子
    return v;
}
```

关键点：**`bbc` 能在 inflate 之后拿到 View 做后处理**，也能在 inflate 之前判断 id。这就是插入自定义布局的天然位置。

而 `GoogleInputMethodService` 缓存的 inflater 正是 `a()` 的返回值（第 1690 / 4774 行），键盘布局就是用这个 inflater 出来的——**路径覆盖到**。

### 2.2 框架自带 XmlPullParser inflate 能力

`bar` / `bbc` 都完整实现了：

```java
public View inflate(XmlPullParser parser, ViewGroup root, boolean attach)
```

也就是说，**Android 原生就支持从一个 XmlPullParser 流 inflate**，不需要资源 id。这与「布局必须走资源 id」并不矛盾——那个约束只针对 `inflate(int resId)` 这个重载。**换成 parser 重载，就能从任意 XML 流构建视图树。**

这是整个方案成立的技术基础。

### 2.3 布局 id 可以在交给 helper 之前被替换

`KeyboardViewHelper.a(ViewGroup)`（第 80 行）：

```java
int layoutId = this.a /* KeyboardViewDef */ .b;      // 第 96 行
this.a = delegate.loadSoftKeyboardView(this, layoutId, container);
```

`KeyboardViewDef;->b:I` 是 `final`，不能事后改。但可以在**它被创建时**换掉——`KeyboardViewDef` 由 `KeyboardDef` 持有，而 `KeyboardDef` 来自解析键盘 XML。若在此处插入「按用户配置改写布局 id」的逻辑，就能让自定义布局进入既有流程。

## 三、为什么「可行」但「工程量大」

### 3.1 键盘不是普通 View 树

一个键盘要能工作，需要**三套东西同时就位**：

| # | 内容 | 谁提供 |
| --- | --- | --- |
| 1 | **视图树**：槽位、权重、层级 | 布局 XML（inflate） |
| 2 | **映射表**：槽位 id → 软键 id | keymapping XML（`KeyMappingDef`） |
| 3 | **软键定义**：软键 id → 行为/外观 | softkeys XML（`SoftKeyDef`） |

用户 JSON 只描述第 1 套（哪些键、怎么排）。**第 2、3 套要么复用现成的，要么也得让用户配。**

这带来一个核心设计问题：**JSON 里引用软键时用什么标识？**

- 用资源 id（`0x7f0f0238`）：不友好，且随版本变化；
- 用资源名（`softkey_bottom_comma_zh`）：需要用 `ang`（`Lang`）按名解析，**可行**（框架自己就这么解析 XML 资源名）；
- 用语义名（`"comma"`）：需要我们自己维护一张语义名 → 资源名的映射表，最友好但工作量大。

**建议用资源名**，与框架既有做法一致，且用户可在 JSON 里直接写 `softkey_*` 名字。

### 3.2 视图树构建有两条路，都要写

| 路径 | 做法 | 难度 |
| --- | --- | --- |
| A. XML 转译 | 把 JSON 转成一段布局 XML 文本 → 用 XmlPullParser inflate | 中。需要自己序列化 XML，且 `@id/...`、`@style/...` 引用要靠 `getIdentifier` 解析 |
| B. 纯代码构建 | 直接用 `SoftKeyView` 构造 View 树，自己设 `LayoutParams.weight` | 中高。要复刻 inflate 时框架做的初始化（style 解析、id 绑定） |

**A 更省事**：转成 XML 后交给框架既有的 inflate 流程，attr 解析、style 应用都由框架完成。代价是要处理 `@...` 引用的解析。

### 3.3 与 keymapping 的对接是最大难点

布局树 inflate 出来后，框架还要按**槽位 id** 找 `SoftKeyDef`：`KeyMappingDef.a(Context, int keyId)`（前面查过的地图表查找）。

所以自定义布局里的槽位 id 必须是**框架认识的那种 id**（`@id/key_pos_bottom_symbol_1` 一类），否则运行时按 id 查不到软键，会抛 `SoftKeyDef 0x%x has not been defined.`。

**结论：JSON 不能自由发明槽位 id，只能复用框架已有的槽位 id。** 这实际上限制得很死——用户能改的是「槽位怎么排、权重多少、要不要显示」，**不能新增槽位名称**。

需要进一步验证：能否用「槽位 id + 软键 id」的组合，让同一个槽位 id 在不同布局里挂不同软键（这正好是 `KeyMappingDef` 的既有能力，映射层可以按布局区分吗？待查）。

### 3.4 缓存要处理

`GoogleInputMethodService.loadSoftKeyboardView` 用 `HashMap<Integer, SoftKeyboardView>` 按 **布局 resId** 缓存。自定义布局没有 resId，需要：

- 用自定义 id 段（如负数）参与缓存；或
- 换一套缓存键（如「布局标识字符串」），改动面更大。

### 3.5 设置 UI 是独立的一块

「布局管理」页面：列表、启用/隐藏、删除、导入。参考现有 `setting_keyboard.xml` 与 `CommonPreferenceFragment` 的做法，属于常规工作量，但牵扯：

- 存储：导入的 JSON 存哪（`SharedPreferences`？内部存储目录？）；
- 校验：JSON schema 校验、非法时的降级；
- 生效：改完要不要重启输入法（布局缓存的存在使这一点必须考虑）。

## 四、工程量粗估

按「能做出来、能用、不太脆弱」的标准：

| 阶段 | 内容 | 相对工作量 |
| --- | --- | --- |
| 一期 | JSON schema 定义 + 解析器 + 转 XML + 接入 inflate 路径 + 缓存处理 | **最大**，占总量的近一半 |
| 二期 | 与 keymapping/软键的对接（按槽位 id 查软键、长按 merge 兼容） | 次大，且**风险最高**（错一处就是白屏或崩溃） |
| 三期 | 设置 UI（列表 / 启用 / 隐藏 / 删除 / 导入导出） | 中等，常规工作 |
| 四期 | 「选择键盘布局」入口接入 + 与既有布局切换机制打通 | 中等 |

**总体量级：这是一个新子系统，不是补丁。** 大致相当于把「一个能用的键盘布局描述格式 + 渲染器 + 管理器」从头做出来。

## 五、主要风险

1. **白屏风险高**：本项目已经因为自造 View（`CommaPeriodToggleKeyView`）导致过除手写外全部键盘白屏，且**日志无异常**。自建布局渲染器的失败模式与此高度相似——一旦视图树或映射对不上，就是白屏，且不好定位。
2. **状态位不够**：如果要按「用户选了哪套自定义布局」切换状态，会消耗 `STATE_*` 位，而只剩 4 个空闲位（bit 59、61–63）。**建议走「换布局 id」而非「加状态位」**，避开这个限制。
3. **升级兼容**：自定义 JSON 引用的软键名若在新版本被改名/删除，布局会崩。需要版本标记 + 降级策略。
4. **安全边界**：JSON 是外部输入，必须严格校验（槽位数量、权重范围、软键名白名单），否则用户一份坏 JSON 可能让输入法不可用。

## 六、建议

### 6.1 先做一个最小验证（强烈建议）

在投入完整方案前，先花小代价验证一件事：**能否让框架 inflate 一段自定义 XML 并正常渲染 + 响应点击。**

具体做法：在 `bbc.inflate` 里对某个特定 id 拦截，改用一个硬编码的 XML 字符串（内容与 `keyboard_prime_bottom.xml` 等价）走 parser 重载。

- 成功 → 整条路打通，再继续做 JSON 与管理 UI；
- 失败 → 及早止损，避免做完才发现渲染层不通。

**这一步的结论决定了后面三期是否值得投入。**

### 6.2 如果要做，分层交付

- 一期只支持「**复用已有软键、重排已有槽位**」，不支持新增槽位类型；
- 二期再考虑更自由的形式。

理由：复用已有槽位 id 才能保证 keymapping 能查到软键（见 3.3），这是**在不改框架的前提下唯一稳的路**。

### 6.3 需要用户先确认的事

1. **自由度的期望**：是「换键、调宽度、调顺序」，还是「想加任意新按键」？后者会显著增加难度（涉及新增软键定义）。
2. **是否接受「只能复用系统已有软键」**这个限制。
3. **JSON 的来源**：只有用户自己写，还是要考虑分享/导入他人文件？后者要加校验与版本处理。
4. **优先级**：这条线是现在就做，还是先把逗号句号开关收尾？

## 七、与既有工作的关系

- 逗号句号开关（当前在做的）是这个框架的**特例**：它只改槽位显隐，用的是状态位 + keymapping。
- 该框架做成后，逗号句号开关可以变成一份内置 JSON 预设。
- **建议顺序**：先收尾逗号句号开关（已验证的技术路径），再做这个框架。避免两条线同时动键盘渲染层。

## 八、证据位置

- `work/decoded/smali/com/google/android/inputmethod/pinyin/PinyinIME.smali:179`（`a()` 返回 `bbc`）
- `work/decoded/smali/bbc.smali:63, 145`（`inflate(int)` 与 `inflate(XmlPullParser)` 重写）
- `work/decoded/smali/bar.smali:87, 101`（`inflate(XmlPullParser, ...)` 实现）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService.smali:1690, 4774`（inflater 缓存）、`:5116`（`loadSoftKeyboardView` + 按 resId 缓存）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/keyboard/KeyboardViewHelper.smali:80-102`（布局 id 读取与委托）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/metadata/KeyMappingDef$a.smali:1390`（`SoftKeyDef 0x%x has not been defined.`）
- 本文件只记结论与依据，不含用户数据。
