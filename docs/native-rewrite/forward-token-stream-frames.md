# Marisa 与 Forward 的流式帧

本文继续 [普通 Forward 单项读取](forward-token-dictionary.md)，记录原函数的状态推进及已接通的宿主 ExactCursor。内层 Marisa 分段查询及普通 Forward source/target 协调已走真实资源。长度属性 getter 和普通 Manager 查询已接通，多记录排序仍未接入。

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

未打研究补丁的上游 v0.2.6 已提供同类真实图迁移与 tail 操作，但普通 `lookup()` 每次调用 `lookup_init()`，清零节点与查询位置，并把两种未形成 exact 结果的情况都返回 false。本次修改该核心实现，供单项读取与可继续帧共用，见下节。

Ghidra 曾把两个尾跳转包装推导为 void。这里以已采集的跳转、实际内核返回值及外层调用方判断为依据，不把伪码中的 void 当作原 ABI 无返回值。

## Marisa Pop、Reset 与 Advance

`0x1db1bc` 首先清当前结果标志。有帧时按最后一帧记录的长度缩短合并字符串并删一帧，返回 true。空栈则返回 false。它不会立刻重新匹配父帧。

`0x1d9350` 清当前标志、合并字符串和保存帧。此前已登记的 `0x1d93bc` 只清当前标志。失败 Push 也会经过内核更新标志，回滚字符串不代表恢复此前可读结果。

## 宿主 ExactCursor

`ForwardTokenDictionaryView::ExactCursor` 已实现 Push、Pop、Reset、Depth、HasCurrent 与 Current。它持有字典的共享引用，使用该字典唯一的真实 LOUDS 图、缓存、嵌套 Trie 和 tail，不另建图或 ABI 对象。

Push 追加已准备字节，从最后保存帧恢复节点与查询位置，再进入三态查询。只有 Exact 设置当前结果，Prefix 也保存新帧，Missing 缩回字符串并保持原帧数量。Pop 和 Reset 清当前标志，不立即重查父帧。Current 返回完整累计查询及原 Marisa key ID，原 token ID 与文本仍由外层按表转换。

`dependencies/marisa-resumable-exact.patch` 替换固定上游的 lookup 核心，以单一定义的 LookupResult 表达三态。已有公共 bool API 只保留原来的 exact 判断，宿主视图直接使用核心。固定依赖 checkout 保持原样，构建从指定提交导出到 work 后应用补丁。补丁中的恢复逻辑属于 Google-derived 研究材料，许可边界沿用 NOTICE，上游 BSD 通知继续保留。

本实现仅接原 Exact 调用方已恢复的准备字节与保存帧路径，不提供原 Agent ABI 或任意模式入口。宿主枚举名称不代表恢复了原枚举名，也未把原模式 2、8 写入上游另一套状态枚举。

## Forward 的惰性协调

外层 `0x1b3488` 的 Pop 先恢复原短索引初值，清已收集记录、同步标志和 target 模式，再删除一个待应用字符串。即使没有待删除字符串，前面的清理仍执行，最后才返回 false。

`0x1b3528` 的 Reset 清待应用字符串、收集记录和两个模式标志。它没有直接调用底层 Reset，也没有清掉已应用字符串向量。底层调整留给下一次 Forward Next，不能用统一的立即回滚替代。

`0x1b2628` 在 source 模式下递增短索引，在 target 模式下直接把索引设为 1。这里不能改成通用 size_t 游标或始终递增。原 owner 的 `+0xc` 是 32 位限制字段，复制到 cursor 的索引时收窄为短整数。现已定位构造函数 `0x1b3388`：直接写入默认值 `0x80`，即 128。宿主视图只恢复该默认普通资源投影，不提供尚未恢复的外部限额修改入口。

## 宿主 source 惰性协调

`ForwardTokenDictionaryView::Cursor` 已接 source 的 Push、NextFrame、Current、Advance、Done、Pop 和 Reset。此前的 SourceCursor 已改名，不保留别名或第二套实现。Push 只准备并保存字符串，Next 才从待应用栈顶比较已有字符串、Pop 不同后缀并重新 Push。若整个待应用查询已相同，仍 Pop 并重做最后一段，以重新取得已被收集消费的子结果。

同步标志在 Next 开始时设置，后续 Push 须经 Pop 或 Reset 才能继续。失败保留已成功应用的子帧，下一次同步继续按真实共同部分协调。外层 Pop、Reset 清待应用项及当前记录，不直接清内层已应用字符串和帧。

普通资源没有多记录值区，每个 exact 结果只投影一个原表行。本实现保留原 16 位记录索引、查询长度和有符号短游标，Current 经共享的 token 填充函数读取 ID、language、identity 和码点文本。source 文本准备也与普通单项入口共用。当前已补长度属性与 target 分支，仍不把此投影当作完整 Forward 迭代器。

新增端到端用例沿用已有真实资源 fixture 入口，以 `source` case 选择运行：按原栈顺序输入 `hong`、`z` 得到 `zhong`，消费后重做相同帧，Pop 后改成 `chong`，并在 Reset、延迟匹配失败后恢复到 `a`。token ID 与 UTF-8 期望为原清单字面值，不由查询算法计算。

## target 与长度属性

Cursor 的 Push 以 target 参数选择原入口。普通 literal target 只在待应用栈为空时保存 C-string 副本与查询 language，并直接建立索引 0 的帧。Next 不推进也不重启此帧，Advance 固定设为 1。Pop、Reset 解除 target 模式，原 source 子帧仍留到后续 source Next 再协调。

Current 与单项 ReadTarget 共用一份 literal token 填充逻辑。它在读取时检查一个 Unicode 码点，使用字典 selector 生成 ID，并保留查询 language，而非替换为字典 language。`target_uses_source=true` 则交回同一 source 分支，不另造 target 查询实现。

原属性函数 `0x1b43bc` 用 S0 返回 float，不能按 Ghidra 的 undefined4 伪码签名推断为整数。target 或关闭 length_penalty 时返回正零。开启时按原 Meta 行与记录长度比较，匹配、失配字面值分别为 `0xbdd7c741` 和 `0xc0135d8e`，在宿主只保留一个定义点。当前八份原资源的 length_penalty 和 target_uses_source 都关闭，开启分支仅有静态恢复证据，未作为本轮运行覆盖。

收集记录的评分只供内部排序，没有另一个对外评分 getter。普通无值区资源每个 exact 只产生一条记录，默认限额为 128，达不到部分排序条件。原清单八份资源的 Meta 均等于 key 字节长度，收集还会把匹配记录的评分置为正零。因此本投影不增加评分缓存或虚构读取接口。多记录、外部改限额等路径仍待单独恢复。

## BFS 的另一条证据

`0x1b7aa0` 实际是 BFS 输入边处理，不是 owner 构造。特定 target 分支保存原输入边。普通分支的输入匹配 metadata 字符串字段 2 时，遍历 repeated 字段 3，逐个替换输入再委派子接口。这确认了字段 2 的符号展开作用，但不恢复其原始字段名，也不代表 BFS 已实现。

## 证据与边界

静态取证阶段的 `12` 段帧与后补的 `7` 段内核及匹配链证据保持原样，均与保留 v2.1.7 库逐字节相同。本次仅补 owner 构造函数的一段 FDE，与保留 v2.1.7 库逐字节相同，中央登记增至 `480` 段。metadata 构造函数的既有 ADRP 差异及其他旧证据继续保留，没有重跑旧 FDE。

- 指令与增量比较：`work/native-rewrite/restart-v217/native-forward-token-frames-comparison.json`
- 成功伪码：`work/native-rewrite/ghidra/forward-token-stream-frames/`、`marisa-exact-lookup-kernel/` 和 `forward-token-bfs-edge/`
- 比较日志：`work/native-rewrite/forward-token-frames-evidence.log`

此前 `0x1e88e0` 缺少 Ghidra 入口的阻塞已解除，旧失败日志仍保留。`ExportNativeFunctions.java` 增加显式的 `--unwind-ranges CPP_TYPES_JSON` 选项，先核对原 APK 中目标 ELF 与分析程序的 SHA-256，再仅对请求且有确切 unwind 范围的缺失入口建函数。反汇编限制在该范围，已有函数体保持原样。

新增比较与指令在 `work/native-rewrite/restart-v217/native-marisa-resume-comparison.json`，日志在 `work/native-rewrite/marisa-resume-evidence.log`。成功伪码分别保存在 `work/native-rewrite/ghidra/` 下的 `marisa-lookup-dispatch-unwind/`、`marisa-lookup-core-unwind/`、`marisa-lookup-steps-unwind/`、`marisa-lookup-match-unwind/` 和 `marisa-lookup-tail-unwind/`。

宿主验证使用 `build_forward_token_research.sh queries`，日志为 `work/native-rewrite/forward-token-build/resumable-build.log`。自有 C++17 源码按严格告警编译。分段查询测试从原 `pinyin_token_v_2` 资源进入，检查 `<unused_` 续为 `<unused_token>`、失败后续输、Pop 后由 `zhong` 改为 `zhang`，并检查 Reset。预期 key ID 为独立原清单的字面值 0、474、509。

因本次更换图持有方式与查询核心，普通字典入口另做新后端回归，八份原资源的全部 3,464 个 key 通过。未改的 metadata 模块测试没有重跑。上述宿主结果不代表原 ARM、分配失败顺序或完整输入法运行等价。

source 投影以 `build_forward_token_research.sh source` 完整宿主编译并运行一条受影响的真实入口，日志为 `work/native-rewrite/forward-token-build/forward-source-build.log`。旧普通读取、内层帧及 metadata 用例未重复执行。owner 构造证据在 `work/native-rewrite/restart-v217/native-forward-owner-constructor-comparison.json`，伪码在 `work/native-rewrite/ghidra/forward-token-owner-constructor/`。

新增 `build_forward_token_research.sh cursor` 窄范围流程，只编译并运行受影响的 source、target 两条真实资源用例。共享协调器已变化，source 随本轮执行一次；target 覆盖 C-string 截断、查询 language、Advance 后的 Next，以及 Pop、Reset 后切换 source/target。四字节码点另有真实入口检查，期望 ID 为冻结格式字面值。严格 C++17 编译及两条用例通过，日志为 `work/native-rewrite/forward-token-build/forward-cursor-build.log`。未重复执行内层、metadata 或整表枚举用例，中央静态登记保持 480 段。

普通 Cursor 现已直接实现共享的宿主接口，接入 [Manager 匹配帧与懒缓存](token-manager-selection.md)，不是逐方法转发壳。真实资源通过一条复合入口验证，完整工厂和上层接线仍未恢复。下一步追踪工厂注册及资源选择。多记录值区及排序、BFS、binary/custom 编码、外部限额修改、OOM、原 ARM 和 Android 尚未验收。本轮未构建产品、操作设备或用户数据。
