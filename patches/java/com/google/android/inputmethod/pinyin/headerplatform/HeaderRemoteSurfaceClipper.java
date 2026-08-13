package com.google.android.inputmethod.pinyin.headerplatform;

import android.graphics.Rect;
import android.view.View;

/** API-neutral callback; only the guarded API 30 bridge performs platform clipping. */
public interface HeaderRemoteSurfaceClipper {
    void applyClip(View view, Rect bounds);
}
