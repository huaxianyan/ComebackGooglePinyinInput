package com.google.android.inputmethod.pinyin.headerplatform;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.os.Build;
import android.view.View;
import android.view.ViewTreeObserver;
import com.google.android.inputmethod.pinyin.ViewFrameRateCompat;
import java.util.LinkedHashSet;

/** Service-owned motion lifetime; the native animation remains the sole motion driver. */
public final class HeaderMotionCoordinator implements HeaderModule {
    private static final String MODULE_ID = "native-motion";
    private Motion active;

    @Override public String getModuleId() { return MODULE_ID; }
    @Override public int getDefaultPriority() { return 0; }
    @Override public void onAttach(HeaderPlatformContext context) {}
    @Override public void onHeaderAvailable(HeaderHandle header) {}
    @Override public void onStartInput(HeaderEditorContext editor, long token) { finish(); }
    @Override public void onHeaderUnavailable(long token) { finish(); }
    @Override public void onNativeCandidateStateChanged(boolean active) {}
    @Override public void onThemeChanged(long token) { finish(); }
    @Override public void onFinishInput(long token) { finish(); }
    @Override public void onDetach() { finish(); }

    public static void prepareNativeMotion(Animator animator, View[] views) {
        if (Build.VERSION.SDK_INT < 36 || animator == null || views == null || views.length == 0 || views[0] == null) return;
        HeaderPlatformOwner owner = HeaderPlatformOwners.find(views[0].getContext());
        if (owner != null) {
            HeaderModule module = owner.getHeaderPlatformController().getRegisteredModule(MODULE_ID);
            if (module instanceof HeaderMotionCoordinator) {
                ((HeaderMotionCoordinator) module).prepare(animator, views);
            }
        }
    }

    public static void finishNativeMotion(android.content.Context context) {
        HeaderPlatformOwner owner = HeaderPlatformOwners.find(context);
        if (owner == null) return;
        HeaderModule module = owner.getHeaderPlatformController().getRegisteredModule(MODULE_ID);
        if (module instanceof HeaderMotionCoordinator) ((HeaderMotionCoordinator) module).finish();
    }

    public void prepare(Animator animator, View[] views) {
        finish();
        LinkedHashSet<View> targets = new LinkedHashSet<View>();
        for (View view : views) {
            if (view == null) continue;
            targets.add(view);
            if (view instanceof HeaderMotionTargetSource) {
                ((HeaderMotionTargetSource) view).appendHeaderMotionTargets(targets);
            }
        }
        if (targets.isEmpty()) return;
        active = new Motion(animator, views[0], targets);
        animator.addListener(active);
    }

    public void finish() {
        if (active != null) active.close();
    }

    private final class Motion extends AnimatorListenerAdapter
            implements View.OnAttachStateChangeListener, ViewTreeObserver.OnPreDrawListener {
        private final Animator animator;
        private final View anchor;
        private final LinkedHashSet<View> targets;
        private ViewTreeObserver observer;
        private boolean requested;

        Motion(Animator animator, View anchor, LinkedHashSet<View> targets) {
            this.animator = animator; this.anchor = anchor; this.targets = targets;
        }

        @Override public void onAnimationStart(Animator animation) {
            requested = true;
            for (View target : targets) ViewFrameRateCompat.requestHigh(target, true);
            anchor.addOnAttachStateChangeListener(this);
            observer = anchor.getViewTreeObserver();
            observer.addOnPreDrawListener(this);
        }

        void close() {
            if (requested) {
                requested = false;
                for (View target : targets) ViewFrameRateCompat.requestHigh(target, false);
            }
            anchor.removeOnAttachStateChangeListener(this);
            if (observer != null && observer.isAlive()) observer.removeOnPreDrawListener(this);
            observer = null;
            animator.removeListener(this);
            if (active == this) active = null;
        }

        @Override public void onAnimationEnd(Animator animation) { close(); }
        @Override public void onAnimationCancel(Animator animation) { close(); }
        @Override public void onViewDetachedFromWindow(View view) { close(); }
        @Override public void onViewAttachedToWindow(View view) {}
        @Override public boolean onPreDraw() {
            for (View target : targets) if (target.isShown()) return true;
            close();
            return true;
        }
    }
}
