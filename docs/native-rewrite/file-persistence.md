# 原生文件保存入口

## 入口与返回值

本阶段恢复 `MutableDictionaryAccessorInterfaceImpl.nativePersist(JLjava/lang/String;)Z` 的文件写入部分，不自行添加原子替换协议。

原链路为：

| 位置 | 行为 |
| --- | --- |
| JNI `0x112768` | 创建 FileStoragePersister，打开传入路径，再调用 accessor 的保存入口 |
| accessor `0x189924` | 在原两层锁中取得模型，调用模型的序列化入口 |
| `0x1fa44c` | 关闭先前流，以 `fopen(path, "wb")` 打开目标 |
| `0x1fa400` | `fwrite(data, 1, size)`，返回值必须等于请求长度 |
| 析构 `0x1fa39c` | 执行 `fflush`、`fclose`，不把两者结果传回 JNI |

`wb` 会在序列化前截断已有目标。JNI 没有使用 open 的返回值决定是否调用序列化，空流的 write 最后返回失败。源码在 open 失败时直接返回 false，未复现随后无效序列化的分配步骤。

FileStoragePersister 另有虚表 flush `0x1fa31c` 和 close `0x1fa34c`。后者只有在 flush 成功后才 fclose，不能把它与上述析构混为一条路径。此 JNI 的最终清理由析构完成。

这条入口没有 `fsync`、备份、rename 或中断恢复。true 表示序列化写入成功，不能当成持久提交完成。`fflush` 或关闭时才出现的失败不会改变原返回值，本阶段保留这一行为，不悄悄改成新契约。

## 单一 writer 与文件所有权

源码入口是 [user_dictionary_file.h](../../research/native-rewrite/recovered/user_dictionary_file.h) 的 `PersistUserDictionaryFile`。它打开实际文件，使用 RAII 清理，并把现有字节生产过程接到实际 `fwrite`。

文件头、元数据和六子模型的顺序只在共用 writer 中定义：

- `WriteUserDictionaryImage` 组合文件头、外层消息和子容器。
- `WriteMutableDictionaryImage` 组合内部消息和六个子模型。
- `dictionary_image_writer.h/.cc` 共用命名字节段、对齐与内存追加。
- 内存入口拥有局部输出，全部成功后才发布。文件入口直接写已打开的目标，失败可能留下不完整文件。

没有复制第二份格式、保留旧私有 ImageWriter 或新增空后端。内存和文件是同一编码过程的实际消费者。

本接口接收调用方稳定持有的模型快照，不伪造原 accessor 的所有权或两层锁。调用方负责同步和选择保存路径，目前仅在项目测试目录调用。原文件替换与恢复策略仍需沿 Java 调用方恢复，不从 `wb` 入口推测临时文件名或备份规则。

## 尺寸与失败边界

完整镜像的规范尺寸检查也使用共用 writer，以计数 sink 取得长度，取消了上一阶段的完整子容器临时副本。子表和 trie 镜像仍会分配并计算 CRC，不等同于原 `0x1c6994` 的无分配求尺寸。

目前按已恢复子模型镜像输出，不复现原 stream 的每一次 fwrite 分块。写入失败后的具体字节前缀、分配故障和异常步骤尚未验收，不宣称部分 I/O 等价。

普通文件读取只在测试中取得真实字节，再交给完整镜像 parser。原 FileMMap 的映射、文件描述符与生命周期没有被一个临时 read 后端替代。

## 验证

全部 recovered C++ 严格编译一次，延伸既有同一条端到端流程：

1. 通过实际文件入口保存合成词典，再从磁盘读取，字节与既有完整内存镜像一致。
2. 由完整 parser 加载实际文件，再通过真实关联入口删除一条关系，显式更新外层累计与同步时间。
3. 用较短的第二代镜像覆盖原文件，真实 EOF 与内存镜像一致，旧尾部已截断。
4. 以实际目录路径触发 open 失败，得到 false，先前测试文件仍可读取。
5. 只删除本次测试创建的字典文件，移除空临时目录。

文件均位于新建的 `work/` 子目录，没有读写设备或用户词典。未制造磁盘耗尽、崩溃、晚期 flush/close 故障或 SAF Provider 故障。

共用构建命令见 [可变词典镜像](mutable-dictionary-image.md)。当前测试入口需要传入一个新建的项目内测试目录。

八段新函数与保留 `v2.1.7` 发布库字节一致，文件 persister 虚表及实际 JNI 分支锚点通过，真实出口现导出 `246` 个区域。材料保留于：

- `work/native-rewrite/ghidra/file-storage-persister/`
- `work/native-rewrite/ghidra/file-persister-entry/`
- `work/native-rewrite/ghidra/file-persist-coordinator/`
- `work/native-rewrite/restart-v217/native-file-persist-comparison.json`

## 下一步

从 Java 的 persist 调用方继续定位路径选择、文件替换和失败恢复。原持久编辑器、完整学习协调器、旧文件格式、映射读取及跨进程同步仍未恢复。本轮未执行原 ARM64，也没有把 WSL1 普通文件成功写入当作 Android 持久性验收。

协调层已恢复，见 [Java 文件替换协议](java-file-replacement.md)：`_tmp` 写入、`_bak` 移动、主替换和 `finally` 清理已按 DEX 重建，并用保留构建交叉核对；跨运行时集成流通过 Windows JDK 与实际 C++ 驱动运行。下一步恢复学习与同步流程中的显式入口。
