# 原生用户词典导入研究（进行中）

探针。目的是判断「原生导入丢权重」能不能在原实现上修好，
而不是继续绕开它。

## 已经确认的事实

### 导入链路

`TaskFactory` 的任务名 `user_dict_import` 由 `awx` 注册，实现是
`UserDictImportTask`：

1. 用 `AbstractHmmEngineFactory.MutableDictionaryType.USER_DICTIONARY` 构造
   `DictionaryAccessor`。
2. 从 `DictionaryFormat.getParser()` 取 `bed`（本 APK 的拼音格式实现）。
3. `Parser.connect()` 接上 `new DictionaryImporter(accessor)`。
4. 逐行解析后 `DictionaryImporter.write()` → `DictionaryAccessor.insertOrUpdate(Entry)`。

### 上限

`DictionaryImporter.write()` 里写死比较：`getDictionarySize() >= 0x7a120`（500000）时抛
`DictionaryImportExportException`（字符串资源 `0x7f11033f`）。所以**导入上限是 50 万条**，
之前 10 万条没触发是正常的。

### 关键疑点

`DictionaryImporter` 走的是 `DictionaryAccessor.insertOrUpdate(Entry)`，
`DictionaryAccessor.insertOrUpdateEntry` 再调用
`MutableDictionaryAccessorInterface.insertOrUpdate(tokens, languageIds, value, count,
isModified, isNormalizedToken)`。这正是我们自己导入路径用的同一个原生接口，而我们的路径
权重保留、导出正常。

也就是说：**丢权重不是「原生接口不支持权重」**，入口和参数形状都一样。差别只能在
`bed` 拼出来的 `Entry` 字段里。

### `Entry` 的字段对应（从 `bec` 导出器反推）

`bec` 写文件时取 `entry.value` 作第一列、`entry.count` 作第二列、`entry.tokens` 作第三列，
与导出文件 `phrase \t weight \t code` 一致。`bed` 解析时同样是把三列分别落到 value、count、
tokens，`languageIds` 每项填 `0x10`（即 `PINYIN_LANGUAGE_ID = 16`），`isModified = false`，
`isNormalizedToken = true`，`tokenExpansionType = 0`。这些与我们的构造完全一致。

`bed` 里确实有 `Integer.parseInt` + `Math.max(1, w)` 的权重解析，说明解析器并没有丢权重。

## 实验结果（已推翻原来的诊断）

研究分支上加了一个只用于研究的探针（`NativeImportProbe`，不进主线），用两种方式跑同一份备份：

| 方式 | 结果 |
| --- | --- |
| 直接跑原生管线：`bea` 格式 → parser → `TsvFileReader` → `DictionaryImporter` | 2 条词条权重 100 和 7，`count=107`，`getAllEntries=2`，persist 后重载仍是 107 |
| 调度原来的任务 `user_dict_import`（`beh` + `aib`） | 同样 2 条：`count=107`、2 条；40 条那份：`count=190`（权重和）、`getAllEntries=40` |

两种方式都**完整保留了权重**。也就是说原生导入链路本来是好的。

## 结论（已修正）

**原生导入没有丢权重。** 之前看到的「40 条词条权重全变 0」，是我们自己桥接代码在早期版本里
重建 `Change` 时丢了 `count`（`AGENTS.md` 里 2026-11-11 那条真机记录就是这个），被误判成了原生缺陷。

因此：

- 不需要修原生导入，它没有坏。
- 自己的导入路径继续保留，但理由要改成真实的那两条：整批原子发布（失败不留半成品）
  和显式拒绝语义。原生任务写到一半失败会留下部分词条，这一点实测过。

## 探针怎么跑

探针放在主线的 `patches/research/`，但**不进正式包**：`apply_patches.py` 只有带 `--research`
时才把类文件和清单里的 `NativeProbeActivity` 装进解码目录。不带这个参数构建出来的 APK，dex 和
清单里都没有 `NativeProbe` 字样（2026-11-12 核过），本地常规构建和 CI 产物都不受影响。

## 顺带回答：9.6 万条词库是怎么丢的

这不是导入造成的，`docs/handoff/2026-11-11.md` 已记录事故全过程。今天补了一个机制实验：

把 1,610,688 字节（10,000 条）的词库截断到 966,412 字节后重新注册：

| 观察点 | 结果 |
| --- | --- |
| `getDictionarySize()` / `getDictionaryCount()` | 仍报 50000 / 49996，与截断前一致 |
| `getAllEntries()` | `SIGBUS`（`BUS_ADRERR`）崩溃，进程直接死 |
| `_bak` / `_tmp` / `_unreadable` | 都没有生成，原生没有把这当成「文件不可读」 |

两个结论：

1. 词库是 mmap 的，计数来自文件头部，枚举才会真正读页。文件短于头部声明时不是报错，是崩溃。
2. 所以 9.6 万那次**不是文件损坏**，否则会崩。它是「头部与索引只指向一小部分记录、文件本身仍然
   完整」的逻辑塌陷：引擎如实报出约 3,552 条，文件保持 21.64 MB，补回 96,670 条只增长 226,600
   字节，说明数据一直躺在文件里。

塌陷会自我固化：内存只读回一小部分，之后每次保存都把这一小部分写回磁盘，于是云端备份一份接一份
都是 122 kB。

触发时刻只能缩到「11-07 20:19 之后、11-09 01:40 之前」，那段时间没有日志留存，无法再缩小。
原生没有暴露「在原文件上重建索引」的接口，`refreshData()` 是否真能修好一个塌陷视图也还没验证
（探针在枚举阶段就崩了，没走到那一步）。

## 塌陷能不能靠刷新救回来（已验证：不能）

实验：先让引擎持有 40 条的词库，然后把一份 2 条、5,128 字节的词库用 rename 覆盖到同一路径。

| 步骤 | `getDictionaryCount()` | `getAllEntries()` |
| --- | --- | --- |
| 换文件前 | 190 | 40 |
| 换文件后（同一句柄） | 190 | 40，视图仍是旧的 |
| `refreshMutableDictionaryData(USER_DICTIONARY)` 之后 | 190 | 40，**没有变化** |
| 关掉再注册一个新的 accessor | 107 | 2，读到的是新文件 |

两点结论：

1. 引擎把词库 mmap 住，`refreshMutableDictionaryData` 不会重新绑定已经存在的句柄，所以刷新
   救不回塌陷视图。
2. 新注册的 accessor 会重新读文件，说明文件本身修好后不需要重装或清数据，只要让引擎重新注册。
   对运行中的输入法来说，这个时机只发生在服务重启或保存边界，所以「恢复后重启输入法」仍然是
   唯一的可靠做法。

顺带说明：字节恢复必须用 rename 覆盖，不能在原文件上写。写原文件会截断正在被 mmap 的文件，
下一次读取直接 SIGBUS——这也是 `DictionaryFileSnapshot.restore()` 现在写临时文件再 rename 的原因。

## 对产品决策的影响

「原生那边能不能修」这个问题已经不需要回答了：原生没坏。

要不要换回原生任务，是一个取舍问题：

- 原生任务：少维护一份解析代码，但失败时可能留下部分词条。
- 现在的自有路径：整批原子发布、失败不落盘、权重回读校验。

按今天验过的行为，保留自有路径更稳，但主线文档里不能再写「原生导入丢权重」，
那是错误归因。

## 探针的用法

改探针源码后重新生成 Smali：

```bash
python scripts/generate_research_probe_smali.py   --android-jar "$SDK/platforms/android-36/android.jar"   --jdk "$JDK" --build-tools "$SDK/build-tools/36.0.0" --apktool work/tools/apktool.jar
```

构建带探针的审计包（本地脚本认 `PINYIN_RESEARCH=1`）：

```bash
PINYIN_RESEARCH=1 bash work/dyn-inspect/build_all.sh
```

跑探针时把词典文件放进应用自己的 `files/`：`file:///sdcard/...` 会被 scoped storage 挡掉，
报 `EACCES`。然后 `am start` 加参数：

```bash
adb shell am start -n <包名>/com.google.android.inputmethod.pinyin.NativeProbeActivity   -a android.intent.action.VIEW -d file:///data/data/<包名>/files/two.txt --ez task_probe true
adb logcat -s NativeProbe:*
```

| 参数 | 作用 |
| --- | --- |
| 无 | 走原始导入链并逐条打印权重 |
| `--ez task_probe true` | 复现应用原先调度的 `beh` 导入任务 |
| `--ez refresh_probe true` | 只调 `refreshData()`，看文件重读 |
| `--el damage_keep <字节>` | 把词库文件截断到指定大小，观察引擎反应 |

2026-11-12 在 arm64 真机上用 2 条目的文件验过 `task_probe`：任务回报 `onTaskFinished [true,null]`、
`getAllEntries=2`，两条权重分别 100 和 90，没有丢。

探针会读写真词库，`damage_keep` 更是直接截断文件。所以它只能存在于研究构建里，这一点由构建参数
保证，不靠自觉。
