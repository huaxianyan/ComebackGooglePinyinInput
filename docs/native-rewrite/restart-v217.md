# v2.1.7 源码重建重启记录

## 本轮目标与结果

2026-10-18，维护者要求重启旧研究，先补齐近期功能，再继续逆向与开发。目标是把当前版本重建为可读、可维护的源码，后续开发和构建以源码为唯一入口，而不是换目录保存反编译产物。

本轮从 master `242f9ea` 创建 `research/native-rewrite-v217`，按路径取回旧研究分支 `5f9876449a9b18c3e70ac3bceacfe37bcf7162d9` 的 19 份研究文档、脚本、测试和依赖声明。没有 merge 或 rebase 旧分支，也没有带回旧产品实现。旧分支保持原样。

本轮先完成基线和功能清单对齐，随后新增可在既有工具条件下执行的 ABI 研究入口。结果见 [JNI 与 C++ 边界](native-abi-map.md)。尚未建立独立构建的输入法源码工程，旧数据解析与完整反汇编依赖也尚未恢复。

目标与分支归档条件统一见 [研究计划](../native-rewrite-plan.md)。功能身份与状态统一见 [功能清单](feature-inventory.md)，本记录不另设一份能力总表。完整调查未结束，构建缺口和下一步环境需求见 [调查状态](source-reconstruction-readiness.md)。

## 当前基线与旧成果

当前行为基线固定为已发布 `v2.1.7`，身份见 [基线与方法](baseline-and-methodology.md)。原始 APK 仍作为底层算法、格式和指令研究的固定输入，旧指令地址不自动成为当前发布库的地址。

旧研究已经提供：

- 应用、资源、DEX 和 native 边界盘点
- data bundle、Marisa、token dictionary 和 DirectMapping 的部分格式与离线查询工具
- expansion score、结果身份三元组和部分类别请求的指令证据
- 尚未连接完整的 JNI、decoder 初始化、结果消费和候选输出链

这些是还原源码的证据和工具，不是已经恢复的完整输入引擎。旧表中的替代引擎、退役和产品取舍提案不视作本次授权。

近期功能的对齐入口：

| 功能清单 ID | 现有实现或契约入口 |
| --- | --- |
| DAT-007、DAT-008、DAT-011 | `patches/java/` 中备份与 Rime 实现，`docs/dictionary-auto-backup-design.md` 及现有 Rime 专项文档 |
| MOD-018、UI-019 | `patches/java/`、`patches/smali/` 中复古 9 键和成对标点实现，以及对应生成器和门禁 |
| UI-006、VIS-008、VIS-010 | 统一 Header、主题、高刷和手写布局补丁，`docs/compatibility-notes.md` |
| SET-006、SET-008、SET-009、SET-010、SET-011 | `modern-settings/compose-runtime/src/`，偏好清单及设置恢复说明 |
| PLT-001～PLT-007 | `version.properties`、构建脚本、签名配置和 `docs/build-and-release.md` |

已有可读 Kotlin/Java 实现优先直接整合，不能为了「重写」再维护一套相同业务规则。依赖旧混淆类、反射、DEX 拼接或资源 ID 的连接点需逐项替换为源码工程的真实实现，不能用占位返回值凑通编译。

## 发布库与原始库的边界

使用 Python 标准库读取两个 APK 的 ZIP 内容，只比较 native 文件字节并列举 DEX。输入分别为仓库固定原始 APK 和发布阶段已核对的 `v2.1.7` 下载资产，没有重新核验同一发布身份或执行 APK。

原始 APK 为单 DEX，当前发布包为 `classes.dex` 至 `classes4.dex`。native 文件比较结果：

| 文件 | 相对固定原始 APK |
| --- | --- |
| `libandroidx.graphics.path.so` | 当前新增 |
| `liben_data_bundle.so` | 字节变化 |
| `libgnustl_shared.so` | 字节变化 |
| `libhmm_gesture_hwr_zh.so` | 字节变化 |
| `libhwrword.so` | 字节变化 |
| `libpinyin_data_bundle.so` | 字节一致 |

本轮证据位于被忽略的 `work/native-rewrite/restart-v217/artifact-boundary.json`。字节变化本身不证明算法改变，也不能单凭它判断具体重排方式。当前版本的 16 KiB 与系统适配结论沿用已有验收，原始库的大小、alignment、地址和 relocation 坐标仍只用于原始库研究。

## REA 与本机研究条件

REA 是分析编排与证据工具，不是从 APK 自动得到完整、语义等价源码的编译器。它可以用于研究，但不能进入最终产品构建依赖。

依据上游文档，本轮判断如下：

- Android 分析封装 JADX，可辅助类、方法和静态引用调查。需要匹配的 REA 发布包、完整 JDK 17+ 和固定版本引擎 JAR，实际主机可用性仍需验证。
- 官方 Windows Ghidra 接口当前列出的 native 准入范围不包含本项目的 ARM64 ELF。不能把 Windows ARM64 PE 支持理解成 Android ELF 支持，也不能据此断言 Ghidra 本体不能分析 ELF。
- 后续若需要 REA/Ghidra 处理核心库，先选择支持该输入的分析主机与 provider，再核对已有共用工具。暂不自动安装工具、注册 MCP 或运行会改写多处用户配置的 `rea setup`。
- 本机当前命令所用 Python 未找到 `capstone`、`lief`、`marisa_trie`。旧工具的依赖版本保留在 `research/native-rewrite/requirements.txt`。没有执行需要这些依赖的旧测试，也没有新建项目私有工具安装副本。

上游依据：

- [REA Android 分析](https://github.com/morluto/rea/blob/main/docs/android-analysis.md)
- [REA Windows Ghidra 支持边界](https://github.com/morluto/rea/blob/main/docs/windows-ghidra-p0.md)

上游 main 与 npm 发布包可能存在差别。正式接入时应锁定具体版本并做一次真实输入验证，本轮不声明 REA 已接入或可在当前主机分析核心库。

## 下一段研究与实现入口

本轮已用既有 dexlib2 和标准库恢复 JNI、RTTI、虚表候选、函数范围与直接分支证据，连接引擎刷新、词典刷新和手势扩展器的部分类型路径。

接下来恢复所需共用分析依赖，不重复建设工具环境。继续追踪缓存消费者及搜索、评分、学习和各模式状态，不能用已知 ABI 代替完整引擎源码。具体未关闭项见调查状态。

阶段产出应是有来源的类型、字段、调用关系与未决项，而不是把反编译器伪代码直接当源码。对已确认的独立格式或函数，可以先实现和对照验证，不必等待全机研究结束。

每个源码组件至少能说明：

1. 来自哪个固定输入，保持哪项现有行为。
2. 哪些字段与分支有证据，哪些仍未知。
3. 如何以正常编译入口构建，如何用独立的原行为或数据证据作对照。
4. 仍依赖哪些旧二进制或构建步骤，距离最终源码入口还缺什么。

没有真实输入路径的空输入法、写死候选、不可编译伪代码，或者保留闭源引擎只重写界面，都不能作为整体重构完成的证据。本轮没有构建、安装 APK，没有访问设备数据，也没有改动正式发布和签名材料。
