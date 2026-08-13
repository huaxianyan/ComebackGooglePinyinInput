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
    fun capabilityGatedKeyboardBatchPreservesExactKeysAndDefaults() {
        assertEquals(
            listOf("enable_popup_on_keypress", "enable_voice_input"),
            BooleanSettingContracts.capabilityGatedKeyboardBatch.map { it.key },
        )
        assertTrue(
            BooleanSettingContracts.capabilityGatedKeyboardBatch.all { it.defaultValue }
        )
    }

    @Test
    fun headerShortcutPreservesExactKeyAndDefault() {
        assertEquals(
            listOf("show_simplified_traditional_header_toggle"),
            BooleanSettingContracts.headerShortcutBatch.map { it.key },
        )
        assertTrue(BooleanSettingContracts.headerShortcutBatch.all { it.defaultValue })
    }

    @Test
    fun languageSwitchGroupPreservesExactKeysAndDefaults() {
        assertEquals(
            listOf(
                "show_emoji_switch_key",
                "show_language_switch_key",
                "switch_to_other_imes",
            ),
            BooleanSettingContracts.languageSwitchDependencyBatch.map { it.key },
        )
        assertEquals(
            listOf(false, true, true),
            BooleanSettingContracts.languageSwitchDependencyBatch.map { it.defaultValue },
        )
    }

    @Test
    fun englishDependencyBatchPreservesExactKeysDefaultsAndDependency() {
        assertEquals(
            listOf(
                "pref_key_auto_correction",
                "show_suggestions",
                "next_word_prediction",
                "enable_auto_capitalization",
            ),
            BooleanSettingContracts.englishDependencyBatch.map { it.key },
        )
        assertTrue(BooleanSettingContracts.englishDependencyBatch.all { it.defaultValue })
        assertEquals(
            BooleanSettingContracts.latinShowSuggestions,
            BooleanSettingContracts.nextWordPrediction.dependency,
        )
        assertEquals(null, BooleanSettingContracts.latinShowSuggestions.dependency)
    }

    @Test
    fun gestureGroupPreservesMirroredKeyDefaultsAndDependencies() {
        assertEquals("enable_gesture_input", BooleanSettingContracts.gestureInput.key)
        assertEquals(
            "enable_gesture_input_persistent",
            BooleanSettingContracts.gestureInputPersistent.key,
        )
        assertTrue(BooleanSettingContracts.gestureInput.defaultValue)
        assertTrue(BooleanSettingContracts.gestureInputPersistent.defaultValue)
        assertEquals(
            listOf("enable_incremental_gesture_input", "enable_gesture_auto_commit"),
            BooleanSettingContracts.gestureDependencyBatch.map { it.key },
        )
        assertEquals(
            listOf(true, false),
            BooleanSettingContracts.gestureDependencyBatch.map { it.defaultValue },
        )
        assertTrue(
            BooleanSettingContracts.gestureDependencyBatch.all {
                it.dependency == BooleanSettingContracts.gestureInput
            }
        )
    }

    @Test
    fun fuzzyPinyinGroupPreservesKeysOrderDefaultsAndDependency() {
        assertEquals("fuzzy_pinyin", BooleanSettingContracts.fuzzyPinyin.key)
        assertEquals(false, BooleanSettingContracts.fuzzyPinyin.defaultValue)
        assertEquals(
            listOf(
                "fuzzy_pinyin_z_zh",
                "fuzzy_pinyin_c_ch",
                "fuzzy_pinyin_s_sh",
                "fuzzy_pinyin_an_ang",
                "fuzzy_pinyin_en_eng",
                "fuzzy_pinyin_in_ing",
                "fuzzy_pinyin_l_n",
                "fuzzy_pinyin_f_h",
                "fuzzy_pinyin_r_l",
                "fuzzy_pinyin_k_g",
                "fuzzy_pinyin_ian_iang",
                "fuzzy_pinyin_uan_uang",
            ),
            BooleanSettingContracts.fuzzyPinyinOptionBatch.map { it.key },
        )
        assertEquals(
            listOf(true, true, true, true, true, true) + List(6) { false },
            BooleanSettingContracts.fuzzyPinyinOptionBatch.map { it.defaultValue },
        )
        assertTrue(
            BooleanSettingContracts.fuzzyPinyinOptionBatch.all {
                it.dependency == BooleanSettingContracts.fuzzyPinyin
            }
        )
    }

    @Test
    fun writableSettingsHaveNoDuplicateKeys() {
        val keys = BooleanSettingContracts.writable.map { it.key }
        assertEquals(keys.size, keys.toSet().size)
    }
}
