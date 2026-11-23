package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.inputmethodservice.InputMethodService;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.FrameLayout;

/**
 * Floating keyboard: the IME reports that it covers nothing and paints a scaled card, so the app
 * keeps its full layout and the keyboard sits on top of it.
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
 *
 * <p>The card position is stored as a fraction of the free range in each axis, separately per
 * orientation, so the same numbers survive a resolution or density change.
 */
public final class FloatingKeyboardCompat {

    private static final String TAG = "FloatingKeyboard";

    private static final String PREFERENCES = "floating_keyboard_preferences";
    private static final String KEY_ENABLED = "enabled";
    private static final String KEY_SCALE = "scale";
    private static final String KEY_X_FRACTION = "x_fraction_";
    private static final String KEY_Y_FRACTION = "y_fraction_";

    private static final int TABLET_SMALLEST_WIDTH_DP = 600;
    private static final float DEFAULT_SCALE = 0.72f;
    private static final float MIN_SCALE = 0.40f;
    private static final float MAX_SCALE = 1.0f;

    /** Drag handle height; also the gap it occupies between the card and the content above. */
    static final int HANDLE_HEIGHT_DP = 18;

    private static final float DEFAULT_X_FRACTION = 0.5f;
    private static final float DEFAULT_Y_FRACTION = 1f;
    /** Below the low threshold snaps left, above the high one snaps right, otherwise centred. */
    private static final float SNAP_LOW = 0.34f;
    private static final float SNAP_HIGH = 0.66f;
    /** Releasing near the bottom docks the card instead of leaving it hovering mid-screen. */
    private static final float DOCK_THRESHOLD = 0.80f;

    /**
     * Scale currently applied to the keyboard view. {@code setScaleX} requests a layout pass, and
     * that pass calls back into {@link #applyInsets}, so the value is compared before writing.
     */
    private static float appliedScale = -1f;
    /** The view the scale was applied to; the service rebuilds its views, and a stale value here
     *  would skip scaling the replacement. */
    private static View scaledView;
    private static final Rect lastRegion = new Rect();

    private static FloatingKeyboardHandle handle;
    private static boolean dragging;
    private static float dragDownRawX;
    private static float dragDownRawY;
    private static float dragStartX;
    private static float dragStartY;

    private FloatingKeyboardCompat() {}

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

        final float factor = scale(service);
        View area = findKeyboardArea(decor);
        Rect region = new Rect();
        if (area != null && applyScale(area, factor)) {
            // Position before measuring the region: the translation is part of the view matrix
            // that getGlobalVisibleRect applies, so ordering them the other way reports the
            // card where it used to be.
            applyPosition(decor, area, factor);
            if (visualRegion(area, region)) {
                // Reserve the handle strip here rather than asking the handle for its rectangle:
                // the insets pass must not depend on view state that is updated a frame later.
                int handleHeight = Math.round(HANDLE_HEIGHT_DP * density(area));
                region.set(region.left, region.top - handleHeight, region.right, region.bottom);
            }
        }
        if (region.isEmpty()) {
            // The first pass runs before the keyboard frame is laid out. A strip covering the
            // bottom third keeps typing alive for that single pass instead of going dead.
            int top = screenHeight - screenHeight / 3;
            region.set(0, top, screenWidth, screenHeight);
        }
        // The region is interpreted in window coordinates, while getGlobalVisibleRect reports
        // screen coordinates. On a phone the status bar offset is 172 px, which would shift the
        // whole region off the keyboard and let touches fall through to the app.
        int[] decorLocation = new int[2];
        decor.getLocationOnScreen(decorLocation);
        region.offset(-decorLocation[0], -decorLocation[1]);
        outInsets.touchableRegion.set(region);
        // Only when it changes: this runs on every insets pass and would otherwise fill the log.
        if (!region.equals(lastRegion)) {
            lastRegion.set(region);
            Log.i(TAG, "scale=" + factor + " region=" + region.toShortString()
                    + " screen=" + screenWidth + "x" + screenHeight);
        }
        scheduleHandle(decor, area, factor);
    }

    /**
     * The handle is added on the next frame. Adding a view from inside
     * {@code onComputeInsets} makes the platform drop the touchable region it was just given,
     * which silently turns the card into a hole that passes touches through to the app.
     */
    private static void scheduleHandle(final View decor, final View area, final float factor) {
        if (area == null) return;
        decor.post(new Runnable() {
            @Override
            public void run() {
                if (!isEnabled(decor.getContext())) return;
                ensureHandle(decor, area, factor);
            }
        });
    }

    /** Puts everything back, otherwise the docked insets would clip a card or a stray handle. */
    private static void resetScale(InputMethodService service) {
        dragging = false;
        removeHandle();
        if (appliedScale == 1f && scaledView == null) return;
        appliedScale = 1f;
        scaledView = null;
        Window window = serviceWindow(service);
        if (window == null) return;
        View decor = window.getDecorView();
        if (decor == null) return;
        View area = findKeyboardArea(decor);
        if (area == null) return;
        area.setScaleX(1f);
        area.setScaleY(1f);
        area.setTranslationX(0f);
        area.setTranslationY(0f);
    }

    /** Returns false when the view has no size yet, so the caller can fall back. */
    private static boolean applyScale(View area, float factor) {
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return false;
        if (appliedScale != factor || scaledView != area) {
            appliedScale = factor;
            scaledView = area;
            area.setPivotX(width / 2f);
            area.setPivotY(height);
            area.setScaleX(factor);
            area.setScaleY(factor);
        }
        return true;
    }

    /**
     * Turns the stored fractions into a translation. The untranslated card sits centred at the
     * bottom, so the fractions describe how far it has been pulled from there.
     */
    private static boolean applyPosition(View decor, View area, float factor) {
        if (dragging || factor <= 0f) return false;
        float[] range = freeRange(decor, area, factor);
        if (range == null) return false;
        float translateX = xFraction(decor.getContext()) * range[0] - (1f - factor) * decor.getWidth() / 2f;
        float translateY = (yFraction(decor.getContext()) - 1f) * range[1];
        boolean moved = area.getTranslationX() != translateX || area.getTranslationY() != translateY;
        if (area.getTranslationX() != translateX) area.setTranslationX(translateX);
        if (area.getTranslationY() != translateY) area.setTranslationY(translateY);
        return moved;
    }

    /** {free horizontal travel, free vertical travel} in pixels, or null before layout. */
    private static float[] freeRange(View decor, View area, float factor) {
        int width = decor.getWidth();
        int height = decor.getHeight();
        int areaWidth = area.getWidth();
        int areaHeight = area.getHeight();
        if (width <= 0 || height <= 0 || areaWidth <= 0 || areaHeight <= 0) return null;
        return new float[] {
                Math.max(1f, width - areaWidth * factor),
                Math.max(1f, height - areaHeight * factor),
        };
    }

    private static void ensureHandle(View decor, View area, float factor) {
        if (factor >= 1f) return;
        ViewGroup host = handleHost(decor, area);
        if (host == null) return;
        int handleHeight = Math.round(HANDLE_HEIGHT_DP * density(decor));
        if (handle == null || handle.getParent() != host) {
            removeHandle();
            handle = new FloatingKeyboardHandle(decor.getContext());
            handle.setLayoutParams(new FrameLayout.LayoutParams(0, handleHeight));
            host.addView(handle);
            handle.bringToFront();
            if (android.os.Build.VERSION.SDK_INT >= 21) {
                // The keyboard frame is a sibling; without a higher elevation it swallows the
                // touch.
                handle.setElevation(handleHeight);
            }
        }
        updateHandleBounds(host, area, handleHeight);
    }

    /**
     * The handle goes into the window content frame: it spans the screen, so the strip above the
     * card is not clipped. Elevation is raised in {@link #ensureHandle} so the keyboard frame,
     * which is a sibling covering the whole window, does not swallow the touch.
     */
    private static ViewGroup handleHost(View decor, View area) {
        View content = decor.findViewById(android.R.id.content);
        if (content instanceof ViewGroup) return (ViewGroup) content;
        return decor instanceof ViewGroup ? (ViewGroup) decor : null;
    }

    private static void updateHandleBounds(ViewGroup host, View area, int handleHeight) {
        if (handle == null) return;
        Rect card = new Rect();
        if (!area.getGlobalVisibleRect(card) || card.isEmpty()) return;
        int[] hostLocation = new int[2];
        host.getLocationOnScreen(hostLocation);
        int left = card.left - hostLocation[0];
        int top = card.top - hostLocation[1] - handleHeight;
        FrameLayout.LayoutParams params =
                handle.getLayoutParams() instanceof FrameLayout.LayoutParams
                        ? (FrameLayout.LayoutParams) handle.getLayoutParams()
                        : new FrameLayout.LayoutParams(card.width(), handleHeight);
        if (params.width == card.width() && params.height == handleHeight
                && params.leftMargin == left && params.topMargin == top) {
            return;
        }
        params.width = card.width();
        params.height = handleHeight;
        params.gravity = android.view.Gravity.TOP | android.view.Gravity.LEFT;
        // Margins instead of translation: a laid out position keeps the view matrix identity, so
        // hit testing uses the same rectangle that is drawn.
        params.leftMargin = left;
        params.topMargin = top;
        handle.setLayoutParams(params);
    }

    private static void moveHandle(View decor, View area) {
        if (handle == null) return;
        ViewGroup host = handleHost(decor, area);
        if (host == null || handle.getParent() != host) return;
        updateHandleBounds(host, area, Math.round(HANDLE_HEIGHT_DP * density(decor)));
    }

    private static void removeHandle() {
        if (handle == null) return;
        ViewGroup parent = handle.getParent() instanceof ViewGroup
                ? (ViewGroup) handle.getParent()
                : null;
        if (parent != null) parent.removeView(handle);
        handle = null;
    }

    private static boolean visualRegion(View area, Rect out) {
        if (area.getWidth() <= 0 || area.getHeight() <= 0) return false;
        // getGlobalVisibleRect walks up through the parents, so the view transform is applied and
        // the rectangle matches what is on screen. Computing it by hand double-counts the offset,
        // because the reported location already includes the scale.
        if (!area.getGlobalVisibleRect(out)) return false;
        return !out.isEmpty();
    }

    /** Returns true when the drag subsystem consumed the event. */
    public static boolean onHandleTouch(View view, MotionEvent event) {
        if (!(view.getParent() instanceof View)) return false;
        View decor = (View) view.getParent();
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN: {
                View area = findKeyboardArea(decor);
                if (area == null) return false;
                float factor = appliedScale > 0f ? appliedScale : scale(view.getContext());
                float[] range = freeRange(decor, area, factor);
                if (range == null) return false;
                dragging = true;
                dragDownRawX = event.getRawX();
                dragDownRawY = event.getRawY();
                dragStartX = fractionFromTranslation(area, decor, factor, range, true);
                dragStartY = fractionFromTranslation(area, decor, factor, range, false);
                return true;
            }
            case MotionEvent.ACTION_MOVE: {
                if (!dragging) return false;
                View area = findKeyboardArea(decor);
                if (area == null) return false;
                float factor = appliedScale > 0f ? appliedScale : scale(view.getContext());
                float[] range = freeRange(decor, area, factor);
                if (range == null) return false;
                float fractionX = clamp01(
                        dragStartX + (event.getRawX() - dragDownRawX) / range[0]);
                float fractionY = clamp01(
                        dragStartY + (event.getRawY() - dragDownRawY) / range[1]);
                area.setTranslationX(
                        fractionX * range[0] - (1f - factor) * decor.getWidth() / 2f);
                area.setTranslationY((fractionY - 1f) * range[1]);
                moveHandle(decor, area);
                return true;
            }
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL: {
                if (!dragging) return false;
                dragging = false;
                settle(view, decor);
                return true;
            }
            default:
                return false;
        }
    }

    /** Snaps to the nearest edge or centre, docks when released low, and stores the result. */
    private static void settle(View view, View decor) {
        View area = findKeyboardArea(decor);
        if (area == null) return;
        float factor = appliedScale > 0f ? appliedScale : scale(view.getContext());
        float[] range = freeRange(decor, area, factor);
        if (range == null) return;
        float fractionX = fractionFromTranslation(area, decor, factor, range, true);
        float fractionY = fractionFromTranslation(area, decor, factor, range, false);
        // Docking only applies when the card is brought back down from higher up. The card rests
        // at the bottom by default, so testing the released position alone would turn every
        // horizontal drag into a dock and make it impossible to move sideways.
        if (fractionY > DOCK_THRESHOLD && dragStartY < DOCK_THRESHOLD) {
            fractionY = 1f;
            fractionX = 0.5f;
        } else if (fractionX < SNAP_LOW) {
            fractionX = 0f;
        } else if (fractionX > SNAP_HIGH) {
            fractionX = 1f;
        } else {
            fractionX = 0.5f;
        }
        Context context = view.getContext();
        preferences(context).edit()
                .putFloat(KEY_X_FRACTION + orientation(context), fractionX)
                .putFloat(KEY_Y_FRACTION + orientation(context), fractionY)
                .apply();
        applyPosition(decor, area, factor);
        ensureHandle(decor, area, factor);
        // The touchable region is recomputed from the view tree, so this asks the window to
        // recalculate it with the card at its new place.
        decor.requestLayout();
    }

    private static float fractionFromTranslation(
            View area, View decor, float factor, float[] range, boolean horizontal) {
        if (horizontal) {
            return clamp01((area.getTranslationX() + (1f - factor) * decor.getWidth() / 2f)
                    / range[0]);
        }
        return clamp01(area.getTranslationY() / range[1] + 1f);
    }

    private static float xFraction(Context context) {
        return preferences(context)
                .getFloat(KEY_X_FRACTION + orientation(context), DEFAULT_X_FRACTION);
    }

    private static float yFraction(Context context) {
        return preferences(context)
                .getFloat(KEY_Y_FRACTION + orientation(context), DEFAULT_Y_FRACTION);
    }

    private static String orientation(Context context) {
        return context.getResources().getConfiguration().orientation
                        == Configuration.ORIENTATION_LANDSCAPE
                ? "landscape"
                : "portrait";
    }

    private static float clamp01(float value) {
        return Math.max(0f, Math.min(1f, value));
    }

    private static float density(View view) {
        return view.getResources().getDisplayMetrics().density;
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
