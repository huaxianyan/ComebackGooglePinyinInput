# 普通 Forward token 资源与单项读取

本文继续 [Manager 查询](token-manager-selection.md) 和 [token 辅助数据](token-dictionary-auxiliary.md)。ForwardTokenDictionaryView 从原 APK 的真实 Marisa 图、配置和五张表读取 token，未接入 Android，也不是完整 DFS、BFS 或 ManagerIterator。

## 恢复范围

支持原版全拼、数字和六套双拼，共八份普通资源。源码为 `recovered/forward_token_dictionary.{h,cc}`，同属 `research/native-rewrite/`：

- 只读映射原始序列化图，不重建 key 或准备候选。
- 完整 source 字符串经真实 Marisa 精确查找，结果索引读取原 token ID 和 meta。
- 按 ID 低 21 位填入 UTF-8 文本，auxiliary 写字典 language，身份 bit 按存储长度与本次匹配字节长度比较。
- 普通 target 经原 C 字符串复制后只接受一个 Unicode 码点，生成原 literal ID，auxiliary 保留请求 language，并清除身份 bit。
- metadata 的 target_uses_source 为真时走同一 source 读取。资格匹配复用 MatchesTokenDictionary，不另写通配规则。

这个入口只恢复无附属值记录、UTF-8 码点编码的普通资源。encoded-token trie、非空 field_10、二进制编码和 custom encoding 返回不支持的空对象，不产生就绪的占位词典。单个原始 key 对应一个结果的范围内没有候选重排，也未实现多结果评分。

## 真实 reader 与空表修正

`0x1b6cb0` 依次加载底层 trie、metadata、五张 FlatVector、可选 custom encoding 和 prefix score 字节区。五张表的顺序固定为 ID、score、meta、code、node ID。每张都包含 LE32 count、LE32 width 和完整 32 位字负载，整体推进到八字节边界。

ID 表也有 count。此前把同一字段解释成外层 token_count、再称 ID 表省略 count，只是错误的分层，不是另一种 wire 格式。Direct 与 Forward 现在共用 LoadFlatIntegerTableImage，原 Direct 私有副本已移除。

数字资源紧跟 ID 表的八个零字节是合法的空 score 表头，count 和 width 均为零。后面依次为 1-bit meta、6-bit code 和 4-bit node ID，最后仍有计数为零的 prefix 字节区。此前「只有四张表」「数字没有 node ID」「零字节用途未知」的结论已更正。

prefix 的长度为 LE64，后接相应数量的字节及八字节对齐填充。旧解释中的「32 位保留零字段」实际是长度的高半部。提取工具 schema 升为 `3`，取消跨零表头搜索和按 token 数量猜位宽的分支。八份普通资源共有 `40` 张 FlatVector，其中数字的 score 表为空。原有 `17,310` 个数值的字节解码结论不变，不能沿用旧列名误差。

## Metadata 的字段与默认值

原 generated parser 为 `0x1bf1f0`，默认值初始化为 `0x1bec2c`。唯一协议定义在 `recovered/forward_token_metadata.proto`，由既有官方 protobuf-lite 生成 C++，不另建手写解析器。

| 字段 | 已确认作用 | 未设置时 |
| --- | --- | --- |
| 1 | selector | 0 |
| 2 | BFS 输入匹配后展开字段 3 的符号，原名称未恢复 | 空串 |
| 3 | 输入符号字符串集合 | 空集合 |
| 4 | language ID | 0 |
| 5 | 使用 token score | false |
| 6 | 文本编码：0 二进制、1 UTF-8 码点、2 custom | 0 |
| 7 | 保留原大小写，控制 source 复制分支 | true |
| 8 | target 复用 source 读取 | false |
| 9 | encoded-token trie，普通 DFS 工厂在此为真时不创建接口 | false |
| 10 | 字符串，非空时参与特殊 token ID 初始化 | 空串 |
| 11 | 长度惩罚属性 | false |

未设置的 language 为零，不是未就绪 getter 返回的 UNKNOWN_LANGUAGE `26`。显式 false 与未设置继续由 proto2 presence 区分，不能补成另一套默认状态。

## 文本与身份

`0x1b2e84` 把字段 7、8 分别复制到 cursor 的 source、target 分支标志。source 的字段 7 为真时实际调用 `0x85e88`，它使用 strlen；为假时按 span 复制再调用原 ASCII lowercase。这里保留内嵌 NUL 的 C 字符串截断，不把它改成统一按长度读取。AppendTokenQueryUnits 自身仍按长度保留 NUL，两个入口不能混同。

`0x1b4d48` 的编码 1 分支把 ID 低 21 位交给 `0x1bf884` 填文本，不是取 code 表转字符。例如，微软双拼的 `jt`、`jv` 返回同一 ID 和 `U+E098` 文本，但它们的 code、node ID 槽位不同，不能按共享 token 合并原始表行。

合法 UTF-8 单元解码与码点编码留在 token_query，共用原 nibble 拆分，不增加 Unicode 归一化。可选文本准备 `0x1bf63c` 仍未恢复。接口接收完整、合法、已准备的字符串，不模拟原始指针长度与 C 字符串范围相矛盾的调用。

## 宿主依赖与验证

研究使用上游 Marisa `v0.2.6`，提交 `e54f296bb52d16693931c8b963744931ef1e37f7`，读取原序列化图。版本固定在 `dependencies/marisa.json`，选择上游双许可中的 BSD-2-Clause，完整通知在相邻 COPYING 文件。现已附带可复现的三态查询研究补丁，单项读取与分段 ExactCursor 共用一个核心。这是宿主研究依赖，不代表原 APK 使用这个确切版本，也不替换产品输入法引擎。

在已具备编译器和 protobuf 的 WSL 中：

```bash
bash research/native-rewrite/tools/build_forward_token_research.sh
```

先按 manifest 的 SSH URL、标签取得源码到指定 work 目录。脚本核对提交，从该提交导出构建副本并应用 manifest 指定的研究补丁，依赖 checkout 保持原样。自有源码严格使用 C++17、`-Wall -Wextra -Werror`，上游源码和官方生成代码独立编译。传入 `queries` 可只运行受影响的普通字典与流式查询入口，跳过未改的 metadata 模块。

本轮结果：

- Metadata 模块保持原默认值、存在性和显式字段的字面 wire 往返。UTF-8 编码以独立字面字节覆盖一至四字节及零码点。
- 真实 C++ 入口从八份原资源精确读取全部 `3,464` 个 key，与已有独立 Python 字节解码所得 token ID 一致。每份资源单独核对列角色及 prefix 活跃长度，不重复原 FlatVector 全值差分。
- 字面资源用例验证 source 文本、双拼别名文本、原 C 字符串分支、数字 meta 角色及补充平面 target 的 ID 和请求 language。
- 初次驱动把非 native blob 的 null 容器当字典，构建与模块测试后在 Python 阶段失败。修正驱动后只重跑受影响的资源入口，日志均保留。

数据及 schema 3 清单位于 `work/native-rewrite/forward-token-data/`，旧清单单独标为 `manifest-v2-obsolete-digits.json`。构建、失败诊断和成功资源入口分别位于 `work/native-rewrite/forward-token-build/build.log`、`first-attempt-native-evidence.log` 和 `resource-test.log`。

## 静态证据与下一步

中央登记增至 `460` 段。本次新增 `25` 段中，`24` 段与保留 v2.1.7 库逐字节相同。metadata 构造函数的 `0x1bec68` 有一条 ADRP 不同，两侧经后续 ADD 分别指向 `0x69f3e0`、`0x6a13e0`，都为各自 `.bss + 0x3a20`。它是地址差异，不记录为字节相同，也不据此宣称运行等价。另有三组 Marisa、metadata 虚表重定位相同。

增量证据在 `work/native-rewrite/restart-v217/native-forward-token-snapshot-comparison.json`。Ghidra 输出位于 `forward-token-owner/`、`forward-token-marisa-protocol/`、`forward-token-proto-codec/`、`forward-token-resource-load/`、`forward-token-cursor-init/`、`forward-token-image-slice/` 和 `forward-token-byte-header/`。一次手输的非函数入口导致导出中止，后续只补齐真实入口，失败日志没有被当作成功证据。

后续 [流式帧记录](forward-token-stream-frames.md) 已接通内层 Marisa ExactCursor 与普通 source/target 协调，owner 默认限额已从原构造函数恢复为 128，中央静态登记为 `480` 段。换用共享图核心后，八份资源的 3,464 个 key 已在新后端重新通过普通入口，原分段查询另走一条端到端测试。普通 Cursor 的 source、target 与长度属性另有窄范围真实入口验证。默认普通资源只返回至多一条记录，不触发多记录评分排序，没有新增评分缓存或接口。普通 Cursor 已通过共享宿主接口接入真实 Manager 懒缓存与查询入口，下一步恢复工厂及上层资源接线。BFS、多记录引用、custom 编码、评分与截断、损坏资源的部分发布、OOM、完整 ARM 执行和 Android 均未验收。保留原产品库与用户数据，不以当前静态和宿主证据替代完整输入法验收。
