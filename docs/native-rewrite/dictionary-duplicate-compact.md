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

原生阶段还计算日期相关的候选数量，再以数量上限确定选择区间。最终保留数量不能只用 Java 传入的容量参数推断。

## 已恢复的选择计划

`dictionary_compaction.h/.cc` 从当前 V21 payload 恢复实际比较器与堆选择，不读写词典：

1. 候选计数使用 `(count > 0 || flag31) && day >= cutoff`，日期边界含等号。
2. 比较器先区分 `count != 0 || flag31`；均为活动条目时按日期降序、flag30 优先、count 降序。原比较器不读键文本，也不以 flag27 或 category 补齐排序。
3. 数量上限为模型报告数量与 `uint64(float(limit) * 0.9f)` 的较小值，不拿成功读出的 vector 长度代替模型数量。
4. 仅在上限或候选数与模型数量不等时整理，保留数为上限与候选数的较小值。
5. 复原 `0x1a3544` 的 heap build、选择及 sort，采用 `0x1a33e4` 的相等子节点选择方式。不改用宿主 STL 的 partial_sort，以免相等条目的置换不同。

结果只有索引排列、保留前缀长度和是否需要整理。后缀保留原堆算法产生的删除顺序，不把全体候选重新排序。该结果是可验证的真实选择子模块，不宣称已经执行原 compact。

V21 解码器与 `0x1a112c` 共同确认了原记录的 count、flag31、flag30、flag27、日期和 category 字段位置。字段的业务名称仍按已知位标记表述，不猜同步含义。

模块字面测试覆盖比较优先级、含等号日期、实际选择与删除排列、相等条目的堆置换和无需整理的路径，通过严格编译。尚未接原迭代顺序、实际删除及外层计数更新，没有添加近似 compact 或空 backend。

## 冻结证据

复制与 compact 入口七段、后续选择与记录流程七段及 float32 数据均与保留 `v2.1.7` 发布库一致。导出清单现登记 `260` 个区域。静态入口门禁执行至 `258` 个区域，最后新增的堆下沉和 size getter 两段单独比较，不重复此前检查。

- `work/native-rewrite/ghidra/duplicate-compact-{jni,accessor,model}/`
- `work/native-rewrite/ghidra/compact-selection/`
- `work/native-rewrite/ghidra/compact-entry-selection/`、`compact-comparator/`、`compact-heap/`
- `work/native-rewrite/restart-v217/native-duplicate-compact-comparison.json`
- `work/native-rewrite/restart-v217/native-compact-order-comparison.json`

下一步恢复原记录遍历并连接真实删除和外层计数更新。已完成的复制和保存模型流程继续沿用，不用接口外观代替执行证据。未执行原 ARM64、用户词典或设备操作。
