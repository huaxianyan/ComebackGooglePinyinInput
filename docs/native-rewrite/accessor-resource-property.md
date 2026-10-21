# Android 模型缓存与词典属性

本阶段展开 accessor 的资源入口和发布后属性选择。资源缓存只取证，可编译部分恢复 DictionaryPropertyProto 与 ResolveDictionaryProperty，未建立 Android 缓存或同步替身。

## 资源入口实际是 DataManager

原 HmmEngineFactory 构造将 Impl 首地址的虚表设为 DataManager。主地址点为 `0x67a510`，slot 9 指向 `0x1976f8`，slot 10 指向 `0x198f28`。因此 [创建链路](accessor-initialization.md) 中的「工厂 slot 9」可进一步确定为 DataManager 入口。

slot 9 在进入、退出同步包装之间调用 slot 10。后续已确认这是 DataManager 自己的 writer 锁，不与 accessor 引用锁或模型数据锁合并。实际原语取证与宿主持有边界见 [模型引用与两层同步](single-trie-model-reference.md)。

slot 10 按 dataId 查询缓存：

1. 节点已有非空句柄时，加引用并返回该句柄，不重新调用模型创建器。句柄存在不等于其模型指针可用。
2. 缓存缺失时查询配置，配置不存在或其首字段为零时返回空。该字段的业务枚举尚未命名。
3. 使用配置中的创建器名，空名称选择 `GenericDataModelCreator`。创建器接收 DataManager 的次级接口，再按 dataId 和配置创建模型。
4. 创建得到非空模型才装入缓存。新句柄的引用计数先为一、原标记为零，再增加返回引用。失败结果未在此处写入缓存。

所以，accessor 清除旧句柄后再次请求资源，仍可能拿回缓存中的同一模型。不能把这次请求等同于重新打开磁盘文件。[后续注册取证](model-creator-enrollment.md) 已定位 FD、空数据来源及失效标记，legacy 类型表与具体模型初始化仍待恢复。

## 发布后选择 DictionaryPropertyProto

`0x18bbcc` 从模型 slot 20 取得扩展数据。DoubleTrieUserDictionary 与 SingleTrieUserDictionary 共用 `0x1a07f4`，对应外层 UserDictionaryMetaData 的字段 3，即现有研究名 extension_data。

原选择顺序为：

- 模型存在、扩展非空且 protobuf 解析成功，使用存储属性。
- 其他情况调用 `0x18b8ec` 构造引擎回退属性，再完整复制。复制先清除旧状态，不能留下失败解析的部分字段。

引擎回退先构造属性消息，再查参数 `31`。参数存在且转换成功时，设置属性字段 1 并记录存在性。本阶段未恢复参数读取器，接口要求调用方显式提供实际引擎回退，不把消息默认值冒充引擎配置。

## 已恢复的消息与选择函数

`recovered/dictionary_property.proto` 使用 RTTI 确认的原类名和命名空间：

```text
i18n_input.engine.hmm.internal.proto.DictionaryPropertyProto
```

已确认唯一已知字段为 tag `8` 的可选 bool。构造与 Clear 将值设为 true，但不设置存在性；原 IsInitialized 返回真。字段原名与业务含义未知，使用研究名 flag_1，不将它解释为学习、同步或持久化开关。

ResolveDictionaryProperty 读取现有外层元数据，不新增字节容器或状态副本。官方 protobuf 负责解析、存在性和未知字段，选择失败时返回调用方给出的完整回退消息。模型锁与资源刷新仍属于上层生命周期。

## 验证

使用共用 WSL1、官方 protobuf 3.0.0 与严格 C++17 编译，增量更新原 recovered.a：

- 模块测试使用字面 wire 数据，验证存储属性覆盖回退、未知字段保留、空数据与截断数据回退，以及默认 true 的 unset 状态。
- 延伸原完整镜像端到端测试。实际映射文件中的既有无效扩展，选择显式给出的 false 回退。原编辑、保存、覆盖和重映射流程一并通过，夹具字节未改。

两项流程通过后，删除本轮两个探针可执行文件和临时镜像目录，保留可复用生成文件、对象和研究证据。未升级全量构建，未重跑旧 Java 验证。

本轮取证十三个 native 区间：十一段与保留发布库逐字节一致，加入中央清单后为 `292` 区域。另两段仅有 ADRP 页地址差异，目标在两库的 `.bss` 节内偏移一致。这两段没有列入逐字节一致清单。DataManager 虚表绑定也与保留发布库一致。

主要证据：

- `work/native-rewrite/ghidra/accessor-post-publish/`
- `work/native-rewrite/ghidra/accessor-factory-resource/`
- `work/native-rewrite/ghidra/accessor-resource-setting/`
- `work/native-rewrite/ghidra/accessor-resource-cache/`
- `work/native-rewrite/ghidra/accessor-property-wire-complete/`
- `work/native-rewrite/ghidra/accessor-property-array/`
- `work/native-rewrite/restart-v217/native-accessor-resource-property-comparison.json`
- `work/native-rewrite/restart-v217/accessor-resource-property-export.json`

未执行原 ARM64、操作设备或访问用户词典。消息与选择函数的宿主通过，不代表 Android 缓存、线程协调或完整输入法已验收。
