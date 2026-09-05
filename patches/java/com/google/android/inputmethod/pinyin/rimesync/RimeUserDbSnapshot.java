package com.google.android.inputmethod.pinyin.rimesync;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Parses, merges, and writes the public Rime *.userdb.txt snapshot format. */
public final class RimeUserDbSnapshot {
    public static final String DESCRIPTION = "# Rime user dictionary";

    private final Map<String, String> metadata = new LinkedHashMap<String, String>();
    private final Map<String, Entry> entries = new LinkedHashMap<String, Entry>();

    public static RimeUserDbSnapshot read(Reader source) throws IOException {
        BufferedReader reader = source instanceof BufferedReader
                ? (BufferedReader) source : new BufferedReader(source);
        RimeUserDbSnapshot snapshot = new RimeUserDbSnapshot();
        String line;
        int lineNumber = 0;
        boolean descriptionSeen = false;
        while ((line = reader.readLine()) != null) {
            lineNumber++;
            if (lineNumber == 1 && line.length() > 0 && line.charAt(0) == '\ufeff') {
                line = line.substring(1);
            }
            if (line.length() == 0) continue;
            if (line.startsWith("#@/")) {
                int separator = line.indexOf('\t');
                if (separator <= 3 || separator == line.length() - 1) {
                    throw formatError(lineNumber, "invalid metadata");
                }
                snapshot.metadata.put(line.substring(3, separator), line.substring(separator + 1));
            } else if (line.charAt(0) == '#') {
                if (DESCRIPTION.equals(line)) descriptionSeen = true;
            } else {
                String[] columns = line.split("\\t", -1);
                if (columns.length != 3 || columns[0].length() == 0 || columns[1].length() == 0) {
                    throw formatError(lineNumber, "invalid entry columns");
                }
                Entry entry = Entry.parse(columns[0], columns[1], columns[2], lineNumber);
                snapshot.entries.put(entry.key(), entry);
            }
        }
        if (!descriptionSeen) throw new IOException("missing Rime user dictionary header");
        snapshot.validateMetadata();
        return snapshot;
    }

    public void write(Writer destination) throws IOException {
        validateMetadata();
        BufferedWriter writer = destination instanceof BufferedWriter
                ? (BufferedWriter) destination : new BufferedWriter(destination);
        writer.write(DESCRIPTION);
        writer.newLine();
        writeMetadata(writer, "db_name");
        writeMetadata(writer, "db_type");
        if (metadata.containsKey("rime_version")) writeMetadata(writer, "rime_version");
        writeMetadata(writer, "tick");
        writeMetadata(writer, "user_id");
        List<String> keys = new ArrayList<String>(entries.keySet());
        Collections.sort(keys);
        for (String key : keys) {
            Entry entry = entries.get(key);
            writer.write(entry.code);
            writer.write('\t');
            writer.write(entry.phrase);
            writer.write('\t');
            writer.write(entry.pack());
            writer.newLine();
        }
        writer.flush();
    }

    /**
     * Converts this peer snapshot in place to the exact result of merging it into an empty
     * tick-zero snapshot. The caller owns this parsed snapshot and may then use it as the Bridge.
     */
    void mergeFromEmpty(boolean deletionWinsTies) throws IOException {
        long theirTick = tick();
        long mergedTick = Math.max(0L, theirTick);
        for (Map.Entry<String, Entry> item : entries.entrySet()) {
            Entry source = item.getValue();
            Entry other = source.atTick(theirTick);
            int commits = 0;
            long otherMagnitude = magnitude(other.commits);
            if (otherMagnitude > 0L
                    || (deletionWinsTies && other.commits < 0)) {
                commits = other.commits;
            }
            double dee = Math.max(0.0, other.dee);
            if (source.commits != commits || Double.compare(source.dee, dee) != 0
                    || source.tick != mergedTick) {
                item.setValue(new Entry(source.code, source.phrase, commits, dee, mergedTick));
            }
        }
        metadata.put("tick", Long.toString(mergedTick));
    }

    /** Merge one external device snapshot into this Bridge device snapshot. */
    public void mergeFrom(RimeUserDbSnapshot incoming, boolean deletionWinsTies) throws IOException {
        if (!dbName().equals(incoming.dbName())) {
            throw new IOException("Rime dictionary name mismatch");
        }
        long ourTick = tick();
        long theirTick = incoming.tick();
        long mergedTick = Math.max(ourTick, theirTick);
        for (Entry source : incoming.entries.values()) {
            Entry other = source.atTick(theirTick);
            Entry current = entries.get(source.key());
            if (current == null) current = new Entry(source.code, source.phrase, 0, 0.0, 0L);
            current = current.atTick(ourTick);
            int commits = current.commits;
            long currentMagnitude = magnitude(current.commits);
            long otherMagnitude = magnitude(other.commits);
            if (currentMagnitude < otherMagnitude
                    || (deletionWinsTies && currentMagnitude == otherMagnitude
                    && other.commits < 0 && current.commits >= 0)) {
                commits = other.commits;
            }
            entries.put(source.key(), new Entry(
                    source.code,
                    source.phrase,
                    commits,
                    Math.max(current.dee, other.dee),
                    mergedTick));
        }
        metadata.put("tick", Long.toString(mergedTick));
    }

    public String dbName() {
        return metadata.get("db_name");
    }

    public long tick() throws IOException {
        try {
            return Long.parseLong(metadata.get("tick"));
        } catch (RuntimeException failure) {
            throw new IOException("invalid Rime tick", failure);
        }
    }

    public Map<String, String> metadata() {
        return Collections.unmodifiableMap(metadata);
    }

    public Map<String, Entry> entries() {
        return Collections.unmodifiableMap(entries);
    }

    public void putMetadata(String key, String value) {
        if (key == null || value == null || key.length() == 0 || value.length() == 0) {
            throw new IllegalArgumentException("metadata must not be empty");
        }
        metadata.put(key, value);
    }

    public void put(Entry entry) {
        entries.put(entry.key(), entry);
    }

    void remove(String key) {
        entries.remove(key);
    }

    private void validateMetadata() throws IOException {
        if (!"userdb".equals(metadata.get("db_type"))) {
            throw new IOException("snapshot is not a Rime userdb");
        }
        if (empty(metadata.get("db_name")) || empty(metadata.get("user_id"))) {
            throw new IOException("missing Rime snapshot identity");
        }
        tick();
    }

    private static boolean empty(String value) {
        return value == null || value.length() == 0;
    }

    private void writeMetadata(BufferedWriter writer, String key) throws IOException {
        String value = metadata.get(key);
        if (value == null) throw new IOException("missing Rime metadata: " + key);
        writer.write("#@/");
        writer.write(key);
        writer.write('\t');
        writer.write(value);
        writer.newLine();
    }

    private static long magnitude(int value) {
        return value == Integer.MIN_VALUE ? 2147483648L : Math.abs((long) value);
    }

    private static IOException formatError(int line, String message) {
        return new IOException("Rime snapshot line " + line + ": " + message);
    }

    public static final class Entry {
        public final String code;
        public final String phrase;
        public final int commits;
        public final double dee;
        public final long tick;

        public Entry(String code, String phrase, int commits, double dee, long tick) {
            if (code == null || code.length() == 0 || phrase == null || phrase.length() == 0) {
                throw new IllegalArgumentException("Rime entry key must not be empty");
            }
            this.code = code.charAt(code.length() - 1) == ' ' ? code : code + " ";
            this.phrase = phrase;
            this.commits = commits;
            this.dee = Math.min(10000.0, dee);
            this.tick = tick;
        }

        public String key() {
            return code + '\t' + phrase;
        }

        public String pack() {
            return "c=" + commits + " d=" + Double.toString(dee) + " t=" + tick;
        }

        private Entry atTick(long targetTick) {
            if (tick >= targetTick) return this;
            return new Entry(code, phrase, commits,
                    dee * Math.exp(((double) tick - (double) targetTick) / 200.0), tick);
        }

        private static Entry parse(String code, String phrase, String packed, int line)
                throws IOException {
            int commits = 0;
            double dee = 0.0;
            long tick = 0L;
            String[] values = packed.split(" ");
            try {
                for (String item : values) {
                    int separator = item.indexOf('=');
                    if (separator <= 0 || separator == item.length() - 1) continue;
                    String key = item.substring(0, separator);
                    String value = item.substring(separator + 1);
                    if ("c".equals(key)) commits = Integer.parseInt(value);
                    else if ("d".equals(key)) dee = Double.parseDouble(value);
                    else if ("t".equals(key)) tick = Long.parseLong(value);
                }
            } catch (RuntimeException failure) {
                throw formatError(line, "invalid entry value");
            }
            if (Double.isNaN(dee) || Double.isInfinite(dee) || dee < 0.0 || tick < 0L) {
                throw formatError(line, "entry value is out of range");
            }
            return new Entry(code, phrase, commits, dee, tick);
        }
    }
}
