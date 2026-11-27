package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.view.View;

/**
 * Draws the floating card's shadow.
 *
 * <p>The keyboard area cannot do this with elevation: it is scaled with a view transform, its
 * layout bounds stay at the full size, and the system clips the shadow away completely.
 *
 * <p>This view covers its parent and is never scaled. Every pass it is told the card's current
 * on-screen rectangle and paints a band just outside it. That keeps the shadow at a fixed blur and
 * opacity whatever the card's size: scaling a shadow-casting view would shrink the blur with it, so
 * the same card would look heavy when large and nearly flat when small.
 *
 * <p>The band is square, matching the card's corners, and is drawn by hand rather than with
 * elevation because elevation also adds an ambient layer across the whole view, which shows through
 * the translucent header.
 */
final class FloatingCardShadow extends View {

    /** How far the band reaches outside the card, in dp. Must exceed the blur radius plus offset. */
    static final float INSET_DP = 9f;

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path ring = new Path();
    private final RectF card = new RectF();
    private final float inset;

    FloatingCardShadow(Context context, float density) {
        super(context);
        inset = INSET_DP * density;
        paint.setStyle(Paint.Style.FILL);
        // Almost transparent fill: the shape only exists to cast the shadow below. A fully
        // transparent colour would drop the shadow with it.
        paint.setColor(0x01000000);
        ring.setFillType(Path.FillType.EVEN_ODD);
        paint.setShadowLayer(6f * density, 0f, 2f * density, 0x26000000);
        setWillNotDraw(false);
        setClickable(false);
        setFocusable(false);
        setImportantForAccessibility(IMPORTANT_FOR_ACCESSIBILITY_NO);
        // setShadowLayer only blurs on a software canvas.
        setLayerType(LAYER_TYPE_SOFTWARE, null);
    }

    /** The card's rectangle in this view's coordinates. Cheap to call every pass. */
    void setCardRect(float left, float top, float width, float height) {
        if (card.left == left && card.top == top
                && card.right == left + width && card.bottom == top + height) {
            return;
        }
        card.set(left, top, left + width, top + height);
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        if (card.isEmpty()) return;
        int width = getWidth();
        int height = getHeight();
        if (width <= 0 || height <= 0) return;
        // Only the band outside the card is painted, so the shadow never lands on the keys. An
        // even-odd path gives the band in one pass; two overlapping rectangles would double the
        // shadow where they meet.
        ring.reset();
        ring.addRect(card.left - inset, card.top - inset, card.right + inset, card.bottom + inset,
                Path.Direction.CW);
        ring.addRect(card.left, card.top, card.right, card.bottom, Path.Direction.CW);
        canvas.drawPath(ring, paint);
    }
}
