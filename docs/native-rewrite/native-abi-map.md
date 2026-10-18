# JNI、C++ 类型与输入处理边界

## 范围

本记录使用固定原始 APK 和已核对的 `v2.1.7` 发布资产。取证只做静态读取，没有执行目标 native 库或访问设备数据。首轮仅复用既有工具，后续依赖恢复与源码组件状态见 [键生成与分数源码](key-generator-score-math.md)。

本轮新增 DEX 声明与调用点导出、JNI 方法表匹配、C++ RTTI、虚表候选和 DWARF 函数范围工具。它们产出研究证据，不产出完整输入法源码，也不进入最终产品构建。

## Java/native 声明覆盖

直接使用现有 apktool 2.12.1 内的 dexlib2。读取结果如下：

| 输入 | DEX | 方法定义 | native 声明 | 普通 MethodReference 静态 invoke 点 |
| --- | ---: | ---: | ---: | ---: |
| 固定原版 | 1 | 19,104 | 180 | 77,306 |
| `v2.1.7` | 4 | 132,971 | 188 | 461,638 |

这里是调用指令数量，不是去重后的调用图边数。接口调用、反射、动态加载和实际运行分派仍需另外解释。

当前版本保留原版的全部 180 个 native 身份。新增 8 个属于 AndroidX Graphics Path，不是新加的拼音解码接口。不能把当前所有方法定义都算成待手写的业务逻辑，其中还包含第三方依赖和编译器生成代码。

原有 native 类与声明数：

| 类 | 声明数 |
| --- | ---: |
| `hmm.DataManagerImpl` | 12 |
| `hmm.EngineFactory` | 8 |
| `hmm.HmmEngineInterfaceImpl` | 69 |
| `hmm.MutableDictionaryAccessorInterfaceImpl` | 25 |
| `hmm.SettingManagerImpl` | 3 |
| `hmmgesture.HmmGestureDecoder` | 9 |
| `hmmgesture.JniUtil` | 2 |
| `delight4.Decoder` | 26 |
| `delight4.DynamicLm` | 11 |
| `delight4.JniUtil` | 1 |
| `delight4.LanguageIdentifier` | 2 |
| `handwriting.classifiers.WordRecognizerJNI` | 12 |

类名前缀省略部分只为表格阅读，完整 descriptor、prototype、访问标志、调用点和地址在 JSON 证据中。

## 方法表与归属依据

统一核心库中恢复了 163 个重定位方法三元组，以及 17 个匹配 Java 声明的静态 JNI export。独立手写库另有 12 个匹配的静态 export，与统一库的 WordRecognizer 接口重叠。当前全部 native 声明均找到静态绑定证据，但这不证明实际注册和加载成功。

同名、同签名的方法不能只靠字符串认定所属类。例如 `nativeClose(J)V` 同时存在于引擎与词典访问器。工具保留以下不同依据：

- 初始化代码中的字面 class、方法表和数量参数。
- JNI slot 215 调用处的方法表、数量及完整 prototype 集合。
- 类注册描述记录中的方法表、数量及完整 prototype 集合。

HMM 的五条类注册描述记录，文件中的 class 指针为零。所属类通过完整方法集合推断，不伪装成文件中已保存的 class 名称。运行时怎样填充这些指针仍待追踪。JSON 的 `owner_basis` 保留这一差别。

函数地址可能对应多个 C++ export 别名。工具列出全部别名，不把任取的一个符号当成原业务方法名。

原版与当前版的物理方法三元组比较表明：39 个 delight4 表项地址保持不变，124 个 HMM 与手势表项地址增加 `0x2000`。对应函数地址保持不变。此结论是地址对应关系，不是函数执行等价性证明。

## C++ 类型与函数范围

固定原始核心库恢复了：

- 895 条 class RTTI 记录及其基类信息。
- 790 个虚表候选，不称为完整虚表清单。
- 14,263 条 DWARF FDE 函数范围。
- 58,392 条跨函数立即数 `B` / `BL` 引用。

借用既有 WSL 中的 GNU `c++filt` 2.30，895 个类型名均成功解码，包括模板类型。没有新安装 demangler。没有选择 demangler 时，工具明确保留 mangled name，不维护另一套猜测式解码器。

函数引用图只覆盖 FDE 范围内的直接分支。虚调用、函数指针、模型选择和不在这些范围内的代码不在其覆盖范围。虚表和 RTTI 的存在也不证明该类型在当前输入模式下被实例化。

ABI 解释依据为 [Itanium C++ ABI RTTI 布局](https://itanium-cxx-abi.github.io/cxx-abi/abi.html#rtti-layout)。虚基类的 offset 是虚表中的位置，不能当成固定对象偏移。

## 接上旧研究留下的三个入口

以下地址均为固定原始库的 ELF 虚拟地址，不能直接套用当前重排后的数据地址。

### 引擎刷新与默认类别配置

已经连接：

```text
Java HmmEngineInterfaceImpl.nativeRefreshData(J)V
  → JNI 0x10ddf0，取虚表 +0x10
  → HmmEngine 主虚表 slot 2：0x140bc8
  → 0x140cf0 直接调用 0x17522c
  → TokenDecoderBase 的类别配置入口
```

该入口使用旧研究已经确认的 `[1, 2]` 配置。现在能把它连到引擎刷新路径，但不能因此把所有初始化、模式或设置组合都判定为使用同一配置。

### 三个独立单类别请求的上层来源

旧客户端 `0x18caa0` 的两个直接入口分别位于：

- `0x18be20`～`0x18bf2c`，分支点 `0x18bebc`。
- 构造函数 `0x18cbac`～`0x18cbf8`，尾分支点 `0x18cbf4`。

它们仍对应旧研究的三个独立请求，不合并成一次 `[3, 4, 1]` 请求。

已经连接的类型路径包括：

```text
MutableDictionaryAccessor 主虚表 slot 2：0x18c168
  → 0x18be20 → 0x18caa0
MutableDictionaryAccessor 主虚表 slot 27：0x18c19c
  → 0x18be20 → 0x18caa0
```

词典访问器的 JNI `nativeRefreshData` 也取虚表 `+0x10`。因此这些缓存能连接到词典刷新路径。辅助对象本身的原类名仍未确认，不能直接把它命名为 MutableDictionaryAccessor。

DWARF 边界也说明：`0x18bebc` 不属于邻近的虚方法 `0x18bcc0`。不能仅凭地址邻近或虚表附近存在某类，就认定整段代码归该类所有。

### 单独 fuzzy 请求的类型归属

`0x130044` 是 `i18n_input::engine::gesture::TermExpander` 的虚表 slot 2，函数范围为 `0x130044`～`0x130300`。

这把旧 fuzzy 客户端连接到手势扩展器。它不等于普通键入路径中全局启用了模糊拼音，也不能替代逐模式的调用分析。

## Java composing 与候选的消费边界

固定 DEX 中已经连接：

```text
AbstractHmmChineseDecodeProcessor
  → IHmmEngineWrapper
  → HmmEngineWrapper
  → HmmEngineInterface
  → HmmEngineInterfaceImpl / JNI
```

接口 invoke 不能直接当作运行时选中了某个实现。Impl 的接口实现关系和方法体需与这份引用证据一起使用。

`HmmEngineWrapper.update()` 更新 composing 状态，再更新 token 候选和普通候选。普通候选请求受候选开关、composing 状态和非空 Range 约束。成功填充后读取 native 的高亮项。

`HmmEngineCandidateIterator.next()` 按 native 索引读取文字、token 和来源，再经 delegate 生成说明、简繁显示与 reading text，构造 Candidate。composing 渲染则消费 segment、token、input unit 和它们各自的 Range。源码重建不能只返回候选字符串，丢掉这些身份与状态。

词典键生成路径的扩展消费、分数归一化与数学叶源码已有后续进展，见 [键生成与分数源码](key-generator-score-math.md)。仍未连接完整的是：扩展结果怎样经过实际输入搜索、评分和剪枝，最终成为 segment、候选和用户学习更新。不能用 Java 消费层或局部数学源码代替完整算法。

## 复现与证据

工具位于 `research/native-rewrite/tools/`。使用既有 JDK 17 和 apktool JAR：

```text
java -cp work/tools/apktool.jar research/native-rewrite/tools/DexInventory.java <apk> <dex.tsv>
python research/native-rewrite/tools/map_jni_registration.py --apk <apk> --dex-inventory <dex.tsv> --output <jni.json>
python research/native-rewrite/tools/map_cpp_types.py --apk <apk> --output <cpp.json>
```

可选的 `--demangler` 放在最后，后接实际 GNU `c++filt -t` 命令。Windows 调用既有 WSL 时可使用 `--demangler wsl.exe -d Ubuntu --exec c++filt -t`，该参数只启动命令，不注册服务或改配置。

证据保留在 `work/native-rewrite/original-apk/` 和 `work/native-rewrite/restart-v217/`。一个真实 APK 双入口测试通过，覆盖 DEX 导出与 JNI 映射。另外两个模块测试分别确认类型继承偏移、扩展器调用的准确函数范围。它们不是原生输入行为等价性或设备验收。
