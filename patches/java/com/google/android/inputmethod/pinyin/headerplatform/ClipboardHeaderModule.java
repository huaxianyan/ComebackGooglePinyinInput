package com.google.android.inputmethod.pinyin.headerplatform;

/** Clipboard control-plane module; native Candidate data/rendering remains in the legacy core. */
public final class ClipboardHeaderModule implements HeaderModule,
        HeaderNativeCandidateStateAware {
    public static final String MODULE_ID = "clipboard";
    private static final String CONTRIBUTION_ID = "native-candidate";
    private static final int PRIORITY = 100;
    private static final HeaderRendererPayload PAYLOAD = new HeaderRendererPayload() {};

    private HeaderPlatformContext platform;
    private long sessionToken;
    private long headerToken;

    @Override public String getModuleId() { return MODULE_ID; }
    @Override public int getDefaultPriority() { return PRIORITY; }
    @Override public void onAttach(HeaderPlatformContext context) { platform = context; }

    @Override
    public void onStartInput(HeaderEditorContext editor, long token) {
        sessionToken = token;
        withdraw();
    }

    @Override
    public void onHeaderAvailable(HeaderHandle header) {
        headerToken = header == null ? 0L : header.getToken();
    }

    @Override
    public void onHeaderUnavailable(long token) {
        if (headerToken == token) {
            withdraw();
            headerToken = 0L;
        }
    }

    @Override
    public void onNativeCandidateStateChanged(boolean active) {
        onNativeCandidateStateChanged(active, false);
    }

    public void onNativeCandidateStateChanged(boolean active, boolean clipboardOnly) {
        if (active && clipboardOnly) publish();
        else withdraw();
    }

    @Override public void onThemeChanged(long themeToken) {}

    @Override
    public void onFinishInput(long token) {
        if (sessionToken == token) {
            withdraw();
            sessionToken = 0L;
        }
    }

    @Override
    public void onDetach() {
        withdraw();
        platform = null;
        sessionToken = 0L;
        headerToken = 0L;
    }

    private void publish() {
        if (platform == null || sessionToken <= 0L || headerToken <= 0L
                || platform.getCurrentSessionToken() != sessionToken
                || platform.getCurrentHeaderToken() != headerToken) return;
        platform.publish(new HeaderContribution(
                MODULE_ID, CONTRIBUTION_ID, sessionToken, headerToken, PRIORITY,
                HeaderPresentationKind.NATIVE_CANDIDATE, HeaderPlacement.CENTER_CONTENT,
                false, PAYLOAD));
    }

    private void withdraw() {
        if (platform != null) platform.withdrawModule(MODULE_ID);
    }
}
