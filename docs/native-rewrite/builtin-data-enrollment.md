# 内置 bundle 的数据注册

普通资源现在从原始 DataScheme 字节建立 ID 索引，再进入既有模型缓存与真实游标。宿主只恢复成功的初始内存注册，输入是已提取的真实库及命名 blob 快照，不在 Windows 上模拟 ARM dlopen。

## Java、JNI 与原注册入口

DataManagerImpl 的 Java 方法直接转交 native manager 句柄和参数。原 JNI 绑定与链路为：

| Java native 方法 | RVA | 后续入口 |
| --- | --- | --- |
| nativeEnrollBuiltInData | `0x10f544` | 查找 blob 后构造内存 DataInfo，调用 DataManager slot 2 |
| nativeEnrollDataScheme | `0x1108cc` | 获取 byte[] 的指针与长度，调用 slot 3 |
| nativeEnrollBuiltInDataScheme | `0x1109b4` | 查找原 scheme blob，按完整长度构造字符串，再调用 slot 3 |

slot 3 为 `0x19915c`，解析 DataScheme 并逐项注册。slot 4 的 `0x1998b8` 是另一个 installer 入口，不是 data scheme 注册函数，不因地址相邻而合并。

`0x1135a4` 接收两个 std::string 引用和第三个 64 位长度输出地址。它按库名选择符号作用域，查找 `_binary_<blob>_start` 和 `_end`，两端均存在时返回起点并写入长度。关闭本次 dlopen 句柄不代表宿主可以释放模型仍使用的字节，Android 的库持有者尚未在宿主复刻。

旧 Ghidra 签名漏掉 X2 长度输出，导致调用方局部长度看似始终为零，注册分支被误删。ARM 指令在调用前明确把栈上长度地址放到 X2，随后读取该位置。导出工具现提供有界修复选项：

```text
ExportNativeFunctions.java NEW_DIRECTORY --unwind-ranges CPP_TYPES_JSON --builtin-blob-signature IMAGE_RELATIVE_OFFSETS...
```

修复先沿用已有 APK/ELF 哈希校验，再核对 `0x1135a4..0x11376c` 的确切 FDE。只声明两个不透明名称引用、长度输出和指针返回，不伪造 std::string 布局。启用状态写入导出 manifest，随后重新反编译，实际注册分支已恢复。

## DataScheme 到内存 DataInfo

原 `0x19915c` 先校验格式版本：版本未出现可继续，显式版本必须为 `1`。对每项数据按 storage type 分派：

- `2`：按 scheme 的库名和条目的 blob 名查找首尾符号，以差值作为长度。
- `1`、`5`：走路径来源，本阶段不接入。
- 其他值：记录该项失败，继续处理后续项。

storage type 2 经 `0x19c278` 包装已有指针与长度，不复制载荷，再由已有 `0x19b22c` 构造 mode 2 的 DataInfo。原函数随后复制显式模型名、创建器名及初始化选项，以条目的 data ID 调用 slot 2。成功内存注册不等于已经创建字典模型，后者仍由首次按 ID 查询触发。

原循环累计失败，但可能已经发布其他条目，没有整份回滚。重复 ID 经既有配置更新替换，缓存失效沿用原协议，本阶段不把它简化成通用事务。

## 宿主成功注册投影

`bundle_data_scheme.proto` 明确是 bundle 读取投影，不冒充完整原 DataInfo schema。它恢复条目的 data type、data ID、storage type、blob 名，以及 scheme 的库名和版本存在性。完整枚举名、模型选项等未恢复字段仍作为未知字节保留；构建索引时明确拒绝，不静默忽略。

TokenDictionaryResources::Load 接收原 scheme 字节和按库名、blob 名分组的真实快照。原人工 data-ID Sources 构造入口已移除。注册按传入 scheme 顺序处理，重复 ID 后到替换，保存数据类型和共享字节区域。原注册中的模型创建与查询排序仍是不同阶段，不用注册顺序替代 Manager 的资格 pair 顺序。

索引保留其他数据类型的绑定，但 Resolve 仅支持 data type 4 的普通非反向 token 模型。其他类型明确返回 Unsupported，不把 n-gram、expansion 或 token ID table 强制作为 token 字典读取。类名前缀分派和成功模型缓存仍各保留一个实现。

该入口只构建新的不可变索引。缺失 blob、未支持来源或字段、版本错误返回 null，不发布部分宿主索引。这是成功初始注册的投影，不宣称已恢复原失败时的部分发布、注册更新、失效、锁、FD 或 dlopen 生命周期。共享 OwnedByteRegion 保持宿主字节有效，不冒充原 MemoryChunk 的引用 ABI。

## 验证与后续

同一条 Manager 端到端入口已升级：C++ 直接读取原 en_data_scheme、data_scheme、gesture_data_scheme 的完整字节，输入覆盖原 46 项注册。Python 只提供库名、blob 名和文件，不再读取清单中的解码 ID 表来代做注册。原 token 设置、明确测试选择项、真实六资源查询与跨 Manager 缓存验证继续执行。

一次 `build_forward_token_research.sh manager` 完整宿主构建、新 schema 模块测试及该流程通过。模块测试使用字面 wire 确认字段与版本存在性；旧设置模块和独立查询测试未重跑。最终把库查找移入条目循环，使空 scheme 沿原流程成功而不查库。该小调整仅严格重编译资源模块，未重跑上述端到端流程，也未新增空 scheme 运行覆盖。构建日志为 `work/native-rewrite/forward-token-build/builtin-registration-build.log`。

新增六段完整 FDE，全部与保留 v2.1.7 库 raw-equal，中央从 500 增至 506。证据为 `work/native-rewrite/restart-v217/native-builtin-data-enrollment-comparison.json`。修复后的 Ghidra 导出保存在 `builtin-data-enrollment-verified/`，旧 500 段直接沿用。

本轮没有执行原 ARM64 或 Android，没有改正式版工作区或设备。下一步接上层文本准备及 source/target 查询调用方，核对文本方向和请求属性后再组合，不提前新增未使用的转换接口。
