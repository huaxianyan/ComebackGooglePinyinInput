package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertEquals
import org.junit.Test

class DynamicColorSettingTest {
    @Test
    fun persistenceKeyRemainsStable() {
        assertEquals(
            "compat_system_dynamic_color_theme",
            DynamicColorSetting.preferenceKey,
        )
    }

    /** The switch is hidden below Android 12, where the palette does not exist. */
    @Test
    fun minimumSdkMatchesMaterialYou() {
        assertEquals(31, DynamicColorSetting.minSdk)
    }
}
