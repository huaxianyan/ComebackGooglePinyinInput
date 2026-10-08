package com.example.dynamiccolorfixture;

import android.app.Instrumentation;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import android.os.Build;
import android.os.Bundle;
import android.widget.ImageView;
import java.lang.reflect.Method;

/** Real Android bitmap fixture, restricted to the isolated debugging package. */
public final class ColorProbe extends Instrumentation {
    public void onCreate(Bundle arguments) { start(); }

    public void onStart() {
        Bundle result = new Bundle();
        try {
            Context context = getTargetContext();
            if (!context.getPackageName().endsWith(".colorroleaudit")
                    || (context.getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) == 0
                    || Build.VERSION.SDK_INT < 31) {
                throw new IllegalStateException("Requires the isolated API-31+ debug target");
            }
            Class<?> bridge = context.getClassLoader().loadClass(
                    "com.google.android.inputmethod.pinyin.SystemAutoThemeCompat");
            Method enable = bridge.getMethod("setDynamicEnabled", Context.class, boolean.class);
            Method enabled = bridge.getMethod("isDynamicEnabled", Context.class);
            Method bind = bridge.getMethod("applyDynamicFunctionIcon",
                    Context.class, int.class, ImageView.class);
            Method automatic = bridge.getMethod("isEnabled", Context.class);
            Method setAutomatic = bridge.getMethod("setEnabled", Context.class, boolean.class);
            boolean originalEnabled = ((Boolean) enabled.invoke(null, context)).booleanValue();
            boolean originalAutomatic = ((Boolean) automatic.invoke(null, context)).booleanValue();
            try {
                enable.invoke(null, context, true);
                Bitmap mask = Bitmap.createBitmap(
                        new int[] {0x99000000, 0x4c000000, 0, 0x99ffffff},
                        2, 2, Bitmap.Config.ARGB_8888);
                mask.setDensity(320);
                // Frozen IDs from the original APK's public resources and key metadata,
                // independent of the production whitelist. Includes the previously missed DEL.
                int[] keys = {0x7f0f0221, 0x7f0f0222, 0x7f0f020e, 0x7f0f020f,
                        0x7f0f036e, 0x7f0f0371, 0x7f0f0373, 0x7f0f0374,
                        0x7f0f0375, 0x7f0f0376};
                for (int index = 0; index < keys.length; index++) {
                    ImageView image = image(context, mask);
                    int tint = index == 1 ? 0xff0000ff : 0xff00ff00;
                    image.setColorFilter(tint, PorterDuff.Mode.SRC_IN);
                    bind.invoke(null, context, keys[index], image);
                    Bitmap actual = ((BitmapDrawable) image.getDrawable()).getBitmap();
                    if (actual.getPixel(0, 0) != 0xff000000
                            || actual.getPixel(1, 0) != 0x7e000000
                            || actual.getPixel(0, 1) != 0
                            || actual.getPixel(1, 1) != 0xffffffff
                            || actual.getDensity() != 320
                            || image.getImageAlpha() != 153
                            || image.getDrawable().getAlpha() != 153
                            || mask.getPixel(0, 0) != 0x99000000) {
                        throw new AssertionError("Mask or metadata changed for key " + keys[index]);
                    }
                    Bitmap surface = Bitmap.createBitmap(2, 2, Bitmap.Config.ARGB_8888);
                    image.getDrawable().setBounds(0, 0, 2, 2);
                    image.getDrawable().draw(new Canvas(surface));
                    int expected = index == 1 ? 0x990000ff : 0x9900ff00;
                    if (surface.getPixel(0, 0) != expected) {
                        throw new AssertionError("Rendered tint/alpha changed for key " + keys[index]);
                    }
                }
                // Original disabled Shift must retain its independent state appearance.
                ImageView disabled = image(context, mask);
                bind.invoke(null, context, 0x7f0f036f, disabled);
                if (((BitmapDrawable) disabled.getDrawable()).getBitmap().getPixel(0, 0)
                        != 0x99000000) {
                    throw new AssertionError("Disabled Shift appearance changed");
                }
                enable.invoke(null, context, false);
                ImageView ordinary = image(context, mask);
                bind.invoke(null, context, 0x7f0f0221, ordinary);
                if (((BitmapDrawable) ordinary.getDrawable()).getBitmap().getPixel(0, 0)
                        != 0x99000000) {
                    throw new AssertionError("Ordinary theme appearance changed");
                }
                // Independent framework values for the API-31 fallback check.
                int semantic = context.getResources().getIdentifier(
                        "system_surface_container_light", "color", "android");
                int tonal = context.getResources().getIdentifier(
                        "system_neutral1_100", "color", "android");
                result.putString("base-semantic-present", String.valueOf(semantic != 0));
                result.putString("tonal-base-light", Integer.toHexString(
                        context.getResources().getColor(tonal, context.getTheme())));
                result.putString("result", "PASS");
            } finally {
                enable.invoke(null, context, originalEnabled);
                if (originalAutomatic) setAutomatic.invoke(null, context, true);
            }
            finish(0, result);
        } catch (Throwable failure) {
            result.putString("result", "FAIL");
            result.putString("failure-type", failure.getClass().getName());
            if (failure.getCause() != null) {
                result.putString("cause-type", failure.getCause().getClass().getName());
            }
            finish(1, result);
        }
    }

    private static ImageView image(Context context, Bitmap mask) {
        ImageView image = new ImageView(context);
        image.setId(0x7f0f0057);
        image.setImageBitmap(mask);
        image.setImageAlpha(153);
        return image;
    }
}
