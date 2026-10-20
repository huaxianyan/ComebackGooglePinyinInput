# 原文件映射读取契约

本页记录原始取证契约。后续 [只读映射源码](file-mmap-source.md) 已恢复受限的 mode `0` 宿主路径，并扩展同一 State/COW。[完整文件加载](mapped-dictionary-load.md) 已接此路径，其他映射模式仍待恢复。

## 真实只读入口

`0x1f59f4` 调用 `0x1f9c50`，实际传入 mode `0`、不创建文件、创建长度 `0`。成功后经 `0x1fa4a4` 包装为字节区域，再赋给输出；失败返回 false。

另一入口 `0x1f5a54` 同样传 mode `0`，但失败路径还有原日志包装。两者都不是把文件读入新 heap 缓冲的替身。

## 打开、映射与资源

FileMMap 保存模式、数据地址、完整文件长度、文件名和 fd。`0x1fa038` 先清理旧映射，再 open、fstat；空文件或 stat 失败不进入映射。

| mode | open | protection | sharing |
| --- | --- | --- | --- |
| `0` | `O_RDONLY` | `PROT_READ` | `MAP_SHARED` |
| `1` | `O_RDWR` | `PROT_READ \| PROT_WRITE` | `MAP_SHARED` |
| `2` | `O_RDONLY` | `PROT_READ \| PROT_WRITE` | `MAP_PRIVATE` |

当前实际读入口只需要 mode `0`。未恢复 mode `1`、`2`，不能把它们统一当作只读，也不能借此新增文件创建策略。

映射后 fd 保留到清理。`0x1f9f78` 释放映射后将地址和长度清零，再 close fd；该函数没有把 fd 字段重置为 `-1`。失败清理与析构可能重复 close，这里只记录证据，未当作本阶段产品修复。

实际 mmap、munmap 调用经过库内包装 `0x303e1c`、`0x303c7c`，并非可直接假定无钩子的 libc 入口。包装及字节区域对映射对象的所有权转移仍待展开。

## 已确认的长度边界

对象先保存完整 stat 长度，但 ARM64 在 `0x1fa110` 执行 `sxtw x1, w1`，再调用映射包装。不能按宿主 size_t 重写后宣称所有长度等价。

未执行大文件、失败 fd 重用或映射并发实验，也未把这些未覆盖输入新增为防御性测试。当前不运行存在资源语义疑问的近似实现。

## 与共用所有权的衔接

映射描述符的实际持有关系已在后续取证确认，并接入同一 OwnedByteRegion State/COW。原 heap 和 parent-slice 共用现有分配与释放，没有第二个字节容器或分配器。

只读映射的可写请求必须有实据支持，不能把映射地址当作 heap 指针交给 realloc/free，或返回可写地址。未确定部分保持未实现，没有 opaque 或假成功 backend。

## 证据

- `work/native-rewrite/ghidra/file-mmap-ownership/`
- `work/native-rewrite/ghidra/file-mmap-open/`
- `work/native-rewrite/ghidra/file-mmap-system/`
- `work/native-rewrite/ghidra/file-mmap-entry/`
- `work/native-rewrite/restart-v217/native-file-mmap-comparison.json`

新增 `14` 段与保留发布库一致。中央清单只登记四个关键入口，累计 `272` 区域，没有重跑旧 C++ 或完整静态门禁。未读取用户词典、安装工具或操作设备。
