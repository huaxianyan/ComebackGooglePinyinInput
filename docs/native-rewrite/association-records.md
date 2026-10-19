# 关联表引用与记录源码

## 本轮范围

引用与字段写入源码位于 `research/native-rewrite/recovered/association_records.h`、`association_records.cc`。列表追加协调位于 `association_list.cc`，池范围操作共用 `index_pool.cc`。原字节操作仍可独立构建，不因协调入口引入存储后端链接依赖。

组件包含四字节关联表引用的编解码，以及单键、双键关联记录的原位字段写入。它继续共用 `little_endian.h`，没有建立另一套字节序实现。索引池的分配、扩容与回收已有源码，定长记录后端见 [记录存储源码](fixed-phrase-table.md)。trie 值、双向删除、已有关系更新和双向新增已有源码，完整表容器及磁盘存储仍待恢复。

## 引用头与索引池

`0x1c39cc` 从 trie 值的首四个字节读取引用，`0x1c4348` 将两个字段合成为同一个小端整数：

```text
word = (first_index << 9) | (count & 0x1ff)
first_index = word >> 9
count = word & 0x1ff
```

写入保留 23 位索引和 9 位数量，按原指令截取位，不改为饱和。字面样本 `55 ad 68 24` 对应索引 `0x123456`、数量 `0x155`。读取允许后面还有其他 trie 值数据。

`first_index` 进入索引池的元素访问。匹配循环以 `first_index + i` 遍历 `count` 个位置，再由 `0x1c3ac8` 或 `0x1c7f7c`：

1. 调用 `0x1e3fc8`，从索引池取得 32 位记录 ID。
2. 通过记录存储对象虚表 `+0x48` 取得对应记录的字节视图。
3. 读取记录中的键 ID，与请求的键或键对比较。

因此，引用中的索引不是直接指向记录正文的文件字节偏移，也不是记录 ID 本身。已定位的 `FixedPhraseTable` 使用表内字节偏移作为记录 ID，首条记录的零 ID 有效，不能把它当作记录序号。

## 列表追加与插入顺序

| 恢复入口 | 原函数 | 职责 |
| --- | --- | --- |
| `AppendAssociationRecord` | `0x1c5120` | 先存记录，再按列表数量分派 |
| `CreateIndexRange` | `0x1e4dd4` | 申请一个位置并写入首个记录 ID |
| `InsertIndexRange` | `0x1e4e3c` | 保存旧 ID、插入新 ID，再重建池范围 |

追加入口先通过记录后端的 `+0x58` 存下记录。列表数量为零时创建首条，非零时以当前数量作为插入位置，即追加到列表末尾。返回偏移按原调用方收窄后进入池，没有扩大原有 31 位 ID 的可寻址范围。

插入先构造含新 ID 的临时向量，再释放旧范围。若回收后的范围比旧列表更大，直接在合并范围中填入新列表。否则重新分配，成功后回写引用并逐个写入 ID。新起点可能向前或向后移动，调用方须使用返回引用更新上层 trie 值。

插入位置允许从零到原数量。原路径直接用位置写临时向量，恢复接口对越界位置提前返回失败，不复刻无效 cursor 的越界写入。正常路径共用既有字段、范围与节点操作，没有第二套列表存储。

这一层保留顺序提交：记录存下后若链接失败，已追加记录仍存在。插入释放旧范围后若再分配失败，旧范围已经归还，输出引用可能仍保留旧值，不能假设原列表可继续使用。临时向量在释放前构造，分配异常在不同位置留下的状态也不同。上层编辑器的整体失败恢复仍未闭合，本轮没有新增事务回滚。

## 两种记录布局

| 分支 | 前缀 | payload 起点 |
| --- | --- | --- |
| 两侧 trie 的关联记录 | 一个 32 位对端键 ID | 偏移 4 |
| SingleTrie 的关联记录 | 两个 32 位键 ID | 偏移 8 |

字段均为小端。记录布局与 V10／V21 payload 是不同维度，不能按 payload 版本猜测使用哪种记录布局。公共接口通过 `AssociationRecordLayout` 明确选择，两种布局共用一份写入逻辑。

`0x1c3a30`、`0x1c80cc` 都支持可选字段更新：键指针或 payload 对象为空时，保留对应字节。非空 payload 只覆盖传入视图的长度，后面的字节保留。顺序写入不是事务，后段容量不足时，前段已完成的写入仍然存在。

恢复接口使用调用方提供的有效缓冲区及显式容量，不复制旧字符串对象 ABI。容量检查避免无效 cursor 导致越界写入，旧实现的无效指针或越界 cursor 访问不属于兼容契约。正常字段写入和容量不足的逐段失败行为按原路径保留。

trie 值中的引用头可能另接可选的十六位校验字段与附加数据，它们不等于这里的关联记录 payload。可选值字段的原位补丁已接入新键创建与双向新增，见下方的新增协调说明。

## 反编译视图的参数缺口

Ghidra 在 `0x1c3b68` 的调用点漏显示输出参数，并将匹配条件误显示为目标参数等于零。原指令明确通过 `x2` 传入临时键 ID 的地址，随后在 `0x1c3bf8` 将读出的键 ID 与 `w24` 中的目标键比较。它不是只接受零号键。

SingleTrie 的匹配入口 `0x1c7ff4` 先确认记录至少八字节，再比较两个 ID。恢复依据是指令、调用约定与字节布局，不是直接照抄上述 C 视图。

## 验证与留存

使用既有 WSL C++17 工具链：

```bash
mkdir -p work/native-rewrite/recovered-associations
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/recovered/payload_codec.cc \
  research/native-rewrite/tests/association_records_test.cc \
  -o work/native-rewrite/recovered-associations/association_records_test
work/native-rewrite/recovered-associations/association_records_test
```

实际源码构建通过。模块测试使用独立字面引用、单键和双键记录，走已有 payload 编码到关联记录写入的真实组件入口，检查字段更新和原有容量失败语义。测试没有伪造索引池或模拟完整词典。

列表级验证扩展现有 [记录存储整合入口](fixed-phrase-table.md#验证)。入口已改走真实追加协调器，覆盖首条创建、原位扩展、中间插入后搬迁，以及其他列表的保留。独立字面期望验证新 ID 顺序为 `50`、`0`、`60`。向保留的哨兵位置链接会真实失败，测试确认此前追加的 ID `70` 记录仍存在，引用保留旧值。该失败路径来自原指令的保留索引检查，不是故障注入。

真实 APK 入口补入先存后链接、先释放后分配的调用锚点后通过，仍导出 149 个区域。已有函数范围与发布字节对照继续适用，没有执行原 ARM64 入口或验收全部内存故障位置。

既有真实 APK 取证入口补入位布局、字段偏移与实际键比较锚点后通过，该轮导出器共 94 个区域。十三个新区域与已发布库的指令字节全部一致。

证据留在：

- `work/native-rewrite/original-apk/native-association-records.txt`
- `work/native-rewrite/restart-v217/native-association-comparison.json`
- `work/native-rewrite/ghidra/association-records/`
- `work/native-rewrite/ghidra/association-pool-addressing/`
- `work/native-rewrite/ghidra/association-readers/`

本轮没有执行原 ARM64 记录操作、读取用户词典、操作设备或验证真实磁盘读写。Google 衍生逻辑的权利边界继续按 NOTICE 保留。

## 按键删除与逻辑收缩

`RemoveAssociationRecord` 恢复 `0x1c524c` 的单键记录路径，按列表顺序经池和定长表寻找首个目标键。匹配后调用 `IndexPoolView::EraseRecordId`，对应原函数 `0x1e4870`。它仅适用于 `TargetKey` 布局，不代替双键记录或上层 trie 删除。

删除保留原搬移选择：

- 左侧没有空闲范围时，将后缀向前移动，释放列表末端单元。
- 左侧空闲范围存在时比较两侧长度，右侧缺失按原有带符号 `-1` 语义处理。左侧更大时将前缀向后移动、释放首单元，并增加引用起点。长度相等时释放末端单元。
- 只剩一项时，先将引用数量置零，再归还原单元，引用保留原起点，不统一改成 `{0, 0}`。

引用修改在空闲单元回收前发生，回收失败不恢复原引用。单元回收复用现有合并算法，没有第二套链表。这里只减少关联数量，不减少池活动范围、分配容量或定长表记录数量，也不是词典文件压缩。

扩展同一整合入口，按目标键走真实读取和删除：中间项删除后保留 `50`、`60`，释放另一列表后改走前缀搬移，剩余 `50` 的起点从 `5` 变为 `6`。最后一项删除后数量为零、起点仍为 `6`，已编辑的记录正文仍保留。独立期望确认空闲单元合并成 `{2, 6}`。严格 C++17 构建通过，没有新增模拟后端或故障注入。

真实 APK 入口补入搬移方向、引用提交和回收锚点后通过，当前导出 151 个区域。两个新增区域与发布库字节一致，证据为 `work/native-rewrite/original-apk/native-association-removal.txt` 及对应 comparison JSON。

## 已有关系更新

`dictionary_association_update.cc` 的 `ModifyDictionaryAssociation` 统一恢复 `0x1c5660` 的模式 `1` 和 `2`。模式 `2` 只更新已有关系：先复制双方键值并解码引用，再更新第一侧匹配记录的可选 payload，随后确认第二侧存在对应记录。最后只修改反向键的可选附加数据，再通过 slot 1 原位写回值。原仅更新入口已移除，调用方显式选择模式，不保留转发壳。

第二侧确认传入两个空更新参数，因此只查找，不请求可写记录。`UpdateAssociationRecord` 统一这个原入口与节点迁移的匹配写入，保留首个匹配规则和顺序失败行为。按键复制值也集中到 `ReadTrieValueByKey`，删除与更新不各自实现一份。

`PatchAssociationValue` 恢复原值补丁的可选引用、校验和附加数据。首四字节可写关联引用，启用校验且参数非空时，在偏移 `4` 写入小端十六位校验。尾随数据从偏移 `4` 或 `6` 开始。省略的字段及未覆盖后缀保留，写入仍按原顺序执行。

2026-10-20 的严格构建与既有模块入口通过：在八字节值中写入 `0x66b0` 和一个字节数据，独立字面期望确认引用头和最后一个字节保留。计算共用 [词典 CRC](dictionary-storage.md#crc-来源与实现)，没有建立另一套值写入或区域所有权。

本轮宿主流程覆盖附加数据偏移 `6`，不带十六位字段的偏移 `4` 分支目前只有原指令和恢复源码证据。

已有关系更新不增加键、值或关联记录，不修改关系数量或状态位。缺少反向匹配时，正向 payload 可能已经写入，反向值尚未提交。模式 `2` 不进入模式 `1` 的追加和新键清理分支，缺失项直接返回失败，不使用模拟创建路径。

下方同一真实双侧流程先更新 `a-x`：偏移 `0` 的记录保留目标 ID 并写入六个新字节，八字节反向值保留引用和十六位字段，只更新最后两字节。独立字面期望检查结果，双方记录数量保留。单侧缺失场景还确认正向记录偏移 `30` 的 payload 已更新，反向值与记录数量保持原样。

节点迁移调用了同一匹配写入实现，因此另外回归已有输入输出明确的节点迁移测试。两条反向 ID 修复与后续缺失端点的部分完成语义通过。两项测试共用一次严格 C++17 源码编译，没有增加第二套接收者或测试后端。

## 双向新增与新键清理

模式 `1` 先执行相同的已有关系更新，已有双向匹配时不增加关系数量。缺少任一匹配后，双方当前列表数量均低于 `511` 才允许追加。先写正向记录、链接池项和发布值，再处理反向，全部成功后关系数量加一并设置 `0x10`。

`0x1c4494` 的查键与新键建立也已连接。新值先清零，按键的真实字节计算 CRC16，再经已有 `InsertTrieValue` 追加值和插入终端。原 `0x1c45cc` 未检查校验补丁返回值，恢复路径保留该顺序。键插入绑定同一 `UpdateMovedNodeId`，真实搬迁可修复对侧记录。

`AssociationEditor` 按方向拥有记录和值暂存区，更新、删除与新增共用这些区域。记录暂存区跨调用保留省略 payload 的旧字节，新键的值暂存区才清零。区域大小读取实际定长表的记录宽度，没有第二套宽度配置或记录分配器。拥有位置按源码结构归一化，未复制原对象 ABI。

追加路径失败后，按当时列表数量清理空端点。已经追加成功的列表数量大于零，因此不会因为这次操作失败就被整体删除。查键或引用解码阶段失败直接返回，不补做这段清理。键删除不回收已追加的值或关联记录，整体恢复不在此层。

一条真实组件流程创建 `a-x`、`a-y`、`b-y`，验证独立 CRC 字节、附加数据、暂存 payload 保留与已有关系更新。继续通过真实编辑新增 `510` 个键，将 `x` 的反向列表填到 `511`，并在增长后核对原关联和最后一个新关联。再新增 `overflow-x` 时，创建的空正向键被清理，关系数量仍为 `513`。定长值表保留新值记录，正反向关联记录数量仍各为 `513`，没有故障注入或伪造计数。

严格 WSL C++17 共享编译通过，新增流程与既有更新、删除和单侧缺失流程均通过。真实 APK 出口新增 CRC 写入、列表上限、计数与清理锚点后通过，仍为 `186` 个区域。原 ARM64、外层准入与内存故障等价仍未验收。

## 双向关联删除

`association_editor.h` 和 `dictionary_association_removal.cc` 恢复 `0x1c52ac` 的执行协调。`AssociationEditor` 在既有方向依赖外补充 trie 的拥有区域，继续使用同一对象。方向依赖的 trie 与值表引用可写，通知读取与编辑不各自维护一套状态。

`RemoveDictionaryAssociation` 先查找并复制两侧键值，再解码和删除第一侧列表项。第二侧引用的解码在这之后，删除第二侧列表项后，才开始发布任一 trie 的变化。每一侧列表为空就调用真实键删除，否则仅覆盖值首四字节的关联引用，再通过 `UpdateTrieValueByKey` 原位写回。

更新使用原 slot 1，没有借用 slot 0 的「更新失败后追加」策略。两个入口的已有值更新共用同一实现，更新失败不创建替代记录。可选十六位字段和尾随数据保持原字节，该删除路径不重新计算校验值或覆盖附加内容。

`DictionaryEditState` 显式保存原运行时关系数量和状态位，对应对象 `+0x34` 和 `+0x20`。它不是文件头布局，也不是设置页的词库统计。第一侧发布成功后，第二侧发布无论成功还是返回失败，仍减少关系数量并置位 `0x10`。更早失败则保留此前修改并直接返回，不补偿池或重建键值。

### 双侧整合验证

```bash
out=work/native-rewrite/recovered-dictionary-association-update
mkdir -p "$out"
g++ -std=c++17 -O2 -Wall -Wextra -Werror -nostdlib -r \
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
  research/native-rewrite/recovered/node_id_updater.cc \
  research/native-rewrite/recovered/dictionary_checksum.cc \
  research/native-rewrite/recovered/dictionary_association_removal.cc \
  research/native-rewrite/recovered/dictionary_association_update.cc \
  -o "$out/recovered.o"
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/tests/dictionary_association_removal_test.cc \
  "$out/recovered.o" -o "$out/dictionary_association_update_test"
"$out/dictionary_association_update_test"
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/tests/dictionary_association_creation_test.cc \
  "$out/recovered.o" -o "$out/dictionary_association_creation_test"
"$out/dictionary_association_creation_test"
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/tests/node_id_updater_test.cc \
  "$out/recovered.o" -o "$out/node_id_updater_test"
"$out/node_id_updater_test"
```

严格 C++17 构建通过。真实插入键、追加值和关联列表建立 `a-x`、`a-y`、`b-y` 三条关系。删除分别覆盖第一侧保留、第二侧保留和双方空列表分支，最终双方键数为零，值表各两条、记录表各三条留存。关系数量从三降到零，状态位从 `0x80` 到 `0x90`。

独立字面引用验证第一侧剩余列表，第二侧通过发布的引用实际取得偏移 `4` 的目标记录。六字节与八字节值的尾随字段保留原字节，没有使用生产算法计算期望。

随后用实际追加建立只有正向记录、反向键为空列表的输入。删除返回失败时，第一侧池项已经释放，但两侧键、旧发布引用、关系数量与状态位保留。断言经冻结的池读取协议观察空闲单元，而非绑定无关的分配容量，也未注入失败回调。

APK 入口补入第二列表失败早退、更新与删除分派、第二侧编码失败及计数状态写回锚点后通过，总数仍为 186。已有关系更新还补入两侧匹配、附加数据补丁和模式分派锚点。复用既有 `native-association-removal.txt`、`native-editor-header.txt` 等证据，没有新建重复取证批次。

## 双向删除的失败边界

已静态连接 `0x1c52ac`：查找双方键，依次修改双方池列表，再按各列表是否为空删除 trie 键或重写引用。列表删除与 trie 写回不是同一次提交。

原指令还确认一个重要顺序：第二侧引用编码失败，或第二侧 trie 写入、删除返回失败时，尾部仍执行关系数量 `+0x34` 减一，并将状态字段 `+0x20` 置位 `0x10`，随后返回该失败结果。第一侧失败的早退位置不同，不能将这一函数改写成统一的「全部成功后再减数量」。

双侧删除已有宿主证据，缺少反向记录的早退也已执行。第二侧发布失败后仍减数量的分支，目前只有静态与恢复源码证据，未注入内存故障验收。值与记录暂存区现已按方向跨调用复用，但按需分配与原构造阶段分配不同，分配失败步骤仍不承诺等价。外层恢复、原 ARM64、损坏格式及完整内存故障仍未验收，不把部分提交解释为词典整体回滚。

## 下一步

索引池节点布局、独立元数据与内存操作见 [索引池源码](index-pool.md)。CRC16、双向新增与空端点清理已经连接。下一步恢复完整表容器与外层恢复，再连接文件读写；不以宿主编辑流程代替持久化或完整输入引擎验收。
