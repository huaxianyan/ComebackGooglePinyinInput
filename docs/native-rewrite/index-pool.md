# 索引池块布局与内存操作源码

## 本轮范围

恢复组件为 `research/native-rewrite/recovered/index_pool.h`、`index_pool.cc`，模块探针为 `research/native-rewrite/tests/index_pool_test.cc`。

`IndexPoolView` 提供记录 ID 读写、空闲节点操作，以及固定存储上的查找、拆分复用与相邻块回收。`InitializeIndexPool` 和 `AllocateIndexRange` 使用两份 `OwnedByteRegion` 承接初始化与增长，节点操作仍共用视图实现。完整文件载入、外部 Provider 与持久化尚未闭合。

关联引用与池范围统一使用 `IndexRange`，定义只保留在 `index_pool.h`。旧研究类型 `AssociationReference` 已由该类型替换，调用方同步修改，没有保留转发别名。关联引用的 23／9 位字节布局保持原样。

## 元数据与数据区分离

构造入口 `0x1e3b6c` 建立两份缓冲区所有权，并另存数据区指针。`0x1e3bdc` 的正常初始化分别写入：

| 区域 | 首个 32 位字 | 第二个 32 位字 |
| --- | --- | --- |
| 八字节元数据 | `0`，用途尚未命名 | 已使用单元数，初始为 `2` |
| 数据区的两个哨兵单元 | 初始为 `2` | 初始为 `0` |

**元数据中的数量不在数据区第二个单元内。** 数据区第二个单元是空闲链表尾节点索引，会随链接操作改变。把这两份缓冲区混为一体，会在更新尾节点时破坏数量解释。

视图分别接收元数据和数据区的地址、长度。数量从元数据的偏移 4 读取，数据区长度只表示可访问容量。已使用范围包含哨兵和空闲单元，不是词条数或记录数。

原可写缓冲区访问器含写时复制。恢复视图不复制该所有权 ABI，调用方须先取得可写存储，并在缓冲区搬迁后重建视图。

## 单元与空闲节点

每个单元为小端 32 位。记录访问从索引 `2` 开始，最高位表示占用，低 31 位保存记录 ID：

```text
occupied_word = record_id | 0x80000000
record_id = occupied_word & 0x7fffffff
```

读取有效范围内的空闲单元时，checked-read 将输出设为 `0xffffffff` 并返回失败。索引不在已使用范围内时，失败但保留输出。即使数据区还有剩余容量，也不能把这些位置当成已使用单元读取。

空闲节点布局如下：

| 位置 | 内容 |
| --- | --- |
| 节点首字低 2 位 | 长度为 1、2 时直接保存，长度至少 3 时保存标记 `3` |
| 节点首字的位 2～30 | 后继空闲节点索引 |
| 节点 `+1` 单元 | 长度至少 2 时保存前驱索引 |
| 节点 `+2` 单元 | 长度至少 3 时保存实际长度 |

索引 `0` 的哨兵长度为 2，首字连接链表头，第二字保存链表尾。单格空闲块没有前驱字段，原路径通过链表扫描寻找前驱。恢复的 `LinkFreeRanges` 写入前驱节点的后继与长度信息，并按后继长度更新其前驱字段，不自行清零或分配范围。

范围验证保留原接口的有符号正数约束。内存视图还检查访问不超出实际缓冲区，但没有声称验证整条链表、占用关系或完整文件合法性。

## 回收与复用核心

| 恢复入口 | 原路径 | 行为 |
| --- | --- | --- |
| `FindFreeRange` | `0x1e41b8` | 按链表顺序寻找首个足够大的块 |
| `ClaimFreeRange` | `0x1e45b4`、`0x1e4a20` | 取得链表前后节点，写入 ID，再拆分或移除空闲块 |
| `ReleaseRange` | `0x1e47e4`、`0x1e4244`、`0x1e463c` | 查找物理相邻空闲块，合并、清零并重新链接 |

`FindFreeRange` 成功且返回 `{0, 0}` 表示现有空闲块不足，上层需要增长存储。这个结果不是完整 Allocate 的失败回退。碎片总量足够但单块不足时，同样保留该结果。

`ClaimFreeRange` 接受真实空闲范围。完全用尽时移除节点，有剩余时保留剩余块并重接前后节点。输入范围随后描述已占用部分。原填充循环不累计单元写入返回值，恢复视图沿用该顺序，已验证范围内的原位写入不搬迁存储。

`ReleaseRange` 接受调用方拥有的占用范围。没有相邻空闲块时按地址插入，有相邻块时合并左侧、右侧或两侧。清零后先回写合并范围，再更新链表。返回范围可能比输入更大、起点更早。

这些操作要求已验证、按地址有序且无环的空闲链表。它们不增加回滚，也不验证重复归还、所有权或整张表。所有权与增长由下述双缓冲区入口承担，视图本身只处理当前内存。

## 拆分时的旧长度

Ghidra 的 `0x1e4a20` C 视图把寄存器快照误写成后续内存读取。如果照抄，会先改写已占用长度，再用新长度减去自身，错误地产生零长剩余块。原指令保留旧描述符：

```text
0x1e4ad8  ldr x0, [x19]          ; 保存旧索引与长度
0x1e4ae0  str w4, [x19, #4]      ; 更新已占用长度
0x1e4ae8  asr x0, x0, #0x20      ; 从快照取旧长度
0x1e4af0  sub x0, x0, x4         ; 计算实际剩余长度
```

恢复源码先计算剩余范围，再更新出参。模块测试中的五格拆成两格加三格，直接以独立字面镜像验证，期望值不由被测实现生成。

## 双缓冲区分配与增长

`InitializeIndexPool` 对应 `0x1e3bdc`，先调整单元区，再调整元数据区，写入初始数量与哨兵。`AllocateIndexRange` 对应 `0x1e4b44`，使用 [堆缓冲区所有权组件](owned-byte-region.md)，不另建一套节点或分配器实现。

分配顺序如下：

1. 查找首个足够大的空闲块。有合适块时直接复用，返回的单元先存占用状态的零记录 ID。
2. 没有合适块时，读取活动尾部。只有尾空闲块恰好结束于活动边界时，才把它的长度计入可复用部分。
3. 若实际容量不足，将活动数量乘 1.25 并截断为整数，与「活动数量加三倍请求量」取较大值，再向上对齐到偶数单元。
4. 重新取得增长后数据指针。追加的活动数量只取「请求量减尾部可复用量」，也对齐到偶数，不直接激活全部容量。
5. 先更新元数据活动数量，再将追加单元标为占用零 ID，经已有回收路径与尾块合并。
6. 构造零 ID 向量后回写输出范围，再由已有填充、拆分逻辑完成占用。

元数据写时分离后立即重建视图，单元区调整大小后也重新取得指针并重建视图。此前借用的视图由调用方重新取得，执行器不额外维护另一份缓存指针。实现沿用正常有效池的 32 位运算与有符号字节缩放，整型耗尽和非正常池输入尚未验收。

跨缓冲区修改按顺序提交。后续失败时，先前完成的容量、活动数量或空闲链修改仍可能保留，没有新增事务回滚。

已知故障差异：原初始化忽略缓冲区分配失败，随后可能解引用空指针。恢复入口对已识别的分配失败返回 false，保留此前修改，不复刻空指针解引用。内存耗尽、分配异常与原 Android 的完整故障表现尚未验证，不能据此宣称故障等价。

## 序列化边界

`0x1e3e4c` 输出的表容器依次是：八字节 `P-TABLE\0` 标识、八字节 CRC64、八字节元数据，以及已使用单元的字节。总长度为 `24 + 4 × 已使用单元数`。

`0x1e3c50` 的 CRC64 覆盖元数据和已使用数据区。它已接入同一 [词典 CRC](dictionary-storage.md#crc-来源与实现)，64 位反射多项式与初值均为 `0xab0547580daac74e`，没有末尾 XOR。此 CRC 不等于外层词典头的 CRC32。

[共享表镜像编解码](../../research/native-rewrite/recovered/dictionary_table_image.cc) 已恢复正常格式路径。`SerializeDictionaryTableImage` 选择 `IndexPool` 后输出活动字节，不输出分配容量。`LoadDictionaryTableImage` 对照 `0x1e3cf0`，校验成功才安装两份区域，并返回本帧消耗的字节数，输入可带后续内容。元数据保留父切片，数据区按原入口请求可写区域并分离。原视图应在加载后重新取得。

单元宽度和元数据宽度移入 `index_pool_layout.h`，原池操作与容器共用同一组定义。载入只校验签名、长度与 CRC，不证明空闲链表有序、无环或记录关联完整。

正常边界之外仍有明确差异：恢复入口先检查最小长度，按原有符号 32 位长度的正常正数范围处理切片，不模拟短输入读越界或整数截断后的无效访问。加载沿用先安装区域、再请求写指针且不检查空结果的顺序，但恢复类型没有原缓存指针，完整分配故障不承诺等价。

此入口操作堆内存镜像，未连接磁盘或 Provider。原 writer 分四次写流，失败时可能留下部分输出；当前内存编码不模拟该 I/O 故障顺序，不能据此宣称磁盘持久化已经完成。

## 容器验证

```bash
mkdir -p work/native-rewrite/recovered-pool-codec
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/dictionary_table_image.cc \
  research/native-rewrite/recovered/datrie_validation.cc \
  research/native-rewrite/recovered/dictionary_checksum.cc \
  research/native-rewrite/tests/index_pool_codec_test.cc \
  -o work/native-rewrite/recovered-pool-codec/index_pool_codec_test
work/native-rewrite/recovered-pool-codec/index_pool_codec_test
```

严格 WSL C++17 构建及一条真实流程通过：初始化并分配记录 ID `0x123456`，保存四十字节容器，带后续字节加载，修改为 `0x07654321`，再保存。两份完整容器的独立字面期望分别含 CRC64 `0x2233d4180b92d695`、`0xa49ba9d347950f33`，均由 GF(2) 多项式长除法推导，未调用生产算法算答案。已加载的编辑保持可读，改坏输入记录的 CRC 校验失败，两个区域保持原值。

共享计算扩为 64 位后，既有词典头、CRC32 与 CRC16 fixture 的严格构建通过，关联修改调用方的接口编译通过。真实 APK 入口补入 64 位扩展、初始化、配置和虚表锚点后通过，现导出 `188` 个区域。两段新函数与配置均和保留的 `v2.1.7` 发布库字节一致：

- `work/native-rewrite/original-apk/native-pool-crc64.txt`
- `work/native-rewrite/restart-v217/native-pool-codec-comparison.json`

未执行原 ARM64，未读写设备或用户词典。

随后 DATrie 表确认使用相同签名、CRC64、元数据和活动正文形状，公共包络已合并为 `dictionary_table_image.h/.cc` 的单一入口，通过 `DictionaryTableKind` 选择真实格式。旧仅池入口已删除，没有逐方法转发或第二套编解码。迁移后的既有池流程通过，DATrie 的额外图校验及证据见 [DATrie 镜像](datrie-view.md#表镜像与原加载校验)。

## 池操作的既有验证与证据

使用既有 WSL 编译器，以 `-std=c++17 -O2 -Wall -Wextra -Werror` 编译：

```bash
mkdir -p work/native-rewrite/recovered-pool
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/tests/index_pool_test.cc \
  -o work/native-rewrite/recovered-pool/index_pool_test
work/native-rewrite/recovered-pool/index_pool_test
```

源码构建通过。既有探针继续覆盖元数据分离、节点布局、占用标志、关联引用解析，以及固定存储的回收与复用。

新增一条拥有存储的真实 API 流程，从空池初始化后转为父切片形态，再多次分配、归还和增长。流程验证尾块复用、直接复用空闲块、已有容量内激活，以及容量增长至 12、16、20 个单元。最终独立字面镜像包含 18 个活动单元、剩余空闲尾、未激活的零字节，以及跨增长保留的记录 ID。

真实 APK 取证入口补入增长系数、偶数对齐、指针更新与活动数量提交锚点后通过，仍导出 138 个区域。此前池操作的二十五个区域与发布库字节一致，缓冲区路径见 [堆缓冲区所有权源码](owned-byte-region.md)。

证据留在 `work/native-rewrite/original-apk/native-index-pool.txt`、`work/native-rewrite/restart-v217/native-index-pool-comparison.json`，以及 Ghidra 的 `index-pool-blocks/`、`index-pool-runs/`、`index-pool-node-fields/` 和 `index-pool-ownership/` 目录。

没有执行原 ARM64 池函数、访问用户词典或操作设备。Google 衍生逻辑继续遵循 NOTICE 的权利边界，宿主模块通过不代表完整分配、回收或持久化等价。
