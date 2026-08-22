package com.milkice.iflytek.voiceime;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.preference.EditTextPreference;
import androidx.preference.Preference;
import androidx.preference.PreferenceFragmentCompat;

public final class SettingsActivity extends AppCompatActivity {
    private static final int REQUEST_RECORD_AUDIO = 42;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        setTitle(R.string.settings_title);
        if (state == null) {
            getSupportFragmentManager().beginTransaction()
                    .replace(android.R.id.content, new SettingsFragment())
                    .commit();
        }
        if (getIntent().getBooleanExtra("request_record_audio", false)
                && android.os.Build.VERSION.SDK_INT >= 23
                && checkSelfPermission(Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            getWindow().getDecorView().postDelayed(
                    () -> requestPermissions(
                            new String[]{Manifest.permission.RECORD_AUDIO},
                            REQUEST_RECORD_AUDIO),
                    250L);
        }
    }

    @Override
    public void onRequestPermissionsResult(
            int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_RECORD_AUDIO && grantResults.length > 0
                && grantResults[0] != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, R.string.settings_permission_message, Toast.LENGTH_LONG).show();
        }
    }

    public static final class SettingsFragment extends PreferenceFragmentCompat {
        @Override
        public void onCreatePreferences(Bundle state, String rootKey) {
            setPreferencesFromResource(R.xml.preferences, rootKey);
            bindSecret("app_id", false);
            bindSecret("api_key", true);
            bindSecret("api_secret", true);
        }

        private void bindSecret(String key, boolean password) {
            EditTextPreference preference = findPreference(key);
            if (preference == null) return;
            preference.setSummaryProvider(value -> {
                String text = ((EditTextPreference) value).getText();
                if (text == null || text.isEmpty()) return getString(summaryFor(key));
                return mask(text, password);
            });
            preference.setOnPreferenceChangeListener((item, newValue) -> {
                if (newValue instanceof String && !((String) newValue).trim().isEmpty()) {
                    return true;
                }
                Toast.makeText(requireContext(), R.string.settings_missing_config,
                        Toast.LENGTH_SHORT).show();
                return false;
            });
            if (password) {
                preference.setOnBindEditTextListener(editText ->
                        editText.setInputType(android.text.InputType.TYPE_CLASS_TEXT
                                | android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD));
            }
        }

        private int summaryFor(String key) {
            if ("app_id".equals(key)) return R.string.settings_app_id_summary;
            if ("api_key".equals(key)) return R.string.settings_api_key_summary;
            return R.string.settings_api_secret_summary;
        }

        private static String mask(String value, boolean secret) {
            if (!secret || value.length() <= 4) return value;
            return "••••" + value.substring(value.length() - 4);
        }
    }
}
