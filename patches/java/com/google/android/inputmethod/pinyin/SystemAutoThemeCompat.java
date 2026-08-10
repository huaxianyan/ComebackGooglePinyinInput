package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.res.Configuration;
import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Old-ART-safe theme-slot bridge over the original two-key theme runtime.
 *
 * <p>Three complete theme specifications are persisted independently. The two
 * original theme preferences are only the materialized runtime output, so
 * enabling automatic selection never destroys the fixed theme and disabling it
 * restores that theme exactly.</p>
 */
public final class SystemAutoThemeCompat {
    public static final String AUTO_THEME_KEY = "compat_system_auto_keyboard_theme";
    public static final String SLOT_LIGHT = "light";
    public static final String SLOT_DARK = "dark";
    public static final String SLOT_FIXED = "fixed";

    private static final String DIAGNOSTIC_TAG = "SystemAutoTheme";
    private static final String INITIALIZED_KEY = "compat_theme_slots_initialized";
    private static final String SELECTION_SLOT_KEY = "compat_theme_selection_slot";
    private static final String LIGHT_BASE_KEY = "compat_theme_light_keyboard";
    private static final String LIGHT_ADDITIONAL_KEY = "compat_theme_light_additional";
    private static final String DARK_BASE_KEY = "compat_theme_dark_keyboard";
    private static final String DARK_ADDITIONAL_KEY = "compat_theme_dark_additional";
    private static final String FIXED_BASE_KEY = "compat_theme_fixed_keyboard";
    private static final String FIXED_ADDITIONAL_KEY = "compat_theme_fixed_additional";

    // Stable IDs from the original 4.5.2 resource table.
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
        ensureInitialized(context);
        SharedPreferences.Editor editor = preferences(context).edit()
                .remove(SELECTION_SLOT_KEY);
        if (enabled) {
            editor.putBoolean(AUTO_THEME_KEY, true);
        } else {
            editor.remove(AUTO_THEME_KEY);
        }
        editor.commit();
        applyConfiguredTheme(context, context.getResources().getConfiguration());
    }

    /** Called before launching the original selector in one-slot assignment mode. */
    public static void beginSelection(Context context, String slot) {
        ensureInitialized(context);
        boolean automatic = isEnabled(context);
        if (!isValidSlot(slot)
                || (SLOT_FIXED.equals(slot) ? automatic : !automatic)) {
            throw new IllegalStateException("Theme slot is disabled");
        }
        SharedPreferences preferences = preferences(context);
        String base = preferences.getString(baseKey(slot), "");
        String additional = preferences.getString(additionalKey(slot), "");
        preferences.edit()
                .putString(SELECTION_SLOT_KEY, slot)
                .putString(context.getString(PREF_KEY_KEYBOARD_THEME), base)
                .putString(context.getString(PREF_KEY_ADDITIONAL_THEME), additional)
                .commit();
    }

    /** Captures the selector's final original theme state and restores the active slot. */
    public static boolean finishSelection(Context context) {
        ensureInitialized(context);
        SharedPreferences preferences = preferences(context);
        String slot = preferences.getString(SELECTION_SLOT_KEY, null);
        if (!isValidSlot(slot)) {
            return false;
        }
        String[] selected = resolveCurrentTheme(context);
        preferences.edit()
                .putString(baseKey(slot), selected[0])
                .putString(additionalKey(slot), selected[1])
                .remove(SELECTION_SLOT_KEY)
                .commit();
        applyConfiguredTheme(context, context.getResources().getConfiguration());
        return true;
    }

    /** Legacy fixed-theme selection exits automatic mode unless a slot session owns it. */
    public static void disable(Context context) {
        ensureInitialized(context);
        if (hasSelectionSession(context)) {
            return;
        }
        preferences(context).edit().remove(AUTO_THEME_KEY).commit();
    }

    /** Captures an ordinary legacy selector write as the durable fixed slot. */
    public static void captureFixedTheme(Context context) {
        ensureInitialized(context);
        if (hasSelectionSession(context)) {
            return;
        }
        String[] selected = resolveCurrentTheme(context);
        preferences(context).edit()
                .putString(FIXED_BASE_KEY, selected[0])
                .putString(FIXED_ADDITIONAL_KEY, selected[1])
                .commit();
    }

    /**
     * Repoints every slot that referenced an edited or deleted user theme.
     *
     * <p>The original editor has already materialized its replacement or
     * fallback before this method runs. Reusing that resolved pair preserves
     * its lifecycle semantics without parsing or classifying theme files.</p>
     */
    public static void reconcileCustomThemeEdit(Context context, Intent data) {
        ensureInitialized(context);
        if (data == null || data.getExtras() == null) {
            return;
        }
        String deleted = data.getExtras().getString("intent_extra_key_deleted_theme_file_name");
        if (deleted == null || deleted.length() == 0) {
            return;
        }
        String[] replacement = resolveCurrentTheme(context);
        SharedPreferences preferences = preferences(context);
        SharedPreferences.Editor editor = preferences.edit();
        boolean changed = false;
        String[] slots = new String[] { SLOT_LIGHT, SLOT_DARK, SLOT_FIXED };
        for (int index = 0; index < slots.length; index++) {
            String slot = slots[index];
            String additional = preferences.getString(additionalKey(slot), "");
            if (additional.startsWith("files:user_theme_") && additional.endsWith(deleted)) {
                editor.putString(baseKey(slot), replacement[0]);
                editor.putString(additionalKey(slot), replacement[1]);
                changed = true;
            }
        }
        if (changed) {
            editor.commit();
        }
    }

    /** IME process startup recovers stale selector sessions and materializes the configured slot. */
    public static boolean applyOnCreate(Context context) {
        ensureInitialized(context);
        preferences(context).edit().remove(SELECTION_SLOT_KEY).commit();
        return applyConfiguredTheme(context, context.getResources().getConfiguration());
    }

    public static boolean applyIfEnabled(Context context, Configuration configuration) {
        debugLog(context, "configuration uiMode=" + configuration.uiMode);
        ensureInitialized(context);
        if (hasSelectionSession(context) || !isEnabled(context)) {
            return false;
        }
        return writeSlot(
                context,
                isDark(configuration) ? SLOT_DARK : SLOT_LIGHT,
                isDark(configuration) ? "resolved target=dark" : "resolved target=light");
    }

    /** Debug builds only: records framework rebuild without settings or text data. */
    public static void logInputViewRebuild(Context context) {
        debugLog(context, "rebuilding InputView after automatic theme resolution");
    }

    private static boolean applyConfiguredTheme(Context context, Configuration configuration) {
        if (hasSelectionSession(context)) {
            return false;
        }
        if (isEnabled(context)) {
            boolean dark = isDark(configuration);
            return writeSlot(
                    context,
                    dark ? SLOT_DARK : SLOT_LIGHT,
                    dark ? "resolved target=dark" : "resolved target=light");
        }
        return writeSlot(context, SLOT_FIXED, "resolved target=fixed");
    }

    private static boolean writeSlot(Context context, String slot, String diagnostic) {
        SharedPreferences preferences = preferences(context);
        String keyboardThemeKey = context.getString(PREF_KEY_KEYBOARD_THEME);
        String additionalThemeKey = context.getString(PREF_KEY_ADDITIONAL_THEME);
        String keyboardTheme = preferences.getString(baseKey(slot), "");
        String additionalTheme = preferences.getString(additionalKey(slot), "");
        debugLog(context, diagnostic);
        if (keyboardTheme.equals(preferences.getString(keyboardThemeKey, null))
                && additionalTheme.equals(preferences.getString(additionalThemeKey, null))) {
            debugLog(context, "legacy theme pair already resolved");
            return false;
        }
        boolean committed = preferences.edit()
                .putString(keyboardThemeKey, keyboardTheme)
                .putString(additionalThemeKey, additionalTheme)
                .commit();
        debugLog(context, committed ? "legacy theme pair committed" : "theme commit failed");
        return committed;
    }

    private static synchronized void ensureInitialized(Context context) {
        SharedPreferences preferences = preferences(context);
        if (preferences.getBoolean(INITIALIZED_KEY, false)) {
            return;
        }
        String[] current = resolveCurrentTheme(context);
        String baseMaterial = context.getString(BASE_MATERIAL_THEME);
        preferences.edit()
                .putString(FIXED_BASE_KEY, current[0])
                .putString(FIXED_ADDITIONAL_KEY, current[1])
                .putString(LIGHT_BASE_KEY, baseMaterial)
                .putString(LIGHT_ADDITIONAL_KEY, context.getString(MATERIAL_LIGHT_THEME))
                .putString(DARK_BASE_KEY, baseMaterial)
                .putString(DARK_ADDITIONAL_KEY, context.getString(MATERIAL_DARK_THEME))
                .putBoolean(INITIALIZED_KEY, true)
                .commit();
    }

    private static String[] resolveCurrentTheme(Context context) {
        try {
            Class<?> type = Class.forName("baq");
            Method factory = type.getMethod("a", Context.class);
            Object theme = factory.invoke(null, context);
            Field base = type.getField("a");
            Field additional = type.getField("b");
            return new String[] {
                    (String) base.get(theme),
                    (String) additional.get(theme),
            };
        } catch (Exception ignored) {
            SharedPreferences preferences = preferences(context);
            return new String[] {
                    preferences.getString(
                            context.getString(PREF_KEY_KEYBOARD_THEME),
                            context.getString(BASE_MATERIAL_THEME)),
                    preferences.getString(
                            context.getString(PREF_KEY_ADDITIONAL_THEME),
                            ""),
            };
        }
    }

    private static boolean hasSelectionSession(Context context) {
        return isValidSlot(preferences(context).getString(SELECTION_SLOT_KEY, null));
    }

    private static boolean isValidSlot(String slot) {
        return SLOT_LIGHT.equals(slot) || SLOT_DARK.equals(slot) || SLOT_FIXED.equals(slot);
    }

    private static String baseKey(String slot) {
        if (SLOT_LIGHT.equals(slot)) return LIGHT_BASE_KEY;
        if (SLOT_DARK.equals(slot)) return DARK_BASE_KEY;
        if (SLOT_FIXED.equals(slot)) return FIXED_BASE_KEY;
        throw new IllegalArgumentException("Unknown theme slot");
    }

    private static String additionalKey(String slot) {
        if (SLOT_LIGHT.equals(slot)) return LIGHT_ADDITIONAL_KEY;
        if (SLOT_DARK.equals(slot)) return DARK_ADDITIONAL_KEY;
        if (SLOT_FIXED.equals(slot)) return FIXED_ADDITIONAL_KEY;
        throw new IllegalArgumentException("Unknown theme slot");
    }

    private static boolean isDark(Configuration configuration) {
        return (configuration.uiMode & Configuration.UI_MODE_NIGHT_MASK)
                == Configuration.UI_MODE_NIGHT_YES;
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
