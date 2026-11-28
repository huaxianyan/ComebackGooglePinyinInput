# 给快捷入口栏加自定义入口

记录悬浮键盘入口是怎么接进去的，以及为什么要走这条路。

## 结论

不需要自绘、不碰 smali 的业务逻辑：原生 `init_access_points` 数组里每一项是一个
style，`GoogleInputMethodService` 启动时遍历它、把每项解析成入口定义并注册。加一个
style、写进数组，注册、排序、动画、无障碍、图标染色全部由原生完成。只有点击需要接代码。

## 原生结构

`GoogleInputMethodService.a(Configuration)` 里：

```
obtainTypedArray(R.array.init_access_points)   →  每项是一个 style 资源
  → AccessPointsManager->a:Laoo  (builder)  reset
  → Laoo.a(context, styleRes)
  → Laoo.a() → Laon            (入口定义)
  → AccessPointsManager.a(Laon)  (注册)
```

`Laon`（入口定义）的字段来自 6 个属性：

| 属性 | 字段 | 说明 |
| --- | --- | --- |
| `apStringId` | `a:String` | 入口 id 字符串，点击时按它分发 |
| `apIcon` | `a:I` | 常态图标 |
| `apCloseIcon` | `b:I` | 关闭态图标（可省） |
| `apLabel` | `b:String` | 标签 |
| `apHighlighted` | `a:Z` | 是否保持高亮选中 |
| `apContentDescription` | `c:String` | 无障碍描述 |

属性数组是 `R$a.b`，对应 `apStringId`、`apIcon`、`apCloseIcon`、`apLabel`、
`apHighlighted`、`apContentDescription`。

## 加一个入口

`scripts/access_point_patches.py` 做四件事：

1. `strings.xml` 加 `id_access_point_floating`、`label_access_point_floating`、
   `access_point_floating_content_desc`
2. `styles.xml` 加 `FloatingAccessPoint` style
3. `arrays.xml` 的 `init_access_points` 加 `<item>@style/FloatingAccessPoint</item>`
4. 加矢量图标 `res/drawable/ic_access_point_floating.xml`

图标用固定 drawable 而不是 `?主题属性`：主题属性要求每个主题都定义同名值，漏一个就解析成
空。bar 会给图标统一染色，所以白色矢量在深浅主题下都是对的颜色。

`apHighlighted` 不写，入口是一次性动作，不保持选中态，正好符合开关语义。

## 点击处理

`AccessPointsManager.a(IAccessPointFeatureHandler)` 注册处理器，bar 把 id 交给每个
处理器直到有一个认领：

```java
public interface IAccessPointFeatureHandler {
    boolean closeFeature(String id);
    boolean launchFeature(String id, Map<String, Object> args);
}
```

`FloatingAccessPointHandler` 实现它：id 对得上就翻转悬浮开关，返回 `true`；否则返回
`false` 让别的处理器接手。

注册点在 `GoogleInputMethodService` 建完 manager 之后（`a(Configuration)` 的 `:cond_2`），
因为那个方法每次配置变化都会跑，注册用静态标志防重。

编译时 `IAccessPointFeatureHandler` 是应用自己的类，Java 侧引用需要 stub：
`generate_floating_keyboard_smali.py` 生成一份只含接口的 stub 给 javac，不打包。

## 排序与开关

`AccessPointsOrder.apply()` 早就在改这个列表（用户配置的顺序与开关）。新 id 不在用户
配置里时会被追加到末尾并保留，不需要额外处理。

它在悬浮开启时还会摘掉单手入口：两者互斥，单手模式调整的是停靠键盘，卡片本身已经可移动。

## 踩过的坑

- **别按 contentDescription 隐藏入口**：原生入口描述和猜测差得远（工具栏单手入口是
  `One handed mode`，不是 `left_handed_content_desc`）。按 id 走列表更稳。
- **bar 可能折叠**：默认只显示一个箭头，点开才是图标行。验证入口是否存在时先确认 bar 形态，
  否则会误判成没生效。
- **停靠键盘不显示 bar**：悬浮卡片里 bar 也是一行图标，位置随卡片。对照实验时用同一形态比。
