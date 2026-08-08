package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.activity.compose.BackHandler
import androidx.annotation.StringRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

data class SettingsActions(
    val onSoundEnabledChange: (Boolean) -> Unit,
    val onVolumeCommit: (Int) -> Unit,
    val onVolumeDefault: () -> Unit,
    val onVibrationEnabledChange: (Boolean) -> Unit,
    val onOneHandedModeChange: (Int) -> Unit,
    val onPinyinSchemeChange: (Int) -> Unit,
    val onGestureInputEnabledChange: (Boolean) -> Unit,
    val onBooleanChange: (BooleanSettingContract, Boolean) -> Unit,
    val onVibrationCommit: (Int) -> Unit,
    val onVibrationDefault: () -> Unit,
    val onKeyboardHeightChange: (Int) -> Unit,
    val onSlideSensitivityChange: (Int) -> Unit,
    val onLongPressDelayChange: (Int) -> Unit,
    val onLongPressDefault: () -> Unit,
    val onHandwritingTimeoutChange: (Int) -> Unit,
    val onHandwritingStrokeWidthChange: (Int) -> Unit,
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(snapshot: SettingsSnapshot, actions: SettingsActions) {
    var fuzzyDetailVisible by rememberSaveable { mutableStateOf(false) }
    BackHandler(enabled = fuzzyDetailVisible) { fuzzyDetailVisible = false }
    if (fuzzyDetailVisible) {
        FuzzyPinyinDetailScreen(
            snapshot = snapshot,
            actions = actions,
            onNavigateBack = { fuzzyDetailVisible = false },
        )
        return
    }

    val context = LocalContext.current
    val percentText: (Int) -> String = {
        context.getString(R.string.modern_settings_percent_format, it)
    }
    val millisecondsText: (Int) -> String = {
        context.getString(R.string.modern_settings_milliseconds_format, it)
    }
    Scaffold(
        topBar = { TopAppBar(title = { Text(stringResource(R.string.modern_settings_title)) }) },
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier.padding(innerPadding),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            item {
                Text(
                    text = stringResource(R.string.modern_settings_stage_summary),
                    modifier = Modifier.padding(horizontal = 24.dp, vertical = 12.dp),
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            item { SectionTitle(stringResource(R.string.modern_settings_section_input)) }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_double_space_period_title",
                        R.string.modern_settings_double_space_title,
                    ),
                    supporting = legacyString(
                        "setting_double_space_period_summary_cn",
                        R.string.modern_settings_double_space_summary,
                    ),
                    checked = snapshot.doubleSpacePeriod.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.doubleSpacePeriod, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_gesture_input_title",
                        R.string.modern_settings_gesture_input_title,
                    ),
                    supporting = legacyString(
                        "setting_gesture_input_summary",
                        R.string.modern_settings_gesture_input_summary,
                    ),
                    checked = snapshot.gestureInput.value,
                    onCheckedChange = actions.onGestureInputEnabledChange,
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_scrub_move_title",
                        R.string.modern_settings_scrub_move_title,
                    ),
                    supporting = legacyString(
                        "setting_scrub_move_summary",
                        R.string.modern_settings_scrub_move_summary,
                    ),
                    checked = snapshot.scrubMove.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.scrubMove, it)
                    },
                )
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item {
                SectionTitle(
                    legacyString(
                        "setting_chinese_input",
                        R.string.modern_settings_section_chinese_input,
                    )
                )
            }
            item {
                EnumeratedListSetting(
                    title = legacyString(
                        "setting_pinyin_scheme_title",
                        R.string.modern_settings_pinyin_scheme_title,
                    ),
                    selectedIndex = snapshot.pinyinSchemeIndex,
                    selectedLabel = snapshot.pinyinSchemeLabel,
                    labels = snapshot.pinyinSchemeLabels,
                    onSelect = actions.onPinyinSchemeChange,
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_chinese_english_mixed_input_title",
                        R.string.modern_settings_chinese_english_title,
                    ),
                    supporting = legacyString(
                        "setting_chinese_english_mixed_input_summary",
                        R.string.modern_settings_chinese_english_summary,
                    ),
                    checked = snapshot.chineseEnglishMixedInput.value,
                    onCheckedChange = {
                        actions.onBooleanChange(
                            BooleanSettingContracts.chineseEnglishMixedInput,
                            it,
                        )
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_chinese_digits_mixed_input_title",
                        R.string.modern_settings_chinese_digits_title,
                    ),
                    supporting = legacyString(
                        "setting_chinese_digits_mixed_input_summary",
                        R.string.modern_settings_chinese_digits_summary,
                    ),
                    checked = snapshot.chineseDigitsMixedInput.value,
                    onCheckedChange = {
                        actions.onBooleanChange(
                            BooleanSettingContracts.chineseDigitsMixedInput,
                            it,
                        )
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_suggest_emojis_title",
                        R.string.modern_settings_suggest_emojis_title,
                    ),
                    supporting = legacyString(
                        "setting_suggest_emojis_summary",
                        R.string.modern_settings_suggest_emojis_summary,
                    ),
                    checked = snapshot.suggestEmojis.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.suggestEmojis, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_intelligent_correction_title",
                        R.string.modern_settings_spatial_correction_title,
                    ),
                    supporting = legacyString(
                        "setting_intelligent_correction_summary",
                        R.string.modern_settings_spatial_correction_summary,
                    ),
                    checked = snapshot.spatialCorrection.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.spatialCorrection, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_tradition_title",
                        R.string.modern_settings_traditional_chinese_title,
                    ),
                    checked = snapshot.traditionalChinese.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.traditionalChinese, it)
                    },
                )
            }
            item {
                val dependencyEnabled = snapshot.gestureInput.value
                val originalSummary = legacyString(
                    "setting_gesture_input_preview_summary",
                    R.string.modern_settings_gesture_preview_summary,
                )
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_gesture_input_preview_title",
                        R.string.modern_settings_gesture_preview_title,
                    ),
                    supporting = if (dependencyEnabled) originalSummary else
                        originalSummary + "\n" + stringResource(
                            R.string.modern_settings_requires_gesture_input
                        ),
                    checked = snapshot.incrementalGesturePreview.value,
                    enabled = dependencyEnabled,
                    onCheckedChange = {
                        actions.onBooleanChange(
                            BooleanSettingContracts.incrementalGesturePreview,
                            it,
                        )
                    },
                )
            }
            item {
                val dependencyEnabled = snapshot.gestureInput.value
                val originalSummary = legacyString(
                    "setting_gesture_auto_commit_summary",
                    R.string.modern_settings_gesture_auto_commit_summary,
                )
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_gesture_auto_commit_title",
                        R.string.modern_settings_gesture_auto_commit_title,
                    ),
                    supporting = if (dependencyEnabled) originalSummary else
                        originalSummary + "\n" + stringResource(
                            R.string.modern_settings_requires_gesture_input
                        ),
                    checked = snapshot.gestureAutoCommit.value,
                    enabled = dependencyEnabled,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.gestureAutoCommit, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_prediction_chinese_title",
                        R.string.modern_settings_chinese_prediction_title,
                    ),
                    supporting = legacyString(
                        "setting_prediction_chinese_summary",
                        R.string.modern_settings_chinese_prediction_summary,
                    ),
                    checked = snapshot.chinesePrediction.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.chinesePrediction, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_auto_space_title",
                        R.string.modern_settings_automatic_space_title,
                    ),
                    supporting = legacyString(
                        "setting_auto_space_summary",
                        R.string.modern_settings_automatic_space_summary,
                    ),
                    checked = snapshot.automaticSpace.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.automaticSpace, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_fuzzy_pinyin_title",
                        R.string.modern_settings_fuzzy_pinyin_title,
                    ),
                    checked = snapshot.fuzzyPinyin.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.fuzzyPinyin, it)
                    },
                )
            }
            item {
                SettingsNavigationRow(
                    title = legacyString(
                        "setting_fuzzy_pinyin_detail_title",
                        R.string.modern_settings_fuzzy_pinyin_detail_title,
                    ),
                    enabled = snapshot.fuzzyPinyin.value,
                    onClick = { fuzzyDetailVisible = true },
                )
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item {
                SectionTitle(
                    legacyString(
                        "setting_english_input",
                        R.string.modern_settings_section_english_input,
                    )
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_spell_correction_title",
                        R.string.modern_settings_latin_auto_correction_title,
                    ),
                    supporting = legacyString(
                        "setting_spell_correction_summary",
                        R.string.modern_settings_latin_auto_correction_summary,
                    ),
                    checked = snapshot.latinAutoCorrection.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.latinAutoCorrection, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_show_suggestion_title",
                        R.string.modern_settings_latin_show_suggestions_title,
                    ),
                    supporting = legacyString(
                        "setting_show_suggestion_summary",
                        R.string.modern_settings_latin_show_suggestions_summary,
                    ),
                    checked = snapshot.latinShowSuggestions.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.latinShowSuggestions, it)
                    },
                )
            }
            item {
                val dependencyEnabled = snapshot.latinShowSuggestions.value
                val originalSummary = legacyString(
                    "setting_next_word_prediction_summary",
                    R.string.modern_settings_next_word_prediction_summary,
                )
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_next_word_prediction_title",
                        R.string.modern_settings_next_word_prediction_title,
                    ),
                    supporting = if (dependencyEnabled) originalSummary else
                        originalSummary + "\n" + stringResource(
                            R.string.modern_settings_requires_show_suggestions
                        ),
                    checked = snapshot.nextWordPrediction.value,
                    enabled = dependencyEnabled,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.nextWordPrediction, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_auto_capitalization_title",
                        R.string.modern_settings_auto_capitalization_title,
                    ),
                    supporting = legacyString(
                        "setting_auto_capitalization_summary",
                        R.string.modern_settings_auto_capitalization_summary,
                    ),
                    checked = snapshot.autoCapitalization.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.autoCapitalization, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_block_offensive_words_title",
                        R.string.modern_settings_block_offensive_words_title,
                    ),
                    supporting = legacyString(
                        "setting_block_offensive_words_summary",
                        R.string.modern_settings_block_offensive_words_summary,
                    ),
                    checked = snapshot.blockOffensiveWords.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.blockOffensiveWords, it)
                    },
                )
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item { SectionTitle(stringResource(R.string.modern_settings_section_key_feedback)) }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_sound_on_keypress_title",
                        R.string.modern_settings_sound_title,
                    ),
                    supporting = stringResource(
                        if (snapshot.soundEnabled) R.string.modern_settings_enabled
                        else R.string.modern_settings_disabled
                    ),
                    checked = snapshot.soundEnabled,
                    onCheckedChange = actions.onSoundEnabledChange,
                )
            }
            item {
                DefaultAwareAdjustment(
                    title = legacyString(
                        "setting_sound_volume_of_keypress",
                        R.string.modern_settings_volume_title,
                    ),
                    state = snapshot.volume.toVolumeProgress(),
                    valueText = percentText,
                    enabledByDependency = snapshot.soundEnabled,
                    decreaseDescription = stringResource(R.string.modern_settings_decrease_volume),
                    increaseDescription = stringResource(R.string.modern_settings_increase_volume),
                    onCommit = actions.onVolumeCommit,
                    onRestoreDefault = actions.onVolumeDefault,
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_vibrate_on_keypress_title",
                        R.string.modern_settings_vibration_title,
                    ),
                    supporting = stringResource(
                        if (snapshot.vibrationEnabled) R.string.modern_settings_enabled
                        else R.string.modern_settings_disabled
                    ),
                    checked = snapshot.vibrationEnabled,
                    onCheckedChange = actions.onVibrationEnabledChange,
                )
            }
            item {
                DefaultAwareAdjustment(
                    title = legacyString(
                        "setting_vibration_strength_on_keypress_title",
                        R.string.modern_settings_vibration_duration_title,
                    ),
                    state = snapshot.vibration,
                    valueText = millisecondsText,
                    enabledByDependency = snapshot.vibrationEnabled,
                    decreaseDescription = stringResource(
                        R.string.modern_settings_decrease_vibration
                    ),
                    increaseDescription = stringResource(
                        R.string.modern_settings_increase_vibration
                    ),
                    onCommit = actions.onVibrationCommit,
                    onRestoreDefault = actions.onVibrationDefault,
                )
            }
            if (snapshot.capabilities.popupOnKeypressVisible) {
                item {
                    SettingsSwitchRow(
                        title = legacyString(
                            "setting_popup_on_keypress_title",
                            R.string.modern_settings_popup_on_keypress_title,
                        ),
                        checked = snapshot.popupOnKeypress.value,
                        onCheckedChange = {
                            actions.onBooleanChange(BooleanSettingContracts.popupOnKeypress, it)
                        },
                    )
                }
            }
            if (snapshot.capabilities.voiceInputVisible) {
                item {
                    SettingsSwitchRow(
                        title = legacyString(
                            "setting_voice_input_title",
                            R.string.modern_settings_voice_input_title,
                        ),
                        checked = snapshot.voiceInput.value,
                        onCheckedChange = {
                            actions.onBooleanChange(BooleanSettingContracts.voiceInput, it)
                        },
                    )
                }
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item { SectionTitle(stringResource(R.string.modern_settings_section_layout_gestures)) }
            if (snapshot.capabilities.oneHandedModeVisible) {
                item {
                    EnumeratedListSetting(
                        title = legacyString(
                            "setting_one_handed_mode_title",
                            R.string.modern_settings_one_handed_mode_title,
                        ),
                        selectedIndex = snapshot.oneHandedModeIndex,
                        selectedLabel = snapshot.oneHandedModeLabel,
                        labels = snapshot.oneHandedModeLabels,
                        onSelect = actions.onOneHandedModeChange,
                    )
                }
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_show_english_keyboard_title",
                        R.string.modern_settings_show_english_keyboard_title,
                    ),
                    checked = snapshot.showEnglishKeyboard.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.showEnglishKeyboard, it)
                    },
                )
            }
            item {
                SettingsSwitchRow(
                    title = legacyString(
                        "setting_enable_symbol_alt_physical_key_title",
                        R.string.modern_settings_physical_alt_title,
                    ),
                    supporting = legacyString(
                        "setting_enable_symbol_alt_physical_key_summary",
                        R.string.modern_settings_physical_alt_summary,
                    ),
                    checked = snapshot.emojiAltPhysicalKey.value,
                    onCheckedChange = {
                        actions.onBooleanChange(BooleanSettingContracts.emojiAltPhysicalKey, it)
                    },
                )
            }
            item {
                DiscreteSettingsSlider(
                    title = legacyString(
                        "setting_keyboard_height_ratio_title",
                        R.string.modern_settings_keyboard_height_title,
                    ),
                    value = snapshot.keyboardHeightIndex.toFloat(),
                    valueText = snapshot.keyboardHeightLabel,
                    valueTextForIndex = snapshot.keyboardHeightLabels::get,
                    maximumIndex = SliderSettingContracts.keyboardHeight.values.lastIndex,
                    editable = true,
                    onValueCommit = actions.onKeyboardHeightChange,
                )
            }
            item {
                DiscreteSettingsSlider(
                    title = legacyString(
                        "setting_keyboard_slide_sensitivity_ratio_title",
                        R.string.modern_settings_slide_sensitivity_title,
                    ),
                    value = snapshot.slideSensitivityIndex.toFloat(),
                    valueText = snapshot.slideSensitivityLabel,
                    valueTextForIndex = snapshot.slideSensitivityLabels::get,
                    maximumIndex = SliderSettingContracts.slideSensitivity.values.lastIndex,
                    editable = true,
                    onValueCommit = actions.onSlideSensitivityChange,
                )
            }
            item {
                LongPressDelaySetting(
                    title = legacyString(
                        "setting_key_long_press_delay_title",
                        R.string.modern_settings_long_press_title,
                    ),
                    state = snapshot.longPress,
                    millisecondsText = millisecondsText,
                    onCommit = actions.onLongPressDelayChange,
                    onRestoreDefault = actions.onLongPressDefault,
                )
            }
            item { HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp)) }
            item { SectionTitle(stringResource(R.string.modern_settings_section_handwriting)) }
            item {
                DiscreteSettingsSlider(
                    title = legacyString(
                        "setting_handwriting_timeout_title",
                        R.string.modern_settings_handwriting_timeout_title,
                    ),
                    value = snapshot.handwritingTimeoutIndex.toFloat(),
                    valueText = handwritingTimeoutText(
                        snapshot.handwritingTimeoutIndex,
                        snapshot.handwritingTimeoutLabels,
                        millisecondsText,
                    ),
                    valueTextForIndex = { index ->
                        handwritingTimeoutText(
                            index,
                            snapshot.handwritingTimeoutLabels,
                            millisecondsText,
                        )
                    },
                    maximumIndex = SliderSettingContracts.handwritingTimeout.values.lastIndex,
                    editable = true,
                    onValueCommit = actions.onHandwritingTimeoutChange,
                )
            }
            item {
                DiscreteSettingsSlider(
                    title = legacyString(
                        "setting_handwriting_stroke_width_title",
                        R.string.modern_settings_handwriting_stroke_width_title,
                    ),
                    value = snapshot.handwritingStrokeWidthIndex.toFloat(),
                    valueText = handwritingStrokeWidthText(
                        snapshot.handwritingStrokeWidthIndex,
                        snapshot.handwritingStrokeWidthLabels,
                    ),
                    valueTextForIndex = { index ->
                        handwritingStrokeWidthText(
                            index,
                            snapshot.handwritingStrokeWidthLabels,
                        )
                    },
                    maximumIndex = SliderSettingContracts.handwritingStrokeWidth.values.lastIndex,
                    editable = true,
                    onValueCommit = actions.onHandwritingStrokeWidthChange,
                )
            }
        }
    }
}

private data class FuzzyPinyinOptionUi(
    val contract: BooleanSettingContract,
    val legacyTitle: String,
    @param:StringRes val fallbackTitle: Int,
    val legacyDescription: String,
    @param:StringRes val fallbackDescription: Int,
)

private val fuzzyPinyinOptions = listOf(
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinZZh, "setting_fuzzy_pinyin_option_z_zh", R.string.modern_settings_fuzzy_z_zh, "setting_desc_fuzzy_pinyin_option_z_zh", R.string.modern_settings_fuzzy_z_zh_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinCCh, "setting_fuzzy_pinyin_option_c_ch", R.string.modern_settings_fuzzy_c_ch, "setting_desc_fuzzy_pinyin_option_c_ch", R.string.modern_settings_fuzzy_c_ch_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinSSh, "setting_fuzzy_pinyin_option_s_sh", R.string.modern_settings_fuzzy_s_sh, "setting_desc_fuzzy_pinyin_option_s_sh", R.string.modern_settings_fuzzy_s_sh_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinAnAng, "setting_fuzzy_pinyin_option_an_ang", R.string.modern_settings_fuzzy_an_ang, "setting_desc_fuzzy_pinyin_option_an_ang", R.string.modern_settings_fuzzy_an_ang_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinEnEng, "setting_fuzzy_pinyin_option_en_eng", R.string.modern_settings_fuzzy_en_eng, "setting_desc_fuzzy_pinyin_option_en_eng", R.string.modern_settings_fuzzy_en_eng_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinInIng, "setting_fuzzy_pinyin_option_in_ing", R.string.modern_settings_fuzzy_in_ing, "setting_desc_fuzzy_pinyin_option_in_ing", R.string.modern_settings_fuzzy_in_ing_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinLN, "setting_fuzzy_pinyin_option_l_n", R.string.modern_settings_fuzzy_l_n, "setting_desc_fuzzy_pinyin_option_l_n", R.string.modern_settings_fuzzy_l_n_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinFH, "setting_fuzzy_pinyin_option_f_h", R.string.modern_settings_fuzzy_f_h, "setting_desc_fuzzy_pinyin_option_f_h", R.string.modern_settings_fuzzy_f_h_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinRL, "setting_fuzzy_pinyin_option_r_l", R.string.modern_settings_fuzzy_r_l, "setting_desc_fuzzy_pinyin_option_r_l", R.string.modern_settings_fuzzy_r_l_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinKG, "setting_fuzzy_pinyin_option_k_g", R.string.modern_settings_fuzzy_k_g, "setting_desc_fuzzy_pinyin_option_k_g", R.string.modern_settings_fuzzy_k_g_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinIanIang, "setting_fuzzy_pinyin_option_ian_iang", R.string.modern_settings_fuzzy_ian_iang, "setting_desc_fuzzy_pinyin_option_ian_iang", R.string.modern_settings_fuzzy_ian_iang_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinUanUang, "setting_fuzzy_pinyin_option_uan_uang", R.string.modern_settings_fuzzy_uan_uang, "setting_desc_fuzzy_pinyin_option_uan_uang", R.string.modern_settings_fuzzy_uan_uang_description),
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun FuzzyPinyinDetailScreen(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
    onNavigateBack: () -> Unit,
) {
    require(snapshot.fuzzyPinyinOptions.size == fuzzyPinyinOptions.size)
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        legacyString(
                            "setting_fuzzy_pinyin_detail_title",
                            R.string.modern_settings_fuzzy_pinyin_detail_title,
                        )
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = stringResource(
                                R.string.modern_settings_navigate_back,
                            ),
                        )
                    }
                },
            )
        },
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyColumn(modifier = Modifier.padding(innerPadding)) {
            fuzzyPinyinOptions.forEachIndexed { index, option ->
                item(option.contract.key) {
                    SettingsSwitchRow(
                        title = legacyString(option.legacyTitle, option.fallbackTitle),
                        checked = snapshot.fuzzyPinyinOptions[index].value,
                        enabled = snapshot.fuzzyPinyin.value,
                        accessibilityDescription = legacyString(
                            option.legacyDescription,
                            option.fallbackDescription,
                        ),
                        onCheckedChange = {
                            actions.onBooleanChange(option.contract, it)
                        },
                    )
                }
            }
        }
    }
}

@Composable
private fun SettingsNavigationRow(
    title: String,
    enabled: Boolean,
    onClick: () -> Unit,
) {
    val color = if (enabled) MaterialTheme.colorScheme.onSurface
    else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
    ListItem(
        headlineContent = {
            Text(
                title,
                modifier = Modifier.padding(start = 8.dp),
                color = color,
            )
        },
        trailingContent = {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.KeyboardArrowRight,
                contentDescription = null,
                modifier = Modifier.padding(end = 8.dp),
                tint = color,
            )
        },
        modifier = Modifier.clickable(enabled = enabled, onClick = onClick),
    )
}

@Composable
private fun LongPressDelaySetting(
    title: String,
    state: DefaultableSetting<Int>,
    millisecondsText: (Int) -> String,
    onCommit: (Int) -> Unit,
    onRestoreDefault: () -> Unit,
) {
    val milliseconds = when (state) {
        is DefaultableSetting.Default -> state.value
        is DefaultableSetting.Explicit -> state.value
    }
    Column {
        DiscreteSettingsSlider(
            title = title,
            value = SliderSettingContracts.longPressProgress(milliseconds).toFloat(),
            valueText = millisecondsText(milliseconds),
            valueTextForIndex = { progress ->
                millisecondsText(SliderSettingContracts.longPressMilliseconds(progress))
            },
            maximumIndex = 60,
            editable = true,
            onValueCommit = { progress ->
                onCommit(SliderSettingContracts.longPressMilliseconds(progress))
            },
        )
        OutlinedButton(
            onClick = onRestoreDefault,
            enabled = state is DefaultableSetting.Explicit,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp),
        ) {
            Text(stringResource(R.string.modern_settings_use_default))
        }
    }
}

private fun handwritingTimeoutText(
    index: Int,
    labels: List<String>,
    millisecondsText: (Int) -> String,
): String = labels[index] + " · " + millisecondsText(
    SliderSettingContracts.handwritingTimeout.valueAt(index).toInt()
)

private fun handwritingStrokeWidthText(index: Int, labels: List<String>): String =
    labels[index] + " · " + SliderSettingContracts.handwritingStrokeWidth.valueAt(index)

@Composable
private fun legacyString(name: String, @StringRes fallback: Int): String {
    val context = LocalContext.current
    val id = context.resources.getIdentifier(name, "string", context.packageName)
    return if (id != 0) context.getString(id) else stringResource(fallback)
}

@Composable
private fun SectionTitle(title: String) {
    Text(
        text = title,
        modifier = Modifier.padding(horizontal = 24.dp, vertical = 8.dp),
        color = MaterialTheme.colorScheme.primary,
        fontWeight = FontWeight.Medium,
        style = MaterialTheme.typography.labelLarge,
    )
}

@Composable
private fun EnumeratedListSetting(
    title: String,
    selectedIndex: Int,
    selectedLabel: String,
    labels: List<String>,
    onSelect: (Int) -> Unit,
) {
    require(selectedIndex in labels.indices)
    var dialogVisible by rememberSaveable { mutableStateOf(false) }

    ListItem(
        headlineContent = {
            Text(title, modifier = Modifier.padding(start = 8.dp))
        },
        supportingContent = {
            Text(selectedLabel, modifier = Modifier.padding(start = 8.dp))
        },
        modifier = Modifier.clickable { dialogVisible = true },
    )

    if (dialogVisible) {
        AlertDialog(
            onDismissRequest = { dialogVisible = false },
            title = { Text(title) },
            text = {
                Column(
                    modifier = Modifier
                        .heightIn(max = 480.dp)
                        .verticalScroll(rememberScrollState())
                        .selectableGroup(),
                ) {
                    labels.forEachIndexed { index, label ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .selectable(
                                    selected = index == selectedIndex,
                                    onClick = {
                                        if (index != selectedIndex) onSelect(index)
                                        dialogVisible = false
                                    },
                                    role = Role.RadioButton,
                                )
                                .padding(horizontal = 8.dp, vertical = 12.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            RadioButton(
                                selected = index == selectedIndex,
                                onClick = null,
                            )
                            Text(
                                text = label,
                                modifier = Modifier.padding(start = 12.dp),
                            )
                        }
                    }
                }
            },
            confirmButton = {},
            dismissButton = {
                TextButton(onClick = { dialogVisible = false }) {
                    Text(stringResource(android.R.string.cancel))
                }
            },
        )
    }
}

@Composable
private fun SettingsSwitchRow(
    title: String,
    supporting: String? = null,
    checked: Boolean,
    enabled: Boolean = true,
    accessibilityDescription: String? = null,
    onCheckedChange: (Boolean) -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                title,
                color = if (enabled) MaterialTheme.colorScheme.onSurface
                else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                style = MaterialTheme.typography.bodyLarge,
            )
            supporting?.let {
                Text(
                    it,
                    color = if (enabled) MaterialTheme.colorScheme.onSurfaceVariant
                    else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
        Switch(
            checked = checked,
            enabled = enabled,
            onCheckedChange = onCheckedChange,
            modifier = if (accessibilityDescription == null) Modifier else {
                Modifier.semantics {
                    contentDescription = accessibilityDescription
                }
            },
        )
    }
}

@Composable
private fun DiscreteSettingsSlider(
    title: String,
    value: Float,
    valueText: String,
    valueTextForIndex: ((Int) -> String)? = null,
    maximumIndex: Int,
    dependencyEnabled: Boolean = true,
    editable: Boolean = false,
    onValueCommit: (Int) -> Unit = {},
) {
    var displayedValue by remember(value) { mutableFloatStateOf(value) }
    val interactionEnabled = editable && dependencyEnabled
    val displayedIndex = displayedValue.roundToInt().coerceIn(0, maximumIndex)
    val displayedValueText = valueTextForIndex?.invoke(displayedIndex) ?: valueText
    val semanticsText = stringResource(
        if (interactionEnabled) R.string.modern_settings_value_adjustable
        else R.string.modern_settings_value_read_only,
        title,
        displayedValueText,
    )
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 10.dp),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Text(
                title,
                color = if (dependencyEnabled) MaterialTheme.colorScheme.onSurface
                else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
                style = MaterialTheme.typography.bodyLarge,
            )
            Text(
                displayedValueText,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.labelLarge,
            )
        }
        Slider(
            value = displayedValue.coerceIn(0f, maximumIndex.toFloat()),
            onValueChange = { if (interactionEnabled) displayedValue = it },
            onValueChangeFinished = {
                if (interactionEnabled) onValueCommit(displayedValue.roundToInt())
            },
            valueRange = 0f..maximumIndex.toFloat(),
            steps = (maximumIndex - 1).coerceAtLeast(0),
            enabled = interactionEnabled,
            modifier = Modifier
                .fillMaxWidth()
                .windowInsetsPadding(WindowInsets.safeGestures.only(WindowInsetsSides.Horizontal))
                .semantics { contentDescription = semanticsText },
        )
    }
}
