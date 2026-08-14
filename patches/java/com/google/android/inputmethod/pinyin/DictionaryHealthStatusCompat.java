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

/** On-demand, read-only health snapshot for the user-dictionary settings page. */
public final class DictionaryHealthStatusCompat {
    public interface Callback { void onLoaded(String summary); }

    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ExecutorService IO = Executors.newSingleThreadExecutor();
    private static final Object FALLBACK_LOCK = new Object();
    private static final String CHINESE = "user_dict_3_3";
    private static final String ENGLISH = "user_dict_3_3_english";

    private DictionaryHealthStatusCompat() {}

    /** This is deliberately called only by the visible dictionary settings controller. */
    public static void load(Context source, final Callback callback) {
        if (source == null || callback == null) return;
        final Context context = source.getApplicationContext();
        IO.execute(new Runnable() {
            @Override public void run() {
                final String summary = inspect(context);
                MAIN.post(new Runnable() {
                    @Override public void run() { callback.onLoaded(summary); }
                });
            }
        });
    }

    private static String inspect(Context context) {
        FileStats zh;
        FileStats en;
        Integer zhEntries;
        Integer enEntries;
        // Match native export/save serialization so counts and files are not sampled
        // halfway through a main/_bak/_tmp rotation.
        synchronized (dictionaryLock()) {
            zh = files(context, CHINESE);
            en = files(context, ENGLISH);
            zhEntries = nativeEntryCount(context, "bdt");
            enEntries = nativeEntryCount(context, "agb");
        }

        boolean nativeReadable = zhEntries != null && enEntries != null;
        boolean recoveryArtifact = zh.unreadable || en.unreadable;
        boolean temporary = zh.temporary || en.temporary;
        String state;
        if (recoveryArtifact) state = "需注意：发现不可读恢复归档，建议立即备份";
        else if (temporary) state = "需复查：发现未完成的临时文件，建议重启后再查看";
        else if (nativeReadable) state = "正常：中文和英文用户词库均可读取";
        else state = "部分状态无法读取，文件信息如下";

        StringBuilder out = new StringBuilder(256);
        out.append("状态：").append(state);
        if (nativeReadable) {
            long total = (long) zhEntries.intValue() + (long) enEntries.intValue();
            out.append("\n词条：中文 ").append(zhEntries).append("；英文 ")
                    .append(enEntries).append("；合计 ").append(total);
        } else {
            out.append("\n词条：");
            out.append(zhEntries == null ? "中文无法读取" : "中文 " + zhEntries);
            out.append("；");
            out.append(enEntries == null ? "英文无法读取" : "英文 " + enEntries);
        }
        out.append("\n主文件：中文 ").append(describeMain(zh))
                .append("；英文 ").append(describeMain(en));
        out.append("\n滚动副本：中文 ").append(describeBackup(zh))
                .append("；英文 ").append(describeBackup(en));
        out.append("\n恢复旁路：").append(describeSidecars(zh, en));
        long newest = Math.max(zh.modified, en.modified);
        if (newest > 0L) {
            out.append("\n最近落盘：")
                    .append(DateFormat.getDateFormat(context).format(newest)).append(' ')
                    .append(DateFormat.getTimeFormat(context).format(newest));
        }
        return out.toString();
    }

    private static Object dictionaryLock() {
        try {
            Class<?> saveTask = Class.forName(
                    "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask");
            Object lock = saveTask.getField("sSaveLock").get(null);
            return lock == null ? FALLBACK_LOCK : lock;
        } catch (Throwable ignored) {
            return FALLBACK_LOCK;
        }
    }

    private static Integer nativeEntryCount(Context context, String factoryName) {
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
            if (accessor == null) return null;
            Class<?> accessorType = Class.forName(
                    "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface");
            Object value = accessorType.getMethod("getDictionarySize").invoke(accessor);
            return value instanceof Integer && ((Integer) value).intValue() >= 0
                    ? (Integer) value : null;
        } catch (Throwable ignored) {
            return null;
        } finally {
            if (accessor != null) {
                try {
                    Class<?> accessorType = Class.forName(
                            "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface");
                    accessorType.getMethod("close").invoke(accessor);
                } catch (Throwable ignored) {}
            }
        }
    }

    private static FileStats files(Context context, String name) {
        File main = context.getFileStreamPath(name);
        File backup = context.getFileStreamPath(name + "_bak");
        File temporary = context.getFileStreamPath(name + "_tmp");
        File unreadable = context.getFileStreamPath(name + "_unreadable");
        return new FileStats(main.exists() && main.canRead(), main.exists() ? main.length() : 0L,
                main.exists() ? main.lastModified() : 0L,
                backup.exists() && backup.canRead(), backup.exists() ? backup.length() : 0L,
                temporary.exists(), unreadable.exists());
    }

    private static String describeMain(FileStats s) {
        if (!s.main) return "尚未落盘";
        return formatBytes(s.mainBytes);
    }

    private static String describeBackup(FileStats s) {
        if (!s.backup) return "无";
        return "有（" + formatBytes(s.backupBytes) + "）";
    }

    private static String describeSidecars(FileStats zh, FileStats en) {
        int tmp = (zh.temporary ? 1 : 0) + (en.temporary ? 1 : 0);
        int unreadable = (zh.unreadable ? 1 : 0) + (en.unreadable ? 1 : 0);
        if (tmp == 0 && unreadable == 0) return "无 _tmp / _unreadable";
        return "_tmp " + tmp + " 个；_unreadable " + unreadable + " 个";
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
