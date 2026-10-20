# 可变词典完整内存镜像

## 范围与所有权

[mutable_dictionary_image.h](../../research/native-rewrite/recovered/mutable_dictionary_image.h) 和 `.cc` 组合此前恢复的元数据、DATrie、值表、索引池及关联记录表，覆盖当前 proto 格式的六子模型容器。

当前后端组合为 `VariableValueLengthTrie(DATrie, FixedPhraseTable)`、`IndexPool` 和 `FixedPhraseTable`。标签来自原类型名函数，不用 RTTI 全名代替磁盘标签。其他 trie、变长值后端及旧 24 字节元数据格式尚未恢复，读取遇到这些标签会返回失败，没有占位后端或静默转换。

`MutableDictionaryStorage` 拥有官方元数据和六个子模型。早期 `DictionaryEditState` 已删除，两个关联编辑入口直接修改同一个 `MutableDictionaryMetaData`。数量按原 32 位加减回绕，生成类型的 setter 同时维护第 5 字段存在性，不保留第二份计数或手工同步的 flags。

trie 与表的已有区域继续使用 `OwnedByteRegion`，容器不引入另一套存储分配器。加载后的 borrowed view 与编辑器必须重新取得。方向暂存仍属于编辑协调器，不写入镜像。

## 字节顺序

原 writer `0x1c6660` 依次保存：

1. 可变词典 proto 元数据的 LE32 长度与八字节对齐段。
2. 正向键 trie。
3. 反向值 trie。
4. 正向关联范围池。
5. 反向关联范围池。
6. 正向关联记录表。
7. 反向关联记录表。

两侧 trie 的具体布局为：

```text
对齐字符串 "VariableValueLengthTrie"
  对齐字符串 "DATrie"
  DA-TRIE / CRC64 / 元数据 / 活动节点
  对齐字符串 "FixedPhraseTable"
  值表的数量 / 宽度 / 活动正文 / padding
```

索引池直接保存 `P-TABLE` 镜像，不在前面添加类名。关联记录表带 `FixedPhraseTable` 字符串，再跟定长表镜像。所有原始子模型边界补齐至八字节，正文格式继续由各组件维护。

命名包络与补零只在容器 codec 的共用 writer 中实现，底层镜像使用已有 API。原 trie 与定长表的虚方法偏移不同，源码不复制两套相同的包络算法。

## 加载与发布

`0x1c71a4` 按同一顺序读取，`0x1c7814` 只有在全部成功后才发布元数据与六个子模型。源码同样先构造局部拥有对象，全部通过后再替换输出。

命名 trie、池与记录表的父级读取还检查对齐后的完整范围。原始定长表组件允许缺末尾 padding，但完整容器的父级边界必须存在。这由 `0x1c6a38`、`0x1c6bd4`、`0x1c6ca8` 和 `0x1df138` 确认，不把底层宽松读取扩大成整个文件的规则。

容器返回本次完整消耗长度，保留父流后续数据。池、trie 与记录切片沿用现有 COW，重新取得可写区域后修改，不让旧 borrowed view 跨加载继续使用。

## 验证

在共用 WSL1 环境使用已安装的官方 protobuf 3.0.0 工具与匹配运行库。六子模型接入时严格编译全部 recovered C++ 源码，并执行三个受影响流程。之后完整镜像与文件保存扩展同一测试入口。可复现完整构建如下：

```bash
out=work/native-rewrite/mutable-container-build
mkdir -p "$out"
protoc -I research/native-rewrite/recovered --cpp_out="$out" \
  research/native-rewrite/recovered/mutable_dictionary_metadata.proto \
  research/native-rewrite/recovered/user_dictionary_metadata.proto
for source in research/native-rewrite/recovered/*.cc "$out"/*.pb.cc; do
  name=$(basename "$source" .cc)
  g++ -std=c++17 -O2 -Wall -Wextra -Werror \
    -I "$out" -I research/native-rewrite/recovered \
    -c "$source" -o "$out/$name.o"
done
ar rcs "$out/recovered.a" "$out"/*.o
scratch=$(mktemp -d "$out/disk-test.XXXXXX")
for name in mutable_dictionary_image dictionary_association_creation dictionary_association_removal; do
  g++ -std=c++17 -O2 -Wall -Wextra -Werror \
    -I "$out" -I research/native-rewrite/recovered \
    "research/native-rewrite/tests/${name}_test.cc" "$out/recovered.a" \
    -lprotobuf-lite -pthread -o "$out/${name}_test"
  "$out/${name}_test" "$scratch"
done
rmdir "$scratch"
```

六子模型接入时三条流程均通过。随后外层镜像沿用同一测试入口，增加的验证见 [完整用户词典镜像](user-dictionary-image.md)。容器流程覆盖：

- 初始化真实六子模型，匹配空容器的 `5504` 字节长度、字面标签与固定偏移。期望位置与字节不调用被测包络或尺寸算法计算。
- 经真实入口新增双向关系，再保存和重载，取得双方列表的实际记录与字面 payload。
- 重载后更新旧关系并新增另一关系，保存第二代镜像，再次读取两条预期 payload。
- 未知 proto 字段与计数存在性保留，COW 修改保持第一代输入镜像原字节。
- 最后一张表缺失一个字节时加载失败，先前完整字典仍可读取。这对应原完整发布边界，不是模拟分配失败。

已有新增与删除流程迁移为官方元数据后通过，仍覆盖九位列表边界、增长搬迁、原生部分失败与暂存复用。旧测试里手填的未定义 flags 不再充当持久化状态。

新增十八段函数与保留 `v2.1.7` 发布库字节一致，真实出口取证现导出 `236` 个区域。材料在：

- `work/native-rewrite/ghidra/mutable-container-{images,layout,read,parser,bounds}/`
- `work/native-rewrite/restart-v217/native-mutable-container-comparison.json`

## 尚未覆盖

本轮未执行原 ARM64，未操作设备或用户词典。官方宿主 protobuf 与真实文件 stream 的部分 I/O、分配故障及全部损坏输入仍不承诺等价。

本容器已接到十六字节文件头与外层 UserDictionary 元数据，见 [完整用户词典内存镜像](user-dictionary-image.md)。写入统一使用共用 sink，实际文件验证见 [原生文件保存](file-persistence.md)。下一步沿调用方恢复文件替换、同步及中断恢复。宿主流程不代表设备上的完整输入引擎验收。
