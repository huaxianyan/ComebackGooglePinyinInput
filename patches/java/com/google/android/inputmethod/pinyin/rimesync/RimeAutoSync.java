package com.google.android.inputmethod.pinyin.rimesync;

import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;

/** Owns automatic scheduling and consent; dictionary work remains in the existing facade. */
public final class RimeAutoSync {
    private static final String PREFERENCES = "rime_auto_sync_preferences";
    private static final String ENABLED = "enabled";
    private static final String INTERVAL = "interval_hours";
    private static final String LAST_ERROR = "last_error";
    public static final int JOB_ID = 0x52494d45;

    private RimeAutoSync() {}

    private static SharedPreferences preferences(Context context) {
        return context.getApplicationContext().getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE);
    }

    public static final class Settings {
        public final boolean enabled;
        public final int intervalHours;
        public final int[] intervalOptions;
        public final int lastError;

        Settings(boolean enabled, int intervalHours, int lastError) {
            this.enabled = enabled;
            this.intervalHours = intervalHours;
            this.intervalOptions = RimeAutoSyncPolicy.intervalOptions(intervalHours);
            this.lastError = lastError;
        }
    }

    public static Settings read(Context context) {
        SharedPreferences p = preferences(context);
        return new Settings(p.getBoolean(ENABLED, false),
                p.getInt(INTERVAL, RimeAutoSyncPolicy.DEFAULT_HOURS), p.getInt(LAST_ERROR, 0));
    }

    /** Enabling is validated by the facade; disabling can cancel while dictionary I/O runs. */
    static boolean configure(Context context, boolean enabled, int hours) {
        RimeAutoSyncPolicy.intervalMillis(hours);
        preferences(context).edit().putInt(INTERVAL, hours).putBoolean(ENABLED, enabled)
                .putInt(LAST_ERROR, 0).apply();
        boolean scheduled = reconcile(context);
        RimeSyncSettingsCompat.notifyStateChanged();
        return scheduled;
    }

    public static boolean reconcile(Context context) {
        if (Build.VERSION.SDK_INT < 21) return false;
        Settings settings = read(context);
        JobScheduler scheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);
        if (!settings.enabled) {
            scheduler.cancel(JOB_ID);
            return true;
        }
        long interval = RimeAutoSyncPolicy.intervalMillis(settings.intervalHours);
        ComponentName component = new ComponentName(context, RimeAutoSyncJobService.class);
        for (JobInfo existing : scheduler.getAllPendingJobs()) {
            if (existing.getId() == JOB_ID && existing.getIntervalMillis() == interval
                    && component.equals(existing.getService())) return true;
        }
        JobInfo job = new JobInfo.Builder(JOB_ID, component).setPersisted(true)
                .setPeriodic(interval)
                .setBackoffCriteria(RimeAutoSyncPolicy.RETRY_BASE_MILLIS,
                        JobInfo.BACKOFF_POLICY_EXPONENTIAL)
                .build();
        if (scheduler.schedule(job) != JobScheduler.RESULT_SUCCESS) {
            preferences(context).edit().putBoolean(ENABLED, false)
                    .putInt(LAST_ERROR, RimeSyncSettingsCompat.ERROR_OPERATION_FAILED).apply();
            RimeSyncSettingsCompat.notifyStateChanged();
            return false;
        }
        return true;
    }

    /** Returns true only for a framework-managed, delayed retry, never a local retry loop. */
    static boolean completed(Context context, RimeSyncSettingsCompat.Result result) {
        if (!read(context).enabled) return false;
        boolean pause = requiresAttention(result);
        SharedPreferences.Editor editor = preferences(context).edit()
                .putInt(LAST_ERROR, result.errorCode);
        if (pause) editor.putBoolean(ENABLED, false);
        editor.apply();
        if (pause) reconcile(context);
        RimeSyncSettingsCompat.notifyStateChanged();
        return !result.success && !pause;
    }

    static boolean requiresAttention(RimeSyncSettingsCompat.Result result) {
        switch (result.errorCode) {
            case RimeSyncSettingsCompat.ERROR_CONFIGURATION_REQUIRED:
            case RimeSyncSettingsCompat.ERROR_DELETION_CONFIRMATION_REQUIRED:
            case RimeSyncSettingsCompat.ERROR_NATIVE_PERSISTENCE:
            case RimeSyncSettingsCompat.ERROR_PREVIEW_SOURCE_DATABASE:
                return true;
            case RimeSyncSettingsCompat.ERROR_LOCATION_UNAVAILABLE:
                return !result.settings.locationAccessible;
            default:
                return false;
        }
    }
}
