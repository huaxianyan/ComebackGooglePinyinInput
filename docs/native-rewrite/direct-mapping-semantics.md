# Reconversion 离线语义分析

## 范围

本轮将 [native 查找、迭代和默认分数公式](direct-mapping-native.md) 应用于固定原始 APK 的四个 reconversion blob，恢复可枚举的 source-to-target 关系。

这是基于静态指令建立的研究模型，不是 native 执行结果。模型只枚举索引接受的低 21 位 source 值，不模拟迭代器的输入类型过滤、metadata 门控和原输入回退，也不代表最终候选排序。

英文两份 blob 相同，不能把它们当成两个独立格式样本。完整映射只输出到被忽略的 `work/`，不提交或作为未来可分发词典。

## 可复现入口

复用 `research/native-rewrite/tools/extract_data_bundles.py` 的现有 APK 导出入口，不新增第二套容器 parser：

```text
PYTHONPATH=tools/python python research/native-rewrite/tools/extract_data_bundles.py \
  --apk original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk \
  --output-dir work/native-rewrite/original-apk/data-bundles \
  --manifest work/native-rewrite/original-apk/data-bundle-manifest.json
```

DirectMapping 的 `native_container.lookup_analysis` 新增：

- source 和 target 数量
- 每个 source 的目标数量分布
- 基础位置、间接入口和实际目标位置的覆盖统计
- 分离数量用途后的 score code 分布
- 按原生存储顺序排列的逐 source 记录

每条记录保留 `source_key_id`、基础位置、解析后的目标起点，以及完整 target token ID、score code 和研究模型计算的 float32 分数。source key ID 与完整 token ID 是不同字段，不混用。

## 枚举结果

| blob | source 数 | target 总数 | 不同 target ID 数 | 间接入口数 |
| --- | ---: | ---: | ---: | ---: |
| `en_reconversion_expansion` | 52 | 52 | 26 | 0 |
| `english_reconversion_expansion` | 52 | 52 | 26 | 0 |
| `digits_reconversion_expansion` | 10 | 10 | 10 | 0 |
| `pinyin_reconversion_expansion` | 25,379 | 26,578 | 421 | 1,123 |

拼音 source 数是接受的 key 值数量，不等于汉字数量。原数据还包含符号等来源，不能把表中 25,379 直接宣传为汉字覆盖量。

英文 source 正好覆盖 ASCII `A`–`Z` 与 `a`–`z`，两段分别映射到同一组 26 个 target ID。数字覆盖 `0`–`9`。英文 target 的原始值可恢复，但尚未将其对齐到仍未拆解的 `DirectTokenDictionary`。

### 拼音的连续目标数量

| 每个 source 的目标数 | source 数 |
| ---: | ---: |
| 1 | 24,256 |
| 2 | 1,056 |
| 3 | 58 |
| 4 | 9 |

1,123 个间接入口对应 2,322 个尾部目标元素。加上 24,256 个直接目标，总计 26,578 个实际目标。原数组包含的另外 1,123 个 word 是间接入口本身，不是额外 token。

所有 27,701 个原始 word 都被基础位置或实际目标位置引用。数量 byte 所在位置与实际 score byte 所在位置没有重叠，支持对这两类用途分别统计，而不是对全部原始 byte 统一换算分数。

## Target 身份精确对齐

拼音的 421 个不同 target ID 均能直接匹配 `pinyin_token_v_2` 的完整 token ID，数字的 10 个 target ID 也全部匹配数字 token dictionary。匹配时没有清除标志位、截断低位或更换编码。

这里的完整 ID 匹配只应用于实际目标。间接入口已经由 native 规则转成位置和数量，不进入 token dictionary 查找。

工具在 bundle 内复用既有 token dictionary 索引建立 `token_reference`，并把匹配到的 key 写入目标记录。尚未匹配的值会保留原始 ID 和未解析清单，不用猜测性字符串替代。

### 不能用 token code 替换 token ID

原始 source `一` 的 target 为 `0x0080e183`，完整 token ID 匹配到 `yi`。若截取低位后错误地按 token code `0xe183` 查找，则会得到另一个 key `fuai`。

因此，数值落入相似范围或「能查到某个 key」都不是身份对齐成功的证据。本轮使用的是整个 token ID 相等，而不是低位范围相似。

## 分数和顺序

拼音实际目标使用 138 种 score code，范围为 `0`–`167`，其中 24,653 个目标位置的 code 为零。所有分数按已确认的默认 float32 查找表公式计算，不把数量 byte 当作 score code。

以下是固定原始数据中的小型研究样本，不来自用户词典：

| source | 按存储顺序枚举的 key | score code | 离线 float32 分数 |
| --- | --- | ---: | ---: |
| `一` | `yi` | 0 | `-0.0` |
| `中` | `zhong` | 0 | `-0.0` |
| `重` | `chong` | 11 | `-0.8627451062202454` |
| `重` | `zhong` | 7 | `-0.5490196347236633` |
| `行` | `hang` | 32 | `-2.5098040103912354` |
| `行` | `xing` | 1 | `-0.0784313753247261` |

这些目标按原数组顺序枚举，没有额外排序。例如 `重` 的 `chong` 先于 `zhong`，但分数并非从高到低排列。因此，枚举顺序不是最终候选优先级。上层如何组合此分数与其他引擎分数仍未知。

## 验证

沿用一个真实 APK 导出端到端测试，增加有明确输入输出的模块测试：

```text
PYTHONPATH=tools/python python -m unittest discover \
  -s research/native-rewrite/tests -p test_direct_mapping_export.py -v
```

覆盖范围：

- 四个原始 blob 的字节区间与枚举输出
- 英文范围、区间空洞及 native 低 21 位掩码
- 数量 byte 与目标 score code 的分离
- 固定数据样本的 token ID、key、code 和 float32 结果
- 拼音目标数量分布、完整 word 覆盖与精确 token ID 匹配

测试使用固定字节、固定输入和预先记录的期望值，不在断言中调用被测算法计算答案。原始 APK 导出产生的临时文件位于项目 `work/`，测试结束自动清理。

本轮没有 native 执行对照。因此，测试通过表示离线工具按已恢复模型稳定输出结果，不是独立证明模型与原生运行时完全等价。

## 未验证边界

- 输入类型过滤与 metadata 各字段的业务含义
- lookup 未找到后的上层回退和 composing 行为
- 英文 target 到 DirectTokenDictionary 的完整身份对齐
- 默认 float32 计算与实际 native 执行结果的逐位对照
- reconversion 分数在最终候选排序中的权重

后续工作入口继续统一在 [native 查找研究](direct-mapping-native.md#验证与限制)。
