# 拼音组合期间的成对符号退格修复

## 问题与修复

开启符号补全后，在符号中间输入拼音。按退格纠正字母时，原实现会先删除编辑框内的符号，再删除未上屏的字母。

`PairedPunctuationProcessor` 位于中文解码处理器之前。它直接读取光标两侧的已提交文本，找到符号对就调用 `replaceText`。拼音保留在输入法内的组合区，因此光标两侧此时仍是符号。

修复在 DEL 分支读取当前解码器的 `isComposing()`。组合期间返回原生处理路径，让解码器先处理退格。组合结束后，再按原有规则删除空符号对。开关、配对表、原生字母删除和补全规则保持原样。

状态直接来自原生分发器 `ard` 的 `IImeDecodeProcessor`，与 `ProcessorBasedIme.isComposing()` 共用同一对象。原始 APK 的 `ProcessorBasedIme.initialize()` 将这个分发器传给处理器，未增加独立组合状态或消息监听。

## 验证结果

完整 Compose 宿主构建通过。最终隔离 APK 重新解码后，`verify_paired_punctuation.py` 通过。新增断言确认组合状态检查早于编辑框文本读取，且组合期间进入原生退格回退分支。

Pixel 10 Pro 的中文拼音 26 键回归通过，走实际软键触摸和真实编辑连接：

1. 专用编辑框放入 `（）`，光标位于中间。
2. 输入 `nihao`，编辑框保留原符号，拼音尚未提交。
3. 按两次退格，再输入 `ao`，编辑框仍保留原符号。
4. 按五次退格清空拼音，每次都确认编辑框仍为 `（）`。
5. 再按一次退格，确认整对符号删除，编辑框变为空白。

最终仪器测试返回 `paired_delete=PASS` 和 `INSTRUMENTATION_CODE: -1`。已恢复开始前的默认输入法，并卸载本轮新增的隔离包。

本轮使用非正式 application ID、非 Debug 的隔离 APK，未覆盖正式包。测试入口为 `scripts/run_paired_punctuation_device_test.py`，夹具位于 `scripts/device-tests/paired-punctuation/`。

## 测试工具边界

新安装的原生键盘先显示布局选择页。首轮测试未区分缩略图与实际键盘，旧的宽松通过结果作废，不作为验收证据。

经用户授权，截图交给 Pi 配置的 OpenCode 免费视觉模型。主助手只接收文字结果。观察确认首次布局选择页，以及选中布局后显示的中文拼音 `ni hao`。

原生拼音显示在输入法内，编辑框内没有组合跨度。拼音行也未通过当前无障碍查询暴露。因此最终自动化断言检查编辑框内容与退格顺序，不将查询不到拼音视图判作产品失败，也不伪造拼音状态。

布局缩略图使用本次截图定位的测试触摸坐标，坐标按屏幕大小换算。这是测试夹具的设备约束，不进入产品布局。当前夹具要求新安装、竖屏及本轮观察到的首次布局选择页。布局变化后必须重新定位。

截图默认关闭。另获当前任务授权后，才可传 `--capture-on-failure`，目标限于 `work/device/`。设备侧临时截图在同次测试中精确清理，不默认上传图片。

## 重现命令

先通过完整宿主构建入口生成隔离 APK，application ID 为 `com.google.android.inputmethod.pinyin.pairdeleteaudit`。工具、签名材料与口令通道见本地约定，不在命令中填入口令。

```bash
python scripts/run_paired_punctuation_device_test.py \
  --sdk <android-sdk> --jdk <jdk-17> \
  --audit-apk <paired-delete-audit.apk> \
  --keystore <audit-keystore> --key-alias <audit-key-alias> \
  --serial <device-serial> --work work/pairfix/device
```

脚本要求两个测试包均未安装，按本轮测试创建和清理。运行期间会临时选择隔离输入法，结束后恢复原默认项。开始前先核对设备、锁屏和前台任务，勿打断用户操作。

## 未覆盖项

本轮直接建立删除逻辑所需的符号与光标状态，未重跑符号面板的自动补全过程。配对删除本身不记录符号来源，该状态与补全后相同。

真机覆盖限于中文拼音 26 键和专用原生编辑框。中文九键、手写、英文、长按退格和第三方编辑器未在本轮追加验收。共享处理器中的状态判断不等于这些路径均已实测。

修复仍在独立分支，尚未合入 master 或发布 Release。重写研究分支保留并暂停，未随本轮修复重放、合并或删除。
