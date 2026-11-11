package com.google.android.inputmethod.pinyin;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory;
import com.google.android.inputmethod.pinyin.rimesync.GoogleNativeDictionaryBridge;
import com.google.android.inputmethod.pinyin.dictsafety.DictionarySafetyGuard;

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
        Toast.makeText(this, "正在读取备份目录……", Toast.LENGTH_SHORT).show();
        DictionaryAutoBackupCompat.listBackupsAsync(this, this);
    }

    @Override public void onBackupListLoaded(
            final List<DictionaryAutoBackupCompat.BackupEntry> entries) {
        if (isFinishing()) return;
        if (entries.isEmpty()) {
            new AlertDialog.Builder(this).setTitle("没有可访问的用户词典备份")
                    .setMessage("尚未设置备份和导入目录，或所选目录中没有 Google 拼音用户词典备份。请在字典设置中选择已有备份目录，也可以从文件管理器打开或分享备份 .txt。")
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
                .setMessage("将「" + name + "」合并到当前用户词典？")
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

    public static boolean startNativeImport(Context source, Uri uri) {
        final Context app = source.getApplicationContext();
        Toast.makeText(app, "正在导入用户词典备份", Toast.LENGTH_SHORT).show();
        new Thread(new Runnable() {
            @Override public void run() {
                String message;
                try {
                    byte[] backup = readAll(app, uri);
                    Object factory = Class.forName("bdt")
                            .getMethod("a", Context.class).invoke(null, app);
                    int written = GoogleNativeDictionaryBridge.importBackup(app,
                            (AbstractHmmEngineFactory) factory, backup);
                    message = written > 0
                            ? "已导入 " + written + " 条词条"
                            : "备份里没有可导入的词条";
                    DictionarySafetyGuard.request(app);
                } catch (Throwable failure) {
                    android.util.Log.e("PinyinImport", "backup import failed", failure);
                    message = "导入未完成：" + failure.getMessage();
                }
                final String text = message;
                new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
                    @Override public void run() {
                        Toast.makeText(app, text, Toast.LENGTH_LONG).show();
                    }
                });
            }
        }).start();
        return true;
    }

    private static byte[] readAll(Context context, Uri uri) throws java.io.IOException {
        java.io.InputStream in = context.getContentResolver().openInputStream(uri);
        if (in == null) throw new java.io.IOException("backup cannot be opened");
        try {
            java.io.ByteArrayOutputStream bytes = new java.io.ByteArrayOutputStream();
            byte[] buffer = new byte[8192];
            int read;
            while ((read = in.read(buffer)) != -1) bytes.write(buffer, 0, read);
            return bytes.toByteArray();
        } finally {
            in.close();
        }
    }
}
