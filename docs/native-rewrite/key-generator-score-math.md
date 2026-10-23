# 词典键生成、扩展结果消费与分数源码

## 当前范围

本轮恢复了研究依赖，沿词典访问器持有的辅助对象继续追踪。已定位扩展结果的消费、同一 token 判断、键生成分数归一化和裁剪，并还原一个能从普通 C++ 源码构建的标量数学组件。后续 [token 身份与扩展归一化](key-expansion-state.md) 已复用该组件，恢复身份判断、收集结束结果和稳定裁剪，后续真实普通资源、批量 source 转换及无扩展键的消费投影也已接通，[真实补文本与迭代收集](key-expansion-state.md#真实-manager-补文本与收集) 也已接通。

这仍不是完整输入法源码工程。这里的分数属于词典键生成路径，不能据此宣称已经恢复最终候选排序、用户学习或整句搜索。

固定原始 APK、当前发布基线和 ABI 坐标约定见 [JNI 与 C++ 边界](native-abi-map.md)。下文函数地址限定为固定原始库。

## 辅助对象与实际消费者

原生诊断字符串指向：

```text
i18n/input/engine/hmm/internal/storage/key_generator.cc
```

因此可把这一组函数称为词典键生成路径，但没有从文件名强行恢复某个 C++ 类的原名。

`MutableDictionaryAccessor +0xf0` 持有一个独立分配的 `0x40` 字节对象。已经确认的布局为：

| 偏移 | 已观察用途 |
| --- | --- |
| `+0x00` | 第一项管理器指针，刷新时从访问器 `+0xd8` 所指对象的 `+8` 取得 |
| `+0x08` | 扩展器管理器指针 |
| `+0x10` | 单类别 `[3]` 的缓存迭代器 |
| `+0x18` | 单类别 `[4]` 的缓存迭代器 |
| `+0x20` | 单类别 `[1]` 的缓存迭代器 |
| `+0x28` | 字符串对象，来自访问器 `+0xf8` 的配置 |

`0x18caa0` 配置缓存，只有传入的管理器指针非空才更新对应绑定。非空扩展器管理器会依次创建并替换三个缓存，旧对象随后释放；传入空值不等于清空已有缓存。`0x18cbac` 先清零三项缓存指针、复制配置字符串，再调用这一配置入口。`0x18be20` 根据词典可用状态创建、刷新或释放整个辅助对象，不是每次刷新都重新分配。

本阶段只把无扩展调用方实际需要的普通 Manager 作为借用参数，没有建立缺少后端的 0x40 字节上下文壳。访问器就绪、缓存替换与释放仅有静态证据，不宣称完整宿主生命周期。

已经连接的消费者包括：

- `0x18e264` 从 `+0x10` 取迭代器，逐源 token 收集扩展结果。
- `0x18e0e8` 从 `+0x18` 取迭代器，给已有选择继续扩展并带上已有分数。
- 词典写入、修改和导出附近的多条路径通过访问器 `+0xf0` 调用这些键生成函数。

第三个缓存的完整消费及所有模式分派仍未闭合，不根据类别编号直接命名为语言或输入方案。

## 结果消费与返回值

`0x18d07c` 调用迭代器的 reset、current、advance 和 exhausted 槽。它给输出记录补齐文字，将迭代器分数与调用方传入的分数作一次 float32 相加，再追加到输出向量。

该输出记录步长为 `0x28`：前 `0x20` 字节保留 token 记录，`+0x20` 保存分数，`+0x24` 保存一个调用方标记。标记的原业务名称尚未确定，不把它猜成学习、语言或命中状态。

返回值不能简单叫作「是否生成成功」。在特定模式下，即使输出非空，只要整个输出只有一项且与输入 token 身份相同，它仍返回 false。调用方会据此决定继续扩展或走其他路径。

身份比较 `0x18c620` 比较 token 记录 `+0x18` 起的低 48 bit，再比较 `+0x1e` 的 bit 0，不比较显示字符串。它与旧研究的 token ID、附加短字段和单 bit 身份键一致。

## 语言列表检查

`0x18ccb0` 要求源字符串数量与语言 ID 数量一致。两段向量分别按 24 字节、4 字节计数。

诊断信息明确区分 `language_ids`、源 token 和 `UNKNOWN_LANGUAGE`。当管理器返回未知语言标识 `26` 时，源语言列表中出现同一未知值会导致这条检查失败。

这证明键生成接口保留逐项语言选择，重建时不能把它简化成一个全局语言开关。检查先比较数量，再读取 Manager 的 slot 8；只有聚合语言为 26 时，才遍历拒绝源语言中的 26。单一具体语言的 Manager 可以接收该请求值，不按字典数量一刀切禁止。

`0x191e30` 调整次级对象 this 后经 `0x191e28` 读取主对象 `+0xb4`。`0x1948d0` 按配置遍历顺序聚合所有已解析条目，初值为 -1，不同语言变为 26，最后仍为 -1 时转成 26。宿主在 Load 时保留这一顺序与哨兵，不能从保留首项后的排序活跃表重新推算。其余相邻字段仍按已有观察表达，不由这个编号给整份记录猜业务名。

## 已接无扩展调用方

GenerateUnexpandedLearningKeys 恢复 `0x18db08` 中先校验、再真实批量转换的分支。返回零或一个既有 GeneratedLearningKey 消费投影。转换失败时，内部临时 token 即使已有部分结果，也不发布键记录；空输入则按原分支成功产生一个空 parts 记录。

原指令明确写入 binary32 1、标志 true 和 category 0，宿主按这些已观察值构造，不是为未恢复的生成器填默认系数。原完整记录还有 token 身份和逐项 true 的 vector<bool>，现有消费投影不读取它们，仍不新增第二份结果结构或假空向量。真实 token 文本进入已有 SerializeLearningKey，模式非零按 token 顺序拼接，零按反序拼接，计数缩放也使用原消费者。

一次完整宿主构建和同一真实资源入口通过，覆盖生成后消费、不同序列化方向、数量不匹配、多语言未知值拒绝、单语言未知值准入、部分未命中及空输入。旧数学、逆序和 schema 模块未重跑。日志为 `work/native-rewrite/forward-token-build/unexpanded-key-generation-build.log`。

新增三个完整 FDE，全部 raw-equal，中央从 521 增至 524。原校验、激活归约、调用方和缓存配置字节证据直接沿用。证据为 `work/native-rewrite/restart-v217/native-unexpanded-key-generation-comparison.json`，Ghidra 输出位于 `key-generator-input-context/` 和 `key-generator-input-language/`。未执行原 ARM/Android，也未修改设备、用户词典或正式包。

## 原生分数计算

`0x18d424` 对一组扩展分数执行：

1. 以第一项分数为起点，用 `0x18c69c` 逐项合并。
2. 每项减去合并结果，保留 float32 运算。
3. 保留结果不低于原生阈值 `0xc0133333` 的项，随后缩短向量。

该阈值是 float32 的约 `-2.3`。这里使用近似对数运算，不能把阈值包装成一个精确的概率承诺，也不能解释为用户词频换算。

### 合并不是普通标准库 log-sum-exp

`0x18c69c` 的形状接近 log-sum-exp，但调用的是自带查表函数：

- `0x18c56c`：指数近似，包含一次明确的 float32 FMADD。
- `0x18c5d8`：对数近似，按指数和尾数分段查表、插值，同样包含 FMADD。
- 两个分数之差乘原生 `log2(e)` 后，绝对值大于 `126` 时直接取较大分数。

共有四段查表数据，合计 640 个 32-bit word。原生 `ln(2)`、偏置和界限也按原始 bit 保留。不能直接换成 `std::exp`、`std::log`，也不能把 FMADD 拆成两步再声称数值等价。

已对比固定原版与 `v2.1.7`：这三个标量函数的反汇编指令序列、表数据、标量常数及归一化阈值一致。该指针对应区没有发生本轮预想的地址迁移，不引入额外版本兼容分支。证据为 `work/native-rewrite/restart-v217/score-math-baseline-comparison.json`。

## 已还原的可编译源码

源码位于：

```text
research/native-rewrite/recovered/score_math.h
research/native-rewrite/recovered/score_math.cc
research/native-rewrite/recovered/score_math_tables.inc
```

这套组件实现有限输入域中的 AddLogScores 与 ExpLogScore，使用恢复的指数与对数查表函数。后续已选路径接纳复用同一 ExpLogScore，将实际路径分数转成 scale，详见 [接纳与结果集合](key-expansion-state.md#已选路径的接纳与结果集合)。没有输入法占位实现、固定候选或对旧 `.so` 的转发。后续归一化已在独立 key_expansion 组件实现，宿主只表达已观察 token 字段，不克隆原布局。后续普通 token 管理器及无扩展消费投影已有真实入口，真实扩展收集与已选路径接纳后续已有入口，完整候选流、键组合和输入引擎仍在后续范围。

`score_math_tables.inc` 是已经入库的可读常数源文件。研究导出器可以重新生成它，但编译时不需要 APK、LIEF、Capstone、反编译器或旧 native 库。该材料不因恢复成源码而自动获得新的 MPL 授权，权利范围继续按 `NOTICE`。

本机使用已有 WSL 编译器，从项目根执行普通 C++ 构建：

```sh
mkdir -p work/native-rewrite/recovered-score
g++ -std=c++17 -O2 -Wall -Wextra -Werror -ffp-contract=off \
  research/native-rewrite/recovered/score_math.cc \
  research/native-rewrite/tools/score_math_probe.cc \
  -o work/native-rewrite/recovered-score/score_math_probe
```

该命令在 Linux shell 中执行，Windows 可通过既有 WSL 进入项目目录。禁止启用 fast-math，非原生 FMADD 位置保持分离运算。研究 probe 消费这个组件并输出 float32 bit，暂未接入 Android 输入法。

## 验证与未覆盖项

- 依赖恢复后，旧数据导出与反汇编的五个既有测试通过，完整导出入口提取 63 个数据 blob。
- 扩充既有 native 出口测试，确认键消费、归一化、FMADD 和关键原始常数，没有另建同能力防御测试。
- C++ 源码构建通过。真实 CLI 的四组标量输入验证了相等分数与远距分数，期望值来自原生常数和零残差查表单元的静态推导，不由新实现计算。

这些结果不等于 ARM64 原生执行对照。非零插值单元、完整数值范围、Android 编译器与实际输入引擎尚未完成等价性验收。后续组件已验证少量非零插值的裁剪结果，仍不是完整数值范围或原 ARM64 逐 bit 对照。下一步展开实际源 token 查询接口和资源来源，不能以这些组件代表全部排序和学习已恢复。
