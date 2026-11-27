package com.google.android.inputmethod.pinyin;

import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

/**
 * Places the clipboard candidate's dismiss control on the right-hand key column.
 *
 * <p>The floating keyboard scales the whole card with a view transform. {@code getLocationInWindow}
 * reports positions after that transform, {@code getWidth} still reports the pre-transform layout
 * size, and a margin set on a child is applied in pre-transform space. Mixing the three puts the
 * control left of its target by roughly (1 - scale) times the distance from the row's left edge,
 * and that error grows as the card shrinks: at 0.9 it is a visible offset, at 0.7 the control has
 * been pushed into the candidate text and is no longer readable.
 *
 * <p>The delta is therefore converted back to the container's own space before it becomes a margin.
 */
public final class ClipboardDismissAlign {

    private ClipboardDismissAlign() {}

    /**
     * Aligns {@code dismiss} horizontally on the centre of {@code reference}, both inside
     * {@code container}. Silently does nothing when the views have no size yet.
     */
    public static void align(View container, View dismiss, View reference) {
        if (container == null || dismiss == null || reference == null) return;
        ViewGroup.LayoutParams params = dismiss.getLayoutParams();
        if (!(params instanceof FrameLayout.LayoutParams)) return;

        int dismissWidth = params.width > 0 ? params.width : dismiss.getMeasuredWidth();
        if (dismissWidth <= 0) dismissWidth = dismiss.getWidth();
        if (dismissWidth <= 0) return;

        float scale = accumulatedScaleX(container);
        int[] referenceLocation = new int[2];
        int[] containerLocation = new int[2];
        reference.getLocationInWindow(referenceLocation);
        container.getLocationInWindow(containerLocation);

        // The reference's own width is pre-transform, so it has to be scaled up to match the
        // window-space position reported above.
        int referenceWidth = Math.round(reference.getWidth() * scale);
        int targetCenter = referenceLocation[0] + referenceWidth / 2;
        float deltaLocal = (targetCenter - containerLocation[0]) / scale;
        int leftMargin = Math.round(deltaLocal - dismissWidth / 2f - container.getPaddingLeft());

        FrameLayout.LayoutParams frame = (FrameLayout.LayoutParams) params;
        frame.gravity = 3;
        frame.leftMargin = leftMargin;
        frame.rightMargin = 0;
        dismiss.setLayoutParams(frame);
    }

    /** Product of the scale factors between {@code view} and the window. */
    private static float accumulatedScaleX(View view) {
        float scale = 1f;
        View current = view;
        while (current != null) {
            float value = current.getScaleX();
            if (value > 0f) scale *= value;
            current = current.getParent() instanceof View ? (View) current.getParent() : null;
        }
        return scale > 0f ? scale : 1f;
    }
}
