package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.res.ColorStateList;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.FrameLayout;
import android.widget.TextView;

/** Independently owned native Candidate chrome with no Candidate model or action binding. */
public final class HeaderVisualSlot {
    private static final int ID_CANDIDATE_SEPARATOR = 0x7f0f0013;
    private static final int ID_LABEL = 0x7f0f0183;
    private static final int ID_DELETABLE_LABEL = 0x7f0f0185;
    private static final int ID_ORDINAL_LABEL = 0x7f0f0187;

    private final View root;
    private final FrameLayout contentHost;
    private final View separator;
    private final View railSeparator;
    private final ColorStateList candidateLabelColors;
    private final Integer candidateLabelCurrentColor;

    public HeaderVisualSlot(View nativeRoot) {
        if (!(nativeRoot instanceof ViewGroup)) {
            throw new IllegalArgumentException("native slot root must be a ViewGroup");
        }
        View candidateLabel = nativeRoot.findViewById(ID_LABEL);
        candidateLabelColors = candidateLabel instanceof TextView
                ? ((TextView) candidateLabel).getTextColors() : null;
        candidateLabelCurrentColor = candidateLabel instanceof TextView
                ? Integer.valueOf(((TextView) candidateLabel).getCurrentTextColor()) : null;
        hideSemanticView(candidateLabel);
        hideSemanticView(nativeRoot.findViewById(ID_DELETABLE_LABEL));
        hideSemanticView(nativeRoot.findViewById(ID_ORDINAL_LABEL));
        separator = nativeRoot.findViewById(ID_CANDIDATE_SEPARATOR);
        railSeparator = nativeRoot.findViewWithTag("compat_clipboard_right_separator");
        if (separator == null || railSeparator == null
                || !(separator.getParent() instanceof ViewGroup)) {
            throw new IllegalStateException("native Candidate separator/content parent is missing");
        }
        ViewGroup nativeContent = (ViewGroup) separator.getParent();
        ViewParent contentParent = nativeContent.getParent();
        if (!(contentParent instanceof ViewGroup)) {
            throw new IllegalStateException("native Candidate content owner is missing");
        }
        ((ViewGroup) contentParent).removeView(nativeContent);
        FrameLayout neutralRoot = new FrameLayout(nativeRoot.getContext());
        android.graphics.drawable.Drawable nativeBackground = nativeRoot.getBackground();
        nativeRoot.setBackground(null);
        neutralRoot.setBackground(nativeBackground);
        neutralRoot.setPadding(nativeRoot.getPaddingLeft(), nativeRoot.getPaddingTop(),
                nativeRoot.getPaddingRight(), nativeRoot.getPaddingBottom());
        neutralRoot.setMinimumWidth(nativeRoot.getMinimumWidth());
        neutralRoot.setMinimumHeight(nativeRoot.getMinimumHeight());
        neutralRoot.setClipChildren(true);
        neutralRoot.setClipToPadding(true);
        neutralRoot.addView(nativeContent, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        root = neutralRoot;
        contentHost = new FrameLayout(nativeRoot.getContext());
        contentHost.setClipChildren(true);
        contentHost.setClipToPadding(true);
        contentHost.setSaveEnabled(false);
        nativeContent.addView(contentHost, new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        separator.bringToFront();
        root.setContentDescription(null);
        root.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
    }

    public View getRoot() { return root; }
    public FrameLayout getContentHost() { return contentHost; }
    public View getSeparator() { return separator; }
    public View getRailSeparator() { return railSeparator; }
    public ColorStateList getCandidateLabelColors() { return candidateLabelColors; }
    public Integer getCandidateLabelCurrentColor() { return candidateLabelCurrentColor; }

    public void clear() {
        contentHost.removeAllViews();
    }

    private static void hideSemanticView(View view) {
        if (view == null) return;
        view.setContentDescription(null);
        view.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS);
        view.setVisibility(View.GONE);
    }
}
