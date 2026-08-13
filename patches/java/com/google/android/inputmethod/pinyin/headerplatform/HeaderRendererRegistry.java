package com.google.android.inputmethod.pinyin.headerplatform;

import android.content.Context;

import java.util.EnumMap;
import java.util.Map;

/** Closed renderer registry owned by the platform host, never by feature modules. */
public final class HeaderRendererRegistry {
    private final Map<HeaderPresentationKind, HeaderRenderer> renderers =
            new EnumMap<HeaderPresentationKind, HeaderRenderer>(HeaderPresentationKind.class);

    public void register(HeaderRenderer renderer) {
        if (renderer == null || renderer.getPresentationKind() == null) {
            throw new IllegalArgumentException("renderer and kind must not be null");
        }
        HeaderPresentationKind kind = renderer.getPresentationKind();
        if (renderers.containsKey(kind)) {
            throw new IllegalArgumentException("duplicate Header renderer: " + kind);
        }
        renderers.put(kind, renderer);
    }

    public HeaderRenderedContent prepare(Context context, HeaderContribution contribution,
            HeaderChromeFactory chromeFactory) {
        if (contribution == null) return null;
        HeaderRenderer renderer = renderers.get(contribution.getPresentationKind());
        if (renderer == null) {
            throw new IllegalStateException(
                    "No Header renderer for " + contribution.getPresentationKind());
        }
        HeaderRenderedContent content = renderer.prepare(context, contribution, chromeFactory);
        if (content == null || content.getView() == null) {
            if (content != null) content.release();
            throw new IllegalStateException("Header renderer returned no View");
        }
        return content;
    }
}
