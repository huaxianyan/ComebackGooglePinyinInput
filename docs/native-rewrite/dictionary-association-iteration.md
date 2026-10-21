# 真实关联组快照

SnapshotDictionaryAssociations 现由六子模型与 SingleTrie 共用，提供原 compact 的记录输入，不修改词典或元数据。下文保留六子模型阶段的证据，[SingleTrie 方向筛选](single-trie-compaction.md) 记录后续恢复。

## 同一组实际组件

- FirstTerminal、NextTerminal 访问 forward trie，保留原 alphabet 顺序和前缀边界。
- ReadTrieValueByNodeId 读取实际关联描述，DecodeAssociationReference 取得同一池范围。
- ReadAssociationRecordAt 读取实际池和固定记录表，按池内顺序推进。
- ReadTerminalKey 从两侧终端 ID 重建原始键字节。
- 成功的当前记录复制六字节 V21 payload，不重新估算词频或解释标志。

结果为拥有两侧键和 payload 的临时快照，后续删除时不再借用正在编辑的表。没有复制 native 对象布局、建立第二个词典或按反向键排序。

## 原失败路径

关联描述读取失败时跳过该 trie 键。六子模型原刷新先读第一记录，next 才检查范围，实现保留此顺序。SingleTrie 则按其原刷新跳过零 count 范围，不把两者合成同一空范围行为。

原固定表读取失败不清除此前的借用记录输出，当前实现保留它。键重建或完整六字节 payload 读取不成功的条目不进入快照，不修复关联计数。

Ghidra 将 `0x1c3c8c` 的 target 参数错误显示为零。ARM64 实际在 `0x1c3ca4` 传栈上目标输出，在 `0x1c3ccc` 重新加载，再调用另一侧 trie 的 slot 10。快照使用记录里的真实目标 ID，不模仿反编译器的常量假象。

## 一条真实输入流程

既有完整镜像流程加载两关联模型，再通过实际双向编辑向第一键追加另一关联。结果必须按以下字面顺序读取：

```text
a → b : 96 00 00 00 01 00
a → a : 01 00 00 00 02 00
b → a : 01 00 00 00 02 00
```

同一键的 `b` 在 `a` 前面，来自实际池中追加顺序，不是对目标键排序。新增模块严格增量编译，并在同一完整镜像端到端流程通过。

已有 ARM64 比较证据直接复用，不重跑旧字节检查。未验收全部损坏记录、OOM 或原 ARM64 执行，也未操作设备和用户词典。

## 下一步

[实体删除与累计](user-dictionary-edit.md) 已接原 payload 查找、双向删除和官方外层计数。两种后端均已接 [用户模型 compact](user-dictionary-compaction.md)。下一步恢复原持久编辑器、模型生命周期和 Android 保存协调。
