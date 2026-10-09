# Header 快捷入口动画高刷体验实现

实现位于 `fix/header-shortcut-frame-rate`，暂不合入主线或发布。

## 实现边界

`HeaderMotionTargetSource` 由原生 `SoftKeyView` 和 `AccessPointsBar` 实现，提供按键本体、原生内容容器、文字与图标，以及快捷条拥有的直接运动承载层。不递归遍历任意后代，不读取文字正文。快捷条缓存通过原生 `Lkx.b(I)` 只读取值，不调用会移除条目的 `c(I)`，静态门禁锁定这一边界。

仅对文字与图标的 5 个目标请求 HIGH，仍未稳定改善收起帧率。补齐原生 chrome 与运动承载层后，本轮布局共收集 18 个去重目标。集合来自明确的 renderer 所有权，不宣称每个目标都已分别证明不可省略。

`HeaderMotionCoordinator` 注册到现有 Header module registry，由输入法服务持有。展开绑定完整 300 ms AnimatorSet，收起绑定原生 200 ms 动画，时长、插值、可见性和业务回调不变。API 36 以下不启动运动请求，API 36 复用既有 HIGH／NO_PREFERENCE 桥。结束、取消、替换、Header 失效、主题变化、输入结束及 detach 均设有释放路径，窗口隐藏由平台宿主转交释放。

平台与 Clipboard 的 Smali 改为一次编译生成，不再保留第二套 Clipboard 生成入口。编译时的桥签名 stub 不进入 APK，生成器与宿主测试复用同一份 frame-rate binding stub。

## 验证强度

API 36 真机通过原生菜单入口完成一组正常展开／收起，并在动画开始后 40 ms 分别触发原生取消和输入法窗口隐藏。最终一轮 UI 帧间隔中位数为展开 8.336 ms、收起 8.335 ms。18 个目标开始时均为 HIGH，正常结束、取消和窗口隐藏检查时均为 NO_PREFERENCE。窗口隐藏检查在隐藏后 30 ms 执行，不以动画正常结束代替隐藏时释放的证据。

这是短时 UI 回调与公开 View 请求值验证，不是面板刷新率、长期功耗或新一轮 FrameTimeline 验证。detach、动画替换、各布局／主题及旧 API 的 ART 回归尚未分别实测，用户主观体验待验收。

从原始 APK 完整重建的非 Debug 体验版为 `2.1.5-header-animation-test.1`，使用独立包名和审计签名，不含测量探针。已通过 Header motion、候选高刷、统一 Header 和 Android 16 基线静态门禁，以及 Header 宿主契约测试。包身份、ARM64、v1/v2/v3 签名与 16 KiB ZIP alignment 已核对。

## 设备交接

体验版已安装并选为当前输入法，空白编辑器已卸载，设备推送文件已清理。正式包、正式数据与版本标签均未修改。证据在本地 `work/header-motion-fix/`，测量包只用于回归，不作为用户体验产物。

请用户感受左侧快捷入口的展开、收起与快速反复切换，并检查隐藏键盘后再次唤起、切换布局或主题后的表现。未完成用户验收前不合并、不发布。
