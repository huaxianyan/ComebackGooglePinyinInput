# Java 文件替换协议

## persist() 的两层结构

`DictionaryAccessor.persist()Z` 是文件保存的 Java 协调层，实际写文件仍是上一阶段恢复的 C++ 入口。协调层协议按原 DEX 重建，也用保留 `v2.1.7` 构建的 Smali 交叉核对：两个构建只有一处差异，残留构建把备份删除的失败分支和诊断输出换成简单 `exists()`，是否删除备份不改变返回值。清理与恢复分支完全一致。

协调步骤基于 `Context.getFileStreamPath` 解析的同一词库名：

1. 删除遗留的 `<name>_tmp`。删除失败在 try 之外直接返回 false，此时没有替换动作。
2. 通过 `MutableDictionaryAccessorInterface.persist(absolutePath)` 写 `_tmp`。这是原 nativePersist 的直写入口。
3. 若主文件存在：先删 `_bak`，删除失败即失败；否则把主文件重命名为 `_bak`。
4. 重命名 `_tmp` 到主路径；失败即失败，此时主文件可能是刚移走的 `_bak`。
5. 删除 `_bak` 的失败只记诊断，不当作保存失败。
6. `finally`：存在 `_tmp` 就删除；若 `_bak` 存在而主文件不存在，把 `_bak` 重命名回主路径。

`finally` 只保证分享运行期可见的清理与恢复步骤，不承诺进程被杀时的磁盘状态。原协调层与原 native 样例都没用 `fsync`，保存成功不等于持久提交。

恢复的实现是 [DictionaryFilePersistence.java](../../research/native-rewrite/recovered/java/comeback/recovered/DictionaryFilePersistence.java)。它接收调用方解析的主文件对象与真实持久化操作，文件名后缀 `_bak`、`_tmp` 是原协议的一部分，不是新命名；路径解析和同步仍由调用方负责。原 `alg.b` 诊断输出没有恢复，`finally` 中恢复步骤的原生错误同样被静默忽略。

## 跨运行时集成流

文件名、绝对路径和重命名语义都来自 `java.io.File`，因此跨运行时只能用协调层构造真实状态，不能把 C++ 语义复制成第二个版本。真实 Windows JDK 与 WSL1 的集成流由 Java 门禁运行：

1. 复用既有端到端测试产出的两代完整镜像作为真实 fixture。
2. C++ 驱动只提供真实入口：`persist` 模式读取 fixture，完整解析，`PersistUserDictionaryFile` 写目标；`uninitialized` 模式显式传入空模型，验证真实序列化失败。
3. 协调层调用该真实入口完成保存、缩短重写与暂存清理。
4. 残留非空 `_tmp` 目录在 try 前返回 false，符合冻结的 DEX 边界。
5. 真实失败清理部分临时文件，`finally` 把保留的 `_bak` 还原到主路径。

这验证的是协调层集成，不是 Android savestore 的验收。没有构造 `rename` 失败或强制崩溃等危险或难再现故障。

## 验证

- [compare_persist_smali.py](../../research/native-rewrite/tools/compare_persist_smali.py) 从原始与保留构建导出同一方法，剥去寄存器、标签和行号后确认仅存那一处诊断差异。证据：`work/native-rewrite/restart-v217/java-file-policy-comparison.json`。
- Smali 全类由既有 DexInventory 导出，保存在 `work/native-rewrite/original-apk/smali-file-policy/` 与 `work/native-rewrite/restart-v217/smali-file-policy/`，保留构建的 `v2.1.7` APK 直接走同一入口。
- REA/JADX 提供的 Java 视图与 Smali 消息一致，只作为辅助：证据目录 `work/native-rewrite/original-apk/rea-file-policy/`。
- 全部 recovered C++ 严格编译一次，Java 用 Windows JDK 17 编译；每轮实际消耗数据在结束后删除，脚本本身不删除任何项目产物。

## 下一步

协调层已经确定保存协议，接下来沿 `alg`、`UserDictionaryMigrater` 或其调用方恢复学习与同步流程中的显式入口。原持久编辑器、完整学习协调器、映射读取和进程崩溃恢复仍未覆盖。本轮没有运行目标 APK、访问设备或采集用户字典。
