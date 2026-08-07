package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Coordinates typed persistence and one-shot platform effects without owning Compose state. */
class SettingsController(
    private val repository: LegacySettingsRepository,
    private val previewEffects: SettingsPreviewEffects,
) {
    fun read(): SliderSettingsSnapshot = repository.readSliderSnapshot()

    fun setSoundEnabled(enabled: Boolean): SliderSettingsSnapshot =
        repository.setSoundEnabled(enabled)

    fun setVolumePercent(percent: Int): SliderSettingsSnapshot {
        val snapshot = repository.setVolumePercent(percent)
        previewEffects.previewVolume(percent)
        return snapshot
    }

    fun restoreVolumeDefault(): SliderSettingsSnapshot = repository.restoreVolumeDefault()

    fun setVibrationEnabled(enabled: Boolean): SliderSettingsSnapshot =
        repository.setVibrationEnabled(enabled)

    fun setVibrationDuration(milliseconds: Int): SliderSettingsSnapshot {
        val snapshot = repository.setVibrationDuration(milliseconds)
        previewEffects.previewVibration(milliseconds)
        return snapshot
    }

    fun restoreVibrationDefault(): SliderSettingsSnapshot =
        repository.restoreVibrationDefault()

    fun setKeyboardHeightIndex(index: Int): SliderSettingsSnapshot =
        repository.setKeyboardHeightIndex(index)

    fun setSlideSensitivityIndex(index: Int): SliderSettingsSnapshot =
        repository.setSlideSensitivityIndex(index)

    fun setHandwritingTimeoutIndex(index: Int): SliderSettingsSnapshot =
        repository.setHandwritingTimeoutIndex(index)

    fun setHandwritingStrokeWidthIndex(index: Int): SliderSettingsSnapshot =
        repository.setHandwritingStrokeWidthIndex(index)
}
