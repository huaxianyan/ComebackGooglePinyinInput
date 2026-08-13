package com.google.android.inputmethod.pinyin.headerplatform;

/**
 * Renderer-only native chrome seam. This interface is never exposed through
 * HeaderPlatformContext, so modules cannot obtain or manipulate Header Views.
 */
public interface HeaderChromeFactory {
    HeaderVisualSlot createCandidateChromeSlot();
    HeaderNativeChromeSnapshot captureNativeChrome();
    HeaderActionSlot createActionChromeSlot(HeaderActionKind kind);
}
