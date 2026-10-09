# 长期决策

只记稳定结论，被推翻时才改。当轮过程与试错放在同目录的日期文件里。

需要指向内网地址、服务器路径、设备信息或凭据位置时，只写「见本地 `AGENTS.md`」，把具体值留在那个不入库的文件里。

## 仓库定位

- 仓库：`https://github.com/huaxianyan/ComebackGooglePinyinInput`。
- 正式包名：`com.google.android.inputmethod.pinyin.compat`。
- 当前正式基线：`v2.1.5`，`targetSdkVersion=36`，`minSdkVersion=23`。后续开发从最新 `master` 创建分支，不能把旧实验基线当作当前基线。
- 正式签名身份必须保持不变。私钥、口令和其他签名材料只保存在仓库外或 GitHub Actions Secrets 中。
- 默认不修改原生输入、候选、学习权重、词典格式、手写、主题、分页和触摸语义，以修复已定位缺陷为默认立场。

## 助手私有目录与交接

- 助手私有目录（`.workbuddy/`、`.workbuddy-ai/`、`.pi/`、`.claude/`、`.cursor/`）一律排除在 Git 之外，只放临时草稿。
- 进度与交接记录写在仓库的 `docs/handoff/` 下，跟代码一起提交。换任何工具都能读到，不为某个软件做特化。
- 本机的路径、凭据位置和设备信息不写进入库文档，只写在本地 `AGENTS.md`，该文件经 `.git/info/exclude` 忽略。

## 分支策略

- 开发从当前 `master` 创建分支。一组工作一个分支，验收阶段相互独立，不为了方便混进同一版本。
- 验收通过后及时合并到 `master`，并清理已完整合入的本地与远端分支引用。开发中和未完成验收的工作保留。
- 不因分支整理擅自 rebase 开发分支、改写其他 worktree、创建版本标签或发布 Release。
- 被暂停但计划恢复的分支保留历史，不删除。不再使用的失败实验，用户已允许只合并历史并清理分支引用，不恢复失败代码。

## 已决定不改的行为

- 英文键盘上符号后第一次退格只退出建议、删成对符号要按两次，判定为原版 Google 拼音输入法既有行为，**不改代码**。
- 理由：消除它要么收窄喂给原生解码器的 `symbols_word_separators`（连带改自动空格、自动大写、句末判定），要么改解码器退格判据 `adw.a(JLchw;)Z`，都超出「修复已定位缺陷」的范围。
- 处理方式：不做界面文案提示（避免误导成补全功能带来的问题），只在 Release 页面写明这一既有行为与保留理由，由用户自行判断是否开启补全。
- 一次性说明写在 `docs/releases/v2.1.3.md` 的「已知行为说明」小节，作为该版本的额外说明，不进入标准发布流程模板，也不进 `CHANGELOG.md`。

## 动态配色主题

- 方向已定：**目标为真动态配色（Material You），按系统能力降级**——只有 `API >= 31` 的设备启用动态槽，其余版本完全走现有三槽逻辑（零改动零风险）。
- 降级判据单一且明确：`Build.VERSION.SDK_INT >= 31`。
- 系统动态色资源**必须按资源名取，不能硬编码 id**。真机实测（Pixel 10 Pro / Android 16）证明：android.jar 是编译期符号表，真机 framework 资源 id 运行时分配，两者不等同（`0x01060037` 真机不存在，真机 accent1 起于 `0x010603ba`）。先前基于 android.jar 的「id 跨版本稳定可硬编码」结论**已被真机推翻**。
- 系统动态色资源在 Android 16 上按深浅色拆分为独立 id（`system_accent1_100_dark` / `_light`），正好对应浅色槽/深色槽设计，取色不依赖 `uiMode`。
- **不需要移植 Material Color Utilities**：系统已算好完整语义色（`system_primary_light`、`system_surface_container_dark` 等），实测应用进程内 `getIdentifier` + `getColor` 全部可读（18/18 语义色、色阶色全命中）。
- 主题包可在运行期用代码构造（`baj` 写入器），经 `files:` 前缀通路（原版既有）加载，写入与读取的 zip 条目名完全一致。
- 架构上新增 `SLOT_DYNAMIC` 作为第四槽，接进现有 `SystemAutoThemeCompat` 机制。
- 项目约束 AndroidX-free，`ContextCompat.getColor` 不可用，只能用平台 `getResources().getColor(int, Theme)`（API 23+）。
- 三项真机实测**全部通过**：实测①（运行期读系统色，40/40 命中）、实测②（自造主题包可渲染，键盘区 96.6% 探针色）、实测③（系统色→主题包→渲染全链路，`color_base` 精确等于 `system_surface_light`）。详见 [实测①](../dynamic-color-device-test-1.md)、[实测②③](../dynamic-color-device-test-2.md)。
- **主题生效键是 `additional_keyboard_theme`，不是 `keyboard_theme`**（实测②结论）。`baq.a(Context)` 中 `additional_keyboard_theme` 非空即短路，`keyboard_theme` 被完全忽略；且只写 `keyboard_theme` 时 `gc.b()` 校验必然失败（值无 `assets:`/`files:`/`system:` 前缀）而退回内置主题。**自定义主题只能通过 `additional_keyboard_theme` 注入，值必须以三种前缀之一开头。**
- **`ThemePackageMetadata` 字段映射已纠正**：`field1`=int 版本（可省略）、`field2`=**repeated string 主 style_sheet 文件名列表**、`field3`=嵌套消息含 border 文件列表。此前把 `field2` 当主题名、`field3` 当单文件列表是错的，会导致 `bbl.a(File)Z` 校验失败。**最稳做法：照抄某个内置主题 metadata 的原始字节。**
- **系统色 → 键盘槽映射已跑通**（实测③，20 槽）：`color_base←system_surface_light`、`color_header←system_surface_container_light`、`color_label←system_on_surface_light`、`color_icon←system_on_surface_variant_light`、`color_state_action←system_primary_light`、`color_state_action_pressed←system_primary_container_light`、`color_popup_background←system_surface_container_high_light`、`color_keyboard_separator←system_outline_variant_light`。完整表见 [实测②③](../dynamic-color-device-test-2.md)。
- 实测②证据：`additional_keyboard_theme=files:user_theme_000000000000001_00.zip`，键盘区 **96.6% 像素为 `#FF00FF`**（`work/dynamic-color-probe/shots/probe_v3_additional.png`）；仅改该单键亦生效。
- 远程设备接入必须用 server 模式：`ADB_SERVER_SOCKET=tcp:<ip>:15037` 或 `adb -H <ip> -P <port>`。**`adb connect <ip>:15037` 会永远 `offline`**（语义错配：转发器暴露的是整个 ADB server，不是一台设备）。
- **实测载体必须干净**：首轮实测②用的是 2.2.0 失败产物（`pairauto` 包），结论作废。2.2.0 是「System Auto 主题」方向的失败尝试，不在 git / CHANGELOG / 任何记录中，功能已定性**暂不做**，其产物与设备包已清理。
- `SystemAutoThemeCompat.debugLog` **仅在 `ApplicationInfo.flags & 0x2`（FLAG_DEBUGGABLE）时输出**。release-like 包无 `SystemAutoTheme` 日志属正常，**不能据此判定该类未被调用**——调用链已确认：`PinyinIME` → `Labp` → `GoogleInputMethodService.onCreate()` → `applyOnCreate`。
- 已有的「跟随系统深浅色」是 `SystemAutoThemeCompat` **三槽模型**（`followThemeEnabled + light + dark + fixed`），commit `f3b264c`，**自 2.0.1 起在正式版中**。动态配色是**在此模型上加第四槽 `SLOT_DYNAMIC`**，不是从零开始。
- 因系统语义色现成可用，**颜色推导算法这一最大工作量项被移除**，动态配色难度由「高」下调；剩余工作集中在「系统色 → 键盘色槽」映射表。详见 [动态配色实测②③](../dynamic-color-device-test-2.md)。

## 开发与测试包名

- **开发与真机测试一律使用非正式包名**，验收后卸载测试包。绝不把调试产物装成正式 ID `com.google.android.inputmethod.pinyin.compat`。
- 当前测试包：`com.google.android.inputmethod.pinyin.dev`（versionName 2.1.3 / versionCode 4520404，release-like，用 `work/audit-signing/audit-signing.p12` 签名）。
- 构建入口是 `scripts/build.ps1`，传 `-ApplicationId <隔离包名>`；需 `run-as` / JDWP 时加 `-Debuggable`，`apply_patches.py` 会拒绝让正式 ID 变 debuggable。
- **本地构建版本号会漂**：`build.ps1` 不读 `version.properties`，`apply_patches.py` 默认版本与之一致性靠人传参。正式发布的版本一致性由 GitHub Actions（`build-release.yml` 校验 tag 与 `version.properties` 相符）保证，本地构建只适合做测试包。

## 已知坑与结论

- 英文 IME 定义里的 `extra_value_latin_enable_suspend_prediction_on_backspace` 不能改成 `false`。`adw.a(JLchw;)Z` 里 `cgp.h == false` 会**无条件**进入挂起分支，改 `false` 会让候选缺失的退格全部被吞，问题加重。详见 [英文符号引发后续建议与首次退格被吞的调研](../symbol-backspace-swallow-research.md)。
- 符号后第一次退格被吞由各语言的 `symbols_word_separators` 决定，与符号自身无关。会结束词的符号，其后退格被解码器挂起。同上。
- 「只让符号不引发预测、保留字母的下一词预测」在补全钩子里做不到：清空联想容器的 `azh.b()V` 是私有方法，框架侧可达的 `textCandidatesUpdated` 与 `finishComposingText` 都只是向外通知。同上。
- 2026-10-10 用户恢复 16 KiB 工作并更新验收标准，替代此前「等待原生 16 KiB 实机而搁置」的决定。真实 16 KiB 页大小模拟器验证通过，加普通 4 KiB 实机正常使用通过，即可验收合并。ARM 转译与未测试边界如实说明，未来真实 16 KiB 设备发现问题再开独立分支修复。当前实施与历史边界以 [16 KiB 专项记录](../native-16kb-compatibility.md) 为准，旧分支保留为历史来源。
- Gboard 的「点击主题立即出预览」与动态配色是**两条独立链路**：预览机制负责渲染，配色由主题提供器产出。我们做动态配色时落地形态是一个新的主题提供器，**列表项与预览链路可原样复用，预览不需要重写**。机制为「内存 Bitmap 缓存 + 占位图 + 异步回填」三件套，可用平台原生类实现，不引入新依赖。详见 [Gboard 预览机制](../gboard-preview-mechanism.md)。
