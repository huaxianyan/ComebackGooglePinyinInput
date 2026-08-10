package com.google.android.inputmethod.pinyin.modernsettings.compose

enum class ThemeSelectionSlot(val persistedValue: String) {
    Light("light"),
    Dark("dark"),
    Fixed("fixed"),
}

/** Dependency rules shared by the UI and repository write boundary. */
internal object ThemeSettingRules {
    fun canSelect(slot: ThemeSelectionSlot, followThemeEnabled: Boolean): Boolean =
        when (slot) {
            ThemeSelectionSlot.Light,
            ThemeSelectionSlot.Dark,
            -> followThemeEnabled
            ThemeSelectionSlot.Fixed -> !followThemeEnabled
        }
}
