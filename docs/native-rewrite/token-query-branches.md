# Token 查询分支与资源接口

本轮展开源 token 转换的两套实际查询、管理器工厂和资源虚表，并恢复 BFS 输入的 UTF-8 单元拆分。普通 Direct/Forward 的 Manager 查询及已解析资源工厂已有真实宿主实现，没有新增 lookup 替身。后续 [ManagerIterator 状态与准入](token-manager-selection.md) 已展开匹配帧和懒缓存，并将资格匹配、target 准入恢复为源码，普通 [Direct DFS 子查询](direct-token-dictionary.md) 也已连接真实资源。

## 管理器实际接口

TokenDictionaryManager 有 SettingDelegate 主对象和 `+8` 的 TokenDictionaryInterface 次级对象。主地址点为 `0x67a250`，次级地址点为 `0x67a2d8`。

源转换使用次级接口 slot 9/10，经 `0x194430/0x193f30` 调整 this 减八，进入 `0x1941fc/0x193c7c`。不能把次级地址点的槽号直接用于主虚表。

- 首选工厂分配真实 ManagerIterator，地址点 `0x67a380`。它遍历管理器 `+0xc0` 起的活跃条目，经 `0x19208c` 取得字典对象，再调用各字典 slot 9，记录两项原属性并加入合并迭代器。
- 即使活跃集合为空，首选工厂正常分配后仍返回合并对象。不能用「没有查询结果」触发另一查询分支。
- 另一工厂分配 BFSMergedIterator，地址点 `0x67a400`。按每个字典及其附属映射选择 slot 10 或 11，只纳入非空子接口；没有取得任何子接口时才销毁合并对象、返回空。

原 `0x19550c` 仅在首选接口本身为空时请求备用接口。某个词查询失败后不会再自动尝试 BFS。活跃表现已确认按有符号 `(selector, language)` 排序并保留同键首次插入项，普通已解析资源工厂已有后续实现。后续已接 TokenDictionaryDataSetting 与普通 bundle ID 缓存，附属迭代选项只恢复 schema。原 DataManager 注册和完整 Android accessor 仍待接入。

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

两套查询还共享 `0x1bf63c` 的可选文本准备，它经 Unicode 中间对象重新编码。具体字符策略尚未闭合，不将其猜为 ASCII 小写、case-fold 或 NFC，本轮不实现替代规则。后续恢复的 LowercaseTokenBytes 对应另一函数 `0x2d16c8`，只有原 256 字节表定义的 ASCII 转换，不填补这一缺口。

## 验证与证据

仅严格编译一个拆分源码及一个组件测试。字面输入包含一至四字节 UTF-8、NUL、补充平面字符和组合附加符，并保留已有 prior 项，输出与独立字面向量一致。测试通过，没有运行或伪造实际 lookup。

八段新 FDE、四个资源地址点和宽度表与原版及保留 v2.1.7 库逐字节一致，中央增至 `377` 区域。原转换入口、身份、归一化和存储证据直接复用，没有重跑旧流程。

- 查询助手：`work/native-rewrite/ghidra/token-query-branches/`
- 管理器成功导出的四个函数：`work/native-rewrite/ghidra/token-query-resources/`
- 正确文本函数输出：`work/native-rewrite/ghidra/token-query-text/`
- 比较：`work/native-rewrite/restart-v217/native-token-query-comparison.json`
- 中央导出：`work/native-rewrite/restart-v217/token-query-export.json`

首次手输工厂地址错误，纠正后四个工厂/调整函数成功，随后又因文本地址的基址换算错误中断。文本函数用正确地址另行导出，相关错误日志保留，不把 headless 进程退出零当脚本成功。结论仅使用上述成功函数与独立 FDE 比较。

测试二进制精确清理，build.log 留存于 `work/native-rewrite/token-query-build/`。未执行原 ARM64，未操作设备、正式包或用户词典。ManagerIterator 的匹配帧、懒缓存和准入已有后续记录。普通 Direct 子查询已有真实资源实现，[普通 Forward 单项读取](forward-token-dictionary.md) 也已接入原始图和五张表。Forward 流式游标、Manager 工厂、设置字节及普通 ID 缓存均已有后续真实入口。普通模型注册与创建回调已有后续证据，见 [创建链记录](token-model-creation.md)。下一步定位内置 data scheme 的内存注册，再接上层文本准备，不增加固定结果或通用转发接口。
