package com.google.android.inputmethod.pinyin;

import android.content.Context;

import com.google.android.apps.inputmethod.libs.framework.core.AccessPointsManager;

import java.util.Map;

/**
 * Handles taps on the floating-keyboard shortcut in the access point bar.
 *
 * <p>The entry itself is a stock {@code style} in {@code init_access_points}, so the bar builds,
 * sorts, animates and describes it exactly like the built-in ones. Only the tap needs code: the
 * bar hands the id to every registered feature handler until one claims it.
 *
 * <p>Registration happens from {@code GoogleInputMethodService} once the manager exists. It is
 * guarded because that call site runs on every configuration change.
 */
public final class FloatingAccessPointHandler
        implements AccessPointsManager.IAccessPointFeatureHandler {

    private static final String STRING_ID = "id_access_point_floating";

    private static boolean registered;
    private static FloatingAccessPointHandler instance;

    private final Context context;
    private final String id;

    private FloatingAccessPointHandler(Context context, String id) {
        this.context = context.getApplicationContext();
        this.id = id;
    }

    /**
     * Registers the handler once. Called from the stock service after it has built its access
     * point manager.
     */
    public static void register(Context context, AccessPointsManager manager) {
        if (registered || context == null || manager == null) return;
        registered = true;
        instance = new FloatingAccessPointHandler(context, resolveId(context));
        if (instance.id != null) manager.a(instance);
    }

    private static String resolveId(Context context) {
        int id = context.getResources().getIdentifier(STRING_ID, "string", context.getPackageName());
        return id == 0 ? null : context.getString(id);
    }

    @Override
    public boolean launchFeature(String feature, Map<String, Object> args) {
        if (id == null || !id.equals(feature)) return false;
        FloatingKeyboardCompat.setEnabled(context, !FloatingKeyboardCompat.isEnabled(context));
        return true;
    }

    @Override
    public boolean closeFeature(String feature) {
        // A toggle has no open state to close; claiming the id keeps other handlers from
        // treating it as their own.
        return id != null && id.equals(feature);
    }
}
