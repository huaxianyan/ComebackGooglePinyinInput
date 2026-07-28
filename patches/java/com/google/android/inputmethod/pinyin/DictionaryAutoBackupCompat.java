package com.google.android.inputmethod.pinyin;

import android.content.ContentResolver;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.UriPermission;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.provider.DocumentsContract;
import android.widget.Toast;

import com.google.android.apps.inputmethod.libs.framework.core.TaskListener;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** Provider-backed rotating exports for manual recovery after clear-data/uninstall. */
public final class DictionaryAutoBackupCompat {
    static final String PREFS = "dictionary_local_backup_preferences";
    static final String KEY_ENABLED = "dictionary_auto_backup_enabled";
    static final String KEY_TREE_URI = "dictionary_auto_backup_tree_uri";
    static final String KEY_TREE_LABEL = "dictionary_auto_backup_tree_label";
    static final String KEY_INTERVAL = "dictionary_auto_backup_interval_days";
    static final String KEY_RETENTION = "dictionary_auto_backup_retention_count";
    static final String KEY_LAST_SUCCESS = "dictionary_auto_backup_last_success_time";
    static final String KEY_LAST_ATTEMPT = "dictionary_auto_backup_last_attempt_time";
    static final String KEY_LAST_STATUS = "dictionary_auto_backup_last_status";
    static final String KEY_LAST_URI = "dictionary_auto_backup_last_document_uri";
    static final String KEY_LAST_SHA256 = "dictionary_auto_backup_last_sha256";
    static final String KEY_FAILURES = "dictionary_auto_backup_consecutive_failures";
    static final String KEY_BACKUP_NOW = "dictionary_auto_backup_now";
    static final String KEY_IMPORT_BACKUP = "dictionary_auto_backup_import";

    static final String EXTERNAL_STORAGE_AUTHORITY = "com.android.externalstorage.documents";
    private static final String PREFIX = "google-pinyin-user-dictionary-";
    private static final String PARTIAL_SUFFIX = ".txt.partial";
    private static final String FINAL_SUFFIX = ".txt";
    private static final long HOUR_MS = 60L * 60L * 1000L;
    private static final long DAY_MS = 24L * HOUR_MS;
    private static final long PARTIAL_MAX_AGE_MS = DAY_MS;

    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ExecutorService IO = Executors.newSingleThreadExecutor();
    private static boolean sInProgress;

    private DictionaryAutoBackupCompat() {}

    static SharedPreferences prefs(Context context) {
        return context.getApplicationContext().getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    public static boolean isInProgress() {
        synchronized (DictionaryAutoBackupCompat.class) {
            return sInProgress;
        }
    }

    static boolean isSupportedTree(Uri uri) {
        if (Build.VERSION.SDK_INT < 21 || uri == null
                || !ContentResolver.SCHEME_CONTENT.equals(uri.getScheme())
                || uri.getAuthority() == null || uri.getAuthority().length() == 0) {
            return false;
        }
        try {
            return DocumentsContract.isTreeUri(uri);
        } catch (RuntimeException ignored) {
            return false;
        }
    }

    static boolean hasPersistedAccess(Context context, Uri uri) {
        if (!isSupportedTree(uri)) return false;
        try {
            List<UriPermission> permissions = context.getContentResolver().getPersistedUriPermissions();
            for (UriPermission permission : permissions) {
                if (uri.equals(permission.getUri()) && permission.isReadPermission()
                        && permission.isWritePermission()) {
                    return true;
                }
            }
        } catch (RuntimeException ignored) {
        }
        return false;
    }

    public static void request(Context source, boolean force) {
        if (source == null) return;
        final Context context = source.getApplicationContext();
        final SharedPreferences preferences = prefs(context);
        final long now = System.currentTimeMillis();
        final Uri tree;

        synchronized (DictionaryAutoBackupCompat.class) {
            if (sInProgress) {
                if (force) showToast(context, "用户词典备份正在进行");
                return;
            }
            if (Build.VERSION.SDK_INT < 21) {
                if (force) showToast(context, "自定义目录备份需要 Android 5.0 或更高版本");
                return;
            }
            if (!force && !preferences.getBoolean(KEY_ENABLED, false)) return;
            if (!force) {
                int intervalDays = clamp(preferences.getInt(KEY_INTERVAL, 7), 1, 365, 7);
                long lastSuccess = preferences.getLong(KEY_LAST_SUCCESS, 0L);
                boolean due = lastSuccess <= 0L || now < lastSuccess
                        || now - lastSuccess >= intervalDays * DAY_MS;
                if (!due) return;
                long lastAttempt = preferences.getLong(KEY_LAST_ATTEMPT, 0L);
                if (lastAttempt > 0L && now >= lastAttempt && now - lastAttempt < HOUR_MS
                        && preferences.getInt(KEY_FAILURES, 0) > 0) {
                    return;
                }
            }
            String treeValue = preferences.getString(KEY_TREE_URI, null);
            if (treeValue == null || treeValue.length() == 0) {
                failWithoutStarting(context, force, "未选择备份和导入位置");
                return;
            }
            try {
                tree = Uri.parse(treeValue);
            } catch (RuntimeException e) {
                failWithoutStarting(context, force, "备份和导入位置无效");
                return;
            }
            if (!hasPersistedAccess(context, tree)) {
                failWithoutStarting(context, force, "备份和导入位置不可访问，请重新选择");
                return;
            }
            sInProgress = true;
            preferences.edit().putLong(KEY_LAST_ATTEMPT, now)
                    .putString(KEY_LAST_STATUS, "正在备份").apply();
        }

        DictionaryAutoBackupSettingsCompat.refreshAll();
        IO.execute(new Runnable() {
            @Override public void run() {
                prepareAndStart(context, tree, force);
            }
        });
    }

    private static void failWithoutStarting(Context context, boolean force, String message) {
        SharedPreferences p = prefs(context);
        p.edit().putLong(KEY_LAST_ATTEMPT, System.currentTimeMillis())
                .putString(KEY_LAST_STATUS, message)
                .putInt(KEY_FAILURES, p.getInt(KEY_FAILURES, 0) + 1).apply();
        if (force) showToast(context, message);
        DictionaryAutoBackupSettingsCompat.refreshAll();
    }

    private static void prepareAndStart(final Context context, final Uri tree,
            final boolean force) {
        Uri partial = null;
        try {
            cleanupOldPartials(context, tree);
            String stamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss-SSS", Locale.US)
                    .format(new Date());
            String finalName = PREFIX + stamp + FINAL_SUFFIX;
            String partialName = finalName + ".partial";
            Uri parent = treeDocumentUri(tree);
            partial = DocumentsContract.createDocument(context.getContentResolver(), parent,
                    "text/plain", partialName);
            if (partial == null) throw new IllegalStateException("createDocument returned null");
            final Uri created = partial;
            final String outputName = finalName;
            MAIN.post(new Runnable() {
                @Override public void run() {
                    enqueueNativeExport(context, tree, created, outputName, force);
                }
            });
        } catch (Throwable t) {
            if (partial != null) deleteQuietly(context, partial);
            finishFailure(context, force, "无法在所选备份目录创建文件", t);
        }
    }

    private static void enqueueNativeExport(Context context, Uri tree, Uri partial,
            String finalName, boolean force) {
        try {
            Class<?> managerClass = Class.forName("aib");
            Object manager = managerClass.getMethod("a").invoke(null);
            Class<?> factoryInterface = Class.forName(
                    "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory");
            Class<?> factoryClass = Class.forName("beg");
            Constructor<?> constructor = factoryClass.getConstructor(Context.class,
                    TaskListener.class, Uri.class);
            TaskListener listener = new ExportListener(context, tree, partial, finalName, force);
            Object factory = constructor.newInstance(context, listener, partial);
            Method schedule = managerClass.getMethod("a", String.class, factoryInterface,
                    Long.TYPE);
            schedule.invoke(manager, "user_dict_auto_backup", factory, 0L);
        } catch (Throwable t) {
            deleteQuietly(context, partial);
            finishFailure(context, force, "无法启动原生用户词典导出", t);
        }
    }

    private static final class ExportListener implements TaskListener {
        private final Context context;
        private final Uri tree;
        private final Uri partial;
        private final String finalName;
        private final boolean force;
        private int taskError;

        ExportListener(Context context, Uri tree, Uri partial, String finalName, boolean force) {
            this.context = context.getApplicationContext();
            this.tree = tree;
            this.partial = partial;
            this.finalName = finalName;
            this.force = force;
        }

        @Override public void onTaskStart() {}
        @Override public void onTaskProgress(int progress) {}
        @Override public void onTaskError(int error) { taskError = error; }

        @Override public void onTaskFinished(final boolean success, Object result) {
            IO.execute(new Runnable() {
                @Override public void run() {
                    if (!success) {
                        deleteQuietly(context, partial);
                        finishFailure(context, force,
                                taskError == 0 ? "原生用户词典导出失败" :
                                        "原生用户词典导出失败（" + taskError + "）", null);
                        return;
                    }
                    finalizeExport(context, tree, partial, finalName, force);
                }
            });
        }
    }

    private static void finalizeExport(Context context, Uri tree, Uri partial,
            String finalName, boolean force) {
        try {
            String sha256 = validateAndHash(context, partial);
            Uri completed = DocumentsContract.renameDocument(context.getContentResolver(),
                    partial, finalName);
            if (completed == null) throw new IllegalStateException("renameDocument returned null");
            long now = System.currentTimeMillis();
            SharedPreferences p = prefs(context);
            p.edit().putLong(KEY_LAST_SUCCESS, now)
                    .putString(KEY_LAST_STATUS, "备份成功")
                    .putString(KEY_LAST_URI, completed.toString())
                    .putString(KEY_LAST_SHA256, sha256)
                    .putInt(KEY_FAILURES, 0).apply();
            boolean cleanupOk = rotate(context, tree,
                    clamp(p.getInt(KEY_RETENTION, 10), 1, 100, 10));
            if (!cleanupOk) {
                p.edit().putString(KEY_LAST_STATUS, "备份成功，但旧版本清理失败").apply();
            }
            finishSuccess(context, force);
        } catch (Throwable t) {
            deleteQuietly(context, partial);
            finishFailure(context, force, "备份校验或发布失败", t);
        }
    }

    private static String validateAndHash(Context context, Uri uri) throws Exception {
        InputStream in = null;
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        try {
            in = context.getContentResolver().openInputStream(uri);
            if (in == null) throw new IllegalStateException("openInputStream returned null");
            byte[] buffer = new byte[8192];
            int count;
            while ((count = in.read(buffer)) != -1) bytes.write(buffer, 0, count);
        } finally {
            if (in != null) in.close();
        }
        byte[] data = bytes.toByteArray();
        byte[] header = ("\ufeff# User dictionary for Google Pinyin Input\n")
                .getBytes("UTF-16LE");
        if (data.length < header.length) throw new IllegalStateException("backup too short");
        for (int i = 0; i < header.length; i++) {
            if (data[i] != header[i]) throw new IllegalStateException("invalid backup header");
        }
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(data);
        StringBuilder out = new StringBuilder(hash.length * 2);
        for (byte value : hash) out.append(String.format(Locale.US, "%02x", value & 0xff));
        return out.toString();
    }

    interface BackupListCallback {
        void onBackupListLoaded(List<BackupEntry> entries);
    }

    static void listBackupsAsync(final Context source, final BackupListCallback callback) {
        final Context context = source.getApplicationContext();
        IO.execute(new Runnable() {
            @Override public void run() {
                final List<BackupEntry> entries = listConfiguredBackups(context);
                MAIN.post(new Runnable() {
                    @Override public void run() { callback.onBackupListLoaded(entries); }
                });
            }
        });
    }

    private static List<BackupEntry> listConfiguredBackups(Context context) {
        SharedPreferences p = prefs(context);
        String value = p.getString(KEY_TREE_URI, null);
        if (value == null || value.length() == 0) return new ArrayList<BackupEntry>();
        try {
            Uri tree = Uri.parse(value);
            if (!hasPersistedAccess(context, tree)) return new ArrayList<BackupEntry>();
            return listBackups(context, tree);
        } catch (Throwable ignored) {
            return new ArrayList<BackupEntry>();
        }
    }

    private static List<BackupEntry> listBackups(Context context, Uri tree) throws Exception {
        List<BackupEntry> backups = new ArrayList<BackupEntry>();
        Cursor cursor = null;
        try {
            Uri children = DocumentsContract.buildChildDocumentsUriUsingTree(tree,
                    DocumentsContract.getTreeDocumentId(tree));
            String[] projection = {
                    DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                    DocumentsContract.Document.COLUMN_DISPLAY_NAME
            };
            cursor = context.getContentResolver().query(children, projection, null, null, null);
            if (cursor == null) throw new IllegalStateException("backup directory query failed");
            while (cursor.moveToNext()) {
                String name = cursor.getString(1);
                if (name != null && name.startsWith(PREFIX) && name.endsWith(FINAL_SUFFIX)
                        && !name.endsWith(PARTIAL_SUFFIX)) {
                    backups.add(new BackupEntry(name,
                            DocumentsContract.buildDocumentUriUsingTree(tree, cursor.getString(0))));
                }
            }
        } finally {
            if (cursor != null) cursor.close();
        }
        Collections.sort(backups, new Comparator<BackupEntry>() {
            @Override public int compare(BackupEntry left, BackupEntry right) {
                return right.name.compareTo(left.name);
            }
        });
        return backups;
    }

    static final class BackupEntry {
        final String name;
        final Uri uri;
        BackupEntry(String name, Uri uri) { this.name = name; this.uri = uri; }
    }

    private static boolean rotate(Context context, Uri tree, int retention) {
        boolean ok = true;
        try {
            List<BackupEntry> backups = listBackups(context, tree);
            ContentResolver resolver = context.getContentResolver();
            for (int i = retention; i < backups.size(); i++) {
                try {
                    if (!DocumentsContract.deleteDocument(resolver, backups.get(i).uri)) ok = false;
                } catch (Throwable ignored) {
                    ok = false;
                }
            }
        } catch (Throwable ignored) {
            ok = false;
        }
        return ok;
    }

    private static void cleanupOldPartials(Context context, Uri tree) {
        Cursor cursor = null;
        try {
            ContentResolver resolver = context.getContentResolver();
            Uri children = DocumentsContract.buildChildDocumentsUriUsingTree(tree,
                    DocumentsContract.getTreeDocumentId(tree));
            String[] projection = {
                    DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                    DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                    DocumentsContract.Document.COLUMN_LAST_MODIFIED
            };
            cursor = resolver.query(children, projection, null, null, null);
            if (cursor == null) return;
            long now = System.currentTimeMillis();
            while (cursor.moveToNext()) {
                String name = cursor.getString(1);
                long modified = cursor.isNull(2) ? 0L : cursor.getLong(2);
                if (name != null && name.startsWith(PREFIX) && name.endsWith(PARTIAL_SUFFIX)
                        && modified > 0L && now >= modified
                        && now - modified >= PARTIAL_MAX_AGE_MS) {
                    Uri child = DocumentsContract.buildDocumentUriUsingTree(tree,
                            cursor.getString(0));
                    try { DocumentsContract.deleteDocument(resolver, child); }
                    catch (Throwable ignored) {}
                }
            }
        } catch (Throwable ignored) {
        } finally {
            if (cursor != null) cursor.close();
        }
    }

    interface ValidationCallback {
        void onValidationFinished(Uri tree, String error);
    }

    static void validateTreeAsync(final Context source, final Uri tree,
            final ValidationCallback callback) {
        final Context context = source.getApplicationContext();
        IO.execute(new Runnable() {
            @Override public void run() {
                final String error = validateTree(context, tree);
                MAIN.post(new Runnable() {
                    @Override public void run() {
                        callback.onValidationFinished(tree, error);
                    }
                });
            }
        });
    }

    private static String validateTree(Context context, Uri tree) {
        if (!isSupportedTree(tree)) return "请选择系统目录选择器提供的文件夹";
        if (!hasPersistedAccess(context, tree)) return "未获得所选目录的持久读写权限";
        Uri created = null;
        Uri renamed = null;
        try {
            ContentResolver resolver = context.getContentResolver();
            Uri parent = treeDocumentUri(tree);
            String token = UUID.randomUUID().toString();
            created = DocumentsContract.createDocument(resolver, parent, "text/plain",
                    ".google-pinyin-backup-test-" + token + ".tmp");
            if (created == null) return "该目录不支持创建备份文件";
            OutputStream out = resolver.openOutputStream(created, "w");
            if (out == null) return "该目录不支持写入备份文件";
            out.write(new byte[] {0x47, 0x50, 0x49});
            out.close();
            InputStream in = resolver.openInputStream(created);
            if (in == null || in.read() != 0x47 || in.read() != 0x50 || in.read() != 0x49) {
                if (in != null) in.close();
                return "该目录不支持可靠读取备份文件";
            }
            in.close();
            renamed = DocumentsContract.renameDocument(resolver, created,
                    ".google-pinyin-backup-test-renamed-" + token + ".tmp");
            if (renamed == null) return "该目录不支持安全发布备份文件";
            created = null;
            if (!DocumentsContract.deleteDocument(resolver, renamed)) {
                return "该目录不支持删除旧备份版本";
            }
            renamed = null;
            return null;
        } catch (Throwable t) {
            return "所选存储位置不支持安全自动备份";
        } finally {
            if (created != null) deleteQuietly(context, created);
            if (renamed != null) deleteQuietly(context, renamed);
        }
    }

    private static Uri treeDocumentUri(Uri tree) {
        return DocumentsContract.buildDocumentUriUsingTree(tree,
                DocumentsContract.getTreeDocumentId(tree));
    }

    private static void finishSuccess(final Context context, final boolean force) {
        synchronized (DictionaryAutoBackupCompat.class) { sInProgress = false; }
        MAIN.post(new Runnable() {
            @Override public void run() {
                DictionaryAutoBackupSettingsCompat.refreshAll();
                if (force) showToast(context, "用户词典备份成功");
            }
        });
    }

    private static void finishFailure(final Context context, final boolean force,
            final String message, Throwable throwable) {
        SharedPreferences p = prefs(context);
        p.edit().putString(KEY_LAST_STATUS, message)
                .putInt(KEY_FAILURES, p.getInt(KEY_FAILURES, 0) + 1).apply();
        synchronized (DictionaryAutoBackupCompat.class) { sInProgress = false; }
        MAIN.post(new Runnable() {
            @Override public void run() {
                DictionaryAutoBackupSettingsCompat.refreshAll();
                if (force) showToast(context, message);
            }
        });
    }

    private static void deleteQuietly(Context context, Uri uri) {
        try { DocumentsContract.deleteDocument(context.getContentResolver(), uri); }
        catch (Throwable ignored) {}
    }

    private static void showToast(final Context context, final String text) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
        } else {
            MAIN.post(new Runnable() {
                @Override public void run() {
                    Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
                }
            });
        }
    }

    private static int clamp(int value, int min, int max, int fallback) {
        return value < min || value > max ? fallback : value;
    }
}
