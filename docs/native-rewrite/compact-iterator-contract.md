# compact 记录遍历契约

本阶段只恢复调用契约和游标推进证据，尚未实现替代迭代器。已通过的复制、文件流与选择计划没有重跑。

## 已确认的调用链

```text
UserDictionary 0x1a1448
  MutableDictionary slot 10 / +0x50 → 0x1c4888
    forward trie → 0x1d1c34 → trie slot 7 / +0x38
    MutableDictionary::KeyIteratorImpl<DFSIteratorBase>
```

`0x1c4888` 使用同一组 forward trie、reverse trie、记录表和池创建当前迭代器。没有新建词条集合，也不按词文本重新排序。

`0x1a0f74` 保存模型与原迭代器指针，初始化 payload 缓冲，然后通过 slot 0 用空前缀初始化原迭代器。`0x1a0fb8` 通过 slot 9 判断结束，`0x1a0fdc` 通过 slot 10 推进。

原可变词典迭代器对应入口：

| 动作 | slot | 原地址 |
| --- | --- | --- |
| 初始化 | 0 | `0x1c620c` |
| 读取第一侧键 | 3 | `0x1c3964` |
| 读取第二侧键 | 4 | `0x1c3c8c` |
| 读取 payload | 5 | `0x1c4e88`，尚未单独导出 |
| 判断结束 | 9 | `0x1c386c` |
| 推进 | 10 | `0x1c6190` |

这些 slot 由实际虚表与包装函数共同确认，不按方法地址相邻顺序猜接口。`0x1c4b3c` 属于另一个读取分支，不是 next，不能因为它含记录操作就当作推进。

## 关联内顺序与跨键推进

`0x1c6190` 先推进当前关联索引。索引仍在当前范围内时，通过已有 `0x1c3ac8` 读取池中的下一记录；走完范围后才推进底层 trie，再调用 `0x1c60e0` 重新取得下一组关联。

因此恢复不能用「把词条全部按键排序」代替原遍历。池内顺序与 trie 访问顺序共同决定堆中相等项的置换，也决定后续删除顺序。

底层 DATrie 初始化 `0x1d6d94` 使用键长和节点构成的帧栈，并按动态类型继续定位。当前已经定位实际前缀游标，尚未完成替代实现。

## 实际前缀游标与键刷新

kind 1 经 VariableValueLengthTrie 的 `0x1de6b8` 委托 DATrie。`0x1d4b00` 构造的实际类型是 PrefixMatchIterator，不能用 ExactMatchIterator 的 next 代替：后者 `0x1d4308` 只将当前结果清零，前者使用 `0x1d61b4`。

前缀推进调用链为 `0x1d61b4` → `0x1d60e4` → `0x1d5ee0`。末层先定位前缀路径，验证当前终端，再沿父链确定访问边界。后续兄弟选择使用元数据中的 alphabet 顺序及其反向索引，不按码点或节点编号排序。找到兄弟后委托 `0x1d5bc8` 向下取得终端，越过前缀边界时结束。

`0x1c60e0` 是关联组刷新入口。它跳过无法读取或解码关联描述的 trie 键，再发布池范围和第一记录。payload 读取 `0x1c4e88` 复用原记录读取，正文从记录偏移 4 开始，不新建第二套记录编码。

键文本重建已恢复为 DATrieView::ReadTerminalKey，下降帮助函数仍待接入游标。已确认的排序来源和帧边界留给实际实现复用。

## 模型报告数量

`0x1a02ec` 在模型就绪时委托内层 size。内层 `0x1c37a0` 从同一个内部元数据对象读取偏移 `+0x34` 的 int32 关联计数，并符号扩展到 long。

它不是外层权重总数，也不是遍历成功条目数。选择计划已经把模型报告数量独立作为输入。后续控制器应保留原位宽与比较路径，不根据 vector 长度补写元数据。

## 证据与下一步

- `work/native-rewrite/ghidra/compact-iterator-entry/`
- `work/native-rewrite/ghidra/compact-iterator-step/`
- `work/native-rewrite/ghidra/compact-iterator-interface/`
- `work/native-rewrite/ghidra/compact-iterator-navigation/`
- 原虚表：`work/native-rewrite/original-apk/cpp-types.json`
- 字节比较：`work/native-rewrite/restart-v217/native-compact-iterator-comparison.json`

本阶段 19 段新函数与保留发布库一致，另一个已验证区域直接复用。中央导出清单只登记四个关键迭代入口，累计 264 个区域；其余研究函数保存在上述专项证据，没有重跑已有全量静态检查。

前缀游标与键刷新新增 13 段函数也与发布库一致，证据在 `native-prefix-cursor-comparison.json`。Source 导出目录为 `compact-dfs-navigation/`、`compact-variable-iterator/`、`compact-prefix-iterator/`、`compact-prefix-step/` 和 `compact-next-terminal/`。

## 终端键文本已恢复

`0x1d4234` 委托 DATrie slot 10 的 `0x1d6af0` 重建键。ReadTerminalKey 先确认实际终端，再清空输出，从终端父节点向根移动。每步追加 `node - base(parent)` 的低八位，最后反转字节，不做文本规范化或重新编码。

既有 DATrie 镜像流程添加此真实入口检查：初始化、加载、插入两字节键、保存并重新加载后，从终端恢复字面 `ab` 和原值，通过。只增量编译 datrie_view.cc 并运行受影响流程。

下降函数 `0x1d5bc8` 的源码已取得：跳过已有终端和空闲节点，按 alphabet 递归下降，零边直接返回终端，根的空键不作为结果。尚未将它和 successor 接入模型，未以普通 DFS 冒充完成。

三段新函数与发布库一致，证据在 `native-terminal-key-comparison.json`。中央导出只登记重建键入口，累计 265 个区域。下一步补齐下降、successor 及关联组遍历，原记录读取继续复用 association 模块。未执行 ARM64 或设备测试。
