# SingleTrie 关联遍历与用户模型 compact

已将 SingleTrie 的真实关联顺序接入同一用户模型 compact。两种后端共用快照遍历、原选择器、物理删除与累计流程，没有第二套排序或按固定表全量扫描的替代实现。

## 原迭代器与共享记录

SingleTrie 模型 slot 10 为 `0x1c8d8c`，创建 KeyIteratorImpl 的 DFS 游标，虚表地址点为 `0x67c7f0`。构造时将 CommonIterator 的方向字节设为一。

- 初始化 slot 0 为 `0x1ca18c`，先初始化底层前缀游标，再刷新范围并寻找当前记录。
- 刷新 `0x1c9fe0` 按 trie 顺序取得当前终端、值和池范围，跳过无法读取或 count 为零的范围。
- 查找 `0x1ca0a4` 按池顺序读共享记录，仅当当前终端 ID 等于记录的第一 ID 时发布。方向字节为一，原 `(direction ^ 1) * 4` 选择偏移零。
- next 的 `0x1ca16c` 先增加当前范围内位置，再调用同一查找。走完范围才推进 trie 并刷新下一组。
- 第一侧键来自当前 trie 游标，第二侧键经 `0x1cad98` 从记录偏移四的 ID 重建，`0x1c9520` 从偏移八读取 payload。

同一有序记录虽挂在两个端点的池中，但只从第一端点输出。自关联只挂一次，也只输出一次。反向关系是另一条记录，仍独立输出，不用集合去重或文本排序。

模型报告数使用 slot 7 的 `0x1c7be4`：就绪时从 `+0x34` 读取有符号 int32 并扩展到 64 位。它是内部关联数，不是固定表行数、遍历结果数或外层权重。

## 共用实现

SnapshotDictionaryAssociations 改为按实际后端实例化的同一遍历：

- 六子模型绑定 forward/reverse trie、前向池和记录表，TargetKey 正文偏移四。
- SingleTrie 绑定同一 trie、范围池和共享记录表，KeyPair 正文偏移八，增加第一 ID 方向筛选。
- 两者都保留 trie alphabet 与池内顺序，使用同一 IndexPool、定长表、终端键重建和六字节 payload 编码。
- 固定表 checked read 失败仍保留先前借用视图，不增加清零或计数修复。SingleTrie 跳过空范围，六子模型保持原先先读第一槽再检查范围的差异。

CompactUserDictionaryAtCutoff 和真实日期包装均改为同一模板入口。调用方传具体存储、limit、可选原 cutoff 及对应编辑器，旧六子模型调用改为显式新参数顺序，没有转发兼容壳。

选择器继续独立接收符号扩展的模型报告数，按原 float32 限额、候选条件、比较器和堆顺序选择。删除后缀继续调用同一用户级物理删除，并忽略单条失败，不改成事务或保证全部删除成功。

## 实际流程验证

延伸现有 SingleTrie 同一端到端流程：

1. 原始四条记录按插入次序为 `a→a`、`b→b`、`b→a`、`a→b`。实际快照按 trie 和池顺序输出 `a→a`、`a→b`、`b→b`、`b→a`，共享端点引用未重复计入。
2. 从保留的真实模型复制四条关系，通过实际已有更新写入独立字面 payload：`a→a` 为零计数删除标记、日值四；`a→b` 权重 150、日值一；`b→b` 零计数无标记、日值五；`b→a` 权重一、日值三。外层累计设为 151。
3. limit 三、cutoff 二，经原 float32 限额保留两条：较新的标记与轻关系。过期重关系及无效零计数自关联被物理删除，当前关系二、累计一、固定表仍四行，保留模型原内容不变。
4. 第六个独立文件往返后，标记和有向关系的全部六字节保持。
5. 真实日期包装令 1970 年的剩余条目过期，删除至关联数和外层累计均为零，空端点 a、b 移除。原路径覆盖保存并重载，活遍历为空，固定表的历史正文仍保留。

全源码严格编译一次，SingleTrie 扩展流程与原六子模型流程均通过。使用独立字面顺序、字节和计数，不以选择器计算测试答案。六份 SingleTrie 文件、原六子模型文件、对象、archive 和二进制精确清理，生成 protobuf 源码及日志留存。

## 证据与边界

八个新增 FDE 区域与原始 APK、保留发布 v2.1.7 的库字节完全一致，中央登记增至 `337` 区域。其余导出的辅助函数用于定位调用拓扑，不据此宣称整个迭代器运行等价。既有 compact 选择、日期和删除证据不重证。

- Ghidra：`work/native-rewrite/ghidra/single-compact-iterator/`、`single-compact-step/`
- 新字节比较：`work/native-rewrite/restart-v217/native-single-compact-comparison.json`
- 中央导出：`work/native-rewrite/restart-v217/single-compact-export.json`
- 严格构建及实际流程：`work/native-rewrite/single-compact-build/build.log`

临时快照、堆计划与字符串保留可读实现，不承诺原分配次数或性能。未覆盖全部损坏输入、OOM、删除中间失败或原 ARM64 执行。未操作设备、正式包或用户词典。

当前入口要求调用方保持同一模型就绪、独占及编辑器绑定。原运行时工厂、accessor 锁、Android 调度保存、进程生命周期及完整学习键管线仍未接入。下一步沿原持久编辑器与模型生命周期继续恢复。
