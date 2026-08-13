package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.ImageView;

/** Project action rendered only from a runtime snapshot of genuine native chrome. */
public final class HeaderActionSlot {
    private static final int ATTR_ICON_ALPHA = 0x7f010087;
    private static final int ATTR_ICON_LEFT = 0x7f01008a;
    private static final int ATTR_ICON_RIGHT = 0x7f01008b;
    private static final int ID_SHOW_MORE_CANDIDATES = 0x7f0f0149;
    private static final int RAIL_WIDTH_RES_ID = 0x7f0d0206;
    private static final String DIVIDER_TAG = ".divider.vertical.for-candidate-key";

    private final HeaderVisualSlot visualSlot;
    private final ImageView icon;
    private final HeaderNativeChromeSnapshot chrome;
    private final HeaderActionKind kind;

    public HeaderActionSlot(Context context, HeaderVisualSlot slot, HeaderActionKind kind,
            HeaderNativeChromeSnapshot chrome) {
        if (context == null || slot == null || kind == null || chrome == null) {
            throw new IllegalArgumentException("action chrome metadata must not be null");
        }
        visualSlot = slot;
        this.chrome = chrome;
        this.kind = kind;
        icon = new ImageView(context);
        icon.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        int iconSize = Math.max(1,
                Math.round(24.0f * context.getResources().getDisplayMetrics().density));
        visualSlot.getContentHost().addView(icon, new FrameLayout.LayoutParams(
                iconSize, iconSize, Gravity.CENTER));
        visualSlot.getSeparator().setVisibility(View.GONE);
        visualSlot.getRailSeparator().setVisibility(View.GONE);
        ImageView railSeparator = new ImageView(context);
        railSeparator.setScaleType(ImageView.ScaleType.FIT_XY);
        railSeparator.setImageDrawable(chrome.newDivider(context));
        railSeparator.setAlpha(chrome.getDividerAlpha());
        railSeparator.setPadding(0, chrome.getDividerPaddingTop(), 0,
                chrome.getDividerPaddingBottom());
        FrameLayout.LayoutParams separatorParams = new FrameLayout.LayoutParams(
                Math.max(1, chrome.getDividerWidth()),
                ViewGroup.LayoutParams.MATCH_PARENT,
                (kind == HeaderActionKind.NEXT ? Gravity.START : Gravity.END)
                        | Gravity.CENTER_VERTICAL);
        ((FrameLayout) visualSlot.getRoot()).addView(railSeparator, separatorParams);
    }

    public View getRoot() { return visualSlot.getRoot(); }
    public int getRailWidth() { return chrome.getRailWidth(); }
    public int getLeadingInset() { return chrome.getLeadingInset(); }
    public int getTrailingInset() { return chrome.getTrailingInset(); }

    public void setEnabled(boolean enabled) {
        View root = visualSlot.getRoot();
        root.setEnabled(enabled);
        icon.setEnabled(enabled);
        root.setClickable(enabled);
        root.setFocusable(enabled);
        root.setImportantForAccessibility(enabled
                ? View.IMPORTANT_FOR_ACCESSIBILITY_YES
                : View.IMPORTANT_FOR_ACCESSIBILITY_NO);
        icon.setAlpha(1.0f);
        icon.setImageAlpha(Math.round(chrome.getIconAlpha() * 255.0f));
        Drawable actionIcon = chrome.newActionIcon(root.getContext(), kind, enabled);
        if (actionIcon != null && visualSlot.getCandidateLabelColors() != null) {
            int color = visualSlot.getCandidateLabelColors().getColorForState(
                    icon.getDrawableState(),
                    visualSlot.getCandidateLabelColors().getDefaultColor());
            actionIcon.setColorFilter(Color.rgb(Color.red(color), Color.green(color),
                    Color.blue(color)), PorterDuff.Mode.SRC_IN);
        }
        icon.setImageDrawable(actionIcon);
        if (actionIcon != null) actionIcon.setState(icon.getDrawableState());
    }

    public void clear() {
        visualSlot.clear();
        visualSlot.getRoot().setOnClickListener(null);
        visualSlot.getRoot().setContentDescription(null);
    }

    /** Called by the native holder seam after its real Views have been theme-bound. */
    public static HeaderNativeChromeSnapshot captureNativeChrome(View candidateHolder) {
        if (candidateHolder == null) throw new IllegalArgumentException("holder is missing");
        Context context = candidateHolder.getContext();
        ViewParent parent = candidateHolder.getParent();
        ViewGroup owner = parent instanceof ViewGroup ? (ViewGroup) parent : null;
        int leading = owner == null ? 0 : owner.getPaddingLeft();
        int trailing = owner == null ? 0 : owner.getPaddingRight();
        View showMore = owner == null ? null : owner.findViewById(ID_SHOW_MORE_CANDIDATES);
        int width = showMore == null ? 0
                : Math.max(showMore.getWidth(), showMore.getMeasuredWidth());
        if (width <= 0 && showMore != null) width = showMore.getMinimumWidth();
        if (width <= 0) width = context.getResources().getDimensionPixelSize(
                RAIL_WIDTH_RES_ID);
        View divider = findDivider(showMore);
        ImageView dividerImage = divider instanceof ImageView ? (ImageView) divider : null;
        Drawable dividerDrawable = dividerImage == null ? null
                : freezeDrawable(dividerImage);
        ViewGroup.LayoutParams dividerParams = divider == null ? null : divider.getLayoutParams();
        int dividerWidth = dividerParams != null && dividerParams.width > 0
                ? dividerParams.width : 1;

        Drawable previousSelector = resolveDrawable(context, ATTR_ICON_LEFT);
        Drawable nextSelector = resolveDrawable(context, ATTR_ICON_RIGHT);
        // Native left/right paging keys get their image alpha from
        // SoftKeyDef alpha="@attr/IconAlpha". The show-more Header action is
        // a different key and its fully opaque icon is not a paging-key alpha
        // source.
        float runtimeAlpha = resolveAlpha(context, ATTR_ICON_ALPHA);
        HeaderVisualSlot themeProbe = ((HeaderChromeFactory) candidateHolder)
                .createCandidateChromeSlot();
        Integer candidateTextColor = themeProbe.getCandidateLabelCurrentColor();
        themeProbe.clear();
        return new HeaderNativeChromeSnapshot(dividerDrawable,
                dividerImage == null ? 1.0f : effectiveImageAlpha(dividerImage),
                previousSelector, previousSelector,
                nextSelector, nextSelector,
                runtimeAlpha, width, leading, trailing, dividerWidth,
                divider == null ? 0 : divider.getPaddingTop(),
                divider == null ? 0 : divider.getPaddingBottom(), candidateTextColor);
    }

    private static Drawable freezeDrawable(ImageView source) {
        Drawable drawable = source.getDrawable();
        if (drawable == null) return null;
        int width = Math.max(1, source.getWidth() - source.getPaddingLeft()
                - source.getPaddingRight());
        int height = Math.max(1, source.getHeight() - source.getPaddingTop()
                - source.getPaddingBottom());
        if (width <= 1) width = Math.max(1, drawable.getIntrinsicWidth());
        if (height <= 1) height = Math.max(1, drawable.getIntrinsicHeight());
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        android.graphics.Rect oldBounds = drawable.copyBounds();
        drawable.setBounds(0, 0, width, height);
        drawable.draw(canvas);
        drawable.setBounds(oldBounds);
        BitmapDrawable frozen = new BitmapDrawable(source.getResources(), bitmap);
        frozen.setFilterBitmap(false);
        return frozen;
    }

    /** Gives native Clipboard rails the exact runtime show-more divider appearance. */
    public static void syncClipboardDividers(final View candidateRoot,
            final View left, final View right) {
        syncClipboardDividers(candidateRoot, left, right, true);
    }

    private static void syncClipboardDividers(final View candidateRoot,
            final View left, final View right, boolean allowDeferredSync) {
        if (candidateRoot == null) return;
        View root = candidateRoot.getRootView();
        View showMore = root == null ? null : root.findViewById(ID_SHOW_MORE_CANDIDATES);
        View divider = findDivider(showMore);
        if (!(divider instanceof ImageView)) return;
        final ImageView source = (ImageView) divider;
        int contentWidth = source.getWidth() - source.getPaddingLeft()
                - source.getPaddingRight();
        int contentHeight = source.getHeight() - source.getPaddingTop()
                - source.getPaddingBottom();
        if (allowDeferredSync && (contentWidth <= 0 || contentHeight <= 0)) {
            if (left != null) left.setVisibility(View.INVISIBLE);
            if (right != null) right.setVisibility(View.INVISIBLE);
            final ViewTreeObserver observer = candidateRoot.getViewTreeObserver();
            observer.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
                @Override public boolean onPreDraw() {
                    ViewTreeObserver current = candidateRoot.getViewTreeObserver();
                    if (current.isAlive()) current.removeOnPreDrawListener(this);
                    int width = source.getWidth() - source.getPaddingLeft()
                            - source.getPaddingRight();
                    int height = source.getHeight() - source.getPaddingTop()
                            - source.getPaddingBottom();
                    if (width > 0 && height > 0) {
                        syncClipboardDividers(candidateRoot, left, right, false);
                        if (left != null) left.setVisibility(View.VISIBLE);
                        if (right != null) right.setVisibility(View.VISIBLE);
                    }
                    return true;
                }
            });
            candidateRoot.invalidate();
            return;
        }
        syncDividerTarget(source, left);
        syncDividerTarget(source, right);
    }

    private static void syncDividerTarget(ImageView source, View targetView) {
        if (!(targetView instanceof ImageView)) return;
        ImageView target = (ImageView) targetView;
        Drawable frozen = freezeDrawable(source);
        target.setImageTintList(null);
        target.clearColorFilter();
        target.setImageDrawable(frozen);
        target.setScaleType(source.getScaleType());
        target.setImageAlpha(255);
        target.setPadding(source.getPaddingLeft(), source.getPaddingTop(),
                source.getPaddingRight(), source.getPaddingBottom());
        float ancestorAlpha = effectiveAncestorAlpha(target);
        float desired = effectiveImageAlpha(source);
        target.setAlpha(ancestorAlpha <= 0.0f ? desired
                : Math.max(0.0f, Math.min(1.0f, desired / ancestorAlpha)));
    }

    private static float effectiveImageAlpha(ImageView image) {
        return effectiveAlpha(image) * image.getImageAlpha() / 255.0f;
    }

    private static float effectiveAncestorAlpha(View view) {
        float alpha = 1.0f;
        ViewParent parent = view.getParent();
        while (parent instanceof View) {
            View current = (View) parent;
            alpha *= current.getAlpha();
            parent = current.getParent();
        }
        return alpha;
    }

    private static float effectiveAlpha(View view) {
        float alpha = 1.0f;
        View current = view;
        while (current != null) {
            alpha *= current.getAlpha();
            ViewParent parent = current.getParent();
            current = parent instanceof View ? (View) parent : null;
        }
        return alpha;
    }

    private static View findDivider(View view) {
        if (view == null) return null;
        Object tag = view.getTag();
        if (tag != null && DIVIDER_TAG.equals(tag.toString())) return view;
        if (!(view instanceof ViewGroup)) return null;
        ViewGroup group = (ViewGroup) view;
        for (int i = 0; i < group.getChildCount(); i++) {
            View result = findDivider(group.getChildAt(i));
            if (result != null) return result;
        }
        return null;
    }

    private static float resolveAlpha(Context context, int attribute) {
        TypedArray values = context.obtainStyledAttributes(new int[] { attribute });
        try {
            int alpha = values.getInt(0, 255);
            return Math.max(0, Math.min(255, alpha)) / 255.0f;
        } finally {
            values.recycle();
        }
    }

    private static Drawable resolveDrawable(Context context, int attribute) {
        TypedArray values = context.obtainStyledAttributes(new int[] { attribute });
        try {
            Drawable drawable = values.getDrawable(0);
            if (drawable == null) throw new IllegalStateException("native action icon is missing");
            return drawable;
        } finally {
            values.recycle();
        }
    }

}
