package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class SettingsNavigationTest {
    @Test
    fun initialPathIsHomeAndCannotPop() {
        assertEquals(SettingsRoute.Home, SettingsRouteStack.current(SettingsRouteStack.initialPath))
        assertFalse(SettingsRouteStack.canPop(SettingsRouteStack.initialPath))
        assertEquals(SettingsRouteStack.initialPath, SettingsRouteStack.pop(SettingsRouteStack.initialPath))
    }

    @Test
    fun nestedRoutePushAndPopPreserveHierarchy() {
        val input = SettingsRouteStack.push(SettingsRouteStack.initialPath, SettingsRoute.Input)
        val chinese = SettingsRouteStack.push(input, SettingsRoute.ChineseInput)
        val fuzzy = SettingsRouteStack.push(chinese, SettingsRoute.FuzzyPinyin)

        assertEquals(SettingsRoute.FuzzyPinyin, SettingsRouteStack.current(fuzzy))
        assertTrue(SettingsRouteStack.canPop(fuzzy))
        assertEquals(chinese, SettingsRouteStack.pop(fuzzy))
        assertEquals(input, SettingsRouteStack.pop(chinese))
        assertEquals(SettingsRouteStack.initialPath, SettingsRouteStack.pop(input))
    }

    @Test(expected = IllegalArgumentException::class)
    fun homeCannotBePushedAsAChild() {
        SettingsRouteStack.push(SettingsRouteStack.initialPath, SettingsRoute.Home)
    }

    @Test
    fun invalidRestoredPathFallsBackToHome() {
        assertEquals(listOf(SettingsRoute.Home), SettingsRouteStack.decode("RemovedRoute"))
        assertEquals(SettingsRoute.Home, SettingsRouteStack.current("RemovedRoute"))
    }
}
