package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.util.Size;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InlineSuggestion;
import android.view.inputmethod.InlineSuggestionsRequest;
import android.view.inputmethod.InlineSuggestionsResponse;
import android.widget.inline.InlineContentView;
import android.widget.inline.InlinePresentationSpec;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

/** API 30+ bridge and lifecycle controller for Android's standard Inline Autofill protocol. */
public final class InlineAutofillCompat {
    private static final int API_R = 30;
    private static final int HEADER_HEIGHT_RES_ID = 0x7f0d00a9;
    private static final int PRESENTATION_COUNT = 3;
    private static final float MIN_CHIP_WIDTH_DP = 48.0f;
    private static final float MAX_CHIP_WIDTH_DP = 240.0f;
    private static final long INFLATION_TIMEOUT_MS = 1200L;

    private static final Handler MAIN_HANDLER = new Handler(Looper.getMainLooper());
    private static int generation;
    private static boolean activeInputSession;
    private static int pendingCount;
    private static View[] pendingViews;
    private static boolean[] completedInflations;
    private static WeakReference<InlineAutofillClipHost> pendingHost;
    private static Runnable timeout;
    private static boolean published;

    private InlineAutofillCompat() {}

    public static synchronized void startInputSession() {
        generation++;
        activeInputSession = true;
        cancelPendingLocked();
        InlineAutofillClipHost.clearAllHosts();
    }

    public static synchronized InlineSuggestionsRequest createRequest(
            Context context, Bundle uiExtras) {
        if (Build.VERSION.SDK_INT < API_R || context == null) {
            return null;
        }
        generation++;
        activeInputSession = true;
        cancelPendingLocked();
        InlineAutofillClipHost.clearAllHosts();

        Resources resources = context.getResources();
        DisplayMetrics metrics = resources.getDisplayMetrics();
        int height = resources.getDimensionPixelSize(HEADER_HEIGHT_RES_ID);
        int minWidth = Math.max(1, Math.round(MIN_CHIP_WIDTH_DP * metrics.density));
        int requestedMaxWidth = Math.max(
                minWidth, Math.round(MAX_CHIP_WIDTH_DP * metrics.density));
        int availableWidth = metrics.widthPixels > 0 ? metrics.widthPixels : requestedMaxWidth;
        int maxWidth = Math.max(minWidth, Math.min(requestedMaxWidth, availableWidth));

        Size minSize = new Size(minWidth, height);
        Size maxSize = new Size(maxWidth, height);
        InlinePresentationSpec spec =
                new InlinePresentationSpec.Builder(minSize, maxSize).build();
        ArrayList<InlinePresentationSpec> specs =
                new ArrayList<InlinePresentationSpec>(PRESENTATION_COUNT);
        for (int i = 0; i < PRESENTATION_COUNT; i++) {
            specs.add(spec);
        }
        return new InlineSuggestionsRequest.Builder(specs)
                .setMaxSuggestionCount(PRESENTATION_COUNT)
                .build();
    }

    public static synchronized boolean handleResponse(final InlineSuggestionsResponse response) {
        generation++;
        cancelPendingLocked();
        InlineAutofillClipHost.clearAllHosts();
        if (!activeInputSession || response == null) {
            return false;
        }

        final InlineAutofillClipHost host = InlineAutofillClipHost.findCurrentHost();
        if (host == null) {
            return false;
        }
        List<InlineSuggestion> suggestions = response.getInlineSuggestions();
        int count = suggestions == null ? 0 : Math.min(PRESENTATION_COUNT, suggestions.size());
        if (count == 0) {
            return true;
        }

        final int callbackGeneration = generation;
        final WeakReference<InlineAutofillClipHost> hostReference =
                new WeakReference<InlineAutofillClipHost>(host);
        pendingCount = count;
        pendingViews = new View[count];
        completedInflations = new boolean[count];
        pendingHost = hostReference;
        published = false;
        final Executor executor = host.getContext().getMainExecutor();
        final int height = host.getResources().getDimensionPixelSize(HEADER_HEIGHT_RES_ID);
        final Size inflateSize = new Size(ViewGroup.LayoutParams.WRAP_CONTENT, height);

        for (int i = 0; i < count; i++) {
            final int index = i;
            try {
                suggestions.get(i).inflate(
                        host.getContext(),
                        inflateSize,
                        executor,
                        new Consumer<InlineContentView>() {
                            @Override
                            public void accept(InlineContentView view) {
                                acceptInflated(callbackGeneration, hostReference.get(), index, view);
                            }
                        });
            } catch (RuntimeException failure) {
                acceptInflated(callbackGeneration, hostReference.get(), index, null);
            }
        }

        if (!published) {
            timeout = new Runnable() {
                @Override
                public void run() {
                    publishPartial(callbackGeneration, hostReference.get());
                }
            };
            MAIN_HANDLER.postDelayed(timeout, INFLATION_TIMEOUT_MS);
        }
        return true;
    }

    private static synchronized void acceptInflated(
            int callbackGeneration, InlineAutofillClipHost host, int index, View view) {
        if (!isCurrentLocked(callbackGeneration, host) || published
                || index < 0 || index >= pendingViews.length || completedInflations[index]) {
            return;
        }
        completedInflations[index] = true;
        pendingViews[index] = view;
        pendingCount--;
        if (pendingCount == 0) {
            publishLocked(callbackGeneration, host);
        }
    }

    private static synchronized void publishPartial(
            int callbackGeneration, InlineAutofillClipHost host) {
        if (isCurrentLocked(callbackGeneration, host) && !published) {
            publishLocked(callbackGeneration, host);
        }
    }

    private static boolean isCurrentLocked(int callbackGeneration, InlineAutofillClipHost host) {
        return callbackGeneration == generation
                && activeInputSession
                && host != null
                && host.isAvailable()
                && pendingHost != null
                && pendingHost.get() == host
                && pendingViews != null;
    }

    private static void publishLocked(int callbackGeneration, InlineAutofillClipHost host) {
        if (!isCurrentLocked(callbackGeneration, host) || published) {
            return;
        }
        published = true;
        if (timeout != null) {
            MAIN_HANDLER.removeCallbacks(timeout);
            timeout = null;
        }
        ArrayList<View> views = new ArrayList<View>(pendingViews.length);
        for (View view : pendingViews) {
            if (view != null) {
                views.add(view);
            }
        }
        pendingViews = null;
        completedInflations = null;
        pendingHost = null;
        pendingCount = 0;
        if (views.isEmpty()) {
            host.clearInlineViews();
        } else {
            host.setInlineViews(views);
        }
    }

    private static void cancelPendingLocked() {
        if (timeout != null) {
            MAIN_HANDLER.removeCallbacks(timeout);
            timeout = null;
        }
        pendingCount = 0;
        pendingViews = null;
        completedInflations = null;
        pendingHost = null;
        published = false;
    }

    public static void applyRemoteClip(View view, android.graphics.Rect clipBounds) {
        if (Build.VERSION.SDK_INT >= API_R && view != null) {
            view.setClipBounds(clipBounds);
        }
    }

    public static synchronized void clear() {
        generation++;
        activeInputSession = false;
        cancelPendingLocked();
        InlineAutofillClipHost.clearAllHosts();
    }
}
