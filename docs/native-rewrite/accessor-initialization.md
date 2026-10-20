# Android accessor 创建与模型发布

本阶段定位原 Java 创建入口、JNI、native 构造与就绪发布，不新增 Android accessor、锁或初始化替身。

## 创建链路

```text
AbstractHmmEngineFactory.createMutableDictionaryAccessor(type)
  → accessorId、文件名
  → EngineFactory.createMutableDictionaryAccessor(engineId, "", dataId)
  → nativeCreateMutableDictionaryAccessor 0x10f12c
  → HmmEngineFactory slot 3，0x138010
  → Impl::CreateDictionaryAccessor 0x137fb4
  → 分配 0x118 字节，构造 0x18bf2c
  → 初始化 0x18be20
```

JNI 只检查 native 工厂及三个 Java 字符串是否为 null。空 userId 是原 Java 明确传入的有效参数，不能新增非空字符串限制。

三个参数在 Java 日志中分别称为 engineId、userId 和 dataId。dataId 在 accessor 内保存到 `+0x38`，后续经 DataManager 查询。缓存与发布属性见 [后续取证](accessor-resource-property.md)，实际文件来源仍待追踪。

Impl 返回分配的 accessor 地址。构造期间模型不可用也不等于没有分配对象，因此非零 native 地址不能代替就绪判定。

## 原构造与刷新条件

带 dataId 的构造在开始设置 `+0x10`、`+0x11`、`+0x12` 为零，建立依赖后调用初始化。另一个无 dataId 构造 `0x18c050` 将 `+0x11` 置一，不能把两个分支合并。

`0x18bde8` 按原字段选择：

- `+0x11 == 0`：当前句柄为空，或句柄 `+0xc` 的原标记等于 `1` 时，调用 `0x18bd50`。
- `+0x11 != 0`：只在当前句柄为空时进入 `0x18ba0c`，该分支尚未恢复。

这里只保留标记数值，不猜其业务枚举含义。

## 重载不保留旧 accessor 句柄

`0x18bd50` 的顺序已经由 ARM64 核对：

1. `0x18bd74` 先将 accessor `+0xe0` 清零。
2. `0x18bd7c` 释放原句柄，再向工厂 slot `9` 查询 dataId。
3. 候选句柄可取到模型时，`0x18bdb8` 才装入新句柄，并调用 `0x18bbcc`。
4. 候选不可用则不装入，释放候选，原句柄没有恢复。

后续 DataManager 取证确认，候选可能来自缓存。创建器失败处理与缓存失效尚未展开，不能将上述顺序简化为「磁盘读取失败必然丢弃模型」。

[宿主文件加载](mapped-dictionary-load.md) 失败时保留调用方模型，是局部解析入口的契约。它不代表原 accessor 重载会保留旧句柄，后续组合时须区分这两层。

## 就绪与附属对象

`0x18be20` 先调用 `0x19c520`，再确保存储句柄，并刷新 `+0xd8`、`+0xe8` 的依赖。这里不把未展开的同步函数直接命名为互斥锁。

随后仅当 `+0xd8` 非空、且 `0x189910(+0xe0)` 得到模型指针时，将 `+0x10` 就绪字节置为真。原 getter 对空句柄返回空，否则返回句柄首字段。

未就绪时，清除并销毁 `+0xf0` 附属对象。就绪且已有附属对象时调用 `0x18caa0` 重新绑定，否则调用 `0x18cbac` 创建。其完整类型和后置配置仍待恢复。

## 验证与证据范围

十个新增 native 区间与保留 `v2.1.7` 发布库逐字节一致。真实 APK 导出入口新增七段，并通过十个新加载、释放与发布指令锚点，中央清单为 `281` 区域。

- `work/native-rewrite/ghidra/accessor-file-create-jni/`
- `work/native-rewrite/ghidra/accessor-file-create-factory/`
- `work/native-rewrite/ghidra/accessor-file-create-impl/`
- `work/native-rewrite/ghidra/accessor-file-initialize/`
- `work/native-rewrite/ghidra/accessor-file-publish/`
- `work/native-rewrite/ghidra/accessor-file-load-owner/`
- `work/native-rewrite/restart-v217/native-accessor-initialization-comparison.json`
- `work/native-rewrite/restart-v217/accessor-initialization-export.json`

Java 依据原版 DEX 反汇编，未完成发布版新增工厂方法的逐方法交叉核对，不扩大 native 字节一致结论。

本阶段未修改运行实现，未重跑旧 C++ 或完整静态门禁，未执行原 ARM64、访问设备或用户词典。后续已展开资源入口与发布属性，详情及新增可编译部分见 [模型缓存与词典属性](accessor-resource-property.md)。
