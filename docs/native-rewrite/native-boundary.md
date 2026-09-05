# Google 拼音 4.5.2 native 边界研究

## 文档状态

本文档记录固定原始 APK 中 5 个 ARM64 ELF 的第一轮静态分析。已经确认 ELF 结构、动态依赖、Java native 声明、静态 JNI export、动态注册字符串和 data bundle 符号边界。

尚未反编译 native 函数体，也没有通过运行时 linker trace 验证实际装载顺序。文中明确标记的推断不能视为运行时事实。

## 方法

使用项目本地 Python 3.12 和 LIEF 0.17.6 执行：

```text
PYTHONPATH=tools/python python research/native-rewrite/tools/inventory_elf.py \
  --apk original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk \
  --java-sources work/native-rewrite/original-apk/jadx-src/sources \
  --output work/native-rewrite/original-apk/elf-inventory.json
```

脚本输出：

- ELF header、section 和 segment
- `DT_NEEDED` 动态依赖
- import、export、dynamic symbol 和 relocation
- Java `native` 声明
- 静态 JNI export
- Java class descriptor 和 native method name 字符串候选

方法名或类名出现在 ELF 字符串表，只能证明它是动态注册候选，不能独立证明该库最终注册了对应方法。

## ELF 总表

所有文件都是 little-endian ARM64 `ET_DYN`。

| 文件 | 大小 | 函数 export | 函数 import | relocation | `PT_LOAD` alignment |
| --- | ---: | ---: | ---: | ---: | --- |
| `liben_data_bundle.so` | 9,456 bytes | 0 | 2 | 3 | 64 KiB |
| `libgnustl_shared.so` | 1,095,984 bytes | 2,817 | 96 | 2,715 | 64 KiB |
| `libhmm_gesture_hwr_zh.so` | 6,926,712 bytes | 559 | 220 | 15,536 | 4 KiB |
| `libhwrword.so` | 2,373,728 bytes | 351 | 171 | 5,419 | 64 KiB |
| `libpinyin_data_bundle.so` | 10,077,424 bytes | 0 | 2 | 3 | 64 KiB |

只有 `libhmm_gesture_hwr_zh.so` 的两个 `PT_LOAD` segment 使用 4 KiB alignment。其余四个库的 `PT_LOAD` 均为 64 KiB。这与现有 16 KiB 兼容调查中「核心统一库仍是阻塞项」的结论一致。

## 动态依赖

| 文件 | `DT_NEEDED` |
| --- | --- |
| `liben_data_bundle.so` | `libc.so` |
| `libpinyin_data_bundle.so` | `libc.so` |
| `libhmm_gesture_hwr_zh.so` | `libdl.so`、`liblog.so`、`libc.so`、`libm.so` |
| `libhwrword.so` | `libgnustl_shared.so`、`liblog.so`、`libz.so`、`libdl.so`、`libstdc++.so`、`libm.so`、`libc.so` |
| `libgnustl_shared.so` | `libm.so`、`libc.so`、`libdl.so` |

统一库没有声明对 `libhwrword.so` 或 `libgnustl_shared.so` 的 `DT_NEEDED` 依赖。它导入 `dlopen` 和 `dlsym`，因此仍可能在运行时按其他标识装载数据或代码，但当前没有发现 `libhwrword.so` 文件名字符串。

## PinyinApp 的逻辑库别名

`PinyinApp` 静态初始化调用：

```text
amd.a(
  "hmm_gesture_hwr_zh",
  "hmm",
  "gesture",
  "handwriting",
  "hwr_zh_model",
  "jni_delight4decoder"
)
```

`amd` 将后五个逻辑名称映射到第一个物理库。后续调用：

```text
amd.b("hmm")
amd.b("gesture")
amd.b("jni_delight4decoder")
```

最终都会执行：

```text
System.loadLibrary("hmm_gesture_hwr_zh")
```

因此，HMM、gesture、当前手写和 Delight4 入口在该 APK 中由同一个物理 ELF 提供。逻辑名称不是独立 `.so`。

`amd` 在系统无法直接加载时，还会从 APK 的 `lib/<ABI>/` 精确提取目标 `.so` 到应用私有临时目录，再调用 `System.load()`。这是旧 Android native 装载兼容逻辑，不应成为未来原生架构的默认方案。

## Java native 声明

DEX 中共有 180 个 Java `native` 声明，其中有 174 个唯一的 class/method name 组合。6 个差值来自重载方法。

| Java 类 | 声明数 | 职责 |
| --- | ---: | --- |
| `HmmEngineInterfaceImpl` | 69 | HMM input graph、候选、segment 和 token |
| `Decoder` | 26 | Delight4 英文解码和个性化 |
| `MutableDictionaryAccessorInterfaceImpl` | 25 | mutable dictionary |
| `DataManagerImpl` | 12 | data scheme 和数据载荷 |
| `WordRecognizerJNI` | 12 | 手写词识别 |
| `DynamicLm` | 11 | Delight4 dynamic language model |
| `HmmGestureDecoder` | 9 | HMM gesture |
| `EngineFactory` | 8 | native factory |
| `SettingManagerImpl` | 3 | setting scheme |
| HMM gesture `JniUtil` | 2 | 初始化和释放 |
| `LanguageIdentifier` | 2 | 语言识别 |
| Delight4 `JniUtil` | 1 | 初始化 |

## 静态 JNI export

### libhmm_gesture_hwr_zh.so

统一库导出 17 个标准 `Java_...` JNI symbol：

- `EngineFactory.initJNI` 和 `deinitJNI`
- HMM gesture `JniUtil.initJNI` 和 `deinitJNI`
- Delight4 `JniUtil.init`
- `WordRecognizerJNI` 的 12 个方法

统一库没有导出 `JNI_OnLoad`。这说明它不是在 `JNI_OnLoad` 中统一注册全部接口，至少一部分注册由上述显式初始化函数触发。

gesture decoder 的 9 个实现以 C++ mangled symbol 导出，例如：

```text
_Z12nativeCreate...
_Z12nativeDecode...
_Z13nativeRelease...
_Z23nativeSetKeyboardLayout...
```

它们不是标准 `Java_...` 名称，需要动态注册或由静态 JNI 方法间接绑定。

### libhwrword.so

`libhwrword.so` 导出 23 个标准 JNI symbol：

- `SingleCharRecognizerJNI` 的 11 个方法
- `WordRecognizerJNI` 的 12 个方法

当前 DEX 中存在 `WordRecognizerJNI`，但不存在 `SingleCharRecognizerJNI` Java class。统一库也重复导出同一组 12 个 `WordRecognizerJNI` 方法。

当前 Java 源中没有发现 `hwrword` 字符串或直接装载调用，其他 ELF 也没有通过 `DT_NEEDED` 引用它。现有证据支持「该库可能是未被当前产品路径使用的遗留或备用手写实现」这一推断，但在运行时 linker trace 完成前不能标记为确定无调用方。

### data bundle 和 GNU STL

以下库没有 JNI 函数 export：

- `liben_data_bundle.so`
- `libpinyin_data_bundle.so`
- `libgnustl_shared.so`

data bundle 的作用通过全局数据 symbol 表达，不通过 Java JNI 函数调用。

## 动态注册证据

`libhmm_gesture_hwr_zh.so` 包含以 `RegisterNatives failed for methods in` 开头的注册失败文案，并包含 9 个 Java class descriptor：

```text
com/google/android/apps/inputmethod/libs/hmm/DataManagerImpl
com/google/android/apps/inputmethod/libs/hmm/EngineFactory
com/google/android/apps/inputmethod/libs/hmm/HmmEngineInterfaceImpl
com/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterfaceImpl
com/google/android/apps/inputmethod/libs/hmm/SettingManagerImpl
com/google/android/apps/inputmethod/libs/hmmgesture/HmmGestureDecoder
com/google/android/keyboard/client/delight4/Decoder
com/google/android/keyboard/client/delight4/DynamicLm
com/google/android/keyboard/client/delight4/LanguageIdentifier
```

它还包含 160 个与 Java native class/method name 匹配的字符串候选，包括 HMM、data manager、setting manager、mutable dictionary、gesture 和 Delight4 方法。

结合显式 `initJNI()`、class descriptor、method name、JNI signature 和注册失败文案，可以确认统一库使用 `RegisterNatives` 风格的方法表注册大量接口。尚待完成的是将每个 Java 声明映射到 method table 地址和 native 函数地址。

## data bundle 的真实结构

### 共同结构

两个 data bundle 的 `.text` 都只有 60 bytes，主要载荷集中在 `.rodata`：

| 文件 | `.rodata` 大小 |
| --- | ---: |
| `liben_data_bundle.so` | 2,304 bytes |
| `libpinyin_data_bundle.so` | 10,065,920 bytes |

它们没有函数 export，但 dynamic symbol 中存在大量：

```text
_binary_<name>_start
_binary_<name>_end
```

这证明它们是以 ELF 作为载体的命名二进制数据集合，而不是普通计算库。统一库导入 `dlopen` 和 `dlsym`，原版 `DataManager.enrollBuiltInDataScheme()` 又接收 data bundle 文件名，因此可推断 native data manager 会通过动态装载和 symbol 名称取得数据边界。该调用方式仍需通过函数体或运行时 trace 最终确认。

### 拼音 data bundle

已经从 symbol 边界确认的主要载荷：

| 数据 | 大小 |
| --- | ---: |
| `pinyin_system_dictionary` | 5,374,840 bytes |
| `pinyin_bigram` | 3,151,376 bytes |
| `stroke_token_dictionary` | 700,304 bytes |
| `pinyin_system_english_dictionary` | 295,256 bytes |
| `pinyin_system_digits_dictionary` | 45,648 bytes |
| `pinyin_system_emoji_dictionary` | 25,728 bytes |
| `pinyin_token_v_2` | 9,880 bytes |
| `data_scheme` | 3,189 bytes |
| `gesture_data_scheme` | 600 bytes |

这组大小关系表明主要中文候选数据由约 5.37 MB 的 system dictionary 和约 3.15 MB 的 bigram 数据构成。具体编码、概率表示和索引方式尚未解析。

七种拼音方案也有独立数据边界。全拼使用 `pinyin_token_v_2`，六套双拼 token 数据大小约为 9 KiB：

| 双拼方案 | token 数据大小 |
| --- | ---: |
| 智能 ABC | 9,312 bytes |
| 小鹤双拼 | 9,312 bytes |
| 拼音加加 | 9,552 bytes |
| 微软双拼 | 9,376 bytes |
| 紫光双拼 | 9,312 bytes |
| 自然码 | 9,592 bytes |

此外还存在：

- 六套双拼 token ID table
- 12 组 fuzzy expansion
- pinyin initial 和 reverse-initial token expansion
- English 和 digits token/reconversion expansion
- QWERTY 与九键有无英文的 setting scheme
- handwriting 和 stroke setting scheme
- mutable dictionary accessor setting scheme
- shortcuts token 与 accessor setting scheme

因此，双拼和模糊音主要通过可替换的数据表进入同一个 HMM engine，而不是七套完全独立的解码器。

### 英文 data bundle

`liben_data_bundle.so` 中已确认：

```text
en_data_scheme
english_qwerty_setting_scheme
english_9key_setting_scheme
en_mutable_dictionary_accessor_setting_scheme
en_tokens
en_reconversion_expansion
shortcuts_tokens
shortcuts_mutable_dictionary_accessor_setting_scheme
```

该库只有 2,304 bytes `.rodata`，不是完整英文语言模型。完整英文模型另由 `res/raw/main_en_d3_20160715.gzip` 提供。data bundle 主要承载 schema、token 和 setting metadata。

## ELF 构建特征

### 统一库

`libhmm_gesture_hwr_zh.so` 的主要 section：

| section | 大小 |
| --- | ---: |
| `.text` | 2,684,216 bytes |
| `.rodata` | 2,883,800 bytes |
| `.eh_frame` | 572,944 bytes |
| `.data.rel.ro` | 93,520 bytes |
| `.data.rel.ro.local` | 42,624 bytes |
| `.data` | 6,536 bytes |
| `.bss` | 50,824 bytes |

它没有普通 `.symtab`，只保留 `.dynsym`，但仍有 559 个函数 export、完整 JNI class/method 字符串和大量 C++ 类型信息。后续 native 分析可以围绕动态注册表和已导出函数展开，不需要先从完全剥离的地址空间盲目识别全部函数。

### data bundle

`libpinyin_data_bundle.so` 的 10,065,920-byte `.rodata` 占文件绝大部分，且 start/end symbol 直接给出各 blob 边界。目前已无重叠地导出两个 bundle 中的全部 63 个命名 blob，并将 17 个 protobuf 和 46 个原生数据容器分类，完整结果见 `data-bundle-formats.md`。

## JADX 失败方法分类

### defpackage.bnr

`bnr` 是 Google Play services API manager：

- 创建名为 `GoogleApiHandler` 的线程
- 管理 Google API client 和 ConnectionResult
- 引用 `GoogleApiActivity`、Sign-In 状态及 PendingIntent

失败方法是其 `Handler.Callback.handleMessage()`。它属于已退役的 Google 服务基础设施，不在拼音解码、候选或本地词典主路径中。现阶段无需为原生重写恢复该方法。

### defpackage.xw

`xw` 持有 RecyclerView 集合和预取任务，是旧 Android Support RecyclerView 的 GapWorker 类。失败方法是 `Runnable.run()`。

它可能影响旧设置列表的滚动性能，但不是输入引擎逻辑。未来原生设置已经采用 Compose，不需要重建该内部实现。除非后续研究发现输入视图使用同一 RecyclerView 路径，否则不继续还原该方法。

因此，JADX 的两个失败方法都不是当前核心输入研究的阻塞项。

## 对未来重写的直接影响

### HMM 接口不能简化成字符串查询

native 接口拥有 input graph、Range、segment、token、input unit、普通候选、prediction 候选和 token 候选。未来引擎可以采用不同内部算法，但对上层至少要表达：

- 增量输入
- composing 分段
- 部分选择和取消选择
- 候选与覆盖范围
- 预测候选
- 删除和重新组词
- 键盘几何或 scored input
- 用户词典更新

### 数据与算法可以分开研究

拼音 bundle 已经提供明确 blob 边界。研究可以分别处理：

1. token 和方案映射
2. system dictionary
3. bigram
4. setting/data scheme
5. fuzzy expansion
6. stroke dictionary
7. mixed-input dictionary

不需要把 10 MB data bundle 当作单一未知文件。

### 手写存在两套实现痕迹

统一库和 `libhwrword.so` 都导出 `WordRecognizerJNI`。未来调查需要先确定运行时实际使用哪一套，再研究模型和 lattice，不能把两个库的代码或能力简单相加。

## 下一步

1. 恢复 setting scheme 数值参数的名称和单位
2. 解析 token dictionary 与 system dictionary 的 auxiliary 数据
3. 将 9 个动态注册 class 的 method table 映射到函数地址
4. 对 HMM append、fill candidate、select candidate 和 dictionary accessor 建立最小 ARM64 调用子图
5. 通过受控 linker 日志或 hook 验证 `libhwrword.so` 是否实际装载
6. 定位 data type factory 和各原生数据容器 reader
