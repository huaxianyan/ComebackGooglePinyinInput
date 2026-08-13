package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.Size;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.view.inputmethod.InlineSuggestion;
import android.view.inputmethod.InlineSuggestionsRequest;
import android.view.inputmethod.InlineSuggestionsResponse;
import android.widget.inline.InlineContentView;
import android.widget.inline.InlinePresentationSpec;

import com.google.android.apps.inputmethod.libs.framework.keyboard.IKeyboardTheme;
import com.google.android.inputmethod.pinyin.headerplatform.HeaderModule;
import com.google.android.inputmethod.pinyin.headerplatform.HeaderPlatformOwner;
import com.google.android.inputmethod.pinyin.headerplatform.HeaderPlatformOwners;
import com.google.android.inputmethod.pinyin.headerplatform.HeaderRemoteSurfaceClipper;
import com.google.android.inputmethod.pinyin.headerplatform.InlineAutofillHeaderModule;

import androidx.autofill.inline.UiVersions;
import androidx.autofill.inline.common.TextViewStyle;
import androidx.autofill.inline.common.ViewStyle;
import androidx.autofill.inline.v1.InlineSuggestionUi;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

/** API 30+ bridge and lifecycle controller for Android's standard Inline Autofill protocol. */
public final class InlineAutofillCompat {
    private static final String DIAGNOSTIC_TAG = "HeaderPlatformAudit";
    private static final int API_R = 30;
    private static final int HEADER_HEIGHT_RES_ID = 0x7f0d00a9;
    private static final int RAIL_WIDTH_RES_ID = 0x7f0d0206;
    private static final int ATTR_COLOR_LABEL_CANDIDATE = 0x7f010066;
    private static final int LAYOUT_SOFTKEY_CANDIDATE = 0x7f040171;
    private static final int ID_CANDIDATE_LABEL = 0x7f0f0183;
    private static final int PRESENTATION_SPEC_COUNT = 3;
    private static final int MAX_SUGGESTION_COUNT = 6;
    private static final float MIN_CHIP_WIDTH_DP = 48.0f;
    private static final float MAX_CHIP_WIDTH_DP = 240.0f;
    private static final long INFLATION_TIMEOUT_MS = 1200L;

    private static final Handler MAIN_HANDLER = new Handler(Looper.getMainLooper());
    private static final HeaderRemoteSurfaceClipper REMOTE_CLIPPER =
            new HeaderRemoteSurfaceClipper() {
                @Override
                public void applyClip(View view, android.graphics.Rect bounds) {
                    applyRemoteClip(view, bounds);
                }
            };
    private static int generation;
    private static boolean activeInputSession;
    private static int pendingCount;
    private static View[] pendingViews;
    private static boolean[] completedInflations;
    private static WeakReference<InlineAutofillHeaderModule> pendingModule;
    private static long pendingSessionToken;
    private static long pendingHeaderToken;
    private static Runnable timeout;
    private static boolean published;
    private static Integer activeRequestCandidateTextColor;

    private InlineAutofillCompat() {}

    public static synchronized void startInputSession() {
        generation++;
        activeInputSession = true;
        cancelPendingLocked();
        Log.i(DIAGNOSTIC_TAG, "inline session started generation=" + generation);
    }

    public static synchronized InlineSuggestionsRequest createRequest(
            Context context, Bundle uiExtras) {
        if (Build.VERSION.SDK_INT < API_R || context == null) {
            Log.i(DIAGNOSTIC_TAG, "inline request rejected api/context");
            return null;
        }
        generation++;
        activeInputSession = true;
        cancelPendingLocked();
        InlineAutofillHeaderModule module = findModule(context);
        Log.i(DIAGNOSTIC_TAG, "inline request generation=" + generation
                + " module=" + (module != null)
                + " session=" + (module != null && module.isSessionAvailable())
                + " header=" + (module != null && module.getHeaderToken() > 0L));
        if (module != null) module.clearRemoteViews();

        Resources resources = context.getResources();
        DisplayMetrics metrics = resources.getDisplayMetrics();
        int height = resources.getDimensionPixelSize(HEADER_HEIGHT_RES_ID);
        int minWidth = Math.max(1, Math.round(MIN_CHIP_WIDTH_DP * metrics.density));
        int requestedMaxWidth = Math.max(
                minWidth, Math.round(MAX_CHIP_WIDTH_DP * metrics.density));
        int railWidth = resources.getDimensionPixelSize(RAIL_WIDTH_RES_ID);
        int screenWidth = metrics.widthPixels > 0 ? metrics.widthPixels : requestedMaxWidth;
        int availableWidth = Math.max(minWidth, screenWidth - (2 * railWidth));
        int maxWidth = Math.max(minWidth, Math.min(requestedMaxWidth, availableWidth));

        Size minSize = new Size(minWidth, height);
        Size maxSize = new Size(maxWidth, height);
        // A bound Header is the authoritative runtime theme source. Only
        // fall back to isolated native-shell resolution when Framework asks
        // before the new Header exists.
        Integer nativeCandidateColor = module == null
                ? null : module.getCurrentCandidateTextColor();
        if (nativeCandidateColor == null) {
            nativeCandidateColor = resolveKeyboardThemeCandidateColor(
                    context, ATTR_COLOR_LABEL_CANDIDATE);
        }
        activeRequestCandidateTextColor = nativeCandidateColor;
        Log.i(DIAGNOSTIC_TAG, "inline request geometry orientation="
                + resources.getConfiguration().orientation
                + " night=" + (resources.getConfiguration().uiMode
                        & android.content.res.Configuration.UI_MODE_NIGHT_MASK)
                + " screen=" + screenWidth + "x" + metrics.heightPixels
                + " specMin=" + minWidth + "x" + height
                + " specMax=" + maxWidth + "x" + height);
        // Official AndroidX protocol bundle required by ExtServices to render
        // androidx.autofill.inline.v1 Slice presentations. Native chrome remains
        // platform-owned; these styles only make the remote payload renderable.
        ViewStyle chipStyle = new ViewStyle.Builder()
                .setBackgroundColor(0x00000000)
                .setPadding(0, 0, 0, 0)
                .setLayoutMargin(0, 0, 0, 0)
                .build();
        // Keep Provider/Framework typography unchanged. The foreground is an
        // advisory request style resolved from an empty native Candidate shell
        // through the same keyboard theme, bbc inflater, View style-sheet, and
        // drawable state as the real Candidate. No Provider payload is read.
        TextViewStyle.Builder titleStyleBuilder = new TextViewStyle.Builder();
        TextViewStyle.Builder subtitleStyleBuilder = new TextViewStyle.Builder();
        if (nativeCandidateColor != null) {
            int textColor = nativeCandidateColor.intValue();
            titleStyleBuilder.setTextColor(textColor);
            subtitleStyleBuilder.setTextColor(textColor);
        }
        TextViewStyle titleStyle = titleStyleBuilder.build();
        TextViewStyle subtitleStyle = subtitleStyleBuilder.build();
        Bundle styles = UiVersions.newStylesBuilder()
                .addStyle(InlineSuggestionUi.newStyleBuilder()
                        .setChipStyle(chipStyle)
                        .setSingleIconChipStyle(chipStyle)
                        .setTitleStyle(titleStyle)
                        .setSubtitleStyle(subtitleStyle)
                        .build())
                .build();
        InlinePresentationSpec spec = new InlinePresentationSpec.Builder(minSize, maxSize)
                .setStyle(styles)
                .build();
        ArrayList<InlinePresentationSpec> specs =
                new ArrayList<InlinePresentationSpec>(PRESENTATION_SPEC_COUNT);
        for (int i = 0; i < PRESENTATION_SPEC_COUNT; i++) {
            specs.add(spec);
        }
        return new InlineSuggestionsRequest.Builder(specs)
                .setMaxSuggestionCount(MAX_SUGGESTION_COUNT)
                .build();
    }

    public static synchronized boolean handleResponse(
            final Context context, final InlineSuggestionsResponse response) {
        if (!activeInputSession || context == null || response == null) {
            Log.i(DIAGNOSTIC_TAG, "inline response rejected active/context/response");
            return false;
        }

        final InlineAutofillHeaderModule module = findModule(context);
        if (module == null || !module.isSessionAvailable()) {
            Log.i(DIAGNOSTIC_TAG, "inline response rejected module/session module="
                    + (module != null));
            return false;
        }
        List<InlineSuggestion> suggestions = response.getInlineSuggestions();
        int count = suggestions == null ? 0 : Math.min(MAX_SUGGESTION_COUNT, suggestions.size());
        if (count == 0) {
            // Framework can emit an empty companion response immediately after
            // a non-empty response for the same editor. Preserve only a
            // non-empty response whose asynchronous inflation is still in
            // flight. Once no inflation is pending, an empty response is an
            // explicit invalidation of any published remote Surfaces (for
            // example when a password vault is locked).
            Log.i(DIAGNOSTIC_TAG, "inline empty response pending=" + (pendingViews != null)
                    + " published=" + published);
            if (pendingViews == null) {
                module.clearRemoteViews();
                published = false;
            }
            return true;
        }

        generation++;
        cancelPendingLocked();
        module.clearRemoteViews();
        Log.i(DIAGNOSTIC_TAG, "inline response accepted count=" + count
                + " generation=" + generation + " header=" + (module.getHeaderToken() > 0L));
        final int callbackGeneration = generation;
        final WeakReference<InlineAutofillHeaderModule> moduleReference =
                new WeakReference<InlineAutofillHeaderModule>(module);
        pendingCount = count;
        pendingViews = new View[count];
        completedInflations = new boolean[count];
        pendingModule = moduleReference;
        pendingSessionToken = module.getSessionToken();
        pendingHeaderToken = module.getHeaderToken();
        published = false;
        final Executor executor = context.getMainExecutor();
        // Responses retain the presentation spec from the request that created
        // them. During rotation or theme/configuration replacement, current
        // resource dimensions can already differ from that spec. WRAP_CONTENT
        // is explicitly valid for both axes and lets Framework constrain the
        // remote view to its own immutable min/max contract.
        final Size inflateSize = new Size(ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);

        for (int i = 0; i < count; i++) {
            final int index = i;
            try {
                suggestions.get(i).inflate(
                        context,
                        inflateSize,
                        executor,
                        new Consumer<InlineContentView>() {
                            @Override
                            public void accept(InlineContentView view) {
                                acceptInflated(callbackGeneration, moduleReference.get(), index, view);
                            }
                        });
            } catch (RuntimeException failure) {
                Log.i(DIAGNOSTIC_TAG, "inline inflate threw index=" + index
                        + " type=" + failure.getClass().getSimpleName());
                acceptInflated(callbackGeneration, moduleReference.get(), index, null);
            }
        }

        if (!published) {
            timeout = new Runnable() {
                @Override
                public void run() {
                    publishPartial(callbackGeneration, moduleReference.get());
                }
            };
            MAIN_HANDLER.postDelayed(timeout, INFLATION_TIMEOUT_MS);
        }
        return true;
    }

    private static synchronized void acceptInflated(
            int callbackGeneration, InlineAutofillHeaderModule module, int index, View view) {
        if (!isCurrentLocked(callbackGeneration, module) || published
                || index < 0 || index >= pendingViews.length || completedInflations[index]) {
            return;
        }
        completedInflations[index] = true;
        pendingViews[index] = view;
        ViewGroup.LayoutParams params = view == null ? null : view.getLayoutParams();
        Log.i(DIAGNOSTIC_TAG, "inline inflate callback index=" + index
                + " view=" + (view != null)
                + " size=" + (view == null ? "none" : view.getWidth() + "x" + view.getHeight())
                + " measured=" + (view == null ? "none"
                        : view.getMeasuredWidth() + "x" + view.getMeasuredHeight())
                + " lp=" + (params == null ? "none" : params.width + "x" + params.height));
        pendingCount--;
        if (pendingCount == 0) publishLocked(callbackGeneration, module);
    }

    private static synchronized void publishPartial(
            int callbackGeneration, InlineAutofillHeaderModule module) {
        if (isCurrentLocked(callbackGeneration, module) && !published) {
            publishLocked(callbackGeneration, module);
        }
    }

    private static boolean isCurrentLocked(
            int callbackGeneration, InlineAutofillHeaderModule module) {
        return callbackGeneration == generation
                && activeInputSession
                && module != null
                && module.isSessionAvailableFor(pendingSessionToken)
                && pendingModule != null
                && pendingModule.get() == module
                && pendingViews != null;
    }

    private static void publishLocked(
            int callbackGeneration, InlineAutofillHeaderModule module) {
        if (!isCurrentLocked(callbackGeneration, module) || published) {
            Log.i(DIAGNOSTIC_TAG, "inline publish skipped stale/published");
            return;
        }
        published = true;
        if (timeout != null) {
            MAIN_HANDLER.removeCallbacks(timeout);
            timeout = null;
        }
        ArrayList<View> views = new ArrayList<View>(pendingViews.length);
        for (View view : pendingViews) if (view != null) views.add(view);
        pendingViews = null;
        completedInflations = null;
        pendingModule = null;
        pendingSessionToken = 0L;
        pendingHeaderToken = 0L;
        pendingCount = 0;
        if (views.isEmpty()) {
            Log.i(DIAGNOSTIC_TAG, "inline publish empty");
            module.clearRemoteViews();
        } else {
            boolean accepted = module.setRemoteViews(
                    views, REMOTE_CLIPPER, activeRequestCandidateTextColor);
            Log.i(DIAGNOSTIC_TAG, "inline publish views=" + views.size()
                    + " accepted=" + accepted + " header=" + (module.getHeaderToken() > 0L));
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
        pendingModule = null;
        pendingSessionToken = 0L;
        pendingHeaderToken = 0L;
        published = false;
    }

    private static InlineAutofillHeaderModule findModule(Context context) {
        HeaderPlatformOwner owner = HeaderPlatformOwners.find(context);
        if (owner == null) return null;
        HeaderModule module = owner.getHeaderPlatformController().getRegisteredModule(
                InlineAutofillHeaderModule.MODULE_ID);
        return module instanceof InlineAutofillHeaderModule
                ? (InlineAutofillHeaderModule) module : null;
    }

    public static void applyRemoteClip(View view, android.graphics.Rect clipBounds) {
        if (Build.VERSION.SDK_INT >= API_R && view != null) {
            view.setClipBounds(clipBounds);
        }
    }

    private static Integer resolveKeyboardThemeCandidateColor(
            Context context, int attribute) {
        Context themedContext = context;
        if (context instanceof PinyinIME) {
            // GoogleInputMethodService.getKeyboardTheme() is a cached field
            // refreshed later in the keyboard rebuild. PinyinIME.a() is the
            // native factory used by that refresh and resolves the newly
            // selected style-sheet immediately, before the new Header exists.
            IKeyboardTheme keyboardTheme = ((PinyinIME) context).a();
            if (keyboardTheme != null) {
                ContextThemeWrapper isolated = new ContextThemeWrapper(context, 0);
                isolated.getTheme().setTo(context.getTheme());
                keyboardTheme.applyToContext(isolated);
                themedContext = isolated;
                // Inflate an empty native Candidate shell so the diagnostic
                // observes the same bbc View style-sheet and drawable state as
                // a real Candidate without creating Candidate data or text.
                View candidate = LayoutInflater.from(isolated).inflate(
                        LAYOUT_SOFTKEY_CANDIDATE, null, false);
                View label = candidate.findViewById(ID_CANDIDATE_LABEL);
                if (label instanceof TextView) {
                    return Integer.valueOf(((TextView) label).getCurrentTextColor());
                }
            }
        }
        TypedArray values = themedContext.obtainStyledAttributes(new int[] { attribute });
        try {
            android.content.res.ColorStateList colors = values.getColorStateList(0);
            return colors == null ? null : Integer.valueOf(colors.getDefaultColor());
        } finally {
            values.recycle();
        }
    }

    public static synchronized void clear() {
        generation++;
        activeInputSession = false;
        activeRequestCandidateTextColor = null;
        cancelPendingLocked();
    }
}
