package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Persistence and capability contract shared with the primary-DEX compatibility bridge. */
internal object DynamicColorSetting {
    const val preferenceKey = "compat_system_dynamic_color_theme"

    /** Material You semantic colors only exist from Android 12. */
    const val minSdk = 31
}
