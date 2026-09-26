package com.google.android.inputmethod.pinyin.rimesync;

import android.content.Context;
import android.content.Intent;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.preference.TwoStatePreference;
import android.text.format.DateFormat;

import java.util.Map;
import java.util.WeakHashMap;

/**
 * Bridges the legacy dictionary page to the same manual synchronization boundary the modern
 * settings page calls. This block binds the page and displays real state; editing configuration
 * and running synchronization follow in later blocks.
 *
 * <p>Legacy callers cannot reference the host R class, so resource names are resolved through
 * {@link android.content.res.Resources#getIdentifier}. Missing strings degrade to the resource
 * name instead of crashing the page.
 */
public final class RimeSyncLegacySettingsCompat {
    private static final int REQUEST_TREE = 0x6b02;

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

    /** The directory picker result belongs to this controller; it starts being used in the next block. */
    public static boolean handleActivityResult(PreferenceFragment fragment, int requestCode,
            int resultCode, Intent data) {
        return requestCode == REQUEST_TREE;
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

    private static final class Controller implements Preference.OnPreferenceClickListener,
            RimeSyncSettingsCompat.StateListener {
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

            RimeSyncSettingsCompat.addStateListener(this);
            reload();
        }

        void destroy() {
            statusGeneration++;
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
            if (preference == statusPreference) reload();
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
            if (intervalPreference != null) {
                intervalPreference.setEnabled(automatic != null && automatic.enabled && !busy);
            }
            if (rootPreference != null) rootPreference.setEnabled(!busy && !recovery);
            if (devicePreference != null) devicePreference.setEnabled(!busy && !recovery);
            if (snapshotPreference != null) snapshotPreference.setEnabled(!busy && !recovery);
            if (synchronizePreference != null) {
                synchronizePreference.setEnabled(complete && settings.locationAccessible && !busy);
            }
            if (resetPreference != null) {
                resetPreference.setEnabled(complete && !busy && !recovery);
            }
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
