package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;

import com.google.android.apps.inputmethod.libs.framework.keyboard.SoftKeyboardView;

/** Keeps the original password key sizes while reserving a separate header row. */
public final class PasswordBodyView extends SoftKeyboardView {
    private static final int KEYBOARD_HEADER_HEIGHT = 0x7f0d00a9;

    private int originalHeight;
    private boolean expanded;

    public PasswordBodyView(Context context) {
        super(context);
    }

    public PasswordBodyView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (expanded) {
            return;
        }
        ViewGroup.LayoutParams params = getLayoutParams();
        if (params == null || params.height <= 0) {
            return;
        }
        originalHeight = params.height;
        params.height = originalHeight
                + getResources().getDimensionPixelSize(KEYBOARD_HEADER_HEIGHT);
        setLayoutParams(params);
        expanded = true;
    }

    @Override protected void onDetachedFromWindow() {
        if (expanded) {
            ViewGroup.LayoutParams params = getLayoutParams();
            if (params != null) {
                params.height = originalHeight;
                setLayoutParams(params);
            }
            expanded = false;
        }
        super.onDetachedFromWindow();
    }
}
