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

internal fun androidx.compose.foundation.lazy.LazyListScope.inputSettingsItems(snapshot: SettingsSnapshot, actions: SettingsActions, navigateTo: (SettingsRoute) -> Unit) {
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
            SettingsNavigationRow(
                title = legacyString(
                    "setting_chinese_input",
                    R.string.modern_settings_section_chinese_input,
                ),
                supporting = stringResource(R.string.modern_settings_chinese_input_summary),
                onClick = { navigateTo(SettingsRoute.ChineseInput) },
            )
        }
        item {
            SettingsNavigationRow(
                title = legacyString(
                    "setting_english_input",
                    R.string.modern_settings_section_english_input,
                ),
                supporting = stringResource(R.string.modern_settings_english_input_summary),
                onClick = { navigateTo(SettingsRoute.EnglishInput) },
            )
        }
}

internal fun androidx.compose.foundation.lazy.LazyListScope.chineseInputSettingsItems(snapshot: SettingsSnapshot, actions: SettingsActions, navigateTo: (SettingsRoute) -> Unit) {
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
            onClick = { navigateTo(SettingsRoute.FuzzyPinyin) },
        )
    }
}

internal fun androidx.compose.foundation.lazy.LazyListScope.englishInputSettingsItems(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
) {
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
}
