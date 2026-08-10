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

internal fun androidx.compose.foundation.lazy.LazyListScope.keyboardSettingsItems(
    navigateTo: (SettingsRoute) -> Unit,
) {
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_keyboard_appearance_title),
                supporting = stringResource(R.string.modern_settings_keyboard_appearance_summary),
                onClick = { navigateTo(SettingsRoute.KeyboardAppearance) },
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_keyboard_keys_title),
                supporting = stringResource(R.string.modern_settings_keyboard_keys_summary),
                onClick = { navigateTo(SettingsRoute.KeyboardKeys) },
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_section_key_feedback),
                supporting = stringResource(R.string.modern_settings_keyboard_feedback_summary),
                onClick = { navigateTo(SettingsRoute.KeyboardFeedback) },
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_section_handwriting),
                supporting = stringResource(R.string.modern_settings_handwriting_summary),
                onClick = { navigateTo(SettingsRoute.Handwriting) },
            )
        }
}

internal fun androidx.compose.foundation.lazy.LazyListScope.keyboardAppearanceSettingsItems(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
) {
    item {
        SettingsSwitchRow(
            title = stringResource(R.string.modern_settings_system_auto_theme_title),
            supporting = stringResource(R.string.modern_settings_system_auto_theme_summary),
            checked = snapshot.systemAutoThemeEnabled,
            onCheckedChange = actions.onSystemAutoThemeEnabledChange,
        )
    }
    item {
        SettingsNavigationRow(
            title = legacyString(
                "setting_theme",
                R.string.modern_settings_theme_title,
            ),
            supporting = stringResource(R.string.modern_settings_manual_theme_summary),
            onClick = actions.onOpenThemeSelector,
        )
    }
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
}

internal fun androidx.compose.foundation.lazy.LazyListScope.keyboardKeysSettingsItems(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
    millisecondsText: (Int) -> String,
) {
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
    if (snapshot.capabilities.emojiSwitchKeyVisible) {
        item {
            SettingsSwitchRow(
                title = legacyString(
                    "setting_show_emoji_switch_key_title",
                    R.string.modern_settings_show_emoji_switch_key_title,
                ),
                supporting = legacyString(
                    "setting_show_emoji_switch_key_summary",
                    R.string.modern_settings_show_emoji_switch_key_summary,
                ),
                checked = snapshot.showEmojiSwitchKey.value,
                onCheckedChange = {
                    actions.onBooleanChange(
                        BooleanSettingContracts.showEmojiSwitchKey,
                        it,
                    )
                },
            )
        }
    }
    item {
        SettingsSwitchRow(
            title = legacyString(
                "setting_show_language_switch_key_title",
                R.string.modern_settings_show_language_switch_key_title,
            ),
            checked = snapshot.languageSwitchState.languageSwitchChecked,
            enabled = snapshot.languageSwitchState.languageSwitchEnabled,
            onCheckedChange = {
                actions.onBooleanChange(
                    BooleanSettingContracts.showLanguageSwitchKey,
                    it,
                )
            },
        )
    }
    if (snapshot.languageSwitchState.switchToOtherImesVisible) {
        item {
            SettingsSwitchRow(
                title = legacyString(
                    "setting_switch_to_other_imes_title",
                    R.string.modern_settings_switch_to_other_imes_title,
                ),
                supporting = legacyString(
                    "setting_switch_to_other_imes_summary",
                    R.string.modern_settings_switch_to_other_imes_summary,
                ),
                checked = snapshot.switchToOtherImes.value,
                enabled = snapshot.languageSwitchState.switchToOtherImesEnabled,
                onCheckedChange = {
                    actions.onBooleanChange(
                        BooleanSettingContracts.switchToOtherImes,
                        it,
                    )
                },
            )
        }
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
}

internal fun androidx.compose.foundation.lazy.LazyListScope.keyboardFeedbackSettingsItems(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
    percentText: (Int) -> String,
    millisecondsText: (Int) -> String,
) {
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
    if (snapshot.capabilities.vibrationControlsVisible) {
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
    }
}
