package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.format.DateFormat;
import java.io.File;
import java.lang.reflect.Method;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** On-demand metadata/readability inspection. Never exports or modifies dictionary entries. */
public final class DictionaryHealthStatusCompat {
    public interface Callback { void onLoaded(String summary); }
    public interface SnapshotCallback { void onLoaded(Snapshot snapshot); }
    public static final int HEALTH_OK = 0;
    public static final int HEALTH_NOTICE = 1;
    public static final int HEALTH_ERROR = 2;
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ExecutorService IO = Executors.newSingleThreadExecutor();
    private DictionaryHealthStatusCompat() {}

    public static final class Snapshot {
        public final int status;
        public final String summary;
        public final String details;
        Snapshot(int status, String summary, String details) {
            this.status = status; this.summary = summary; this.details = details;
        }
    }

    /** Frozen API for legacy Preference callers; both UIs use the same inspection. */
    public static void load(Context source, final Callback callback) {
        if (source == null || callback == null) return;
        loadSnapshot(source, new SnapshotCallback() {
            @Override public void onLoaded(Snapshot snapshot) {
                callback.onLoaded(snapshot.summary + "\n" + snapshot.details);
            }
        });
    }

    public static void loadSnapshot(Context source, final SnapshotCallback callback) {
        if (source == null || callback == null) return;
        final Context context = source.getApplicationContext();
        IO.execute(new Runnable() {
            @Override public void run() {
                final Snapshot snapshot = inspect(context);
                MAIN.post(new Runnable() {
                    @Override public void run() { callback.onLoaded(snapshot); }
                });
            }
        });
    }

    private static Snapshot inspect(Context context) {
        try {
            Object lock = Class.forName(
                    "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask")
                    .getField("sSaveLock").get(null);
            if (lock == null) throw new IllegalStateException("dictionary lock unavailable");
            synchronized (lock) {
                FileStats zh = files(context, "user_dict_3_3");
                FileStats en = files(context, "user_dict_3_3_english");
                boolean zhReadable = nativeReadable(context, "bdt");
                boolean enReadable = nativeReadable(context, "agb");
                int status = HEALTH_OK;
                String summary = "中文词库可读取，英文词库可读取";
                if (!zhReadable || !enReadable) {
                    status = HEALTH_ERROR;
                    summary = "词库检查未完成，请稍后重试";
                } else if (zh.unreadable || en.unreadable) {
                    status = HEALTH_NOTICE;
                    summary = "词库可读取，保留了此前的异常文件，建议先备份当前词库";
                } else if (zh.temporary || en.temporary) {
                    status = HEALTH_NOTICE;
                    summary = "词库可读取，发现上次保存的临时文件，请稍后重新检查";
                }
                StringBuilder details = new StringBuilder();
                details.append("中文词库：").append(zhReadable ? "可读取" : "暂时无法确认")
                        .append("\n英文词库：").append(enReadable ? "可读取" : "暂时无法确认");
                details.append("\n中文文件：").append(describeMain(zh))
                        .append("\n英文文件：").append(describeMain(en));
                details.append("\n上次保存副本：中文 ").append(describeBackup(zh))
                        .append("，英文 ").append(describeBackup(en));
                details.append("\n保留的异常文件：")
                        .append((zh.unreadable ? 1 : 0) + (en.unreadable ? 1 : 0)).append(" 个");
                details.append("\n未完成保存的文件：")
                        .append((zh.temporary ? 1 : 0) + (en.temporary ? 1 : 0)).append(" 个");
                long modified = Math.max(zh.modified, en.modified);
                if (modified > 0L) {
                    details.append("\n词库文件最近更新：")
                            .append(DateFormat.getDateFormat(context).format(modified)).append(' ')
                            .append(DateFormat.getTimeFormat(context).format(modified));
                }
                return new Snapshot(status, summary, details.toString());
            }
        } catch (Throwable unavailable) {
            return new Snapshot(HEALTH_ERROR, "暂时无法检查词库，请稍后重试", "");
        }
    }

    private static boolean nativeReadable(Context context, String factoryName) {
        Object accessor = null;
        try {
            Class<?> factoryClass = Class.forName(factoryName);
            Object factory = factoryClass.getMethod("a", Context.class).invoke(null, context);
            Class<?> typeClass = Class.forName(
                    "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory$MutableDictionaryType");
            @SuppressWarnings({"rawtypes", "unchecked"})
            Object userType = Enum.valueOf((Class<? extends Enum>) typeClass.asSubclass(Enum.class),
                    "USER_DICTIONARY");
            Class<?> baseClass = Class.forName(
                    "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory");
            Method create = baseClass.getMethod("createMutableDictionaryAccessor", typeClass);
            accessor = create.invoke(factory, userType);
            if (accessor == null) return false;
            Class<?> accessorType = Class.forName(
                    "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface");
            // A cheap readability probe only: this value is a weight sum, not a record count.
            Object value = accessorType.getMethod("getDictionaryCount").invoke(accessor);
            return value instanceof Integer && ((Integer) value).intValue() >= 0;
        } catch (Throwable unavailable) {
            return false;
        } finally {
            if (accessor != null) {
                try {
                    Class.forName("com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface")
                            .getMethod("close").invoke(accessor);
                } catch (Throwable ignored) {}
            }
        }
    }

    private static FileStats files(Context context, String name) {
        File main = context.getFileStreamPath(name);
        File backup = context.getFileStreamPath(name + "_bak");
        return new FileStats(main.exists() && main.canRead(), main.exists() ? main.length() : 0L,
                main.exists() ? main.lastModified() : 0L,
                backup.exists() && backup.canRead(), backup.exists() ? backup.length() : 0L,
                context.getFileStreamPath(name + "_tmp").exists(),
                context.getFileStreamPath(name + "_unreadable").exists());
    }
    private static String describeMain(FileStats s) {
        return s.main ? formatBytes(s.mainBytes) : "尚无可读取的文件";
    }
    private static String describeBackup(FileStats s) {
        return s.backup ? formatBytes(s.backupBytes) : "无";
    }
    private static String formatBytes(long bytes) {
        if (bytes < 1024L) return bytes + " B";
        if (bytes < 1048576L) return String.format(Locale.US, "%.1f KB", bytes / 1024.0);
        return String.format(Locale.US, "%.2f MB", bytes / 1048576.0);
    }
    private static final class FileStats {
        final boolean main; final long mainBytes; final long modified;
        final boolean backup; final long backupBytes;
        final boolean temporary; final boolean unreadable;
        FileStats(boolean m, long mb, long mt, boolean b, long bb, boolean t, boolean u) {
            main = m; mainBytes = mb; modified = mt; backup = b; backupBytes = bb;
            temporary = t; unreadable = u;
        }
    }
}
