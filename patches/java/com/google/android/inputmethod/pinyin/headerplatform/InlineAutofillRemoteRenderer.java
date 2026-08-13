package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;

/** Platform renderer for framework-owned Inline Autofill remote Surfaces. */
public final class InlineAutofillRemoteRenderer implements HeaderRenderer {
    @Override
    public HeaderPresentationKind getPresentationKind() {
        return HeaderPresentationKind.REMOTE_SURFACE;
    }

    @Override
    public HeaderRenderedContent prepare(Context context, HeaderContribution contribution,
            HeaderChromeFactory chromeFactory) {
        if (!(contribution.getPayload() instanceof InlineAutofillRemotePayload)) {
            throw new IllegalArgumentException("Inline Autofill requires remote payload");
        }
        return new InlineAutofillRemoteContent(context,
                (InlineAutofillRemotePayload) contribution.getPayload(), chromeFactory);
    }
}
