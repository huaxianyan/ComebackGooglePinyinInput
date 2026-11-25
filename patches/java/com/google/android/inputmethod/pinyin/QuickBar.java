package com.google.android.inputmethod.pinyin;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.List;

/**
 * Project-owned toolbar for the access point row.
 *
 * <p>It replaces the contents of the native {@code AccessPointsBar}. That list is driven by a
 * resource array plus an internal preference we can neither reorder reliably nor extend, so the
 * entries and their order live here instead. Adding a shortcut means adding one line to
 * {@link #ALL}.
 *
 * <p>The row keeps the native position: it is the strip the keyboard expands from its top left
 * corner, collapsed by default. The surrounding header still owns the expand button and the
 * "more" key; only the entry area between them belongs to this class.
 */
public final class QuickBar {
    /** Tag marking our own row inside the overlay container. */
    private static final String TAG_VIEW = "quickbar.self";

    /** One shortcut: what it looks like and what it does. */
    public static final class Entry {
        final String id;
        final String iconName;
        final String label;
        final int action;

        Entry(String id, String iconName, String label, int action) {
            this.id = id;
            this.iconName = iconName;
            this.label = label;
            this.action = action;
        }
    }

    private static final int ACTION_NATIVE = 0;

    /**
     * Every shortcut we know about. New entries go here.
     *
     * <p>The order matters: native buttons are matched by position, see {@link #clickNative}.
     */
    private static final Entry[] ALL = {
            new Entry("access_point_theme_setting", "ic_access_point_theme_setting_dark_theme",
                    "\u4e3b\u9898", ACTION_NATIVE),
            new Entry("access_point_one_handed", "ic_access_point_one_handed_dark_theme",
                    "\u5355\u624b\u6a21\u5f0f", ACTION_NATIVE),
            new Entry("access_point_settings", "ic_access_point_setting_dark_theme",
                    "\u8bbe\u7f6e", ACTION_NATIVE),
            new Entry("access_point_textediting", "ic_access_point_text_editing_dark_theme",
                    "\u6587\u672c\u7f16\u8f91", ACTION_NATIVE),
    };

    private QuickBar() {
    }

    public static List<Entry> allEntries() {
        List<Entry> entries = new ArrayList<Entry>();
        for (Entry entry : ALL) {
            entries.add(entry);
        }
        return entries;
    }

    /**
     * Shows our own row in place of the native one.
     *
     * <p>The native bar sits inside the {@code access_points_overlay_view} container, which is the
     * piece the header actually sizes. Our row goes in there too, so the surrounding row keeps
     * deciding the width and the expand button stays untouched.
     */
    public static void attach(View nativeBar, boolean selfEnabled) {
        if (nativeBar == null || !(nativeBar.getParent() instanceof ViewGroup)) return;
        // Collapsed, the row still exists but is not on screen. Taking it over then would put our
        // row on top of the expand button.
        if (selfEnabled && !nativeBar.isShown()) return;
        ViewGroup overlay = (ViewGroup) nativeBar.getParent();

        if (!selfEnabled) {
            detach(overlay);
            showNativeEntries(nativeBar);
            return;
        }

        hideNativeEntries(nativeBar);
        if (overlay.findViewWithTag(TAG_VIEW) != null) return;
        View bar = create(nativeBar.getContext(), nativeBar);
        overlay.addView(bar);
        ViewGroup.LayoutParams params = bar.getLayoutParams();
        if (params != null) {
            params.width = ViewGroup.LayoutParams.MATCH_PARENT;
            params.height = ViewGroup.LayoutParams.MATCH_PARENT;
            bar.setLayoutParams(params);
        }
    }

    /**
     * Empties the native row without hiding it.
     *
     * <p>The bar itself stays visible so it keeps taking part in layout; only its entries go away,
     * along with the strip background that would otherwise still be painted behind our own row.
     */
    private static void hideNativeEntries(View nativeBar) {
        if (!(nativeBar instanceof ViewGroup)) return;
        ViewGroup group = (ViewGroup) nativeBar;
        for (int i = 0; i < group.getChildCount(); i++) {
            View child = group.getChildAt(i);
            if (child.getVisibility() != View.GONE) {
                child.setVisibility(View.GONE);
                child.setBackground(null);
            }
        }
        group.setBackground(null);
    }

    /** Puts the native buttons back, for when the project row is switched off. */
    private static void showNativeEntries(View nativeBar) {
        if (!(nativeBar instanceof ViewGroup)) return;
        ViewGroup group = (ViewGroup) nativeBar;
        for (int i = 0; i < group.getChildCount(); i++) {
            View child = group.getChildAt(i);
            if (child.getVisibility() == View.GONE) child.setVisibility(View.VISIBLE);
        }
    }

    private static void detach(ViewGroup parent) {
        View existing = parent.findViewWithTag(TAG_VIEW);
        if (existing != null) parent.removeView(existing);
    }

    private static View create(Context context, View nativeBar) {
        LinearLayout bar = new LinearLayout(context);
        bar.setTag(TAG_VIEW);
        bar.setOrientation(LinearLayout.HORIZONTAL);
        bar.setGravity(Gravity.CENTER_VERTICAL);

        for (Entry entry : ALL) {
            bar.addView(createButton(context, entry, nativeBar), buttonParams(context));
        }
        return bar;
    }

    private static LinearLayout.LayoutParams buttonParams(Context context) {
        float density = context.getResources().getDisplayMetrics().density;
        int size = Math.round(56.0f * density);
        int gap = Math.round(4.0f * density);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(0, size, 1.0f);
        params.gravity = Gravity.CENTER_VERTICAL;
        params.setMargins(gap, 0, gap, 0);
        return params;
    }

    private static View createButton(final Context context, final Entry entry,
            final View nativeBar) {
        ImageView icon = new ImageView(context);
        icon.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        icon.setContentDescription(entry.label);
        Drawable drawable = drawable(context, entry.iconName);
        if (drawable != null) {
            icon.setImageDrawable(drawable);
            // The bundled icons only ship in their dark-theme (light) variant, so the colour has to
            // come from the current theme instead of the asset.
            icon.setColorFilter(keyboardIconColor(context));
        }
        icon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                run(context, entry, nativeBar);
            }
        });
        return icon;
    }

    private static int keyboardIconColor(Context context) {
        android.util.TypedValue value = new android.util.TypedValue();
        if (context.getTheme().resolveAttribute(android.R.attr.textColorPrimary, value, true)) {
            return context.getResources().getColor(value.resourceId);
        }
        return 0;
    }

    private static Drawable drawable(Context context, String name) {
        int id = context.getResources().getIdentifier(name, "drawable", context.getPackageName());
        return id == 0 ? null : context.getDrawable(id);
    }

    private static void run(Context context, Entry entry, View nativeBar) {
        if (entry.action == ACTION_NATIVE && clickNative(nativeBar, entry.id)) return;
        launch(context, entry.id);
    }

    /**
     * Forwards a click to the matching native button.
     *
     * <p>The native buttons are hidden but still wired, so the whole action path stays native.
     * They are matched by position: the access point manager builds them in the same order this
     * table is written in, and the row belongs to us from here on.
     */
    private static boolean clickNative(View nativeBar, String id) {
        if (!(nativeBar instanceof ViewGroup)) return false;
        int index = indexOf(id);
        if (index < 0) return false;
        ViewGroup group = (ViewGroup) nativeBar;
        if (group.getChildCount() <= index) return false;
        View item = group.getChildAt(index);
        if (!item.getClass().getName().endsWith("SoftKeyView")) return false;
        try {
            return item.performClick();
        } catch (Throwable ignored) {
            return false;
        }
    }

    private static int indexOf(String id) {
        for (int i = 0; i < ALL.length; i++) {
            if (ALL[i].id.equals(id)) return i;
        }
        return -1;
    }

    /** Last resort when the native button is not there: open the matching settings screen. */
    private static void launch(Context context, String id) {
        String className = null;
        if ("access_point_theme_setting".equals(id)) {
            className = "com.google.android.apps.inputmethod.libs.theme.preference"
                    + ".ThemeSelectorActivity";
        } else if ("access_point_settings".equals(id)) {
            className = "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity";
        }
        if (className == null) return;
        try {
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.setClassName(context.getPackageName(), className);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch (Throwable ignored) {
            // A shortcut that cannot open must never take the keyboard down with it.
        }
    }
}
