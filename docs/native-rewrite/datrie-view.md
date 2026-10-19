# DATrie 节点与已有值操作

## 已恢复的范围

源码为 `research/native-rewrite/recovered/datrie_view.h`、`datrie_view.cc`，验证入口为 `research/native-rewrite/tests/datrie_view_test.cc`。

`DATrieView` 借用已经就绪的 trie 元数据和可写节点缓冲区，恢复严格字节准入、从根查找已有路径，以及已有终端值更新。调用方负责原对象的就绪状态、写访问所有权与视图生命周期。该视图不拥有就绪状态。独立拥有型入口已恢复真实初始化、节点扩容与 base 选择，调用方负责上层对象的 ready 标志。冲突选择与搬迁已接通真实通知，见 [冲突搬迁](datrie-relocation.md)。文件加载和完整节点增删仍未实现。

## 字节与节点

当前路径使用的元数据字段如下：

| 位置 | 内容 |
| --- | --- |
| 元数据 `+0x0c` | 节点范围大小 |
| 元数据 `+0x10` | 有序字节表长度 |
| 元数据 `+0x14` 起的 256 字节 | 有序字节表 |
| 元数据 `+0x114` 起的 256 字节 | 字节对应的排序编号，零也表示未准入 |
| 每节点 `+0` | base，终端节点中为四字节值 |
| 每节点 `+4` | check，记录所属父节点 |

节点宽度为八字节，根索引为 `1`。这里没有 UTF-16 字符偏移或拼音切分，也不做大小写转换、编码转换或 Unicode 规范化。

`AcceptsKey` 对应 `0x1d4c34` 与 `0x1d4bf0`：逐个取无符号字节，允许值为 `1`～`255`，并要求准入表对应项非零。已就绪对象的空键通过这一步。`0x1d4c9c` 另有额外允许元数据指定字节的路径，本轮没有混入严格入口。

`FindNode` 对应根入口 `0x1d4e24` 和行走函数 `0x1d4d2c`：下一索引按 32 位加法计算为 `base + byte`，要求索引在范围内，且下一节点的 check 等于当前索引。空路径返回根，并不意味着根上存在终端值。原行走函数对零字节有独立边处理，不能把它改成遇零结束的 C 字符串，也不能直接用严格准入替代行走。

键准入不保证键已存在。允许使用的字节可以没有对应边，两者必须分别处理。

## 已有终端更新

`DATrieEditor` 的已有项更新 `0x1d5998` 先查路径，再调用 `0x1d5914`。后者从键节点的 base 取得终端索引，经 `0x1d5654` 检查后写入四字节值。终端关系要求其父节点的 base 指回该终端。

空闲节点判定 `0x1d54bc` 要求 base 和 check 的有符号值都不大于零。终端值可以为零，正的父索引使其与空闲节点区别开来，不能将零值视为缺失。

`UpdateValue` 只修改已有终端，不创建缺失键，不改变节点范围。它可写入 [trie 值记录](trie-values.md) 的四字节偏移，也不将该偏移改成关联池的打包引用。

视图将访问限制在给定缓冲区范围内。原终端判定对候选索引等于范围大小的情况未提前拒绝，且父索引用于有符号地址计算。恢复入口不执行损坏索引对应的内存访问。损坏格式、越界访问及内存故障不属于已验收等价范围。

## 真实初始化、节点归还与子节点枚举

`InitializeDATrie` 对应 `0x1d51e8` 和 `0x1d5158`。它准备 `0x218` 字节元数据，建立 256 个节点。输入字母表先去重，再移除指定字节，并纳入零标签。随后按无符号字节顺序生成列表和排序编号，零标签编号为零，因此严格准入仍排除零字节。

元数据与节点均在临时区域内建立，成功后才发布两区域。原对象还会设置自身 ready 字节，恢复的区域入口由调用方管理该对象状态，没有新增常量式 ready 实现。元数据实际长 536 字节，既有借用视图的 532 字节是其已访问字段的最小范围，不代表完整文件头长度。

初始化先建立包含节点一的空闲链，再复用摘链操作取出根，设置根的 base/check 都为 `1`。因此摘链入口允许尚为空闲的节点一，不把正常已占用根作为空闲单元。节点零保存链首尾，根与哨兵保持不同身份。

`ReturnFreeNode` 对应 `0x1d53e8`，从指定游标沿有序链寻找插入位置，依次写入本节点前驱、后继及邻居链接。输入节点不在当前链中，游标为前方链节点或哨兵。该入口不建立副本或重复归还检测，也不自动清理节点引用。

`EnumerateChildren` 对应 `0x1d559c`。它按元数据列表顺序检查 `base + label`，只输出 check 属于当前节点的标签，遇到越界候选立即返回已有结果。输出包含零标签，并保留输出数组未使用的尾部。原生固定容量标签数组现有一个共用类型定义。

真实初始化的根会枚举出零标签，但终端值判定排除节点一，不能把这个标签当成一个用户词条。共享前缀节点的零标签与非零边也应分别处理。

扩展既有整合入口已通过严格 C++17 构建：使用真实初始化得到有序去重字母表，独立完整字节期望验证元数据与根。摘除中间单元后从前方游标归还，字面期望验证双向链复原。独立已有路径夹具验证 `a` 节点枚举零标签和 `b` 边，`ab` 节点枚举零标签，并继续真实记录引用更新。

实际 APK 出口补入初始化长度、排序表、根保留、链归还与枚举写入锚点后通过，四个新增区域与发布库指令字节一致。证据位于 `work/native-rewrite/ghidra/datrie-return-enumeration/`、`work/native-rewrite/original-apk/native-datrie-initialize-return.txt` 及对应 comparison JSON。源码测试仍不等于原 ARM64 执行或完整编辑器验收。

## 空闲链、扩容与 base 选择

`GrowDATrieNodes` 对应 `0x1d4e5c`，复用 `OwnedByteRegion`。节点零是空闲链哨兵，base 保存负的尾索引，check 保存负的首索引。空闲节点分别保存负的前驱与后继，零表示链端。这与关联索引池的四字节单元不是同一种格式。

每次扩容将节点范围增加 256。已有容量小于或等于新范围时重新分配，容量选「原容量乘 1.25 后截断」与「原容量加 512」的较大值。系数复用 `storage_growth.h`，没有第三份增长常量。新缓冲区先填 `ff`，再复制旧容量的全部完整单元，不只复制旧活动范围。

写入顺序保留为：连接原尾端、建立新后继、建立新前驱、更新哨兵尾端，最后提交元数据范围。原生输入大小转换包含带符号容量读取和无符号浮点转换，极端整数范围尚未验收。

`FindDATrieBase` 对应 `0x1d4fe8`。输入为合法的字节标签、最小字节及有序空闲链。它先跳过不大于最小字节的候选，以「候选减最小字节」作为 base，逐项检查子位置。要求节点范围减一严格大于 base 加 256，边界相等仍扩容。子位置的 check 必须为负，不能改用允许零后继的通用空闲判定。

搜索失败候选后沿空闲链继续，必要时增长，并重新取得元数据和节点视图。选择本身不预留节点。`UnlinkFreeNode` 对应 `0x1d5128`，只将真实空闲单元从链中摘除，保留本单元两字内容。原调用方随后设置占用字段，不能把摘链单独当作完成节点插入。

恢复入口在识别到分配失败时返回 false，保留此前已完成的增长或所有权变化。原 base 搜索忽略增长返回值，可能继续循环或访问无效内存。这项差异已声明，完整内存耗尽等价没有验收。

### 分配组件验证

```bash
mkdir -p work/native-rewrite/recovered-datrie-allocation
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/datrie_view.cc \
  research/native-rewrite/tests/datrie_allocation_test.cc \
  -o work/native-rewrite/recovered-datrie-allocation/datrie_allocation_test
work/native-rewrite/recovered-datrie-allocation/datrie_allocation_test
```

严格构建与独立夹具流程通过：节点范围从 `4` 到 `260`，容量为 `516`。base 搜索淘汰会覆盖已占用节点的候选，因余量边界再次增长到范围 `516`、容量 `1028`，验证容量相等时仍分配。字面字节确认链首、链尾、未用容量 `ff` 填充、共享旧缓冲区保留，以及摘链只改邻居的行为。

真实 APK 出口补入容量边界、范围提交、候选符号位和摘链锚点后通过。三个新增区域与发布库指令字节一致，证据位于 `work/native-rewrite/ghidra/datrie-node-allocation/`、`datrie-free-chain/`，以及 `work/native-rewrite/original-apk/native-datrie-allocation.txt` 和对应 comparison JSON。

## 键与已有值验证

```bash
mkdir -p work/native-rewrite/recovered-datrie-view
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/fixed_phrase_table.cc \
  research/native-rewrite/recovered/trie_values.cc \
  research/native-rewrite/recovered/datrie_view.cc \
  research/native-rewrite/tests/datrie_view_test.cc \
  -o work/native-rewrite/recovered-datrie-view/datrie_view_test
work/native-rewrite/recovered-datrie-view/datrie_view_test
```

严格 C++17 构建与一条真实组件流程通过。独立字节夹具定义共享前缀的 `a`、`ab` 路径与终端，不调用被测算法生成 fixture。流程接入真实值记录表，追加后将 `ab` 的终端从偏移 `6` 更新为 `12`，再从终端字节解析偏移取得新正文。短键的零偏移终端保留。准入字母表允许但不存在的 `b` 仍保持缺失，断言来自已有项更新入口的冻结语义。

实际 APK 出口补入字节读取、根索引、base/check 行走、空闲判定和终端写入锚点后通过，八个新增区域与发布库字节一致。源码流程没有执行原 ARM64 DATrie，也不是实际词典或整套输入法验收。

证据保留于 `work/native-rewrite/ghidra/datrie-key-admission/`、`datrie-edit-core/`、`datrie-key-traversal/`，以及 `work/native-rewrite/original-apk/native-datrie-view.txt` 和对应 comparison JSON。

辅助查询曾把 `0x1d4be4` 当作函数入口，脚本失败且未生成 manifest。该批次保留日志，但不列为完整导出证据。空闲节点的行为以原指令取证为准，不把 Headless 进程退出当作导出成功。

Google 派生逻辑继续按 `NOTICE` 保留边界。实际通知接收者已恢复，见 [终端节点迁移通知](node-id-updater.md)。冲突搬迁已接通该接收者。下一步恢复完整节点插入、删除、双向关联写回与外层失败恢复。
