# 候选确认、提交与学习边界

## 本轮结论

已确认当前事件确认分支，以及 processor、HMM 范围选择、文本提交和词典增量的下游入口。核心路径来自固定原版 APK，另用实际 `v2.1.7` 发布包核对保留方法和新增拦截。异步调度与各模式的 processor 选择仍待补齐。

这仍是静态取证。native 内部的频率编码、衰减、合并与持久化尚未还原，不能用 Java 层的 `addCount(..., 1, ...)` 推断最终权重。

## 当前版本对照

- `AbstractHmmChineseDecodeProcessor` 的 54 个方法、`HmmEngineWrapper` 的 94 个方法，在剔除调试声明后与原版一致。结果保存在 `work/native-rewrite/restart-v217/candidate-method-diff.json`。
- `AbstractHmmDecodeProcessor` 和 `MutableDictionaryAccessorInterfaceImpl` 的完整 Smali 与原版逐字节一致。结果在同目录的 `commit-accessor-baseline-comparison.json`。
- `InputBundle` 使用当前版本本体取证。Clipboard 装饰候选，并在预览和确认两个入口消费自己的 Candidate，之后才轮到原生候选路径。

## 预览与确认分开

当前 `InputBundle.selectTextCandidate(Candidate, boolean)` 最终向 `IIme.selectTextCandidate` 传 `false`。它属于候选预览，不能直接当作提交入口。

真正的确认分支位于 `InputBundle.a(Event)I`。事件首项 KeyData 的代码为 `-10002`，对象载荷为 Candidate。Clipboard 拦截成功就结束该分支，否则向 IME 传入 Candidate 和 `true`。

processor 的 `onSelectTextCandidate` 按状态处理：

1. Candidate 为空时返回失败。
2. composing 中先检查候选有效性。预览只高亮候选并刷新 composing。
3. 确认时选择候选。`isAllInputConverted(true)` 为真就进入提交，否则继续刷新 composing 和候选。
4. 无 composing 的预测候选只接受确认，用候选文本提交并继续请求预测。

原生候选的载荷保留 Integer 索引。`HmmEngineWrapper.selectCandidate` 检查载荷类型和候选列表开关，再进入 `selectCandidateByIndex`。后者取 native 候选 Range、调用 native 选择、记录转换范围，随后选择普通刷新或 bulk input 过滤。

Range 的 start/end 是输入图顶点，不是应用文本框中的 UTF-16 偏移。composing renderer 另从 segment、token 和 input unit 构造文本，最终才以 `CharSequence.length()` 记录文本长度。

## 提交与学习

原始 DEX 中有同名、同参数但返回类型不同的两个方法：

```text
a(String, String)V
a(String, String)Z
```

void 方法先选择高亮候选，再调用 boolean 方法。后者取得渲染后的提交文本和 `ConvertedComposingText`，按提交状态处理学习，然后提交到应用。

学习路径有以下边界：

- 状态字符串为 `CANCELLED` 时跳过学习，后续提交逻辑仍会执行。这与 `onAbortComposing` 只重置状态的路径不同。
- 转换文本非空时，先按 TARGET_TOKEN、文本分类及 languageIds 选择 accessor。
- languageIds 全为 `0` 时选择英语 accessor。其余只有全部属于 `{0, 16, 69, 300}` 的路径才进入另一 accessor。
- 不符合上述语言集合的路径直接跳到提交部分，也跳过 `a(ConvertedComposingText)` 钩子。
- 选中的 accessor 非空时，以 tokens、languageIds、转换文本、增量 `1` 和 `isFullMatch` 调用 `addCount`。
- 成功写入且 `isAllInputConverted(false)` 为真时，保留最近成功学习的转换对象。这个条件不同于候选确认阶段使用的 `true`。
- 转换文本为空且英语 accessor 可用时，原实现按 UTF-16 char 拆分渲染文本，对 Locale.US 小写结果生成 token，再调用英语增量入口。

这里记录的是已经观察到的路由，语言编号的完整命名和 accessor 的全部准入条件仍待追踪。不能把它简化成「每次提交都给中文词频加一」。

原版 JNI 入口为：

```text
MutableDictionaryAccessorInterfaceImpl.nativeAddCount
(J[Ljava/lang/String;[ILjava/lang/String;IZ)Z
libhmm_gesture_hwr_zh.so: 0x111f08
```

Java 实现直接传递 native accessor、tokens、languageIds、文本、增量和匹配标志。另有缺少 languageIds 与匹配标志的旧重载，地址为 `0x111e14`，不能仅按方法名混在一起。

地址取自原版的既有 `jni-map.json`，是静态方法表绑定证据。当前库坐标与实际注册成功、执行效果仍按 [ABI 取证边界](native-abi-map.md) 区分。

## 提交、重置与回删

`commitTextAndResetInternalStates` 先清除两类候选。提交文本非空时向 delegate 提交，再清空 composing 并重置引擎和本地状态。`onAbortComposing` 则直接重置，不走上述文本提交。

回删使用编辑操作栈，按操作类型选择删除最近输入、撤回候选选择或撤回 token 选择。操作栈和输入图范围也参与状态检查。源码重建不能只把回删替换成应用端的字符删除。

原版部分 metrics 块仍拼接文本。新源码沿用项目的诊断隐私边界，恢复本地学习业务，不恢复这类文本诊断或历史上报。

## REA 实际接入

本轮沿维护者原有的可选 REA 接入要求，部署共享 `rea-agents 6.7.0` CLI。JADX 使用该包声明的 `0.7.1` 引擎，下载后与声明哈希匹配。复用现有 Node 和完整 JDK，不运行 setup，不注册 MCP，也不修改 PATH 或客户端配置。

npm 安装省略可选依赖和生命周期脚本。没有安装可选 Frida，也未启用设备注入。Windows 上实际 APK 方法反编译成功，说明本次使用的 Android provider 可用，不代表其他 provider 全部就绪。Windows Ghidra 对目标 ARM64 ELF 的准入限制保持原样。

批量入口复用 REA 已安装的 MCP SDK，按顺序采集方法证据，并在结束或失败时关闭连接：

```text
node research/native-rewrite/tools/rea_android_batch.mjs REA_DIRECTORY APK QUERIES_JSON NEW_OUTPUT_DIRECTORY
```

`REA_DIRECTORY` 是包含 `node_modules` 的共享安装根目录。调用进程提供 `JAVA_HOME` 和 `REA_JADX_MCP_JAR`，可按需设置 REA 的 JVM 堆与处理器预算。输出目录须为新目录，父目录须已存在。

查询文件是数组，每项使用 REA 的参数形状：

```json
[
  {
    "class_name": "com.google.android.apps.inputmethod.libs.hmm.HmmEngineWrapper",
    "method_name": "selectCandidate"
  }
]
```

同名重载需要附带 `overload_index`。索引和显示别名只对当前引擎、当前 APK 有效，最终核对 `dex_descriptor`。每项保存完整 MCP 结果和便于阅读的源码文本，同时输出 body status、representation 和 fallback 状态。采集成功不等于源码恢复完成。

## 反编译输出的实际缺口

JADX 把上述 boolean 方法显示为 `m518a`，把其他冲突方法显示为 `m516a` 等名字。它们是当前观察到的别名，不是新源码 API。

更重要的是，该 boolean 方法虽然标为 `available`、`fell_back=false`，输出仍有未初始化的 accessor 局部变量。对不支持的语言集合，Java 视图还丢失了跳过学习钩子的控制流。原始 DEX 的 `if-eqz ... :cond_65` 明确跳到提交部分。本轮以 DEX 为准，未将该反编译文本当作可编译实现入库。

同一方法的调试分支还出现无效 Java 赋值表达式。因此 provider 的成功状态只说明拿到了反编译视图，不证明代码可编译或语义完整。后续恢复需要真实入口、明确坐标和数据类型，以及对关键分支的人工还原。

研究证据集中在 `work/native-rewrite/original-apk/rea-*-flow/`，当前 Clipboard 边界在 `work/native-rewrite/restart-v217/rea-candidate-flow/`。没有运行目标 APK、访问设备或采集用户词典。
