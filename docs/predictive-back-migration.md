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

已从原始 APK 完整重建一次。成品 Manifest 策略检查通过，包名为既有隔离 ID `com.google.android.inputmethod.pinyin.handwritingtest`，避免另建需要首次引导的测试身份。正式 ID 不变，手机上的既有第三版尚未覆盖。

产物为 `work/predictive-back/GooglePinyin-2.1.5-predictive-back-test.1.apk`，版本名 `2.1.5-predictive-back-test.1`、versionCode `4520419`、min SDK 23、target SDK 36、ARM64、非 Debug，沿用审计签名。27,825,642 字节，SHA-256 `f3da4273493d65542a425277d538b56ff601f73331d6848da11b1272231f2391`。构建中的 v1/v2/v3 签名与 16 KiB ZIP alignment 检查通过。记录在本地 `work/predictive-back/`。

实机验证阻塞：本机没有目标设备，远程及备用代理路径未得到有效 ADB 连接。没有安装、启动 Activity、修改手机设置或读取截图。返回提交、取消、系统预览、对话框和子页返回均未实测，旧 API ART 也未补测。没有启动额外 CI 或创建 Release。

## 下一步

1. 设备可用后，检查前台任务和锁屏，再覆盖既有隔离身份，保留数据及默认输入法。正式包不动。
2. 经真实入口检查根页面返回的提交与取消、内部子页和对话框返回顺序。设置取消手势应停留原页，提交应退出 Activity，内部子页应只退一层。
3. 主题编辑取消与结果回传单独检查，测试图片仅用明确授权的素材，不改壁纸。
4. 首次引导退出路径和 IME 原生返回链作为后续阶段，先确认回调及任务语义，再决定接入，不启用全应用属性绕过这些检查。
5. 用户确认系统预览观感后再考虑合并。本分支尚未验收。
