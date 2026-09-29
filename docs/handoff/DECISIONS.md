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

## 已决定不改的行为

- 英文键盘上符号后第一次退格只退出建议、删成对符号要按两次，判定为原版 Google 拼音输入法既有行为，**不改代码**。
- 理由：消除它要么收窄喂给原生解码器的 `symbols_word_separators`（连带改自动空格、自动大写、句末判定），要么改解码器退格判据 `adw.a(JLchw;)Z`，都超出「修复已定位缺陷」的范围。
- 处理方式：不做界面文案提示（避免误导成补全功能带来的问题），只在 Release 页面写明这一既有行为与保留理由，由用户自行判断是否开启补全。
- 一次性说明写在 `docs/releases/v2.1.3.md` 的「已知行为说明」小节，作为该版本的额外说明，不进入标准发布流程模板，也不进 `CHANGELOG.md`。

## 已知坑与结论

- 英文 IME 定义里的 `extra_value_latin_enable_suspend_prediction_on_backspace` 不能改成 `false`。`adw.a(JLchw;)Z` 里 `cgp.h == false` 会**无条件**进入挂起分支，改 `false` 会让候选缺失的退格全部被吞，问题加重。详见 [英文符号引发后续建议与首次退格被吞的调研](../symbol-backspace-swallow-research.md)。
- 符号后第一次退格被吞由各语言的 `symbols_word_separators` 决定，与符号自身无关。会结束词的符号，其后退格被解码器挂起。同上。
- 「只让符号不引发预测、保留字母的下一词预测」在补全钩子里做不到：清空联想容器的 `azh.b()V` 是私有方法，框架侧可达的 `textCandidatesUpdated` 与 `finishComposingText` 都只是向外通知。同上。
- 16 KiB native page-size 最终验收搁置，`fix/native-16kb-page-size` 的实现和证据保留。
