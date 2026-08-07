package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.media.AudioManager
import android.os.VibrationEffect
import android.os.Vibrator

/** Platform previews kept outside Compose state and persistence. Loaded only on API 35+. */
class SettingsPreviewEffects(context: Context) {
    private val audioManager = context.getSystemService(AudioManager::class.java)
    private val vibrator = context.getSystemService(Vibrator::class.java)

    fun previewVolume(percent: Int) {
        require(percent in 0..100)
        audioManager.playSoundEffect(5, SliderSettingContracts.encodeVolumePercent(percent))
    }

    fun previewVibration(milliseconds: Int) {
        require(milliseconds in 0..100)
        if (milliseconds == 0 || !vibrator.hasVibrator()) return
        vibrator.vibrate(
            VibrationEffect.createOneShot(
                milliseconds.toLong(),
                VibrationEffect.DEFAULT_AMPLITUDE,
            )
        )
    }
}
