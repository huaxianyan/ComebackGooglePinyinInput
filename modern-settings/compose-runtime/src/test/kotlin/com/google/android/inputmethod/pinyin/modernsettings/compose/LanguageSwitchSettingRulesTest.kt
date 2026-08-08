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
        assertFalse(state.switchToOtherImesEnabled)
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
        assertTrue(state.switchToOtherImesEnabled)
    }

    @Test
    fun switchToOtherImesRequiresEnglishAndEffectiveLanguageKeys() {
        val noEnglish = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = true,
            inputMethodSwitchingAvailable = true,
            emojiSwitchKeyChecked = false,
            showEnglishKeyboard = false,
            persistedLanguageSwitchKey = true,
        )
        assertTrue(noEnglish.languageSwitchEnabled)
        assertTrue(noEnglish.languageSwitchChecked)
        assertFalse(noEnglish.switchToOtherImesEnabled)

        val noLanguage = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = true,
            inputMethodSwitchingAvailable = true,
            emojiSwitchKeyChecked = false,
            showEnglishKeyboard = true,
            persistedLanguageSwitchKey = false,
        )
        assertFalse(noLanguage.switchToOtherImesEnabled)
    }

    @Test
    fun noSwitchTargetRemovesChildAndMakesLanguageDependOnEnglish() {
        val state = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = false,
            inputMethodSwitchingAvailable = false,
            emojiSwitchKeyChecked = true,
            showEnglishKeyboard = false,
            persistedLanguageSwitchKey = true,
        )
        assertFalse(state.languageSwitchEnabled)
        assertFalse(state.languageSwitchChecked)
        assertFalse(state.switchToOtherImesVisible)
    }
}
