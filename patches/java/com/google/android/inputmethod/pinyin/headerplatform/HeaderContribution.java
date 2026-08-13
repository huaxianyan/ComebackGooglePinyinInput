package com.google.android.inputmethod.pinyin.headerplatform;

/** Immutable module publication accepted only for its originating Header session. */
public final class HeaderContribution {
    private final String moduleId;
    private final String stableId;
    private final long sessionToken;
    private final long headerToken;
    private final int priority;
    private final HeaderPresentationKind presentationKind;
    private final HeaderPlacement placement;
    private final boolean allowsActions;
    private final HeaderRendererPayload payload;

    public HeaderContribution(String moduleId, String stableId, long sessionToken,
            long headerToken, int priority, HeaderPresentationKind presentationKind,
            HeaderPlacement placement, boolean allowsActions,
            HeaderRendererPayload payload) {
        if (moduleId == null || moduleId.length() == 0) {
            throw new IllegalArgumentException("moduleId must not be empty");
        }
        if (stableId == null || stableId.length() == 0) {
            throw new IllegalArgumentException("stableId must not be empty");
        }
        if (sessionToken <= 0L || headerToken <= 0L) {
            throw new IllegalArgumentException("session and Header tokens must be positive");
        }
        if (presentationKind == null || placement == null || payload == null) {
            throw new IllegalArgumentException("presentation metadata must not be null");
        }
        if (presentationKind == HeaderPresentationKind.NATIVE_ACTION
                && placement != HeaderPlacement.LEADING_ACTION
                && placement != HeaderPlacement.TRAILING_ACTION
                && placement != HeaderPlacement.PERSISTENT_ACTION) {
            throw new IllegalArgumentException("native actions require action placement");
        }
        if (presentationKind != HeaderPresentationKind.NATIVE_ACTION
                && placement != HeaderPlacement.CENTER_CONTENT
                && placement != HeaderPlacement.EXCLUSIVE_CONTENT) {
            throw new IllegalArgumentException("content renderers require content placement");
        }
        this.moduleId = moduleId;
        this.stableId = stableId;
        this.sessionToken = sessionToken;
        this.headerToken = headerToken;
        this.priority = priority;
        this.presentationKind = presentationKind;
        this.placement = placement;
        this.allowsActions = allowsActions;
        this.payload = payload;
    }

    public String getModuleId() { return moduleId; }
    public String getStableId() { return stableId; }
    public long getSessionToken() { return sessionToken; }
    public long getHeaderToken() { return headerToken; }
    public int getPriority() { return priority; }
    public HeaderPresentationKind getPresentationKind() { return presentationKind; }
    public HeaderPlacement getPlacement() { return placement; }
    public boolean allowsActions() { return allowsActions; }
    public HeaderRendererPayload getPayload() { return payload; }
}
