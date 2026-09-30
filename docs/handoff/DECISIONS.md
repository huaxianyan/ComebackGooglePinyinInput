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
- **进度状态（2026-09-30）**：方案已定，代码尚未按此方向实施；白屏版补丁仍在工作树里。效果对比图已交用户取舍，等待答复。详见 [2026-09-30 交接](./2026-09-30.md)。


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
