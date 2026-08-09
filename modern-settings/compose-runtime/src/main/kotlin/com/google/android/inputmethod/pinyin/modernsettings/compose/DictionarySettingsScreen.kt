package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp

internal fun LazyListScope.dictionarySettingsItems(
    snapshot: DictionarySettingsSnapshot,
    health: DictionaryHealthState,
    actions: SettingsActions,
) {
    item(key = "dictionary_health", contentType = "status") {
        DictionaryHealthRow(health, actions.onRefreshDictionaryHealth)
    }
    item(key = "dictionary_backup_section", contentType = "section") {
        SectionTitle(stringResource(R.string.modern_settings_dictionary_backup_section))
    }
    item(key = "dictionary_backup_enabled", contentType = "switch") {
        SettingsSwitchRow(
            title = legacyString(
                "dictionary_auto_backup_title",
                R.string.modern_settings_dictionary_auto_backup_title,
            ),
            supporting = snapshot.automaticBackupSummary,
            checked = snapshot.automaticBackupEnabled,
            enabled = !snapshot.backupInProgress,
            onCheckedChange = actions.onAutomaticBackupEnabledChange,
        )
    }
    item(key = "dictionary_backup_location", contentType = "action") {
        SettingsActionRow(
            title = legacyString(
                "dictionary_auto_backup_location_title",
                R.string.modern_settings_dictionary_location_title,
            ),
            supporting = snapshot.locationSummary,
            enabled = !snapshot.backupInProgress,
            onClick = actions.onChooseBackupLocation,
        )
    }
    item(key = "dictionary_backup_interval", contentType = "list") {
        EnumeratedListSetting(
            title = legacyString(
                "dictionary_auto_backup_interval_title",
                R.string.modern_settings_dictionary_interval_title,
            ),
            selectedIndex = snapshot.intervalIndex,
            selectedLabel = snapshot.intervalLabels[snapshot.intervalIndex],
            labels = snapshot.intervalLabels,
            enabled = snapshot.automaticBackupEnabled && snapshot.locationAccessible &&
                !snapshot.backupInProgress,
            onSelect = actions.onBackupIntervalChange,
        )
    }
    item(key = "dictionary_backup_retention", contentType = "list") {
        EnumeratedListSetting(
            title = legacyString(
                "dictionary_auto_backup_retention_title",
                R.string.modern_settings_dictionary_retention_title,
            ),
            selectedIndex = snapshot.retentionIndex,
            selectedLabel = snapshot.retentionLabels[snapshot.retentionIndex],
            labels = snapshot.retentionLabels,
            enabled = snapshot.automaticBackupEnabled && snapshot.locationAccessible &&
                !snapshot.backupInProgress,
            onSelect = actions.onBackupRetentionChange,
        )
    }
    item(key = "dictionary_backup_now", contentType = "action") {
        SettingsActionRow(
            title = legacyString(
                "dictionary_auto_backup_now_title",
                R.string.modern_settings_dictionary_backup_now_title,
            ),
            supporting = stringResource(
                if (snapshot.locationAccessible) R.string.modern_settings_dictionary_backup_now_summary
                else R.string.modern_settings_dictionary_location_required,
            ),
            enabled = snapshot.locationAccessible && !snapshot.backupInProgress,
            onClick = actions.onBackupNow,
        )
    }
    item(key = "dictionary_backup_import", contentType = "action") {
        SettingsActionRow(
            title = legacyString(
                "dictionary_auto_backup_import_title",
                R.string.modern_settings_dictionary_import_title,
            ),
            supporting = stringResource(
                if (snapshot.locationAccessible) R.string.modern_settings_dictionary_import_summary
                else R.string.modern_settings_dictionary_import_choose_summary,
            ),
            enabled = !snapshot.backupInProgress,
            onClick = actions.onImportBackup,
        )
    }
    item(key = "dictionary_backup_privacy", contentType = "text") {
        Text(
            text = legacyString(
                "dictionary_auto_backup_privacy_summary",
                R.string.modern_settings_dictionary_privacy_summary,
            ),
            modifier = Modifier.padding(horizontal = 24.dp, vertical = 12.dp),
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            style = MaterialTheme.typography.bodyMedium,
        )
    }
    item(key = "dictionary_shortcuts_section", contentType = "section") {
        SectionTitle(
            legacyString(
                "setting_shortcuts_dictionary_category_title",
                R.string.modern_settings_dictionary_shortcuts_section,
            ),
        )
    }
    item(key = "dictionary_shortcuts_enabled", contentType = "switch") {
        SettingsSwitchRow(
            title = legacyString(
                "setting_enable_shortcuts_dictionary_title",
                R.string.modern_settings_dictionary_enable_shortcuts,
            ),
            checked = snapshot.shortcutsEnabled.value,
            onCheckedChange = actions.onShortcutsEnabledChange,
        )
    }
    item(key = "dictionary_shortcuts_editor", contentType = "action") {
        SettingsActionRow(
            title = legacyString(
                "setting_edit_shortcuts_dictionary_title",
                R.string.modern_settings_dictionary_edit_shortcuts,
            ),
            supporting = stringResource(R.string.modern_settings_dictionary_system_editor_summary),
            enabled = snapshot.shortcutsEnabled.value,
            onClick = actions.onOpenShortcutEditor,
        )
    }
    item(key = "dictionary_legacy_section", contentType = "section") {
        SectionTitle(stringResource(R.string.modern_settings_dictionary_legacy_operations_section))
    }
    item(key = "dictionary_legacy_operations", contentType = "navigation") {
        SettingsNavigationRow(
            title = stringResource(R.string.modern_settings_dictionary_legacy_operations_title),
            supporting = stringResource(R.string.modern_settings_dictionary_legacy_operations_summary),
            onClick = actions.onOpenLegacyDictionaryOperations,
        )
    }
}

@Composable
internal fun DictionaryImportDialog(
    state: DictionaryImportState,
    actions: SettingsActions,
) {
    if (!state.visible) return
    val selected = state.selected
    if (selected != null) {
        AlertDialog(
            onDismissRequest = actions.onCancelImportConfirmation,
            title = { Text(stringResource(R.string.modern_settings_dictionary_import_confirm_title)) },
            text = {
                Text(
                    stringResource(
                        R.string.modern_settings_dictionary_import_confirm_message,
                        selected.name,
                    ),
                )
            },
            confirmButton = {
                TextButton(onClick = actions.onConfirmImportBackup) {
                    Text(stringResource(R.string.modern_settings_dictionary_import_action))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onCancelImportConfirmation) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
        return
    }
    AlertDialog(
        onDismissRequest = actions.onDismissImportBackup,
        title = { Text(stringResource(R.string.modern_settings_dictionary_import_list_title)) },
        text = {
            when {
                state.loading -> Box(
                    modifier = Modifier.fillMaxWidth().heightIn(min = 96.dp),
                    contentAlignment = Alignment.Center,
                ) {
                    CircularProgressIndicator()
                }
                state.entries.isEmpty() -> Text(
                    stringResource(R.string.modern_settings_dictionary_import_empty),
                )
                else -> LazyColumn(
                    modifier = Modifier.fillMaxWidth().heightIn(max = 420.dp),
                ) {
                    items(
                        items = state.entries,
                        key = { it.uri },
                    ) { entry ->
                        ListItem(
                            headlineContent = { Text(entry.name) },
                            modifier = Modifier.clickable {
                                actions.onSelectImportBackup(entry)
                            },
                            colors = ListItemDefaults.colors(containerColor = Color.Transparent),
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = actions.onDismissImportBackup) {
                Text(stringResource(R.string.modern_settings_cancel))
            }
        },
    )
}

@Composable
private fun DictionaryHealthRow(
    state: DictionaryHealthState,
    onRefresh: () -> Unit,
) {
    LaunchedEffect(state.summary, state.loading) {
        if (state.summary.isEmpty() && !state.loading) onRefresh()
    }
    val supporting = when {
        state.summary.isEmpty() -> stringResource(
            R.string.modern_settings_dictionary_health_loading,
        )
        state.loading -> state.summary + "\n" + stringResource(
            R.string.modern_settings_dictionary_health_loading,
        )
        else -> state.summary + "\n" + stringResource(
            R.string.modern_settings_dictionary_health_refresh,
        )
    }
    ListItem(
        headlineContent = {
            Text(
                legacyString(
                    "dictionary_current_status_title",
                    R.string.modern_settings_dictionary_health_title,
                ),
                modifier = Modifier.padding(start = 8.dp),
            )
        },
        supportingContent = {
            Text(
                supporting,
                modifier = Modifier.padding(start = 8.dp),
            )
        },
        modifier = Modifier.clickable(enabled = !state.loading, onClick = onRefresh),
    )
}
