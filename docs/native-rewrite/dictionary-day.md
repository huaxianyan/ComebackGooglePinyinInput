# 原生日期来源与整理包装

DictionaryDayFromUnixSeconds 恢复 `0x1a0ce0` 的有符号 `seconds / 86400`。CurrentDictionaryDay 通过真实 `time(nullptr)` 读取系统墙钟，没有占位时间或测试时钟替换。

原 import 已在此前匹配为 `time`，不是单调时钟，也不是本地日历。即使 time 返回 `-1`，原除法也截断为 `0`，恢复保留该结果，不添加新回退策略。

DictionaryCompactionCutoff 恢复 `0x1a39d8` 的 32 位减 `62`，通过 unsigned 位运算和位复制保留 ARM64 回绕，避免 C++ signed overflow。年龄常量只有一个定义点。

CompactUserDictionary 现在接真实日期、原 cutoff 和同一 AtCutoff 内部入口。AtCutoff 是已恢复的原内部函数，不是替代默认路径的假时钟接口。

## 一条实际时钟流程

同一完整镜像端到端流程先验证字面 cutoff 下的日期优先选择，再把重新加载的剩余 Unix-day-2 历史条目交给真实时钟入口。它实际过期并删除，完整保存和重新加载后内外计数均为 `0`。

模块字面输入输出另验证 `0`、`86399`、`86400`、`172800`、time 失败值 `-1`，以及 day `63`、`62`、`0` 的 cutoff。没有用生产常量或算法计算断言期望值。

新日期模块与改变的组合模块增量编译，模块测试和同一端到端流程通过。未再次全量构建或重证旧 native 区间。

## 证据与边界

- `docs/native-rewrite/native-learning-update.md` 的原日期与 import 结论。
- `work/native-rewrite/ghidra/initial-functions/002a0ce0.c`。
- `work/native-rewrite/original-apk/native-learning-clock-import.json`。
- `work/native-rewrite/restart-v217/native-learning-storage-comparison.json`。
- 整理包装沿用 `work/native-rewrite/restart-v217/native-duplicate-compact-comparison.json`。

日期不代表外层 last_sync_time 的单位。V21 日期的低 16 位回绕、完整学习衰减和全部异常时钟仍未验收。JNI/accessor 锁与 Android 保存任务也未接，未操作设备或系统时间设置。
