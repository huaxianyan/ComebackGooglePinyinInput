# 学习键编码与逐键增量消费

已恢复生成结果到真实用户词典之间的消费段：拼接键、按 binary32 缩放增量、依次调用既有 AddUserDictionaryCount。它接入已有模型写锁，不代表完整 token 到学习键生成已经恢复。

## 输入边界

GeneratedLearningKey 是原 `0x40` 字节结果的消费投影，只保存本段实际读取的 token 字符串、`+0x30` 缩放系数、`+0x34` 标志和 `+0x38` 类别。它不是原 ABI 布局，也不虚构暂未使用的 token 身份或另一向量。

原生成器还会验证逐项 language ID，调用 token 管理器及扩展器，完成身份匹配、分数处理和键组合。这些依赖尚未恢复，本轮没有添加返回固定键列表的生成器或回调替身。

## 两种 token 拼接顺序

原 `0x194e9c` 接收键记录、accessor `+0xd0` 的字节及输出字符串：

- 字节非零时，`0x194e14` 按 token 原顺序拼接。
- 字节为零时，按 token 倒序拼接，每个字符串内部的字节顺序保持。
- 两种情况都先清空输出，没有分隔符、转义或字符串终止符截断，内嵌零字节保留。

这与 full-match 标志或后端 forward/reverse 方向不同，源码使用 in_token_order 表达实际顺序。

Ghidra 在调用 `0x194e14` 时漏显示第三参数。ARM64 的 x2 仍持有输出地址，x0、x1 指向两个迭代器。实现依寄存器传参恢复，不照抄缺参的伪码。

## binary32 缩放

ScaleLearningCount 对应原 `0x18a68c` 的 `SCVTF → FMUL → FCVTZS`，最后把非正整数变成一：

- int32 先转换成 binary32，再以 binary32 相乘，不改用 double 或四舍五入。
- ARM64 的有符号转换在正溢出时饱和为 `2147483647`，负溢出和 NaN 经最终钳制得到一。
- 可转换范围内按零方向截断。源码避免 C++ 浮点越界转整数的未定义行为，不改变原整数结果。

独立字面用例中，`16777219 × 0.5f` 先把整数舍入为 `16777220`，最终得到 `8388610`。double 路径会得到不同整数，因此它不是可互换的实现。模块还覆盖转入 float 时的正溢出，以及正负无穷和 NaN 的原转换结果。

宿主限定 IEEE binary32、默认的 round-to-nearest/ties-to-even 环境及非 fast-math，不承诺原 FP 异常标志、全部 FPCR 状态或原 ARM64 执行等价。

## 实际逐键写入

ApplyGeneratedLearningKeys 对接 SingleTrie 实际拥有模型，复用既有共享 AddUserDictionaryCount。六子模型的已有计数协调保持不变，本段不新增暂无调用方的实例化。调用方已通过 accessor 的准入检查，传入正增量，并持有引用、模型两层 writer 访问。

循环依次编码每条键，以缩放结果调用既有 AddUserDictionaryCount。flag30 和 category 来自当前结果，flag27 按原调用固定为 false。第一次 false 终止后续键，保留此前写入和底层已有的部分失败，不做回滚。

空结果的循环值为 false，非空且全部处理成功为 true。这只是原循环的结果，不是完整 accessor 返回值。原额外文本路径在循环失败后仍可能执行，原始 token 是否为空也会影响最终返回，本轮没有把它们简化成循环结果。

调用方也不能用本段取代零增量、文本大小或原始就绪字节检查。完整 accessor 中零增量的提前返回仍属于上层。原生成阶段位于引用 writer 锁内、模型数据锁前，本段只接两锁已持有的循环。后续组合完整生成器时须保留这个阶段，不能提前取得模型数据锁执行生成。

## 验证

- 新增一个有字面输入输出的模块测试，验证两种 token 顺序、旧输出替换和内嵌零字节，以及上述 binary32 转换协议。
- 延伸同一 SingleTrie 实际流程，使用字面键记录作为消费段输入，不声称它们来自已恢复的生成器。通过模型真实 Write Access，增量五按 `0.5/0.25/1.5` 得到 `2/1/7`，累计从 36 到 46。
- 实际反序键 cdab、ghef、ji 的 payload 前缀为 `02 00 00 80`、`01 00 00 d0`、`07 00 00 80`，验证标志、类别和已写入权重。
- 下一批先成功学习 kept，再由真实 trie 字母表拒绝零字节键，循环返回 false。累计保留为 47、kept 前缀为 `01 00 00 80`，后续 later 尚未写入。该停止规则来自原失败分支，不使用 Mock 注入。

严格编译词典依赖闭包，模块测试和 SingleTrie 原七文件完整流程通过。收尾移除无调用方的泛化实例化后，只增量编译、链接实际 SingleTrie 签名，循环逻辑不变，不重跑已通过流程。未重跑不变的六子模型。文件、对象、archive 和两个二进制精确清理，生成源码及 build.log、signature-link.log 留存于 `work/native-rewrite/learning-key-build/`。

## 证据与后续

两个新增字符串拼接 FDE 与原始 APK、保留 v2.1.7 库逐字节一致，中央为 `367` 区域。原生成器、缩放和存储消费区间复用旧证据，不重新比较。

- `work/native-rewrite/ghidra/learning-key-consumer/`
- `work/native-rewrite/restart-v217/native-learning-key-consumer-comparison.json`
- `work/native-rewrite/restart-v217/learning-key-consumer-export.json`

完整上游生成、分数到缩放系数的构造、原额外文本键及最终返回选择仍未实现。下一步从实际 token 管理器转换与扩展结果形成入手，复用本轮唯一的消费投影、拼接和缩放实现，不补默认键或默认系数。

未执行原 ARM64，未操作设备、正式包或用户词典。容器分配次数、OOM、并发完整 accessor、JNI 和 Android 调度仍不在本轮验收范围。
