#!/usr/bin/env python3
"""Verify the source-built Compose Material 3 host and optional decoded APK."""

from __future__ import annotations

import argparse
from pathlib import Path
from zipfile import ZIP_STORED, ZipFile


def require(text: str, fragments: tuple[str, ...], label: str) -> None:
    missing = [fragment for fragment in fragments if fragment not in text]
    if missing:
        raise RuntimeError(f"{label} is incomplete: {missing}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", type=Path, default=Path("modern-settings"))
    parser.add_argument("--decoded", type=Path)
    parser.add_argument("--apk", type=Path)
    args = parser.parse_args()

    project = args.project
    runtime_build = (project / "compose-runtime/build.gradle.kts").read_text(encoding="utf-8")
    require(
        runtime_build,
        (
            'id("org.jetbrains.kotlin.plugin.compose")',
            'androidx.compose:compose-bom:2026.06.01',
            'androidx.activity:activity-compose:1.13.0',
            'androidx.compose.material3:material3',
            'androidx.compose.material:material-icons-core',
            'androidx.compose.animation:animation',
            "minSdk = 23",
        ),
        "Compose runtime dependencies",
    )
    kotlin_root = project / "compose-runtime/src/main/kotlin"
    kotlin_files = tuple(kotlin_root.rglob("*.kt"))
    kotlin_text = "\n".join(path.read_text(encoding="utf-8") for path in kotlin_files)
    activity_text = next(
        kotlin_root.rglob("ModernSettingsActivity.kt")
    ).read_text(encoding="utf-8")
    require(
        activity_text,
        (
            "class ModernSettingsActivity : ComponentActivity()",
            "SettingsController(",
            "SettingsPreviewEffects(this)",
            "SettingsScreen(",
            "override fun onResume()",
            "snapshot = controller.read()",
            "LegacySettingsNavigation.themeSelectorIntent(this)",
            "setContent {",
            "CompositionLocalProvider(LocalLayoutDirection provides layoutDirection)",
            "context.resources.configuration.layoutDirection",
            "modernSettingsLayoutDirection(",
            "dictionaryImport = dictionaryImport",
            "openDictionaryImport()",
            "DictionaryImportStateReducer.select(",
            "dictionaryRepository::importBackup",
        ),
        "guarded Compose settings activity",
    )
    require(
        kotlin_text,
        (
            "import androidx.compose.material3.Slider",
            "import androidx.compose.material3.Switch",
            "import androidx.compose.material3.AlertDialog",
            "import androidx.compose.material3.ListItem",
            "import androidx.compose.material3.RadioButton",
            "import androidx.compose.material.icons.automirrored.filled.ArrowBack",
            "import androidx.activity.compose.BackHandler",
            "import androidx.compose.material3.TopAppBar",
            "data class SettingsActions(",
            "val onOpenThemeSelector: () -> Unit",
            "actions.onOpenThemeSelector",
            "val onRefreshDictionaryHealth: () -> Unit",
            "DictionaryHealthStatusCompat\\$Callback",
            "DictionaryHealthStateReducer.start(dictionaryHealth)",
            "DictionaryHealthStateReducer.complete(",
            'item(key = "dictionary_health", contentType = "status")',
            "DictionaryAutoBackupCompat\\$ValidationCallback",
            "takePersistableUriPermission(",
            "persistedUriPermissions.any",
            "DictionarySettingContracts.intervalValues",
            "DictionarySettingContracts.retentionValues",
            "dictionarySettingsItems(",
            "dictionaryHealth,",
            "DictionaryImportDialog(",
            "ListItemDefaults.colors(containerColor = Color.Transparent)",
            "DictionaryAutoBackupCompat\\$BackupListCallback",
            'getMethod("startNativeImport", Context::class.java, Uri::class.java)',
            "DictionaryImportStateReducer.open()",
            "AnimatedContent(",
            "SettingsRouteStack.direction(initialState, targetState)",
            "slideInHorizontally(tween(300))",
            "slideOutHorizontally(tween(220))",
            ".background(MaterialTheme.colorScheme.surface)",
            ".clipToBounds()",
            "actions.onShortcutsEnabledChange",
            "actions.onOpenLegacyDictionaryOperations",
            '"PREFERENCE_FRAGMENT",',
            '"setting_dictionary",',
            "SettingsRoute.About",
            "LegacySettingsNavigation.legacyWebIntent",
            "LegacySettingsNavigation.licensesIntent",
            "val onLauncherIconVisibleChange: (Boolean) -> Unit",
            "actions.onLauncherIconVisibleChange",
            "snapshot.launcherIcon.value",
            "fun SettingsScreen(",
            "fun DefaultAwareAdjustment(",
            "data class AdjustmentInteractionState(",
            "AdjustmentStateReducer.update(",
            "AdjustmentStateReducer.commit(",
            "AdjustmentStateReducer.restoreDefault(",
            "AdjustmentStateReducer.canRestoreDefault(",
            "displayedValue = 0",
            "onValueChangeFinished = ::commitTouchedValue",
            "rememberSaveable(title, resolvedKey, stateSaver = adjustmentStateSaver)",
            "previewEffects.previewVolume(percent)",
            "previewEffects.previewVibration(milliseconds)",
            "snapshot.keyboardHeightLabels::get",
            "snapshot.slideSensitivityLabels::get",
            "actions.onBooleanChange",
            "BooleanSettingContracts.doubleSpacePeriod",
            "BooleanSettingContracts.scrubMove",
            "BooleanSettingContracts.showEnglishKeyboard",
            "BooleanSettingContracts.emojiAltPhysicalKey",
            "BooleanSettingContracts.chineseEnglishMixedInput",
            "BooleanSettingContracts.chineseDigitsMixedInput",
            "BooleanSettingContracts.suggestEmojis",
            "BooleanSettingContracts.spatialCorrection",
            "BooleanSettingContracts.traditionalChinese",
            "BooleanSettingContracts.chinesePrediction",
            "BooleanSettingContracts.automaticSpace",
            "BooleanSettingContracts.blockOffensiveWords",
            "BooleanSettingContracts.latinAutoCorrection",
            "BooleanSettingContracts.latinShowSuggestions",
            "BooleanSettingContracts.nextWordPrediction",
            "BooleanSettingContracts.autoCapitalization",
            "actions.onOneHandedModeChange",
            "snapshot.oneHandedModeLabels",
            "snapshot.capabilities.popupOnKeypressVisible",
            "snapshot.capabilities.voiceInputVisible",
            "snapshot.capabilities.vibrationControlsVisible",
            "snapshot.capabilities.oneHandedModeVisible",
            "BooleanSettingContracts.popupOnKeypress",
            "BooleanSettingContracts.voiceInput",
            "BooleanSettingContracts.showEmojiSwitchKey",
            "BooleanSettingContracts.showLanguageSwitchKey",
            "BooleanSettingContracts.switchToOtherImes",
            "snapshot.capabilities.emojiSwitchKeyVisible",
            "snapshot.languageSwitchState.languageSwitchChecked",
            "snapshot.languageSwitchState.switchToOtherImesVisible",
            "snapshot.languageSwitchState.switchToOtherImesEnabled",
            "actions.onPinyinSchemeChange",
            "snapshot.pinyinSchemeLabels",
            "BooleanSettingContracts.fuzzyPinyin",
            "BooleanSettingContracts.fuzzyPinyinOptionBatch",
            "FuzzyPinyinDetailScreen(",
            "SettingsNavigationRow(",
            "accessibilityDescription = legacyString(",
            "actions.onGestureInputEnabledChange",
            "BooleanSettingContracts.incrementalGesturePreview",
            "BooleanSettingContracts.gestureAutoCommit",
            "enabled = dependencyEnabled",
            "actions.onLongPressDelayChange",
            "actions.onLongPressDefault",
            "LongPressDelaySetting(",
            "actions.onHandwritingTimeoutChange",
            "actions.onHandwritingStrokeWidthChange",
            "snapshot.handwritingTimeoutLabels",
            "snapshot.handwritingStrokeWidthLabels",
            "WindowInsets.safeGestures.only(WindowInsetsSides.Horizontal)",
            "interaction.displayedValue.toFloat()",
            "stringResource(R.string.modern_settings_system_default)",
            "stringResource(R.string.modern_settings_use_system_default)",
        ),
        "official Compose Material 3 settings modules",
    )
    for forbidden in ("android.widget.SeekBar", "onDraw(", "Md3SliderView"):
        if forbidden in kotlin_text:
            raise RuntimeError(f"modern settings must not simulate Slider: {forbidden}")
    adjustment_controls = next(
        kotlin_root.rglob("AdjustmentControls.kt")
    ).read_text(encoding="utf-8")
    for obsolete_flow in (
        "SystemDefaultAdjustment(",
        "modern_settings_set_custom",
        "modern_settings_choose_custom_unsaved",
        "modern_settings_cancel",
        "modern_settings_apply",
    ):
        if obsolete_flow in adjustment_controls:
            raise RuntimeError(
                f"key-feedback adjustment must commit directly on release: {obsolete_flow}"
            )
    if any("\u4e00" <= character <= "\u9fff" for character in kotlin_text):
        raise RuntimeError("modern settings Kotlin must not hard-code Chinese UI text")

    values = (project / "compose-runtime/src/main/res/values/strings.xml").read_text(
        encoding="utf-8"
    )
    values_zh = (project / "compose-runtime/src/main/res/values-zh/strings.xml").read_text(
        encoding="utf-8"
    )
    for localized_text, label in ((values, "English"), (values_zh, "Simplified Chinese")):
        require(
            localized_text,
            (
                'name="modern_settings_set_custom"',
                'name="modern_settings_choose_custom_unsaved"',
                'name="modern_settings_use_system_default"',
                'name="modern_settings_use_default"',
                'name="modern_settings_section_input"',
                'name="modern_settings_section_chinese_input"',
                'name="modern_settings_section_english_input"',
                'name="modern_settings_pinyin_scheme_title"',
                'name="modern_settings_one_handed_mode_title"',
                'name="modern_settings_theme_title"',
                'name="modern_settings_launcher_icon_title"',
                'name="modern_settings_launcher_icon_summary"',
                'name="modern_settings_dictionary_health_title"',
                'name="modern_settings_dictionary_backup_section"',
                'name="modern_settings_dictionary_location_title"',
                'name="modern_settings_dictionary_import_title"',
                'name="modern_settings_dictionary_enable_shortcuts"',
                'name="modern_settings_dictionary_legacy_operations_title"',
                'name="modern_settings_about_title"',
                'name="modern_settings_terms_title"',
                'name="modern_settings_privacy_title"',
                'name="modern_settings_licenses_title"',
                'name="modern_settings_version_title"',
                'name="modern_settings_popup_on_keypress_title"',
                'name="modern_settings_voice_input_title"',
                'name="modern_settings_fuzzy_pinyin_title"',
                'name="modern_settings_fuzzy_pinyin_detail_title"',
                'name="modern_settings_navigate_back"',
                'name="modern_settings_fuzzy_z_zh_description"',
                'name="modern_settings_fuzzy_uan_uang_description"',
                'name="modern_settings_double_space_title"',
                'name="modern_settings_scrub_move_title"',
                'name="modern_settings_show_english_keyboard_title"',
                'name="modern_settings_show_emoji_switch_key_title"',
                'name="modern_settings_show_emoji_switch_key_summary"',
                'name="modern_settings_show_language_switch_key_title"',
                'name="modern_settings_switch_to_other_imes_title"',
                'name="modern_settings_switch_to_other_imes_summary"',
                'name="modern_settings_physical_alt_title"',
                'name="modern_settings_chinese_english_title"',
                'name="modern_settings_chinese_digits_title"',
                'name="modern_settings_suggest_emojis_title"',
                'name="modern_settings_spatial_correction_title"',
                'name="modern_settings_traditional_chinese_title"',
                'name="modern_settings_chinese_prediction_title"',
                'name="modern_settings_automatic_space_title"',
                'name="modern_settings_block_offensive_words_title"',
                'name="modern_settings_latin_auto_correction_title"',
                'name="modern_settings_latin_show_suggestions_title"',
                'name="modern_settings_next_word_prediction_title"',
                'name="modern_settings_requires_show_suggestions"',
                'name="modern_settings_auto_capitalization_title"',
                'name="modern_settings_gesture_input_title"',
                'name="modern_settings_gesture_preview_title"',
                'name="modern_settings_gesture_auto_commit_title"',
                'name="modern_settings_requires_gesture_input"',
                'name="modern_settings_value_adjustable"',
            ),
            f"{label} modern settings resources",
        )

    contracts = next((project / "compose-runtime/src/main/kotlin").rglob("SliderSettingContracts.kt"))
    contract_text = contracts.read_text(encoding="utf-8")
    require(
        contract_text,
        (
            'SOUND_VOLUME_KEY = "sound_volume"',
            'VIBRATION_DURATION_KEY = "vibration_duration"',
            "ResolvedSetting.SystemDefault",
            "if (encoded == 0) 0 else encoded - 1",
            'values = listOf("0.9", "0.95", "1.0", "1.05", "1.1")',
            'values = listOf("3000", "2000", "1500", "1000", "700", "400", "100")',
            "progress * 10 + 100",
            "fun encodeVolumePercent(percent: Int)",
            "percent / 100f",
            "sealed interface DefaultableSetting",
            "fun resolveLongPress(",
            "fun encodeLongPress(milliseconds: Int)",
        ),
        "audited Slider persistence contracts",
    )

    list_contracts = next(
        (project / "compose-runtime/src/main/kotlin").rglob("ListSettingContracts.kt")
    ).read_text(encoding="utf-8")
    require(
        list_contracts,
        (
            'key = "one_handed_mode"',
            'defaultValue = "0"',
            'values = listOf("0", "1", "2")',
            'key = "pinyin_scheme"',
            'defaultValue = "quanpin"',
            '"shuangpin_ms"',
            '"shuangpin_ziguang"',
            '"shuangpin_jiajia"',
            '"shuangpin_abc"',
            '"shuangpin_ziranma"',
            '"shuangpin_flypy"',
        ),
        "audited ListPreference persistence contracts",
    )
    list_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("ListSettingContractsTest.kt")
    ).read_text(encoding="utf-8")
    require(
        list_test,
        (
            "oneHandedModePreservesExactLegacyKeyDefaultAndOrder",
            "pinyinSchemePreservesExactLegacyKeyDefaultAndOrder",
            "absentValueUsesFullPinyinDefault",
            "unsupportedValueAndIndexAreRejected",
        ),
        "ListPreference contract tests",
    )

    capabilities = next(
        (project / "compose-runtime/src/main/kotlin").rglob("SettingsCapabilities.kt")
    ).read_text(encoding="utf-8")
    require(
        capabilities,
        (
            "popupOnKeypressVisible = !isTablet",
            "vibrationControlsVisible = vibrationControlsVisible(",
            "context.getSystemService(Vibrator::class.java)",
            "serviceIsVibrator = vibratorService != null",
            "hasVibrator = vibratorService?.hasVibrator() == true",
            "serviceIsVibrator && hasVibrator",
            "oneHandedModeVisible = !isTablet",
            "emojiSwitchKeyVisible = Build.VERSION.SDK_INT >= 19 && !isTablet",
            "inputMethodSwitchingAvailable = hasSettingsActivitySwitchTarget(",
            "manager.enabledInputMethodList.map",
            'inputMethod.packageName.startsWith("com.google.android")',
            'inputMethod.subtypeModes.any { it == "voice" }',
            "getEnabledInputMethodSubtypeList(",
            "catch (_: Exception)",
        ),
        "audited keyboard capability predicates",
    )
    capability_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("SettingsCapabilitiesTest.kt")
    ).read_text(encoding="utf-8")
    require(
        capability_test,
        (
            "vibrationControlsRequireVibratorServiceWithHardware",
            "enabledGoogleVoiceSubtypeIsAvailable",
            "packagePrefixModeAndEnabledListMustMatchExactly",
            "emptyEnabledInputMethodListIsUnavailable",
            "ownImeWithMultipleEnabledSubtypesOffersSwitching",
            "otherGoogleImeRequiresANonAuxiliaryEnabledSubtype",
            "nonGoogleOtherImeDoesNotSatisfyLegacyFallback",
        ),
        "keyboard capability predicate tests",
    )

    launcher_rules = next(
        (project / "compose-runtime/src/main/kotlin").rglob("LauncherIconSettingRules.kt")
    ).read_text(encoding="utf-8")
    require(
        launcher_rules,
        ("!isSystemOrUpdatedSystemApp && resourceDefault",),
        "launcher icon absent-key default",
    )
    launcher_rules_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("LauncherIconSettingRulesTest.kt")
    ).read_text(encoding="utf-8")
    require(
        launcher_rules_test,
        (
            "sideloadedAppUsesResourceDefault",
            "systemAndUpdatedSystemAppsDefaultToHidden",
        ),
        "launcher icon default tests",
    )

    language_switch_rules = next(
        (project / "compose-runtime/src/main/kotlin").rglob("LanguageSwitchSettingRules.kt")
    ).read_text(encoding="utf-8")
    require(
        language_switch_rules,
        (
            "(!emojiSwitchKeyVisible || !emojiSwitchKeyChecked)",
            "(inputMethodSwitchingAvailable || showEnglishKeyboard)",
            "languageSwitchChecked = languageSwitchEnabled && persistedLanguageSwitchKey",
            "switchToOtherImesVisible = inputMethodSwitchingAvailable",
            "inputMethodSwitchingAvailable &&",
            "showEnglishKeyboard && languageSwitchChecked",
        ),
        "language and emoji switch dependency rules",
    )
    language_switch_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob(
            "LanguageSwitchSettingRulesTest.kt"
        )
    ).read_text(encoding="utf-8")
    require(
        language_switch_test,
        (
            "emojiKeyTemporarilyUnchecksLanguageKeyWithoutChangingPersistedInput",
            "disablingEmojiRestoresPersistedLanguageKey",
            "switchToOtherImesRequiresEnglishAndEffectiveLanguageKeys",
            "noSwitchTargetRemovesChildAndMakesLanguageDependOnEnglish",
        ),
        "language and emoji switch dependency tests",
    )

    boolean_contracts = next(
        (project / "compose-runtime/src/main/kotlin").rglob("BooleanSettingContracts.kt")
    ).read_text(encoding="utf-8")
    require(
        boolean_contracts,
        (
            'key = "enable_double_space_period"',
            'key = "enable_scrub_move"',
            'key = "show_english_keyboard"',
            'key = "enable_emoji_alt_physical_key"',
            'key = "chinese_english_mixed_input"',
            'key = "chinese_digits_mixed_input"',
            'key = "enable_suggest_emojis"',
            'key = "enable_spatial_model"',
            'key = "enable_sc_tc_conversion"',
            'key = "enable_chinese_prediction"',
            'key = "auto_space"',
            'key = "block_offensive_words"',
            'key = "enable_popup_on_keypress"',
            'key = "enable_voice_input"',
            'key = "show_emoji_switch_key"',
            'key = "show_language_switch_key"',
            'key = "switch_to_other_imes"',
            'key = "pref_key_auto_correction"',
            'key = "show_suggestions"',
            'key = "next_word_prediction"',
            'dependency = latinShowSuggestions',
            'key = "enable_auto_capitalization"',
            'key = "enable_gesture_input"',
            'key = "enable_gesture_input_persistent"',
            'key = "enable_incremental_gesture_input"',
            'key = "enable_gesture_auto_commit"',
            'dependency = gestureInput',
            'key = "fuzzy_pinyin"',
            'fuzzyOption("fuzzy_pinyin_z_zh", true)',
            'fuzzyOption("fuzzy_pinyin_c_ch", true)',
            'fuzzyOption("fuzzy_pinyin_s_sh", true)',
            'fuzzyOption("fuzzy_pinyin_an_ang", true)',
            'fuzzyOption("fuzzy_pinyin_en_eng", true)',
            'fuzzyOption("fuzzy_pinyin_in_ing", true)',
            'fuzzyOption("fuzzy_pinyin_l_n", false)',
            'fuzzyOption("fuzzy_pinyin_f_h", false)',
            'fuzzyOption("fuzzy_pinyin_r_l", false)',
            'fuzzyOption("fuzzy_pinyin_k_g", false)',
            'fuzzyOption("fuzzy_pinyin_ian_iang", false)',
            'fuzzyOption("fuzzy_pinyin_uan_uang", false)',
            'dependency = fuzzyPinyin',
            "defaultValue = false",
            "defaultValue = true",
            "val firstPlainBatch = listOf(",
            "val secondPlainBatch = listOf(",
            "val thirdPlainBatch = listOf(",
            "val capabilityGatedKeyboardBatch = listOf(",
            "val languageSwitchDependencyBatch = listOf(",
            "val englishDependencyBatch = listOf(",
            "val gestureDependencyBatch = listOf(",
            "capabilityGatedKeyboardBatch + languageSwitchDependencyBatch +",
        ),
        "audited Boolean persistence contracts",
    )
    boolean_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("BooleanSettingContractsTest.kt")
    ).read_text(encoding="utf-8")
    require(
        boolean_test,
        (
            "firstPlainBatchPreservesExactLegacyKeysAndDefaults",
            "secondPlainBatchPreservesExactLegacyKeysAndDefaults",
            "thirdPlainBatchPreservesExactLegacyKeysAndDefaults",
            "capabilityGatedKeyboardBatchPreservesExactKeysAndDefaults",
            "languageSwitchGroupPreservesExactKeysAndDefaults",
            "englishDependencyBatchPreservesExactKeysDefaultsAndDependency",
            "gestureGroupPreservesMirroredKeyDefaultsAndDependencies",
            "fuzzyPinyinGroupPreservesKeysOrderDefaultsAndDependency",
            "writableSettingsHaveNoDuplicateKeys",
        ),
        "Boolean contract tests",
    )

    require(
        kotlin_text,
        (
            "sealed interface AdjustmentEditorState",
            "data object SystemDefault",
            "data class Explicit(val value: Int)",
            "data class AdjustmentInteractionState(",
            "val displayedValue: Int",
            "touched = true",
            "require(state.touched)",
            "state.touched || state.persisted is AdjustmentEditorState.Explicit",
            "fun isInteractive(dependencyEnabled: Boolean): Boolean = dependencyEnabled",
        ),
        "pure adjustment state reducer",
    )
    navigation = next(
        (project / "compose-runtime/src/main/kotlin").rglob("SettingsNavigation.kt")
    ).read_text(encoding="utf-8")
    require(
        navigation,
        (
            "internal enum class SettingsRoute",
            "KeyboardAppearance",
            "KeyboardKeys",
            "KeyboardFeedback",
            "Handwriting",
            "object SettingsRouteStack",
            "fun decode(path: String)",
            "fun push(path: String, destination: SettingsRoute)",
            "fun pop(path: String)",
            "fun direction(initialPath: String, targetPath: String)",
            "SettingsNavigationDirection.Forward",
            "SettingsNavigationDirection.Backward",
            "require(destination != SettingsRoute.Home)",
        ),
        "saveable settings route stack",
    )
    settings_source_dir = project / "compose-runtime/src/main/kotlin/com/google/android/inputmethod/pinyin/modernsettings/compose"
    split_sources = {
        name: (settings_source_dir / name).read_text(encoding="utf-8")
        for name in (
            "SettingsScreen.kt",
            "SettingsHomeScreen.kt",
            "InputSettingsScreens.kt",
            "KeyboardSettingsScreens.kt",
            "HandwritingSettingsScreen.kt",
            "FuzzyPinyinSettingsScreen.kt",
            "SettingsComponents.kt",
        )
    }
    require(
        split_sources["SettingsScreen.kt"],
        (
            "when (route)",
            "homeSettingsItems(navigateTo)",
            "chineseInputSettingsItems(snapshot, actions, navigateTo)",
            "keyboardKeysSettingsItems(",
            "handwritingSettingsItems(",
        ),
        "settings route dispatcher",
    )
    if "SettingsSwitchRow(" in split_sources["SettingsScreen.kt"]:
        raise RuntimeError("top-level SettingsScreen must not own page controls")
    require(
        split_sources["SettingsComponents.kt"],
        (
            "fun SettingsNavigationRow(",
            "fun SettingsSwitchRow(",
            ".toggleable(",
            "role = Role.Switch",
            ".semantics(mergeDescendants = true)",
            "onCheckedChange = null",
            "fun EnumeratedListSetting(",
            "fun DiscreteSettingsSlider(",
        ),
        "shared settings components",
    )

    dictionary_bridge = (
        project.parent
        / "patches/java/com/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat.java"
    ).read_text(encoding="utf-8")
    import_bridge = (
        project.parent
        / "patches/java/com/google/android/inputmethod/pinyin/LocalBackupImportActivity.java"
    ).read_text(encoding="utf-8")
    require(
        dictionary_bridge + "\n" + import_bridge,
        (
            "public interface BackupListCallback",
            "public static final class BackupEntry",
            "public String getName()",
            "public Uri getUri()",
            "public static void listBackupsAsync(",
            "public static boolean startNativeImport(Context source, Uri uri)",
        ),
        "primary-DEX modern dictionary import bridge",
    )

    legacy_navigation = (settings_source_dir / "LegacySettingsNavigation.kt").read_text(
        encoding="utf-8"
    )
    require(
        legacy_navigation,
        (
            '"com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"',
            "Intent().setClassName(context, themeSelectorActivity)",
        ),
        "legacy specialized settings navigation",
    )

    navigation_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("SettingsNavigationTest.kt")
    ).read_text(encoding="utf-8")
    require(
        navigation_test,
        (
            "initialPathIsHomeAndCannotPop",
            "nestedRoutePushAndPopPreserveHierarchy",
            "routeDepthDeterminesTransitionDirection",
            "homeCannotBePushedAsAChild",
            "invalidRestoredPathFallsBackToHome",
        ),
        "settings navigation tests",
    )

    adjustment_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("AdjustmentStateTest.kt")
    ).read_text(encoding="utf-8")
    require(
        adjustment_test,
        (
            "systemDefaultUsesLeftmostDisplayWithoutBecomingExplicitZero",
            "touchingLeftmostPositionCanCommitExplicitZero",
            "dragUpdatesTransientValueAndReleaseCommitsIt",
            "restoreDeletesCustomIdentityAndReturnsDisplayToLeftmost",
            "dependencyOnlyControlsInteractivityWithoutChangingState",
        ),
        "adjustment reducer tests",
    )

    repository = next((project / "compose-runtime/src/main/kotlin").rglob("LegacySettingsRepository.kt"))
    repository_text = repository.read_text(encoding="utf-8")
    require(
        repository_text,
        (
            '"${applicationContext.packageName}_preferences"',
            "preferences.contains(SliderSettingContracts.SOUND_VOLUME_KEY)",
            "preferences.contains(SliderSettingContracts.VIBRATION_DURATION_KEY)",
            '"pref_def_value_sound_volume_on_keypress"',
            '"pref_def_value_per_device_vibration_duration_on_keypress"',
            '"HARDWARE" to Build.HARDWARE',
            '"entries_pinyin_scheme"',
            '"entries_keyboard_height_ratio"',
            '"entries_keyboard_slide_sensitivity_ratio"',
            "keyboardHeightLabels: List<String>",
            "slideSensitivityLabels: List<String>",
            "handwritingTimeoutLabels: List<String>",
            "handwritingStrokeWidthLabels: List<String>",
            "fuzzyPinyin: BooleanSettingState",
            "fuzzyPinyinOptions: List<BooleanSettingState>",
            "capabilities: SettingsCapabilities",
            "launcherIcon: BooleanSettingState",
            "fun setLauncherIconVisible(visible: Boolean)",
            'LAUNCHER_ICON_KEY = "show_launcher_icon"',
            "ApplicationInfo.FLAG_SYSTEM or ApplicationInfo.FLAG_UPDATED_SYSTEM_APP",
            "LauncherIconSettingRules.defaultVisible(",
            "popupOnKeypress: BooleanSettingState",
            "voiceInput: BooleanSettingState",
            "showEmojiSwitchKey: BooleanSettingState",
            "showLanguageSwitchKey: BooleanSettingState",
            "switchToOtherImes: BooleanSettingState",
            "languageSwitchState: LanguageSwitchSettingState",
            "oneHandedModeLabels: List<String>",
            "fun readSnapshot()",
            "data class SettingsSnapshot(",
            "fun setSoundEnabled(enabled: Boolean)",
            "fun setVibrationEnabled(enabled: Boolean)",
            "requireVibrationControlsAvailable()",
            "require(SettingsCapabilityResolver.resolve(applicationContext).vibrationControlsVisible)",
            "fun setOneHandedModeIndex(index: Int)",
            'require(SettingsCapabilityResolver.resolve(applicationContext).oneHandedModeVisible)',
            "fun setPinyinSchemeIndex(index: Int)",
            "preferences.edit().putString(contract.key, contract.valueAt(index)).apply()",
            "fun setGestureInputEnabled(enabled: Boolean)",
            ".putBoolean(BooleanSettingContracts.gestureInput.key, enabled)",
            ".putBoolean(BooleanSettingContracts.gestureInputPersistent.key, enabled)",
            "fun setBoolean(",
            "require(contract in BooleanSettingContracts.writable)",
            "require(capabilities.popupOnKeypressVisible)",
            "require(capabilities.voiceInputVisible)",
            "require(capabilities.emojiSwitchKeyVisible)",
            "currentLanguageSwitchState(capabilities)",
            "require(state.languageSwitchEnabled)",
            "require(state.switchToOtherImesVisible)",
            "require(state.switchToOtherImesEnabled)",
            "contract.dependency?.let { dependency ->",
            '"Boolean dependency is disabled: ${dependency.key}"',
            "isExplicit = preferences.contains(contract.key)",
            "fun setVolumePercent(percent: Int)",
            "fun restoreVolumeDefault()",
            "fun setVibrationDuration(milliseconds: Int)",
            "fun restoreVibrationDefault()",
            "fun setKeyboardHeightIndex(index: Int)",
            "fun setSlideSensitivityIndex(index: Int)",
            "fun setLongPressDelay(milliseconds: Int)",
            "fun restoreLongPressDefault()",
            "fun setHandwritingTimeoutIndex(index: Int)",
            "fun setHandwritingStrokeWidthIndex(index: Int)",
            "preferences.edit().putString(contract.key, contract.valueAt(index)).apply()",
        ),
        "staged legacy settings repository",
    )
    expected_write_counts = {
        "putBoolean(": 6,
        "putFloat(": 1,
        "putString(": 5,
        ".remove(": 3,
    }
    for operation, expected_count in expected_write_counts.items():
        actual_count = repository_text.count(operation)
        if actual_count != expected_count:
            raise RuntimeError(
                f"audited settings write count changed for {operation}: "
                f"expected {expected_count}, found {actual_count}"
            )
    for forbidden_write in ("putInt(", ".clear("):
        if forbidden_write in repository_text:
            raise RuntimeError(f"unaudited settings write path: {forbidden_write}")

    host_builder = Path("scripts/build_modern_settings_host.py").read_text(encoding="utf-8")
    require(
        host_builder,
        (
            'formal_application_id = "com.google.android.inputmethod.pinyin.compat"',
            'if args.debuggable and args.application_id == formal_application_id:',
            'raise RuntimeError("Debug mode is forbidden for the formal application ID")',
            'if args.launcher_label and args.application_id == formal_application_id:',
            'raise RuntimeError("A custom launcher label is forbidden for the formal application ID")',
            'if args.ime_label and args.application_id == formal_application_id:',
            'raise RuntimeError("A custom IME label is forbidden for the formal application ID")',
            'manifest_command.extend(("--launcher-label", args.launcher_label))',
            'manifest_command.extend(("--ime-label", args.ime_label))',
            'variant = "debug" if args.debuggable else "release"',
            'gradle_task = "assembleDebug" if args.debuggable else "assembleRelease"',
            'reconstructed-host-prototype-release-unsigned.apk',
            '*(["--debuggable"] if args.debuggable else [])',
        ),
        "release-like modern host builder",
    )

    gradle_properties = (project / "gradle.properties").read_text(encoding="utf-8")
    require(
        gradle_properties,
        ("android.enableResourceOptimizations=false",),
        "embedded legacy resource retention",
    )

    host_build = (project / "reconstructed-host-prototype/build.gradle.kts").read_text(
        encoding="utf-8"
    )
    require(
        host_build,
        (
            "minSdk = 17",
            "targetSdk = 36",
            "multiDexEnabled = true",
            'implementation(project(\":compose-runtime\"))',
            '"--stable-ids"',
            'androidResources.noCompress += "json"',
            "checkReleaseBuilds = false",
        ),
        "reconstructed host build",
    )
    patch_script = Path("scripts/apply_patches.py").read_text(encoding="utf-8")
    require(
        patch_script,
        (
            "ThemeSettingsInsetsCompat;->attachSelector(Landroid/app/Activity;)V",
            '"ThemeSettingsInsetsCompat.smali"',
            '"ThemeSettingsInsetsCompat$SystemBarsListener.smali"',
        ),
        "legacy theme selector system-bar integration",
    )
    theme_insets = Path("patches/smali/ThemeSettingsInsetsCompat$SystemBarsListener.smali").read_text(
        encoding="utf-8"
    )
    require(
        theme_insets,
        (
            "WindowInsets$Type;->systemBars()I",
            "WindowInsets;->getInsets(I)Landroid/graphics/Insets;",
            "getSystemWindowInsetTop()I",
            "getSystemWindowInsetBottom()I",
            "View;->setPadding(IIII)V",
        ),
        "dynamic theme selector system-bar Insets",
    )

    manifest_prep = Path("scripts/prepare_compose_host_manifest.py").read_text(encoding="utf-8")
    require(
        manifest_prep,
        (
            "androidx.startup.InitializationProvider",
            "androidx.profileinstaller.ProfileInstallReceiver",
            'application.set(T + "remove", "android:appComponentFactory")',
            'activity.set(A + "enabled", "@bool/modern_settings_runtime_enabled")',
            'values_v35 / "modern_settings_runtime.xml"',
            'uses_sdk.set(T + "overrideLibrary"',
            '"androidx.compose.material.icons"',
            'queries = root.find("queries")',
            'action.set(A + "name", "android.view.InputMethod")',
            'activity.set(A + "exported", "true" if args.audit_launcher else "false")',
            'if args.launcher_label and args.package_name == FORMAL_APPLICATION_ID:',
            'legacy_launchers[0].set(A + "label", args.launcher_label)',
            'if args.ime_label and args.package_name == FORMAL_APPLICATION_ID:',
            'ime_services[0].set(A + "label", args.ime_label)',
            "broad QUERY_ALL_PACKAGES permission",
        ),
        "guarded legacy manifest",
    )
    require(
        patch_script,
        (
            'const-string v1, \\"app_icon\\"',
            'PinyinFirstRunActivity;->b(Landroid/content/Context;)Z',
            'const/16 v1, 0x23',
            'const-string v1, \\"modern_settings_use_legacy\\"',
            'modernsettings.compose.ModernSettingsActivity',
            '->setClassName(',
            'preference/SettingsActivity;->finish()V',
        ),
        "API-35 modern settings route",
    )
    require(
        kotlin_text,
        ('"modern_settings_use_legacy"',),
        "legacy dictionary route bypass",
    )

    if args.apk is not None:
        with ZipFile(args.apk) as archive:
            for entry in (
                "res/raw/main_en_d3_20160715.gzip",
                "res/raw/metadata.json",
            ):
                if entry not in archive.namelist():
                    raise RuntimeError(f"missing English runtime payload: {entry}")
                if archive.getinfo(entry).compress_type != ZIP_STORED:
                    raise RuntimeError(
                        f"English runtime payload must be uncompressed: {entry}"
                    )

    if args.decoded is not None:
        decoded = args.decoded
        manifest_text = (decoded / "AndroidManifest.xml").read_text(encoding="utf-8")
        require(
            manifest_text,
            (
                "com.google.android.apps.inputmethod.pinyin.PinyinApp",
                "com.google.android.inputmethod.pinyin.PinyinIME",
                "ModernSettingsActivity",
                "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity",
                "com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity",
                'android:enabled="@bool/modern_settings_runtime_enabled"',
                '<queries>',
                'android:name="android.view.InputMethod"',
            ),
            "combined host manifest",
        )
        values_text = "\n".join(
            path.read_text(encoding="utf-8")
            for path in decoded.glob("res/values*/**/*.xml")
        )
        require(
            values_text,
            (
                '<bool name="modern_settings_runtime_enabled">false</bool>',
                '<bool name="modern_settings_runtime_enabled">true</bool>',
            ),
            "API-35 modern activity gate",
        )
        apktool_yml = (decoded / "apktool.yml").read_text(encoding="utf-8")
        require(
            apktool_yml,
            ("minSdkVersion: 17", "targetSdkVersion: 36"),
            "combined host SDK contract",
        )
        for forbidden in (
            "androidx.startup.InitializationProvider",
            "androidx.profileinstaller.ProfileInstallReceiver",
            "android:appComponentFactory=",
            "android.permission.QUERY_ALL_PACKAGES",
        ):
            if forbidden in manifest_text:
                raise RuntimeError(f"unguarded AndroidX process entry point: {forbidden}")

        app_base = decoded / (
            "smali/com/google/android/apps/inputmethod/libs/framework/core/AppBase.smali"
        )
        require(
            app_base.read_text(encoding="utf-8"),
            (
                "const v1, 0x7f110299",
                "LauncherIconVisibilityInitializer;->a(Landroid/content/Context;)V",
            ),
            "launcher icon SharedPreferences side effect",
        )
        launcher_initializer = decoded / (
            "smali/com/google/android/apps/inputmethod/libs/framework/core/"
            "LauncherIconVisibilityInitializer.smali"
        )
        require(
            launcher_initializer.read_text(encoding="utf-8"),
            (
                "LauncherActivity;",
                "LauncherIconVisibilityInitializer;->b(Landroid/content/Context;)V",
            ),
            "launcher component visibility initializer",
        )

        theme_selector = decoded / (
            "smali/com/google/android/apps/inputmethod/libs/theme/preference/"
            "ThemeSelectorActivity.smali"
        )
        theme_selector_text = theme_selector.read_text(encoding="utf-8")
        require(
            theme_selector_text,
            ("ThemeSettingsInsetsCompat;->attachSelector(Landroid/app/Activity;)V",),
            "theme selector Insets hook",
        )
        theme_insets_helper = decoded / (
            "smali/com/google/android/inputmethod/pinyin/"
            "ThemeSettingsInsetsCompat$SystemBarsListener.smali"
        )
        if not theme_insets_helper.is_file():
            raise RuntimeError("theme selector system-bar Insets helper is missing")

        legacy_ime = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
        if not legacy_ime.is_file():
            raise RuntimeError("legacy IME must remain in primary classes.dex")
        settings_activity = decoded / (
            "smali/com/google/android/apps/inputmethod/pinyin/preference/SettingsActivity.smali"
        )
        settings_activity_text = settings_activity.read_text(encoding="utf-8")
        require(
            settings_activity_text,
            (
                'const-string v1, "app_icon"',
                "PinyinFirstRunActivity;->b(Landroid/content/Context;)Z",
                "Build$VERSION;->SDK_INT:I",
                "const/16 v1, 0x23",
                'const-string v1, "modern_settings_use_legacy"',
                "modernsettings.compose.ModernSettingsActivity",
                "->setClassName(",
                "SettingsActivity;->finish()V",
            ),
            "primary-DEX API-35 settings route",
        )
        if "Lcom/google/android/inputmethod/pinyin/modernsettings/compose/ModernSettingsActivity;" in settings_activity_text:
            raise RuntimeError("primary DEX must reference the modern Activity by string only")
        compose_activities = list(
            decoded.glob(
                "smali_classes*/com/google/android/inputmethod/pinyin/modernsettings/compose/"
                "ModernSettingsActivity.smali"
            )
        )
        if len(compose_activities) != 1:
            raise RuntimeError(f"expected one Compose activity in secondary DEX, found {compose_activities}")

    print("official Compose Material 3 settings runtime verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
