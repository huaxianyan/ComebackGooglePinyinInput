# SingleTrie 用户词典空初始化

已按真实 builder 恢复空存储配置及三个子模型初始化，接入已有镜像读写。该入口只构造拥有数据的存储，不建立原运行时工厂、持久编辑器或外层 UserDictionary。

## 实际工厂

原 `0x1a4d28` 使用的是 builder 注册表。它与注册 SingleTrieMutableDictionary 模型对象的表不同，不能把两种工厂混在一起。

静态入口 `0x7a324` 登记 SingleTrieMutableDictionaryBuilder，并把 SingleTrieMutableDictionary 别名指向它。构造回调为 `0x1a6dd4`，虚表地址点 `0x67b190` 的 slot 2 为 `0x1a6dfc`。

原用户词典初始化 `0x1a259c` 选择 VariableValueLengthTrie 和 DATrie，传入空的初始条目集。builder 继承调用方字母表、排除字节及 token category，然后创建三组件。

## 空存储参数

| 项目 | 原空用户词典配置 |
| --- | --- |
| 字母表 | 字节 1～255，排除字节 0 |
| forward payload | 共用六字节 payload |
| reverse data | 零 |
| forward trie omitted | false，字段已设置 |
| key checksum | true，字段已设置 |
| trie 值表宽度 | 四字节引用加两字节校验，合计六字节 |
| 短语表宽度 | payload 加八字节附加量，合计十四字节 |
| format parameter | 调用方传入的 token category |
| association count | 初始未设置，不写成显式零 |

后续 [已有关系更新取证](single-trie-association-update.md) 确认，八字节附加量是两个有序的 trie terminal node ID，不是 IndexRange。初始化与已有 KeyPair 补丁现共用记录头尺寸定义。元数据 presence 来自原 `0x2f` 掩码，继续复用同一 protobuf 消息与 payload 宽度定义。

builder 即使没有初始条目，也建立并结束编辑器。已追到 `0x1c9700`、`0x1c96e0` 和 `0x1c9658`，该空流程保留 MutableDictionaryMetaData 的关联计数未设置。本次不复制这些运行时对象，仅恢复空存储内容。

## 源码与边界

[single_trie_mutable_dictionary_init.h](../../research/native-rewrite/recovered/single_trie_mutable_dictionary_init.h) 的 InitializeSingleTrieUserStorage 接收明确的 token category，复用 InitializeDATrie、InitializeIndexPool 和 FixedPhraseTable。全部完成后发布新存储。

该函数没有通用 builder 参数、虚表兼容层或占位编辑器。原编辑器建立失败、各处分配失败和原模型就绪状态仍未复现。外层初始化的成功标记及失败行为沿用 [已有取证](legacy-single-trie-initialization.md)，不改成宿主 bool 的含义。

[上一轮三组件流程](single-trie-mutable-dictionary-image.md) 的八字节 trie 值和六字节短语表是显式 codec fixture。它继续验证格式，默认空配置以本页及新增入口为准。

## 验证

严格编译新增入口及实际依赖闭包，没有升级到全项目构建或重跑旧流程。测试入口为 `single_trie_mutable_dictionary_init_test.cc`，传入项目新建临时目录。复现也可按 [共用构建](mutable-dictionary-image.md#验证) 生成源码和 archive，再链接该测试。该测试自行删除文件，最后只需移除空目录。

测试只走一条初始化、写入、映射、加载路径：

- token category 为字面值 `31`，元数据序列化为 `08 06 10 00 18 00 20 01 30 1f`，关联计数保持未设置。
- 空三组件镜像为 `2760` 字节，使用独立字面偏移检查六字节值表和十四字节短语表。该尺寸仅适用于本次 category 的编码，不包括外层文件头。
- 项目临时文件实际写入并只读映射，加载后保留参数与宽度。读取器接受低位、高位非零字节，已有 trie 没有词条。
- 测试文件和可执行文件精确清理，生成 protobuf 源码与构建日志保留。

六段新增 native 与保留发布库字节一致，中央登记增至 `321` 区域。builder 注册函数只差数据页 ADRP，目标 `.data` 或 `.bss` 节内偏移一致，未加入字节一致清单。builder 虚表绑定一致，旧用户初始化及 VariableValueLengthTrieBuilder 证据直接复用。

- `work/native-rewrite/ghidra/single-trie-concrete-builder/`
- `work/native-rewrite/ghidra/single-trie-builder-{construct,create}/`
- `work/native-rewrite/ghidra/single-trie-user-default-params/`
- `work/native-rewrite/ghidra/single-trie-empty-editor-{lifetime,finish,release}/`
- `work/native-rewrite/restart-v217/native-single-trie-init-comparison.json`
- `work/native-rewrite/restart-v217/single-trie-init-export.json`
- `work/native-rewrite/single-init-build/build.log`

未执行原 ARM64，未操作设备或用户词典。下一步让同一外层镜像入口选择具体后端，再恢复 SingleTrie 编辑，不另建第二套文件头、元数据和保存协议。
