# 定长记录存储源码

## 范围与归属

已恢复 `FixedPhraseTable` 的堆内存后端，覆盖初始化、定长追加、只读记录、可写记录、数量读取和整表清空。源码为 [fixed_phrase_table.h](../../research/native-rewrite/recovered/fixed_phrase_table.h) 与 [fixed_phrase_table.cc](../../research/native-rewrite/recovered/fixed_phrase_table.cc)。

`MutableDictionaryBuilder` 的 `0x1a6a2c` 调用 `0x1f2f70` 创建后端。构造函数安装的虚表地址为 `0x67e0e0`，RTTI 名称为 `i18n_input::engine::FixedPhraseTable`。已确认的槽位如下：

| 虚表字节偏移 | 原函数 | 能力 |
| --- | --- | --- |
| `+0x18` | `0x1f2c8c` | 初始化 |
| `+0x38` | `0x1f2cb4` | 已追加记录数量 |
| `+0x40` | `0x1f2ccc` | 就绪状态 |
| `+0x48` | `0x1f2d90` | 只读记录视图 |
| `+0x50` | `0x1f2e20` | 可写记录视图 |
| `+0x58` | `0x1f3178` | 追加记录并返回 ID |
| `+0x60` | `0x1f2eb0` | 清空整表 |

这些槽位对应 [关联记录](association-records.md) 已定位的读取、修改与追加调用。源码使用现有 `OwnedByteRegion` 管理字节，不复制旧对象 ABI，也不以另一种词典引擎替代该后端。

## ID、数量与容量

记录 ID 是表内字节偏移，不是记录序号，也不是整个词典文件的偏移。十字节记录连续追加时，ID 为 `0`、`10`、`20`，首条记录的零 ID 有效。

读取同时要求表已就绪、ID 按记录宽度对齐，以及整条记录位于已使用字节内。实际分配容量可以比已使用字节更多，不能据容量允许读取尾部空间。

原对象分别保留：

- `+0x0c`：32 位已追加记录数量
- `+0x10`：固定记录字节宽度
- `+0x18`：缓冲区所有权
- `+0x20`：64 位已使用字节数

记录数量与已使用字节数不是同一个字段。此处的数量也不是词典学习权重或索引池活动单元数量。

追加返回 64 位偏移，现有索引池只保留 31 位记录 ID。跨格式上界与极端整数行为仍待验收，本轮没有扩大可寻址范围。

## 追加与编辑

`0x1f3178` 要求非空输入及精确记录宽度。`0x1f30ec` 在容量不足时选择「当前容量乘 1.25 后截断」与「新记录结束位置」的较大值，再调用精确调整大小入口。

原指令为 `UCVTF` 和 `FCVTZU`，使用无符号大小转换。Ghidra 的 C 视图将其写成有符号 `long`，恢复依据是指令而非该类型推断。增长系数统一定义在 `storage_growth.h`，索引池与记录表共用系数，各自保留不同的截断、容量选择及对齐规则。

追加先准备空间，再写入完整记录，随后更新数量和已使用字节，最后发布 ID。较早发生的容量变化在后续失败时仍可能保留，没有新增事务回滚。

读取和编辑共用一份偏移验证。可写入口先经所有权组件取得写指针，调用方随后可直接使用已有 `PatchAssociationRecord`。借用的字节视图在修改后由调用方重新取得，追加输入应来自在增长期间仍有效的外部区域。

## 初始化与清空

初始化把表标为就绪，并重置数量和已使用字节。已有容量保留，此路径不清零原缓冲区。

`Clear` 也保留容量，但经 `0x1fa65c` 对整个保留区域填零，再重置数量和已使用字节。该辅助函数不是释放缓冲区。表仍保持就绪，后续追加从偏移零重新开始。这是整表操作，不是删除某一条记录。

故障边界显式保留：原清零辅助函数若取得空写指针，会跳过填零，调用方仍重置数量与使用量。恢复源码沿用这一路径，描述符分配异常在元数据重置前传播。

另外，恢复的可写和追加入口对已识别的空分配结果返回 false。原对应路径没有完整检查，可能发布无效指针或继续写入。该差异已声明，完整内存耗尽及 Android 故障等价尚未验收。

## 验证

使用既有 WSL C++17 工具链构建真实组件入口：

```bash
mkdir -p work/native-rewrite/recovered-fixed-phrase
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/recovered/association_list.cc \
  research/native-rewrite/recovered/payload_codec.cc \
  research/native-rewrite/recovered/fixed_phrase_table.cc \
  research/native-rewrite/tests/fixed_phrase_table_test.cc \
  -o work/native-rewrite/recovered-fixed-phrase/fixed_phrase_table_test
work/native-rewrite/recovered-fixed-phrase/fixed_phrase_table_test
```

严格构建与一条源码流程通过：真实 payload 编码、关联记录构造、多次定长追加、真实池分配、记录 ID 写入、关联引用编解码、存储读取及原位编辑。独立字面字节确认 ID `50` 取得第六条记录，修改保留短 payload 后缀和第一条记录。清空后可继续从 ID `0` 追加。

流程现已改走恢复的 `0x1c5120` 协调入口，覆盖首条建立、原位插入和搬迁，并验证链接失败后保留已存记录。列表删除与上层整体失败恢复仍未完成，具体边界见 [关联列表](association-records.md#列表追加与插入顺序)。它仍不是整本词典的端到端验收。

真实 APK 出口补入记录宽度、数量提交、偏移返回、无符号转换与清零参数锚点后通过，当前导出 149 个区域。十一个新增区域与已发布 `v2.1.7` 库的指令字节一致。

证据留存于：

- `work/native-rewrite/ghidra/record-store-construction/`
- `work/native-rewrite/ghidra/fixed-phrase-core/`
- `work/native-rewrite/ghidra/fixed-phrase-growth/`
- `work/native-rewrite/original-apk/native-fixed-phrase-table.txt`
- `work/native-rewrite/restart-v217/native-fixed-phrase-comparison.json`

未执行原 ARM64 记录后端，未访问设备或用户词典。Google 派生材料继续遵循 `NOTICE`，没有扩大分发或许可范围。

## 下一步

继续恢复列表删除、收缩及上层编辑失败恢复，再推进底层 trie、键序列和完整文件容器。表容器编解码、CRC、文件同步与实际持久化仍未完成。
