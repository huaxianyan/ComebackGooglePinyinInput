# Ghidra headless 静态分析入口

## 安装与范围

维护者明确批准安装后，共享部署以下官方预构建包：

- [Ghidra 12.1.4](https://github.com/NationalSecurityAgency/ghidra/releases/tag/Ghidra_12.1.4_build)。
- [Temurin JDK 21.0.12.1+1](https://github.com/adoptium/temurin21-binaries/releases/tag/jdk-21.0.12.1%2B1)。

两包均匹配官方资产的 SHA-256。各安装目录的 `installation-receipt.json` 留有来源、哈希和字节数，已回收下载压缩包。Adoptium API 返回 403，改用其官方 GitHub Release 取得同一供应商的发布包。

本入口直接使用官方 Windows headless，不修改 REA 的格式准入。保留原 JDK 17，仅在子进程选择 JDK 21。安装未更改默认 JAVA_HOME、PATH、注册表或 WSL。

安装前已查官方安全公告。这里仅做本地静态分析，不启动 Ghidra Server、BSim 或 Debugger ISF Server。12.1.4 不能据此认定为修复了所有组件的全部公告。

## 调用

`ExportNativeFunctions.java` 是标准 GhidraScript，使用官方 decompiler API。参数为新输出目录和相对 image base 的十六进制偏移。对于本项目的零基址 ELF，偏移与现有 native 地址对应。

在临时 PowerShell 进程中设置路径，再调用官方启动脚本。尖括号内替换为本机目录：

```powershell
$ghidra = '<ghidra>'
$env:JAVA_HOME = '<jdk-21>'
$env:PATH = "$env:JAVA_HOME/bin;$env:PATH"
$env:JAVA_TOOL_OPTIONS = "-Dapplication.settingsdir=$ghidra/runtime/settingsdir -Dapplication.cachedir=$ghidra/runtime/cachedir -Dapplication.tempdir=$ghidra/runtime/tempdir"
$env:GHIDRA_HEADLESS_JAVA_OPTIONS = '-XX:ActiveProcessorCount=4'
& "$ghidra/support/analyzeHeadless.bat" '<projects>' original-v217-research `
    -import '<library>' -max-cpu 4 -analysisTimeoutPerFile 120 `
    -scriptPath '<repo>/research/native-rewrite/tools' `
    -postScript ExportNativeFunctions.java '<new-output>' 001a1d9c 001a1894 001a0ce0
```

项目目录和输出目录的父目录须预先存在。程序数据库已建好时，将 `-import '<library>'` 改为 `-process libhmm_gesture_hwr_zh.so -noanalysis`，继续复用已有分析。新输出目录须不存在，避免覆盖之前的证据。

三个目录属性通过 JAVA_TOOL_OPTIONS 传入启动器及其 Java 子进程。这样 LaunchSupport 保存的 JDK 选择、Ghidra 设置、缓存与临时文件都留在工具自己的 runtime 下。

## 实际验证

原版 APK 的单个 HMM 库已导入。首次自动分析约 80 秒，随后复用数据库，成功导出存储分派、已有项更新和日期函数的三个 C 视图。运行选择为 `AARCH64:LE:64:v8A`，compiler 为 `default`，image base 为 `0x100000`。

实际证据集中在 `work/native-rewrite/ghidra/`：

- `projects/`：本次建立的分析数据库。
- `original-import.log`：初次导入、自动分析和脚本日志。
- `initial-query.log`：修正地址换算后复用数据库的导出日志。
- `initial-functions/manifest.json`：程序哈希、架构、基址、函数原型和诊断。
- `initial-functions/*.c`：三个函数的反编译视图。

Ghidra 将零基址 ELF 装载到 `0x100000`。导出器统一把输入偏移加上程序 image base，不要求调用者修改已有取证地址。

## 结果限制

初次脚本因未加 image base 而找不到函数，headless 仍返回零。调用端必须检查完整 manifest，不能只看退出码。修正后只运行导出脚本，未重做自动分析。

自动分析虽报告成功，但日志含 GCC 异常表、函数边界和 landing pad 错误。后续涉及异常处理时，仍需结合既有 FDE 范围和指令核对。

首批视图还存在调用参数推断缺口：分派函数把已有项更新显示为无参数调用，而该目标的独立视图有多个参数。需要按 AArch64 ABI 校核调用现场，不能将视图直接加入恢复源码。

本次验证证明官方 native 后端可以分析目标 ELF、产生函数视图。它不证明完整引擎已恢复、视图可编译或运行行为等价。原始库与分析工具仍只用于研究，最终产品构建目标保持不变。
