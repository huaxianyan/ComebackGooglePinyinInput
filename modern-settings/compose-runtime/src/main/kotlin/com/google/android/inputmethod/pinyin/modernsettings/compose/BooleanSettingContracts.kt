package com.google.android.inputmethod.pinyin.modernsettings.compose

/** A Boolean value plus whether the legacy SharedPreferences key is present. */
data class BooleanSettingState(
    val value: Boolean,
    val isExplicit: Boolean,
)

data class BooleanSettingContract(
    val key: String,
    val defaultValue: Boolean,
    val dependency: BooleanSettingContract? = null,
)

/**
 * First audited plain CheckBoxPreference contracts.
 *
 * These preferences have Boolean persistence and no Preference change listener,
 * platform preview, custom widget state machine, or dynamic availability gate.
 */
object BooleanSettingContracts {
    val doubleSpacePeriod = BooleanSettingContract(
        key = "enable_double_space_period",
        defaultValue = true,
    )
    val scrubMove = BooleanSettingContract(
        key = "enable_scrub_move",
        defaultValue = true,
    )
    val showEnglishKeyboard = BooleanSettingContract(
        key = "show_english_keyboard",
        defaultValue = true,
    )
    val emojiAltPhysicalKey = BooleanSettingContract(
        key = "enable_emoji_alt_physical_key",
        defaultValue = true,
    )
    val chineseEnglishMixedInput = BooleanSettingContract(
        key = "chinese_english_mixed_input",
        defaultValue = true,
    )
    val chineseDigitsMixedInput = BooleanSettingContract(
        key = "chinese_digits_mixed_input",
        defaultValue = true,
    )
    val suggestEmojis = BooleanSettingContract(
        key = "enable_suggest_emojis",
        defaultValue = true,
    )
    val spatialCorrection = BooleanSettingContract(
        key = "enable_spatial_model",
        defaultValue = true,
    )
    val traditionalChinese = BooleanSettingContract(
        key = "enable_sc_tc_conversion",
        defaultValue = false,
    )
    val chinesePrediction = BooleanSettingContract(
        key = "enable_chinese_prediction",
        defaultValue = true,
    )
    val automaticSpace = BooleanSettingContract(
        key = "auto_space",
        defaultValue = true,
    )
    val blockOffensiveWords = BooleanSettingContract(
        key = "block_offensive_words",
        defaultValue = true,
    )
    val popupOnKeypress = BooleanSettingContract(
        key = "enable_popup_on_keypress",
        defaultValue = true,
    )
    val voiceInput = BooleanSettingContract(
        key = "enable_voice_input",
        defaultValue = true,
    )
    val showEmojiSwitchKey = BooleanSettingContract(
        key = "show_emoji_switch_key",
        defaultValue = false,
    )
    val showLanguageSwitchKey = BooleanSettingContract(
        key = "show_language_switch_key",
        defaultValue = true,
    )
    val switchToOtherImes = BooleanSettingContract(
        key = "switch_to_other_imes",
        defaultValue = true,
    )
    val latinAutoCorrection = BooleanSettingContract(
        key = "pref_key_auto_correction",
        defaultValue = true,
    )
    val latinShowSuggestions = BooleanSettingContract(
        key = "show_suggestions",
        defaultValue = true,
    )
    val nextWordPrediction = BooleanSettingContract(
        key = "next_word_prediction",
        defaultValue = true,
        dependency = latinShowSuggestions,
    )
    val autoCapitalization = BooleanSettingContract(
        key = "enable_auto_capitalization",
        defaultValue = true,
    )
    val gestureInput = BooleanSettingContract(
        key = "enable_gesture_input",
        defaultValue = true,
    )
    val gestureInputPersistent = BooleanSettingContract(
        key = "enable_gesture_input_persistent",
        defaultValue = true,
    )
    val incrementalGesturePreview = BooleanSettingContract(
        key = "enable_incremental_gesture_input",
        defaultValue = true,
        dependency = gestureInput,
    )
    val gestureAutoCommit = BooleanSettingContract(
        key = "enable_gesture_auto_commit",
        defaultValue = false,
        dependency = gestureInput,
    )
    val fuzzyPinyin = BooleanSettingContract(
        key = "fuzzy_pinyin",
        defaultValue = false,
    )
    val fuzzyPinyinZZh = fuzzyOption("fuzzy_pinyin_z_zh", true)
    val fuzzyPinyinCCh = fuzzyOption("fuzzy_pinyin_c_ch", true)
    val fuzzyPinyinSSh = fuzzyOption("fuzzy_pinyin_s_sh", true)
    val fuzzyPinyinAnAng = fuzzyOption("fuzzy_pinyin_an_ang", true)
    val fuzzyPinyinEnEng = fuzzyOption("fuzzy_pinyin_en_eng", true)
    val fuzzyPinyinInIng = fuzzyOption("fuzzy_pinyin_in_ing", true)
    val fuzzyPinyinLN = fuzzyOption("fuzzy_pinyin_l_n", false)
    val fuzzyPinyinFH = fuzzyOption("fuzzy_pinyin_f_h", false)
    val fuzzyPinyinRL = fuzzyOption("fuzzy_pinyin_r_l", false)
    val fuzzyPinyinKG = fuzzyOption("fuzzy_pinyin_k_g", false)
    val fuzzyPinyinIanIang = fuzzyOption("fuzzy_pinyin_ian_iang", false)
    val fuzzyPinyinUanUang = fuzzyOption("fuzzy_pinyin_uan_uang", false)

    val firstPlainBatch = listOf(
        doubleSpacePeriod,
        scrubMove,
        showEnglishKeyboard,
        emojiAltPhysicalKey,
    )
    val secondPlainBatch = listOf(
        chineseEnglishMixedInput,
        chineseDigitsMixedInput,
        suggestEmojis,
        spatialCorrection,
    )
    val thirdPlainBatch = listOf(
        traditionalChinese,
        chinesePrediction,
        automaticSpace,
        blockOffensiveWords,
    )
    val capabilityGatedKeyboardBatch = listOf(
        popupOnKeypress,
        voiceInput,
    )
    val languageSwitchDependencyBatch = listOf(
        showEmojiSwitchKey,
        showLanguageSwitchKey,
        switchToOtherImes,
    )
    val englishDependencyBatch = listOf(
        latinAutoCorrection,
        latinShowSuggestions,
        nextWordPrediction,
        autoCapitalization,
    )
    val gestureDependencyBatch = listOf(
        incrementalGesturePreview,
        gestureAutoCommit,
    )
    val fuzzyPinyinOptionBatch = listOf(
        fuzzyPinyinZZh,
        fuzzyPinyinCCh,
        fuzzyPinyinSSh,
        fuzzyPinyinAnAng,
        fuzzyPinyinEnEng,
        fuzzyPinyinInIng,
        fuzzyPinyinLN,
        fuzzyPinyinFH,
        fuzzyPinyinRL,
        fuzzyPinyinKG,
        fuzzyPinyinIanIang,
        fuzzyPinyinUanUang,
    )
    val writable = firstPlainBatch + secondPlainBatch + thirdPlainBatch +
        capabilityGatedKeyboardBatch + languageSwitchDependencyBatch +
        englishDependencyBatch + gestureDependencyBatch + fuzzyPinyin +
        fuzzyPinyinOptionBatch

    private fun fuzzyOption(key: String, defaultValue: Boolean) =
        BooleanSettingContract(
            key = key,
            defaultValue = defaultValue,
            dependency = fuzzyPinyin,
        )
}
