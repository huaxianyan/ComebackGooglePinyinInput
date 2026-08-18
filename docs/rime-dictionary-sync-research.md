# Rime 用户词典双向同步调研

> **当前状态：暂缓，不进入实现阶段。** 本文只记录已经确认的格式、原生行为、风险和后续决策边界。当前不新增同步入口、后台任务、状态数据库或词典逻辑，也不修改 Rime 和 Google 拼音的任何数据。

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

此前讨论中的时间范围只属于工程估算，尚无 20 万条隔离基准，不应写成产品承诺。

如果状态记录达到 20 万级，不应长期把所有词条放入 Java 对象图。后续可评估流式处理和应用私有 SQLite，但在恢复实现前不提前建设状态数据库。

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

## 11. 恢复工作前的最小验证

只有重新确认功能优先级后，才执行以下工作：

1. 在隔离审计包验证已有同键词的 `insertOrUpdate()` count 语义
2. 验证重复导入、较高 count、较低 count 和同文件重复键
3. 用合成数据完成 10 万、20 万和接近容量上限的导入／导出基准
4. 比较「只导入真正新增词」与「导入完整 Rime userdb」的候选质量
5. 验证容量预检、失败中断和恢复
6. 决定只同步词条集合，还是继续研究有状态的近似词频
7. 在设计评审通过前，不增加设置入口、后台任务或正式 APK 代码

## 12. 当前决定

Rime 用户词典双向同步暂不开展。保留以下长期边界：

- 基于现有 Google 原生词典和原生导入／导出
- Bridge 是可移除的独立功能模块
- 不重做 HMM、Candidate 或私有 Trie
- 第一优先级是词条集合，不承诺学习模型无损同步
- 词频、删除、容量投影和自动调度都需要独立证据后再决定
- 超过 50 万条时优先研究外部保留与受控投影，不替换输入引擎
