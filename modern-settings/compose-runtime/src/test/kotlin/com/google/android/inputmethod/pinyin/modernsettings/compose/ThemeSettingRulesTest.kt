package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class ThemeSettingRulesTest {
    @Test
    fun automaticSlotsRequireFollowTheme() {
        assertFalse(ThemeSettingRules.canSelect(ThemeSelectionSlot.Light, false, false))
        assertFalse(ThemeSettingRules.canSelect(ThemeSelectionSlot.Dark, false, false))
        assertTrue(ThemeSettingRules.canSelect(ThemeSelectionSlot.Light, true, false))
        assertTrue(ThemeSettingRules.canSelect(ThemeSelectionSlot.Dark, true, false))
    }

    @Test
    fun fixedSlotRequiresFollowThemeToBeOff() {
        assertTrue(ThemeSettingRules.canSelect(ThemeSelectionSlot.Fixed, false, false))
        assertFalse(ThemeSettingRules.canSelect(ThemeSelectionSlot.Fixed, true, false))
    }

    /**
     * The generated palette owns the resolved theme pair while it is on, so it
     * suppresses every selectable slot regardless of the follow-theme state.
     * This is the rule the greyed-out rows and the repository write boundary
     * both read, so a hole here would be a row that looks disabled but still
     * accepts a write.
     */
    @Test
    fun dynamicColorSuppressesEverySelectableSlot() {
        ThemeSelectionSlot.values().forEach { slot ->
            assertFalse(
                ThemeSettingRules.canSelect(slot, followThemeEnabled = true, dynamicColorEnabled = true),
            )
            assertFalse(
                ThemeSettingRules.canSelect(slot, followThemeEnabled = false, dynamicColorEnabled = true),
            )
        }
    }
}
