# 长期决策

只记稳定结论，被推翻时才改。当轮过程与试错放在同目录的日期文件里。

需要指向内网地址、服务器路径、设备信息或凭据位置时，只写「见本地 `AGENTS.md`」，把具体值留在那个不入库的文件里。

## 仓库定位

- 仓库：`https://github.com/huaxianyan/ComebackGooglePinyinInput`。
- 正式包名：`com.google.android.inputmethod.pinyin.compat`。
- 当前正式基线：`v2.1.3`（`master` 已含成对标点补全的成对删除与智能跳过，三条路径各三条场景全部通过真机验收），`targetSdkVersion=36`，`minSdkVersion=17`。
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

## 底部行标点显示开关

- 逗号键、句号键各有一个独立显示开关，位于「键盘 → 按键」，与表情切换键、语言切换键同组。中文与英文底部行都提供。全屏手写不纳入。
- 语义是「隐藏按钮让出空间由空格键延伸」，不是交换字符，与「双空格输入句号」是两件事，实施时不得混同。
- 关闭逗号后长按表情入口一并消失，视为预期，仅在设置项说明里提示。
- 状态位用 bit 55（逗号）与 bit 58（句号）。**不可用 bit 56、57**，它们分别是 `abs.STATE_SINGLE_CHARACTER_CANDIDATE` 与 `abs.STATE_ENABLE_SC_TC_CONVERSION`；bit 60 被 `bdx.STATE_SHUANGPIN_MS_ZIGUANG` 占用。也不用 `Laku$a` 动态段（19–43）与 customized 保留段（61–63）。
- 选位必须同时满足两条约束：位值落在 `aku.<clinit>` 的反射掩码内（原为 `0xffffffffffffff`，现已加宽到 `0x7ffffffffffffff` 覆盖 bit 0–58），且不与 `aku`、`abs`、`bdx` 已声明的任何 `STATE_*` 位冲突。只看掩码会把已被占用的位误判为空闲。
- 关键机制三条：偏好只能按名读（`Lamx;->a(Ljava/lang/String;Z)Z`），新资源 id 无法在 smali 硬编码；空软键的可见性恢复布局初值，槽位须声明 `gone`；`Lauf.a(J)` 后遍历覆盖，状态映射组须排在 stock 映射之后。
- 方案与门禁见 [实施设计](../comma-period-toggle-design.md)，原调研见 [逗号与句号显示开关方案调研](../comma-period-toggle-research.md)。
- **实现方式限定为「纯布局 + keymapping」，不得新增 View 子类，也不得运行时改写 `layout_weight`。** 参考对象是原版语言切换键：布局声明 `visibility="gone"`，keymapping 用状态位在真实键与 `softkey_empty` 之间切换，框架自动处理可见性。逗号、句号槽位是顶层兄弟，gone 后释放的宽度按权重比例摊给所有可见兄弟，空格因此变宽，其余键一同微增，这一点作为既定取舍接受。
- 理由：曾新增 `CommaPeriodToggleKeyView` 改写空格权重，真机上导致除手写外的全部键盘布局白屏，且日志无异常，无从定位。`SoftKeyView` 本身不读写权重，没有任何框架钩子可按状态改权重，绕过布局去改权重的收益不足以承担渲染失败的风险。
- **进度状态**：**已搁置（2026-09-30）**。用户判定工程量超出预期，决定不做，等待更合适的实现路径。方案 B/A 从未拍板，代码未按纯布局方向实施，白屏版补丁仍留在工作树（未构建、未发布）。详见 [逗号句号开关：项目搁置决策记录](../comma-period-toggle-shelved.md)。


## 键盘布局插件化（独立 APK 提供布局）

- 结论：**「独立 APK 提供键盘布局供输入法读取」在原版框架上不可直接实现**。原版确有按包名解析资源的机制（`ang` 类，即 `Lang`，三级回退：模块包名 → 自身包名 → 递归 delegate），但它是为**同一 APK 内的模块资源覆盖**设计的，写入点在 `PinyinApp` 启动时取 `R.class.getPackage().getName()`。`Resources.getIdentifier` 只在本 APK 的资源表内查找，跨 APK 读取是 AssetManager 层安全边界，加权限也绕不过。
- 状态位容量同样不支持开放接口：64 位掩码中 bit 55、58 已占用，仅剩 59、61–63 共 4 个空闲位，且注册表全局唯一，插件之间必然冲突。
- 若确需对外开放，收敛为**布局配置规范**（开发者提供数据，输入法负责渲染），不碰跨包资源、不新增状态位。详见 [键盘布局插件化可行性调研](../keyboard-layout-plugin-research.md)。
- 不做通用插件接口。
- **补充（产物归属问题）**：任何布局方案最终都要进输入法自己的资源表——`<view layout="@layout/...">` 走 `getAttributeResourceValue` 取**编译期资源 id**（`KeyboardViewDef$a` 实证），布局不在本 APK 资源表里就拿不到 id，`inflate` 直接断链。因此「多个开发者各塞一套布局」不存在可行实现，改配置格式只是把膨胀从代码挪到配置目录。
- **分层原则**：可扩展的应是「框架解析后的参数」，不是「框架解析的输入」。第 1 层固定开关、第 2 层用户级参数、第 3 层用户级配置（JSON）都不进资源表，不产生膨胀；第 4 层第三方布局包必然膨胀，唯一可行形态是提 PR 由维护者合入。详见 [键盘布局扩展的边界与分层](../keyboard-layout-extensibility-limits.md)。

## 用户自定义键位

- 键位由三层构成：**布局槽位**（`keyboard_prime_bottom.xml`，槽位 id 与权重）→ **映射**（`keymapping_*.xml`，`view_id` → `key_id`）→ **软键定义**（`softkeys_*.xml`，action/label/long_press）。
- **映射层可以运行期重建**：`KeyMappingDef` 有 Builder（`KeyMappingDef$a`，`a(Z)` 建、`a(ILSoftKeyDef;[J)` 加、`a()` 出）。框架自己在 `SoftKeyViewsMapper$MergeMultiLingualKeyMappingDefTask` 里就这么干（跨语言合并时重建映射表）。这是「用户自定义键位」的可行落点。
- **布局层与 XML 解析层都只认资源 id**：`SimpleXmlParser.a(Context, int resId)` 是唯一入口，不接受文件路径或 InputStream；布局用 `getAttributeResourceValue` 取编译期 id。因此「用户提供一份布局/keymapping XML 直接加载」不可行。
- **能做的**：每个既定槽位里放哪个键（换键、对调、复用功能键、映射到 `softkey_empty` 屏蔽）。**不能做的**：槽位数量、顺序、权重（即「空格左右各加一个键」「两个槽位合并成宽键」）。
- 推荐先做映射层（第 2 层）：不需要重打包、不新增资源、不新增状态位，风险最低。逗号句号开关是它的特例（等价于把两个槽位映射到 `softkey_empty`）。
- 详见 [用户自定义键盘键位：可行边界与实施路径](../custom-key-layout-feasibility.md)。
- **重要纠正（同日）**：映射层方案**不足以满足「用户自定义键位」**。用户要的是**布局改变**（键的位置、数量、宽度），映射层只能改「每个槽位放什么键」，是范围不足的方案。用户已明确否定。
- **布局在编译期固化，运行期无任何钩子**，证据链四环：① 布局 id 来自 `getAttributeResourceValue`（编译期）；② `GoogleInputMethodService.loadSoftKeyboardView` 用 `inflate(resId)` **一次成型整棵树**并按 resId 缓存；③ `SoftKeyView` 对 `LayoutParams`/`weight` 引用数为 **0**；④ 键盘视图路径上**无任何 addView/removeView**。
- **原版扩展系统（`ExtensionManager`）只扩展功能面板，不扩展布局**。模块注册（`Lawu.b()`）从**自身** `ApplicationInfo.metaData` 读 `"module:"` 前缀项，第三方包无法注册。
- **最终结论**：用户自定义布局**不可行**。唯一形态是「输入法内置有限几套完整布局，用户在其中选」——这是选预设，不是自定义。若坚持任意布局，只能进输入法资源表（即由维护者合入 / 提 PR）。
- 详见 [用户自定义键盘布局：边界纠正与真正的结论](../custom-layout-boundary-correction.md)。

## 自定义布局框架（JSON 导入）评估

- 用户提出：加一层框架，支持导入 JSON 定义布局，设置里做布局管理（启用/隐藏/删除/导入），并接入「选择键盘布局」。
- **结论：技术可行，但工程量是新子系统级别，不是补丁。**
- **两个现成能力（原版就有）**：① `PinyinIME.a()`（第 179 行）返回 `bbc` —— 输入法自包装的 `LayoutInflater`，在 inflate 前后都能拦截；② `bar`/`bbc` 已实现 `inflate(XmlPullParser, root, attach)` 重载，**可从任意 XML 流构建视图树**，不受资源 id 限制。
- **核心难点**：键盘需三套东西同时就位 —— 视图树（JSON 负责）、映射表（槽位 id → 软键 id）、软键定义。JSON 只能自由描述视图树；**槽位 id 必须是框架认识的既有 id**，否则运行时按 id 查不到软键，抛 `SoftKeyDef 0x%x has not been defined.`。这限制了「只能重排已有槽位、复用已有软键」。
- **其他要点**：布局 id 可在 `KeyboardViewDef` 创建时替换（字段 `final`，不能事后改）；`GoogleInputMethodService` 按布局 resId 缓存 `SoftKeyboardView`，自定义布局需另设缓存键；**建议走「换布局 id」而非新增状态位**，避开只剩 4 个空闲位的限制。
- **风险**：白屏（本项目已发生一次且日志无异常）、状态位耗尽、JSON 损坏致不可用。
- **强烈建议先做最小验证**：硬编码一段 XML 走 parser 重载，确认能渲染且能点击，再决定是否投入完整方案。
- 详见 [自定义键盘布局框架（JSON 导入）：技术评估](../custom-layout-framework-assessment.md)。
- **状态：已搁置（2026-09-30）**。用户判定整体工期超出预期，随逗号句号开关一并停止，未做任何验证探针。技术结论保留，重启前应先读搁置记录。

## 参考实现：T+ fork（新增整套静态布局）

- 仓库 `JunperoH/Tback-google-pinyin-input` 与本项目**走同一条技术路线**（`original` + `patches` + `scripts` 补丁式改造同一份 Google 拼音 4.5.2 APK），在同一基线上**成功新增了一整套 T+ 双字母布局**，已上真机。是本项目最有参考价值的外部实现。
- **新增整套布局的真实成本远低于此前估计**：只需资源文件（`keyboard_*.xml`、`keymapping_*.xml`、`softkeys_*.xml`、`values/*.xml` 声明 id、`ime_*.xml` 注册）加一个 IME 注册项，**不改 `KeyboardViewDef`、不新增状态位、不重写 inflate**，几十个 XML 全部可脚本化生成。
- **槽位 id 池是跨布局共享的全局资源**：T+ 的 `keyboard_tplus_body_inner.xml` 直接 `<include layout="@layout/keyboard_prime_bottom" />` 复用了本项目的目标文件。这意味着 JSON 布局方案不需要发明新 id，只需重新组合既有 id 池——**这正是「多 JSON 共用一套 id 池、无需预注册」的技术依据**。
- **资源 id 可静态固化**：`scripts/generate_stable_resource_ids.py` + `verify_stable_resource_ids.py` 让每次重建生成同一套 id，避免资源表重排致 smali 引用失效。若要重启 JSON 框架，这是预留固定 id 区间的现成做法。
- **自定义 KeyView 子类可行但有门槛**：`SimplifiedTraditionalToggleKeyView`（`extends SoftKeyView`）+ 生成脚本 + 9.5 KB 门禁 + 设备验证。本项目白屏的 `CommaPeriodToggleKeyView` 属同类但只有第一步，这是白屏的深层原因。
- **新增静态布局 ≠ 运行期可配置布局**。T+ 提供的是「一整套布局长什么样」的清单与工程手法，不提供 JSON 运行期加载的任何东西。
- 详见 [参考实现调研：Tback-google-pinyin-input](../reference-tplus-fork.md)。

## 已决定不改的行为

- 英文键盘上符号后第一次退格只退出建议、删成对符号要按两次，判定为原版 Google 拼音输入法既有行为，**不改代码**。
- 理由：消除它要么收窄喂给原生解码器的 `symbols_word_separators`（连带改自动空格、自动大写、句末判定），要么改解码器退格判据 `adw.a(JLchw;)Z`，都超出「修复已定位缺陷」的范围。
- 处理方式：不做界面文案提示（避免误导成补全功能带来的问题），只在 Release 页面写明这一既有行为与保留理由，由用户自行判断是否开启补全。
- 一次性说明写在 `docs/releases/v2.1.3.md` 的「已知行为说明」小节，作为该版本的额外说明，不进入标准发布流程模板，也不进 `CHANGELOG.md`。

## 真机验收的安装纪律

- 真机验收一律用**独立包名的审计包**（如 `com.google.android.inputmethod.pinyin.pairauto`），不用正式包名 `compat` 覆盖安装未验证的构建。正式包名只在验证通过、准备发布时使用。
- 理由：本轮曾把未验证的 2.2.0 以正式包名覆盖安装，因状态位掩码越界导致输入法启动即崩，影响用户日常使用，且降级需卸载、会清空用户词典。
- 手动构建必须显式带 `--version-name`/`--version-code`，或依赖脚本从 `version.properties` 读取的新默认值，避免产出低版本包被系统拒装。

## 已知坑与结论

- 英文 IME 定义里的 `extra_value_latin_enable_suspend_prediction_on_backspace` 不能改成 `false`。`adw.a(JLchw;)Z` 里 `cgp.h == false` 会**无条件**进入挂起分支，改 `false` 会让候选缺失的退格全部被吞，问题加重。详见 [英文符号引发后续建议与首次退格被吞的调研](../symbol-backspace-swallow-research.md)。
- 符号后第一次退格被吞由各语言的 `symbols_word_separators` 决定，与符号自身无关。会结束词的符号，其后退格被解码器挂起。同上。
- 「只让符号不引发预测、保留字母的下一词预测」在补全钩子里做不到：清空联想容器的 `azh.b()V` 是私有方法，框架侧可达的 `textCandidatesUpdated` 与 `finishComposingText` 都只是向外通知。同上。
- 16 KiB native page-size 最终验收搁置，`fix/native-16kb-page-size` 的实现和证据保留。
- 新增静态状态位（`STATE_*`）必须同时通过两条校验。其一，位值落在 `aku.<clinit>` 的反射掩码内（`(~mask & value) == 0`），原掩码 `0xffffffffffffff` 只覆盖 bit 0–55，否则抛 `is not in the range`。其二，位值不得与其他已声明的状态位重合，`aku`、`abs`、`bdx` 三个类的 `STATE_*` 都注册进同一个 `Laku;->a:Lkm` 表，重合时抛 `conflicts with`。两条约束互相独立，掩码内的位不代表可用。已知占用：bit 56 属 `abs.STATE_SINGLE_CHARACTER_CANDIDATE`，bit 57 属 `abs.STATE_ENABLE_SC_TC_CONVERSION`，bit 60 属 `bdx.STATE_SHUANGPIN_MS_ZIGUANG`，bit 19–43 属运行期分配段。掩码在整个 smali 里只被 `aku.<clinit>` 这一处读取，需要更多位时加宽它是安全的，但必须逐位核对占用表，不能只看掩码边界。
