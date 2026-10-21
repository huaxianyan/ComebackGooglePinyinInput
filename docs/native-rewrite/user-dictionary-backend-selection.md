# 外层镜像选择具体后端

SingleTrie 已接入同一份完整用户词典镜像、复制及文件读写协议。调用方明确选择模型，文件头与外层元数据保持原格式。

## 类型选择

`UserDictionaryStorage<Backend>` 同时拥有外层 UserDictionaryMetaData 和具体后端：

| Backend | 原模型 | 子模型数 |
| --- | --- | --- |
| MutableDictionaryStorage | DoubleTrieUserDictionary | 六 |
| SingleTrieMutableDictionaryStorage | SingleTrieUserDictionary | 三 |

类型没有默认参数。原数据类型 23、24 选 SingleTrie 的依据沿用 [legacy 表取证](legacy-single-trie-initialization.md)。当前没有运行时 DataManager 替身，由调用方明确实例化对应类型。

原文件头没有新增后端标记，也不通过内容猜测、失败重试或类型名称替换选择后端。业务字典类型与上述数据类型继续分开。

## 共用协议

以下入口各保留一份实现，通过具体后端的已有读写函数绑定完成选择：

- WriteUserDictionaryImage 和 SerializeUserDictionaryImage。
- LoadUserDictionaryImage 和 DuplicateUserDictionary。
- PersistUserDictionaryFile 和 LoadUserDictionaryFile。

文件头、外层消息、当前版本判断、六字节 payload 检查、规范尺寸比较及候选发布都共用。复制继续先序列化再加载，保持对应后端类型。绑定点只有函数指针，不增加逐方法转发壳。

文件入口继续用真实只读映射，宿主整文件消费者检查 exact EOF。写入仍先以 `wb` 打开，再序列化，flush/close 返回值仍不影响原写入结果。暂存、备份和替换属于上层协议，未复制进另一套 SingleTrie 文件实现。

规范尺寸由所选后端 writer 计数。子表和 trie 仍会分配临时镜像并计算 CRC，原直接尺寸计算的成本边界没有因此消失。

## 编辑范围

已恢复的删除和 compact 接口明确接受 `UserDictionaryStorage<MutableDictionaryStorage>`。旧测试和宿主传输也显式指定六子模型，未保留隐藏默认后端或类型别名。

SingleTrie 现覆盖空存储初始化、完整镜像、复制和文件读写。后续已接 [已有关系 payload 更新](single-trie-association-update.md)，词条新增、删除、学习、compact、原持久编辑器及 Android 生命周期仍未接通。类型选择不会让未恢复的编辑器看起来可用。

宿主传输 dictionary_persistence_driver 已按显式类型链接通过，仍服务六子模型 fixture。本轮没有重跑 Java 替换集成，也没有把它当作 SingleTrie 运行入口。

## 验证

外层存储类型和文件入口跨多个模块，严格全源码编译一次，运行两个实际受影响流程：

- 延伸现有 SingleTrie 初始化测试。category 31 的空容器为 `2760` 字节，设置外层累计和同步时间为零后，完整文件为 `2784` 字节。
- 完整头匹配独立字面 `3.1` 字节，外层段从偏移 `16` 开始，SingleTrie 段从偏移 `24` 开始。位置和期望值不由被测尺寸算法生成。
- 经实际文件入口保存、映射加载并复制 SingleTrie。修改副本的外层同步时间和扩展字节，再写入同一路径并读取，原对象保留先前元数据。
- 释放旧映射后，用原较短镜像覆盖较长副本。整文件加载成功到 EOF，短镜像不含上一代尾部。
- 原六子模型完整流程继续通过，覆盖编辑、原格式校验、复制、映射及较短文件覆盖。旧业务逻辑仅增加明确的类型参数。

临时文件、对象、archive 和可执行文件精确清理，官方生成源码与日志留在 `work/native-rewrite/user-backend-build/`。复现沿用 [共用完整构建](mutable-dictionary-image.md#验证)，本轮两个测试名为 `single_trie_mutable_dictionary_init` 和 `mutable_dictionary_image`。

本轮复用已有 native 取证，中央仍为 `321` 区域，没有重复字节比较或 ARM 导出。未执行原 ARM64，未操作设备、正式包或用户词典。下一步恢复 SingleTrie 真实词条编辑，再接学习与生命周期。
