package com.google.android.inputmethod.pinyin.modernsettings.compose

/** A Boolean value plus whether the legacy SharedPreferences key is present. */
data class BooleanSettingState(
    val value: Boolean,
    val isExplicit: Boolean,
)

data class BooleanSettingContract(
    val key: String,
    val defaultValue: Boolean,
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
    val writablePlain = firstPlainBatch + secondPlainBatch
}
