package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.view.MotionEvent;
import android.view.View;

/**
 * Draws the floating card's shadow.
 *
 * <p>The keyboard area cannot do this with elevation: it is scaled with a view transform, so its
 * layout bounds stay at the full size and the system clips the shadow away completely. This view is
 * instead a child of the card, laid out one {@code INSET_DP} larger on every side: its band is
 * therefore exactly the ring outside the card, and it inherits the card's own transform, so it
 * moves and scales with the card in the same pass instead of chasing it.
 *
 * <p>The shadow is drawn by hand rather than with elevation because elevation also adds an ambient
 * shadow across the whole view, and the header is translucent, so that ambient layer showed through
 * it as a grey wash. Drawing only the ring outside the card avoids that entirely.
 *
 * <p>It takes no touch. The card is a sibling drawn above it.
 */
final class FloatingCardShadow extends View {

    /** How far the band sits outside the card, in dp. Must exceed the blur radius plus offset. */
    static final float INSET_DP = 13f;

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path ring = new Path();
    private final float radius;
    private final float inset;
    private final float inner;

    FloatingCardShadow(Context context, float density) {
        super(context);
        radius = 9f * density;
        inner = 12f * density;
        // Must exceed the blur radius, otherwise the inner half of the shadow reaches past the
        // ring and shows through the translucent header.
        inset = INSET_DP * density;
        paint.setStyle(Paint.Style.FILL);
        // Almost transparent fill: the shape only exists to cast the shadow below. A fully
        // transparent colour would drop the shadow with it.
        paint.setColor(0x01000000);
        ring.setFillType(Path.FillType.EVEN_ODD);
        // The shadow comes from this layer rather than from the view's elevation.
        paint.setShadowLayer(radius, 0f, 2f * density, 0x40000000);
        setWillNotDraw(false);
        setClickable(false);
        setFocusable(false);
        setImportantForAccessibility(IMPORTANT_FOR_ACCESSIBILITY_NO);
        setLayerType(LAYER_TYPE_SOFTWARE, null);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return false;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        int width = getWidth();
        int height = getHeight();
        if (width <= inset * 2 || height <= inset * 2) return;
        // Only the ring outside the card is painted, so the shadow never lands on the keys. An
        // even-odd path gives the ring in one pass; two overlapping rectangles would double the
        // shadow where they meet.
        ring.reset();
        // Rounded to match the card's corners: the ring is the band between two rounded rects.
        ring.addRoundRect(0f, 0f, width, height, inner + inset, inner + inset,
                Path.Direction.CW);
        ring.addRoundRect(inset, inset, width - inset, height - inset, inner, inner,
                Path.Direction.CW);
        canvas.drawPath(ring, paint);
    }
}
