package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.AssistChip
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.listSaver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

private val adjustmentStateSaver = listSaver<AdjustmentEditorState, Int>(
    save = { state ->
        when (state) {
            AdjustmentEditorState.SystemDefault -> listOf(0, 0, 0)
            is AdjustmentEditorState.EditingDraft -> listOf(
                1,
                state.value,
                if (state.touched) 1 else 0,
            )
            is AdjustmentEditorState.Explicit -> listOf(2, state.value, 1)
        }
    },
    restore = { saved ->
        when (saved[0]) {
            0 -> AdjustmentEditorState.SystemDefault
            1 -> AdjustmentEditorState.EditingDraft(saved[1], saved[2] != 0)
            2 -> AdjustmentEditorState.Explicit(saved[1])
            else -> error("Unknown saved adjustment state: ${saved[0]}")
        }
    },
)

fun ResolvedSetting<Float>.toVolumeProgress(): ResolvedSetting<Int> = when (this) {
    is ResolvedSetting.Explicit -> ResolvedSetting.Explicit(
        SliderSettingContracts.volumePercent(value),
    )
    is ResolvedSetting.SystemDefault -> ResolvedSetting.SystemDefault(
        if (effectiveValue < 0f) -1 else SliderSettingContracts.volumePercent(effectiveValue),
    )
}

@Composable
fun DefaultAwareAdjustment(
    title: String,
    state: ResolvedSetting<Int>,
    valueText: (Int) -> String,
    enabledByDependency: Boolean,
    decreaseDescription: String,
    increaseDescription: String,
    onCommit: (Int) -> Unit,
    onRestoreDefault: () -> Unit,
) {
    val resolvedState = AdjustmentStateReducer.fromResolved(state)
    val resolvedKey = when (resolvedState) {
        AdjustmentEditorState.SystemDefault -> "default"
        is AdjustmentEditorState.Explicit -> "explicit:${resolvedState.value}"
        is AdjustmentEditorState.EditingDraft -> error("Repository cannot contain a draft")
    }
    var editorState by rememberSaveable(title, resolvedKey, stateSaver = adjustmentStateSaver) {
        mutableStateOf(resolvedState)
    }

    when (val current = editorState) {
        AdjustmentEditorState.SystemDefault -> {
            SystemDefaultAdjustment(
                title = title,
                dependencyEnabled = enabledByDependency,
                onCustomize = {
                    editorState = AdjustmentStateReducer.startCustom(current)
                },
            )
        }
        is AdjustmentEditorState.EditingDraft -> {
            AdjustmentControlGroup(
                title = title,
                value = current.value,
                summary = if (current.touched) valueText(current.value)
                else stringResource(R.string.modern_settings_choose_custom_unsaved),
                valueText = valueText,
                enabled = AdjustmentStateReducer.isInteractive(
                    current,
                    enabledByDependency,
                ),
                decreaseDescription = decreaseDescription,
                increaseDescription = increaseDescription,
                onValueChange = { value ->
                    editorState = AdjustmentStateReducer.updateDraft(editorState, value)
                },
                footer = {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End,
                    ) {
                        TextButton(
                            onClick = {
                                editorState = AdjustmentStateReducer.cancelDraft(editorState)
                            },
                        ) {
                            Text(stringResource(R.string.modern_settings_cancel))
                        }
                        Button(
                            onClick = {
                                val applied = AdjustmentStateReducer.applyDraft(editorState)
                                onCommit(applied.value)
                            },
                            enabled = enabledByDependency && current.touched,
                        ) {
                            Text(stringResource(R.string.modern_settings_apply))
                        }
                    }
                },
            )
        }
        is AdjustmentEditorState.Explicit -> {
            AdjustmentControlGroup(
                title = title,
                value = current.value,
                summary = valueText(current.value),
                valueText = valueText,
                enabled = AdjustmentStateReducer.isInteractive(
                    current,
                    enabledByDependency,
                ),
                decreaseDescription = decreaseDescription,
                increaseDescription = increaseDescription,
                onCommit = { value ->
                    AdjustmentStateReducer.updateExplicit(current, value)
                    onCommit(value)
                },
                footer = {
                    OutlinedButton(
                        onClick = {
                            AdjustmentStateReducer.restoreDefault(current)
                            onRestoreDefault()
                        },
                        enabled = enabledByDependency,
                        modifier = Modifier.fillMaxWidth(),
                    ) {
                        Text(stringResource(R.string.modern_settings_use_system_default))
                    }
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
                    stringResource(
                        if (dependencyEnabled) {
                            R.string.modern_settings_system_default_explanation
                        } else {
                            R.string.modern_settings_dependency_disabled
                        }
                    ),
                    color = if (dependencyEnabled) MaterialTheme.colorScheme.onSurfaceVariant
                    else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            AssistChip(
                onClick = {},
                label = { Text(stringResource(R.string.modern_settings_system_default)) },
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
            Text(stringResource(R.string.modern_settings_set_custom))
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
    val adjustmentSemantics = stringResource(
        R.string.modern_settings_value_adjustable,
        title,
        valueText(displayedProgress),
    )
    val updateValue: (Int) -> Unit = { candidate ->
        val updated = candidate.coerceIn(0, 100)
        displayedValue = updated.toFloat()
        onValueChange?.invoke(updated)
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
                    .semantics { contentDescription = adjustmentSemantics },
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
