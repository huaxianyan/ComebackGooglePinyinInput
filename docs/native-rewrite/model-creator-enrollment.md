# 词典注册、模型创建与缓存失效

本阶段确认原 Java 词典注册来源、GenericDataModelCreator 分支与缓存失效顺序，只更新取证和导出登记。未建立模型创建器、空词典或 Android 生命周期的宿主替身。

## 实际词典注册参数

原 AbstractHmmEngineFactory 默认数组按新词、联系人、用户词典、快捷短语排列：

| 项目 | 新词 | 联系人 | 用户词典 | 快捷短语 |
| --- | --- | --- | --- | --- |
| 数据类型 | 24 | 24 | 23 | 24 |
| 字典类型 | 3 | 3 | 2 | 3 |

数据类型由注册流程传入 DataInfo。字典类型属于另一套设置，不将这些数值直接解释为某一种 trie 结构。

`enrollMutableDictionary` 以词典文件名为 dataId，调用 Context.getFileStreamPath 检查本机私有文件：

1. 文件存在时，通过 openFileInput 取得 FD，offset 为零，length 为 File.length() 转 int，再传入 token category。
2. 注册成功后关闭 Java 输入流。
3. 文件不存在、发生 IOException 或 FD 注册返回 false 时，调用 enrollEmptyMutableDictionary。这是 Java 的显式回退。具体词典模型另有加载失败后的初始化分支，见 [默认 legacy 类型与初始化](legacy-single-trie-initialization.md)。

FD JNI 为 `0x112464`，空注册 JNI 为 `0x1125ec`。两者构造 DataInfo，并将 token category 编码进初始化选项，再调用 DataManager slot 2。

FD 构造 `0x19b1c4` 将模型名、创建器名及路径设为空，模式为 `0`，保存 fd、offset、length。空注册构造 `0x19b22c` 使用模式 `2`、fd 为 `-1`，并持有传入的空 MemoryChunk。因此这条路径确实使用默认 GenericDataModelCreator，而非按文件名猜创建器。

Java 证据来自原版 DEX 反汇编，不宣称已完成这些方法在发布版的逐方法对照。

## 注册校验与 FD 所有权

`0x19774c` 先调用 DataInfo 校验，再在同步包装之间调用 slot 11 的 `0x1988a4`。

已确认的校验包括：数据类型非零，FD 源的 offset 非负、length 大于零。路径源与 FD 互斥。原路径模式 `1` 明确标记为 NON_MMAP_FILE，并在该普通注册入口拒绝，仅供服务端使用，不能把它接成 Android 默认加载路径。

DataManager 更新配置时对 FD 执行 dup，成功后才替换原描述符，再关闭旧 FD。Java 输入流关闭后，注册配置持有自己的 FD。

保留原部分失败语义：函数可能先插入默认配置节点，再尝试 dup。dup 失败时返回 false，未执行后续缓存失效，不据此承诺整个注册完全无修改。

## 内存与文件创建通道

GenericDataModelCreator `0x19a3c0` 的源选择为：

- 路径为空且 fd 为 `-1`：回调取得 DataInfo 的 MemoryChunk，空注册也走这一分支。
- 路径为空且 fd 有效：回调使用注册的 fd、offset、length，目标为 `0x1f5b30`，再接既有 mmap 工厂。
- 路径非空、模式 `0`：先尝试内存映射加载；未得到模型且 legacy 工厂名称可用时，再走模型文件接口。
- 路径非空、模式 `1`：进入文件通道。该能力不等于上述 Android 注册允许该模式。

模型数据类型 `4`、`5`、`34` 共用 `0x19ba28` 的类名前缀加载器，先读按 8 字节对齐的类名，再经原注册器创建模型。Direct/Forward 的模块注册、创建回调和加载桥已在 [普通 token 模型创建链](token-model-creation.md) 闭合。`35` 按显式模型名查找。原 Java 的 `23`、`24` 走 legacy 类型表，再经 `0x131d84` 的模型名或别名注册器创建对象。后续已确认两者均登记为 SingleTrieUserDictionary，具体绑定见 [类型表取证](legacy-single-trie-initialization.md)。

`0x19b984` 调用模型内存接口，根据返回成功标记决定是否保留对象，失败时销毁本次对象。本层没有将返回载荷与输入总长比较，其载荷含义仍待确认。[宿主文件入口](mapped-dictionary-load.md) 的整文件 EOF 条件仍只属于宿主契约。

`0x19b748` 调用模型文件接口，按状态保留或销毁对象，包含平台不支持的处理。该通用函数本身不创建空词典，具体词典的初始化回退已另行取证，不能只按通用层推断最终失败行为。

## 缓存失效是显式协议

配置更新完成后，`0x1988a4` 调用 `0x19819c`：

1. 找到缓存节点的旧句柄，将其 `+0xc` 标记设为 `1`。
2. 释放缓存持有的引用，再把节点句柄清零，保留缓存节点。
3. 原 accessor 的 `0x18bde8` 正是见到该标记后重新请求资源。

这解释了 [缓存与属性取证](accessor-resource-property.md) 中尚未命名的标记用途。失效不是强制清除所有持有者，也不是按文件时间自动轮询。线程与跨进程语义仍未恢复。

## 证据与边界

本轮新增十七个 native 区间对照：十三段与保留发布库逐字节一致，加入中央清单后为 `305` 区域。另四段仅有 ADRP 差异，目标 `.bss` 节内偏移一致，未列入字节一致清单。DataManager 虚表绑定沿用前一阶段证据，不重复验证。

- `work/native-rewrite/ghidra/model-creator-source/`
- `work/native-rewrite/ghidra/model-creator-load/`
- `work/native-rewrite/ghidra/model-creator-memory/`
- `work/native-rewrite/ghidra/model-creator-adapter/`
- `work/native-rewrite/ghidra/model-enrollment-jni/`
- `work/native-rewrite/ghidra/model-enrollment-descriptor/`
- `work/native-rewrite/ghidra/model-enrollment-file-range/`
- `work/native-rewrite/restart-v217/native-model-creator-enrollment-comparison.json`
- `work/native-rewrite/restart-v217/model-creator-enrollment-export.json`

真实 APK 导出核对十三个新区域及独立 FDE 端点。未重跑旧构建与产品验收，未执行原 ARM64、操作设备或访问用户词典。legacy 类型表与初始化已有后续记录，普通 token 创建链也已闭合。下一步定位内置 data scheme 到 DataInfo 的内存注册，不扩展 FD 可变词典或复制通用模型 ABI。
