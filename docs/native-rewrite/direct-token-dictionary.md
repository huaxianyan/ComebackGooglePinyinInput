# DirectTokenDictionary 的实际资源与 DFS 查询

本文继续 [ManagerIterator 研究](token-manager-selection.md)。已恢复普通 DirectTokenDictionary 的真实资源加载及 DFS 查询游标，读取原 APK 的字符范围，结果不来自预先准备的候选。

实现位于 `research/native-rewrite/recovered/direct_token_dictionary.h/.cc`。它使用既有 KeyToken、字典资格谓词、区域描述符、UTF-8 单元拆分，以及唯一的 ASCII 字节小写转换，不克隆原虚表 ABI。

## 资源与字符准入

类名前缀由外层移除。payload 前 `16` 字节是四个 LE32 字段，随后是两张 [Flat integer 表](flat-integer-table.md)：第一张存范围起点，第二张存对应长度，并非结束码点。

DFS 使用 selector、language 和第三字段的大小写策略。第四字段不在 DFS 读取，但后续已定位为工厂使用的 IsUsingReversedToken 标志，模型从原 LE32 字段读取，不用推测值覆盖。

`0x1b15dc` 先检查第一起点，再对起点做 lower_bound。精确命中起点直接成功，否则判断与前一起点的差是否小于该条长度。`0x1b1768` 对 source 的每个 Unicode 码点执行此检查。

四份原始资源包含三种不同内容，两份 shortcuts 的字节相同：

- `en_tokens` 接受小写英文字母、单引号与连字符。
- `pinyin_english_token_v_2` 接受小写英文字母。
- `shortcuts_tokens` 使用 selector `4`、language `25`，保留原大小写策略。

`0x2d16c8` 的完整 256 字节表只将 ASCII 大写字母转成小写，其余字节保持原值。它与 `0x1bf63c` 的 UTF-8 码点逆序不是同一能力。后者已有仅覆盖原 interchange-valid 输入的宿主实现，修复路径未移植，见 [查询助手](token-query-branches.md)。

## source、target 与 token ID

两个原生 Push 薄入口分别将第五参数设为零和一，再进入 `0x1b19c0`。资格匹配复用 MatchesTokenDictionary，只有当前没有帧、输入非空且编码成功才发布结果。

source 依第三字段决定是否转换 ASCII 大写，再验证每个码点的范围。target 保留文本并跳过 source 范围检查，但仍执行原 selector 与 language 匹配。

单码点 ID 包含原 selector 左移 `28` 位、码点值和模式位。source 模式位为 `0x00800000`，target 为 `0x01000000`。

多码点使用字典对象内共享的原子计数器，原构造器将其初始化为零。ID 低部按原有的有符号 `counter % 0x110000 + 0xf0000` 计算，保持 ARM 32 位回绕后的有符号解释，不改成每个游标独立计数。

`0x1b1110` 的 Current 从保存的文本复制结果。它按 ID 的 bit 24 决定使用字典语言还是请求语言，并只写入低十六位。原入口不重置 KeyToken 的身份 bit，本实现保留调用方原值，不顺手修正这一行为。

按 ID 回填文本的 `0x1b16c4` 是另一条路径，不等同于 Current 的保存文本复制。后续已由 [真实扩展收集](key-expansion-state.md#真实-manager-补文本与收集) 接入该入口，不建立动态 ID 反向映射。

## 帧与推进

- Push 成功后即可读取结果。
- 原 slot 2 的 `0x1b08ec` 确实固定返回 false，并非宿主占位。它不使成功帧的结果失效。
- 结果推进只标记 Done，当前匹配帧仍在。继续 Push 需要先 Pop 或 Reset。
- Pop 仅在存在帧时清除匹配状态，Reset 无条件清除。保存文本、ID、请求语言和字典计数器不随这两项操作重置。
- 原 slot 6 的 `0x1b0918` 返回 binary32 零。现在通过 Attribute 供真实 Manager 消费，不是宿主占位。

这些方法属于真实 Direct DFS 游标，已直接实现共同宿主接口，并与普通 Forward 接入 Manager 的匹配帧和懒缓存。尤其不能将其固定 false 的帧 Next 当作查询失败，也不能将其多码点编码移植成 Forward 的 target 路径。

## 验证与证据

一个真实入口读取三种原始资源，走源字符、源多字、补充平面目标字符、目标多字以及帧释放后再查询的流程。字面结果覆盖原小写策略、不同字符范围、selector、语言低位、身份 bit 保留，以及跨游标共享动态 ID。

WSL C++17、`-O2 -Wall -Wextra -Werror` 构建和入口通过。测试为 `research/native-rewrite/tests/direct_token_dictionary_test.cc`，日志留在 `work/native-rewrite/flat-integer-table-build/build.log`。

已有提取数据时，可在 WSL 的仓库根复现此入口：

```bash
out=work/native-rewrite/flat-integer-table-build
mkdir -p "$out"
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  -I research/native-rewrite/recovered \
  research/native-rewrite/recovered/{direct_token_dictionary,flat_integer_table,token_query,token_manager_selection,owned_byte_region,file_mmap}.cc \
  research/native-rewrite/tests/direct_token_dictionary_test.cc \
  -o "$out/direct_token_dictionary_test"
"$out/direct_token_dictionary_test" \
  work/native-rewrite/forward-token-data/liben_data_bundle/en_tokens.bin \
  work/native-rewrite/forward-token-data/libpinyin_data_bundle/pinyin_english_token_v_2.bin \
  work/native-rewrite/forward-token-data/libpinyin_data_bundle/shortcuts_tokens.bin
```

资源缺失时使用既有 `extract_data_bundles.py`，输入原始 APK，输出目录为 `work/native-rewrite/forward-token-data/`，manifest 置于同目录。完成后精确清理测试二进制，保留取证与日志。

本轮新增 `40` 段原生指令、五组子字典虚表重定位及字符数据，与原版和保留的 `v2.1.7` 库相同。两处函数尾部浮点常量单独采集，中央共登记 `435` 个区域。已有 `395` 个区域沿用先前证据，本轮只做增量导出，记录在 `work/native-rewrite/restart-v217/native-token-resources-comparison.json`。

Ghidra 输出位于 `work/native-rewrite/ghidra/` 下的 `forward-token-query*`、`forward-token-table-access/`、`direct-token-query*`、`direct-token-codec/`、`direct-token-resource-reader/`、`direct-token-construction/` 和 `direct-token-model-init/`。早期误查的相邻函数只作为研究留存，不计入已恢复能力。

## 验收边界与下一步

当前输入域为完整合法 UTF-8，以及原始普通非空、对应计数一致的范围资源。未恢复 BFS、损坏或空范围的原崩溃与部分发布、计数乘积溢出、原 OOM、日志栈报告、原子操作的完整平台内存序和原 ARM 运行等价。

加载器以普通共享持有表达只读模型快照，不实现原模型就地重配置。普通 Manager 查询已有后续真实入口验证，字典的 selector/language 只读 getter 用于取得工厂资格快照，反向标志 getter 则限制普通已解析资源工厂的输入域。未连接 Android、完整 accessor、上游 Unicode 准备或完整工厂注册，未操作设备、正式包或用户词典。

Forward 已恢复普通资源的真实子遍历、source/target 协调与 token 回填，并与 Direct 一起通过 [Manager 缓存入口](token-manager-selection.md)。普通资源工厂已有后续实现，设置解析、资源 ID accessor 与其他字典仍有缺口，不把这个投影当作完整输入法查询链。
