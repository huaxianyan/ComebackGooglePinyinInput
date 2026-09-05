# Token dictionary auxiliary 与 native reader 研究

## 文档状态

本文档继续研究 `ForwardTokenDictionary`、`InMemoryTokenExpander` 和 `DirectMappingTokenExpander` 的辅助数据，并将 data bundle 字节结构与 `libhmm_gesture_hwr_zh.so` 中保留的 reader 诊断字符串交叉验证。

当前已经恢复八个拼音类 `ForwardTokenDictionary` 的位压缩辅助表边界，并将拼音、模糊音、首字母和数字 expansion 中的 token ID 对齐到 Marisa key。本文档不导出系统词典正文，也不开始新输入法实现。

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

因此，`ForwardTokenDictionary` 的 auxiliary data 不是单一 token 数组，而是多个互相关联的表。八个拼音类容器已经确认包含 token ID、token score、token metadata 和 token code。除数字词典外，另外六套双拼与全拼还包含 token node ID 和 prefix score。

native reader 提到的 `custom token encoding` 和 `meta data` 尚未恢复为独立区间。它们可能由前置 config、容器 header 或特定变体承载，不能仅按诊断字符串顺序假定一定存在额外表。

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

`token_count` 与 trie key 数量相等，证明每个 Marisa key ID 都有一个辅助表槽位，但不代表 Marisa key ID 与内部 token ID 数值相等。

### 位压缩辅助表

除笔画外，八个容器都使用 little-endian、低位优先的连续位流。表尾以零填充到 8-byte 边界。第一张 token ID 表省略 count，因为外层已经给出 `token_count`：

```text
uint32_le token_id_bit_width
packed_lsb token_ids[token_count]
zero padding to 8-byte boundary
```

后续表使用统一头部：

```text
uint32_le element_count
uint32_le bit_width
packed_lsb values[element_count]
zero padding to 8-byte boundary
```

全拼和六套双拼依次包含：

1. token IDs
2. token scores
3. token meta
4. token codes
5. token node IDs
6. prefix scores

前五张表的 count 均为 `token_count`。prefix score 使用独立 count，头部为 `uint32_le prefix_count` 和一个值为 `0`、语义未明的 32-bit 字段，随后是 `prefix_count` 个 8-bit 值和零结尾填充。

| dictionary | ID bits | score bits | meta bits | code bits | node bits | prefix count |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 全拼 | 26 | 8 | 4 | 16 | 10 | 535 |
| 智能 ABC | 26 | 8 | 4 | 16 | 9 | 482 |
| 小鹤双拼 | 26 | 8 | 4 | 16 | 9 | 484 |
| 拼音加加 | 26 | 8 | 4 | 16 | 9 | 508 |
| 微软双拼 | 26 | 8 | 4 | 16 | 9 | 488 |
| 紫光双拼 | 26 | 8 | 4 | 16 | 9 | 482 |
| 自然码 | 26 | 8 | 4 | 16 | 9 | 511 |

数字词典使用 28-bit token ID、1-bit score、6-bit meta 和 4-bit code，不含独立 node ID 或 prefix score。其 token ID 表和 score 表之间还有 8 个零字节，作用未知。当前工具验证这段字节，但不将其命名为 custom encoding。

### Token 身份对齐

全拼的 517 个 Marisa key 分别对应 517 个唯一 token ID、token code 和 node ID：

- token code 数值恰好连续覆盖 `0xE000`–`0xE204`，该范围落在 Unicode 私用区，但 native 是否按字符解释仍未知
- node ID 恰好是 `0`–`516` 的一个排列
- token ID 是另一组 26-bit 内部标识，不能由 Marisa key ID 或 token code 数值替代

expansion 记录引用的正是这组 token ID。当前已将以下 16 个 expansion 的全部唯一 source 和 target ID 零遗漏地映射回 key：

- 默认模糊音和 12 组可选模糊音
- 拼音 initial 和 reverse-initial
- 数字 reverse-initial

12 组可选模糊音中的每条 source 都包含自身和对应模糊音目标，反向记录也存在。其 source key 集与 target key 集完全相同。这解释了每组目标总数恰好是 source 数的两倍，并确认这些 blob 表达双向可选扩展，而不是单向字符串替换。

英文 reverse-initial 尚未纳入这项对齐，因为英文使用仍未切分的 `DirectTokenDictionary`。

### 双拼 alias

六套双拼都以 Marisa key ID 索引辅助表，但并非每个 key 都对应不同的内部 token：

| 方案 | key 数 | 唯一 token ID | alias key 数 |
| --- | ---: | ---: | ---: |
| 智能 ABC | 480 | 480 | 0 |
| 小鹤双拼 | 480 | 480 | 0 |
| 拼音加加 | 504 | 480 | 24 |
| 微软双拼 | 486 | 480 | 6 |
| 紫光双拼 | 480 | 480 | 0 |
| 自然码 | 507 | 480 | 27 |

重复关系同时出现在 token code 和 node ID 表中。例如，微软双拼的 `jt` 与 `jv`、`lt` 与 `lv` 分别收敛到同一内部 token。拼音加加和自然码也存在多输入 key 对一 token 的 alias。

这直接否定了「Marisa key ID 就是 HMM token ID」的假设。未来数据模型必须显式保留 `input key → token identity` 的多对一关系。

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

- 12 组可选 fuzzy 的 988 个目标全部为 `0.0`
- 默认 fuzzy 的 `c → c/ch`、`s → s/sh`、`z → z/zh` 分数为 `0.0`
- 默认 fuzzy 还将 `jv`、`qv`、`xv`、`yv` 及其 `van/ve/vn` 变体映射到 `ju`、`qu`、`xu`、`yu` 对应形式
- `lve → lue` 与 `nve → nue` 也属于默认映射
- 上述 `v` 形式归一化目标的 float32 分数均为约 `-0.1`

默认 fuzzy 因此同时承担默认翘舌扩展和 `v` 拼写归一化，并对后一类目标施加独立分数。

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

- 全拼和双拼 auxiliary 中五张 token 表的精确字节边界、元素数量和位宽已经恢复
- 全拼和双拼 prefix score 的精确字节边界已经恢复
- 数字词典包含四张 token 表，不含独立 node ID 和 prefix score
- 每个 token 表槽位由同一个 Marisa key ID 索引，但内部 token ID 是独立数值
- 三套双拼存在多 key 对一 token 的 alias
- 16 个拼音和数字 expansion 的全部 source 与 target token ID 都能映射回相应 key
- 八个拼音类 token dictionary 都包含 length-prefixed protobuf config
- 全拼和双拼的可接受输入符号集合不同
- 六套双拼即使大小相同，内容也不相同
- 笔画使用不同的 ForwardTokenDictionary 变体
- InMemoryTokenExpander 的目标附加字段是 expansion score
- DirectMappingTokenExpander 使用 key、start-position、target、score 和 metadata 表
- class n-gram reader 需要 word-to-class map 和内部 model

## 推断

- 默认 fuzzy 的约 `-0.1` 很可能是相对零分扩展的候选惩罚
- 笔画 header 的非零变体值可能与 custom token encoding 有关

这些推断仍需函数控制流或行为样本验证。

## 未知

- token ID 的位级语义和分段编码方式
- token score、token meta 与 prefix score 的量化公式和单位
- prefix count 与底层 trie node 的精确对应规则
- config、header 中哪些字段承载 custom token encoding 和 metadata
- 笔画 ForwardTokenDictionary 的辅助表布局
- DirectMapping 五张表的元素宽度和边界
- 两个 class n-gram trie 的具体职责
- data type 数值到 factory 构造函数的精确映射

## 对未来实现的约束

- token dictionary 接口必须区分外部输入 key、Marisa key ID、内部 token ID、token code 和 trie node ID
- token dictionary 必须允许多个输入 key 指向同一 token
- prefix score 不能与完整 token score 合并为一个无语义数值
- 模糊音 expansion 必须保留每条目标的独立 score
- reconversion 应使用可枚举的 source-to-target 结构，不依赖原版压平表布局
- 双拼方案不能按大小去重
- 笔画需要独立 token encoding 契约

## 下一步

1. 解析 `DirectMappingTokenExpander` 的五张表
2. 从 config 与 native reader 控制流恢复 score、meta、code 和 encoding 配置
3. 定位 `GenericDataModelCreator` 和各 storage reader 的 ARM64 构造调用
4. 将英文 reverse-initial ID 对齐到 `DirectTokenDictionary`
5. 独立拆解笔画 ForwardTokenDictionary 变体
