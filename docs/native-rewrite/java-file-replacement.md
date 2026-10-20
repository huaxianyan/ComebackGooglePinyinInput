# Java 文件替换与启动恢复

## 发布基线修正

`e21538e` 将原始和发布构建的差异误记为「诊断分支差异」。这个结论作废：原始 APK 成功后删除 `_bak`，发布构建保留上一代词典。删除动作有数据语义，不能通过剥除寄存器和标签证明两者等价。

明确依据是 `scripts/apply_patches.py` 的 rolling-backup 补丁，以及保留 `v2.1.7` APK 的 `DictionaryAccessor.persist()`。本阶段恢复发布基线的保留行为，修正研究源码和测试，产品 APK 与现有补丁未变。

`compare_persist_smali.py` 现在只保存两份方法的哈希、原始差异和补丁出处，不改写代码后宣称等价。对应 JSON 的旧「等价」字段也已替换。

## 保存协议

[DictionaryFilePersistence.java](../../research/native-rewrite/recovered/java/comeback/recovered/DictionaryFilePersistence.java) 接收调用方解析的主路径和真实持久化操作。主路径与 `_bak`、`_tmp`、`_unreadable` 的关系只在一个 Paths 对象中定义。

1. 删除遗留 `_tmp`，失败时在 try 之外返回 false。
2. 在 try 内调用真实 C++ 入口写 `_tmp`。
3. 主文件存在时，删除旧 `_bak`，再把主文件改名为 `_bak`。任一步失败即返回 false。
4. 将 `_tmp` 改名为主文件，成功后保留 `_bak`。
5. finally 删除残留 `_tmp`。若主文件缺失而 `_bak` 存在，尝试还原。

路径解析与调用方同步仍由外层负责，原日志未复原。原 `nativePersist` 的 flush/close 返回语义见 [原生文件保存](file-persistence.md)。两次 rename 组成的流程不是整段原子事务，也没有磁盘 fsync 保证。

## 启动恢复

恢复逻辑来自现有 `patches/smali/DictionaryRecoveryCompat.smali`，并核对发布 APK 中同类的 DEX。它属于项目既有兼容修复，不是新引擎策略。

- `prepareForLoad`：主文件存在时保留原状；缺失时先尝试 `_bak`，再尝试 `_tmp`。
- `recoverAfterLoadFailure`：存在 `_bak` 时只尝试该候选，否则尝试 `_tmp`。一次调用处理一个候选，调用方负责重新加载与下一次恢复。
- 替换失败主文件时，先将其保存为 `_unreadable`。该文件已有时删除当前坏主文件，保留首次故障材料，再移动候选。
- 没有候选时，尝试归档坏主文件，返回 false。
- `purgeSidecars`：显式清理旧副本，保留主文件。普通保存仍保留上一代备份。

源码恢复保留原来的失败返回和文件操作顺序，没有新增验证器。候选内容继续由完整 C++ parser 检查。当前宿主尚未接入 Android enrollment、FileMMap 或原持久编辑器。

## 真实集成验证

同一条 Windows JDK 17 / WSL1 端到端流程使用项目内合成词典：

- 两代保存后，主文件是第二代，备份是第一代。
- try 前无法删除非空临时目录时，保持原提前返回边界。
- 空模型调用真实 C++ 序列化失败，finally 清理部分文件并还原备份。
- 重建主文件缺失状态，启动恢复优先采用备份，留下未完成的临时文件。
- 真实 parser 拒绝坏主文件和坏备份后，恢复有效临时词典，保留首次 `_unreadable`。
- 显式清理移除 sidecar，当前主词典字节保持不变。

`dictionary_persistence_driver.cc` 的 `persist`、`validate` 都使用实际完整镜像 parser；保存使用 `PersistUserDictionaryFile`。`uninitialized` 是明确的故障输入，构造未初始化模型触发真实编码失败，不是占位后端。没有断言该失败的字节前缀与原 ARM64 一致。

本阶段全部 recovered C++ 严格编译一次，Java 以 `-Xlint:all -Werror` 编译，扩展流程通过。旧的 `246` 段 native 取证直接沿用，没有重复导出。未执行 Android JNI、强制杀进程、断电或设备测试。

## 入口与材料

- 测试：`research/native-rewrite/tests/DictionaryFilePersistenceTest.java`
- C++ 驱动：`research/native-rewrite/tests/dictionary_persistence_driver.cc`
- 镜像 fixture 由既有 `mutable_dictionary_image_test.cc` 导出，消费后由本轮构建清理。
- 原始及发布 Smali：`work/native-rewrite/{original-apk,restart-v217}/smali-file-policy/`
- 差异记录：`work/native-rewrite/restart-v217/java-file-policy-comparison.json`

共用 C++ 编译命令见 [可变词典镜像](mutable-dictionary-image.md)。同一个 archive 再链接驱动，以 Windows JDK 编译 Java 协调层与测试。测试参数依次是 Windows fixture 目录、对应的 WSL 目录、WSL 驱动路径。跨 Git Bash 调用 WSL 时关闭本次调用的 MSYS 路径转换。

## 下一步

继续恢复 SaveDictionaryTask 的定期保存、容量整理和同步入口。文件状态重建覆盖启动恢复算法，不等于真实进程崩溃或设备持久性验收。原持久编辑器、完整学习协调器和映射读取仍待完成。
