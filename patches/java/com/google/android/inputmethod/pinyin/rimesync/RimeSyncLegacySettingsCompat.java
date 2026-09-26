package com.google.android.inputmethod.pinyin.rimesync;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Build;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.preference.TwoStatePreference;
import android.provider.DocumentsContract;
import android.text.format.DateFormat;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Map;
import java.util.WeakHashMap;

/**
 * Bridges the legacy dictionary page to the same synchronization boundaries the modern settings
 * page calls. The page displays real state, persists the synchronization directory, device name
 * and snapshot file, configures automatic synchronization, and runs manual synchronization with
 * the compatibility rule and the deletion plan confirmed first.
 *
 * <p>Legacy callers cannot reference the host R class, so resource names are resolved through
 * {@link android.content.res.Resources#getIdentifier}. Missing strings degrade to the resource
 * name instead of crashing the page.
 */
public final class RimeSyncLegacySettingsCompat {
    private static final int REQUEST_TREE = 0x6b02;
    private static final String EXTERNAL_STORAGE_AUTHORITY = "com.android.externalstorage.documents";
    private static final String DOCUMENTS_FALLBACK = "primary:Documents";
    private static final String PROBE_DEVICE_NAME = "probe";

    private static final String KEY_STATUS = "rime_sync_current_status";
    private static final String KEY_AUTO_ENABLED = "rime_sync_auto_enabled";
    private static final String KEY_AUTO_INTERVAL = "rime_sync_auto_interval_hours";
    private static final String KEY_ROOT = "rime_sync_root";
    private static final String KEY_DEVICE = "rime_sync_device";
    private static final String KEY_SNAPSHOT = "rime_sync_snapshot_file";
    private static final String KEY_NOW = "rime_sync_now";
    private static final String KEY_RESET = "rime_sync_reset";

    private static final Map<PreferenceFragment, Controller> CONTROLLERS =
            new WeakHashMap<PreferenceFragment, Controller>();

    private RimeSyncLegacySettingsCompat() {}

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

    /** The directory picker result belongs to this controller. */
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
        if (controller != null) controller.reload();
    }

    public static void unbind(PreferenceFragment fragment) {
        synchronized (CONTROLLERS) {
            Controller controller = CONTROLLERS.remove(fragment);
            if (controller != null) controller.destroy();
        }
    }

    private static String text(Context context, String name, Object... arguments) {
        int identifier = context.getResources().getIdentifier(name, "string",
                context.getPackageName());
        if (identifier == 0) return name;
        if (arguments.length == 0) return context.getString(identifier);
        return context.getString(identifier, arguments);
    }

    private static void toast(Context context, String name) {
        if (context == null) return;
        Toast.makeText(context, text(context, name), Toast.LENGTH_SHORT).show();
    }

    private static String errorName(int errorCode) {
        switch (errorCode) {
            case RimeSyncSettingsCompat.ERROR_CONFIGURATION_REQUIRED:
                return "rime_sync_error_configuration";
            case RimeSyncSettingsCompat.ERROR_LOCATION_UNAVAILABLE:
                return "rime_sync_error_location";
            case RimeSyncSettingsCompat.ERROR_OPERATION_IN_PROGRESS:
                return "rime_sync_error_in_progress";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_CHANGED:
                return "rime_sync_error_preview_changed";
            case RimeSyncSettingsCompat.ERROR_DELETION_CONFIRMATION_REQUIRED:
                return "rime_sync_error_confirmation";
            case RimeSyncSettingsCompat.ERROR_CAPACITY_EXCEEDED:
                return "rime_sync_error_capacity";
            case RimeSyncSettingsCompat.ERROR_NATIVE_PERSISTENCE:
                return "rime_sync_error_native_persistence";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SOURCE_LIST:
                return "rime_sync_error_source_list";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SOURCE_OPEN:
                return "rime_sync_error_source_open";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SOURCE_PARSE:
                return "rime_sync_error_source_parse";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SOURCE_DATABASE:
                return "rime_sync_error_source_database";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SOURCE_CLOSE:
                return "rime_sync_error_source_close";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_RIME_MERGE:
                return "rime_sync_error_rime_merge";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_GOOGLE_EXPORT:
                return "rime_sync_error_google_export";
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SESSION_PLAN:
                return "rime_sync_error_session_plan";
            case RimeSyncSettingsCompat.ERROR_DIRECTORY_IDENTITY:
                return "rime_sync_error_directory_identity";
            case RimeSyncSettingsCompat.ERROR_BRIDGE_SNAPSHOT_MISSING:
                return "rime_sync_error_bridge_missing";
            default:
                return "rime_sync_error_failed";
        }
    }

    /** A snapshot file is validated by the same constructor the synchronization path uses. */
    private static boolean isValidSnapshot(String value) {
        try {
            new RimeSyncConfiguration(PROBE_DEVICE_NAME, value);
            return true;
        } catch (IllegalArgumentException failure) {
            return false;
        }
    }

    private static String describeRoot(Context context, Uri uri) {
        String authority = uri.getAuthority();
        if (EXTERNAL_STORAGE_AUTHORITY.equals(authority)) {
            try {
                String id = DocumentsContract.getTreeDocumentId(uri);
                int separator = id.indexOf(':');
                String volume = separator < 0 ? id : id.substring(0, separator);
                String path = separator < 0 ? "" : id.substring(separator + 1);
                String root = "primary".equalsIgnoreCase(volume)
                        ? text(context, "rime_sync_root_internal")
                        : text(context, "rime_sync_root_removable", volume);
                return path.length() == 0 ? root : root + "/" + path;
            } catch (RuntimeException ignored) {
            }
        }
        try {
            ProviderInfo provider = context.getPackageManager()
                    .resolveContentProvider(authority == null ? "" : authority, 0);
            if (provider != null) {
                CharSequence label = provider.loadLabel(context.getPackageManager());
                if (label != null && label.length() > 0) return label.toString();
            }
        } catch (RuntimeException ignored) {
        }
        return text(context, "rime_sync_root_selected");
    }

    private static final class Controller implements Preference.OnPreferenceClickListener,
            Preference.OnPreferenceChangeListener, RimeSyncSettingsCompat.StateListener {
        private PreferenceFragment fragment;
        private Preference statusPreference;
        private TwoStatePreference automaticPreference;
        private ListPreference intervalPreference;
        private Preference rootPreference;
        private Preference devicePreference;
        private Preference snapshotPreference;
        private Preference synchronizePreference;
        private Preference resetPreference;
        private RimeSyncSettingsCompat.Settings latest;
        private int statusGeneration;
        private boolean picking;
        private boolean editing;
        private int[] populatedOptions;
        private boolean applyingInterval;

        Controller(PreferenceFragment fragment) { this.fragment = fragment; }

        void bind() {
            statusPreference = fragment.findPreference(KEY_STATUS);
            // The Material You decorator rewrites CheckBoxPreference into SwitchPreference on
            // API 35+, so bind through the shared parent instead of the declared XML class.
            automaticPreference = (TwoStatePreference) fragment.findPreference(KEY_AUTO_ENABLED);
            intervalPreference = (ListPreference) fragment.findPreference(KEY_AUTO_INTERVAL);
            rootPreference = fragment.findPreference(KEY_ROOT);
            devicePreference = fragment.findPreference(KEY_DEVICE);
            snapshotPreference = fragment.findPreference(KEY_SNAPSHOT);
            synchronizePreference = fragment.findPreference(KEY_NOW);
            resetPreference = fragment.findPreference(KEY_RESET);

            if (statusPreference != null) statusPreference.setOnPreferenceClickListener(this);
            if (rootPreference != null) rootPreference.setOnPreferenceClickListener(this);
            if (devicePreference != null) devicePreference.setOnPreferenceClickListener(this);
            if (snapshotPreference != null) snapshotPreference.setOnPreferenceClickListener(this);
            if (synchronizePreference != null) {
                synchronizePreference.setOnPreferenceClickListener(this);
            }
            // Both entries change scheduling rather than a stored value, so the controller
            // answers each change and writes through the facade itself.
            if (automaticPreference != null) {
                automaticPreference.setOnPreferenceChangeListener(this);
            }
            if (intervalPreference != null) {
                intervalPreference.setOnPreferenceChangeListener(this);
            }

            RimeSyncSettingsCompat.addStateListener(this);
            reload();
        }

        void destroy() {
            statusGeneration++;
            picking = false;
            editing = false;
            applyingInterval = false;
            populatedOptions = null;
            RimeSyncSettingsCompat.removeStateListener(this);
            fragment = null;
            statusPreference = null;
            automaticPreference = null;
            intervalPreference = null;
            rootPreference = null;
            devicePreference = null;
            snapshotPreference = null;
            synchronizePreference = null;
            resetPreference = null;
            latest = null;
        }

        private Context context() {
            return fragment == null || fragment.getActivity() == null ? null
                    : fragment.getActivity().getApplicationContext();
        }

        @Override public boolean onPreferenceClick(Preference preference) {
            if (preference == statusPreference) {
                reload();
            } else if (preference == rootPreference) {
                openTreePicker();
            } else if (preference == devicePreference) {
                showEditDialog(true);
            } else if (preference == snapshotPreference) {
                showEditDialog(false);
            } else if (preference == synchronizePreference) {
                requestSynchronization();
            }
            return true;
        }

        @Override public boolean onPreferenceChange(Preference preference, Object value) {
            RimeSyncSettingsCompat.Settings settings = latest;
            if (settings == null) return false;
            if (preference == automaticPreference) {
                if (!Boolean.TRUE.equals(value)) {
                    configureAutomatic(false, settings.automatic.intervalHours);
                    return true;
                }
                if (!settings.canEnableAutomatic) {
                    toast(context(), "rime_sync_auto_prerequisite");
                    return false;
                }
                // Enabling keeps the switch in place until the consent dialog is answered.
                showAutomaticConsentDialog(settings.automatic.intervalHours);
                return false;
            }
            if (preference == intervalPreference) {
                if (applyingInterval) return true;
                int hours;
                try {
                    hours = Integer.parseInt(String.valueOf(value));
                } catch (NumberFormatException failure) {
                    return false;
                }
                if (hours == settings.automatic.intervalHours) return true;
                configureAutomatic(settings.automatic.enabled, hours);
                return true;
            }
            return true;
        }

        @Override public void onChanged(boolean busy) {
            if (fragment != null) reload();
        }

        void reload() {
            final Context context = context();
            if (context == null) return;
            final int generation = ++statusGeneration;
            RimeSyncSettingsCompat.readAsync(context, new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    if (generation != statusGeneration || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    applyState();
                }
            });
        }

        private void openTreePicker() {
            if (fragment == null || fragment.getActivity() == null || picking || editing) return;
            picking = true;
            Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
            if (Build.VERSION.SDK_INT >= 26) {
                intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, initialTree());
            }
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
            try {
                fragment.startActivityForResult(intent, REQUEST_TREE);
            } catch (RuntimeException failure) {
                picking = false;
                toast(context(), "rime_sync_picker_unavailable");
            }
        }

        private Uri initialTree() {
            String configured = latest == null ? "" : latest.rootUri;
            if (configured.length() > 0) {
                try {
                    Uri tree = Uri.parse(configured);
                    return DocumentsContract.buildDocumentUriUsingTree(tree,
                            DocumentsContract.getTreeDocumentId(tree));
                } catch (RuntimeException ignored) {
                }
            }
            return DocumentsContract.buildDocumentUri(EXTERNAL_STORAGE_AUTHORITY,
                    DOCUMENTS_FALLBACK);
        }

        void onTreeResult(int resultCode, Intent data) {
            picking = false;
            final Context context = context();
            if (context == null || fragment == null) return;
            if (resultCode != Activity.RESULT_OK || data == null || data.getData() == null) {
                reload();
                return;
            }
            Uri tree = data.getData();
            int granted = data.getFlags() & (Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            if (granted != (Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION)) {
                toast(context, "rime_sync_error_location");
                reload();
                return;
            }
            try {
                context.getContentResolver().takePersistableUriPermission(tree, granted);
            } catch (RuntimeException failure) {
                toast(context, "rime_sync_error_location");
                reload();
                return;
            }
            final String previous = latest == null ? "" : latest.rootUri;
            final String selected = tree.toString();
            final String label = describeRoot(context, tree);
            RimeSyncSettingsCompat.acceptRootAsync(context, tree, label,
                    new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    Context current = context();
                    if (current == null || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    if (result.success) {
                        releaseRoot(current, previous, selected);
                        toast(current, "rime_sync_root_saved");
                    } else {
                        releaseRoot(current, selected, previous);
                        toast(current, errorName(result.errorCode));
                    }
                    applyState();
                }
            });
        }

        /** Keeping the permission of the directory that is still configured. */
        private void releaseRoot(Context context, String uri, String keep) {
            if (uri == null || uri.length() == 0 || uri.equals(keep)) return;
            try {
                context.getContentResolver().releasePersistableUriPermission(Uri.parse(uri),
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                                | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            } catch (RuntimeException ignored) {
            }
        }

        private void showEditDialog(final boolean deviceName) {
            if (fragment == null || fragment.getActivity() == null || picking || editing) return;
            final Activity activity = fragment.getActivity();
            final RimeSyncSettingsCompat.Settings settings = latest;
            if (settings == null) return;
            final EditText input = new EditText(activity);
            input.setSingleLine(true);
            input.setText(deviceName ? settings.deviceDirectory : settings.snapshotFile);
            input.setSelection(input.getText().length());
            final AlertDialog dialog = new AlertDialog.Builder(activity)
                    .setTitle(text(activity, deviceName ? "rime_sync_device_title"
                            : "rime_sync_snapshot_title"))
                    .setView(input)
                    .setPositiveButton(android.R.string.ok, null)
                    .setNegativeButton(android.R.string.cancel, null)
                    .create();
            dialog.setOnShowListener(new DialogInterface.OnShowListener() {
                @Override public void onShow(DialogInterface source) {
                    Button confirm = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
                    if (confirm == null) return;
                    confirm.setOnClickListener(new View.OnClickListener() {
                        @Override public void onClick(View view) {
                            String value = input.getText().toString();
                            if (deviceName && !RimeSyncConfiguration.isValidDeviceName(value)) {
                                toast(context(), "rime_sync_device_invalid");
                                return;
                            }
                            if (!deviceName && !isValidSnapshot(value)) {
                                toast(context(), "rime_sync_snapshot_invalid");
                                return;
                            }
                            dialog.dismiss();
                            saveConfiguration(deviceName ? value : null,
                                    deviceName ? null : value);
                        }
                    });
                }
            });
            dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                @Override public void onDismiss(DialogInterface source) { editing = false; }
            });
            editing = true;
            dialog.show();
        }

        private void saveConfiguration(String deviceName, String snapshotFile) {
            final Context context = context();
            RimeSyncSettingsCompat.Settings settings = latest;
            if (context == null || settings == null) return;
            String device = deviceName != null ? deviceName : settings.deviceDirectory;
            String snapshot = snapshotFile != null ? snapshotFile : settings.snapshotFile;
            RimeSyncSettingsCompat.saveConfigurationAsync(context, device, snapshot,
                    new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    Context current = context();
                    if (current == null || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    if (!result.success) toast(current, errorName(result.errorCode));
                    applyState();
                }
            });
        }

        /**
         * Manual synchronization keeps the two gates the modern page uses. The compatibility
         * rule is accepted once, and a plan that deletes entries is approved before it runs.
         */
        private void requestSynchronization() {
            RimeSyncSettingsCompat.Settings settings = latest;
            if (fragment == null || settings == null || settings.operationInProgress) return;
            if (!settings.compatibilityAccepted) {
                showKeepRejectedDialog();
                return;
            }
            synchronize();
        }

        private void synchronize() {
            final Context context = context();
            if (context == null) return;
            RimeSyncSettingsCompat.synchronizeAsync(context,
                    new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    Context current = context();
                    if (current == null || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    if (!result.success) {
                        // The rule can also be missing when the stored answer was cleared.
                        if (result.errorCode
                                == RimeSyncSettingsCompat.ERROR_COMPATIBILITY_CONSENT) {
                            showKeepRejectedDialog();
                            return;
                        }
                        toast(current, errorName(result.errorCode));
                        applyState();
                        return;
                    }
                    if (result.preview) {
                        applyState();
                        showPreviewDialog(result);
                        return;
                    }
                    toast(current, "rime_sync_success");
                    applyState();
                }
            });
        }

        private void showKeepRejectedDialog() {
            if (fragment == null || fragment.getActivity() == null || editing) return;
            final Activity activity = fragment.getActivity();
            editing = true;
            new AlertDialog.Builder(activity)
                    .setTitle(text(activity, "rime_sync_keep_rejected_title"))
                    .setMessage(text(activity, "rime_sync_keep_rejected_message"))
                    .setPositiveButton(text(activity, "rime_sync_keep_rejected_action"),
                            new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            // Dismissing first releases the dialog guard, because accepting the
                            // rule starts a synchronization that can ask for a preview at once.
                            dialog.dismiss();
                            acceptCompatibility();
                        }
                    })
                    .setNegativeButton(android.R.string.cancel, null)
                    .setOnDismissListener(new DialogInterface.OnDismissListener() {
                        @Override public void onDismiss(DialogInterface dialog) {
                            editing = false;
                            applyState();
                        }
                    })
                    .show();
        }

        private void acceptCompatibility() {
            final Context context = context();
            if (context == null) return;
            RimeSyncSettingsCompat.acceptCompatibilityAsync(context,
                    new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    Context current = context();
                    if (current == null || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    if (!result.success) {
                        toast(current, errorName(result.errorCode));
                        applyState();
                        return;
                    }
                    synchronize();
                }
            });
        }

        /** Deletions are shown as counts, because the plan itself belongs to the engine. */
        private void showPreviewDialog(final RimeSyncSettingsCompat.Result preview) {
            if (fragment == null || fragment.getActivity() == null) return;
            final Activity activity = fragment.getActivity();
            editing = true;
            new AlertDialog.Builder(activity)
                    .setTitle(text(activity, "rime_sync_preview_title"))
                    .setMessage(text(activity, "rime_sync_preview_message",
                            preview.googleAdditionCount, preview.googleDeletionCount,
                            preview.rimeAdditionCount, preview.rimeDeletionCount,
                            preview.rimeResurrectionCount))
                    .setPositiveButton(text(activity, preview.requiresDeletionConfirmation
                                    ? "rime_sync_confirm_deletions" : "rime_sync_confirm"),
                            new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                            execute(preview.confirmationToken,
                                    preview.requiresDeletionConfirmation);
                        }
                    })
                    .setNegativeButton(android.R.string.cancel, null)
                    .setOnDismissListener(new DialogInterface.OnDismissListener() {
                        @Override public void onDismiss(DialogInterface dialog) {
                            editing = false;
                            applyState();
                        }
                    })
                    .show();
        }

        private void execute(String confirmationToken, boolean deletionConfirmed) {
            final Context context = context();
            if (context == null) return;
            RimeSyncSettingsCompat.executeAsync(context, confirmationToken, deletionConfirmed,
                    new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    Context current = context();
                    if (current == null || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    if (result.success) {
                        toast(current, "rime_sync_success");
                    } else {
                        toast(current, errorName(result.errorCode));
                    }
                    applyState();
                }
            });
        }

        /** Enabling scheduling changes what runs in the background, so it asks first. */
        private void showAutomaticConsentDialog(final int hours) {
            if (fragment == null || fragment.getActivity() == null || editing) return;
            final Activity activity = fragment.getActivity();
            editing = true;
            new AlertDialog.Builder(activity)
                    .setTitle(text(activity, "rime_sync_auto_title"))
                    .setMessage(text(activity, "rime_sync_auto_consent"))
                    .setPositiveButton(text(activity, "rime_sync_auto_enable"),
                            new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            configureAutomatic(true, hours);
                        }
                    })
                    .setNegativeButton(android.R.string.cancel, null)
                    .setOnDismissListener(new DialogInterface.OnDismissListener() {
                        @Override public void onDismiss(DialogInterface dialog) {
                            editing = false;
                            applyState();
                        }
                    })
                    .show();
        }

        private void configureAutomatic(boolean enabled, int hours) {
            final Context context = context();
            if (context == null) return;
            RimeSyncSettingsCompat.configureAutomaticAsync(context, enabled, hours,
                    new RimeSyncSettingsCompat.Callback() {
                @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                    Context current = context();
                    if (current == null || fragment == null) return;
                    if (result.settings != null) latest = result.settings;
                    if (!result.success) toast(current, errorName(result.errorCode));
                    applyState();
                }
            });
        }

        /**
         * Builds the interval list from the engine contract. An interval stored by the earlier
         * slider stays selectable as an extra option, which the static XML default cannot express.
         */
        private void populateIntervalOptions(Context context, RimeAutoSync.Settings automatic) {
            if (context == null || intervalPreference == null) return;
            int[] options = automatic.intervalOptions;
            if (populatedOptions != null && java.util.Arrays.equals(populatedOptions, options)) {
                return;
            }
            CharSequence[] entries = new CharSequence[options.length];
            CharSequence[] values = new CharSequence[options.length];
            for (int index = 0; index < options.length; index++) {
                entries[index] = intervalLabel(context, options[index]);
                values[index] = String.valueOf(options[index]);
            }
            intervalPreference.setEntries(entries);
            intervalPreference.setEntryValues(values);
            populatedOptions = options.clone();
        }

        private String intervalLabel(Context context, int hours) {
            if (hours > 24 && hours % 24 == 0) {
                return text(context, "rime_sync_auto_days", hours / 24);
            }
            return text(context, "rime_sync_auto_hours", hours);
        }

        void applyState() {
            Context context = context();
            RimeSyncSettingsCompat.Settings settings = latest;
            if (context == null || settings == null) return;
            RimeAutoSync.Settings automatic = settings.automatic;
            boolean busy = settings.operationInProgress;
            boolean complete = settings.rootUri.length() > 0
                    && settings.deviceDirectory.length() > 0
                    && settings.snapshotFile.length() > 0;
            boolean recovery = settings.phase != RimeSyncStateStore.PHASE_IDLE;

            if (statusPreference != null) {
                String summary = statusText(context, settings, complete, recovery);
                if (settings.lastSuccess > 0L && settings.counts != null) {
                    summary = summary + "\n" + text(context, "rime_sync_status_counts",
                            settings.counts.shared, settings.counts.rimeOnly);
                }
                statusPreference.setSummary(summary);
                statusPreference.setEnabled(true);
            }
            if (automaticPreference != null && automatic != null) {
                automaticPreference.setChecked(automatic.enabled);
                automaticPreference.setSummary(automaticText(context, settings));
                automaticPreference.setEnabled(automatic.enabled
                        || (settings.canEnableAutomatic && !busy));
            }
            if (intervalPreference != null && automatic != null) {
                populateIntervalOptions(context, automatic);
                String value = String.valueOf(automatic.intervalHours);
                if (!value.equals(intervalPreference.getValue())) {
                    applyingInterval = true;
                    intervalPreference.setValue(value);
                    applyingInterval = false;
                }
                intervalPreference.setSummary(intervalLabel(context, automatic.intervalHours));
                intervalPreference.setEnabled(automatic.enabled && !busy);
            }
            if (rootPreference != null) {
                rootPreference.setSummary(rootText(context, settings));
                rootPreference.setEnabled(!busy && !recovery);
            }
            if (devicePreference != null) {
                devicePreference.setSummary(settings.deviceDirectory.length() == 0
                        ? text(context, "rime_sync_device_unset") : settings.deviceDirectory);
                devicePreference.setEnabled(!busy && !recovery);
            }
            if (snapshotPreference != null) {
                snapshotPreference.setSummary(settings.snapshotFile);
                snapshotPreference.setEnabled(!busy && !recovery);
            }
            if (synchronizePreference != null) {
                synchronizePreference.setEnabled(complete && settings.locationAccessible && !busy);
            }
            if (resetPreference != null) {
                resetPreference.setEnabled(complete && !busy && !recovery);
            }
        }

        private String rootText(Context context, RimeSyncSettingsCompat.Settings settings) {
            if (settings.rootUri.length() == 0) return text(context, "rime_sync_root_unset");
            if (!settings.locationAccessible) {
                return text(context, "rime_sync_root_inaccessible");
            }
            if (settings.rootLabel.length() > 0) return settings.rootLabel;
            return text(context, "rime_sync_root_selected");
        }

        private String statusText(Context context, RimeSyncSettingsCompat.Settings settings,
                boolean complete, boolean recovery) {
            if (settings.operationInProgress) return text(context, "rime_sync_status_in_progress");
            if (!complete) return text(context, "rime_sync_status_unconfigured");
            if (!settings.locationAccessible) return text(context, "rime_sync_status_location");
            if (settings.nativeFailureKind != RimeSyncSettingsCompat.NATIVE_FAILURE_NONE) {
                return text(context, "rime_sync_status_paused");
            }
            if (settings.automatic.lastError != 0) {
                return text(context, settings.automatic.enabled
                        ? "rime_sync_status_auto_retry" : "rime_sync_status_auto_paused");
            }
            if (recovery) return text(context, "rime_sync_status_unfinished");
            if (settings.lastSuccess > 0L) {
                return lastSuccessText(context, settings.lastSuccess);
            }
            return text(context, "rime_sync_status_not_run");
        }

        private String automaticText(Context context, RimeSyncSettingsCompat.Settings settings) {
            RimeAutoSync.Settings automatic = settings.automatic;
            if (settings.operationInProgress) return text(context, "rime_sync_status_in_progress");
            if (automatic.lastError != 0 && !automatic.enabled) {
                return text(context, "rime_sync_status_auto_paused");
            }
            if (automatic.lastError != 0) return text(context, "rime_sync_status_auto_retry");
            if (!settings.canEnableAutomatic) {
                return text(context, "rime_sync_auto_prerequisite");
            }
            if (automatic.enabled && settings.lastSuccess > 0L) {
                return lastSuccessText(context, settings.lastSuccess);
            }
            return text(context, "rime_sync_auto_summary");
        }

        private String lastSuccessText(Context context, long timestamp) {
            return text(context, "rime_sync_status_last_success",
                    DateFormat.getDateFormat(context).format(timestamp),
                    DateFormat.getTimeFormat(context).format(timestamp));
        }
    }
}
