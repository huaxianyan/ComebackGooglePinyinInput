# Changelog

## [Unreleased]

### Added

- 为系统标记敏感的剪贴板内容以及文本、Web、数字密码输入框增加脱敏候选粘贴：候选按原文 UTF-16 长度显示圆点并以 32 个为上限，点击仍提交完整原文，TalkBack 不朗读敏感内容。

### Changed

- 剪贴板候选的显示文本、可访问性说明、完整提交值和关闭去重标识改为相互分离；敏感原文不再进入 Candidate 对象或去重键，并在点击、关闭、剪贴板变化和 IME 停止时清除进程内引用。

## [2.0.1] - 2026-08-10

Android 15+ 设置界面改用源码构建的官方 Compose Material 3 运行时；Android 14 及更低版本继续使用原生旧版 Preference 设置。正式发布仍需完成最终真机人工验收。

### Added

- 为 API 35+ 增加官方 Material 3 分层设置首页、类型化开关/列表/Slider、可保存路由栈、页面转场、动态配色、RTL、大字体、横屏、分屏和 TalkBack 语义。
- 在现代词典页内整合 SAF 备份列表、合并导入、联系人建议授权，以及带四位随机确认码的清除用户词典流程；不跳转旧设置页，也不读取或显示联系人和词典正文。
- 增加纯 Java、primary-DEX、AndroidX-free 的窄桥接层，复用原词典导入、联系人偏好和 `UserDictClearTask` 控制器；清除任务继续强制关闭已废弃的账户同步路径。
- 增加独立“主题背景”页和“跟随主题”策略：浅色模式、深色模式、固定模式分别保存一套完整主题规格，三个槽都可使用原版完整主题选择器；系统只按深浅模式选择槽位，不替用户分类主题，开关切换不会覆盖非活动槽。

### Changed

- API 17–34 保持旧 Preference UI、键值、默认值、依赖、回调和专用页面；API 35+ 才路由到 Compose Activity，旧 ART 正常启动不解析 Compose/AndroidX 类型。
- 按键音量和振动时长改为始终可见的官方 Material 3 Slider；拖动释放时仅提交和预览一次，系统默认仍通过删除键表达，显式零值保持独立。
- 正式构建改用可复现的现代 Compose host 管线，保留全部 6,633 个旧资源 ID、primary DEX 和原生载荷，并继续验证 API 31/33/34/35/36、v1/v2/v3 签名及 16 KiB ZIP alignment。
- 正式版本身份由 `version.properties` 单一来源管理；Tag 必须精确匹配 `v$VERSION_NAME`，APK 名称和 Release 元数据不再硬编码旧版本号。

## [2.0.0] - 2026-08-06

Android 16 大版本正式基线。已验收的 target SDK 29–36 分支合并到 `master`；后续 Material You/MD3、16 KiB、预测返回和其他开发均以该基线为起点。

### Changed

- 正式开发身份更新为 Android `versionName 2.0.0`、`versionCode 4520385`、target SDK 36；application ID 和签名身份保持不变，可覆盖升级 `v1.0.3`。
- 将 target 36 V19 的 covering-IME、双导航主题延伸、动态图片裁剪和 Android 12–16 静态门禁作为新的 `master` 基线。
- 保留 API 29–36 的长期审计分支、隔离 application ID、完成门槛和历史取证；Android 17 继续作为独立调查阶段。
- GitHub Actions 增加预期 target SDK 身份检查和构建摘要，防止审计产物在目标版本不符时继续发布。
- target 29 V1 已在 Pixel 10 Pro / Android 16 完成首次引导、核心输入、手写、候选、剪贴板、主题、联系人及 SAF 备份测试；ART、DropBox、进程日志和 Root 文件检查未发现新增问题。
- 所有非正式 application ID 的后续审计包统一显示为“Google 拼音输入法（测试版）”，便于在 Launcher、应用列表和输入法选择器中与正式版区分。
- 从已验收的 target 29 里程碑创建 `feat/target-sdk-30`，第一版只启用 Android 11 / API 30 target 行为，不预先隐藏 scoped storage、Toast 或 package visibility 问题。
- target 30 V1 已在 Pixel 10 Pro / Android 16 完成功能、ART、Root、scoped storage、Google Drive SAF 和日志检查，未发现 target 30 新增回归；旧 target 29 审计包已从设备卸载。
- 按维护者要求暂停 target 31，建立与 release-like 验收分离、且禁止用于正式包的可选 debug 诊断模式。
- 新增构建期 `--debuggable`/`-Debuggable` 开关、Actions 身份保护和 `capture_audit_diagnostics.ps1`；默认不采集输入、剪贴板、联系人或词典正文。
- 基础 Debug 模式完成真机使用和隐私检查后冻结；后续默认继续使用 release-like 包，仅在普通诊断不足时启用 Debug。
- 创建 `feat/target-sdk-31`，将 target 提升到 31，为七个遗留 PendingIntent 增加 `FLAG_IMMUTABLE`，并新增 Android 12 `android:exported`/mutability 静态构建门禁。
- target 31 V1 已在 Pixel 10 Pro / Android 16 完成功能、ART、Root、PendingIntent/exported、词典、主题、联系人和 Google Drive SAF 检查；没有 crash/ANR、mutability 异常或新增回归。
- 从已验收的 target 31 创建 `feat/target-sdk-32`；V1 仅提升到 Android 12L / API 32，不预先加入 API 33+ 行为补丁。
- target 32 V1 已在 Pixel 10 Pro / Android 16 完成功能、ART、Root、手写 native、主题缓存、词典、联系人和 SAF 本地备份检查；没有 crash/ANR 或 API 32 新增回归。
- 从已验收的 target 32 创建 `feat/target-sdk-33`；V1 仅提升到 Android 13 / API 33，不增加无用途的通知或媒体权限。
- target 33 V1 已在 Pixel 10 Pro / Android 16 完成首次引导、核心输入、手写、剪贴板、主题/系统图片选择器、联系人、词典和 Google Drive SAF 回归；未请求通知或媒体权限，没有 crash/ANR、权限异常或 API 33 新增回归。
- 从已验收的 target 33 创建 `feat/target-sdk-34`；V1 提升到 Android 14 / API 34，为跨包 GServices 动态 receiver 增加 `RECEIVER_EXPORTED` 与旧系统兼容分支，并新增 receiver/动态代码静态门禁。
- target 34 V1 已在 Pixel 10 Pro / Android 16 完成首次引导、核心输入、手写、主题、联系人、词典、Google Drive SAF、ART/Root 和动态 receiver 回归；没有 crash/ANR、receiver 安全异常、动态代码错误或 API 34 新增回归。
- 从已验收的 target 34 创建 `feat/target-sdk-35`；V1 仅提升到 Android 15 / API 35，不使用 edge-to-edge opt-out，也不预先加入推测性的 Insets、TextView 或键盘布局补偿，以保留可归因的视觉基线。
- target 35 V1 真机确认首次引导页脚和 IME 底行被三键导航栏遮挡；V2 保持 edge-to-edge 开启，仅为 first-run footer/pager 与 InputView 应用 bottom inset，并用原键盘背景绘制 IME inset 区域。
- V2 复测发现 broad system-window bottom inset 在 IME 窗口产生过大黑区且最高键盘仍可被遮挡；V3 改为只读取 `WindowInsets.Type.navigationBars()`，避免混入其他 inset source。
- V3 在键盘高度调整引发的系统栏可见性过渡中会收到临时 bottom=0；V4 改用 `getInsetsIgnoringVisibility(Type.navigationBars())` 保持设备动态导航栏高度稳定，不写死像素值。

## [1.0.3] - 2026-08-01

### Fixed

- 移除已经失效的 Google 账户用户词典同步适配器、认证 Activity 和账户/同步权限，避免 Android 在重启后反复请求 Google 账户访问权；Google Drive 等 SAF 备份目录继续仅使用持久 URI 授权。
- 隐藏旧“同步用户词典”和“立即同步”，并将可能从旧版本恢复的同步开关归一化为关闭，避免设置页重新进入废弃认证路径。
- 保留原生“清除用户字典”确认流程，但只执行本机中英文词典清空、持久化、恢复旁路清理和引擎通知，不再调度废弃的远端同步清除任务。

## [1.0.2] - 2026-07-28

### Changed

- 自定义词典备份目录不再限制为设备本地 ExternalStorageProvider；Google Drive 等能通过创建、读写、重命名和删除能力验证的云端 DocumentsProvider 也可供备份与内置导入共用。
- Google Drive 目录选择、立即备份和内置导入已在 Pixel 10 Pro / Android 16 上通过真机验证。
- GitHub Release 标题改为以版本号开头，APK 及其校验文件统一采用 `ComebackGooglePinyinInput-...` 无空格连字符命名。

## [1.0.1] - 2026-07-28

### Changed

- 支持自定义用户词典备份路径；自动备份、立即备份、版本轮换和内置导入共用用户选择的设备本地目录。

## [1.0.0] - 2026-07-25

“Google 拼音输入法 创造性 AI 版”首个完整正式版本，也是提升 target API 之前当前 API 阶段的最终正式版本。Android `versionName` 为 `1.0.0`，`versionCode` 为 `4520381`，架构为 `arm64-v8a`；应用内显示名称仍保持“Google 拼音输入法”。

### Changed

- 项目中文名称定为“Google 拼音输入法 创造性 AI 版”，英文名称为 “Comeback Google Pinyin Input”；Android 应用、输入法选择器、设置页和 Launcher 的显示名称仍保持“Google 拼音输入法”。
- 正式 APK 文件名定为 `ComebackGooglePinyinInput-arm64-v8a-1.0.0.apk`，正式包名和签名身份保持不变，可覆盖此前兼容安装。
- 首次引导“完成”恢复为进入 Google 拼音设置页并结束引导，不再直接发送 HOME；返回键仍在非第一页后退一页、第一页退出软件。
- 剪贴板建议改用 Google 拼音原生候选文字样式和左右候选分隔线，移除为 Gboard 较高建议栏设计的圆角框、描边、阴影、额外高度及前置图标。
- 剪贴板建议右侧在原展开箭头位置提供关闭按钮；关闭仅屏蔽当前剪贴板项目，不清空系统剪贴板，新复制内容仍可再次建议。
- 剪贴板建议改为仅在候选空闲状态显示；中文、英文、手写等正常输入一旦产生候选就完整让位，输入完成或取消并回到无候选状态后再恢复。
- 剪贴板文字区使用左右对称的原展开按钮宽度预留位；分隔线跟随候选文本的实际宽度，短验证码不会留下过长空白。
- 剪贴板可见文字最大宽度收窄到 200dp，并禁止自动横向缩小原生 21sp 字号，超长文本改为在分隔线内省略；关闭符号颜色直接同步当前原生候选文字颜色。
- 关闭按钮复用 Google 拼音原生按键反馈控制器，遵循键盘按键音、振动、音量和振动时长设置。
- 修正短文本布局回归：左右分隔符改为候选内部两个独立分隔符，最终布局阶段强制隐藏可能重叠的原生末列分隔符。
- 不再信任兼容分隔符 XML 的静态主题解析；每轮渲染直接克隆当前已完成主题处理的原生候选分隔符 Drawable、tint、image alpha 和 View alpha，确保浅色、深色及彩色主题一致。
- 关闭键不再猜测右列宽度；每轮布局直接复制原生展开候选键的实际测量外宽。
- 分隔符主题源改为原生展开候选键中已经经过实时主题引擎处理的真实 divider，并额外复制 Drawable color filter，避免注入候选自身未进入动态主题路径。
- 关闭键不再以候选栏右边缘推算中心：QWERTY 直接读取当前可见退格键的窗口坐标，九键读取右侧光标键，必要时回退语音键，再将 `×` 的中心精确对齐到该真实按键列。
- 分隔符最终改为直接保留剪贴板 Candidate 自己的原生 `candidate_separator` 作为右边界，仅在同一候选/同一父级 alpha 层内克隆其最终 Drawable/tint/filter 到左边界，避免跨 View 层级复制透明度造成浅色、深色和彩色主题下过淡。
- 剪贴板变化时统一以 `textCandidatesUpdated(false)` 清空旧空闲候选周期后再追加唯一新项目，修复英文输入模式保留旧行并显示两个粘贴候选、从而无法居中的问题。
- 移除候选 holder 左侧人为 45dp 预留及对应 overlay；200dp 文本上限已经保证与右侧关闭键互不覆盖，全宽居中会自然留下左右空间。
- 左分隔符不再克隆再叠加 tint/alpha 状态，而是清除自身静态 tint/filter 后直接共享同一 Candidate 内右侧原生分隔符已经完成主题处理的 Drawable，消除仅左线持续过淡的问题。
- 在剪贴板候选文字前加入 18dp 剪贴板图标：复用原 Google 拼音 APK 已包含的 AppCompat Material paste glyph，不复制 Gboard 素材；按当前候选文字的实际主题色动态着色，并纳入 200dp 测量和 END ellipsis，完整提交 payload 不变。
- 修复首版图标不可见：旧 `AutoSizeTextView` 的 `onDraw()` 直接调用 `Canvas.drawText()` 而不调用 `TextView.onDraw()`，因此 compound drawable 永远不会绘制。改为真实 sibling `ImageView`，并在标签 start padding 中预留 18dp 图标加 6dp 间距；普通候选回收时隐藏图标并恢复原生 padding。
- 修复 V12 真机 ART `VerifyError`：`decorateView()` 的 `v7` 在“无右兼容分隔符”分支保留为整数，却在合流后用于 `instance-of ImageView`。新增独占引用寄存器 `v8`，并让所有分支先经过图标查找后再检查，避免任何 int/View 类型合流。
- 在已通过真机验证的图标布局上增加 4dp 左侧呼吸空间：图标距左分隔符由 6dp 调整为 10dp，同时标签 start reserve 从 24dp 调整为 28dp，保持图标与文字 6dp 间距、组合居中和当时的 200dp 总上限。
- 将剪贴板候选最大可见宽度在 200dp 基线之上增加两个当前候选文字 em（`2 × TextView.getTextSize()`）；默认 21sp/字体缩放 1.0 时约为 242dp，可多显示约两个中文字符，同时随系统字体缩放保持“两字”语义。
- 在词典设置的本地备份区域增加“当前用户词库状态”：仅进入页面或点击该行时异步读取中文/英文词条数、主文件与 `_bak` 大小、`_tmp`/`_unreadable` 旁路和最近落盘时间；不在应用或键盘启动时扫描，不显示词条内容，也不触发备份、恢复或持久化。

### Fixed

- 重写剪贴板候选视图装饰方法的 smali 寄存器分配，修复 Android ART 因引用/布尔值寄存器类型合流而拒绝整个兼容类的 `VerifyError`。
- 禁止 IME 服务从后台启动旧透明 `PermissionsActivity`；设置 Activity 内用户触发的运行时权限请求仍沿用原生路径，避免干净安装时权限页与首次引导并发抢占前台。
- 将首次引导最终完成状态同步写入独立、非云恢复的本地偏好文件，避免 IME 启动与引导任务退出之间读到旧状态。
- Android 自动恢复默认偏好后清理安装本地的 `HAD_FIRST_RUN` 和 `USER_SELECTED_KEYBOARD`，不再让旧安装状态跳过首次引导或四布局选择。
- 完成引导后的第一个合适普通文本字段稳定进入原生四布局 Dashboard，并保留密码、数字、硬键盘和其他原生排除条件。
- 对 Settings 与 IME 的并发首次引导检查增加进程内启动占有，避免完成前已经排队的第二个 `singleTask` Intent 再次显示完成页。
- 完成后迟到的引导 Intent 仅静默移除任务，不再发送第二个 HOME Intent，避免触发第三方 Launcher 的应用抽屉行为。

### Build

- GitHub Actions 手动构建支持独立 application ID 和 artifact 名称，便于不覆盖正式包的审计测试。

### Initial compatibility baseline

- 将已验证的固定路径用户词典自动备份、整合式备份列表和卸载重装权限恢复合并到正式兼容包。
- 使用新的“导入本地备份”和“立即备份”替换旧 DocumentsUI 导入/导出设置项，避免功能重复和不可用的空文件选择器。
- 正式包名为 `com.google.android.inputmethod.pinyin.compat`。
- README 更新为完整的版本、来源、签名、功能、构建和版权说明。
- 将经 SHA-256 与 Google 原始证书信息标识的 4.5.2 arm64-v8a 原始 APK 收录至 `original/`，用于保存和可复现构建。

## [0.40.0] - 2026-07-24

对应 Compatibility v46 / versionCode `4520359`，把固定目录备份列表整合回字典设置页，并补齐卸载重装后的文件权限请求。

### Fixed

- “导入本地备份”不再启动单独页面，改为在当前字典设置页显示与频率/版本数选择一致的单选列表对话框；选择版本后再就地确认导入。
- 当前安装无法列出旧 MediaStore 文件且尚未授权时，由新入口直接申请旧框架相同的 `WRITE_EXTERNAL_STORAGE` 文件权限；授权成功后自动重新加载备份列表，不再要求先点击旧导入入口。
- 保留导出文件从 File Geek 通过 `ACTION_VIEW` / `ACTION_SEND` 打开到 Google 拼音的外部恢复入口。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat46-integrated-backup-import`。
- 独立测试包名：`com.google.android.inputmethod.pinyin.localbackupaudit`。

## [0.39.0] - 2026-07-24

对应 Compatibility v45 / versionCode `4520358`，移除不可用的 DocumentsUI 目录选择依赖，改为固定 Documents 本地备份和显式手动导入。

### Changed

- 备份固定写入 `内部存储/Documents/GooglePinyinBackup`；“备份位置”改为只读显示，不再启动系统目录选择器。
- API 29+ 通过 `MediaStore.Files`、`RELATIVE_PATH` 和 `IS_PENDING` 创建并发布原生 UTF-16LE TSV；清除数据或卸载后公共文件保留。
- 新增“导入本地备份”，列出当前安装可访问的固定目录备份并复用原生 `UserDictImportTask`。
- 新增显式 `ACTION_VIEW` / `ACTION_SEND text/plain` 导入 Activity；卸载重装后可在 File Geek 中打开或分享旧备份到 Google 拼音，由用户确认后导入。
- 测试阶段保留旧“导入用户字典/导出用户字典”；验证完成后再以固定路径入口替换重复旧入口。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat45-fixed-documents-backup`。
- 独立测试包名：`com.google.android.inputmethod.pinyin.localbackupaudit`。

## [0.38.0] - 2026-07-24

对应 Compatibility v44 / versionCode `4520357`，修复 V43 本地目录选择器无法从左侧位置列表进入内部存储的问题。

### Fixed

- 移除 tree picker 上的 `Intent.EXTRA_LOCAL_ONLY` 提示；Android 16 DocumentsUI 在目录模式下可能因此隐藏或禁用 primary storage 入口。
- 纯本地限制仍由返回 URI 的 `com.android.externalstorage.documents` authority 强制执行，云端 provider 即使显示也无法通过验证。
- API 26+ 使用 `DocumentsContract.EXTRA_INITIAL_URI` 默认打开 `primary:Documents`，让用户能直接选择预先建立的 `Documents/GooglePinyinBackupAudit`，体验更接近现有“导入用户字典”的文件选择器。
- 继续使用 `ACTION_OPEN_DOCUMENT_TREE`，因为现有导入的 `GET_CONTENT` 只能授权单个文件，无法给自动备份授予创建和轮换多个文件所需的目录写权限。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat44-local-backup-picker-fix`。
- 独立测试包名仍为 `com.google.android.inputmethod.pinyin.localbackupaudit`，可覆盖安装 V42/V43。

## [0.37.0] - 2026-07-24

对应 Compatibility v43 / versionCode `4520356`，修复 V42 打开字典设置时的立即崩溃。

### Fixed

- 旧 `CommonPreferenceFragment` 会在 API 20+ 把 XML 中的 `CheckBoxPreference` 运行时替换为 `SwitchPreference`；V42 helper 错误地强制转换回 `CheckBoxPreference`，触发 `ClassCastException`。
- 自动备份开关改为通过两者共同的 `TwoStatePreference` 基类绑定，不改变旧框架的 Switch 转换和样式。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat43-local-backup-settings-fix`。
- 独立测试包名仍为 `com.google.android.inputmethod.pinyin.localbackupaudit`，可覆盖安装 V42 测试包。

## [0.36.0] - 2026-07-24

对应 Compatibility v42 / versionCode `4520355`，使用独立 localbackupaudit 包验证清除数据或卸载后仍保留的设备本地用户词典导出备份。

### Added

- 在“设置 → 字典 → 用户字典”加入本地自动备份开关、本地目录、频率、保留版本和“立即备份”。
- 仅接受 Pixel/AOSP 的本地 ExternalStorageProvider，通过 SAF 持久目录授权写入；不接受云端 DocumentsProvider，不上传或同步词条。
- 完整复用原生中文/英文 `UserDictExportTask` 和 UTF-16LE TSV 格式，先写 `.partial`，校验 BOM/header 后 rename 为正式 `.txt`。
- 自动配置保存在未注册到旧 `BackupAgent` 的独立 SharedPreferences；清除数据或卸载后配置消失，但公共本地备份文件保留，新装后由用户使用现有“导入用户字典”手动导入。
- 支持 1/3/7/14/30 天最小间隔、3/5/10/20/30 份轮换以及失败退避；不新增 Alarm、Job、Worker、自动恢复或启动扫描。

### Changed

- 原生用户词典 exporter 与 V41 保存路径共享进程级 dictionary-I/O lock，避免生命周期同步保存与后台导出并发访问 mutable dictionary。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat42-local-dictionary-backup`。
- 独立测试包名：`com.google.android.inputmethod.pinyin.localbackupaudit`。
- 测试 APK 已通过 apktool 重建、zipalign 以及 v1/v2/v3 签名校验；构建时设备未连接，因此尚未安装或执行功能测试。
- 研究与设计：`docs/dictionary-auto-backup-design.md`。

## [0.35.0] - 2026-07-24

对应 Compatibility v41 / versionCode `4520354`，在独立 dictionaryaudit 包中复核可变词库的滚动保存与故障恢复。

### Changed

- 对照当前 Gboard 的 `DictionaryAccessor`、enrollment 和 `SaveDictionaryTask`，记录完整故障矩阵及真机词库快照结果。
- 原生加载主文件及 `_bak` 都失败时，继续尝试仍存在的 `_tmp`；每个候选只消费一次，重试路径保持有界。
- 为旧 `SaveDictionaryTask.saveDictionaries()` 增加进程内共享锁，避免不同任务实例中的定时异步保存与生命周期强制保存同时轮换相同的主文件、`_bak` 和 `_tmp`。
- 用户明确关闭某个可变词库，且主文件已删除或本来就不存在时，同时清除 `_bak`、`_tmp` 和 `_unreadable`，避免以后重新启用时恢复已删除数据。
- “清除用户字典”成功持久化空词库后，清除旧滚动备份和故障副本，确保破坏性操作覆盖所有恢复副本；普通学习、编辑和定时保存仍保留滚动备份。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat41-dictionary-recovery`。
- 新增研究记录：`docs/gboard-dictionary-recovery-research.md`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并安装为独立的 `com.google.android.inputmethod.pinyin.dictionaryaudit` 审计包；未覆盖当前兼容包，也未执行输入功能或视觉测试。

## [0.34.0] - 2026-07-24

对应 Compatibility v40 / versionCode `4520353`，继续使用独立 guideaudit 包验证统一的 footer 操作。

### Changed

- 移除完成页内容区中央的完成按钮；完成页右下角沿用前两页“下一步”的固定位置和同一按钮样式。
- 进入最后一页时，右下角按钮文字从“下一步”切换为“完成”，保持可交互；返回前一页时恢复为“下一步”。
- 右下角按钮在最后一页调用 V38 已验证的 `exitGuide()`，直接返回桌面并移除引导任务；第一、第二页仍执行原生下一页动画。
- 最后一页继续保留左下角“上一步”，整体形成固定的左后退、右继续/完成导航逻辑。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat40-footer-finish`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，覆盖安装 guideaudit 测试包，清除该测试包数据并打开引导入口；未执行功能或视觉测试。

## [0.33.0] - 2026-07-23

对应 Compatibility v39 / versionCode `4520352`，继续使用独立 guideaudit 包验证显式引导导航。

### Changed

- 完整移除首次引导底部 PageIndicator，不再依赖旧 `PageIndicatorView` 的 enabled-state 视觉语义。
- 将首次引导 pager 替换为 `NonSwipeableFirstRunViewPager`，仅禁止用户触摸滑页，保留按钮触发的原生程序化翻页和动画。
- 底部改为左侧“上一步”和右侧“下一步”按钮；第一页隐藏上一步，最后一页隐藏下一步。
- 上一步复用旧框架 `navi_skip` 插槽但仅在 `PinyinFirstRunActivity` 中改为后退，功能介绍 Activity 继续保持原来的跳过/关闭行为。
- 启用或选择输入法完成后不再自动跳页，只解锁当前页的下一步按钮；未完成时下一步不可交互，并使用明确的 disabled 背景和文字颜色。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat39-guided-first-run`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并覆盖安装独立的 `com.google.android.inputmethod.pinyin.guideaudit` 测试包；已清除该测试包数据并打开引导入口，未执行功能或视觉测试。

## [0.32.0] - 2026-07-23

对应 Compatibility v38 / versionCode `4520351`，继续使用独立 guideaudit 包验证首次引导。

### Fixed

- 移除步骤完成状态中勾号背后的第二层圆形底色，改为直接在外层完成容器上显示随明暗主题着色的勾号。
- 系统返回键在第二、第三页时返回前一页，仅在第一页退出；不再从任意页面直接关闭引导。
- 完成或从第一页退出时先显式返回桌面，再移除引导任务，避免重新露出启动引导的应用设置页面。
- 为指示器增加独立的明暗主题颜色；暗色模式当前页使用浅色，其他页使用明显更暗的灰色，不再复用按钮 primary/outline 色。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat38-first-run-navigation`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并覆盖安装独立的 `com.google.android.inputmethod.pinyin.guideaudit` 测试包；未执行功能或视觉测试。

## [0.31.0] - 2026-07-23

对应 Compatibility v37 / versionCode `4520350`，用于首次使用引导专项验证。

### Changed

- 对照当前 Gboard 的标准三页数组，将首次使用流程固定为“启用输入法 → 选择输入法 → 完成”，不再显示旧权限总览页或匿名指标页。
- 保留旧框架从系统设置/输入法选择器返回后的状态刷新、自动推进、PageIndicator、完成按钮和 `finishAndRemoveTask()` 行为。
- 构建脚本新增可选 application ID；正式默认仍为 `com.google.android.inputmethod.pinyin.compat`，本次测试包使用独立的 `com.google.android.inputmethod.pinyin.guideaudit`，并同步隔离用户词典 authority 和应用数据。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat37-first-run-audit`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并以独立包名安装到 Pixel 10 Pro；原 V36 compatibility 包仍保持安装且版本不变。
- 未执行引导功能或视觉测试，验证由项目维护者完成。

## [0.30.0] - 2026-07-23

对应 Compatibility v36 / versionCode `4520349`。

### Changed

- 对照当前 Gboard，将手写 `ayc` 的 down/move/up 局部裁剪改为不带 `Region.Op` 的 `Canvas.clipRect(RectF)`，继续以成对 save/restore 隔离每次 dirty rect 绘制。
- 为 `aye` 与 `HandwritingOverlayView` 的全画布清屏补齐 save/restore，并在恢复完整 Canvas 状态后再重放保留的 strokes。
- 不修改 ALPHA_8 离屏 Bitmap、pressure、Path、dirty rect、MotionEvent、Stroke 或 JNI 识别路径；滑行轨迹继续保留原有独立修复。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat36-handwriting-canvas`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试，手写验证由项目维护者完成。

## [0.29.0] - 2026-07-23

对应 Compatibility v35 / versionCode `4520348`。

### Changed

- V34 真机确认全键盘符号/表情单指可轻松左右翻页，局部 velocity fling 修复通过。
- 删除临时 `PagerDiagnosticsCompat`、`GPPagerDiag` 日志及 `lk` 中全部诊断调用；正式版只保留对 `PageableRecentSubCategorySoftKeyListHolderView` 验证通过的 legacy distance 门槛旁路。
- V32 分页误选取消、慢速手势 50% settle、候选 pager、左侧竖向列表和其他 `lk` 使用者保持不变。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat35-symbol-pager-fling`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.28.0] - 2026-07-23

对应 Compatibility v34 / versionCode `4520347`。

### Fixed

- V33 的 30 次采样确认旧 `lk` final-delta distance 始终为 0，导致全键盘符号/表情的 fling 分支完全不可达；21 次回弹中有 16 次速度实际已超过系统 minimum。
- 仅对 `PageableRecentSubCategorySoftKeyListHolderView` 跳过失效的 legacy 25dp final-delta 门槛，改为在已经进入 dragging 后按系统 minimum fling velocity 进入原有 fling 目标页逻辑。
- 保留 paging touch slop、方向竞争、慢速手势 50% settle、target clamp、页码和 Scroller 动画；候选 pager 与其他共享 `lk` 的界面继续使用原双重门槛。
- 保留 V33 日志一个验证周期，并修正 `result` 文本；诊断 tag 仍为 `GPPagerDiag`。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat34-symbol-pager-fling`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；安装后已清空 Logcat，未执行功能测试。

## [0.27.0] - 2026-07-23

对应 Compatibility v33 / versionCode `4520346`，仅用于横向 pager 诊断。

### Diagnostics

- 新增 `PagerDiagnosticsCompat`，只记录 `PageableRecentSubCategorySoftKeyListHolderView` 在 UP 时已经计算完成的 current/target、页面 offset、拖动 distance、25dp threshold、velocity、minimum velocity 与 fling 判定。
- 日志 tag 为 `GPPagerDiag`；候选 pager 和其他共享 `lk` 的界面通过类型检查排除。
- 诊断调用不修改 `lk` 字段、MotionEvent、touch slop、velocity、settle、目标页或 Scroller 动画，V32 点击取消逻辑保持不变。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat33-pager-diagnostics`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；安装后已清空 Logcat，未执行功能测试。

## [0.26.0] - 2026-07-23

对应 Compatibility v32 / versionCode `4520345`。

### Fixed

- 对照 Gboard 的显式滚动取消协议，将分页辅助类 `aws` 接入现有 `ScrollTouchCompat` 外层状态桥。
- 分页候选及全键盘符号/表情在超过原生 paging touch slop 后，除取消 holder 自身事件副本外，也会取消 `SoftKeyboardView` 自定义按键管线的外层释放，避免现代 Android 上滑动后松手误选起点按键。
- 保持 pager 的 `super -> aws detector` 顺序以及原生 touch slop、方向、速度、翻页阈值和 fling 参数不变；不调整已经验证的左侧竖向列表逻辑。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat32-pageable-touch-cancel`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.25.0] - 2026-07-23

对应 Compatibility v31 / versionCode `4520344`。

### Reverted

- 根据 V29/V30 真机测试结果，回滚全部 IME 帧率干预：删除 `FrameRateCompat`、Window touch boost、Window preferred refresh rate、View frame-rate vote 以及开始/结束输入生命周期注入。
- 不恢复曾导致疑似异常发热的固定 120Hz 实现；当前完全由 Android 系统默认调度帧率和 LTPO/ARR。
- 高刷新率支持推迟到 target API 与渲染管线现代化后重新实现。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat31-system-frame-rate`。

## [0.23.0] - 2026-07-23

对应 Compatibility v29 / versionCode `4520342`。

### Fixed

- 移除 IME Window `preferredRefreshRate=120` 和 decor view `setFrameRate(120, DEFAULT)` 两条固定高刷新率请求，避免键盘可见但空闲时阻止 LTPO/ARR 降频。
- API 35+ 改用当前 Gboard 使用的 `Window.setFrameRateBoostOnTouchEnabled(true)`，让系统只在触摸交互期间提升刷新率。
- 新增 `FrameRateCompat.clear()`，在 `onFinishInputView()` 中关闭 touch boost，并将 Window/View 的遗留 frame-rate vote 清为 0。
- Android 30–34 不再写死 120Hz，由系统默认策略选择适合设备的刷新率；90Hz、120Hz、144Hz 屏幕不再被统一映射到固定值。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat29-dynamic-frame-rate`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.22.0] - 2026-07-23

对应 Compatibility v28 / versionCode `4520341`。

### Fixed

- 根据 V27 真机主题切换结果，确认所有主题仍进入原有浅/深 fallback。
- 定位原因：Google 拼音 stylesheet 通过自定义 `bam` Drawable 包装原背景，并把最终主题 tint 保存在公开 `ColorStateList` 中；读取包装内部的基础 `GradientDrawable` 无法获得最终颜色。
- `NavigationBarCompat` 现在优先识别 `bam`，按 Drawable 当前 state 从其 `ColorStateList` 读取真实颜色，再回退到 Android 标准 Drawable 和主题名称路径。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat28-stylesheet-nav-color`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.21.0] - 2026-07-23

对应 Compatibility v27 / versionCode `4520340`。

### Changed

- `NavigationBarCompat` 不再优先通过 theme cache key 猜测浅色或深色，而是读取当前 `keyboard_body_view_holder` 中已经完成 stylesheet 渲染的键盘 body 背景色。
- body 在早期生命周期或切换过程中暂不可用时，继续尝试读取 `keyboard_area` 的最终背景色；只有无法得到 alpha 255 的 surface 时才回退到 V26 的名称判断和内置浅/深颜色。
- 支持从 `ColorDrawable`、`GradientDrawable`、`LayerDrawable` 和当前 `DrawableContainer` 状态中提取颜色，因此可覆盖内置 shape、layer-list 及额外主题 selector。
- 虚拟导航键明暗改为根据实际 surface 的加权亮度计算，不再由主题名称直接决定。
- 本阶段不改变 divider、WindowInsets、三键/手势模式和 contrast enforcement，降低基础重构范围。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat27-rendered-nav-surface`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.20.0] - 2026-07-22

对应 Compatibility v26 / versionCode `4520339`。

### Fixed

- 修正 V25 在亮色键盘中直接使用深色候选文字 RGB 生成 chip 背景，导致整体明显偏暗的问题。
- 根据 Gboard 二进制 stylesheet 的实际规则实现亮暗表面：亮色键盘使用约 `#4CFFFFFF` 的白色 surface 叠加，暗色键盘使用约 `#1AFFFFFF`，不再使用文字色作为背景色。
- 描边降为亮色主题下约 9% 黑色、暗色主题下约 15% 白色，elevation 从 3dp 降到 2dp并移除额外 translationZ，避免阴影过重。
- 按 Gboard 紧凑 AutoPaste chip 参数调整为 34dp 高、14sp 文本、20dp 图标和 1000dp 完全胶囊圆角。

### Research

- 确认 Gboard chip XML 使用白色 pill shape 作为 ripple background/mask，实际颜色由 `.bg-chip-item-suggestion` stylesheet tag 重写；亮色默认映射到 bordered-key surface，而不是半透明黑色。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat26-gboard-light-chip`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.19.0] - 2026-07-22

对应 Compatibility v25 / versionCode `4520338`。

### Changed

- 完整移除 4–8 位验证码正则及提取分支；剪贴板候选现在始终忠实提交完整原文，仅屏幕摘要保留 18 字符加 `...` 的视觉截断。
- 将 clipboard chip 的主题色填充透明度由约 9% 提升到约 19%，描边透明度提升到约 44%，增强与底层候选栏的层次差异。
- 为圆角 chip 增加 3dp elevation、1dp translationZ 和平台圆角 outline 阴影，使其呈现更接近 Material 按钮的凸起质感。
- 候选 View 回收时同步清除 elevation 和 translationZ，避免普通候选继承阴影。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat25-raised-clipboard-chip`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.18.0] - 2026-07-22

对应 Compatibility v24 / versionCode `4520337`。

### Fixed

- 修复仅将 chip 内部文字设为居中、但单个候选 `SoftKeyView` 仍停靠候选栏左侧的问题：当候选栏中只有剪贴板 chip 时，将整个候选项组水平居中；出现普通候选后恢复原生起始对齐。
- 修复 `AutoSizeTextView` 接收 `16sp` 原始数值后错误计算最小字号比例，导致文字异常放大并被 chip 高度裁切的问题；现在先按 `scaledDensity` 转换为真实像素，再交给旧版自动缩放实现。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat24-centered-clipboard-chip`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.17.0] - 2026-07-22

对应 Compatibility v23 / versionCode `4520336`。

### Changed

- 剪贴板候选的长文本摘要改为最多显示开头 18 个字符，并使用三个点 `...` 结尾；提交内容仍保持完整。
- 参考 Gboard AutoPaste chip，将剪贴板候选改为单行垂直/水平居中布局、16sp 文本、36dp 最小高度和更紧凑的内边距。
- 在内容外增加随键盘文字颜色变化的半透明圆角填充与描边，并隐藏该项的原生候选分隔线。
- 将剪贴板图标固定为 16dp，放置在文本前并保留 8dp 间距。
- 候选 View 回收时恢复原生背景、字号、padding、分隔线和 drawable，避免普通候选继承 clipboard chip 样式。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat23-clipboard-chip`。

### Build

- V23 APK 已成功重建，通过 zipalign 和 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro。
- 按约定未执行功能测试，视觉效果由项目维护者真机验证。

## [0.16.0] - 2026-07-22

对应 Compatibility v22 / versionCode `4520335`。

### Added

- 将已通过真机最小验证的原生候选栏方案接入系统剪贴板：输入视图启动时读取最近两分钟内的纯文本剪贴板，并在剪贴板变化时刷新候选 model。
- 对 4–8 位独立数字自动提取验证码；其他文本显示并提交原始内容，过长显示文本会截断但不改变提交内容。
- 剪贴板候选参与每轮拼音、英文和手写候选更新，使用原生 `Candidate`、`SoftKeyView`、键盘主题、触摸及可访问性路径。

### Privacy

- 密码、可见密码、网页密码和数字密码输入框不读取或展示剪贴板候选。
- 支持应用通过 `privateImeOptions=disableAutoPaste` 禁用建议，并忽略标记为 `android.content.extra.IS_SENSITIVE` 的剪贴板及非文本内容。
- 仅在输入视图活动期间注册剪贴板监听器；输入视图结束后立即移除监听并清理当前候选。
- 点击后的同一条剪贴板内容在进程生命周期内不再重复建议。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat22-clipboard-candidate`。
- 编码代理继续负责 APK 构建、签名和安装；功能验证及回归测试统一由项目维护者执行。

### Testing

- 原生候选栏静态原型已由项目维护者验证：位置正确、点击可上屏，并可在英文与手写笔画模式正常工作。
- V22 APK 已成功重建，通过 zipalign 和 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro。
- 动态剪贴板读取、验证码提取、候选合并和隐私过滤尚待项目维护者真机验证。

## [0.15.0] - 2026-07-21

对应 Compatibility v20 / versionCode `4520332`。

### Fixed

- 修复词库持久化成功后立即删除上一份 `_bak` 的问题，改为始终保留一份上一版本滚动备份。
- 修复保存过程中进程终止后主词库缺失时，启动逻辑忽略 `_bak`/`_tmp` 并直接创建空词库的问题：现在优先恢复 `_bak`，无备份时再尝试 `_tmp`。
- 修复原生引擎无法载入主词库时直接注册空词库的问题：现在先隔离不可读主文件，再恢复上一份 `_bak` 并递归重试一次。
- 无可用备份时，将不可读主文件保留为 `_unreadable`，避免在首次降级为空词库时立刻销毁唯一的故障现场。

### Safety

- 恢复逻辑应用于拼音和英文引擎的全部可变词库，包括用户词库、新词库、联系人词库和快捷词库。
- 不改变原生词库格式、50 万条用户词库容量和压缩算法，降低兼容风险。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat20`。

### Testing

- APK 已成功重建、签名并覆盖安装；新增 smali 类及修改后的异常恢复分支均通过 apktool 汇编。
- 正常安装和包信息检查通过。中断写入及损坏词库恢复仍需后续构造场景进行专项验证。

## [0.14.0] - 2026-07-21

对应 Compatibility v19 / versionCode `4520331`。

### Removed

- 移除用户词典设置页中的“词典更新”分类、“词典更新”开关和“词典更新通知”开关。
- 停止向周期任务管理器注册 `new_words_update`，不再创建指向已失效 `https://tools.google.com/service/update?as=pinyinsysdict` 的 `NewWordsUpdateTaskFactory`。
- 移除在线词典更新对应的 INTERNET/ACCESS_NETWORK_STATE 功能权限注册。
- 补充移除遗留的 `daily_ping_task` 周期统计任务注册；保留与在线系统词典无关的本地 English model 周期维护任务。

### Preserved

- 保留用户词典本地导入、导出、快捷词典和用户词典同步入口；本次仅移除失效的系统词典在线更新。
- 保留 v18 的统计、Firebase 和反馈上传清理。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat19`。

### Testing

- APK 已重建、签名并覆盖安装到 Pixel 10 Pro；设置 XML 和 `PinyinIME` 中已无在线系统词典更新入口及任务注册。

## [0.13.0] - 2026-07-21

对应 Compatibility v18 / versionCode `4520330`。

### Removed

- 移除设置“其他”页面中的“发送使用情况统计信息”开关。
- 移除设置菜单中的“发送反馈”入口，以及 Manifest 中的拼音反馈 Activity、Google User Feedback Activities 和上传 Service。
- 移除 Manifest 中的 Firebase Instance ID Receivers、Service 和 Firebase JobDispatcher Receiver，阻止失效的注册、广播及后台任务入口被系统启动。
- 停止在 `PinyinApp` 中创建 `Laym`，不再注册 Clearcut/Primes 的每日 ping、IME 事件和键盘事件统计处理器，也不再创建 Clearcut 上传适配器。

### Preserved

- 保留本地 `IMetrics` 接口供旧框架内部计时和状态逻辑使用，但不挂接任何网络上传处理器。
- 用户词典同步和在线词典更新暂未在本次清理范围内。
- 横向符号/表情分页继续保持 v17 已恢复的原版逻辑。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat18`。

### Testing

- APK 已重建、签名并覆盖安装；Manifest 和设置 XML 中已无 Firebase、User Feedback、使用统计及发送反馈入口。

## [0.12.0] - 2026-07-21

对应 Compatibility v17 / versionCode `4520329`。

### Reverted

- 完整回滚此前所有针对全键盘符号、标点、表情横向分页的修改，包括早期将翻页提交距离从 25 dp 降至 8 dp、移除最低 fling 速度条件，以及 v14-v16 的 touch slop、方向、分页状态桥和强制翻页实验。
- 横向分页器 `lk`、`mq` 及 `PageableSoftKeyListHolderView` 恢复原版 APK 的触摸阈值、释放判定、动画、方向和事件处理。
- 保留已经验证正常的九宫格左侧纵向列表修复、高刷新率请求、Android 16 手写及导航栏兼容补丁。

### Changed

- 为允许覆盖安装已经发布到手机的高 versionCode 测试版，回滚构建使用 versionCode `4520329` 和 versionName `4.5.2.193126728-arm64-v8a-a16compat17`。除横向分页代码恢复原版外，其余功能代码以已验证的 v13 为基线。

### Testing

- 已从 v13 APK 重新解码并重建，签名验证通过，随后成功覆盖安装到 Pixel 10 Pro。

## [0.11.0] - 2026-07-21

对应 Compatibility v13 / versionCode `4520325`。

### Fixed

- 修复静止点击被错误归类为滚动：不再依据子 View 事件坐标位移，因为现代 Android 的事件副本和坐标转换会让同一次静止触摸在不同分派阶段出现较大的局部坐标差。
- 改为在内部 `ScrollView` 完成每个 `MOVE` 后比较实际 `scrollY`。只有列表内容确实移动至少 1 px 才设置滚动状态；静止点击不会取消，快速连续滑动也不再依赖不稳定的事件坐标。
- 保留 v12 的释放时序，内部列表继续先收到原始 `ACTION_UP`，不影响惯性滚动。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat13`。

### Testing

- APK 已重建并签名；安装时手机已从 ADB 断开，等待重新连接后安装。

## [0.10.0] - 2026-07-21

对应 Compatibility v12 / versionCode `4520324`。

### Fixed

- 修复 v11 中普通点击也被取消的问题：现在外层在每次新的 `ACTION_DOWN` 时无条件清除上一手势的滚动状态。
- 恢复滚动惯性：不再提前修改送往内部 `ScrollView` 的释放事件。列表先接收原始 `ACTION_UP` 并计算 fling，随后才把外层自定义按键管线即将处理的事件改为 `ACTION_CANCEL`。
- 避免快速连续滑动时因前一手势状态残留而随机输入符号。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat12`。

### Testing

- 已覆盖安装独立包名版本；等待分别复测单击、慢速拖动和快速甩动。

## [0.9.0] - 2026-07-21

对应 Compatibility v11 / versionCode `4520323`。

### Fixed

- 原版在 Android 16 上可复现同样问题，确认这是旧触摸实现与新系统事件分派之间的兼容问题，而非此前补丁单独引入。
- 旧实现假设在内部 `ScrollView` 修改 `MotionEvent` 后，外层 `SoftKeyboardView` 会看到同一个已修改对象。现代 Android 向子 View 分派经过坐标转换的事件副本，内部副本改为 `ACTION_CANCEL` 后，外层自定义按键管线仍会收到原始 `ACTION_UP`，因而选中滑动起点。
- 新增显式滚动状态桥：内部列表检测到实际纵向移动后记录状态；外层 `SoftKeyboardView` 在处理自己的原始释放事件前读取该状态并将其改为 `ACTION_CANCEL`。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat11`。

### Testing

- 已覆盖安装独立包名版本；官方原版继续保留，可直接切换对比。

## [0.8.0] - 2026-07-21

对应 Compatibility v10 / versionCode `4520322`。

### Changed

- 兼容版应用 ID 改为 `com.google.android.inputmethod.pinyin.compat`，可与官方原版 `com.google.android.inputmethod.pinyin` 并存，方便同机对比触摸行为。
- 同步隔离用户词典 Provider authority，避免与原版冲突。
- 应用中文名及其他语言显示名称保持原样，不添加“改版”或其他后缀。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat10`。

### Testing

- 已在 Pixel 10 Pro 成功安装独立包名版本，并确认系统同时识别两个不同的输入法组件。

## [0.7.0] - 2026-07-21

对应 Compatibility v9 / versionCode `4520321`。

### Fixed

- 根据真机现象修正问题定义：列表本身能够滚动，误选固定发生在松手时，并选择滑动起点处原先按住的候选或标点。
- 不再依赖 `GestureDetector` 的方向判定或外层布局坐标。滚动容器 `awo` 直接记录本次手势的起始 Y 坐标；只要纵向总位移超过系统 touch slop，就在释放进入子按键和外层输入管线前把 `ACTION_UP` 改为 `ACTION_CANCEL`。
- 普通静止点击仍保留原始 `ACTION_UP`。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat9`。

### Testing

- 已重建、签名并覆盖安装到 Pixel 10 Pro；等待九宫格左侧列表真机复测。

## [0.6.0] - 2026-07-21

对应 Compatibility v8 / versionCode `4520320`。

### Fixed

- 确认九宫格左侧误上屏发生在 `ACTION_DOWN`：`TappingActionHelper` 会在手指按下时立即建立并执行 `PRESS` 动作，因此在 `ACTION_UP` 阶段发送取消事件已经太晚。
- 对九宫格左侧面板改用延迟判定：标准 View 事件仍实时交给 `ScrollView`；自定义按键处理管线暂不接收 `DOWN/MOVE`。松手时若发生纵向移动则不生成按键事件；若没有移动则补发完整的 `DOWN/UP` 点击序列。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat8`。

### Testing

- 已重建、签名并覆盖安装到 Pixel 10 Pro；等待九宫格左侧候选及标点列表真机复测。

## [0.5.0] - 2026-07-21

对应 Compatibility v7 / versionCode `4520319`。

### Fixed

- 在 `SoftKeyboardView` 的外层自定义触摸管线增加仅针对九宫格左侧面板的纵向滑动保护。该输入法在标准 View 分派之后还会再次处理同一个事件，解释了仅在内部 `ScrollView` 取消释放仍会上屏的问题。
- 分页器的翻页提交距离从 25 dp 降至 8 dp，并取消“位移达标后还必须同时达到最低 fling 速度”的限制，使慢速短距离滑动也能翻页。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat7`。

### Testing

- 已重建、签名并覆盖安装到 Pixel 10 Pro；等待真机交互复测。

## [0.4.0] - 2026-07-21

对应 Compatibility v6 / versionCode `4520318`。

### Fixed

- 九宫格左侧候选/标点滚动容器现在从完整的 `dispatchTouchEvent` 事件流识别滑动，并在事件到达子按键前取消释放，修复滑动结束时内容直接上屏。
- 撤销 v5 对分页容器 `ACTION_UP` 处理顺序的错误修改；该修改会把正常轻扫改成取消事件，导致全键盘标点页必须拖过半页才能翻页。

### Changed

- 在 Android 11+ 为整个输入法窗口显式请求 120 Hz 帧率，改善分页滑动和候选区展开/收回动画的流畅度；系统会按屏幕能力选择最接近的刷新率。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat6`。

### Testing

- 待在 Pixel 10 Pro / Android 16 真机复测九宫格滚动、全键盘标点翻页及输入法窗口实际呈现帧率。

## [0.3.0] - 2026-07-20

对应 Compatibility v5 / versionCode `4520317`。

### Changed

- 首次使用引导在 Android 15+ 更新为 Material Design 3 风格，支持浅色和深色配色。
- 更新引导页的排版、圆角按钮、完成状态容器、页面背景和系统栏颜色。
- 从首次使用流程中移除匿名使用情况选择页面；统计偏好继续保持默认关闭。
- 最终完成按钮和系统返回键现在会关闭整个引导任务，不再露出功能介绍或应用设置。
- 首次启动始终使用完整页面集合，避免输入法启用前后页面指示器从 2 个变成 4 个。
- 使用 MD3 主色和轮廓色明确区分当前页面指示器，并优化已完成步骤的圆形勾选状态。
- 候选与标点翻页列表在滑动结束时先发送取消事件，避免松手误选触点下的内容。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat5`。

### Testing

- APK 已通过 apktool 2.12.1 重建；引导流程及候选/标点滑动修复等待 Android 16 真机复测。

## [0.2.0] - 2026-07-20

对应 Compatibility v4 / versionCode `4520316`。

### Fixed

- 根据 Android 16 真机 logcat 定位手写首次落笔崩溃：旧绘制器调用了系统不再允许的 `Region.Op.REPLACE`。
- 将手写及滑行绘制路径中的 6 处画布裁剪操作改为 `Region.Op.INTERSECT`。
- 使用成对的 `Canvas.save()` / `Canvas.restore()` 隔离每个笔画点的裁剪区，避免裁剪区持续收缩导致笔迹不可见。

### Changed

- versionCode：4520315 → 4520316。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat4`。

### Testing

- 已在 Pixel 10 Pro / Android 16 真机验证：手写笔迹显示、中文识别和候选上屏均正常。

## [0.1.0] - 2026-07-20

对应 Compatibility v3 / versionCode `4520315`。

### Added

- 增加 Android 16 系统导航栏主题适配。
- 根据 Google 拼音键盘主题标识选择浅色 `#ECEFF1` 或深色 `#263238`。
- 浅色主题使用深色系统导航图标，深色主题使用浅色图标。
- Android 28+ 同步导航栏分隔线颜色。
- Android 29+ 关闭系统强制导航栏对比度蒙层。
- 在候选区及扩展区更新后重新应用导航栏主题，避免输入时变黑。
- 增加可复现的 apktool 补丁及构建脚本。

### Changed

- targetSdkVersion：26 → 28。
- versionCode：4520313 → 4520315。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat3`。
- 为输入法服务和 Launcher Activity 显式声明 `android:exported="true"`。
- 为开机初始化 Receiver 显式声明 `android:exported="false"`。

### Known issues

- 手写输入会导致输入法进程崩溃，原因待 logcat/native backtrace 确认。
