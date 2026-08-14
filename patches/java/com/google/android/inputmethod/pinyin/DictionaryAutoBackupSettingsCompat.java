package com.google.android.inputmethod.pinyin;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Build;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.preference.TwoStatePreference;
import android.provider.DocumentsContract;
import android.text.format.DateFormat;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

/** Binds a shared user-selected DocumentsProvider directory to backup and import. */
public final class DictionaryAutoBackupSettingsCompat {
    private static final int REQUEST_TREE = 0x6b01;
    private static final String KEY_LOCATION = "dictionary_auto_backup_location";
    private static final int PICK_LOCATION = 0;
    private static final int PICK_ENABLE = 1;
    private static final int PICK_IMPORT = 2;
    private static final Map<PreferenceFragment, Controller> CONTROLLERS =
            new WeakHashMap<PreferenceFragment, Controller>();

    private DictionaryAutoBackupSettingsCompat() {}

    public static void bind(PreferenceFragment fragment) {
        if (fragment == null || fragment.getActivity() == null) return;
        synchronized (CONTROLLERS) {
            Controller old = CONTROLLERS.remove(fragment);
            if (old != null) old.destroy();
            Controller controller = new Controller(fragment);
            CONTROLLERS.put(fragment, controller);
            controller.bind();
        }
    }

    public static boolean handleActivityResult(PreferenceFragment fragment, int requestCode,
            int resultCode, Intent data) {
        if (requestCode != REQUEST_TREE) return false;
        Controller controller;
        synchronized (CONTROLLERS) { controller = CONTROLLERS.get(fragment); }
        if (controller != null) controller.onTreeResult(resultCode, data);
        return true;
    }

    public static boolean handleRequestPermissionsResult(PreferenceFragment fragment,
            int requestCode, String[] permissions, int[] results) {
        return false;
    }

    public static void refresh(PreferenceFragment fragment) {
        Controller controller;
        synchronized (CONTROLLERS) { controller = CONTROLLERS.get(fragment); }
        if (controller != null) controller.refresh();
    }

    public static void unbind(PreferenceFragment fragment) {
        synchronized (CONTROLLERS) {
            Controller controller = CONTROLLERS.remove(fragment);
            if (controller != null) controller.destroy();
        }
    }

    static void refreshAll() {
        final List<Controller> snapshot;
        synchronized (CONTROLLERS) {
            snapshot = new ArrayList<Controller>(CONTROLLERS.values());
        }
        for (Controller controller : snapshot) controller.refresh();
    }

    private static final class Controller implements Preference.OnPreferenceClickListener,
            Preference.OnPreferenceChangeListener,
            DictionaryAutoBackupCompat.ValidationCallback,
            DictionaryAutoBackupCompat.BackupListCallback {
        private PreferenceFragment fragment;
        private Preference dictionaryStatus;
        private TwoStatePreference enabledPreference;
        private Preference locationPreference;
        private ListPreference intervalPreference;
        private ListPreference retentionPreference;
        private Preference backupNowPreference;
        private Preference importPreference;
        private int pickPurpose = PICK_LOCATION;
        private boolean validating;
        private boolean importLoading;
        private Uri pendingTree;
        private int statusGeneration;
        private boolean statusLoading;

        Controller(PreferenceFragment fragment) { this.fragment = fragment; }

        void bind() {
            dictionaryStatus = fragment.findPreference("dictionary_current_status");
            enabledPreference = (TwoStatePreference) fragment.findPreference(
                    DictionaryAutoBackupCompat.KEY_ENABLED);
            locationPreference = fragment.findPreference(KEY_LOCATION);
            intervalPreference = (ListPreference) fragment.findPreference(
                    DictionaryAutoBackupCompat.KEY_INTERVAL);
            retentionPreference = (ListPreference) fragment.findPreference(
                    DictionaryAutoBackupCompat.KEY_RETENTION);
            backupNowPreference = fragment.findPreference(DictionaryAutoBackupCompat.KEY_BACKUP_NOW);
            importPreference = fragment.findPreference(DictionaryAutoBackupCompat.KEY_IMPORT_BACKUP);

            if (dictionaryStatus != null) dictionaryStatus.setOnPreferenceClickListener(this);
            if (enabledPreference != null) enabledPreference.setOnPreferenceChangeListener(this);
            if (locationPreference != null) locationPreference.setOnPreferenceClickListener(this);
            if (intervalPreference != null) intervalPreference.setOnPreferenceChangeListener(this);
            if (retentionPreference != null) retentionPreference.setOnPreferenceChangeListener(this);
            if (backupNowPreference != null) backupNowPreference.setOnPreferenceClickListener(this);
            if (importPreference != null) importPreference.setOnPreferenceClickListener(this);
            refresh();
            loadDictionaryStatus();
        }

        void destroy() {
            statusGeneration++;
            statusLoading = false;
            importLoading = false;
            fragment = null;
            dictionaryStatus = null;
            enabledPreference = null;
            locationPreference = null;
            intervalPreference = null;
            retentionPreference = null;
            backupNowPreference = null;
            importPreference = null;
            pendingTree = null;
        }

        private Context context() {
            return fragment == null || fragment.getActivity() == null ? null
                    : fragment.getActivity().getApplicationContext();
        }

        @Override public boolean onPreferenceClick(Preference preference) {
            Context context = context();
            if (context == null) return true;
            if (preference == dictionaryStatus) {
                loadDictionaryStatus();
            } else if (preference == locationPreference) {
                openTreePicker(PICK_LOCATION);
            } else if (preference == backupNowPreference) {
                DictionaryAutoBackupCompat.request(context, true);
            } else if (preference == importPreference) {
                SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
                Uri tree = configuredTree(p);
                if (tree == null || !DictionaryAutoBackupCompat.hasPersistedAccess(context, tree)) {
                    openTreePicker(PICK_IMPORT);
                } else {
                    openImportList();
                }
            }
            return true;
        }

        @Override public boolean onPreferenceChange(Preference preference, Object newValue) {
            Context context = context();
            if (context == null) return false;
            SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
            if (preference == enabledPreference) {
                boolean enabled = Boolean.TRUE.equals(newValue);
                if (!enabled) {
                    p.edit().putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false).apply();
                    refreshSoon();
                    return true;
                }
                Uri tree = configuredTree(p);
                if (tree == null || !DictionaryAutoBackupCompat.hasPersistedAccess(context, tree)) {
                    openTreePicker(PICK_ENABLE);
                    return false;
                }
                p.edit().putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, true).apply();
                DictionaryAutoBackupCompat.request(context, true);
                refreshSoon();
                return true;
            }
            if (preference == intervalPreference) {
                p.edit().putInt(DictionaryAutoBackupCompat.KEY_INTERVAL,
                        boundedInt(newValue, 1, 365, 7)).apply();
                refreshSoon();
                return true;
            }
            if (preference == retentionPreference) {
                p.edit().putInt(DictionaryAutoBackupCompat.KEY_RETENTION,
                        boundedInt(newValue, 1, 100, 10)).apply();
                refreshSoon();
                return true;
            }
            return false;
        }

        private void openTreePicker(int purpose) {
            if (fragment == null || validating || importLoading) return;
            if (Build.VERSION.SDK_INT < 21) {
                Toast.makeText(fragment.getActivity(), "自定义备份目录需要 Android 5.0 或更高版本",
                        Toast.LENGTH_SHORT).show();
                return;
            }
            pickPurpose = purpose;
            Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
            if (Build.VERSION.SDK_INT >= 26) {
                Uri initial = configuredTree(DictionaryAutoBackupCompat.prefs(
                        fragment.getActivity().getApplicationContext()));
                if (initial != null) {
                    try {
                        initial = DocumentsContract.buildDocumentUriUsingTree(initial,
                                DocumentsContract.getTreeDocumentId(initial));
                    } catch (RuntimeException ignored) {
                        initial = null;
                    }
                }
                if (initial == null) initial = DocumentsContract.buildDocumentUri(
                        DictionaryAutoBackupCompat.EXTERNAL_STORAGE_AUTHORITY,
                        "primary:Documents");
                intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, initial);
            }
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
            try {
                fragment.startActivityForResult(intent, REQUEST_TREE);
            } catch (RuntimeException e) {
                Toast.makeText(fragment.getActivity(), "无法打开目录选择器",
                        Toast.LENGTH_SHORT).show();
            }
        }

        void onTreeResult(int resultCode, Intent data) {
            if (fragment == null) return;
            if (resultCode != Activity.RESULT_OK || data == null || data.getData() == null) {
                pickPurpose = PICK_LOCATION;
                refresh();
                return;
            }
            final Context context = context();
            if (context == null) return;
            Uri tree = data.getData();
            if (!DictionaryAutoBackupCompat.isSupportedTree(tree)) {
                Toast.makeText(context, "所选位置不是可持久授权的系统文档目录",
                        Toast.LENGTH_LONG).show();
                pickPurpose = PICK_LOCATION;
                refresh();
                return;
            }
            int flags = data.getFlags()
                    & (Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            if (flags != (Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION)) {
                Toast.makeText(context, "所选目录没有授予完整读写权限", Toast.LENGTH_LONG).show();
                pickPurpose = PICK_LOCATION;
                refresh();
                return;
            }
            try {
                context.getContentResolver().takePersistableUriPermission(tree, flags);
            } catch (RuntimeException e) {
                Toast.makeText(context, "无法保存所选目录的访问权限", Toast.LENGTH_LONG).show();
                pickPurpose = PICK_LOCATION;
                refresh();
                return;
            }
            pendingTree = tree;
            validating = true;
            setControlsEnabled(false);
            Toast.makeText(context, "正在验证备份目录…", Toast.LENGTH_SHORT).show();
            DictionaryAutoBackupCompat.validateTreeAsync(context, tree, this);
        }

        @Override public void onValidationFinished(Uri tree, String error) {
            Context context = context();
            if (context == null) return;
            validating = false;
            if (pendingTree == null || !pendingTree.equals(tree)) {
                refresh();
                return;
            }
            pendingTree = null;
            final int completedPurpose = pickPurpose;
            pickPurpose = PICK_LOCATION;
            if (error != null) {
                releaseGrant(context, tree);
                Toast.makeText(context, error, Toast.LENGTH_LONG).show();
                refresh();
                return;
            }

            SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
            String oldValue = p.getString(DictionaryAutoBackupCompat.KEY_TREE_URI, null);
            boolean shouldEnable = completedPurpose == PICK_ENABLE
                    || p.getBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false);
            String label = describeTree(context, tree);
            p.edit().putString(DictionaryAutoBackupCompat.KEY_TREE_URI, tree.toString())
                    .putString(DictionaryAutoBackupCompat.KEY_TREE_LABEL, label)
                    .putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, shouldEnable)
                    .putString(DictionaryAutoBackupCompat.KEY_LAST_STATUS, "备份目录验证成功")
                    .apply();

            if (oldValue != null && !oldValue.equals(tree.toString())) {
                try { releaseGrant(context, Uri.parse(oldValue)); }
                catch (RuntimeException ignored) {}
            }
            Toast.makeText(context, "备份和导入目录已设置", Toast.LENGTH_SHORT).show();
            refresh();
            if (completedPurpose == PICK_IMPORT) openImportList();
            if (shouldEnable) DictionaryAutoBackupCompat.request(context, true);
        }

        private void openImportList() {
            if (fragment == null || fragment.getActivity() == null || importLoading) return;
            importLoading = true;
            setControlsEnabled(false);
            Toast.makeText(fragment.getActivity(), "正在读取备份目录…",
                    Toast.LENGTH_SHORT).show();
            DictionaryAutoBackupCompat.listBackupsAsync(fragment.getActivity(), this);
        }

        @Override public void onBackupListLoaded(
                final List<DictionaryAutoBackupCompat.BackupEntry> entries) {
            if (fragment == null || fragment.getActivity() == null) return;
            importLoading = false;
            refresh();
            if (entries.isEmpty()) {
                new AlertDialog.Builder(fragment.getActivity()).setTitle("没有可用备份")
                        .setMessage("所选备份和导入目录中没有 Google 拼音用户词典备份。")
                        .setPositiveButton(android.R.string.ok, null).show();
                return;
            }
            String[] names = new String[entries.size()];
            for (int i = 0; i < names.length; i++) names[i] = entries.get(i).name;
            new AlertDialog.Builder(fragment.getActivity()).setTitle("导入用户词典备份")
                    .setItems(names, new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            confirmImport(entries.get(which));
                        }
                    }).setNegativeButton(android.R.string.cancel, null).show();
        }

        private void confirmImport(final DictionaryAutoBackupCompat.BackupEntry entry) {
            if (fragment == null || fragment.getActivity() == null) return;
            new AlertDialog.Builder(fragment.getActivity()).setTitle("导入用户词典备份")
                    .setMessage("将「" + entry.name + "」合并到当前用户词典？")
                    .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            LocalBackupImportActivity.startNativeImport(fragment.getActivity(), entry.uri);
                        }
                    }).setNegativeButton(android.R.string.cancel, null).show();
        }

        void refresh() {
            Context context = context();
            if (context == null) return;
            SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
            boolean supported = Build.VERSION.SDK_INT >= 21;
            boolean enabled = p.getBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false);
            Uri tree = configuredTree(p);
            boolean accessible = tree != null
                    && DictionaryAutoBackupCompat.hasPersistedAccess(context, tree);
            boolean busy = validating || importLoading;

            if (enabledPreference != null) {
                enabledPreference.setChecked(enabled);
                String status = p.getString(DictionaryAutoBackupCompat.KEY_LAST_STATUS, null);
                long last = p.getLong(DictionaryAutoBackupCompat.KEY_LAST_SUCCESS, 0L);
                if (DictionaryAutoBackupCompat.isInProgress()) {
                    enabledPreference.setSummary("正在生成用户词典备份…");
                } else if (status != null && status.length() > 0 && !"备份成功".equals(status)) {
                    enabledPreference.setSummary(status);
                } else if (last > 0L) {
                    enabledPreference.setSummary("上次备份："
                            + DateFormat.getDateFormat(context).format(last) + " "
                            + DateFormat.getTimeFormat(context).format(last));
                } else {
                    enabledPreference.setSummary("备份文件在清除数据或卸载后仍会保留");
                }
                enabledPreference.setEnabled(supported && !busy);
            }
            if (locationPreference != null) {
                String label = p.getString(DictionaryAutoBackupCompat.KEY_TREE_LABEL, null);
                if (tree == null) locationPreference.setSummary("未选择（备份和导入共用）");
                else if (!accessible) locationPreference.setSummary("位置不可访问，请重新选择");
                else locationPreference.setSummary(label == null || label.length() == 0
                        ? "已选择备份目录" : label);
                locationPreference.setEnabled(supported && !busy);
            }
            if (intervalPreference != null) {
                intervalPreference.setValue(Integer.toString(p.getInt(
                        DictionaryAutoBackupCompat.KEY_INTERVAL, 7)));
                intervalPreference.setEnabled(enabled && accessible && !busy);
            }
            if (retentionPreference != null) {
                retentionPreference.setValue(Integer.toString(p.getInt(
                        DictionaryAutoBackupCompat.KEY_RETENTION, 10)));
                retentionPreference.setEnabled(enabled && accessible && !busy);
            }
            if (backupNowPreference != null) {
                backupNowPreference.setEnabled(accessible && !busy
                        && !DictionaryAutoBackupCompat.isInProgress());
                backupNowPreference.setSummary(accessible
                        ? "立即导出到所选目录" : "请先选择备份和导入目录");
            }
            if (importPreference != null) {
                importPreference.setEnabled(supported && !busy);
                importPreference.setSummary(accessible
                        ? "列出所选目录中的用户词典备份" : "选择已有备份目录并导入");
            }
        }

        private void loadDictionaryStatus() {
            final Context context = context();
            if (context == null || dictionaryStatus == null || statusLoading) return;
            statusLoading = true;
            final int generation = ++statusGeneration;
            dictionaryStatus.setSummary("正在读取当前用户词库…");
            DictionaryHealthStatusCompat.load(context, new DictionaryHealthStatusCompat.Callback() {
                @Override public void onLoaded(String summary) {
                    if (generation != statusGeneration || fragment == null || dictionaryStatus == null)
                        return;
                    statusLoading = false;
                    dictionaryStatus.setSummary(summary + "\n点击重新检查");
                }
            });
        }

        private void setControlsEnabled(boolean enabled) {
            if (enabledPreference != null) enabledPreference.setEnabled(enabled);
            if (locationPreference != null) locationPreference.setEnabled(enabled);
            if (intervalPreference != null) intervalPreference.setEnabled(enabled);
            if (retentionPreference != null) retentionPreference.setEnabled(enabled);
            if (backupNowPreference != null) backupNowPreference.setEnabled(enabled);
            if (importPreference != null) importPreference.setEnabled(enabled);
        }

        private void refreshSoon() {
            if (fragment != null && fragment.getActivity() != null) {
                fragment.getActivity().getWindow().getDecorView().post(new Runnable() {
                    @Override public void run() { refresh(); }
                });
            }
        }

        private static Uri configuredTree(SharedPreferences p) {
            String value = p.getString(DictionaryAutoBackupCompat.KEY_TREE_URI, null);
            if (value == null || value.length() == 0) return null;
            try { return Uri.parse(value); }
            catch (RuntimeException e) { return null; }
        }

        private static int boundedInt(Object value, int min, int max, int fallback) {
            try {
                int parsed = Integer.parseInt(String.valueOf(value));
                return parsed < min || parsed > max ? fallback : parsed;
            } catch (RuntimeException e) {
                return fallback;
            }
        }

        private static void releaseGrant(Context context, Uri tree) {
            try {
                context.getContentResolver().releasePersistableUriPermission(tree,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                                | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            } catch (RuntimeException ignored) {}
        }

        private static String describeTree(Context context, Uri tree) {
            if (DictionaryAutoBackupCompat.EXTERNAL_STORAGE_AUTHORITY.equals(tree.getAuthority())) {
                try {
                    String id = DocumentsContract.getTreeDocumentId(tree);
                    int split = id.indexOf(':');
                    String volume = split < 0 ? id : id.substring(0, split);
                    String path = split < 0 || split + 1 >= id.length()
                            ? "" : id.substring(split + 1);
                    String root = "primary".equalsIgnoreCase(volume)
                            ? "内部存储" : "SD 卡（" + volume + "）";
                    return path.length() == 0 ? root : root + "/" + path;
                } catch (RuntimeException ignored) {}
            }
            String provider = null;
            try {
                PackageManager pm = context.getPackageManager();
                ProviderInfo info = pm.resolveContentProvider(tree.getAuthority(), 0);
                if (info != null) {
                    CharSequence label = info.loadLabel(pm);
                    if (label != null && label.length() > 0) provider = label.toString();
                }
            } catch (RuntimeException ignored) {}
            if (provider != null) return provider;
            return "已选择备份目录";
        }
    }
}
