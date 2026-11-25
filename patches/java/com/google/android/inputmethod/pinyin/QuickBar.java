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
 * <p>It replaces the contents of the native {@code AccessPointsBar}. The native list is driven by
 * a resource array plus an internal preference we can neither reorder reliably nor extend, so the
 * entries and their order live here instead. Adding a shortcut means adding one line to
 * {@link #ALL}.
 *
 * <p>The row keeps the native position: it is the strip the keyboard expands from its top left
 * corner, collapsed by default.
 */
public final class QuickBar {
    /** Tag marking our own row inside the parent container. */
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

    private static final int ACTION_THEME = 1;
    private static final int ACTION_SETTINGS = 2;

    /** Every shortcut we know about. New entries go here. */
    private static final Entry[] ALL = {
            new Entry("theme", "ic_access_point_theme_setting_dark_theme", "\u4e3b\u9898",
                    ACTION_THEME),
            new Entry("settings", "ic_access_point_setting_dark_theme", "\u8bbe\u7f6e",
                    ACTION_SETTINGS),
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
     * <p>The native bar is set {@code INVISIBLE} rather than {@code GONE}: it has to keep taking
     * part in layout, otherwise the surrounding container stops calling {@code onLayout} and we
     * lose the only hook we have for keeping this in sync.
     */
    public static void attach(View nativeBar, boolean selfEnabled) {
        if (nativeBar == null || !(nativeBar.getParent() instanceof ViewGroup)) return;
        ViewGroup parent = (ViewGroup) nativeBar.getParent();

        if (!selfEnabled) {
            detach(parent);
            return;
        }

        hideNativeEntries(nativeBar);
        if (parent.findViewWithTag(TAG_VIEW) != null) return;
        View bar = create(nativeBar.getContext());
        // Let the parent build the layout params, then stretch them to fill the row.
        parent.addView(bar, insertionIndex(parent, nativeBar));
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
     * <p>The bar itself stays visible so it keeps taking part in layout and the outer container
     * keeps calling {@code onLayout}; only its entries go away, along with the strip background
     * that would otherwise still be painted behind our own row.
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

    private static int insertionIndex(ViewGroup parent, View nativeBar) {
        int index = parent.indexOfChild(nativeBar);
        return index < 0 ? parent.getChildCount() : index + 1;
    }

    private static void detach(ViewGroup parent) {
        View existing = parent.findViewWithTag(TAG_VIEW);
        if (existing != null) parent.removeView(existing);
    }

    private static View create(Context context) {
        LinearLayout bar = new LinearLayout(context);
        bar.setTag(TAG_VIEW);
        bar.setOrientation(LinearLayout.HORIZONTAL);
        bar.setGravity(Gravity.CENTER_VERTICAL);

        int count = allEntries().size();
        for (Entry entry : allEntries()) {
            bar.addView(createButton(context, entry), buttonParams(context, count > 0));
        }
        return bar;
    }

    private static LinearLayout.LayoutParams buttonParams(Context context, boolean shareWidth) {
        int size = Math.round(48.0f * context.getResources().getDisplayMetrics().density);
        LinearLayout.LayoutParams params = shareWidth
                ? new LinearLayout.LayoutParams(0, size, 1.0f)
                : new LinearLayout.LayoutParams(size, size);
        params.gravity = Gravity.CENTER_VERTICAL;
        return params;
    }

    private static View createButton(final Context context, final Entry entry) {
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
                run(context, entry);
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

    private static void run(Context context, Entry entry) {
        switch (entry.action) {
            case ACTION_THEME:
                launch(context, "com.google.android.apps.inputmethod.libs.theme.preference"
                        + ".ThemeSelectorActivity");
                break;
            case ACTION_SETTINGS:
                launch(context, "com.google.android.apps.inputmethod.pinyin.preference"
                        + ".SettingsActivity");
                break;
            default:
                break;
        }
    }

    private static void launch(Context context, String className) {
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
