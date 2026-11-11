package com.google.android.inputmethod.pinyin.dictsafety;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * The text form of one safety snapshot.
 *
 * <p>A snapshot is the engine's own readable view written out as plain entries, so restoring never
 * depends on the native binary format and never touches the running dictionary file. Entry weights
 * travel with the snapshot: an entry that comes back must come back with the weight it had, not
 * with a reset weight, or the ranking silently changes underneath the user.
 *
 * <p>Parsing is all-or-nothing. A snapshot that is truncated, reordered or hand-edited is dropped
 * instead of being partially applied, because a half-read snapshot would look like a healthy one.
 */
public final class DictionarySafetySnapshot {

    static final int FORMAT_VERSION = 1;
    private static final String HEADER = "GPISAFETY\t" + FORMAT_VERSION;

    public final int totalEntryCount;
    public final List<Entry> entries;

    private DictionarySafetySnapshot(int totalEntryCount, List<Entry> entries) {
        this.totalEntryCount = totalEntryCount;
        this.entries = Collections.unmodifiableList(entries);
    }

    public static final class Entry {
        public final String phrase;
        public final String code;
        public final int count;

        public Entry(String phrase, String code, int count) {
            this.phrase = phrase;
            this.code = code;
            this.count = count;
        }

        String key() {
            return code + '\t' + phrase;
        }
    }

    public static DictionarySafetySnapshot of(int totalEntryCount, List<Entry> entries) {
        return new DictionarySafetySnapshot(totalEntryCount, entries);
    }

    public static String serialize(int totalEntryCount, List<Entry> entries) {
        StringBuilder out = new StringBuilder(entries.size() * 24 + 32);
        out.append(HEADER).append('\n');
        out.append(totalEntryCount).append('\n');
        for (Entry entry : entries) {
            out.append(entry.phrase).append('\t')
                    .append(entry.code).append('\t')
                    .append(entry.count).append('\n');
        }
        out.append("END\t").append(entries.size()).append('\n');
        return out.toString();
    }

    /** Returns null when the text is not a complete snapshot. */
    public static DictionarySafetySnapshot parse(String text) {
        if (text == null || text.isEmpty()) return null;
        String[] lines = text.split("\n", -1);
        if (lines.length < 2) return null;
        if (!HEADER.equals(lines[0])) return null;
        int totalEntryCount;
        try {
            totalEntryCount = Integer.parseInt(lines[1].trim());
        } catch (NumberFormatException error) {
            return null;
        }
        if (totalEntryCount < 0) return null;

        List<Entry> entries = new ArrayList<Entry>(Math.max(8, lines.length - 3));
        Set<String> keys = new HashSet<String>();
        int lastIndex = lines.length - 1;
        while (lastIndex >= 2 && lines[lastIndex].isEmpty()) lastIndex--;
        if (lastIndex < 2) return null;
        // The trailer is what makes truncation detectable: the declared total counts entries the
        // engine holds but cannot project, so it can never be compared with the line count.
        if (!("END\t" + (lastIndex - 2)).equals(lines[lastIndex])) return null;
        for (int index = 2; index < lastIndex; index++) {
            String line = lines[index];
            String[] fields = line.split("\t", -1);
            if (fields.length != 3) return null;
            String phrase = fields[0];
            String code = fields[1];
            int count;
            try {
                count = Integer.parseInt(fields[2].trim());
            } catch (NumberFormatException error) {
                return null;
            }
            if (phrase.isEmpty() || code.isEmpty() || count <= 0) return null;
            // The bridge cannot represent single-character phrases, so a snapshot must never
            // claim one: accepting it would make the file disagree with what restore can do.
            if (phrase.codePointCount(0, phrase.length()) < 2) return null;
            Entry entry = new Entry(phrase, code, count);
            if (!keys.add(entry.key())) return null;
            entries.add(entry);
        }
        if (entries.isEmpty() && totalEntryCount > 0) return null;
        if (entries.size() > totalEntryCount) return null;
        return new DictionarySafetySnapshot(totalEntryCount, entries);
    }
}
