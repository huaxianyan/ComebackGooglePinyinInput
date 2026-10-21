# SingleTrie 三组件内存镜像

已恢复 SingleTrieMutableDictionary 当前格式的容器读写，复用现有元数据、trie、IndexPool 和定长表。原工厂的默认初始化、SingleTrie 词条编辑及外层文件选择尚未接通。

## 原格式与共用定义

原 writer `0x1ca3d8` 和 parser `0x1ca7f8` 使用以下顺序：

```text
MutableDictionaryMetaData 的长度前缀与八字节对齐段
命名 VariableValueLengthTrie
  命名 DATrie 与 DA-TRIE 数据
  命名 FixedPhraseTable 与 trie 值表
P-TABLE 范围池
命名 FixedPhraseTable 与短语表
```

该模型有三个直接子模型，区别于 MutableDictionary 六子模型。元数据仍是现有 MutableDictionaryMetaData，未增加消息副本。

原 parser 的「range table」直接调用已恢复的 `0x1e3cf0`，writer 使用 `0x1e3e4c`。它们就是已有 IndexPool 镜像，不新增 RangeTable 类、CRC 或分配器。

命名 trie、池、定长表和父流读取器从六子模型文件移到 `dictionary_submodel_image.h/.cc`，两个容器共用。DictionaryTrieStorage 也只有这一处定义。六子模型的组合顺序与接口保持不变。

## 源码入口

[single_trie_mutable_dictionary_image.h](../../research/native-rewrite/recovered/single_trie_mutable_dictionary_image.h) 提供三个子模型的拥有对象：trie、范围池和短语表。调用方显式提供元数据与初始化后的子模型。

- WriteSingleTrieMutableDictionaryImage 按原顺序写入共用 sink，沿用部分写入返回失败的规则。
- LoadSingleTrieMutableDictionary 只处理当前 protobuf 段，不含外层 UserDictionary 文件头，也不恢复旧版 24 字节元数据。
- loader 在局部候选中读取三个子模型，全部完成后才替换输出，对应原 `0x1cb034` 的发布顺序。

返回值为容器消耗长度。命名段及表的完整对齐范围由父读取器检查，后续父流仍可继续读取。可写操作使用共用 COW，修改或重载后重新取得 borrowed view。

## 初始化边界

原 `0x1a4e54` 取得工厂，调用其 slot 2，再销毁工厂包装。它所选实现如何处理初始化参数仍待恢复。本轮未添加该工厂、默认参数或就绪状态的替身。

测试显式初始化已有原语，并手动组成一个可读取的 fixture：trie 的值为范围，池中的元素为短语记录 ID，最后读取六字节记录。这用于验证三组件持久格式，不代表已恢复原生词条新增或学习。

外层词典的失败初始化分支仍按 [默认类型取证](legacy-single-trie-initialization.md) 处理。底层 codec 的局部候选发布不能代替外层失败后的原初始化行为。

## 验证

严格编译全部 recovered C++ 源码一次，使用共用 WSL1、官方 protobuf 3.0.0 和匹配运行库。共用模块抽取影响新旧容器，所以执行 SingleTrie 新流程及原六子模型完整流程，没有重跑其他产品验收。

新流程通过以下检查：

- 明确配置的空 fixture 为 `2768` 字节。元数据、命名 trie、P-TABLE 和短语表位置使用独立字面值，未由被测尺寸算法生成。该尺寸不表示原工厂默认空词典大小。
- 用真实原语组成一个 trie、池和记录表的可达记录，写入项目临时文件并只读映射。读取经实际三组件得到字面 payload，元数据存在性与未知字段保留。
- 重新取得可写记录，修改后保存第二代镜像。最后一条短语缺少 payload 字节时，加载失败且已有模型保留，对应原 parser 的明确错误及候选发布边界。
- 释放旧映射再覆盖文件，重新映射后通过同一读取路径取得新 payload。精确清理本流程文件及编译出的临时二进制。

复现使用 [共用完整构建](mutable-dictionary-image.md#验证)，新增测试入口为 `single_trie_mutable_dictionary_image_test.cc`。

原工厂调用、writer 和 parser 三段与保留发布库字节一致，中央登记为 `315` 区域。已有 P-TABLE、元数据和公共子模型证据直接复用，不重复比较。

- `work/native-rewrite/ghidra/single-trie-create-parse/`
- `work/native-rewrite/ghidra/single-trie-range-image/`
- `work/native-rewrite/restart-v217/native-single-trie-image-comparison.json`
- `work/native-rewrite/restart-v217/single-trie-image-export.json`
- `work/native-rewrite/single-container-build/build.log`

真实 APK 导出核对三个新区域及独立 FDE 端点。未执行原 ARM64，未访问设备或用户词典。下一步恢复真实工厂初始化，再让外层镜像选择已恢复的具体后端，不通过改模型名模拟接入。
