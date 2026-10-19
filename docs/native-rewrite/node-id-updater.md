# 终端节点迁移通知与反向引用修复

## 范围

恢复的是固定记录表分支的实际接收者，不是节点搬迁本身。源码位于 `node_id_updater.cc`、`trie_value_lookup.cc` 及既有 DATrie、关联模块。Google 派生逻辑继续按仓库 `NOTICE` 和原始权利范围处理。

`AssociationSide` 是真实存储的非拥有型组合：DATrie 视图、值记录表、关联池两区域及关联记录表。它不代替上层对象就绪状态，也不添加备用后端或占位通知。

## 实际接收链

原编辑器构造器 `0x1c5a00` 为两个方向分别创建通知对象。类型信息明确标识接收对象为 `i18n_input::engine::hmm::NodeIdUpdator`，绑定方法为 `0x1c5520`。`0x1c59a0` 将其注册到编辑器辅助对象。

DATrie 搬迁例程 `0x1d6410` 在零标签终端迁移后调用通知槽位 `+0x20`，参数为旧终端索引、新 base。零标签的新终端索引就是新 base。这里的 ID 是终端单元索引，不是键路径节点，也不是值记录偏移。

| 原函数 | 职责 |
| --- | --- |
| `0x1d6388`、`0x1d62b0` | 校验终端索引，取得四字节值引用 |
| `0x1deaa0`、`0x1de920` | 按该引用读真实值，并复制到输出区域 |
| `0x1c5520` | 根据正向列表逐条修复反向引用 |
| `0x1c54ac` | 找到反向列表中首个旧 ID，并修改其记录 |

## 源码行为

`ReadTerminalValue` 复用既有终端判定，取得本单元的值。`ReadTrieValueByNodeId` 将其解释为固定表字节偏移，读取并复制值正文，不把内部记录指针当作拥有型输出。

`UpdateMovedNodeId` 保留原流程：

1. 用新终端 ID 读取迁移侧的关联范围。
2. 逐条读关联记录，取得另一侧终端 ID。
3. 读取另一侧终端对应的反向范围。
4. 找到其中首个旧 ID，只写入新 ID，保留负载与列表顺序。
5. 继续下一条，或在任一步失败时停止。

共享查找由 `FindAssociationRecord` 定义，删除与迁移修复复用同一实现。查找区分列表位置和实际记录偏移。池使用 const 视图读取，不为查询分离共享单元；可写记录仍通过 `MutableRecord` 获取。

原通知没有成功状态，恢复入口同样返回 void。后续失败保留先前修复结果，不补原子事务、回滚或无条件成功回调。

## 验证

```bash
mkdir -p work/native-rewrite/recovered-node-id-updater
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/fixed_phrase_table.cc \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/recovered/association_list.cc \
  research/native-rewrite/recovered/datrie_view.cc \
  research/native-rewrite/recovered/trie_value_lookup.cc \
  research/native-rewrite/recovered/node_id_updater.cc \
  research/native-rewrite/tests/node_id_updater_test.cc \
  -o work/native-rewrite/recovered-node-id-updater/node_id_updater_test
work/native-rewrite/recovered-node-id-updater/node_id_updater_test
```

严格构建与真实存储流程通过。独立终端字节夹具提供新 ID，列表和记录均通过实际入口建立。两条反向记录从 `6` 修复为 `10`，前置无关记录与六字节负载保留。第二次通知先将首条改为 `12`，随后因真实缺失端点停止，后条保持 `10`。期望值使用字面记录与范围，不由被测实现生成。

APK 出口补入按 ID 读取、正文复制、匹配更新及失败停止锚点后通过。六个新增指令区域与发布库一致。Ghidra 证据位于 `work/native-rewrite/ghidra/datrie-move-receiver/`、`datrie-move-value-lookup/`、`datrie-move-value-resolve/`，完整指令与对照见 `work/native-rewrite/original-apk/native-node-id-updator.txt` 及对应 comparison JSON。

## 边界与下一步

原生读取先准备四字节临时引用，恢复入口使用有类型整数中转，再复制实际值。保留正常路径的字节复制语义，分配步骤和内存耗尽表现尚未验收。现有损坏输入保护、就绪状态与借用视图生命周期约束继续适用。

尚未执行原 ARM64 通知或完整键盘验收，也没有操作设备与用户词典。真实接收者已接入 [冲突搬迁](datrie-relocation.md)，宿主流程覆盖扩容与分离后的子节点、终端值及反向引用共同迁移。下一步恢复完整节点插入、删除及外层故障处理。
