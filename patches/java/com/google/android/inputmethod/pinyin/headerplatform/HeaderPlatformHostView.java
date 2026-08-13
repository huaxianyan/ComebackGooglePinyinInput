package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;
import android.os.Looper;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.FrameLayout;

/** The single platform-owned extension surface in every universal Header. */
public final class HeaderPlatformHostView extends FrameLayout
        implements HeaderRenderPlanListener, HeaderNativeCandidateStateListener {
    private final FrameLayout leadingHost;
    private final FrameLayout centerHost;
    private final FrameLayout trailingHost;
    private final HeaderRendererRegistry renderers = new HeaderRendererRegistry();
    private final RenderedSlot leadingSlot;
    private final RenderedSlot centerSlot;
    private final RenderedSlot trailingSlot;
    private HeaderPlatformController controller;
    private HeaderChromeFactory chromeFactory;
    private HeaderNativeCandidateSource nativeCandidateSource;
    private View nativeLayer;
    private long boundHeaderToken;
    private HeaderRenderPlan currentPlan = HeaderRenderPlan.idle();
    private long appliedRenderGeneration;

    public HeaderPlatformHostView(Context context) {
        this(context, null);
    }

    public HeaderPlatformHostView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setClipChildren(true);
        setClipToPadding(true);
        setSaveEnabled(false);
        setVisibility(GONE);
        leadingHost = newContainer(context);
        centerHost = newContainer(context);
        trailingHost = newContainer(context);
        addView(centerHost, matchParent());
        addView(leadingHost, wrapContentStart());
        addView(trailingHost, wrapContentEnd());
        leadingSlot = new RenderedSlot(leadingHost, false);
        centerSlot = new RenderedSlot(centerHost, true);
        trailingSlot = new RenderedSlot(trailingHost, false);
        renderers.register(new HeaderNativeActionRenderer());
        if (android.os.Build.VERSION.SDK_INT >= 30) {
            renderers.register(new InlineAutofillRemoteRenderer());
        }
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        HeaderPlatformOwner owner = HeaderPlatformOwners.find(getContext());
        if (owner == null) {
            throw new IllegalStateException("Header platform owner is missing");
        }
        nativeLayer = findNativeLayer();
        if (nativeLayer == null) {
            throw new IllegalStateException("Native Header layer contract is missing");
        }
        chromeFactory = findNearestChromeFactory();
        if (chromeFactory == null || !(chromeFactory instanceof HeaderNativeCandidateSource)) {
            throw new IllegalStateException("Native Header chrome/source contract is missing");
        }
        nativeCandidateSource = (HeaderNativeCandidateSource) chromeFactory;
        controller = owner.getHeaderPlatformController();
        HeaderNativeChromeSnapshot nativeChrome = chromeFactory.captureNativeChrome();
        boundHeaderToken = controller.bindHost(this,
                nativeChrome == null ? null : nativeChrome.getCandidateTextColor()).getToken();
        Log.i("HeaderPlatformAudit", "host attached token=" + boundHeaderToken);
        nativeCandidateSource.setHeaderNativeCandidateStateListener(this);
    }

    @Override
    protected void onDetachedFromWindow() {
        if (nativeCandidateSource != null) {
            nativeCandidateSource.setHeaderNativeCandidateStateListener(null);
        }
        if (controller != null) controller.unbindHost(this);
        if (nativeLayer != null) nativeLayer.setVisibility(VISIBLE);
        controller = null;
        chromeFactory = null;
        nativeCandidateSource = null;
        nativeLayer = null;
        boundHeaderToken = 0L;
        clearContainers();
        currentPlan = HeaderRenderPlan.idle();
        appliedRenderGeneration = 0L;
        setVisibility(GONE);
        super.onDetachedFromWindow();
    }

    @Override
    public void onNativeCandidateStateChanged(boolean active, boolean clipboardOnly) {
        if (controller != null && boundHeaderToken > 0L
                && controller.getCurrentHeaderToken() == boundHeaderToken) {
            controller.setNativeCandidateState(active, clipboardOnly);
        }
    }

    @Override
    public void onHeaderRenderPlanChanged(final HeaderRenderPlan plan) {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            post(new Runnable() {
                @Override public void run() { applyPlan(plan); }
            });
            return;
        }
        applyPlan(plan);
    }

    private void applyPlan(HeaderRenderPlan plan) {
        HeaderRenderPlan next = plan == null ? HeaderRenderPlan.idle() : plan;
        long nextGeneration = next.getRenderGeneration();
        if (nextGeneration > 0L && nextGeneration < appliedRenderGeneration) {
            Log.i("HeaderPlatformAudit", "host ignored stale plan generation="
                    + nextGeneration + " applied=" + appliedRenderGeneration);
            return;
        }
        if (nextGeneration > 0L) appliedRenderGeneration = nextGeneration;
        currentPlan = next;
        Log.i("HeaderPlatformAudit", "host plan native=" + currentPlan.isNativeOwned()
                + " idle=" + currentPlan.isIdle()
                + " center=" + (currentPlan.getCenter() != null));
        if (currentPlan.isNativeOwned()) {
            // Temporary native Candidate ownership must not destroy prepared
            // remote Surfaces. Hide the platform tree and restore it atomically.
            setVisibility(GONE);
            if (nativeLayer != null) nativeLayer.setVisibility(VISIBLE);
            return;
        }
        if (currentPlan.isIdle()) {
            clearContainers();
            setVisibility(GONE);
            if (nativeLayer != null) nativeLayer.setVisibility(VISIBLE);
            return;
        }
        PendingSlot leading = null;
        PendingSlot center = null;
        PendingSlot trailing = null;
        try {
            long generation = currentPlan.getRenderGeneration();
            leading = leadingSlot.prepare(getContext(), currentPlan.getLeading(),
                    generation, renderers, chromeFactory);
            center = centerSlot.prepare(getContext(), currentPlan.getCenter(),
                    generation, renderers, chromeFactory);
            trailing = trailingSlot.prepare(getContext(), currentPlan.getTrailing(),
                    generation, renderers, chromeFactory);
            leading.commit();
            center.commit();
            trailing.commit();
            if (nativeLayer != null) nativeLayer.setVisibility(INVISIBLE);
            setVisibility(VISIBLE);
            bringToFront();
            Log.i("HeaderPlatformAudit", "host visible child=" + getChildCount());
        } catch (RuntimeException failure) {
            Log.i("HeaderPlatformAudit", "host render failed type="
                    + failure.getClass().getSimpleName());
            if (leading != null) leading.cancel();
            if (center != null) center.cancel();
            if (trailing != null) trailing.cancel();
            throw failure;
        }
    }

    HeaderChromeFactory getChromeFactory() { return chromeFactory; }
    HeaderRendererRegistry getRendererRegistry() { return renderers; }
    FrameLayout getLeadingHost() { return leadingHost; }
    FrameLayout getCenterHost() { return centerHost; }
    FrameLayout getTrailingHost() { return trailingHost; }
    HeaderRenderPlan getCurrentPlan() { return currentPlan; }

    private void clearContainers() {
        leadingSlot.clear();
        centerSlot.clear();
        trailingSlot.clear();
    }

    private static FrameLayout newContainer(Context context) {
        FrameLayout view = new FrameLayout(context);
        view.setClipChildren(true);
        view.setClipToPadding(true);
        return view;
    }

    private static LayoutParams matchParent() {
        return new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
    }

    private static LayoutParams wrapContentStart() {
        LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT,
                LayoutParams.MATCH_PARENT);
        params.gravity = android.view.Gravity.START;
        return params;
    }

    private static LayoutParams wrapContentEnd() {
        LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT,
                LayoutParams.MATCH_PARENT);
        params.gravity = android.view.Gravity.END;
        return params;
    }

    private static boolean sameContribution(HeaderContribution first,
            HeaderContribution second) {
        return first == second || (first != null && second != null
                && first.getSessionToken() == second.getSessionToken()
                && first.getHeaderToken() == second.getHeaderToken()
                && first.getModuleId().equals(second.getModuleId())
                && first.getStableId().equals(second.getStableId())
                && first.getPresentationKind() == second.getPresentationKind()
                && first.getPayload() == second.getPayload());
    }

    private static final class RenderedSlot {
        private final FrameLayout container;
        private final boolean fillWidth;
        private HeaderContribution contribution;
        private HeaderRenderedContent content;
        private long renderGeneration;

        RenderedSlot(FrameLayout container, boolean fillWidth) {
            this.container = container;
            this.fillWidth = fillWidth;
        }

        LayoutParams childLayoutParams() {
            return new LayoutParams(fillWidth ? LayoutParams.MATCH_PARENT
                    : LayoutParams.WRAP_CONTENT, LayoutParams.MATCH_PARENT);
        }

        PendingSlot prepare(Context context, HeaderContribution next, long generation,
                HeaderRendererRegistry registry, HeaderChromeFactory chromeFactory) {
            if (sameContribution(contribution, next)) {
                return new PendingSlot(this, next, generation, null, true);
            }
            HeaderRenderedContent prepared = next == null ? null
                    : registry.prepare(context, next, chromeFactory);
            return new PendingSlot(this, next, generation, prepared, false);
        }

        void clear() {
            container.removeAllViews();
            if (content != null) content.release();
            content = null;
            contribution = null;
            renderGeneration = 0L;
        }
    }

    private static final class PendingSlot {
        private final RenderedSlot target;
        private final HeaderContribution contribution;
        private HeaderRenderedContent prepared;
        private final boolean unchanged;
        private final long renderGeneration;
        private boolean committed;

        PendingSlot(RenderedSlot target, HeaderContribution contribution,
                long renderGeneration, HeaderRenderedContent prepared, boolean unchanged) {
            this.target = target;
            this.contribution = contribution;
            this.renderGeneration = renderGeneration;
            this.prepared = prepared;
            this.unchanged = unchanged;
        }

        void commit() {
            if (committed || unchanged) {
                committed = true;
                return;
            }
            View newView = prepared == null ? null : prepared.getView();
            if (newView != null) {
                ViewParent parent = newView.getParent();
                if (parent instanceof ViewGroup) ((ViewGroup) parent).removeView(newView);
                target.container.addView(newView, target.childLayoutParams());
            }
            HeaderRenderedContent old = target.content;
            View oldView = old == null ? null : old.getView();
            if (oldView != null && oldView.getParent() == target.container) {
                target.container.removeView(oldView);
            }
            target.content = prepared;
            target.contribution = contribution;
            target.renderGeneration = renderGeneration;
            prepared = null;
            committed = true;
            if (old != null) old.release();
        }

        void cancel() {
            if (!committed && prepared != null) prepared.release();
            prepared = null;
        }
    }

    private View findNativeLayer() {
        ViewParent parent = getParent();
        if (!(parent instanceof ViewGroup)) return null;
        ViewGroup header = (ViewGroup) parent;
        for (int i = 0; i < header.getChildCount(); i++) {
            View child = header.getChildAt(i);
            Object tag = child.getTag();
            if (tag != null && "header-platform-native-layer".equals(tag.toString())) {
                return child;
            }
        }
        return null;
    }

    private HeaderChromeFactory findNearestChromeFactory() {
        ViewParent ancestor = getParent();
        while (ancestor instanceof View) {
            HeaderChromeFactory result = findChromeFactory((View) ancestor);
            if (result != null) return result;
            ancestor = ancestor.getParent();
        }
        return null;
    }

    private static HeaderChromeFactory findChromeFactory(View view) {
        if (view instanceof HeaderChromeFactory) return (HeaderChromeFactory) view;
        if (!(view instanceof ViewGroup)) return null;
        ViewGroup group = (ViewGroup) view;
        for (int i = 0; i < group.getChildCount(); i++) {
            HeaderChromeFactory result = findChromeFactory(group.getChildAt(i));
            if (result != null) return result;
        }
        return null;
    }
}
