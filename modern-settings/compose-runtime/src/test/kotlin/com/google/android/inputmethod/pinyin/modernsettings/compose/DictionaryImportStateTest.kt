package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class DictionaryImportStateTest {
    private val entry = DictionaryImportEntry("backup.txt", "content://private/backup")

    @Test
    fun openLoadSelectCancelAndCloseAreExplicit() {
        val loading = DictionaryImportStateReducer.open()
        assertTrue(loading.visible)
        assertTrue(loading.loading)

        val loaded = DictionaryImportStateReducer.loaded(listOf(entry))
        assertTrue(loaded.visible)
        assertFalse(loaded.loading)
        assertEquals(listOf(entry), loaded.entries)

        val selected = DictionaryImportStateReducer.select(loaded, entry)
        assertEquals(entry, selected.selected)

        val cancelled = DictionaryImportStateReducer.cancelConfirmation(selected)
        assertNull(cancelled.selected)
        assertEquals(listOf(entry), cancelled.entries)

        assertEquals(DictionaryImportState(), DictionaryImportStateReducer.close())
    }

    @Test(expected = IllegalArgumentException::class)
    fun selectionOutsideLoadedListIsRejected() {
        DictionaryImportStateReducer.select(
            DictionaryImportStateReducer.loaded(emptyList()),
            entry,
        )
    }
}
