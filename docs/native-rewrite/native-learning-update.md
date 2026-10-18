# native 学习增量与存储入口

## 范围与当前基线

本轮接续 [候选提交与学习](candidate-commit-learning.md)，跟踪 `nativeAddCount` 的参数转换、虚调用、键生成、计数缩放和下一级存储分派。

固定原版与实际 `v2.1.7` 发布包的八个新增指令区间已对照。七个区间的反汇编完全相同，键生成区间只有两处 ADRP 改变。两处都读取 `.bss` 中同一相对位置的标志，随 `.bss` 移动 `0x2000`，分支本身不变。

对照保存在 `work/native-rewrite/restart-v217/native-learning-comparison.json`。这证明这些指令路径的对应关系，不代表整个 native 库、运行时标志或学习结果已经等价。

## JNI 到 accessor

原版完整参数入口的 FDE 范围为 `0x111f08–0x112048`：

```text
nativeAddCount(J, String[], int[], String, int, boolean)
  → 转换 token 数组
  → 转换 languageId 数组
  → 转换文本
  → accessor primary vtable +0x70
```

句柄为空或数组转换失败时，返回 false。Java boolean 先按低字节读取，再转换成传给 C++ 的布尔值。另一个旧重载调用 `+0x78`，不与完整参数入口混用。

既有 C++ 类型图中，`MutableDictionaryAccessor` 的 primary slot 14 指向 `0x18a68c`，slot 15 指向 `0x189d94`。后者为 token 数量构建辅助数组，再转回 slot 14，并传入 true。

这里使用静态 RTTI 和 vtable 候选连接虚调用。具体句柄的工厂归属与运行时动态类型仍需分别核对，不把表项匹配当成实际注册或调用成功。

## 增量的前置条件

accessor 的 `0x18a68c–0x18a91c` 保留以下控制流：

1. 读取对象 `+0x10` 的字节，与增量整数的符号位比较。只有前者无符号大于后者才继续，不能先把该字段缩成 boolean。
2. 调用 `0x1896d4` 检查文本长度。上限为零时放行，否则使用 native string 长度严格小于上限的判断。它不是 Java UTF-16 长度检查。
3. 文本检查通过但增量为零时，直接返回检查结果，不进入实际更新。
4. 通过对象 `+0xf0` 的键生成器调用 `0x18e380`，传入 tokens、languageIds、文本与完整匹配标志，取得键记录向量。
5. 通过对象 `+0xe0` 的间接持有结构取得下一级存储对象，遍历键记录。

因此，这个 API 返回 true 本身不能当成「本次一定新增了记录或改变了权重」的证据。

## 一次调用可更新多个键

键记录步长为 `0x40`。本轮只确认被当前消费者读取的字段，不给未恢复的结构强行补完整类定义：

| 相对偏移 | 当前消费者用途 |
| --- | --- |
| `+0x30` | binary32 缩放系数 |
| `+0x34` | 传给下级入口的字节标志 |
| `+0x38` | 传给下级入口的 32 位参数 |

每项先经 `0x194e9c` 生成键字节串，再把键、文本和计数传给 `0x1a1d9c`。增量的实际指令顺序为：

```text
SCVTF：把传入 int32 增量转换为 binary32
FMUL：与记录 +0x30 的系数相乘
FCVTZS：转换为有符号整数
比较和 CSINC：非正数变成 1
```

即使 Java 层传 `1`，native 仍会生成若干键并分别处理。这里保留的是具体浮点与整数转换协议，不能直接改成以 double 计算后四舍五入，也不能把 API 当成简单的负数减权器。

生成键入口还会调用此前确认的 token/language 校验和扩展收集路径。它把学习接到了同一键生成体系，不是把屏幕上的词直接当作唯一存储键。

## 额外路径与返回值

对象 `+0x12` 的标志会启用额外文本键路径。该路径经 `0x189890` 处理文本，再用原始增量调用下一级入口，不走上述逐记录缩放。

函数最后还检查原始 token 向量是否为空。为空时采用额外路径的结果，该路径关闭时为 false。非空时保留生成键循环的结果。不能把返回值改成两条路径简单的 AND 或 OR，也不能据此宣称整个调用具有事务原子性。

`0x1a1d9c–0x1a1e54` 是下一级分派入口：

- 先检查增量为正数，且接收对象 `+0x10` 字节的低位有效。
- 先调用 `0x1a1894`。
- 第一条路径返回 false 时，再调用 `0x1a1bb4`。

后续已细读两条路径及其四个辅助函数，见下节。实际存储对象的动态类型、写盘、合并、衰减和完整溢出策略仍需继续追踪。

## 已有项更新与补写

`0x1a1894–0x1a1a40` 先通过 `0x1a14b8` 查找旧项。查找使用对象 `+0x48` 的虚调用，取得字节表示后，由对象 `+0x98` 的 codec 解出计数、字节标志、16 位字段和类别参数。

查找失败返回 false，供上级进入第二条路径。查找成功时还可能直接返回 true 而不写入：类别条件不满足，或新计数和有效类别都没变化。因此，成功还包含「已有项已处理」的含义。

这条路径对计数和类别的处理为：

- 旧类别小于请求类别时通常保留旧项，只有请求类别为 `1`、旧类别为 `0` 的组合例外。
- 需要累加时，使用 32 位 ADD，再把负结果变为零。类别 `2` 的结果计数只保留零或一。
- 有效类别取请求值与旧值的较小者。
- 确实需要修改时，调用 codec 的 slot 3 生成字节表示，再调用修改对象的 slot 2。

`0x1a1bb4–0x1a1d9c` 是后续补写路径。它同样查询旧项，按类别和计数决定是否保留。相同类别且旧计数已不小于请求时，也会直接成功返回。需要写入时调用相同 codec，但经修改对象的 slot 0 通道处理。

这里已确认「更新已有项」与「补写」的区别。slot 0 的具体 trie 操作、迭代器和失败恢复仍要沿实际实现核对，不把它简化成无条件插入。

## 清零、总量与日期

补写路径还会在条件允许且请求计数为零时进入 `0x1a1a74`。该函数按标志选择重新编码零计数并更新旧项，或使用另一修改槽。两条通道的磁盘效果尚未确认，不能把零计数直接当作文件中的记录已经消失。

成功的非 `2` 类别更新会调用 `0x1a0cbc`：

- 对象 `+0x38` 是本路径使用的 64 位累计字段。
- 加上有符号新计数，再减去有符号旧计数。指令结果为负时存零。
- 对象 `+0x28` 的状态位同时 OR `2`。

这是计数累计与状态标记的直接证据，还未把该字段的 getter 连接到公开统计 API，不以它推断记录条数。

`0x1a0ce0` 经 PLT 调用已匹配的 `time` import，传入 NULL，再做有符号除法，除数为 `86400`。已有项更新路径明确取结果低 16 位后传给 codec。日期编码的其他位宽、回绕与衰减含义仍需解出 codec 后确认。

两条主路径和四个辅助区间与当前发布库的指令字节完全一致。证据在 `work/native-rewrite/restart-v217/native-learning-storage-comparison.json`，时钟 import 匹配在原版目录的 `native-learning-clock-import.json`。

## 复现与验证

本项研究累计新增十四个固定区间，地址定义只维护在 `disassemble_direct_mapping.py` 的 REGIONS。它继续使用 Capstone，不扩展自制指令解码器。

```text
python research/native-rewrite/tools/disassemble_direct_mapping.py --apk original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk --output work/native-rewrite/original-apk/native-evidence.json
```

既有真实 APK 出口测试已加入本轮独立观察到的虚调用、键生成、缩放及存储分支锚点，并通过。本轮验证限于静态导出，不含产品构建或 native 执行对照。细读材料保存在：

```text
work/native-rewrite/original-apk/native-learning-jni.txt
work/native-rewrite/original-apk/native-learning-accessor.txt
work/native-rewrite/original-apk/native-learning-helpers.txt
work/native-rewrite/original-apk/native-learning-storage.txt
work/native-rewrite/original-apk/native-learning-storage-helpers.txt
```

这些局部路径还不足以实现完整持久词典。下一步沿 codec、键序列编码和实际 trie 修改、写盘与合并，继续补齐学习和持久化规格。
