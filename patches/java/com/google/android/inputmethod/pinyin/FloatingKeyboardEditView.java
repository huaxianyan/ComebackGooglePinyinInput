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
 * <p>The overlay is laid out on the card rather than the whole window, so the app behind the card
 * is not dimmed. The border frame fills the overlay, and the action buttons keep the stock
 * layout's own arrangement.
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
    /** Only one gesture at a time: a second finger would otherwise overwrite the anchor. */
    private int activePointer = -1;

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
    void fitFrame() {
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
                if (activePointer != -1 || activeCorner != -1) return true;
                activePointer = event.getPointerId(0);
                dragging = true;
                reportDrag(event, 0, false);
                return true;
            case MotionEvent.ACTION_MOVE: {
                if (!dragging) return true;
                int index = event.findPointerIndex(activePointer);
                if (index >= 0) reportDrag(event, index, false);
                return true;
            }
            case MotionEvent.ACTION_POINTER_DOWN:
                // A second finger during a drag is ignored rather than started as a scale.
                return true;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                return endDrag(event);
            default:
                return true;
        }
    }

    private boolean endDrag(MotionEvent event) {
        if (!dragging) return true;
        int index = event.findPointerIndex(activePointer);
        if (index >= 0) reportDrag(event, index, true);
        dragging = false;
        activePointer = -1;
        return true;
    }

    private boolean onScaleTouch(int corner, MotionEvent event) {
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                // Any gesture already in flight keeps its corner; a second finger must not
                // silently re-anchor the scale on a different corner.
                if (activePointer != -1 || activeCorner != -1 || dragging) return true;
                activePointer = event.getPointerId(0);
                activeCorner = corner;
                reportScale(corner, event, 0, false);
                return true;
            case MotionEvent.ACTION_MOVE: {
                if (activeCorner != corner) return true;
                int index = event.findPointerIndex(activePointer);
                if (index >= 0) reportScale(corner, event, index, false);
                return true;
            }
            case MotionEvent.ACTION_POINTER_DOWN:
                return true;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                if (activeCorner != corner) return true;
                int index = event.findPointerIndex(activePointer);
                if (index >= 0) reportScale(corner, event, index, true);
                else if (event.getActionMasked() == MotionEvent.ACTION_CANCEL) {
                    // The stream was cancelled with the tracking pointer already gone; the
                    // compat side still has to be told the gesture is over.
                    reportScale(corner, event, 0, true);
                }
                activeCorner = -1;
                activePointer = -1;
                return true;
            default:
                return true;
        }
    }

    private void reportDrag(MotionEvent event, int index, boolean finished) {
        if (listener == null) return;
        listener.onDrag(rawX(event, index), rawY(event, index), finished);
    }

    private void reportScale(int corner, MotionEvent event, int index, boolean finished) {
        if (listener == null) return;
        listener.onScale(corner, rawX(event, index), rawY(event, index), finished);
    }

    /** Raw position of one pointer. For a single-pointer stream this equals getRawX/getRawY. */
    private float rawX(MotionEvent event, int index) {
        return event.getX(index) + (event.getRawX() - event.getX());
    }

    private float rawY(MotionEvent event, int index) {
        return event.getY(index) + (event.getRawY() - event.getY());
    }
}
