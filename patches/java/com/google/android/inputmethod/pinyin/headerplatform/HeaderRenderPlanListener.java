package com.google.android.inputmethod.pinyin.headerplatform;

/** Host callback. The platform remains the sole owner of render-plan transitions. */
public interface HeaderRenderPlanListener {
    void onHeaderRenderPlanChanged(HeaderRenderPlan plan);
}
