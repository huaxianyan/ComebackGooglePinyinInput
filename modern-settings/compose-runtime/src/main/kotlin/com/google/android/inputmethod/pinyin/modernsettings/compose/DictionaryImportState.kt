package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Display metadata only. The URI remains opaque and is never rendered or logged. */
data class DictionaryImportEntry(
    val name: String,
    internal val uri: String,
)

data class DictionaryImportState(
    val visible: Boolean = false,
    val loading: Boolean = false,
    val entries: List<DictionaryImportEntry> = emptyList(),
    val selected: DictionaryImportEntry? = null,
)

internal object DictionaryImportStateReducer {
    fun open(): DictionaryImportState = DictionaryImportState(visible = true, loading = true)

    fun loaded(entries: List<DictionaryImportEntry>): DictionaryImportState =
        DictionaryImportState(visible = true, entries = entries)

    fun select(
        state: DictionaryImportState,
        entry: DictionaryImportEntry,
    ): DictionaryImportState {
        require(state.visible && !state.loading && entry in state.entries)
        return state.copy(selected = entry)
    }

    fun cancelConfirmation(state: DictionaryImportState): DictionaryImportState =
        state.copy(selected = null)

    fun close(): DictionaryImportState = DictionaryImportState()
}
