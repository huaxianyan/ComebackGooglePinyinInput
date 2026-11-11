package com.google.android.inputmethod.pinyin.dictsafety;

/**
 * The single definition of "healthy" used by every part of the safety net.
 *
 * <p>Nothing here is an absolute count taken from one device. The baseline is the largest entry
 * count this installation has ever read, so a user with 400 words and a user with 100,000 words
 * are judged by the same rule: a dictionary does not lose half of itself without someone asking.
 *
 * <p>Snapshot admission, snapshot rotation and post-restore verification all call
 * {@link #isCollapsed(int, int)} so the three never drift apart.
 */
public final class DictionarySafetyPolicy {

    private DictionarySafetyPolicy() {}

    /** True when the engine reads less than half of what this installation has seen before. */
    public static boolean isCollapsed(int currentCount, int knownCount) {
        if (currentCount < 0) return false;
        if (knownCount <= 0) return false;
        return (long) currentCount * 2L < (long) knownCount;
    }

    /** Highest entry count this installation has read so far. */
    public static int nextKnownCount(int knownCount, int currentCount) {
        return Math.max(knownCount, Math.max(currentCount, 0));
    }

    /** A snapshot may enter rotation only if it would not itself raise the alarm. */
    public static boolean acceptsSnapshot(int snapshotCount, int knownCount) {
        if (snapshotCount <= 0) return false;
        if (knownCount <= 0) return true;
        return !isCollapsed(snapshotCount, knownCount);
    }

    /** A snapshot may be used for repair only if importing it could clear the alarm. */
    public static boolean canRepairWith(int snapshotCount, int knownCount) {
        return acceptsSnapshot(snapshotCount, knownCount);
    }
}
