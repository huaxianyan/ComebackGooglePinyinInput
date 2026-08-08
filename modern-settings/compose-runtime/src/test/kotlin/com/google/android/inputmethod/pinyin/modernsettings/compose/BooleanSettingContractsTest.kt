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
    fun secondPlainBatchPreservesExactLegacyKeysAndDefaults() {
        assertEquals(
            listOf(
                "chinese_english_mixed_input",
                "chinese_digits_mixed_input",
                "enable_suggest_emojis",
                "enable_spatial_model",
            ),
            BooleanSettingContracts.secondPlainBatch.map { it.key },
        )
        assertTrue(BooleanSettingContracts.secondPlainBatch.all { it.defaultValue })
    }

    @Test
    fun thirdPlainBatchPreservesExactLegacyKeysAndDefaults() {
        assertEquals(
            listOf(
                "enable_sc_tc_conversion",
                "enable_chinese_prediction",
                "auto_space",
                "block_offensive_words",
            ),
            BooleanSettingContracts.thirdPlainBatch.map { it.key },
        )
        assertEquals(
            listOf(false, true, true, true),
            BooleanSettingContracts.thirdPlainBatch.map { it.defaultValue },
        )
    }

    @Test
    fun writablePlainSettingsHaveNoDuplicateKeys() {
        val keys = BooleanSettingContracts.writablePlain.map { it.key }
        assertEquals(keys.size, keys.toSet().size)
    }
}
