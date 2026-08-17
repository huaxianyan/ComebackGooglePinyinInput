package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.text.InputType;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;

import com.google.android.apps.inputmethod.libs.framework.keyboard.SoftKeyboardView;

/** Keeps the extra password digit row scoped to real password editors. */
public final class PasswordBodyView extends SoftKeyboardView {
    private static final int KEYBOARD_HEADER_HEIGHT = 0x7f0d00a9;

    private static PasswordBodyView attachedView;
    private static boolean passwordEditor;

    private int originalHeight;
    private boolean expanded;

    public PasswordBodyView(Context context) {
        super(context);
    }

    public PasswordBodyView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public static void setEditorInfo(EditorInfo editorInfo) {
        passwordEditor = isPasswordEditor(editorInfo);
        if (attachedView != null) {
            attachedView.updateHeight();
        }
    }

    private static boolean isPasswordEditor(EditorInfo editorInfo) {
        if (editorInfo == null) {
            return false;
        }
        int inputClass = editorInfo.inputType & InputType.TYPE_MASK_CLASS;
        int variation = editorInfo.inputType & InputType.TYPE_MASK_VARIATION;
        if (inputClass == InputType.TYPE_CLASS_TEXT) {
            return variation == InputType.TYPE_TEXT_VARIATION_PASSWORD
                    || variation == InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD
                    || variation == InputType.TYPE_TEXT_VARIATION_WEB_PASSWORD;
        }
        return inputClass == InputType.TYPE_CLASS_NUMBER
                && variation == InputType.TYPE_NUMBER_VARIATION_PASSWORD;
    }

    @Override protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        attachedView = this;
        updateHeight();
    }

    @Override protected void onDetachedFromWindow() {
        collapse();
        if (attachedView == this) {
            attachedView = null;
        }
        super.onDetachedFromWindow();
    }

    @Override protected void onVisibilityChanged(View changedView, int visibility) {
        super.onVisibilityChanged(changedView, visibility);
        updateHeight();
    }

    @Override protected void onWindowVisibilityChanged(int visibility) {
        super.onWindowVisibilityChanged(visibility);
        updateHeight();
    }

    private void updateHeight() {
        if (!passwordEditor || !isShown() || getWindowVisibility() != View.VISIBLE) {
            collapse();
            return;
        }
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

    private void collapse() {
        if (!expanded) {
            return;
        }
        ViewGroup.LayoutParams params = getLayoutParams();
        if (params != null) {
            params.height = originalHeight;
            setLayoutParams(params);
        }
        expanded = false;
    }
}
