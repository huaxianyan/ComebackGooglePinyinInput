package com.google.android.inputmethod.pinyin.headerplatform;

/** Narrow module-to-platform publication API; modules never receive sibling Views. */
public interface HeaderPlatformContext {
    long getCurrentSessionToken();
    long getCurrentHeaderToken();
    Integer getCurrentCandidateTextColor();
    boolean publish(HeaderContribution contribution);
    void withdraw(String moduleId, String stableId);
    void withdrawModule(String moduleId);
}
