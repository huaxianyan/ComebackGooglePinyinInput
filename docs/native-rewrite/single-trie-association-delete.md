# SingleTrie 物理关联删除

已恢复原编辑器 slot 5 的物理删除路径。它移除列表项及空端点，不调整用户词典外层累计，也不选择墓碑策略。后续已接 [用户级累计与保留标记策略](user-dictionary-removal-policy.md)，完整学习与原持久编辑器仍未接通。

## 原调用顺序

`0x1c9998` 通过已有键查找读取节点 ID 和范围，不创建键：

1. 自关联只读取、删池和发布一次。
2. 不同键先读取两侧，再分别调用 `0x1c8420`。两个列表都按相同的有序节点 ID 查找共享记录，均删除后才开始发布。
3. `0x1c9910` 对非空范围补写四字节引用并更新 trie 值，对空范围移除键。校验及值后缀保留。
4. 全部端点发布成功后，关联计数减一并设置字段存在性。

固定表记录不擦除、不收缩，物理表行数可以大于当前关联数。这里的「物理删除」指池和 trie 中的关系移除，不代表记录正文安全擦除。

## 共用原语

[single_trie_association.h](../../research/native-rewrite/recovered/single_trie_association.h) 新增 RemoveSingleTrieAssociation，复用同一 SingleTrieAssociationEditor 的实际值缓冲，不新建编辑对象或协议。

RemoveAssociationRecord 在同一实现中支持 TargetKey 和有序 KeyPair。查找先使用只读池视图，命中后才申请可写区域，再重建视图执行 EraseRecordId。失败查找不额外触发池 COW，该顺序也用于原六子模型调用。

PublishAssociationRange 共用空键移除和范围发布，取代六子模型原局部函数。它只改引用字段，不改 checksum/suffix。键移除经已有 DATrie 接口重绑 live view。

## 失败时序

删池、第一侧发布及第二侧发布之间没有事务回滚：

- 第二侧找不到共享记录时，第一侧已删的池项保留，两侧 trie 值尚未发布。
- 第一侧或第二侧发布失败时，已完成的池修改与第一侧发布保留。
- SingleTrie 只有全部发布成功才减关联数。六子模型原协调器在第一侧成功后，即使第二侧发布失败仍减计数，这个差异保留。

不把固定表遗留记录清理、外层权重调整或墓碑选择混进底层操作。OOM、各中间失败与原 ARM 运行结果尚未完整验收。

## 验证

扩展现有同一条 SingleTrie 实际创建、映射、搬迁及保存流程，没有新增平行 fixture：

- 从 197 条关联删除 `(a, b)`，反向及自关联 payload 保留，重复删除失败且计数保持 196。
- 删除 `(b, b)` 后，`(b, a)` 仍可读取。继续删除最后这条有向关系，端点 b 被移除，a 的其他关系继续可读。
- 删除 `(a95, a)` 后，其自关联仍可读取，再删最后的自关联，空端点 a95 被移除。
- 五次成功删除后，当前关联数为 `192`，固定表记录数仍为 `197`。保留模型的原 payload 不变。
- 保存到第三个独立路径并重载，确认删除结果、剩余 payload，以及独立的外层累计 `300` 和同步时间 `42`。

共用删除和发布原语跨模块，全源码严格编译一次，SingleTrie 扩展流程与原六子模型完整流程均通过。三份本轮文件、对象、archive 及二进制精确清理，生成源码与日志保留。

三段新增 native 与保留发布库字节一致，中央增至 `329` 区域。键查找、pair 匹配及记录读取沿用既有证据，不重证。

- `work/native-rewrite/ghidra/single-trie-delete-entry/002c9998.c`
- `work/native-rewrite/ghidra/single-trie-delete-primitives/`
- `work/native-rewrite/restart-v217/native-single-delete-comparison.json`
- `work/native-rewrite/restart-v217/single-delete-export.json`
- `work/native-rewrite/single-delete-build/build.log`

复现沿用 [共用完整构建](mutable-dictionary-image.md#验证)，测试名仍为 `single_trie_association` 和 `mutable_dictionary_image`。未执行原 ARM64，未操作设备、正式包或用户词典。上层删除策略现已接入，下一步恢复学习协调与生命周期。
