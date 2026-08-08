package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Effective legacy Preference state without changing any persisted child value. */
data class LanguageSwitchSettingState(
    val languageSwitchEnabled: Boolean,
    val languageSwitchChecked: Boolean,
    val switchToOtherImesVisible: Boolean,
    val switchToOtherImesEnabled: Boolean,
)

object LanguageSwitchSettingRules {
    fun resolve(
        emojiSwitchKeyVisible: Boolean,
        inputMethodSwitchingAvailable: Boolean,
        emojiSwitchKeyChecked: Boolean,
        showEnglishKeyboard: Boolean,
        persistedLanguageSwitchKey: Boolean,
    ): LanguageSwitchSettingState {
        val languageSwitchEnabled =
            (!emojiSwitchKeyVisible || !emojiSwitchKeyChecked) &&
                (inputMethodSwitchingAvailable || showEnglishKeyboard)
        val languageSwitchChecked = languageSwitchEnabled && persistedLanguageSwitchKey
        return LanguageSwitchSettingState(
            languageSwitchEnabled = languageSwitchEnabled,
            languageSwitchChecked = languageSwitchChecked,
            switchToOtherImesVisible = inputMethodSwitchingAvailable,
            switchToOtherImesEnabled = inputMethodSwitchingAvailable &&
                showEnglishKeyboard && languageSwitchChecked,
        )
    }
}
