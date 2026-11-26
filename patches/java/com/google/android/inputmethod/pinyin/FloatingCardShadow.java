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
 * layout bounds stay at the full window size and the shadow lands along the screen edges. This view
 * is positioned at the card's on-screen rectangle instead, so the shadow follows the card.
 *
 * <p>The shadow is drawn by hand rather than with elevation because elevation also adds an ambient
 * shadow across the whole view, and the header is translucent, so that ambient layer showed through
 * it as a grey wash. Drawing only the ring outside the card avoids that entirely.
 *
 * <p>It takes no touch. The card is a sibling drawn above it.
 */
final class FloatingCardShadow extends View {

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path ring = new Path();
    private final float radius;
    private final float inset;

    FloatingCardShadow(Context context, float density) {
        super(context);
        radius = 6f * density;
        // Must exceed the blur radius, otherwise the inner half of the shadow reaches past the
        // ring and shows through the translucent header.
        inset = 9f * density;
        paint.setStyle(Paint.Style.FILL);
        // Almost transparent fill: the shape only exists to cast the shadow below. A fully
        // transparent colour would drop the shadow with it.
        paint.setColor(0x01000000);
        ring.setFillType(Path.FillType.EVEN_ODD);
        // The shadow comes from this layer rather than from the view's elevation.
        paint.setShadowLayer(radius, 0f, 1.5f * density, 0x24000000);
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
        ring.addRect(0f, 0f, width, height, Path.Direction.CW);
        ring.addRect(inset, inset, width - inset, height - inset, Path.Direction.CW);
        canvas.drawPath(ring, paint);
    }
}
