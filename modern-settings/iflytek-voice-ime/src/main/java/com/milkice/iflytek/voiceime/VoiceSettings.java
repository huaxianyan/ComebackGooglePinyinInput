package com.milkice.iflytek.voiceime;

import android.content.Context;
import android.content.SharedPreferences;

import androidx.preference.PreferenceManager;

final class VoiceSettings {
    final String appId;
    final String apiKey;
    final String apiSecret;
    final String language;

    private VoiceSettings(String appId, String apiKey, String apiSecret, String language) {
        this.appId = appId;
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
        this.language = language;
    }

    static VoiceSettings load(Context context) {
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        return new VoiceSettings(
                preferences.getString("app_id", "").trim(),
                preferences.getString("api_key", "").trim(),
                preferences.getString("api_secret", "").trim(),
                preferences.getString("language", "zh_cn"));
    }

    boolean isComplete() {
        return !appId.isEmpty() && !apiKey.isEmpty() && !apiSecret.isEmpty();
    }
}
