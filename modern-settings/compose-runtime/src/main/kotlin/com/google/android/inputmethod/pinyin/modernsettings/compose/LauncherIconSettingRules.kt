package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Exact absent-key fallback used by LauncherIconVisibilityInitializer. */
internal object LauncherIconSettingRules {
    fun defaultVisible(
        isSystemOrUpdatedSystemApp: Boolean,
        resourceDefault: Boolean,
    ): Boolean = !isSystemOrUpdatedSystemApp && resourceDefault
}
