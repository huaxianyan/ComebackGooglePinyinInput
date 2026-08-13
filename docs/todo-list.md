# 兼容性适配 Todo List

## 当前任务：剪贴板候选

- [x] 验证原生候选栏静态原型的位置、点击上屏、英文和手写笔画兼容性
- [x] 接入动态纯文本剪贴板读取和活动输入视图期间的变更监听
- [x] 接入两分钟时效及候选点击后去重；按交互需求移除验证码提取，始终忠实粘贴完整原文
- [x] 过滤密码输入框、`disableAutoPaste`、敏感标记和非文本剪贴板
- [x] 剪贴板候选仅在无正常输入候选的空闲状态注入；输入候选活动期间完全让位，完成或取消输入后恢复
- [x] 完成长文本摘要、居中布局、圆角边框、前置剪贴板图标和 Material 凸起阴影的 Gboard 风格交互迭代
- [x] 真机验证动态剪贴板候选、完整文本上屏及点击去重
- [x] V15 真机确认最终剪贴板候选视觉和功能符合预期：最大宽度 `200dp + 2 × 21sp em`、图标距左 divider 10dp/距文字 6dp、组合居中、END ellipsis 和回收清理均正常
- [x] 验证中英文模式每次只显示一个剪贴板候选并保持居中；连续复制新内容不再保留旧兼容候选
- [ ] 验证关闭按钮反馈严格遵循按键音、振动、音量和振动时长设置
- [ ] 隔离验证候选状态机：开始输入立即隐藏剪贴板且不混入第一候选，提交/取消并回到无候选后自动恢复，输入中复制新内容不打断正常候选
- [ ] 干净安装验证：完成进入 Google 拼音设置页、不会先显示无提示默认 26 键、下一个普通文本字段首次即显示带提示的四布局 Dashboard
- [ ] 验证 IME 后台不再并发启动旧 `PermissionsActivity`，设置页内显式权限请求仍正常
- [ ] 可选：补充验证额外彩色主题下的候选文字、分隔线和关闭按钮对比度

## 当前任务：首次使用引导

- [x] 将首次使用引导页面整体更新为 Material Design 3 风格
- [x] 对照当前 Gboard，将标准完整流程收窄为“启用 → 选择 → 完成”三页
- [x] 移除“发送匿名使用情况/反馈信息”和旧权限总览页面
- [x] 统一完整引导流程，修复页面指示器先显示 2 个、重开后显示 4 个
- [x] 修正页面指示器的选中/未选中视觉状态
- [x] 优化已完成步骤的圆形勾选状态
- [x] V38 完成/第一页返回时显式回桌面；其他页面返回上一页，不再露出应用设置
- [x] V38 移除完成勾号的多余圆底；逐页返回和完成退出已通过真机验证
- [x] V39 移除 PageIndicator、禁止触摸滑页，改用上一步/下一步显式导航和完成状态门控
- [x] V40 将完成按钮统一移动到 footer 右下角的下一步位置，并通过完整三页流程真机验证
- [x] 将 `HAD_FIRST_RUN` / `USER_SELECTED_KEYBOARD` 从跨安装恢复状态中规范化，最终完成值在退出前同步持久化
- [x] 首个普通文本字段稳定显示原生四布局 Dashboard 及首次布局提示
- [x] 串行化 Settings/IME 的并发引导启动请求；静默丢弃完成后迟到的 singleTask Intent，避免重复完成页和第三方 Launcher 二次 Home 行为

## 当前任务：输入面板触摸

- [x] 调整候选与符号翻页容器，在滑动结束前发送取消事件，避免松手误选
- [x] 对照 Gboard 调查 ScrollView、分页候选、RecyclerView、ViewPager 与外层 SoftKeyboardView 的显式滚动取消协议
- [x] V32 将分页辅助类 `aws` 接入 `ScrollTouchCompat` 外层取消桥，保持原生 pager/fling 参数不变
- [x] V32 真机复测未发现误选或点击回归；候选展开与左侧竖向列表滑动正常
- [x] 将全键盘符号/表情横向 pager 手感拆分为独立任务，并对照 Gboard ViewPager2/RecyclerView 调查旧 `lk` 的 slop、25dp fling distance、minimum velocity 与 50% settle
- [x] V33 诊断确认 30 次手势的旧 25dp final-delta 全为 0，fling 分支完全不可达；21 次回弹中 16 次速度已超过 minimum
- [x] V34 真机确认单指可轻松左右翻页且无已知回归；V35 已移除临时诊断，只保留验证通过的局部 fling 修复

## 当前任务：词库持久化与恢复

- [x] 使用 root 只读导出当前私有词库，与 2026-07-22 快照逐文件比较；主文件、滚动备份和原生导出均正常
- [x] 对照当前 Gboard 复核 `DictionaryAccessor`、启动 enrollment、保存调度及 `_bak`/`_tmp` 轮换
- [x] 确认 V20 在备份加载失败后遗漏有效 `_tmp`、强制保存可与异步保存重叠、显式清除可能遗留旧备份
- [x] V41 增加 backup → tmp 的有界加载回退，串行化保存，并在明确删除/清空后清除恢复旁路文件
- [x] 完成用户词典自动备份和手动恢复：复用原生 exporter/importer，由用户选择 SAF 目录，通过 `.partial` 校验后 rename 发布并轮换版本；备份和内置导入共用该目录（见 `docs/dictionary-auto-backup-design.md`）
- [x] 使用 Google Drive 目录验证授权、立即备份和内置导入，真机测试正常
- [ ] 继续观察 Google Drive 版本轮换、离线失败和网络恢复后的重试行为
- [x] 真机验证“自选本地目录 → 立即备份 → 内置列表导入”，确认备份与导入共用自定义路径且功能正常；卸载重装后的重新授权恢复继续作为长期灾难恢复观察项
- [x] 增加按需“当前用户词库状态”设计与实现：仅进入词典设置页后异步读取中英文 native 词条数、主文件/滚动副本大小、恢复旁路和最近落盘时间（见 `docs/dictionary-health-status-design.md`）
- [ ] 在独立 `dictionarystatusaudit` 包验证空词库、已有中英文词条、有/无 `_bak`、状态行手动刷新、退出页面时迟到回调和键盘启动零扫描
- [ ] 按自然使用时间继续观察 1/3/7/14/30 天自动备份调度及保留版本轮换
- [ ] 使用独立 dictionaryaudit 包验证中断轮换、损坏备份、有效临时文件及显式清空场景

## 当前任务：既有功能基础复核

- [x] 对照 Gboard 调查系统虚拟导航键、导航栏颜色、图标明暗、divider、contrast 和 WindowInsets 处理
- [x] V27 确认标准 Drawable 读取被 Google 拼音自定义 `bam` stylesheet wrapper 阻断，所有主题实际进入 fallback
- [x] V28 读取 `bam` 当前 state 的最终 `ColorStateList`，主题名称与硬编码颜色仅保留为早期生命周期 fallback
- [x] 真机验证常用内置浅色/深色主题的导航栏颜色和虚拟键明暗
- [ ] 可选：补充验证额外彩色主题的导航栏表面和图标对比度
- [ ] 分别设计三键导航、手势导航、浮动键盘和 bottom frame 的兼容策略
- [x] 对照 Gboard 复核固定 120Hz 请求、触摸 boost、内容速度提示和设备 ARR 能力
- [x] V29 移除固定 120Hz Window/View vote，API 35+ 改用触摸动态 boost，并在 `onFinishInputView()` 对称释放
- [x] V30 交互期 Surface vote 真机无可感知改善；V31 已回滚所有帧率干预，恢复系统默认调度
- [ ] target API 与渲染路径现代化后重新实现高刷新率支持
- [x] 对照 Gboard 复核手写离屏 Bitmap/Canvas、down/move/up clip、save/restore、pressure 与 dirty-rect 路径
- [x] 真机验证 V36 手写 Canvas 整理：首笔、连续多笔、识别、笔迹显示及候选上屏
- [ ] 继续复核其他已修改功能

## 后续兼容性工作

- [ ] 清理或禁用失效的统计、Firebase 与反馈上传逻辑
- [ ] 回归测试拼音九键、拼音全键盘、英文输入和滑行输入
- [x] 移除失效的 Google 账户词典 SyncAdapter、认证 Activity、设置入口及账户/同步权限
- [x] 正式包名覆盖安装后重启，确认旧 SyncAdapter 不再注册且未再申请 Google 账户权限
- [x] 真机验证保留的本地“清除用户字典”四位确认流程及清除/恢复行为，未发现其他问题
- [x] 记录逐 target 独立分支、隔离包和完成门槛：[`target-sdk-modernization-plan.md`](target-sdk-modernization-plan.md)
- [x] `feat/target-sdk-29`：Android 10 / API 29 隔离构建、真机 ART/Root 检查和功能回归通过
- [x] `feat/target-sdk-30`：Android 11 / API 30 隔离构建、真机 ART/Root 检查、scoped storage 和功能回归通过
- [x] `feat/audit-debug-mode`：双模式云构建、签名、有效载荷一致性、正式 ID 防护、覆盖安装、数据保留、`run-as`、隐私检查和基础使用均通过
- [x] `feat/target-sdk-31`：release-like 构建、Android 12 静态门禁、首次引导、ART/Root、PendingIntent/exported、词典、主题、联系人和 Drive SAF 回归通过
- [x] `feat/target-sdk-32`：release-like 构建、首次引导、ART/Root、核心输入、手写、主题、词典、联系人和 SAF 本地备份回归通过
- [x] `feat/target-sdk-33`：release-like 构建、Android 12/13 静态门禁、首次引导、ART/Root、核心输入、主题选择器、联系人、词典和 Google Drive SAF 回归通过
- [x] `feat/target-sdk-34`：release-like 构建、Android 12/13/14 静态门禁、动态 receiver、首次引导、ART/Root、核心输入、手写、主题、联系人、词典和 Google Drive SAF 回归通过
- [x] `feat/target-sdk-35`：covering IME Window、InputView-owned 非交互底部 frame、双导航、语音往返、主题、高度、Insets 和核心功能验收通过
- [x] `feat/target-sdk-36`：V19 release-like 的首次引导、核心功能、双导航、内置/图片主题、动态图片裁剪、候选边界、ART/Crash/DropBox 和最终 Window/Insets 几何验收通过
- [x] 非正式 application ID 的审计包统一显示为“Google 拼音输入法（测试版）”，正式包名称保持不变
- [ ] 解决 `libhmm_gesture_hwr_zh.so` 的 `PT_LOAD Align 0x1000`，产出可审计的 16 KiB 兼容重链接或替代库
- [ ] 在真正的 16 KiB page-size 设备/模拟器上验证全部原生库、拼音、滑行输入和中文手写
- [ ] 调查并消除 `MetricsProcessorHelper` 的反射参数错误日志

## 当前任务：现代设置运行时

- [x] 第一批普通 Boolean 设置完成真机验收：开关、持久化、相互隔离、中文资源，以及空格滑动和英文键盘实际行为均正常
- [ ] 低优先级调查“双空格输入句号”历史失效：`v2.0.0` 正式版和 Compose 审计版均无法触发，开关持久化本身正常，因此不是现代设置迁移回归；当前阶段不修改原生输入语义
- [x] Compose 审计包英文运行时修复通过真机验收：正式 `v2.0.0` 和 fresh 非 Compose 隔离基线帮助排除 fresh data、application ID 与 audit 签名；最终定位 Compose AGP host 将原版 `ZIP_STORED` 的 `res/raw/metadata.json` 错误压缩，破坏依赖 `openRawResourceFd()` 的英文模型初始化。增加 `androidResources.noCompress += "json"` 和 APK 级 `ZIP_STORED` 门禁后，英文候选开关语义、候选关闭时独立英文滑行、手势父开关对中英文滑行的控制以及中文回归全部通过
- [x] 首个 Compose ListPreference `pinyin_scheme` 通过真机验收：官方 Material 3 单选对话框保留 String 类型、缺省 `quanpin`、七项原始顺序和本地化标签；取消不写、持久化、全拼与小鹤双拼实际输入、滑行回归均正常，`ListItem` 标题和摘要也已与同页 24 dp 内容边缘对齐
- [x] Compose 模糊拼音依赖组通过真机验收：父开关缺省关闭，详情入口随父开关禁用；详情页按原始顺序提供十二个 Material 3 Switch，保留前六项 true、后六项 false 的默认值、父关闭时保留子值且拒绝写入、显式可访问性描述、工具栏/系统 Back 和配置重建导航状态；实际模糊候选、关闭后的恢复以及全拼/小鹤双拼/中英文滑行回归均正常
- [x] Compose 键盘能力门控组通过真机验收：严格复现 `ais`——`is_tablet=true` 隐藏按键弹出和单手模式，语音按钮仅在已启用的 `com.google.android*` IME 具有 mode=`voice` 的已启用/隐式 subtype 时显示，异常时隐藏；隐藏项由 Repository 拒绝写入。单手模式保留 String `0/1/2`、默认 `0`、原始顺序和普通 SharedPreferences 通知；手机侧可见性、语音能力门控、按键弹出效果、左右/关闭三种单手布局、持久化、横竖屏几何及现有输入回归均正常。`is_tablet=true` 运行时分支仍留待后续大屏矩阵覆盖
- [x] Compose 表情/语言切换键状态机通过真机验收：表情键与语言键反向依赖、禁用时视觉取消但保留语言键持久值、关闭表情键后的恢复均正确；首版错误隐藏 `switch_to_other_imes` 已定位并通过精确 `android.view.InputMethod` intent query 修复，不申请 `QUERY_ALL_PACKAGES`。Pixel 上该行恢复可见，可正常开关和持久化，实际点击语言键时“切换到其他输入法”开/关行为均符合预期；表情键、语言键、英文键盘均关闭时，中文键盘不再错误出现内部 globe key
- [x] target 36 既有设置回归已由 MD3 路径解决：`switch_to_other_imes` 行在 target 28 可见，升级 target 36 后旧值继续生效但旧设置页无法修改；不回补已发布的 target 36 release，MD3 宿主已恢复可见性和可修改性，并通过开/关实际行为验证。正式发布前仍需在最终 application ID 上覆盖升级保留值
- [x] 确定现代设置页面层级：设置首页只提供“输入设置 / 键盘 / 词典与备份 / 其他”导航；输入设置下分常规、中文、英文，模糊拼音归属中文；键盘下分外观与布局、按键与切换、按键反馈、手写。手写不再单占首页层级，但两个 Preference 的 key、默认值、类型、预览和 Slider 语义不变
- [x] 页面层级 V1 通过真机验收：导航首页、输入/中文/英文/模糊拼音、键盘四个子页、词典与其他占位页均正常；显式 route stack 的各入口、系统/工具栏 Back、配置重建和跨页依赖无异常
- [x] 完成页面源码机械拆分：`SettingsScreen.kt` 只保留 route dispatch、Back 和顶层 Scaffold；首页、输入、键盘、手写、模糊拼音及共享组件分别归档，Verifier 禁止顶层 Screen 重新持有具体设置控件；未改变页面内容、顺序、依赖或写入语义
- [x] Compose 振动能力门控通过 Pixel 有振动器分支真机验收：严格保持旧 `ais.c(Context)` 的“存在 `Vibrator` 且 `hasVibrator()` 为 true”条件，API 35+ 使用 typed system service；两行可见性、开关依赖、显式值保留、预览、恢复系统默认及声音设置隔离均正常。无振动器时同时隐藏两行、保留值并由 Repository 拒绝三条写入，纯逻辑四种真值组合已覆盖；无振动器运行时分支留待后续设备矩阵
- [x] Compose 主题导航及 target 36 系统栏几何通过真机验收：入口、当前主题、内置/图片主题、Builder/Editor、返回与键盘实际主题行为均与 release 正常；旧无 ActionBar `ThemeSelectorActivity` 顶部遮挡由动态 system-bars Insets listener 修复，顶部/底部、横竖屏、返回和主题行为均无回归，不硬编码高度、不消费 Insets、不使用 edge-to-edge opt-out
- [x] Compose“显示启动器图标”通过真机验收：保留 key=`show_launcher_icon`、Boolean 类型和 absence 状态；缺省值严格复现 `LauncherIconVisibilityInitializer`——system/updated-system app 缺省隐藏，普通侧载包采用 `@bool/show_launcher_icon`。关闭/持久化/重新开启、旧 `LauncherActivity` 图标消失与恢复、审计 launcher 独立保留、旧入口启动、IME 和主题隔离均正常；最终公开 package 查询确认正式组件与审计组件均 enabled，默认 IME 未改变
- [x] Compose“词典与备份”基础能力通过 Pixel 真机验收：只读健康状态继续调用现有异步 inspector；SAF 目录必须取得持久读写授权并通过现有 create/read/rename/delete 验证后才提交；自动备份开关、Int 间隔 `1/3/7/14/30`、Int 保留数 `3/5/10/20/30`、立即备份和导入继续委托原生 exporter/importer 与合并语义；自定义短语保留 Boolean 默认 true 和编辑器依赖。维护者额外验证 Google Drive 目录上的备份和合并导入正常。旧 Fragment 跳转曾作为联系人建议和清除词典的过渡实现，现已由下述当前页 Compose 流程替代；API 17–34 的旧 Fragment 仍保持不变
- [x] “其他 → 关于”Compose 子页通过真机验收：复用旧 `tos_url` / `privacy_url`、现有 `UnquantumLicenseMenuActivity` 和当前 package version；工具栏/系统 Back、浏览器解析和许可证页面正常
- [x] 最终验收产物 `work/modern-settings-dictionary-about-v3.apk`（SHA-256 `b7b911a9e7a37a6a120a55d732371b7013482275847d9ea15d2f7342f91346cb`，29,835,596 bytes）：双构建逐字节一致；46 项单元测试、6,633/6,633 旧资源 ID、API 31/33/34/35/36、v1/v2/v3 签名、16 KiB ZIP alignment 和英文 raw `ZIP_STORED` 门禁通过。设备覆盖安装后默认输入法保持该审计包，当前进程 PID 与 V2 历史崩溃 PID 不同且没有新增 crash/ANR/VerifyError；清除用户字典仍需独立 `dictionaryaudit` 与破坏性测试授权
- [x] API 35+ 正式设置路由通过真机验收：旧 `SettingsActivity` 仅以字符串类名启动 `ModernSettingsActivity`，API 17–34 不解析 Compose 类型；词典旧操作携带精确旁路参数避免循环。普通启动器、系统设置入口、旧词典页和 Back 返回均正常。最终 application ID 使用正式签名覆盖已发布 `v2.0.0` 的安装测试确认数据和 `switch_to_other_imes` 继承正常；该设备安装测试不等于发布，新版本号和 Release 尚未创建
- [x] 词典页滚动锚点抖动已定位并通过隔离 release-like 审计包验收：120 Hz Perfetto 证明中文输入稳定 116–120 fps、词典纯滚动 1,989/1,993 帧按时呈现，问题不是 GPU 或全局 LazyColumn 吞吐；健康首项离屏重入时重复执行 `LaunchedEffect(Unit)`，并在单行加载状态与多行摘要间改变高度，触发 LazyColumn 锚点反复修正。健康状态现提升到 Activity、保留旧摘要、拒绝并发加载，词典项增加稳定 key/contentType。`work/modern-settings-dictionary-scroll-fix-v1.apk`（SHA-256 `4debf048d9c20f7d6dd6ddaf1ba87c4b53170e30f606995204aff205116a2f8f`，27,509,157 bytes）双构建逐字节一致、49 项单元测试和全部现有门禁通过；维护者确认抖动与不流畅感均未复现，修复后 P90/P95 为 5/6 ms、Missed Vsync=0。正式 ID 安装仍是修复前候选，本轮未覆盖正式包
- [x] 显示与可访问性矩阵通过 Pixel 10 Pro 真机验收：动态深/浅色、横屏 `918x411dp`、分屏 `411x411dp`/`sw349dp`、`fontScale=2.0`、最大显示 `320x714dp` 及二者组合均无裁切、重叠、不可达内容、状态丢失或滚动回归。TalkBack 首轮发现视觉标题未标记相邻 Switch，修复为整行合并的 `Role.Switch`/`toggleable` 语义，视觉 Switch 移除重复回调；复测完整朗读状态、标题、说明、角色和操作，首页焦点、Slider、禁用项、对话框及 Back 均通过。原应用继续不声明全局 `supportsRtl=true`，避免镜像 API 17–34 和原生 IME；仅 `ModernSettingsActivity` 从 `Configuration.layoutDirection` 提供 `LocalLayoutDirection`。强制 RTL 首轮复现全局配置已 RTL 但 Compose 仍 LTR，隔离修复后首页/Back、Switch、Slider、对话框、关于与词典正确镜像，恢复 LTR 后正常。最终审计包 `work/modern-settings-rtl-v1.apk`（SHA-256 `5d9a6a3cdbc567e6c674875622a90b08a7f7fa04f8ad6d77da916076a002d0c4`，27,513,253 bytes）双构建逐字节一致、51 项单元测试、6,633/6,633 旧资源 ID、API 31/33/34/35/36、v1/v2/v3 签名和 16 KiB ZIP alignment 门禁通过；正式 ID 未覆盖
- [x] 运行时能力与旧设置路由完成当前环境可达到的矩阵：API 36 translated x86_64 在 `sw411dp` 解析 `is_tablet=false`，在 `sw720dp` 解析 `is_tablet=true`；popup、单手和 emoji 切换可见性同步由 true 变 false，Compose Activity 在 tablet 配置下完成 ART 启动。真机和 Emulator 均有振动器；JVM 与设备 ART 分支注入确认 service 缺失或 `hasVibrator=false` 时振动控件均不可见，但明确不描述成真实无振动器硬件验收。未经修改的 ARM64 审计 APK 在 API 34 x86_64 native translation 上安装并由同包 instrumentation 成功启动旧 `SettingsActivity`，无 VerifyError/AndroidX 启动错误。API 23 x86_64 无翻译而报 `INSTALL_FAILED_NO_MATCHING_ABIS`；删除 native 会在 `PinyinApp` 查 ZIP entry 时失败，伪装 x86 路径会被 linker 以 `unexpected e_machine: 183` 正确拒绝；官方 Emulator 又拒绝在 x86_64 主机运行 API 23 ARM64 AVD，故 API 23 仍为环境阻塞。Manifest 虽声明 minSdk 17，但 APK 仅含 ARM64，而 Android API 21 前不存在 ARM64 应用 ABI，因此 API 17 是静态门禁而非可实现的运行时验收
- [x] 最新 release-like ARM64 审计包完成 Pixel 10 Pro 核心 IME 回归：中文全拼、首选/非首选候选、删除重输、展开候选与翻页、中英文切换、英文建议/空格/大小写、中文滑行、手写、符号/Emoji/剪贴板候选均正常；主题选择与恢复、键盘高度、声音/振动默认和自定义预览、单手模式、语言/Emoji/其他输入法往返及专用页面 Back 均正常；语音输入往返、锁屏解锁、手势/三按钮导航、Home/Back/Recents、横竖屏和输入法切换后的首次显示均正常。默认输入法保持审计包，测试前后进程 PID `6729` 持续存活，最终 crash buffer 为 0 行，无新增 crash/ANR/VerifyError/IllegalAccessError。测试使用隔离 ID，不代表正式 ID 安装或发布
- [x] fresh-install 首次引导的未完成 Back 路径通过 Pixel 真机验收：API 35+ 启动器入口先执行首次引导门禁，再进入 Compose 设置路由；一次性迁移快照只信任启动引导前已存在的 `HAD_FIRST_RUN`，引导基类在打开时写入的临时遗留标记不会再被误认为完成。首次打开、Back 回桌面、再次打开仍显示同一单页引导，只有“完成”可写 `guide_complete`。API 35+ 页面改用与 Compose `dynamicLightColorScheme` / `dynamicDarkColorScheme` 对应的系统 tonal palette，步骤操作使用 40 dp tonal button，完成操作保留 filled primary；维护者确认卡片、按钮和配色达到预期。验收包 `work/modern-settings-fresh-install-v6.apk`（SHA-256 `73d2a5d9c72c0795b9e94f386fe3c539f185e61009403bc26b4c8e447db51cfb`，27,513,436 bytes）。完整终态也已通过：第一项完成后第二项正确解锁，两项完成后“完成”按钮正确启用；完成操作原子记录状态并进入 Compose MD3 设置首页，退出后再次点击启动器直接进入设置，不再显示引导，未发现重复引导、旧设置页闪现或路由循环。最终审计进程 PID `3469` 存活并成为默认 IME，crash buffer 为 0 行，无匹配的 crash/ANR/VerifyError/IllegalAccessError/NoClassDefFoundError，`ApplicationExitInfo` 无记录
- [x] Compose 页面动画与当前页词典导入通过 Pixel 真机验收：saveable route stack 增加方向感知的轻量滑动/淡入过渡，Toolbar Back 和系统 Back 反向返回，RTL 方向由 `LocalLayoutDirection` 决定；V1 因动画容器透明而在深色主题滑动间隙暴露白色 Window，V2 固定绘制动态 Material surface 并裁剪边界后不再闪白。词典备份列表不再启动新的 `LocalBackupImportActivity`，改为当前 `ModernSettingsActivity` 内的 MD3 列表与合并确认；primary DEX 只公开异步 SAF 列表元数据和既有 native import 入口，文件管理器 VIEW/SEND、备份筛选排序、原生合并任务和结果提示保持不变。V1 的不透明 `ListItem surface` 在对话框内形成第二层黑色矩形，V2 改为透明列表项后只保留外层 Dialog surface。维护者确认前进/返回动画、列表显示、选择与确认均正常，并实际完成一次合并导入，词典健康状态可刷新。最终 `work/modern-settings-inline-import-animation-v2.apk`（SHA-256 `773def80e30ac4315687b7cf8d3898d9d8d3ca124baad6b64d31758f5488a14e`，27,525,724 bytes）双构建逐字节一致，54 项单元测试、6,633/6,633 旧资源 ID、API 31/33/34/35/36、v1/v2/v3 签名及 16 KiB ZIP alignment 门禁通过；安装 APK 与设备 `base.apk` 一致。最终进程 PID `14784` 存活且仍为默认 IME，crash buffer 与错误匹配均为 0；两条 `ApplicationExitInfo` 均为本轮覆盖安装产生的 `PACKAGE UPDATED`，无 crash/ANR
- [x] Compose 按键反馈的直接调整交互通过 Pixel 真机验收：音量和振动 Slider 在 key 缺失时仍保持可操作，左端仅作为“系统默认”的 UI 占位且不伪造数值；移除“设置自定义值 / 取消 / 应用”，拖动期间只更新暂态，松手写入一次并立即执行一次预览，加减按钮每次提交一次；显式 `0` 继续与 key 缺失区分，“使用系统默认”仅在发生调整或存在显式值时启用，点击后删除 key、回到左端并恢复“系统默认”。维护者确认交互形式、振动预览和实际振动均正确；声音首轮无预览且实际按键静音，设备证据确认 `sound_effects_enabled=1`、`STREAM_SYSTEM` 音量为 7/7，但 `ZEN_MODE_IMPORTANT_INTERRUPTIONS` 将 `STREAM_SYSTEM` 标记为 muted，关闭系统勿扰模式后声音预览、音量调整和实际按键声全部正常，因此不绕过系统静音策略。最终 `work/modern-settings-direct-feedback-v3.apk`（SHA-256 `a418142778c573b899de91c7ffcb67a7f8633420bccef9e7fc0191c4e18a9b20`，27,521,628 bytes）双构建逐字节一致，55 项单元测试、6,633/6,633 旧资源 ID、API 31/33/34/35/36、v1/v2/v3 签名和 16 KiB ZIP alignment 门禁通过；安装 `base.apk` 一致。最终进程 PID `20866` 存活且仍为默认 IME，crash buffer 与错误匹配均为 0；`ApplicationExitInfo` 只有覆盖安装产生的 `PACKAGE UPDATED`，无 crash/ANR
- [x] API 35+ 词典页已实现原生 Compose 联系人建议授权和清除用户词典呈现，不再跳转旧设置：Activity 持有权限结果与任务回调，随机四位码确认在精确匹配前不能启动，进行中拒绝并发并在重建后重新挂接；primary-DEX `DictionaryOperationsCompat` 只读写原 `import_user_contacts` 契约并复用 `bdz`/`UserDictClearTask`，不暴露联系人或词典正文，且在清除前强制关闭已移除的账户同步。Activity 销毁与重建间完成的结果由 bridge 保留并只投递一次；进程重建不会隐式重试破坏性操作。60 项单元测试通过；API 34 translated-ARM64 instrumentation 确认旧 `SettingsActivity` 继续启动，新桥在无联系人权限时拒绝启用、允许关闭且清除状态为空闲；API 36 ART 非破坏性注入确认待投递结果重挂接只回调一次。已验收的隔离 `dictionaryaudit` 构建曾被错误标为临时 `3.0.0`/`4520386`；该版本号不用于正式候选，最终已按维护者指定纠正为 `2.0.1`，代码与验收内容不变。维护者随后在正式候选中自行完成“先备份 → 清除 → 健康状态归零 → 导入 → 恢复到清除前状态”的破坏性闭环，未发现清除、状态刷新或原生合并导入问题
- [x] Release workflow 已切换为现代 Compose host 构建，版本身份集中到 `version.properties`（候选 `2.0.1` / `4520386`），Tag 必须精确匹配版本；Artifact/Release 文件名与说明动态派生，并加入 Compose 测试、最终 APK 静态门禁、6,633 资源 ID、签名、16 KiB alignment 和双构建一致性检查。手动 Actions run `31328675084` 全部门禁通过并只生成 Artifact（未创建 Tag/Release）；该 run 产出的误标 `3.0.0` 正式 ID Artifact 已作废且从未安装，不得发布。纠正后的 Actions run `31346688976` 从提交 `13a6e5e` 构建 `2.0.1` 正式候选并通过全部门禁与双构建一致性；APK 为 27,538,012 bytes、SHA-256 `04ac65d08e10769b50648248c0e052db94c7fa3ee7d98ceb08ff678dd7c8063d`，正式证书 SHA-256 保持 `985CBF843A362169B129AEAC5E153D13095F0923231936D1486A20C8332CDE2F`
- [x] Pixel 10 Pro / Android 16 已验收 API 35+ 词典操作的非破坏性矩阵：联系人权限拒绝/授权及开关状态、清除确认错误码、取消、Back、旋转重建和当前页 MD3 呈现均正常，全程未跳转旧 Preference 页面，未读取联系人正文，也未启动真实词典清除。审计进程 PID `6621` 存活，正式包仍是默认输入法；package crash buffer 和 crash/ANR/VerifyError/IllegalAccessError/NoClassDefFoundError 匹配均为 0
- [x] 真实词典清除与恢复已由维护者主动完成：清除前先备份，清除后聚合健康状态显示为零，重新导入后恢复到清除前可见状态；助手未读取、记录或比较任何词条正文
- [x] 经维护者明确授权，正式签名 `2.0.1` 已从 `2.0.0` 覆盖安装到 Pixel 10 Pro：`versionCode` 从 `4520385` 升至 `4520386`，默认输入法保持正式 `PinyinIME`，升级后启动器直接路由 Compose `ModernSettingsActivity` 而未重入首次引导；设备 `base.apk` 与 Actions Artifact 逐字节一致，审计包已卸载
- [x] 正式 ID 候选已完成一轮简单功能测试，未发现功能问题；词典备份、真实清除、健康归零和恢复闭环通过
- [x] 设置首页正式文案已改为“Google 拼音输入法设置”（英文为 “Google Pinyin Input settings”），并移除已经完成使命的“官方 Compose Material 3 · 分阶段写入验证”说明；Verifier 禁止该验证文案重新进入正式首页。完整隔离构建、60 项单元测试、6,633 资源 ID 和 API 31/33/34/35/36 门禁通过，未覆盖当前正式候选，仍不发布并等待下一项计划功能
- [x] 正式 `v2.0.1` 已创建签名 Tag 和 GitHub Release；Release APK 与 Actions Artifact、设备安装 `base.apk` 逐字节一致，SHA-256 为 `09061687ca67cce5879323207d2b876d90a00bbd621d96167ce9ae695ae95b1c`，正式签名身份、v1/v2/v3 和 16 KiB ZIP alignment 复核通过
- [x] 统一键盘 Header 与敏感剪贴板候选已在隔离分支完成全键盘、浅色/深色、密码/PIN 脱敏、完整 payload 提交、关闭和无崩溃验收；提交 `8902e1f` 的 Actions run `31414951727` 全部门禁通过且只生成 Artifact
- [x] `v2.0.2` 正式候选由 `master` Actions run `31418998015` 从提交 `39510e5` 完整构建：Compose 测试、API 31/33/34/35/36、统一 Header、敏感剪贴板、6,633 旧资源 ID、v1/v2/v3、正式证书、16 KiB ZIP alignment 和双构建一致性全部通过。APK 为 27,550,386 bytes，SHA-256 为 `c94a12a4ea3e1f06f49dd91f127b64f02da44a5d8d3577f3db6706022026a9a9`；正式包已从 `2.0.1` 覆盖安装到 Pixel 10 Pro，默认输入法保持正式 `PinyinIME`，设备 `base.apk` 与 Artifact 逐字节一致，`headeraudit` 和敏感剪贴板测试器已卸载
- [x] 完成 Android 官方 Inline Suggestions协议、Gboard `17.8.4` 当前公开 APK及 HeliBoard/FlorisBoard/AnySoftKeyboard 的静态交叉研究，形成 `docs/gboard-inline-autofill-research.md`；确认 IME只声明 presentation spec并托管远端 `InlineContentView`，看不到或提交 Autofill payload，现有统一 Header需增加独立 Surface裁剪 host而不能把 Autofill转换成原生文字 Candidate
- [x] `feat/inline-autofill` 阶段 A：声明标准 Inline Suggestions能力，建立 API 30+窄桥和独立 `InlineAutofillCompat`，请求3个有界 presentation spec且最多3项建议；尚无 Surface host时不读取 response数量、元数据或正文，只推进 generation并返回未处理。输入视图开始/结束及服务销毁均使 generation失效；源码编译、最终 DEX窄桥、API 17–29 SDK门控和隐私边界已加入静态门禁。提交 `10e45f5` 的 Actions run `31454668628` 已通过 Compose测试、API 31/33/34/35/36、6,633旧资源 ID、签名、16 KiB alignment和双构建一致性门禁，仅上传隔离 Artifact，未创建 Release
- [x] `feat/inline-autofill` 阶段 A 的 API 36 运行时协议验收完成：标准 Framework request/response、Bitwarden 与合成 Provider 的 Inline Surface、Framework-owned click 及空 response/session 失效均正常。API 17–29 旧 ART 运行时仍受 ARM64 ABI/当前模拟环境限制，只保留静态门禁，不能描述成运行时通过
- [x] `feat/inline-autofill` 阶段 B实现：独立 API中立 Header ClipHost托管横向远端 View；最多3项异步 inflate按 provider索引聚合，具备 generation/会话/Header身份校验、1.2秒超时及 null/异常/重复 callback处理；layout/scroll/attach/detach均显式更新或释放 remote View clip bounds。表现层优先级为原生 Candidate > Inline Autofill > 空闲剪贴板，不改变 Body键、密码预测/学习语义、Candidate/剪贴板数据模型或 touch exploration声明。提交 `d09ee44` 的 Actions run `31459097182` 已通过 Compose、API 31/33/34/35/36、Inline专用门禁、6,633旧资源 ID、签名、16 KiB alignment和双构建一致性检查，只生成隔离 Artifact
- [x] `feat/header-platform` 完成阶段 B 及平台化真机验收：Pixel 10 Pro / API 36 验证 0/1/多项、Framework 点击填充、稳定 rails、局部坐标 Surface 裁剪、字段/网页/Header/方向切换、Clipboard Candidate 接管与恢复、Bitwarden 解锁/认证 Activity 往返、主题和完整 Compose 组合包；诊断不采集凭据、Clipboard/Candidate/Provider 正文。详见 `docs/header-platform-runtime-acceptance.md`
- [ ] Inline Autofill TalkBack touch-exploration 独立验收；完成前继续不声明 `supportsInlineSuggestionsWithTouchExploration`
- [ ] 在可用 ARM64 API 17–29 环境补做旧 ART 启动；当前 API 17 静态-only、API 23 环境阻塞结论保持不变

## 测试约定

- 编码代理负责构建、签名和安装 APK；功能验证、真机操作检查和回归测试由项目维护者执行。

## 已完成

- [x] 适配 Android 16 浅色和深色导航栏
- [x] 消除 Android 16 的旧版应用提示
- [x] 修复手写首次落笔崩溃
- [x] 修复手写识别正常但笔迹不可见
- [x] 在 Pixel 10 Pro / Android 16 上验证手写显示、识别与候选上屏
