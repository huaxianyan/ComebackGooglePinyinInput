# 用户词典完整内存镜像

## 已恢复的后端范围

完整镜像已支持 MutableDictionary 六子模型和 SingleTrieMutableDictionary 三组件。原 Java 默认词典选择 SingleTrieUserDictionary，依据见 [默认类型取证](legacy-single-trie-initialization.md)。

[具体后端选择](user-dictionary-backend-selection.md) 由调用方类型指定，两个后端共用外层镜像、复制及文件入口。SingleTrie 已覆盖真实空存储初始化、完整文件、[新增、已有更新与节点修复](single-trie-association-create.md) 及 [物理关联删除](single-trie-association-delete.md)。上层删除策略、学习、原运行时工厂及生命周期仍未接通，默认 Android 词典尚未完整恢复。

## 格式与所有权

[user_dictionary_image.h](../../research/native-rewrite/recovered/user_dictionary_image.h) 和 `.cc` 组合当前格式的完整字节流：

```text
十六字节文件头，当前 writer 固定 3.1
外层 UserDictionaryMetaData 的长度前缀与对齐段
调用方选定的 MutableDictionary 或 SingleTrieMutableDictionary 容器
容器末尾的八字节对齐 padding
```

文件头继续使用原 CRC32。当前 major、minor 移到 `dictionary_header.h` 的单一定义点，文件头写入和完整镜像的版本判断共用，不另写一份版本常量。

`UserDictionaryStorage<Backend>` 拥有外层元数据与调用方选定的可变词典。外层累计频率和内部关系数量属于不同业务字段，底层关联编辑不会自动维护外层学习累计。完整学习协调器尚未恢复，本 codec 只保真保存调用方提供的两个对象。

当前只读取 major `3` 的完整格式。底层文件头组件仍能识别旧版本，但这里没有旧元数据转换、旧后端或静默升级。minor 按原入口读取，不单独拒绝，保存仍由原当前 writer 写成 `3.1`。

## 读取检查

原 `0x1a2b38` 在读取文件头、外层消息和可变词典后继续检查：

1. 子容器的实际消耗量与按文件头计算的序列化尺寸一致。
2. 对齐后的完整范围处于输入区域内。
3. 通过可变词典虚表 `+0xb8` 取得的 payload 宽度为六。
4. 编辑器成功建立后，才向外发布。

六子模型的第 1 项由 `0x1c6994` 实现，SingleTrie 对应 `0x1c9e30`。当前 proto 格式使用消息规范尺寸及所选子模型尺寸，旧格式分支使用 `24` 字节元数据。`0x1c37c0` 读取内部元数据第 1 字段，实际入口在 `0x1a2f7c` 比较六字节。源码复用 `payload_codec.h` 的 `kPayloadSize`，没有第二个宽度定义。

`0x1a3c9c` 用局部元数据与局部后端接收结果，成功后统一替换原对象。源码也先在局部拥有对象中完成校验，解析或格式检查失败保留先前对象。

本层发布镜像数据，不创建原持久编辑器。调用方按既有接口重建 borrowed view，六子模型测试继续走实际编辑路径，SingleTrie 已覆盖空初始化、文件流程、新增、已有更新、节点修复和物理关联删除，尚未恢复上层删除策略与学习。原编辑器创建失败和分配故障尚未覆盖，不宣称完整 UserDictionary 实例已恢复。

返回值是实际消耗长度，允许父流还有后续字节，与原 chunk 入口一致。它不是磁盘文件长度或文件系统提交成功的证明。

## 尺寸检查的成本边界

规范尺寸由选定后端 writer 的计数 sink 取得，与内存和真实文件共用格式定义。已取消最初的完整子容器临时副本，但子表和 trie 编码仍会分配并计算 CRC。原实现直接求尺寸，开销仍不等价。

这一额外成本在源码和此处明确申报，不包装成无分配读取。原 stream 的部分 I/O、OOM 步骤、所有分配异常和性能尚未验收。

## 验证

延伸既有 `mutable_dictionary_image_test.cc` 的同一条流程，复用六子模型及编辑依赖，不新增一份相同 fixture。官方生成源码现需同时生成两类元数据，共用编译入口见 [可变词典镜像](mutable-dictionary-image.md)。

六子模型完整镜像接入时，严格编译全部 recovered C++ 源码，扩展后的同一流程通过以下检查：

- 完整镜像匹配独立字面的 `3.1` 文件头，外层消息从偏移 `16` 开始，内部容器从偏移 `32` 开始。
- 保存、加载后通过真实关联路径取得六字节 payload，再用已有 V21 解码器读得字面计数与日期。
- 再次新增关系，显式修改外层累计与 64 位同步时间，第二代完整镜像可重新加载。
- 外层未知字段与原样扩展字节保留，内部关系数量独立保留。
- 四个冗余已知字段让内部消息的规范尺寸与消耗量不同。数据表及 CRC 完整时，原尺寸边界仍拒绝该输入并保留先前对象。
- 内部 payload 声明改为五字节后，写入保留原声明，读取按原六字节限制拒绝，先前两条关系仍可读取。

最后两项对应原入口直接依赖的冻结协议，不是为假想损坏场景新增防御规则。期望字节、位置和计数使用字面值，不用被测尺寸或编码算法计算答案。

真实 APK 出口补入两段校验函数、宽度比较和虚表锚点后通过，现导出 `238` 个区域。两段新函数与保留 `v2.1.7` 发布库字节一致。原 writer、payload loader 和成功发布入口沿用已有取证，不重建重复批次。

新增材料：

- `work/native-rewrite/ghidra/user-dictionary-image/`
- `work/native-rewrite/restart-v217/native-user-image-validation-comparison.json`

SingleTrie 外层接入的新增验证见 [后端选择](user-dictionary-backend-selection.md)，沿用初始化测试走完整文件、复制和较短覆盖流程。共用代码变更后，新旧两个流程均通过。

## 下一步

已接通 [原生文件保存入口](file-persistence.md)，通过项目目录中的实际写入、读取及较短镜像覆盖；其上的 [Java 文件替换协议](java-file-replacement.md) 也已按 DEX 重建，覆盖暂存写入、备份移动、主替换与 finally 清理的跨运行时集成流。`nativePersist` 的成功不是持久提交，进程崩溃状态与中断恢复不属于已恢复协议。

外层第 3 字段原业务含义及 string/bytes 声明仍待确认，其他后端和旧完整格式仍未恢复。本轮未执行原 ARM64，未访问设备、用户词典或正式包。
