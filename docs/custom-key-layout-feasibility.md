# 用户自定义键盘键位：可行边界与实施路径

> 承接 [布局扩展的边界与分层](./keyboard-layout-extensibility-limits.md)。
> 状态：**调研完成，给出可施工的分层路径。未动代码。**

## 一、诉求

逗号句号开关是妥协的产物——它只解决「隐藏」，解决不了「我想换个键位」。用户真正想要的是**自定义键盘键位布局**。

## 二、键位在框架里是怎么定义的（实证）

三层结构，缺一不可：

### 第 1 层：布局（槽位）

`res/layout/keyboard_prime_bottom.xml` 声明**槽位**，每个槽位是一个 `SoftKeyView`，带一个 id 和权重：

```xml
<SoftKeyView android:id="@id/key_pos_switch_to_symbol" android:layout_weight="150.0" ... />
<SoftKeyView android:id="@id/key_pos_bottom_symbol_1"   android:layout_weight="100.0" ... />
<LinearLayout android:layout_weight="500.0">
    <SoftKeyView android:id="@id/key_pos_switch_to_next_language" android:visibility="gone" android:layout_weight="100.0" ... />
    <SoftKeyView android:id="@id/key_pos_space" android:layout_weight="400.0" ... />
</LinearLayout>
<SoftKeyView android:id="@id/key_pos_bottom_symbol_2" android:layout_weight="100.0" ... />
<SoftKeyView android:id="@id/key_pos_ime_action"      android:layout_weight="150.0" ... />
```

槽位 id 是**编译期资源 id**，布局里只能出现本 APK 的资源。

### 第 2 层：keymapping（槽位 → 软键）

`res/xml/keymapping_bottom_zh_cn_symbol.xml`：

```xml
<key_mapping>
    <mapping view_id="@id/key_pos_bottom_symbol_1" key_id="@id/softkey_bottom_comma_zh_popup_settings" />
    <mapping view_id="@id/key_pos_bottom_symbol_2" key_id="@id/softkey_bottom_sentence_zh_popup_punctuation" />
</key_mapping>
```

`view_id` 对**槽位**，`key_id` 对**软键定义**（`softkeys_*.xml` 里的 `<softkey id="@id/...">`）。

### 第 3 层：软键定义（软键 → 行为）

`res/xml/softkeys_punctuation_bottom_zh.xml`：

```xml
<softkey id="@id/softkey_bottom_comma_zh" layout="@layout/softkey_label_medium_bottom" ...>
    <action type="PRESS" keycode="PLAIN_TEXT" intention="COMMIT" data="，" />
    <label location="@id/label_bottom" value="，" />
</softkey>
```

**键位 = 槽位（含权重与位置） + 映射（槽位指向哪个软键）。**「自定义键位」就是改这两样。

## 三、框架其实支持运行时重建映射表

这是**好消息**，也是可行性所在。

`KeyMappingDef` 有 Builder 模式（`KeyMappingDef$a`）：

```java
KeyMappingDef.a(false)                            // 建 Builder
builder.a(viewId, softKeyDef, long[] stateMask)   // 逐条加映射
builder.a()                                       // build 出不可变 KeyMappingDef
```

**框架自己就在运行期这么干**：`SoftKeyViewsMapper$MergeMultiLingualKeyMappingDefTask.doInBackground()` 会遍历现有映射，用 Builder 重建一份新的（跨语言键盘合并时用）。说明「运行期换一份键位映射表」是**框架既有能力**，不是我们要发明的东西。

## 四、但入口全部是资源 id（硬边界）

`SimpleXmlParser.a(Context, int resId)`（`SimpleXmlParser.smali` 第 37 行）：

```java
public static SimpleXmlParser a(Context c, int resId) {
    if (c == null || resId == 0) throw new IllegalArgumentException();
    SimpleXmlParser p = new SimpleXmlParser();
    p.a = new Laob(c, resId);        // ← 唯一的输入入口就是这个 resId
    p.a = c;
    return p;
}
```

**整个键盘配置链（布局、软键、keymapping）的解析入口全部是资源 id。** 没有任何一处接受文件路径或 `InputStream`。

由此得到结论：

| 想做的事 | 是否可行 | 原因 |
| --- | --- | --- |
| 用户改配置 → 运行期生效 | **可行** | 配置是**数据**，由我们自己解析，不经过 `SimpleXmlParser` |
| 用户提供一份布局 XML 文件 → 直接加载 | **不可行** | 解析入口是资源 id，文件进不来 |
| 用户提供一份 keymapping XML 文件 → 直接加载 | **不可行** | 同上 |
| 用户改键位映射 → 运行期重建映射表 | **可行** | Builder 是框架既有能力，用 SoftKeyDef 对象直接构造，不碰 XML |

**分水岭**：能表达为「对既有软键定义的重新组合」的，就能做；需要「引入新的布局/新软键 XML」的，就得进资源表。

## 五、可施工的分层路径

### 第 1 层：槽位显隐 + 权重（已设计，零新增机制）

即当前逗号句号开关。改的是槽位 `visibility` 与权重分配，走 keymapping 状态位。**能解决「我不想要这个键」，解决不了「我想换成别的键」。**

### 第 2 层：槽位 → 软键 的重新映射（推荐，性价比最高）

**这是真正能做到「用户自己排键位」的最小可行方案。**

原理：`view_id → key_id` 是一个映射表，可在运行期用 Builder 重建。所以只要：

1. 把底部行每个槽位的**可选软键**列出来（例如 `key_pos_bottom_symbol_1` 可以放：全角逗号 / 半角逗号 / 顿号 / 自定义字符 / 空）；
2. 让用户在设置里为每个槽位挑一个；
3. 运行时按用户选择，用 `KeyMappingDef$a` 重建映射表并替换。

**可行性依据**：
- `SoftKeyDef` 对象本身有 `a:I`（软键 id）等字段，可以按 id 取出已有定义再重新挂到别的槽位上；
- Builder 已存在，框架自己就在用；
- **不需要新增任何资源**，纯运行期对象重排。

**能实现的效果举例**：

| 用户想要的 | 第 2 层能否做到 |
| --- | --- |
| 把逗号换成顿号 | 能（如果顿号软键已存在） |
| 逗号句号位置对调 | 能 |
| 把某个槽位换成「切到符号键盘」 | 能（复用已有 `softkey_switch_to_non_prime_keyboard`） |
| 屏蔽某个槽位 | 能（映射到 `softkey_empty`） |
| 空格键左右各加一个键 | **不能**，槽位数量是布局定死的 |
| 把两个槽位合并成一个宽键 | **不能**，同前 |

**边界要讲清楚**：第 2 层改的是「每个既定槽位里放什么」，**不是「有几个槽位」**。槽位数量、排列顺序、权重分布由布局决定，属于第 3 层。

### 第 3 层：槽位布局本身（权重、顺序、数量）

要改槽位的数量、顺序、权重，就必须改布局 XML。布局 XML 的 inflate 入口是资源 id（`getAttributeResourceValue`），**因此必须进资源表，必须重新打包输入法**。

能做的最接近的形态：**在布局里预置若干「备用槽位」**（`visibility="gone"`、权重 0），用户想启用时把它显出来并分配权重。

- 优点：用户可感知的「自定义」范围能明显扩大；
- 代价：布局被预置槽位撑大，且每个备用槽位的权重分配需要运行时改写（**这正是本轮白屏的做法**，风险已知）。

**建议不做**，除非第 2 层验证后确实不够用。

## 六、实施建议

### 6.1 先做第 2 层

理由：

1. 它是「用户自己排键位」中**唯一不需要重新打包、不新增资源、不新增状态位**的形态；
2. 复用的是框架既有的 Builder 与映射表机制，风险可控；
3. 能覆盖绝大多数真实诉求（换键、对调、屏蔽、复用功能键）。

### 6.2 第 2 层的施工前必须确认的事

1. **可映射软键的枚举范围**：是所有已定义的 `softkey_*`，还是限定一个白名单？
2. **作用范围**：全局，还是按语言（中文/英文）分别配置？
3. **槽位启用条件**：某些槽位受输入类型约束（`INPUT_TYPE_URI` 下逗号位是 `/`），用户配置要不要覆盖它？
4. **冲突处理**：同一个软键被映射到多个槽位时，长按 merge 会不会打架（参考逗号长按表情的 merge 机制）？
5. **UI 形态**：设置页做下拉选择，还是仅支持导入导出配置？
6. **恢复默认**：必须有，且要能一键回到原版几何。

### 6.3 与现有工作的关系

- 逗号句号开关（第 1 层）：作为「预设」保留，是第 2 层的一个特例。
- 第 2 层做成后，逗号句号开关可以理解为「把两个槽位映射到 `softkey_empty`」的快捷方式，两者不冲突。

## 七、结论

**「用户自定义键位」可以做到「每个槽位放什么键」，做不到「槽位本身怎么排」——除非重新打包输入法。**

- 前者（第 2 层）是运行期重建 `KeyMappingDef` 映射表，框架既有能力支持，**推荐实施**；
- 后者（第 3 层）受资源 id 入口约束，必须进输入法资源表，只能作为 PR 合入主干。

## 八、证据位置

- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/metadata/KeyMappingDef$a.smali`（Builder 与 `a(ILSoftKeyDef;[J)`）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyViewsMapper$MergeMultiLingualKeyMappingDefTask.smali`（框架运行期重建映射表）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/SimpleXmlParser.smali`（`a(Context, int)` 资源 id 入口）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/metadata/KeyboardViewDef$a.smali`（`getAttributeResourceValue`）
- `work/decoded/res/layout/keyboard_prime_bottom.xml`、`res/xml/keymapping_bottom_zh_cn_symbol.xml`、`res/xml/softkeys_punctuation_bottom_zh.xml`
- 本文件只记结论与依据，不含用户数据。
