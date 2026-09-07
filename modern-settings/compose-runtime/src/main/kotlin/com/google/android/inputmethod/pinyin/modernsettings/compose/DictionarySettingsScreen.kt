package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.clickable
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.shrinkVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedButton
import androidx.compose.ui.draw.rotate
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.graphics.luminance
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp

internal fun LazyListScope.dictionarySettingsItems(
    snapshot: DictionarySettingsSnapshot,
    health: DictionaryHealthState,
    actions: SettingsActions,
    rime: RimeSyncSettingsSnapshot,
) {
    item(key = "dictionary_health", contentType = "status") {
        DictionaryHealthRow(health, snapshot, rime, actions.onRefreshDictionaryHealth)
    }
    item(key = "dictionary_personalization_section", contentType = "section") {
        SectionTitle(stringResource(R.string.modern_settings_dictionary_personalization_section))
    }
    item(key = "dictionary_contact_suggestions", contentType = "switch") {
        SettingsSwitchRow(
            title = legacyString(
                "setting_import_user_contacts_title",
                R.string.modern_settings_dictionary_contacts_title,
            ),
            supporting = stringResource(
                if (snapshot.contactsPermissionGranted) {
                    R.string.modern_settings_dictionary_contacts_summary
                } else {
                    R.string.modern_settings_dictionary_contacts_permission_summary
                },
            ),
            checked = snapshot.contactSuggestionsEnabled,
            onCheckedChange = actions.onContactSuggestionsEnabledChange,
        )
    }
    item(key = "dictionary_clear", contentType = "action") {
        SettingsActionRow(
            title = legacyString(
                "setting_sync_clear_title",
                R.string.modern_settings_dictionary_clear_title,
            ),
            supporting = stringResource(
                if (snapshot.clearInProgress) {
                    R.string.modern_settings_dictionary_clear_in_progress
                } else {
                    R.string.modern_settings_dictionary_clear_summary
                },
            ),
            enabled = !snapshot.clearInProgress && !snapshot.backupInProgress,
            onClick = actions.onOpenClearDictionaryConfirmation,
        )
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
}

internal fun LazyListScope.dictionaryShortcutSettingsItems(
    snapshot: DictionarySettingsSnapshot,
    actions: SettingsActions,
) {
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
}

@Composable
internal fun DictionaryClearDialog(
    state: DictionaryClearState,
    actions: SettingsActions,
) {
    if (!state.confirmationVisible) return
    AlertDialog(
        onDismissRequest = actions.onDismissClearDictionaryConfirmation,
        title = { Text(stringResource(R.string.modern_settings_dictionary_clear_confirm_title)) },
        text = {
            androidx.compose.foundation.layout.Column {
                Text(
                    stringResource(
                        R.string.modern_settings_dictionary_clear_confirm_message,
                        state.challenge,
                    ),
                )
                OutlinedTextField(
                    value = state.input,
                    onValueChange = actions.onClearDictionaryInputChange,
                    modifier = Modifier.fillMaxWidth().padding(top = 16.dp),
                    label = {
                        Text(stringResource(R.string.modern_settings_dictionary_clear_code_label))
                    },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                )
            }
        },
        confirmButton = {
            TextButton(
                onClick = actions.onConfirmClearDictionary,
                enabled = DictionaryClearStateReducer.canConfirm(state),
            ) {
                Text(stringResource(R.string.modern_settings_dictionary_clear_action))
            }
        },
        dismissButton = {
            TextButton(onClick = actions.onDismissClearDictionaryConfirmation) {
                Text(stringResource(R.string.modern_settings_cancel))
            }
        },
    )
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
    dictionary: DictionarySettingsSnapshot,
    rime: RimeSyncSettingsSnapshot,
    onRefresh: () -> Unit,
) {
    var expanded by rememberSaveable { mutableStateOf(false) }
    val dark = MaterialTheme.colorScheme.surface.luminance() < 0.5f
    val color by animateColorAsState(
        targetValue = when {
            state.loading || state.tone == DictionaryHealthTone.Unknown -> MaterialTheme.colorScheme.outline
            state.tone == DictionaryHealthTone.Healthy -> if (dark) Color(0xFF81C784) else Color(0xFF2E7D32)
            state.tone == DictionaryHealthTone.Notice -> if (dark) Color(0xFFFFD54F) else Color(0xFF8D6500)
            else -> MaterialTheme.colorScheme.error
        },
        label = "dictionary health indicator",
    )
    LaunchedEffect(state.summary, state.loading) {
        if (state.summary.isEmpty() && !state.loading) onRefresh()
    }
    val statusLabel = stringResource(when {
        state.summary.isEmpty() -> R.string.modern_settings_dictionary_health_loading
        state.tone == DictionaryHealthTone.Healthy -> R.string.modern_settings_health_readable
        state.tone == DictionaryHealthTone.Notice -> R.string.modern_settings_health_notice
        else -> R.string.modern_settings_health_unconfirmed
    })
    val detailsEnter = expandVertically() + fadeIn()
    val detailsExit = shrinkVertically() + fadeOut()
    val expansionRotation by animateFloatAsState(
        targetValue = if (expanded) 180f else 0f,
        label = "dictionary details expansion",
    )
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
            Column(Modifier.padding(start = 8.dp)) {
                // Only this status line contains an indicator; all other text keeps the page inset.
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    Box(Modifier.size(10.dp).background(color, CircleShape))
                    Text(statusLabel)
                }
                // Retain the previous result while checking so the surrounding list does not jump.
                if (state.summary.isNotEmpty()) Text(state.summary)
                AnimatedVisibility(
                    visible = expanded && state.details.isNotEmpty(),
                    enter = detailsEnter,
                    exit = detailsExit,
                ) {
                    Text(state.details, modifier = Modifier.padding(top = 8.dp))
                }
                if (dictionary.automaticBackupEnabled) {
                    Text(stringResource(R.string.modern_settings_dictionary_auto_backup_title),
                        modifier = Modifier.padding(top = 12.dp),
                        style = MaterialTheme.typography.titleSmall)
                    Text(dictionary.automaticBackupSummary)
                }
                // Collapsed summaries follow enabled automation; manual sync details remain expandable.
                AnimatedVisibility(
                    visible = rime.configurationComplete && (expanded || rime.automatic?.enabled == true),
                    enter = detailsEnter,
                    exit = detailsExit,
                ) {
                    Column {
                        Text(stringResource(R.string.modern_settings_rime_sync_section),
                            modifier = Modifier.padding(top = 12.dp),
                            style = MaterialTheme.typography.titleSmall)
                        Text(rimeStatusText(rime))
                        AnimatedVisibility(
                            visible = expanded,
                            enter = detailsEnter,
                            exit = detailsExit,
                        ) {
                            Column {
                                Text(stringResource(if (rime.automatic?.enabled == true)
                                    R.string.modern_settings_rime_health_auto_on
                                    else R.string.modern_settings_rime_health_auto_off))
                                if (rime.lastSuccess > 0L) {
                                    Text(stringResource(R.string.modern_settings_rime_health_counts,
                                        rime.sharedEntryCount, rime.rimeOnlyCount))
                                }
                            }
                        }
                    }
                }
                FlowRow(
                    modifier = Modifier.padding(top = 8.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    OutlinedButton(
                        onClick = { expanded = !expanded },
                        enabled = state.details.isNotEmpty() || rime.configurationComplete,
                    ) {
                        Text(stringResource(if (expanded) R.string.modern_settings_health_hide_details
                            else R.string.modern_settings_health_details))
                        Icon(Icons.Default.KeyboardArrowDown, contentDescription = null,
                            modifier = Modifier.padding(start = 4.dp).rotate(expansionRotation))
                    }
                    OutlinedButton(onClick = onRefresh, enabled = !state.loading) {
                        Box(Modifier.padding(end = 4.dp).size(24.dp),
                            contentAlignment = Alignment.Center) {
                            if (state.loading) {
                                CircularProgressIndicator(modifier = Modifier.size(24.dp),
                                    strokeWidth = 2.dp)
                            } else {
                                Icon(Icons.Default.Refresh, contentDescription = null)
                            }
                        }
                        Text(stringResource(R.string.modern_settings_dictionary_health_refresh))
                    }
                }
            }
        },
    )
}
