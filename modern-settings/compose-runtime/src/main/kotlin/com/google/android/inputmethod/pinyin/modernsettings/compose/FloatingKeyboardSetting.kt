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
    const val IDLE_FADE_KEY = "idle_fade"
    const val DEFAULT_SCALE = 0.72f
    const val MIN_SCALE = 0.50f
    const val MAX_SCALE = 0.92f

    fun preferences(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)

    fun isEnabled(context: Context): Boolean =
        preferences(context).getBoolean(ENABLED_KEY, false)

    fun setEnabled(context: Context, enabled: Boolean) {
        preferences(context).edit().putBoolean(ENABLED_KEY, enabled).apply()
    }

    /** Whether the card fades out while idle. Kept apart from [isEnabled] on purpose: turning
     * the card off must not forget this choice, it only stops applying. */
    fun isIdleFadeEnabled(context: Context): Boolean =
        preferences(context).getBoolean(IDLE_FADE_KEY, false)

    fun setIdleFadeEnabled(context: Context, enabled: Boolean) {
        preferences(context).edit().putBoolean(IDLE_FADE_KEY, enabled).apply()
    }

    fun scale(context: Context): Float =
        preferences(context).getFloat(SCALE_KEY, DEFAULT_SCALE)
            .coerceIn(MIN_SCALE, MAX_SCALE)

    /** Position is stored per orientation as a fraction of the screen. */
    private fun positionKeys(): List<String> = listOf(
        "x_fraction_portrait",
        "y_fraction_portrait",
        "x_fraction_landscape",
        "y_fraction_landscape",
    )

    /**
     * Puts the card back to the default size and position.
     *
     * A safety valve: a card dragged or scaled into an awkward state can be recovered from the
     * settings screen without clearing app data. The on/off switch and the idle-transparency choice
     * are deliberately left alone; this only forgets geometry.
     */
    fun resetGeometry(context: Context) {
        val editor = preferences(context).edit().remove(SCALE_KEY)
        for (key in positionKeys()) editor.remove(key)
        editor.apply()
    }

    fun setScale(context: Context, value: Float) {
        preferences(context).edit().putFloat(SCALE_KEY, value.coerceIn(MIN_SCALE, MAX_SCALE))
            .apply()
    }
}
