# Setting schema 与原生数据容器研究

## 文档状态

本文档继续拆解 `data-bundle-formats.md` 已识别的 setting protobuf 和原生数据容器。当前已经恢复：

- setting scheme 的顶层 message 结构
- Preference 对关键 setting 字段的修改路径
- 17 个 `InMemoryTokenExpander` 的完整记录边界
- 9 个 `ForwardTokenDictionary` 的 Marisa trie 边界
- 7 个 gesture Marisa container 的 trie 边界
- 4 个 system dictionary 中 Marisa trie 的精确区间
- `pinyin_bigram` 内的两个 Marisa trie

尚未恢复所有字段的原始 proto 名称，也没有解码 system dictionary 的 value 数据和 n-gram 权重。

## 复现环境

项目本地分析依赖统一记录在：

```text
research/native-rewrite/requirements.txt
```

安装到被忽略的项目目录：

```text
python -m pip install --target tools/python \
  -r research/native-rewrite/requirements.txt
```

然后重新生成清单：

```text
PYTHONPATH=tools/python python research/native-rewrite/tools/extract_data_bundles.py \
  --apk original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk \
  --output-dir work/native-rewrite/original-apk/data-bundles \
  --manifest work/native-rewrite/original-apk/data-bundle-manifest.json
```

清单中的 Marisa 结果使用 `marisa-trie==1.4.1` 读取，并通过 `Trie.tobytes()` 验证序列化字节前缀完全相同。这里只使用 key 数量和序列化边界，不把原版 key 内容写入文档。

## SettingScheme 顶层结构

混淆类 `cda` 是 setting scheme 的 nano protobuf。JADX 已恢复 field 1–21 与 Java message class 的对应关系：

| field | Java 类型 | wire type | 当前证据边界 |
| ---: | --- | ---: | --- |
| 1 | `String` | 2 | engine 或 setting ID |
| 2 | `cdf` | 2 | token dictionary ID；`bdt` 会按全拼、双拼和混输设置修改 |
| 3 | `ccm` | 2 | token expansion ID 列表；`bdt` 会追加启用的模糊音 |
| 4 | `cco` | 2 | dictionary data setting；Java 会追加内置和 mutable dictionary |
| 5 | `cco` | 2 | 第二组 dictionary data setting；具体消费阶段未知 |
| 6 | `ccm` | 2 | 当前内置拼音 scheme 指向 `pinyin_bigram` |
| 7 | `ccj` | 2 | 当前导出的 setting 未使用 |
| 8 | `ccm` | 2 | 当前导出的 setting 未使用 |
| 9 | `ccm` | 2 | 当前导出的 setting 未使用 |
| 10 | `ccn` | 2 | 大型 engine 参数 message |
| 11 | `ccm` | 2 | 当前内置拼音 scheme 再次指向 `pinyin_bigram`，具体职责未知 |
| 12 | `ccr` | 2 | repeated dictionary 参数 |
| 13 | `ccw` | 2 | mutable dictionary accessor 参数 |
| 14 | `ccm` | 2 | 当前导出的 setting 未使用 |
| 15 | `ccb` | 2 | gesture decoder 配置 |
| 16 | `ccm` | 2 | 当前导出的 setting 未使用 |
| 17 | `ccx` | 2 | 当前导出的 setting 未使用 |
| 18 | `cct` | 2 | 当前导出的 setting 未使用 |
| 19 | `ccu` | 2 | keyboard layout message；当前导出的 setting 未使用 |
| 20 | `cdg` | 2 | 九键和笔画 scheme 使用的两字段参数 |
| 21 | `cdb` | 2 | 当前导出的 setting 未使用 |

「当前未使用」只表示本 APK 的 14 个内置 setting blob 没有编码该字段，不代表 native engine 不支持它。

### 可稳定命名的子结构

#### field 2：token dictionary setting

`cdf` 包含：

- field 1：repeated string data ID
- field 2：repeated `ccq`

`bdt` 直接改写 field 1，使它成为当前拼音方案 token dictionary，并按设置追加英文、数字和 shortcuts token dictionary。field 2 在当前内置 scheme 中没有出现，语义未知。

#### field 3：token expansion setting

`ccm` 是单字段 repeated string message。`bdt` 会在 field 3 中保留默认 fuzzy expansion，并追加用户启用的 12 组模糊音 expansion。

#### field 4 和 field 5：dictionary data setting

`cco` 包含 repeated `ccp`。每个 `ccp` 为：

| field | 类型 | Java 侧用途 |
| ---: | --- | --- |
| 1 | enum 数值 | dictionary type |
| 2 | string | dictionary data ID 或 mutable dictionary 文件名 |

`AbstractHmmEngineFactory.appendItemToDictionaryDataSetting()` 明确按此结构追加 dictionary。field 4 和 field 5 都会经过 mutable dictionary 更新逻辑，但两个字段在 native 中分别用于什么阶段仍未知。

#### field 10：engine 参数

`ccn` 是最大的参数 message，已声明 70 余个 field，包含：

- bool、int、float 和 enum 参数
- repeated 子配置
- token decoder class
- 多组容量、阈值、数量和开关

当前 scheme 中 field 53 明确写入 `BFSTokenDecoder`。其余数值不能仅凭默认值命名。

QWERTY、九键、手写和笔画使用不同的 field 10 参数。例如：

| 参数 | QWERTY | 九键 | 手写 | 笔画 |
| --- | ---: | ---: | ---: | ---: |
| field 13 | 1024 | 1024 | 1024 | 96 |
| field 16 | 400 | 2000 | 300 | 1000 |
| field 22 | 1 | 1000 | 1 | 未设置 |
| field 30 | 1 | 1 | 10 | 1 |
| field 38 | 1 | 1 | 10 | 1 |
| field 40 | 3 | 3 | 10 | 3 |

这些差异证明四种 engine 不是只更换 token dictionary。字段名称和单位尚未确认，不能将上述数字直接固化到未来实现。

#### field 12：dictionary 参数

`ccr` 包含 repeated `ccs`。`ccs` 的四个字段为：

1. dictionary ID
2. int 参数
3. int 参数，默认值为 `1`
4. float 参数，默认值为 `0.0002`

当前拼音 scheme 包含 system optional、联系人、shortcuts 及其部分英文 dictionary 参数。字段 2–4 的准确名称仍未知。

#### field 13：mutable dictionary accessor

`ccw` 的默认 class 字符串为：

```text
DoubleTrieUserDictionary
```

其余字段包括 bool、分隔字符字符串和 int。拼音 accessor scheme 将 field 1 设为 `false`、field 4 设为 `true`；英文 accessor 还覆盖分隔字符。该结构属于 mutable dictionary 存储与解析参数，不是候选列表本身。

#### field 15：gesture setting

`ccb` 包含 repeated `ccd` gesture module。`ccd` 继续引用：

- module ID，例如 `zh_pinyin` 或 `en_wordlist`
- 一组权重和数量参数
- token dictionary、token ID table、gesture bigram 或英文 system dictionary

`bdv` 会按拼音方案修改这些引用。因此 gesture 数据配置和普通 HMM setting 是两条同步更新的链路。

## SettingScheme 组合

| setting 类别 | 顶层 field |
| --- | --- |
| 拼音 QWERTY | 1、2、3、4、5、6、10、11、12 |
| 拼音九键 | 1、2、3、4、5、6、10、11、12、20 |
| 拼音手写 | 1、2、3、4、5、6、10、11、12 |
| 笔画 | 1、2、4、5、6、10、11、20 |
| 英文 QWERTY 和九键 | 1、15 |
| 四种拼音 gesture 组合 | 1、15 |
| 拼音和英文 mutable accessor | 1、2、3、13 |
| shortcuts mutable accessor | 1、2、13 |

内置 protobuf 是可修改的初始 setting。Java 会在 enroll 前根据 Preference 重新写入数据源和参数，不能把 blob 的原始内容直接视为最终运行时状态。

## 通用 class envelope

所有带 class marker 的 token 和 expansion 容器都使用相同外层前缀：

```text
uint32_le class_name_size
byte[class_name_size] class_name
zero padding to 8-byte boundary
class-specific payload
```

已确认的 class name：

```text
DirectTokenDictionary
ForwardTokenDictionary
InMemoryTokenExpander
DirectMappingTokenExpander
MarisaTrie
```

class name 是 native factory 选择具体 reader 的稳定证据。class-specific payload 不能按一种统一结构解析。

## InMemoryTokenExpander

17 个 `InMemoryTokenExpander` 都可按以下结构完整消费：

```text
class envelope
uint32_le config_size
byte[config_size] protobuf config
zero padding to 8-byte boundary
uint32_le record_count
repeated record {
  uint32_le source_token_id
  uint32_le target_count
  repeated target {
    uint32_le target_token_id
    float32_le expansion_score
  }
}
uint32_le zero trailer
```

每个文件都满足：

- 16 个 config 为 8 bytes，数字 reverse-initial config 因 field 3 的两字节 varint 而为 9 bytes
- record_count 条记录全部可解析
- source token 数量与 record_count 一致
- target_count 不越界
- 结尾恰好剩余 4-byte zero trailer

### config 模式

config 由四个 varint field 组成：

| 载荷家族 | field 1 | field 2 | field 3 | field 4 |
| --- | ---: | ---: | ---: | ---: |
| initial expansion | 1 | 0 | 16 | 1 |
| fuzzy expansion | 2 | 0 | 16 | 1 |
| reconversion expansion | 3 | 0 | 0、16 或 300 | 1 |
| reverse-initial expansion | 4 | 0 | 0、16 或 300 | 0 |

field 1 与文件职责稳定对应，可以视为模式 enum 数值。field 2–4 的名称和单位仍未知。

### 记录规模

| expansion | source records | targets |
| --- | ---: | ---: |
| 拼音 initial | 26 | 487 |
| 拼音 reverse-initial | 414 | 414 |
| 英文 reverse-initial | 26 | 26 |
| 数字 reverse-initial | 10 | 10 |
| 默认 fuzzy | 21 | 24 |
| 12 组可选 fuzzy 合计 | 494 | 988 |

12 组可选 fuzzy 的每个 source 都有两个 target，说明它们按双向映射编码。默认 fuzzy 同时包含 1-target 和 2-target 记录，不等同于任意一组可选模糊音。

native reader 的错误文案将目标记录的第二个 32-bit 字段称为 `expanding score`。绝大多数记录的分数为 `0.0`，默认 fuzzy 的部分记录为约 `-0.1`。因此，该字段已从推断提升为已确认的 expansion score。

## ForwardTokenDictionary

9 个 `ForwardTokenDictionary` 具有共同结构：

```text
class envelope
uint64_le marisa_size
uint64_le second_header_word
byte[marisa_size] marisa_trie
auxiliary data
```

Marisa 区间均可精确 round-trip：

| dictionary | Marisa keys | Marisa bytes | auxiliary bytes |
| --- | ---: | ---: | ---: |
| 全拼 | 517 | 4,976 | 4,856 |
| 数字 | 10 | 3,440 | 144 |
| 智能 ABC | 480 | 4,824 | 4,440 |
| 小鹤双拼 | 480 | 4,824 | 4,440 |
| 拼音加加 | 504 | 4,848 | 4,656 |
| 微软双拼 | 486 | 4,824 | 4,504 |
| 紫光双拼 | 480 | 4,824 | 4,440 |
| 自然码 | 507 | 4,856 | 4,688 |
| 笔画 | 90,701 | 150,112 | 550,144 |

进一步分析确认，该首个 uint32 是 length-prefixed token config 的字节数，不是 token count。config 后还有一个独立 token count，八个拼音类容器均与各自 Marisa key 数量相等。native reader 又确认 auxiliary data 包含 token ID、score、meta、code、node ID 和 prefix score 等多张表，详见 `token-dictionary-auxiliary.md`。

笔画容器明显不同：第二个 header word 为 `4`，其他八个容器为 `0`，且 auxiliary data 远大于 trie。它虽然复用 `ForwardTokenDictionary` class，但不是拼音 token 表的简单变体。

## Gesture Marisa container

`pinyin_gesture_bigram` 和六套双拼 token ID table 的 Marisa 区间都从 offset 56 开始，长度记录在 offset 40 的 uint64 中。

| blob | Marisa keys | Marisa bytes | auxiliary bytes |
| --- | ---: | ---: | ---: |
| gesture bigram | 424 | 4,800 | 181,475 |
| 智能 ABC token ID | 409 | 4,080 | 960 |
| 小鹤双拼 token ID | 409 | 4,080 | 960 |
| 拼音加加 token ID | 431 | 4,128 | 984 |
| 微软双拼 token ID | 415 | 4,080 | 968 |
| 紫光双拼 token ID | 409 | 4,080 | 960 |
| 自然码 token ID | 434 | 4,128 | 992 |

六个 token ID table 共享同一组前导常量，只在 Marisa 和 auxiliary data 中体现方案差异。gesture bigram 的前导标志不同，且 auxiliary data 大得多。

## System dictionary 中的 Marisa

四个 `MarisaTrie` dictionary 都由三部分组成：

```text
class envelope
prefix metadata
marisa_trie
auxiliary data
```

| dictionary | prefix | Marisa keys | Marisa bytes | auxiliary bytes |
| --- | ---: | ---: | ---: | ---: |
| 中文系统词典 | 2,128,288 | 527,754 | 1,732,080 | 1,514,456 |
| 英文混输词典 | 21,224 | 30,578 | 83,824 | 190,192 |
| 数字词典 | 920 | 4,969 | 12,584 | 32,128 |
| Emoji 词典 | 5,344 | 2,416 | 13,592 | 6,776 |

Marisa key 数量不等于整个 dictionary 的候选条目数。prefix 和 auxiliary data 很可能保存 token、value、权重或属性，但尚未确认具体布局。

## Pinyin bigram 中的 Marisa

`pinyin_bigram` 中已经精确定位两个独立 trie：

| offset | Marisa keys | Marisa bytes |
| ---: | ---: | ---: |
| 175,864 | 58,560 | 165,576 |
| 2,673,880 | 4,968 | 18,056 |

同一容器还包含 `ClassNGramModel` 和 `ClassBigramModel` marker。两个 trie 的具体职责尚不能仅凭 key 形状命名。

## 已确认事实

- `cda` field 1–21 的 Java message 类型已经完整映射
- token、fuzzy、dictionary 和 gesture 的 Preference 修改点已经定位
- 17 个 `InMemoryTokenExpander` 可按统一记录结构完整消费
- 9 个 `ForwardTokenDictionary` 的 Marisa 区间和 key 数量已经确定
- 7 个 gesture Marisa container 的 trie 区间已经确定
- 4 个 system dictionary 都包含一个可精确 round-trip 的 Marisa trie
- `pinyin_bigram` 包含两个独立 Marisa trie
- 笔画与拼音虽然共用容器 class，但 header 和 auxiliary 结构明显不同

## 推断

- system dictionary 的 prefix 和 auxiliary data 很可能承载 key 之外的 token、value 和权重
- field 6 与 field 11 虽然都引用 `pinyin_bigram`，但应服务于不同 engine 阶段

这些推断仍需 native reader 或运行时行为验证。

## 未知

- `cda` 大多数数值字段的原始名称和单位
- ForwardTokenDictionary auxiliary data 的具体 schema
- system dictionary prefix 与 auxiliary value 的连接方式
- bigram 两个 trie 的职责和权重编码
- Marisa ID 是否直接等于 HMM token ID
- DirectTokenDictionary 与 DirectMappingTokenExpander 的完整 payload 结构

## 对未来实现的约束

- 设置模型必须显式区分 token source、expansion、lexicon、language model 和 gesture source
- 双拼切换必须原子更新普通 token dictionary 与 gesture token ID table
- 模糊音必须表达有向 token expansion 和可选 score adjustment
- 笔画不能复用拼音 token dictionary 的 auxiliary parser
- 系统词典 API 不能假设「一个 trie key 对应一个候选」
- 原版参数数值在语义和单位确认前不进入未来产品常量

## 下一步

1. 切分 ForwardTokenDictionary auxiliary data 中的八张表
2. 将 fuzzy token ID 与 ForwardTokenDictionary key/ID 对齐
3. 定位 native data type factory 与各 reader 的构造入口
4. 分析 system dictionary prefix 和 auxiliary 区域的整数表关系
5. 将动态 JNI 注册表映射到函数地址，并连接 DataManager 与 SettingManager reader
