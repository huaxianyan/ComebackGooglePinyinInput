package com.google.android.inputmethod.pinyin.headerplatform;

/** Optional module extension for distinguishing Clipboard-only native Candidate state. */
public interface HeaderNativeCandidateStateAware {
    void onNativeCandidateStateChanged(boolean active, boolean clipboardOnly);
}
