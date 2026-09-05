package com.google.android.inputmethod.pinyin.rimesync;

import android.app.job.JobParameters;
import android.app.job.JobService;

/** API-21+ system entry. No Activity, network check, or independent synchronization worker. */
public final class RimeAutoSyncJobService extends JobService {
    private JobParameters active;

    @Override public boolean onStartJob(final JobParameters parameters) {
        if (!RimeAutoSync.read(this).enabled) return false;
        active = parameters;
        RimeSyncSettingsCompat.runAutomaticAsync(this, new RimeSyncSettingsCompat.Callback() {
            @Override public void onFinished(RimeSyncSettingsCompat.Result result) {
                boolean retry = RimeAutoSync.completed(RimeAutoSyncJobService.this, result);
                if (active == parameters) {
                    active = null;
                    jobFinished(parameters, retry);
                }
            }
        });
        return true;
    }

    @Override public boolean onStopJob(JobParameters parameters) {
        if (active == parameters) active = null;
        // Do not interrupt a native persist. Journaled work may finish or be recovered later.
        return RimeAutoSync.read(this).enabled;
    }
}
