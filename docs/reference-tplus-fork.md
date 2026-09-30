# 参考实现调研：Tback-google-pinyin-input（T+ 双字母布局）

> 仓库：<https://github.com/JunperoH/Tback-google-pinyin-input>
> 状态：`master`，最近提交 `b38f78a`（2026-09-01，`merge: port T+ 2.1.0 onto upstream v2.0.10`）

## 一、这是什么

基于上游 [ComebackGooglePinyinInput](https://github.com/huaxianyan/ComebackGooglePinyinInput) 2.0.10 的个人 fork。在 **同一份 Google 拼音 4.5.2 原始 APK** 上，用同样的「固定原始 APK + 资源/Smali 补丁」流水线，**独立重建了触宝 T+ 双字母全键布局**，并保留上游对 Android 15/16、Compose Material 3 设置、统一 Header、Inline Autofill 的兼容更新。

关键点：**它和我们走的是同一条技术路线**——不是源码重建，是 `original/` + `patches/` + `scripts/` 的补丁式改造。因此它的做法对我们有直接参考价值。

```
QW  ER  TY  UI  OP
AS  DF  GH  JK  L-
    ZX  CV  BN  M'
```

一个按键容纳两个相邻字母，点按两个字母同权交给 HMM 引擎按上下文消歧；短滑左/右明确输入其中一个；长按弹数字/标点/大小写。

T+ 注册为 `zh_cn_pinyin_tplus`，**与 QWERTY、九键、笔画、手写并列出现在原生键盘布局选择页**——这正是用户想要的「在选择键盘布局里可以看到」。

## 二、他们改了哪些文件

**核心结论：新增一整套布局，只靠资源文件 + 一个 IME 注册 XML，没有修改 `KeyboardViewDef`、没有新增状态位、没有重写 inflate。**

| 层 | 文件 | 说明 |
| --- | --- | --- |
| 键盘定义 | `patches/res/xml/keyboard_zh_cn_pinyin_tplus.xml` | 声明 header + body 两个 view，各挂 softkeys / keymapping / motion_event_handler |
| 布局槽位 | `patches/res/layout/keyboard_tplus_input_area.xml` | 3 行 `LinearLayout`，全 `SoftKeyView` |
| 容器 | `keyboard_tplus_chinese_body.xml`、`keyboard_tplus_body_inner.xml` | 根是 `SoftKeyboardView` |
| 映射表 | `patches/res/xml/keymapping_body_zh_cn_pinyin_tplus.xml` | 15 条基础映射 + SHIFT / SHIFT_LOCK / COMPOSING 状态映射 |
| 软键定义 | `patches/res/xml/softkeys_input_zh_cn_pinyin_tplus.xml` | 10 KB，键内容 / 标签 / 长按 |
| **id 与字符串** | `patches/res/values/tplus.xml` | **纯 `<item type="id">` 声明区** |
| IME 注册 | `patches/res/xml/ime_zh_cn_pinyin_tplus.xml` | 绑定 label、keyboard_group、processors |
| 本地化 | `values-zh-rCN/tplus.xml`、`values-zh-rTW/tplus.xml` | 两行，只覆盖 label |

### 2.1 槽位布局（`keyboard_tplus_input_area.xml` 节选）

```xml
<LinearLayout style="@style/KeyboardRow">
    <SoftKeyView android:id="@id/key_pos_tplus_qw" android:layout_weight="200.0" style="@style/SoftKey.BigInset" />
    ...
</LinearLayout>
```

**和我们的布局是同一套写法**——`SoftKeyView` + `@id` + `layout_weight`。权重用 200/150/100 这种比例值，不是我们的 1000 总量制，但机制完全一致。

### 2.2 三层 id 声明（`tplus.xml`）

```xml
<item type="id" name="keyboard_zh_cn_pinyin_tplus" />
<item type="id" name="key_pos_tplus_qw" />      <!-- 槽位 id，14 个 -->
<item type="id" name="softkey_tplus_qw" />      <!-- 软键 id，14 个 -->
<item type="id" name="softkey_tplus_up_qw" />   <!-- 大写软键 id，14 个 -->
```

**这三个 id 池必须成组出现，缺一即运行期抛异常**——这正是我们在评估文档里写的「三套东西必须同时就位」。

### 2.3 映射表结构

```xml
<key_mapping>
    <mapping view_id="@id/key_pos_tplus_qw" key_id="@id/softkey_tplus_qw" />
    ...
</key_mapping>
<key_mapping state="SHIFT"> ... </key_mapping>
<key_mapping state="SHIFT_LOCK"> ... </key_mapping>
```

`state="COMPOSING"` / `"SHIFT"` / `"SHIFT_LOCK"` / `"COMPOSING+SHIFT_LOCK"` —— **同一槽位在不同状态下映射到不同软键**。这是原版既有机制，T+ 直接复用。

## 三、对我们要点最大的三处启发

### 启发 1：他们复用了 `keyboard_prime_bottom.xml`

`keyboard_tplus_body_inner.xml` 全文只有两个 include：

```xml
<LinearLayout android:id="@id/input_area" style="@style.BodyInner">
    <include layout="@layout/keyboard_tplus_input_area" />
    <include layout="@layout/keyboard_prime_bottom" />
</LinearLayout>
```

**那一行 `keyboard_prime_bottom` 就是我们的目标文件。** 说明：

- 底部行的槽位 id 池是**跨布局共享的全局资源**，不是某个布局私有的。
- 我们想让逗号/句号独立显示的开关，改的正是这个共享文件的 `visibility`——**改动面比想象中小得多**。
- 更重要的是：**对「用户导入 JSON 自定义布局」方案，这条事实是正面证据**。JSON 不需要发明新槽位 id，只需重新组合既有 id 池。我们评估文档里那句「槽位 id 必须复用既有」的限制，在其上限之内**其实容得下相当大的自由度**——换顺序、换位置、换宽度、隐藏，都在能力范围内。

### 启发 2：资源 id 可以静态固化

他们有一个专门的脚本对：

- `scripts/generate_stable_resource_ids.py`（1.9 KB）
- `scripts/verify_stable_resource_ids.py`（1.6 KB）

**目的**：让每次重建生成同一套资源 id，避免资源表重排导致已编译的 smali 引用失效。

这正是我们那个「布局 id 由 `getAttributeResourceValue` 取编译期常量」问题的**正面解法**。如果要走 JSON 布局框架，这个思路可以直接拿来用——**给自定义布局预留一段固定 id 区间**。

### 启发 3：他们确实用了自定义 KeyView 子类，但条件不同

`patches/java/com/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView.java`（5.2 KB），配套：

- `scripts/generate_simplified_traditional_toggle_smali.py`（3.7 KB）
- `scripts/verify_simplified_traditional_header_toggle.py`（9.5 KB 门禁）

这个类 `extends SoftKeyView`，实现在 header 里按设置和可用空间动态显示/隐藏。

**对照我们白屏的 `CommaPeriodToggleKeyView`**：

| | 他们 | 我们（已废弃） |
| --- | --- | --- |
| 位置 | header（候选栏） | 键盘主体底部行 |
| 继承 | `extends SoftKeyView` | 同类做法 |
| 配套 | 生成脚本 + 9.5 KB 门禁 + 验证 | 无门禁 |
| 结果 | 跑通 | 白屏 |

**结论**：自定义 KeyView 子类不是绝对禁区，但门槛在「**继承 `SoftKeyView` + 生成脚本 + 静态门禁 + 设备验证**」四件套都齐。我们当时只做了第一步，这是白屏的深层原因。

## 四、他们没做什么（同样重要）

- **没有改 `KeyboardViewDef`**：布局 id 仍是编译期资源 id，走完全正常的解析路径。
- **没有新增状态位**：T+ 是独立 IME（`zh_cn_pinyin_tplus`），不是给现有布局加状态。这一点我们做不到——加逗号句号开关会占状态位，而只剩 4 个空闲。
- **没有运行期改布局**：布局是静态 XML，`SoftKeyView` 的权重完全来自布局。

也就是说，**他们的方案是「新增一整套静态布局」，不是「让布局可配置」**。这提示了一条务实路线：与其做通用 JSON 框架，不如**内置几套完整布局**（T+ 就是这么干的）。

## 五、可直接借鉴的工程实践

| 做法 | 文件 | 价值 |
| --- | --- | --- |
| 资源 id 固化 | `generate_stable_resource_ids.py` | 解决编译期 id 失效 |
| 布局专项门禁 | `verify_tplus.py`（11.8 KB） | 26 字母位、pair action、视觉顺序、IME 注册、双解码分支全静态校验 |
| 验证矩阵文档化 | `docs/touchpal-tplus-port.md` | 逐条列验收项（安装→激活→选择→长按→手势→覆盖升级） |
| 单一发布身份 | `version.properties` | 版本号唯一来源 |
| CI 全门禁 | `.github/workflows` | 上游门禁 + T+/Stroke 专项并行 |

`verify_tplus.py` 尤其值得学：它把「布局是否真的按预期生成」变成**可在 CI 里跑失败的静态断言**，而不是靠人肉看截图。我们本项目已经吃过一次「看截图误判」的亏，这条直接对症。

## 六、对我们结论的修正

| 原判断 | 修正后 |
| --- | --- |
| 「布局在编译期固化 → 用户自定义布局不可行」 | **弱化**。布局仍进资源表，但**复用既有槽位 id 池 + 只重组不自造**时，JSON 描述可行，且不膨胀（新增的是数据，不是资源） |
| 「新增一整套布局必须重打包、成本高」 | **下调**。T+ 一整套布局的资源量是几十个 XML，可完全脚本化生成 |
| 「自定义 KeyView 子类不可行」 | **限定**。可行，但需继承 `SoftKeyView` + 生成脚本 + 静态门禁 + 设备验证四件套 |
| 「独立 APK 提供布局不可行」 | **不变**。跨 APK 资源表边界仍然成立 |

## 七、下一步建议

1. **立刻可用**：把 `verify_tplus.py` 的「布局静态断言」思路搬过来，给逗号句号开关写布局门禁（正好对应待办里的门禁第 7、8 条）。
2. **优先级中**：研究 `generate_stable_resource_ids.py`，评估能否为 JSON 布局框架预留固定 id 区间。
3. **优先级中**：若最终决定做 JSON 框架，**先照 T+ 的样子手工新建一套静态布局验证全链路**（几小时工作量），跑通再上 JSON。这比直接硬编码 XML 字符串探针更接近真实路径。
4. **不变**：逗号句号开关的纯布局修复仍是第一优先，它和 JSON 框架是两件事。

## 附：仓库结构对照

| 目录 | 用途 |
| --- | --- |
| `original/` | 已校验的 Google 拼音 4.5.2 arm64-v8a 原始 APK |
| `patches/java/` | Java 补丁源码（编译进 smali） |
| `patches/res/` | 资源补丁 |
| `patches/smali/` | 直接注入的 smali |
| `modern-settings/` | API 35+ Compose Material 3 设置运行时 |
| `scripts/` | 补丁、构建、生成、门禁脚本 |
| `docs/` | 设计、研究、验收、发布记录 |

与我们仓库结构高度一致（`original/` + `patches/` + `scripts/` + `docs/`），说明上游社区已形成事实标准。
