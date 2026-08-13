package com.google.android.inputmethod.pinyin.headerplatform;

/** Owns monotonically increasing input-session identities used to reject late publications. */
public final class HeaderSessionController {
    private long generation;
    private long activeToken;

    public synchronized long startSession() {
        generation++;
        if (generation <= 0L) generation = 1L;
        activeToken = generation;
        return activeToken;
    }

    public synchronized void invalidate() {
        activeToken = 0L;
        generation++;
        if (generation <= 0L) generation = 1L;
    }

    public synchronized long getActiveToken() { return activeToken; }
    public synchronized boolean isActive(long token) {
        return token > 0L && token == activeToken;
    }
}
