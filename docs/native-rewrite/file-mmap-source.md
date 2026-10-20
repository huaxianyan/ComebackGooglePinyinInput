# 只读映射与共用字节所有权

MapReadOnlyFile 恢复原 mode `0` 的实际文件映射。它使用 `O_RDONLY`、`PROT_READ` 和 `MAP_SHARED`，保留 fd 与映射到最后一个区域引用释放。

映射共用 OwnedByteRegion 的同一 State、父切片和 heap COW。新增的私有持有令牌只由实际映射工厂创建，供资源析构使用，不承载另一份存储协议或字节容器。

## 原持有关系

`0x1fa4a4` 分配原描述符，再由 `0x1fa7b0` 保存映射地址、长度、引用数与 FileMMap 所有权。原销毁 `0x1fa928` 通过 FileMMap 析构释放映射。

`0x1fab6c` 对 mode `0` 的写指针请求先分离到 heap，父区域也走同一分离方法。映射改变长度时，`0x1fabcc` 同样分离。宿主恢复沿用这些关系，没有把映射地址交给 realloc/free。

## 实际验证

一条实际文件流程使用项目内的三字节夹具：

1. 映射 `ABC`，工厂返回后仍可读取。
2. 独立文件句柄把中间字节改为 `D`，映射读出 `ADC`，证明实际共享映射而非 heap 读入。
3. 独占映射取得写指针并改为 `XDC`，增长后是 `XDC` 加两个零字节。
4. 另一个映射的父句柄离开作用域，切片仍读出 `DC`。切片写成 `DY` 后，实际文件仍为 `ADC`。

严格增量编译共用所有权和映射模块，原 heap/切片测试与实际映射流程均通过。夹具已精确清理，未再次全量构建，也未访问用户文件。

独立复现入口，在 Linux/WSL 的仓库根执行：

```bash
mkdir -p work/native-rewrite/mmap-probe
g++ -std=c++17 -O2 -Wall -Wextra -Werror \
  -I research/native-rewrite/recovered \
  research/native-rewrite/recovered/owned_byte_region.cc \
  research/native-rewrite/recovered/file_mmap.cc \
  research/native-rewrite/tests/file_mmap_test.cc \
  -o work/native-rewrite/mmap-probe/file_mmap_test
work/native-rewrite/mmap-probe/file_mmap_test work/native-rewrite/mmap-probe/shared.bin
```

测试自行删除指定的夹具，完成后可删除探针可执行文件。

接入完整加载后，映射入口以 FileMappingResult 区分成功、空文件和其他失败。空文件结果来自同次 fstat，供上层保留原无效镜像类别，其他映射行为保持不变。

## 明确限制与差异

- 只恢复非空、正向 int32 可表示长度的现有文件，较大文件返回映射失败。未照搬原长度缩窄后暴露完整 stat 长度的风险，不宣称大文件等价。
- fd 按 C++ 唯一资源所有权关闭一次，包括初始化失败。未重演原失败清理可能重复 close 的行为，这是明确的归一化差异。
- 原系统包装包含分配器通知及替换钩子，普通路径调用 ARM64 mmap/munmap syscall。宿主使用 POSIX mmap/munmap，未恢复这些钩子。
- 未恢复 mode `1`、`2`、文件创建或容量取整。[完整文件加载](mapped-dictionary-load.md) 已接入同一映射，字节区域入口仍保留原流语义。
- 未验收 Android、原 ARM64 执行、OOM、全部损坏文件或异常并发。

## 证据

`work/native-rewrite/restart-v217/native-file-mmap-owner-comparison.json` 记录两个构造区间字节一致。两个系统包装的原始字节比较发现差异，逐条确认差异均为 ADRP 指向的数据地址平移，寄存器与节内偏移一致，其他指令字节一致。

不把地址平移写成字节完全相同。中央原始字节清单只新增两个构造区间，累计 `274` 区域。旧共享赋值与引用释放直接沿用已有登记。
