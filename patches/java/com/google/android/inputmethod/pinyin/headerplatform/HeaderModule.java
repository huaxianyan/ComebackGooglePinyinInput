package com.google.android.inputmethod.pinyin.headerplatform;

/** Compile-time registered Header feature with platform-owned rendering and arbitration. */
public interface HeaderModule {
    String getModuleId();
    int getDefaultPriority();
    void onAttach(HeaderPlatformContext context);
    void onStartInput(HeaderEditorContext editor, long sessionToken);
    void onHeaderAvailable(HeaderHandle header);
    void onHeaderUnavailable(long headerToken);
    void onNativeCandidateStateChanged(boolean active);
    void onThemeChanged(long themeToken);
    void onFinishInput(long sessionToken);
    void onDetach();
}
