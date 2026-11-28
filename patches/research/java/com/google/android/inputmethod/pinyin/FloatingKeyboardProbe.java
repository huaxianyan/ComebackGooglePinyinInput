package com.google.android.inputmethod.pinyin;

import android.app.Dialog;
import android.inputmethodservice.InputMethodService;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.google.android.apps.inputmethod.libs.framework.core.GoogleInputMethodService;
import com.google.android.apps.inputmethod.libs.framework.core.IMetrics;
import com.google.android.apps.inputmethod.libs.framework.core.IPopupViewManager;
import com.google.android.apps.inputmethod.libs.framework.core.KeyboardEditingViewHelper;

/**
 * Research only, never shipped: try the stock keyboard-editing UI before replacing anything.
 *
 * <p>The stock editor is a popup view inflated by {@code IPopupViewManager}, driven by a {@code
 * KeyboardEditingViewHelper}. It is what one-handed mode uses. The aim here is to answer four
 * questions that decide whether the floating card can simply reuse it:
 *
 * <ol>
 *   <li>Can the helper be built and its popup inflated from the IME service?
 *   <li>Which theme does the inflated overlay resolve? The dim colour is read back from the actual
 *       view, not from the resource table, so the answer covers the current theme.
 *   <li>What does {@code a(View, int)} expect as its second argument? The anchor view is logged
 *       with the popup's frame afterwards, so the relationship can be compared across offsets.
 *   <li>Do the delegate callbacks fire, and with what values? They are logged as they arrive, so
 *       dragging and corner pinches can be read straight off logcat.
 * </ol>
 *
 * <p>The floating keyboard keeps working underneath: this probe forwards to the normal insets hook
 * so the card is present for the editor to attach to. It never moves or resizes anything.
 */
public final class FloatingKeyboardProbe implements KeyboardEditingViewHelper.Delegate {

    private static final String TAG = "FloatingProbe";
    private static KeyboardEditingViewHelper helper;
    private static View popup;


    private FloatingKeyboardProbe() {}

    /** Called from GoogleInputMethodService.onComputeInsets after the original calculation. */
    public static void apply(InputMethodService service, InputMethodService.Insets outInsets) {
        // The real card still has to be laid out for the editor to attach to.
        FloatingKeyboardCompat.applyInsets(service, outInsets);
        if (!(service instanceof GoogleInputMethodService)) {
            Log.w(TAG, "service is " + service.getClass().getName());
            return;
        }
        GoogleInputMethodService ime = (GoogleInputMethodService) service;
        Window window = windowOf(service);
        View decor = window == null ? null : window.getDecorView();
        if (decor == null) return;
        if (!decor.isLaidOut() || decor.getWidth() == 0 || decor.getHeight() == 0) return;
        if (!decor.isAttachedToWindow()) return;
        // The first insets pass happens while the window is still 126 px tall; the editor must wait
        // until the floating card has grown it, otherwise the popup inflates into a window that no
        // longer matches its own geometry.
        int screenHeight = decor.getResources().getDisplayMetrics().heightPixels;
        if (decor.getHeight() < screenHeight * 3 / 4) return;

        try {
            if (helper == null) {
                IPopupViewManager popupManager = ime.getPopupViewManager();
                Log.i(TAG, "popupManager=" + (popupManager == null ? "null"
                        : popupManager.getClass().getName()));
                if (popupManager == null) return;
                IMetrics metrics = ime.getMetrics();
                helper = new KeyboardEditingViewHelper(ime, new FloatingKeyboardProbe(), metrics);
                Log.i(TAG, "metrics=" + (metrics == null ? "null" : metrics.getClass().getName()));
                helper.a = popupManager;
                Log.i(TAG, "helper created; showing the stock editor");
                showEditor(ime, decor);
            } else if (popup != null) {
                int[] location = new int[2];
                popup.getLocationOnScreen(location);
                Log.i(TAG, "editor frame " + popup.getWidth() + "x" + popup.getHeight()
                        + " at " + location[0] + "," + location[1]);
            }
        } catch (Throwable error) {
            Log.e(TAG, "stock editor failed", error);
        }
    }

    /** Inflates the stock editor and prints what its overlay resolved to. */
    private static void showEditor(GoogleInputMethodService ime, View decor) {
        // The stock caller anchors on the keyboard holder, but that view is not the one the
        // floating card scales and moves. Anchor on the card itself so the frame follows it.
        final View anchor = decor.findViewById(decor.getResources().getIdentifier(
                "keyboard_area", "id", ime.getPackageName()));
        if (anchor == null) {
            Log.w(TAG, "keyboard_area missing, cannot anchor the editor");
            return;
        }
        // The stock caller passes the keyboard's top offset. Try that first; the popup's frame is
        // logged on the next pass so the relationship can be checked against the value.
        final int offset = anchor.getTop();
        // The editor's size comes from the anchor's visible rect, which is still empty during the
        // first insets pass. Wait a frame so the card has been laid out.
        decor.post(new Runnable() {
            @Override
            public void run() {
                try {
                    helper.a(anchor, offset);
                    Log.i(TAG, "helper.a(anchor=" + anchor.getClass().getSimpleName()
                            + " " + anchor.getWidth() + "x" + anchor.getHeight()
                            + ", offset=" + offset + ") called");
                    inspectEditor(anchor.getRootView());
                } catch (Throwable error) {
                    Log.e(TAG, "stock editor failed", error);
                }
            }
        });
    }

    /** Reads the overlay's real background colour and frame once the popup is attached. */
    private static void inspectEditor(View root) {
        View overlay = findByName(root, "keyboard_editing_overlay");
        if (overlay == null) {
            Log.w(TAG, "no overlay found in the whole tree");
            if (root instanceof ViewGroup) dump((ViewGroup) root, 0);
            return;
        }
        popup = overlay;
        Object background = overlay.getBackground();
        Log.i(TAG, "overlay=" + overlay.getClass().getName()
                + " " + overlay.getWidth() + "x" + overlay.getHeight()
                + " alpha=" + overlay.getAlpha()
                + " background=" + background);
        if (background instanceof android.graphics.drawable.ColorDrawable) {
            int color = ((android.graphics.drawable.ColorDrawable) background).getColor();
            Log.i(TAG, "overlay colour #" + Integer.toHexString(color));
        }
    }

    private static View findByName(View root, String name) {
        if (root.getId() != View.NO_ID) {
            try {
                if (name.equals(root.getResources().getResourceEntryName(root.getId()))) {
                    return root;
                }
            } catch (Throwable ignored) {
            }
        }
        if (root instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) root;
            for (int i = 0; i < group.getChildCount(); i++) {
                View found = findByName(group.getChildAt(i), name);
                if (found != null) return found;
            }
        }
        return null;
    }

    private static void dump(ViewGroup root, int depth) {
        String indent = new String(new char[depth * 2]).replace('\0', ' ');
        for (int i = 0; i < root.getChildCount(); i++) {
            View child = root.getChildAt(i);
            String id = "";
            if (child.getId() != View.NO_ID) {
                try {
                    id = child.getResources().getResourceEntryName(child.getId());
                } catch (Throwable ignored) {
                }
            }
            Log.i(TAG, indent + child.getClass().getSimpleName() + " " + id
                    + " " + child.getWidth() + "x" + child.getHeight());
            if (child instanceof ViewGroup && depth < 4) dump((ViewGroup) child, depth + 1);
        }
    }

    private static Window windowOf(InputMethodService service) {
        Dialog dialog = service.getWindow();
        return dialog == null ? null : dialog.getWindow();
    }

    @Override
    public void updateKeyboardPosition(int x, int y) {
        Log.i(TAG, "updateKeyboardPosition x=" + x + " y=" + y);
    }

    @Override
    public void updateKeyboardScale(int x, int y, float factor) {
        Log.i(TAG, "updateKeyboardScale x=" + x + " y=" + y + " factor=" + factor);
    }

    @Override
    public void resetKeyboard() {
        Log.i(TAG, "resetKeyboard");
    }

    @Override
    public void onExitEditingKeyboard() {
        Log.i(TAG, "onExitEditingKeyboard");
        if (helper != null) helper.a();
        popup = null;
    }
}
