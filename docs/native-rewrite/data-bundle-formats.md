# Google 拼音 4.5.2 data bundle 格式研究

## 文档状态

本文档记录 `liben_data_bundle.so` 和 `libpinyin_data_bundle.so` 中 63 个命名 blob 的精确导出、格式分类和第一轮 schema 恢复结果。

本轮没有反编译词典内容，也没有将原版数据纳入未来产品方案。导出的二进制文件和机器清单仅保存在被忽略的 `work/` 中。

## 可复现方法

执行：

```text
PYTHONPATH=tools/python python research/native-rewrite/tools/extract_data_bundles.py \
  --apk original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk \
  --output-dir work/native-rewrite/original-apk/data-bundles \
  --manifest work/native-rewrite/original-apk/data-bundle-manifest.json
```

脚本会：

1. 直接从固定 APK 读取两个 data bundle
2. 配对全部 `_binary_<name>_start` 和 `_binary_<name>_end` symbol
3. 验证区间非空、完整且互不重叠
4. 将 ELF virtual address 映射为原始 blob
5. 记录大小、地址、文件偏移、SHA-256、entropy 和格式 marker
6. 验证完整 protobuf wire stream
7. 按已恢复的 `Data.DataScheme` 字段布局解析数据注册关系
8. 切分拼音类 ForwardTokenDictionary 的位压缩辅助表
9. 将拼音和数字 expansion token ID 对齐到 Marisa key
10. 将 63 个 blob 分别写入被忽略的输出目录

脚本不依赖原先手工提取的 `.so`，输入只需要原始 APK。

## 完整性结果

| data bundle | blob 数 | 命名载荷 | blob 间 padding | 未知格式 |
| --- | ---: | ---: | ---: | ---: |
| `liben_data_bundle.so` | 8 | 1,241 bytes | 887 bytes | 0 |
| `libpinyin_data_bundle.so` | 55 | 10,059,206 bytes | 6,602 bytes | 0 |
| 合计 | 63 | 10,060,447 bytes | 7,489 bytes | 0 |

63 组 symbol 全部满足：

- start 和 end 一一配对
- `start < end`
- 位于唯一 ELF section 中
- 导出字节数与 symbol 区间长度一致
- 相邻命名区间没有重叠

两个 `.rodata` 在最后一个命名 blob 后还分别有少量尾部字节，因此「命名载荷加内部 padding」小于整个 `.rodata` 是预期结果，不是导出缺失。

## 格式分类

| 分类 | 数量 | 已确认依据 |
| --- | ---: | --- |
| protobuf wire stream | 17 | 可完整消费全部字节，且与 JADX 中的 nano protobuf 读取路径一致 |
| `InMemoryTokenExpander` | 17 | 原生容器类型 marker |
| `ForwardTokenDictionary` | 9 | 原生容器类型 marker 和 Marisa marker |
| Marisa container | 7 | `We love Marisa.` marker；包括 gesture bigram 和六套 token ID table |
| `DirectMappingTokenExpander` | 4 | 原生容器类型 marker |
| `DirectTokenDictionary` | 4 | 原生容器类型 marker |
| `MarisaTrie` dictionary | 4 | `MarisaTrie` 和 Marisa marker |
| class n-gram model | 1 | `ClassNGramModel` 和 `ClassBigramModel` marker |

所有 46 个非 protobuf blob 都能归入已知容器家族。进一步的 class envelope、expansion 记录和 Marisa 区间分析见 `setting-and-container-formats.md`；system dictionary 的辅助数据和评分语义仍未恢复。

`We love Marisa.` 是 Marisa trie 格式识别线索。它不能单独证明所有含该 marker 的 blob 都具有相同顶层 schema。

## protobuf 载荷

17 个 protobuf blob 分成三组：

| 类别 | 数量 | Java 侧证据 |
| --- | ---: | --- |
| data scheme | 3 | `Data$DataScheme` 和 `DataManager.enrollBuiltInDataScheme()` |
| engine 或 gesture setting scheme | 10 | `cda.a(byte[])` 和 `SettingManager.loadBuiltInSettingScheme()` |
| mutable dictionary accessor setting scheme | 4 | `SettingManager.enrollSettingScheme()` 和 accessor 初始化链 |

### Data.DataScheme

JADX 已恢复顶层字段：

| field | wire type | 语义 |
| ---: | ---: | --- |
| 1 | length-delimited | repeated data definition |
| 2 | length-delimited | data bundle library name |
| 3 | length-delimited | 可选字符串，当前内置 scheme 未设置 |
| 4 | varint | 可选整数，当前内置 scheme 未设置 |

每个 data definition 对应混淆类 `ccf`。本轮可以稳定读取的字段为：

| field | wire type | 当前含义 |
| ---: | ---: | --- |
| 1 | varint | data type enum 数值 |
| 2 | length-delimited | native data ID |
| 3 | varint | storage type enum 数值 |
| 4 | length-delimited | bundle 中的 blob 名称 |

其他 `ccf` 字段在三个内置 scheme 中没有出现。enum 名称尚未恢复，因此当前只记录数值，不为其编造名称。

### 三个 data scheme

| scheme | 注册项 | 指向的 bundle |
| --- | ---: | --- |
| `en_data_scheme` | 3 | `liben_data_bundle.so` |
| `data_scheme` | 36 | `libpinyin_data_bundle.so` |
| `gesture_data_scheme` | 7 | `libpinyin_data_bundle.so` |

全部 46 个注册项都指向同一 ELF 中真实存在的命名 blob，storage type 均为数值 `2`。

data type 数值与载荷家族的对应关系已经确认到以下程度：

| data type | 数量 | 载荷角色 |
| ---: | ---: | --- |
| 4 | 13 | token dictionary |
| 5 | 21 | token expansion 或 reconversion expansion |
| 6 | 1 | 拼音 class n-gram model |
| 22 | 4 | 拼音系统词典 |
| 26 | 1 | gesture bigram |
| 28 | 6 | 双拼 token ID table |

这里的角色来自 data ID、blob 名称和容器 marker 的交叉验证；enum 的原始符号名称仍未知。

## 拼音数据关系

### system dictionary

以下四个 blob 均以 `MarisaTrie` 容器开头：

| blob | 大小 |
| --- | ---: |
| `pinyin_system_dictionary` | 5,374,840 bytes |
| `pinyin_system_english_dictionary` | 295,256 bytes |
| `pinyin_system_digits_dictionary` | 45,648 bytes |
| `pinyin_system_emoji_dictionary` | 25,728 bytes |

这确认中文、混输英文、数字和 Emoji 是四个独立 dictionary data source。它们是否共享 value 编码和权重结构仍未知。

### bigram

`pinyin_bigram` 大小为 3,151,376 bytes，包含：

```text
ClassNGramModel
ClassBigramModel
We love Marisa.
```

其中出现两个 Marisa marker。两个 trie 已经可以分别精确 round-trip，包含 58,560 和 4,968 个 key。它们具体承担 class map、unigram、bigram 还是其他索引职责，尚待结合 native reader 验证。

`pinyin_gesture_bigram` 是独立的 186,331-byte Marisa container，由 `gesture_data_scheme` 以 data type `26` 注册。它不是普通拼音 `pinyin_bigram` 的别名。

### token dictionary

`ForwardTokenDictionary` 包括：

- 全拼 token
- 数字 token
- 六套双拼 token
- 笔画 token

`DirectTokenDictionary` 包括：

- 英文 token
- shortcuts token
- 拼音 bundle 内的英文 token
- 拼音 bundle 内的 shortcuts token

全拼和双拼均使用 forward dictionary，说明输入串到内部 token 的映射支持前缀或 trie 查找。英文及 shortcuts 使用 direct dictionary，具体查找差异仍需 native reader 佐证。

### expansion

17 个 `InMemoryTokenExpander` 包括：

- 12 组可选模糊音
- 1 组默认模糊音
- 拼音 initial expansion
- 拼音 reverse-initial expansion
- 英文 reverse-initial expansion
- 数字 reverse-initial expansion

4 个 `DirectMappingTokenExpander` 包括：

- 英文 reconversion
- 拼音 bundle 中的英文 reconversion
- 拼音 reconversion
- 数字 reconversion

因此，模糊音、首字母和反向首字母扩展不是系统词典中的特殊词条，而是独立注册的数据源。

## 双拼链路

每套双拼都具有两个不同 blob：

1. 约 9 KiB 的 `ForwardTokenDictionary`
2. 约 5 KiB 的 gesture token ID table

| 方案 | token dictionary | gesture token ID table |
| --- | ---: | ---: |
| 智能 ABC | 9,312 bytes | 5,096 bytes |
| 小鹤双拼 | 9,312 bytes | 5,096 bytes |
| 拼音加加 | 9,552 bytes | 5,168 bytes |
| 微软双拼 | 9,376 bytes | 5,104 bytes |
| 紫光双拼 | 9,312 bytes | 5,096 bytes |
| 自然码 | 9,592 bytes | 5,176 bytes |

普通 HMM engine 通过 token dictionary 切换拼音方案；gesture setting 则同时切换相应的 token ID table。

`bdt` 的设置更新逻辑确认七种方案映射到七个 token dictionary ID。`bdv` 又确认非全拼方案会修改 gesture setting：

- QWERTY gesture 使用对应双拼 token dictionary 和 token ID table
- 九键 gesture 还会调整一个数值参数
- 开启模糊音时，会向 gesture setting 增加与主 HMM engine 的连接配置

因此，「双拼只替换普通键入 token 表」是不完整的。未来验收必须同时覆盖普通键入和滑行输入。

## setting scheme 结构

混淆类 `cda` 是 setting scheme 的 nano protobuf。它具有 field 1–21，其中 field 1 是 engine 或 setting ID，其余字段是不同子配置 message。

本轮确认的主 engine scheme：

| blob | field 1 ID | 顶层 field |
| --- | --- | --- |
| `pinyin_qwerty_setting_scheme` | `zh-t-i0-pinyin-x-f0-delight` | 1、2、3、4、5、6、10、11、12 |
| `pinyin_t9_setting_scheme` | `zh-t-i0-pinyin-x-l0-t9key` | 1、2、3、4、5、6、10、11、12、20 |
| `pinyin_handwriting_setting_scheme` | `zh-t-i0-handwriting` | 1、2、3、4、5、6、10、11、12 |
| `stroke_setting_scheme` | `zh-t-i0-stroke-x-p0-android` | 1、2、4、5、6、10、11、20 |
| `english_qwerty_setting_scheme` | `en_qwerty` | 1、15 |
| `english_9key_setting_scheme` | `en_9key` | 1、15 |

主拼音、九键和手写 scheme 都引用：

- 拼音 token dictionary
- 默认 fuzzy expansion
- 拼音 system dictionary
- 拼音 bigram model
- system optional、contacts 和 shortcuts mutable dictionary
- contacts、user 和 shortcuts 的英文 mutable dictionary ID

Java 层随后根据 Preference 修改反序列化后的 `cda`，再重新 enroll：

- 切换全拼或双拼 token dictionary
- 追加启用的 12 组 fuzzy expansion
- 按设置追加英文、数字、shortcuts 和 Emoji dictionary

这证明内置 setting scheme 是初始配置，不是最终运行时配置的不可变快照。

## 跨 bundle 重复载荷

SHA-256 验证发现三组完全相同的载荷：

1. `en_reconversion_expansion` 与 `english_reconversion_expansion`
2. 两个 bundle 中的 `shortcuts_tokens`
3. 两个 bundle 中的 `shortcuts_mutable_dictionary_accessor_setting_scheme`

这是物理重复，不是内容相似。未来架构可将它们建模为共享数据组件，不需要复制原版的 bundle 隔离方式。

`en_tokens` 与 `pinyin_english_token_v_2` 虽然都是 80 bytes 的 `DirectTokenDictionary`，但 SHA-256 不同，不能合并。

## 已确认事实

- 两个 data bundle 共包含 63 个完整、互不重叠的命名 blob
- 17 个 blob 是完整 protobuf wire stream
- 46 个 data scheme 注册项全部解析成功，并指向真实 blob
- 所有非 protobuf blob 都有已知原生容器 marker
- 拼音系统词典和 bigram 是独立数据源
- 普通拼音和 gesture 使用不同的 bigram 数据
- 双拼同时拥有普通 token dictionary 和 gesture token ID table
- 模糊音由独立 expansion 数据驱动
- setting scheme 会被 Java Preference 逻辑动态修改
- 拼音类 ForwardTokenDictionary 的 token ID、score、meta、code、node ID 和 prefix score 已分表切分
- 拼音和数字 expansion 的内部 token ID 已全部对齐到对应 Marisa key
- 部分双拼方案允许多个输入 key 指向同一内部 token

## 推断

- `ForwardTokenDictionary` 很可能提供前缀友好的输入到 token 映射
- `pinyin_bigram` 内部的两个 Marisa 结构很可能分别承担 class 或 n-gram 索引职责
- 原版 data manager 很可能通过 `dlopen` 和 `dlsym` 取得 start/end symbol

这些推断尚未由 native 函数体或运行时 trace 最终确认。

## 未知

- token score、meta 和 prefix score 的量化语义
- 笔画 token dictionary 的辅助表布局
- system dictionary 中词、拼音、词频和属性的排列方式
- bigram 权重、量化和 backoff 规则
- token ID 的位级语义及其跨数据版本稳定性
- `cda` field 2–21 的原始 proto 字段名称和多数数值参数单位
- data type 和 storage type enum 的原始符号名称
- 原版数据的许可证和未来可分发性

## 实现决策

- 未来引擎的数据契约按 token、lexicon、language model、expansion 和 setting 分层，不复制 ELF data bundle 包装
- 不将原版 10 MB bundle 直接纳入原生重写产物
- 在格式与许可证都明确前，不把原版词典视为可分发依赖
- 全拼、双拼、九键和 gesture 必须共享明确的 token identity 契约
- Preference 对 setting 的动态修改应转换为类型安全的配置模型，不延续 protobuf 字节修改模式

## 下一步

1. 在 [DirectMapping 字节布局](direct-mapping-layout.md) 基础上恢复索引查找与间接记录语义
2. 定位 native 中 `MarisaTrie`、`ForwardTokenDictionary` 和 `ClassNGramModel` reader
3. 将 data scheme 的 data type 数值映射到 native enum 或 factory
4. 分析 system dictionary 的 prefix 和 auxiliary 数据
5. 建立 token dictionary、system dictionary 和 bigram 之间的 ID 一致性检查
