# 下层编辑器获取与驻留搬迁回调

本阶段补齐原 SingleTrie 下层 editor、kind 零游标的获取与释放契约，并把节点搬迁回调从单次修改局部状态改为现有编辑器持有。没有新增转发句柄、假就绪字段或空工厂。

## 获取入口不是插入入口

中央清单原名 trie_editor_create 的 `0x1dec04` 实际为 VariableValueLengthTrie::EditorImpl 的 slot 0 插入操作，现更名为 trie_editor_insert，地址和既有指令证据不变。

真实的 VariableValueLengthTrie slot 15 为 `0x1de7e4`，不能凭标签或函数排列把编辑操作当作工厂。原获取链为：

```text
SingleTrie slot 19：0x1c9860
  VariableValueLengthTrie slot 15：0x1de7e4
    DATrie slot 15：0x1d45b0
    DATrie slot 7(kind=0)：0x1d4b28
    两者均非空 → 0x1de788 构造 VariableValueLengthTrie 编辑器
  VariableValueLengthTrie slot 7(kind=0)：0x1de6b8
    DATrie slot 7(kind=0)：0x1d4b28
    非空 → 0x1de64c 构造值解析游标包装
  两个外层对象均非空 → 0x1c9700 构造 SingleTrie 编辑器
```

各层先检查自身 `+8` 就绪字节。需要两个对象的入口即使先取 editor 返回空，仍继续取得游标，再一起判空。失败释放已经取得的局部对象，保留空结果，不改成短路获取或发布部分编辑器。

`0x1de6b8` 的 C 反编译未列出 kind 参数，ARM64 则在调用底层 slot 7 前保留 w1，实际继续转交它。DATrie `0x1d4b28` 只处理 kind 零和一：零调用 `0x1d4ad8`，安装 `0x67d280` 虚表，RTTI 确认为 ExactMatchIterator；一才是原 PrefixMatchIterator。后续不能用前缀推进代替 kind 零游标。

## 拥有关系与释放

`0x1de788` 持有 VariableValueLengthTrie 父对象、下层 editor、下层 kind 零游标及四字节引用缓冲。`0x1de64c` 持有父对象、底层游标和独立值视图对象。DATrie 编辑器由 `0x1d45b0` 建立，直接保存同一 DATrie 父对象。

两个局部持有槽的释放协议不同：

- `0x1c59d0` 先取出并清零自己的指针，再调用 editor slot 3。
- `0x186bc0` 同样先清零自己的指针，但调用游标 slot 10。
- VariableValueLengthTrie 编辑器的 slot 3 是 `0x1de294`，继续分派 slot 5 的 `0x1de768`。后者先执行已恢复取证的 `0x1de734` 析构，再释放对象内存。

不能统一假定 slot 0/1 是析构，或跳过释放协议直接删父对象。游标 slot 10 的实际删除体和全部底层释放分支仍未恢复为宿主对象，当前只确认虚表绑定和调用拓扑。

## 驻留回调接入

原 `0x1c9700` 在编辑器构造时安装 `0x1c8928` 回调，不是在每次修改中临时构造。现有 SingleTrieAssociationEditor 新增同一个长期持有的 node_moved：

- 构造时绑定稳定的实际 storage 地址，而不是捕获某次调用的局部 DATrieView。
- 调用时从当前元数据和节点重新建立 live view，再复用唯一的 RepairMoved 记录修复逻辑。
- 普通关联插入和下层直接插入均通过原 notify 参数使用它，不另建一套节点 ID 修补。
- 成员顺序保证三块缓冲先释放，再释放回调，最后由拥有模型释放 storage。

回调继续保留原 void 失败语义，不把读取或修补失败变成事务回滚，也不重解先前保存的局部端点 ID。

## 验证与证据

在原完整 SingleTrie 流程中，96 组真实自关联/有向关系建立后，插入 64 个带字面空范围值的实际下层 trie 键。直接插入使用同一个编辑器持有的回调，不经过 ModifySingleTrieAssociation。记录前后关联端点 ID，确认至少一个实际搬迁，再逐条验证独立字面 payload。

初版测试错误地要求特定根端点 a 必须移动；DATrie 可选择移动另一端点。按实际协议改为检测既有关联端点集合中的搬迁，不限制内部碰撞选择。未扩增输入或改生产算法，原记录、保留模型、保存重载及拥有模型替换流程全部通过。

全源码严格编译一次；修正该测试条件后只重编同一测试并执行，未重复构建源码或重跑六子模型。七份文件及失败轮次的自建临时文件精确清理，对象、archive 和二进制清理，生成源码和日志留存于 `work/native-rewrite/editor-callback-build/`，最终日志为 final.log。

十段新增 FDE 区域与原始 APK、保留 v2.1.7 发布库字节一致，中央增至 `347` 区域。旧插入、修改、删除、SingleTrie 构造和搬迁修复证据直接复用，没有因改名再比较一次。

- 新获取链：`work/native-rewrite/ghidra/editor-acquisition/`、`editor-acquisition-constructors/`
- 新字节比较：`work/native-rewrite/restart-v217/native-editor-acquisition-comparison.json`
- 中央导出：`work/native-rewrite/restart-v217/editor-acquisition-export.json`

## 边界与下一步

宿主现已持有并实际使用驻留回调，但没有复刻原回调对象 ABI、虚句柄、引用计数或自动工厂。后续已恢复 [kind 零状态与实际读值](trie-exact-match-cursor.md)，两种后端持有实际读取游标。[写编辑器内部游标与引用缓冲](trie-value-editor-state.md) 也已接入，下层获取失败与完整释放仍待恢复，不以返回非空的包装壳补齐。

未覆盖全部 OOM、并发、释放中间失败或原 ARM64 执行。未操作设备、正式包或用户词典。下一步恢复实际下层对象获取与释放，继续保留非短路获取顺序，再接模型锁和 accessor 生命周期。
