package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.SharedPreferences

/**
 * Floating keyboard state, kept in its own preferences file.
 *
 * The input method service reads it on every insets pass, so it must not depend
 * on the settings process having finished writing anything else. The file name
 * and keys mirror `FloatingKeyboardCompat` on the patch side; changing one
 * without the other silently disables the feature.
 */
object FloatingKeyboardSetting {
    const val PREFERENCES = "floating_keyboard_preferences"
    const val ENABLED_KEY = "enabled"
    const val SCALE_KEY = "scale"
    const val DEFAULT_SCALE = 0.72f
    const val MIN_SCALE = 0.40f
    const val MAX_SCALE = 1.0f

    fun preferences(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)

    fun isEnabled(context: Context): Boolean =
        preferences(context).getBoolean(ENABLED_KEY, false)

    fun setEnabled(context: Context, enabled: Boolean) {
        preferences(context).edit().putBoolean(ENABLED_KEY, enabled).apply()
    }

    fun scale(context: Context): Float =
        preferences(context).getFloat(SCALE_KEY, DEFAULT_SCALE)
            .coerceIn(MIN_SCALE, MAX_SCALE)

    fun setScale(context: Context, value: Float) {
        preferences(context).edit().putFloat(SCALE_KEY, value.coerceIn(MIN_SCALE, MAX_SCALE))
            .apply()
    }
}
