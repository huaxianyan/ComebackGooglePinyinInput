package com.google.android.inputmethod.pinyin.dictsafety;

import android.content.Context;
import android.content.SharedPreferences;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.zip.CRC32;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

/**
 * The safety net's own storage: app-private, invisible to the user, unrelated to the user-facing
 * backup location and to Rime sync.
 *
 * <p>A snapshot only enters rotation after it has been written, read back and parsed. Rotation
 * never touches the newest valid snapshot and never runs while the live dictionary looks collapsed,
 * because the snapshot it would delete may be the only healthy copy left.
 */
public final class DictionarySafetyStore {

    static final String KEY_KNOWN_COUNT = "known_entry_count";
    static final String KEY_STRIKES = "collapsed_strikes";
    static final String KEY_LAST_CHECK = "last_check_at";
    static final String KEY_LAST_REPAIR = "last_repair_at";
    static final String KEY_NOTE = "last_note";
    static final String KEY_DEBUG = "last_debug";
    static final String KEY_KNOWN_FILE_SIZE = "known_dictionary_file_size";
    /** Largest the dictionary file has been on this device, in bytes. */
    static final String KEY_FILE_HIGH_WATER = "dictionary_file_high_water";
    /** Sizes seen at recent save boundaries, newest last. Sizes only, never entry content. */
    static final String KEY_SAVE_JOURNAL = "save_journal";

    /** Size of the engine's previous copy, or -1 when the engine has not rotated one yet. */
    public static long backupDictionarySize(Context context, DictionarySafetyKind kind) {
        File file = new File(context.getFilesDir(), kind.fileName + "_bak");
        return file.exists() ? file.length() : -1L;
    }

    /** Size of the main dictionary file, which is the only place entries can still live. */
    public static long mainDictionarySize(Context context, DictionarySafetyKind kind) {
        File file = new File(context.getFilesDir(), kind.fileName);
        return file.isFile() ? file.length() : 0L;
    }

    private static final String PREFIX = "snapshot-";
    private static final String SUFFIX = ".txt.gz";
    private static final String PARTIAL_SUFFIX = ".partial";
    private static final int RETAINED_SNAPSHOTS = 3;
    private static final Charset UTF_8 = Charset.forName("UTF-8");

    private final Context context;
    private final DictionarySafetyKind kind;

    public DictionarySafetyStore(Context context, DictionarySafetyKind kind) {
        this.context = context.getApplicationContext();
        this.kind = kind;
    }

    public SharedPreferences preferences() {
        return context.getSharedPreferences(kind.preferencesName, Context.MODE_PRIVATE);
    }

    private File directory() {
        File directory = new File(context.getFilesDir(), kind.directoryName);
        if (!directory.isDirectory() && !directory.mkdirs()) return null;
        return directory;
    }

    /** Valid snapshots, newest first. Anything unreadable is ignored rather than repaired. */
    public List<StoredSnapshot> snapshots() {
        File directory = directory();
        if (directory == null) return Collections.emptyList();
        File[] files = directory.listFiles();
        if (files == null) return Collections.emptyList();
        List<StoredSnapshot> snapshots = new ArrayList<StoredSnapshot>();
        for (File file : files) {
            if (!file.getName().startsWith(PREFIX) || !file.getName().endsWith(SUFFIX)) continue;
            DictionarySafetySnapshot parsed = read(file);
            if (parsed == null) continue;
            snapshots.add(new StoredSnapshot(file, parsed));
        }
        Collections.sort(snapshots, new Comparator<StoredSnapshot>() {
            @Override public int compare(StoredSnapshot left, StoredSnapshot right) {
                return Long.signum(right.file.lastModified() - left.file.lastModified());
            }
        });
        return snapshots;
    }

    /** Newest snapshot that could still clear the alarm, or null when none qualifies. */
    public StoredSnapshot newestRepairable(int knownCount) {
        for (StoredSnapshot snapshot : snapshots()) {
            if (DictionarySafetyPolicy.canRepairWith(
                    snapshot.snapshot.totalEntryCount, knownCount)) {
                return snapshot;
            }
        }
        return null;
    }

    /** Writes, verifies, then rotates. Returns the stored snapshot, or null if nothing was kept. */
    public StoredSnapshot write(DictionarySafetySnapshot snapshot) {
        File directory = directory();
        if (directory == null) return null;
        String text = DictionarySafetySnapshot.serialize(
                snapshot.totalEntryCount, snapshot.entries);
        File target = new File(directory,
                PREFIX + System.currentTimeMillis() + SUFFIX);
        File partial = new File(directory, target.getName() + PARTIAL_SUFFIX);
        try {
            writeCompressed(partial, text);
            if (!partial.renameTo(target)) {
                delete(partial);
                return null;
            }
        } catch (IOException unusable) {
            delete(partial);
            return null;
        }
        DictionarySafetySnapshot verified = read(target);
        if (verified == null || verified.entries.size() != snapshot.entries.size()) {
            delete(target);
            return null;
        }
        return new StoredSnapshot(target, verified);
    }

    /** Drops the oldest snapshots beyond the retention, never the newest, never while collapsed. */
    public void rotate(boolean liveDictionaryHealthy) {
        if (!liveDictionaryHealthy) return;
        List<StoredSnapshot> snapshots = snapshots();
        if (snapshots.size() <= RETAINED_SNAPSHOTS) return;
        for (int index = RETAINED_SNAPSHOTS; index < snapshots.size(); index++) {
            StoredSnapshot candidate = snapshots.get(index);
            if (candidate == snapshots.get(0)) continue;
            delete(candidate.file);
        }
    }

    /** Content fingerprint, so an unchanged dictionary does not produce a second copy. */
    public static long fingerprint(DictionarySafetySnapshot snapshot) {
        CRC32 crc = new CRC32();
        byte[] bytes = DictionarySafetySnapshot.serialize(
                snapshot.totalEntryCount, snapshot.entries).getBytes(UTF_8);
        crc.update(bytes, 0, bytes.length);
        return crc.getValue();
    }

    private static void writeCompressed(File file, String text) throws IOException {
        Writer writer = new OutputStreamWriter(
                new GZIPOutputStream(new FileOutputStream(file)), UTF_8);
        try {
            writer.write(text);
        } finally {
            writer.close();
        }
    }

    private static DictionarySafetySnapshot read(File file) {
        FileInputStream fileIn = null;
        try {
            fileIn = new FileInputStream(file);
            GZIPInputStream gzip = new GZIPInputStream(fileIn);
            Reader reader = new InputStreamReader(gzip, UTF_8);
            StringBuilder text = new StringBuilder(64 * 1024);
            char[] buffer = new char[8192];
            int read;
            while ((read = reader.read(buffer)) != -1) text.append(buffer, 0, read);
            reader.close();
            return DictionarySafetySnapshot.parse(text.toString());
        } catch (IOException unreadable) {
            return null;
        } finally {
            if (fileIn != null) {
                try {
                    fileIn.close();
                } catch (IOException ignored) {
                    // Nothing left to do with a stream that already failed to close.
                }
            }
        }
    }

    private static void delete(File file) {
        if (file != null && file.exists()) file.delete();
    }

    public static final class StoredSnapshot {
        public final File file;
        public final DictionarySafetySnapshot snapshot;

        StoredSnapshot(File file, DictionarySafetySnapshot snapshot) {
            this.file = file;
            this.snapshot = snapshot;
        }
    }
}
