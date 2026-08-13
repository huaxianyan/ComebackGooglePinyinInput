package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;
import android.graphics.Rect;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.FrameLayout;

import java.util.ArrayList;
import java.util.List;

/** One pre-mounted, clipped Inline Autofill carousel inside native Header chrome. */
final class InlineAutofillRemoteContent implements HeaderRenderedContent,
        View.OnLayoutChangeListener, Runnable {
    private static final int RAIL_WIDTH_RES_ID = 0x7f0d0206;
    private static final int PREVIOUS_DESCRIPTION_RES_ID = 0x7f110200;
    private static final int NEXT_DESCRIPTION_RES_ID = 0x7f1101ff;

    private final FrameLayout root;
    private final HeaderVisualSlot candidateSlot;
    private final HeaderActionSlot previousSlot;
    private final HeaderActionSlot nextSlot;
    private final ArrayList<View> views = new ArrayList<View>();
    private final Rect hostRect = new Rect();
    private final Rect childRect = new Rect();
    private final int railWidth;
    private final int leadingInset;
    private final int trailingInset;
    private final HeaderRemoteSurfaceClipper clipper;
    private int currentIndex;
    private boolean released;

    InlineAutofillRemoteContent(Context context, InlineAutofillRemotePayload payload,
            HeaderChromeFactory chromeFactory) {
        if (chromeFactory == null) throw new IllegalArgumentException("chrome factory is missing");
        clipper = payload.getClipper();
        root = new FrameLayout(context);
        root.setClipChildren(true);
        root.setClipToPadding(true);
        root.setSaveEnabled(false);
        int fallbackRailWidth = context.getResources().getDimensionPixelSize(
                RAIL_WIDTH_RES_ID);

        candidateSlot = chromeFactory.createCandidateChromeSlot();
        // Rails already define both outer boundaries; the Candidate slot's
        // trailing divider would be a duplicate separator beside the account.
        candidateSlot.getSeparator().setVisibility(View.GONE);
        previousSlot = chromeFactory.createActionChromeSlot(HeaderActionKind.PREVIOUS);
        nextSlot = chromeFactory.createActionChromeSlot(HeaderActionKind.NEXT);
        railWidth = nextSlot.getRailWidth() > 0
                ? nextSlot.getRailWidth() : fallbackRailWidth;
        leadingInset = previousSlot.getLeadingInset();
        trailingInset = nextSlot.getTrailingInset();
        root.addView(candidateSlot.getRoot(), centerParams(context, payload.getViews()));
        root.addView(previousSlot.getRoot(), railParams(Gravity.START, leadingInset));
        root.addView(nextSlot.getRoot(), railParams(Gravity.END, trailingInset));
        previousSlot.getRoot().setContentDescription(
                context.getText(PREVIOUS_DESCRIPTION_RES_ID));
        nextSlot.getRoot().setContentDescription(context.getText(NEXT_DESCRIPTION_RES_ID));
        previousSlot.getRoot().setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View ignored) { showIndex(currentIndex - 1); }
        });
        nextSlot.getRoot().setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View ignored) { showIndex(currentIndex + 1); }
        });
        mount(payload.getViews());
        root.addOnLayoutChangeListener(this);
        showIndex(0);
    }

    @Override public View getView() { return root; }

    @Override
    public void release() {
        if (released) return;
        released = true;
        root.removeCallbacks(this);
        root.removeOnLayoutChangeListener(this);
        for (View view : views) {
            clipper.applyClip(view, null);
            view.setTranslationX(0.0f);
            view.setEnabled(true);
            view.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_AUTO);
        }
        candidateSlot.clear();
        previousSlot.clear();
        nextSlot.clear();
        views.clear();
        root.removeAllViews();
    }

    @Override
    public void onLayoutChange(View view, int left, int top, int right, int bottom,
            int oldLeft, int oldTop, int oldRight, int oldBottom) {
        updateRemoteClip();
    }

    @Override public void run() { updateRemoteClip(); }

    private void mount(List<View> source) {
        FrameLayout content = candidateSlot.getContentHost();
        for (View view : source) {
            ViewParent parent = view.getParent();
            if (parent instanceof ViewGroup) ((ViewGroup) parent).removeView(view);
            ViewGroup.LayoutParams old = view.getLayoutParams();
            int width = old != null && old.width > 0
                    ? old.width : ViewGroup.LayoutParams.MATCH_PARENT;
            int height = old != null && old.height > 0
                    ? old.height : ViewGroup.LayoutParams.MATCH_PARENT;
            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                    width, height, Gravity.CENTER);
            content.addView(view, params);
            views.add(view);
        }
    }

    private void showIndex(int index) {
        if (released || index < 0 || index >= views.size()) return;
        currentIndex = index;
        Rect empty = new Rect(0, 0, 0, 0);
        for (int i = 0; i < views.size(); i++) {
            View view = views.get(i);
            boolean current = i == currentIndex;
            view.setTranslationX(0.0f);
            view.setVisibility(current ? View.VISIBLE : View.INVISIBLE);
            view.setEnabled(current);
            view.setImportantForAccessibility(current
                    ? View.IMPORTANT_FOR_ACCESSIBILITY_AUTO
                    : View.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS);
            if (!current) clipper.applyClip(view, empty);
        }
        // Keep both rails mounted for every non-empty contribution. Stable
        // outer geometry prevents the remote Surface from shifting when a
        // bounded partial response later adds or removes suggestions.
        previousSlot.getRoot().setVisibility(View.VISIBLE);
        nextSlot.getRoot().setVisibility(View.VISIBLE);
        previousSlot.setEnabled(currentIndex > 0);
        nextSlot.setEnabled(currentIndex + 1 < views.size());
        root.post(this);
    }

    private void updateRemoteClip() {
        FrameLayout content = candidateSlot.getContentHost();
        if (released || views.isEmpty() || root.getVisibility() != View.VISIBLE
                || content.getWidth() <= 0 || content.getHeight() <= 0) return;
        for (int i = 0; i < views.size(); i++) {
            View child = views.get(i);
            if (i != currentIndex) {
                clipper.applyClip(child, new Rect(0, 0, 0, 0));
                continue;
            }
            // InlineContentView owns an embedded Surface whose reported screen
            // location can include Surface-layer transforms. Mixing
            // getLocationOnScreen() with a normal View global rect produced a
            // fictitious +126,+63 offset on Pixel landscape and clipped a
            // 496x97 child to 370x34. Convert the host-local bounds through the
            // actual View ancestry instead, matching Android's reference IME
            // clipping algorithm.
            hostRect.set(0, 0, content.getWidth(), content.getHeight());
            childRect.set(hostRect);
            content.offsetRectIntoDescendantCoords(child, childRect);
            if (!childRect.intersect(0, 0, child.getWidth(), child.getHeight())) {
                childRect.set(0, 0, 0, 0);
            }
            Log.i("HeaderPlatformAudit", "inline layout index=" + i
                    + " root=" + root.getWidth() + "x" + root.getHeight()
                    + " host=" + content.getWidth() + "x" + content.getHeight()
                    + " child=" + child.getWidth() + "x" + child.getHeight()
                    + " local=" + child.getLeft() + "," + child.getTop()
                    + " clip=" + childRect.left + "," + childRect.top + ","
                    + childRect.right + "," + childRect.bottom);
            clipper.applyClip(child, new Rect(childRect));
        }
    }

    private FrameLayout.LayoutParams centerParams(Context context, List<View> remoteViews) {
        int fallback = Math.max(1,
                Math.round(240.0f * context.getResources().getDisplayMetrics().density));
        int width = 0;
        for (View view : remoteViews) {
            ViewGroup.LayoutParams params = view.getLayoutParams();
            if (params != null && params.width > width) width = params.width;
        }
        if (width <= 0) width = fallback;
        return new FrameLayout.LayoutParams(width,
                ViewGroup.LayoutParams.MATCH_PARENT, Gravity.CENTER);
    }

    private FrameLayout.LayoutParams railParams(int gravity, int outerInset) {
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(railWidth,
                ViewGroup.LayoutParams.MATCH_PARENT, gravity);
        if (gravity == Gravity.START) params.leftMargin = outerInset;
        else params.rightMargin = outerInset;
        return params;
    }
}
