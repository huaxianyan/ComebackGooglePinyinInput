package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.platform.LocalContext

enum class RimeSyncEditDialog { DeviceName, SnapshotFile }

data class RimeSyncUiState(
    val settings: RimeSyncSettingsSnapshot = RimeSyncSettingsSnapshot(),
    val automaticConfirmationVisible: Boolean = false,
    val editDialog: RimeSyncEditDialog? = null,
    val deviceDirectoryInput: String = "",
    val deviceNameInputValid: Boolean = true,
    val snapshotFileInput: String = "pinyin_simp.userdb.txt",
    val preview: RimeSyncPreview? = null,
    val resetConfirmationVisible: Boolean = false,
    val keepRejectedConfirmationVisible: Boolean = false,
)

data class RimeSyncActions(
    val onAutomaticChange: (Boolean) -> Unit,
    val onAutomaticConfirm: () -> Unit,
    val onAutomaticDismiss: () -> Unit,
    val onAutomaticIntervalChange: (Int) -> Unit,
    val onChooseRoot: () -> Unit,
    val onOpenDeviceName: () -> Unit,
    val onOpenSnapshotFile: () -> Unit,
    val onDeviceDirectoryInputChange: (String) -> Unit,
    val onSnapshotFileInputChange: (String) -> Unit,
    val onDismissEdit: () -> Unit,
    val onSaveDeviceName: () -> Unit,
    val onSaveSnapshotFile: () -> Unit,
    val onPreview: () -> Unit,
    val onDismissPreview: () -> Unit,
    val onConfirmSync: (Boolean) -> Unit,
    val onRecover: () -> Unit,
    val onOpenKeepRejectedConfirmation: () -> Unit,
    val onDismissKeepRejectedConfirmation: () -> Unit,
    val onConfirmKeepRejected: () -> Unit,
    val onOpenResetConfirmation: () -> Unit,
    val onDismissResetConfirmation: () -> Unit,
    val onConfirmReset: () -> Unit,
)

internal fun LazyListScope.rimeSyncSettingsItems(
    state: RimeSyncUiState,
    dictionaryOperationInProgress: Boolean,
    actions: RimeSyncActions,
) {
    val settings = state.settings
    item(key = "rime_sync_section", contentType = "section") {
        SectionTitle(stringResource(R.string.modern_settings_rime_sync_section))
    }
    settings.automatic?.let { auto ->
        val ready = settings.canEnableAutomatic
        item(key = "rime_sync_automatic", contentType = "switch") {
            SettingsSwitchRow(
                title = stringResource(R.string.modern_settings_rime_auto_title),
                supporting = stringResource(when {
                    auto.lastError != 0 && !auto.enabled -> R.string.modern_settings_rime_auto_paused
                    auto.lastError != 0 -> R.string.modern_settings_rime_auto_retry
                    !ready -> R.string.modern_settings_rime_auto_prerequisite
                    else -> R.string.modern_settings_rime_auto_summary
                }),
                checked = auto.enabled,
                enabled = auto.enabled || (ready && !settings.operationInProgress &&
                    !dictionaryOperationInProgress),
                onCheckedChange = actions.onAutomaticChange,
            )
        }
        item(key = "rime_sync_automatic_interval", contentType = "list") {
            val context = LocalContext.current
            val labels = auto.intervalOptions.map { hours ->
                if (hours > 24 && hours % 24 == 0) {
                    context.getString(R.string.modern_settings_rime_auto_days, hours / 24)
                } else {
                    context.getString(R.string.modern_settings_rime_auto_hours, hours)
                }
            }
            val selectedIndex = auto.intervalOptions.indexOf(auto.intervalHours)
            EnumeratedListSetting(
                title = stringResource(R.string.modern_settings_rime_auto_interval),
                selectedIndex = selectedIndex,
                selectedLabel = labels[selectedIndex],
                labels = labels,
                enabled = auto.enabled && !settings.operationInProgress && !dictionaryOperationInProgress,
                onSelect = { actions.onAutomaticIntervalChange(auto.intervalOptions[it]) },
            )
        }
    }
    item(key = "rime_sync_root", contentType = "action") {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_rime_sync_root_title),
            supporting = when {
                settings.rootUri.isEmpty() -> stringResource(
                    R.string.modern_settings_rime_sync_root_unset,
                )
                !settings.locationAccessible -> stringResource(
                    R.string.modern_settings_rime_sync_root_inaccessible,
                )
                settings.rootLabel.isNotEmpty() -> settings.rootLabel
                else -> stringResource(R.string.modern_settings_rime_sync_root_selected)
            },
            enabled = !settings.operationInProgress && !settings.recoveryRequired,
            onClick = actions.onChooseRoot,
        )
    }
    item(key = "rime_sync_device", contentType = "action") {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_rime_sync_device_title),
            supporting = settings.deviceDirectory.ifEmpty {
                stringResource(R.string.modern_settings_rime_sync_device_unset)
            },
            enabled = !settings.operationInProgress && !settings.recoveryRequired,
            onClick = actions.onOpenDeviceName,
        )
    }
    item(key = "rime_sync_file", contentType = "action") {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_rime_sync_file_title),
            supporting = settings.snapshotFile,
            enabled = !settings.operationInProgress && !settings.recoveryRequired,
            onClick = actions.onOpenSnapshotFile,
        )
    }
    item(key = "rime_sync_status", contentType = "action") {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_rime_sync_status_title),
            supporting = when {
                settings.operationInProgress -> stringResource(
                    R.string.modern_settings_rime_sync_in_progress,
                )
                settings.recoveryRequired && settings.nativeFailureRepeated &&
                    settings.nativeRejectedCount > 0 -> stringResource(
                        R.string.modern_settings_rime_sync_native_insert_stalled,
                        settings.nativeRejectedCount,
                    )
                settings.recoveryRequired && settings.nativeFailureRepeated &&
                    settings.hasNativePersistenceDiagnostics -> stringResource(
                        R.string.modern_settings_rime_sync_native_stalled,
                        settings.nativeActualCount,
                        settings.nativeExpectedCount,
                        settings.nativeMissingCount,
                    )
                settings.recoveryRequired && settings.nativeFailureRepeated -> stringResource(
                    R.string.modern_settings_rime_sync_native_stalled_generic,
                )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Io -> stringResource(
                        R.string.modern_settings_rime_sync_native_io_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Memory -> stringResource(
                        R.string.modern_settings_rime_sync_native_memory_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Runtime -> stringResource(
                        R.string.modern_settings_rime_sync_native_runtime_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Duplicate -> stringResource(
                        R.string.modern_settings_rime_sync_native_duplicate_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Insert -> stringResource(
                        R.string.modern_settings_rime_sync_native_insert_failure,
                        settings.nativeRejectedCount,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Persist -> stringResource(
                        R.string.modern_settings_rime_sync_native_persist_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Rebuild -> stringResource(
                        R.string.modern_settings_rime_sync_native_rebuild_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Export -> stringResource(
                        R.string.modern_settings_rime_sync_native_export_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Data -> stringResource(
                        R.string.modern_settings_rime_sync_native_data_failure,
                    )
                settings.recoveryRequired &&
                    settings.nativeFailureKind == NativeFailureKind.Stale -> stringResource(
                        R.string.modern_settings_rime_sync_native_stale_failure,
                    )
                settings.recoveryRequired && settings.hasNativePersistenceDiagnostics -> stringResource(
                    R.string.modern_settings_rime_sync_native_missing,
                    settings.nativeActualCount,
                    settings.nativeExpectedCount,
                    settings.nativeMissingCount,
                )
                settings.recoveryRequired -> stringResource(
                    R.string.modern_settings_rime_sync_recovery_required,
                )
                settings.lastSuccess > 0L -> stringResource(
                    R.string.modern_settings_rime_sync_completed,
                )
                else -> stringResource(R.string.modern_settings_rime_sync_not_run)
            },
            enabled = settings.recoveryRequired &&
                (!settings.nativeFailureRepeated || settings.nativeRejectedCount > 0) &&
                !settings.operationInProgress && !dictionaryOperationInProgress,
            onClick = if (settings.nativeFailureRepeated && settings.nativeRejectedCount > 0) {
                actions.onOpenKeepRejectedConfirmation
            } else {
                actions.onRecover
            },
        )
    }
    item(key = "rime_sync_now", contentType = "action") {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_rime_sync_now_title),
            supporting = stringResource(R.string.modern_settings_rime_sync_now_summary),
            enabled = settings.configurationComplete && settings.locationAccessible &&
                !settings.operationInProgress && !settings.recoveryRequired &&
                !dictionaryOperationInProgress,
            onClick = actions.onPreview,
        )
    }
    item(key = "rime_sync_reset", contentType = "action") {
        SettingsActionRow(
            title = stringResource(R.string.modern_settings_rime_sync_reset_title),
            supporting = stringResource(R.string.modern_settings_rime_sync_reset_summary),
            enabled = settings.configurationComplete && !settings.operationInProgress &&
                !settings.recoveryRequired,
            onClick = actions.onOpenResetConfirmation,
        )
    }
}

@Composable
internal fun RimeSyncDialogs(state: RimeSyncUiState, actions: RimeSyncActions) {
    if (state.automaticConfirmationVisible) {
        AlertDialog(
            onDismissRequest = actions.onAutomaticDismiss,
            title = { Text(stringResource(R.string.modern_settings_rime_auto_title)) },
            text = { Text(stringResource(R.string.modern_settings_rime_auto_consent)) },
            confirmButton = {
                TextButton(onClick = actions.onAutomaticConfirm) {
                    Text(stringResource(R.string.modern_settings_rime_auto_enable))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onAutomaticDismiss) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
    }
    state.editDialog?.let { dialog ->
        val editingDeviceName = dialog == RimeSyncEditDialog.DeviceName
        AlertDialog(
            onDismissRequest = actions.onDismissEdit,
            title = {
                Text(stringResource(
                    if (editingDeviceName) R.string.modern_settings_rime_sync_device_title
                    else R.string.modern_settings_rime_sync_file_title,
                ))
            },
            text = {
                OutlinedTextField(
                    value = if (editingDeviceName) {
                        state.deviceDirectoryInput
                    } else {
                        state.snapshotFileInput
                    },
                    onValueChange = if (editingDeviceName) {
                        actions.onDeviceDirectoryInputChange
                    } else {
                        actions.onSnapshotFileInputChange
                    },
                    modifier = Modifier.fillMaxWidth(),
                    label = {
                        Text(stringResource(
                            if (editingDeviceName) R.string.modern_settings_rime_sync_device_title
                            else R.string.modern_settings_rime_sync_file_title,
                        ))
                    },
                    supportingText = if (editingDeviceName &&
                        state.deviceDirectoryInput.isNotEmpty() &&
                        !state.deviceNameInputValid
                    ) {
                        {
                            Text(stringResource(
                                R.string.modern_settings_rime_sync_device_invalid,
                            ))
                        }
                    } else {
                        null
                    },
                    isError = editingDeviceName && state.deviceDirectoryInput.isNotEmpty() &&
                        !state.deviceNameInputValid,
                    singleLine = true,
                )
            },
            confirmButton = {
                TextButton(
                    onClick = if (editingDeviceName) {
                        actions.onSaveDeviceName
                    } else {
                        actions.onSaveSnapshotFile
                    },
                    enabled = if (editingDeviceName) {
                        state.deviceDirectoryInput.isNotEmpty() && state.deviceNameInputValid
                    } else {
                        state.snapshotFileInput.isNotEmpty()
                    },
                ) {
                    Text(stringResource(R.string.modern_settings_apply))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onDismissEdit) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
    }
    state.preview?.let { preview ->
        AlertDialog(
            onDismissRequest = actions.onDismissPreview,
            title = { Text(stringResource(R.string.modern_settings_rime_sync_preview_title)) },
            text = {
                Text(stringResource(
                    R.string.modern_settings_rime_sync_preview_message,
                    preview.googleAdditionCount,
                    preview.googleDeletionCount,
                    preview.rimeAdditionCount,
                    preview.rimeDeletionCount,
                    preview.rimeResurrectionCount,
                ))
            },
            confirmButton = {
                TextButton(onClick = {
                    actions.onConfirmSync(preview.requiresDeletionConfirmation)
                }) {
                    Text(stringResource(
                        if (preview.requiresDeletionConfirmation) {
                            R.string.modern_settings_rime_sync_confirm_deletions
                        } else {
                            R.string.modern_settings_rime_sync_confirm
                        },
                    ))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onDismissPreview) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
    }
    if (state.keepRejectedConfirmationVisible) {
        AlertDialog(
            onDismissRequest = actions.onDismissKeepRejectedConfirmation,
            title = {
                Text(stringResource(
                    R.string.modern_settings_rime_sync_keep_rejected_confirm_title,
                ))
            },
            text = {
                Text(stringResource(
                    R.string.modern_settings_rime_sync_keep_rejected_confirm_message,
                    state.settings.nativeRejectedCount,
                ))
            },
            confirmButton = {
                TextButton(onClick = actions.onConfirmKeepRejected) {
                    Text(stringResource(
                        R.string.modern_settings_rime_sync_keep_rejected_action,
                    ))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onDismissKeepRejectedConfirmation) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
    }
    if (state.resetConfirmationVisible) {
        AlertDialog(
            onDismissRequest = actions.onDismissResetConfirmation,
            title = { Text(stringResource(R.string.modern_settings_rime_sync_reset_confirm_title)) },
            text = { Text(stringResource(R.string.modern_settings_rime_sync_reset_confirm_message)) },
            confirmButton = {
                TextButton(onClick = actions.onConfirmReset) {
                    Text(stringResource(R.string.modern_settings_rime_sync_reset_action))
                }
            },
            dismissButton = {
                TextButton(onClick = actions.onDismissResetConfirmation) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
            },
        )
    }
}
