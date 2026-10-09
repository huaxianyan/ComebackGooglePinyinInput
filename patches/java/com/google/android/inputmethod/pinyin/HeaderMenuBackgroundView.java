package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.AttributeSet;
import android.widget.ImageView;

/** Native menu chrome: plain keyboards use an opaque main-area color. */
public final class HeaderMenuBackgroundView extends ImageView
        implements SharedPreferences.OnSharedPreferenceChangeListener {
    private final float borderedAlpha;
    private final String borderKey;
    private SharedPreferences preferences;

    public HeaderMenuBackgroundView(Context context, AttributeSet attrs) {
        super(context, attrs);
        borderedAlpha = getAlpha();
        borderKey = context.getString(context.getResources().getIdentifier(
                "pref_key_enable_key_border", "string", context.getPackageName()));
    }

    @Override protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        preferences = PreferenceManager.getDefaultSharedPreferences(getContext());
        preferences.registerOnSharedPreferenceChangeListener(this);
        updateOpacity();
    }

    @Override protected void onDetachedFromWindow() {
        if (preferences != null) {
            preferences.unregisterOnSharedPreferenceChangeListener(this);
            preferences = null;
        }
        super.onDetachedFromWindow();
    }

    @Override public void onSharedPreferenceChanged(SharedPreferences prefs, String key) {
        if (borderKey.equals(key)) updateOpacity();
    }

    private void updateOpacity() {
        setAlpha(preferences.getBoolean(borderKey, false) ? borderedAlpha : 1.0f);
    }
}
