package com.google.android.inputmethod.pinyin;

import android.content.Context;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Applies the stored shortcut preferences to the native quick-access entries.
 *
 * <p>The native manager builds its entry ids from {@code access_points_order} and keeps them in a
 * list plus a matching set. Rewriting both in place lets the stock bar render, lay out and handle
 * clicks exactly as before, while the user decides which entries exist and in what order.
 */
public final class AccessPointsOrder {

    private static final String PREFERENCES = "floating_keyboard_preferences";
    private static final String SHORTCUTS_KEY = "shortcuts";

    /**
     * Entries the floating card makes pointless.
     *
     * <p>One-handed mode rearranges a docked keyboard; the card is already movable, so the entry
     * only crowds the bar. It is filtered here rather than hidden afterwards because the stock bar
     * then never builds the view at all, which also survives its own re-inflates.
     */
    private static final String ONE_HANDED = "access_point_one_handed";

    private AccessPointsOrder() {
    }

    /**
     * Filters and reorders the native entry list in place.
     *
     * <p>Ids the stored list does not mention keep their relative position, so entries this screen
     * does not know about are left alone instead of disappearing.
     */
    public static void apply(Context context, List<String> ids, Set<String> known) {
        if (context == null || ids == null || ids.isEmpty()) return;

        boolean floating = FloatingKeyboardCompat.isEnabled(context);

        String raw = readShortcuts(context);
        if (raw == null || raw.isEmpty()) {
            if (floating) dropOneHanded(ids, known);
            return;
        }

        List<String> enabled = new ArrayList<String>();
        Set<String> disabled = new HashSet<String>();
        for (String item : raw.split("\\|")) {
            String[] parts = item.split(":");
            if (parts.length != 2) continue;
            String id = parts[0];
            if (id.isEmpty()) continue;
            if ("1".equals(parts[1])) {
                if (!enabled.contains(id)) enabled.add(id);
            } else {
                disabled.add(id);
            }
        }
        if (enabled.isEmpty() && disabled.isEmpty()) return;

        List<String> result = new ArrayList<String>();
        for (String id : enabled) {
            // Do not require the id to still be in the list. A shortcut that was switched off has
            // already been dropped from it, and checking would then never let it come back.
            // Ids the entry map does not know are skipped at render time anyway.
            if (!result.contains(id)) result.add(id);
        }
        for (String id : ids) {
            if (result.contains(id) || disabled.contains(id)) continue;
            result.add(id);
        }

        ids.clear();
        ids.addAll(result);

        if (floating) dropOneHanded(ids, known);

        if (known != null) {
            // The render pass treats this set as a whitelist, so a switched-off shortcut has to
            // leave it and a switched-on one has to come back. Dropping without re-adding is why a
            // disabled shortcut never reappeared until the process restarted. Ids that are not
            // entries at all, such as the expand trigger, are simply left alone.
            known.removeAll(disabled);
            known.addAll(enabled);
        }
    }

    /** Removes the one-handed entry while the card is on, restoring it as soon as it is off. */
    private static void dropOneHanded(List<String> ids, Set<String> known) {
        ids.remove(ONE_HANDED);
        if (known != null) known.remove(ONE_HANDED);
    }

    private static String readShortcuts(Context context) {
        String fromFile = readFromFile(context);
        if (fromFile != null && !fromFile.isEmpty()) return fromFile;
        try {
            return context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
                    .getString(SHORTCUTS_KEY, null);
        } catch (Throwable error) {
            android.util.Log.i("AccessPointsOrder", "shortcut preferences unreadable: " + error);
            return null;
        }
    }

    private static String readFromFile(Context context) {
        FileInputStream stream = null;
        try {
            File dir = context.getFilesDir().getParentFile();
            File file = new File(dir, "shared_prefs/" + PREFERENCES + ".xml");
            if (!file.isFile()) return null;
            stream = new FileInputStream(file);
            byte[] buffer = new byte[(int) file.length()];
            int read = stream.read(buffer);
            if (read <= 0) return null;
            String xml = new String(buffer, 0, read, "UTF-8");
            int start = xml.indexOf("name=\"" + SHORTCUTS_KEY + "\"");
            if (start < 0) return null;
            int valueStart = xml.indexOf('>', start);
            int valueEnd = xml.indexOf('<', valueStart);
            if (valueStart < 0 || valueEnd < 0) return null;
            return xml.substring(valueStart + 1, valueEnd);
        } catch (Throwable error) {
            return null;
        } finally {
            if (stream != null) {
                try {
                    stream.close();
                } catch (Throwable ignored) {
                    // Nothing useful to do while closing.
                }
            }
        }
    }
}
