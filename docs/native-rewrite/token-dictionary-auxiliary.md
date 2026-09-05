# Token dictionary auxiliary 与 native reader 研究

## 文档状态

本文档继续研究 `ForwardTokenDictionary`、`InMemoryTokenExpander` 和 `DirectMappingTokenExpander` 的辅助数据，并将 data bundle 字节结构与 `libhmm_gesture_hwr_zh.so` 中保留的 reader 诊断字符串交叉验证。

本轮只恢复容器协议和 reader 职责，不导出原版词典正文，不开始新输入法实现。

## 证据来源

可复现证据来自两个清单：

```text
work/native-rewrite/original-apk/data-bundle-manifest.json
work/native-rewrite/original-apk/elf-inventory.json
```

生成工具：

```text
research/native-rewrite/tools/extract_data_bundles.py
research/native-rewrite/tools/inventory_elf.py
```

`inventory_elf.py` 现在单独记录 HMM storage reader 的 class、源码路径、protobuf 类型和失败诊断字符串，避免依赖一次性的手工 strings 输出。

## Native storage reader 身份

统一核心库中保留了以下内部源码路径：

```text
i18n/input/engine/hmm/internal/storage/direct_token_dictionary.h
i18n/input/engine/hmm/internal/storage/forward_token_dictionary.cc
i18n/input/engine/hmm/internal/storage/forward_token_dictionary.h
i18n/input/engine/hmm/internal/storage/in_memory_token_expander.h
i18n/input/engine/hmm/internal/storage/direct_mapping_token_expander.h
i18n/input/engine/hmm/internal/storage/class_ngram_model_reader.h
```

同时保留 protobuf 类型：

```text
i18n_input.engine.hmm.proto.ForwardTokenDictionaryMetaData
i18n_input.engine.hmm.proto.ClassNGramModelMetadata
```

这确认 data bundle 中的 class marker 与核心库中的具体 reader 一一对应，不只是构建期残留文件名。

## ForwardTokenDictionary 读取职责

native 诊断字符串明确给出 reader 依次涉及的组件：

```text
underlying trie
token IDs table
token scores table
token meta table
token codes table
token node ids table
custom token encoding
prefix scores table
meta data
```

因此，`ForwardTokenDictionary` 的 auxiliary data 不是单一 token 数组，而是多个互相关联的表。当前可以确认的数据模型至少需要表达：

- trie key 到 token ID 的映射
- token score
- token metadata
- token code
- trie node ID
- 可选 custom encoding
- prefix score
- dictionary metadata

具体序列化边界仍需结合 reader 函数控制流恢复。

## 拼音类 ForwardTokenDictionary 的进一步结构

除笔画外，八个拼音、双拼和数字 token dictionary 在 Marisa trie 后都具有：

```text
uint32_le config_size
byte[config_size] protobuf config
zero padding to 8-byte boundary
uint32_le token_count
byte[] token table payload
```

八个文件全部满足：

```text
token_count == marisa_key_count
```

| dictionary | config bytes | token count | token table payload |
| --- | ---: | ---: | ---: |
| 全拼 | 106 | 517 | 4,740 bytes |
| 数字 | 22 | 10 | 108 bytes |
| 智能 ABC | 109 | 480 | 4,316 bytes |
| 小鹤双拼 | 109 | 480 | 4,316 bytes |
| 拼音加加 | 109 | 504 | 4,532 bytes |
| 微软双拼 | 109 | 486 | 4,380 bytes |
| 紫光双拼 | 109 | 480 | 4,316 bytes |
| 自然码 | 109 | 507 | 4,564 bytes |

`token_count` 与 trie key 数量相等，证明 auxiliary table 与 Marisa key ID 至少在数量上是一对一关系。但在各子表边界恢复前，不能断言 Marisa ID 就是 HMM token ID。

### Token config

全拼 config 的 repeated field 3 为：

```text
abcdefghijklmnopqrstuvwxyz<>_
```

六套双拼多一个分号：

```text
abcdefghijklmnopqrstuvwxyz<>_;
```

数字 config 的 field 3 是空字符串。其他稳定字段：

| config field | 全拼和双拼 | 数字 |
| ---: | ---: | ---: |
| 1 | 0 | 0 |
| 2 | `*` | `*` |
| 4 | 16 | 300 |
| 5 | 1 | 0 |
| 6 | 1 | 1 |
| 7 | 1 | 1 |
| 8 | 0 | 0 |
| 9 | 0 | 0 |
| 11 | 0 | 0 |

field 3 明确表达可接受的输入符号集合。field 4 的名称和单位未知，不能只凭 `16` 和 `300` 将其命名为容量或长度。

### 六套双拼不是共享 trie

智能 ABC、小鹤和紫光的 key 数、Marisa bytes 与 token table payload 大小相同，但三者的 Marisa SHA-256 和 payload SHA-256 都不同。其余三套的数量和大小也不同。

因此，不能通过「相同大小」推断这些方案共享 token 映射。六套方案都需要作为独立映射验证。

## 笔画容器是独立变体

`stroke_token_dictionary` 也声明为 `ForwardTokenDictionary`，但它与八个拼音类容器不同：

- 第二个 64-bit header word 为 `4`，其他八个为 `0`
- Marisa trie 包含 90,701 个 key
- auxiliary data 为 550,144 bytes
- auxiliary 起始位置不符合拼音类 length-prefixed config

native reader 诊断中存在 `custom token encoding`，笔画 header 差异与该能力相符，但当前没有函数级证据证明数值 `4` 就是 custom encoding enum。未来 parser 必须按 header 和 metadata 选择变体，不能强行套用拼音结构。

## InMemoryTokenExpander 分数字段

上一轮已按以下记录结构完整消费 17 个 expansion：

```text
source token
number of expanding tokens
repeated {
  expanding token
  float32 expanding score
}
```

native 诊断字符串逐项确认：

```text
number of expansions
source token
number of expanding tokens
expanding token
expanding score
meta_data
```

因此，记录中的第二个 32-bit word 已确认是 `float32 expanding score`，不再只是基于 bit pattern 的推断。

当前数据中：

- 绝大多数 expansion score 为 `0.0`
- 默认 fuzzy 的部分目标为约 `-0.1`
- 12 组可选 fuzzy 的 988 个目标全部为 `0.0`

默认 fuzzy 因此不仅定义映射，还对部分扩展施加分数惩罚。

## DirectMappingTokenExpander 读取职责

native 诊断字符串给出五张表：

```text
key ids table
start position table
target id table
expansion score table
meta data table
```

四个 direct mapping blob 的 config field 1 均为 `3`，与 reconversion 角色一致：

- 英文 reconversion
- 拼音 bundle 中的英文 reconversion
- 数字 reconversion
- 拼音 reconversion

其 data payload 尚未完整切分，但 reader 证据已经表明它使用压平 target array 加 start-position index 的结构，而不是 `InMemoryTokenExpander` 的逐 source 变长记录。

## Class n-gram reader 证据

核心库保留以下诊断：

```text
ClassNGramModelReader
Load word to class map failed
Incorrect internal model type
ClassNGramModelMetadata
```

这确认 `pinyin_bigram` 至少包含：

- word-to-class map
- 内部 n-gram model
- class n-gram metadata

上一轮定位的两个 Marisa trie 中，至少一个参与 word-to-class map。当前尚无充分证据将 58,560-key trie 或 4,968-key trie 分别命名为 word trie、class trie 或 n-gram index。

## GenericDataModelCreator

核心库包含 `GenericDataModelCreator`，并保留多种 model type 字符串：

```text
SingleTrieStaticDictionary
EncodedSingleTrieStaticDictionary
ConstFst32NgramModel
VectorFstNgramModel
TensorFlowLstmModel
```

这些字符串证明同一 HMM 框架具备多个数据模型 factory 分支，不证明当前拼音 APK 实际注册或使用所有分支。当前 data scheme 只确认本 APK 的 type 4、5、6、22、26 和 28 数据路径。

## 已确认事实

- ForwardTokenDictionary auxiliary data 由多张 token 相关表组成
- 八个拼音类 token dictionary 都包含 length-prefixed protobuf config
- 八个 token count 全部等于各自 Marisa key count
- 全拼和双拼的可接受输入符号集合不同
- 六套双拼即使大小相同，内容也不相同
- 笔画使用不同的 ForwardTokenDictionary 变体
- InMemoryTokenExpander 的目标附加字段是 expansion score
- DirectMappingTokenExpander 使用 key、start-position、target、score 和 metadata 表
- class n-gram reader 需要 word-to-class map 和内部 model

## 推断

- ForwardTokenDictionary 的多张 auxiliary 表很可能按 Marisa key ID 或 node ID 对齐
- 笔画很可能启用了 custom token encoding
- 默认 fuzzy 的 `-0.1` 是相对零分扩展的候选惩罚

这些推断仍需函数控制流或行为样本验证。

## 未知

- Forward auxiliary 各表的精确字节边界
- HMM token ID 的编码方式
- Marisa key ID、token ID、token code 和 node ID 的转换关系
- token score 与 prefix score 的单位
- DirectMapping 五张表的元素宽度和边界
- 两个 class n-gram trie 的具体职责
- data type 数值到 factory 构造函数的精确映射

## 对未来实现的约束

- token dictionary 接口必须区分外部输入 key、内部 token ID 和 trie node ID
- prefix score 不能与完整 token score 合并为一个无语义数值
- 模糊音 expansion 必须保留每条目标的独立 score
- reconversion 应使用可枚举的 source-to-target 结构，不依赖原版压平表布局
- 双拼方案不能按大小去重
- 笔画需要独立 token encoding 契约

## 下一步

1. 根据 reader 诊断顺序切分 ForwardTokenDictionary 的八张 auxiliary 表
2. 从 metadata protobuf 恢复 token code、score 和 encoding 配置
3. 将 fuzzy source/target token ID 与全拼 token table 对齐
4. 定位 `GenericDataModelCreator` 和各 storage reader 的 ARM64 构造调用
5. 解析 DirectMappingTokenExpander 的五张表
