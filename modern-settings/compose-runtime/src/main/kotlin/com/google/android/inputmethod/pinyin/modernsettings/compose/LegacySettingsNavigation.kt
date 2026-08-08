package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.Intent

/** Explicit entry points whose implementations remain in the legacy primary DEX. */
internal object LegacySettingsNavigation {
    const val themeSelectorActivity =
        "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"

    fun themeSelectorIntent(context: Context): Intent =
        Intent().setClassName(context, themeSelectorActivity)
}
