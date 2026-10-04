package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    /**
     * The preview renderer's rasterised keyboards, as it names them.
     *
     * <p>Each file is one drawn keyboard, keyed on the theme value it was drawn
     * from, so every file with this prefix belongs to exactly one value and
     * holds the palette that value had when it was last drawn.</p>
     */
    private static final String SNAPSHOT_CACHE_PREFIX = "keyboardsnapshotcache_";
    private static final String SNAPSHOT_CACHE_SUFFIX = ".png";

    private static final String ASSET_DIRECTORY = "theme/";
    private static final String METADATA_ENTRY = "metadata.binarypb";
    private static final String MATERIAL_TEMPLATE_PREFIX = "style_sheet_material_";
    private static final String METADATA_TEMPLATE_PREFIX = "theme_package_metadata_material_";
    private static final String MODE_LIGHT = "light";
    private static final String MODE_DARK = "dark";

    /**
     * The theme-package format the generated package declares.
     *
     * <p>The engine reads a package's format version from field 1 of its
     * metadata and picks a style-sheet converter from it. The built-in packages
     * live in the APK's assets, which the engine loads without consulting the
     * version at all; a package under {@code files:} does not get that
     * exemption. A package that declares no version reads as version 0, which
     * the engine takes for a legacy CSS-era theme and rewrites on the way in:
     * every selector that names a key loses that name, and a rule left with no
     * selector at all is dropped. The keyboard's keys then match nothing and
     * fall back to the built-in colours, while the theme grid - which draws no
     * keys - looks correct. That is why a generated package has to say which
     * format it is in.</p>
     *
     * <p>Versions 1 and 2 select the older converter chains and anything above
     * 2 selects the pass-through converter, so this is the first version that
     * means "already current". The sheets copied into the package are the
     * current ones, so the pass-through is the right choice.</p>
     */
    private static final int THEME_PACKAGE_FORMAT_VERSION = 3;

    /** Protobuf tag for field 1 as a varint: field number 1, wire type 0. */
    private static final int METADATA_VERSION_TAG = 0x08;

    /**
     * Which set of slots the generator writes, as opposed to which format the
     * package is in.
     *
     * <p>The signature doubles as the cache key for the file on disk, so a
     * generator that starts writing different colors has to change it or the
     * previous package keeps being served: the palette it holds still matches,
     * so the sync reports "unchanged" and the new sheet is never built. Revision
     * 1 colored only {@code style_sheet_material_<mode>.binarypb}; revision 2
     * also colors the border sheet that the engine swaps in when key borders
     * are on; revision 3 gives that sheet's key fills enough contrast against
     * {@code color_base} to be visible at all.</p>
     */
    private static final int DYNAMIC_PALETTE_REVISION = 3;

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
     * The entry named {@code style_sheet_material_<mode>.binarypb} is recolored
     * from the palette, and so is {@code style_sheet_material_<mode>_border
     * .binarypb} - the engine layers the latter over the former whenever key
     * borders are on. Every other entry is copied byte for byte.
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
     * Keyboard style slot to Material You color name. The concrete resource is
     * this name plus {@code _light} or {@code _dark}. Both arrays must stay in
     * step; they are parallel by index so the mapping reads as a table.
     */
    private static final String[] DYNAMIC_SLOT_NAMES = {
        "color_base",
        "color_header",
        "color_popup_background",
        "color_access_points_menu_background",
        "color_access_point_panel_item_background",
        "color_label",
        "color_label_header_active",
        "color_popup_label",
        "color_icon",
        "color_state_action",
        "color_state_action_pressed",
        "color_action_default",
        "color_label_dynamic",
        "color_keyboard_editing_button",
        "color_keyboard_editing_button_background",
        "color_key_paging_scrollbar",
        "color_notice_text",
        "color_state_popup_item_pressed",
        "color_generic_extension_background_activated",
        "color_keyboard_separator",
    };
    private static final String[] DYNAMIC_SLOT_RESOURCES = {
        "system_surface",
        "system_surface_container",
        "system_surface_container_high",
        "system_surface",
        "system_surface",
        "system_on_surface",
        "system_on_surface",
        "system_on_surface",
        "system_on_surface_variant",
        "system_primary",
        "system_primary_container",
        "system_primary",
        "system_primary",
        "system_primary",
        "system_primary_container",
        "system_primary",
        "system_primary",
        "system_primary_container",
        "system_secondary_container",
        "system_outline_variant",
    };

    /**
     * Border-sheet variable to the keyboard slot it takes its color from.
     *
     * <p>When key borders are on the engine layers
     * {@code style_sheet_material_<mode>_border.binarypb} over the material
     * sheet, and every variable it declares wins over the material one. The
     * template's border sheet is not palette-neutral: it carries the Material
     * demo's teal in {@code color_state_border_key_action}, so a generated
     * package that copies it verbatim paints the action key teal even though
     * the material sheet says otherwise. Each built-in theme's border sheet
     * carries that theme's own colors, which is what these entries restore.</p>
     *
     * <p>The key fills are the reason this table cannot just point at
     * {@code color_base}. In the material sheet {@code color_state_key} and
     * {@code color_state_key_dark} are fully transparent: the keyboard paints
     * one flat {@code color_base} and the keys are only told apart by the
     * shadow each key view casts. The border sheet replaces them with opaque
     * fills, and that is the whole mechanism behind the "key borders" switch -
     * an inset opaque key against the sheet's own base colour. A border sheet
     * whose key fill equals {@code color_base} therefore renders as a flat
     * slab: the switch appears to do nothing, and the preview, which never
     * draws the per-key shadow, shows only the keys that happen to differ.
     * The template keeps a deliberate gap - light {@code #fbfbfc} keys on
     * {@code #eceff1}, dark {@code #404a50} keys on {@code #263238} - and the
     * entries below reproduce it from the surface container ramp, which is the
     * one family guaranteed to differ from {@code system_surface} in both
     * modes (lighter in dark, darker in light).</p>
     *
     * <p>Sources name slots from {@link #DYNAMIC_SLOT_NAMES}, so no platform
     * resource is read twice and the palette signature needs no extra terms.
     * Both arrays are parallel by index.</p>
     */
    private static final String[] BORDER_SHEET_NAMES = {
        "color_state_key",
        "color_state_key_dark",
        "color_state_key_pressed",
        "color_state_key_dark_pressed",
        "color_label_space_key",
        "color_state_border_key_action",
        "color_state_border_key_action_pressed",
    };
    private static final String[] BORDER_SHEET_SOURCES = {
        "color_header",
        "color_popup_background",
        "color_generic_extension_background_activated",
        "color_generic_extension_background_activated",
        "color_icon",
        "color_action_default",
        "color_state_action_pressed",
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

    /**
     * Builds the generated palette package without changing which theme is in use.
     *
     * <p>The palette has no package until something generates one, and the
     * settings screen has to draw the mode before it is switched on. Building it
     * here rather than switching the mode on keeps the two apart: the caller
     * gets a package to render, and the theme the keyboard is actually using
     * stays where it was. Nothing outside the package file and its signature is
     * touched, so calling this twice in a row is a no-op.</p>
     *
     * <p>Returns the value the package is addressed by, or {@code null} when the
     * platform has no palette to build from or the build failed.</p>
     */
    public static String prepareDynamicTheme(Context context) {
        if (!supportsDynamicColor()) {
            return null;
        }
        ensureInitialized(context);
        boolean dark = isDark(context.getResources().getConfiguration());
        if (syncDynamicTheme(context, dark) == SYNC_UNAVAILABLE) {
            return null;
        }
        return DYNAMIC_ADDITIONAL_PREFIX + DYNAMIC_PACKAGE_NAME;
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
        // The new package is in place and the value addressing it has not
        // changed, so every preview drawn from the previous palette is now
        // showing the wrong colours. Drop them here, after the package has been
        // swapped in, so a preview requested from now on redraws from the new
        // one instead of being served the old bitmap.
        invalidatePreviewSnapshots(context);
        debugLog(context, "dynamic theme package rebuilt");
        return SYNC_REBUILT;
    }

    /** Reads the platform palette by resource name; missing entries keep the template color. */
    private static Map<String, Integer> resolveDynamicColors(Context context, boolean dark) {
        Resources resources = context.getResources();
        Resources.Theme theme = context.getTheme();
        String suffix = dark ? "_dark" : "_light";
        Map<String, Integer> colors = new HashMap<String, Integer>();
        for (int index = 0; index < DYNAMIC_SLOT_NAMES.length; index++) {
            String resource = DYNAMIC_SLOT_RESOURCES[index] + suffix;
            int identifier = resources.getIdentifier(resource, "color", "android");
            if (identifier == 0) {
                continue;
            }
            try {
                colors.put(
                        DYNAMIC_SLOT_NAMES[index],
                        Integer.valueOf(resources.getColor(identifier, theme)));
            } catch (RuntimeException ignored) {
                // A ROM that declares the name but cannot resolve it falls back
                // to the template color for this one slot only.
            }
        }
        return colors;
    }

    /**
     * The palette entries the border sheet needs, read back by slot name.
     *
     * <p>A slot the platform did not resolve is left out, and the border sheet
     * then keeps the template value for that one variable - the same fallback
     * the material sheet uses.</p>
     */
    private static Map<String, Integer> borderSheetColors(Map<String, Integer> colors) {
        Map<String, Integer> border = new HashMap<String, Integer>();
        for (int index = 0; index < BORDER_SHEET_NAMES.length; index++) {
            Integer value = colors.get(BORDER_SHEET_SOURCES[index]);
            if (value != null) {
                border.put(BORDER_SHEET_NAMES[index], value);
            }
        }
        return border;
    }

    private static String dynamicSignature(boolean dark, Map<String, Integer> colors) {
        StringBuilder builder = new StringBuilder(dark ? MODE_DARK : MODE_LIGHT);
        // The format is part of what is being signed. Without it, a build that
        // writes a different format would find the previous build's file on
        // disk and keep it, because the palette it holds still matches.
        builder.append("@v").append(THEME_PACKAGE_FORMAT_VERSION);
        builder.append("@r").append(DYNAMIC_PALETTE_REVISION);
        for (int index = 0; index < DYNAMIC_SLOT_NAMES.length; index++) {
            Integer value = colors.get(DYNAMIC_SLOT_NAMES[index]);
            builder.append(':');
            if (value != null) {
                builder.append(Integer.toHexString(value.intValue()));
            }
        }
        return builder.toString();
    }

    /**
     * The template metadata with the package format declared.
     *
     * <p>The template carries the sheet list and the flavour table but no
     * version, so the field is prepended. Protobuf fields may appear in any
     * order and every reader here walks them by tag, so prepending is enough
     * and no other byte has to move.</p>
     */
    private static byte[] withFormatVersion(byte[] metadata) {
        ByteArrayOutputStream output = new ByteArrayOutputStream(metadata.length + 2);
        output.write(METADATA_VERSION_TAG);
        output.write(THEME_PACKAGE_FORMAT_VERSION);
        output.write(metadata, 0, metadata.length);
        return output.toByteArray();
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
        Map<String, Integer> borderColors = borderSheetColors(colors);
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
                data = rewriteStyleSheetColors(data, colors);
            } else if (borderName.equals(name)) {
                data = rewriteStyleSheetColors(data, borderColors);
            }
            if (data == null) {
                debugLog(context, "dynamic style sheet rewrite failed: " + name);
                return false;
            }
            payloads[index] = data;
        }
        byte[] metadata = templateBytes(context, METADATA_TEMPLATE_PREFIX + mode + ".binarypb");
        if (metadata == null) {
            debugLog(context, "dynamic template missing: metadata");
            return false;
        }
        metadata = withFormatVersion(metadata);

        File target = new File(context.getFilesDir(), DYNAMIC_PACKAGE_NAME);
        File temporary = new File(context.getFilesDir(), DYNAMIC_PACKAGE_TEMP_NAME);
        ZipOutputStream zip = null;
        try {
            zip = new ZipOutputStream(new FileOutputStream(temporary));
            putStoredEntry(zip, METADATA_ENTRY, metadata);
            for (int index = 0; index < entries.length; index++) {
                putStoredEntry(zip, entries[index], payloads[index]);
            }
        } catch (IOException e) {
            debugLog(context, "dynamic theme package write failed");
            closeQuietly(zip);
            temporary.delete();
            return false;
        }
        closeQuietly(zip);

        if (!temporary.renameTo(target)) {
            // Some volumes refuse an in-place replace; retry once without the
            // previous package so a stale file can never win over the new one.
            if (!target.delete() || !temporary.renameTo(target)) {
                temporary.delete();
                debugLog(context, "dynamic theme package replace failed");
                return false;
            }
        }
        return true;
    }

    /**
     * Drops the rasterised keyboards the renderer cached for the previous palette.
     *
     * <p>{@code KeyboardPreviewRenderer} stores one bitmap per theme value under
     * {@code keyboardsnapshotcache_<md5>.png} and builds the key from the value
     * string plus the screen shape, the view-definition set and the key-border
     * flag. Nothing in that key moves when this package is rebuilt under the
     * same name, so an entry drawn from an earlier palette keeps being served
     * forever and the preview shows colours the keyboard is no longer using.
     * Deleting the files is the whole fix: the renderer's only other cache is a
     * map on the renderer instance, and a renderer is built per render.</p>
     *
     * <p>Every snapshot goes, not just the generated theme's, because the file
     * name is a hash of a key that cannot be reconstructed from the value
     * alone. The cost is one re-render of the other themes' previews, which a
     * cold cache would have paid anyway, and the files are small.</p>
     *
     * <p>This runs on the rebuild path only. A palette that did not change
     * leaves the cache alone, so the common case - the hook that runs on every
     * keyboard show - still costs one preference read and no I/O.</p>
     */
    private static void invalidatePreviewSnapshots(Context context) {
        File[] directories = transientCacheDirectories(context);
        int removed = 0;
        for (int directory = 0; directory < directories.length; directory++) {
            File[] entries = directories[directory].listFiles();
            if (entries == null) {
                continue;
            }
            for (int entry = 0; entry < entries.length; entry++) {
                String name = entries[entry].getName();
                if (name.startsWith(SNAPSHOT_CACHE_PREFIX)
                        && name.endsWith(SNAPSHOT_CACHE_SUFFIX)
                        && entries[entry].delete()) {
                    removed++;
                }
            }
        }
        debugLog(context, "preview snapshots dropped: " + removed);
    }

    /**
     * The directories the renderer's transient caches can be in.
     *
     * <p>The renderer gives its cache a context backed by device-protected
     * storage, so from API 24 the snapshots sit outside the credential-protected
     * directory {@link Context#getFilesDir()} returns; below 24 there is no
     * device-protected storage and they sit in that directory. Both are derived
     * and scanned rather than asking for a device-protected context, because the
     * framework builds the path the same way - {@code LoadedApk} replaces
     * {@code /user/} with {@code /user_de/} in the data directory - so this
     * needs neither direct-boot awareness nor an API guard. A directory that is
     * not there simply yields nothing to delete.</p>
     */
    private static File[] transientCacheDirectories(Context context) {
        File credentialProtected = context.getFilesDir();
        if (credentialProtected == null) {
            return new File[0];
        }
        List<File> directories = new ArrayList<File>();
        directories.add(credentialProtected);
        String path = credentialProtected.getAbsolutePath();
        if (path.contains("/user/")) {
            directories.add(new File(path.replace("/user/", "/user_de/")));
        }
        return directories.toArray(new File[directories.size()]);
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
            long color = 0L;
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
                        color = value[0];
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

            Integer replacement = name == null ? null : colorMap.get(name);
            if (replacement != null && hasColor) {
                byte[] nameBytes = name.getBytes(UTF_8);
                ByteArrayOutputStream value = new ByteArrayOutputStream();
                value.write(0x08);
                writeVarint(value, replacement.longValue() & 0xFFFFFFFFL);
                byte[] valueBytes = value.toByteArray();

                ByteArrayOutputStream body = new ByteArrayOutputStream();
                body.write(0x0A);
                writeVarint(body, nameBytes.length);
                body.write(nameBytes, 0, nameBytes.length);
                body.write(0x12);
                writeVarint(body, valueBytes.length);
                body.write(valueBytes, 0, valueBytes.length);
                if (hasSelector) {
                    body.write(0x1A);
                    writeVarint(body, selector & 0xFFFFFFFFL);
                }
                byte[] bodyBytes = body.toByteArray();

                output.write(0x12);
                writeVarint(output, bodyBytes.length);
                output.write(bodyBytes, 0, bodyBytes.length);
            } else {
                int ruleLength = ruleEnd - ruleStart;
                output.write(0x12);
                writeVarint(output, ruleLength);
                output.write(source, ruleStart, ruleLength);
            }
            position = ruleEnd;
        }
        return output.toByteArray();
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
