# 词典复制与原生整理入口

## 复制是序列化再加载

调用路径已由原 ARM64 与 accessor 虚表确认：

```text
nativeDuplicateDictionary 0x10e620
  accessor slot 26 / +0xd0 → 0x18c3f8
    0x18c27c → MemoryChunk + serializer → 新 factory → 加载同一 chunk
```

`0x18c3f8` 在持有 accessor 锁时执行复制，成功后替换共享模型所有者、刷新接口并置复制标志；失败时清除 accessor 就绪标志。内部模型复制不是直接浅拷贝，也不是只复制两个 trie 的 COW 指针。

`DuplicateUserDictionary` 按内存 chunk 往返恢复当前完整镜像的模型复制，继续复用同一 serializer 和 loader。没有添加第二份克隆算法或协议。新模型持有 chunk 切片的所有权，函数局部缓冲退出后仍可读取和编辑。

此入口只恢复模型级操作，不伪造原 accessor 的共享指针、锁、就绪位或复制标志。其他文件版本及未恢复后端仍沿用现有失败边界。

## 真实编辑验证

既有完整镜像端到端流程改走实际复制入口，保留内外元数据、未知字段和独立计数。对复制体新增关联并修改外层消息后，重新编码原模型，原完整镜像字节保持不变。

本阶段只增量编译改变的 `user_dictionary_image.cc`、更新 archive 并链接该流程，通过。没有再次全量编译已确认的其他源码，也没有复跑无关 Java 集成流。

## compact 的已确认边界

```text
nativeCompact 0x10e510
  int 参数符号扩展 → accessor slot 6 / +0x30 → 0x1899b4
    0x1a39d8 → 当前原生日值减 0x3e → 0x1a3758
```

Java 保存任务先以 double 乘 `0.9d` 产生 compact 参数。原生选择阶段又以 float32 乘一个系数，`0x1a39d4` 的真实字节为 `6666663f`，即 `0.9f`，两者不能合并成同一精度的乘法。

原生阶段还计算日期相关的候选数量，再以数量上限确定选择区间。最终保留数量不能只用 Java 传入的容量参数推断。比较器、记录解码、排序与删除流程尚未完整恢复，因此没有添加近似 compact、空实现或未经证实的权重排序。

## 冻结证据

七段新函数及 float32 数据与保留 `v2.1.7` 发布库一致。导出入口现覆盖 `253` 个区域，JNI 参数、虚表 slot 和日期偏移锚点通过。

- `work/native-rewrite/ghidra/duplicate-compact-{jni,accessor,model}/`
- `work/native-rewrite/ghidra/compact-selection/`
- `work/native-rewrite/restart-v217/native-duplicate-compact-comparison.json`

下一步沿选择函数的记录遍历、比较器和删除入口恢复真实 compact。已完成的复制和保存模型流程继续沿用，不用实现外观代替候选选择证据。未执行原 ARM64、用户词典或设备操作。
