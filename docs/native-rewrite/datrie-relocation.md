# DATrie 冲突选择与节点搬迁

## 范围

`datrie_relocation.cc` 恢复 `0x1d66cc` 的冲突入口与 `0x1d6410` 的子节点搬迁。实现复用原有字段访问、空闲链、base 选择和枚举，不建立另一套节点格式。根索引与有符号字段判定也保持单一定义。

这仍是完整键插入内部的步骤。冲突入口返回迁移后的当前节点，认领新边并写入父索引。新边的 base 或值由外层插入继续填写，当前尚未恢复该完整入口。

## 冲突选择

`ResolveCollision` 先取得拥有型区域的可写访问，并将当前视图重新绑定到实际区域。

- 目标没有正父索引时直接摘链、认领。
- 目标属于根时搬迁当前节点的子节点。
- 当前不是根，且其子节点数加一小于另一侧数量时，也搬迁当前侧。
- 其余情况搬迁另一侧，并接回可能改变的当前节点索引。

搬迁当前侧时，以新字节作为 base 选择的最小字节。搬迁另一侧时，原函数使用其最后一个标签作为最小字节，并从检查数组中扣除该标签。该位置已由候选空闲单元保证，不改成另一种搜索策略。

base 选择可能扩容。每次选择后，入口重新取得两区域并更新同一个视图对象，使引用该对象的真实通知接收者读到新节点。其他借用视图仍需调用方重新取得。

## 搬迁顺序

`RelocateChildren` 保存一个与子节点数量相同的临时值数组，保留两阶段流程。

第一阶段逐标签占用目标单元，设置父索引并保存旧 base。非零标签且旧 base 为正时，将其下一层节点的 check 改到新索引，并更新正在遍历的节点索引。随后将旧单元按空闲链游标归还，根单元采用原特殊处理。若下一目标正是刚归还的游标，先将游标退到其前驱。

全部旧单元处理后才提交父节点的新 base。第二阶段将暂存 base 写入目标单元，遇到零标签后立即通知旧终端 ID 与新 base。原通知可能先于后续标签的 base 写回，恢复实现也不把通知集中移到最后。

可选通知类型只表达已经确认的两个 ID 与 void 返回。整合测试实际绑定 [反向引用修复接收者](node-id-updater.md)，没有空回调或模拟接收者。通知内部停止时，搬迁本身不因此回滚或获得成功状态。

## 验证

```bash
mkdir -p work/native-rewrite/recovered-datrie-relocation
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/fixed_phrase_table.cc \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/recovered/association_list.cc \
  research/native-rewrite/recovered/datrie_view.cc \
  research/native-rewrite/recovered/datrie_relocation.cc \
  research/native-rewrite/recovered/trie_value_lookup.cc \
  research/native-rewrite/recovered/node_id_updater.cc \
  research/native-rewrite/tests/datrie_relocation_test.cc \
  -o work/native-rewrite/recovered-datrie-relocation/datrie_relocation_test
work/native-rewrite/recovered-datrie-relocation/datrie_relocation_test
```

严格 C++17 跨组件流程通过。真实初始化建立空闲链，独立加载字节定义已有路径。向现有前缀补零标签时，与另一键的终端产生实际冲突，走搬迁另一侧的分支。

该样本同时触发共享区域分离和节点范围从 `256` 扩展到 `512`，容量为 `768`。当前节点从 `21` 迁到 `3`，终端从 `20` 迁到 `2`。已有深层路径仍到达 `23`、`25`，终端 `40`、`42` 保留字面值偏移 `4`、`8`。旧共享句柄保留原节点字节。

真实接收者将两条反向记录的 ID 从 `20` 修复为 `2`，六字节负载保留。测试不只检查通知调用，而是读取实际反向记录。新认领的零标签边尚未写入外层值，测试在这一原生步骤边界结束。

APK 出口加入父索引重写、旧单元归还、暂存值写回、通知槽位和分支锚点后通过。两个新增区域与发布库指令字节一致。证据位于已有 Ghidra 批次 `datrie-free-chain/`、`datrie-node-allocation/`，以及 `work/native-rewrite/original-apk/native-datrie-relocation.txt` 与对应 comparison JSON。

## 验证边界

实际流程覆盖搬迁另一侧、当前节点重定位、扩容后视图刷新和真实反向引用修复。搬迁当前侧及根特殊分支有静态证据，尚未分别执行宿主场景。没有运行原 ARM64 搬迁或完整键盘验收，也没有访问设备或用户词典。

下一层索引重写复用已有枚举，适用条件为有序字母表、有效正 base 且没有整数回绕。不将该复用推广到损坏镜像。恢复入口对已识别的失败返回零，保留此前修改，完整越界及分配故障等价未验收。

下一步恢复完整节点插入，填写本步骤认领的新边、终端值及相关计数，再连接删除、持久化和外层故障处理。Google 派生逻辑继续按仓库 `NOTICE` 保留边界。
