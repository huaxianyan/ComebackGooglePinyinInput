package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Size;
import android.view.inputmethod.InlineSuggestionsRequest;
import android.view.inputmethod.InlineSuggestionsResponse;
import android.widget.inline.InlinePresentationSpec;

import java.util.ArrayList;

/**
 * API 30+ bridge for Android's standard inline Autofill protocol.
 *
 * <p>This first stage deliberately does not inflate or render a suggestion. It only advertises a
 * bounded presentation contract and invalidates response generations without reading suggestion
 * metadata or payloads. Rendering is added separately once the Header Surface host exists.</p>
 */
public final class InlineAutofillCompat {
    private static final int API_R = 30;
    private static final int HEADER_HEIGHT_RES_ID = 0x7f0d00a9;
    private static final int PRESENTATION_COUNT = 3;
    private static final float MIN_CHIP_WIDTH_DP = 48.0f;
    private static final float MAX_CHIP_WIDTH_DP = 240.0f;

    private static int generation;

    private InlineAutofillCompat() {}

    public static synchronized InlineSuggestionsRequest createRequest(
            Context context, Bundle uiExtras) {
        if (Build.VERSION.SDK_INT < API_R || context == null) {
            return null;
        }
        generation++;

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

    public static synchronized boolean handleResponse(InlineSuggestionsResponse response) {
        generation++;
        // Stage A has no Surface host. Returning false preserves the platform fallback contract.
        return false;
    }

    public static synchronized void clear() {
        generation++;
    }
}
