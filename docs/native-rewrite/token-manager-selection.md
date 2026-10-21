# ManagerIterator 状态与结果准入

本轮继续 [查询分支与资源接口](token-query-branches.md)，展开真实 ManagerIterator 的匹配帧、懒缓存及结果选择。已将字典资格匹配和单次结果准入恢复为源码，完整复合迭代器仍依赖未恢复的其他子字典，普通 [Direct DFS 查询](direct-token-dictionary.md) 已有后续真实资源实现。

## 匹配帧与子字典

核心对象保存子迭代器向量的栈，初始只有根帧。source/target 入口分别为 `0x1947a0/0x194750`，设置模式、清空结果缓存，再进入共同的 `0x194438`。

每次 Push 只遍历当前顶帧，按工厂记录的两个 32 位属性筛选：

- 第一个 selector 相等，或任一方为 `-1`。
- language ID 相等，或任一方为 UNKNOWN_LANGUAGE `26`。
- 两条同时满足才调用子 slot 0/1，只有子 Push 成功的接口进入下一帧。

没有成功子接口时返回 false，旧帧保留；成功时追加一帧并从头跳过已结束的子接口。MatchesTokenDictionary 是这两条原谓词的唯一源码定义，不给第一个 selector 猜业务名称。

这里的 language 通配不改变上层检查。多字典场景对 UNKNOWN_LANGUAGE 的原准入要求仍见 [键生成研究](key-generator-score-math.md)，不能凭低层匹配把未知语言视为上层合法输入。

## Next、Pop 与缓存

- slot 2 的 `0x191f94` 先清缓存，再向顶帧每个子接口委派 slot 2，重置子索引并跳过结束项。它的 true 表示执行了这次帧操作，不承诺存在结果。
- slot 3 的 `0x192244` 清缓存后，向顶帧子接口委派 Pop，移除整帧。前一帧仍是匹配帧时，将子索引归零并跳过结束项。子 Pop 返回值不新增失败 gate。
- Reset 经 `0x194184` 对根帧的全部子接口调用 slot 9，再将帧栈缩为一层并清缓存。

`0x193278` 在首次取 token、属性或推进缓存结果时，按子接口次序完整收集当前帧。读 token 来自子 slot 5，附带值来自子 slot 6，子 slot 8 逐条推进。当前子接口结束后才转到下一接口。

收集完成后设置缓存就绪并清空本次去重集合。`0x193444` 的结果推进会先确保缓存已形成，再增加缓存索引，不直接继续读取子字典。Done 根据缓存是否就绪，分别看底层子扫描或缓存索引。

这套顺序已有静态证据，尚未以宿主虚接口或 fake 子迭代器实现。不能把 Push、帧 Next 和缓存结果推进统一成一个通用 next。

## source 与 target 的不同准入

source 保留每个成功读出的 token。target 使用另一个原生键：

```text
((token.id >> 28) & 7, token.text 的完整字节及长度)
```

`0x193278` 的 UBFX 取 bit 28～30，不含 bit 31。`0x193190` 返回树插入位置与插入标志，只有首次插入才保留 token。`0x192e48` 的比较先看三位分类，再按 memcmp 与字符串长度判断，不以 NUL 截断。

因此，target 可丢掉完整身份不同、但分类和文本相同的后到记录。它不按附加字段、身份 bit 或完整 ID 去重，也不按子 slot 6 的值重新排序。优先关系来自原子接口扫描的先后。

SameKeyTokenIdentity 继续服务原 `0x18c620` 的身份比较。ManagerTokenAdmission 则恢复上述原 target 准入，两者各有调用语义，不合并成错误的统一比较键。后者复用唯一 KeyToken，每次实际收集使用一个独立对象，不实现查询或制造结果。

原缓存虽也是 `0x28` 步长，并不能套成带 marker 的 ScoredKeyToken。后续 Direct 取证结合本段已存指令，确认 `0x19337c` 保存 s0，`0x1934bc` 从 `+0x20` 加载 s0，该值类型为 binary32，而非任意整数。当前仍未创建缓存的替代布局，也不添加 marker 或新的权重换算。

## 验证与边界

仅严格编译 token_manager_selection 一份源码及一个组件测试：

- 七组字面输入覆盖 selector、language 的匹配及双向通配。
- 同一成功子记录输入流，source 全部保留；target 保留首个分类/文本组合，并保持到达顺序。
- 输入包括低位 ID、bit 31、附加字段及身份 bit 不同的同类同文记录，另含分类差异、大小写和 NUL 后缀差异。
- 期望为独立字面 ID 向量，不调用新规则计算答案，不伪造字典或迭代器。

测试通过，未重跑不变的输入拆分、归一化、存储和学习流程。标准 set 用于表达已确认的唯一键，分配、OOM、原树 ABI 及异常恢复不宣称等价。未运行完整 Push/Pop、真实资源查询、原 ARM64 或 Android，未操作设备、正式包和用户词典。

十八段新增 FDE 与原版及保留 v2.1.7 库逐字节相同，中央增至 `395` 区域。前期工厂、虚表和单项查询证据直接复用。比较与导出留在 `work/native-rewrite/restart-v217/native-token-manager-selection-comparison.json` 和 `token-manager-selection-export.json`。

Ghidra 成功输出位于 `token-manager-query-state/`、`token-manager-query-core/`、`token-manager-selection/`、`token-manager-key-order/` 和 `token-manager-cache-advance/`，均在 `work/native-rewrite/ghidra/`。测试二进制精确清理，build.log 留存于 `work/native-rewrite/token-manager-selection-build/`。

后续 [DirectTokenDictionary](direct-token-dictionary.md) 已从三种不同原始资源恢复普通 DFS 查询，共用本段的资格谓词。后续 [普通 Forward 资源读取](forward-token-dictionary.md) 已接入真实 Marisa 图和五张表，恢复完整字符串的单项 source 与 literal target，但不是子 cursor。Forward 的 Push、Pop、Reset、待应用帧和 Manager 缓存组合仍待恢复，不用提前准备的查询结果替代真实读取。
