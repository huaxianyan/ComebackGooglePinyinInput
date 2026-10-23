# Token 身份与扩展结果归一化

已恢复 token 身份、真实扩展 Manager 的补文本与收集。真实资源结果已进入批次合并和分数归一化裁剪。源码复用唯一 AddLogScores，不调用标准库 exp/log。完整键组合与缓存生命周期仍未恢复。

## 身份与记录

KeyToken 表达原 `0x20` 字节 token 中已观察的字符串、32 位 ID、16 位附加字段和一个身份 bit。ScoredKeyToken 再保存原 `+0x20` 分数及 `+0x24` 原始标记字节。两者是宿主语义类型，不克隆内存布局、padding 或未使用高位。后续 `0x195270` 确认新 token 的已知默认字段为空文本、ID 零、附加字段 `26`、身份 bit false。它们已集中到 KeyToken，Manager 缓存临时 token 也复用默认构造，未知语言常量只保留一个定义。

原 `0x18c620` 比较 `+0x18` 起低 48 bit，再比较 `+0x1e` 的 bit 0，文本不参与身份。因此，显示拼写不同也可能是同一 token。SameKeyTokenIdentity 是唯一身份判断点。后续 [ManagerIterator 准入](token-manager-selection.md) 恢复了另一个原生规则：target 按 ID 的三位分类和完整文本去重，保留先到项。它与本节的身份比较用途不同，继续复用 KeyToken，不用身份相等替代 target 准入。

新增取证 `0x18c658` 表明原排序先比较有符号 short，再比较无符号 ID，最后比较身份 bit。附加字段用 int16_t 保留其符号，暂不根据编号猜业务名。后续扩展 Manager 的真实结果集合已消费该顺序，KeyTokenIdentityLess 与身份相等判断共用唯一字段投影。

## 收集结果不是非空判断

CollectedExpansionResult 只对应 `0x18d07c` 的结束判断，前提是真实迭代器指针非空且迭代完成：

- 整份输出为空时，返回 false。
- 接受单个原身份时，非空输出返回 true。
- 另一模式下，仅有一项且身份等于源 token 时返回 false，结果项仍保留。
- 多于一项时按原逻辑返回 true，不逐项去重；旧输出也计入总数。

它不执行 reset/current/advance，不补 token 文本，也不代替管理器查询。原迭代器为空时的分支不属于这个 helper，不能仅凭此返回值宣称完整收集成功。

## 真实 Manager 补文本与收集

CollectTokenExpansions 位于 `recovered/token_expansion_collection.cc`，对应 `0x18d07c`。它借用实际 TokenDictionaryManager 和 TokenExpanderCursor，真实调用方测试传入扩展 Manager。没有建立空上下文壳、预制结果或替身后端。

### 按 ID 补文本

辅助对象 `+0` 保存的是 TokenDictionaryInterface 次级接口。slot 12 位于 `0x67a338`，经 `0x1921e8` 调整 this 减八，进入 `0x1921ac`。主地址点同偏移指向相邻的 `0x1921f0`，不能混用。实际模型选择在 `0x1920a0`：

- 分类复用 TokenKindFromId，即 ID 的 bit 28～30。
- bit 24 未设置时，按分类和有符号附加字段精确选择活跃项。这里的 `26` 不是通配值。
- bit 24 设置时，从同分类、语言非负的首个活跃项中选择，忽略 token 自带的附加字段。
- 没有匹配模型时返回 false，保留原文本。选中模型后直接返回该模型的回填结果，不继续扫描其他字典。

Direct 的 `0x1b16c4` 只修改文本。低 21 位为零时清空文本；其余 source 必须通过原字符范围检查，literal 则跳过范围检查。拒绝时保留原文本。成功时复用 EncodeTokenCodepoint，不转换大小写，也不重写 ID、附加字段或身份 bit。

Forward 的 `0x1b4d48` 只投影已支持的 CODEPOINT_UTF8、空 field_10 配置。该配置没有非零空 token 哨兵，按低 21 位编码文本，零值产生一个 NUL 字节。原 source/target 回填也复用此方法。拼音内部单元仍是原私用区字符，不猜成 n、en 或 wu 的显示拼写。

补文本不是 Direct 动态 ID 的反向词表。原多字 Current 复制保存的文本，此入口按 ID 和范围处理，不新增计数器反向映射。当前回填域限定为合法 Unicode scalar ID，超界值的原修复、其他编码和非空 field_10 仍未接。

### 收集与真实结果消费

收集器先 Reset，再按 exhausted、Current、Advance 循环。每个 Current 使用新建的默认 ScoredKeyToken，不沿用扩展 Manager 内部 Apply 的临时字段。Reset 和补文本的返回值都不新增失败门禁；Current 返回 false 时只推进，不追加。

Current 成功后先补文本，以 binary32 将子分数加上调用方分数，再复制原始标记字节并追加。已有输出保留，最后复用 CollectedExpansionResult。空游标直接返回 false，已有输出保持原样；单项同身份可以返回 false，同时保留已补文本的结果。

升级同一条真实资源端到端用例，三个原 DataScheme 共用已有缓存。扩展配置明确选择四个 DirectMapping ID，普通字典从原设置另加英文与数字 ID：

- 「唔」的三个有序结果补成原私用区 UTF-8，带入 `-1` 分数和 `0xd3` 标记。随后交给既有 NormalizeAndPruneExpansions，裁剪后保留 wu 对应的内部 token，文本和标记仍配对。
- 同身份结果的文本可以改变。两个结束模式、追加旧输出及空游标使用实际 Manager 产生的记录验证。
- 仅有拼音字典时，真实英文扩展仍追加空文本结果，证明补文本未命中没有成为新门禁。数字结果按完整 ID 和附加字段回填。
- 精确语言选择、literal 选择、范围拒绝、零值差异及补充平面字符经实际字典验证，没有伪造模型。

一次完整 expander 宿主构建通过。Forward 原 source/target 已改为共用回填入口，同次构建另跑其既有 Manager 和无扩展键消费流程。旧身份、数学、metadata 和 schema 模块未重跑。日志为 `work/native-rewrite/forward-token-build/token-text-collection-build.log`。

新增模型选择、补文本及次级 thunk 三段完整 FDE，均与原版及保留 v2.1.7 库 raw-equal，中央增至 527 段。旧字典回填、收集及归一化证据沿用。比较记录为 `work/native-rewrite/restart-v217/native-token-text-collection-comparison.json`，Ghidra 导出位于 `token-text-fill/` 和 `token-text-manager/`。

Current 失败分支未由现有真实 Manager 触发，不构造替身补覆盖。归一化消费已使用真实收集结果，但 `0x18e264`、`0x18e0e8` 的完整键组合仍未恢复。默认 InMemory、三个缓存的生命周期、原 ARM/Android 动态等价及 OOM 仍未验收。

## 批次内同身份分数合并

MergeExpansionScoresByIdentity 对应 `0x18def4`，由 `0x18e0e8` 在每组二次扩展后调用。输入复用 ScoredKeyToken，不增加另一份 token 或分数结构。

按原输入顺序逐项处理。同身份首次出现时保留完整已知 token 和分数，后来项以 AddLogScores 合入该分数，文本仍取首次值。结果按既有 KeyTokenIdentityLess 顺序写回，最后缩短原向量。身份投影及分数函数各保留唯一实现。

此处不使用扩展 Manager 的「更大分数覆盖」规则，也不归一化或裁剪。原写回只替换文本、ID、附加字段、身份 bit 和分数，目标位置的标记字节保持原值。它与 NormalizeAndPruneExpansions 的整项稳定移动不同。原 `0x18e0e8` 给此批次的所有标记写零，因此没有改成随排序项移动标记。

升级同一真实资源入口：先收集数字，再追加两次真实英文身份结果。合并后英文在前、数字在后，英文分数由两个正零合为字面 word `0x3f317218`，即原近似函数的 ln(2)。输入标记 `0x62/0x63/0x64` 写回后保留前两个位置的 `0x62/0x63`，不随 token 重排。输入全部来自实际 Manager 和收集器，没有预制结果或替身后端。

一次 expander 宿主构建及该入口通过，日志为 `work/native-rewrite/forward-token-build/expansion-score-merge-build.log`。本轮只新增批次合并消费者，普通字典行为未改。expander 范围已取消上一轮临时附带的普通 Manager 回归，旧身份、数学、metadata 和 schema 模块也未重跑。

新增一段完整 FDE，与原版及保留 v2.1.7 库 raw-equal，中央增至 528 段。证据为 `work/native-rewrite/restart-v217/native-expansion-score-merge-comparison.json`。同身份不同文本时保留首次文本的规则已按静态路径恢复，现有模型的同 ID 回填文本稳定，尚无不同文本的运行样本。原 ARM 动态等价及 OOM 仍未验收。

### 组合调用方的已确认顺序

本轮导出保留在 `work/native-rewrite/ghidra/` 下的 `expanded-key-callers/`、`expanded-key-combination/` 和 `expanded-key-combiner-core/`。以下仍是静态调用关系，不代表完整宿主实现：

- `0x18e264` 经 `0x18c850`、`0x195700` 准备 token。后者按 UTF-8 单元拆分并逆序执行 target 查询，语言参数为 26，不是已有逐项语言的 source 批量入口。
- 首阶段使用缓存 `+0x10`，调用方分数零、标记一、拒绝单项原身份。任一组返回 false 时结束该路径。
- `0x18e0e8` 使用缓存 `+0x18`，逐主选择带入旧分数，标记零、接受单项原身份。组内收集失败后仍合并已收集项，并继续处理后面的组。任一组失败会在循环后清空全部二次组。
- 随后以主组、二次组和整数参数 `2/1` 构造 `0x18ebd8` 对象，由 `0x190ea0` 消费。该过程还有候选流、堆和结果集合，不能直接改为笛卡尔积或预设 scale。
- `0x18e264` 最后读取生成记录 `+0x34`：非零时 category 为零，否则为二。scale 的形成、集合顺序和全部模式仍需继续核对。

下一步先展开候选流构造 `0x190c44` 和结果接纳 `0x18fc10`，再接完整组合。已导出的 `0x190db8`、`0x190138`、`0x190ea0` 和结果复制 `0x18f7b4` 沿用本轮取证，不重复导出。

## 归一化与稳定裁剪

NormalizeAndPruneExpansions 对应原 `0x18d424`：

1. 第一项作为累计起点，随后按输入顺序调用原 AddLogScores。
2. 各项以 binary32 减去累计值，不使用 double、排序重加或并行归约。
3. 保留不低于原 word `0xc0133333` 的项，稳定压缩后销毁尾部。

源码用精确十六进制浮点常量表达该阈值。交换时字符串、完整已知身份、分数和原标记字节一起移动，保留项顺序与原输入一致。宿主移动及分配方式不宣称与原临时字符串交换等价。

范围限定为有限分数、正常舍入环境及非 fast-math。实际键组合、分数到缩放系数的形成仍未恢复，不能将归一化分数直接当作上一阶段的 scale。

## 普通源 token 转换

原 `0x19550c` 已展开，不是对源字符串简单编号：

- 先请求管理器 slot 9 的接口，取得后进入其 slot 9，逐项调用 `0x195a68`，最后进入 slot 10。
- 第一个接口为空才请求管理器 slot 10 的另一接口，逐项调用 `0x195c74`，最后进入 slot 12。
- 输出先调整为源数量。源 token 从后往前读取，目标位置为 `n-1-i`，即输出顺序反转。
- 每项同时传入对应 language ID。某项失败就停止，仍经过对应结束钩子，不引入成功后统一提交的事务。

后续 [查询分支与资源接口](token-query-branches.md) 已接真实普通 Manager、子字典、资源、有效输入的码点逆序和单项助手。本阶段 ConvertSourceTokens 从实际 Manager 属性取得逆序标志，使用真实 DFS 工厂，按上述原顺序转换，不再依赖预制 token 数组。

输入 language 与源字符串逐项对应，数量在原 int32 范围内，均为原 interchange-valid 输入。接口只接实际调用方的非空输出引用及普通 Manager，不模拟任意 provider 的 null/BFS 分派。resize 缩小时销毁尾项，增长时仅默认初始化新项，已有未写项保持原值。某项失败留下已写前缀、旧未写项和新增默认项，不做回滚。

Manager 空集合仍创建 DFS，空输入转换清空输出并成功，非空输入未命中后保留已调整长度的输出。结束 slot 10 的 `0x1926b4` 经 `0x192694` 析构并释放迭代器，宿主用真实唯一所有权清理，不增加结束占位钩子。词典 key、Marisa key ID、内部 token ID 和身份字段仍不能互相替代。

另一个 `0x18d8b8` 只是拷贝结果，包含 `+0x18` 的 vector<bool>，不是产生 scale 的函数。当前消费投影不读取该向量，本轮不为完整生成器填空向量或默认系数。

## 验证与证据

新增一个纯组件测试，直接调用实际公开入口：

- 单项不同拼写但同身份时，收集结果为 false，输出仍存在。ID、附加字段或身份 bit 不同则判为不同。
- 两项同身份输出仍按原整个向量规则返回 true，不自动去重。
- 输入分数 `-128/0/0` 裁掉首项，另外两项保留顺序，得到字面 `-ln(2)` word `0xbf317218`，身份及 `0x21/0xe3` 标记保持配对。
- 输入对 `0/-2.19`、`0/-2.20` 的次项一留一裁，覆盖原阈值两侧，不由新算法计算期望值。

仅严格编译新组件和已有 score_math 两份源码，测试通过。没有重跑不变的存储、七文件流程或上一阶段消费测试。测试二进制精确清理，build.log 留存于 `work/native-rewrite/key-expansion-build/`。

两个新增身份排序、源转换 FDE 与原版及保留 v2.1.7 库逐字节相同，中央为 `369` 区域。原相等判断、收集、归一化和标量数学证据直接复用。

- `work/native-rewrite/ghidra/token-expansion-state/`
- `work/native-rewrite/restart-v217/native-token-expansion-state-comparison.json`
- `work/native-rewrite/restart-v217/token-expansion-state-export.json`

未执行原 ARM64，未操作设备、正式包或用户词典。完整非零插值逐 bit 对照、原容器 OOM/分配、其他后端及 Android 学习仍未验收。后续批量阶段一次完整宿主构建和同一真实原资源入口通过，覆盖逆序输出、逐项语言、失败部分结果及空 Manager；没有重跑本节旧数学组件测试。日志为 `work/native-rewrite/forward-token-build/source-token-sequence-build.log`。

新增九段完整 FDE，全部 raw-equal，中央增至 521，旧 512 段沿用。原第二调用方 `0x18e380` 和批量本体证据已存在，不重复比较。证据为 `work/native-rewrite/restart-v217/native-source-token-sequence-comparison.json`。后续已接 `0x18ccb0` 的输入检查及 `0x18db08` 的真实无扩展消费投影，详见 [键生成调用方](key-generator-score-math.md#已接无扩展调用方)。其 scale、标志及 category 来自原写入值，不是未完成生成器的默认返回。仍不创建未消费的身份或标记向量替身。后续四份真实资源的 [DirectMapping 子游标](direct-mapping-host-cursor.md) 已进入 [扩展 Manager](expander-manager-identity.md#宿主-manager)。顺序应用、身份排序及分数更新已恢复，后续已接本页的真实补文本、迭代收集和归一化消费。下一步沿原调用方恢复完整扩展键组合，继续保留缓存生命周期边界。
