# 索引池块布局与内存操作源码

## 本轮范围

恢复组件为 `research/native-rewrite/recovered/index_pool.h`、`index_pool.cc`，模块探针为 `research/native-rewrite/tests/index_pool_test.cc`。

`IndexPoolView` 提供记录 ID 读写、空闲节点长度与后继读取，以及空闲范围的链接更新。它是借用内存的视图，不负责分配、扩容、相邻块合并、所有权或完整文件载入。

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

## 分配与回收的静态路径

- `0x1e41b8` 沿空闲链查找首个足够大的块。
- `0x1e4b44` 在容量不足时选择增长值，涉及已使用数量的 1.25 倍、当前数量加请求数量的三倍，以及偶数单元对齐。尾部空闲块和已使用范围分别处理，不能把容量直接当作活动尾部。
- `0x1e4a20` 写入记录 ID、拆出剩余范围，再连接相邻空闲节点。
- `0x1e47e4` 经 `0x1e4244` 查找物理相邻空闲范围，交给 `0x1e463c` 合并。合并路径还处理链表前后节点、清零和链接更新。

这些入口已有函数范围、指令和反编译视图，但可写存储、搬迁、内存不足及中途失败尚未恢复成完整执行器。组件未提供返回固定结果的 Allocate 或 Release 占位接口。

## 序列化边界

`0x1e3e4c` 输出的表容器依次是：八字节 `P-TABLE\0` 标识、八字节 CRC64、八字节元数据，以及已使用单元的字节。总长度为 `24 + 4 × 已使用单元数`。

`0x1e3c50` 的 CRC64 覆盖元数据和已使用数据区。`0x1e3cf0` 校验载入的表，再安装两份区域和数据指针。此处 CRC64 不等于外层词典头的 CRC32。本轮没有恢复表容器编解码、CRC64 或实际磁盘写入。

## 验证与证据

使用既有 WSL 编译器，以 `-std=c++17 -O2 -Wall -Wextra -Werror` 编译：

```bash
mkdir -p work/native-rewrite/recovered-pool
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/index_pool.cc \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/tests/index_pool_test.cc \
  -o work/native-rewrite/recovered-pool/index_pool_test
work/native-rewrite/recovered-pool/index_pool_test
```

源码构建通过。独立字面镜像覆盖元数据与数据区分离、单格／双格／扩展长度节点、头尾链接、占用标志及已使用范围。模块入口从真实关联引用解码进入池视图，取出对应记录 ID。共享范围类型变更后的关联记录模块回归通过。

既有真实 APK 取证入口增加单元标志、节点字段及初始化锚点后通过，当前导出 119 个区域。二十五个新增区域与发布库的指令字节一致。

证据留在 `work/native-rewrite/original-apk/native-index-pool.txt`、`work/native-rewrite/restart-v217/native-index-pool-comparison.json`，以及 Ghidra 的 `index-pool-blocks/`、`index-pool-runs/`、`index-pool-node-fields/` 和 `index-pool-ownership/` 目录。

没有执行原 ARM64 池函数、访问用户词典或操作设备。Google 衍生逻辑继续遵循 NOTICE 的权利边界，宿主模块通过不代表完整分配、回收或持久化等价。
