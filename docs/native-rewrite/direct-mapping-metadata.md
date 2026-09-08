# TokenExpander metadata 与管理器

## 范围与证据

本轮将 DirectMapping 前置消息的字段号、对象偏移、输入匹配条件和管理器调用路径连接起来。证据仍来自固定原始 APK 的 ARM64 ELF，不涉及设备用户数据或正式输入法实现。

复用 `research/native-rewrite/tools/disassemble_direct_mapping.py`，新增 metadata 序列化、解析、默认值与管理器指令区间。工具现在导出 24 个有界区间，字符串锚点与分组 relocation 分别位于 `string_anchors` 和 `relocation_regions`。

地址均为 ELF 虚拟地址，函数职责名是研究标签，不是原始 C++ 符号。复现命令见 [native 查找研究](direct-mapping-native.md)。完整反汇编输出继续保存在 `work/`，不提交。

## 前置消息类型已确认

native 的类型名函数 `0x19f6c0` 引用 `0x32c89d` 的字符串：

```text
i18n_input.engine.hmm.proto.TokenExpanderMetaData
```

消息序列化函数 `0x19f518` 将四个字段写出，解析函数 `0x19fa00` 根据 wire tag `8`、`16`、`24`、`32` 写入相同字段。构造路径从 `0x19f7a8` 起将四个字段默认值清零。

DirectMapping 把消息对象嵌入自身 `+0x10`，因此可以把消息偏移与迭代器实际访问的 expander 偏移对应起来：

| field | 消息内偏移 | expander 内偏移 | 类型与默认值 | 已确认职责 |
| ---: | --- | --- | --- | --- |
| 1 | `+0x18` | `+0x28` | enum，默认 `0` | 扩展类别，管理器据此分组 |
| 2 | `+0x1c` | `+0x2c` | 32-bit 整数，默认 `0` | 匹配输入 token 的 bits 28–30，`-1` 为通配 |
| 3 | `+0x20` | `+0x30` | 32-bit 整数，默认 `0` | 匹配输入附加短整型标识，并写入输出标识 |
| 4 | `+0x24` | `+0x34` | bool，默认 `false` | 查找未命中后是否提供原输入回退项 |

field 1 的 enum validator `0x19f79c` 接受数值 `0`–`4`。原始枚举符号名未恢复，不能把研究标签当成原始 proto 定义。

field 3 的原始名称及其是否表示语言、编码域或其他分类仍未知。这里采用「附加短整型标识」这一职责描述，不因拼音使用 `16`、数字使用 `300` 就擅自命名为语言 ID。

## 当前数据的字段取值

| DirectMapping blob | field 1 | field 2 | field 3 | field 4 |
| --- | ---: | ---: | ---: | --- |
| 英文，两份相同 blob | 3 | 0 | 0 | true |
| 数字 | 3 | 0 | 300 | true |
| 拼音 | 3 | 0 | 16 | true |

结合其他 expansion blob 的同形前置字段，当前数据中的类别数值与角色对应为：

- `1`：initial expansion
- `2`：默认和可选 fuzzy expansion
- `3`：reconversion expansion
- `4`：reverse-initial expansion

这些是当前样本的数值与角色关联。`0` 虽然可通过消息 enum 解析，但管理器注册路径会跳过该类别并记录诊断，不把它作为有效扩展组。

## 输入匹配与回退

`iterator_reset` 的匹配发生在低 21 位 key 查找之前：

```text
input_kind = (input_token_id >> 28) & 7
kind_matches = (input_kind == field2) or (field2 == -1)

input_aux = signed16(input_token.aux)
aux_matches = (input_aux == field3) or (input_aux == 26) or (field3 == 26)
```

高位提取指令位于 `0x19d114`。附加标识通过 `ldrsh` 读取，匹配条件位于 `0x19d130`–`0x19d158`。`26` 在这条匹配路径中充当通配值，不由此推广成整个 HMM 的通用常量。

DirectMapping 的行为分为三条路径：

| 条件 | reset 结果 | 迭代器结果 |
| --- | --- | --- |
| 任一输入匹配条件失败 | false | 不建立本次有效查找，调用方必须处理拒绝 |
| 匹配成功且 lookup 命中 | true | 枚举直接或间接目标 |
| 匹配成功但 lookup 未命中 | true | field 4 为 true 时返回原输入一次，否则为空 |

field 3 不仅用于输入匹配。正常目标读取在 `0x19cd68`–`0x19cd6c` 把它写入输出 token 的短整型字段。回退项则复制原输入，不能混为「所有输出都强制改写该标识」。

离线枚举工具目前只解释中间的 lookup 路径。它既没有完整输入 token 对象，也没有模拟上述匹配和回退，所以枚举到 source 不等于任何输入状态下都能产生同样结果。

## TokenExpanderManager 的连接证据

管理器及其迭代器的 RTTI 名称位于 `0x34a9b0` 和 `0x34a9e0`。对应 typeinfo 名称指针 relocation 位于 `0x68af30` 和 `0x68af48`。迭代器虚表的 RTTI slot `0x67a488` 指向 `0x68af40`，reset slot `0x67a490` 指向 `0x196af0`。

这一链路证明下列函数属于管理器路径，而不是仅凭邻近地址猜测：

| 研究标签 | 区间，末端不包含 | 职责 |
| --- | --- | --- |
| manager_register | `0x196d30`–`0x196ff0` | 取得 expander，按类别分组 |
| manager_create_iterator | `0x197348`–`0x1974a4` | 按请求的类别列表收集子迭代器 |
| manager_reset | `0x196af0`–`0x196bec` | 以原输入和零分初始化，依次应用子迭代器 |
| manager_apply_iterator | `0x196874`–`0x196af0` | 处理拒绝、替换、分数累加与重复结果 |

注册函数在 `0x196e4c` 调用 expander 虚表 slot `+0x38`。DirectMapping 的该 slot 对应 `0x19c9c4`，返回 `expander +0x28`，因此 field 1 的分组职责有直接调用证据。

管理器收到的类别请求顺序、哪个 engine 阶段请求类别 `3`，以及它与 Java composing 入口的完整连接仍未恢复。

## 管理器不是简单并集

`manager_reset` 先放入原输入，初始分数为零，再依收到的子迭代器列表顺序调用 `manager_apply_iterator`。

apply 函数先把当前结果容器移到临时集合，并清空当前集合，然后逐项处理：

1. 子迭代器 reset 返回 false 时，保留原项及已有分数
2. reset 返回 true 时，改用子迭代器枚举出的结果
3. 新结果分数为已有分数加本轮 expansion 分数
4. 新扩展目标插入时若被容器判定重复，保留较大的分数

分数相加的 `fadd s8, s0, s8` 位于 `0x196a2c`。重复插入路径在 `0x196a78`–`0x196acc` 比较已有分数，并在新分数较大时覆盖。

这里确认的是新扩展目标的重复处理。拒绝输入后保留原项的分支只看到插入和重复项释放，没有相同的分数更新代码，因此不能把前述行为推广为任何插入路径都执行全局取最大值。

比较器究竟用哪些 token 字段判定重复仍未知，不能把它直接描述为「按文本去重」或「只按 token ID 去重」。

这也解释了拒绝与接受但无目标的区别：拒绝时由管理器保留原项，而接受但迭代器为空时，该项不会因管理器自动保留而继续传递。后者是否需要原输入，取决于扩展器自己的回退配置。

整个过程是前一轮结果进入后一轮的顺序变换，不是把所有 expansion 各自作用于最初输入后求并集。这一差异会影响多组模糊音组合和累积分数，但具体用户输入行为还需要追踪实际类别请求及独立执行验证。

## 验证与限制

沿用一个真实 APK 证据导出测试，增加字段序列化与解析位置、输入匹配、管理器 RTTI/虚表、分数相加和重复覆盖指令断言：

```text
PYTHONPATH=tools/python python -m unittest discover \
  -s research/native-rewrite/tests -p test_direct_mapping_native.py -v
```

测试核对固定原始指令，不执行 native 代码，也不把复现出的控制流当成真机行为验收。本轮没有扩大离线模型范围，没有修改 APK、用户词典或正式输入法功能。

后续应优先恢复管理器比较器和类别请求调用方。只有补齐这些路径，才能讨论多扩展组合后的可见结果和最终排序。统一进度入口见 [native 查找研究](direct-mapping-native.md#验证与限制)。
