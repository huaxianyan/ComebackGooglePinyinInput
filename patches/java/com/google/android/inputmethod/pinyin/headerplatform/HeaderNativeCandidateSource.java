package com.google.android.inputmethod.pinyin.headerplatform;

/** Explicit native-holder seam; replaces module-specific InputBundle static hooks. */
public interface HeaderNativeCandidateSource {
    void setHeaderNativeCandidateStateListener(HeaderNativeCandidateStateListener listener);
}
