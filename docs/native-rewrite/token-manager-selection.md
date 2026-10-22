# ManagerIterator 状态与结果准入

本轮继续 [查询分支与资源接口](token-query-branches.md)，展开真实 ManagerIterator 的匹配帧、懒缓存及结果选择。字典资格匹配、单次结果准入和普通 Direct/Forward 组合游标均已恢复为源码，真实资源已通过 Manager 懒缓存入口。设置 protobuf、普通资源 ID 缓存与 DFS 工厂也已接通。原 DataManager 注册、Android accessor、其他子字典和上层键生成仍未完成。

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

ManagerTokenCursor 现在只由 TokenDictionaryManager 工厂构造，Child 记录与快照构造器均已私有化。工厂读取真实字典资格属性，不再把测试传入的任意列表当作原工厂顺序，也不支持动态重配置。

Push 先清缓存、设置全局 source/target 模式，再筛选顶帧。失败保留旧匹配帧，但不恢复先前模式。Pop 只向顶帧委派并移除此帧，返回父帧时不擅自 Next。Reset 清根帧所有子游标，再缩回根帧。默认根帧没有可读结果。

首次 Current、Attribute 或 Advance 才收集剩余子记录，按原顺序消费全部子游标。Attribute 按原 `0x193474` 先物化再检查缓存索引，越界返回正零。缓存完成后只推进缓存索引，直接子游标不会因第二次读取而重查。收集时 KeyToken 临时对象只初始化一次，保留 Direct Current 不重置身份 bit 的原行为。

早期快照入口使用六份原资源验证了游标协议，包括两份英语的相同 source ID、target 分类/文本去重及 Direct Next 固定 false。该列表不是原工厂产生的活跃集合，同资格资源在真正激活时只保留先到的一份。本轮已把同一入口升级为工厂驱动，不继续保留人工根快照作为接线。

一次 `build_forward_token_research.sh manager` 完整宿主编译和一条端到端流程通过。用例验证资格筛选、source 到达顺序、重复项保留、属性入口物化、缓存消费后的帧重查、嵌套 Pop 换分支、target 去重和 Reset。期望 ID 是原清单或冻结格式字面值，不来自被测查询计算。之后据既有属性 getter 修正物化与边界检查顺序，仅重编译该模块，未重复执行已通过的用例。

日志为 `work/native-rewrite/forward-token-build/manager-cursor-build.log`。旧规则组件、内层 Marisa、普通全表枚举及独立 Direct/Forward 用例未重复执行。中央静态登记仍为 480 段，沿用既有 FDE 与字符表证据。未运行 ARM、Android，也未操作设备、正式包或用户词典。

原 DataManager 注册与 Android accessor、其他子字典、BFS、重配置、OOM 和原容器 ABI 仍不在本投影范围。

## 普通资源激活与 DFS 工厂

原设置回调 `0x194c84` 进入 `0x1948d0`，先经 `0x192b3c` 清空活跃表与迭代选项表，再通过 accessor 按配置中的数据 ID 取得模型句柄。`0x19208c` 只是句柄解引用，不是字典懒装载；结果缓存的惰性行为不能用于推断资源 I/O。

`0x193880` 的活跃表以两个有符号 int32 的 `(selector, language)` 为键，按这一顺序比较。相同键保留第一次插入的句柄，后来资源不覆盖。`0x1941fc` 中序遍历该表建立根快照，因此既不是设置列表顺序，也不是文件名顺序。先按资格激活、再做 target 结果去重，是两个不同阶段。

上一阶段 LoadActive 的镜像列表入口已移除，当前唯一入口为 TokenDictionaryManager::Load。它解析 TokenDictionaryDataSetting，再按配置列表中的 data ID 查询 TokenDictionaryResources。类名前缀分派移到资源层，Direct/Forward 加载器与活跃表选择各保留一个实现。普通非反向边界不变，未支持镜像与非空迭代选项返回 null，不发布部分工厂。

Direct 的第四个 LE32 元数据字段由原 `0x1b09c0` 的 IsUsingReversedToken getter 读取，Forward 的 `0x1b2720` 固定返回 false。当前原资源均为非反向模型。宿主现在读取 Direct 原字段，反向配置不进入这个普通工厂，不填默认值或替代准备规则。

CreateDfsCursor 按活跃表顺序创建真实子游标，调用既有 Manager 实现。即使活跃表为空也返回真实 Manager 对象，不能据空结果改走 BFS。多次创建的游标共享已装载模型及 Direct 动态计数器，匹配帧和结果缓存各自独立。原工厂逐次插入后重置根帧，宿主用同等空状态的新游标表达，不复用已消费游标。

本轮一次 `build_forward_token_research.sh manager` 严格宿主构建及升级后的单条端到端流程通过。六份资源故意按非排序顺序提供，结果证明 pair 顺序、拼音优先于同键 ABC、英语优先于同键拼音英语。单引号利用两份英语的真实字符范围差异验证先到保留，另以两个游标的字面动态 ID 验证模型共享。空集合仍返回 Manager，现有帧、缓存和 target 路径继续经同一真实入口。

新增五段 FDE 与两个完整叶函数 getter，均与保留 v2.1.7 库逐字节相同，中央增至 487 段。旧 480 段及 ADRP 差异沿用。证据为 `work/native-rewrite/restart-v217/native-token-manager-factory-comparison.json`，构建日志为 `work/native-rewrite/forward-token-build/manager-factory-build.log`。本轮未运行 ARM、Android 或旧独立测试。

## 设置消息与 data ID 缓存

新增 `token_dictionary_setting.proto`，消息名称由原 RTTI 确认。TokenDictionaryDataSetting 的 field 1 是 repeated string data_id，field 2 是 repeated DictionaryIteratorOptions。后者的 field 1、2 为默认 false 的可选 bool，field 3 是 data ID。两个布尔字段的业务名仍未知，不据其字节位置命名为 source/target。

序列化函数 `0x281bc8`、`0x281b20` 确定字段号与 wire 类型。选项初始化 `0x2845bc` 在 `+0x20` 写入零 ushort，清理 `0x287270` 同时恢复默认值和存在位。`0x194dd8` 分别读两个 bool 后组成返回值，不将 Ghidra 的 undefined2 当作独立原字段。

TokenDictionaryResources 的输入已升级为原 DataScheme 字节及按库名、blob 名分组的真实快照，由 C++ 建立原 data ID 索引。旧人工 Sources 构造入口已移除，详见 [内置数据注册](builtin-data-enrollment.md)。按 ID 缓存成功装载的真实模型，创建失败不进入缓存。缺失 ID 沿原 `0x1948d0` 跳过，宿主未支持的模型则返回 Unsupported，使工厂失败，不冒充原创建器确实返回空。

原 DataManager 的成功缓存规则沿用已有 `0x198f28` 证据，不重取。宿主恢复成功初始内存注册、不可变索引及普通模型缓存，不实现原部分失败发布、扩展创建器注册、FD 来源、Android 锁、失效标记或重配置。多个 Manager 通过同一资源对象复用模型，游标快照仍持有自己的共享引用。

后续已定位原 type 4 的类名前缀加载、Direct/Forward 模块注册和创建回调，见 [普通模型创建链](token-model-creation.md)。这两类的普通分派与现有宿主一致，本阶段不改查询实现，也不另加通用注册器。后续普通 bundle 的成功初始注册已接原 scheme 字节，完整 Android DataManager 生命周期仍待恢复。

同一条端到端入口现在读取原 pinyin_qwerty 设置的 field 2 原字节，ID 绑定取自原 data scheme。额外六个选择项是明确的测试配置，包括一个缺失 ID，不代表应用默认偏好。原六资源的帧、排序、先到保留和 target 用例继续执行，跨 Manager 的动态 ID 连续性验证真实缓存复用。没有新增人工结果或子游标。

一次 manager 宿主构建、上述端到端流程和一个 schema 模块测试通过。模块测试用字面 wire 验证字段、显式 false 存在性和默认值。日志为 `work/native-rewrite/forward-token-build/manager-setting-build.log`。迭代选项只恢复 schema，当前非空配置明确不支持。

新增七段完整 FDE，五段 raw-equal。两个构造函数各有一条 ADRP 差异，默认实例分别保持 `.bss+0x5a90` 与 `.bss+0x5840`，其余指令相同。中央增至 494 段，证据为 `work/native-rewrite/restart-v217/native-token-dictionary-setting-comparison.json`。旧区域不重跑，未执行 ARM 或 Android。

## 早期规则组件验证

当时仅严格编译 token_manager_selection 一份源码及一个组件测试：

- 七组字面输入覆盖 selector、language 的匹配及双向通配。
- 同一成功子记录输入流，source 全部保留；target 保留首个分类/文本组合，并保持到达顺序。
- 输入包括低位 ID、bit 31、附加字段及身份 bit 不同的同类同文记录，另含分类差异、大小写和 NUL 后缀差异。
- 期望为独立字面 ID 向量，不调用新规则计算答案，不伪造字典或迭代器。

测试通过，未重跑不变的输入拆分、归一化、存储和学习流程。标准 set 用于表达已确认的唯一键，分配、OOM、原树 ABI 及异常恢复不宣称等价。未运行完整 Push/Pop、真实资源查询、原 ARM64 或 Android，未操作设备、正式包和用户词典。

十八段新增 FDE 与原版及保留 v2.1.7 库逐字节相同，中央增至 `395` 区域。前期工厂、虚表和单项查询证据直接复用。比较与导出留在 `work/native-rewrite/restart-v217/native-token-manager-selection-comparison.json` 和 `token-manager-selection-export.json`。

Ghidra 成功输出位于 `token-manager-query-state/`、`token-manager-query-core/`、`token-manager-selection/`、`token-manager-key-order/` 和 `token-manager-cache-advance/`，均在 `work/native-rewrite/ghidra/`。测试二进制精确清理，build.log 留存于 `work/native-rewrite/token-manager-selection-build/`。

后续 [DirectTokenDictionary](direct-token-dictionary.md) 与 [普通 Forward 资源读取](forward-token-dictionary.md) 均有真实子游标，已接通本页的 Manager 匹配帧与缓存。设置字节与普通 ID 缓存已接到工厂。原内置 scheme 已进入普通资源注册，真实 DFS 单项助手现也已接入，见 [查询分支](token-query-branches.md)。下一步恢复上层工厂选择与标志来源，不用提前准备的结果替代真实读取。
