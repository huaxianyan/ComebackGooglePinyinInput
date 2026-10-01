package com.google.android.inputmethod.pinyin.modernsettings.compose

enum class ThemeSelectionSlot(val persistedValue: String) {
    Light("light"),
    Dark("dark"),
    Fixed("fixed"),
}

/** Dependency rules shared by the UI and repository write boundary. */
internal object ThemeSettingRules {
    /**
     * Whether a theme slot may be opened.
     *
     * The generated palette owns the resolved theme pair while it is on, so it
     * suppresses every selectable slot rather than competing with them. It is
     * never itself selectable: it has no picker, only a switch.
     */
    fun canSelect(
        slot: ThemeSelectionSlot,
        followThemeEnabled: Boolean,
        dynamicColorEnabled: Boolean,
    ): Boolean {
        if (dynamicColorEnabled) {
            return false
        }
        return when (slot) {
            ThemeSelectionSlot.Light,
            ThemeSelectionSlot.Dark,
            -> followThemeEnabled
            ThemeSelectionSlot.Fixed -> !followThemeEnabled
        }
    }
}
