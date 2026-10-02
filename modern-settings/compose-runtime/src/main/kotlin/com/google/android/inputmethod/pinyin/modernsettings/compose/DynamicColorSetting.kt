package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Persistence and capability contract shared with the primary-DEX compatibility bridge. */
internal object DynamicColorSetting {
    const val preferenceKey = "compat_system_dynamic_color_theme"

    /** Material You semantic colors only exist from Android 12. */
    const val minSdk = 31

    /**
     * The package the bridge generates into the app's files directory.
     *
     * The generated slot stores this value in `additional_keyboard_theme`, so
     * the theme inventory has to recognize it to name the slot instead of
     * reporting an unrecognized package.
     */
    const val generatedPackageValue = "files:dynamic_theme.zip"
}
