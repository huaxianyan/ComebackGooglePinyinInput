package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertSame

class DictionarySettingContractsTest {
    @Test
    fun intervalOrderAndFallbackMatchLegacyLists() {
        assertEquals(listOf(1, 3, 7, 14, 30), DictionarySettingContracts.intervalValues)
        assertEquals(2, DictionarySettingContracts.intervalIndex(7))
        assertEquals(2, DictionarySettingContracts.intervalIndex(-1))
        assertEquals(2, DictionarySettingContracts.intervalIndex(365))
    }

    @Test
    fun retentionOrderAndFallbackMatchLegacyLists() {
        assertEquals(listOf(3, 5, 10, 20, 30), DictionarySettingContracts.retentionValues)
        assertEquals(2, DictionarySettingContracts.retentionIndex(10))
        assertEquals(2, DictionarySettingContracts.retentionIndex(0))
        assertEquals(2, DictionarySettingContracts.retentionIndex(100))
    }

    @Test
    fun healthRefreshRetainsTheLastStableSummary() {
        val loaded = DictionaryHealthState(summary = "healthy", loading = false)

        assertEquals(
            DictionaryHealthState(summary = "healthy", loading = true),
            DictionaryHealthStateReducer.start(loaded),
        )
    }

    @Test
    fun healthRefreshRejectsConcurrentLoads() {
        val loading = DictionaryHealthState(summary = "healthy", loading = true)

        assertSame(loading, DictionaryHealthStateReducer.start(loading))
    }

    @Test
    fun healthCompletionAtomicallyPublishesTheNewSummary() {
        val loading = DictionaryHealthState(summary = "old", loading = true)

        assertEquals(
            DictionaryHealthState(summary = "new", loading = false),
            DictionaryHealthStateReducer.complete(loading, "new"),
        )
    }
}
