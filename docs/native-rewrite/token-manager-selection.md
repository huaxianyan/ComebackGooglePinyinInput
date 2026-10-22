# ManagerIterator 状态与结果准入

本轮继续 [查询分支与资源接口](token-query-branches.md)，展开真实 ManagerIterator 的匹配帧、懒缓存及结果选择。字典资格匹配、单次结果准入和普通 Direct/Forward 组合游标均已恢复为源码，真实资源已通过 Manager 懒缓存入口。完整工厂注册、其他子字典和上层键生成接线仍未完成。

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

这套顺序已由 ManagerTokenCursor 接通，Direct 与 Forward 的实际类直接实现唯一的 TokenDictionaryCursor 宿主接口，没有逐方法转发壳或 fake 子迭代器。Push、帧 Next 与缓存结果推进保持独立。

## source 与 target 的不同准入

source 保留每个成功读出的 token。target 使用另一个原生键：

```text
((token.id >> 28) & 7, token.text 的完整字节及长度)
```

`0x193278` 的 UBFX 取 bit 28～30，不含 bit 31。`0x193190` 返回树插入位置与插入标志，只有首次插入才保留 token。`0x192e48` 的比较先看三位分类，再按 memcmp 与字符串长度判断，不以 NUL 截断。

因此，target 可丢掉完整身份不同、但分类和文本相同的后到记录。它不按附加字段、身份 bit 或完整 ID 去重，也不按子 slot 6 的值重新排序。优先关系来自原子接口扫描的先后。

SameKeyTokenIdentity 继续服务原 `0x18c620` 的身份比较。ManagerTokenAdmission 则恢复上述原 target 准入，两者各有调用语义，不合并成错误的统一比较键。后者复用唯一 KeyToken，每次实际收集使用一个独立对象，不实现查询或制造结果。

原缓存虽也是 `0x28` 步长，并不能套成带 marker 的 ScoredKeyToken。后续 Direct 取证结合本段已存指令，确认 `0x19337c` 保存 s0，`0x1934bc` 从 `+0x20` 加载 s0，该值类型为 binary32，而非任意整数。宿主 Result 仅保存 KeyToken 与 float 属性，不复制原容器 ABI，不添加 marker 或新的权重换算。

## 普通宿主 Manager

ManagerTokenCursor 接受有序、非空指针的真实 DFS 子游标快照。资格属性由调用方从真实字典元数据取得，保留工厂当时的 selector/language 快照。实现不自行注册资源、不猜应用中的工厂顺序，也不改为动态重配置。

Push 先清缓存、设置全局 source/target 模式，再筛选顶帧。失败保留旧匹配帧，但不恢复先前模式。Pop 只向顶帧委派并移除此帧，返回父帧时不擅自 Next。Reset 清根帧所有子游标，再缩回根帧。默认根帧没有可读结果。

首次 Current、Attribute 或 Advance 才收集剩余子记录，按原顺序消费全部子游标。Attribute 按原 `0x193474` 先物化再检查缓存索引，越界返回正零。缓存完成后只推进缓存索引，直接子游标不会因第二次读取而重查。收集时 KeyToken 临时对象只初始化一次，保留 Direct Current 不重置身份 bit 的原行为。

真实入口使用六份原资源：拼音、ABC 双拼、数字，以及英语、拼音英语、shortcuts。两份英语产生相同 source ID，缓存保留两条。target 按既有分类/文本规则合并同类记录，shortcuts 的不同分类保留。真实 Direct Next 固定 false，但 Manager 帧 Next 仍能成功，不能据子返回值伪造查询失败。

一次 `build_forward_token_research.sh manager` 完整宿主编译和一条端到端流程通过。用例验证资格筛选、source 到达顺序、重复项保留、属性入口物化、缓存消费后的帧重查、嵌套 Pop 换分支、target 去重和 Reset。期望 ID 是原清单或冻结格式字面值，不来自被测查询计算。之后据既有属性 getter 修正物化与边界检查顺序，仅重编译该模块，未重复执行已通过的用例。

日志为 `work/native-rewrite/forward-token-build/manager-cursor-build.log`。旧规则组件、内层 Marisa、普通全表枚举及独立 Direct/Forward 用例未重复执行。中央静态登记仍为 480 段，沿用既有 FDE 与字符表证据。未运行 ARM、Android，也未操作设备、正式包或用户词典。

完整工厂及注册顺序、其他子字典、BFS、重配置、OOM 和原容器 ABI 仍不在本投影范围。

## 早期规则组件验证

当时仅严格编译 token_manager_selection 一份源码及一个组件测试：

- 七组字面输入覆盖 selector、language 的匹配及双向通配。
- 同一成功子记录输入流，source 全部保留；target 保留首个分类/文本组合，并保持到达顺序。
- 输入包括低位 ID、bit 31、附加字段及身份 bit 不同的同类同文记录，另含分类差异、大小写和 NUL 后缀差异。
- 期望为独立字面 ID 向量，不调用新规则计算答案，不伪造字典或迭代器。

测试通过，未重跑不变的输入拆分、归一化、存储和学习流程。标准 set 用于表达已确认的唯一键，分配、OOM、原树 ABI 及异常恢复不宣称等价。未运行完整 Push/Pop、真实资源查询、原 ARM64 或 Android，未操作设备、正式包和用户词典。

十八段新增 FDE 与原版及保留 v2.1.7 库逐字节相同，中央增至 `395` 区域。前期工厂、虚表和单项查询证据直接复用。比较与导出留在 `work/native-rewrite/restart-v217/native-token-manager-selection-comparison.json` 和 `token-manager-selection-export.json`。

Ghidra 成功输出位于 `token-manager-query-state/`、`token-manager-query-core/`、`token-manager-selection/`、`token-manager-key-order/` 和 `token-manager-cache-advance/`，均在 `work/native-rewrite/ghidra/`。测试二进制精确清理，build.log 留存于 `work/native-rewrite/token-manager-selection-build/`。

后续 [DirectTokenDictionary](direct-token-dictionary.md) 与 [普通 Forward 资源读取](forward-token-dictionary.md) 均有真实子游标，已接通本页的 Manager 匹配帧与缓存。下一步恢复工厂和资源接线，再接上层键生成，不用提前准备的结果替代真实读取。
