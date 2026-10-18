# 输入会话、编辑事务与选区源码

## 当前基线对照

本轮从实际 `v2.1.7` 发布包按 descriptor 导出七个类，与固定原版同类比较。比较时只剔除调试行号等声明，不把 Smali 文本差异自动称为行为差异。

对照结果：

- `abp`、`ajx`、`InputBundleManager`、`SelectionChangeTracker` 的方法体一致。
- `GoogleInputMethodService` 有五个方法存在文本变化，涉及初始化、视图创建、配置和输入视图启动。选区回调、文本提交、composing 和 batch 方法不在变化列表。
- `InputBundle` 的事件入口和三个候选相关方法发生变化，需要保留当前 Header、剪贴板及事件拦截语义。
- `PinyinIME` 新增六个覆盖方法，另有六个方法变化。不能只照原版 Service 的生命周期恢复现代功能。

证据在 `work/native-rewrite/restart-v217/lifecycle-method-diff.json`，所需 Smali 在同目录的 `smali/`。本轮只生成所需类的反汇编，没有生成当前 APK 的全库 Smali 或解码资源。

## Service 与会话切换

真实继承关系为：

```text
PinyinIME → abp → GoogleInputMethodService → InputMethodService
```

Service 中的 `c:Z` 在创建时清除、销毁时置位，是本轮观察到的销毁门控。`onStartInput`、`onStartInputView` 等入口据此提前返回，不能把它猜成输入模式偏好。

`InputBundleManager.a(EditorInfo, restarting)` 保存 EditorInfo，再选择目标 bundle。目标变化时，先停用和释放旧 bundle，再激活新 bundle。只有 restarting、输入视图处于活动状态、bundle 未变化且仍存在时，才进入原来的同 bundle 重启路径。

`onFinishInputView` 与 `onFinishInput` 是不同边界。前者会调用 bundle manager 的输入视图停用路径，后者处理连接相关状态并调用 Framework。源码重建不把两个回调折叠为一个统一清理动作。

当前 `PinyinIME` 的新增语义包括：

| 入口 | 当前职责 |
| --- | --- |
| `onStartInput` | 先更新密码字段信息，再调用父类，建立 Header editor context 和 Inline 会话 |
| `onFinishInput` | 清除密码字段信息与 Inline 内容，结束 Header 输入会话，再调用父类 |
| `onStartInputView` | 父类路径之后保留首次引导分流、窗口与导航适配、Clipboard 会话等当前钩子 |
| `onFinishInputView` | 先停止 Clipboard，再执行父类与原有弹层、延迟任务清理 |
| `onDestroy` | 销毁 Header、清除 Inline，保存词典并调用父类 |

新增的 `onWindowHidden` 本体只调用父类，没有额外动作。它是现存转发覆盖，不能把「多了一个方法」算成多了一项窗口清理能力。后续源码迁移应核对真实依赖，不继续扩展这类壳。

## 输出有不同的状态语义

`commitText(text, correction, cursor)` 会更新预测选区。correction 分支还发送 `CorrectionInfo`，并在 batch 中提交。普通分支经 `ajx` 更新 tracker 后提交。

`setComposingText(text, cursor)` 先计算预期选区与 composing，再对真实连接执行 batch、设置文本和结束 batch。原方法包含异常回退与清理路径，完整 Android 适配器迁移时仍需单独核对。

另有 `commitTextToApp`、`setComposingTextToApp` 等直接通道。它们不等价于上述带预测状态的通道，不能仅因名称类似就合并。

连接为空时，原输出入口会在更新预测队列之前返回。实际 `onUpdateSelection` 还检查活动连接身份与 bundle 状态。下面的纯状态组件不持有连接，Android 适配层必须继续承担这些职责。

## 预测队列与选区回调

跟踪状态区分实际回调状态和尚未确认的预测状态：

- 预测队列非空时，后续编辑依据最后一项预测，而不是只依据旧实际光标。
- 预测项记录选区末端、选区跨度、composing 长度和 composing 内光标位置。
- `EditorInfo` 初值保留原始 start/end 差值。框架回调阶段才按 min/max 归一化，不提前修改初始方向。
- Android 文本偏移按 UTF-16 code unit 计算，不按 Unicode code point 计数。

回调归类并非「有预测就是 IME」：

1. 以六个回调坐标计算实际选区、composing 长度及前后范围。
2. 正数的零宽 composing 范围走独立 IME 分支，清空预测，且不设置普通首次回调标记。
3. 旧选区为 `(-1, -1)` 时清空预测并归为 IME。
4. 其他回调从队首查找匹配末端、选区跨度和 composing 长度的预测项。
5. 未匹配的通常归为 OTHER。首次回调与已经发出的 commit 还有原来的 IME 归类规则。

队列包含 `IME`、`DELETE`、`OTHER` 原因。回调匹配不比较预测的 composing 内光标字段，不能在源码重建时擅自强化成四字段完全匹配。

batch 首次进入时先保存预测基线，再增加嵌套深度。事务内编辑替换最后一项预测。仍在 batch 中且只剩最后一项时，框架回调不会消耗它。最外层结束时，仅把确实不同于前一状态的最终预测留在队列。

这些都是编辑坐标协议，不是词典学习或用户文本采集。回调中的「选区在零且 composing 端点非正数」也不能直接解释为应用文本框为空。

## 已恢复的纯 Java 源码

```text
research/native-rewrite/recovered/java/comeback/recovered/SelectionTracker.java
```

源码合并了原 tracker 与其真实调用方中有关坐标、预测和回调归类的逻辑。使用明确的 State、Expected、Update 与原因类型，不再保留混淆字段或依赖旧 DEX 的转发。对象池属于原内部实现，恢复组件使用普通不可变记录和队列。

组件只读取传入文本的长度，不保存或记录文本。它不是 InputConnection mock，不执行候选生成，也未接入 Android 输入法。真实连接、编辑器会话身份、实际事务调用与异常回退仍由后续适配器承担。

只用现有 JDK 即可构建和运行模块测试：

```text
javac -encoding UTF-8 -d work/native-rewrite/recovered-selection research/native-rewrite/recovered/java/comeback/recovered/SelectionTracker.java research/native-rewrite/tests/SelectionTrackerProbe.java
java -cp work/native-rewrite/recovered-selection SelectionTrackerProbe
```

输出目录需先建立。构建不读取 APK、Smali、Android JAR 或旧 native 库。源码权利边界继续按 `NOTICE`，不因翻译为可读 Java 就自动纳入 MPL。

## 验证边界与下一步

模块的真实入口已覆盖 composing 回调、应用移动光标、提交、事务内中间回调及 UTF-16 代理对偏移。测试以固定输入的独立静态坐标为期望，比较模块实际返回的状态。

这些不是完整 Android 编辑行为验收。仍需连接异步 processor 会话、候选选中、删除与替换、连接失效、字段切换及各输入模式，不能用这个纯状态组件替代整个输入生命周期。
