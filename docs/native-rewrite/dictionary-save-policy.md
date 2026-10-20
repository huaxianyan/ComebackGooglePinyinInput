# 定期保存与容量整理决策

## 已恢复的纯决策

`DictionarySavePolicy.java` 从发布 DEX 的 SaveDictionaryTask 与 AbstractHmmEngineFactory 恢复三个不依赖 Android 的决策：

- 准入：该 factory 没有正在运行的任务，且 `Math.abs(now - lastSave) > 14400000L`。阈值是四小时，严格大于；保留 Java long 运算和墙钟差值，不改成单调时钟。
- 时间键：`save_dict_time_` 加 factory 的简单类名。调用方仍负责读取原偏好和传入时间，没有另建状态副本。
- 整理目标：用户词典容量 `500000`，新词词典容量 `10000`，先转 double、乘字面 `0.9d`，再转 int。对应目标分别为 `450000`、`9000`。

这些值在 recovered 源码中各有一个定义点。它们是策略模块，不会自行启动任务、压缩模型或写偏好。

## 已核实的原调用流程

SaveDictionaryTask 的任务顺序是新词词典、用户词典，不是每个 factory 五种词典。每种词典先检查文件名，创建 DictionaryAccessor，再 duplicate；失败时关闭并跳过。成功后 compact、persist、通知变化，最后关闭。

原流程没有按 persist 的 boolean 决定通知或记录时间。即使某次保存返回 false，只要流程没有抛异常，整批结束后仍写当前时间。源码恢复不得悄悄把它变成「只有成功才记录」。

普通定时任务先检查运行集合与时间，加入集合后提交 AsyncTask，完成回调移除。强制保存直接调用 saveDictionaries。发布版额外用一个类共享的 sSaveLock 包住整批执行，见 `scripts/apply_patches.py`；锁不在运行集合判断外层。

此处只核实调用顺序，尚未实现完整任务类。没有用空 compact、假 duplicate、临时执行器或模拟成功补齐原 backend。

## 证据与验证

- 发布 DEX：`work/native-rewrite/restart-v217/smali-save-task/` 下的 SaveDictionaryTask 和 AbstractHmmEngineFactory。
- 原 Java 视图：`work/native-rewrite/original-apk/rea-save-task/`，只作定位辅助。
- 模块测试：`DictionarySavePolicyTest.java`，期望阈值、键和目标均为独立字面值。
- Windows JDK 17 以 `-Xlint:all -Werror` 编译，通过准入边界、正在运行、未来墙钟、原时间键与两个整理目标检查。

本阶段仅执行这个新增模块测试，没有重跑已经通过的 C++ 编译与文件集成流。未操作设备、偏好、用户词典或在线账户。

## 后续实现边界

下一步沿 `nativeDuplicateDictionary(J)Z` 和 `nativeCompact(JI)Z` 恢复实际模型处理。完整 AsyncTask、通知、偏好适配与共享锁接入仍待实现，不把纯策略测试当作定时保存已经可运行。失效账户同步和在线词典更新继续保持关闭。
