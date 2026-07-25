# 首次引导重复与键盘布局选择状态调查

## 现象

在多次卸载、重新安装测试包后可能出现：

1. 已走完“启用 → 选择输入法 → 完成”，第一次准备输入时又回到一次完成页面；再次点击完成后不再出现。
2. 第一次弹出键盘时直接进入 26 键，而不是原版的四布局 Dashboard。
3. 后来手动打开键盘切换界面时，才显示“请选择您常用的键盘布局”首次提示。

三个现象来自同一组安装状态，而不是词典导入本身。

## 原始状态链路

### 引导完成状态

共享 `apy` 使用默认 SharedPreferences 中的整数：

```text
HAD_FIRST_RUN
```

`PinyinFirstRunActivity.b(Context)` 在 `SettingsActivity` 和 `PinyinIME.d()` 两处调用。只要值不等于资源中的 first-run version，就会以 `FLAG_ACTIVITY_NEW_TASK` 启动首次引导。

旧框架在 `apy.onCreate()` 一进入 Activity 就写 `HAD_FIRST_RUN`，并通过 `Lamx.a(String,int)` 最终调用 `SharedPreferences.Editor.apply()`；最后“完成”按钮本身只负责启动 Home 并 `finishAndRemoveTask()`，没有同步的最终完成事务。

因此原始状态表达的是“引导 Activity 创建过”，不是“用户点击完成且任务已退出”。IME 服务又会在第二步被选中时启动并独立检查相同状态，形成 Activity/IME 生命周期交叉。

### 键盘布局状态

四选一页面不是 Activity 引导的一页，而是输入法内部的 `Dashboard` InputBundle。是否自动进入 Dashboard 由：

```text
USER_SELECTED_KEYBOARD
```

控制：

- `false`：`GoogleInputMethodService.shouldSwitchToDashboard()` 对普通软键盘文本字段返回 true；
- 用户从 Dashboard 切换到具体布局后，`GoogleInputMethodService.g()` 将其写为 true；
- Dashboard 在 false 时显示 `hint_text_choose_keyboard_layout`，即“请选择您常用的键盘布局”。

如果 IME 服务在引导第二步就已初始化，它可能先持有普通 26 键 InputBundle；原始代码没有“最终完成后，在第一个合适输入框重新执行 Dashboard 选择”的明确事务。因此可以出现“先显示 26 键，手动切换后才在 Dashboard 弹首次提示”。

## BackupAgent 影响

应用声明的自定义 `BackupAgent` 使用：

```text
SharedPreferencesBackupHelper(<package>_preferences)
```

备份整个默认偏好文件。其恢复排除数组为空，所以以下安装本地状态也会随卸载重装/设备恢复返回：

```text
HAD_FIRST_RUN
USER_SELECTED_KEYBOARD
ACTIVE_IME.SOFT.*
```

这解释了为何问题在多次重新安装审计包时更容易出现：恢复的数据可能来自不同测试阶段，而旧框架把一次性引导状态、布局是否已选择、当前布局和普通可迁移设置混在同一个默认偏好文件中。备份配置本身不应决定新安装是否完成系统输入法启用步骤。

正式本地词典备份使用独立 `dictionary_local_backup_preferences`，不参与这个问题；用户词典导入也不会写上述键。

## 修复设计

### 1. 安装本地完成标记

新增未注册到 BackupAgent 的：

```text
first_run_local_state
  guide_complete
  dashboard_pending
```

最后一页点击“完成”时：

1. 使用同步 `commit()` 写 `guide_complete=true`；
2. 写 `dashboard_pending=true`；
3. 同步重置 `USER_SELECTED_KEYBOARD=false`；
4. 然后才执行 Home + `finishAndRemoveTask()`。

`PinyinFirstRunActivity.b(Context)` 优先检查安装本地 `guide_complete`，避免任务移除后的新检查再次启动引导。旧 `HAD_FIRST_RUN` 检查保留，兼容已经完成引导但尚无新标记的升级用户。

首次隔离验证证明，仅增加最终完成标记仍不足：`SettingsActivity` 首次决定启动引导后，在用户进行系统“启用/选择输入法”步骤期间，`PinyinIME.d()` 还可以在最终完成值写入前再次通过同一个检查。后写入的完成值只能阻止未来检查，不能撤销此前已经被 Android ActivityTaskManager 接受的 `NEW_TASK`/`singleTask` 启动请求，于是该请求会在完成退出后把任务再次带到前台。

修正版增加进程内、同步的 `sGuideLaunchClaimed`：第一次调用者在返回“需要启动”时原子占有启动权；Activity 存活期间 Settings 和 IME 的后续检查均返回 false。未完成就销毁 Activity 时释放占有，允许重新进入；完成后则由持久化 `guide_complete` 继续阻止启动。Activity 创建时也复核完成标记，使已经排队的旧 Intent 即使到达也立即退出，而不会停留在完成页。

第二次隔离验证确认完成页不再停留，但复核分支错误地复用了正常完成路径 `exitGuide()`。该路径会发送 `ACTION_MAIN + CATEGORY_HOME`；迟到 Intent 到达时用户已在桌面，第二个 HOME 语义会触发部分第三方 Launcher 的“再次按 Home 打开应用抽屉”。最终处理改为：正常点击完成仍保留已经验证过的 Home/任务清理行为；仅对完成后迟到的 Activity 直接 `finishAndRemoveTask()`，静默丢弃任务，不再发送第二个 HOME Intent。

### 2. 不恢复一次性安装状态

`BackupAgent.onRestore()` 在原生恢复后只移除：

```text
HAD_FIRST_RUN
USER_SELECTED_KEYBOARD
```

其他主题、输入偏好、当前布局等仍按原有 BackupAgent 恢复。新安装或新设备仍需完成 Android 系统层面的启用/选择步骤，不应被旧备份直接判定为完成。

### 3. 第一个合适文本字段显示 Dashboard

`PinyinIME.onStartInputView()` 检查 `dashboard_pending`：

- 继续复用原生 `shouldSwitchToDashboard()`，因此密码、数字、硬键盘、TV 或只有单一布局的场景不会被强制切换；
- 对第一个符合原生条件的普通文本字段调用现有 `InputBundleManager.b("dashboard")`；
- 成功请求后消费 pending；
- 如果用户已经主动选择了布局，则直接消费 pending，不覆盖用户选择。

没有修改 Dashboard 的四项内容、截图、触摸、提示气泡或 `USER_SELECTED_KEYBOARD` 的原生完成语义。

## 隔离验证范围

测试包使用：

```text
com.google.android.inputmethod.pinyin.guideaudit
```

需要验证：

1. 新安装完整走完三步后，准备输入时不再出现第二次完成页；
2. 第一个普通文本输入框自动显示四布局 Dashboard；
3. “请选择您常用的键盘布局”在 Dashboard 中正常出现；
4. 选择 9 键或 26 键后进入对应键盘，后续不再自动打开 Dashboard；
5. 第一个字段若是密码/数字，不强制 Dashboard；随后第一个普通文本字段仍显示；
6. 卸载重装并发生系统偏好恢复后仍重复 1–5；
7. 正式包 `com.google.android.inputmethod.pinyin.compat` 的数据和默认输入法不受隔离包安装影响。

## 后台权限 Activity 并发（2026-07-25）

一次干净安装的剪贴板隔离测试捕获了不同于重复完成页的旧路径：IME 服务在首个输入字段启动 `com.google.android.apps.inputmethod.libs.framework.core.PermissionsActivity`，约 150 ms 后首次引导又启动 `PinyinFirstRunActivity`。透明权限宿主、系统权限页和首次引导因此成为两个并发任务；这不是 `guide_complete` 竞争，也不是迟到 Intent 的第二次 HOME。

`FeaturePermissionsManager` 已经有两条权限路径：有前台设置 Activity 时直接调用 `Activity.requestPermissions()`；没有 Activity、仅持有应用 Context 时则通过静态 helper 以 `FLAG_ACTIVITY_NEW_TASK` 启动 `PermissionsActivity`。现代化策略只禁止后一条后台拉起路径：

- IME 启动不再抢占当前文本应用或首次引导；
- 未获授权的可选功能保持禁用；
- 用户从真实设置 Activity 触发的权限请求继续使用原生回调；
- 本地备份设置自己的显式权限请求不受影响。

该路径需要在修正版干净安装包中确认：首次输入只进入首次引导，不再同时创建 `PermissionsActivity` 任务。

## 最终完成目的地调整（2026-07-25）

后续真机测试发现，即使移除后台透明权限 Activity，完成时直接发送 HOME 仍会让当前文本窗口、IME 重启和 `dashboard_pending` 的消费顺序互相竞争：首次重新弹出键盘可能先显示无提示的默认 26 键，第二次才出现带引导文字的四布局 Dashboard。

因此放弃“点击完成直接回桌面”的设计，恢复原版使用习惯：完成事务同步写入后，显式打开 Google 拼音 `SettingsActivity`，再以普通 `finish()` 结束引导，不发送 HOME，也不立即移除包含设置页的任务。这样当前文本应用先明确失去焦点，用户离开设置后进入下一个普通文本字段时，Dashboard 才有单一、稳定的触发机会。

返回键行为保持不变且与完成动作分离：

- 不在第一页：只回到上一页；
- 在第一页：调用退出路径回到 Home 并移除引导任务；
- 已完成后迟到的 singleTask Intent：继续静默 `finishAndRemoveTask()`，不发送 HOME。
