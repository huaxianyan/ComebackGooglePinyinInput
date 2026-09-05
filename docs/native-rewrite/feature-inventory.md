# 原生重写功能清单

## 用途

本文档是原生重写范围的唯一总表。详细研究文档负责解释证据和机制，本表负责记录每项能力的身份、状态、目标处理和下一步，不在其他文档重复维护同一状态。

当前为阶段 0 首版清单，依据：

- 固定 Google 拼音 `4.5.2.193126728` APK 的 Manifest 和资源静态盘点
- `README.md`、`CHANGELOG.md` 和现有 `docs/` 研究记录
- Comeback `v2.0.10`，提交 `1e8fb9276acd3ef666536222dd394170427ff033`

Rime 双向同步尚未进入本基线。其分支完成并合并后再更新对应条目。

## 状态

| 状态 | 含义 |
| --- | --- |
| 已确认 | 固定输入或已有可重复证据能够证明结论 |
| 部分确认 | 已确认入口或部分行为，核心机制仍未知 |
| 待研究 | 只有资源、名称或间接证据，尚不能说明实际逻辑 |
| 待决策 | 事实基本清楚，但原生版本的产品取舍未确定 |
| 已退役 | Comeback 已明确移除，不计划按原方式恢复 |
| 外部进行中 | 由独立分支开发，合并后才进入本研究基线 |

## 处理类型

| 处理 | 含义 |
| --- | --- |
| 保持 | 原生版本应尽可能保持当前用户行为 |
| 重建 | 保留能力，内部实现从零建立 |
| 迁移 | 当前原创实现或稳定契约可以迁入原生工程 |
| 替代 | 使用新的本地、公开或许可证明确的实现满足同一目标 |
| 退役 | 不恢复失效或不再需要的历史能力 |
| 未定 | 需要更多证据或产品决定 |

## 1. 应用和生命周期

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| APP-001 | `ORIGINAL`、`COMEBACK` | 安装后启用、选择并完成首次引导 | 已确认 | 迁移 | 整理当前单页引导的最终状态机 |
| APP-002 | `ANDROID`、`ORIGINAL` | `InputMethodService` 注册及输入视图生命周期 | 部分确认 | 重建 | 建立 Service 回调和会话状态图 |
| APP-003 | `ORIGINAL` | Direct Boot 感知 | 已确认 | 未定 | 调查锁定前实际可用数据和降级行为 |
| APP-004 | `ORIGINAL`、`COMEBACK` | Launcher 图标动态显示 | 已确认 | 迁移 | 提取最终 Preference 与组件状态契约 |
| APP-005 | `ORIGINAL` | Android BackupAgent 恢复 | 部分确认 | 未定 | 调查实际备份集合及首次引导污染边界 |
| APP-006 | `ORIGINAL` | 输入字段、应用、方向和配置切换 | 部分确认 | 保持 | 建立生命周期中断行为样本 |
| APP-007 | `ORIGINAL` | 语言、语音和其他输入法切换 | 已确认 | 保持 | 整理 Window token、subtype 和返回状态 |
| APP-008 | `ORIGINAL` | 手机、平板和横屏布局 | 部分确认 | 重建 | 建立资源限定符与实际布局矩阵 |
| APP-009 | `ORIGINAL` | Android TV 输入法和设置 | 待决策 | 未定 | 确认产品是否继续支持电视 |
| APP-010 | `ORIGINAL` | 浮动实体键盘及 12 键、QWERTY 变体 | 待研究 | 未定 | 确认可达条件和用户价值 |

## 2. 拼音和候选引擎

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| ENG-001 | `ORIGINAL` | 全拼字符输入和 composing | 部分确认 | 重建 | 建立增量输入状态样本和 Java/native 边界 |
| ENG-002 | `ORIGINAL` | 音节切分和撇号分隔 | 待研究 | 重建 | 构造歧义音节样本 |
| ENG-003 | `ORIGINAL` | 简拼和不完整拼音 | 待研究 | 重建 | 确认接受范围、候选和回退规则 |
| ENG-004 | `ORIGINAL` | 七种全拼、双拼方案 | 已确认 | 重建 | 已恢复六套双拼的 key、token ID、code 和 node ID 映射，并确认三套方案存在 alias，继续研究零声母规则 |
| ENG-005 | `ORIGINAL` | 12 组模糊拼音规则 | 已确认 | 重建 | 494 个 source 和 988 个 target 已全部对齐到全拼 key，并保留独立 expansion score，继续建立组合样本 |
| ENG-006 | `ORIGINAL` | 单字、词组和长句候选 | 部分确认 | 重建 | 分析候选图、分段和整句路径 |
| ENG-007 | `ORIGINAL` | 候选排序、去重和选中项 | 部分确认 | 重建 | 分离静态词频、上下文和用户学习影响 |
| ENG-008 | `ORIGINAL` | 候选增量请求和分页 | 已确认 | 重建 | 调查批次协议、hasMore 和稳定顺序 |
| ENG-009 | `ORIGINAL` | 部分选择和剩余拼音重新组词 | 待研究 | 重建 | 建立部分提交、删除和光标行为样本 |
| ENG-010 | `ORIGINAL` | 中文联想和下一词预测 | 已确认 | 重建 | 区分提交后预测与 composing 候选 |
| ENG-011 | `ORIGINAL` | 中英文混输 | 已确认 | 重建 | 已确认独立英文 token、system dictionary 和运行时追加逻辑，继续调查候选类型与自动空格 |
| ENG-012 | `ORIGINAL` | 中文数字混输 | 部分确认 | 重建 | 已确认独立数字 token、system dictionary 和运行时追加逻辑，继续建立行为样本 |
| ENG-013 | `ORIGINAL` | Emoji 候选建议 | 已确认 | 重建 | 已确认独立 Emoji system dictionary 和运行时门控，继续调查触发条件与优先级 |
| ENG-014 | `ORIGINAL` | 简繁转换 | 已确认 | 替代 | 研究四个转换数据文件及可分发替代方案 |
| ENG-015 | `ORIGINAL` | 双空格句号 | 部分确认 | 保持 | 调查历史失效条件及预期行为 |
| ENG-016 | `ORIGINAL` | 中文自动空格 | 已确认 | 重建 | 调查混输边界和 OutputProcessor 协议 |
| ENG-017 | `ORIGINAL` | 空格滑动移动光标 | 已确认 | 重建 | 建立手势阈值和编辑状态样本 |
| ENG-018 | `ORIGINAL` | 空间模型 | 已确认 | 重建 | 调查按键坐标、纠错和候选排序关系 |
| ENG-019 | `ORIGINAL` | 不雅词过滤 | 部分确认 | 未定 | 确认词表、过滤阶段和默认语义 |
| ENG-020 | `ORIGINAL` | Incognito 输入状态 | 部分确认 | 重建 | 确认进入条件及学习、日志和持久化边界 |

## 3. 词典、学习和数据

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| DAT-001 | `ORIGINAL` | 中文基础词典和语言模型 | 部分确认 | 替代 | 已定位 4 个 system trie 与 bigram 内的 2 个 trie，继续解析 auxiliary 数据、评分职责和可分发来源 |
| DAT-002 | `ORIGINAL` | 英文基础模型 | 部分确认 | 替代 | 分析 gzip、metadata 和 native 加载链 |
| DAT-003 | `ORIGINAL` | 中文用户词典学习 | 部分确认 | 重建 | 调查写入时机、权重、衰减和排序影响 |
| DAT-004 | `ORIGINAL` | 英文用户词典学习 | 部分确认 | 重建 | 调查与中文数据的文件及协议差异 |
| DAT-005 | `ORIGINAL` | 用户词典 `_bak`、`_tmp` 和保存恢复 | 已确认 | 迁移 | 将当前加固后的最终语义整理成独立契约 |
| DAT-006 | `ORIGINAL` | 原生用户词典导入、导出和合并 | 已确认 | 重建 | 研究文件格式并定义迁移测试 |
| DAT-007 | `COMEBACK` | SAF 自动备份、立即备份和版本轮换 | 已确认 | 迁移 | 提取 Provider 无关的稳定业务契约 |
| DAT-008 | `COMEBACK` | 用户词典健康状态 | 已确认 | 迁移 | 从旧文件名解耦为新引擎健康模型 |
| DAT-009 | `ORIGINAL`、`COMEBACK` | 联系人建议及权限控制 | 已确认 | 重建 | 调查联系人进入候选和词典的生命周期 |
| DAT-010 | `ORIGINAL` | Android 自定义短语入口 | 已确认 | 保持 | 调查系统词典读取和内部候选合并 |
| DAT-011 | `COMEBACK` | Rime 用户词典双向同步 | 外部进行中 | 迁移 | 合并后记录最终数据、冲突和删除契约 |
| DAT-012 | `ORIGINAL` | Google 账户词典同步 | 已退役 | 退役 | 保留历史说明，不恢复账户权限和 SyncAdapter |
| DAT-013 | `ORIGINAL` | 在线词典更新 | 已退役 | 替代 | 调查是否存在需要本地版本更新替代的用户价值 |
| DAT-014 | `ORIGINAL` | Android BackupAgent 数据恢复 | 部分确认 | 未定 | 盘点备份实体和升级行为 |
| DAT-015 | `ORIGINAL` | 清除用户词典及确认流程 | 已确认 | 迁移 | 保持备份、清除和恢复闭环 |

## 4. 键盘和输入模式

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| MOD-001 | `ORIGINAL` | 中文拼音 QWERTY | 已确认 | 重建 | 作为首个核心输入模式研究 |
| MOD-002 | `ORIGINAL` | 中文拼音九键 | 已确认 | 重建 | 分析 T9 解码器、消歧和候选布局 |
| MOD-003 | `ORIGINAL` | 中文笔画 | 已确认 | 重建 | 已确认 ForwardTokenDictionary header 与拼音类容器不同，继续定位 custom encoding 与候选协议 |
| MOD-004 | `ORIGINAL` | 中文手写 | 已确认 | 替代 | 已发现统一库与 `libhwrword.so` 两套 JNI 痕迹，先确认实际装载，再分离画布、模型、lattice 和识别协议 |
| MOD-005 | `ORIGINAL` | 英文 QWERTY 候选和纠错 | 已确认 | 替代 | 调查模型、候选和自动纠正 |
| MOD-006 | `ORIGINAL` | 英文九键 | 已确认 | 重建 | 调查可达条件和 T9 行为 |
| MOD-007 | `ORIGINAL` | 中文滑行输入 | 已确认 | 替代 | 已定位独立 gesture bigram、六套双拼 ID table 和 setting 动态更新，继续调查轨迹协议与自动提交 |
| MOD-008 | `ORIGINAL` | 英文滑行输入 | 已确认 | 替代 | 已定位统一库中的 Delight4 JNI，继续调查与中文滑行共享的 native 能力 |
| MOD-009 | `ORIGINAL` | 滑行预览及自动提交 | 已确认 | 重建 | 提取设置和运行时状态关系 |
| MOD-010 | `ORIGINAL` | 数字键盘 | 已确认 | 重建 | 映射 inputType 和布局选择规则 |
| MOD-011 | `ORIGINAL` | 电话键盘 | 已确认 | 重建 | 映射 inputType 和动作键规则 |
| MOD-012 | `ORIGINAL` | 日期时间键盘 | 已确认 | 重建 | 映射 inputType 和字符集合 |
| MOD-013 | `ORIGINAL`、`COMEBACK` | 密码和数字密码键盘 | 已确认 | 重建 | 固定 Body 必需键和隐私边界 |
| MOD-014 | `ORIGINAL` | 实体键盘 | 部分确认 | 重建 | 调查快捷键、Alt 符号和候选选择 |
| MOD-015 | `ORIGINAL` | 单手模式 | 已确认 | 重建 | 提取左、右、关闭状态及几何规则 |
| MOD-016 | `ORIGINAL` | 键盘高度 | 已确认 | 迁移 | 保持当前直接调整和预览语义 |
| MOD-017 | `ORIGINAL` | 文本编辑面板 | 部分确认 | 重建 | 调查选择、方向、复制、剪切和粘贴动作 |

## 5. 候选、Header 和附加输入

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| UI-001 | `ORIGINAL` | 固定候选栏 | 已确认 | 重建 | 提取 Candidate 展示、选择和更新协议 |
| UI-002 | `ORIGINAL` | 展开候选和分页 | 已确认 | 重建 | 建立页面、滚动和返回行为样本 |
| UI-003 | `ORIGINAL` | reading text 候选 | 部分确认 | 重建 | 确认出现条件和输入模式 |
| UI-004 | `ORIGINAL` | 浮动候选 | 待研究 | 未定 | 确认可达设备和使用场景 |
| UI-005 | `ORIGINAL`、`COMEBACK` | 候选、符号和 Emoji 滑动后的点击取消 | 已确认 | 迁移 | 将可见行为转换为新触摸协议 |
| UI-006 | `COMEBACK` | 统一 Header 平台 | 已确认 | 迁移 | 保留仲裁和 renderer 边界，不迁移 Smali 宿主 |
| UI-007 | `COMEBACK` | Header 简繁快速切换 | 已确认 | 迁移 | 与未来转换引擎状态连接 |
| UI-008 | `COMEBACK` | 剪贴板候选 | 已确认 | 迁移 | 保持完整提交、摘要、时效和关闭语义 |
| UI-009 | `COMEBACK` | 敏感剪贴板脱敏 | 已确认 | 迁移 | 固定显示、提交、日志和持久化边界 |
| UI-010 | `COMEBACK`、`ANDROID` | Inline Autofill Suggestions | 已确认 | 迁移 | 保持 Framework payload 和远端 Surface 所有权 |
| UI-011 | `ORIGINAL` | Symbol 分类和分页 | 已确认 | 重建 | 盘点字符集合、分类、最近使用和收藏 |
| UI-012 | `ORIGINAL` | Emoji 分类和分页 | 已确认 | 重建 | 盘点 Unicode 集合、版本差异和最近使用 |
| UI-013 | `ORIGINAL` | 颜文字分类 | 已确认 | 重建 | 盘点集合、分类和最近使用 |
| UI-014 | `ORIGINAL` | Dashboard 和 Access Points | 部分确认 | 重建 | 调查展开、优先级和首次提示状态 |
| UI-015 | `ORIGINAL` | 语音输入入口 | 已确认 | 替代 | 保持系统语音 IME 切换，不重建语音识别服务 |
| UI-016 | `ORIGINAL` | 按键弹出 | 已确认 | 重建 | 提取能力门控和视觉反馈 |
| UI-017 | `ORIGINAL`、`COMEBACK` | 按键音和振动 | 已确认 | 迁移 | 保持系统默认、显式值和预览契约 |
| UI-018 | `ORIGINAL` | 长按和替代字符 | 部分确认 | 重建 | 盘点 keymapping 和延迟规则 |

## 6. 主题、窗口和显示

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| VIS-001 | `ORIGINAL` | 内置浅色、深色和彩色主题 | 已确认 | 重建 | 提取状态和设计 token，替换原版资源 |
| VIS-002 | `ORIGINAL` | 自定义图片主题 | 已确认 | 重建 | 调查选图、裁剪、预览和存储格式 |
| VIS-003 | `COMEBACK` | 跟随系统自动主题 | 已确认 | 迁移 | 保持设置和键盘主题切换语义 |
| VIS-004 | `COMEBACK`、`ANDROID` | Android 16 covering-IME 和底部视觉面 | 已确认 | 迁移 | 在原生 Window/View 结构中直接实现 |
| VIS-005 | `COMEBACK` | 三按钮与手势导航适配 | 已确认 | 迁移 | 整理 WindowInsets 和主题联动契约 |
| VIS-006 | `ORIGINAL`、`COMEBACK` | 横屏、分屏、大字体和显示缩放 | 已确认 | 重建 | 建立新 UI 的设备形态矩阵 |
| VIS-007 | `ORIGINAL` | RTL 资源和方向图标 | 部分确认 | 重建 | 区分设置 RTL 与中文键盘固定方向 |
| VIS-008 | `COMEBACK` | 候选展开和收起期间的动态高刷请求 | 已确认 | 迁移 | 记录触发、释放和无收益回退边界 |
| VIS-009 | `ORIGINAL` | 基础可访问性属性和系统语义 | 部分确认 | 重建 | 盘点 content description、焦点和操作语义 |

## 7. 设置和管理界面

设置 key、类型、缺省值和依赖的详细真值表只维护在 `docs/modern-settings-preference-inventory.md`。本表只记录页面级能力。

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| SET-001 | `ORIGINAL` | 输入设置及子项 | 已确认 | 迁移 | 将现有 Preference 契约映射到原生设置模型 |
| SET-002 | `ORIGINAL` | 键盘、反馈和切换设置 | 已确认 | 迁移 | 保持能力门控和依赖 |
| SET-003 | `ORIGINAL` | 手写设置 | 已确认 | 迁移 | 与未来手写替代引擎重新连接 |
| SET-004 | `ORIGINAL`、`COMEBACK` | 词典与备份设置 | 已确认 | 迁移 | 吸收 Rime 同步后的最终页面和状态 |
| SET-005 | `ORIGINAL`、`COMEBACK` | 其他与关于页面 | 已确认 | 迁移 | 更新未来项目身份、许可证和链接 |
| SET-006 | `COMEBACK` | API 35+ Compose Material 3 设置 | 已确认 | 迁移 | 原生工程直接使用正式 AndroidX 依赖 |
| SET-007 | `ORIGINAL` | API 17–34 旧 Preference 设置 | 已确认 | 未定 | 根据未来 min SDK 决定是否保留 |
| SET-008 | `ORIGINAL` | 主题选择、创建和编辑页面 | 已确认 | 重建 | 研究状态、预览、图片和持久化 |
| SET-009 | `ORIGINAL` | 许可证页面 | 已确认 | 替代 | 由未来依赖清单生成，不复制旧许可证集合 |

## 8. 平台、安全和发布

| ID | 来源 | 能力 | 状态 | 原生处理 | 下一步 |
| --- | --- | --- | --- | --- | --- |
| PLT-001 | `COMEBACK` | target SDK 36 | 已确认 | 迁移 | 新工程从现代 target 基线开始 |
| PLT-002 | `ORIGINAL` | min SDK 17 声明 | 已确认 | 待决策 | 根据 Kotlin、Compose、ABI 和维护成本决定新下限 |
| PLT-003 | `ORIGINAL` | 仅 `arm64-v8a` native 载荷 | 已确认 | 替代 | 5 个 ELF 均为 ARM64 `ET_DYN`，新引擎确定后重新规划 ABI |
| PLT-004 | `COMEBACK` | API 31、33、34、35、36 静态门禁 | 已确认 | 迁移 | 改写为原生工程测试矩阵 |
| PLT-005 | `COMEBACK` | 16 KiB APK alignment | 已确认 | 迁移 | 已确认只有统一核心库仍是 4 KiB `PT_LOAD`，新引擎确定后验证全部 ELF page size |
| PLT-006 | `COMEBACK` | 可复现构建和发布校验 | 已确认 | 迁移 | 保持版本、签名、哈希和双构建原则 |
| PLT-007 | `COMEBACK` | 独立包名和正式签名升级 | 已确认 | 迁移 | 原生版本先使用新的并存身份 |
| PLT-008 | `COMEBACK` | 密码字段预测、学习和 Header 隔离 | 已确认 | 迁移 | 建立编辑字段安全状态矩阵 |
| PLT-009 | `COMEBACK` | 不记录用户输入、候选和敏感正文 | 已确认 | 迁移 | 固定日志和诊断数据模型 |
| PLT-010 | `ORIGINAL` | 网络和 Google 服务依赖 | 部分确认 | 替代 | 建立网络调用清单，默认采用离线设计 |
| PLT-011 | `ORIGINAL` | Firebase、统计和反馈上传 | 已退役 | 退役 | 原生工程不引入对应组件和权限 |
| PLT-012 | `ORIGINAL` | 旧账户和同步权限 | 已退役 | 退役 | 原生工程不申请 |
| PLT-013 | `ORIGINAL`、`COMEBACK` | 崩溃、ANR 和 native 加载验收 | 已确认 | 迁移 | 建立原生版稳定性门槛 |
| PLT-014 | `ORIGINAL` | 启动、候选、内存、电量性能 | 待研究 | 重建 | 建立固定测量方法和基准结果 |

## 第一轮结论

当前清单已经确认目标远大于单一拼音解码器。最终替换至少涉及五个互相依赖的系统：

1. Android IME 和输入会话
2. 中文、英文、滑行及手写引擎
3. 基础词典、语言模型和用户学习
4. 键盘、候选、Header、主题和设置界面
5. 备份、同步、迁移、安全和发布

最大未知项集中在：

- `libhmm_gesture_hwr_zh.so` 动态注册表的精确函数地址和内部状态
- `libpinyin_data_bundle.so` 中 Marisa、token、expansion 和 n-gram 容器的内部字段与评分语义
- 候选排序和用户学习语义
- 中文、英文滑行与手写模型的替代来源
- 原版资源入口与运行时可达功能之间的差异
- Android TV、旧 Android 版本和浮动实体键盘的最终范围

## 下一步

阶段 0 下一轮按以下顺序补强本表：

1. 切分 DirectMappingTokenExpander 与笔画 ForwardTokenDictionary 的辅助表
2. 映射统一库动态注册表中的 method name、JNI signature 和函数地址
3. 恢复 token score、meta 和 prefix score 的量化语义
4. 从 27,080 条 call graph 边中提取 Service、InputBundle、DecodeProcessor、HMM、词典、滑行和手写子图
5. 建立 XML include、class、layout、keymapping 和 processor 的机器可查询引用图
6. 运行时验证 `libhwrword.so` 是否实际装载
7. 把 Comeback 补丁入口映射到本架构图和功能清单 ID
8. Rime 双向同步合并后更新 `DAT-011` 及相关设置、迁移和安全条目

本表达到阶段 0 出口条件前，不据此冻结未来源码模块。
