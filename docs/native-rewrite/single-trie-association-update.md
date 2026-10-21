# SingleTrie 已有关联读取与更新

已恢复底层有序键对查找及已有 payload 更新，接入完整文件保存和加载。新增、删除、学习与原持久编辑器仍未实现，不将现有原语组装成占位编辑后端。

## 记录含义

SingleTrie 的十四字节记录不是 IndexRange 加 payload：

| 偏移 | 内容 |
| --- | --- |
| 0 | 第一个 trie terminal node ID，四字节小端 |
| 4 | 第二个 trie terminal node ID，四字节小端 |
| 8 | 六字节 payload |

两个键共享一个 trie。不同端点的列表可以指向同一条定长记录，自关联只需一个端点列表。键对有顺序，`(a, b)` 与 `(b, a)` 可以保存不同 payload。

原 `0x1c7ff4` 沿第一个键的池范围逐条读取，两个节点 ID 同时匹配才返回，顺序不交换。`0x1c7f7c` 先解析池中的 record ID，再读定长表。已有 KeyPair 补丁 `0x1c80cc` 分别写两个节点 ID 和偏移八的 payload。

## 共用与入口

[association_records.h](../../research/native-rewrite/recovered/association_records.h) 现在统一提供 AssociationRecordHeaderSize。已有 TargetKey 和 KeyPair 补丁、SingleTrie 初始化及 payload 读取共用它，未新建另一份记录结构。

原有 FindAssociationRecord 增加可选第二键，在同一实现中选择 TargetKey 或有序 KeyPair。旧方向编辑、删除及修复保持原匹配规则。

[single_trie_association.h](../../research/native-rewrite/recovered/single_trie_association.h) 提供两个明确入口：

- ReadSingleTrieAssociationPayload 读取底层记录 payload，不代表完整候选或预测查询接口。
- UpdateSingleTrieAssociationPayload 对应 `0x1c8e60` 的已有关系更新路径，输入宽度按 `0x1c9c58` 检查，再由 `0x1c8508` 和共用 KeyPair 补丁更新记录。

API 只接受明确提供的 payload，不暴露尚未恢复的创建模式，也不建立临时编辑器。查找重建借用视图，更新经真实 MutableRecord 获取可写区域，处理只读映射的 COW。更新只改目标记录，不新增关系、不设置关联计数或调整外层累计权重。

## 验证及边界

新增一条实际文件流程，没有再建平行 fixture 框架：

- 通过已有 trie、CRC16、池和定长表原语组装三条 fixture：`(b, a)`、`(a, a)`、`(a, b)`。该 fixture 不是通过新增接口生成，也不是原 ARM64 运行导出的词典。
- 三条记录的 payload 使用独立字面值。目标 `(a, b)` 排在另外两条之后，更新必须同时匹配两个字段，保留反向和自关联 payload。
- 经共用完整文件入口写入、只读映射并保留副本，再更新目标 payload。元数据序列化字节保持原值，保留模型仍读到旧 payload。
- 缺失的 `(b, b)` 返回失败且记录数仍为三，对应原模式 2 的冻结行为，不用创建模式假装更新成功。
- 将更新后的模型写到另一路径，释放旧映射后清理本轮文件。重载读得新 payload、原内部关联数及独立外层累计值。

共用记录头和查找函数影响两个后端，严格全源码编译一次。新 SingleTrie 流程与原六子模型完整流程均通过，未重跑其他历史测试。临时文件、对象、archive 和二进制已清理，生成 protobuf 源码及日志保留。

四段新增 native 与保留发布库字节一致，中央增至 `325` 区域。已登记的 pair 查找、记录读取和 KeyPair 补丁沿用既有证据。中央收录完整 `0x1c8e60` 函数，不表示其中的新增分支已实现。

- `work/native-rewrite/ghidra/single-trie-entry-edit/`
- `work/native-rewrite/ghidra/single-trie-entry-primitives/`
- `work/native-rewrite/restart-v217/native-single-association-comparison.json`
- `work/native-rewrite/restart-v217/single-association-export.json`
- `work/native-rewrite/single-association-build/build.log`

复现沿用 [共用完整构建](mutable-dictionary-image.md#验证)，本轮测试名为 `single_trie_association` 和 `mutable_dictionary_image`。未执行原 ARM64，未操作设备、正式包或用户词典。分配故障、原编辑器生命周期与性能仍未等价验收。下一步恢复共享记录新增及节点搬迁修复，再接删除、学习与生命周期。
