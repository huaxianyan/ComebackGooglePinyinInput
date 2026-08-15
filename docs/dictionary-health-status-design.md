# 用户词库状态按需检查设计

## 目标

在「词典」设置页的用户词典/本地备份区域显示一份只读状态快照，让用户不必先导出 UTF-16LE 备份文件，也能通过词条数、主文件、滚动副本和恢复旁路判断当前词库是否大致健康。

这不是完整的二进制修复或离线校验工具，也不改变现有词典内容、学习权重、导入导出格式和恢复顺序。

## 启动边界

状态检查严格由 `DictionarySettingsFragment` 页面中的 `DictionaryAutoBackupSettingsCompat.Controller.bind()` 触发：

- 应用、IME 服务和键盘启动时不扫描
- 不注册 Worker、Job、Alarm、BroadcastReceiver 或文件观察器
- 不写入新的状态缓存
- 离开页面后通过 generation token 丢弃迟到的 UI 回调
- 点击状态行可以手动重新检查，正在检查时忽略重复点击。

所有文件和 native accessor 查询都在单线程 IO executor 执行，结果只在主线程更新 Preference summary。

## 展示字段

状态行显示：

1. 综合状态：
   - 中文和英文 native 用户词典均可读取时显示正常
   - 存在 `_unreadable` 时提示立即备份
   - 存在 `_tmp` 时提示重启后复查
   - native 查询失败时只报告部分状态无法读取，不擅自修复或清空。
2. 词条数：
   - 中文 `user_dict_3_3`
   - 英文 `user_dict_3_3_english`
   - 两者合计。
3. 主文件大小：中文和英文分别显示 B、KB 或 MB。
4. 滚动副本：分别显示 `_bak` 是否存在及其大小。
5. 恢复旁路：统计 `_tmp` 和 `_unreadable` 数量。
6. 最近落盘时间：两个主文件 `lastModified` 的较新值。

## 词条数来源

不创建临时公共备份，也不解析用户文本。检查器复用原生导出路径所使用的两个 engine factory：

- `bdt`：中文
- `agb`：英文。

通过公开的 `AbstractHmmEngineFactory.createMutableDictionaryAccessor(USER_DICTIONARY)` 获取短生命周期 accessor，调用 `getDictionarySize()` 后立即 `close()`。这是现有 `UserDictExportTask` 创建并关闭 `DictionaryAccessor` 的同一底层机制，但不调用 `exportAllEntries()`，因此不会为大词库分配完整词条数组。

查询通过反射完成，以避免新 Java helper 对混淆类名产生编译期依赖。任何反射或 native 异常都被降级为「无法读取」，不得传播到设置页主线程。

## 一致性与安全

状态采样同步在 `SaveDictionaryTask.sSaveLock` 上，与已经加固的保存和原生导出序列化：

- 避免在 `main → _bak`、`_tmp → main` 轮换中间读取
- 文件快照和 native 词条数尽量来自同一稳定窗口
- 如果反射不到该锁，使用检查器自己的 fallback lock，但仍只读且不会触发恢复。

`_bak` 与 main 大小不同本身不是故障：滚动副本通常代表上一次成功保存。状态页只报告其存在和大小，不把「不相同」误判为损坏。

## 明确非目标

状态页不会：

- 自动备份、自动恢复或启动扫描
- 计算或上传词条内容
- 显示具体用户词语
- 修改、压缩、清空或重新保存词典
- 将安装内状态写入公共目录
- 把文件缺失单独判定为损坏（空词库可能尚未落盘）
- 替代真实导出验证、SHA-256、root 只读审计或故障注入测试。
