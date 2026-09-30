# 用户自定义键盘布局：边界纠正与真正的结论

> 承接 [用户自定义键位：可行边界与实施路径](./custom-key-layout-feasibility.md)。
> **本文件纠正上一版的说法。** 上一版把「映射层自定义」当成了答案，用户指出那不够——用户要的是**布局改变**，不是换键内容。用户是对的。

## 一、上一版的判断失误

上一版推荐「运行期重建 `KeyMappingDef` 映射表」，能做换键、对调、屏蔽。但：

- 那些改的是**「每个槽位里放什么」**；
- 用户要的是**「键怎么排、有几个、多宽」**。

**这是两件事。** 映射层方案给不了布局变化，把它当作「用户自定义键位」的答案是范围不足。用户否掉它是正确的。

## 二、布局层为什么动不了（完整证据链）

### 2.1 布局由一次 inflate 整体生成

`GoogleInputMethodService.loadSoftKeyboardView()`（第 5116 行起）：

```java
SoftKeyboardView cached = cache.get(layoutResId);
if (cached == null) {
    View v = LayoutInflater.from(context).inflate(layoutResId, container, false);
    SoftKeyboardView skv = (SoftKeyboardView) v;   // 整棵树一次性成型
    cache.put(layoutResId, skv);
}
```

- 入参 `p2` 是**布局资源 id**。
- 数据源是 `KeyboardViewDef;->b:I`，来自 `KeyboardViewDef$a` 的 `getAttributeResourceValue`（编译期 id）。
- **整棵键盘树（含全部槽位与权重）由这一次 inflate 决定**，之后按 resId 缓存复用。

### 2.2 槽位不是动态拼的

键盘槽位的 View 树**没有任何 addView/removeView**。前面 grep 到的 `addView` 全在 `AccessPointsBar`（快捷栏）、`Dashboard`、`PopupHandler`、`KeyboardPreviewRenderer`，**没有一个在 `Keyboard`/`SoftKeyboardView` 的槽位构建路径上**。

`SoftKeyView` 自身对 `LayoutParams`/`weight` 的引用数为 **0**（已复核）。它既不读也不写权重。

### 2.3 权重只能来自静态布局

因为（a）inflate 一次成型；（b）`SoftKeyView` 不碰权重；（c）槽位不动态增删——所以**键的位置、数量、宽度全部由 `keyboard_prime_bottom.xml` 静态决定**。

### 2.4 扩展系统（ExtensionManager）也帮不上

本轮新挖到原版的扩展机制，逐项核对后确认不适用：

| 机制 | 内容 | 为什么不适用 |
| --- | --- | --- |
| `ExtensionManager` | 有 `IBasicExtension` / `IOpenableExtension` / `ActivationSource`，是正式的扩展系统 | 扩展的是**功能面板**（`setExtensionView`、`onExtensionViewOpened`），不是键盘布局 |
| `Lawu.b()` 模块注册 | 从**自己的** `ApplicationInfo.metaData` 读 `"module:"` 前缀项注册 | 读的是 `getPackageName()`，**第三方包无法注册** |
| `ModuleDef.e:Ljava/lang/String` | 每个模块带一个偏好开关 | 只能开关已有模块，不能注入新布局 |
| `KeyboardViewHelper$Delegate.loadSoftKeyboardView` | 接口，看起来可自定义 | 实现链最终落到 `GoogleInputMethodService` 的那次 `inflate(resId)`，仍受资源 id 约束 |

**结论：原版有扩展系统，但它扩展的是功能，不是布局。**

## 三、真正的结论

### 3.1 布局层不可运行期自定义

把三件事叠起来看：

```text
布局 → aapt 编译 → 资源 id（0x7f0400c4）
                     ↓
       inflate(resId) 一次成型整棵树
                     ↓
       SoftKeyView 不碰 LayoutParams
                     ↓
       槽位无动态增删
```

**任何一环都没有留给运行期的口子。** 用户的布局从安装输入法的那一刻就定死了。

### 3.2 所以「用户自定义布局」只有两种形态

| 形态 | 可行性 | 说明 |
| --- | --- | --- |
| **A. 有限预设** | 可行 | 输入法内置若干套完整布局（不同键位排列），用户在设置里选一套。每套都是编译期定好的资源，运行时只是切换**用哪个 resId** |
| **B. 任意布局** | 不可行 | 需要用户或第三方提供布局文件 → 必须进资源表 → 必须重打包输入法 |

**A 是唯一路径。** 而且要注意：A 的「多套布局」也不是无限加——每套都是一个独立的 layout 资源（可能还是多套：手机 + 平板 + 横屏），都要进输入法资源表，所以**数量必须有限**（这印证了上一轮「塞很多」的判断）。

### 3.3 一个关键的技术细节：A 是否真的可切换

`ExtensionManager` 那行按接口收集类的代码说明框架有**按偏好切换行为**的能力。但布局选择要落到「换 resId」上，需要确认：

- `KeyboardViewDef;->b:I`（布局 id）能否在运行时被替换？
- `GoogleInputMethodService` 的 `cache.get(layoutResId)` 说明缓存按 id 分键，**换 resId 天然不冲突**。

这一点**尚未验证**，是 A 方案能否落地的技术前提。需要在 `Keyboard.smali` 里确认 `KeyboardViewDef` 的布局 id 是否可以按偏好改写。

## 四、给用户的话

**「用户想要自己排布键盘键位」在当前框架下做不到。** 布局在编译期固化，运行期没有任何钩子能改键的位置、数量或宽度。

能做到的最大程度是：**输入法内置有限几套完整布局，用户在其中选择。** 这不是「自定义」，是「选预设」。

如果确实要「任意布局」，唯一的路是让布局进输入法资源表，也就是**由维护者合入**——对第三方来说就是提 PR。

## 五、待用户决策

1. **接受「选预设」**：那需要定义几套？（例如：标准 / 无逗号句号 / 大空格 / 左手模式）该项需要先验证 3.3 的技术前提。
2. **不接受，坚持任意布局**：那这条需求在当前架构下应当**关闭**，并如实告知用户不可能。
3. **回到逗号句号开关**：它是 A 的一个特例（切换的是槽位显隐，不是整套布局），继续按既定方案做完。

## 六、证据位置

- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService.smali:5116`（`loadSoftKeyboardView`，`inflate(resId)` 一次成型 + 按 resId 缓存）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/keyboard/KeyboardViewHelper.smali:80`（`a(ViewGroup)` → 委托 `loadSoftKeyboardView`）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/core/metadata/KeyboardViewDef$a.smali:230`（`getAttributeResourceValue` 取编译期布局 id）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/module/ExtensionManager.smali`（扩展系统：只扩展功能面板）
- `work/decoded/smali/awu.smali:198`（`b()` 从自身 `ApplicationInfo.metaData` 读 `module:` 注册模块）
- `work/decoded/smali/com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView.smali`（`LayoutParams`/`weight` 出现次数为 0）
- 本文件只记结论与依据，不含用户数据。
