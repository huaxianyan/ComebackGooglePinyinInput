package com.google.android.inputmethod.pinyin.rimesync;

/** User-facing interval contract, independent of Android scheduling. */
public final class RimeAutoSyncPolicy {
    private static final int[] INTERVAL_HOURS = {6, 12, 24, 48, 72, 168};
    public static final int DEFAULT_HOURS = INTERVAL_HOURS[2];
    public static final int MIN_HOURS = INTERVAL_HOURS[0];
    public static final int MAX_HOURS = INTERVAL_HOURS[INTERVAL_HOURS.length - 1];
    public static final long RETRY_BASE_MILLIS = 30L * 60L * 1000L;

    private RimeAutoSyncPolicy() {}

    /** Preserve intervals actually stored by the earlier slider until the user selects another. */
    public static int[] intervalOptions(int currentHours) {
        intervalMillis(currentHours);
        for (int hours : INTERVAL_HOURS) {
            if (hours == currentHours) return INTERVAL_HOURS.clone();
        }
        int[] options = java.util.Arrays.copyOf(INTERVAL_HOURS, INTERVAL_HOURS.length + 1);
        options[INTERVAL_HOURS.length] = currentHours;
        java.util.Arrays.sort(options);
        return options;
    }

    public static long intervalMillis(int hours) {
        if (hours < MIN_HOURS || hours > MAX_HOURS) {
            throw new IllegalArgumentException("automatic synchronization interval out of range");
        }
        return hours * 60L * 60L * 1000L;
    }
}
