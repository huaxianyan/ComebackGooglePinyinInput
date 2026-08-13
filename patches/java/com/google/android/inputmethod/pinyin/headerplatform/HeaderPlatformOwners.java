package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;
import android.content.ContextWrapper;

/** Safe Context-wrapper traversal shared by the host and guarded protocol bridges. */
public final class HeaderPlatformOwners {
    private HeaderPlatformOwners() {}

    public static HeaderPlatformOwner find(Context context) {
        Context current = context;
        while (current != null) {
            if (current instanceof HeaderPlatformOwner) return (HeaderPlatformOwner) current;
            if (!(current instanceof ContextWrapper)) return null;
            Context next = ((ContextWrapper) current).getBaseContext();
            if (next == current) return null;
            current = next;
        }
        return null;
    }
}
