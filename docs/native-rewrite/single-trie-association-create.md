# SingleTrie 共享记录新增与节点修复

已恢复原 `0x1c8e60` 的共享记录新增与已有更新协调，接入 `0x1c8928` 节点 ID 修复。后续已接 [物理关联删除](single-trie-association-delete.md)，上层删除策略、学习、compact 和运行时持久编辑器仍未恢复。

## 一个协调入口

[single_trie_association.h](../../research/native-rewrite/recovered/single_trie_association.h) 使用 SingleTrieAssociationEditor 保留记录及两个值的 scratch。它只持有存储引用和实际缓冲，不模拟就绪标记、工厂或原对象 ABI。

ModifySingleTrieAssociation 同时处理 CreateOrUpdate 和 ExistingOnly。上一阶段的 UpdateSingleTrieAssociationPayload 已移除，未保留转发壳。ReadSingleTrieAssociationPayload 继续提供底层记录读取，不代替候选或预测查询。

编辑模式、九位计数上限、按 ID 更新记录以及记录 ID 入池均收至已有共用模块。六子模型和 SingleTrie 共用这些原语，不另建池、分配器或记录结构。

## 新增顺序

1. 按原入口检查 payload 宽度及键，读取已有值，创建模式才允许插入缺失键。
2. 原元数据第 3、4 个布尔字段分别决定两个端点新建值的 CRC16，自关联使用两者的 OR。默认第一个端点可保留零校验字节。共享消息的研究名 forward_trie_omitted 不能直接当作 SingleTrie 省略模型的含义。
3. 先尝试更新已有有序记录。已有关系不增加计数，null payload 只确认匹配存在。
4. 新增时先写一条十四字节共享记录，再把同一 ID 链入端点列表。自关联只链一次，普通键对链两次。单个列表最多 511 项。
5. 补好复制值中的池范围后发布 trie 值，全部完成才增加关联数并设置字段存在性。外层累计权重仍由上层维护。

记录 scratch 跨调用保留，省略新增 payload 会保留上次 append 缓冲的 payload，不从上一次已有更新自动取得。新键值先清零，再按对应端点标志写校验。

## 节点搬迁

DATrie 的同步通知使用已经重建的 live view 读取新 terminal ID 的值与范围，然后逐条检查共享记录：

- 第一节点 ID 等于旧值时只改第一字段。
- 第二节点 ID 等于旧值时只改第二字段。
- 自关联同时改两个字段，均不匹配时无需获取可写记录。
- 遇到读取或补丁失败立即停止，已修复记录保留，void 通知不把失败传回插入。

更新经共用 MutableRecord 和 KeyPair 补丁，支持只读映射 COW。记录可写访问后不再使用先前的记录指针，池范围分配后不复用旧池视图。

## 失败及未覆盖边界

原实现不是事务：记录追加、第一侧池、第二侧池和值发布可能只完成一部分。自关联新增失败后，只有当前范围仍为空才删除该键。不同键分支没有对应空键清理，不移植六子模型的双端清理规则。

原协调器在第二个键插入前已经保存第一个局部 ID，节点通知只修复已存记录，不更新这个局部变量。源码保留该顺序，没有静默重新查 ID。本轮没有完成所有「双新键插入时第一个节点搬迁」组合的 ARM 运行验证，不能据成功流保证这些组合等价或一致。

OOM、部分 I/O、原编辑器建立失败、所有中间失败和性能仍未完整验收。

## 验证

替换上一阶段手工组装记录的 fixture，同一条 SingleTrie 流程改为全部经实际协调入口创建：

- 创建两个自关联及两条有向关系，四条关系只有四条共享记录。
- 经完整文件保存、只读映射和复制，再更新已有关系，反向、自关联及保留模型仍能读取原 payload。
- 新增 96 组自关联及指向已有端点的关系。比较创建时和后续 terminal ID，确实发生搬迁，逐条仍能读取独立字面 payload，不断言内部通知次数。
- 再以省略 payload 创建一条关系，读得上次 append scratch 的字面 payload。记录数与关联数均为 `197`，新建第一端点的两个校验字节为零。
- 保存到另一路径并重载，读取新旧关系及独立外层累计值。原保留模型仍为四条关系。

共用原语影响两个后端，全源码严格编译一次，新 SingleTrie 流程与原六子模型完整流程均通过。临时文件、对象、archive 和二进制精确清理，生成源码及日志保留在 `work/native-rewrite/single-create-build/`。

新增修复函数与保留发布库字节一致，中央增至 `326` 区域。已有 coordinator、输入校验及记录补丁证据直接沿用，不重证。

- `work/native-rewrite/ghidra/single-trie-entry-edit/002c8928.c`
- `work/native-rewrite/restart-v217/native-single-create-comparison.json`
- `work/native-rewrite/restart-v217/single-create-export.json`
- `work/native-rewrite/single-create-build/build.log`

复现沿用 [共用完整构建](mutable-dictionary-image.md#验证)，测试名仍为 `single_trie_association` 和 `mutable_dictionary_image`。未执行原 ARM64，未操作设备、正式包或用户词典。原物理删除分支现已恢复，下一步接上层删除策略、学习与生命周期。
