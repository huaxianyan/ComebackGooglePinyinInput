package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.view.View
import androidx.compose.ui.unit.LayoutDirection
import org.junit.Assert.assertEquals
import org.junit.Test

class ModernSettingsThemeTest {
    @Test
    fun modernSettingsUsesRtlConfigurationWithoutChangingApplicationManifest() {
        assertEquals(
            LayoutDirection.Rtl,
            modernSettingsLayoutDirection(View.LAYOUT_DIRECTION_RTL),
        )
    }

    @Test
    fun modernSettingsKeepsLtrConfiguration() {
        assertEquals(
            LayoutDirection.Ltr,
            modernSettingsLayoutDirection(View.LAYOUT_DIRECTION_LTR),
        )
    }
}
