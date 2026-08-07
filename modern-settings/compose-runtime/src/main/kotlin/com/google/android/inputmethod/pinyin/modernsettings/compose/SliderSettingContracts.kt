package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Whether a value came from an explicitly stored preference or the absent-key default. */
sealed interface ResolvedSetting<out T> {
    data class SystemDefault<T>(val effectiveValue: T) : ResolvedSetting<T>
    data class Explicit<T>(val value: T) : ResolvedSetting<T>
}

data class EnumeratedSliderContract(
    val key: String,
    val values: List<String>,
    val defaultValue: String,
) {
    init {
        require(values.isNotEmpty())
        require(defaultValue in values)
    }

    fun indexOf(storedValue: String?): Int {
        val candidate = storedValue ?: defaultValue
        val index = values.indexOf(candidate)
        if (index >= 0) return index
        val defaultIndex = values.indexOf(defaultValue)
        return if (defaultIndex >= 0) defaultIndex else values.size / 2
    }

    fun valueAt(index: Int): String = values[index]
}

/** Exact persistence contracts recovered from the original Preference subclasses. */
object SliderSettingContracts {
    const val SOUND_VOLUME_KEY = "sound_volume"
    const val SOUND_ENABLED_KEY = "enable_sound_on_keypress"
    const val VIBRATION_DURATION_KEY = "vibration_duration"
    const val VIBRATION_ENABLED_KEY = "enable_vibrate_on_keypress"
    const val LONG_PRESS_DELAY_KEY = "key_long_press_delay"

    val keyboardHeight = EnumeratedSliderContract(
        key = "keyboard_height_ratio",
        values = listOf("0.9", "0.95", "1.0", "1.05", "1.1"),
        defaultValue = "1.0",
    )
    val slideSensitivity = EnumeratedSliderContract(
        key = "keyboard_slide_sensitivity_ratio",
        values = listOf("3.0", "1.5", "1.0", "0.8", "0.5"),
        defaultValue = "1.0",
    )
    val handwritingTimeout = EnumeratedSliderContract(
        key = "handwriting_timeout_ms",
        values = listOf("3000", "2000", "1500", "1000", "700", "400", "100"),
        defaultValue = "1000",
    )
    val handwritingStrokeWidth = EnumeratedSliderContract(
        key = "handwriting_stroke_width_scale",
        values = listOf("0.4", "0.6", "0.8", "1.0", "1.2", "1.5", "2"),
        defaultValue = "1.0",
    )

    fun resolveVolume(hasStoredValue: Boolean, storedValue: Float, deviceDefault: Float): ResolvedSetting<Float> =
        if (hasStoredValue) ResolvedSetting.Explicit(storedValue)
        else ResolvedSetting.SystemDefault(deviceDefault)

    /**
     * The original VibrationDurationPreference stores zero milliseconds as "0"
     * and positive N milliseconds as (N + 1). The absent key alone represents
     * the per-device default, which is commonly -1 (system default).
     */
    fun resolveVibration(
        hasStoredValue: Boolean,
        storedValue: String?,
        deviceDefaultMs: Int,
    ): ResolvedSetting<Int> {
        if (!hasStoredValue) return ResolvedSetting.SystemDefault(deviceDefaultMs)
        val encoded = requireNotNull(storedValue).toInt()
        val milliseconds = if (encoded == 0) 0 else encoded - 1
        return ResolvedSetting.Explicit(milliseconds)
    }

    fun encodeVibration(milliseconds: Int): String {
        require(milliseconds >= 0)
        return if (milliseconds == 0) "0" else (milliseconds + 1).toString()
    }

    fun longPressProgress(milliseconds: Int): Int = (milliseconds - 100) / 10

    fun longPressMilliseconds(progress: Int): Int {
        require(progress in 0..60)
        return progress * 10 + 100
    }
}
