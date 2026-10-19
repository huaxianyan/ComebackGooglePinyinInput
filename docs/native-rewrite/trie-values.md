# trie 值记录与四字节引用

## 恢复范围

`VariableValueLengthTrie` 的当前 Builder 分支把实际值存入 `FixedPhraseTable`，底层 trie 只保存四字节记录偏移。已恢复这层值追加与原位更新：

- `research/native-rewrite/recovered/trie_values.h`
- `research/native-rewrite/recovered/trie_values.cc`
- `research/native-rewrite/tests/trie_values_test.cc`

源码复用既有 `FixedPhraseTable`、`OwnedByteRegion` 与小端读写。它没有新增存储后端或第二份所有权实现，也不包含 DATrie 键遍历、节点插入、节点删除或完整 trie 编辑器。

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

slot 4 不是键删除，不能仅凭函数在虚表中的位置推断操作。slot 2 的尾调用保留键参数，当前入口没有同步回收值表记录。完整 DATrie 删除尚未恢复，这份静态连接不作为键删除执行验收。

`0x1c5e64` 检查可选 payload 长度后，分别调用两侧读取对象 `+0x68`。VariableValueLengthTrie 的对应入口 `0x1de3a8` 在就绪后继续委托底层读取对象。当前证据支持将此路径称为长度与键准入检查，不再把它命名为「参数规范化」。严格字节准入、已有路径查找与终端更新已有源码，见 [DATrie 借用视图](datrie-view.md)。节点增删仍待恢复。

## 验证

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

Google 派生逻辑继续按 `NOTICE` 保留权利边界。DATrie 节点扩容与空闲 base 选择已有源码。下一步恢复节点归还、子节点枚举与冲突搬迁，再接通节点插入、删除及双向关联写回。
