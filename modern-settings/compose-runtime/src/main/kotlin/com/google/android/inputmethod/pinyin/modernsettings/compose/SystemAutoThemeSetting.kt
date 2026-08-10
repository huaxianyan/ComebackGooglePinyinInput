package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Persistence and configuration contract shared with the primary-DEX compatibility bridge. */
internal object SystemAutoThemeSetting {
    const val preferenceKey = "compat_system_auto_keyboard_theme"
    const val nightModeMask = 0x30
    const val nightModeYes = 0x20

    fun isDarkMode(uiMode: Int): Boolean =
        (uiMode and nightModeMask) == nightModeYes
}
