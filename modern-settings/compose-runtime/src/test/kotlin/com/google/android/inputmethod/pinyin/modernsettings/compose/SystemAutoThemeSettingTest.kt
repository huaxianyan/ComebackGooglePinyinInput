package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class SystemAutoThemeSettingTest {
    @Test
    fun resolvesOnlyNightYesAsDark() {
        assertTrue(SystemAutoThemeSetting.isDarkMode(0x20))
        assertTrue(SystemAutoThemeSetting.isDarkMode(0x22))
        assertFalse(SystemAutoThemeSetting.isDarkMode(0x10))
        assertFalse(SystemAutoThemeSetting.isDarkMode(0x00))
        assertFalse(SystemAutoThemeSetting.isDarkMode(0x30))
    }

    @Test
    fun persistenceKeyRemainsStable() {
        assertTrue(
            SystemAutoThemeSetting.preferenceKey == "compat_system_auto_keyboard_theme",
        )
    }
}
