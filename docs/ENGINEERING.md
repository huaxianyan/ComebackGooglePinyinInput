# 工程细则

`AGENTS.md` 只留稳定约束与本机信息。原生行为、构建链、界面边界与标点补全的实现在这里。

## 原生行为与分支

- 正式包名为 `com.google.android.inputmethod.pinyin.compat`，正式签名身份保持不变。
- 默认保留原生输入、候选、学习权重、词典格式、手写、主题、分页与触摸语义，优先修复已定位缺陷。
- 新增原生能力须使用独立分支和明确授权。默认关闭，关闭时逐入口交回原实现，不新增键盘布局或改变既有按键与候选语义，并完成静态门禁及真机验收。
- 英文 9 键的「复古 9 键」是已接受的能力，沿用既有多击、关闭回退与候选规则。
- 后续开发从最新 `master` 创建主题分支，设置改造、16 KiB、预测性返回、系统版本迁移、破坏性词典测试和 Debug 诊断分别验收。
- 已完成验收才合入和清理分支引用。暂停或未完成工作保留，不因文档整理重放旧代码、rebase 开发分支或操作其他 worktree。
- 清理时核对本地、远端、worktree 和提交包含关系。等价重放核对实际补丁，远端删除使用明确旧 SHA 保护，本地优先 `git branch -d`。
- 已归档失败实验只保留历史，不恢复旧实现。
- 2026-11-04 起不采用逐函数重写原生库的路线：保留原版 `lib/*.so` 黑箱，Java／Android 层维持正常源码，
  原生层缺陷只在 Java 侧规避。原生重写研究分支已本地与远端删除，历史提交可由 SHA 恢复，但不再作为基线。
  记录见仓库 `docs/handoff/2026-11-04.md`。
- 原生库的 16 KiB 兼容由构建期 ELF 重写与静态审计维持，是保留黑箱的代价；该链路的改动必须重跑审计。
- 构建方向是摆脱 apktool 工具链，方案未定前不落实现。已有一条已验收的备用链路
  （`scripts/build_no_apktool_chain.py`），正式发布仍走常规链路。
- 维护模式：存量原始类继续用 smali 补丁修改，新功能一律独立源码实现
  （`patches/java/`、`modern-settings`）并经 Compat 类接入，不新增 smali 功能代码。
  接触原生类优先「极小钩子 + Compat 类」。单轮修复改动超过 200 行 smali 时，
  才考虑对涉及的那个类做局部 Java 化。
- Java 层源码重写路线已彻底放弃，与原生库重写一并归档，不再作为备选重新评估。
  实测自有类 626、第三方类 2292，估算 6～8 周，收益受「默认不改原生语义」限制。
  记录见仓库 `docs/handoff/DECISIONS.md`。
## 本地工具与构建

- SDK、JDK 和机器代理继承机器级约定，构建时 `<android-sdk>` 与 `<jdk-17>` 取该约定里的共用路径。不在项目新增工具链安装副本，装之前先查机器上有没有。
- 现有脚本明确配置的现代设置 Gradle 工作目录为 `work/modern-settings-gradle-home`。不另设新的私有缓存，共享用户缓存只按必要范围读取或操作，不清空其他项目缓存。
- `work/` 是按可再生产物管理的容器，整目录删除不损失实现，留存与回收规则继承 `project-conventions` 技能。签名材料和用户专项授权导出不按缓存处理，删前单独确认。设备取材落 `work/device/`，不落在仓库根。
- 跨 Git Bash 与原生 Windows 的路径使用 `cygpath -w`，避免把 `/e/...` 传给原生 Python 或 MSBuild。错误输出不能被当作空结果或检查成功。
- 本机没有 AVD 目录，旧文档里的 AVD 与系统镜像目录 不存在，那是旧机器的布局。需要模拟器时先建并核对当前工具与镜像，不据旧启动耗时判断可用性。
- 旧 arm64 模拟验证使用 `work/emulator/emulator-34.2.16/`。平台、加速器和实际页大小在具体模拟任务中重新核对，不把模拟器结果写成真机结论。
- 补丁必须从原始 APK 可复现应用，实现维护在 `scripts/`、`patches/` 和源码目录，不能只改 `work/` 的解码产物。
- 完整宿主构建入口为 `work/dyn-inspect/build_all.sh`。Kotlin-only 改动也要使用对应完整流程，不能对已 prepare 的树直接重复 `resume_host_build.py --offline`。
- 宿主签名经 `MODERN_SETTINGS_KS_PASS` 与 `MODERN_SETTINGS_KEY_PASS` 等既有通道引用，参数值不写入约定、命令输出或日志。
- 构建期间不修改输入源码。核对实际产物字节与新符号，不以文件大小判断是否重建。
- Windows 上旧 apktool 收尾曾发生移动 `AndroidManifest.xml.orig` 被拒、但 APK 已生成的情况。遇到该具体故障需核对日志、产物及后续验证，不把任意非零退出码都解释为成功。
- apktool 解码会改写标签、寄存器、非 ASCII 转义和资源限定符。最终 APK 门禁按语义验证，不能仅匹配源码表现形式。
- 两个生成器覆盖面不同：`generate_dictionary_patch_smali.py` 管词典、同步与设置类，
  `DictionaryHealthStatusCompat` 归 `generate_rime_sync_smali.py`。改错脚本会得到
  「updated 0 Smali files」，源码改了但 APK 没变。生成后看 `git diff` 确认 Smali 真有变化。
- 研究探针在 `patches/research/`，只有 `apply_patches.py --research` 才会装进解码目录，
  正式包和 CI 产物里不存在（构建参数保证，不靠自觉）。用法见
  `docs/research/native-dictionary-import-research.md`。
- Java 补丁生成链为 `patches/java/` → 对应 `generate_*_smali.py` → `patches/smali/` → `apply_patches.py`。生成的 Smali 入库，自动应用未调用的生成器需按变更手动执行。
- 新资源显式登记 `public.xml` 并保持原始资源 ID。反射混淆方法需要匹配返回类型，相关断言沿用现有门禁。
- 原生库保留 `packaging.jniLibs.useLegacyPackaging = true`，低 API 安装、实际加载与对齐分别验证。
- 修改实现后按影响范围执行对应门禁和构建。仅整理文档不重跑历史产品验收。
## 界面与平台边界

- covering-IME 几何边界沿用 `docs/research/compatibility-notes.md`。导航视觉区域不扩大原生输入或触摸区域，不硬编码设备尺寸，不恢复已失败的 Insets 高度补偿。
- Header 功能复用统一模块生命周期、仲裁、主题、几何与清理接口。Clipboard 使用真实 Candidate，Inline Autofill 保持独立远端 Surface，不读取凭据或把建议转换为普通文本提交。
- 设置与首次引导使用官方 Compose Material 3，原 Preference key、类型、默认值、unset 状态和业务回调保持不变，不用手绘模拟官方控件。
- 独立 Compose 宿主与原生键盘补丁分开处理依赖和资源，保持原始资源 ID，不用批量删除旧资源绕过冲突。
- 新引导采用同页启用、选择和完成路径。首次 Back 与完成路径保持独立，完成时原子记录后进入设置并正常结束。
- 预测性返回按已接受的设置范围维护，主题编辑、首次引导和键盘保留各自返回语义，不把全局统一返回列为补完目标。
- 16 KiB 验收使用实际页大小为 `16384` 的模拟器，加普通 4 KiB 实机回归，明确 ARM 转译与未覆盖项。不为验收解锁或改造用户设备，不用 ZIP 对齐代替 ELF 与实际加载验证。
- API 27～29 等未完成运行验证的范围注明推断，低 API 门禁、实际 ART 加载、完整功能和主观体验分别记录。
## 成对标点自动补全（2.1.x，log 迁入）

- 一个开关管中英两边：中文走处理器链（`PairedPunctuationProcessor`），英文在 IME 自己的 `handle()` 里调共用 helper（`PairedPunctuationHook`）。配对表只有一份（处理器里那份，`public static` 共用），两语不会漂移；改表必须同步 `scripts/verify_paired_punctuation.py` 钉住的清单。
- 表里 31 对：半角/全角括号、书名号及其变体、弯引号与直角引号、直引号 `"`，以及符号键盘「括号」页的装饰括号/引号与竖排形式（U+FE35..U+FE42 等）。**`'` 故意不在表里**：它在英文里同时是撇号，`don't` 会被补成 `don''t`。
- **中文九键左侧的引号键是特例，不要介入**：它是全树唯一 `DECODE` 意图的标点软键，按一次左弯引号、再按一次右弯引号，这个交替来自 Google 自带的中文标点转换，处理器看不到它。要接管就得把意图改成 `COMMIT`，那会同时关掉中文全角转换与交替——不要动。英文九键同名键用 `COMMIT`，会正常补全。
- **英文不能走处理器链**：全 APK 只有 `ProcessorBasedIme` 读 `<processors>`，`LatinIme` 对它引用数为 0，给英文 `<ime>` 加 include 会被静默忽略。且 `AbstractIme.mContext` 在英文路径的 `handle()` 里运行时是 null，两个英文 IME 必须各自覆盖 `initialize()` 把 Context 存进 helper 的静态字段。
- 框架会在键盘就绪时派发一个 intention 为 null 的软键事件，守卫要把「值缺失」当作普通拒绝，且绝不在这类值上调方法。
- `patches/smali/EnglishT9MultiTapIme.smali` 行尾是 **CRLF**（上游 PR #8），改它必须字节替换 + `os.replace`；`patches/smali/pairauto/` 下的类必须手写 Smali（`ProcessMessage` 的字段 `a` 有 13 种不同类型，`javac` 编不出来）。
- 属性门禁只对**成品合并态**解码树跑，补丁源码树与复用树都会误报 `the feature must default to enabled`。
- 偏好 `en_t9_multitap_enabled`（界面名「复古 9 键」）**缺省为 false**，此时软键点出的符号会吃掉第一次退格。正式包 compat 显式写 `true`、隔离测试包没有这个 key，所以同一份代码表现不同。**遇到两个包行为不一致，先逐项比偏好**（`edit_prefs.py PKG live KEY=VAL` 单变量改一项，行为翻转即定案）。
- 键盘页面会自行漂移，且字母页与符号页的切换键占同一位置，**不要靠截图判断当前页**（误判会把键盘切到反方向）；脚本改成按结果重试。Google 输入法的软键不是 uiautomator 可访问节点。
- 设备：正式包 `com.google.android.inputmethod.pinyin.compat`，隔离测试包 `...pinyin.pairauto`，屏幕 1080×2410。机器已 root，可直接读写私有目录；锁屏有密码，助手不能自行解锁。
