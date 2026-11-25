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

        String raw = readShortcuts(context);
        if (raw == null || raw.isEmpty()) return;

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
            if (ids.contains(id) && !result.contains(id)) result.add(id);
        }
        for (String id : ids) {
            if (result.contains(id) || disabled.contains(id)) continue;
            result.add(id);
        }

        ids.clear();
        ids.addAll(result);

        if (known != null) {
            // The set also holds ids that are not entries, such as the expand trigger. Only the
            // disabled ones go, everything else stays so the native pass keeps seeing it.
            known.removeAll(disabled);
        }
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
