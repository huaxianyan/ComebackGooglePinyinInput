# 用户词典 payload 编码源码

## 已恢复的范围

已恢复 `UserDictionary` 使用的两种固定值编码，作为独立 C++17 组件：

- `research/native-rewrite/recovered/payload_codec.h`
- `research/native-rewrite/recovered/payload_codec.cc`
- `research/native-rewrite/tests/payload_codec_test.cc`

它只负责六字节值的编码与解码。构建不读取 APK 或原执行库，也不依赖 Ghidra。文件头前缀另见 [词典编辑器与文件头源码](dictionary-storage.md)。protobuf 元数据、键、trie 对象、完整编辑器、文件合并与写盘仍未恢复，不能据此称为完整词典实现。

## 类型与调用归属

既有 RTTI 数据中有 `UserDictionary::PayloadEncoderInterface`，两个实现分别为匿名命名空间中的 `PayloadEncoderV10` 和 `PayloadEncoderV21`。primary 虚表的 slot 3 为编码，slot 4 为解码，两者的 slot 2 均返回值宽度 `6`。

| 实现 | 编码入口 | 解码入口 | 虚表 address point |
| --- | --- | --- | --- |
| V10 | `0x1a09a4` | `0x1a06d8` | `0x67b0e0` |
| V21 | `0x1a0888` | `0x1a05c0` | `0x67b0a0` |

`0x1a259c` 建立新词典时配置六字节值宽度，使用 `VariableValueLengthTrie` 和 `DATrie` 名称创建存储，再把 V21 实例存入对象 `+0x98`。读取对象与编辑器分别存入 `+0x48` 和 `+0x50`，与前一轮学习路径中的接收者对应。

载入函数 `0x1a2b38` 的视图显示，受支持头部的 major 值小于 `2` 时选择 V10，其他受支持值选择 V21。`0x1a3c9c` 接收载入结果，并把编码器安装到同一字段。完整头部校验和解析尚未恢复，本组件不自行按字节猜测格式版本。

## 字节布局

两种值均由小端 32 位字和小端 16 位日期组成。原函数把栈上的整数交给共用 memcpy 读写辅助函数，目标 ELF 为 AArch64 little-endian。恢复源码显式处理字节序，不依赖宿主字节序。

| 字段 | V10 | V21 |
| --- | --- | --- |
| count | bit 0～29 | bit 0～26 |
| flag31 | bit 31 | bit 31 |
| flag30 | bit 30 | bit 30 |
| flag27 | 编码忽略，解码为 false | bit 27 |
| category | 编码忽略，解码由 bit 30 推导 | bit 28～29 |
| day | byte 4～5 | byte 4～5 |

编码时，count 先按无符号值饱和到各自位宽上限。V21 的 category 只取低两位。V10 解码在 bit 30 为一时给出 category `0`，否则给出 `2`。

标志位暂按格式位置命名。它们的全部业务意义尚未闭合，不把 category `2` 擅自命名为删除、屏蔽或系统词。

## API 与读取行为

恢复组件用一个版本参数选择布局，共用元数据结构和编解码实现。它没有恢复原 C++ 对象 ABI 或分配器，编码返回固定数组，解码接收字节视图和输出字段。

原解码器只在日期输出指针非空时读取后两个字节。源码保留这个行为：只读元数据时需要四字节前缀，请求日期时需要六字节。六字节仍是完整 payload 的固定宽度，四字节前缀不代表另一种文件格式。

读取失败时，原指令在元数据赋值前返回。恢复组件同样保留先前输出值。完整字节布局、计数饱和、旧版字段归一化和可选日期均有独立字面 fixture。

## 构建与验证

在已有 WSL 编译环境中，从仓库根目录运行：

```bash
mkdir -p work/native-rewrite/recovered-payload
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/payload_codec.cc \
  research/native-rewrite/tests/payload_codec_test.cc \
  -o work/native-rewrite/recovered-payload/payload_codec_test
work/native-rewrite/recovered-payload/payload_codec_test
```

实际构建和运行通过。四组固定字节独立指定输入与解码结果，没有用被测算法计算期望值。例如 V21 的一组值为 `67 45 23 a9 2b 4a`，对应 count `0x01234567`、category `2`、日期 `0x4a2b`，flag31 与 flag27 为 true。

既有真实 APK 导出测试已补入布局指令锚点，实际入口通过，导出器现有 64 个区间。本轮九个新区域与 `v2.1.7` 发布库的指令字节全部一致。

静态证据与视图留在：

- `work/native-rewrite/original-apk/native-payload-codec.txt`
- `work/native-rewrite/restart-v217/native-payload-comparison.json`
- `work/native-rewrite/ghidra/payload-functions/`
- `work/native-rewrite/ghidra/payload-helpers/`
- `work/native-rewrite/ghidra/payload-selection/`
- `work/native-rewrite/ghidra/payload-load/`

## 剩余边界

本次没有执行原 ARM64 编码器，也没有导入用户词典或验证整库迁移。模块输出来自静态指令推导的固定样本，不能扩展为全部输入的原生执行等价证明。

下一步沿已定位的编辑器恢复关联池、底层 trie、持久化与合并，再连接类别、日期与衰减。Google 派生逻辑仍按 NOTICE 保留权利边界。
