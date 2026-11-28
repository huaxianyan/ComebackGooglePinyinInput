package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Rect;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

/**
 * Stock keyboard-editing chrome, positioned over the floating card.
 *
 * <p>The visual part is the app's own {@code keyboard_editing} layout: the dim overlay, the border
 * with its corner marks and the three action buttons all come from the theme, so they stay legible
 * on any palette without inventing colours. Only the geometry and the gestures are ours, because
 * the stock {@code KeyboardEditingViewHelper} assumes it owns the keyboard's scale and translation,
 * which the floating card has already applied.
 *
 * <p>The overlay fills the whole window, the same way the stock editor does. The border frame is
 * laid out on top of the card, and the action buttons keep the stock layout's own arrangement.
 */
public final class FloatingKeyboardEditView extends FrameLayout {

    /** Stock layout: dim overlay plus border frame plus action buttons. */
    private static final int LAYOUT = 0x7f04007b;
    private static final int ID_FRAME = 0x7f0f015c;
    private static final int ID_RESET = 0x7f0f01c5;
    private static final int ID_MOVE = 0x7f0f01a4;
    private static final int ID_EXIT = 0x7f0f001b;
    /**
     * Corner touch targets, in the order the drag handler expects:
     * left-top, right-top, right-bottom, left-bottom.
     */
    private static final int[] SCALE_IDS = {
            0x7f0f001e, 0x7f0f0020, 0x7f0f001f, 0x7f0f001d,
    };

    public interface Listener {
        void onDrag(float screenX, float screenY, boolean finished);
        void onScale(int corner, float screenX, float screenY, boolean finished);
        void onReset();
        void onDone();
    }

    private final View frame;
    private Listener listener;
    private int activeCorner = -1;
    private boolean dragging;

    public FloatingKeyboardEditView(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(LAYOUT, this, true);
        frame = findViewById(ID_FRAME);

        View reset = findViewById(ID_RESET);
        if (reset != null) {
            reset.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (listener != null) listener.onReset();
                }
            });
        }
        View exit = findViewById(ID_EXIT);
        if (exit != null) {
            exit.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (listener != null) listener.onDone();
                }
            });
        }

        // Moving is done by dragging the border frame or the move button.
        OnTouchListener dragListener = new OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent event) {
                return onDragTouch(event);
            }
        };
        if (frame != null) frame.setOnTouchListener(dragListener);
        View move = findViewById(ID_MOVE);
        if (move != null) move.setOnTouchListener(dragListener);

        for (int i = 0; i < SCALE_IDS.length; i++) {
            final int corner = i;
            View cornerView = findViewById(SCALE_IDS[i]);
            if (cornerView == null) continue;
            cornerView.setOnTouchListener(new OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent event) {
                    return onScaleTouch(corner, event);
                }
            });
        }
    }

    void setListener(Listener listener) {
        this.listener = listener;
    }

    /** The border frame fills this view, which is itself laid out on the card. */
    void setFrameBounds(Rect bounds) {
        if (frame == null) return;
        ViewGroup.LayoutParams params = frame.getLayoutParams();
        params.width = ViewGroup.LayoutParams.MATCH_PARENT;
        params.height = ViewGroup.LayoutParams.MATCH_PARENT;
        frame.setLayoutParams(params);
        frame.setVisibility(VISIBLE);
    }

    private boolean onDragTouch(MotionEvent event) {
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                dragging = true;
                reportDrag(event, false);
                return true;
            case MotionEvent.ACTION_MOVE:
                if (dragging) reportDrag(event, false);
                return true;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                if (dragging) reportDrag(event, true);
                dragging = false;
                return true;
            default:
                return true;
        }
    }

    private boolean onScaleTouch(int corner, MotionEvent event) {
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                activeCorner = corner;
                reportScale(corner, event, false);
                return true;
            case MotionEvent.ACTION_MOVE:
                if (activeCorner == corner) reportScale(corner, event, false);
                return true;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                if (activeCorner == corner) reportScale(corner, event, true);
                activeCorner = -1;
                return true;
            default:
                return true;
        }
    }

    private void reportDrag(MotionEvent event, boolean finished) {
        if (listener != null) listener.onDrag(event.getRawX(), event.getRawY(), finished);
    }

    private void reportScale(int corner, MotionEvent event, boolean finished) {
        if (listener != null) {
            listener.onScale(corner, event.getRawX(), event.getRawY(), finished);
        }
    }
}
