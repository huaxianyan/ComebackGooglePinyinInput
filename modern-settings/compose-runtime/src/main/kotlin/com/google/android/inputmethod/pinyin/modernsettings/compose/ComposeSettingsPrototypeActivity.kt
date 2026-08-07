package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.os.Build
import android.os.Bundle
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
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
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
    private var snapshot by mutableStateOf<SliderSettingsSnapshot?>(null)

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        repository = LegacySettingsRepository(this)
        setContent {
            PrototypeTheme {
                snapshot?.let {
                    StagedSettingsScreen(
                        snapshot = it,
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
                ReadOnlySwitchRow(
                    title = "按键音",
                    supporting = if (snapshot.soundEnabled) "已开启" else "已关闭",
                    checked = snapshot.soundEnabled,
                )
            }
            item {
                DefaultAwareFloatSlider(
                    title = "按键音量",
                    state = snapshot.volume,
                    enabledByDependency = snapshot.soundEnabled,
                )
            }
            item {
                ReadOnlySwitchRow(
                    title = "按键振动",
                    supporting = if (snapshot.vibrationEnabled) "已开启" else "已关闭",
                    checked = snapshot.vibrationEnabled,
                )
            }
            item {
                DefaultAwareVibrationSlider(
                    state = snapshot.vibration,
                    enabledByDependency = snapshot.vibrationEnabled,
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
private fun ReadOnlySwitchRow(title: String, supporting: String, checked: Boolean) {
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
        Switch(checked = checked, onCheckedChange = null, enabled = false)
    }
}

@Composable
private fun DefaultAwareFloatSlider(
    title: String,
    state: ResolvedSetting<Float>,
    enabledByDependency: Boolean,
) {
    val value = when (state) {
        is ResolvedSetting.Explicit -> state.value
        is ResolvedSetting.SystemDefault -> state.effectiveValue
    }
    if (value < 0f) {
        SystemDefaultRow(
            title = title,
            dependencyEnabled = enabledByDependency,
            disabledDescription = "按键音已关闭，启用后使用系统默认音量",
        )
    } else {
        DiscreteReadOnlySlider(
            title = title,
            value = (value * 100f).coerceIn(0f, 100f),
            valueText = "${(value * 100f).toInt()}%",
            maximumIndex = 100,
            dependencyEnabled = enabledByDependency,
        )
    }
}

@Composable
private fun DefaultAwareVibrationSlider(
    state: ResolvedSetting<Int>,
    enabledByDependency: Boolean,
) {
    val value = when (state) {
        is ResolvedSetting.Explicit -> state.value
        is ResolvedSetting.SystemDefault -> state.effectiveValue
    }
    if (value < 0) {
        SystemDefaultRow(
            title = "振动时长",
            dependencyEnabled = enabledByDependency,
            disabledDescription = "按键振动已关闭，启用后使用系统默认时长",
        )
    } else {
        DiscreteReadOnlySlider(
            title = "振动时长",
            value = value.coerceIn(0, 100).toFloat(),
            valueText = "$value ms",
            maximumIndex = 100,
            dependencyEnabled = enabledByDependency,
        )
    }
}

@Composable
private fun SystemDefaultRow(
    title: String,
    dependencyEnabled: Boolean,
    disabledDescription: String,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 12.dp),
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
                if (dependencyEnabled) "由系统决定，不对应数值零" else disabledDescription,
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
