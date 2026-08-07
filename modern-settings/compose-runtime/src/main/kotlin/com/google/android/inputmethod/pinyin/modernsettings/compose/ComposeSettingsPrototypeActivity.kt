package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
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
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

/** Read-only proof that real legacy settings can drive official Compose Material 3. */
class ComposeSettingsPrototypeActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        setContent {
            PrototypeTheme {
                val context = LocalContext.current
                val snapshot = remember {
                    LegacySettingsRepository(context).readSliderSnapshot()
                }
                ReadOnlySettingsScreen(snapshot)
            }
        }
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
private fun ReadOnlySettingsScreen(snapshot: SliderSettingsSnapshot) {
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
                    text = "官方 Compose Material 3 · 只读状态验证",
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
                    valueText = SliderSettingContracts.keyboardHeight.valueAt(
                        snapshot.keyboardHeightIndex,
                    ),
                    maximumIndex = SliderSettingContracts.keyboardHeight.values.lastIndex,
                )
            }
            item {
                DiscreteReadOnlySlider(
                    title = "滑动灵敏度",
                    value = snapshot.slideSensitivityIndex.toFloat(),
                    valueText = SliderSettingContracts.slideSensitivity.valueAt(
                        snapshot.slideSensitivityIndex,
                    ),
                    maximumIndex = SliderSettingContracts.slideSensitivity.values.lastIndex,
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
                    valueText = SliderSettingContracts.handwritingTimeout.valueAt(
                        snapshot.handwritingTimeoutIndex,
                    ) + " ms",
                    maximumIndex = SliderSettingContracts.handwritingTimeout.values.lastIndex,
                )
            }
            item {
                DiscreteReadOnlySlider(
                    title = "笔画宽度",
                    value = snapshot.handwritingStrokeWidthIndex.toFloat(),
                    valueText = SliderSettingContracts.handwritingStrokeWidth.valueAt(
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
        SystemDefaultRow(title, enabledByDependency)
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
        SystemDefaultRow("振动时长", enabledByDependency)
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
private fun SystemDefaultRow(title: String, dependencyEnabled: Boolean) {
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
                "由系统决定，不对应数值零",
                color = MaterialTheme.colorScheme.onSurfaceVariant,
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
    maximumIndex: Int,
    dependencyEnabled: Boolean = true,
) {
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
                valueText,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.labelLarge,
            )
        }
        Slider(
            value = value.coerceIn(0f, maximumIndex.toFloat()),
            onValueChange = {},
            valueRange = 0f..maximumIndex.toFloat(),
            steps = (maximumIndex - 1).coerceAtLeast(0),
            enabled = false,
            modifier = Modifier
                .fillMaxWidth()
                .semantics { contentDescription = "$title，$valueText，只读" },
        )
    }
}
