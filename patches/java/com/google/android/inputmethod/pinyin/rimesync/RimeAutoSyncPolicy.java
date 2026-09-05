package com.google.android.inputmethod.pinyin.rimesync;

/** User-facing interval contract, independent of Android scheduling. */
public final class RimeAutoSyncPolicy {
    public static final int DEFAULT_HOURS = 24;
    public static final int MIN_HOURS = 6;
    public static final int MAX_HOURS = 7 * 24;
    public static final long RETRY_BASE_MILLIS = 30L * 60L * 1000L;

    private RimeAutoSyncPolicy() {}

    public static long intervalMillis(int hours) {
        if (hours < MIN_HOURS || hours > MAX_HOURS) {
            throw new IllegalArgumentException("automatic synchronization interval out of range");
        }
        return hours * 60L * 60L * 1000L;
    }
}
