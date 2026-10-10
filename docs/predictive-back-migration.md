# 预测性返回迁移

## 目标与阶段

用户要求从当前主线建立独立分支实现预测性返回。分支为 `feat/predictive-back`，基底为 `91366a2`，包括已验收的手写第三版和 Native 16 KiB 改动。

第一阶段接入现代设置与主题编辑 Activity 的系统预测性返回。保留页面内部的返回顺序，不增加所有子页的跟手动画，不合入主线，不发布。首次引导及原生 IME 尚未迁移，不能把本阶段称为全应用完成。

## 接入依据

现代页面已使用官方 `ComponentActivity` 与 `androidx.activity:activity-compose:1.13.0`。设置根页面的 `BackHandler` 在有内部返回栈时才启用，根页面交由 Activity 的默认返回路径。主题编辑 Activity 使用默认返回取消编辑，成功保存仍走原来的结果回传。

官方支持在应用默认关闭时，单独给 Activity 设置 `android:enableOnBackInvokedCallback="true"`，见 [预测性返回接入指南](https://developer.android.com/guide/navigation/custom-back/predictive-back-gesture)。本阶段仅为 `ModernSettingsActivity` 与 `ModernThemeBuilderActivity` 启用该属性。

- 系统处理 Activity 之间或返回桌面的预览、取消及提交，不增加拦截默认返回的 callback。
- 内部设置子页仍由现有 AndroidX `BackHandler` 在提交时返回，不声称它们已具备手势进度驱动的页面动画。
- 首次引导的 `exitToHome()` 仍主动启动 Home 并移除任务，保留现有返回路径。它需要独立检查，不能以启用属性替代迁移。
- 应用默认 opt-out 保留，原生 IME、候选、手写及遗留入口继续原有分发，不改键盘返回顺序。
- 只在 Manifest 生成脚本定义接入 Activity 名单，成品门禁复用同一检查函数，避免维护第二份迁移名单。

`verify_target36.py` 保留原生 IME／遗留壳的检查，但不再把全部现代 Activity 描述为冻结返回。新策略接入现有 Compose 成品门禁。

## 本阶段验证

首次从原始 APK 完整重建后，成品 Manifest 策略检查通过，当时准备复用手写隔离身份，尚未安装。用户随后通知设备已远程连接，并授权清除手写测试版，因此重新构建为独立 `com.google.android.inputmethod.pinyin.predictivebacktest`，用审计设置入口直接测试现代页面，不复用旧包数据，也不主动启动或更改首次引导。

产物为 `work/predictive-back/GooglePinyin-2.1.5-predictive-back-test.1.apk`，版本名 `2.1.5-predictive-back-test.1`、versionCode `4520419`、min SDK 23、target SDK 36、ARM64、非 Debug，沿用审计签名。27,825,642 字节，独立身份版本的 SHA-256 为 `82d6a45ea2ab2dc523e0d3687a185db96d7b25f00e720a942a720a3238992314`。构建中的 v1/v2/v3 签名与 16 KiB ZIP alignment 检查通过。记录在本地 `work/predictive-back/`。

设备随后已通过远程 ADB 正常查询。前台为 Launcher，未锁屏，使用三按钮导航，默认输入法已为正式版。独立包的流式安装失败，推送安装又因连接重置失败，因此停止重复安装。失败推送的确切临时路径已清理。

已按用户授权通过 `pm uninstall` 清除手写第三版及其私有数据，设备本项目仅保留正式包，默认输入法仍为正式包。未启动新 Activity、切换导航模式或读取截图。返回提交、取消、系统预览、对话框和子页返回均未实测，旧 API ART 也未补测。没有启动额外 CI 或创建 Release。当时阻塞是安装传输失败，而非设备离线。

用户要求重试后，普通推送仍报连接重置。改用标准输入安装时出现 APK 解析失败，完整性检查发现设备收到的哈希正好等于原 APK 在第 718 字节的 `0x1A` 处截断、并按 Windows 文本模式转换后的哈希。该标准输入路径的失败有文本模式截断证据，不归为网络波动，也不解释普通推送的独立重置问题。

随后改用 Base64 文本传输，在设备端还原后核对完整 SHA-256 与本机产物一致，安装成功。只直接启动已导出的现代设置审计入口，未启动首次引导，未启用或选择审计输入法。

真实设置根页面完成边缘返回动作检查：拖回并取消后保留同一 Activity，提交后退出到原 Launcher。测试临时切换手势导航，结束恢复三按钮导航，默认输入法保持正式版。窗口输出未取得返回预览的进度或 Animator 状态，因此该检查只证明取消／提交的最终页面行为，不代替用户对系统预览动画的视觉验收。子页、对话框与主题编辑返回尚未实测。

两份明确使用过的安装临时 APK 均已删除，设备只保留正式包和独立返回测试包，手写测试包保持已卸载。证据为本地 `install-remote.json`、`runtime-result.json` 与 `cleanup-test.json`，均位于 `work/predictive-back/`。

## 下一步

1. 独立返回审计包已经安装，交由用户判断系统预览的实际观感。需要体验边缘手势时由用户选择手势导航，当前已恢复原有三按钮模式。正式包和默认输入法保持原状，首次引导不主动启动或改写。
2. 根页面提交与取消的最终行为已检查，继续补内部子页和对话框返回顺序，不能据根页面通过宣称所有返回场景通过。
3. 主题编辑取消与结果回传单独检查，测试图片仅用明确授权的素材，不改壁纸。
4. 首次引导退出路径和 IME 原生返回链作为后续阶段，先确认回调及任务语义，再决定接入，不启用全应用属性绕过这些检查。
5. 用户确认系统预览观感后再考虑合并。本分支尚未验收。
