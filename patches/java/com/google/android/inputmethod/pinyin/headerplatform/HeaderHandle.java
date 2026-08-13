package com.google.android.inputmethod.pinyin.headerplatform;

/** Opaque identity for one attached Header host; it deliberately exposes no View. */
public final class HeaderHandle {
    private final long token;

    HeaderHandle(long token) {
        if (token <= 0L) throw new IllegalArgumentException("token must be positive");
        this.token = token;
    }

    public long getToken() { return token; }
}
