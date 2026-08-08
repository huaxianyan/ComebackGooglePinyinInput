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
- [ ] Compose 表情/语言切换键状态机部分通过、尚未验收闭环：表情键与语言键的反向依赖、禁用时视觉取消但保留语言键持久值、关闭表情键后的恢复，以及多数布局/输入回归正常；但 Pixel 当前已启用 Gboard 等可切换 IME，MD3 页面仍错误隐藏 `switch_to_other_imes`，说明 Settings Activity 能力解析存在缺陷。另观察到表情键、语言键均关闭后再关闭英文键盘会出现一个输入法切换按钮，而正式 `v2.0.0` 不出现；需先区分该按钮属于键盘内部 globe key 还是 SystemUI 导航栏 IME picker，再定位修复
- [ ] 记录 target 36 既有设置回归：`switch_to_other_imes` 行在 target 28 可见，升级后已保存值仍继续生效；target 36 设置页不再提供该行，因此无法修改。暂不回补已发布的 target 36 release，必须在 MD3 新 release 路由启用前恢复可见性和可修改性，并验证新装、升级保留值及开/关两条路径

## 测试约定

- 编码代理负责构建、签名和安装 APK；功能验证、真机操作检查和回归测试由项目维护者执行。

## 已完成

- [x] 适配 Android 16 浅色和深色导航栏
- [x] 消除 Android 16 的旧版应用提示
- [x] 修复手写首次落笔崩溃
- [x] 修复手写识别正常但笔迹不可见
- [x] 在 Pixel 10 Pro / Android 16 上验证手写显示、识别与候选上屏
