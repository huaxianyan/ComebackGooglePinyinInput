package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.MotionEvent;
import android.view.View;

/**
 * Drag handle drawn just above the floating card.
 *
 * <p>It lives in the window decor rather than inside the keyboard so it can sit outside the card
 * without being scaled with it, and it must be added to the window's touchable region by
 * {@link FloatingKeyboardCompat#applyInsets} or touches would pass straight through to the app.
 */
public final class FloatingKeyboardHandle extends View {

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final float density;

    public FloatingKeyboardHandle(Context context) {
        super(context);
        density = context.getResources().getDisplayMetrics().density;
        // Mid grey reads on both the light and the dark keyboard theme.
        paint.setColor(0x99808080);
        setClickable(true);
    }

    /** Height the compat class reserves for this view, in pixels. */
    public int heightPx() {
        return Math.round(FloatingKeyboardCompat.HANDLE_HEIGHT_DP * density);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        float barWidth = Math.min(getWidth() * 0.18f, 56f * density);
        float barHeight = 4f * density;
        float left = (getWidth() - barWidth) / 2f;
        float top = (getHeight() - barHeight) / 2f;
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
