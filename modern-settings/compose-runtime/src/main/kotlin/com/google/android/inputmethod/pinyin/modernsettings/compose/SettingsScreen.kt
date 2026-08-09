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
    val onOpenThemeSelector: () -> Unit,
    val onOpenTerms: () -> Unit,
    val onOpenPrivacyPolicy: () -> Unit,
    val onOpenLicenses: () -> Unit,
    val onRefreshDictionaryHealth: () -> Unit,
    val onAutomaticBackupEnabledChange: (Boolean) -> Unit,
    val onChooseBackupLocation: () -> Unit,
    val onBackupIntervalChange: (Int) -> Unit,
    val onBackupRetentionChange: (Int) -> Unit,
    val onBackupNow: () -> Unit,
    val onImportBackup: () -> Unit,
    val onShortcutsEnabledChange: (Boolean) -> Unit,
    val onOpenShortcutEditor: () -> Unit,
    val onOpenLegacyDictionaryOperations: () -> Unit,
    val onLauncherIconVisibleChange: (Boolean) -> Unit,
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
fun SettingsScreen(
    snapshot: SettingsSnapshot,
    dictionarySnapshot: DictionarySettingsSnapshot,
    dictionaryHealth: DictionaryHealthState,
    actions: SettingsActions,
) {
    var routePath by rememberSaveable { mutableStateOf(SettingsRouteStack.initialPath) }
    val route = SettingsRouteStack.current(routePath)
    val navigateTo: (SettingsRoute) -> Unit = { destination ->
        routePath = SettingsRouteStack.push(routePath, destination)
    }
    val navigateBack: () -> Unit = {
        routePath = SettingsRouteStack.pop(routePath)
    }
    val canNavigateBack = SettingsRouteStack.canPop(routePath)

    BackHandler(enabled = canNavigateBack, onBack = navigateBack)
    if (route == SettingsRoute.FuzzyPinyin) {
        FuzzyPinyinDetailScreen(
            snapshot = snapshot,
            actions = actions,
            onNavigateBack = navigateBack,
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
    val title = routeTitle(route)
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(title) },
                navigationIcon = {
                    if (canNavigateBack) {
                        IconButton(onClick = navigateBack) {
                            Icon(
                                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                                contentDescription = stringResource(
                                    R.string.modern_settings_navigate_back,
                                ),
                            )
                        }
                    }
                },
            )
        },
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier.padding(innerPadding),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            when (route) {
                SettingsRoute.Home -> homeSettingsItems(navigateTo)
                SettingsRoute.Input -> inputSettingsItems(snapshot, actions, navigateTo)
                SettingsRoute.ChineseInput -> chineseInputSettingsItems(snapshot, actions, navigateTo)
                SettingsRoute.EnglishInput -> englishInputSettingsItems(snapshot, actions)
                SettingsRoute.Keyboard -> keyboardSettingsItems(navigateTo)
                SettingsRoute.KeyboardAppearance -> keyboardAppearanceSettingsItems(snapshot, actions)
                SettingsRoute.KeyboardKeys -> keyboardKeysSettingsItems(
                    snapshot, actions, millisecondsText,
                )
                SettingsRoute.KeyboardFeedback -> keyboardFeedbackSettingsItems(
                    snapshot, actions, percentText, millisecondsText,
                )
                SettingsRoute.Handwriting -> handwritingSettingsItems(
                    snapshot, actions, millisecondsText,
                )
                SettingsRoute.Dictionary -> dictionarySettingsItems(
                    dictionarySnapshot,
                    dictionaryHealth,
                    actions,
                )
                SettingsRoute.Other -> otherSettingsItems(snapshot, actions, navigateTo)
                SettingsRoute.About -> aboutSettingsItems(actions)
                SettingsRoute.FuzzyPinyin -> error("Fuzzy Pinyin uses its dedicated screen")
            }
        }
    }
}

@Composable
private fun routeTitle(route: SettingsRoute): String = when (route) {
    SettingsRoute.Home -> stringResource(R.string.modern_settings_title)
    SettingsRoute.Input -> stringResource(R.string.modern_settings_home_input_title)
    SettingsRoute.ChineseInput -> legacyString(
        "setting_chinese_input",
        R.string.modern_settings_section_chinese_input,
    )
    SettingsRoute.EnglishInput -> legacyString(
        "setting_english_input",
        R.string.modern_settings_section_english_input,
    )
    SettingsRoute.Keyboard -> stringResource(R.string.modern_settings_home_keyboard_title)
    SettingsRoute.KeyboardAppearance -> stringResource(
        R.string.modern_settings_keyboard_appearance_title,
    )
    SettingsRoute.KeyboardKeys -> stringResource(R.string.modern_settings_keyboard_keys_title)
    SettingsRoute.KeyboardFeedback -> stringResource(R.string.modern_settings_section_key_feedback)
    SettingsRoute.Handwriting -> stringResource(R.string.modern_settings_section_handwriting)
    SettingsRoute.Dictionary -> stringResource(R.string.modern_settings_home_dictionary_title)
    SettingsRoute.Other -> stringResource(R.string.modern_settings_home_other_title)
    SettingsRoute.About -> legacyString(
        "setting_about_title",
        R.string.modern_settings_about_title,
    )
    SettingsRoute.FuzzyPinyin -> legacyString(
        "setting_fuzzy_pinyin_detail_title",
        R.string.modern_settings_fuzzy_pinyin_detail_title,
    )
}
