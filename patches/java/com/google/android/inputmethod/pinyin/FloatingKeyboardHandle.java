package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.MotionEvent;
import android.view.View;

/**
 * Drag handle drawn inside the floating card, just above its bottom edge.
 *
 * <p>It lives in the window content frame rather than inside the keyboard so it can sit above the
 * scaled card without being scaled with it, and the card rectangle already covers it in the
 * window's touchable region.
 */
public final class FloatingKeyboardHandle extends View {

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final float density;
    /** Distance from the view's bottom edge to the bar's centre, in pixels. */
    private float barCenterFromBottom = -1f;

    public FloatingKeyboardHandle(Context context) {
        super(context);
        density = context.getResources().getDisplayMetrics().density;
        // A quiet grey: visible on both the light and the dark keyboard theme, but not reading as
        // one more key.
        paint.setColor(0xFFC2C8D2);
        setClickable(true);
    }

    /** Height the compat class reserves for this view, in pixels. */
    public int heightPx() {
        return Math.round(FloatingKeyboardCompat.HANDLE_HEIGHT_DP * density);
    }

    /**
     * Places the bar inside the reserved gutter instead of the middle of the touch strip. The
     * gutter is scaled with the keyboard while this view is not, so the offset has to be handed in
     * by {@link FloatingKeyboardCompat} on every layout pass.
     */
    public void setBarCenterFromBottom(float pixels) {
        if (pixels < 0f || Math.abs(pixels - barCenterFromBottom) < 0.5f) return;
        barCenterFromBottom = pixels;
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        float barWidth = Math.min(getWidth() * 0.22f, 60f * density);
        float barHeight = 6f * density;
        float left = (getWidth() - barWidth) / 2f;
        float center = barCenterFromBottom >= 0f ? getHeight() - barCenterFromBottom : getHeight() / 2f;
        float top = center - barHeight / 2f;
        canvas.drawRoundRect(
                left,
                top,
                left + barWidth,
                top + barHeight,
                barHeight / 2f,
                barHeight / 2f,
                paint);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return FloatingKeyboardCompat.onHandleTouch(this, event);
    }
}
