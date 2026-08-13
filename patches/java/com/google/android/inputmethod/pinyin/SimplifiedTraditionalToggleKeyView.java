package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Rect;
import android.preference.PreferenceManager;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;

import com.google.android.apps.inputmethod.libs.framework.keyboard.SoftKeyView;

/** Native SoftKey slot whose presence follows the user setting and available Header space. */
public final class SimplifiedTraditionalToggleKeyView extends SoftKeyView
        implements SharedPreferences.OnSharedPreferenceChangeListener,
        ViewTreeObserver.OnPreDrawListener {
    public static final String PREFERENCE_KEY =
            "show_simplified_traditional_header_toggle";

    private static final String[] LEFT_SLOT_IDS = {
            "key_pos_header_access_points_menu",
            "key_pos_header_lang_1",
            "key_pos_header_lang_2",
    };
    private static final String ACCESS_POINTS_OVERLAY_ID = "access_points_overlay_view";
    private static final String VOICE_SLOT_ID = "key_pos_header_voice";

    private SharedPreferences preferences;
    private boolean preferenceHidden;
    private boolean geometryHidden;
    private int shortcutWidth;

    public SimplifiedTraditionalToggleKeyView(Context context) {
        super(context);
    }

    public SimplifiedTraditionalToggleKeyView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SimplifiedTraditionalToggleKeyView(Context context, AttributeSet attrs,
            int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        preferences = PreferenceManager.getDefaultSharedPreferences(getContext());
        preferences.registerOnSharedPreferenceChangeListener(this);
        getViewTreeObserver().addOnPreDrawListener(this);
        updatePreferenceVisibility();
    }

    @Override
    protected void onDetachedFromWindow() {
        ViewTreeObserver observer = getViewTreeObserver();
        if (observer.isAlive()) observer.removeOnPreDrawListener(this);
        if (preferences != null) {
            preferences.unregisterOnSharedPreferenceChangeListener(this);
            preferences = null;
        }
        super.onDetachedFromWindow();
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        if (PREFERENCE_KEY.equals(key)) updatePreferenceVisibility();
    }

    @Override
    public boolean onPreDraw() {
        if (preferenceHidden) return true;
        int measuredWidth = getMeasuredWidth();
        if (measuredWidth > 0) shortcutWidth = measuredWidth;
        boolean shouldHide = !hasAvailableHeaderSpace();
        if (geometryHidden == shouldHide) return true;
        geometryHidden = shouldHide;
        applyVisibility();
        requestLayout();
        return false;
    }

    @Override
    public void setVisibility(int visibility) {
        super.setVisibility(preferenceHidden || geometryHidden ? View.GONE : visibility);
    }

    private void updatePreferenceVisibility() {
        preferenceHidden = preferences != null
                && !preferences.getBoolean(PREFERENCE_KEY, true);
        applyVisibility();
    }

    private void applyVisibility() {
        setVisibility(preferenceHidden || geometryHidden ? View.GONE : View.VISIBLE);
    }

    private boolean hasAvailableHeaderSpace() {
        if (shortcutWidth <= 0) return false;
        if (!(getParent() instanceof ViewGroup)) return false;
        ViewGroup rightSlots = (ViewGroup) getParent();
        if (!(rightSlots.getParent() instanceof ViewGroup)) return false;
        ViewGroup headerInner = (ViewGroup) rightSlots.getParent();
        View accessPointsOverlay = findExplicitSlot(headerInner, ACCESS_POINTS_OVERLAY_ID);
        if (accessPointsOverlay == null
                || accessPointsOverlay.getVisibility() != View.VISIBLE) return false;
        View voice = findExplicitSlot(headerInner, VOICE_SLOT_ID);
        if (voice == null || voice.getParent() != rightSlots
                || voice.getVisibility() != View.VISIBLE) return false;

        Rect voiceRect = descendantRect(headerInner, voice);
        int occupiedRight = 0;
        for (String idName : LEFT_SLOT_IDS) {
            View slot = findExplicitSlot(headerInner, idName);
            if (slot != null && slot.getVisibility() == View.VISIBLE) {
                occupiedRight = Math.max(occupiedRight, descendantRect(headerInner, slot).right);
            }
        }
        return voiceRect.left - shortcutWidth >= occupiedRight;
    }

    private View findExplicitSlot(ViewGroup headerInner, String idName) {
        int id = getResources().getIdentifier(idName, "id", getContext().getPackageName());
        return id == 0 ? null : headerInner.findViewById(id);
    }

    private static Rect descendantRect(ViewGroup root, View descendant) {
        Rect rect = new Rect(0, 0, descendant.getWidth(), descendant.getHeight());
        root.offsetDescendantRectToMyCoords(descendant, rect);
        return rect;
    }
}
