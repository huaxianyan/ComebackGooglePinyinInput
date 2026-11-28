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
    private static final String KEY_IDLE_FADE = "idle_fade";
    private static final String KEY_X_FRACTION = "x_fraction_";
    private static final String KEY_Y_FRACTION = "y_fraction_";

    private static final int TABLET_SMALLEST_WIDTH_DP = 600;
    private static final float DEFAULT_SCALE = 0.72f;
    private static final float MIN_SCALE = 0.50f;
    private static final float MAX_SCALE = 0.92f;

    /** Touch strip of the drag handle, measured up from the card's bottom edge. */
    static final int HANDLE_HEIGHT_DP = 20;
    /**
     * Empty strip added below the key rows while the card is floating. The last key row reaches the
     * card's bottom edge, so a handle drawn there would sit on the space bar; the gutter keeps the
     * two apart without changing any key.
     */
    static final int HANDLE_GUTTER_DP = 34;

    private static final float DEFAULT_X_FRACTION = 0.5f;
    private static final float DEFAULT_Y_FRACTION = 1f;
    /** Releasing near the bottom docks the card instead of leaving it hovering mid-screen. */
    /** Hold this long on the handle before it lets go and starts following the finger. */
    private static final long DRAG_LONG_PRESS_MS = 380L;
    /** Pending long press; non-null only between a touch down and its resolution. */
    private static Runnable pendingLongPress;
    /** True while the finger is down but the press has not become a drag yet. */
    private static boolean pendingDrag;
    private static float downRawX;
    private static float downRawY;
    private static int touchSlop = -1;
    /**
     * Releasing this close to the bottom row docks the card. Kept tight so a normal drag never
     * gets pulled down; the card otherwise stays wherever it was dropped.
     */
    private static final float DOCK_THRESHOLD = 0.92f;
    /** How long the card stays fully opaque after the last touch. */
    private static final long IDLE_FADE_DELAY_MS = 5000L;
    /** Alpha the card drops to while idle, so the app behind it stays readable. */
    private static final float IDLE_ALPHA = 0.5f;
    /** Second press must follow the first within this to count as a double tap. */
    private static final long DOUBLE_TAP_MS = 320L;
    /** How long the second press has to be held before edit mode opens. */
    private static final long EDIT_HOLD_MS = 300L;
    /** Fade out gently; it is a background event. */
    private static final long IDLE_FADE_OUT_MS = 320L;
    /** Come back quickly, so the first touch never feels laggy. */
    private static final long IDLE_WAKE_MS = 120L;

    /**
     * Scale currently applied to the keyboard view. {@code setScaleX} requests a layout pass, and
     * that pass calls back into {@link #applyInsets}, so the value is compared before writing.
     */
    private static float appliedScale = -1f;
    /**
     * The card's own shadow ring. It is a child of the card, so the card's transform carries it.
     */
    private static FloatingCardShadow cardShadow;
    /**
     * Re-reads the card's geometry before every frame. Insets only arrive on their own schedule, so
     * a corner drag changed the card's scale while the shadow kept the rectangle from the last
     * insets pass and only caught up on release.
     */
    private static android.view.ViewTreeObserver.OnPreDrawListener cardShadowSync;
    private static View cardShadowArea;
    /** The view the scale was applied to; the service rebuilds its views, and a stale value here
     *  would skip scaling the replacement. */
    private static View scaledView;    private static final Rect lastRegion = new Rect();

    private static FloatingKeyboardHandle handle;
    /** Area whose function layer was last sampled for the handle colour. */
    private static View handleColorSource;
    private static FloatingKeyboardEditView editOverlay;
    /** True while the card is in edit mode: keys frozen, whole card draggable. */
    private static boolean editing;
    /** Time of the last lift inside the drag handle, used for the double tap. */
    private static long lastHandleUp;
    private static boolean armingEdit;
    /** True while a corner square is held; the placement belongs to the finger until release. */
    private static boolean scaling;
    private static float scaleStartFactor;
    private static float scaleStartTx;
    private static float scaleStartTy;
    /** Screen coordinates of the corner that stays put, and its offset inside the view. */
    private static float scaleAnchorX;
    private static float scaleAnchorY;
    private static float scaleAnchorOffX;
    private static float scaleAnchorOffY;
    private static float scaleStartDistance;
    /** Card watched for idleness; null while docked. */
    private static View idleArea;
    private static long lastAccessPointPost;

    
    private static View watchedDecor;

    private static long lastAccessPointScan;

    private static final android.view.ViewTreeObserver.OnGlobalLayoutListener layoutListener =
            new android.view.ViewTreeObserver.OnGlobalLayoutListener() {
                @Override
                public void onGlobalLayout() {
                    // The card rewrites the handle's bounds on every frame, so layout fires
                    // constantly. A toolbar rebuild does not happen that often; half a second is
                    // plenty and keeps the tree walk off the per-frame path.
                    long now = android.os.SystemClock.uptimeMillis();
                    if (now - lastAccessPointScan < 500L) return;
                    lastAccessPointScan = now;
                    View decor = watchedDecor;
                    if (decor != null) requestAccessPointVisibility(decor, true);
                }
            };
    /**
     * Transparent view covering the window that reports the first touch of every gesture. The key
     * rows consume their own touches, so a listener on the keyboard frame never fires.
     */
    private static View idleProbe;
    /** The area the current idle probe's listener was bound to. */
    private static View idleProbeArea;
    private static boolean idleScheduled;
    private static final android.os.Handler idleHandler =
            new android.os.Handler(android.os.Looper.getMainLooper());
    private static final Runnable fadeOut = new Runnable() {
        @Override
        public void run() {
            idleScheduled = false;
            if (dragging || scaling || editing || idleArea == null) return;
            animateIdleAlpha(IDLE_ALPHA, IDLE_FADE_OUT_MS);
        }
    };
    /** Bottom padding {@code keyboard_area} had before the gutter was applied; -1 until read. */
    private static int baseBottomPadding = -1;
    /** The InputView's own elevation before the floating card suppressed it. */
    private static float baseInputElevation = -1f;
    private static boolean dragging;
    private static float dragDownRawX;
    private static float dragDownRawY;
    private static float dragStartX;
    private static float dragStartY;

    private FloatingKeyboardCompat() {}

    public static boolean isEnabled(Context context) {
        return preferences(context).getBoolean(KEY_ENABLED, false);
    }

    /** Kept separate from {@link #isEnabled}: switching the card off must not forget this choice. */
    static boolean idleFadeEnabled(Context context) {
        return preferences(context).getBoolean(KEY_IDLE_FADE, false);
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
            unwatchAccessPoints();
            requestAccessPointVisibility(service, false);
            return;
        }
        Window window = serviceWindow(service);
        if (window == null) return;
        View decor = window.getDecorView();
        if (decor == null) return;
        // The toolbar is built lazily and rebuilt when it expands, so a single pass at insets
        // time misses the buttons. Watching layout catches every rebuild.
        watchAccessPoints(decor);
        requestAccessPointVisibility(decor, true);

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
            // The stock InputView has an outline provider and elevation, and its drop shadow is
            // the band below the card. That is a view-level shadow, not the window's surface
            // shadow, so it comes off without resizing the window or touching the keyboard
            // layout. Clearing the decor's elevation earlier never reached this view.
            if (area.getParent() instanceof View) {
                View inputView = (View) area.getParent();
                if (inputView.getElevation() != 0f) {
                    if (baseInputElevation < 0f) baseInputElevation = inputView.getElevation();
                    inputView.setElevation(0f);
                }
            }
            // The handle sits inside the card's bottom edge, so the card rectangle already covers
            // it; the region needs no extra strip.
            visualRegion(area, region);
            ensureCardShadow(area, factor);
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
        // The fade switch can be flipped while the keyboard is away, and nothing would then
        // reschedule the idle timer. Check on every insets pass so the card comes back to full
        // opacity as soon as the switch is off, whether it was faded out or mid-fade.
        if (!idleFadeEnabled(service)) {
            idleScheduled = false;
            idleHandler.removeCallbacks(fadeOut);
            // Restore directly, not with an animation: this runs on every insets pass, and
            // restarting the animator each frame would never let it reach full opacity.
            restoreOpaque();
        }
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
                if (!isEnabled(decor.getContext())) {
                    dropFloatingChrome();
                    return;
                }
                ensureHandle(decor, area, factor);
            }
        });
    }

    /**
     * Takes down everything floating-only: edit overlay, handle, idle probe.
     *
     * <p>Edit mode belongs to the floating card, so switching floating off ends it. The insets
     * path already goes through {@link #resetScale}, but a layout pass that gives up early
     * would otherwise leave an edit overlay and a handle behind.
     */
    private static void dropFloatingChrome() {
        editing = false;
        dragging = false;
        scaling = false;
        armingEdit = false;
        idleHandler.removeCallbacks(enterEditRunnable);
        removeEditOverlay();
        removeHandle();
        removeIdleProbe();
        restoreInputElevation();
        removeCardShadow();
    }

    /** Restores the elevation the docked InputView had before the floating card suppressed it. */
    private static void restoreInputElevation() {
        if (baseInputElevation < 0f) return;
        View area = scaledView != null ? scaledView : cardShadowArea;
        if (area != null && area.getParent() instanceof View) {
            ((View) area.getParent()).setElevation(baseInputElevation);
        }
        baseInputElevation = -1f;
    }

    /** Puts everything back, otherwise the docked insets would clip a card or a stray handle. */
    private static void resetScale(InputMethodService service) {
        dragging = false;
        scaling = false;
        editing = false;
        armingEdit = false;
        idleHandler.removeCallbacks(enterEditRunnable);
        removeHandle();
        removeEditOverlay();
        removeIdleProbe();
        // Put the docked keyboard's own shadow back, and drop the floating one with its pre-draw
        // listener; otherwise the docked keyboard keeps the flat look and an extra per-frame pass.
        restoreInputElevation();
        removeCardShadow();
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
        applyGutter(area, false);
    }

    /**
     * Hides the one-handed shortcut inside the toolbar the left chevron opens.
     *
     * <p>The two modes fight over the same insets, so switching one on already switches the other
     * off. Leaving that shortcut reachable inside the floating card would let the toolbar switch
     * one-handed mode back on behind the settings page's back, and the card would then be fighting
     * a docked layout for the same space.
     */
    /**
     * Queues the visibility change instead of doing it inside the insets pass.
     *
     * <p>Insets are computed while the window is being laid out, and a toolbar child flipping to
     * {@code GONE} there asks for another layout from inside the current one. On this keyboard that
     * recursion ended with the card never being rescaled at all. Posting moves the change to the
     * next message, and the flag keeps a queue from building up.
     */
    private static void requestAccessPointVisibility(InputMethodService service, boolean hidden) {
        Window window = serviceWindow(service);
        if (window == null) return;
        View decor = window.getDecorView();
        if (decor == null) return;
        requestAccessPointVisibility(decor, hidden);
    }

    private static void requestAccessPointVisibility(final View decor, final boolean hidden) {
        // Rate limit by timestamp, not by a pending flag: a post that never runs would leave the
        // flag stuck and the shortcuts hidden forever after the card is switched off.
        long now = android.os.SystemClock.uptimeMillis();
        if (now - lastAccessPointPost < 50L) return;
        lastAccessPointPost = now;
        decor.post(new Runnable() {
            @Override
            public void run() {
                try {
                    setOneHandedAccessPointHidden(decor, hidden);
                } catch (Throwable ignored) {
                    // Hiding a toolbar shortcut must never take the card down with it.
                }
            }
        });
    }

    private static void watchAccessPoints(final View decor) {
        if (watchedDecor == decor) return;
        unwatchAccessPoints();
        watchedDecor = decor;
        decor.getViewTreeObserver().addOnGlobalLayoutListener(layoutListener);
    }

    private static void unwatchAccessPoints() {
        final View decor = watchedDecor;
        if (decor == null) return;
        watchedDecor = null;
        decor.getViewTreeObserver().removeOnGlobalLayoutListener(layoutListener);
    }

    /**
     * The one-handed shortcuts answer to three different descriptions, and which one is present
     * depends on the current mode: left and right while docked, "exit" while one-handed. None of
     * them matches {@code one_handed_access_point_content_desc}, which labels the panel entry.
     */
    private static final String[] ONE_HANDED_LABELS = {
            "left_handed_content_desc",
            "right_handed_content_desc",
            "expand_keyboard_content_desc",
    };

    private static void setOneHandedAccessPointHidden(View decor, boolean hidden) {
        Context context = decor.getContext();
        String[] labels = new String[ONE_HANDED_LABELS.length];
        int found = 0;
        for (String name : ONE_HANDED_LABELS) {
            int id = context.getResources().getIdentifier(name, "string", context.getPackageName());
            if (id != 0) labels[found++] = context.getString(id);
        }
        if (found == 0) return;
        if (found < labels.length) {
            String[] trimmed = new String[found];
            System.arraycopy(labels, 0, trimmed, 0, found);
            labels = trimmed;
        }
        setAccessPointVisibility(decor, labels, hidden);
    }

    private static void setAccessPointVisibility(View view, String[] labels, boolean hidden) {
        CharSequence description = view.getContentDescription();
        if (description != null) {
            String text = description.toString();
            for (String label : labels) {
                if (label.equals(text)) {
                    int target = hidden ? View.GONE : View.VISIBLE;
                    if (view.getVisibility() != target) view.setVisibility(target);
                    break;
                }
            }
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                setAccessPointVisibility(group.getChildAt(i), labels, hidden);
            }
        }
    }

    private static void scheduleIdleFade(final View area) {
        idleArea = area;
        if (!idleFadeEnabled(area.getContext())) {
            // Turning the switch off must bring the card back even after the fade has finished:
            // by then idleScheduled is already false, so gating on it would leave the card dim.
            idleScheduled = false;
            idleHandler.removeCallbacks(fadeOut);
            restoreOpaque();
            return;
        }
        if (idleScheduled) return;
        idleScheduled = true;
        idleHandler.postDelayed(fadeOut, IDLE_FADE_DELAY_MS);
    }

    /** Restarts the countdown on user input. Layout passes only arm it once, never re-arm it. */
    private static void rearmIdleFade(final View area) {
        if (!idleFadeEnabled(area.getContext())) {
            // The switch is off: restore through the probe's own area, which is still valid even
            // when the cached idleArea points at a view that has since been replaced.
            idleScheduled = false;
            idleHandler.removeCallbacks(fadeOut);
            setOpaque(area);
            setOpaque(handle);
            return;
        }
        idleArea = area;
        idleScheduled = true;
        idleHandler.removeCallbacks(fadeOut);
        idleHandler.postDelayed(fadeOut, IDLE_FADE_DELAY_MS);
    }

    private static void wakeIdle() {
        idleScheduled = false;
        idleHandler.removeCallbacks(fadeOut);
        animateIdleAlpha(1f, IDLE_WAKE_MS);
    }

    /**
     * Cross-fades the card and the handle together. {@code animate()} cancels whatever was running
     * on that view, so a touch that lands mid-fade reverses it from wherever it got to.
     */
    private static void animateIdleAlpha(float target, long duration) {
        fadeAlpha(idleArea, target, duration);
        fadeAlpha(handle, target, duration);
    }

    /** Cancels any fade animation and puts the card back to full opacity at once. */
    private static void restoreOpaque() {
        setOpaque(idleArea);
        setOpaque(handle);
    }

    private static void setOpaque(View view) {
        if (view == null) return;
        view.animate().cancel();
        if (view.getAlpha() != 1f) view.setAlpha(1f);
    }

    private static void fadeAlpha(View view, float target, long duration) {
        if (view == null) return;
        if (view.getAlpha() == target) {
            view.animate().cancel();
            return;
        }
        view.animate().alpha(target).setDuration(duration).start();
    }

    /**
     * Watches the whole window for touches without taking any of them: returning {@code false}
     * makes the frame continue down the tree to the key that was actually hit.
     */
    private static void attachIdleProbe(ViewGroup host, final View area) {
        // Rebind when the card was replaced under the same host, otherwise the probe keeps
        // reporting touches for a view that is no longer on screen.
        if (idleProbe != null && idleProbe.getParent() == host && idleProbeArea == area) return;
        if (idleProbe != null && idleProbe.getParent() instanceof ViewGroup) {
            ((ViewGroup) idleProbe.getParent()).removeView(idleProbe);
        }
        View probe = new View(host.getContext());
        probe.setLayoutParams(new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        probe.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent event) {
                switch (event.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        wakeIdle();
                        // A non-clickable view never receives the UP of this gesture, so the
                        // countdown is restarted here instead of on release.
                        rearmIdleFade(area);
                        break;
                    case MotionEvent.ACTION_UP:
                    case MotionEvent.ACTION_CANCEL:
                        scheduleIdleFade(area);
                        break;
                    default:
                        break;
                }
                // Never consume: the keyboard below must receive the same stream.
                return false;
            }
        });
        host.addView(probe);
        idleProbe = probe;
        idleProbeArea = area;
    }

    private static void removeIdleProbe() {
        wakeIdle();
        if (idleArea != null) {
            idleArea.animate().cancel();
            idleArea.setAlpha(1f);
        }
        if (handle != null) {
            handle.animate().cancel();
            handle.setAlpha(1f);
        }
        if (idleProbe != null && idleProbe.getParent() instanceof ViewGroup) {
            ((ViewGroup) idleProbe.getParent()).removeView(idleProbe);
        }
        idleProbe = null;
        idleProbeArea = null;
        idleArea = null;
    }

    /**
     * Reserves (or releases) the strip the handle is drawn in. Written through
     * {@code setPadding} on the keyboard area rather than a child view so the key rows keep their
     * own heights and only move up by the gutter.
     */
    private static void applyGutter(View area, boolean enabled) {
        if (baseBottomPadding < 0) baseBottomPadding = area.getPaddingBottom();
        int target = baseBottomPadding;
        if (enabled) target += Math.round(HANDLE_GUTTER_DP * density(area));
        if (area.getPaddingBottom() == target) return;
        area.setPadding(
                area.getPaddingLeft(),
                area.getPaddingTop(),
                area.getPaddingRight(),
                target);
    }

    /** Returns false when the view has no size yet, so the caller can fall back. */
    private static boolean applyScale(View area, float factor) {
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return false;
        applyGutter(area, true);
        // Insets come in on every frame. While a corner is held the size belongs to the finger,
        // so a preference that has not been written yet must not pull the card back.
        if (scaling || editing) factor = appliedScale;
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
        if (dragging || scaling || editing || factor <= 0f) return false;
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
        // In edit mode the card is dragged directly; a handle would only get in the way.
        if (editing) return;
        if (factor >= 1f) {
            // Full width leaves nothing to drag or resize.
            removeHandle();
            return;
        }
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
        attachIdleProbe(host, area);
        scheduleIdleFade(area);
        updateHandleBounds(host, area, handleHeight);
        // The function keys can be unsized on the first pass, in which case the grey stays and the
        // sample is retried on the next layout instead of caching a miss.
        if (handle != null && handleColorSource != area) {
            int layerColor = functionLayerColor(area);
            if (layerColor != 0) {
                handle.setBarColor(layerColor);
                handleColorSource = area;
            }
        }
    }

    /**
     * Colour of the function layer: the row the hide-keyboard and simplified/traditional keys sit
     * on.
     *
     * <p>The handle belongs to that layer, not to the main key grid; the space key in particular is
     * painted from the keyboard palette and does not match. The keys are drawn by the keyboard
     * canvas rather than carrying a background of their own, so the colour is read back from a
     * rendered copy of the key, away from its centred glyph.
     */
    private static int functionLayerColor(View area) {
        // The function keys do not live under the keyboard view, and the keys themselves carry no
        // background of their own: their colour is whatever the function row paints underneath.
        // The colour is therefore read from the card's rendered pixels at the key's position.
        int[] ids = {0x7f0f0002, 0x7f0f0005, 0x7f0f004f, 0x7f0f0169,
                0x7f0f02b7, 0x7f0f0276, 0x7f0f022f};
        View root = area.getRootView();
        for (int id : ids) {
            View key = root == null ? null : root.findViewById(id);
            if (key == null || !key.isShown()) continue;
            // An empty row is the usual state of the access points bar; the next candidate still
            // describes the same layer.
            if (key.getWidth() <= 0 || key.getHeight() <= 0) continue;
            int color = functionRowInk(area, key);
            if (color != 0) return color;
        }
        return 0;
    }

    /**
     * Ink colour of the function row: the colour of the labels and arrows the hide-keyboard and
     * simplified/traditional keys are drawn with.
     *
     * <p>Their fill is a band behind the whole row and sits too close to the card to read as a
     * separate object, so the handle takes the ink instead. The row is drawn on the keyboard canvas
     * rather than by views of its own, so the colour is read back from the card's rendered pixels:
     * the band's dominant colour is its fill, and the sample furthest from it is the ink.
     */
    private static int functionRowInk(View area, View band) {
        int width = area.getWidth();
        int height = area.getHeight();
        float scale = area.getScaleX();
        if (width <= 0 || height <= 0 || scale <= 0f) return 0;
        try {
            int[] areaLocation = new int[2];
            int[] bandLocation = new int[2];
            area.getLocationOnScreen(areaLocation);
            band.getLocationOnScreen(bandLocation);
            // Window coordinates are scaled, the bitmap is not.
            int left = Math.round((bandLocation[0] - areaLocation[0]) / scale);
            int top = Math.round((bandLocation[1] - areaLocation[1]) / scale);
            int bandWidth = band.getWidth();
            int bandHeight = band.getHeight();

            android.graphics.Bitmap bitmap = android.graphics.Bitmap.createBitmap(
                    width, height, android.graphics.Bitmap.Config.ARGB_8888);
            area.draw(new android.graphics.Canvas(bitmap));
            int[] samples = new int[64];
            int count = 0;
            for (int row = 1; row <= 4 && count < samples.length; row++) {
                int y = top + bandHeight * row / 5;
                if (y < 0 || y >= height) continue;
                for (int column = 1; column <= 16 && count < samples.length; column++) {
                    int x = left + bandWidth * column / 17;
                    if (x < 0 || x >= width) continue;
                    samples[count++] = bitmap.getPixel(x, y);
                }
            }
            bitmap.recycle();
            if (count == 0) return 0;

            int fill = 0;
            int fillCount = 0;
            for (int i = 0; i < count; i++) {
                int matches = 0;
                for (int j = 0; j < count; j++) {
                    if (samples[j] == samples[i]) matches++;
                }
                if (matches > fillCount) {
                    fillCount = matches;
                    fill = samples[i];
                }
            }

            int ink = 0;
            int inkDistance = 0;
            for (int i = 0; i < count; i++) {
                int distance = distanceSquared(samples[i], fill);
                if (distance > inkDistance) {
                    inkDistance = distance;
                    ink = samples[i];
                }
            }
            // Nothing on the row stands out, so there is no ink to borrow.
            return inkDistance < 1600 ? 0 : ink;
        } catch (Throwable ignored) {
            return 0;
        }
    }

    private static int distanceSquared(int first, int second) {
        int red = android.graphics.Color.red(first) - android.graphics.Color.red(second);
        int green = android.graphics.Color.green(first) - android.graphics.Color.green(second);
        int blue = android.graphics.Color.blue(first) - android.graphics.Color.blue(second);
        return red * red + green * green + blue * blue;
    }

    /**
     * The handle goes into the window content frame: it spans the card's width, so the strip along
     * the card's bottom edge is not clipped. Elevation is raised in {@link #ensureHandle} so the
     * keyboard frame, which is a sibling covering the whole window, does not swallow the touch.
     */
    private static ViewGroup handleHost(View decor, View area) {
        View content = decor.findViewById(android.R.id.content);
        if (content instanceof ViewGroup) return (ViewGroup) content;
        return decor instanceof ViewGroup ? (ViewGroup) decor : null;
    }

    private static void removeCardShadow() {
        if (cardShadowSync != null && cardShadow != null
                && cardShadow.getParent() instanceof View) {
            ((View) cardShadow.getParent()).getViewTreeObserver()
                    .removeOnPreDrawListener(cardShadowSync);
        }
        cardShadowSync = null;
        cardShadowArea = null;
        if (cardShadow == null) return;
        ViewGroup parent = cardShadow.getParent() instanceof ViewGroup
                ? (ViewGroup) cardShadow.getParent()
                : null;
        if (parent != null) parent.removeView(cardShadow);
        cardShadow = null;
    }

    /**
     * Keeps the shadow band behind the card, at a fixed strength whatever the card's size.
     *
     * <p>The band is painted by an unscaled overlay that is told the card's current on-screen
     * rectangle. Mirroring the card's scale onto a shadow view would scale the blur with it, so the
     * shadow would look heavy on a large card and flat on a small one. A child of the card cannot be
     * used either: children take part in the card's measure pass, and since the band is sized from
     * the card, each round made both grow without bound.
     *
     * <p>The rectangle is refreshed from a pre-draw listener rather than only from the insets pass:
     * a corner drag changes the card's scale directly, without new insets, so the shadow would
     * otherwise keep a stale rectangle for the whole gesture and only adapt on release.
     */
    private static void ensureCardShadow(View area, float factor) {
        if (!(area.getParent() instanceof ViewGroup)) return;
        ViewGroup host = (ViewGroup) area.getParent();
        if (cardShadow == null || cardShadow.getParent() != host) {
            removeCardShadow();
            cardShadow = new FloatingCardShadow(area.getContext(), density(area));
            host.addView(cardShadow, 0, new FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
            cardShadow.setTranslationZ(-1f);
            cardShadowArea = area;
            cardShadowSync = new android.view.ViewTreeObserver.OnPreDrawListener() {
                @Override
                public boolean onPreDraw() {
                    syncCardShadow();
                    return true;
                }
            };
            host.getViewTreeObserver().addOnPreDrawListener(cardShadowSync);
        }
        syncCardShadow();
    }

    /** Places the band on the card's current rectangle. Safe to call every frame. */
    private static void syncCardShadow() {
        View area = cardShadowArea;
        if (cardShadow == null || area == null || cardShadow.getParent() == null) return;
        float scaleX = Math.abs(area.getScaleX());
        float scaleY = Math.abs(area.getScaleY());
        if (scaleX <= 0f || scaleY <= 0f) return;
        // The card's own scale, not the stored preference: during a corner drag the preference is
        // only written on release, so reading it would lag a whole gesture behind.
        float width = area.getWidth() * scaleX;
        float height = area.getHeight() * scaleY;
        if (width <= 0f || height <= 0f) return;
        int[] areaLocation = new int[2];
        area.getLocationOnScreen(areaLocation);
        int[] shadowLocation = new int[2];
        cardShadow.getLocationOnScreen(shadowLocation);
        cardShadow.setCardRect(
                areaLocation[0] - shadowLocation[0],
                areaLocation[1] - shadowLocation[1],
                width,
                height);
    }

    private static void updateHandleBounds(ViewGroup host, View area, int handleHeight) {
        if (handle == null) return;
        // Both views report in the same coordinate space, so the subtraction is meaningful. The
        // scaled extent has to be applied by hand: getWidth() stays at the pre-scale size, while
        // getLocationOnScreen() already accounts for the pivot and translation.
        int[] areaLocation = new int[2];
        area.getLocationOnScreen(areaLocation);
        int[] hostLocation = new int[2];
        host.getLocationOnScreen(hostLocation);
        float factor = appliedScale > 0f ? appliedScale : 1f;
        int cardWidth = Math.round(area.getWidth() * factor);
        int cardHeight = Math.round(area.getHeight() * factor);
        if (cardWidth <= 0 || cardHeight <= 0) return;
        int left = areaLocation[0] - hostLocation[0];
        // Inside the card's bottom edge: the gutter below the key rows is reserved for it.
        int top = areaLocation[1] - hostLocation[1] + cardHeight - handleHeight;
        FrameLayout.LayoutParams params =
                handle.getLayoutParams() instanceof FrameLayout.LayoutParams
                        ? (FrameLayout.LayoutParams) handle.getLayoutParams()
                        : new FrameLayout.LayoutParams(cardWidth, handleHeight);
        // Centre the bar in the gutter, not in the touch strip: the strip is taller than the
        // gutter and a bar centred in it would ride up onto the key rows.
        // The strip is a fixed height while the gutter inside the card is scaled, so the bar has
        // to stay clamped inside the strip. At the largest scale the raw offset put it against the
        // strip's top edge, where it was neither visible nor easy to grab; that left the card with
        // no usable way back. Keeping a margin here makes the handle reachable at every scale.
        // Half the bar plus a hair: the bar is 6 dp tall and does not scale, so clamping further
        // than that pulled the bar away from the card's bottom band at small sizes.
        float margin = 4f * density(area);
        float barCenter = area.getPaddingBottom() * factor / 2f;
        barCenter = Math.max(margin, Math.min(handleHeight - margin, barCenter));
        handle.setBarCenterFromBottom(barCenter);
        if (params.width == cardWidth && params.height == handleHeight
                && params.leftMargin == left && params.topMargin == top) {
            return;
        }
        params.width = cardWidth;
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
        // A queued long press would fire against a detached view.
        cancelLongPress(handle);
        ViewGroup parent = handle.getParent() instanceof ViewGroup
                ? (ViewGroup) handle.getParent()
                : null;
        if (parent != null) parent.removeView(handle);
        handle = null;
        // A fresh handle has to sample the theme again.
        handleColorSource = null;
    }

    private static final Runnable enterEditRunnable = new Runnable() {
        @Override
        public void run() {
            armingEdit = false;
            View area = idleArea;
            if (area == null) return;
            enterEditMode(area.getRootView(), area);
        }
    };

    private static void enterEditMode(View decor, View area) {
        if (editing || area == null) return;
        ViewGroup host = handleHost(decor, area);
        if (host == null) return;
        editing = true;
        dragging = false;
        scaling = false;
        armingEdit = false;
        idleHandler.removeCallbacks(fadeOut);
        // The handle only drags; in edit mode the whole card drags, so it is not needed.
        removeHandle();
        removeEditOverlay();
        // Stock chrome: the theme supplies the dim, the border and the buttons, so they stay
        // legible on any palette. Only the geometry and the gestures belong to the card.
        editOverlay = new FloatingKeyboardEditView(area.getContext());
        editOverlay.setLayoutParams(new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        editOverlay.setListener(new FloatingKeyboardEditView.Listener() {
            @Override
            public void onDrag(float screenX, float screenY, boolean finished) {
                handleEditDrag(screenX, screenY, finished);
            }

            @Override
            public void onScale(int corner, float screenX, float screenY, boolean finished) {
                handleEditScale(corner, screenX, screenY, finished);
            }

            @Override
            public void onReset() {
                resetFromEdit();
            }

            @Override
            public void onDone() {
                View current = idleArea;
                if (current == null) return;
                exitEditMode(current.getRootView(), current);
            }
        });
        host.addView(editOverlay);
        editOverlay.bringToFront();
        if (android.os.Build.VERSION.SDK_INT >= 21) {
            editOverlay.setElevation(Math.round(HANDLE_HEIGHT_DP * density(decor)) + 2f);
        }
        updateEditBounds(host, area);
        area.performHapticFeedback(android.view.HapticFeedbackConstants.LONG_PRESS);
        area.invalidate();
    }

    /**
     * The keyboard window went away, so edit mode has to end with it.
     *
     * <p>A theme change is reached through the theme picker, which hides the keyboard first.
     */
    public static void onKeyboardHidden() {
        cancelGestures();
        leaveEditMode(true);
    }

    /**
     * The input view is being rebuilt, which is what a theme change does underneath.
     *
     * <p>Nothing survives a rebuild: the card is a new view at the docked position, so the geometry
     * taken while editing belongs to a view that no longer exists. The previous position is
     * therefore restored from preferences instead of being written from the new view.
     */
    public static void onCardRebuilt() {
        cancelGestures();
        leaveEditMode(false);
    }

    /**
     * Drops every in-flight gesture, not just edit mode.
     *
     * <p>The keyboard can go away between the long-press timer and the drag actually starting, or
     * while a corner is held. Leaving those flags set would let a queued runnable open the editor
     * on a card that is already gone, or keep {@code applyPosition} disabled for the next card.
     */
    private static void cancelGestures() {
        idleHandler.removeCallbacks(enterEditRunnable);
        armingEdit = false;
        if (handle != null) cancelLongPress(handle);
        pendingDrag = false;
        if (dragging && handle != null && handle.getParent() instanceof View) {
            // The card already sits where the finger left it; remember that spot without docking.
            View decor = (View) handle.getParent();
            View area = findKeyboardArea(decor);
            float factor = appliedScale > 0f ? appliedScale : scale(handle.getContext());
            float[] range = area == null ? null : freeRange(decor, area, factor);
            if (range != null) {
                Context context = handle.getContext();
                preferences(context).edit()
                        .putFloat(KEY_X_FRACTION + orientation(context),
                                fractionFromTranslation(area, decor, factor, range, true))
                        .putFloat(KEY_Y_FRACTION + orientation(context),
                                fractionFromTranslation(area, decor, factor, range, false))
                        .apply();
            }
        }
        dragging = false;
        scaling = false;
    }

    private static void leaveEditMode(boolean persistGeometry) {
        if (!editing) return;
        View area = idleArea;
        View decor = area != null ? area.getRootView()
                : editOverlay != null ? editOverlay.getRootView() : null;
        if (area == null && decor != null) area = findKeyboardArea(decor);
        if (area == null || decor == null) {
            editing = false;
            removeEditOverlay();
            return;
        }
        exitEditMode(decor, area, persistGeometry);
    }

    private static void exitEditMode(View decor, View area) {
        exitEditMode(decor, area, true);
    }

    private static void exitEditMode(View decor, View area, boolean persistGeometry) {
        if (!editing) return;
        editing = false;
        dragging = false;
        scaling = false;
        float factor = appliedScale > 0f ? appliedScale : scale(area.getContext());
        float[] range = freeRange(decor, area, factor);
        if (persistGeometry && range != null) {
            Context context = area.getContext();
            float fractionX = fractionFromTranslation(area, decor, factor, range, true);
            float fractionY = fractionFromTranslation(area, decor, factor, range, false);
            preferences(context).edit()
                    .putFloat(KEY_SCALE, factor)
                    .putFloat(KEY_X_FRACTION + orientation(context), fractionX)
                    .putFloat(KEY_Y_FRACTION + orientation(context), fractionY)
                    .apply();
        }
        removeEditOverlay();
        applyPosition(decor, area, factor);
        ensureHandle(decor, area, factor);
        scheduleIdleFade(area);
        decor.requestLayout();
    }

    private static void resetFromEdit() {
        View area = idleArea;
        if (area == null) return;
        View decor = area.getRootView();
        Context context = area.getContext();
        // Only the size is reset. The card stays where the user put it, now and after leaving edit
        // mode, so the stored position is re-derived from the current translation at the new scale
        // rather than replaced with the default.
        appliedScale = DEFAULT_SCALE;
        area.setScaleX(DEFAULT_SCALE);
        area.setScaleY(DEFAULT_SCALE);
        float[] range = freeRange(decor, area, DEFAULT_SCALE);
        android.content.SharedPreferences.Editor editor = preferences(context).edit()
                .putFloat(KEY_SCALE, DEFAULT_SCALE);
        if (range != null) {
            editor.putFloat(KEY_X_FRACTION + orientation(context),
                    fractionFromTranslation(area, decor, DEFAULT_SCALE, range, true));
            editor.putFloat(KEY_Y_FRACTION + orientation(context),
                    fractionFromTranslation(area, decor, DEFAULT_SCALE, range, false));
        }
        editor.apply();
        if (editOverlay != null && editOverlay.getParent() instanceof ViewGroup) {
            updateEditBounds((ViewGroup) editOverlay.getParent(), area);
        }
        decor.requestLayout();
    }

    private static void updateEditBounds(ViewGroup host, View area) {
        if (editOverlay == null) return;
        int[] areaLocation = new int[2];
        area.getLocationOnScreen(areaLocation);
        int[] hostLocation = new int[2];
        host.getLocationOnScreen(hostLocation);
        float factor = appliedScale > 0f ? appliedScale : 1f;
        int width = Math.round(area.getWidth() * factor);
        int height = Math.round(area.getHeight() * factor);
        if (width <= 0 || height <= 0) return;
        int left = areaLocation[0] - hostLocation[0];
        int top = areaLocation[1] - hostLocation[1];
        FrameLayout.LayoutParams params =
                editOverlay.getLayoutParams() instanceof FrameLayout.LayoutParams
                        ? (FrameLayout.LayoutParams) editOverlay.getLayoutParams()
                        : new FrameLayout.LayoutParams(width, height);
        // The dim covers only the card, not the app behind it: the overlay itself is laid out on
        // the card, and the stock layout's border frame fills it.
        if (params.width == width && params.height == height
                && params.leftMargin == left && params.topMargin == top) {
            return;
        }
        params.width = width;
        params.height = height;
        params.gravity = android.view.Gravity.TOP | android.view.Gravity.LEFT;
        params.leftMargin = left;
        params.topMargin = top;
        editOverlay.setLayoutParams(params);
        editOverlay.fitFrame();
    }

    private static void removeEditOverlay() {
        if (editOverlay == null) return;
        ViewGroup parent = editOverlay.getParent() instanceof ViewGroup
                ? (ViewGroup) editOverlay.getParent()
                : null;
        if (parent != null) parent.removeView(editOverlay);
        editOverlay = null;
    }

    /** Dragging in edit mode: any press that misses a corner or a disc moves the card. */
    private static void handleEditDrag(float screenX, float screenY, boolean finished) {
        View area = idleArea;
        if (area == null) return;
        View decor = area.getRootView();
        float factor = appliedScale > 0f ? appliedScale : 1f;
        float[] range = freeRange(decor, area, factor);
        if (range == null) return;

        if (!dragging) {
            dragDownRawX = screenX;
            dragDownRawY = screenY;
            dragStartX = fractionFromTranslation(area, decor, factor, range, true);
            dragStartY = fractionFromTranslation(area, decor, factor, range, false);
            dragging = true;
            if (finished) {
                dragging = false;
                return;
            }
        }

        float fractionX = clamp01(dragStartX + (screenX - dragDownRawX) / range[0]);
        float fractionY = clamp01(dragStartY + (screenY - dragDownRawY) / range[1]);
        area.setTranslationX(fractionX * range[0] - (1f - factor) * decor.getWidth() / 2f);
        area.setTranslationY((fractionY - 1f) * range[1]);
        if (editOverlay != null && editOverlay.getParent() instanceof ViewGroup) {
            updateEditBounds((ViewGroup) editOverlay.getParent(), area);
        }
        if (finished) {
            dragging = false;
            Context context = area.getContext();
            preferences(context).edit()
                    .putFloat(KEY_X_FRACTION + orientation(context), fractionX)
                    .putFloat(KEY_Y_FRACTION + orientation(context), fractionY)
                    .apply();
        }
        decor.requestLayout();
    }

    /** Resizing in edit mode: same maths as the handle version, anchored at the opposite corner. */
    private static void handleEditScale(
            int corner, float screenX, float screenY, boolean finished) {
        View area = idleArea;
        if (area == null) return;
        View decor = area.getRootView();

        if (!scaling) {
            int width = area.getWidth();
            int height = area.getHeight();
            if (width <= 0 || height <= 0) return;
            float factor = appliedScale > 0f ? appliedScale : 1f;
            int[] location = new int[2];
            area.getLocationOnScreen(location);
            float left = location[0];
            float top = location[1];
            float right = left + width * factor;
            float bottom = top + height * factor;
            switch (corner) {
                case 0:
                    scaleAnchorX = right;
                    scaleAnchorY = bottom;
                    scaleAnchorOffX = width;
                    scaleAnchorOffY = height;
                    break;
                case 1:
                    scaleAnchorX = left;
                    scaleAnchorY = bottom;
                    scaleAnchorOffX = 0f;
                    scaleAnchorOffY = height;
                    break;
                case 2:
                    scaleAnchorX = left;
                    scaleAnchorY = top;
                    scaleAnchorOffX = 0f;
                    scaleAnchorOffY = 0f;
                    break;
                default:
                    scaleAnchorX = right;
                    scaleAnchorY = top;
                    scaleAnchorOffX = width;
                    scaleAnchorOffY = 0f;
                    break;
            }
            scaleStartDistance = distance(screenX, screenY, scaleAnchorX, scaleAnchorY);
            if (scaleStartDistance < 1f) return;
            scaleStartFactor = factor;
            scaleStartTx = area.getTranslationX();
            scaleStartTy = area.getTranslationY();
            scaling = true;
            if (finished) {
                scaling = false;
                return;
            }
        }

        if (finished) {
            scaling = false;
            float factor = appliedScale > 0f ? appliedScale : 1f;
            Context context = area.getContext();
            preferences(context).edit().putFloat(KEY_SCALE, factor).apply();
            if (editOverlay != null && editOverlay.getParent() instanceof ViewGroup) {
                updateEditBounds((ViewGroup) editOverlay.getParent(), area);
            }
            return;
        }

        float moved = distance(screenX, screenY, scaleAnchorX, scaleAnchorY);
        float factor = Math.max(MIN_SCALE,
                Math.min(MAX_SCALE, scaleStartFactor * moved / scaleStartDistance));
        // The anchored corner stays put, so growth is bounded by the room left towards the
        // dragged corner. Both the anchor and the decor bounds have to be in the same space:
        // getLocationOnScreen includes the status-bar offset, decor.getHeight does not.
        int[] decorLocation = new int[2];
        decor.getLocationOnScreen(decorLocation);
        float roomX = (corner == 1 || corner == 2)
                ? decorLocation[0] + decor.getWidth() - scaleAnchorX
                : scaleAnchorX - decorLocation[0];
        float roomY = (corner == 2 || corner == 3)
                ? decorLocation[1] + decor.getHeight() - scaleAnchorY
                : scaleAnchorY - decorLocation[1];
        if (roomX > 0f && roomY > 0f) {
            float limit = Math.min(roomX / area.getWidth(), roomY / area.getHeight());
            // The room wins over the minimum scale: clamping back up to MIN_SCALE here would let
            // the card grow past the screen edge it just ran into.
            factor = Math.min(factor, limit);
        }
        float pivotX = area.getWidth() / 2f;
        float pivotY = area.getHeight();
        float shift = scaleStartFactor - factor;
        area.setScaleX(factor);
        area.setScaleY(factor);
        appliedScale = factor;
        area.setTranslationX(scaleStartTx + (scaleAnchorOffX - pivotX) * shift);
        area.setTranslationY(scaleStartTy + (scaleAnchorOffY - pivotY) * shift);
        if (editOverlay != null && editOverlay.getParent() instanceof ViewGroup) {
            updateEditBounds((ViewGroup) editOverlay.getParent(), area);
        }
        decor.requestLayout();
    }

    private static float distance(float x1, float y1, float x2, float y2) {
        float dx = x1 - x2;
        float dy = y1 - y2;
        return (float) Math.sqrt(dx * dx + dy * dy);
    }

    /**
     * Fills {@code out} with the card in <em>screen</em> coordinates.
     *
     * <p>Deliberately not {@code getGlobalVisibleRect}: inside the IME window it reports the
     * content frame's coordinates, which sit below the window origin by the inset height.
     *
     * <p>Screen coordinates on purpose. {@code applyInsets} already moves the rectangle into window
     * space with a single {@code offset}; subtracting the window origin here as well cancelled it
     * twice and pushed the whole region above the card, so every touch below the first key row was
     * dropped.
     */
    private static boolean visualRegion(View area, Rect out) {
        if (area.getWidth() <= 0 || area.getHeight() <= 0) return false;
        int[] areaLocation = new int[2];
        area.getLocationOnScreen(areaLocation);
        float factor = appliedScale > 0f ? appliedScale : 1f;
        int width = Math.round(area.getWidth() * factor);
        int height = Math.round(area.getHeight() * factor);
        out.set(areaLocation[0], areaLocation[1],
                areaLocation[0] + width, areaLocation[1] + height);
        return !out.isEmpty();
    }

    /** Returns true when the drag subsystem consumed the event. */
    private static int touchSlop(View view) {
        if (touchSlop < 0) {
            touchSlop = android.view.ViewConfiguration.get(view.getContext()).getScaledTouchSlop();
        }
        return touchSlop;
    }

    private static void cancelLongPress(View view) {
        if (pendingLongPress != null) {
            view.removeCallbacks(pendingLongPress);
            pendingLongPress = null;
        }
        pendingDrag = false;
    }

    /**
     * Arms the long press. Moving further than the touch slop first cancels it, so a flick over the
     * handle does not drag the keyboard by accident.
     */
    private static void armLongPress(final View view, final View decor, final View area) {
        cancelLongPress(view);
        pendingDrag = true;
        pendingLongPress = new Runnable() {
            @Override
            public void run() {
                pendingLongPress = null;
                if (!pendingDrag || !isEnabled(view.getContext())) return;
                pendingDrag = false;
                float factor = appliedScale > 0f ? appliedScale : scale(view.getContext());
                float[] range = freeRange(decor, area, factor);
                if (range == null) return;
                dragging = true;
                // Anchor on where the finger already is: anchoring on the original down point
                // would jump the card by however long the press took to be recognised.
                dragDownRawX = downRawX;
                dragDownRawY = downRawY;
                dragStartX = fractionFromTranslation(area, decor, factor, range, true);
                dragStartY = fractionFromTranslation(area, decor, factor, range, false);
                view.performHapticFeedback(android.view.HapticFeedbackConstants.LONG_PRESS);
                wakeIdle();
            }
        };
        view.postDelayed(pendingLongPress, DRAG_LONG_PRESS_MS);
    }

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
                downRawX = event.getRawX();
                downRawY = event.getRawY();
                wakeIdle();
                long now = android.os.SystemClock.uptimeMillis();
                if (now - lastHandleUp <= DOUBLE_TAP_MS) {
                    // Second tap: holding it opens edit mode. Dragging is not armed this time.
                    armingEdit = true;
                    idleHandler.postDelayed(enterEditRunnable, EDIT_HOLD_MS);
                } else {
                    armingEdit = false;
                    armLongPress(view, decor, area);
                }
                return true;
            }
            case MotionEvent.ACTION_MOVE: {
                if (armingEdit) {
                    float dx = event.getRawX() - downRawX;
                    float dy = event.getRawY() - downRawY;
                    int slop = touchSlop(view);
                    if (dx * dx + dy * dy > (float) slop * slop) {
                        armingEdit = false;
                        idleHandler.removeCallbacks(enterEditRunnable);
                    }
                    return true;
                }
                if (!dragging) {
                    if (pendingDrag) {
                        float dx = event.getRawX() - downRawX;
                        float dy = event.getRawY() - downRawY;
                        int slop = touchSlop(view);
                        if (dx * dx + dy * dy > (float) slop * slop) cancelLongPress(view);
                    }
                    return true;
                }
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
                lastHandleUp = android.os.SystemClock.uptimeMillis();
                if (armingEdit) {
                    armingEdit = false;
                    idleHandler.removeCallbacks(enterEditRunnable);
                    return true;
                }
                cancelLongPress(view);
                if (!dragging) return true;
                dragging = false;
                settle(view, decor);
                View settledArea = findKeyboardArea(decor);
                if (settledArea != null) scheduleIdleFade(settledArea);
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
        // Free placement: the card stays exactly where it was released. No left/centre/right
        // snapping, which used to yank the card sideways when the finger stopped near an edge.
        if (fractionY > DOCK_THRESHOLD && dragStartY < DOCK_THRESHOLD) {
            fractionY = 1f;
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
