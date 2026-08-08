package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class BooleanSettingContractsTest {
    @Test
    fun firstPlainBatchPreservesExactLegacyKeysAndDefaults() {
        assertEquals(
            listOf(
                "enable_double_space_period",
                "enable_scrub_move",
                "show_english_keyboard",
                "enable_emoji_alt_physical_key",
            ),
            BooleanSettingContracts.firstPlainBatch.map { it.key },
        )
        assertTrue(BooleanSettingContracts.firstPlainBatch.all { it.defaultValue })
    }

    @Test
    fun firstPlainBatchHasNoDuplicateKeys() {
        val keys = BooleanSettingContracts.firstPlainBatch.map { it.key }
        assertEquals(keys.size, keys.toSet().size)
    }
}
