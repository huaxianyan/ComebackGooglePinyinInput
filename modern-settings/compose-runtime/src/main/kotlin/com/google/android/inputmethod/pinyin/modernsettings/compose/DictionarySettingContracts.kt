package com.google.android.inputmethod.pinyin.modernsettings.compose

internal object DictionarySettingContracts {
    const val preferencesName = "dictionary_local_backup_preferences"
    const val enabledKey = "dictionary_auto_backup_enabled"
    const val treeUriKey = "dictionary_auto_backup_tree_uri"
    const val treeLabelKey = "dictionary_auto_backup_tree_label"
    const val intervalKey = "dictionary_auto_backup_interval_days"
    const val retentionKey = "dictionary_auto_backup_retention_count"
    const val lastSuccessKey = "dictionary_auto_backup_last_success_time"
    const val lastStatusKey = "dictionary_auto_backup_last_status"

    val intervalValues = listOf(1, 3, 7, 14, 30)
    val retentionValues = listOf(3, 5, 10, 20, 30)

    fun intervalIndex(value: Int): Int = intervalValues.indexOf(value).takeIf { it >= 0 }
        ?: intervalValues.indexOf(7)

    fun retentionIndex(value: Int): Int = retentionValues.indexOf(value).takeIf { it >= 0 }
        ?: retentionValues.indexOf(10)
}

data class DictionaryHealthState(
    val summary: String = "",
    val loading: Boolean = false,
)

internal object DictionaryHealthStateReducer {
    fun start(state: DictionaryHealthState): DictionaryHealthState =
        if (state.loading) state else state.copy(loading = true)

    fun complete(state: DictionaryHealthState, summary: String): DictionaryHealthState =
        state.copy(summary = summary, loading = false)
}

data class DictionarySettingsSnapshot(
    val automaticBackupEnabled: Boolean,
    val locationAccessible: Boolean,
    val locationSummary: String,
    val intervalIndex: Int,
    val intervalLabels: List<String>,
    val retentionIndex: Int,
    val retentionLabels: List<String>,
    val backupInProgress: Boolean,
    val automaticBackupSummary: String,
    val shortcutsEnabled: BooleanSettingState,
)
