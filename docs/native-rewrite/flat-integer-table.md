# Flat integer 表读取

本文继续 [token 辅助数据研究](token-dictionary-auxiliary.md)，把实际资源所用的 FlatVector 读取恢复为 `FlatIntegerTableView`。它复用 OwnedByteRegion 和唯一的小端读取，不另建分配器，也不代表整个词典查询已接通。

## 原生读取与位宽

`0x13303c` 先检查索引小于条目数，随后按 `index * width` 定位 32 位字。值跨字时拼接下一字，再应用对象保存的掩码。位宽为零时直接得到零，但索引检查仍先执行。

`0x133ce8` 加载 LE32 条目数、LE32 位宽，再取按 32 位字补齐的负载。`0x133e44` 将整块推进量对齐到八字节。Direct 的两个范围表与 Forward 的五张表共用这一格式。后续真实 reader 已确认，所谓 Forward 外层 token_count 就是首张 ID 表的 count，不是另一种省略表头格式。

原加载器有一个需要保留的细节：掩码使用 ARM 的 32 位移位语义，移位量只取低五位。因此位宽 `32` 的掩码为零，读出的值也是零，而不是完整的无符号整数。本轮最初按常规满掩码实现，读取加载器后已改正，并以独立字面结果固定这一原行为。

视图复制既有区域描述符，保持负载的生命周期。构造要求位宽不大于 `32`，负载包含所需的完整小端字。调用方需先取得合法资源布局，来源更换后重新建立视图。

## 宿主验证

- 一份字面模块用例覆盖位宽 `0`、`1`、跨字的 `3` 以及原生零掩码的 `32`。输入字节和期望整数均为独立字面量。
- 首次真实资源入口以已有只读映射读取原 APK 的八份普通 Forward 资源，共 `39` 张非空表、`17,310` 个值。后续确认数字资源还包含一张空 score 表，总数为 `40`，先前数字列名也已更正，数值解码本身不变。
- 真实资源结果与先于本组件存在的 Python 大整数解码器比较，不从新 C++ 实现计算期望，也不打印 token 文本。
- WSL C++17 严格构建通过。资源差分只运行一次，实际资源位宽均小于 `32`，后续零掩码修正不改变该输入域。

代码为 `research/native-rewrite/recovered/flat_integer_table.h/.cc`，入口为 `tools/flat_integer_table_probe.cc` 和 `tests/verify_forward_token_tables.py`，均在同一研究目录下。

原始提取数据及当前 schema 3 manifest 留在 `work/native-rewrite/forward-token-data/`，旧清单标为 `manifest-v2-obsolete-digits.json`。首次真实资源差分在 `flat-integer-table-build/initial-build.log`，修正后字面验证在该目录的 `build.log`。前者早期的常规 32 位字面断言已作废，当前代码以原加载器的零结果为准。

## 边界

索引越界保留终止行为，但未复制原日志与栈报告。计数表加载只覆盖合法、非溢出资源，不等同完整字典流状态机，也不承诺损坏表、乘积溢出、分配失败或原 ARM 运行等价。

[Direct 词典](direct-token-dictionary.md) 与 [普通 Forward 资源读取](forward-token-dictionary.md) 已真实使用该视图，共用唯一 LoadFlatIntegerTableImage。Forward 的流式帧、多记录区间、评分和有界候选选择仍需继续恢复，不能用表读取替代完整查询验收。
