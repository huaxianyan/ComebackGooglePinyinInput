package com.google.android.inputmethod.pinyin.headerplatform;

/** Renderer payload for a project-owned Header action; it exposes no View to the module. */
public final class HeaderNativeActionPayload implements HeaderRendererPayload {
    private final HeaderActionKind kind;
    private final CharSequence contentDescription;
    private final boolean enabled;
    private final HeaderActionCallback callback;

    public HeaderNativeActionPayload(HeaderActionKind kind, CharSequence contentDescription,
            boolean enabled, HeaderActionCallback callback) {
        if (kind == null || contentDescription == null || callback == null) {
            throw new IllegalArgumentException("native action metadata must not be null");
        }
        this.kind = kind;
        this.contentDescription = contentDescription;
        this.enabled = enabled;
        this.callback = callback;
    }

    public HeaderActionKind getKind() { return kind; }
    public CharSequence getContentDescription() { return contentDescription; }
    public boolean isEnabled() { return enabled; }
    public HeaderActionCallback getCallback() { return callback; }
}
