# SingleTrie 模型引用与两层同步

已接入真实模型的共享持有、两层读写访问及最后引用释放。实现是模型引用原语，不是完整 Android accessor，也不模拟 DataManager 缓存或就绪字节。

## 原锁的语义与层次

原 `0x2dca68` 的快路径取得 writer 位 `0x08`，`0x2dcb14` 在 reader 位 `0x80` 上累加 `0x100`。对应释放为 `0x2dc374`、`0x2dc3e8`。后者区分最后一个 reader，不能把这些函数当同一把普通互斥锁。

已确认入口组合：

| 原入口 | 外层 accessor 引用锁 `+0x18` | 实际模型数据锁 `+8` |
| --- | --- | --- |
| `0x189924` 保存 | reader | reader |
| `0x1899b4` compact | writer | writer |
| `0x18a68c` 学习计数 | writer | writer |

顺序都是外层锁在先，模型锁在后，返回时反序释放。DataManager `0x1976f8` 还有自己的缓存锁，不属于上述两把锁。这里只恢复表中两种组合，不扩大为所有复制、重载入口的锁矩阵。

`0x19c520` 则不是锁。它以零参数进入 `0x19c360`，遍历资源值项，重取缺失或原标记为一的项，比较字节串后通知依赖。它与真正的 writer/reader 包装分开取证，不再笼统称为同步原语。

## 实际模型引用

[single_trie_model_reference.h](../../research/native-rewrite/recovered/single_trie_model_reference.h) 的 SingleTrieModelReference 直接持有实际 SingleTrieUserDictionaryModel 的 shared_ptr 和引用锁。模型自身持有唯一 data_mutex，因此两个不同引用指向同一模型时，共用同一数据锁。

Read、Write 返回作用域 Access：

1. 先取得对应引用锁，再保留当前实际模型。
2. 模型存在时再取得该模型数据锁；引用为空时保留空访问结果。
3. Access 销毁时先释放数据锁，再解除本次模型持有，最后释放引用锁。

读取使用 shared_lock，写入使用 unique_lock。Access 不复制或移动，C++17 按值返回直接构造，不允许移动赋值提前释放外锁或模型。

模型通过引用共享后，调用方都应通过相应 Access 读写，变更只在 Write 内执行。原独占存储入口仍保留，不与共享访问并发混用。引用对象本身应活到全部 Access 结束。

Bind 只替换已经提供的实际模型，结束该引用上的访问后调用。它不查 dataId，不代表原重载成功；原 accessor 清旧句柄后才请求 DataManager 的次序保持未合并。非空模型也不代替完整 accessor 的引擎依赖和就绪条件。

原 `0x113ec0` 在计数减至零后释放模型及句柄。宿主以 shared_ptr 管理同一持有语义，不复制十六字节句柄布局、标记或原引用计数 ABI。

## 验证

延伸原 SingleTrie 同一实际流程，不另建并发 fake：

- 使用前阶段实际初始化、学习后的模型，初始累计四。两个真实引用各从独立线程执行十六次实际 AddUserDictionaryCount，得到字面累计 36 和 payload 前缀 `24 00 00 80`。
- 两个 reader 各取得访问后再等对方到达，确认读锁可同时持有。两者读取同一字面结果，不以计时或 Mock 调用次数判断通过。
- 清除一个引用和调用方 shared_ptr 后，另一个引用仍能读取模型。最后一个引用释放后，实际 weak_ptr 过期，模型和其编辑资源结束生命周期。

严格编译词典依赖闭包，SingleTrie 原七文件完整流程和上述实际并发访问均通过。未重跑不变的六子模型与属性模块。文件、对象、archive 和二进制精确清理，生成源码和 build.log 留存于 `work/native-rewrite/model-reference-build/`。

## native 证据

九段新增取证中七段与原始 APK、保留 v2.1.7 发布库逐字节一致，中央增至 `365` 区域。writer 获取与资源值刷新主体仅有 ADRP 差异，目标在两库 `.bss` 的相对偏移一致；这两段不列入逐字节清单。

- 同步原语：`work/native-rewrite/ghidra/model-reference-locks/`
- 实际引用释放及值刷新：`work/native-rewrite/ghidra/model-reference-lifetime/`，释放入口以 `00213ec0.c` 为准。
- 原学习与 compact 锁序：`work/native-rewrite/ghidra/model-lock-operations/`
- 比较及差异说明：`work/native-rewrite/restart-v217/native-model-reference-locks-comparison.json`
- 中央导出：`work/native-rewrite/restart-v217/model-reference-export.json`

早期导出误传的 ELF 地址 `0x13ec0` 不属于本引用释放入口，未用于结论或登记。原已登记保存、学习、compact 和发布入口直接复用，不重新比较。

## 尚未覆盖

宿主使用 std::shared_mutex 重建读写互斥和持有顺序，不移植原位布局、慢路径、等待队列、公平性或分配实现。未承诺原调度、性能、全部异常与原 ARM64 运行等价。

DataManager 缓存、失效标记、句柄存在但模型为空、完整 accessor 就绪及 Android 创建销毁仍未实现。Bind 不是这些行为的替身。原子引用计数与锁 ABI、虚工厂未就绪及 OOM 边界继续单独保留。

未操作设备、正式包或用户词典。后续已通过本轮实际模型访问接入 [学习键编码与逐键缩放消费](generated-learning-key-consumer.md)，没有为每个业务方法新增转发接口。下一步展开真实 token 管理器转换与扩展结果形成，完整键生成仍未恢复。
