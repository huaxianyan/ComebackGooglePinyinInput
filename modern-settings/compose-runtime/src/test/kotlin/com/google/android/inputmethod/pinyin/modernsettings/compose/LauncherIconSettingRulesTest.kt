package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class LauncherIconSettingRulesTest {
    @Test
    fun sideloadedAppUsesResourceDefault() {
        assertTrue(
            LauncherIconSettingRules.defaultVisible(
                isSystemOrUpdatedSystemApp = false,
                resourceDefault = true,
            )
        )
        assertFalse(
            LauncherIconSettingRules.defaultVisible(
                isSystemOrUpdatedSystemApp = false,
                resourceDefault = false,
            )
        )
    }

    @Test
    fun systemAndUpdatedSystemAppsDefaultToHidden() {
        assertFalse(
            LauncherIconSettingRules.defaultVisible(
                isSystemOrUpdatedSystemApp = true,
                resourceDefault = true,
            )
        )
    }
}
