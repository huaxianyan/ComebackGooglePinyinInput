package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp

internal fun LazyListScope.dictionarySettingsItems(
    snapshot: DictionarySettingsSnapshot,
    actions: SettingsActions,
) {
    item {
        DictionaryHealthRow(actions.onLoadDictionaryHealth)
    }
    item {
        SectionTitle(stringResource(R.string.modern_settings_dictionary_backup_section))
    }
    item {
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
    item {
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
    item {
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
    item {
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
    item {
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
    item {
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
    item {
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
    item {
        SectionTitle(
            legacyString(
                "setting_shortcuts_dictionary_category_title",
                R.string.modern_settings_dictionary_shortcuts_section,
            ),
        )
    }
    item {
        SettingsSwitchRow(
            title = legacyString(
                "setting_enable_shortcuts_dictionary_title",
                R.string.modern_settings_dictionary_enable_shortcuts,
            ),
            checked = snapshot.shortcutsEnabled.value,
            onCheckedChange = actions.onShortcutsEnabledChange,
        )
    }
    item {
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
    item {
        SectionTitle(stringResource(R.string.modern_settings_dictionary_legacy_operations_section))
    }
    item {
        SettingsNavigationRow(
            title = stringResource(R.string.modern_settings_dictionary_legacy_operations_title),
            supporting = stringResource(R.string.modern_settings_dictionary_legacy_operations_summary),
            onClick = actions.onOpenLegacyDictionaryOperations,
        )
    }
}

@Composable
private fun DictionaryHealthRow(load: ((String) -> Unit) -> Unit) {
    var loading by rememberSaveable { mutableStateOf(true) }
    var summary by rememberSaveable {
        mutableStateOf("")
    }
    val refresh = {
        if (!loading || summary.isEmpty()) {
            loading = true
            load { result ->
                summary = result
                loading = false
            }
        }
    }
    LaunchedEffect(Unit) { refresh() }
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
                if (loading) stringResource(R.string.modern_settings_dictionary_health_loading)
                else summary + "\n" + stringResource(R.string.modern_settings_dictionary_health_refresh),
                modifier = Modifier.padding(start = 8.dp),
            )
        },
        modifier = Modifier.clickable(enabled = !loading, onClick = refresh),
    )
}
