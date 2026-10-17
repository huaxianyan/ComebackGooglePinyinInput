package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.foundation.layout.padding
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource

data class SettingsTransferActions(
    val onExport: () -> Unit,
    val onImport: () -> Unit,
    val onConfirmImport: () -> Unit,
    val onDismissImport: () -> Unit,
    val onRecoveryShown: () -> Unit,
)

internal fun LazyListScope.settingsTransferItems(
    state: SettingsTransferState,
    actions: SettingsTransferActions,
    navigateTo: (SettingsRoute) -> Unit,
) {
    item {
        Text(stringResource(R.string.modern_settings_transfer_summary),
            modifier = Modifier.padding(horizontal = 24.dp, vertical = 12.dp))
    }
    item {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_transfer_export),
            enabled = !state.busy,
            onClick = actions.onExport,
        )
    }
    item {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_transfer_import),
            enabled = !state.busy,
            onClick = actions.onImport,
        )
    }
    state.message?.let { message ->
        item { Text(stringResource(message), modifier = Modifier.padding(horizontal = 24.dp)) }
    }
    item {
        SettingsNavigationRow(
            title = stringResource(R.string.modern_settings_transfer_recovery),
            supporting = stringResource(R.string.modern_settings_transfer_recovery_summary),
            onClick = { if (!state.busy) navigateTo(SettingsRoute.RestoreSetup) },
        )
    }
}

internal fun LazyListScope.restoreSetupItems(
    contactsRequested: Boolean,
    dictionary: DictionarySettingsSnapshot,
    rime: RimeSyncUiState,
    actions: SettingsActions,
) {
    if (contactsRequested) {
        item { SectionTitle(stringResource(R.string.modern_settings_dictionary_contacts_title)) }
        item {
            SettingsSwitchRow(
                title = stringResource(R.string.modern_settings_dictionary_contacts_title),
                supporting = stringResource(if (dictionary.contactsPermissionGranted)
                    R.string.modern_settings_dictionary_contacts_summary
                    else R.string.modern_settings_dictionary_contacts_permission_summary),
                checked = dictionary.contactSuggestionsEnabled,
                onCheckedChange = actions.onContactSuggestionsEnabledChange,
            )
        }
    }
    item { SectionTitle(stringResource(R.string.modern_settings_dictionary_backup_section)) }
    item {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_dictionary_location_title),
            supporting = dictionary.locationSummary,
            enabled = !dictionary.backupInProgress,
            onClick = actions.onChooseBackupLocation,
        )
    }
    item {
        SettingsSwitchRow(
            title = stringResource(R.string.modern_settings_dictionary_auto_backup_title),
            supporting = dictionary.automaticBackupSummary,
            checked = dictionary.automaticBackupEnabled,
            enabled = !dictionary.backupInProgress,
            onCheckedChange = actions.onAutomaticBackupEnabledChange,
        )
    }
    item {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_dictionary_import_title),
            supporting = stringResource(R.string.modern_settings_dictionary_import_choose_summary),
            enabled = !dictionary.backupInProgress && !dictionary.clearInProgress,
            onClick = actions.onImportBackup,
        )
    }
    // Reuse the actual settings rows and callbacks, including first-sync admission and all dialogs.
    rimeSyncSettingsItems(rime, dictionary.backupInProgress || dictionary.clearInProgress,
        actions.rimeSync, recoveryOrder = true)
}

@Composable
internal fun SettingsTransferDialog(state: SettingsTransferState, actions: SettingsTransferActions) {
    if (state.busy) {
        AlertDialog(
            onDismissRequest = {},
            title = { Text(stringResource(R.string.modern_settings_transfer_busy)) },
            text = { Text(stringResource(R.string.modern_settings_transfer_wait)) },
            confirmButton = {},
        )
    } else if (state.confirmImport) {
        AlertDialog(
            onDismissRequest = actions.onDismissImport,
            title = { Text(stringResource(R.string.modern_settings_transfer_import)) },
            text = { Text(stringResource(R.string.modern_settings_transfer_confirm)) },
            confirmButton = {
                TextButton(onClick = actions.onConfirmImport) {
                    Text(stringResource(R.string.modern_settings_transfer_import))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onDismissImport) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
    }
}
