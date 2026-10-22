# Marisa 与 Forward 的流式帧

本文继续 [普通 Forward 单项读取](forward-token-dictionary.md)，仅记录原函数的状态推进。尚未新增流式 cursor 或将上游 bool lookup 包装成原三态接口。

## 两层接口的 slot 2 不同

底层 Marisa ExactMatchIterator 的 `0x1d92d0` 返回保存帧的数量，即深度。它不是 TokenDictionaryIterator 的帧 Next，也不是固定 false。只有外层 Forward 的 slot 2 才进入已定位的协调与收集流程。

底层构造 `0x1dad64` 创建真实 Marisa Agent、合并查询字符串、帧向量及当前结果标志。帧记录包含本次追加字节数和 Agent 的两个 32 位遍历状态，保存时扩为机器字。这里不按原 ABI 重建另一个容器。

## Marisa Push 与结果状态

`0x1dbd58` 先按 span 把字节追加到合并字符串，再调用虚 slot 13。成功后记录追加长度和遍历状态。失败时将字符串缩回原长度，不追加帧。

Exact 的 slot 13 为 `0x1d97fc`：

1. 给 Agent 设置当前合并字符串。
2. 有旧帧时恢复其两个遍历状态，没有旧帧时置零。
3. 设置原模式字段为 2，进入 `0x1e88e0`。
4. 只有返回 0 才设置当前结果标志。返回 2 时 Push 失败，其他返回值可使 Push 成功但没有当前 exact 结果。

不能把「Push 成功」等同「已有 token」，也不能从上游 bool lookup 猜出中间状态。现已沿 `0x1e88e0` 找到实际内核 `0x1ea130`，三态与压缩链回退见下节。

`0x1dbb34` 读取 Agent 中当前 key 的字节指针及长度，不是重新返回调用方传入的最后一个分段。原 getter 自身不检查当前结果标志，调用方仍需按真实结束状态决定能否使用结果。

## 实际三态内核与压缩链

`0x1e88e0` 检查 Trie 是否存在，按需初始化 Agent，然后尾跳转到 `0x1ea130`。诊断路径包含 `third_party/marisa/v0_2_0/lib/marisa/trie.cc`，只能作为原分支来源线索，不能据此认定它等同未修改的上游版本。

实际内核使用 Agent 保存的节点与查询位置。模式为 2 或 8 时保留这两项，其他模式先置零，随后进入模式 2。原字段的枚举名称仍未恢复。

| 返回值 | 原内核状态 | 外层 Push |
| --- | --- | --- |
| 0 | 查询耗尽且当前节点为 terminal，更新 Agent 的 key 与 terminal rank ID | 成功，有当前 exact 结果 |
| 1 | 查询已消费，但尚未形成 exact 结果，包括压缩链内的匹配前缀 | 成功，没有当前 exact 结果 |
| 2 | 原内核的非空检查失败，或子边匹配在查询耗尽前失败 | 失败，没有当前 exact 结果 |

每次调用 `0x1e9f5c` 前，内核保存当前节点与查询位置。子边失败后，用失败时的查询位置判断返回 1 还是 2，再恢复调用前的两项状态。返回 1 因此也可能保存压缩边之前的位置，而不是查询末尾。下一次 Push 要用累计字符串重新走这条边，不能把缓存位置直接设为新字符串长度。

`0x1e9f5c` 使用真实缓存或 LOUDS 子边。`0x1e9e70` 按图结构委派嵌套 Trie 匹配 `0x1e9ce8` 或 tail 匹配 `0x1f1830`。这两条路径均先比较字节，再推进查询位置。查询在匹配链内耗尽时可返回 false，正是内核仍须区分 1 与 2 的原因。terminal 位读取为 `0x1e9af4`，key ID 使用 `0x1e7200` 的排他 rank1。

固定的上游 v0.2.6 已提供同类真实图迁移与 tail 操作，但普通 `lookup()` 每次调用 `lookup_init()`，清零节点与查询位置，并把两种未形成 exact 结果的情况都返回 false。它只能沿用既有单项读取验证，不能直接承接上述可继续帧。

Ghidra 曾把两个尾跳转包装推导为 void。这里以已采集的跳转、实际内核返回值及外层调用方判断为依据，不把伪码中的 void 当作原 ABI 无返回值。

## Marisa Pop、Reset 与 Advance

`0x1db1bc` 首先清当前结果标志。有帧时按最后一帧记录的长度缩短合并字符串并删一帧，返回 true。空栈则返回 false。它不会立刻重新匹配父帧。

`0x1d9350` 清当前标志、合并字符串和保存帧。此前已登记的 `0x1d93bc` 只清当前标志。失败 Push 也会经过内核更新标志，回滚字符串不代表恢复此前可读结果。

## Forward 的惰性协调

外层 `0x1b3488` 的 Pop 先恢复原短索引初值，清已收集记录、同步标志和 target 模式，再删除一个待应用字符串。即使没有待删除字符串，前面的清理仍执行，最后才返回 false。

`0x1b3528` 的 Reset 清待应用字符串、收集记录和两个模式标志。它没有直接调用底层 Reset，也没有清掉已应用字符串向量。底层调整留给下一次 Forward Next，不能用统一的立即回滚替代。

`0x1b2628` 在 source 模式下递增短索引，在 target 模式下直接把索引设为 1。这里不能改成通用 size_t 游标或始终递增。原 owner 的 `+0xc` 是 32 位限制字段，复制到 cursor 的索引时收窄为短整数。其初始化来源与默认值仍未闭合，不填写猜测常量。

## BFS 的另一条证据

`0x1b7aa0` 实际是 BFS 输入边处理，不是 owner 构造。特定 target 分支保存原输入边。普通分支的输入匹配 metadata 字符串字段 2 时，遍历 repeated 字段 3，逐个替换输入再委派子接口。这确认了字段 2 的符号展开作用，但不恢复其原始字段名，也不代表 BFS 已实现。

## 证据与边界

本阶段仍为静态取证，没有运行或伪造流式查询。此前的 `12` 段帧证据保持原样，本次补充内核及匹配链的 `7` 段 FDE，均与保留 v2.1.7 库逐字节相同，中央登记增至 `479` 段。前 `472` 段沿用已有证据，metadata 构造函数的既有 ADRP 差异仍保留。

- 指令与增量比较：`work/native-rewrite/restart-v217/native-forward-token-frames-comparison.json`
- 成功伪码：`work/native-rewrite/ghidra/forward-token-stream-frames/`、`marisa-exact-lookup-kernel/` 和 `forward-token-bfs-edge/`
- 比较日志：`work/native-rewrite/forward-token-frames-evidence.log`

此前 `0x1e88e0` 缺少 Ghidra 入口的阻塞已解除，旧失败日志仍保留。`ExportNativeFunctions.java` 增加显式的 `--unwind-ranges CPP_TYPES_JSON` 选项，先核对原 APK 中目标 ELF 与分析程序的 SHA-256，再仅对请求且有确切 unwind 范围的缺失入口建函数。反汇编限制在该范围，已有函数体保持原样。

新增比较与指令在 `work/native-rewrite/restart-v217/native-marisa-resume-comparison.json`，日志在 `work/native-rewrite/marisa-resume-evidence.log`。成功伪码分别保存在 `work/native-rewrite/ghidra/` 下的 `marisa-lookup-dispatch-unwind/`、`marisa-lookup-core-unwind/`、`marisa-lookup-steps-unwind/`、`marisa-lookup-match-unwind/` 和 `marisa-lookup-tail-unwind/`。

下一步把上述三态和回退位置接到共享的真实图读取层，恢复累计字符串与保存帧，不另造 ABI 容器，也不在外层用 bool lookup 或预测搜索补判来模拟状态。随后再接 Forward 的惰性协调与 Manager 懒缓存。

单项读取的八份资源、3,464 个 key 证据直接沿用，不重跑；它们不证明本页的流式帧运行等价。尚未创建 Manager 合并帧、恢复 BFS、执行 ARM 或操作设备及用户数据。
