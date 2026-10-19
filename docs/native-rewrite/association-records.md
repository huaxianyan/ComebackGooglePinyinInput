# 关联表引用与记录源码

## 本轮范围

恢复源码位于 `research/native-rewrite/recovered/association_records.h`、`association_records.cc`，模块探针为 `research/native-rewrite/tests/association_records_test.cc`。

组件包含四字节关联表引用的编解码，以及单键、双键关联记录的原位字段写入。它继续共用 `little_endian.h`，没有建立另一套字节序实现。索引池的分配、扩容、回收、完整 trie 值和磁盘存储仍未恢复。

## 引用头与索引池

`0x1c39cc` 从 trie 值的首四个字节读取引用，`0x1c4348` 将两个字段合成为同一个小端整数：

```text
word = (first_index << 9) | (count & 0x1ff)
first_index = word >> 9
count = word & 0x1ff
```

写入保留 23 位索引和 9 位数量，按原指令截取位，不改为饱和。字面样本 `55 ad 68 24` 对应索引 `0x123456`、数量 `0x155`。读取允许后面还有其他 trie 值数据。

`first_index` 进入索引池的元素访问。匹配循环以 `first_index + i` 遍历 `count` 个位置，再由 `0x1c3ac8` 或 `0x1c7f7c`：

1. 调用 `0x1e3fc8`，从索引池取得 32 位记录 ID。
2. 通过记录存储对象虚表 `+0x48` 取得对应记录的字节视图。
3. 读取记录中的键 ID，与请求的键或键对比较。

因此，引用中的索引不是直接指向记录正文的文件字节偏移，也不是记录 ID 本身。

`0x1c5120` 先通过存储对象的 `+0x58` 调用取得记录 ID，再按列表是否为空分派到 `0x1e4dd4` 或 `0x1e4e3c`。前者申请一个位置并写入记录 ID，后者复制旧列表、插入新 ID，再处理容量与分配。这些步骤已有静态视图，但分配块元数据、回收和失败恢复尚未闭合，未把它们编写成半成品池后端。

## 两种记录布局

| 分支 | 前缀 | payload 起点 |
| --- | --- | --- |
| 两侧 trie 的关联记录 | 一个 32 位对端键 ID | 偏移 4 |
| SingleTrie 的关联记录 | 两个 32 位键 ID | 偏移 8 |

字段均为小端。记录布局与 V10／V21 payload 是不同维度，不能按 payload 版本猜测使用哪种记录布局。公共接口通过 `AssociationRecordLayout` 明确选择，两种布局共用一份写入逻辑。

`0x1c3a30`、`0x1c80cc` 都支持可选字段更新：键指针或 payload 对象为空时，保留对应字节。非空 payload 只覆盖传入视图的长度，后面的字节保留。顺序写入不是事务，后段容量不足时，前段已完成的写入仍然存在。

恢复接口使用调用方提供的有效缓冲区及显式容量，不复制旧字符串对象 ABI。容量检查避免无效 cursor 导致越界写入，旧实现的无效指针或越界 cursor 访问不属于兼容契约。正常字段写入和容量不足的逐段失败行为按原路径保留。

trie 值中的引用头可能另接可选的十六位字段与附加数据，它们不等于这里的关联记录 payload。本轮只恢复已闭合的引用头和记录写入，没有省略这些字段后假装恢复完整 trie 值。

## 反编译视图的参数缺口

Ghidra 在 `0x1c3b68` 的调用点漏显示输出参数，并将匹配条件误显示为目标参数等于零。原指令明确通过 `x2` 传入临时键 ID 的地址，随后在 `0x1c3bf8` 将读出的键 ID 与 `w24` 中的目标键比较。它不是只接受零号键。

SingleTrie 的匹配入口 `0x1c7ff4` 先确认记录至少八字节，再比较两个 ID。恢复依据是指令、调用约定与字节布局，不是直接照抄上述 C 视图。

## 验证与留存

使用既有 WSL C++17 工具链：

```bash
mkdir -p work/native-rewrite/recovered-associations
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/association_records.cc \
  research/native-rewrite/recovered/payload_codec.cc \
  research/native-rewrite/tests/association_records_test.cc \
  -o work/native-rewrite/recovered-associations/association_records_test
work/native-rewrite/recovered-associations/association_records_test
```

实际源码构建通过。模块测试使用独立字面引用、单键和双键记录，走已有 payload 编码到关联记录写入的真实组件入口，检查字段更新和原有容量失败语义。测试没有伪造索引池或模拟完整词典。

既有真实 APK 取证入口补入位布局、字段偏移与实际键比较锚点后通过，导出器共 94 个区域。十三个新区域与已发布库的指令字节全部一致。

证据留在：

- `work/native-rewrite/original-apk/native-association-records.txt`
- `work/native-rewrite/restart-v217/native-association-comparison.json`
- `work/native-rewrite/ghidra/association-records/`
- `work/native-rewrite/ghidra/association-pool-addressing/`
- `work/native-rewrite/ghidra/association-readers/`

本轮没有执行原 ARM64 记录操作、读取用户词典、操作设备或验证真实磁盘读写。Google 衍生逻辑的权利边界继续按 NOTICE 保留。

下一步恢复索引池分配块与记录存储的具体类型、容量元数据、回收和失败恢复，再连接键序列、完整 trie 值及文件容器。
