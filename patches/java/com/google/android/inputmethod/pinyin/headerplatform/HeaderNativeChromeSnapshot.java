package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;
import android.graphics.drawable.Drawable;

/** Immutable runtime-resolved native Header chrome captured from real bound Views. */
public final class HeaderNativeChromeSnapshot {
    private final Drawable divider;
    private final float dividerAlpha;
    private final Drawable previousEnabled;
    private final Drawable previousDisabled;
    private final Drawable nextEnabled;
    private final Drawable nextDisabled;
    private final float iconAlpha;
    private final int railWidth;
    private final int leadingInset;
    private final int trailingInset;
    private final int dividerWidth;
    private final int dividerPaddingTop;
    private final int dividerPaddingBottom;
    private final Integer candidateTextColor;

    public HeaderNativeChromeSnapshot(Drawable divider, float dividerAlpha,
            Drawable previousEnabled, Drawable previousDisabled,
            Drawable nextEnabled, Drawable nextDisabled, float iconAlpha,
            int railWidth, int leadingInset, int trailingInset, int dividerWidth,
            int dividerPaddingTop, int dividerPaddingBottom, Integer candidateTextColor) {
        this.divider = divider;
        this.dividerAlpha = dividerAlpha;
        this.previousEnabled = previousEnabled;
        this.previousDisabled = previousDisabled;
        this.nextEnabled = nextEnabled;
        this.nextDisabled = nextDisabled;
        this.iconAlpha = iconAlpha;
        this.railWidth = railWidth;
        this.leadingInset = leadingInset;
        this.trailingInset = trailingInset;
        this.dividerWidth = dividerWidth;
        this.dividerPaddingTop = dividerPaddingTop;
        this.dividerPaddingBottom = dividerPaddingBottom;
        this.candidateTextColor = candidateTextColor;
    }

    public Drawable newDivider(Context context) { return clone(context, divider); }
    public Drawable newActionIcon(Context context, HeaderActionKind kind, boolean enabled) {
        Drawable source = kind == HeaderActionKind.PREVIOUS
                ? (enabled ? previousEnabled : previousDisabled)
                : (enabled ? nextEnabled : nextDisabled);
        return clone(context, source);
    }
    public float getDividerAlpha() { return dividerAlpha; }
    public float getIconAlpha() { return iconAlpha; }
    public int getRailWidth() { return railWidth; }
    public int getLeadingInset() { return leadingInset; }
    public int getTrailingInset() { return trailingInset; }
    public int getDividerWidth() { return dividerWidth; }
    public int getDividerPaddingTop() { return dividerPaddingTop; }
    public int getDividerPaddingBottom() { return dividerPaddingBottom; }
    public Integer getCandidateTextColor() { return candidateTextColor; }

    private static Drawable clone(Context context, Drawable source) {
        if (source == null) return null;
        Drawable.ConstantState state = source.getConstantState();
        Drawable result = state == null ? source.mutate()
                : state.newDrawable(context.getResources()).mutate();
        // Do not copy the source View's transient enabled/pressed state. The
        // target ImageView owns state propagation for the cloned selector.
        result.setLevel(source.getLevel());
        result.setBounds(source.getBounds());
        return result;
    }
}
