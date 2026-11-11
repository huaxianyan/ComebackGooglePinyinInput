package com.google.android.inputmethod.pinyin;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;

/**
 * Research-only entry point for the probes in {@link NativeImportProbe}. It exists in research
 * builds and nowhere else: {@code apply_patches.py --research} adds both the class and its manifest
 * entry, and release builds contain neither.
 *
 * <p>The probes write to or damage the live user dictionary, so this activity must never ship.
 */
public final class NativeProbeActivity extends Activity {

    @Override protected void onCreate(Bundle state) {
        super.onCreate(state);
        Uri uri = getIntent() == null ? null : getIntent().getData();
        if (getIntent() != null && getIntent().hasExtra("damage_keep")) {
            NativeImportProbe.runDamage(this, uri, getIntent().getLongExtra("damage_keep", 0L));
        } else if (getIntent() != null && getIntent().getBooleanExtra("task_probe", false)) {
            NativeImportProbe.runTask(this, uri);
        } else if (getIntent() != null && getIntent().getBooleanExtra("refresh_probe", false)) {
            NativeImportProbe.runRefresh(this, uri);
        } else {
            NativeImportProbe.run(this, uri);
        }
        finish();
    }
}
