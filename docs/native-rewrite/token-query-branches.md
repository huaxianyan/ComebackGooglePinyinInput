# Token 查询分支与资源接口

本轮展开源 token 转换的两套实际查询、管理器工厂和资源虚表，并恢复 BFS 输入的 UTF-8 单元拆分。普通 Direct/Forward 的 Manager 查询及已解析资源工厂已有真实宿主实现，没有新增 lookup 替身。后续 [ManagerIterator 状态与准入](token-manager-selection.md) 已展开匹配帧和懒缓存，并将资格匹配、target 准入恢复为源码，普通 [Direct DFS 子查询](direct-token-dictionary.md) 也已连接真实资源。

后续已接真实 DFS 单项查询助手 LookupTokenQuery。文本准备已确定为 UTF-8 码点逆序，宿主仅支持开启逆序时已通过原 interchange 校验的输入，未移植原修复路径。普通 Manager 的批量 source 调用方已接；任意 provider 的工厂分派和 BFS 单项查询仍不在宿主范围。

## 管理器实际接口

TokenDictionaryManager 有 SettingDelegate 主对象和 `+8` 的 TokenDictionaryInterface 次级对象。主地址点为 `0x67a250`，次级地址点为 `0x67a2d8`。

源转换使用次级接口 slot 9/10，经 `0x194430/0x193f30` 调整 this 减八，进入 `0x1941fc/0x193c7c`。不能把次级地址点的槽号直接用于主虚表。

- 首选工厂分配真实 ManagerIterator，地址点 `0x67a380`。它遍历管理器 `+0xc0` 起的活跃条目，经 `0x19208c` 取得字典对象，再调用各字典 slot 9，记录两项原属性并加入合并迭代器。
- 即使活跃集合为空，首选工厂正常分配后仍返回合并对象。不能用「没有查询结果」触发另一查询分支。
- 另一工厂分配 BFSMergedIterator，地址点 `0x67a400`。按每个字典及其附属映射选择 slot 10 或 11，只纳入非空子接口；没有取得任何子接口时才销毁合并对象、返回空。

原 `0x19550c` 仅在首选接口本身为空时请求备用接口。某个词查询失败后不会再自动尝试 BFS。活跃表现已确认按有符号 `(selector, language)` 排序并保留同键首次插入项，普通已解析资源工厂已有后续实现。后续已接 TokenDictionaryDataSetting 与普通 bundle ID 缓存，附属迭代选项只恢复 schema。原 scheme 的成功初始内存注册已有投影，完整 Android DataManager/accessor 生命周期仍待接入。

## 首选单项查询

`0x195a68` 的顺序是：

1. 准备文本，按 is_source 选择 slot 0 或 1，传入原 `0xffffffff` 参数、language ID 和字节 span。
2. 调用 slot 2，再检查 slot 7 的结束状态；前面的返回值不新增失败 gate。
3. 查到时，可选调用 slot 5 写 token，然后调用 slot 3 Pop。原实现对 Pop 失败执行致命检查，不能悄悄降级为普通未命中。
4. 未查到时调用 slot 9 Reset，返回 false。

因此，这不是直接调用已有用户词典 TrieExactMatchCursor 就能替代的接口。后者没有 token 字典、language 选择和合并资源的语义。

## BFS 单项查询

`0x195c74` 把准备后的文本拆成 Unicode code point 的 UTF-8 字节串。每个单元构造一条输入边，范围为 `[i,i+1)`，携带同一 language ID。source 模式使用原值零，另一模式使用二，不给它们另猜业务枚举。

每条边进入 slot 0，结束后调用 slot 1，再由 slot 10 判断是否有结果。查到时可选经 slot 7 写 token。无论成功还是失败，都执行 slot 2 的零参数重置，而不是首选分支的 Pop。

本轮没有先造输入边或迭代器壳，只恢复有完整字节依据的拆分操作。原失败诊断会打印 token 文本，后续实现继续遵守项目隐私边界，不恢复这类日志。

## 已恢复的输入拆分

AppendTokenQueryUnits 对应 `0x1bf8dc`，源码位于 `recovered/token_query.{h,cc}`。它使用原 `0x322050` 的十六项高 nibble 宽度表，向已有输出追加完整 UTF-8 字节单元，不清空旧输出。

ARM64 把读到的宽度放入 w2，既用于推进指针，也作为字符串构造长度。Ghidra 漏显示这个长度参数，不能据伪码改成 NUL 结尾字符串读取。

范围限定为完整、合法、已准备的 UTF-8，且输入不借用输出存储。它不是校验器，不增加替换字符、静默截断或新的拒绝策略。内嵌 NUL 按长度保留，补充平面字符作为一个单元，组合附加符另成单元，不按 UTF-16 char 或 grapheme 拆分。

两套查询共享 `0x1bf63c` 的可选文本准备，现已确定其核心为码点逆序，不是重新编码或归一化：

- `0x25a454` 将 UTF-8 交给 UnicodeText，先经 `0x2cf518` 检查 interchange-valid。失败时另走复制及 `0x74b80` 修复，不能猜成替换字符或截断规则。
- `0x25a230` 返回起点，`0x25a238` 返回起点加字节长度。原循环从后者向前者移动。
- `0x25a2e8` 向前移动一个完整 UTF-8 单元，`0x25a304` 将当前单元的原始一至四字节复制到输出。ARM 指令先递减临时迭代器以读取，再递减循环迭代器以推进，并非两次消费。

ReverseTokenQueryUnits 复用已有 AppendTokenQueryUnits 的码点边界，逆序拼接原字节。大小写保持不变，组合附加符与基字符分别逆序，不按 grapheme 处理。输入须已通过原 interchange 校验。宿主没有移植非法或非 interchange 输入的修复，不把该函数作为 UTF-8 校验器使用。LowercaseTokenBytes 仍只对应独立的 `0x2d16c8` ASCII 表，不与逆序合并。

## 已接真实单项助手

LookupTokenQuery 对应 `0x195a68` 的普通 DFS 路径，直接操作 TokenDictionaryCursor：复制输入或按上述范围逆序，按 is_source 映射 source/target，传原 selector `-1` 及请求语言。Push、NextFrame 和 Current 的返回值不新增失败 gate，查到时可选写 token 后 Pop，Pop 失败沿原 CHECK 致命结束。未查到时 Reset，保留原输出并返回 false，不因未命中切换 BFS，也不恢复原打印输入文本的日志。

单项助手的逆序标志仍是显式参数，普通批量入口现已从 Manager 的真实属性读取后传入，不因此开放反向词典装载。可选输出不是无副作用检查，Direct 在 Push 编码多码点时已经推进共享动态 ID，省略 Current 不会撤销它。助手不把共享计数器改成游标局部状态。

## 普通批量调用与标志来源

`0x19550c` 的两个直接调用点位于 `0x18db08` 和已取证的 `0x18e380`。两者先做原输入校验，再从 TokenDictionaryInterface slot 15 取逆序标志，而不是从语言编号猜方向。

Manager 的 slot 15 经 `0x191e40` 调整 this，`0x191e38` 读取主对象 `+0xb8`。原构造器 `0x192314` 将它初始化为 true，非空激活集合才以首个字典的标志替换，再核对其他项一致。它不是各项 OR，也不能把空 Manager 的默认值改为 false。当前不可变普通工厂只接非反向资源，所以非空集合一致为 false，空集合保留原 true。UsingReversedTokens 由现有模型读取或使用已取证的空构造状态，不保存第二份属性。

ConvertSourceTokens 直接接普通 Manager，按实际调用方取得属性，创建真实 DFS、Reset、调整输出长度，再从后往前逐项调用 LookupTokenQuery。输入语言与文本数量逐项对应，计数在原 int32 范围，输出引用对应两条实际调用方的非空参数。它不是任意 TokenDictionaryInterface 的完整替代。

`0x19549c` 调整 token 向量，增长的 `0x195270` 对新元素写入空文本、ID 零、附加字段 26 和身份 bit false。已有元素只在成功写入时改变。失败不清空整个输出，也不恢复已经写入的项。默认已知字段集中于 KeyToken，原缓存初始化也复用，不复制未观察的 padding 或高位。

普通工厂包含空集合也返回非空 DFS，因此这里没有 BFS 占位后端。原结束 slot 10 经 `0x1926b4`、`0x192694` 析构并释放对象，宿主以唯一所有权在成功和失败时清理。BFS 分支的 `0x194df0` 只是调用 slot 2 的零参数 Reset，不把它错当另一种文本准备。

## 验证与证据

原拆分阶段仅严格编译一个拆分源码及一个组件测试。字面输入包含一至四字节 UTF-8、NUL、补充平面字符和组合附加符，并保留已有 prior 项，输出与独立字面向量一致。测试通过，没有运行或伪造实际 lookup。

八段新 FDE、四个资源地址点和宽度表与原版及保留 v2.1.7 库逐字节一致，中央增至 `377` 区域。原转换入口、身份、归一化和存储证据直接复用，没有重跑旧流程。

- 查询助手：`work/native-rewrite/ghidra/token-query-branches/`
- 管理器成功导出的四个函数：`work/native-rewrite/ghidra/token-query-resources/`
- 正确文本函数输出：`work/native-rewrite/ghidra/token-query-text/`
- 比较：`work/native-rewrite/restart-v217/native-token-query-comparison.json`
- 中央导出：`work/native-rewrite/restart-v217/token-query-export.json`

首次手输工厂地址错误，纠正后四个工厂/调整函数成功，随后又因文本地址的基址换算错误中断。文本函数用正确地址另行导出，相关错误日志保留，不把 headless 进程退出零当脚本成功。结论仅使用上述成功函数与独立 FDE 比较。

测试二进制精确清理，build.log 留存于 `work/native-rewrite/token-query-build/`。未执行原 ARM64，未操作设备、正式包或用户词典。ManagerIterator 的匹配帧、懒缓存和准入已有后续记录。普通 Direct 子查询已有真实资源实现，[普通 Forward 单项读取](forward-token-dictionary.md) 也已接入原始图和五张表。Forward 流式游标、Manager 工厂、设置字节及普通 ID 缓存均已有后续真实入口。普通模型注册与创建回调已有后续证据，见 [创建链记录](token-model-creation.md)。后续普通 bundle 的 scheme 内存注册已有真实入口，见 [内置数据注册](builtin-data-enrollment.md)。前一阶段单项助手已进入同一条原 bundle→scheme→Manager 端到端入口。验证覆盖普通 source、逆序 source、Unicode target、未命中后继续、无输出存在性查询，以及保留其状态后的跨 Manager 动态 ID。一次完整宿主构建、新逆序模块及该流程通过，日志为 `work/native-rewrite/forward-token-build/token-query-helper-build.log`。未重跑旧 schema 或独立查询测试。

新增六段 UnicodeText 辅助函数的完整 FDE，全部 raw-equal，中央从 506 增至 512，旧区域不重做。证据为 `work/native-rewrite/restart-v217/native-token-query-helper-comparison.json`，Ghidra 输出为 `work/native-rewrite/ghidra/token-query-unicode-preparation/`。未执行原 ARM/Android，未验证修复路径或完整 BFS。后续批量阶段已将普通上层调用方及标志来源接入同一真实入口。一次完整宿主构建通过，验证输出倒序、逐项语言、缩短与增长、失败前缀和旧剩余项、新 token 默认字段，以及空输入和空 Manager。原单项、schema、逆序模块均未独立重跑。日志为 `work/native-rewrite/forward-token-build/source-token-sequence-build.log`。

新增九段完整 FDE，全部 raw-equal，中央增至 521，旧 512 段直接沿用。证据为 `work/native-rewrite/restart-v217/native-source-token-sequence-comparison.json`。Ghidra 输出为 `token-source-sequence-*`，原第二调用方与批量函数的既有字节证据不重做。下一步接实际调用上下文及 `0x18ccb0` 输入校验，不因转换已完成就宣称完整键生成或引入 BFS 替身。
