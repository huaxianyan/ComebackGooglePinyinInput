package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.media.AudioManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator

/**
 * Platform previews kept outside Compose state and persistence. Loaded on every
 * supported version, so everything here has to work from the app's minSdk up.
 */
class SettingsPreviewEffects(context: Context) {
    private val audioManager = context.getSystemService(AudioManager::class.java)
    private val vibrator = context.getSystemService(Vibrator::class.java)

    fun previewVolume(percent: Int) {
        require(percent in 0..100)
        audioManager.playSoundEffect(5, SliderSettingContracts.encodeVolumePercent(percent))
    }

    /**
     * One pulse at the given length, for the duration slider to feel like something.
     *
     * The version split is not decoration: `VibrationEffect` arrived in API 26, and this
     * page is reachable from minSdk (23) up. Calling it unconditionally crashes the
     * process below 26 with `NoClassDefFoundError: Failed resolution of:
     * Landroid/os/VibrationEffect;` - the reference is real even though the class is not,
     * because D8 outlines it into a synthetic holder that is only entered when the
     * guarded branch runs. Below 26 the deprecated single-argument overload asks for the
     * same thing: one pulse, default amplitude.
     */
    fun previewVibration(milliseconds: Int) {
        require(milliseconds in 0..100)
        if (milliseconds == 0 || !vibrator.hasVibrator()) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(
                VibrationEffect.createOneShot(
                    milliseconds.toLong(),
                    VibrationEffect.DEFAULT_AMPLITUDE,
                )
            )
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(milliseconds.toLong())
        }
    }
}
