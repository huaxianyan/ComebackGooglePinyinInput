package com.google.android.inputmethod.pinyin;

import android.app.Dialog;
import android.graphics.Rect;
import android.inputmethodservice.InputMethodService;
import android.util.Log;
import android.view.View;
import android.view.Window;

/**
 * Research only, never merged into the product.
 *
 * <p>Answers one question before the floating keyboard work goes any further: when the IME
 * reports that it covers nothing, does the app stop making room for it, and does a touch region
 * outside the keyboard still reach the app?
 *
 * <p>The first attempt reported the IME window's own height and the window collapsed to that
 * height, which is the finding this version is built on: the reported insets feed back into the
 * window size, so the window has to be pushed to full height first and held there. The screen
 * height is therefore reported instead of the window height, and the original InputView is
 * stretched to fill the window with the keyboard still laid out at the bottom.
 *
 * <p>The touchable region follows the keyboard frame once it is on screen. Before that first
 * layout pass it falls back to the bottom strip so typing does not go dead during the one pass
 * where the window is still growing.
 */
public final class FloatingKeyboardProbe {

    private static final String TAG = "FloatingProbe";

    private FloatingKeyboardProbe() {}

    /** Called from GoogleInputMethodService.onComputeInsets after the original calculation. */
    public static void apply(InputMethodService service, InputMethodService.Insets outInsets) {
        Window window = windowOf(service);
        if (window == null) {
            Log.w(TAG, "no window");
            return;
        }
        View decor = window.getDecorView();
        if (decor == null) {
            Log.w(TAG, "no decor");
            return;
        }
        int screenHeight = decor.getContext().getResources().getDisplayMetrics().heightPixels;
        int screenWidth = decor.getContext().getResources().getDisplayMetrics().widthPixels;
        if (screenHeight <= 0 || screenWidth <= 0) {
            Log.w(TAG, "unknown screen size");
            return;
        }

        // Reporting the screen height is what makes the window grow to full height. Reporting the
        // window's own height instead makes it shrink to that, because the system derives the IME
        // window size from the reported coverage.
        outInsets.contentTopInsets = screenHeight;
        outInsets.visibleTopInsets = screenHeight;
        outInsets.touchableInsets = InputMethodService.Insets.TOUCHABLE_INSETS_REGION;

        Rect region = new Rect();
        View area = keyboardArea(decor);
        boolean laidOut = false;
        if (area != null && area.getGlobalVisibleRect(region) && !region.isEmpty()) {
            outInsets.touchableRegion.set(region);
            laidOut = true;
        } else {
            int strip = screenHeight - screenHeight / 3;
            region.set(0, strip, screenWidth, screenHeight);
            outInsets.touchableRegion.set(region);
        }

        Log.i(TAG, "decor=" + decor.getWidth() + "x" + decor.getHeight()
                + " screen=" + screenWidth + "x" + screenHeight
                + " contentTopInsets=" + outInsets.contentTopInsets
                + " keyboardLaidOut=" + laidOut
                + " region=" + region.toShortString());
    }

    private static Window windowOf(InputMethodService service) {
        Dialog dialog = service.getWindow();
        return dialog == null ? null : dialog.getWindow();
    }

    private static View keyboardArea(View decor) {
        String packageName = decor.getContext().getPackageName();
        int id = decor.getResources().getIdentifier("keyboard_area", "id", packageName);
        if (id == 0) {
            Log.w(TAG, "id keyboard_area not found in " + packageName);
            return null;
        }
        return decor.findViewById(id);
    }
}
