package com.google.android.inputmethod.pinyin.headerplatform;

import android.util.Log;
import android.view.View;

import java.util.List;

/** Header module for Inline Autofill remote content; API 30 protocol remains in its bridge. */
public final class InlineAutofillHeaderModule implements HeaderModule {
    public static final String MODULE_ID = "inline-autofill";
    private static final String CONTRIBUTION_ID = "suggestions";
    private static final int PRIORITY = 200;

    private HeaderPlatformContext platform;
    private long sessionToken;
    private long headerToken;
    private InlineAutofillRemotePayload payload;

    @Override public String getModuleId() { return MODULE_ID; }
    @Override public int getDefaultPriority() { return PRIORITY; }

    @Override
    public void onAttach(HeaderPlatformContext context) {
        if (context == null) throw new IllegalArgumentException("platform must not be null");
        platform = context;
    }

    @Override
    public void onStartInput(HeaderEditorContext editor, long token) {
        sessionToken = token;
        payload = null;
        withdraw();
    }

    @Override
    public void onHeaderAvailable(HeaderHandle header) {
        headerToken = header == null ? 0L : header.getToken();
        Log.i("HeaderPlatformAudit", "module header available token=" + headerToken
                + " payload=" + (payload != null));
        publishIfReady();
    }

    @Override
    public void onHeaderUnavailable(long token) {
        if (headerToken == token) {
            headerToken = 0L;
            withdraw();
        }
    }

    @Override public void onNativeCandidateStateChanged(boolean active) {}
    @Override public void onThemeChanged(long themeToken) {}

    @Override
    public void onFinishInput(long token) {
        if (sessionToken == token) {
            withdraw();
            payload = null;
            sessionToken = 0L;
        }
    }

    @Override
    public void onDetach() {
        withdraw();
        payload = null;
        sessionToken = 0L;
        headerToken = 0L;
        platform = null;
    }

    public boolean isAvailable() {
        return isAvailableFor(sessionToken, headerToken);
    }

    public boolean isSessionAvailable() {
        return isSessionAvailableFor(sessionToken);
    }

    public boolean isSessionAvailableFor(long expectedSessionToken) {
        return platform != null && expectedSessionToken > 0L
                && sessionToken == expectedSessionToken
                && platform.getCurrentSessionToken() == expectedSessionToken;
    }

    public boolean isAvailableFor(long expectedSessionToken, long expectedHeaderToken) {
        return isSessionAvailableFor(expectedSessionToken)
                && expectedHeaderToken > 0L
                && headerToken == expectedHeaderToken
                && platform.getCurrentHeaderToken() == expectedHeaderToken;
    }

    public long getSessionToken() { return sessionToken; }
    public long getHeaderToken() { return headerToken; }
    public Integer getCurrentCandidateTextColor() {
        return platform == null ? null : platform.getCurrentCandidateTextColor();
    }

    /** Called only by the API 30 bridge after its generation/session checks complete. */
    public boolean setRemoteViews(List<? extends View> views,
            HeaderRemoteSurfaceClipper clipper, Integer requestCandidateTextColor) {
        if (!isSessionAvailable()) return false;
        if (views == null || views.isEmpty()) {
            clearRemoteViews();
            return false;
        }
        payload = new InlineAutofillRemotePayload(
                views, clipper, requestCandidateTextColor);
        publishIfReady();
        return true;
    }

    public void clearRemoteViews() {
        withdraw();
        payload = null;
    }

    private boolean publishIfReady() {
        if (payload == null || !isAvailable()) {
            Log.i("HeaderPlatformAudit", "module publish not ready payload=" + (payload != null)
                    + " session=" + isSessionAvailable() + " header=" + (headerToken > 0L));
            return false;
        }
        boolean accepted = platform.publish(new HeaderContribution(
                MODULE_ID, CONTRIBUTION_ID, sessionToken, headerToken, PRIORITY,
                HeaderPresentationKind.REMOTE_SURFACE, HeaderPlacement.CENTER_CONTENT,
                false, payload));
        Log.i("HeaderPlatformAudit", "module contribution accepted=" + accepted);
        return accepted;
    }

    private void withdraw() {
        if (platform != null) platform.withdrawModule(MODULE_ID);
    }
}
