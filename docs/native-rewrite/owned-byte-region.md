# 堆缓冲区与父切片所有权源码

## 范围

已恢复普通堆缓冲区与父区域切片的共享复制、保活、写时分离和精确调整大小。源码入口为 [OwnedByteRegion](../../research/native-rewrite/recovered/owned_byte_region.h)，实现见 [owned_byte_region.cc](../../research/native-rewrite/recovered/owned_byte_region.cc)。

组件采用正常 C++17 编译，只读取源码。它使用标准共享所有权管理描述符，字节区使用 `malloc`、`realloc` 和 `free`，不复刻旧对象 ABI。池的动态增长尚未接入，外部存储 Provider 和容量取整模式不在本组件范围内。

## 原生入口

| 能力 | 原路径 |
| --- | --- |
| 共享赋值 | `0x1fa508` |
| 父切片 | `0x1fa554` → `0x1fa8b8` → `0x1fa880` |
| 只读数据与长度 | `0x1fa610` → `0x1fa870`、`0x1fa620` → `0x1fa878` |
| 写指针与描述符复制 | `0x1fa5a8` → `0x1facdc`、`0x1fab6c` |
| 精确调整大小 | `0x1fa780` → `0x1fa6ac` → `0x1fabcc` |
| 从父区域分离 | `0x1faab8` |
| 初始化、释放与销毁 | `0x1fa790`、`0x1fa988`、`0x1fa928` |

原描述符字段：

| 偏移 | 内容 |
| --- | --- |
| `+0x00` | 父描述符，可为空 |
| `+0x08` | 当前区域的数据指针 |
| `+0x10` | 逻辑字节数 |
| `+0x18` | 堆分配容量，切片构造未初始化此字段 |
| `+0x20` | 描述符引用计数 |
| `+0x28` | 外部 Provider，可为空 |

`0x1fa780` 明确将容量取整参数设为零。恢复组件沿用这个池实际使用的精确大小入口，没有另加尚未闭合的容量取整选项。

## 两种共享关系

共享复制与切片保活不是同一层关系：

- 复制句柄共享同一个描述符。修改前若描述符被共享，先完整复制其逻辑字节。
- 切片有自己的描述符，同时持有父描述符。即使切片描述符只有一个引用，取得写指针时也需要分离父区域。

只检查描述符引用数，会漏掉第二种情况。恢复源码分别处理这两层关系，内存释放共用一个实现点。

父区域因切片持有而继续存活。嵌套切片保留父链，原句柄被替换后仍能读取旧字节。共享复制或分离完成后，源对象与修改后的对象各自保有对应数据。

写指针仍是普通原生指针。调用方在复制、创建切片或调整大小后，需要重新取得写指针。通过此前取得的指针直接写入，会绕开写时分离，不能把句柄共享解释为任意裸指针写入下的不可变快照。

## 调整大小与提交顺序

- 描述符独占且长度相同时，直接成功。独占切片此时仍可保留父关系，到实际取得写指针时再分离。
- 描述符共享时，先复制原逻辑区域，再调整候选区域大小，成功后替换当前句柄。
- 独占堆区域使用 `realloc`。增长保留原前缀，并将新增长部分清零。
- 父切片改变长度时，分配独立区域，复制新旧长度的较小值，增长部分清零，再释放父关系。
- 调整为零时清理当前区域。零长度切片返回空区域，而不是继续持有父区域。

字节区分配失败时，原数据与句柄保留，`Resize` 返回 false，取写指针返回空指针。描述符分配沿用正常 C++ 分配异常通道，没有将异常改写为成功或空实现。宿主探针未做内存耗尽注入，也未确认原 Android 分配器在耗尽时的完整表现。

## 验证

严格宿主构建入口：

```bash
mkdir -p work/native-rewrite/recovered-region
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/tests/owned_byte_region_test.cc \
  -o work/native-rewrite/recovered-region/owned_byte_region_test
work/native-rewrite/recovered-region/owned_byte_region_test
```

构建与一条真实 API 驱动的所有权流程通过。独立字面字节校验共享复制后的修改、独占与共享切片的写入、原区域与切片增长、缩小后重新增长、清空共享句柄及嵌套切片保活。期望值不由被测实现生成。

真实 APK 取证入口补入引用数、精确大小参数、清零参数和切片字段锚点后通过，当前导出 138 个区域。十九个新增区域与已发布 `v2.1.7` 库的指令字节一致。

证据保存在项目本地：

- `work/native-rewrite/ghidra/buffer-ownership/`
- `work/native-rewrite/ghidra/buffer-storage/`
- `work/native-rewrite/ghidra/buffer-slice/`
- `work/native-rewrite/original-apk/native-buffer-ownership.txt`
- `work/native-rewrite/restart-v217/native-buffer-comparison.json`

未执行原 ARM64 所有权函数，未访问设备或用户词典。宿主通过不代表 Android 内存故障、外部 Provider 或完整存储等价。Google 派生材料仍受 `NOTICE` 边界约束，不因恢复为可读源码自动纳入 MPL。

## 下一步

将组件接入池的元数据与单元缓冲区，恢复增长、活动数量更新、尾部空闲块处理及增长后的指针重取。逐步连接 [索引池回收与复用核心](index-pool.md)，保留跨缓冲区修改的真实失败顺序，再推进记录存储与文件容器。
