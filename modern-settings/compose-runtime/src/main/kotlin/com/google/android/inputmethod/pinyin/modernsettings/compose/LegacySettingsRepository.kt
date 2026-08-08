package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.SharedPreferences
import android.content.pm.ApplicationInfo
import android.os.Build

/** Read-only bridge to the exact default SharedPreferences used by Lamx. */
class LegacySettingsRepository(context: Context) {
    private val applicationContext = context.applicationContext
    private val resources = applicationContext.resources
    private val preferences: SharedPreferences = applicationContext.getSharedPreferences(
        "${applicationContext.packageName}_preferences",
        Context.MODE_PRIVATE,
    )

    fun readSnapshot(): SettingsSnapshot {
        val capabilities = SettingsCapabilityResolver.resolve(applicationContext)
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

        val oneHandedModeIndex = readListIndex(ListSettingContracts.oneHandedMode)
        val pinyinSchemeIndex = readListIndex(ListSettingContracts.pinyinScheme)
        val showEmojiSwitchKey = readBoolean(BooleanSettingContracts.showEmojiSwitchKey)
        val showLanguageSwitchKey = readBoolean(BooleanSettingContracts.showLanguageSwitchKey)
        val showEnglishKeyboard = readBoolean(BooleanSettingContracts.showEnglishKeyboard)
        val languageSwitchState = LanguageSwitchSettingRules.resolve(
            emojiSwitchKeyVisible = capabilities.emojiSwitchKeyVisible,
            inputMethodSwitchingAvailable = capabilities.inputMethodSwitchingAvailable,
            emojiSwitchKeyChecked = showEmojiSwitchKey.value,
            showEnglishKeyboard = showEnglishKeyboard.value,
            persistedLanguageSwitchKey = showLanguageSwitchKey.value,
        )
        val keyboardHeightIndex = readEnumeratedIndex(SliderSettingContracts.keyboardHeight)
        val slideSensitivityIndex = readEnumeratedIndex(SliderSettingContracts.slideSensitivity)
        val handwritingTimeoutIndex = readEnumeratedIndex(SliderSettingContracts.handwritingTimeout)
        val handwritingStrokeWidthIndex = readEnumeratedIndex(
            SliderSettingContracts.handwritingStrokeWidth,
        )
        val launcherIcon = readLauncherIcon()

        return SettingsSnapshot(
            capabilities = capabilities,
            soundEnabled = preferences.getBoolean(SliderSettingContracts.SOUND_ENABLED_KEY, false),
            volume = volume,
            vibrationEnabled = preferences.getBoolean(
                SliderSettingContracts.VIBRATION_ENABLED_KEY,
                true,
            ),
            vibration = vibration,
            doubleSpacePeriod = readBoolean(BooleanSettingContracts.doubleSpacePeriod),
            gestureInput = readBoolean(BooleanSettingContracts.gestureInput),
            gestureInputPersistent = readBoolean(
                BooleanSettingContracts.gestureInputPersistent,
            ),
            incrementalGesturePreview = readBoolean(
                BooleanSettingContracts.incrementalGesturePreview,
            ),
            gestureAutoCommit = readBoolean(BooleanSettingContracts.gestureAutoCommit),
            scrubMove = readBoolean(BooleanSettingContracts.scrubMove),
            chineseEnglishMixedInput = readBoolean(
                BooleanSettingContracts.chineseEnglishMixedInput,
            ),
            chineseDigitsMixedInput = readBoolean(
                BooleanSettingContracts.chineseDigitsMixedInput,
            ),
            suggestEmojis = readBoolean(BooleanSettingContracts.suggestEmojis),
            spatialCorrection = readBoolean(BooleanSettingContracts.spatialCorrection),
            traditionalChinese = readBoolean(BooleanSettingContracts.traditionalChinese),
            chinesePrediction = readBoolean(BooleanSettingContracts.chinesePrediction),
            automaticSpace = readBoolean(BooleanSettingContracts.automaticSpace),
            fuzzyPinyin = readBoolean(BooleanSettingContracts.fuzzyPinyin),
            fuzzyPinyinOptions = BooleanSettingContracts.fuzzyPinyinOptionBatch.map(::readBoolean),
            latinAutoCorrection = readBoolean(BooleanSettingContracts.latinAutoCorrection),
            latinShowSuggestions = readBoolean(BooleanSettingContracts.latinShowSuggestions),
            nextWordPrediction = readBoolean(BooleanSettingContracts.nextWordPrediction),
            autoCapitalization = readBoolean(BooleanSettingContracts.autoCapitalization),
            blockOffensiveWords = readBoolean(BooleanSettingContracts.blockOffensiveWords),
            popupOnKeypress = readBoolean(BooleanSettingContracts.popupOnKeypress),
            voiceInput = readBoolean(BooleanSettingContracts.voiceInput),
            showEmojiSwitchKey = showEmojiSwitchKey,
            showLanguageSwitchKey = showLanguageSwitchKey,
            switchToOtherImes = readBoolean(BooleanSettingContracts.switchToOtherImes),
            languageSwitchState = languageSwitchState,
            oneHandedModeIndex = oneHandedModeIndex,
            oneHandedModeLabel = readEntryLabel(
                "entries_one_handed_mode",
                oneHandedModeIndex,
            ),
            oneHandedModeLabels = readEntryLabels("entries_one_handed_mode"),
            pinyinSchemeIndex = pinyinSchemeIndex,
            pinyinSchemeLabel = readEntryLabel("entries_pinyin_scheme", pinyinSchemeIndex),
            pinyinSchemeLabels = readEntryLabels("entries_pinyin_scheme"),
            showEnglishKeyboard = showEnglishKeyboard,
            emojiAltPhysicalKey = readBoolean(BooleanSettingContracts.emojiAltPhysicalKey),
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
            launcherIcon = launcherIcon,
            longPress = SliderSettingContracts.resolveLongPress(
                preferences.contains(SliderSettingContracts.LONG_PRESS_DELAY_KEY),
                preferences.getString(SliderSettingContracts.LONG_PRESS_DELAY_KEY, null),
            ),
            handwritingTimeoutIndex = handwritingTimeoutIndex,
            handwritingTimeoutLabel = readEntryLabel(
                "entries_handwriting_timeout_ms",
                handwritingTimeoutIndex,
            ),
            handwritingTimeoutLabels = readEntryLabels("entries_handwriting_timeout_ms"),
            handwritingStrokeWidthIndex = handwritingStrokeWidthIndex,
            handwritingStrokeWidthLabel = readEntryLabel(
                "entries_handwriting_stroke_width_scale",
                handwritingStrokeWidthIndex,
            ),
            handwritingStrokeWidthLabels = readEntryLabels(
                "entries_handwriting_stroke_width_scale",
            ),
        )
    }

    fun setLauncherIconVisible(visible: Boolean): SettingsSnapshot {
        preferences.edit().putBoolean(LAUNCHER_ICON_KEY, visible).apply()
        return readSnapshot()
    }

    fun setSoundEnabled(enabled: Boolean): SettingsSnapshot {
        preferences.edit().putBoolean(SliderSettingContracts.SOUND_ENABLED_KEY, enabled).apply()
        return readSnapshot()
    }

    fun setVibrationEnabled(enabled: Boolean): SettingsSnapshot {
        requireVibrationControlsAvailable()
        preferences.edit().putBoolean(SliderSettingContracts.VIBRATION_ENABLED_KEY, enabled).apply()
        return readSnapshot()
    }

    fun setOneHandedModeIndex(index: Int): SettingsSnapshot {
        require(SettingsCapabilityResolver.resolve(applicationContext).oneHandedModeVisible) {
            "One-handed mode is unavailable"
        }
        val contract = ListSettingContracts.oneHandedMode
        preferences.edit().putString(contract.key, contract.valueAt(index)).apply()
        return readSnapshot()
    }

    fun setPinyinSchemeIndex(index: Int): SettingsSnapshot {
        val contract = ListSettingContracts.pinyinScheme
        preferences.edit().putString(contract.key, contract.valueAt(index)).apply()
        return readSnapshot()
    }

    fun setGestureInputEnabled(enabled: Boolean): SettingsSnapshot {
        preferences.edit()
            .putBoolean(BooleanSettingContracts.gestureInput.key, enabled)
            .putBoolean(BooleanSettingContracts.gestureInputPersistent.key, enabled)
            .apply()
        return readSnapshot()
    }

    fun setBoolean(contract: BooleanSettingContract, enabled: Boolean): SettingsSnapshot {
        require(contract in BooleanSettingContracts.writable)
        val capabilities = SettingsCapabilityResolver.resolve(applicationContext)
        if (contract == BooleanSettingContracts.popupOnKeypress) {
            require(capabilities.popupOnKeypressVisible) { "Key popup is unavailable" }
        }
        if (contract == BooleanSettingContracts.voiceInput) {
            require(capabilities.voiceInputVisible) { "Voice input is unavailable" }
        }
        if (contract == BooleanSettingContracts.showEmojiSwitchKey) {
            require(capabilities.emojiSwitchKeyVisible) { "Emoji switch key is unavailable" }
        }
        if (
            contract == BooleanSettingContracts.showLanguageSwitchKey ||
            contract == BooleanSettingContracts.switchToOtherImes
        ) {
            val state = currentLanguageSwitchState(capabilities)
            if (contract == BooleanSettingContracts.showLanguageSwitchKey) {
                require(state.languageSwitchEnabled) { "Language switch key is disabled" }
            } else {
                require(state.switchToOtherImesVisible) {
                    "Switching to other input methods is unavailable"
                }
                require(state.switchToOtherImesEnabled) {
                    "Switching to other input methods is disabled"
                }
            }
        }
        contract.dependency?.let { dependency ->
            require(readBoolean(dependency).value) {
                "Boolean dependency is disabled: ${dependency.key}"
            }
        }
        preferences.edit().putBoolean(contract.key, enabled).apply()
        return readSnapshot()
    }

    fun setVolumePercent(percent: Int): SettingsSnapshot {
        preferences.edit().putFloat(
            SliderSettingContracts.SOUND_VOLUME_KEY,
            SliderSettingContracts.encodeVolumePercent(percent),
        ).apply()
        return readSnapshot()
    }

    fun restoreVolumeDefault(): SettingsSnapshot {
        preferences.edit().remove(SliderSettingContracts.SOUND_VOLUME_KEY).apply()
        return readSnapshot()
    }

    fun setVibrationDuration(milliseconds: Int): SettingsSnapshot {
        requireVibrationControlsAvailable()
        preferences.edit().putString(
            SliderSettingContracts.VIBRATION_DURATION_KEY,
            SliderSettingContracts.encodeVibration(milliseconds),
        ).apply()
        return readSnapshot()
    }

    fun restoreVibrationDefault(): SettingsSnapshot {
        requireVibrationControlsAvailable()
        preferences.edit().remove(SliderSettingContracts.VIBRATION_DURATION_KEY).apply()
        return readSnapshot()
    }

    fun setKeyboardHeightIndex(index: Int): SettingsSnapshot {
        writeEnumerated(SliderSettingContracts.keyboardHeight, index)
        return readSnapshot()
    }

    fun setSlideSensitivityIndex(index: Int): SettingsSnapshot {
        writeEnumerated(SliderSettingContracts.slideSensitivity, index)
        return readSnapshot()
    }

    fun setLongPressDelay(milliseconds: Int): SettingsSnapshot {
        preferences.edit().putString(
            SliderSettingContracts.LONG_PRESS_DELAY_KEY,
            SliderSettingContracts.encodeLongPress(milliseconds),
        ).apply()
        return readSnapshot()
    }

    fun restoreLongPressDefault(): SettingsSnapshot {
        preferences.edit().remove(SliderSettingContracts.LONG_PRESS_DELAY_KEY).apply()
        return readSnapshot()
    }

    fun setHandwritingTimeoutIndex(index: Int): SettingsSnapshot {
        writeEnumerated(SliderSettingContracts.handwritingTimeout, index)
        return readSnapshot()
    }

    fun setHandwritingStrokeWidthIndex(index: Int): SettingsSnapshot {
        writeEnumerated(SliderSettingContracts.handwritingStrokeWidth, index)
        return readSnapshot()
    }

    private fun requireVibrationControlsAvailable() {
        require(SettingsCapabilityResolver.resolve(applicationContext).vibrationControlsVisible) {
            "Vibration controls are unavailable"
        }
    }

    private fun currentLanguageSwitchState(
        capabilities: SettingsCapabilities,
    ): LanguageSwitchSettingState = LanguageSwitchSettingRules.resolve(
        emojiSwitchKeyVisible = capabilities.emojiSwitchKeyVisible,
        inputMethodSwitchingAvailable = capabilities.inputMethodSwitchingAvailable,
        emojiSwitchKeyChecked = readBoolean(BooleanSettingContracts.showEmojiSwitchKey).value,
        showEnglishKeyboard = readBoolean(BooleanSettingContracts.showEnglishKeyboard).value,
        persistedLanguageSwitchKey = readBoolean(
            BooleanSettingContracts.showLanguageSwitchKey,
        ).value,
    )

    private fun readLauncherIcon(): BooleanSettingState {
        val isExplicit = preferences.contains(LAUNCHER_ICON_KEY)
        val value = if (isExplicit) {
            preferences.getBoolean(LAUNCHER_ICON_KEY, false)
        } else {
            val flags = applicationContext.applicationInfo.flags
            val isSystemOrUpdatedSystemApp = flags and (
                ApplicationInfo.FLAG_SYSTEM or ApplicationInfo.FLAG_UPDATED_SYSTEM_APP
            ) != 0
            val resourceId = resources.getIdentifier(
                "show_launcher_icon",
                "bool",
                applicationContext.packageName,
            )
            require(resourceId != 0) { "Missing launcher icon default resource" }
            LauncherIconSettingRules.defaultVisible(
                isSystemOrUpdatedSystemApp = isSystemOrUpdatedSystemApp,
                resourceDefault = resources.getBoolean(resourceId),
            )
        }
        return BooleanSettingState(value = value, isExplicit = isExplicit)
    }

    private fun readBoolean(contract: BooleanSettingContract): BooleanSettingState =
        BooleanSettingState(
            value = preferences.getBoolean(contract.key, contract.defaultValue),
            isExplicit = preferences.contains(contract.key),
        )

    private fun writeEnumerated(contract: EnumeratedSliderContract, index: Int) {
        preferences.edit().putString(contract.key, contract.valueAt(index)).apply()
    }

    private fun readListIndex(contract: EnumeratedListContract): Int =
        contract.indexOf(preferences.getString(contract.key, contract.defaultValue))

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
        private const val LAUNCHER_ICON_KEY = "show_launcher_icon"

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

data class SettingsSnapshot(
    val capabilities: SettingsCapabilities,
    val soundEnabled: Boolean,
    val volume: ResolvedSetting<Float>,
    val vibrationEnabled: Boolean,
    val vibration: ResolvedSetting<Int>,
    val doubleSpacePeriod: BooleanSettingState,
    val gestureInput: BooleanSettingState,
    val gestureInputPersistent: BooleanSettingState,
    val incrementalGesturePreview: BooleanSettingState,
    val gestureAutoCommit: BooleanSettingState,
    val scrubMove: BooleanSettingState,
    val chineseEnglishMixedInput: BooleanSettingState,
    val chineseDigitsMixedInput: BooleanSettingState,
    val suggestEmojis: BooleanSettingState,
    val spatialCorrection: BooleanSettingState,
    val traditionalChinese: BooleanSettingState,
    val chinesePrediction: BooleanSettingState,
    val automaticSpace: BooleanSettingState,
    val fuzzyPinyin: BooleanSettingState,
    val fuzzyPinyinOptions: List<BooleanSettingState>,
    val latinAutoCorrection: BooleanSettingState,
    val latinShowSuggestions: BooleanSettingState,
    val nextWordPrediction: BooleanSettingState,
    val autoCapitalization: BooleanSettingState,
    val blockOffensiveWords: BooleanSettingState,
    val popupOnKeypress: BooleanSettingState,
    val voiceInput: BooleanSettingState,
    val showEmojiSwitchKey: BooleanSettingState,
    val showLanguageSwitchKey: BooleanSettingState,
    val switchToOtherImes: BooleanSettingState,
    val languageSwitchState: LanguageSwitchSettingState,
    val oneHandedModeIndex: Int,
    val oneHandedModeLabel: String,
    val oneHandedModeLabels: List<String>,
    val pinyinSchemeIndex: Int,
    val pinyinSchemeLabel: String,
    val pinyinSchemeLabels: List<String>,
    val showEnglishKeyboard: BooleanSettingState,
    val emojiAltPhysicalKey: BooleanSettingState,
    val keyboardHeightIndex: Int,
    val keyboardHeightLabel: String,
    val keyboardHeightLabels: List<String>,
    val slideSensitivityIndex: Int,
    val slideSensitivityLabel: String,
    val slideSensitivityLabels: List<String>,
    val launcherIcon: BooleanSettingState,
    val longPress: DefaultableSetting<Int>,
    val handwritingTimeoutIndex: Int,
    val handwritingTimeoutLabel: String,
    val handwritingTimeoutLabels: List<String>,
    val handwritingStrokeWidthIndex: Int,
    val handwritingStrokeWidthLabel: String,
    val handwritingStrokeWidthLabels: List<String>,
)
