# 词典编辑器与文件头源码

## 已恢复的范围

本轮接通 `UserDictionary`、mutable dictionary 和底层 trie 编辑器之间的静态路径，并恢复独立的十六字节文件头组件：

- `research/native-rewrite/recovered/dictionary_header.h`
- `research/native-rewrite/recovered/dictionary_header.cc`
- `research/native-rewrite/recovered/dictionary_checksum.h` 和 `dictionary_checksum.cc`
- `research/native-rewrite/tests/dictionary_header_test.cc`

文件头和已有 payload 共用 `little_endian.h` 的整数读写实现。该组件不依赖原 APK、旧执行库或反编译工具，不包含 protobuf 元数据、trie 数据、文件替换或完整编辑器实现。关联引用、记录字段更新与索引池的后续连接见 [关联表引用与记录源码](association-records.md)。底层 trie 的四字节值引用和定长记录更新已有独立源码，见 [trie 值记录](trie-values.md)。

## 编辑器的具体归属

已连通的构建分支为：

1. `0x1a6a2c` 的 `MutableDictionaryBuilder` 分别建立两侧 trie、辅助存储和字节记录池。
2. `0x1c5de8` 把 `MutableDictionary` 的 primary 虚表安装到读取对象。
3. 读取对象的 slot 19，即 `0x1c5c84`，取得两侧底层编辑器与遍历器，再经 `0x1c5a00` 建立 `MutableDictionary::EditorImpl`。
4. `UserDictionary` 将读取对象存入 `+0x48`，编辑器存入 `+0x50`，供此前的学习增量路径使用。

这份静态连接不等于证明某次运行的 handle 必然选择该分支。

| EditorImpl 槽 | 入口 | 已确认的行为 |
| --- | --- | --- |
| slot 0 | `0x1c5f08` | 通过长度与键准入检查后，以模式 `1` 进入共用修改函数 |
| slot 2 | `0x1c5fe8` | 以模式 `2` 进入同一修改函数 |
| slot 5 | `0x1c52ac` | 查找两侧关联，修改关联列表并处理空端点 |

slot 0 在这里是编辑操作，不能套用其他接口中首两个槽为析构函数的布局。

`0x1c4494` 先查已有键。只有模式 `1` 才允许进入缺失键的建立路径。`0x1c5660` 先尝试修改已有双向关联；需要新关联时，同样要求模式 `1`，并更新两侧记录。模式 `2` 不进入这条新关联路径。

因此，上层补写通道允许更新或建立关联，已有项更新通道只处理已有关系。补写仍不能命名为无条件插入。

新增关联成功后，mutable dictionary 的 `+0x34` 字段加一，并设置状态位。这个字段与 `UserDictionary +0x38` 的计数累计字段属于不同对象，不混为词条条数或同一个 API 的统计结果。

失败路径包含针对空端点的清理。关联池回收与单侧列表编辑已有源码，完整双向写回、失败恢复与原子性仍未验收，不把这些视图直接作为可执行编辑器源码。SingleTrie 分支也有模式 `1`、`2`，但同键和异键处理不同，不能用两侧 trie 的结构代替它。

## 文件头格式

`0x1a2228` 的当前 writer 固定写入 major `3`、minor `1`。文件头的小端布局为：

| 偏移 | 长度 | 内容 |
| --- | --- | --- |
| 0 | 8 | CRC 状态的低 32 位零扩展为 64 位 |
| 8 | 4 | major |
| 12 | 4 | minor |

校验只覆盖版本的八个字节，不覆盖整库正文。读取路径接受 major `0`～`3`，minor 保留原值。major 小于 `2` 选择 V10 payload，其他受支持值选择 V21。

当前文件头的固定字节为：

```text
96 a4 cb a7 00 00 00 00 03 00 00 00 01 00 00 00
```

## CRC 来源与实现

原 writer 调用 `Default(32, 0)`。固定库中 degree 32 的配置位于 `0x34ec50`，低多项式为 `0xb9e50c1d`，高半部为零。

构造器把多项式保存在对象 `+0x28`、`+0x30`，Empty 方法从这两个字段取得初始状态。CRC32 的第一组表以该反射多项式生成，短输入按字节扩展，末尾没有额外 XOR。不能替换成标准库默认 CRC32 的多项式和初值。

文件头与关联键现在共用 `CalculateDictionaryChecksum`，用逐位多项式运算代替原表查找。它仅覆盖词典实际使用的 16、32 位配置，不恢复通用 CRC、长块加速、滚动窗口或旧对象 ABI。

原键创建入口 `0x1c4494` 在 `0x1c4564` 选择 `Default(16, 0)`。配置地址由 `0x34e950 + 16 × 24` 得到 `0x34ead0`，低多项式为 `0x9f18`，高半部为零。它与文件头共用 Empty、32 位表实现及无末尾 XOR 的规则。`0x1c45b4` 读取扩展后的状态，`0x1c45c0` 将低十六位写入值补丁参数，初始局部变量的零不代表固定零校验。

四组合法头部 fixture 使用独立 GF(2) 多项式长除法推导。新增键 fixture 使用 normal 多项式 `0x118f9`，输入与输出按位反转，先完成长除法再保存字面期望。空键校验为 `0x9f18`，`nihao` 为 `0x66b0`。二进制、UTF-8 和 32 字节输入也有独立期望，测试不调用被测算法计算答案。

## 后续字节流

当前 writer 在文件头后依次写入：

1. protobuf 元数据，带 32 位长度前缀，并按八字节边界补齐。
2. mutable dictionary 序列化数据，再补齐到八字节边界。

这里只确认字节流的拼接。真实文件的替换、落盘、同步、合并和中断恢复仍未连接，文件头组件不代替整个容器解析器。

## 验证与证据

使用既有 WSL 编译器，以 `-std=c++17 -O2 -Wall -Wextra -Werror` 构建：

```bash
mkdir -p work/native-rewrite/recovered-header
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/payload_codec.cc \
  research/native-rewrite/recovered/dictionary_header.cc \
  research/native-rewrite/recovered/dictionary_checksum.cc \
  research/native-rewrite/tests/dictionary_header_test.cc \
  -o work/native-rewrite/recovered-header/dictionary_header_test
work/native-rewrite/recovered-header/dictionary_header_test
```

实际构建、四种受支持 major 的头部读取、payload 布局选择和当前头部写出均通过。校验失败保留先前输出的协议断言通过。因字节读写提取为共用实现，已有 payload 模块也完成源码重建回归。

既有真实 APK 取证测试新增编辑模式、当前版本和 CRC 配置锚点后通过，该轮导出器共 81 个区域。十七个新区域中十六个与发布库的指令字节一致。CRC 缓存工厂只有两处 ADRP 页地址随既有 `.bss` 移动，其余指令及配置字节一致。

2026-10-20 的严格 WSL 构建通过。既有四组头部、CRC32 写出和六组 CRC16 字面输入均通过。真实 APK 出口新增 degree 16 配置断言后通过，仍导出 186 个区域。配置的 24 字节也与保留的 `v2.1.7` 发布库一致，既有函数指令对照继续沿用。这些结果不代表原 ARM64 CRC 已执行。

主要证据：

- `work/native-rewrite/original-apk/native-editor-header.txt`
- `work/native-rewrite/original-apk/header-fixture-derivation.json`
- `work/native-rewrite/restart-v217/native-editor-header-comparison.json`
- `work/native-rewrite/ghidra/trie-editor-routing/` 与 `trie-editor-core/`
- `work/native-rewrite/ghidra/dictionary-header-crc/`、`header-crc-initialization/`、`header-crc-table/` 和 `header-crc-window/`

没有执行原 ARM64 CRC 或编辑器，没有操作设备和用户词典。静态连接及宿主模块结果不扩展为完整持久化等价结论，权利边界仍按 NOTICE 保留。
