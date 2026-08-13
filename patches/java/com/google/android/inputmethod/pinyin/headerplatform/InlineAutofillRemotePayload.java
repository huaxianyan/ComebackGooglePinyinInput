package com.google.android.inputmethod.pinyin.headerplatform;

import android.view.View;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** API-neutral envelope around framework-owned remote Views; no presentation text is read. */
public final class InlineAutofillRemotePayload implements HeaderRendererPayload {
    private final List<View> views;
    private final HeaderRemoteSurfaceClipper clipper;
    private final Integer requestCandidateTextColor;

    public InlineAutofillRemotePayload(List<? extends View> source,
            HeaderRemoteSurfaceClipper clipper, Integer requestCandidateTextColor) {
        ArrayList<View> copy = new ArrayList<View>();
        if (source != null) {
            for (View view : source) if (view != null) copy.add(view);
        }
        if (copy.isEmpty() || clipper == null) {
            throw new IllegalArgumentException("remote views and clipper must not be empty");
        }
        views = Collections.unmodifiableList(copy);
        this.clipper = clipper;
        this.requestCandidateTextColor = requestCandidateTextColor;
    }

    public List<View> getViews() { return views; }
    public HeaderRemoteSurfaceClipper getClipper() { return clipper; }
    public Integer getRequestCandidateTextColor() { return requestCandidateTextColor; }
}
