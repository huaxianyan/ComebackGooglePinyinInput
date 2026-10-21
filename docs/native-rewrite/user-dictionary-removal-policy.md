# 用户模型删除与保留标记

已将原 `0x1a1a74` 的物理删除、保留删除标记和外层累计处理接入同一用户级入口。支持现有六子模型和 SingleTrie，后续已接 [用户模型计数协调](user-dictionary-learning.md)，accessor 学习键管线、衰减、SingleTrie compact 及原运行时生命周期仍未完成。

## 共用入口

[user_dictionary_edit.h](../../research/native-rewrite/recovered/user_dictionary_edit.h) 的 RemoveUserDictionaryAssociation 由调用方明确提供后端、键、keep_marker 和实际编辑器：

- 六子模型传入 forward、reverse 两个 AssociationEditor。
- SingleTrie 传入一个 SingleTrieAssociationEditor。
- keep_marker 为 false 时走原物理删除，为 true 时保留标记。

两种调用共用读取、V21 解码、标记构造和累计判断，现与学习入口复用同一内部实现。后端仅派发到已经恢复的真实读取、已有更新或物理删除接口，不新增逐方法转发壳。旧物理调用及 compact 显式传入 false，没有隐式兼容入口。

调用方保持模型就绪、独占，并把对应编辑器绑定到同一存储。accessor 锁和原持久编辑器仍在未恢复的上层。

## 原策略

读取原 payload 后，分支按既有 native 行为执行：

| 条件 | 行为 |
| --- | --- |
| 物理删除 | 删除关系，允许原 count 为零 |
| 保留标记且原 count 为零 | 返回失败，保留现有 payload 与累计 |
| 保留标记且原 count 非零 | count 写零，flag31 设 true，flag30、flag27 与 category 保留 |
| 底层修改失败 | 返回失败，不调整外层累计，保留底层原有部分修改 |
| 成功且原 category 不为 2 | 用共用函数从外层累计扣除原 count |
| 成功且原 category 为 2 | 保留外层累计 |

C 反编译将 flag30 参数显示成零，但 ARM64 在 `0x1a1af8` 读取旧 flag30 到 w3，在 `0x1a1b00` 读取旧 flag27 到 w4。编码器参数确认两个 flag 均保留，以寄存器结果为准。

标记日期通过已恢复的 CurrentDictionaryDay 取得，交给同一 V21 codec 编码，保留原截断到十六位的行为。这里不推断 flag27 或 category 的业务含义，也不按剩余关系重算累计。

保留标记不改变内层关联数和固定表行数。标记随后可物理删除，原 count 为零时只移除关系，不再扣除权重。AdjustUserDictionaryTotalCount 仍是累计运算的单一定义点，保持 64 位回绕、负值归零和字段 presence。

## 验证

扩展原有两个实际流程，未新增平行 fixture 或替代后端：

- SingleTrie 在真实已加载关系上写入字面 `07 00 00 58 01 00`。保留标记后前四字节为 `00 00 00 d8`，覆盖 flag31 设置、flag30/flag27/category 保留和 count 归零。
- 外层累计从 `300` 到 `293`，内层关联数保持 `192`。重复标记失败且完整 payload 不变，物理删除该零计数标记后累计仍为 `293`。
- category 2 的非零条目保留标记，前四字节为 `00 00 00 e0`，不扣权重。该类别的物理删除同样保留累计。
- 普通条目物理删除扣除 `11`，最终累计 `282`、当前关联数 `189`、固定表仍为 `197`。保存到第四个独立路径并加载，保留标记的全部六字节及累计成功往返。
- 六子模型原物理删除和类别例外检查继续通过。新增真实关系后保留零计数标记，外层从 `10` 到 `9`，内层关系仍为一，重复标记失败且累计保持。

期待值使用独立字面前缀及计数，日期和 codec 原语沿用已有验证，不再次构建编码算法来计算测试答案。本层调用真实日值，未注入时钟。

接口改造先全源码严格编译一次，两个扩展流程均通过。按 ARM64 修正 flag30 后，仅严格编译实际依赖闭包并执行受影响的 SingleTrie 流程，通过。原六子模型用例的该位为 false，行为相同，不重复执行。

四份 SingleTrie 文件、原六子模型临时文件、对象、archive 和二进制精确清理。生成源码留在构建目录，最终日志为 `work/native-rewrite/user-removal-policy-build/final-policy.log`。完整寄存器依据沿用已有 `single-delete-export.json` 的 learning_store_remove、learning_store_lookup 和 payload_v21_decode。

## 证据与限制

原删除、payload 读取、累计、日值和 V21 codec 已有 native 登记，本轮直接复用，没有重复导出或字节比较，中央仍为 `329` 区域。主要来源为 `0x1a1a74`、`0x1a14b8`、`0x1a0cbc`、`0x1a0ce0` 和 `0x1a0888`。

固定数组 marker 复用现有 codec，不复现原可分配 payload 缓冲的全部 OOM 路径。底层部分失败、原运行时对象、全部分配异常及性能尚未等价验收。未执行原 ARM64，未操作设备、正式包或用户词典。

复现沿用 [共用完整构建](mutable-dictionary-image.md#验证)，测试名仍为 `single_trie_association` 和 `mutable_dictionary_image`。用户模型计数协调现已恢复，下一步接 SingleTrie compact 与生命周期，accessor 学习键管线仍待接入。
