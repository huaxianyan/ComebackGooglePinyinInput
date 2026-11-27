package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.inputmethodservice.InputMethodService;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.graphics.PixelFormat;
import android.view.Gravity;
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
    private static final float MIN_SCALE = 0.40f;
    private static final float MAX_SCALE = 1.0f;

    /** Touch strip of the drag handle, measured up from the card's bottom edge. */
    static final int HANDLE_HEIGHT_DP = 20;
    /** Room left around the card for the hand-drawn shadow ring. */
    static final float SHADOW_GROW_DP = 10f;
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
     * The IME window, kept so position updates can reach its LayoutParams.
     *
     * <p>Vertical placement lives on the window rather than on the keyboard area. The window is
     * only as tall as the card and travels with it, which is what keeps the platform's surface
     * shadow down to the card's own footprint.
     */
    private static Window floatingWindow;
    /** Size the keyboard area had before the window was narrowed to the card. */
    private static int baseAreaWidth = -1;
    private static int baseAreaHeight = -1;
    /** The view the scale was applied to; the service rebuilds its views, and a stale value here
     *  would skip scaling the replacement. */
    private static View scaledView;
    private static final Rect lastRegion = new Rect();

    private static FloatingKeyboardHandle handle;
    private static FloatingCardShadow cardShadow;
    /**
     * Background the keyboard area had before floating; restored when the card stops floating.
     * Dropping it is what removes the grey band under the card on light themes.
     */
    private static Drawable baseAreaBackground;
    private static FloatingKeyboardEdit editOverlay;
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
            // Size the window first: it is the card's container now, so both the position below
            // and the region after that are expressed against it.
            narrowWindowToCard(window, area);
            // Position before measuring the region: the window move is what places the card, and
            // getGlobalVisibleRect reports it where it now sits.
            applyPosition(decor, area, factor);
            visualRegion(area, region);
            ensureCardShadow(decor, area, factor);

            // The handle hangs below the card, and outside the region touches fall straight
            // through to the app. Reach past the handle with margin, and keep the sides on the
            // card as well so the whole strip is reachable.
            int handleHeight = Math.round(HANDLE_HEIGHT_DP * density(decor));
            region.bottom += handleHeight * 2;
            region.top -= handleHeight;
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
        scaling = false;
        editing = false;
        armingEdit = false;
        idleHandler.removeCallbacks(enterEditRunnable);
        removeHandle();
        removeEditOverlay();
        removeIdleProbe();
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
        restoreAreaBackground(area);
        removeCardShadow();
        clearAreaBackground(area);
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
            // Turning the switch off while the card is already half faded has to bring it back
            // up, otherwise it stays dim until the next touch.
            if (idleScheduled) {
                idleScheduled = false;
                idleHandler.removeCallbacks(fadeOut);
                animateIdleAlpha(1f, IDLE_WAKE_MS);
            }
            return;
        }
        if (idleScheduled) return;
        idleScheduled = true;
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
        if (idleProbe != null && idleProbe.getParent() == host) return;
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

    /**
     * The card is scaled in, so its own bottom padding ends up outside the painted area: the
     * keyboard area keeps a background of its own and that background is what showed as a flat
     * grey band under the card on light themes. The key rows and the header paint themselves, so
     * this layer is not needed.
     */
    private static void clearAreaBackground(View area) {
        if (baseAreaBackground != null) return;
        baseAreaBackground = area.getBackground();
        area.setBackground(null);
    }

    private static void restoreAreaBackground(View area) {
        if (baseAreaBackground == null) return;
        area.setBackground(baseAreaBackground);
        baseAreaBackground = null;
    }

    /**
     * The card's shadow belongs to the card, not to the window. Elevation on the keyboard area
     * itself does not work here: it is scaled with a view transform, so its layout bounds stay at
     * the full window size and the shadow would be drawn along the screen edges.
     */
    private static void ensureCardShadow(View decor, View area, float factor) {
        if (android.os.Build.VERSION.SDK_INT < 21) return;
        ViewGroup host = handleHost(decor, area);
        if (host == null) return;
        if (cardShadow == null || cardShadow.getParent() != host) {
            removeCardShadow();
            cardShadow = new FloatingCardShadow(decor.getContext(), density(decor));
            cardShadow.setLayoutParams(new FrameLayout.LayoutParams(0, 0));
            host.addView(cardShadow);
            // Just below the card so its ring is drawn under the keyboard rather than over it.
            cardShadow.setTranslationZ(-1f);
        }
        updateCardShadowBounds(host, area, factor);
    }

    private static void updateCardShadowBounds(ViewGroup host, View area, float factor) {
        if (cardShadow == null) return;
        int[] areaLocation = new int[2];
        area.getLocationOnScreen(areaLocation);
        int[] hostLocation = new int[2];
        host.getLocationOnScreen(hostLocation);
        float applied = factor > 0f ? factor : 1f;
        int cardWidth = Math.round(area.getWidth() * applied);
        int cardHeight = Math.round(area.getHeight() * applied);
        if (cardWidth <= 0 || cardHeight <= 0) return;
        int left = areaLocation[0] - hostLocation[0];
        int top = areaLocation[1] - hostLocation[1];
        // The outline sits slightly outside the card, so the shadow starts beyond its edge and
        // never falls on the keys.
        int outgrow = Math.round(SHADOW_GROW_DP * density(host));
        left -= outgrow;
        top -= outgrow;
        cardWidth += outgrow * 2;
        cardHeight += outgrow * 2;
        FrameLayout.LayoutParams params =
                cardShadow.getLayoutParams() instanceof FrameLayout.LayoutParams
                        ? (FrameLayout.LayoutParams) cardShadow.getLayoutParams()
                        : new FrameLayout.LayoutParams(cardWidth, cardHeight);
        if (params.width == cardWidth && params.height == cardHeight
                && params.leftMargin == left && params.topMargin == top) {
            return;
        }
        params.width = cardWidth;
        params.height = cardHeight;
        params.leftMargin = left;
        params.topMargin = top;
        cardShadow.setLayoutParams(params);
    }

    private static void removeCardShadow() {
        if (cardShadow == null) return;
        ViewGroup parent = cardShadow.getParent() instanceof ViewGroup
                ? (ViewGroup) cardShadow.getParent()
                : null;
        if (parent != null) parent.removeView(cardShadow);
        cardShadow = null;
    }

    /**
     * The IME window is a dialog window, so the platform draws a drop shadow along its surface
     * edges. While the card is scaled in, that shadow no longer lines up with anything and reads
     * as a stray band down the screen sides, ending right above the navigation bar.
     *
     * <p>The shadow is not reachable from the app: it is not view elevation, not the window
     * background, and {@code LayoutParams.surfaceInsets} is a hidden field. The one lever that
     * works is the window size, so the window is narrowed to the card. Width only: narrowing the
     * height clips the card, because the area keeps its original layout height and is positioned
     * from the window's top-left corner.
     *
     * <p>The area is pinned at its original size so the key rows do not reflow across the
     * narrower window. The card itself ends up inside the window either way, since it is scaled
     * about its centre.
     */
    private static void dumpTree(View view, int depth) {
        if (depth > 6) return;
        StringBuilder indent = new StringBuilder();
        for (int i = 0; i < depth; i++) indent.append("  ");
        String name = view.getClass().getSimpleName();
        try {
            name += "#" + view.getResources().getResourceEntryName(view.getId());
        } catch (Exception ignored) {
        }
        Log.i(TAG, "tree " + indent + name
                + " pos=" + view.getLeft() + "," + view.getTop()
                + " size=" + view.getWidth() + "x" + view.getHeight()
                + " scale=" + view.getScaleY()
                + " bg=" + (view.getBackground() != null));
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                dumpTree(group.getChildAt(i), depth + 1);
            }
        }
    }

    private static void clearBottomPadding(View view) {
        if (view != null && view.getPaddingBottom() != 0) {
            view.setPadding(view.getPaddingLeft(), view.getPaddingTop(),
                    view.getPaddingRight(), 0);
        }
    }

    private static View findChildByClass(View view, String className) {
        if (className.equals(view.getClass().getSimpleName())) return view;
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                View found = findChildByClass(group.getChildAt(i), className);
                if (found != null) return found;
            }
        }
        return null;
    }

    private static View findChildByName(View view, String name) {
        try {
            if (name.equals(view.getResources().getResourceEntryName(view.getId()))) {
                return view;
            }
        } catch (Exception ignored) {
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                View found = findChildByName(group.getChildAt(i), name);
                if (found != null) return found;
            }
        }
        return null;
    }

    private static void narrowWindowToCard(Window window, View area) {
        if (window == null) return;
        floatingWindow = window;
        if (window.getDecorView().getElevation() != 0f) window.getDecorView().setElevation(0f);
        // The themed window background is opaque. Now that the window hugs the card, that opaque
        // fill is visible as a solid panel wherever the card is not: beside the handle and in the
        // shadow margin. A transparent drawable removes the fill; it does not remove the surface
        // shadow, which is a separate thing.
        android.graphics.drawable.ColorDrawable transparent =
                new android.graphics.drawable.ColorDrawable(0);
        window.setBackgroundDrawable(transparent);
        // The decor and the content frame carry their own opaque backgrounds from the theme, which
        // fill every part of the window the card does not cover: the shadow margin and the strip
        // under the keys. Clearing only the window background leaves those panels visible.
        View decorView = window.getDecorView();
        decorView.setBackgroundDrawable(transparent);
        View content = decorView.findViewById(android.R.id.content);
        if (content != null) content.setBackgroundDrawable(transparent);
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return;
        // Fixed references, not first-frame measurements: by the time this runs the window may
        // already have been resized once, and a measured baseline then feeds on itself.
        if (baseAreaWidth < 0) {
            baseAreaWidth = area.getContext().getResources().getDisplayMetrics().widthPixels;
        }
        if (baseAreaHeight < 0) {
            int dimen = area.getContext().getResources()
                    .getIdentifier("keyboard_height", "dimen", area.getContext().getPackageName());
            baseAreaHeight = dimen != 0
                    ? area.getContext().getResources().getDimensionPixelSize(dimen)
                    : height;
        }
        ViewGroup.LayoutParams params = area.getLayoutParams();
        if (params != null && (params.width != baseAreaWidth
                || params.height != baseAreaHeight)) {
            params.width = baseAreaWidth;
            params.height = baseAreaHeight;
            area.setLayoutParams(params);
        }
        // The stock BottomInsetsListener pads the keyboard by the navigation bar height. Floating
        // in the middle of the screen there is no navigation bar under the keys, and that padding
        // pushes the bottom key row out of the card.
        // BottomInsetsListener applies the navigation bar height as bottom padding on the
        // InputView itself, not only on keyboard_area. keyboard_area is match_parent inside
        // InputView, so that padding is exactly what pushed the bottom key row out of the card.
        View keyboardAreaView = findChildByName(area, "keyboard_area");
        clearBottomPadding(keyboardAreaView);
        View inputView = findChildByClass(area, "InputView");
        clearBottomPadding(inputView);
        // InputView also hosts a separate gesture-bar placeholder view below keyboard_area,
        // 126 px tall. It is what actually shrinks keyboard_area and clips the bottom key row.
        // Floating there is no gesture bar under the keys, so the placeholder goes away.
        if (inputView instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) inputView;
            for (int i = 0; i < group.getChildCount(); i++) {
                View child = group.getChildAt(i);
                if (child != keyboardAreaView && child.getHeight() > 0
                        && child.getVisibility() != View.GONE) {
                    child.setVisibility(View.GONE);
                }
            }
        }
        float factor = appliedScale > 0f ? appliedScale : 1f;
        int outgrow = Math.round(SHADOW_GROW_DP * density(area)) * 2;
        int handleHeight = Math.round(HANDLE_HEIGHT_DP * density(area));
        int windowWidth = Math.round(baseAreaWidth * factor) + outgrow;
        // Exactly tall enough for the card plus the handle below it. Any taller and the window's
        // own surface shadow draws a band below the card, which is the artifact being removed.
        // Fixed by the factor, never measured from the area: the area is match_parent inside the
        // window, so a measured height would shrink the window a little more on every pass until
        // the keyboard vanished.
        int windowHeight = cardOffsetInWindow(area)[1]
                + Math.round(baseAreaHeight * factor) + handleHeight + outgrow;
        ViewGroup contentGroup = (ViewGroup) decorView.findViewById(android.R.id.content);
        if (contentGroup != null) dumpTree(contentGroup, 0);
        String areaName = "?";
        try {
            areaName = area.getResources().getResourceEntryName(area.getId());
        } catch (Exception ignored) {
        }
        StringBuilder chain = new StringBuilder();
        android.view.ViewParent node = area.getParent();
        while (node instanceof View) {
            View parentView = (View) node;
            String parentName = parentView.getClass().getSimpleName();
            try {
                parentName += "#" + parentView.getResources()
                        .getResourceEntryName(parentView.getId());
            } catch (Exception ignored) {
            }
            chain.append(" <- ").append(parentName);
            node = parentView.getParent();
        }
        Log.i(TAG, "areaIs " + area.getClass().getSimpleName() + "#" + areaName
                + " scale=" + area.getScaleY() + " size=" + area.getWidth() + "x"
                + area.getHeight() + chain);
        View inputAreaView = findChildByName(area, "inputArea");
        Log.i(TAG, "heights panel=" + area.getHeight()
                + " inputArea=" + (inputAreaView == null ? -1 : inputAreaView.getHeight())
                + " keyboardArea=" + (keyboardAreaView == null ? -1 : keyboardAreaView.getHeight())
                + " baseH=" + baseAreaHeight
                + " kaPadB=" + (keyboardAreaView == null ? -1 : keyboardAreaView.getPaddingBottom())
                + " kaH=" + (keyboardAreaView == null ? -1
                        : keyboardAreaView.getLayoutParams().height)
                + " ivPadB=" + (inputAreaView == null ? -1 : inputAreaView.getPaddingBottom()));
        Log.i(TAG, "win " + windowWidth + "x" + windowHeight + " factor=" + factor
                + " areaScale=" + area.getScaleX() + "," + area.getScaleY()
                + " pivot=" + area.getPivotX() + "," + area.getPivotY()
                + " areaPos=" + area.getLeft() + "," + area.getTop()
                + " areaSize=" + width + "x" + height
                + " base=" + baseAreaWidth + "x" + baseAreaHeight);
        android.view.WindowManager.LayoutParams attributes = window.getAttributes();
        if (attributes.width == windowWidth && attributes.height == windowHeight
                && attributes.gravity == (Gravity.TOP | Gravity.START)) {
            return;
        }
        attributes.width = windowWidth;
        attributes.height = windowHeight;
        attributes.gravity = Gravity.TOP | Gravity.START;
        window.setAttributes(attributes);
    }

    /** Returns false when the view has no size yet, so the caller can fall back. */
    private static boolean applyScale(View area, float factor) {
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return false;
        applyGutter(area, false);
        clearAreaBackground(area);
        // Insets come in on every frame. While a corner is held the size belongs to the finger,
        // so a preference that has not been written yet must not pull the card back.
        if (scaling || editing) factor = appliedScale;
        if (appliedScale != factor || scaledView != area) {
            appliedScale = factor;
            scaledView = area;
            area.setPivotX(0f);
            area.setPivotY(0f);
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
        moveWindow(factor, range, xFraction(decor.getContext()), yFraction(decor.getContext()),
                area);
        return true;
    }

    /** {free horizontal travel, free vertical travel} in pixels, or null before layout. */
    /**
     * Distance the card may travel, measured against the screen rather than against the window.
     *
     * <p>The window is cut down to the card and moves with it, so the window size is no longer
     * the space the card travels through. Using it would shrink the range every time the window
     * moved.
     */
    private static float[] freeRange(View decor, View area, float factor) {
        android.util.DisplayMetrics metrics = decor.getContext().getResources()
                .getDisplayMetrics();
        int width = metrics.widthPixels;
        // The card must stop above the navigation bar, otherwise the system draws over its bottom
        // edge and the last key row is half covered.
        // The drag handle hangs below the card, so the card has to stop a handle's height above
        // the navigation bar or the handle ends up inside it and swallows the drag.
        int bars = systemBarHeight(decor)
                + Math.round(HANDLE_HEIGHT_DP * density(area));
        int height = metrics.heightPixels - bars;
        int areaWidth = area.getWidth();
        int areaHeight = area.getHeight();
        if (width <= 0 || height <= 0 || areaWidth <= 0 || areaHeight <= 0) return null;
        return new float[] {
                Math.max(1f, width - areaWidth * factor),
                Math.max(1f, height - areaHeight * factor),
        };
    }

    /**
     * Height taken by the system bars, so the card and its handle stay clear of the navigation
     * bar. The IME window does not fit the system bars, so its own insets report zero; the
     * difference between the real display and the app-visible display is what is actually
     * covered.
     */
    private static int systemBarHeight(View decor) {
        if (floatingWindow == null) return 0;
        android.view.WindowManager manager = floatingWindow.getWindowManager();
        if (manager == null) return 0;
        // Read the navigation bar inset itself. The difference between maximum and current window
        // metrics is not the bar height for an IME window: it measured 92-98 px where the bar is
        // really 126 px, which let the handle slide under the bar.
        // Maximum metrics describe the whole display, so their insets are the real system bars.
        // The IME window's own current metrics report no navigation bar at all.
        int navBottom = manager.getMaximumWindowMetrics().getWindowInsets()
                .getInsets(android.view.WindowInsets.Type.navigationBars()).bottom;
        if (navBottom > 0) return navBottom;
        int real = manager.getMaximumWindowMetrics().getBounds().height();
        int usable = manager.getCurrentWindowMetrics().getBounds().height();
        int difference = Math.max(0, real - usable);
        if (difference > 0) return difference;
        // The IME window reports the full height as its current metrics, so fall back to the frame
        // the content is actually visible in.
        android.graphics.Rect visible = new android.graphics.Rect();
        decor.getWindowVisibleDisplayFrame(visible);
        return Math.max(0, real - visible.bottom);
    }

    /**
     * The card's visible top-left corner in window coordinates.
     *
     * <p>getLocationOnScreen includes the scale and the pivot, so this is where the card is
     * actually drawn. The window's own screen position cancels out because both views are
     * measured the same way.
     */
    private static int[] cardOffsetInWindow(View area) {
        // Pure layout arithmetic, never a measurement of the live view tree. Reading positions
        // back off the screen made each frame's window position depend on the previous frame's,
        // which is what produced the jitter. The area is pinned to the content's top-start corner
        // and scaled about its bottom centre, so the card's visible top-left is fully determined
        // by the layout and the scale.
        int width = area.getWidth();
        int height = area.getHeight();
        float factor = appliedScale > 0f ? appliedScale : 1f;
        return new int[] {area.getLeft(), area.getTop()};
    }

    /**
     * Difference between the content view's screen position and the window's LayoutParams.
     *
     * <p>Constant for a given window configuration, so it is safe to read from the attributes
     * before they are updated.
     */
    private static int[] windowOriginShift(Window window,
            android.view.WindowManager.LayoutParams attributes) {
        // LayoutParams are relative to the available display frame, whose top is the status bar.
        // Reading that inset is stable; comparing live view positions against the attributes was
        // not, because those positions lag a frame behind while the window is moving.
        int statusTop = 0;
        if (window != null && window.getWindowManager() != null) {
            statusTop = window.getWindowManager().getMaximumWindowMetrics().getWindowInsets()
                    .getInsets(android.view.WindowInsets.Type.statusBars()).top;
        }
        return new int[] {0, statusTop};
    }

    /**
     * Places the window so the scaled card lands where the fractions say.
     *
     * <p>The area sits at the window's top-left corner and is scaled about its bottom centre, so
     * the card's visible box is inset from the window by the scale loss on each axis. Subtracting
     * that inset is what turns a window position into a card position and back.
     */
    private static void moveWindow(float factor, float[] range, float fractionX, float fractionY,
            View area) {
        Window window = floatingWindow;
        if (window == null || range == null) return;
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return;
        // The card's offset inside the window is measured, not derived. Deriving it from the
        // scale alone assumes the area sits at a particular place in its parent, and every time
        // that assumption was wrong the window ended up taller or shorter than the card.
        int[] offset = cardOffsetInWindow(area);
        // WindowManager y is relative to the available display frame, which starts below the
        // status bar, not to the physical screen. Measuring the content view against the current
        // attributes gives that shift directly; treating y as a screen coordinate was what put
        // the handle down inside the navigation bar.
        android.view.WindowManager.LayoutParams current = window.getAttributes();
        int[] origin = windowOriginShift(window, current);
        int x = Math.round(fractionX * range[0]) - offset[0] - origin[0];
        int y = Math.round(fractionY * range[1]) - offset[1] - origin[1];
        // Clamp by real geometry rather than trusting the fractions. The card's visible box is
        // the window position plus the measured offset, and the handle hangs below it. Whatever
        // the fractions say, the handle must never end up inside the navigation bar, because the
        // system takes those touches and the card can no longer be dragged back up.
        android.util.DisplayMetrics metrics = area.getContext().getResources().getDisplayMetrics();
        int bars = systemBarHeight(area);
        int handleHeight = Math.round(HANDLE_HEIGHT_DP * density(area));
        int cardWidth = Math.round(baseAreaWidth * factor);
        int cardHeight = Math.round(baseAreaHeight * factor);
        int maxY = metrics.heightPixels - bars - origin[1] - offset[1] - cardHeight - handleHeight;
        int minY = -offset[1] - origin[1];
        if (y > maxY) y = maxY;
        if (y < minY) y = minY;
        int maxX = metrics.widthPixels - offset[0] - cardWidth - origin[0];
        int minX = -offset[0] - origin[0];
        if (x > maxX) x = maxX;
        if (x < minX) x = minX;
        android.view.WindowManager.LayoutParams attributes = window.getAttributes();
        if (attributes.x == x && attributes.y == y) return;
        attributes.x = x;
        attributes.y = y;
        window.setAttributes(attributes);
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
        // getLocationOnScreen already includes the scale, so it reports the card's visible
        // top-left corner, not the area's layout corner. The visible bottom is therefore that
        // corner plus the scaled height, and the visible left is that corner as-is. Adding the
        // unscaled height or the centring inset on top of this double-counts the scale loss and
        // pushes the handle past the bottom of the window, where it is clipped away.
        int left = areaLocation[0] - hostLocation[0];
        // Just below the card's visible bottom edge, in the strip the window reserves for it.
        int top = areaLocation[1] - hostLocation[1] + cardHeight;
        FrameLayout.LayoutParams params =
                handle.getLayoutParams() instanceof FrameLayout.LayoutParams
                        ? (FrameLayout.LayoutParams) handle.getLayoutParams()
                        : new FrameLayout.LayoutParams(cardWidth, handleHeight);
        handle.setBarCenterFromBottom(handleHeight / 2f);
        if (params.width == cardWidth && params.height == handleHeight
                && params.leftMargin == left && params.topMargin == top) {
            return;
        }
        // A narrow pill, centred, so it does not swallow the whole bottom key row.
        int pillWidth = Math.round(handleHeight * 3f);
        params.width = pillWidth;
        params.height = handleHeight;
        params.gravity = android.view.Gravity.TOP | android.view.Gravity.LEFT;
        left += (cardWidth - pillWidth) / 2;
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

    /**
     * Accent of the active keyboard theme.
     *
     * <p>Theme attributes are useless here: the keyboard swaps its palette at runtime without
     * touching {@code colorAccent}, so that attribute always answers with the built-in teal. What
     * does change is the painted UI, so the accent is taken from the keyboard itself: the enter and
     * search keys are the only highly saturated things on the card, and the most saturated of them
     * is the theme accent.
     */
    static int accentColor(View area) {
        int fromPixels = accentFromPixels(area);
        return fromPixels != 0 ? fromPixels : accentFromAttributes(area.getContext());
    }

    /**
     * Reads the accent off the rendered keyboard.
     *
     * <p>The keys paint themselves onto a canvas instead of carrying a background colour, so
     * nothing readable lives on the views. Drawing the card into a bitmap once gives the real
     * pixels, and the most saturated one is the theme accent: the enter and search keys are the
     * only strongly coloured things a keyboard draws.
     */
    private static int accentFromPixels(View area) {
        int width = area.getWidth();
        int height = area.getHeight();
        if (width <= 0 || height <= 0) return 0;
        try {
            android.graphics.Bitmap bitmap = android.graphics.Bitmap.createBitmap(
                    width, height, android.graphics.Bitmap.Config.ARGB_8888);
            android.graphics.Canvas canvas = new android.graphics.Canvas(bitmap);
            area.draw(canvas);
            int[] pixels = new int[width * height];
            bitmap.getPixels(pixels, 0, width, 0, 0, width, height);
            bitmap.recycle();
            int[] best = {0, 0};
            int step = 3;
            for (int y = 0; y < height; y += step) {
                int row = y * width;
                for (int x = 0; x < width; x += step) {
                    considerAccent(pixels[row + x], best);
                }
            }
            return best[0];
        } catch (Throwable ignored) {
            return 0;
        }
    }

    private static void considerAccent(int color, int[] best) {
        if (android.graphics.Color.alpha(color) < 200) return;
        float[] hsv = new float[3];
        android.graphics.Color.colorToHSV(color, hsv);
        if (hsv[1] < 0.35f || hsv[2] < 0.35f) return;
        int score = Math.round(hsv[1] * 100f * hsv[2]);
        if (score > best[1]) {
            best[0] = color;
            best[1] = score;
        }
    }

    private static int accentFromAttributes(Context context) {
        String[] names = {"colorAccent", "colorPrimary", "colorControlActivated"};
        for (String name : names) {
            int attrId = context.getResources()
                    .getIdentifier(name, "attr", context.getPackageName());
            if (attrId == 0) continue;
            android.util.TypedValue value = new android.util.TypedValue();
            if (!context.getTheme().resolveAttribute(attrId, value, true)) continue;
            if (value.resourceId != 0) {
                return android.os.Build.VERSION.SDK_INT >= 23
                        ? context.getColor(value.resourceId)
                        : context.getResources().getColor(value.resourceId);
            }
            if (value.data != 0) return value.data;
        }
        return 0xFF4DB6AC;
    }

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
        editOverlay = new FloatingKeyboardEdit(area.getContext(), accentColor(area));
        editOverlay.setLayoutParams(new FrameLayout.LayoutParams(0, 0));
        editOverlay.setListener(new FloatingKeyboardEdit.Listener() {
            @Override
            public void onEditDrag(float screenX, float screenY, boolean finished) {
                handleEditDrag(screenX, screenY, finished);
            }

            @Override
            public void onEditScale(int corner, float screenX, float screenY, boolean finished) {
                handleEditScale(corner, screenX, screenY, finished);
            }

            @Override
            public void onEditReset() {
                resetFromEdit();
            }

            @Override
            public void onEditDone() {
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

    private static void exitEditMode(View decor, View area) {
        if (!editing) return;
        editing = false;
        dragging = false;
        scaling = false;
        float factor = appliedScale > 0f ? appliedScale : scale(area.getContext());
        float[] range = freeRange(decor, area, factor);
        if (range != null) {
            Context context = area.getContext();
            float fractionX = fractionFromWindow(area, decor, factor, range, true);
            float fractionY = fractionFromWindow(area, decor, factor, range, false);
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
        preferences(context).edit()
                .putFloat(KEY_SCALE, DEFAULT_SCALE)
                .putFloat(KEY_X_FRACTION + orientation(context), DEFAULT_X_FRACTION)
                .putFloat(KEY_Y_FRACTION + orientation(context), DEFAULT_Y_FRACTION)
                .apply();
        appliedScale = DEFAULT_SCALE;
        area.setScaleX(DEFAULT_SCALE);
        area.setScaleY(DEFAULT_SCALE);
        applyPosition(decor, area, DEFAULT_SCALE);
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
            dragStartX = fractionFromWindow(area, decor, factor, range, true);
            dragStartY = fractionFromWindow(area, decor, factor, range, false);
            dragging = true;
            if (finished) {
                dragging = false;
                return;
            }
        }

        float fractionX = clamp01(dragStartX + (screenX - dragDownRawX) / range[0]);
        float fractionY = clamp01(dragStartY + (screenY - dragDownRawY) / range[1]);
        moveWindow(factor, range, fractionX, fractionY, area);
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
            android.view.WindowManager.LayoutParams start =
                    floatingWindow == null ? null : floatingWindow.getAttributes();
            scaleStartTx = start == null ? 0f : start.x;
            scaleStartTy = start == null ? 0f : start.y;
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
        // dragged corner. Without this the card happily grows past the edge of the screen.
        android.util.DisplayMetrics metrics = area.getContext().getResources()
                .getDisplayMetrics();
        float roomX = (corner == 1 || corner == 2)
                ? metrics.widthPixels - scaleAnchorX
                : scaleAnchorX;
        float roomY = (corner == 2 || corner == 3)
                ? metrics.heightPixels - scaleAnchorY
                : scaleAnchorY;
        if (roomX > 0f && roomY > 0f) {
            float limit = Math.min(roomX / area.getWidth(), roomY / area.getHeight());
            factor = Math.min(factor, limit);
            factor = Math.max(MIN_SCALE, factor);
        }
        float pivotX = area.getWidth() / 2f;
        float pivotY = area.getHeight();
        float shift = scaleStartFactor - factor;
        area.setScaleX(factor);
        area.setScaleY(factor);
        appliedScale = factor;
        if (floatingWindow != null) {
            // Size as well as position: leaving the window at its old size while the card shrinks
            // leaves the surface shadow sitting in a large frame of its own, detached from the
            // card.
            narrowWindowToCard(floatingWindow, area);
            android.view.WindowManager.LayoutParams attributes = floatingWindow.getAttributes();
            attributes.x = Math.round(scaleStartTx + (scaleAnchorOffX - pivotX) * shift);
            attributes.y = Math.round(scaleStartTy + (scaleAnchorOffY - pivotY) * shift);
            floatingWindow.setAttributes(attributes);
        }
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
                dragStartX = fractionFromWindow(area, decor, factor, range, true);
                dragStartY = fractionFromWindow(area, decor, factor, range, false);
                view.performHapticFeedback(android.view.HapticFeedbackConstants.LONG_PRESS);
                wakeIdle();
            }
        };
        view.postDelayed(pendingLongPress, DRAG_LONG_PRESS_MS);
    }

    public static boolean onHandleTouch(View view, MotionEvent event) {
        if (!(view.getParent() instanceof View)) return false;
        View decor = (View) view.getParent();
        Log.i(TAG, "handleTouch act=" + event.getActionMasked() + " raw=" + event.getRawX()
                + "," + event.getRawY());
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
                moveWindow(factor, range, fractionX, fractionY, area);
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
        float fractionX = fractionFromWindow(area, decor, factor, range, true);
        float fractionY = fractionFromWindow(area, decor, factor, range, false);
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

    private static float fractionFromWindow(
            View area, View decor, float factor, float[] range, boolean horizontal) {
        Window window = floatingWindow;
        if (window == null) {
            return horizontal ? xFraction(area.getContext()) : yFraction(area.getContext());
        }
        android.view.WindowManager.LayoutParams attributes = window.getAttributes();
        // Same measured offset as moveWindow, so the fraction stored on release describes the
        // position the card was actually released at.
        int[] offset = cardOffsetInWindow(area);
        int[] origin = windowOriginShift(window, attributes);
        if (horizontal) {
            return clamp01((attributes.x + offset[0] + origin[0]) / range[0]);
        }
        return clamp01((attributes.y + offset[1] + origin[1]) / range[1]);
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
        // parentPanel is the stock root container, a direct child of the window's content frame.
        // keyboard_area only looks like the right target but lives inside InputView, whose
        // onLayout repositions and remeasures it on every pass, undoing both the pinned size and
        // the scale. Scaling the root container is what actually sticks.
        // parentPanel comes from the IME library, so looking it up under the app's package name
        // returns nothing. Match the entry name on the content frame's children instead.
        View content = decor.findViewById(android.R.id.content);
        if (content instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) content;
            for (int i = 0; i < group.getChildCount(); i++) {
                View child = group.getChildAt(i);
                try {
                    if ("parentPanel".equals(child.getResources()
                            .getResourceEntryName(child.getId()))) {
                        return child;
                    }
                } catch (Exception ignored) {
                }
            }
        }
        int id = decor.getResources().getIdentifier("keyboard_area", "id", packageName);
        if (id == 0) {
            Log.w(TAG, "id keyboard_area not found in " + packageName);
            return null;
        }
        return decor.findViewById(id);
    }
}
