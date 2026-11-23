# 词库安全兜底（dictsafety）

程序自用的词库塌陷兜底机制。判据、快照格式、触发点与踩过的坑都在这里。


- 定位：给不使用 Rime 同步的用户兜底。完全程序自用，不依赖 SAF、不读用户备份设置、不碰 Rime 状态，无界面也无开关。
- 唯一判据是 `DictionarySafetyPolicy.isCollapsed`：当前条目数低于本机历史最大值的一半。最大值只增不减，代码里不出现来自任何单台设备的绝对条数。
- 快照是引擎可读视图的文本（每行「词、拼音、权重」三列，末行 `END` 记条数），不是二进制。解析全有或全无，缺尾行、字段数不对、单字条目、重复键整份丢弃，不做部分应用。
- 权重非正的条目（引擎的墓碑）必须在构造快照时就跳过。`read()` 会把 `count <= 0` 的条目带出来，写进快照文本后 `parse()` 整份判为无效，`write()` 读回校验失败就删掉新文件并静默返回，什么都不留下。2026-11-23 查到的条目快照就是这个原因从 11-16 起停更 8 天，状态页全程是绿的。`DictionaryBackupText` 与 `Change` 本来就拒绝非正权重，快照走同一判据。
- 权重必须随快照往返。补回条目一律传原权重，不走新词权重默认值。`GoogleNativeDictionaryBridge.prepare()` 重建 `Change` 时不能丢 `count`，2026-11-11 真机就是在这里把 40 条权重压成了 1。
- 恢复只补回缺失条目，从不删除。判据、准入、旋转、修复复核共用同一个谓词，不新增第二套阈值。
- 先分清「真删」和「读不出」：条目数塌了但词典文件没同步变小才算读失败；文件跟着变小按删除处理，接纳新的较小基线，不复活用户删掉的词。期望大小用「基准大小 × 当前条数 ÷ 记录条数」推，不写绝对字节数。缺少基线时只记录不动手。

- 旋转只保留最近 3 份，最新有效快照永不删，当前词库不健康时一份都不删。
- 中文与英文盯的不是同一种文件：中文是 `files/user_dict_3_3`，英文是
  `files/personal/Personal.en.dict`。英文那份由引擎在输入时生成，容器格式与中文不同，
  但字节兜底不依赖格式。`user_dict_3_3_english` 这个名字引擎根本不会创建，别再指回它。
- 英文没有条目级计数：`agb` 的可变词典访问器指向的不是个人词典，实测学习 4 个词后
  计数仍是 0。英文只有文件级兜底有效，不要按中文的计数逻辑推断英文。
- 状态页展开详情显示「最近几次保存时的大小」（只列有文件的样本），塌陷后能看到下跌。
  若上一次是文件恢复，状态行显示「词库文件已自动恢复，重启输入法后生效」而不是词条下降警报。
- 每次保存边界记一条尺寸样本（`save_journal`，只存时间与主文件/_bak 大小，12 条滚动），
  塌陷时把 `file-collapsed`/`count-collapsed` 连同样本写进 `last_debug`，并保证收尾的
  `worker-finished` 不会把它盖掉。这就是下次定位「哪一次保存把词库写小了」的依据。
- 词库是 mmap 的：文件比头部声明短会直接 SIGBUS，`refreshMutableDictionaryData` 也不会重新
  绑定已注册的句柄。所以恢复只能整文件 rename 覆盖（不能原文件写），且必须重启输入法生效。
- 除了条目快照，还保留词库文件的字节副本（`dictionary-safety/file-<字节数>-<时间>.gz`）。它不依赖引擎导出，
  所以在引擎读不出条目时依然有效：字节数创新高记基线，低于基线一半就取最近完整副本写回。判据只有
  `DictionarySafetyPolicy.isFileCollapsed`。用户主动清除词典时 `forget()` 清基线和副本，避免复活删掉的词。
- 存储固定在应用私有目录 `files/dictionary-safety/` 与独立 prefs；不进 SAF 目录、不进 `work/`、不与用户可见备份混用。
- 触发点是词库保存挂钩、备份排程和词库状态检查。真机验证过的行为与边界见 `docs/handoff/2026-11-11.md`。
- Java 侧改动走 `patches/java/.../dictsafety/` → `scripts/generate_dictsafety_smali.py` → `patches/smali/dictsafety/`。改到健康判据或冲突类时两个生成器都要重跑。
- 引擎确实会读 `files/user_dict_3_3`，入口是 `AbstractHmmEngineFactory.enrollMutableDictionary`：先 `prepareForLoad`，再把 fd 和长度交给 `DataManager.enrollMutableDictionary`，失败才回落空词典。不要再写「引擎不加载」。
- 导入走自己的路径（`DictionaryBackupText` 解析 + `GoogleNativeDictionaryBridge.importBackup`）。理由不是「原生坏了」：2026-11-12 用探针实测，原生 `user_dict_import` 任务与 `DictionaryImporter` 都完整保留权重（40 条 `count=190`、`getAllEntries=40`，persist 后重载一致）。历史上那次数十条权重归零是我们自己的 `prepare()` 重建 `Change` 时丢了 `count`，被误判成原生缺陷。保留自有路径的真实理由是整批原子发布（失败不落盘）与显式拒绝语义，原生任务中途失败会留下部分词条。验证方式用「立即备份」导出核对，不要只看状态页。
- 备份文本列顺序是引擎自己的「词、权重、拼音」，UTF-16LE、BOM、`#` 开头注释行。改解析或写盘两边都要对齐这个顺序。
- 状态页「中文词条」是导出条目数（`GoogleNativeDictionaryBridge` 用 `getAllEntries().length`），不是 `getDictionaryCount()` 的权重之和。诊断原生计数时别把两者混在一起。
- `DictionaryAutoBackupCompat`、`DictionaryAutoBackupSettingsCompat`、`LocalBackupImportActivity` 由 `scripts/generate_dictionary_patch_smali.py` 生成，健康页由 `generate_rime_sync_smali.py` 生成。2026-11-11 修过生成器只写外层类、不输出内部类的缺陷；改这几个类后要确认内部类 Smali 也跟着更新，旧内部类文件会被自动删除。
- `DictionaryOperationsCompat` 的 Smali 是手写维护，仓库内没有生成器；改它要手改 Smali，或把调用点放到能生成的类里。
- 仓库内 `org.jf.baksmali.Main` 不可用，`work/tools/apktool.jar` 里没有这个入口。
