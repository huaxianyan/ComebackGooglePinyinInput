# 用户词典实体删除与累计

## 原调用路径

```text
0x1a1a74 physical-delete 分支
  0x1a14b8 → MutableDictionary slot 25 → 0x1c4d08
    两侧查键 → 实际关联描述 → 池中首个匹配记录 → 复制 payload
  V21 解码原 count 与 category
  原双向 RemoveDictionaryAssociation
  category != 2 时调用 0x1a0cbc 更新外层累计
```

ReadDictionaryAssociationPayload 复用同一 trie、FindAssociationRecord 和固定表。先确认两侧真实终端，再复制记录的 payload。测试原有的手写关联读取也改用该入口，减少第二份查找流程。

RemoveUserDictionaryAssociation 恢复实体删除分支。只有原双向删除成功后才调整外层累计，保留底层的顺序部分失败，不回滚已完成的表或计数变化。

category 为 `2` 时仍实体删除，但不调整外层累计。这里保留原数值判定，不猜业务含义，也不按剩余词条数重新计算权重总数。

## 累计的单一来源

AdjustUserDictionaryTotalCount 直接更新官方 UserDictionaryMetaData：先以 64 位执行 `total + new - old`，保留 ARM64 回绕，再将有符号负结果置零。即使结果为零也设置字段 presence。

不直接在 C++ signed int64 上做可能溢出的运算，不建立影子计数或手写 protobuf 位。后续学习新增与修改也应复用该累计函数。

## 真实验证

同一完整镜像流程从两关联、外层累计 `151` 的实际加载模型开始：

1. 删除权重 `1` 的原关联，外层变成 `150`，内部关联数变为 `1`。
2. 将剩余真实关联设为字面 category `2` 后删除，内部关联数变为 `0`，外层仍为 `150`。
3. 独立官方消息从未设置状态减去 `150`，得到 `0` 且 presence 已设置。

严格增量编译 association_list.cc、user_dictionary_edit.cc，再执行同一流程，通过。未重复全量构建。

## 边界与证据

这里只实现原实体删除，不包含 keep-deleted/tombstone 分支，不提供假成功替身。调用方须提供同一就绪模型的两个实际编辑器，accessor 锁仍在上层。

两个学习区间已有中央定义，沿用原登记。本阶段新增 payload lookup 的字节证据，和既有取证入口共同索引于 `native-user-entry-remove-comparison.json`。中央清单累计 `268` 个区域。

未验收全部损坏记录、OOM、原 ARM64 执行或设备持久性，下一步将实体删除接入真实 compact。
