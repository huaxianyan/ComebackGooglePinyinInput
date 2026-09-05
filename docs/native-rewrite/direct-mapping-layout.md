# DirectMappingTokenExpander 字节布局

## 范围与证据

本文记录从固定原始 APK 的四个 `DirectMappingTokenExpander` blob 恢复存储区间的结果，不实现 reconversion 解码器。两个英文 blob 字节相同，因此四个文件只提供三种不同样本。

后续 [native 查找研究](direct-mapping-native.md) 已确认 lower_bound 区间查找、最高位间接索引、连续目标迭代、默认 score 表公式和前置 metadata 读取阶段。下文的字节结果继续有效，语义结论与后续工作以该文档为准。

工具入口仍为 `research/native-rewrite/tools/extract_data_bundles.py`，复现命令见 [容器研究](setting-and-container-formats.md)。输出 manifest 的 `native_container.tables` 记录区间、位宽、数量、SHA-256 和统计值。完整索引只保存在被忽略的 `work/` 中。

所有偏移均相对各自 blob 起点，不相对 ELF、APK 或 class payload。此处确认的是当前样本的字节布局，不是所有版本通用的格式承诺。

## 四个连续区间

沿用已有 class envelope 和 length-prefixed config 后，数据从 offset 48 开始：

1. 第一张位压缩索引，暂按 reader 文案称为 key IDs
2. 第二张位压缩索引，暂按 reader 文案称为 start positions
3. 带字节长度头的 32-bit 原始 word 数组
4. 带字节长度头的 8-bit 原始 score 数组

两张索引的头部均为 `uint32_le count` 与 `uint32_le bit_width`，后接低位优先连续位流，并以零填充到 8-byte 边界。它们复用 ForwardTokenDictionary 研究工具的位流读取函数，没有新增第二套位流解码逻辑。

后两张表的头部可按 `uint64_le byte_size` 读取，随后分别按 32-bit word 和 byte 切分，并以零填充到 8-byte 边界。当前所有长度头的高 32 位均为零，尚不能排除它其实是 32-bit 长度加 32-bit 填充的解释。

| 样本 | key 表 offset / count / bits | position 表 offset / count / bits | target 表 offset / count | score 表 offset / count | blob bytes |
| --- | --- | --- | --- | --- | ---: |
| 英文，两份相同 blob | 48 / 3 / 7 | 64 / 3 / 6 | 80 / 52 | 296 / 52 | 360 |
| 数字 | 48 / 2 / 6 | 64 / 2 / 4 | 80 / 10 | 128 / 10 | 152 |
| 拼音 | 48 / 1736 / 18 | 3968 / 1736 / 15 | 7232 / 27701 | 118048 / 27701 | 145760 |

表中 target 与 score 的 offset 均指向长度头，数据从 offset 加 8 开始。target 的 count 为 word 数，长度头记录的值为其四倍。拼音 target 数据占 110,804 bytes，score 数据占 27,701 bytes。

四段数据加填充完整覆盖 config 后的全部字节。没有剩余的独立非零区间可直接命名为第五张 metadata 表。后续函数控制流已确认 `meta data table` 错误分支来自数组之前的消息读取和解析阶段。

## 索引不是普通 CSR 起始位置表

英文的两张索引解码结果为：

```text
key IDs:         [65, 97, 122]
start positions: [0, 26, 51]
```

数字的结果为：

```text
key IDs:         [48, 57]
start positions: [0, 9]
```

数字有 10 个 target word，却只有 2 个 key 索引值。英文有 52 个 target word，却只有 3 个 key 索引值。不能把每个索引值解释为一个独立 source，再用相邻 position 之差当作该 source 的 target 数量。

后续 native 函数证据确认，它使用 lower_bound 和前一项 anchor 的差值计算位置，并通过下一项 position 排除空洞。具体公式见 [native 查找研究](direct-mapping-native.md)。导出工具现已增加 [离线语义分析](direct-mapping-semantics.md)，恢复索引接受的 source 与目标，不模拟上层类型过滤或回退。

## 拼音 target 含高位标记值

拼音 target 数组包含 27,701 个原始 32-bit word，共 1,544 种不同值。最高字节的分布为：

| 最高字节 | word 数 |
| --- | ---: |
| `0x00` | 26,570 |
| `0x02` | 8 |
| `0x80` | 1,123 |

其中 1,123 个 word 设置了最高位，其低 31 位范围为 `25379`–`27698`，落在 target 数组的后部。position 表最大值为 `25378`，而 target 总数为 `27701`。

后续 native 函数证据确认最高位表示间接索引：低 31 位替换当前位置，原位置的 byte 表示目标数量。推进函数通过位置加一、数量减一枚举连续目标。工具继续命名为 `target_words`，避免把位置值误当成普通 token ID。

byte 数组在英文和数字样本中全部为零，拼音中有 138 种字节值。它具有双重用途：间接入口处存数量，目标元素处存 score code。native 会用 score code 查 float 表并取负值，已恢复的默认构造使用 8-bit code 和 `20.0` 上限。float32 运算顺序见 [native 查找研究](direct-mapping-native.md)，不能将这些 byte 直接解释成 float32 expansion score。

## 修正此前结论

此前依据 reader 的五组诊断字符串，将结构概括为「压平 target array 加 start-position index」。这一概括不足以描述已观察到的区间索引和疑似间接值，不能用作实现协议。

当前已确认四个物理数组的边界与原始值，native 研究进一步恢复了区间查找、间接寻址、连续目标迭代和默认 score 表构造。metadata 错误分支对应数组之前的消息读取和解析阶段，不是第五张尾部数组，其字段语义仍未完整恢复。

## 验证

新增一个走真实 APK 导出入口的端到端测试，以及一个使用固定字节的位流模块测试：

```text
PYTHONPATH=tools/python python -m unittest discover \
  -s research/native-rewrite/tests -p test_direct_mapping_export.py -v
```

端到端测试从原始 APK 导出全部 blob，并核对四个 DirectMapping 样本的固定偏移、数量、位宽、末端位置、英文和数字索引值，以及拼音 word 分布。期望值来自独立字节检查，不由被测函数计算。临时输出位于项目 `work/` 中，测试结束自动清理。

本轮没有修改 APK 补丁或运行时功能，不进行 APK 重建和设备验收。完整字节消费只证明存储区间被覆盖，不代表 reconversion 行为已恢复。

## 下一步

后续工作统一见 [DirectMapping native 查找语义](direct-mapping-native.md#验证与限制)。
