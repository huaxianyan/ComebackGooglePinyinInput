# 扩展结果身份与类别请求

## 范围

本轮继续追踪 `TokenExpanderManager`，确认结果容器的比较键，并定位调用方实际传入的类别列表。

证据来自固定原始 APK 的 ARM64 指令、只读常量和 ELF relocation，不是设备执行记录。地址均为 ELF 虚拟地址，函数标签除 RTTI 类型名外仍是研究命名。

现有 `disassemble_direct_mapping.py` 增加结果比较、类别请求与输出迭代相关区间，共导出 31 个有界区间。新增 `direct_branch_references` 只扫描 `.text` 中立即数形式的 `B` 和 `BL`，不包含虚调用、函数指针调用或运行时生成代码。

## 结果身份是三元组

比较逻辑内联在 `0x196684`–`0x1967cc` 的结果插入函数中。它把节点 `+0x20` 视为结果对象，再按以下顺序比较：

| 优先级 | 结果对象内偏移 | 读取与比较方式 |
| ---: | --- | --- |
| 1 | `+0x1c` | `ldrsh` 读取有符号 16-bit 附加标识，按有符号大小比较 |
| 2 | `+0x18` | `ldr w` 读取完整 32-bit token ID，按无符号大小比较 |
| 3 | `+0x1e` 的 bit 0 | 掩码后得到 `0` 或 `1`，按大小比较 |

可概括为：

```text
identity = (signed16(aux), uint32(token_id), flags_byte & 1)
```

附加标识的有符号分支位于 `0x1966b8`，token ID 的无符号分支位于 `0x1966d0`，两个标志掩码位于 `0x1966e0` 与 `0x1966e4`。

三者相等时，插入返回已有节点，并把「是否新插入」设为 false。新扩展目标的分数更新仍由 [管理器 apply 路径](direct-mapping-metadata.md#管理器不是简单并集) 决定，比较器本身不比较 score。

### 明确排除的误解

这段完整比较逻辑只检查上述三个值：

- 附带文本不参与结果身份比较
- score 不参与结果身份比较
- token ID 使用完整 32 位，不按低 21 位 key 或 token code 比较
- 相同文本但不同三元组的结果，可以作为不同容器项存在
- 相同三元组即使附带文本或分数不同，也会被视为同一项

这里讨论的是 native expansion 结果容器，不是最终候选文本去重。`flags_byte & 1` 的原始字段名称和业务含义仍未知，不能直接称为用户词、系统词或其他来源标记。

## 容器顺序与分数处理分离

`manager_current` 位于 `0x196074`–`0x196224`，从当前节点分别复制附带文本、token ID、附加标识、标志位和 score。

`manager_advance` 位于 `0x196650`–`0x196684`，通过树节点推进函数更新当前节点。容器按上述三元组组织，而不是在比较器中按分数排序。

此前已确认的新目标重复插入路径只在分数更大时更新已有 score，不替换身份字段。拒绝输入后保留原项的插入分支没有同样的 score 更新代码。这两条分支不能统一概括成「同一个文本总是保留最大分数」。

最终候选如何排序、如何合并显示文本仍不在当前证据范围内。

## 五个直接类别请求点

对 `manager_create_iterator`（`0x197348`）的直接分支扫描得到五个 `BL` 调用点：

| 调用位置 | 请求类别 | 已确认的上下文 |
| --- | --- | --- |
| `0x13018c` | `[2]` | 单独 fuzzy 请求，完整客户端类型尚未确认 |
| `0x1752a4` | `[1, 2]` | `TokenDecoderBase` 相关配置路径 |
| `0x18caf0` | `[3]` | 三类别客户端的第一个独立缓存 |
| `0x18cb34` | `[4]` | 同一客户端的第二个独立缓存 |
| `0x18cb78` | `[1]` | 同一客户端的第三个独立缓存 |

类别与当前数据角色的关联沿用 [metadata 研究](direct-mapping-metadata.md#当前数据的字段取值)：`1` 为 initial，`2` 为 fuzzy，`3` 为 reconversion，`4` 为 reverse-initial。这些不是恢复出的原始 enum 符号名。

「五个」只指当前 ELF 中指向该入口的直接分支，不能据此宣称不存在间接调用，也不能将静态引用等同于运行时可达。

### Initial 后接 fuzzy

配置路径 `0x17522c` 从只读地址 `0x349d10` 复制两个 32-bit 值：

```text
01 00 00 00 02 00 00 00
```

它把 `[1, 2]` 传入管理器，再将返回的迭代器保存到调用方对象 `+0xd0`。

关联的构造路径 `0x1751ac` 写入虚表 `0x68aac0`。该虚表的 RTTI 指向 `0x68aa90`，类型名位于 `0x349ce0`：

```text
N10i18n_input6engine3hmm16TokenDecoderBaseE
```

结合此前确认的管理器顺序应用逻辑，这个请求选择 initial 类别后再选择 fuzzy 类别。不能倒置类别顺序，也不能把这条路径改称为 reconversion 后自动追加 fuzzy。

本轮尚未把该配置函数的直接调用方 `0x140cf0` 连接到完整 engine 初始化链，因此不宣称所有输入模式都使用这个类别组合。

### 三个独立缓存，不是一条流水线

`0x18caa0`–`0x18cbac` 先后建立三个单类别请求：

| 类别 | 返回迭代器保存位置 |
| --- | --- |
| `[3]` | 客户端对象 `+0x10` |
| `[4]` | 客户端对象 `+0x18` |
| `[1]` | 客户端对象 `+0x20` |

每次都单独构建一个只有一项的类别列表，并分别调用管理器。因此它不是一个 `[3, 4, 1]` 的串行 expansion 请求，也不是已证明的用户操作顺序。

该客户端配置入口有两条已确认的直接尾调用：`0x18bebc` 向前跳转，构造路径末端 `0x18cbf4` 向后跳转，两者都是 `B` 而不是 `BL`。客户端的原始类型名，以及三个缓存分别由哪些业务操作消费，仍待追踪。

## 宿主 Manager

后续已恢复 `TokenExpanderManager`，从 repeated string 配置、原 data ID 缓存进入真实 DirectMapping 子游标。`0x19c890` 先解析单字段字符串列表，再复制 ID 顺序。读取投影为 `token_expansion_setting.proto`，字段和消息名称仍是研究标签。

原 TokenDictionaryResources 更名为 TokenModelResources。普通字典和扩展器共用类名前缀分派、ID 索引及成功模型缓存，两个 Manager 检查各自模型类别。没有第二套资源登记或兼容别名。

加载按配置顺序将模型追加到类别组。缺失 ID 和类别零沿原路径跳过，未支持的后端使宿主新建工厂失败。此处不模拟原重配置先清空再部分装入的发布行为，也不把未知后端当作空迭代器。

`CreateCursor` 按请求类别顺序拼接各组，保留组内配置顺序和重复选择。实际 DirectMapping 与 Manager 游标共用唯一 TokenExpanderCursor 协议，没有逐方法适配壳。当前只有 DirectMapping 后端，跨不同非空类别组的运行组合仍未覆盖。

`Reset` 放入完整输入和正零分数，再逐项应用子游标，完成后定位有序结果首项。原 `0x196bbc` 明确写入 `w0 = 1`，宿主也返回 true。没有匹配组时，结果是原输入一项，保持真实 Manager 行为。

每轮 Apply 先移出旧集合，再按身份顺序遍历。子游标拒绝时保留原项，不更新碰撞分数。接受时改用子结果，以 binary32 将旧分数加到新分数；目标身份重复时，仅更大分数覆盖旧值，原文本与身份字段保持先到值。

临时 KeyToken 和分数每轮 Apply 仅初始化一次，位置在源项和结果循环之外。DirectMapping 的部分写入可延续此前回退留下的字段，不能每个 Current 前重建临时 token。结果排序与身份相等共用 IdentityFields，定义点在 key_expansion.cc，文本和分数不进入比较键。

Current 复制完整已知 token 字段并支持可选分数，Advance 只推进结果位置。实际调用方传入非空 token，原 Manager 的空 token 输出扩展未投影。普通零 code 的子分数为负零，经 Manager 的正零加法后，结果按原 binary32 得到正零。

### 宿主验证与边界

一次 `build_forward_token_research.sh expander` 完整宿主构建通过，浮点收缩关闭。升级原资源端到端用例，C++ 从三个原 DataScheme 建立同一索引，再按明确测试配置选择四个原 DirectMapping ID：

- 「唔」的数组顺序是 en、n、wu，Manager 输出按身份变为 n、en、wu。重复类别请求继续携带非零分数。
- 未知附加值的「I」先过拼音时得到拼音 ID 和 `16`，先过英文时得到英文 ID 和 `0`，证明顺序变换与简单并集不同。
- 英文和数字经过真实模型，未匹配分类保留完整输入，部分消费后的 Reset 清理旧结果。
- 无匹配类别仍返回原身份，Current 的分数输出可省略。

原 pinyin_qwerty 设置的 field 3 实际只有 default fuzzy ID，依赖未恢复的 InMemory 后端。本轮只核对其原字节解析，再显式选取四个 DirectMapping ID，不宣称应用默认配置已通过宿主运行。

新增身份排序模块核对有符号附加字段、无符号完整 ID、身份 bit 及同身份不同文本。共享缓存的模型类型已改变，因此同一次构建另跑既有字典 Manager 消费流程，查询、共享计数器及无扩展键消费通过。旧独立数学、metadata 和 schema 用例未重跑。

日志为 `work/native-rewrite/forward-token-build/expander-manager-build.log`。成功 Ghidra 导出位于 `expander-manager-readable/` 和 `expander-setting-readable/`。Reset 返回指令另存 `work/native-rewrite/expander-manager-reset-return.txt`，中央仍为 524 段，没有重复比较旧 FDE。

同身份碰撞的两种分数处理、接受但无结果及跨源项临时字段延续均按原静态路径恢复。四份现有资源未触发这些分支，本轮没有构造替身后端补覆盖。InMemory、原重配置、OOM、原 ARM 动态等价和 Android 仍未验收。

下一步核对 token Manager 的补文本入口，再接 `0x18d07c` 收集及实际消费。类别缓存生命周期和完整扩展键组合仍未完成。

## 早期静态验证

复用已有真实 APK 导出测试，不新增第二个同能力端到端测试。新增断言覆盖：

- 有符号附加标识、无符号 token ID 和单 bit 标志的比较指令
- `[1, 2]` 的原始只读字节与 RTTI 关系
- 三个独立单类别请求的参数和保存位置
- 五个直接管理器请求点
- 立即数调用、向前尾调用和向后尾调用

测试命令：

```text
PYTHONPATH=tools/python python -m unittest discover \
  -s research/native-rewrite/tests -p test_direct_mapping_native.py -v
```

新增调用扫描只导出证据，不把函数名猜测、类别链合成或运行时可达性当成分析结果。完整输出仍位于被忽略的 `work/`，本轮没有改变 APK、离线 lookup 模型或输入法功能。

## 后续边界

后续进展见 [JNI 与 C++ 边界](native-abi-map.md)：三类别请求已连接到词典访问器刷新，fuzzy 客户端已连接到手势 `TermExpander`，decoder 配置已连接到引擎刷新。以下缺口继续保留：

- 三类别辅助对象原名与缓存的完整消费路径
- 手势扩展器在各模式中的实际准入条件
- `TokenDecoderBase` 配置入口与完整 engine 初始化、模式选择的连接
- 三元组中标志位与附加标识的原始业务名称
- 管理器输出到 composing 和最终候选的连接

统一下一步安排见 [native 查找研究](direct-mapping-native.md#验证与限制)。
