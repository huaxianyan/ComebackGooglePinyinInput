package com.google.android.inputmethod.pinyin;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import com.google.android.apps.inputmethod.libs.framework.core.TaskListener;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.List;

/** Explicit manual import entry for the selected backup directory and file-manager VIEW/SEND. */
public final class LocalBackupImportActivity extends Activity
        implements DictionaryAutoBackupCompat.BackupListCallback {
    @Override protected void onCreate(Bundle state) {
        super.onCreate(state);
        Uri incoming = incomingUri(getIntent());
        if (incoming != null) confirm(incoming, "所选用户词典备份");
        else showBackups();
    }

    private Uri incomingUri(Intent intent) {
        if (intent == null) return null;
        if (Intent.ACTION_VIEW.equals(intent.getAction())) return intent.getData();
        if (Intent.ACTION_SEND.equals(intent.getAction())) {
            Object value = intent.getParcelableExtra(Intent.EXTRA_STREAM);
            return value instanceof Uri ? (Uri) value : null;
        }
        return null;
    }

    private void showBackups() {
        Toast.makeText(this, "正在读取备份目录…", Toast.LENGTH_SHORT).show();
        DictionaryAutoBackupCompat.listBackupsAsync(this, this);
    }

    @Override public void onBackupListLoaded(
            final List<DictionaryAutoBackupCompat.BackupEntry> entries) {
        if (isFinishing()) return;
        if (entries.isEmpty()) {
            new AlertDialog.Builder(this).setTitle("没有可访问的用户词典备份")
                    .setMessage("尚未设置备份和导入目录，或所选目录中没有 Google 拼音用户词典备份。请在字典设置中选择已有备份目录；也可以从文件管理器打开或分享备份 .txt。")
                    .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface d, int w) { finish(); }
                    }).setOnCancelListener(new DialogInterface.OnCancelListener() {
                        @Override public void onCancel(DialogInterface d) { finish(); }
                    }).show();
            return;
        }
        String[] names = new String[entries.size()];
        for (int i = 0; i < names.length; i++) names[i] = entries.get(i).name;
        new AlertDialog.Builder(this).setTitle("导入用户词典备份")
                .setItems(names, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int which) {
                        confirm(entries.get(which).uri, entries.get(which).name);
                    }
                }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) { finish(); }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override public void onCancel(DialogInterface d) { finish(); }
                }).show();
    }

    private void confirm(final Uri uri, String name) {
        new AlertDialog.Builder(this).setTitle("导入用户词典备份")
                .setMessage("将“" + name + "”合并到当前用户词典？")
                .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) {
                        startNativeImport(LocalBackupImportActivity.this, uri); finish();
                    }
                }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) { finish(); }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override public void onCancel(DialogInterface d) { finish(); }
                }).show();
    }

    static boolean startNativeImport(Context source, Uri uri) {
        final Context app = source.getApplicationContext();
        try {
            Class<?> managerClass = Class.forName("aib");
            Object manager = managerClass.getMethod("a").invoke(null);
            Class<?> factoryType = Class.forName(
                    "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory");
            Constructor<?> ctor = Class.forName("beh").getConstructor(Context.class,
                    TaskListener.class, Uri.class);
            Object factory = ctor.newInstance(app, new ImportListener(app), uri);
            Method schedule = managerClass.getMethod("a", String.class, factoryType, Long.TYPE);
            schedule.invoke(manager, "user_dict_import", factory, 0L);
            Toast.makeText(app, "正在导入用户词典备份", Toast.LENGTH_SHORT).show();
            return true;
        } catch (Throwable t) {
            Toast.makeText(app, "无法启动原生用户词典导入", Toast.LENGTH_LONG).show();
            return false;
        }
    }

    private static final class ImportListener implements TaskListener {
        final Context context;
        ImportListener(Context c) { context = c; }
        @Override public void onTaskStart() {}
        @Override public void onTaskProgress(int p) {}
        @Override public void onTaskError(int e) {}
        @Override public void onTaskFinished(boolean success, Object result) {
            Toast.makeText(context, success ? "用户词典备份导入成功" : "用户词典备份导入失败",
                    Toast.LENGTH_LONG).show();
        }
    }
}
