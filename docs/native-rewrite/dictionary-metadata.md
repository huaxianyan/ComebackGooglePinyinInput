# 可变词典元数据

## 范围

[mutable_dictionary_metadata.proto](../../research/native-rewrite/recovered/mutable_dictionary_metadata.proto) 恢复 `i18n_input.engine.hmm.proto.MutableDictionaryMetaData` 的六个字段。使用官方 protoc 生成 C++ protobuf-lite，测试直接调用生成类型，没有手写 protobuf 解析器、影子元数据类或转发接口。

本层不是外层 `UserDictionaryMetaData`。取证工具早期的 `metadata_*` 标签实际属于 `TokenExpanderMetaData`，也不能据此恢复词典 schema。类型身份由 RTTI、虚表和 `GetTypeName` 共同定位。

## 字段与证据

原 `.proto` 字段名称未取得，当前名称是依据调用方的数据流恢复的研究命名。字段编号、类型、默认值与存在性有指令证据。

| 编号 | 研究名称 | 类型 | 原对象偏移 | 依据 |
| --- | --- | --- | --- | --- |
| 1 | `forward_payload_size` | `int32` | `+0x18` | builder 的 `+0xa8`，正向关联记录宽度为此值加四 |
| 2 | `reverse_data_size` | `int32` | `+0x1c` | builder 的 `+0xac`，反向值另加四字节引用及可选校验 |
| 3 | `forward_trie_omitted` | `bool` | `+0x20` | builder 写入正向 trie 指针是否为空 |
| 4 | `key_checksum_enabled` | `bool` | `+0x21` | builder 的 `+0xb0`，控制两字节键校验 |
| 5 | `association_count` | `int32` | `+0x24` | 编辑器的关系数量，外层对象偏移为 `+0x34` |
| 6 | `format_parameter` | `int32` | `+0x28` | builder 的 `+0xb4` 原样复制，上层业务含义尚未确认 |

`0x1d393c` 按编号依次写出已存在的字段，随后追加未知字段原字节。`0x1d3f04` 按对应 wire tag 读取。`0x1d3c0c` 将值清零，存在位由构造器另行清零，因此使用 proto2 optional，未设值与显式零保持区别。

四个整数经 `0x2cb014` 写出。该函数在 varint64 写入前执行 `SXTW`，证明是 `int32`，不能因解析器读取 32 位值就改为 `uint32`。负值使用十字节 varint，未改成 ZigZag。

关系数量对应存在位 `0x10`。既有编辑器对此位的操作是第 5 个 optional 字段的存在性，不应另解释为独立持久化脏位。

第 6 个字段的数值已完整保留，但目前不将它命名为语言、版本或存储类型。负值测试只证明 wire 类型，不宣称该负值可用于实际词典业务。

## 构建与验证

宿主使用现有 WSL1。经维护者授权，在共用 apt 环境安装匹配的 `protobuf-compiler` 与 `libprotobuf-dev`，包版本均为 `3.0.0-9.1ubuntu1`。这是宿主研究基线，不是 Android 产品最终依赖版本。项目不保存工具副本，生成文件留在被忽略的 `work/`。

```bash
out=work/native-rewrite/generated-protobuf
mkdir -p "$out"
protoc -I research/native-rewrite/recovered --cpp_out="$out" \
  research/native-rewrite/recovered/mutable_dictionary_metadata.proto
g++ -std=c++17 -O2 -Wall -Wextra -Werror -I "$out" \
  "$out/mutable_dictionary_metadata.pb.cc" \
  research/native-rewrite/tests/dictionary_metadata_test.cc \
  -lprotobuf-lite -pthread -o "$out/dictionary_metadata_test"
"$out/dictionary_metadata_test"
```

实际生成、严格 C++17 编译和链接通过。一条编辑流程验证：加载独立字面 wire，区分未设置字段与显式零，修改数量，显式写入 false，保存未知字段，再验证负整数的十字节编码。期望字节由冻结的 tag 和 varint 规则直接给出，不调用被测序列化器计算答案。

真实 APK 取证补入字段编号、bool 写入、默认值、符号扩展和虚表绑定后通过，现导出 `208` 个区域。五段新函数与保留 `v2.1.7` 发布库字节一致。证据为：

- `work/native-rewrite/ghidra/metadata-dictionary-schema/`
- `work/native-rewrite/restart-v217/native-mutable-metadata-comparison.json`

未执行原 ARM64 protobuf，未访问设备或用户词典。外层 UserDictionary 元数据、完整容器拼接、文件替换与失败恢复仍未完成。最终运行时、全部损坏输入、分配故障及跨版本 protobuf 等价尚未验收，权利边界继续遵循 `NOTICE`。
