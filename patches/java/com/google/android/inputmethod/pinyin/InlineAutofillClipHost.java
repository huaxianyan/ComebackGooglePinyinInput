package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.graphics.Rect;
import android.os.Build;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/** API-neutral Header host for API 30+ remote InlineContentView instances. */
public final class InlineAutofillClipHost extends FrameLayout
        implements View.OnLayoutChangeListener, ViewTreeObserver.OnScrollChangedListener,
        Runnable {
    private static final ArrayList<WeakReference<InlineAutofillClipHost>> HOSTS =
            new ArrayList<WeakReference<InlineAutofillClipHost>>();
    private static boolean nativeCandidatesActive;

    private final HorizontalScrollView scrollView;
    private final LinearLayout row;
    private final IdentityHashMap<View, SiblingState> hiddenSiblings =
            new IdentityHashMap<View, SiblingState>();
    private final Rect hostRect = new Rect();
    private final Rect childRect = new Rect();
    private final int[] childLocation = new int[2];
    private boolean observingScroll;

    public InlineAutofillClipHost(Context context) {
        this(context, null);
    }

    public InlineAutofillClipHost(Context context, AttributeSet attrs) {
        super(context, attrs);
        setClipChildren(true);
        setClipToPadding(true);
        setClickable(true);
        setFocusable(false);
        setSaveEnabled(false);

        scrollView = new HorizontalScrollView(context);
        scrollView.setClipChildren(true);
        scrollView.setClipToPadding(true);
        scrollView.setFillViewport(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.setHorizontalFadingEdgeEnabled(false);
        scrollView.setOverScrollMode(View.OVER_SCROLL_NEVER);
        scrollView.setFocusable(false);

        row = new LinearLayout(context);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(android.view.Gravity.CENTER_VERTICAL);
        row.setClipChildren(true);
        row.setClipToPadding(true);
        scrollView.addView(row, new HorizontalScrollView.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.MATCH_PARENT));
        addView(scrollView, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        addOnLayoutChangeListener(this);
    }

    public static synchronized void onCandidates(List<?> candidates) {
        nativeCandidatesActive = candidates != null && !candidates.isEmpty();
        updateHostsForCandidatePriority();
    }

    public static synchronized void onCandidatesCleared() {
        nativeCandidatesActive = false;
        updateHostsForCandidatePriority();
    }

    public static synchronized boolean areNativeCandidatesActive() {
        return nativeCandidatesActive;
    }

    public static synchronized InlineAutofillClipHost findCurrentHost() {
        pruneHosts();
        for (int i = HOSTS.size() - 1; i >= 0; i--) {
            InlineAutofillClipHost host = HOSTS.get(i).get();
            if (host != null && host.isAvailable()) {
                return host;
            }
        }
        return null;
    }

    public static synchronized void clearAllHosts() {
        pruneHosts();
        for (WeakReference<InlineAutofillClipHost> reference : HOSTS) {
            InlineAutofillClipHost host = reference.get();
            if (host != null) {
                host.clearInlineViews();
            }
        }
    }

    private static void updateHostsForCandidatePriority() {
        pruneHosts();
        for (WeakReference<InlineAutofillClipHost> reference : HOSTS) {
            InlineAutofillClipHost host = reference.get();
            if (host != null) {
                host.applyCandidatePriority(nativeCandidatesActive);
            }
        }
    }

    private static void pruneHosts() {
        Iterator<WeakReference<InlineAutofillClipHost>> iterator = HOSTS.iterator();
        while (iterator.hasNext()) {
            if (iterator.next().get() == null) {
                iterator.remove();
            }
        }
    }

    private static synchronized void register(InlineAutofillClipHost host) {
        pruneHosts();
        for (WeakReference<InlineAutofillClipHost> reference : HOSTS) {
            if (reference.get() == host) {
                return;
            }
        }
        HOSTS.add(new WeakReference<InlineAutofillClipHost>(host));
    }

    private static synchronized void unregister(InlineAutofillClipHost host) {
        Iterator<WeakReference<InlineAutofillClipHost>> iterator = HOSTS.iterator();
        while (iterator.hasNext()) {
            InlineAutofillClipHost value = iterator.next().get();
            if (value == null || value == host) {
                iterator.remove();
            }
        }
    }

    public boolean isAvailable() {
        if (getWindowToken() == null) {
            return false;
        }
        ViewParent parent = getParent();
        return parent instanceof View && ((View) parent).isShown();
    }

    public void setInlineViews(List<? extends View> views) {
        clearRowOnly();
        int spacing = Math.max(1, Math.round(4.0f * getResources().getDisplayMetrics().density));
        int index = 0;
        for (View view : views) {
            if (view == null) {
                continue;
            }
            ViewParent parent = view.getParent();
            if (parent instanceof ViewGroup) {
                ((ViewGroup) parent).removeView(view);
            }
            ViewGroup.LayoutParams source = view.getLayoutParams();
            int width = source != null ? source.width : ViewGroup.LayoutParams.WRAP_CONTENT;
            int height = source != null ? source.height : ViewGroup.LayoutParams.MATCH_PARENT;
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(width, height);
            if (index > 0) {
                params.leftMargin = spacing;
            }
            row.addView(view, params);
            index++;
        }
        applyCandidatePriority(areNativeCandidatesActive());
        post(this);
    }

    public void clearInlineViews() {
        removeCallbacks(this);
        clearRowOnly();
        restoreSiblings();
        setVisibility(View.GONE);
    }

    private void clearRowOnly() {
        if (Build.VERSION.SDK_INT >= 30) {
            for (int i = 0; i < row.getChildCount(); i++) {
                InlineAutofillCompat.applyRemoteClip(row.getChildAt(i), null);
            }
        }
        row.removeAllViews();
        scrollView.scrollTo(0, 0);
    }

    private void applyCandidatePriority(boolean candidatesActive) {
        if (row.getChildCount() == 0 || candidatesActive || !isAvailable()) {
            restoreSiblings();
            setVisibility(View.GONE);
            return;
        }
        hideSiblings();
        setVisibility(View.VISIBLE);
        bringToFront();
        post(this);
    }

    private void hideSiblings() {
        ViewParent parent = getParent();
        if (!(parent instanceof ViewGroup)) {
            return;
        }
        ViewGroup group = (ViewGroup) parent;
        for (int i = 0; i < group.getChildCount(); i++) {
            View sibling = group.getChildAt(i);
            if (sibling == this || hiddenSiblings.containsKey(sibling)) {
                continue;
            }
            hiddenSiblings.put(sibling, new SiblingState(
                    sibling.getAlpha(), sibling.getImportantForAccessibility()));
            sibling.setAlpha(0.0f);
            sibling.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS);
        }
    }

    private void restoreSiblings() {
        for (Map.Entry<View, SiblingState> entry : hiddenSiblings.entrySet()) {
            View sibling = entry.getKey();
            SiblingState state = entry.getValue();
            sibling.setAlpha(state.alpha);
            sibling.setImportantForAccessibility(state.importantForAccessibility);
        }
        hiddenSiblings.clear();
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        register(this);
        ViewTreeObserver observer = scrollView.getViewTreeObserver();
        if (observer.isAlive()) {
            observer.addOnScrollChangedListener(this);
            observingScroll = true;
        }
        applyCandidatePriority(areNativeCandidatesActive());
    }

    @Override
    protected void onDetachedFromWindow() {
        if (observingScroll) {
            ViewTreeObserver observer = scrollView.getViewTreeObserver();
            if (observer.isAlive()) {
                observer.removeOnScrollChangedListener(this);
            }
            observingScroll = false;
        }
        unregister(this);
        clearInlineViews();
        super.onDetachedFromWindow();
    }

    @Override
    public void onLayoutChange(View view, int left, int top, int right, int bottom,
            int oldLeft, int oldTop, int oldRight, int oldBottom) {
        updateRemoteClipBounds();
    }

    @Override
    public void onScrollChanged() {
        updateRemoteClipBounds();
    }

    @Override
    public void run() {
        updateRemoteClipBounds();
    }

    private void updateRemoteClipBounds() {
        if (Build.VERSION.SDK_INT < 30 || getVisibility() != View.VISIBLE
                || !getGlobalVisibleRect(hostRect)) {
            return;
        }
        for (int i = 0; i < row.getChildCount(); i++) {
            View child = row.getChildAt(i);
            child.getLocationOnScreen(childLocation);
            childRect.set(
                    childLocation[0],
                    childLocation[1],
                    childLocation[0] + child.getWidth(),
                    childLocation[1] + child.getHeight());
            if (!childRect.intersect(hostRect)) {
                InlineAutofillCompat.applyRemoteClip(child, new Rect(0, 0, 0, 0));
                continue;
            }
            childRect.offset(-childLocation[0], -childLocation[1]);
            InlineAutofillCompat.applyRemoteClip(child, new Rect(childRect));
        }
    }

    private static final class SiblingState {
        final float alpha;
        final int importantForAccessibility;

        SiblingState(float alpha, int importantForAccessibility) {
            this.alpha = alpha;
            this.importantForAccessibility = importantForAccessibility;
        }
    }
}
