package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.AssistChip
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.TextButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

/** Staged proof that official Compose Material 3 can preserve legacy setting contracts. */
class ComposeSettingsPrototypeActivity : ComponentActivity() {
    private lateinit var repository: LegacySettingsRepository
    private lateinit var audioManager: AudioManager
    private lateinit var vibrator: Vibrator
    private var snapshot by mutableStateOf<SliderSettingsSnapshot?>(null)

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        repository = LegacySettingsRepository(this)
        audioManager = getSystemService(AudioManager::class.java)
        vibrator = getSystemService(Vibrator::class.java)
        setContent {
            PrototypeTheme {
                snapshot?.let {
                    StagedSettingsScreen(
                        snapshot = it,
                        onSoundEnabledChange = { enabled ->
                            snapshot = repository.setSoundEnabled(enabled)
                        },
                        onVolumeCommit = { percent ->
                            snapshot = repository.setVolumePercent(percent)
                            audioManager.playSoundEffect(5, percent / 100f)
                        },
                        onVolumeDefault = {
                            snapshot = repository.restoreVolumeDefault()
                        },
                        onVibrationEnabledChange = { enabled ->
                            snapshot = repository.setVibrationEnabled(enabled)
                        },
                        onVibrationCommit = { milliseconds ->
                            snapshot = repository.setVibrationDuration(milliseconds)
                            previewVibration(milliseconds)
                        },
                        onVibrationDefault = {
                            snapshot = repository.restoreVibrationDefault()
                        },
                        onKeyboardHeightChange = { index ->
                            snapshot = repository.setKeyboardHeightIndex(index)
                        },
                        onSlideSensitivityChange = { index ->
                            snapshot = repository.setSlideSensitivityIndex(index)
                        },
                    )
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        snapshot = repository.readSliderSnapshot()
    }

    private fun previewVibration(milliseconds: Int) {
        if (milliseconds <= 0 || !vibrator.hasVibrator()) return
        vibrator.vibrate(
            VibrationEffect.createOneShot(
                milliseconds.toLong(),
                VibrationEffect.DEFAULT_AMPLITUDE,
            )
        )
    }
}

@Composable
private fun PrototypeTheme(content: @Composable () -> Unit) {
    val context = LocalContext.current
    val dark = (context.resources.configuration.uiMode and 0x30) == 0x20
    val colors = when {
        Build.VERSION.SDK_INT >= 31 && dark -> dynamicDarkColorScheme(context)
        Build.VERSION.SDK_INT >= 31 -> dynamicLightColorScheme(context)
        dark -> darkColorScheme()
        else -> lightColorScheme()
    }
    MaterialTheme(colorScheme = colors, content = content)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun StagedSettingsScreen(
    snapshot: SliderSettingsSnapshot,
    onSoundEnabledChange: (Boolean) -> Unit,
    onVolumeCommit: (Int) -> Unit,
    onVolumeDefault: () -> Unit,
    onVibrationEnabledChange: (Boolean) -> Unit,
    onVibrationCommit: (Int) -> Unit,
    onVibrationDefault: () -> Unit,
    onKeyboardHeightChange: (Int) -> Unit,
    onSlideSensitivityChange: (Int) -> Unit,
) {
    Scaffold(
        topBar = { TopAppBar(title = { Text("键盘设置") }) },
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier.padding(innerPadding),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            item {
                Text(
                    text = "官方 Compose Material 3 · 分阶段写入验证",
                    modifier = Modifier.padding(horizontal = 24.dp, vertical = 12.dp),
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            item { SectionTitle("按键反馈") }
            item {
                SettingsSwitchRow(
                    title = "按键音",
                    supporting = if (snapshot.soundEnabled) "已开启" else "已关闭",
                    checked = snapshot.soundEnabled,
                    onCheckedChange = onSoundEnabledChange,
                )
            }
            item {
                DefaultAwareAdjustment(
                    title = "按键音量",
                    state = snapshot.volume.toVolumeProgress(),
                    valueText = { "$it%" },
                    enabledByDependency = snapshot.soundEnabled,
                    decreaseDescription = "降低按键音量",
                    increaseDescription = "提高按键音量",
                    onCommit = onVolumeCommit,
                    onRestoreDefault = onVolumeDefault,
                )
            }
            item {
                SettingsSwitchRow(
                    title = "按键振动",
                    supporting = if (snapshot.vibrationEnabled) "已开启" else "已关闭",
                    checked = snapshot.vibrationEnabled,
                    onCheckedChange = onVibrationEnabledChange,
                )
            }
            item {
                DefaultAwareAdjustment(
                    title = "振动时长",
                    state = snapshot.vibration,
                    valueText = { "$it ms" },
                    enabledByDependency = snapshot.vibrationEnabled,
                    decreaseDescription = "缩短振动时长",
                    increaseDescription = "延长振动时长",
                    onCommit = onVibrationCommit,
                    onRestoreDefault = onVibrationDefault,
                )
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item { SectionTitle("布局和手势") }
            item {
                DiscreteReadOnlySlider(
                    title = "键盘高度",
                    value = snapshot.keyboardHeightIndex.toFloat(),
                    valueText = snapshot.keyboardHeightLabel,
                    valueTextForIndex = snapshot.keyboardHeightLabels::get,
                    maximumIndex = SliderSettingContracts.keyboardHeight.values.lastIndex,
                    editable = true,
                    onValueCommit = onKeyboardHeightChange,
                )
            }
            item {
                DiscreteReadOnlySlider(
                    title = "滑动灵敏度",
                    value = snapshot.slideSensitivityIndex.toFloat(),
                    valueText = snapshot.slideSensitivityLabel,
                    valueTextForIndex = snapshot.slideSensitivityLabels::get,
                    maximumIndex = SliderSettingContracts.slideSensitivity.values.lastIndex,
                    editable = true,
                    onValueCommit = onSlideSensitivityChange,
                )
            }
            item {
                DiscreteReadOnlySlider(
                    title = "长按延迟",
                    value = SliderSettingContracts.longPressProgress(
                        snapshot.longPressDelayMs,
                    ).coerceIn(0, 60).toFloat(),
                    valueText = "${snapshot.longPressDelayMs} ms",
                    maximumIndex = 60,
                )
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item { SectionTitle("手写") }
            item {
                DiscreteReadOnlySlider(
                    title = "识别等待时间",
                    value = snapshot.handwritingTimeoutIndex.toFloat(),
                    valueText = snapshot.handwritingTimeoutLabel + " · " +
                        SliderSettingContracts.handwritingTimeout.valueAt(
                            snapshot.handwritingTimeoutIndex,
                        ) + " ms",
                    maximumIndex = SliderSettingContracts.handwritingTimeout.values.lastIndex,
                )
            }
            item {
                DiscreteReadOnlySlider(
                    title = "笔画宽度",
                    value = snapshot.handwritingStrokeWidthIndex.toFloat(),
                    valueText = snapshot.handwritingStrokeWidthLabel + " · " +
                        SliderSettingContracts.handwritingStrokeWidth.valueAt(
                            snapshot.handwritingStrokeWidthIndex,
                        ),
                    maximumIndex = SliderSettingContracts.handwritingStrokeWidth.values.lastIndex,
                )
            }
        }
    }
}

@Composable
private fun SectionTitle(title: String) {
    Text(
        text = title,
        modifier = Modifier.padding(horizontal = 24.dp, vertical = 8.dp),
        color = MaterialTheme.colorScheme.primary,
        fontWeight = FontWeight.Medium,
        style = MaterialTheme.typography.labelLarge,
    )
}

@Composable
private fun SettingsSwitchRow(
    title: String,
    supporting: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(title, style = MaterialTheme.typography.bodyLarge)
            Text(
                supporting,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodyMedium,
            )
        }
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
        )
    }
}

private fun ResolvedSetting<Float>.toVolumeProgress(): ResolvedSetting<Int> = when (this) {
    is ResolvedSetting.Explicit -> ResolvedSetting.Explicit(
        SliderSettingContracts.volumePercent(value),
    )
    is ResolvedSetting.SystemDefault -> ResolvedSetting.SystemDefault(
        if (effectiveValue < 0f) -1 else SliderSettingContracts.volumePercent(effectiveValue),
    )
}

@Composable
private fun DefaultAwareAdjustment(
    title: String,
    state: ResolvedSetting<Int>,
    valueText: (Int) -> String,
    enabledByDependency: Boolean,
    decreaseDescription: String,
    increaseDescription: String,
    onCommit: (Int) -> Unit,
    onRestoreDefault: () -> Unit,
) {
    var drafting by rememberSaveable(title) { mutableStateOf(false) }
    var draftValue by rememberSaveable(title) { mutableStateOf(0) }
    var draftTouched by rememberSaveable(title) { mutableStateOf(false) }

    when {
        state is ResolvedSetting.Explicit -> {
            AdjustmentControlGroup(
                title = title,
                value = state.value.coerceIn(0, 100),
                summary = valueText(state.value.coerceIn(0, 100)),
                valueText = valueText,
                enabled = enabledByDependency,
                decreaseDescription = decreaseDescription,
                increaseDescription = increaseDescription,
                onCommit = onCommit,
                footer = {
                    OutlinedButton(
                        onClick = onRestoreDefault,
                        enabled = enabledByDependency,
                        modifier = Modifier.fillMaxWidth(),
                    ) {
                        Text("使用系统默认")
                    }
                },
            )
        }
        drafting -> {
            AdjustmentControlGroup(
                title = title,
                value = draftValue,
                summary = if (draftTouched) valueText(draftValue) else "选择自定义值（尚未保存）",
                valueText = valueText,
                enabled = enabledByDependency,
                decreaseDescription = decreaseDescription,
                increaseDescription = increaseDescription,
                onValueChange = {
                    draftValue = it
                    draftTouched = true
                },
                footer = {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End,
                    ) {
                        TextButton(
                            onClick = {
                                drafting = false
                                draftTouched = false
                            },
                        ) {
                            Text("取消")
                        }
                        Button(
                            onClick = {
                                onCommit(draftValue)
                                drafting = false
                                draftTouched = false
                            },
                            enabled = enabledByDependency && draftTouched,
                        ) {
                            Text("应用")
                        }
                    }
                },
            )
        }
        else -> {
            SystemDefaultAdjustment(
                title = title,
                dependencyEnabled = enabledByDependency,
                onCustomize = {
                    draftValue = 0
                    draftTouched = false
                    drafting = true
                },
            )
        }
    }
}

@Composable
private fun SystemDefaultAdjustment(
    title: String,
    dependencyEnabled: Boolean,
    onCustomize: () -> Unit,
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 12.dp),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    title,
                    color = if (dependencyEnabled) MaterialTheme.colorScheme.onSurface
                    else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                    style = MaterialTheme.typography.bodyLarge,
                )
                Text(
                    if (dependencyEnabled) "由系统决定，不对应数值零"
                    else "父开关已关闭，启用后可设置自定义值",
                    color = if (dependencyEnabled) MaterialTheme.colorScheme.onSurfaceVariant
                    else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            AssistChip(
                onClick = {},
                label = { Text("系统默认") },
                enabled = false,
            )
        }
        OutlinedButton(
            onClick = onCustomize,
            enabled = dependencyEnabled,
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 8.dp),
        ) {
            Text("设置自定义值")
        }
    }
}

@Composable
private fun AdjustmentControlGroup(
    title: String,
    value: Int,
    summary: String,
    valueText: (Int) -> String,
    enabled: Boolean,
    decreaseDescription: String,
    increaseDescription: String,
    onCommit: ((Int) -> Unit)? = null,
    onValueChange: ((Int) -> Unit)? = null,
    footer: @Composable () -> Unit,
) {
    var displayedValue by remember(value) { mutableFloatStateOf(value.toFloat()) }
    val displayedProgress = displayedValue.roundToInt().coerceIn(0, 100)
    val displayedSummary = if (onCommit != null) valueText(displayedProgress) else summary
    val updateValue: (Int) -> Unit = {
        displayedValue = it.coerceIn(0, 100).toFloat()
        onValueChange?.invoke(it.coerceIn(0, 100))
    }
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 10.dp),
    ) {
        Text(
            title,
            color = if (enabled) MaterialTheme.colorScheme.onSurface
            else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
            style = MaterialTheme.typography.bodyLarge,
        )
        Text(
            displayedSummary,
            color = if (enabled) MaterialTheme.colorScheme.onSurfaceVariant
            else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
            style = MaterialTheme.typography.bodyMedium,
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .windowInsetsPadding(WindowInsets.safeGestures.only(WindowInsetsSides.Horizontal)),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            TextButton(
                onClick = {
                    val next = (displayedProgress - 1).coerceAtLeast(0)
                    updateValue(next)
                    onCommit?.invoke(next)
                },
                enabled = enabled,
                modifier = Modifier.semantics { contentDescription = decreaseDescription },
            ) {
                Text("−")
            }
            Slider(
                value = displayedValue.coerceIn(0f, 100f),
                onValueChange = { updateValue(it.roundToInt()) },
                onValueChangeFinished = {
                    onCommit?.invoke(displayedValue.roundToInt().coerceIn(0, 100))
                },
                valueRange = 0f..100f,
                steps = 99,
                enabled = enabled,
                modifier = Modifier
                    .weight(1f)
                    .semantics {
                        contentDescription = "$title，${valueText(displayedProgress)}"
                    },
            )
            TextButton(
                onClick = {
                    val next = (displayedProgress + 1).coerceAtMost(100)
                    updateValue(next)
                    onCommit?.invoke(next)
                },
                enabled = enabled,
                modifier = Modifier.semantics { contentDescription = increaseDescription },
            ) {
                Text("+")
            }
        }
        footer()
    }
}

@Composable
private fun DiscreteReadOnlySlider(
    title: String,
    value: Float,
    valueText: String,
    valueTextForIndex: ((Int) -> String)? = null,
    maximumIndex: Int,
    dependencyEnabled: Boolean = true,
    editable: Boolean = false,
    onValueCommit: (Int) -> Unit = {},
) {
    var displayedValue by remember(value) { mutableFloatStateOf(value) }
    val interactionEnabled = editable && dependencyEnabled
    val displayedIndex = displayedValue.roundToInt().coerceIn(0, maximumIndex)
    val displayedValueText = valueTextForIndex?.invoke(displayedIndex) ?: valueText
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 10.dp),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Text(
                title,
                color = if (dependencyEnabled) MaterialTheme.colorScheme.onSurface
                else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                style = MaterialTheme.typography.bodyLarge,
            )
            Text(
                displayedValueText,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.labelLarge,
            )
        }
        Slider(
            value = displayedValue.coerceIn(0f, maximumIndex.toFloat()),
            onValueChange = { if (interactionEnabled) displayedValue = it },
            onValueChangeFinished = {
                if (interactionEnabled) onValueCommit(displayedValue.roundToInt())
            },
            valueRange = 0f..maximumIndex.toFloat(),
            steps = (maximumIndex - 1).coerceAtLeast(0),
            enabled = interactionEnabled,
            modifier = Modifier
                .fillMaxWidth()
                .windowInsetsPadding(WindowInsets.safeGestures.only(WindowInsetsSides.Horizontal))
                .semantics {
                    contentDescription = "$title，$displayedValueText，" +
                        if (interactionEnabled) "可调整" else "只读"
                },
        )
    }
}
