package com.google.android.inputmethod.pinyin.rimesync;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/** Reconciles only this module's persisted job after boot or an in-place APK update. */
public final class RimeAutoSyncReceiver extends BroadcastReceiver {
    @Override public void onReceive(Context context, Intent intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())
                || Intent.ACTION_MY_PACKAGE_REPLACED.equals(intent.getAction())) {
            RimeAutoSync.reconcile(context);
        }
    }
}
