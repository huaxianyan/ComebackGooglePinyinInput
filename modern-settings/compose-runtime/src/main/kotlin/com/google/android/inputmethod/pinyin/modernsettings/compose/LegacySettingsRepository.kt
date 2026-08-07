package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.SharedPreferences
import android.os.Build

/** Read-only bridge to the exact default SharedPreferences used by Lamx. */
class LegacySettingsRepository(context: Context) {
    private val applicationContext = context.applicationContext
    private val resources = applicationContext.resources
    private val preferences: SharedPreferences = applicationContext.getSharedPreferences(
        "${applicationContext.packageName}_preferences",
        Context.MODE_PRIVATE,
    )

    fun readSliderSnapshot(): SliderSettingsSnapshot {
        val volumeDefault = deviceDefault(
            "pref_def_value_sound_volume_on_keypress",
            "-1.0",
        ).removeSuffix("f").toFloat()
        val volumePresent = preferences.contains(SliderSettingContracts.SOUND_VOLUME_KEY)
        val volume = SliderSettingContracts.resolveVolume(
            volumePresent,
            preferences.getFloat(SliderSettingContracts.SOUND_VOLUME_KEY, volumeDefault),
            volumeDefault,
        )

        val vibrationDefault = deviceDefault(
            "pref_def_value_per_device_vibration_duration_on_keypress",
            "-1",
        ).toInt()
        val vibrationPresent = preferences.contains(SliderSettingContracts.VIBRATION_DURATION_KEY)
        val vibration = SliderSettingContracts.resolveVibration(
            vibrationPresent,
            if (vibrationPresent) preferences.getString(
                SliderSettingContracts.VIBRATION_DURATION_KEY,
                null,
            ) else null,
            vibrationDefault,
        )

        val keyboardHeightIndex = readEnumeratedIndex(SliderSettingContracts.keyboardHeight)
        val slideSensitivityIndex = readEnumeratedIndex(SliderSettingContracts.slideSensitivity)
        val handwritingTimeoutIndex = readEnumeratedIndex(SliderSettingContracts.handwritingTimeout)
        val handwritingStrokeWidthIndex = readEnumeratedIndex(
            SliderSettingContracts.handwritingStrokeWidth,
        )

        return SliderSettingsSnapshot(
            soundEnabled = preferences.getBoolean(SliderSettingContracts.SOUND_ENABLED_KEY, false),
            volume = volume,
            vibrationEnabled = preferences.getBoolean(
                SliderSettingContracts.VIBRATION_ENABLED_KEY,
                true,
            ),
            vibration = vibration,
            keyboardHeightIndex = keyboardHeightIndex,
            keyboardHeightLabel = readEntryLabel(
                "entries_keyboard_height_ratio",
                keyboardHeightIndex,
            ),
            keyboardHeightLabels = readEntryLabels("entries_keyboard_height_ratio"),
            slideSensitivityIndex = slideSensitivityIndex,
            slideSensitivityLabel = readEntryLabel(
                "entries_keyboard_slide_sensitivity_ratio",
                slideSensitivityIndex,
            ),
            slideSensitivityLabels = readEntryLabels(
                "entries_keyboard_slide_sensitivity_ratio",
            ),
            longPressDelayMs = preferences.getString(
                SliderSettingContracts.LONG_PRESS_DELAY_KEY,
                "300",
            )!!.toInt(),
            handwritingTimeoutIndex = handwritingTimeoutIndex,
            handwritingTimeoutLabel = readEntryLabel(
                "entries_handwriting_timeout_ms",
                handwritingTimeoutIndex,
            ),
            handwritingStrokeWidthIndex = handwritingStrokeWidthIndex,
            handwritingStrokeWidthLabel = readEntryLabel(
                "entries_handwriting_stroke_width_scale",
                handwritingStrokeWidthIndex,
            ),
        )
    }

    fun setSoundEnabled(enabled: Boolean): SliderSettingsSnapshot {
        preferences.edit().putBoolean(SliderSettingContracts.SOUND_ENABLED_KEY, enabled).apply()
        return readSliderSnapshot()
    }

    fun setVibrationEnabled(enabled: Boolean): SliderSettingsSnapshot {
        preferences.edit().putBoolean(SliderSettingContracts.VIBRATION_ENABLED_KEY, enabled).apply()
        return readSliderSnapshot()
    }

    fun setVolumePercent(percent: Int): SliderSettingsSnapshot {
        preferences.edit().putFloat(
            SliderSettingContracts.SOUND_VOLUME_KEY,
            SliderSettingContracts.encodeVolumePercent(percent),
        ).apply()
        return readSliderSnapshot()
    }

    fun restoreVolumeDefault(): SliderSettingsSnapshot {
        preferences.edit().remove(SliderSettingContracts.SOUND_VOLUME_KEY).apply()
        return readSliderSnapshot()
    }

    fun setVibrationDuration(milliseconds: Int): SliderSettingsSnapshot {
        preferences.edit().putString(
            SliderSettingContracts.VIBRATION_DURATION_KEY,
            SliderSettingContracts.encodeVibration(milliseconds),
        ).apply()
        return readSliderSnapshot()
    }

    fun restoreVibrationDefault(): SliderSettingsSnapshot {
        preferences.edit().remove(SliderSettingContracts.VIBRATION_DURATION_KEY).apply()
        return readSliderSnapshot()
    }

    fun setKeyboardHeightIndex(index: Int): SliderSettingsSnapshot {
        writeEnumerated(SliderSettingContracts.keyboardHeight, index)
        return readSliderSnapshot()
    }

    fun setSlideSensitivityIndex(index: Int): SliderSettingsSnapshot {
        writeEnumerated(SliderSettingContracts.slideSensitivity, index)
        return readSliderSnapshot()
    }

    private fun writeEnumerated(contract: EnumeratedSliderContract, index: Int) {
        preferences.edit().putString(contract.key, contract.valueAt(index)).apply()
    }

    private fun readEnumeratedIndex(contract: EnumeratedSliderContract): Int =
        contract.indexOf(preferences.getString(contract.key, contract.defaultValue))

    private fun readEntryLabel(arrayName: String, index: Int): String =
        readEntryLabels(arrayName)[index]

    private fun readEntryLabels(arrayName: String): List<String> {
        val id = resources.getIdentifier(arrayName, "array", applicationContext.packageName)
        require(id != 0) { "Missing legacy entries array: $arrayName" }
        return resources.getStringArray(id).toList()
    }

    private fun deviceDefault(arrayName: String, fallback: String): String {
        val id = resources.getIdentifier(arrayName, "array", applicationContext.packageName)
        require(id != 0) { "Missing legacy default array: $arrayName" }
        return selectDeviceOverride(
            resources.getStringArray(id),
            mapOf(
                "HARDWARE" to Build.HARDWARE,
                "MODEL" to Build.MODEL,
                "BRAND" to Build.BRAND,
                "MANUFACTURER" to Build.MANUFACTURER,
            ),
            fallback,
        )
    }

    companion object {
        internal fun selectDeviceOverride(
            entries: Array<String>,
            device: Map<String, String>,
            fallback: String,
        ): String {
            var unconditional: String? = null
            var matched: String? = null
            for (entry in entries) {
                val comma = entry.indexOf(',')
                require(comma >= 0) { "Device override has no comma: $entry" }
                val condition = entry.substring(0, comma)
                val value = entry.substring(comma + 1)
                if (condition.isEmpty()) {
                    if (unconditional == null) unconditional = value
                    continue
                }
                if (matched == null && condition.split(':').all { clause ->
                        val equals = clause.indexOf('=')
                        require(equals >= 0) { "Device override has no equals: $clause" }
                        val key = clause.substring(0, equals)
                        val pattern = clause.substring(equals + 1)
                        requireNotNull(device[key]) { "Unknown device override key: $key" }
                            .matches(Regex(pattern))
                    }
                ) {
                    matched = value
                }
            }
            return matched ?: unconditional ?: fallback
        }
    }
}

data class SliderSettingsSnapshot(
    val soundEnabled: Boolean,
    val volume: ResolvedSetting<Float>,
    val vibrationEnabled: Boolean,
    val vibration: ResolvedSetting<Int>,
    val keyboardHeightIndex: Int,
    val keyboardHeightLabel: String,
    val keyboardHeightLabels: List<String>,
    val slideSensitivityIndex: Int,
    val slideSensitivityLabel: String,
    val slideSensitivityLabels: List<String>,
    val longPressDelayMs: Int,
    val handwritingTimeoutIndex: Int,
    val handwritingTimeoutLabel: String,
    val handwritingStrokeWidthIndex: Int,
    val handwritingStrokeWidthLabel: String,
)
