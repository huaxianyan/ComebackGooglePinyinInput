package com.google.android.inputmethod.pinyin.dictsafety;

import android.content.Context;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

/**
 * Byte copies of the dictionary file itself.
 *
 * <p>The engine keeps its own copy of the user dictionary in memory and does not read the file back
 * on its own, so an export taken through the engine can be empty even when the words are all still
 * on disk. These snapshots copy the file as it is, which keeps the safety net working in exactly
 * the situations where the engine cannot be asked.
 */
final class DictionaryFileSnapshot {

    private static final String PREFIX = "file-";
    private static final String SUFFIX = ".gz";
    private static final int KEEP = 3;

    private final Context context;
    private final DictionarySafetyKind kind;

    DictionaryFileSnapshot(Context context, DictionarySafetyKind kind) {
        this.context = context;
        this.kind = kind;
    }

    private File directory() {
        File directory = new File(context.getFilesDir(), kind.directoryName);
        if (!directory.isDirectory() && !directory.mkdirs()) return null;
        return directory;
    }

    /** Reads the dictionary file, or null when it is missing or unreadable. */
    byte[] read() {
        File source = new File(context.getFilesDir(), kind.fileName);
        if (!source.isFile()) return null;
        InputStream in = null;
        try {
            in = new FileInputStream(source);
            ByteArrayOutputStream bytes = new ByteArrayOutputStream((int) source.length());
            byte[] buffer = new byte[8192];
            int read;
            while ((read = in.read(buffer)) != -1) bytes.write(buffer, 0, read);
            return bytes.toByteArray();
        } catch (IOException unreadable) {
            return null;
        } finally {
            closeQuietly(in);
        }
    }

    /** Keeps a compressed copy of these bytes and prunes older ones. Returns true when kept. */
    boolean keep(byte[] data) {
        if (data == null || data.length == 0) return false;
        File directory = directory();
        if (directory == null) return false;
        List<File> existing = snapshots();
        if (!existing.isEmpty()) {
            byte[] newest = load(existing.get(0));
            if (newest != null && java.util.Arrays.equals(newest, data)) return true;
        }
        File target = new File(directory, PREFIX + data.length + "-"
                + System.currentTimeMillis() + SUFFIX);
        FileOutputStream out = null;
        GZIPOutputStream gzip = null;
        try {
            out = new FileOutputStream(target);
            gzip = new GZIPOutputStream(out);
            gzip.write(data);
            gzip.finish();
        } catch (IOException unwritable) {
            target.delete();
            return false;
        } finally {
            closeQuietly(gzip);
            closeQuietly(out);
        }
        prune();
        return true;
    }

    /** Newest copy whose size is at least {@code minimumBytes}, or null when none qualifies. */
    byte[] newestAtLeast(long minimumBytes) {
        for (File file : snapshots()) {
            long size = sizeOf(file);
            if (size < minimumBytes) continue;
            byte[] data = load(file);
            if (data != null) return data;
        }
        return null;
    }

    /** Writes these bytes back over the dictionary file. */
    /**
     * Replaces the dictionary file by writing a sibling and renaming it over the target. Writing in
     * place truncates the file the engine has mapped and turns the next read into a SIGBUS, so the
     * rename is what keeps a repair from crashing the process.
     */
    boolean restore(byte[] data) {
        if (data == null || data.length == 0) return false;
        File target = new File(context.getFilesDir(), kind.fileName);
        File staging = new File(target.getPath() + ".restore");
        FileOutputStream out = null;
        try {
            out = new FileOutputStream(staging);
            out.write(data);
            out.getFD().sync();
            out.close();
            out = null;
            return staging.renameTo(target);
        } catch (IOException unwritable) {
            return false;
        } finally {
            closeQuietly(out);
            if (staging.exists()) {
                staging.delete();
            }
        }
    }

    /** Drops every copy, used when the user deliberately clears the dictionary. */
    void forget() {
        for (File file : snapshots()) file.delete();
    }

    private long sizeOf(File file) {
        String name = file.getName();
        int dash = name.indexOf('-', PREFIX.length());
        if (dash <= PREFIX.length()) return 0L;
        try {
            return Long.parseLong(name.substring(PREFIX.length(), dash));
        } catch (NumberFormatException unparsable) {
            return 0L;
        }
    }

    private List<File> snapshots() {
        File directory = directory();
        if (directory == null) return Collections.emptyList();
        File[] files = directory.listFiles();
        if (files == null) return Collections.emptyList();
        List<File> snapshots = new ArrayList<File>();
        for (File file : files) {
            if (file.getName().startsWith(PREFIX) && file.getName().endsWith(SUFFIX)) {
                snapshots.add(file);
            }
        }
        Collections.sort(snapshots, new Comparator<File>() {
            @Override public int compare(File left, File right) {
                return Long.signum(right.lastModified() - left.lastModified());
            }
        });
        return snapshots;
    }

    private void prune() {
        List<File> snapshots = snapshots();
        for (int index = KEEP; index < snapshots.size(); index++) {
            snapshots.get(index).delete();
        }
    }

    private byte[] load(File file) {
        InputStream in = null;
        try {
            in = new GZIPInputStream(new FileInputStream(file));
            ByteArrayOutputStream bytes = new ByteArrayOutputStream();
            byte[] buffer = new byte[8192];
            int read;
            while ((read = in.read(buffer)) != -1) bytes.write(buffer, 0, read);
            return bytes.toByteArray();
        } catch (IOException unreadable) {
            return null;
        } finally {
            closeQuietly(in);
        }
    }

    private static void closeQuietly(java.io.Closeable closeable) {
        if (closeable == null) return;
        try {
            closeable.close();
        } catch (IOException ignored) {
            // Closing a stream we are done with cannot change the outcome.
        }
    }
}
