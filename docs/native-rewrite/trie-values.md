# trie 值记录与四字节引用

## 恢复范围

`VariableValueLengthTrie` 的当前 Builder 分支把实际值存入 `FixedPhraseTable`，底层 trie 只保存四字节记录偏移。已恢复值追加、原位更新及固定表编辑器协调：

- `research/native-rewrite/recovered/trie_values.h`
- `research/native-rewrite/recovered/trie_values.cc`
- `research/native-rewrite/recovered/trie_value_editor.cc`
- `research/native-rewrite/tests/trie_values_test.cc`
- `research/native-rewrite/tests/trie_value_editor_test.cc`

源码复用既有 `FixedPhraseTable`、`OwnedByteRegion` 与小端读写。固定表编辑器复用已有 DATrie 键插入，没有新增存储后端或第二份所有权实现。完整双向关联协调和文件编辑事务仍未完成。键删除见 [DATrie 键编辑](datrie-relocation.md#键删除)。

## 后端与引用格式

Builder `0x1bfbfc` 在配置宽度非负的分支调用 `0x1f2f70` 构造定长表，逐项追加实际值，再把返回 ID 收窄为四字节值交给底层 trie Builder。`0x1de900` 将底层 trie 与该表组装为 `VariableValueLengthTrie`。

这里的四字节值是小端、无符号的表内字节偏移，不是记录序号，也不是 [关联引用](association-records.md) 的 23 位索引与 9 位数量组合。六字节值连续追加时，引用依次为：

```text
00 00 00 00
06 00 00 00
0c 00 00 00
```

零偏移有效。记录后端原返回 64 位 ID，此处沿原指令只写低 32 位。本轮不扩展寻址上界，也不推断其他构造分支、零宽度或极端整数的完整兼容性。

## 值追加与更新

`AppendTrieValue` 对应 `0x1deb4c`：先通过存储 `+0x58` 追加正文，再将输出区域调整到四字节，取得写指针并写入偏移。发布引用失败时，先前追加的正文仍保留。输出已是四字节时也必须取得可写访问，以保留共享句柄的复制语义。

`UpdateTrieValue` 对应 `0x1deca0`：引用长度必须恰为四字节，解码偏移后经存储 `+0x50` 取得可写记录，再要求输入长度与记录宽度完全相同，最后覆盖正文。没有调整正文长度，也不追加新记录。取得写视图可能先发生所有权复制，长度不符不等于完全没有分配行为。

原路径发布引用时未检查空写指针，恢复入口对已识别的空结果返回 false，保留此前追加。完整内存耗尽与描述符异常等价仍未验收。输入字节须在写访问期间有效，沿用原复制函数的重叠限制，没有新增自行重叠更新契约。

## 编辑器槽位与键准入

`VariableValueLengthTrie::EditorImpl` 虚表位于 `0x67dcf0`：

| 槽 | 地址 | 已确认的职责 |
| --- | --- | --- |
| 0 | `0x1dec04` | 先调用本对象 slot 1，失败后追加值记录，再调用底层编辑器插入 |
| 1 | `0x1ded68` | 经遍历器定位已有键，取四字节引用，再更新正文 |
| 2 | `0x1de270` | 尾调用底层编辑器 `+0x10` |
| 4 | `0x1de734` | 对象析构，释放区域、遍历器和底层编辑器 |
| 5 | `0x1de768` | 删除式析构 |

slot 4 不是键删除，不能仅凭函数在虚表中的位置推断操作。slot 2 的尾调用保留键参数，当前入口没有同步回收值表记录。底层 DATrie 键删除已有源码和宿主整合，这份静态槽位连接仍不代表完整双向删除验收。

`0x1c5e64` 检查可选 payload 长度后，分别调用两侧读取对象 `+0x68`。VariableValueLengthTrie 的对应入口 `0x1de3a8` 在就绪后继续委托底层读取对象。当前证据支持将此路径称为长度与键准入检查，不再把它命名为「参数规范化」。严格字节准入、已有路径查找与终端更新已有源码，见 [DATrie 借用视图](datrie-view.md)。完整字节键插入和键删除已有源码，双向编辑器尚待整合。

## 固定值表编辑协调

`InsertTrieValue` 对应 slot 0 的完整顺序，先定位已有终端并尝试更新正文。只有更新成功才直接返回，否则继续追加值记录，再将四字节引用交给 DATrie 插入。即使已有值更新失败，也不提前替换为另一种返回策略。

新建键时，底层插入会发布可选终端 ID。已有值更新直接返回，保留调用方 ID 输出原值，不额外补写 ID。原调用方通常先查已有项，因此不能假设这两个分支有相同的输出副作用。

正文追加早于底层严格准入。直接调用该层并传入未准入字节时，会保留已追加的记录。正常双向编辑器另有外层检查，不能将这个直接入口的失败样本称为用户正常输入路径。

终端定位由 `FindTerminal` 共用，原终端更新和此协调入口不维护第二份查找逻辑。四字节引用发布由 `WriteTrieValueReference` 共用，保留可写访问与共享区域复制语义。

### 协调整合验证

```bash
mkdir -p work/native-rewrite/recovered-datrie-deletion
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/fixed_phrase_table.cc \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/recovered/association_list.cc \
  research/native-rewrite/recovered/datrie_view.cc \
  research/native-rewrite/recovered/datrie_relocation.cc \
  research/native-rewrite/recovered/datrie_insertion.cc \
  research/native-rewrite/recovered/datrie_deletion.cc \
  research/native-rewrite/recovered/trie_values.cc \
  research/native-rewrite/recovered/trie_value_lookup.cc \
  research/native-rewrite/recovered/trie_value_editor.cc \
  research/native-rewrite/tests/trie_value_editor_test.cc \
  -o work/native-rewrite/recovered-datrie-deletion/datrie_deletion_test
work/native-rewrite/recovered-datrie-deletion/datrie_deletion_test
```

严格构建和真实组件流程通过：初始化后为 `a` 建立终端 `2`，再通过真实追加入口建立两条关联。编辑器原位发布范围，按终端读回字面引用 `02 04 00 00`，经真实索引池取得偏移 `0`、`10` 的记录和完整负载。值表仍是一条，DATrie 键数仍为一。

已有项更新保留 ID 输出哨兵。直接传入未准入的 `z` 时，追加的第二条值记录保留，键数和 ID 输出不变。未使用故障注入或备用后端，期望引用及记录都是独立字面值。

APK 出口增加更新成功短路、ID 参数传递、底层插入和原位更新尾调用锚点后通过。值编辑阶段沿用 184 个区域，加入键删除后总数为 186。两个编辑器区域与发布库字节一致，指令与对照见 `work/native-rewrite/original-apk/native-trie-value-editor.txt` 及对应 comparison JSON。现有 Ghidra 批次 `trie-key-value-edit/` 继续复用。

该流程接通单侧关联建立与引用发布，并扩展为真实键删除验证。删除前缀词后子词值和旧共享图像保留，删除最后的子词会回收路径而保留值表记录，再插入可复用空闲终端。细节见 [键删除](datrie-relocation.md#键删除)。

`MutableDictionaryEditor` 的双向事务、标志、CRC 与删除回退仍待接通。原生遍历器对象和复用临时区域已改为类型化查找与局部区域，分配故障不承诺逐步等价。

## 值记录组件验证

使用既有 WSL C++17 工具链：

```bash
mkdir -p work/native-rewrite/recovered-trie-values
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/fixed_phrase_table.cc \
  research/native-rewrite/recovered/trie_values.cc \
  research/native-rewrite/tests/trie_values_test.cc \
  -o work/native-rewrite/recovered-trie-values/trie_values_test
work/native-rewrite/recovered-trie-values/trie_values_test
```

严格构建与一条真实组件流程通过：三次追加的字面引用、共享旧引用保留、通过引用更新第二条记录、正文数量保持三条、首条内容保留。三字节引用失败的断言来自冻结的四字节格式，不是任意增加的防御分支。

真实 APK 出口补入长度、低 32 位写出、先追加后发布及更新长度匹配锚点后通过。新增九个区域与发布库指令字节一致。没有执行原 ARM64 值后端或操作设备、用户词典，也没有以 host 结果宣称完整 trie 等价。

取证保留于：

- `work/native-rewrite/ghidra/trie-key-value-edit/`
- `work/native-rewrite/ghidra/trie-value-codec/`
- `work/native-rewrite/ghidra/trie-value-builder/`
- `work/native-rewrite/original-apk/native-trie-values.txt`
- `work/native-rewrite/restart-v217/native-trie-values-comparison.json`

Google 派生逻辑继续按 `NOTICE` 保留权利边界。DATrie 初始化、节点扩容、归还、子节点枚举与空闲 base 选择已有源码。按终端 ID 读取与真实迁移通知接收者见 [节点迁移通知](node-id-updater.md)。冲突搬迁已接通真实通知。固定值表的追加与更新已接到完整字节键插入，并通过单侧关联发布流程。底层键删除已有源码，下一步接入完整双向关联协调及其删除回退。
