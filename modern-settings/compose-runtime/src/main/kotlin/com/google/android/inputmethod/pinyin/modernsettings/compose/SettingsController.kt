package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Coordinates typed persistence and one-shot platform effects without owning Compose state. */
class SettingsController(
    private val repository: LegacySettingsRepository,
    private val previewEffects: SettingsPreviewEffects,
) {
    fun read(): SettingsSnapshot = repository.readSnapshot()

    fun setSystemAutoThemeEnabled(enabled: Boolean): SettingsSnapshot =
        repository.setSystemAutoThemeEnabled(enabled)

    fun beginThemeSelection(slot: ThemeSelectionSlot): SettingsSnapshot =
        repository.beginThemeSelection(slot)

    fun finishThemeSelection(): SettingsSnapshot =
        repository.finishThemeSelection()

    fun setLauncherIconVisible(visible: Boolean): SettingsSnapshot =
        repository.setLauncherIconVisible(visible)

    fun setSoundEnabled(enabled: Boolean): SettingsSnapshot =
        repository.setSoundEnabled(enabled)

    fun setVolumePercent(percent: Int): SettingsSnapshot {
        val snapshot = repository.setVolumePercent(percent)
        previewEffects.previewVolume(percent)
        return snapshot
    }

    fun restoreVolumeDefault(): SettingsSnapshot = repository.restoreVolumeDefault()

    fun setVibrationEnabled(enabled: Boolean): SettingsSnapshot =
        repository.setVibrationEnabled(enabled)

    fun setOneHandedModeIndex(index: Int): SettingsSnapshot =
        repository.setOneHandedModeIndex(index)

    fun setPinyinSchemeIndex(index: Int): SettingsSnapshot =
        repository.setPinyinSchemeIndex(index)

    fun setGestureInputEnabled(enabled: Boolean): SettingsSnapshot =
        repository.setGestureInputEnabled(enabled)

    fun setBoolean(
        contract: BooleanSettingContract,
        enabled: Boolean,
    ): SettingsSnapshot = repository.setBoolean(contract, enabled)

    fun setVibrationDuration(milliseconds: Int): SettingsSnapshot {
        val snapshot = repository.setVibrationDuration(milliseconds)
        previewEffects.previewVibration(milliseconds)
        return snapshot
    }

    fun restoreVibrationDefault(): SettingsSnapshot =
        repository.restoreVibrationDefault()

    fun setKeyboardHeightIndex(index: Int): SettingsSnapshot =
        repository.setKeyboardHeightIndex(index)

    fun setSlideSensitivityIndex(index: Int): SettingsSnapshot =
        repository.setSlideSensitivityIndex(index)

    fun setLongPressDelay(milliseconds: Int): SettingsSnapshot =
        repository.setLongPressDelay(milliseconds)

    fun restoreLongPressDefault(): SettingsSnapshot =
        repository.restoreLongPressDefault()

    fun setHandwritingTimeoutIndex(index: Int): SettingsSnapshot =
        repository.setHandwritingTimeoutIndex(index)

    fun setHandwritingStrokeWidthIndex(index: Int): SettingsSnapshot =
        repository.setHandwritingStrokeWidthIndex(index)
}
