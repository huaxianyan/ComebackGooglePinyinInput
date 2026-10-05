package com.google.android.inputmethod.pinyin.modernsettings.compose

enum class ThemeSelectionSlot(val persistedValue: String) {
    Light("light"),
    Dark("dark"),
    Fixed("fixed"),
}

/**
 * The rule that decides whether writing a slot would mean anything right now.
 *
 * The write boundary asks this before it stores anything, and the Java side
 * asks the same question again with its own copy of the rule, so the two
 * refusals cannot drift apart. The settings UI does not ask it: the two assign
 * buttons in the theme sheet are live for every theme that has a slot to write,
 * and the write switches on the mode it needs first. Gating the buttons on this
 * instead is what left them dead for every theme on the page - the mode they
 * depend on is picked on a different tile, and the sheet had nowhere to say so.
 */
internal object ThemeSettingRules {
    /**
     * Whether a theme slot may be written.
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
