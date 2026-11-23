package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.inputmethodservice.InputMethodService;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.Window;

/**
 * Floating keyboard: the IME reports that it covers nothing and paints a scaled card at the
 * bottom, so the app keeps its full layout and the keyboard sits on top of it.
 *
 * <p>The reported insets feed back into the window size on this platform: reporting the window's
 * own height makes the window collapse to it. The window is therefore held at full screen height
 * by reporting the screen height, which also lets {@code InputView} stretch itself and keep
 * {@code keyboard_area} at the bottom through its own layout parameters.
 *
 * <p>Scaling is a view transform rather than a relayout. The native key rows size themselves from
 * fixed heights in the theme, so a narrower container would produce narrow keys at the same row
 * height. Scaling both axes keeps the proportions and keeps touch coordinates correct, because
 * the framework inverts the transform before dispatching events.
 */
public final class FloatingKeyboardCompat {

    private static final String TAG = "FloatingKeyboard";

    private static final String PREFERENCES = "floating_keyboard_preferences";
    private static final String KEY_ENABLED = "enabled";
    private static final String KEY_SCALE = "scale";

    /** Tablets default to the card, phones keep the docked keyboard until the user asks. */
    private static final int TABLET_SMALLEST_WIDTH_DP = 600;
    private static final float DEFAULT_SCALE = 0.72f;
    private static final float MIN_SCALE = 0.40f;
    private static final float MAX_SCALE = 1.0f;

    /**
     * Scale currently applied to the keyboard view. {@code setScaleX} requests a layout pass, and
     * that pass calls back into {@link #applyInsets}, so the value is compared before writing.
     */
    private static float appliedScale = -1f;

    private FloatingKeyboardCompat() {}

    /**
     * Off until the layout stages are finished. Tablets will get it on by default once dragging
     * and resizing exist, so the card is never the only thing a tablet user can reach.
     */
    public static boolean isEnabled(Context context) {
        return preferences(context).getBoolean(KEY_ENABLED, false);
    }

    public static void setEnabled(Context context, boolean enabled) {
        preferences(context).edit().putBoolean(KEY_ENABLED, enabled).apply();
        appliedScale = -1f;
    }

    static boolean isTablet(Context context) {
        Configuration configuration = context.getResources().getConfiguration();
        return configuration.smallestScreenWidthDp >= TABLET_SMALLEST_WIDTH_DP;
    }

    public static float scale(Context context) {
        float value = preferences(context).getFloat(KEY_SCALE, DEFAULT_SCALE);
        return Math.max(MIN_SCALE, Math.min(MAX_SCALE, value));
    }

    public static void setScale(Context context, float value) {
        float clamped = Math.max(MIN_SCALE, Math.min(MAX_SCALE, value));
        preferences(context).edit().putFloat(KEY_SCALE, clamped).apply();
        appliedScale = -1f;
    }

    private static SharedPreferences preferences(Context context) {
        return context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE);
    }

    /**
     * Called from {@code GoogleInputMethodService.onComputeInsets} after the original calculation.
     * Leaves the original insets untouched when the card is off.
     */
    public static void applyInsets(InputMethodService service, InputMethodService.Insets outInsets) {
        if (!isEnabled(service)) {
            resetScale(service);
            return;
        }
        Window window = serviceWindow(service);
        if (window == null) return;
        View decor = window.getDecorView();
        if (decor == null) return;

        DisplayMetrics metrics = decor.getContext().getResources().getDisplayMetrics();
        int screenWidth = metrics.widthPixels;
        int screenHeight = metrics.heightPixels;
        if (screenWidth <= 0 || screenHeight <= 0) return;

        outInsets.contentTopInsets = screenHeight;
        outInsets.visibleTopInsets = screenHeight;
        outInsets.touchableInsets = InputMethodService.Insets.TOUCHABLE_INSETS_REGION;

        float factor = scale(service);
        View area = findKeyboardArea(decor);
        Rect region = new Rect();
        if (area != null && applyScale(area, factor) && visualRegion(area, region)) {
            outInsets.touchableRegion.set(region);
        } else {
            // The first pass runs before the keyboard frame is laid out. A strip covering the
            // bottom third keeps typing alive for that single pass instead of going dead.
            int top = screenHeight - screenHeight / 3;
            region.set(0, top, screenWidth, screenHeight);
            outInsets.touchableRegion.set(region);
        }
        Log.i(TAG, "scale=" + factor + " region=" + region.toShortString()
                + " screen=" + screenWidth + "x" + screenHeight);
    }

    /** Puts the keyboard back to its full size, otherwise the docked insets would clip a card. */
    private static void resetScale(InputMethodService service) {
        if (appliedScale == 1f) return;
        appliedScale = 1f;
        Window window = serviceWindow(service);
        if (window == null) return;
        View decor = window.getDecorView();
        if (decor == null) return;
        View area = findKeyboardArea(decor);
        if (area == null) return;
        area.setScaleX(1f);
        area.setScaleY(1f);
    }

    /** Returns false when the view has no size yet, so the caller can fall back. */
    private static boolean applyScale(View area, float factor) {
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return false;
        if (appliedScale == factor) return true;
        appliedScale = factor;
        area.setPivotX(width / 2f);
        area.setPivotY(height);
        area.setScaleX(factor);
        area.setScaleY(factor);
        return true;
    }

    private static boolean visualRegion(View area, Rect out) {
        if (area.getWidth() <= 0 || area.getHeight() <= 0) return false;
        // getGlobalVisibleRect walks up through the parents, so the view transform is applied and
        // the rectangle matches what is on screen. Computing it by hand double-counts the offset,
        // because the reported location already includes the scale.
        if (!area.getGlobalVisibleRect(out)) return false;
        return !out.isEmpty();
    }

    private static Window serviceWindow(InputMethodService service) {
        android.app.Dialog dialog = service.getWindow();
        return dialog == null ? null : dialog.getWindow();
    }

    private static View findKeyboardArea(View decor) {
        String packageName = decor.getContext().getPackageName();
        int id = decor.getResources().getIdentifier("keyboard_area", "id", packageName);
        if (id == 0) {
            Log.w(TAG, "id keyboard_area not found in " + packageName);
            return null;
        }
        return decor.findViewById(id);
    }
}
