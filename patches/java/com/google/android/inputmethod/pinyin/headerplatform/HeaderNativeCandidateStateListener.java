package com.google.android.inputmethod.pinyin.headerplatform;

/** Platform callback emitted by the native holder after its displayed count changes. */
public interface HeaderNativeCandidateStateListener {
    void onNativeCandidateStateChanged(boolean active, boolean clipboardOnly);
}
