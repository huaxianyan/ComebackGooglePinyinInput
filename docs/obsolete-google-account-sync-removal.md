# 旧 Google 账户词典同步移除说明

## 现象

正式版 `1.0.2` 在部分设备重启后由 Google Play 服务反复请求 Google 账户访问权。该请求与用户选择 Google Drive 作为 SAF 备份目录无关。

## 真机证据

Pixel 10 Pro / Android 16 的只读诊断显示：

- `GET_ACCOUNTS` 运行时权限未授予，AppOps 为 `ignore`；
- 当前应用没有 Google 账户 visibility/token grant；
- Android `SyncManager` 仍注册原版 `SyncService`；
- 同步类型为 `com.google`，Authority 为 `<applicationId>.user_dictionary`；
- 系统中只保留旧初始化同步记录，没有可用的现代云同步结果；
- 该记录早于 Google Drive 目录支持，排除 SAF 备份为账户请求来源。

原版链路会通过 Google Play 服务账户 Provider 枚举 `com.google` 账户，申请旧 `goopy` token，并调度 `user_dict_sync` / `delight4_user_dict_sync`。独立包名和独立签名无法继承 Google 原版授权，该远端同步也已不再适合作为维护版功能。

## 修复范围

构建补丁执行以下操作：

1. 从 Manifest 移除 `USE_CREDENTIALS`、`GET_ACCOUNTS`、`MANAGE_ACCOUNTS`、`READ_SYNC_SETTINGS` 和 `WRITE_SYNC_SETTINGS`；
2. 移除旧 `SyncService`、同步专用 `StubProvider` 和 `AndroidAccountActivity`；
3. 移除“同步用户词典”和“立即同步”入口；
4. 保留原生“清除用户字典”的四位确认流程，但只执行本机中英文词典清空，移除第二个废弃远端同步清除任务；
5. 让旧 AuthHandler 工厂固定返回空；
6. 将可能由旧安装或备份恢复的同步开关归一化为关闭，避免设置页访问已移除的 Preference；
7. 保留 `RECEIVE_BOOT_COMPLETED`，因为 Launcher 图标初始化仍使用它。

## 不受影响的功能

真实用户词典仍位于应用私有文件中，`StubProvider` 只是 Android SyncManager 所需的空壳 Authority，不参与本地词典读写。因此修复不改变：

- 中文及英文用户词典；
- 学习权重、保存、滚动副本与恢复；
- 原生导入、导出和合并语义；
- 自动备份、立即备份和版本轮换；
- 内部存储、SD 卡及 Google Drive 等 DocumentsProvider；
- SAF persisted URI grants。

Google Drive 的账户登录、上传和离线策略由 Google Drive DocumentsProvider 管理，输入法只持有用户选择目录的 URI 读写授权。
