# DATrie 键准入与已有值更新

## 已恢复的范围

源码为 `research/native-rewrite/recovered/datrie_view.h`、`datrie_view.cc`，验证入口为 `research/native-rewrite/tests/datrie_view_test.cc`。

`DATrieView` 借用已经就绪的 trie 元数据和可写节点缓冲区，恢复严格字节准入、从根查找已有路径，以及已有终端值更新。调用方负责原对象的就绪状态、写访问所有权与视图生命周期。此组件没有初始化器、完整文件加载器、扩容、冲突搬迁或节点增删，也不是原类 ready 状态的替代实现。

## 字节与节点

当前路径使用的元数据字段如下：

| 位置 | 内容 |
| --- | --- |
| 元数据 `+0x0c` | 节点范围大小 |
| 元数据 `+0x114` 起的 256 字节 | 字节准入表 |
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

## 验证

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

Google 派生逻辑继续按 `NOTICE` 保留边界。下一步恢复节点分配、扩容与冲突搬迁，再接通真实节点插入和删除，最后回到双向关联写回与外层失败恢复。
