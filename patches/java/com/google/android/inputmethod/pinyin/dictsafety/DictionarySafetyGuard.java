package com.google.android.inputmethod.pinyin.dictsafety;

import android.content.Context;
import android.content.SharedPreferences;

import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
import com.google.android.inputmethod.pinyin.rimesync.GoogleNativeDictionaryBridge;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * The private safety net for users who never configure anything.
 *
 * <p>It keeps a few verified snapshots of the dictionary the engine could actually read, and when
 * that readable view collapses it puts the missing entries back. Nothing is ever deleted, so the
 * repair is idempotent: running it twice, or losing power halfway, cannot make the dictionary worse.
 *
 * <p>No user-facing surface. No dependency on the backup location, on Rime sync, or on the user
 * doing anything at all.
 */
public final class DictionarySafetyGuard {

    private static final String SAVE_LOCK_CLASS =
            "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask";
    private static final String SAVE_LOCK_FIELD = "sSaveLock";

    private static final long CHECK_INTERVAL_MS = 6L * 60L * 60L * 1000L;
    private static final long REPAIR_INTERVAL_MS = 24L * 60L * 60L * 1000L;
    private static final int STRIKES_BEFORE_REPAIR = 2;

    /** One check at a time per dictionary, so two triggers cannot race on the same snapshot. */
    private static final java.util.Map<DictionarySafetyKind, Long> BUSY =
            new java.util.concurrent.ConcurrentHashMap<DictionarySafetyKind, Long>();
    /**
     * A check that has run this long is treated as stuck and replaced. Reading the dictionary
     * queues behind the app's own save lock, which can wait indefinitely while the keyboard is
     * busy; without this the safety net would silently stop checking for the rest of the process.
     */
    private static final long BUSY_TIMEOUT_MS = 2L * 60L * 1000L;
    private static final Object REPAIR_LOCK = new Object();

    private DictionarySafetyGuard() {}

    /** Entries the engine can read right now, or -1 when it cannot be asked. */
    public static int readableEntryCount(Context context) {
        if (context == null) return -1;
        Context app = context.getApplicationContext();
        if (app == null) app = context;
        Object factory = engineFactory(app, DictionarySafetyKind.CHINESE);
        return factory == null ? -1 : readableCount(app, factory);
    }

    /** Entry point used by the existing dictionary-save hooks. Cheap when it is not time to look. */
    public static void request(final Context context) {
        if (context == null) return;
        final Context app = context.getApplicationContext();
        if (app == null) return;
        long now = System.currentTimeMillis();
        app.getSharedPreferences(DictionarySafetyKind.CHINESE.preferencesName,
                Context.MODE_PRIVATE).edit()
                .putString(DictionarySafetyStore.KEY_DEBUG, "request-entered " + now)
                .apply();
        for (final DictionarySafetyKind kind : DictionarySafetyKind.values()) {
            final DictionarySafetyStore store = new DictionarySafetyStore(app, kind);
            if (now - store.preferences().getLong(
                    DictionarySafetyStore.KEY_LAST_CHECK, 0L) < CHECK_INTERVAL_MS) {
                continue;
            }
            // Mark the attempt before starting: a check that dies still counts as this round's
            // attempt, and the timestamp proves the entry point was reached.
            store.preferences().edit()
                    .putLong(DictionarySafetyStore.KEY_LAST_CHECK, now)
                    .apply();
            Long started = BUSY.get(kind);
            if (started != null && now - started.longValue() < BUSY_TIMEOUT_MS) continue;
            BUSY.put(kind, Long.valueOf(now));
            Thread worker = new Thread(new Runnable() {
                @Override public void run() {
                    store.preferences().edit()
                            .putString(DictionarySafetyStore.KEY_DEBUG, "worker-started")
                            .apply();
                    try {
                        runOnce(app, store, kind);
                    } catch (Throwable unrecoverable) {
                        record(store, "检查未完成：" + unrecoverable.getClass().getSimpleName());
                    } finally {
                        store.preferences().edit()
                                .putLong(DictionarySafetyStore.KEY_LAST_CHECK,
                                        System.currentTimeMillis())
                                .apply();
                        store.preferences().edit()
                                .putString(DictionarySafetyStore.KEY_DEBUG, "worker-finished")
                                .apply();
                        BUSY.remove(kind);
                    }
                }
            }, "dictionary-safety");
            worker.setPriority(Thread.MIN_PRIORITY);
            worker.start();
        }
    }

    private static void runOnce(Context context, DictionarySafetyStore store,
            DictionarySafetyKind kind) {
        boolean repaired = protectFile(context, store, kind);
        Object factory = engineFactory(context, kind);
        if (factory == null) {
            if (!repaired) record(store, "引擎尚未就绪，本次跳过");
            return;
        }
        int readable = readableCount(context, factory);
        if (readable < 0) {
            if (!repaired) record(store, "暂时读不出条目数，本次跳过");
            return;
        }

        SharedPreferences preferences = store.preferences();
        int known = DictionarySafetyPolicy.nextKnownCount(
                preferences.getInt(DictionarySafetyStore.KEY_KNOWN_COUNT, 0), readable);
        preferences.edit().putInt(DictionarySafetyStore.KEY_KNOWN_COUNT, known).apply();

        if (!DictionarySafetyPolicy.isCollapsed(readable, known)) {
            preferences.edit().putInt(DictionarySafetyStore.KEY_STRIKES, 0).apply();
            capture(context, store, kind, factory, readable, known);
            store.rotate(true);
            return;
        }
        Boolean stillOnDisk = entriesCouldStillBeOnDisk(
                context, kind, preferences, readable, known);
        if (stillOnDisk == null) {
            // Nothing recorded to compare against yet. Learn the current file size and leave the
            // dictionary alone this round rather than guessing in either direction.
            long size = DictionarySafetyStore.mainDictionarySize(context, kind);
            if (size > 0L) {
                preferences.edit()
                        .putLong(DictionarySafetyStore.KEY_KNOWN_FILE_SIZE, size).apply();
            }
            record(store, "词条数从 " + known + " 条降到 " + readable + " 条，缺少文件大小基线");
            return;
        }
        if (!stillOnDisk.booleanValue()) {
            // The file shrank with the count, so the words really are gone: the user deleted them,
            // or something else did. Adopt the smaller dictionary instead of resurrecting words
            // nobody asked for.
            preferences.edit()
                    .putInt(DictionarySafetyStore.KEY_STRIKES, 0)
                    .putInt(DictionarySafetyStore.KEY_KNOWN_COUNT, readable)
                    .apply();
            record(store, "词条数降到 " + readable + " 条，文件同步变小，按删除处理");
            capture(context, store, kind, factory, readable, readable);
            store.rotate(true);
            return;
        }

        int strikes = preferences.getInt(DictionarySafetyStore.KEY_STRIKES, 0) + 1;
        preferences.edit().putInt(DictionarySafetyStore.KEY_STRIKES, strikes).apply();
        if (strikes < STRIKES_BEFORE_REPAIR) {
            record(store, "词条数从 " + known + " 条降到 " + readable + " 条，等待复核");
            return;
        }
        if (System.currentTimeMillis() - preferences.getLong(
                DictionarySafetyStore.KEY_LAST_REPAIR, 0L) < REPAIR_INTERVAL_MS) {
            return;
        }
        preferences.edit()
                .putLong(DictionarySafetyStore.KEY_LAST_REPAIR, System.currentTimeMillis())
                .apply();
        repair(context, store, kind, factory, readable, known);
    }

    /**
     * Keeps the dictionary file itself safe, without asking the engine anything.
     *
     * <p>The engine holds the user dictionary in memory and does not read the file back, so its
     * export can come back empty while the words are all still on disk. Byte copies keep the words
     * recoverable in that state, and a file that suddenly shrinks is the one loss signal that does
     * not depend on the engine at all.
     */
    private static boolean protectFile(Context context, DictionarySafetyStore store,
            DictionarySafetyKind kind) {
        SharedPreferences preferences = store.preferences();
        DictionaryFileSnapshot files = new DictionaryFileSnapshot(context, kind);
        byte[] current = files.read();
        long size = current == null ? 0L : current.length;
        long high = preferences.getLong(DictionarySafetyStore.KEY_FILE_HIGH_WATER, 0L);

        if (size > high) {
            preferences.edit()
                    .putLong(DictionarySafetyStore.KEY_FILE_HIGH_WATER, size)
                    .apply();
        }
        if (!DictionarySafetyPolicy.isFileCollapsed(size, high)) {
            files.keep(current);
            return false;
        }
        byte[] recovered = files.newestAtLeast(high / 2L);
        if (recovered != null && files.restore(recovered)) {
            record(store, "词库文件从 " + size + " 字节恢复到 " + recovered.length + " 字节，"
                    + "重启输入法后生效");
            return true;
        }
        record(store, "词库文件只剩 " + size + " 字节，暂时没有可用的完整副本");
        return false;
    }

    /** Drops the file baseline and copies, used when the user deliberately clears the dictionary. */
    public static void forget(Context context) {
        if (context == null) return;
        Context app = context.getApplicationContext();
        if (app == null) app = context;
        for (DictionarySafetyKind kind : DictionarySafetyKind.values()) {
            DictionarySafetyStore store = new DictionarySafetyStore(app, kind);
            new DictionaryFileSnapshot(app, kind).forget();
            store.preferences().edit()
                    .putLong(DictionarySafetyStore.KEY_FILE_HIGH_WATER, 0L)
                    .putInt(DictionarySafetyStore.KEY_KNOWN_COUNT, 0)
                    .putInt(DictionarySafetyStore.KEY_STRIKES, 0)
                    .apply();
        }
    }

    /**
     * True when the dictionary file is far larger than the readable count can explain, which means
     * the entries are still on disk and only the engine's view of them shrank.
     *
     * <p>Both sides of this comparison come from this installation's own history: the recorded
     * count and the file size recorded with it. No fixed byte counts are assumed, because every
     * user's dictionary has its own size per entry.
     */
    private static Boolean entriesCouldStillBeOnDisk(Context context, DictionarySafetyKind kind,
            SharedPreferences preferences, int readable, int known) {
        long recordedSize = preferences.getLong(DictionarySafetyStore.KEY_KNOWN_FILE_SIZE, 0L);
        long currentSize = DictionarySafetyStore.mainDictionarySize(context, kind);
        if (recordedSize <= 0L || currentSize <= 0L) return null;
        if (readable <= 0) return Boolean.FALSE;
        long expected = recordedSize * readable / known;
        return Boolean.valueOf(currentSize > expected * 2L);
    }

    /** Writes a snapshot of a dictionary that currently reads as healthy. */
    private static void capture(Context context, DictionarySafetyStore store,
            DictionarySafetyKind kind, Object factory,
            int readable, int known) {
        if (!DictionarySafetyPolicy.acceptsSnapshot(readable, known)) return;
        List<DictionarySafetySnapshot.Entry> entries = entries(store, context, factory);
        if (entries == null || entries.isEmpty()) {
            record(store, "词条明细暂时读不出（计数 " + readable + " 条），本次跳过快照");
            return;
        }
        DictionarySafetySnapshot snapshot = DictionarySafetySnapshot.of(readable, entries);
        List<DictionarySafetyStore.StoredSnapshot> stored = store.snapshots();
        store.preferences().edit()
                .putLong(DictionarySafetyStore.KEY_KNOWN_FILE_SIZE,
                        DictionarySafetyStore.mainDictionarySize(context, kind))
                .apply();
        if (!stored.isEmpty() && DictionarySafetyStore.fingerprint(stored.get(0).snapshot)
                == DictionarySafetyStore.fingerprint(snapshot)) {
            return;
        }
        store.write(snapshot);
    }

    /** Puts back entries the readable view lost. Never deletes anything. */
    private static void repair(Context context, DictionarySafetyStore store,
            DictionarySafetyKind kind, Object factory,
            int readable, int known) {
        DictionarySafetyStore.StoredSnapshot source = store.newestRepairable(known);
        if (source == null) {
            record(store, "词条数降到 " + readable + " 条，但没有可用的安全快照");
            return;
        }
        List<GoogleNativeDictionaryBridge.Change> changes =
                new ArrayList<GoogleNativeDictionaryBridge.Change>(
                        source.snapshot.entries.size());
        for (DictionarySafetySnapshot.Entry entry : source.snapshot.entries) {
            changes.add(GoogleNativeDictionaryBridge.Change.addition(
                    entry.code, entry.phrase, entry.count));
        }
        Object lock = saveLock();
        synchronized (lock == null ? REPAIR_LOCK : lock) {
            try {
                GoogleNativeDictionaryBridge.recover(
                        context, (AbstractHmmEngineFactory) factory, changes);
            } catch (Throwable failed) {
                record(store, "恢复未完成：" + failed.getClass().getSimpleName());
                return;
            }
        }
        int restored = readableCount(context, factory);
        if (DictionarySafetyPolicy.isCollapsed(restored, known)) {
            record(store, "恢复后仍只有 " + restored + " 条，快照 " + source.file.getName());
            return;
        }
        record(store, "已从安全快照恢复，词条数回到 " + restored + " 条");
        store.preferences().edit().putInt(DictionarySafetyStore.KEY_STRIKES, 0).apply();
        capture(context, store, kind, factory, restored, known);
    }

    private static int readableCount(Context context, Object factory) {
        try {
            return GoogleNativeDictionaryBridge.readPresence(
                    context, (AbstractHmmEngineFactory) factory).totalEntryCount;
        } catch (Throwable unavailable) {
            return -1;
        }
    }

    private static List<DictionarySafetySnapshot.Entry> entries(
            DictionarySafetyStore store, Context context, Object factory) {
        try {
            Collection<GoogleNativeDictionaryBridge.GoogleEntry> readable =
                    GoogleNativeDictionaryBridge.read(
                            context, (AbstractHmmEngineFactory) factory).entries.values();
            List<DictionarySafetySnapshot.Entry> entries =
                    new ArrayList<DictionarySafetySnapshot.Entry>(readable.size());
            for (GoogleNativeDictionaryBridge.GoogleEntry entry : readable) {
                entries.add(new DictionarySafetySnapshot.Entry(
                        entry.phrase, entry.code, entry.count));
            }
            return entries;
        } catch (Throwable unavailable) {
            record(store, "读取词条失败：" + unavailable);
            return null;
        }
    }

    private static Object engineFactory(Context context, DictionarySafetyKind kind) {
        try {
            Object factory = Class.forName(kind.engineFactoryClass)
                    .getMethod("a", Context.class).invoke(null, context);
            return factory instanceof AbstractHmmEngineFactory ? factory : null;
        } catch (Throwable unavailable) {
            return null;
        }
    }

    private static Object saveLock() {
        try {
            return Class.forName(SAVE_LOCK_CLASS).getField(SAVE_LOCK_FIELD).get(null);
        } catch (Throwable unavailable) {
            return null;
        }
    }

    private static void record(DictionarySafetyStore store, String note) {
        store.preferences().edit()
                .putString(DictionarySafetyStore.KEY_NOTE, note)
                .putLong(DictionarySafetyStore.KEY_LAST_CHECK, System.currentTimeMillis())
                .apply();
    }
}
