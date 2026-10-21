# kind 零精确匹配游标

已恢复原 kind 零的分片路径、历史帧和缓存引用，并接入两种真实后端的按键读值入口。实现合并 DATrie 状态与固定表引用解析，不复制原虚接口层级。

## 原状态协议

ExactMatchIterator 的地址点为 `0x67d280`。关键入口及状态如下：

| 入口 | 恢复行为 |
| --- | --- |
| `0x1d6d94` Append | 从最后路径节点继续遍历，空帧时从 root 开始。找到路径就压入旧字符串长度与新节点，追加片段，再刷新精确结果 |
| `0x1d4674` Pop | 先清除结果节点和缓存引用，再弹出一帧、截断字符串。空栈返回 false，不自动刷新恢复后的路径 |
| `0x1d4298` Reset | 清空路径、帧及两个结果字，不清空外层引用缓冲 |
| `0x1d4308` Next | 只清除结果节点，保留缓存引用和路径 |
| `0x1d4220` Depth | 返回片段帧数，不是结果条数或字节数 |
| `0x1d5754` / `0x1d58e4` | 从当前路径寻找零边。仅成功时改写缓存引用，没有精确结果时保留旧引用 |
| `0x1d630c` / `0x1de9e4` | 输出缓存的四字节引用，再解析真实固定记录；不根据 Done 自动清空它 |

Append 成功表示片段路径存在，不保证存在精确结果。路径失败只清除结果节点，历史帧和缓存引用仍保留。Pop 清除两个结果字，不会在弹栈后自动恢复上一个命中。

四字节引用复制的状态也不能升级成新失败门禁。原 `0x1d630c` 忽略复制状态，随后引用解析检查实际长度。宿主沿同一顺序写引用、检查四字节长度、读取实际固定记录。

## 共享实现与持有

[trie_exact_match_cursor.h](../../research/native-rewrite/recovered/trie_exact_match_cursor.h) 的 TrieExactMatchCursor 持有路径字符串、帧、结果节点、缓存引用和实际引用缓冲。它不保存临时 DATrieView，每次操作由调用方提供当前视图。

FindNode 增加实际 start 参数，默认仍为 root，同一遍历逻辑供整键和片段使用。TerminalAtPath 是唯一的精确零边检查，FindTerminal 也复用它，没有另一套查找、节点分配或表解码。

ReadTrieValueByKey 改为显式接收实际游标，先 Reset，再 Append 整键。出现精确结果后先发布端点 ID，再复制记录值；后续读取失败仍可留下该 ID。旧签名移除，没有兼容重载或逐方法转发类。

- SingleTrie 编辑协调器长期持有同一 key_cursor，查找、新增协调和删除复用它。
- 六子模型的两个方向各自持有实际 key_cursor。
- 独立只读查询持有本次局部游标，不共享隐式全局状态。
- 复制实际固定记录仍只有一个 CopyRecord 实现，按节点 ID 和缓存引用读取共用它。

路径帧保留原节点 ID。数据搬迁后需要 Reset 再查询，不按保存的字符串自动重解路径。按键读值入口每次先 Reset，沿现有 COW 后重建视图规则操作。

## 验证与证据

扩展原 DATrie 模块测试，不另建 fixture。独立字节镜像的路径 a、ab 对应端点 5、7，记录引用为零和十二，预期 payload 使用字面数组：

1. 先追加 a，再追加 b，帧数一到二，分别读取短键与长键的实际记录。
2. Next 及失败 Append 后，结果为空，缓存的长键记录仍可读取，失败不增加帧。
3. Pop 后两个结果字清零，缓存引用零仍可读首记录。再追加空片段，恢复短键的精确结果。
4. Reset 后空片段的 root 遍历成功，但没有精确结果。

全源码严格编译一次，DATrie 模块、SingleTrie 完整流程及六子模型完整流程通过。另两个迁移调用方只编译和链接，不重复执行已验证产品能力。

最后 rmdir 因六子模型测试额外导出的 generation1.bin、generation2.bin 返回非零，产品测试已经通过。随后只精确删除这两份文件及自建目录，没有重跑通过的测试。对象、archive 和五个二进制也已清理；生成源码与原始 build.log、cleanup.log 留于 `work/native-rewrite/exact-cursor-build/`。

十一段新增 FDE 区域与原始 APK、保留 v2.1.7 发布库字节一致，中央为 `358` 区域。旧遍历、引用写入、固定表及构造证据直接复用。

- 状态取证：`work/native-rewrite/ghidra/exact-cursor-state/`，复用早期 exact 初始化与刷新导出。
- 比较：`work/native-rewrite/restart-v217/native-exact-cursor-comparison.json`
- 中央导出：`work/native-rewrite/restart-v217/exact-cursor-export.json`

## 尚未覆盖

这是读取游标的状态和持有恢复，不是原虚句柄工厂。后续已接入 [写编辑器的独立游标与引用缓冲](trie-value-editor-state.md)，实际下层对象获取仍未恢复。原获取失败、引用计数和完整释放分支尚未恢复为宿主等价路径。

记录读取沿用既有复制 API 的 checked bool 状态，失败保留原输出。原 KeyIterator 的 void getter 会丢弃解析状态，本实现没有宣称与其未检查调用路径等价。损坏输入和全部分配失败也不在本轮等价结论内。std::string、vector、引用缓冲的全部 OOM 与原 ARM64 行为未完整对照，未承诺原分配次数和性能。

未执行原 ARM64，未操作设备、正式包或用户词典。下一步恢复实际下层对象获取与释放，再接模型锁和 accessor 生命周期。
