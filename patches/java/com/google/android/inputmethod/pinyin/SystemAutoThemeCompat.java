package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.util.Log;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.HashSet;
import java.util.Set;
import java.util.TreeMap;
import java.util.WeakHashMap;
import java.util.zip.CRC32;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Old-ART-safe theme-slot bridge over the original two-key theme runtime.
 *
 * <p>Four complete theme specifications are persisted independently. The two
 * original theme preferences are only the materialized runtime output, so
 * enabling automatic selection never destroys the fixed theme and disabling it
 * restores that theme exactly.</p>
 *
 * <p>The fourth slot is a generated package whose main style sheet is recolored
 * from the platform Material You palette. It is gated on API 31+, off by
 * default, and while disabled it changes nothing at all: the original three
 * slots keep behaving exactly as before.</p>
 */
public final class SystemAutoThemeCompat {
    public static final String AUTO_THEME_KEY = "compat_system_auto_keyboard_theme";
    public static final String DYNAMIC_THEME_KEY = "compat_system_dynamic_color_theme";
    public static final String SLOT_LIGHT = "light";
    public static final String SLOT_DARK = "dark";
    public static final String SLOT_FIXED = "fixed";
    public static final String SLOT_DYNAMIC = "dynamic";

    private static final String DIAGNOSTIC_TAG = "SystemAutoTheme";
    private static final String SELECTION_SLOT_KEY = "compat_theme_selection_slot";
    private static final String LIGHT_BASE_KEY = "compat_theme_light_keyboard";
    private static final String LIGHT_ADDITIONAL_KEY = "compat_theme_light_additional";
    private static final String DARK_BASE_KEY = "compat_theme_dark_keyboard";
    private static final String DARK_ADDITIONAL_KEY = "compat_theme_dark_additional";
    private static final String FIXED_BASE_KEY = "compat_theme_fixed_keyboard";
    private static final String FIXED_ADDITIONAL_KEY = "compat_theme_fixed_additional";
    private static final String DYNAMIC_BASE_KEY = "compat_theme_dynamic_keyboard";
    private static final String DYNAMIC_ADDITIONAL_KEY = "compat_theme_dynamic_additional";
    private static final String DYNAMIC_SIGNATURE_KEY = "compat_theme_dynamic_signature";

    // Stable IDs from the original 4.5.2 resource table.
    private static final int PREF_KEY_ADDITIONAL_THEME = 0x7f11023a;
    private static final int PREF_KEY_KEYBOARD_THEME = 0x7f110282;
    private static final int BASE_MATERIAL_THEME = 0x7f110226;
    private static final int MATERIAL_DARK_THEME = 0x7f110224;
    private static final int MATERIAL_LIGHT_THEME = 0x7f110225;

    /** Material You semantic colors only exist from Android 12. */
    private static final int DYNAMIC_MIN_SDK = 31;

    private static final String DYNAMIC_PACKAGE_NAME = "dynamic_theme.zip";
    private static final String DYNAMIC_PACKAGE_TEMP_NAME = "dynamic_theme.tmp";
    private static final String DYNAMIC_ADDITIONAL_PREFIX = "files:";
    private static final String ASSET_DIRECTORY = "theme/";
    private static final String METADATA_ENTRY = "metadata.binarypb";
    private static final String MATERIAL_TEMPLATE_PREFIX = "style_sheet_material_";
    private static final String METADATA_TEMPLATE_PREFIX = "theme_package_metadata_material_";
    private static final String MODE_LIGHT = "light";
    private static final String MODE_DARK = "dark";

    // files: packages need the current-format marker; unversioned packages
    // pass through the legacy selector converter, unlike built-in assets.
    private static final int THEME_PACKAGE_FORMAT_VERSION = 3;
    private static final int DYNAMIC_PALETTE_REVISION = 5;

    // Original Material icons bake 60% opacity into their pixel masks. Keep
    // metadata, disabled-key and drawable alpha separate from that mask.
    private static final int LEGACY_FUNCTION_ICON_ALPHA = 153;
    private static final int PRIMARY_ICON_ID = 0x7f0f0057;
    private static final int[] DYNAMIC_FUNCTION_KEYS = {
        0x7f0f0221, // del
        0x7f0f0222, // del_composing
        0x7f0f020e, // candidate_del
        0x7f0f020f, // candidate_del_composing
        0x7f0f036e, // shift
        0x7f0f0371, // shift_locked
        0x7f0f0373, // shift_no_lock
        0x7f0f0374, // shift_shifted
        0x7f0f0375, // shift_shifted_combo
        0x7f0f0376, // shift_shifted_no_lock
    };
    private static final Map<Bitmap, Bitmap> DYNAMIC_ICON_MASKS = new WeakHashMap<Bitmap, Bitmap>();

    /**
     * Outcome of a palette sync. "Rebuilt" and "unchanged" are both usable, but
     * only a rebuild means the view on screen is now showing stale colors and
     * has to be rebuilt for the new palette to appear.
     */
    private static final int SYNC_UNAVAILABLE = 0;
    private static final int SYNC_UNCHANGED = 1;
    private static final int SYNC_REBUILT = 2;

    /**
     * Zip entries other than metadata, in the exact order the original
     * packaging tool used. Entry names equal the asset template names, so the
     * generated package can be diffed against {@code assets/theme/} directly.
     * Both the material sheet and its border override are recolored. Other
     * entries remain byte-identical to the original templates.
     */
    private static final String[] DYNAMIC_ENTRIES_LIGHT = {
        "style_sheet_color_common.binarypb",
        "style_sheet_material_light.binarypb",
        "style_sheet_color_gif_light.binarypb",
        "style_sheet_color_rules.binarypb",
        "style_sheet_material_rules.binarypb",
        "style_sheet_material_light_border.binarypb",
        "style_sheet_color_rules_border.binarypb",
        "style_sheet_material_rules_border.binarypb",
    };
    private static final String[] DYNAMIC_ENTRIES_DARK = {
        "style_sheet_color_common.binarypb",
        "style_sheet_material_dark.binarypb",
        "style_sheet_color_gif_dark.binarypb",
        "style_sheet_color_rules.binarypb",
        "style_sheet_material_rules.binarypb",
        "style_sheet_material_dark_border.binarypb",
        "style_sheet_color_rules_border.binarypb",
        "style_sheet_material_rules_border.binarypb",
    };

    /**
     * One definition per role: semantic resource stem, then API-31 tonal
     * fallback. A light|dark pair selects the stem before adding the suffix
     * (semantic resources only). Tonal resources already have complete names.
     */
    private static final String[][] DYNAMIC_COLOR_ROLES = {
        {"base", "surface_container", "neutral1_100|neutral1_900"},
        {"surface", "surface", "neutral1_10|neutral1_900"},
        {"letter", "surface_container_lowest|surface_bright", "neutral1_0|neutral1_800"},
        {"high", "surface_container_high", "neutral1_100|neutral1_800"},
        {"highest", "surface_container_highest", "neutral1_200|neutral1_800"},
        {"on_surface", "on_surface", "neutral1_900|neutral1_100"},
        {"function", "secondary_container", "accent2_100|accent2_700"},
        {"on_function", "on_secondary_container", "accent2_900|accent2_100"},
        {"primary", "primary", "accent1_600|accent1_200"},
        {"primary_container", "primary_container", "accent1_100|accent1_700"},
        {"outline", "outline_variant", "neutral2_200|neutral2_700"},
    };

    /** Native variable to role. Shared by ordinary and bordered sheets. */
    private static final String[][] DYNAMIC_STYLE_ROLES = {
        {"color_base", "base"},
        {"color_header", "surface"},
        {"color_popup_background", "high"},
        {"color_access_points_menu_background", "surface"},
        {"color_access_point_panel_item_background", "surface"},
        {"color_label", "on_surface"},
        {"color_label_header_active", "on_surface"},
        {"color_popup_label", "on_surface"},
        {"color_icon", "on_surface"},
        {"color_label_function_key", "on_surface"},
        {"color_label_space_key", "on_surface"},
        {"color_icon_action", "on_function"},
        {"color_state_action", "function"},
        {"color_action_default", "primary"},
        {"color_label_dynamic", "primary"},
        {"color_keyboard_editing_button", "primary"},
        {"color_keyboard_editing_button_background", "primary_container"},
        {"color_key_paging_scrollbar", "primary"},
        {"color_notice_text", "primary"},
        {"color_state_popup_item_pressed", "primary_container"},
        {"color_generic_extension_background_activated", "function"},
        {"color_keyboard_separator", "outline"},
        {"color_state_border_key_action", "function"},
        {"color_state_space_bar", "letter"},
    };

    private static final Charset UTF_8 = Charset.forName("UTF-8");

    private SystemAutoThemeCompat() {}

    public static boolean isEnabled(Context context) {
        return preferences(context).getBoolean(AUTO_THEME_KEY, false);
    }

    public static void setEnabled(Context context, boolean enabled) {
        ensureInitialized(context);
        SharedPreferences.Editor editor = preferences(context).edit()
                .remove(SELECTION_SLOT_KEY);
        if (enabled) {
            // The two automatic modes cannot both own the resolved theme pair.
            editor.putBoolean(AUTO_THEME_KEY, true).remove(DYNAMIC_THEME_KEY);
        } else {
            editor.remove(AUTO_THEME_KEY);
        }
        editor.commit();
        applyConfiguredTheme(context, context.getResources().getConfiguration());
    }

    /** Whether the platform exposes a Material You palette at all. */
    public static boolean supportsDynamicColor() {
        return Build.VERSION.SDK_INT >= DYNAMIC_MIN_SDK;
    }

    public static boolean isDynamicEnabled(Context context) {
        return supportsDynamicColor()
                && preferences(context).getBoolean(DYNAMIC_THEME_KEY, false);
    }

    /**
     * Enables or disables the generated-palette slot.
     *
     * <p>Enabling suppresses automatic selection: both follow the system light
     * and dark switch, so letting them both write the resolved pair would make
     * the owner ambiguous. Disabling suppresses nothing, so the previous
     * follow-system or fixed choice is restored untouched.</p>
     */
    public static void setDynamicEnabled(Context context, boolean enabled) {
        ensureInitialized(context);
        SharedPreferences.Editor editor = preferences(context).edit()
                .remove(SELECTION_SLOT_KEY);
        if (enabled) {
            editor.putBoolean(DYNAMIC_THEME_KEY, true).remove(AUTO_THEME_KEY);
        } else {
            editor.remove(DYNAMIC_THEME_KEY);
        }
        editor.commit();
        applyConfiguredTheme(context, context.getResources().getConfiguration());
    }

    /** Called before launching the original selector in one-slot assignment mode. */
    public static void beginSelection(Context context, String slot) {
        ensureInitialized(context);
        boolean automatic = isEnabled(context);
        if (!isSelectableSlot(slot)
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
        if (!isSelectableSlot(slot)) {
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

    /** Legacy fixed-theme selection exits every automatic mode unless a slot session owns it. */
    public static void disable(Context context) {
        ensureInitialized(context);
        if (hasSelectionSession(context)) {
            return;
        }
        preferences(context).edit()
                .remove(AUTO_THEME_KEY)
                .remove(DYNAMIC_THEME_KEY)
                .commit();
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
        if (hasSelectionSession(context)) {
            return false;
        }
        // The generated palette follows the same light and dark switch, so it
        // has to be resolved on a configuration change too. Leaving it out
        // would refresh the palette only on the next process start, and the
        // keyboard would keep drawing the mode the user just left.
        if (isDynamicEnabled(context)) {
            return applyConfiguredTheme(context, configuration);
        }
        if (!isEnabled(context)) {
            return false;
        }
        return writeSlot(
                context,
                isDark(configuration) ? SLOT_DARK : SLOT_LIGHT,
                isDark(configuration) ? "resolved target=dark" : "resolved target=light");
    }

    /**
     * Keyboard-popup checkpoint for the generated palette.
     *
     * <p>A wallpaper change alters the system palette without raising any
     * configuration change, so the only cheap way to notice is to compare the
     * resolved palette on a hook that already runs constantly. When the
     * signature is unchanged this costs a preference read plus the palette
     * lookups and writes nothing.</p>
     */
    public static boolean applyOnKeyboardShown(Context context) {
        if (!isDynamicEnabled(context)) {
            return false;
        }
        ensureInitialized(context);
        return applyConfiguredTheme(context, context.getResources().getConfiguration());
    }

    /** Debug builds only: records framework rebuild without settings or text data. */
    public static void logInputViewRebuild(Context context) {
        debugLog(context, "rebuilding InputView after automatic theme resolution");
    }

    private static boolean applyConfiguredTheme(Context context, Configuration configuration) {
        if (hasSelectionSession(context)) {
            return false;
        }
        if (isDynamicEnabled(context)) {
            boolean dark = isDark(configuration);
            int sync = syncDynamicTheme(context, dark);
            if (sync != SYNC_UNAVAILABLE) {
                boolean written = writeSlot(
                        context,
                        SLOT_DYNAMIC,
                        dark ? "resolved target=dynamic-dark" : "resolved target=dynamic-light");
                // A rebuilt package changes what the view should draw even when
                // the resolved preference pair is byte-identical, so the caller
                // must rebuild the view for the new palette to appear.
                return sync == SYNC_REBUILT || written;
            }
            // The generated package is unavailable. Pointing the runtime at a
            // file that is not there would fail the original metadata check and
            // drop the keyboard to the built-in default, which is worse than
            // simply keeping the theme the user already had. Fall through and
            // resolve normally instead; the next palette change retries.
            debugLog(context, "dynamic package unavailable, resolving the legacy pair");
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
        if (keyboardTheme.isEmpty() || additionalTheme.isEmpty()) {
            // An empty pair means the slot was never initialized. Writing it
            // would point the runtime at nothing and drop the keyboard to the
            // built-in default, which is worse than keeping the theme the user
            // already has. The slot resolves normally once it is filled in.
            debugLog(context, "theme slot is empty, keeping the current theme");
            return false;
        }
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

    /**
     * Makes sure the generated package matches the current palette.
     *
     * <p>Returns whether a usable package exists and whether it had to be
     * rebuilt, which are different questions. An unchanged palette with a
     * package already on disk is the common path and reports
     * {@link #SYNC_UNCHANGED}; a failed build still reports a usable package
     * when a previous one survived, because a slightly stale palette beats no
     * palette at all.</p>
     */
    private static int syncDynamicTheme(Context context, boolean dark) {
        Map<String, Integer> colors = resolveDynamicColors(context, dark);
        if (colors == null) {
            debugLog(context, "system palette unavailable, retaining the ordinary theme");
            return SYNC_UNAVAILABLE;
        }
        String signature = dynamicSignature(dark, colors);
        SharedPreferences preferences = preferences(context);
        File target = new File(context.getFilesDir(), DYNAMIC_PACKAGE_NAME);
        if (target.isFile()
                && signature.equals(preferences.getString(DYNAMIC_SIGNATURE_KEY, null))) {
            debugLog(context, "dynamic palette unchanged");
            return SYNC_UNCHANGED;
        }
        if (!buildDynamicThemePackage(context, dark, colors)) {
            debugLog(context, "dynamic theme package build failed");
            return target.isFile() ? SYNC_UNCHANGED : SYNC_UNAVAILABLE;
        }
        preferences.edit().putString(DYNAMIC_SIGNATURE_KEY, signature).commit();
        debugLog(context, "dynamic theme package rebuilt");
        return SYNC_REBUILT;
    }

    /** Native icon-binding extension; only generated dynamic themes own this path. */
    public static synchronized void applyDynamicFunctionIcon(Context context, int keyId, ImageView icon) {
        if (icon.getId() != PRIMARY_ICON_ID) return;
        boolean functionKey = false;
        for (int supported : DYNAMIC_FUNCTION_KEYS) {
            if (keyId == supported) { functionKey = true; break; }
        }
        if (!functionKey || !isDynamicEnabled(context)) return;
        String active = preferences(context).getString(context.getString(PREF_KEY_ADDITIONAL_THEME), null);
        if (!(DYNAMIC_ADDITIONAL_PREFIX + DYNAMIC_PACKAGE_NAME).equals(active)) return;
        Drawable drawable = icon.getDrawable();
        if (!(drawable instanceof BitmapDrawable)) return;
        Bitmap source = ((BitmapDrawable)drawable).getBitmap();
        Bitmap normalized = DYNAMIC_ICON_MASKS.get(source);
        if (normalized == null) {
            int width = source.getWidth();
            int height = source.getHeight();
            int[] pixels = new int[width * height];
            source.getPixels(pixels, 0, width, 0, 0, width, height);
            int maximum = 0;
            for (int pixel : pixels) maximum = Math.max(maximum, pixel >>> 24);
            if (maximum != LEGACY_FUNCTION_ICON_ALPHA) return;
            for (int index = 0; index < pixels.length; index++) {
                int alpha = (pixels[index] >>> 24) * 255 / LEGACY_FUNCTION_ICON_ALPHA;
                pixels[index] = (pixels[index] & 0xffffff) | (alpha << 24);
            }
            normalized = Bitmap.createBitmap(pixels, width, height, Bitmap.Config.ARGB_8888);
            normalized.setDensity(source.getDensity());
            DYNAMIC_ICON_MASKS.put(source, normalized);
        }
        icon.setImageBitmap(normalized);
        icon.getDrawable().setColorFilter(drawable.getColorFilter());
        icon.getDrawable().setAlpha(drawable.getAlpha());
    }

    private static String modeStem(String entry, boolean dark) {
        int separator = entry.indexOf('|');
        if (separator < 0) return entry;
        return dark ? entry.substring(separator + 1) : entry.substring(0, separator);
    }

    /** Resolves complete roles instead of mixing missing roles with template teal. */
    private static Map<String, Integer> resolveDynamicColors(Context context, boolean dark) {
        Map<String, Integer> roles = new HashMap<String, Integer>();
        for (String[] role : DYNAMIC_COLOR_ROLES) {
            String semantic = "system_" + modeStem(role[1], dark)
                    + (dark ? "_dark" : "_light");
            Integer value = systemColor(context, semantic);
            if (value == null) {
                value = systemColor(context, "system_" + modeStem(role[2], dark));
            }
            if (value == null) return null;
            roles.put(role[0], value);
        }
        return roles;
    }

    private static Integer systemColor(Context context, String name) {
        Resources resources = context.getResources();
        int identifier = resources.getIdentifier(name, "color", "android");
        if (identifier == 0) return null;
        try {
            return Integer.valueOf(resources.getColor(identifier, context.getTheme()));
        } catch (Resources.NotFoundException unavailable) {
            return null;
        }
    }

    /** A 10% foreground state layer, using integer channel compositing. */
    private static int pressedColor(int background, int foreground) {
        int result = 0xff000000;
        for (int shift = 0; shift <= 16; shift += 8) {
            int base = (background >>> shift) & 255;
            int front = (foreground >>> shift) & 255;
            result |= ((base * 9 + front) / 10) << shift;
        }
        return result;
    }

    private static Map<String, Integer> dynamicStyleColors(
            Map<String, Integer> roles, boolean dark, boolean bordered) {
        Map<String, Integer> colors = new TreeMap<String, Integer>();
        for (String[] slot : DYNAMIC_STYLE_ROLES) {
            colors.put(slot[0], roles.get(slot[1]));
        }
        int function = roles.get("function").intValue();
        int onFunction = roles.get("on_function").intValue();
        int onSurface = roles.get("on_surface").intValue();
        int letter = roles.get("letter").intValue();
        int functionPressed = pressedColor(function, onFunction);
        int letterPressed = dark ? pressedColor(letter, onSurface)
                : roles.get("highest").intValue();
        colors.put("color_state_action_pressed", Integer.valueOf(functionPressed));
        colors.put("color_state_border_key_action_pressed", Integer.valueOf(functionPressed));
        colors.put("color_state_space_bar_pressed", Integer.valueOf(letterPressed));
        if (bordered) {
            colors.put("color_state_key", Integer.valueOf(letter));
            colors.put("color_state_key_pressed", Integer.valueOf(letterPressed));
            colors.put("color_state_key_dark", Integer.valueOf(function));
            colors.put("color_state_key_dark_pressed", Integer.valueOf(functionPressed));
            colors.put("color_icon", Integer.valueOf(onFunction));
            colors.put("color_label_function_key", Integer.valueOf(onFunction));
        } else {
            int background = roles.get("base").intValue();
            colors.put("color_state_key_pressed", Integer.valueOf(pressedColor(background, onSurface)));
            colors.put("color_state_key_dark_pressed", Integer.valueOf(pressedColor(background, onSurface)));
        }
        return colors;
    }

    private static String dynamicSignature(boolean dark, Map<String, Integer> colors) {
        StringBuilder builder = new StringBuilder(dark ? MODE_DARK : MODE_LIGHT);
        builder.append("@v").append(THEME_PACKAGE_FORMAT_VERSION);
        builder.append("@r").append(DYNAMIC_PALETTE_REVISION);
        for (String[] role : DYNAMIC_COLOR_ROLES) {
            builder.append(':').append(Integer.toHexString(colors.get(role[0]).intValue()));
        }
        return builder.toString();
    }

    /**
     * Writes the generated package through a temporary file and swaps it in.
     *
     * <p>A half-written package would fail the original metadata check and drop
     * the keyboard to the default theme, so the swap either replaces the whole
     * file or leaves the previous one untouched.</p>
     */
    private static boolean buildDynamicThemePackage(
            Context context, boolean dark, Map<String, Integer> colors) {
        String mode = dark ? MODE_DARK : MODE_LIGHT;
        String materialName = MATERIAL_TEMPLATE_PREFIX + mode + ".binarypb";
        String borderName = MATERIAL_TEMPLATE_PREFIX + mode + "_border.binarypb";
        Map<String, Integer> mainColors = dynamicStyleColors(colors, dark, false);
        Map<String, Integer> borderColors = dynamicStyleColors(colors, dark, true);
        String[] entries = dark ? DYNAMIC_ENTRIES_DARK : DYNAMIC_ENTRIES_LIGHT;
        byte[][] payloads = new byte[entries.length][];
        for (int index = 0; index < entries.length; index++) {
            String name = entries[index];
            byte[] data = templateBytes(context, name);
            if (data == null) {
                debugLog(context, "dynamic template missing: " + name);
                return false;
            }
            if (materialName.equals(name)) {
                data = rewriteStyleSheetColors(data, mainColors);
            } else if (borderName.equals(name)) {
                data = rewriteStyleSheetColors(data, borderColors);
            }
            if (data == null) {
                debugLog(context, "dynamic style sheet rewrite failed");
                return false;
            }
            payloads[index] = data;
        }
        byte[] metadata = templateBytes(context, METADATA_TEMPLATE_PREFIX + mode + ".binarypb");
        if (metadata == null) {
            debugLog(context, "dynamic template missing: metadata");
            return false;
        }

        ByteArrayOutputStream versioned = new ByteArrayOutputStream(metadata.length + 2);
        versioned.write(0x08);
        versioned.write(THEME_PACKAGE_FORMAT_VERSION);
        versioned.write(metadata, 0, metadata.length);
        metadata = versioned.toByteArray();

        File target = new File(context.getFilesDir(), DYNAMIC_PACKAGE_NAME);
        File temporary = new File(context.getFilesDir(), DYNAMIC_PACKAGE_TEMP_NAME);
        ZipOutputStream zip = null;
        try {
            zip = new ZipOutputStream(new FileOutputStream(temporary));
            putStoredEntry(zip, METADATA_ENTRY, metadata);
            for (int index = 0; index < entries.length; index++) {
                putStoredEntry(zip, entries[index], payloads[index]);
            }
            // Closing writes the central directory. A failure here must not
            // publish an incomplete archive or mark the palette as rebuilt.
            zip.close();
        } catch (IOException e) {
            debugLog(context, "dynamic theme package write failed");
            closeQuietly(zip);
            temporary.delete();
            return false;
        }

        if (!temporary.renameTo(target)) {
            // Both paths are in the app's files directory. If replacement
            // fails, retain the previous usable package for the caller.
            temporary.delete();
            debugLog(context, "dynamic theme package replace failed");
            return false;
        }
        return true;
    }

    /**
     * Recolors a StyleSheetProto message in place.
     *
     * <p>Wire format:
     * <pre>
     * StyleSheet          field 2 (0x12) = repeated StyleRule
     * StyleRule           field 1 (0x0a) = string  property name
     *                     field 2 (0x12) = StylePropertyValue
     *                     field 3 (0x1a) = int     selector
     * StylePropertyValue  field 1 (0x08) = int     ARGB color
     *                     field 2 (0x12) = repeated int
     * </pre>
     *
     * <p>Only a rule whose value block is a bare color varint is rebuilt, and
     * only its length is recomputed. Every other byte is passed through
     * untouched, so a rule this mapping does not know about cannot be damaged
     * by a parse it never needed.</p>
     */
    public static byte[] rewriteStyleSheetColors(byte[] source, Map<String, Integer> colorMap) {
        if (source == null || colorMap == null) {
            return null;
        }
        ByteArrayOutputStream output = new ByteArrayOutputStream(source.length);
        Set<String> present = new HashSet<String>();
        int total = source.length;
        int position = 0;
        while (position < total) {
            if ((source[position] & 0xFF) != 0x12) {
                break;
            }
            position++;
            long[] length = new long[1];
            position = readVarint(source, position, length);
            if (position < 0) {
                return null;
            }
            int ruleStart = position;
            int ruleEnd = ruleStart + (int) length[0];
            if (ruleEnd > total || ruleEnd < ruleStart) {
                return null;
            }

            String name = null;
            boolean hasColor = false;
            int selector = 0;
            boolean hasSelector = false;

            int cursor = ruleStart;
            while (cursor < ruleEnd) {
                int tag = source[cursor] & 0xFF;
                cursor++;
                if (tag == 0x0A) {
                    long[] nameLength = new long[1];
                    cursor = readVarint(source, cursor, nameLength);
                    if (cursor < 0) {
                        return null;
                    }
                    int nameEnd = cursor + (int) nameLength[0];
                    if (nameEnd > ruleEnd) {
                        return null;
                    }
                    name = new String(source, cursor, (int) nameLength[0], UTF_8);
                    cursor = nameEnd;
                } else if (tag == 0x12) {
                    long[] valueLength = new long[1];
                    cursor = readVarint(source, cursor, valueLength);
                    if (cursor < 0) {
                        return null;
                    }
                    int valueEnd = cursor + (int) valueLength[0];
                    if (valueEnd > ruleEnd) {
                        return null;
                    }
                    if (cursor < valueEnd && (source[cursor] & 0xFF) == 0x08) {
                        long[] value = new long[1];
                        if (readVarint(source, cursor + 1, value) < 0) {
                            return null;
                        }
                        hasColor = true;
                    }
                    cursor = valueEnd;
                } else if (tag == 0x1A) {
                    long[] value = new long[1];
                    cursor = readVarint(source, cursor, value);
                    if (cursor < 0) {
                        return null;
                    }
                    selector = (int) value[0];
                    hasSelector = true;
                } else {
                    cursor = ruleEnd;
                }
            }

            if (name != null) present.add(name);
            Integer replacement = name == null ? null : colorMap.get(name);
            if (replacement != null && hasColor) {
                writeColorRule(output, name, replacement.intValue(), hasSelector, selector);
            } else {
                int ruleLength = ruleEnd - ruleStart;
                output.write(0x12);
                writeVarint(output, ruleLength);
                output.write(source, ruleStart, ruleLength);
            }
            position = ruleEnd;
        }
        // Border sheets can override variables declared only in the main sheet.
        // Append their definitions in stable order instead of retaining a main
        // foreground while changing the corresponding key fill.
        for (Map.Entry<String, Integer> entry : new TreeMap<String, Integer>(colorMap).entrySet()) {
            if (present.contains(entry.getKey())) continue;
            writeColorRule(output, entry.getKey(), entry.getValue().intValue(), false, 0);
        }
        return output.toByteArray();
    }

    private static void writeColorRule(ByteArrayOutputStream output, String name,
            int color, boolean hasSelector, int selector) {
        byte[] nameBytes = name.getBytes(UTF_8);
        ByteArrayOutputStream value = new ByteArrayOutputStream();
        value.write(0x08);
        writeVarint(value, color & 0xffffffffL);
        byte[] payload = value.toByteArray();
        ByteArrayOutputStream body = new ByteArrayOutputStream();
        body.write(0x0a);
        writeVarint(body, nameBytes.length);
        body.write(nameBytes, 0, nameBytes.length);
        body.write(0x12);
        writeVarint(body, payload.length);
        body.write(payload, 0, payload.length);
        if (hasSelector) {
            body.write(0x1a);
            writeVarint(body, selector & 0xffffffffL);
        }
        byte[] rule = body.toByteArray();
        output.write(0x12);
        writeVarint(output, rule.length);
        output.write(rule, 0, rule.length);
    }

    private static byte[] templateBytes(Context context, String name) {
        InputStream input = null;
        try {
            input = context.getAssets().open(ASSET_DIRECTORY + name);
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            byte[] buffer = new byte[4096];
            int read;
            while ((read = input.read(buffer)) > 0) {
                output.write(buffer, 0, read);
            }
            return output.toByteArray();
        } catch (IOException e) {
            return null;
        } finally {
            closeQuietly(input);
        }
    }

    /** Stored, not deflated: the package is tiny and stays byte-comparable to the templates. */
    private static void putStoredEntry(ZipOutputStream zip, String name, byte[] data)
            throws IOException {
        CRC32 crc = new CRC32();
        crc.update(data);
        ZipEntry entry = new ZipEntry(name);
        entry.setMethod(ZipEntry.STORED);
        entry.setSize(data.length);
        entry.setCompressedSize(data.length);
        entry.setCrc(crc.getValue());
        zip.putNextEntry(entry);
        zip.write(data);
        zip.closeEntry();
    }

    /** Returns the next position, or -1 when the value does not fit or is truncated. */
    private static int readVarint(byte[] buffer, int position, long[] outValue) {
        long value = 0L;
        int shift = 0;
        while (true) {
            if (position >= buffer.length || shift > 63) {
                return -1;
            }
            int current = buffer[position] & 0xFF;
            position++;
            value |= ((long) (current & 0x7F)) << shift;
            if ((current & 0x80) == 0) {
                break;
            }
            shift += 7;
        }
        outValue[0] = value;
        return position;
    }

    private static void writeVarint(ByteArrayOutputStream output, long value) {
        while (true) {
            int current = (int) (value & 0x7F);
            value >>>= 7;
            if (value != 0L) {
                output.write(current | 0x80);
            } else {
                output.write(current);
                return;
            }
        }
    }

    private static void closeQuietly(Closeable closeable) {
        if (closeable == null) {
            return;
        }
        try {
            closeable.close();
        } catch (IOException ignored) {
            // Closing a stream that is already gone changes nothing for us.
        }
    }

    /**
     * Fills in every slot key that is not on disk yet.
     *
     * <p>A single one-shot flag used to guard this whole routine, so a device
     * initialized by an earlier release never received the keys of a slot added
     * later: the flag was already set and the routine returned before writing
     * them. The generated-palette slot shipped that way, which made it work on
     * a fresh install and stay invisible on every upgrade. Deciding per key
     * instead makes the routine idempotent, so a slot added now reaches an
     * install that predates it.</p>
     *
     * <p>Existing keys are never rewritten. Three of the four slots hold a
     * choice the user made, and initialization must not overwrite it.</p>
     */
    private static synchronized void ensureInitialized(Context context) {
        SharedPreferences preferences = preferences(context);
        if (hasEverySlotKey(preferences)) {
            return;
        }
        SharedPreferences.Editor editor = preferences.edit();
        if (!preferences.contains(FIXED_BASE_KEY) || !preferences.contains(FIXED_ADDITIONAL_KEY)) {
            // Only the fixed slot mirrors whichever theme is live, and only
            // while it is still empty. Once it holds a choice, reading the live
            // theme again would replace that choice with a derived value.
            String[] current = resolveCurrentTheme(context);
            putIfAbsent(editor, preferences, FIXED_BASE_KEY, current[0]);
            putIfAbsent(editor, preferences, FIXED_ADDITIONAL_KEY, current[1]);
        }
        String baseMaterial = context.getString(BASE_MATERIAL_THEME);
        putIfAbsent(editor, preferences, LIGHT_BASE_KEY, baseMaterial);
        putIfAbsent(editor, preferences, LIGHT_ADDITIONAL_KEY, context.getString(MATERIAL_LIGHT_THEME));
        putIfAbsent(editor, preferences, DARK_BASE_KEY, baseMaterial);
        putIfAbsent(editor, preferences, DARK_ADDITIONAL_KEY, context.getString(MATERIAL_DARK_THEME));
        putIfAbsent(editor, preferences, DYNAMIC_BASE_KEY, baseMaterial);
        putIfAbsent(
                editor,
                preferences,
                DYNAMIC_ADDITIONAL_KEY,
                DYNAMIC_ADDITIONAL_PREFIX + DYNAMIC_PACKAGE_NAME);
        editor.commit();
    }

    private static void putIfAbsent(
            SharedPreferences.Editor editor, SharedPreferences preferences, String key, String value) {
        if (!preferences.contains(key)) {
            editor.putString(key, value);
        }
    }

    /** Every slot key this build knows about, which is what makes init idempotent. */
    private static boolean hasEverySlotKey(SharedPreferences preferences) {
        return preferences.contains(FIXED_BASE_KEY)
                && preferences.contains(FIXED_ADDITIONAL_KEY)
                && preferences.contains(LIGHT_BASE_KEY)
                && preferences.contains(LIGHT_ADDITIONAL_KEY)
                && preferences.contains(DARK_BASE_KEY)
                && preferences.contains(DARK_ADDITIONAL_KEY)
                && preferences.contains(DYNAMIC_BASE_KEY)
                && preferences.contains(DYNAMIC_ADDITIONAL_KEY);
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
        return isSelectableSlot(preferences(context).getString(SELECTION_SLOT_KEY, null));
    }

    /** Slots a user may pick in the original selector. The generated slot is never one. */
    private static boolean isSelectableSlot(String slot) {
        return SLOT_LIGHT.equals(slot) || SLOT_DARK.equals(slot) || SLOT_FIXED.equals(slot);
    }

    private static String baseKey(String slot) {
        if (SLOT_LIGHT.equals(slot)) return LIGHT_BASE_KEY;
        if (SLOT_DARK.equals(slot)) return DARK_BASE_KEY;
        if (SLOT_FIXED.equals(slot)) return FIXED_BASE_KEY;
        if (SLOT_DYNAMIC.equals(slot)) return DYNAMIC_BASE_KEY;
        throw new IllegalArgumentException("Unknown theme slot");
    }

    private static String additionalKey(String slot) {
        if (SLOT_LIGHT.equals(slot)) return LIGHT_ADDITIONAL_KEY;
        if (SLOT_DARK.equals(slot)) return DARK_ADDITIONAL_KEY;
        if (SLOT_FIXED.equals(slot)) return FIXED_ADDITIONAL_KEY;
        if (SLOT_DYNAMIC.equals(slot)) return DYNAMIC_ADDITIONAL_KEY;
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
