package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;

/** Platform-owned renderer for one semantic presentation family. */
public interface HeaderRenderer {
    HeaderPresentationKind getPresentationKind();
    HeaderRenderedContent prepare(Context context, HeaderContribution contribution,
            HeaderChromeFactory chromeFactory);
}
