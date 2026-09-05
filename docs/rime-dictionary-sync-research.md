# Rime 用户词典双向同步调研

> **当前状态：已恢复，进入手动同步实现阶段。** 第一阶段只实现手动双向同步，不增加后台自动调度。Bridge 作为同步目录中的一个稳定 Rime 设备，先合并现有设备快照，再转换 Google 拼音与 Rime 的新增和删除，最后只发布自己的设备快照。

## 1. 目标与边界

本调研评估一种可移除的双向文件桥：

```text
Rime 用户词典快照
        ⇅
独立格式转换与同步模块
        ⇅
Google 拼音原生导入／导出文件
```

如果后续恢复工作，模块应继续编译在同一个 APK 中，以便复用应用沙箱内的原生词典操作，但必须保持独立的代码、资源、状态和生命周期。它只通过现有导入、导出能力交换数据，不直接访问或替换私有 Trie。

明确边界：

- Google 拼音原生词典仍是输入时实际使用的词典
- Rime 仍使用自己的用户词典和原生同步流程
- Bridge 只解析、合并和转换双方公开导出文件
- 不改变 HMM、Candidate、学习、手写、Gesture、分页和删除语义
- 不让输入法启动、输入会话或候选更新依赖 Bridge
- 后续移除功能时，只删除模块、设置入口和集中注册点
- 不把双向同步描述为两套学习模型的无损同步

## 2. 已确认的 Rime 快照格式

Rime `*.userdb.txt` 使用 UTF-8 文本，每条记录的主体为：

```text
拼音编码<Tab>词面<Tab>c=... d=... t=...
```

字段含义已经通过 librime 源码确认：

- `c` 是累计 commit count，负数表示删除墓碑
- `d` 是随 tick 衰减的动态使用强度
- `t` 是 Rime 内部 tick
- 内部键由规范化拼音和词面共同确定

参考实现固定在调研时的 librime 提交 `417db2385f732cb0fa194b497042c42abb897d99`：

- [Rime `UserDbValue`、`UserDbMerger` 和 `UserDbImporter`](https://github.com/rime/librime/blob/417db2385f732cb0fa194b497042c42abb897d99/src/rime/dict/user_db.cc)
- [Rime `UserDictManager::Synchronize`](https://github.com/rime/librime/blob/417db2385f732cb0fa194b497042c42abb897d99/src/rime/lever/user_dict_manager.cc)
- [Rime 普通表格导入格式](https://github.com/rime/librime/blob/417db2385f732cb0fa194b497042c42abb897d99/src/rime/dict/table_db.cc)

Rime 同步不是简单拼接多个设备快照，也不是按文件修改时间覆盖。其主要合并语义是：

1. 扫描同步根目录中的设备子目录
2. 对同键记录比较 `abs(c)`，保留绝对值较大的 `c` 及其正负号
3. 按各自 tick 衰减 `d` 后保留较大的动态值
4. 将结果推进到参与同步的最大 tick
5. 为当前设备写出新的合并快照

因此，Bridge 如果需要读取多个 Rime 快照，必须复现上述语义或只读取已经由 Rime 完成合并的权威快照。不能把所有正数记录直接求并集，否则可能复活旧快照中的删除词条。

## 3. 授权本地样本的结构结论

本次只统计了用户明确授权的本地 RimeSync 目录，没有将词面、拼音或设备路径写入仓库。

结构统计显示：

- 主 `pinyin_simp.userdb.txt` 快照约有 10 万条记录
- 最新完整快照包含约 9.75 万条 `c > 0` 记录
- 同一快照还包含 `c = 0` 记录和数百条 `c < 0` 墓碑
- 多设备旧快照之间存在大量 count 冲突，也存在正负号冲突
- `luna_pinyin.userdb.txt` 规模约为 6200 条，与 `pinyin_simp` 部分重叠但不是其严格子集
- 观察到的拼音编码只包含小写字母和空格，语法上可以映射到 Google 拼音 token
- 目录中另有大型静态 `*.dict.yaml`，它们与个人学习词典的生命周期和语义不同

默认同步范围若以后落地，应优先考虑 `pinyin_simp.userdb.txt`。`luna_pinyin` 只能作为可选来源，并按规范化后的 `(词面, 拼音)` 去重。大型基础、百科和扩展 YAML 词典不应默认进入 Google 用户词典。

## 4. 已确认的 Google 拼音导入／导出行为

Google 拼音原生导出不是复制私有二进制 Trie，而是调用 native `exportAllEntries()` 后生成文本：

```text
UTF-16LE + BOM
# User dictionary for Google Pinyin Input
词面<Tab>count<Tab>token／拼音
```

现有导入链路为：

```text
duplicateDictionary()
→ 解析 TSV
→ DictionaryImporter.insertOrUpdate()
→ persist()
→ 通知引擎刷新
```

Bridge 的 Native 适配层复用同一条生命周期，但不经过无法表达删除的 TSV importer：

```text
DictionaryAccessor(USER_DICTIONARY)
→ duplicateDictionary()
→ exportAllEntries()
→ 容量与预览状态复核
→ remove(原始精确 Entry)／insertOrUpdate(count=1)
→ persist()
→ notifyMutableDictionaryDataChanged(USER_DICTIONARY)
→ close()
```

该事务与现有词典保存、导出和自动备份共用 `SaveDictionaryTask.sSaveLock`。任何增删失败都不会调用 `persist()`，关闭词典副本后不发布局部变更。容量预检使用 Native 报告的完整词条数，未参与 Rime 转换的单字和非拼音记录仍占用容量。Rime 只接入中文拼音词典工厂；原版导入／导出同时传入中文和英文工厂，是为了由格式分类器分别路由两类词条，不代表同一 Rime 记录应写入两份词典。

已经确认：

- 导入会在当前词典副本上合并，不会先清空词典
- 当前词典中未出现在导入文件里的词条不会被删除
- 新词通过 `insertOrUpdate()` 写入
- 同词面、同 token 的已有词也会进入 native `insertOrUpdate()`
- parser 会把可解析的 count 下限收敛到 `1`
- 用户词典容量上限为 `500000` 条
- `DictionaryImporter` 在处理每条记录前检查当前容量
- 达到容量上限后会抛出异常，但 `UserDictImportTask` 仍会持久化此前成功处理的部分，因此容量错误不是严格的全有或全无事务

尚未确认：

- 已有同键词条的 count 是替换、取较大值、累加还是其他规则
- 重复导入同一个文件是否在 count 层面完全幂等
- 较低的导入 count 是否会降低已有本地学习结果
- 20 万级已有词典上的复制、更新、持久化和再次导出耗时

`MutableDictionaryAccessorInterface` 同时公开 `insertOrUpdate()`、`addCount()` 和 `decreaseCount()`，因此 `insertOrUpdate()` 不太可能只是无条件累加，但这只是接口层推断。实际实现在 `libhmm_gesture_hwr_zh.so` 中，必须通过隔离运行时实验确认。

## 5. 为什么词频不能直接双向换算

Rime 的 `c` 是长期累计 commit count，样本中常见基础词可以达到数万次。Google 当前导出样本的 count 主要处于较小范围。两者不是同一尺度，也不代表相同的候选权重。

### 5.1 Rime 到 Google 的候选映射

如果后续需要保留大致频率，可研究以下保守映射：

```text
googleCount = min(20, ceil(log2(rimeCount + 1)))
```

该公式只保留数量级，避免将 Rime 多年累计次数原样写入 Google。它目前只是候选方案，尚未通过候选质量和同键导入实验验收。

### 5.2 Google 到 Rime 不能使用逆函数

不能使用：

```text
rimeCount = 2^googleCount - 1
```

正向对数映射会丢失信息，同一个 Google count 可能来自很大的 Rime count，也可能是 Google 本地真实积累的小 count。指数逆变换会把普通 Google 词条错误扩张成数万甚至更多次数。

若以后同步已有词的频率，只能考虑有状态的正增量：

```text
googleDelta = max(0, googleCountNow - googleCountBaseline)
rimeCountNew = max(rimeCountCurrent, lastBridgeCount) + googleDelta
```

该方案还必须满足：

- 首次看到两边已有的同键词时只建立基线，不合并历史次数
- Rime 墓碑默认不自动复活
- Google count 回退时只重建基线，不产生负增量
- Rime 导入 Google 后必须重新确认实际 Google count，避免把本轮导入误认为用户学习
- Bridge 状态丢失时重新建立基线，不重复累计历史值
- Google count 必须先经运行时实验确认可以表达稳定的正增量

Rime 的 `d` 依赖使用时间和 tick。Google 导出不包含足够的时间信息，无法无损恢复。Google 独有词若写入 Rime，只能使用保守初始化。已有 Rime 词应优先保留 Rime 自己的 `d`。

## 6. 更安全的第一阶段语义

如果以后恢复调研，最小风险方案不是立即同步词频，而是先同步词条集合：

```text
Rime 有、Google 没有 → 作为新词加入 Google
Google 有、Rime 没有 → 写入 Bridge 自己的 Rime 快照
两边都有             → 不修改双方已有词频
删除                   → 第一阶段不传播
```

这种模式具有以下特点：

- 同一词条第二次同步时已经存在，不会重复写入
- 不依赖 native 同键 count 语义
- Bridge 状态丢失不会造成词频爆炸
- 模块移除后，已经导入的词仍是双方的普通用户词

不过，Rime userdb 同时包含「真正新增的词」和「基础词典词条的学习频率」。若将整个 userdb 作为自定义词库导入，仍可能改变 Google 原生候选质量。后续应优先研究从 userdb 中识别静态基础词典已经包含的记录，只同步真正缺失的用户词。

## 7. 模块边界

若以后实现，Bridge 可以与设置页和词典操作存在少量明确耦合，但不应侵入输入法核心。

允许的集成点：

1. API 17–34 旧词典设置中的一个入口
2. API 35+ Compose 词典页中的一个入口
3. 包装现有原生导入、导出的窄适配器
4. `scripts/apply_patches.py` 中的集中注册
5. 独立 Activity、资源、SAF 授权和 Bridge 状态

禁止的反向依赖：

- `PinyinIME`、`GoogleInputMethodService` 或键盘启动 Bridge
- Candidate、学习、手写或 Header Platform 引用 Bridge
- 原生 importer、exporter 识别 Rime 格式
- 现有备份格式包含 Bridge 私有状态
- 输入会话扫描 RimeSync 目录
- Bridge 直接读写私有 Trie 文件

移除功能时，预期只删除 Bridge 代码和资源、两个设置入口、Manifest Activity 与集中注册点。现有导入、导出、备份、恢复、HMM 和候选逻辑不应修改。

## 8. 规模、性能与容量

当前 Google 原生用户词典容量为 50 万条。10 万至 20 万级的个人用户词典理论上仍在容量范围内，但必须考虑当前 Google 词条与新增 Rime 唯一键的并集，而不是只看导入文件行数。

任何正式导入前都必须完成：

```text
现有 Google 唯一键
∪
本次准备导入的唯一键
```

的容量预检，并在调用 native importer 前拒绝超过上限的事务，避免产生部分导入结果。

20 万条的纯解析、合并和格式转换是线性或近似线性工作，预计不会成为主要瓶颈。真正的不确定成本是：

- `duplicateDictionary()` 复制已有词典
- 大量 native `insertOrUpdate()`
- 完整 Trie 持久化
- 同步前后完整导出
- 候选质量和输入法启动性能

API 36 translated-ARM64 隔离模拟器已经完成首个 10 万级基准。测试快照包含 100,000 个合成多字条目，使用 50 个有效拼音音节组成均匀分布的三音节键；同步根目录中另一个 Bridge 快照贡献 1 个现存条目，因此最终预览为 100,001 项 Google 新增。首次预览耗时 47.4 秒，观察到的进程常驻内存峰值约 328 MiB；首次执行耗时 173.3 秒，峰值约 356 MiB。首次同步完成后，包含完整 Rime 合并和 Google Native 导出的零增量预览耗时 103.4 秒，峰值约 426 MiB。这些数字只代表当前 x86_64 模拟器上的 ARM64 translation，不是 Pixel 或正式性能承诺。

该基准同时发现 Native 持久化的返回值不构成完整提交证明：100,001 次插入均返回成功且 `persist()` 成功，但随后的完整导出少 2 项，旧实现因而计划 2 项错误的 Rime 删除。该删除没有执行。Google bridge 现已在 Native 持久化后重新打开 accessor，精确核对全部可翻译键集合和 Native 总条目数；不一致时保持 `PLANNED`，由恢复流程只重试缺失项，不发布 Bridge 快照或提交基线。主机测试使用会静默丢弃一项但返回持久化成功的 Fake 固化了这起真实事故。

`v4` 隔离 APK 已完成该复核路径的 API 36 运行时验收。在只包含原始 100,000 条分布式快照的新 SAF 根目录中，首次 Native 持久化再次静默少项；新实现正确停在 `PLANNED`，`pending_operation=100000`、baseline 为零，Bridge 目录没有正式快照。手动恢复在 32.9 秒内只补齐缺失项，随后提交为 `generation=1`、`IDLE`、pending operation 为零、baseline 为 100,000，并发布固定名称 Bridge 快照。立即预览和强制停止进程后的冷启动预览均为五项零变更，全程没有新增 crash、ANR 或类加载错误。

两次不具代表性的失败样本不纳入性能结论：任意四字母组合包含 Native 不接受的无效拼音，全部使用同一 `ce shi` 键则形成极端单索引桶。它们都在 `PLANNED` 阶段停止，未发布 Bridge 快照。

20 万条和真实设备仍无隔离基准，不应把上述时间写成产品承诺。当前 10 万级 Java 对象图已出现超过 400 MiB 的观测峰值；扩大到 20 万条前，应先降低预览期的重复对象和完整集合驻留，而不是直接加倍测试规模。

## 9. 超过 50 万条时的候选方向

当前决定是不重做原生词典系统。若未来同步集合确实超过 50 万条，可以评估外部完整保留、受控投影的兜底：

```text
Rime 与 Google 的完整同步集合
            ↓
Bridge 外部状态
            ↓
按明确策略选择可驻留子集
            ↓
Google 原生用户词典
```

该方向仍让 Google 原生词典负责实际输入。未投影词条只是暂时不进入 Google，不从 Rime 或 Bridge 中删除。

可能的驻留依据包括：

- Google 当前本地已有词优先
- 两边都存在的词优先
- 真正新增的用户词优先
- 近期或高频词优先
- 静态基础词典已经覆盖的普通词降低优先级
- 为 Google 本地后续学习预留容量

具体投影上限、预留量和淘汰规则均未决定。只有真实数据接近容量上限且同步功能价值仍然成立时，才应进入设计和验收。

## 10. 不采用完整词典重写

重新实现一个 SQLite 词库并不能让 Native HMM 自动使用它。若要替换原生词典，还需要改变 Candidate、排序、提交、学习、删除、去重、分页、手写和 Gesture 的数据链路，或者替换整个 Native 解码引擎。

这会破坏本项目保持 Google 拼音原生输入质量和语义的核心边界，其成本与双向同步的当前价值不匹配。若未来必须替换完整解码和学习系统，应将其视为另一个输入法项目，而不是本项目的普通功能分支。

## 11. 实现阶段的最小验证

第一阶段必须依次完成：

1. 用结构化样本验证 Bridge 合并结果与 librime 的 `UserDbMerger` 主体语义一致
2. 验证正负 `c` 平局时删除优先，以及跨设备墓碑和后续复活
3. 在隔离审计包验证 Google 原生精确单条删除、持久化和引擎刷新
4. 验证 Rime 新词初始动态值能够进入合理候选范围，同时不明显扰动已有候选
5. 用合成数据完成 10 万、20 万和接近容量上限的导入／导出与状态基准
6. 验证首次建档、重复同步、操作中断、状态恢复、容量预检和可恢复快照发布
7. 自动调度必须等手动同步的新增、删除、复活和失败恢复完成运行时验收后再设计

## 12. 已确认的第一阶段协议

第一阶段同步 Rime userdb 中的全部多字记录，不再区分基础词典学习记录与真正新增的个人词。首次同步可能带来候选排序变化，后续由两套输入法各自的真实使用继续学习。

固定规则：

- 单字记录不参与新增或删除同步
- 词条身份是规范化后的 `(词面, 拼音)`
- Rime 与 Google 拼音之间不换算历史词频
- Google 新词使用原生 importer 接受的最低有效 `count=1`
- Rime 新词不伪造历史提交次数，使用已通过候选可见性实验的 `c=0 d=1e-8 t=0`
- 已有词保留各自的词频和动态状态
- 删除双向传播，同一轮冲突时删除优先
- 已完成删除的词以后在任一侧重新添加时允许复活
- 第一个版本只提供手动同步，完整验收后再单独设计自动调度

双向删除需要模块私有的同步基线。首次建立基线时不能仅凭一侧缺失推断历史删除；后续只有在完整读取双方状态且基线身份一致时才能传播删除。状态丢失、目录改变、词典文件改变或规范化协议升级时，回到安全的首次建档流程。

基线使用每个 Profile 的随机盐对规范化词条键计算 SHA-256，只长期保存摘要、`PRESENT`／`DELETED` 状态和 Rime 计数绝对值，不长期复制词面与拼音。尚未完成的操作日志可以临时保存恢复操作所需的词面和拼音；双方持久化并提交新基线后立即清除。存在未完成操作时不得更换目录、设备名、词典文件或重建状态。

Google TSV 导入本身不能表达单条删除。虽然原生接口包含 `remove()`，运行时验收已经证明精确 `Entry` 删除不可靠。当前实现是在未持久化的 Native 副本中重建保留条目，再统一持久化并复核，不直接操作私有 Trie，也不恢复旧网络同步。

## 13. Bridge 作为 Rime 设备

Bridge 不检测 Syncthing 或其他同步软件是否在线，也不等待或判断其他设备是否已经同步完成。每次手动同步只读取 SAF 根目录中当时可见的直接子目录快照；其他设备以后带来的文件变化留到下一次手动同步处理。用户通过 SAF 授权 Rime 同步根目录，并手动填写 Bridge 设备目录名；应用在该根目录中创建或复用对应的稳定设备子目录和 `user_id`。Bridge 的行为等价于一个只通过文件参与同步的 Rime 设备：

```text
Rime 各设备快照
        ↓
Bridge 按 Rime 规则合并
        ↓
与 Google 拼音执行双向新增／删除
        ↓
可恢复地发布 Bridge 自己的完整设备快照
        ↓
其他 Rime 设备以后通过原生同步读取
```

每次手动同步：

1. 读取配置文件名对应的全部直接子目录快照，例如 `pinyin_simp.userdb.txt`
2. 以 Bridge 上次完整快照作为自己的本地状态，合并其他设备快照
3. 完整导出 Google 当前用户词典
4. 根据同步基线计算双方新增、删除和复活
5. 通过 Google 原生 accessor 在词典副本中应用精确变更并持久化
6. 在 Bridge 本地 Rime 状态中应用对应新增、墓碑或复活
7. 先写临时文件并校验，再通过旧快照恢复副本替换 Bridge 自己的正式快照
8. 双方持久化都成功后提交新基线；中途失败由持久化操作日志在下次手动同步时恢复

持久化阶段固定为：

```text
IDLE → PLANNED → GOOGLE_APPLIED → SNAPSHOT_PUBLISHED → IDLE
```

`PLANNED` 不能简单解释为「Google 尚未修改」。Native 词典可能已经完成整份持久化，但进程在 SQLite 阶段推进前退出。因此，恢复流程会读取 pending operation，在同一个 Native 锁内检查每个目标键：已经完成的新增或删除按成功处理，仍未完成的操作应用到新副本并持久化。`GOOGLE_APPLIED` 会从最新设备快照重新合并并幂等发布 Bridge 快照，`SNAPSHOT_PUBLISHED` 只提交已经暂存的哈希基线。这样可以覆盖每个外部持久化与 SQLite 阶段更新之间的崩溃窗口。

Bridge 不修改、覆盖或删除其他 Rime 设备的目录和快照。它输出完整快照而不是每次创建新的增量设备目录，并长期复用同一个设备身份。

Rime 合并继续保留原生主体语义：`c` 取绝对值较大的记录，`d` 在各自 tick 上衰减后取较大值，结果推进到最大 tick。为了实现已经确认的「删除优先」，正负 `c` 绝对值相同时由 Bridge 选择墓碑；由 Google 发起的删除使用足以超过本轮全部正数记录的负值，使其他 Rime 设备可以通过原生同步观察到删除。

设置页在现有「自动备份」下方增加独立的「Rime 同步」类别，至少包含：

- 同步目录，点击后直接通过 SAF 选择
- 设备名，使用独立输入框编辑
- Rime 用户词典文件，使用独立输入框编辑，例如 `pinyin_simp.userdb.txt`

设备名默认取 Android 设备型号，按 `Locale.ROOT` 转为小写，并把空格替换为下划线，例如 Pixel 10 Pro 对应 `pixel_10_pro`。用户输入只允许小写字母、数字、下划线和连字符，即 `[a-z0-9_-]+`。界面通过反射边界即时调用 Primary DEX 的唯一校验规则并给出提示，保存时配置对象继续使用该规则拒绝无效值。
- 当前同步状态
- 手动立即同步
- 重新建立同步状态

SAF 授权根固定在同步目录。应用通过该授权读取根目录下所有直接子目录中的同名快照，只创建和更新用户指定的设备目录，不修改或删除其他设备目录。设备名必须符合 `[a-z0-9_-]+`；创建后应通过 Document ID 验证对应目录确实是所选根目录的直接子目录。

Rime 同步与现有自动备份分别保存 SAF 目录、配置、状态和结果，可以单独使用或同时启用。它们不形成业务依赖，各自保留任务队列，通过同一把 `SaveDictionaryTask.sSaveLock` 串行访问 Google Native 词典。

当前实现已加入 Primary DEX 单线程异步门面和 API 35+ Compose 设置入口。Compose 只通过反射安全的窄契约读取状态和发起异步操作，不直接链接混淆后的 Native 类型。同步固定执行「预览 → 必要时确认删除 → 复核确认令牌 → 执行」，配置不完整、恢复事务未完成或其他词典操作进行中时不会开始新的同步。该实现已从固定原始 APK 完成 Compose Host 重建，并验证 65 个 Rime Smali 文件位于 Primary DEX。

Pixel 10 Pro 已通过全新 release-like 隔离包完成 SAF 持久授权丢失与恢复验收。任务专用空目录首次 Preview 为五项零变更；同签名一次性 probe 随后精确释放该包持有的 URI 读写授权，并立即调用与 Compose 相同的异步 Preview 边界。修复前，`RimeSyncSafStore` 构造阶段的授权异常会落入通用操作失败；现在该阶段的 `IOException` 映射为既有 `ERROR_LOCATION_UNAVAILABLE`。运行时返回 `permission_before=true`、`permission_after=false`、`error_code=2` 和 `location_accessible=false`。重新打开 Compose 后显示「目录无法访问，请重新选择」，「立即同步」不可操作；通过「同步目录」重新选择同一目录后恢复授权，再次 Preview 仍为五项零变更。授权失效的 Preview 在 Native 访问前被拦截。正常基线和重新授权后的 Preview 仍会读取 Native 词典，全程未执行同步写入或创建 Bridge 文件，也未观察到 crash／ANR。测试结束后授权随隔离包卸载释放，任务目录和 probe 均已删除，正式默认输入法保持不变。

同一设备随后用另一个 release-like 隔离包验证了 `ExternalStorageProvider` 上的两个 Bridge 发布中断窗口。第一种状态只有有效 `.bridge-previous.txt` 和未完成 `.partial.txt`，没有正式快照；选择 SAF 根目录时，恢复逻辑删除 partial、把 previous 恢复为正式文件，随后 Preview 为五项零变更。第二种状态同时存在正式快照、previous 和 partial；Preview 前恢复逻辑删除 previous 与 partial，保留的正式文件 SHA-256 不变，结果仍为五项零变更。两种状态最终都只保留一个正式快照，没有恢复副本、临时文件、重复文档、事务或 Native 变更。该验收使用人工构造的中断后文件状态，证明恢复入口能处理这两种状态，不代表已经在 `publish()` 执行途中终止进程并验证完整事务恢复。Syncthing 在线状态和其他设备进度不属于 Bridge 状态机。

API 36 隔离模拟器的首轮运行时验收发现并修正了两个仅靠主机测试无法发现的问题。`ExternalStorageProvider` 会按 `text/plain` MIME 类型为不以 `.txt` 结尾的临时名称自动补扩展名，因此临时文件和恢复副本现在都显式以 `.txt` 结尾，同时清理首版遗留的两种临时名称。修复后的升级安装成功从 `PLANNED` 阶段恢复，创建固定名称 Bridge 快照并提交基线。首轮 Native 新增、进程重启持久化和再次预览零变更均已通过。

同一环境还证明，`DictionaryAccessor.remove(Entry)` 对刚通过 accessor 写入并可重新导出的精确条目返回失败。原版在线词典更新代码同样不依赖该返回值，但无法提供删除已持久化的证据。Bridge 因此不再使用该单条删除入口，而是在 Native 副本内清空后按原始 `Entry` 重建全部保留项，再加入计划中的新项，最后只持久化一次。该路径保留无法翻译到 Rime 的单字和其他条目，并保持失败时丢弃未持久化副本。

第二轮 API 36 隔离模拟器验收已覆盖该重建路径：升级安装后从首版遗留的 `PLANNED` 删除事务恢复成功，立即预览和进程重启后的预览均为零变更。随后加入两个独立测试条目，只删除其中一个，再把保留项改为 Rime 墓碑，预览仍能准确识别一项 Google 删除，证明重建没有丢失未计划删除的条目；恢复该 Rime 条目后，立即预览和再次进程重启均为零变更。事务最终保持 `IDLE`、pending operation 为零，全程没有新增 crash、ANR、`VerifyError`、`NoClassDefFoundError` 或 `IllegalAccessError`。

模拟器清除审计包数据后重新配置同名 Bridge 目录时，曾确认 SQLite Profile 丢失会生成新的 Bridge `user_id`，而既有 Bridge 快照保留旧身份，核心因而拒绝合并。`v5` 已补齐该恢复路径：仅在数据库确实没有 Profile 时读取配置目录中的唯一固定名称快照，并且只采用 `rime_version=google-pinyin-bridge`、数据库名匹配且 `user_id` 为规范 UUID 的身份；已有 Profile 时绝不从外部快照改写身份。多个同名文档、非 Bridge 快照、数据库名不匹配、身份异常或快照损坏仍会被拒绝。

API 36 的 4 KiB 隔离模拟器已验证真实 SAF 路径：卸载审计包以移除私有 Profile 后，保留含固定 Bridge UUID 的外部快照；重新安装并选择同一根目录和设备目录后，首次预览正常合并 Bridge 与 peer 的 2 个合成条目，不再出现身份变化错误。预览成功本身证明新 Profile 采用了旧身份，因为合并核心仍会拒绝任何不相等的 Bridge `user_id`。本轮未用 Root 读取非 Debug 包私有数据库。16 KiB 模拟器启动失败仍由已知的 Native ELF `PT_LOAD Align 0x1000` 边界造成，与本阶段 Java/Smali 改动无关。

Pixel 10 Pro 的首轮真实 SAF 验收预览出 97,808 项 Google 新增和零项删除，预览耗时约 8.1 秒。首次执行约 24.7 秒后被 Native 持久化复核拦截，Bridge 目录没有创建；用户明确授权的一次恢复约 25.2 秒后仍保持可恢复状态，Bridge 目录依然没有创建，且没有 crash、ANR、OOM 或类加载错误。这证明发布门禁在真机有效，同时也证明当前缺失项恢复并不保证一次收敛。

`v7` 已将 SQLite 升级到 v2，在 `PLANNED` 阶段保存 Native 预期总数、实际总数、缺失数和由 Profile 盐生成的差异指纹，不保存差异词面、拼音或裸哈希。差异首次出现或发生变化时，设置页显示数量并允许一次人工恢复；连续两次出现相同差异时标记为未收敛并禁用恢复入口，避免用户盲目重复整份持久化。成功进入 `GOOGLE_APPLIED` 时立即清除这些诊断字段。`v8` 补齐了「总数不一致但可翻译键缺失数为 0」的显示条件。

Pixel 的后续恢复没有进入持久化后集合复核。`v9` 将 SQLite 升级到 v3，并把复核前失败按 Native I/O、内存和运行时类别持久化；真机结果为 Native I/O。`v10` 进一步细分复制、导出、插入、persist 调用、重建和数据一致性阶段，真机最终稳定定位为 `DictionaryAccessor.insertOrUpdate()` 在补写待同步词条时明确返回 `false`。因此 Pixel 当前阻塞不是已确认的 persist 后静默少写，而是待补词条被 Native 插入接口明确拒绝。

`v11` 在不持久化 Native 副本的前提下检查全部待补项，任一拒绝存在时不调用 `persist()`、不通知引擎、不发布 Bridge，也不提交基线。私有状态只保存拒绝数量和由 Profile 盐生成的拒绝集合指纹，不保存词面、拼音或裸哈希。Pixel 首次有界诊断统计出 303 个拒绝项。用户明确授权的第二次复核仍为 303 项，加盐集合指纹完全相同，设置页随即锁定恢复入口；这证明当前拒绝集合稳定，不是随机批量少写。用户确认采用「仅保留在 Rime」方案后，`v12` 已将 SQLite 升级到 v4，并为正式基线和暂存基线增加 `SUPPORTED` / `RIME_ONLY` Google 投影状态。继续操作会先重新探测拒绝集合，只有数量和加盐指纹都与锁定记录一致时，才跳过这些拒绝项；随后在一个 SQLite 事务中把对应暂存基线标记为 `RIME_ONLY` 并推进到 `GOOGLE_APPLIED`。如果同一词条以后真实出现在 Google 拼音中，规划器会恢复普通双向同步；如果它先在 Rime 中删除，投影状态会恢复为 `SUPPORTED`，以后明确重新加入时可再次尝试。用户执行「重新建立同步状态」也会清除这些投影判断。

Pixel 真机已从 v3 原地迁移到 v4，并在拒绝集合再次匹配 303 项后完成原 `PLANNED` 事务。状态进入 `IDLE`，Bridge 发布和基线提交成功；立即预览与强制停止后的冷启动预览均为五项零变更，证明 303 项保留在 Rime 且不会在每轮同步中重复加入 Google 拼音。

真实 Syncthing 双向链路已通过 Pixel 与 Windows 上的合成 peer 验收。Bridge 的 4,720,551 字节正式快照先从 Pixel 经 Syncthing-Fork 传播到 Windows，目录中没有临时文件、恢复副本或冲突副本。反向测试最初因合成夹具误把 `db_name` 写成 `pinyin_simp` 而被安全拒绝；`v13` 和 `v14` 增加不含路径、设备身份、词面和拼音的预览阶段分类，最终精确定位为数据库名不匹配。改为当时实现要求的 `pinyin_simp.userdb` 后，同一合成词条依次完成「peer 新增 → Google 新增 1 项 → peer 墓碑 → Google 删除 1 项 → peer 明确重新添加 → Google 复活 1 项」。每个事务均进入 `IDLE`，新增后立即和冷启动预览、删除后立即预览、复活后冷启动预览均为五项零变更。测试结束前再次传播墓碑并从隔离 Google 词典删除合成词条，随后在 Windows 和 Pixel 两端精确删除 synthetic peer 目录；Bridge 保留删除墓碑，最终冷启动预览仍为五项零变更。

Pixel 10 Pro 的隔离审计包已进一步验证单字 Native 条目的重建守恒。测试先确认审计词典中没有被 Rime 投影排除的既有条目，再通过同签名一次性 instrumentation 和原生 accessor 加入 1 个生成的单字条目；随后由独立 synthetic peer 完成多字词新增，并以墓碑得到 `0,1,0,0,0` 删除预览，使生产 Bridge 真实执行全词典重建和持久化。重新打开词典后，排除项仍为 1，合成单字的 tokens、language ID、count、修改标志、规范化标志和 expansion type 均与重建前完全一致。清理 probe 与两个合成条目后，排除项回到 0，最终同步预览为五项零变更；设备与 Windows 均未残留 synthetic peer、临时诊断文件、Bridge 临时文件、恢复副本或同步冲突文件。Probe 只报告数量和布尔比较结果，不输出词面、拼音或指纹。该结果直接覆盖单字及其完整 Native 元数据；其他 language ID、非拼音 token 和英文条目的独立运行时夹具仍待验证。

Pixel 隔离审计包随后完成了其余可构造类型的运行时验收。未持久化预检证明 Native 接受 language ID 为 `0` 的多字 `Entry`，也接受通过文本入口建立的无 tokens 英文条目，但拒绝 language ID 为 `16` 且 token 含连字符的条目。测试只持久化前两种已接受形状，排除项基线为 2；再次通过 synthetic peer 的墓碑得到 `0,1,0,0,0` 删除预览并触发生产 Bridge 全词典重建。重建后排除项仍为 2，基于临时随机盐计算的集合指纹完全相同；指纹覆盖 tokens、language IDs、词面、count、修改标志、规范化标志和 expansion type。删除事务完成后的预览为五项零变更。清理后排除项回到 0，临时 Preferences、probe、Windows 与 Pixel 两端的 synthetic peer 及设备临时文件均已移除。由此，单字、非拼音 language ID、无 tokens 英文条目和完整 Native 元数据的重建守恒均已通过 Pixel 运行时验收；Native 明确拒绝的非拼音 token 不属于可持久化词典状态。

并发审计发现 `SaveDictionaryTask`、`UserDictExportTask` 和 Rime Native Bridge 已共用 `SaveDictionaryTask.sSaveLock`，但原生 `UserDictImportTask` 仍在共享锁之外打开、合并并持久化词典副本。`v15` 已把导入的完整事务纳入同一把锁，范围从打开 accessor 持续到合并、persist 和引擎通知，并增加静态协议门禁，避免导入与 Rime 同步把各自的旧副本覆盖到对方结果上。该修改不增加业务依赖，也不合并自动备份与 Rime 的线程池、SAF 根或状态。

Pixel 上使用任务专用 SAF 目录和只持有共享锁、不访问数据的一次性 instrumentation，已从真实 Compose 入口覆盖 `backup → Rime`、`Rime → backup` 和 `import → Rime`。两次交错备份均发布完整 `.txt`，没有遗留 partial；三次 Rime 预览均为五项零变更。由本轮备份经原生 importer 合并后，Chinese Native 总数和可投影数均保持 `97,505 → 97,505`，随后 Rime 预览仍为零变更，未出现死锁、部分持久化、恢复事务或 Bridge 临时文件。清理阶段释放了自动备份 SAF 授权、清空专属备份 Preferences、删除任务目录并卸载 probe；自动备份恢复为「未选择」，既有 Rime 配置和授权仍可用，证明两套 SAF 状态没有串线。

新词初始状态已经完成双引擎候选验收。Windows 上通过 Weasel 0.17.4／librime 1.13.1 建立完全隔离的 `pinyin_simp` user data，在同一编码下同时导入 `c=0 d=1e-8 t=0` 夹具和 `c=1` 阳性对照；同步前两者均不在 15 个候选中，同步后候选总数增至 17，两个生成词条都能在完整候选列表中精确匹配。Pixel 10 Pro 则使用从固定原始 APK 构建的全新 release-like 隔离包，将一个经过重新打开复核的生成词条以 `count=1` 写入 Native 词典；真实 IME 输入与空格提交得到精确布尔匹配，输入会话结束并切换 IME 后重新打开词典，count 从 `1` 持久化为 `2`。快速重启宿主的额外尝试受冷启动时序影响，不作为稳定交互门槛。两个探针都只输出数量、固定阶段和布尔比较，不输出候选或输入正文。清理时重新激活隔离 Native engine 后确认生成词条不存在，随后禁用并卸载全部审计包，默认输入法恢复为正式包；Windows 隔离 user data 也已删除。该实验分别证明了 Rime 完整候选列表可见性，以及 Google 首选提交与本地 count 增长。Rime 的候选提交和学习增长未在本轮测量，两种 count 也不能据此相互换算。

扩大规模前已完成第一轮规划内存优化。预览不再保留每个 unchanged key 的 `EntryPlan`，两个有序 key 引用数组替代了全量 `TreeSet` 节点；仅预览的 Native 快照逐条释放完整 `Entry`，Google 侧只保留 canonical presence；没有既有 Bridge 时，首个 peer 可在内存中按同一 tick 和删除优先规则转换为初始 Bridge，不再复制整张 map；SQLite baseline 的 32 字节加盐 hash 则按 BLOB 顺序装入连续数组，以二分查找替代 64 字符十六进制 key、`HashMap` 节点和常驻 `Baseline` 对象。执行前仍会重新读取带 code、phrase 和 source 的完整 Native 快照，因此 stale 检查、事务重建和持久化复核没有降级。生成结果仍为 65 个 Primary DEX Rime Smali 文件，现有协议测试继续通过。

API 36 的 4 KiB translated-ARM64 隔离模拟器使用同一 100,000 条合成快照完成最终零变更规划测量。为隔离规划内存，测试 Profile 使用任务专用合成 baseline，把 100,000 项标为 `RIME_ONLY`；Native 中已经存在的 99,998 项会由规划器自然恢复为 `SUPPORTED`，其余 2 项保持 `RIME_ONLY`，最终预览为 `0,0,0,0,0`。该基线不作为同步正确性证据。冷启动初始 RSS 为 209,928 KiB，预览耗时 11.8 秒，峰值 RSS 为 359,712 KiB（约 351.3 MiB），结束时 RSS 为 310,972 KiB，Java Heap PSS 为 64,636 KiB。与早期零增量约 103.4 秒、峰值约 426 MiB 相比，耗时和对象驻留均明显下降。

第二轮又让仅 Preview 使用的 canonicalization 消费其私有临时 Rime snapshot：每条记录只保留 canonical key 和 commit 数值，处理后立即移除 raw map 节点、`Entry`、code 和 phrase；完整执行、恢复与发布仍保留原 snapshot。有效冷启动预览继续得到 `0,0,0,0,0`，耗时 10.6 秒，初始 RSS 为 212,696 KiB，峰值 RSS 为 364,212 KiB，结束时 RSS 为 307,564 KiB，Java Heap PSS 为 44,132 KiB。峰值 RSS 在约第 5 秒发生，随后回收约 60 MiB；同一时点的分类为 Java Heap PSS 44,836 KiB、Native Heap PSS 124,672 KiB、总 PSS 250,494 KiB 和总 RSS 372,492 KiB。由此可见，消费 snapshot 继续减少了约 20 MiB 的存活 Java 堆，但 RSS 高水位主要受完整 Native 导出和 ART 已分配页影响。

早期约 328 MiB 来自 Google Native 词典为空的首次预览，不能作为 Native 已有约 100,000 项时零变更预览必须低于的硬门槛。后续扩容因此按 Java Heap、Native Heap、总 PSS、回收后状态、完成时间和进程存活共同判断，不再只用进程 RSS 高水位放行。

同一 API 36 的 4 KiB translated-ARM64 隔离模拟器随后完成 200,000 条只读规划预检。夹具由已验证的 100,000 条快照和另外 100,000 条生成记录组成，共 9,173,644 字节，SHA-256 为 `8a1e874b28e5e7f3c6edf69466450a48da5a46cff89e60ed25f09ce7cb0c9669`。测试 Profile 使用 200,000 行任务专用合成 baseline，Google Native 保持约 99,998 项；所有记录标为 `RIME_ONLY`，使本轮只覆盖解析、合并、Native presence、baseline 查找和规划，不执行 Native 写入。真实 Compose 入口在 19.2 秒内得到 `0,0,0,0,0`，进程没有重启，也没有 OOM 或 ANR。采样峰值为 Java Heap PSS 76,476 KiB、Native Heap PSS 102,708 KiB、总 PSS 253,615 KiB 和 RSS 407,456 KiB；30 秒回收后分别为 57,648 KiB、82,796 KiB、219,430 KiB 和 347,264 KiB。相较 100,000 条，耗时约线性增长，额外 Rime 和 baseline 数据没有使保持不变的 Google Native Heap 同比翻倍，临时 Java 对象也能回落。

该结果只放行「200,000 条 Rime + 约 100,000 条 Google」的只读规划，不证明 Google Native 可持久化 200,000 条，也不放行 200,000 条写入、删除重建或接近 500,000 条压力测试。后续若扩大 Native 侧规模，必须分阶段增加生成条目，并在每阶段重新检查插入拒绝、持久化后总数、分类 PSS 和恢复收敛。

## 14. 最终一致性审阅：待解决项

- **数据库名称兼容规则已纠正：** 配置仍从 `pinyin_simp.userdb.txt` 得到规范名称 `pinyin_simp`，Bridge 也以该规范名称发布。但 peer 文件头可以包含存储后缀。[librime 1.13.1 的 `UserDbHelper::GetDbName()`](https://github.com/rime/librime/blob/1.13.1/src/rime/dict/user_db.cc) 会删除最后一次出现的 `.userdb` 及其后续内容，因此 `pinyin_simp.userdb` 和 `pinyin_simp.userdb.kct` 都应按 `pinyin_simp` 匹配。此前把带后缀名称限定为本机旧 Bridge 格式的规则过严，导致真实 Rime peer 被误拒绝，现已按官方实现修正。归一化只作用于读取后的内存对象，不改写 peer 文件；本机带后缀 Bridge 仍须通过 `google-pinyin-bridge` 标记和稳定 UUID 校验，其他数据库归一化后仍因名称不匹配而被拒绝。
- **迁移与运行时证据：** Profile 的配置身份、哈希盐和操作日志不含派生数据库名，修复不升级协议版本、不重建 baseline，也不修改 generation 或未完成阶段。已有事务恢复时沿用原阶段，重新读入的本机旧 Bridge 快照按上述规则迁移。模块测试覆盖标准名称、带存储后缀的 peer、保留身份与记录的本机迁移，以及不同数据库和本机无标记快照拒绝。Pixel 10 Pro 的全新非 Debug 隔离包通过真实 SAF 和 Compose 入口，读取标准空 peer 与旧名称空 Bridge，得到五项零变更 Preview；确认后发布 `db_name=pinyin_simp`，原 Bridge UUID 保持不变，peer 文件逐字节不变。该运行时实验覆盖首次恢复身份与重新发布，不代表已有非空 Profile 和每个未完成阶段均已重新实测。
- **Native 同进程复核时序问题的复现证据：** 旧候选 probe 确实省略了 `duplicateDictionary()`，但后续复测直接调用最终隔离 APK 的生产 `GoogleNativeDictionaryBridge.apply()` 和 `read()`，仍复现读旧状态。空词典写入一个生成词条后，同进程抛出 `PersistenceVerificationException`，新 instrumentation 进程的生产读取却返回词条存在、count 为 1、总数为 1。删除同一词条也触发即时复核失败，测试探针在异常返回后使用主线程队列屏障，再调用生产读取，得到词条不存在、总数为 0，新进程读取同样为 0。测试未启用或选择隔离 IME，未访问正式词典，最后已卸载隔离包。
- **刷新完成契约已实现：** 问题来自旧 `notifyMutableDictionaryDataChanged()` 仅投递主线程任务，通知返回不代表数据已重新载入。原生工厂现在提供共享 `refreshMutableDictionaryData()` 入口，同步执行既有 `enrollMutableDictionary()`，再将输入会话通知限定在主线程。旧异步通知入口仍投递任务，但任务复用该刷新入口，只有一份刷新实现。Bridge 在 `SaveDictionaryTask.sSaveLock` 内持久化并关闭旧 accessor，同步刷新数据后再复制、导出和完整复核。后台不执行输入会话监听器，也不持锁等待主线程。原生 `UserDictionaryMigrater` 已有从工作线程载入词典的路径，本次不改 Native 算法或格式。
- **修复后的验证：** 测试词典模型区分 durable 数据和已加载数据，只有刷新才能让新 accessor 看见持久化结果，既有丢项拦截测试仍通过。Pixel 隔离包的生产新增和删除均在同进程立即复核成功，新进程读取一致，没有使用队列屏障、延时重试或引擎重启。真实 Compose 入口完成「peer 新增 1 项 → 同步完成 → 零变更 Preview → peer 墓碑 → 删除完成」，最后新进程生产读取确认总数为 0。首次 fresh instrumentation 曾在 Application 默认 Preference 初始化期间触发 `bdt` 回调空引用，不能计为无崩溃运行；探针随后明确等待 `Application.onCreate()` 完成，真实 Compose 流程正常。已卸载隔离包并清理设备目录。活跃输入会话，以及备份／导入与新版刷新路径的交错回归仍属于最终整合验收范围。
- **保存与导入的刷新边界已补齐：** `70d84c7` 的原生导入和保存仍在共享锁内投递异步刷新后解锁，下一位读取者可能看到旧数据。现在 `UserDictImportTask.doInBackground()` 和 `SaveDictionaryTask` 都在关闭 accessor 后、解锁前调用同一个 `refreshMutableDictionaryData()`，不增加锁或队列。输入会话通知继续只在主线程执行。补丁从固定原始 APK 应用，静态门禁同时检查这两个调用点，避免只修复 Bridge。
- **任务链运行时对照：** Pixel 10 Pro 上的一次性 instrumentation 等待 Application 初始化完成，再暂停隔离包主线程通知队列，最多 5 秒。工作线程通过生产 Bridge 写入生成词条、调用原生 `UserDictExportTask` 导出到私有临时文件、删除词条，再调用原生 `UserDictImportTask` 导入，并立即使用生产 Bridge 读取。修复前在 `READ_IMPORTED` 阶段失败，暂停未超时，复现的是读旧版本，不是数据丢失。修复后同一探针立即读到导入词条，随后通过 Bridge 增加第二项并调用 `SaveDictionaryTask.saveDictionaryNow()`，两项均保留。最后通过 Bridge 删除两项，当前进程和新进程总数均为 0，暂停未超时，私有导出文件已删除，隔离包已卸载，正式默认输入法保持不变。该验证直接执行真实任务工作入口，覆盖通知尚未执行时的连续 Native 操作，不是 Compose 操作、活跃键盘或自动备份调度的完整验收。
- **非空状态保留验证：** 同一隔离 APK 的真实 SQLite 状态库建立了含 1 项 `RIME_ONLY` baseline 的 Profile，并在后续事务中加入 1 项 pending operation。逐阶段关闭、重新打开状态库并调用 `configure()`，覆盖 `IDLE`、`PLANNED`、`GOOGLE_APPLIED` 和 `SNAPSHOT_PUBLISHED`，确认 Bridge 身份、同一测试键的加盐哈希、generation、baseline 投影和计数均保持，pending operation 数量符合阶段。最终提交阶段后返回 `IDLE` 且 pending 清空。这证明重新配置不清除上述状态，不是从旧 APK 覆盖安装的升级测试，也没有执行各阶段的真实 SAF／Native 恢复。
- **活跃输入会话的模拟器验证：** API 36、4 KiB translated-ARM64 本地模拟器上，完成隔离安装的正常首次引导后，让同一 instrumentation／IME 进程与同一输入宿主连接持续存活。在输入连接已建立后，通过生产 Bridge 新增生成词条，确认通知由主线程送达。第一次输入未匹配新词条，但该次输入正常结束后，下一次输入精确提交新词条，宿主确认 composing 已结束，输入连接创建次数保持 `2 → 2`，IME PID 未变。随后通过 Bridge 删除生成词条并确认不存在，卸载全部隔离包，恢复模拟器原默认 IME。该段仅记录模拟器证据，后续真机结果单独列出。
- **活跃输入会话的真机验证：** Pixel 10 Pro 恢复远程连接后，用同一隔离 APK 执行对应回归。同签名探针在应用自身打开正常首次引导页，完成引导后启动专用输入宿主，在输入连接已建立时通过生产 Bridge 新增生成词条。通知在主线程送达，IME PID 保持不变，宿主输入连接创建次数保持 `2 → 2`。第一次输入未精确匹配，清空当前测试文本后，第二次输入精确提交生成词条，composing 为 false，连接未重建。随后生产 Bridge 删除夹具并确认不存在，卸载三个测试包、删除本轮引导 UI dump，恢复原正式默认输入法。该轮验证重置边界后的可见性，不要求通知到达时立即替换当前候选，也不代表视觉体验、所有键盘布局和长期学习均已验收。最初依赖自动弹出引导时机的一轮在准备阶段停止，不计为有效候选测试。
- **保留原生延迟刷新语义：** `AbstractHmmChineseDecodeProcessor.onMutableDataChanged()` 只设置待刷新标记，实际刷新通过既有 `c()` 方法调用 wrapper 和 accessor 的 `refreshData()`，发生在键盘激活或 `onResetInternalStates()`。通知送达不意味着立即替换当前解码状态。上述模拟器结果验证了正常输入重置后的生效，不要求重启进程或重建输入连接，因此本轮没有改动生产解码器。测试宿主早期只拦截旧版 `commitText()`，后来改为核对固定生成词条与 composing 状态；若未完成首次引导，引导页可能占据焦点而使输入连接无法建立，这些轮次不计为产品验收。测试最终通过正常引导界面初始化，不直接写入引导标记。
- **首个整合候选安装记录：** `2.0.10-rime-copywriting-audit.1`（versionCode 为 4520421）已包含数据库名称、Native 刷新、保存／导入边界及错误提示修复。APK SHA-256 为 `db8787d3d549dd5e0cdf52c0d7d500b2e2abbc57511a6eb42119fee1e61c5f4a`，包名为 `com.google.android.inputmethod.pinyin.rimenameaudit`，min SDK 为 17，target SDK 为 36，非 debuggable。最终 APK 反编译后通过 Compose 运行时、65 个 Rime Primary DEX 类及 Native 刷新入口检查，三个 DEX 均与已通过真机回归的写入刷新审计 APK 逐字节一致。已安装到 Pixel，保留首次使用状态，未由助手启动或启用，也未选择同步目录，原默认输入法保持不变。旧 `rimesyncaudit v15` 的词典和配置保留作迁移对照。该安装不是正式发布或真实数据原地升级验收，用户体验确认仍待完成。

用户配置独立测试目录后的预览暴露了上述名称兼容缺陷：生产预览回调返回 `ERROR_PREVIEW_SOURCE_DATABASE`，只读文件头检查确认唯一 peer 的名称为 `pinyin_simp.userdb`，且不是 Google Bridge 快照。这里的失败结果不代表五项变更数量为零。修复后，以同包名、同审计签名覆盖安装 `2.0.10-rime-peer-name-audit.1`（versionCode 为 4520422），现有配置和目录授权仍可用，默认输入法保持不变。真实 Compose 预览得到 Google 新增 97,831、删除 0，Rime 新增 2、删除 0、复活 0。测试停在确认界面，未执行同步，也未改写源快照。诊断只输出错误分类、文件头布尔比较和数量，临时探针及 UI dump 已清理。

修复已从固定原始 APK 完整重建，生成 65 个 Rime Smali 文件，通过协议测试和 API 31、33、34、35、36 静态门禁，并验证 v1/v2/v3 签名和 16 KiB ZIP alignment。资源表与两个现代 DEX 均与前一候选逐字节一致，因此既有 6,633 个资源 ID 的证据仍适用。新 APK SHA-256 为 `24b221389072d5b35ca415baf18ab50c8ff166ba4475c99fffd75f219c65260f`。该轮只完成名称修复与真实目录预览，未据此认定实际写入和零变更闭环通过。

用户随后明确授权执行。真实 Compose 确认界面再次核对计划为 Google 新增 97,831、删除 0，Rime 新增 2、删除 0、复活 0 后，点击确认同步。界面随后显示 `modern_settings_rime_sync_native_insert_failure`，拒绝数量为 303，同步未完成。助手停在该检查点，没有自动恢复、重复尝试或确认 `RIME_ONLY`。该数量与旧审计包的历史结果一致，但没有比较拒绝集合，不能宣称是同一批词条。截至该轮，仍需经授权复核拒绝集合和完成事务，不能宣称持久化及零变更闭环通过。该轮临时 UI dump 已删除，用户选择的测试输入法和配置保持原状。

用户随后授权按既有流程继续。真实 Compose 状态入口执行一次受控恢复，返回 `modern_settings_rime_sync_native_insert_stalled`，数量为 303，表明程序已确认本事务内的拒绝集合重复。打开并确认「仅保留在 Rime」后，协调器在再次执行 Native 恢复时，通过 `verifyRecordedRejectedEntries()` 复核记录中的拒绝集合，随后完成允许保留拒绝项的持久化及完整复核、Bridge 发布和事务提交。界面显示同步完成，立即 Preview 为 `0,0,0,0,0`。在该已完成状态下冷启动同一新测试版，重新从真实 Compose 入口预览，五项仍为零，用户选择的输入法保持不变，临时 UI dump 已清理。两次预览均未再次确认同步。

该结果确认本次测试目录和当前词库完成了「拒绝集合复核 → 303 项仅保留于 Rime → 同步完成 → 即时零变更 → 冷启动零变更」闭环。303 项没有被强行插入 Google 原生词典，也不据同一数量认定它们与旧审计包是相同集合。这里验证的是该词库的同步、持久化和恢复收敛，不代替每个词条的候选提交、长期学习或所有输入布局体验。

## 15. 保留的长期边界

- 基于现有 Google 原生词典和 Native accessor，不替换输入引擎
- Bridge 是可移除的独立功能模块
- 不重做 HMM、Candidate 或私有 Trie
- 不承诺两套学习模型的词频一致
- 不在日志、诊断或同步状态摘要中记录词面和拼音
- 超过 50 万条时优先研究外部保留与受控投影，不替换输入引擎
