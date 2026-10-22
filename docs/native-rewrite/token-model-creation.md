# 普通 token 模型创建链

本阶段闭合原 data type 分派、类名注册、对象创建与内存加载桥。没有修改已通过的 Direct/Forward 查询实现，也未新增通用模型注册器或原 ABI 转发壳。

## 从数据类型到类名前缀

已有 GenericDataModelCreator `0x19a3c0` 先按 DataInfo 选择内存、FD 或路径来源。普通内存通道经 `0x19a1f4` 进入 `0x19a03c`，data type 为 `4`、`5`、`34` 时共用 `0x19ba28`。这些数值不是 Direct/Forward 的类名枚举，不按 type 4 单独选择某一种字典。

`0x19ba28` 的顺序为：

1. 从真实 MemoryChunk 取得数据地址和长度。
2. 调用 `0x1f61c0` 读取类名，传入对齐参数 `8`。
3. 用已消费的前缀长度切出共享 payload，不复制成另一份资源。
4. 调用 `0x19b984`，由类名创建对象，再执行模型内存加载。
5. 若提供外层消费长度输出，写入前缀长度加内层输出。

类名前缀解析成功、内层模型失败时，内层长度仍可为零，外层长度却已包含前缀。消费长度非零不能代替模型成功判定。原通用层没有要求消费长度等于整个资源长度，不据此把宿主局部 EOF 检查推成原 ABI。

## 原注册与创建回调

两个注册函数确实出现在原 ELF 的 `.init_array`，不是未使用的帮助函数。

| 注册函数 RVA | 原类名 | 创建回调 RVA | 同名别名 |
| --- | --- | --- | --- |
| `0x7aac0` | DirectTokenDictionary | `0x1b0f38` | DirectTokenDictionary → DirectTokenDictionary |
| `0x7ac30` | ForwardTokenDictionary | `0x1b33ec` | ForwardTokenDictionary → ForwardTokenDictionary |

每个函数先向原模型注册器登记类名及创建回调，再向别名表登记同名映射。Forward 所在初始化函数还登记 UnicodeBlockEncoding，属于另一注册器，不合并到 token 模型工厂。

创建回调只分配对象并调用构造函数：Direct 为 `0x38` 字节，调用 `0x1b0f00`；Forward 为 `0xe8` 字节，调用 `0x1b3388`。Forward 构造中的默认限额 128 沿用既有证据，不重取。这些大小只描述原 ARM64 对象，不作为宿主类大小或布局约束。

`0x131d84` 优先检查请求名是否为已注册类名。否则查询别名，再校验其指向的类名，最后调用创建器的 `+0x20` 槽位。未知别名与无效目标均返回空。普通两类资源使用原 canonical 名称，当前精确字符串分派覆盖本阶段确认的名称，不新增无人消费的别名框架。其他模块的别名未穷举，不据同名映射推断原注册器只有这两项。

## 内存加载的真实 ABI

`0x19b984` 创建模型后调用对象虚表 slot 2。沿用已保存的调用方与发布桥指令，不能把 Ghidra 伪码中的参数顺序当作 ABI：

| ARM64 位置 | 已确认用途 |
| --- | --- |
| `X0` | 模型 this |
| `X1` | payload MemoryChunk 输入 |
| `X2` | 通用调用方转交的初始化选项 |
| `X8` | 调用方提供的结果记录地址 |
| 结果 `+0` | 成功载荷或失败状态 |
| 结果 `+8` | 成功字节 |

调用方明确执行 `add x8, sp, #0x30`，返回后检查 `[sp, #0x38]`。成功时才将首字输出到消费长度指针。失败时按首字低位清理错误载荷，并销毁刚创建的模型。结果不是一个裸整数，也不是 `bool` 返回加一个随意补出的输出参数。

Direct `0x1b1f8c` 和 Forward `0x1b7e84` 都分别保存 this 与 X8 结果指针。它们只在解析成功后发布新字段，最后设置模型自身的就绪字节。结果记录的 `+8` 与模型的 `+8` 是两个不同对象，不能因偏移相同混为同一状态。

这两个普通发布桥没有消费传入的初始化选项，不据此推断其他模型也忽略选项。当前宿主直接使用唯一的真实加载器，不复制原隐藏返回记录、对象大小或虚表布局。

## 宿主边界与验证

TokenDictionaryResources 已按原类名前缀选择唯一 Direct/Forward 加载器，成功后才缓存模型。本轮没有发现需要修改普通分派的差异。输入域仍为显式提供的普通非反向 bundle 索引，不声称完整复刻类型表、创建器生命周期、OOM 或损坏资源的发布顺序。

新增六段完整 FDE，中央从 494 增至 500。前缀加载器和两个创建回调共三段 raw-equal。两个注册函数与类名创建入口共三段存在 ADRP 差异，其余指令相同。十处差异分别保持 `.data` 或 `.bss` 节内的相对页位置，其中 `.data` 引用为析构登记使用的 DSO handle，不误记为 `.bss`。

证据保存在 `work/native-rewrite/restart-v217/native-token-model-creation-comparison.json`，摘要为 `work/native-rewrite/token-model-creation-evidence.log`。Ghidra 输出位于 `token-model-creator-dispatch/` 和 `token-model-registration/`。原调用方与 Direct/Forward 发布桥沿用既有导出，不重复做字节比较。

本轮仅新增静态取证和文档。上一轮宿主结果继续有效，没有重跑宿主构建、测试、原 ARM64 或 Android。后续已定位内置 data scheme 的 Java/JNI 注册，并用原 scheme 字节替换人工 ID 索引，见 [内置数据注册](builtin-data-enrollment.md)。下一步接上层文本准备与查询调用方。
