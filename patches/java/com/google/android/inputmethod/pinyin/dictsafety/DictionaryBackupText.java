package com.google.android.inputmethod.pinyin.dictsafety;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Reads an exported user dictionary backup.
 *
 * <p>The backup is UTF-16LE with a byte order mark and a leading {@code #} comment, then one entry
 * per line: phrase, weight, pinyin code, separated by tabs. The order is the engine's own, which is
 * why it is read here in exactly that order. The weight column is the whole reason this parser
 * exists: the native import ignores it and writes every word with weight zero, which the engine
 * then treats as deleted.
 */
public final class DictionaryBackupText {

    private DictionaryBackupText() {}

    /** One line of a backup file, with the weight it was exported with. */
    public static final class Entry {
        public final String phrase;
        public final String code;
        public final int count;

        Entry(String phrase, String code, int count) {
            this.phrase = phrase;
            this.code = code;
            this.count = count;
        }
    }

    /** Parses the entries a backup describes, skipping anything that cannot be imported. */
    public static List<Entry> parse(byte[] backup) {
        List<Entry> entries = new ArrayList<Entry>();
        if (backup == null || backup.length == 0) return entries;
        String text;
        try {
            text = new String(backup, "UTF-16LE");
        } catch (UnsupportedEncodingException impossible) {
            return entries;
        }
        if (text.startsWith("\ufeff")) text = text.substring(1);
        Set<String> seen = new HashSet<String>();
        int index = 0;
        while (index < text.length()) {
            int end = text.indexOf('\n', index);
            if (end < 0) end = text.length();
            String line = text.substring(index, end).replace("\r", "");
            index = end + 1;
            if (line.isEmpty() || line.charAt(0) == '#') continue;
            String[] columns = line.split("\t");
            if (columns.length < 3) continue;
            String phrase = columns[0].trim();
            String code = columns[2].trim();
            int count;
            try {
                count = Integer.parseInt(columns[1].trim());
            } catch (NumberFormatException unparsable) {
                continue;
            }
            if (phrase.length() < 2 || code.isEmpty() || count <= 0) continue;
            if (!seen.add(phrase + "\t" + code)) continue;
            entries.add(new Entry(phrase, code, count));
        }
        return entries;
    }
}
