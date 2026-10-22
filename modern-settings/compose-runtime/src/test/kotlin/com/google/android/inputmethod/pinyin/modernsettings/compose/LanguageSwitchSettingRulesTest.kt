package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class LanguageSwitchSettingRulesTest {
    @Test
    fun emojiKeyTemporarilyUnchecksLanguageKeyWithoutChangingPersistedInput() {
        val state = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = true,
            inputMethodSwitchingAvailable = true,
            emojiSwitchKeyChecked = true,
            showEnglishKeyboard = true,
            persistedLanguageSwitchKey = true,
        )
        assertFalse(state.languageSwitchEnabled)
        assertFalse(state.languageSwitchChecked)
    }

    @Test
    fun disablingEmojiRestoresPersistedLanguageKey() {
        val state = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = true,
            inputMethodSwitchingAvailable = true,
            emojiSwitchKeyChecked = false,
            showEnglishKeyboard = true,
            persistedLanguageSwitchKey = true,
        )
        assertTrue(state.languageSwitchEnabled)
        assertTrue(state.languageSwitchChecked)
    }

    @Test
    fun noSwitchTargetMakesLanguageKeyDependOnEnglish() {
        val state = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = false,
            inputMethodSwitchingAvailable = false,
            emojiSwitchKeyChecked = true,
            showEnglishKeyboard = false,
            persistedLanguageSwitchKey = true,
        )
        assertFalse(state.languageSwitchEnabled)
        assertFalse(state.languageSwitchChecked)
    }
}
