# 默认 legacy 类型与空输入初始化

本阶段确定默认可变词典的具体模型和加载失败后的初始化分支，修正研究覆盖范围。只更新取证与导出登记，正式输入法、设备和用户数据均未操作。

## 数据类型实际对应 SingleTrie

legacy 表初始化 `0x19a5f0` 明确登记：

| 数据类型 | 注册名 |
| --- | --- |
| 2、3 | DoubleTrieUserDictionary |
| 23、24 | SingleTrieUserDictionary |

原 Java 默认可变词典使用 `24、24、23、24`，所以都选 SingleTrieUserDictionary，而非根据「双向关系」等业务描述猜 DoubleTrie。

静态注册函数 `0x79d9c` 将 SingleTrieUserDictionary 绑定到工厂回调 `0x137f08`，同名别名也明确登记。回调分配实例后，经 GOT `0x699310` 取得其虚表。地址点 `0x67afc0` 的 slot 2 为 `0x1a3e04`，slot 23 为 `0x1a2544`。

slot 23 返回 SingleTrieMutableDictionary。静态注册同时将该底层模型绑定到 `0x1a0b10`，不能只换一个模型名就把现有六子模型接到默认路径上。

## 外层词典确实有初始化回退

SingleTrie 与 DoubleTrie 共用外层内存入口 `0x1a3e04`：

1. 先调用已有取证 `0x1a3c9c`，尝试加载并接收完整镜像。
2. 成功则转交原返回值。
3. 失败则构造初始化选项，尝试解析调用方传入的选项。入口未以该解析返回值阻止后续初始化。
4. 选项中的 token category 未设置时，记录使用默认值，然后调用 `0x1a259c` 初始化。
5. 初始化成功时取得虚表 `+0x28` 的返回载荷，失败时载荷为零。两种情况都将外层返回的成功标记置真。

已有 `0x1a3c9c` 对空 MemoryChunk 返回错误；非空镜像的底层校验失败也返回错误。因此回退不限于空输入，不能恢复成「所有坏镜像都保留旧模型」，也不能把成功标记解释为初始化已经完整成功。

[注册与创建取证](model-creator-enrollment.md) 中的 Java 空注册，以及通用创建器按成功标记保留或销毁对象，分别属于不同层。具体 UserDictionary 封装改变了失败后的处理，须保留这条真实分支。

## SingleTrieMutableDictionary 的接入位置

原初始化 `0x1a259c` 通过模型类型名调用 `0x1a4e54` 创建底层模型，并设置六字节 payload 等原参数。这里只沿用已确认的初始化取证，不重新导出或重证它。

另已定位底层内存读取链：

```text
0x1c8190：调用 legacy 内存入口，包装返回载荷和成功标记
  → 0x1cb124：将内部失败结果转为零载荷
  → 0x1cb034：局部接收元数据及后端，成功后替换实例
  → 0x1ca7f8：具体底层解析
```

`0x1cb034` 保留局部候选发布，与外层 UserDictionary 初始化回退分开。它们不能合并成一个「加载失败保留旧对象」规则。

下一步从 `0x1a4e54` 的真实创建、初始化调用继续恢复 SingleTrieMutableDictionary，并追具体解析器 `0x1ca7f8`，而不是再扩展六子模型来假装覆盖默认词典。

## 已恢复范围的修正

[完整宿主镜像](user-dictionary-image.md) 目前组合的是 MutableDictionary 六子模型。其字节、编辑、映射、保存与恢复测试继续有效，但尚未覆盖默认路径选中的 SingleTrieMutableDictionary。

外层文件头、元数据、属性选择及已确认的公共 primitive 可继续复用。底层布局和编辑语义须依据 SingleTrie 实现恢复，不据类名推断兼容，也不删除已验证的另一后端。

## 验证与证据

新增九段 native 对照：七段与保留发布库逐字节一致，中央清单增至 `312` 区域。另两段仅有数据页 ADRP 差异，目标在 `.data` 或 `.bss` 中的节内偏移一致，未加入字节一致清单。SingleTrieUserDictionary 的 GOT 与虚表绑定也与保留发布库一致。

- `work/native-rewrite/ghidra/legacy-model-type-table/`
- `work/native-rewrite/ghidra/legacy-single-trie-init/`
- `work/native-rewrite/ghidra/legacy-single-trie-concrete/`
- `work/native-rewrite/ghidra/legacy-single-trie-empty-dispatch/`
- `work/native-rewrite/ghidra/legacy-single-trie-chunk-branch/`
- `work/native-rewrite/restart-v217/native-legacy-single-trie-init-comparison.json`
- `work/native-rewrite/restart-v217/legacy-single-trie-init-export.json`

真实 APK 导出核对七个新区域及独立 FDE 端点。未修改 C++ 运行实现，未重跑旧构建，未执行原 ARM64，宿主通过仍不代表默认 Android 词典或完整输入法已验收。
