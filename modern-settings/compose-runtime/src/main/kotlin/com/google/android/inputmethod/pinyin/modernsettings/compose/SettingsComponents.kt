package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.activity.compose.BackHandler
import androidx.annotation.StringRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
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
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

@Composable
internal fun SettingsNavigationRow(
    title: String,
    supporting: String? = null,
    enabled: Boolean = true,
    onClick: () -> Unit,
) {
    val color = if (enabled) MaterialTheme.colorScheme.onSurface
    else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
    ListItem(
        headlineContent = {
            Text(
                title,
                modifier = Modifier.padding(start = 8.dp),
                color = color,
            )
        },
        supportingContent = supporting?.let { supportingText ->
            {
                Text(
                    supportingText,
                    modifier = Modifier.padding(start = 8.dp),
                    color = if (enabled) MaterialTheme.colorScheme.onSurfaceVariant
                    else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f),
                )
            }
        },
        trailingContent = {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.KeyboardArrowRight,
                contentDescription = null,
                modifier = Modifier.padding(end = 8.dp),
                tint = color,
            )
        },
        modifier = Modifier.clickable(enabled = enabled, onClick = onClick),
    )
}

@Composable
internal fun LongPressDelaySetting(
    title: String,
    state: DefaultableSetting<Int>,
    millisecondsText: (Int) -> String,
    onCommit: (Int) -> Unit,
    onRestoreDefault: () -> Unit,
) {
    val milliseconds = when (state) {
        is DefaultableSetting.Default -> state.value
        is DefaultableSetting.Explicit -> state.value
    }
    Column {
        DiscreteSettingsSlider(
            title = title,
            value = SliderSettingContracts.longPressProgress(milliseconds).toFloat(),
            valueText = millisecondsText(milliseconds),
            valueTextForIndex = { progress ->
                millisecondsText(SliderSettingContracts.longPressMilliseconds(progress))
            },
            maximumIndex = 60,
            editable = true,
            onValueCommit = { progress ->
                onCommit(SliderSettingContracts.longPressMilliseconds(progress))
            },
        )
        OutlinedButton(
            onClick = onRestoreDefault,
            enabled = state is DefaultableSetting.Explicit,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp),
        ) {
            Text(stringResource(R.string.modern_settings_use_default))
        }
    }
}

internal fun handwritingTimeoutText(
    index: Int,
    labels: List<String>,
    millisecondsText: (Int) -> String,
): String = labels[index] + " · " + millisecondsText(
    SliderSettingContracts.handwritingTimeout.valueAt(index).toInt()
)

internal fun handwritingStrokeWidthText(index: Int, labels: List<String>): String =
    labels[index] + " · " + SliderSettingContracts.handwritingStrokeWidth.valueAt(index)

@Composable
internal fun legacyString(name: String, @StringRes fallback: Int): String {
    val context = LocalContext.current
    val id = context.resources.getIdentifier(name, "string", context.packageName)
    return if (id != 0) context.getString(id) else stringResource(fallback)
}

@Composable
internal fun SectionTitle(title: String) {
    Text(
        text = title,
        modifier = Modifier.padding(horizontal = 24.dp, vertical = 8.dp),
        color = MaterialTheme.colorScheme.primary,
        fontWeight = FontWeight.Medium,
        style = MaterialTheme.typography.labelLarge,
    )
}

@Composable
internal fun EnumeratedListSetting(
    title: String,
    selectedIndex: Int,
    selectedLabel: String,
    labels: List<String>,
    onSelect: (Int) -> Unit,
) {
    require(selectedIndex in labels.indices)
    var dialogVisible by rememberSaveable { mutableStateOf(false) }

    ListItem(
        headlineContent = {
            Text(title, modifier = Modifier.padding(start = 8.dp))
        },
        supportingContent = {
            Text(selectedLabel, modifier = Modifier.padding(start = 8.dp))
        },
        modifier = Modifier.clickable { dialogVisible = true },
    )

    if (dialogVisible) {
        AlertDialog(
            onDismissRequest = { dialogVisible = false },
            title = { Text(title) },
            text = {
                Column(
                    modifier = Modifier
                        .heightIn(max = 480.dp)
                        .verticalScroll(rememberScrollState())
                        .selectableGroup(),
                ) {
                    labels.forEachIndexed { index, label ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .selectable(
                                    selected = index == selectedIndex,
                                    onClick = {
                                        if (index != selectedIndex) onSelect(index)
                                        dialogVisible = false
                                    },
                                    role = Role.RadioButton,
                                )
                                .padding(horizontal = 8.dp, vertical = 12.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            RadioButton(
                                selected = index == selectedIndex,
                                onClick = null,
                            )
                            Text(
                                text = label,
                                modifier = Modifier.padding(start = 12.dp),
                            )
                        }
                    }
                }
            },
            confirmButton = {},
            dismissButton = {
                TextButton(onClick = { dialogVisible = false }) {
                    Text(stringResource(android.R.string.cancel))
                }
            },
        )
    }
}

@Composable
internal fun SettingsSwitchRow(
    title: String,
    supporting: String? = null,
    checked: Boolean,
    enabled: Boolean = true,
    accessibilityDescription: String? = null,
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
            Text(
                title,
                color = if (enabled) MaterialTheme.colorScheme.onSurface
                else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                style = MaterialTheme.typography.bodyLarge,
            )
            supporting?.let {
                Text(
                    it,
                    color = if (enabled) MaterialTheme.colorScheme.onSurfaceVariant
                    else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
        Switch(
            checked = checked,
            enabled = enabled,
            onCheckedChange = onCheckedChange,
            modifier = if (accessibilityDescription == null) Modifier else {
                Modifier.semantics {
                    contentDescription = accessibilityDescription
                }
            },
        )
    }
}

@Composable
internal fun DiscreteSettingsSlider(
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
    val semanticsText = stringResource(
        if (interactionEnabled) R.string.modern_settings_value_adjustable
        else R.string.modern_settings_value_read_only,
        title,
        displayedValueText,
    )
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
                .semantics { contentDescription = semanticsText },
        )
    }
}
