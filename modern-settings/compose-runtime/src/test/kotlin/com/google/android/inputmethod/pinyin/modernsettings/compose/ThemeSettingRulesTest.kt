package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class ThemeSettingRulesTest {
    @Test
    fun automaticSlotsRequireFollowTheme() {
        assertFalse(ThemeSettingRules.canSelect(ThemeSelectionSlot.Light, false))
        assertFalse(ThemeSettingRules.canSelect(ThemeSelectionSlot.Dark, false))
        assertTrue(ThemeSettingRules.canSelect(ThemeSelectionSlot.Light, true))
        assertTrue(ThemeSettingRules.canSelect(ThemeSelectionSlot.Dark, true))
    }

    @Test
    fun fixedSlotRequiresFollowThemeToBeOff() {
        assertTrue(ThemeSettingRules.canSelect(ThemeSelectionSlot.Fixed, false))
        assertFalse(ThemeSettingRules.canSelect(ThemeSelectionSlot.Fixed, true))
    }
}
