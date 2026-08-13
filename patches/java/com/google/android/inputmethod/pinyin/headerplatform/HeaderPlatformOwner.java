package com.google.android.inputmethod.pinyin.headerplatform;

/** Implemented by the IME service so Header Views bind without process-global registries. */
public interface HeaderPlatformOwner {
    HeaderPlatformController getHeaderPlatformController();
}
