# 去掉 apktool 的可行性评估

2026-11-04，分支 `research/no-apktool-build`。只评估构建链路，不改产品行为。

## 结论

能做，但要分清两个环节的成本差一个量级：

- **DEX 环节可以换，风险低。** apktool 在 dex 与 smali 之间的工作由内嵌的 smali 库完成，同一份代码有独立发布（`com.android.tools.smali`），换成它没有能力损失。
- **资源环节才是真成本。** apktool 的价值不在搬字节，而在解码与重建资源时的大量兜底：未知属性、9-patch、value 插值、`apktool.yml` 里的压缩规则、资源 ID 稳定性。直接换 aapt2 要自己补齐这些。

已完成一次最小实测，结论比预期好：**资源那一环用 aapt2 直连是通过的**，资源 ID 也保持了原样。剩余成本集中在打包规则与 smali 双向，不在资源重写。

建议接下来按 R2 做正式 spike，用产出物判据决定是否切换，不要先改现有脚本。

## apktool 现在实际在做什么

`scripts/build.ps1` 三步：`apktool d` 解码、`python scripts/apply_patches.py` 打补丁、`apktool b` 重建，之后交给既有的 zipalign／apksigner 链路。补丁会改 `AndroidManifest.xml`、`apktool.yml`、`res/values/*.xml`、`res/layout/*.xml`、`res/xml/*.xml` 与资源 ID 表。

另有一处绕路值得单独指出：`scripts/generate_*_smali.py` 的 Java→smali 链路是 `javac` → `jar` → `d8` → 塞进一个临时 APK → `apktool d` → 取出 smali。apktool 在这里只充当「dex→smali 转换器」，用 baksmali 直接转 d8 的产物即可，这一步可以立刻去掉。

## 环节拆解

| 环节 | 现在 | 替代 | 风险 |
| --- | --- | --- | --- |
| dex → smali | apktool 内嵌 smali | 独立 `baksmali` | 低，同一份实现 |
| Java → smali | javac＋jar＋d8＋临时 APK＋apktool | javac＋d8＋`baksmali` | 低，且省掉临时 APK |
| smali → dex | apktool 内嵌 smali | 独立 `smali` | 低 |
| 资源解码 | apktool（aapt2 dump ＋ 自有还原） | `aapt2 dump` 直出 | 中，apktool 的兜底要自己补 |
| 资源重建 | apktool（aapt2 compile／link ＋ arsc 处理 ＋ 压缩规则） | `aapt2 link` ＋ 自写规则 | 中低，实测通过；压缩规则仍需自写 |
| 打包与签名 | 既有脚本（zipalign／apksigner） | 不变 | 无 |
| 16 KiB ELF 重写 | 既有脚本，在打包后处理 | 不变 | 无，与 apktool 无关 |

## 资源环节的具体风险

1. **资源 ID 稳定性。** 项目靠 `public.xml` 与 `scripts/generate_stable_resource_ids.py` 保住原始 ID。`aapt2 link` 支持 `--stable-ids`，但要先生成与当前一致的映射表，格式与来源都要核对。
2. **`apktool.yml` 的元数据。** `doNotCompress`、`minSdkVersion`、`usesFramework` 这些直接影响产物能否安装与加载，apktool 重建时自动消费，换链路要自己维护。
3. **打包规则。** `doNotCompress` 那一串（`arsc`、`png`、`ogg`、`res/raw/*.gzip` 等）直接决定运行时能否读到，实测这轮未覆盖，切链路时必须逐条复现并验证。
4. **解码产物形状。** 现有 12 个设计文档与补丁脚本都按 apktool 的目录布局写（`smali/`、`smali_classes2/`、`res/`、`apktool.yml`）。换重建实现可以，但换解码布局会让补丁脚本全部失效。
5. **兜底行为。** 未知属性、私有属性、9-patch 边界、`<style>` 继承这类，apktool 有多年补丁；aapt2 直连时会以报错或静默丢弃的形式暴露。

## 实测（2026-11-04）

在原版 APK 上做，链路只用 SDK 自带工具，未改任何脚本。产物留在 `work/no-apktool-spike/`。

| 步骤 | 命令要点 | 结果 |
| --- | --- | --- |
| 解码 | `apktool d -f -q`（沿用现有产物形状） | 5.2 秒，`res/` 2180 个文件 |
| 资源编译 | `aapt2 compile --dir res -o flat.zip` | **0 错误**，2.1 秒 |
| 资源链接 | `aapt2 link -o linked.apk -I android.jar --manifest … --min-sdk-version 17 --target-sdk-version 26 flat.zip` | **0 错误**，1.8 秒 |
| 资源 ID 比对 | `aapt2 dump resources` 两份产物逐条比 | **6633 条全部一致**，无变化、无缺失 |

三个直接结论：

1. apktool 解码出的 `res/` 是 aapt2 可编译的源，不需要重写资源。
2. 本次 `aapt2 link` 没有加 `--stable-ids`，ID 仍与原版逐条一致。这是好消息，但它依赖「原版 ID 恰好与解码顺序一致」，补丁新增资源后必须重新比对，不能当成永久保证。
3. `aapt2 link` 不写 `versionCode`／`versionName`（它们在 `apktool.yml` 里），必须转成 `--version-code`／`--version-name` 参数，否则产物缺这两个属性。这一条实测已暴露。

还没测的部分：`assets/`、`lib/`、`classes*.dex` 的装包与 `doNotCompress` 规则、smali 双向、签名链路（后两项现有脚本已覆盖）。

## 三条路线

| 路线 | 做什么 | 成本 | 风险 | 收益 |
| --- | --- | --- | --- | --- |
| R1 | 只把「dex／smali 双向」与 Java→smali 的绕路换成独立 smali 库，解码与重建仍用 apktool | 小 | 低 | 去掉 CLI 依赖，构建更快 |
| R2 | 解码继续用 apktool 产物形状，重建改成 `smali` ＋ `aapt2 link` ＋ 自有打包 | 中 | 高 | 真正不依赖 apktool |
| R3 | 整个 Java 层还原成可编译源码，Gradle 构建 | 很大 | 高 | 源码可读，本文不评估 |

R3 不在本轮范围：原版 dex 有 3264 个类，自有类 626 个，另外 2638 个是当年打包进来的旧 Support Library 与 Play Services，没有源码就重建不出来。

## 建议的第一步：等价重建 spike

目标不是「构建成功」，而是「产出物在给定维度上等价」。判据如下，全部满足才算通过：

1. 资源 ID 表（`resources.arsc` 里的条目与 ID）与 apktool 构建一致。
2. 二进制 `AndroidManifest.xml` 语义一致：包名、版本、权限、组件、`extractNativeLibs`、`pageSizeCompat` 等逐项比对。
3. `classes*.dex` 的类数与方法数一致，新增类的方法签名逐个比对。
4. 16 KiB ELF 审计 `scripts/audit_elf_page_size.py` 退出 0。
5. 隔离包安装后冒烟通过：启动、切换输入法、中文输入一个词、设置页可进。

只做一次、只对一个版本，不改现有链路；spike 产物留在 `work/` 下可复现。通过则按 R2 推进，不通过则退回 R1，并把结论写回本文。

## 边界

- 本轮不改产品行为，不发布，不动签名身份。
- 不替换原生库，原生层边界仍按 2026-11-04 的决定执行。
- 评估不涉及换引擎的方案。
