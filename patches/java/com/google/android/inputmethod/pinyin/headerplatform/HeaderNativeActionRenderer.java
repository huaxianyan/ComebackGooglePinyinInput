package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;
import android.view.View;

/** Platform renderer for project-owned actions such as future Header shortcuts. */
public final class HeaderNativeActionRenderer implements HeaderRenderer {
    @Override
    public HeaderPresentationKind getPresentationKind() {
        return HeaderPresentationKind.NATIVE_ACTION;
    }

    @Override
    public HeaderRenderedContent prepare(Context context, HeaderContribution contribution,
            HeaderChromeFactory chromeFactory) {
        if (!(contribution.getPayload() instanceof HeaderNativeActionPayload)) {
            throw new IllegalArgumentException("native action payload is required");
        }
        final HeaderNativeActionPayload payload =
                (HeaderNativeActionPayload) contribution.getPayload();
        final HeaderActionSlot slot = chromeFactory.createActionChromeSlot(payload.getKind());
        final View root = slot.getRoot();
        root.setContentDescription(payload.getContentDescription());
        root.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View ignored) {
                if (payload.isEnabled()) payload.getCallback().performAction();
            }
        });
        slot.setEnabled(payload.isEnabled());
        return new HeaderRenderedContent() {
            private boolean released;
            @Override public View getView() { return root; }
            @Override public void release() {
                if (released) return;
                released = true;
                slot.clear();
            }
        };
    }
}
