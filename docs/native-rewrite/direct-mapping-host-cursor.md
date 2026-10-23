# DirectMapping 宿主子游标

已恢复四份原 `DirectMappingTokenExpander` 资源的加载和具体子游标。入口为 `DirectMappingTokenExpander::Load`，接收类名前缀之后的原 payload。类名前缀仍由唯一的 `LoadDictionaryStringImage` 读取。

该子游标已进入真实 [扩展 Manager](expander-manager-identity.md#宿主-manager)，键生成收集和 Android 尚未接入。它与 Manager 共用游标协议，仍不单独代替 `0x18d07c` 的 Manager 消费语义。

## 资源与共享原语

- `token_expander_metadata.proto` 按已确认字段号读取类别、输入分类、附加标识和回退开关。默认值为 `0/0/0/false`。字段名和枚举值名是研究标签，不声称恢复原 proto 文本。
- 两张索引表复用 `FlatIntegerTableView`。target 和 score 数组走原始字节路径，保留完整 target word 及间接位置标记。
- `LoadDictionaryArrayImage` 是唯一的 LE64 长度数组入口。Forward 的 prefix score 区也改用它，移除原内联读取。区域所有权仍由 `OwnedByteRegion` 保持。
- 输入资格复用 `MatchesTokenDictionary`。三位分类提取集中到 `TokenKindFromId`，原 target 准入也调用同一处。

当前加载范围是普通完整资源。宿主对不支持的损坏布局返回空，不复刻原局部发布、分配失败及诊断行为。

## 子游标语义

`Reset` 按输入分类和附加标识匹配，再用低 21 位查询。索引的 lower_bound、32 位区间算术及间接目标展开沿用 [native 证据](direct-mapping-native.md)。

匹配失败时返回 false，只清除待回退标志，原已选区间仍存在。调用方必须处理拒绝，不能把它当成接受后的空区间。该行为直接见 `0x19d0f0`。

匹配成功但查找未命中时，原配置允许的回退项保留完整输入，分数为正零。普通映射只写输出 ID 和附加字段，原输出文本及身份 bit 保持原值。调用方后续补文本，见 `0x19cc8c` 和 `0x18d07c`。

`Current` 支持可选分数输出。默认表按 binary32 分别计算 `20.0/255.0` 和乘法，读取后取负。code 零得到负零，回退仍为正零。`Advance` 先清回退标志，再按剩余数量推进，`Exhausted` 同时检查两种来源。

## 原始数组误读修复

恢复中发现证据工具把原始数组送进 `packed_table`。该函数为匹配原 FlatVector，宽度 32 的结果 mask 为零。因此当前派生 manifest 的 target 值及后续映射分析失真，原 blob 字节完好。

`extract_data_bundles.py` 已将原始数组交给 `raw_integer_array`。位压缩表保留已确认的 mask 行为，两条读取路径只共用统计描述。原始数组的 `data_size` 和 SHA-256 现在只覆盖实际 payload，填充单独计入推进。

本轮已从原 APK 刷新 `forward-token-data` 清单。旧缓存中由错误路径生成的 target、间接数量和映射分析应重新导出，不能作为结果预期。旧静态指令证据和原 blob 字节不受影响。

## 验证

一次完整宿主构建：

```text
bash research/native-rewrite/tools/build_forward_token_research.sh expander
```

构建前已用修正后的导出工具从固定原 APK 刷新资源。一个真实资源端到端用例遍历四份资源，覆盖两个英文 blob、数字及拼音。固定预期来自原始字节和已有静态记录：

- 英文大小写映射到完整 ID `0x00800061`，区间空洞回退时保留输入。
- 数字输出完整 ID `0x08800030` 和附加字段 `300`。
- 「重」按原顺序返回 `0x0080e029`、`0x0080e1a2`，分数 word 为 `0xbf5cdcdd`、`0xbf0c8c8d`。
- 「中」允许输入附加值 `26`，输出原 metadata 的 `16`。
- 已选区间遇到分类拒绝后保留，普通写入保留文本与身份 bit，分数可省略，正负零分别核对。

另有明确 wire/default、原始数组 framing 的模块用例，以及上述 Python 原始 word 误读的回归用例。构建及真实资源用例通过，日志为 `work/native-rewrite/forward-token-build/direct-mapping-expander-build.log`。旧独立组件及旧 Manager 流程没有重复运行。

Ghidra 导出保存在 `work/native-rewrite/ghidra/direct-mapping-readable/`。本轮沿用既有 DirectMapping、metadata 和默认量化函数证据，中央仍为 524 段，没有新增 FDE 比较或执行原 ARM。

## 下一步

扩展 Manager 的顺序应用、拒绝保留和重复身份分数处理已恢复。下一步核对 token Manager 的补文本入口，再接 `0x18d07c`，继续使用已有身份、收集结束判断及归一化原语。

`InMemoryTokenExpander`、完整类别缓存和扩展键组合仍未恢复。尚无原 ARM 动态等价或完整输入法验收，本轮没有操作设备、正式包、用户词典或其他 worktree。
