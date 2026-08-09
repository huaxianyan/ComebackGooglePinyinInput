package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
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

private val adjustmentStateSaver = listSaver<AdjustmentInteractionState, Int>(
    save = { state ->
        val persistedValue = when (val persisted = state.persisted) {
            AdjustmentEditorState.SystemDefault -> -1
            is AdjustmentEditorState.Explicit -> persisted.value
        }
        listOf(persistedValue, state.displayedValue, if (state.touched) 1 else 0)
    },
    restore = { saved ->
        AdjustmentInteractionState(
            persisted = if (saved[0] < 0) {
                AdjustmentEditorState.SystemDefault
            } else {
                AdjustmentEditorState.Explicit(saved[0])
            },
            displayedValue = saved[1],
            touched = saved[2] != 0,
        )
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

/**
 * An always-visible adjustment that keeps key absence distinct from explicit zero.
 * Dragging is transient; release commits once and triggers the caller's one-shot preview.
 */
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
    val resolvedKey = when (val persisted = resolvedState.persisted) {
        AdjustmentEditorState.SystemDefault -> "default"
        is AdjustmentEditorState.Explicit -> "explicit:${persisted.value}"
    }
    var interaction by rememberSaveable(title, resolvedKey, stateSaver = adjustmentStateSaver) {
        mutableStateOf(resolvedState)
    }
    val enabled = AdjustmentStateReducer.isInteractive(enabledByDependency)
    val showsSystemDefault =
        interaction.persisted is AdjustmentEditorState.SystemDefault && !interaction.touched
    val summary = if (showsSystemDefault) {
        stringResource(R.string.modern_settings_system_default)
    } else {
        valueText(interaction.displayedValue)
    }

    fun update(value: Int) {
        interaction = AdjustmentStateReducer.update(interaction, value)
    }

    fun commitTouchedValue() {
        if (!interaction.touched) return
        val committed = AdjustmentStateReducer.commit(interaction)
        interaction = committed
        onCommit(committed.displayedValue)
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
            summary,
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
                    update((interaction.displayedValue - 1).coerceAtLeast(0))
                    commitTouchedValue()
                },
                enabled = enabled,
                modifier = Modifier.semantics { contentDescription = decreaseDescription },
            ) {
                Text("−")
            }
            val adjustmentDescription = stringResource(
                R.string.modern_settings_value_adjustable,
                title,
                summary,
            )
            Slider(
                value = interaction.displayedValue.toFloat(),
                onValueChange = { update(it.roundToInt()) },
                onValueChangeFinished = ::commitTouchedValue,
                valueRange = 0f..100f,
                steps = 99,
                enabled = enabled,
                modifier = Modifier
                    .weight(1f)
                    .semantics { contentDescription = adjustmentDescription },
            )
            TextButton(
                onClick = {
                    update((interaction.displayedValue + 1).coerceAtMost(100))
                    commitTouchedValue()
                },
                enabled = enabled,
                modifier = Modifier.semantics { contentDescription = increaseDescription },
            ) {
                Text("+")
            }
        }
        OutlinedButton(
            onClick = {
                interaction = AdjustmentStateReducer.restoreDefault(interaction)
                onRestoreDefault()
            },
            enabled = enabled && AdjustmentStateReducer.canRestoreDefault(interaction),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Text(stringResource(R.string.modern_settings_use_system_default))
        }
    }
}
