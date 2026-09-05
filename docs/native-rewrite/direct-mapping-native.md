# DirectMapping native 查找语义

## 证据范围

本轮将 [DirectMapping 字节布局](direct-mapping-layout.md) 与固定原始 APK 的 ARM64 指令交叉验证。地址均为 `libhmm_gesture_hwr_zh.so` 的 ELF 虚拟地址，不是运行时地址。函数名是研究标签，不是恢复出的原始 C++ 符号。

新增依赖 `capstone==5.0.6`，版本统一记录在 `research/native-rewrite/requirements.txt`，安装到项目本地 `tools/python/`。

可复现工具直接读取原始 APK，不依赖临时解压库：

```text
PYTHONPATH=tools/python python research/native-rewrite/tools/disassemble_direct_mapping.py \
  --apk original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk \
  --output work/native-rewrite/direct-mapping-native.json
```

输出包含库 SHA-256、五个有界指令区间、区间 SHA-256 和 reader 诊断字符串。工具检查固定地址的字符串锚点，不将这些地址作为其他 APK 版本的通用常量。

## 函数与证据链

| 研究标签 | 区间，末端不包含 | 证据 |
| --- | --- | --- |
| resolve_indirection | `0x19cbf8`–`0x19cc2c` | 检查 target 最高位，读取数量或返回单目标 |
| read_target_and_score | `0x19cc2c`–`0x19cc5c` | 按相同位置读取 target word 与 byte |
| iterator_current | `0x19cc8c`–`0x19cd88` | 调用上述读取函数，查 float 表并取负值 |
| lookup_range | `0x19cfac`–`0x19d0f0` | 两张位压缩表的二分查找与区间计算 |
| read_container | `0x19d1cc`–`0x19d484` | 各读取阶段与五条错误文案相连 |

对象中的 key 表和 position 表指针分别位于 `+0x38` 与 `+0x40`。target 数据指针位于 `+0x50`，byte 数据指针位于 `+0x60`。这些偏移仅描述当前 ARM64 实现，不是未来产品接口。

reader 的两张索引表均调用 `0x133e44`，target 与 byte 数组均调用 `0x1f6030`。相应失败分支分别引用 `0x32c3cb`、`0x32c40a`、`0x32c450` 和 `0x32c48d` 的诊断字符串，建立了表的用途与代码路径之间的联系。

## 区间查找已确认

`0x19cfe0` 首先执行：

```text
and w19, w1, #0x1fffff
```

因此查找输入使用低 21 位，不是整个 32-bit token 值。随后 `0x19cff4`–`0x19d020` 对 key 表进行 lower_bound 查找。

在对象已加载的前提下，控制流可概括为以下研究伪代码。`K` 为 key 表，`P` 为 position 表，`u32` 表示 ARM64 W 寄存器的 32-bit 截断：

```text
q = input & 0x1fffff
j = lower_bound(K, q)
if j == len(K):
    return not_found
if q == K[j]:
    position = P[j]
else:
    if j == 0:
        return not_found
    position = u32(P[j - 1] + q - K[j - 1])
    if position >= P[j]:
        return not_found
resolve_indirection(position)
```

关键算术位于 `0x19d050`–`0x19d088`：先加前一项 position，再减前一项 key，最后与当前 position 作无符号比较。精确命中 anchor 时则直接取当前 position。

这解释了少量 anchor 如何覆盖多个输入值，也解释了区间之间的空洞：

- 数字 `[48, 57] / [0, 9]` 覆盖 `0`–`9`
- 英文 `[65, 97, 122] / [0, 26, 51]` 覆盖 `A`–`Z` 与 `a`–`z`
- 英文两段之间的符号区间会因算得的位置不小于下一项 position 而返回未找到

以上字符范围结论来自已解析索引与上述函数控制流的组合，不是设备运行样本。原生迭代器还有输入类型检查和未找到时的回退路径，因此不能把底层查找未找到直接等同于用户看不到候选。

## 最高位标记与 byte 的双重用途

`0x19cbf8` 的参数包含当前位置与输出数量。它先从 target 数组读取该位置的 32-bit word，然后执行：

```text
0x19cc04  tbz  w3, #31, direct
0x19cc0c  and  x3, x3, #0x7fffffff
0x19cc10  ldrb w0, [x0, x4]
0x19cc14  str  w0, [x2]
0x19cc18  str  x3, [x1]
```

因此此前的间接索引假设得到函数级支持：

- 最高位未设置：当前位置不变，目标数量为 `1`
- 最高位设置：低 31 位替换当前位置，原位置的 byte 作为目标数量输出

同一 byte 数组并非处处表示分数。在间接入口处，它表示数量。读取目标元素时，`0x19cc2c` 才把对应 byte 作为 score code 返回。

这也说明，仅清除最高位然后把结果当成普通 token ID 是错误的。它实际是另一个数组位置，需要和数量一起处理。本轮没有将完整迭代推进函数纳入证据，因此目标枚举全过程仍需后续验证，不能宣称 reconversion 已完整复现。

## Score 不是直接浮点值

`iterator_current` 在 `0x19cd24` 调用 target/byte 读取函数，随后使用 score code 索引 float 查找表：

```text
0x19cd40  ldr  w2, [x1, #4]
0x19cd44  cmp  w0, w2
0x19cd48  b.hi fallback_zero
0x19cd4c  ldr  x1, [x1, #0x18]
0x19cd50  ldr  s0, [x1, w0, uxtw #2]
0x19cd54  fneg s0, s0
```

已确认的是「byte code → float 表 → 取负值」。float 表的构造方式、数值与配置来源仍未知，不能根据 byte 大小直接换算概率，也不能把间接入口处的数量 byte 混入分数统计。

## Metadata 位于前置读取阶段

在 reader 中：

- `0x19d260` 调用前置消息读取函数 `0x1f6158`
- `0x19d274` 调用消息解析函数 `0x2ca6c0`
- 两步失败都跳到 `0x19d42c`
- 该分支引用的正是 `0x32c4d0` 的 `meta data table` 文案
- 成功后才开始读取 key、position、target 和 byte 数组

因此五条诊断字符串不代表五张依次排列在 config 后的表。metadata 失败对应前置消息读取或解析阶段，与上轮发现的前置 length-prefixed config 相符。其原始 protobuf 类型名及各 field 的完整业务语义仍待恢复。

## 验证与限制

新增一个真实 APK 入口测试，固定检查独立反汇编时记录的关键指令、分支目标和 metadata 文案锚点：

```text
PYTHONPATH=tools/python python -m unittest discover \
  -s research/native-rewrite/tests -p test_direct_mapping_native.py -v
```

该测试验证证据导出可复现，不是 native 执行或行为等价性测试。本轮没有修改输入法功能、APK 补丁或数据，也没有进行设备验收。

尚未完成：

- 迭代器的推进与终止路径
- float score 查找表的构造和量化参数
- 输入类型过滤、fallback 与上层 reconversion 的组合行为
- 将实际枚举出的 target 与 token dictionary 完整对齐

下一轮应沿迭代器推进函数和 score 表构造函数继续追踪，而不是再次猜测已确认的最高位用途。
