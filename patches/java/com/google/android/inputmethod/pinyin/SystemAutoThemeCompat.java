package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.content.pm.ApplicationInfo;
import android.util.Log;

/**
 * Old-ART-safe bridge that keeps a persistent automatic-theme mode while
 * materializing the legacy light/dark theme pair expected by the original IME.
 *
 * <p>The automatic-mode key is authoritative. The two legacy theme keys are
 * resolved outputs, not the stored mode, so a configuration change never loses
 * the user's automatic selection.</p>
 */
public final class SystemAutoThemeCompat {
    public static final String AUTO_THEME_KEY = "compat_system_auto_keyboard_theme";
    private static final String DIAGNOSTIC_TAG = "SystemAutoTheme";

    // Stable IDs from the original 4.5.2 resource table. They are deliberately
    // resolved through Context so overlays/localization aliases retain the
    // original theme contract.
    private static final int PREF_KEY_ADDITIONAL_THEME = 0x7f11023a;
    private static final int PREF_KEY_KEYBOARD_THEME = 0x7f110282;
    private static final int BASE_MATERIAL_THEME = 0x7f110226;
    private static final int MATERIAL_DARK_THEME = 0x7f110224;
    private static final int MATERIAL_LIGHT_THEME = 0x7f110225;

    private SystemAutoThemeCompat() {}

    public static boolean isEnabled(Context context) {
        return preferences(context).getBoolean(AUTO_THEME_KEY, false);
    }

    public static void setEnabled(Context context, boolean enabled) {
        if (!enabled) {
            disable(context);
            return;
        }
        writeResolvedTheme(context, context.getResources().getConfiguration(), true);
    }

    public static void disable(Context context) {
        preferences(context).edit().remove(AUTO_THEME_KEY).commit();
    }

    public static boolean applyIfEnabled(Context context) {
        return applyIfEnabled(context, context.getResources().getConfiguration());
    }

    public static boolean applyIfEnabled(Context context, Configuration configuration) {
        debugLog(
                context,
                "configuration uiMode=0x" + Integer.toHexString(configuration.uiMode));
        if (!isEnabled(context)) {
            return false;
        }
        return writeResolvedTheme(context, configuration, false);
    }

    /** Debug builds only: records the framework rebuild event without settings or text data. */
    public static void logInputViewRebuild(Context context) {
        debugLog(context, "rebuilding InputView after automatic theme resolution");
    }

    private static boolean writeResolvedTheme(
            Context context,
            Configuration configuration,
            boolean enable) {
        SharedPreferences preferences = preferences(context);
        String keyboardThemeKey = context.getString(PREF_KEY_KEYBOARD_THEME);
        String additionalThemeKey = context.getString(PREF_KEY_ADDITIONAL_THEME);
        String keyboardTheme = context.getString(BASE_MATERIAL_THEME);
        boolean dark = (configuration.uiMode & Configuration.UI_MODE_NIGHT_MASK)
                == Configuration.UI_MODE_NIGHT_YES;
        String additionalTheme = context.getString(
                dark ? MATERIAL_DARK_THEME : MATERIAL_LIGHT_THEME);
        debugLog(context, dark ? "resolved target=dark" : "resolved target=light");

        boolean alreadyResolved = keyboardTheme.equals(
                preferences.getString(keyboardThemeKey, null))
                && additionalTheme.equals(preferences.getString(additionalThemeKey, null));
        if (!enable && alreadyResolved) {
            debugLog(context, "legacy theme pair already resolved");
            return false;
        }

        SharedPreferences.Editor editor = preferences.edit()
                .putString(keyboardThemeKey, keyboardTheme)
                .putString(additionalThemeKey, additionalTheme);
        if (enable) {
            editor.putBoolean(AUTO_THEME_KEY, true);
        }
        boolean committed = editor.commit();
        debugLog(context, committed ? "legacy theme pair committed" : "theme commit failed");
        return committed;
    }

    private static void debugLog(Context context, String message) {
        if ((context.getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0) {
            Log.d(DIAGNOSTIC_TAG, message);
        }
    }

    private static SharedPreferences preferences(Context context) {
        return context.getSharedPreferences(
                context.getPackageName() + "_preferences",
                Context.MODE_PRIVATE);
    }
}
