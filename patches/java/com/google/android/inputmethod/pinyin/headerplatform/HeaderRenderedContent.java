package com.google.android.inputmethod.pinyin.headerplatform;

import android.view.View;

/** One renderer-owned View tree and its explicit cleanup contract. */
public interface HeaderRenderedContent {
    View getView();
    void release();
}
