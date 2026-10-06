#!/usr/bin/env python3
"""Verify the source-built Compose Material 3 host and optional decoded APK."""

from __future__ import annotations

import argparse
import re
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
            "setContent {",
            "CompositionLocalProvider(LocalLayoutDirection provides layoutDirection)",
            "context.resources.configuration.layoutDirection",
            "modernSettingsLayoutDirection(",
            "dictionaryImport = dictionaryImport",
            "openDictionaryImport()",
            "DictionaryImportStateReducer.select(",
            "dictionaryRepository::importBackup",
            "CLEAR_IN_PROGRESS_KEY",
            "dictionaryRepository.isClearInProgress()",
            "dictionaryRepository.detachClearCallback(dictionaryClearCallback)",
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
            "val onDynamicColorEnabledChange: (Boolean) -> Unit",
            "actions.onDynamicColorEnabledChange",
            "snapshot.dynamicColorEnabled",
            "DynamicColorSetting.preferenceKey",
            '"setDynamicEnabled"',
            "val onSystemAutoThemeEnabledChange: (Boolean) -> Unit",
            "actions.onSystemAutoThemeEnabledChange",
            "snapshot.systemAutoThemeEnabled",
            "SystemAutoThemeSetting.preferenceKey",
            '"com.google.android.inputmethod.pinyin.SystemAutoThemeCompat"',
            "snapshot, actions, navigateTo,",
            "SettingsRoute.ThemeCatalog",
            "ThemeCatalogScreen(",
            "onApplyTheme = actions.onApplyTheme",
            "onAssignThemeSlotFollowingSystem = actions.onAssignThemeSlotFollowingSystem",
            "onFollowSystemEnabledChange = actions.onSystemAutoThemeEnabledChange",
            "onDynamicColorEnabledChange = actions.onDynamicColorEnabledChange",
            "onAddTheme = actions.onAddTheme",
            "onEditTheme = actions.onEditTheme",
            "onDeleteTheme = actions.onDeleteTheme",
            "val onEditTheme: (String) -> Unit",
            "val onDeleteTheme: (String) -> Unit",
            # The wizard is a Compose host of this module's own now, so the
            # settings page names it directly instead of asking the legacy
            # navigation helper for an intent aimed at a legacy activity.
            "themeBuilder.launch(ModernThemeBuilderActivity.intent(this))",
            "ModernThemeBuilderActivity.intent(",
            "ModernThemeBuilderActivity.RESULT_NEW_NAME",
            "controller.deleteUserTheme(themeValue)",
            "controller.applyCustomThemeEditResult(result.data)",
            "LegacySettingsNavigation.routePathExtra",
            # The sheet draws its edit and delete buttons from a null callback
            # rather than from a flag beside one, so a subject with no action
            # cannot be drawn as a button that does nothing.
            "editTheme = if (shown.userMade) closeThen(onEditTheme) else null",
            "deleteTheme = if (shown.userMade) closeThen { pendingDelete = it } else null",
            "subject = ThemePreviewSubject(entry.value, userMade = true)",
            "val editTheme: (() -> Unit)? = null",
            "val deleteTheme: (() -> Unit)? = null",
            # Every button that closes the sheet hides it first. Clearing the
            # subject takes the sheet out of the tree on the same frame, so a
            # button that ran its action directly made the sheet vanish instead
            # of leave - only the scrim, whose dismissal Material 3 routes
            # through a hide of its own, had an exit.
            "scope.launch {",
            "leaveTheWayItArrived(sheetState)",
            "sheetState.hide()",
            "}.invokeOnCompletion {",
            "if (!sheetState.isVisible) action()",
            # The exit runs on the spring the sheet arrived on. Material 3
            # hands the sheet a stiffer spring for hiding than for showing -
            # measured, the way in covers the height in about 200 ms and the
            # way out covers it in under 50 - which is what read as the sheet
            # being yanked off the screen. Neither field is reachable from
            # Kotlin, so the copy goes through the generated accessors.
            "getShowMotionSpec\\$material3",
            "setHideMotionSpec\\$material3",
            "FiniteAnimationSpec::class.java",
            "private fun leaveTheWayItArrived(state: SheetState)",
            # Material 3 writes both specs back on every recomposition, so the
            # copy is re-applied on the frames the sheet is actually moving on.
            # That observer is also the only thing that reaches the scrim's
            # dismissal, which is the component's own hide and cannot be hooked.
            "snapshotFlow { sheetOffset(sheetState) }",
            "private fun sheetOffset(state: SheetState): Float",
            "onClick = { dismissThen(onDismiss) }",
            "onClick = { dismissThen(actions.apply) }",
            "onClick = { dismissThen(actions.assignLight) }",
            "onClick = { dismissThen(actions.assignDark) }",
            "edit = closingAction(actions.editTheme)",
            "delete = closingAction(actions.deleteTheme)",
            "R.string.modern_settings_theme_delete_confirm_title",
            "R.string.modern_settings_theme_delete_confirm_action",
            "ThemePreviewMode.Dynamic",
            "ThemePreviewMode.FollowSystem",
            "val markedValue = if (fixedInUse) activeValue else",
            # The assign buttons used to be enabled by `canSelect`, which is
            # false whenever the follow-the-system mode is off - and the sheet
            # has no way to turn that mode on, so the pair sat dead for every
            # theme on the page. They are now live for every subject that has a
            # slot to write, and the write turns the mode on itself.
            "assignEnablesFollowSystem = assignable && !systemAuto",
            "R.string.modern_settings_theme_assign_enables_follow_system",
            "ThemeCatalogRules.builtinNames(",
            "ThemeCatalogRules.builtinCatalog(",
            "ThemeCatalogRules.userCatalog(",
            "ThemeCatalogRules.resolveSlots(",
            "ThemeSlotKey.entries.associateWith { slot ->",
            "DynamicColorSetting.generatedPackageValue",
            '"entryvalues_builtin_additional_keyboard_theme"',
            '"builtin_theme_package_name_to_theme_name_map"',
            "themeCatalog = themeCatalog",
            "ThemeSettingRules.canSelect(slot, followThemeEnabled, dynamicColorEnabled)",
            "val onRefreshDictionaryHealth: () -> Unit",
            "DictionaryHealthStatusCompat\\$SnapshotCallback",
            "DictionaryHealthStateReducer.start(dictionaryHealth)",
            "dictionaryHealth = result",
            'fields.getField("details").get(snapshot)',
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
            "actions.onContactSuggestionsEnabledChange",
            "DictionaryClearDialog(",
            "DictionaryClearStateReducer.canConfirm(state)",
            "contactsPermission.launch(Manifest.permission.READ_CONTACTS)",
            "dictionaryRepository.startClear(callback)",
            "SettingsRoute.About",
            "LegacySettingsNavigation.legacyWebIntent",
            # The licence page is Compose now. Its list comes from the packaged
            # raw pair, and the legacy licences activity must not be reachable
            # from this module any more.
            "SettingsRoute.Licenses",
            "LicensesScreen(onNavigateBack = navigateBack)",
            "navigateTo(SettingsRoute.Licenses)",
            "readPackagedLicenses(context)",
            '"third_party_license_metadata"',
            '"third_party_licenses"',
            "val onOpenRepository: () -> Unit",
            "actions.onOpenRepository",
            "LegacySettingsNavigation.repositoryUrl",
            "LegacySettingsNavigation.repositoryIntent()",
            # The first-run guide is Compose now, on the same terms as the
            # licence page: the legacy activity keeps the launch gate and the
            # state, and hands the page itself over on the API levels this
            # module serves.
            "class ModernFirstRunActivity : ComponentActivity()",
            "FirstRunScreen(",
            "readFirstRunSetupState(this)",
            "FirstRunStateBridge.activityCreated()",
            "FirstRunStateBridge.activityDestroyed(this)",
            "FirstRunStateBridge.complete(this)",
            "Settings.ACTION_INPUT_METHOD_SETTINGS",
            "showInputMethodPicker()",
            '"https://github.com/huaxianyan/ComebackGooglePinyinInput"',
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
            "BooleanSettingContracts.pairedPunctuation",
            "snapshot.pairedPunctuation.value",
            "modern_settings_paired_punctuation_title",
            "modern_settings_paired_punctuation_summary",
            "BooleanSettingContracts.showSimplifiedTraditionalHeaderToggle",
            "snapshot.showSimplifiedTraditionalHeaderToggle.value",
            "modern_settings_show_simplified_traditional_header_toggle_title",
            "modern_settings_show_simplified_traditional_header_toggle_summary",
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
    # The theme catalog replaced the old theme-background page outright. It is
    # the page the appearance entry opens now, so a leftover row set or route
    # would be a second, unreachable copy of the same screen.
    for retired in (
        "ThemeBackground",
        "themeBackgroundSettingsItems",
    ):
        if retired in kotlin_text:
            raise RuntimeError(f"retired theme-background page still present: {retired}")

    # The user's own themes are the last section, below the packaged colours.
    # That section is empty for anyone who has never built a theme, so it must
    # not be the part the page opens on.
    theme_catalog_screen = next(kotlin_root.rglob("ThemeCatalogScreen.kt")).read_text(
        encoding="utf-8"
    )
    section_offsets = []
    for section in (
        "modern_settings_theme_catalog_section_default",
        "modern_settings_theme_catalog_section_color",
        "modern_settings_theme_catalog_section_mine",
    ):
        reference = f"R.string.{section}"
        if reference not in theme_catalog_screen:
            raise RuntimeError(f"theme catalog is missing its {section} heading")
        section_offsets.append(theme_catalog_screen.index(reference))
    if section_offsets != sorted(section_offsets):
        raise RuntimeError(
            "theme catalog sections must read Defaults, Colors, My themes; "
            f"found offsets {section_offsets}"
        )

    # Every inflated swatch has to be keyed on its theme value. `AndroidView`
    # runs its factory only on the first composition, so an unkeyed one keeps
    # drawing whatever theme was passed when the page was opened - which is
    # exactly how a slot the user had just repointed came to look unassigned.
    theme_tiles = next(kotlin_root.rglob("ThemeTiles.kt")).read_text(encoding="utf-8")
    swatches = theme_tiles.count("inflateThemeSwatch(context, themeValue)")
    keyed = theme_tiles.count("key(themeValue) {")
    if swatches == 0:
        raise RuntimeError("ThemeTiles.kt no longer inflates a theme swatch")
    if keyed < swatches:
        raise RuntimeError(
            f"ThemeTiles.kt inflates {swatches} swatches but keys only {keyed} on "
            f"the theme value; the unkeyed one will not redraw when its theme changes"
        )
    for forbidden in ("android.widget.SeekBar", "onDraw(", "Md3SliderView"):
        if forbidden in kotlin_text:
            raise RuntimeError(f"modern settings must not simulate Slider: {forbidden}")
    # Paired-symbol completion is a general input option, so the Compose switch
    # belongs to the input-settings screen right below "double-space period" and
    # must not stay on the keyboard-settings screen.
    input_settings_text = next(
        kotlin_root.rglob("InputSettingsScreens.kt")
    ).read_text(encoding="utf-8")
    keyboard_settings_text = next(
        kotlin_root.rglob("KeyboardSettingsScreens.kt")
    ).read_text(encoding="utf-8")
    require(
        input_settings_text,
        (
            "BooleanSettingContracts.pairedPunctuation",
            "snapshot.pairedPunctuation.value",
            "modern_settings_paired_punctuation_title",
            "modern_settings_paired_punctuation_summary",
        ),
        "paired punctuation switch on the input-settings screen",
    )
    if input_settings_text.index(
        "setting_paired_punctuation_title"
    ) < input_settings_text.index("setting_double_space_period_title"):
        raise RuntimeError(
            "the paired punctuation switch must sit below the double-space switch"
        )
    if "pairedPunctuation" in keyboard_settings_text:
        raise RuntimeError(
            "the paired punctuation switch must not stay on the keyboard-settings screen"
        )
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
                'name="modern_settings_theme_page_summary"',
                'name="modern_settings_theme_assign_enables_follow_system"',
                'name="modern_settings_theme_edit"',
                'name="modern_settings_theme_delete"',
                'name="modern_settings_theme_delete_confirm_title"',
                'name="modern_settings_theme_delete_confirm_message"',
                'name="modern_settings_theme_delete_confirm_action"',
                'name="modern_settings_system_auto_theme_title"',
                'name="modern_settings_dynamic_color_title"',
                'name="modern_settings_theme_catalog_title"',
                'name="modern_settings_theme_catalog_in_use"',
                'name="modern_settings_theme_catalog_builtin"',
                'name="modern_settings_theme_catalog_custom"',
                'name="modern_settings_theme_catalog_no_custom"',
                'name="modern_settings_theme_catalog_unset"',
                'name="modern_settings_theme_catalog_unresolved"',
                'name="modern_settings_launcher_icon_title"',
                'name="modern_settings_launcher_icon_summary"',
                'name="modern_settings_dictionary_health_title"',
                'name="modern_settings_dictionary_backup_section"',
                'name="modern_settings_dictionary_location_title"',
                'name="modern_settings_dictionary_import_title"',
                'name="modern_settings_dictionary_enable_shortcuts"',
                'name="modern_settings_dictionary_contacts_title"',
                'name="modern_settings_dictionary_contacts_permission_summary"',
                'name="modern_settings_dictionary_clear_confirm_title"',
                'name="modern_settings_dictionary_clear_code_label"',
                'name="modern_settings_dictionary_clear_success"',
                'name="modern_settings_about_title"',
                'name="modern_settings_terms_title"',
                'name="modern_settings_privacy_title"',
                'name="modern_settings_repository_title"',
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
    require(
        values,
        ('<string name="modern_settings_title">Google Pinyin Input settings</string>',),
        "production English settings title",
    )
    require(
        values_zh,
        ('<string name="modern_settings_title">Google 拼音输入法设置</string>',),
        "production Simplified Chinese settings title",
    )
    if "modern_settings_stage_summary" in values + values_zh + kotlin_text:
        raise RuntimeError("staged validation copy must not ship in the production settings home")
    for obsolete_dictionary_copy in (
        "modern_settings_dictionary_privacy_summary",
        "dictionary_backup_privacy",
        "dictionary_auto_backup_privacy_summary",
    ):
        if obsolete_dictionary_copy in values + values_zh + kotlin_text:
            raise RuntimeError(
                f"verbose dictionary backup copy must not ship: {obsolete_dictionary_copy}"
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

    theme_catalog_rules = next(
        (project / "compose-runtime/src/main/kotlin").rglob("ThemeCatalog.kt")
    ).read_text(encoding="utf-8")
    require(
        theme_catalog_rules,
        (
            'require(pairs.size % 2 == 0) { "array size should be multiple of 2." }',
            "USER_THEME_DIRECTORY_PREFIX = \"user_theme_\"",
            "it.startsWith(USER_THEME_DIRECTORY_PREFIX)",
            "additionalBySlot[slot].orEmpty()",
            "entries.firstOrNull { it.value == additional }",
        ),
        "theme inventory rules",
    )
    theme_catalog_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("ThemeCatalogTest.kt")
    ).read_text(encoding="utf-8")
    require(
        theme_catalog_test,
        (
            "builtinCatalogKeepsDeclarationOrder",
            "builtinCatalogDropsValuesWithoutAName",
            "builtinNamesRejectsAnOddArray",
            "userCatalogFiltersSortsAndBuildsFilesValues",
            "generatedPaletteIsNotAScannedUserTheme",
            "resolveSlotsNamesEverySlotAndKeepsUnresolvedValues",
            "resolveSlotsLeavesAnUnknownValueUnresolved",
            "slotKeysMatchTheBridgeNaming",
            "generatedSlotIsNotASelectionTarget",
        ),
        "theme inventory tests",
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
            'key = "show_simplified_traditional_header_toggle"',
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
            "val headerShortcutBatch = listOf(",
            "val languageSwitchDependencyBatch = listOf(",
            "val englishDependencyBatch = listOf(",
            "val gestureDependencyBatch = listOf(",
            "capabilityGatedKeyboardBatch + headerShortcutBatch +",
            "languageSwitchDependencyBatch + englishDependencyBatch",
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
            "headerShortcutPreservesExactKeyAndDefault",
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
    operations_bridge = (
        project.parent
        / "patches/java/com/google/android/inputmethod/pinyin/DictionaryOperationsCompat.java"
    ).read_text(encoding="utf-8")
    auto_theme_bridge = (
        project.parent
        / "patches/java/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.java"
    ).read_text(encoding="utf-8")
    require(
        dictionary_bridge + "\n" + import_bridge + "\n" + operations_bridge,
        (
            "public interface BackupListCallback",
            "public static final class BackupEntry",
            "public String getName()",
            "public Uri getUri()",
            "public static void listBackupsAsync(",
            "public static boolean startNativeImport(Context source, Uri uri)",
            "public interface ClearCallback",
            "hasContactsPermission(Context context)",
            'getBoolean("import_user_contacts", false)',
            'Class.forName("bdz")',
            'getMethod("startClearUserDict")',
            "clearInProgress",
            "pendingClearResult",
            "if (callback == null) pendingClearResult = success",
        ),
        "primary-DEX modern dictionary operations bridge",
    )
    require(
        auto_theme_bridge,
        (
            'AUTO_THEME_KEY = "compat_system_auto_keyboard_theme"',
            "Configuration.UI_MODE_NIGHT_MASK",
            "Configuration.UI_MODE_NIGHT_YES",
            "MATERIAL_DARK_THEME = 0x7f110224",
            "MATERIAL_LIGHT_THEME = 0x7f110225",
            'SLOT_LIGHT = "light"',
            'SLOT_DARK = "dark"',
            'SLOT_FIXED = "fixed"',
            'FIXED_BASE_KEY = "compat_theme_fixed_keyboard"',
            "public static void captureFixedTheme(Context context)",
            "public static void reconcileCustomThemeEdit(Context context, Intent data)",
            "public static void applyCustomThemeEditResult(Context context, Intent data)",
            "public static boolean deleteUserTheme(Context context, String themeValue)",
            "public static void applyTheme(Context context, String additional)",
            "public static void assignSlot(Context context, String slot, String additional)",
            'additional.startsWith("files:user_theme_") && additional.endsWith(deleted)',
            # A removed custom theme must not leave a slot naming a package that
            # is gone, and the slot it was assigned to has to land on the same
            # theme it was initialized with rather than on whatever happens to be
            # live when the delete runs.
            "private static void repointSlots(Context context, String held, String replacement)",
            "private static String defaultAdditional(Context context, String slot)",
            "private static String customThemeName(String themeValue)",
            "USER_THEME_VALUE_PREFIX = \"files:\"",
            "USER_THEME_NAME_PREFIX = \"user_theme_\"",
            "return context.getString(MATERIAL_DARK_THEME)",
            "return context.getString(MATERIAL_LIGHT_THEME)",
            "public static boolean applyOnCreate(Context context)",
            "public static boolean applyIfEnabled(Context context, Configuration configuration)",
            'Class.forName("baq")',
            "putIfAbsent(editor, preferences, FIXED_BASE_KEY, current[0])",
            "putIfAbsent(editor, preferences, LIGHT_ADDITIONAL_KEY, "
            "context.getString(MATERIAL_LIGHT_THEME))",
            "putIfAbsent(editor, preferences, DARK_ADDITIONAL_KEY, "
            "context.getString(MATERIAL_DARK_THEME))",
            "if (!preferences.contains(key))",
            "ApplicationInfo.FLAG_DEBUGGABLE",
            'DIAGNOSTIC_TAG = "SystemAutoTheme"',
            '"configuration uiMode="',
            '"rebuilding InputView after automatic theme resolution"',
        ),
        "primary-DEX System Auto theme bridge",
    )
    # The one-slot selection session is gone. The settings UI writes a slot
    # through `assignSlot` instead of launching the original selector to pick
    # one, so nothing ever opened a session and the machinery could only ever
    # answer "no session". It is removed rather than left standing because a
    # guard that can never be true still reads as a rule, and the next change
    # to this file would be written to obey it.
    for retired in (
        "SELECTION_SLOT_KEY",
        "hasSelectionSession",
        "beginSelection",
        "finishSelection",
    ):
        if retired in auto_theme_bridge:
            raise RuntimeError(f"retired theme selection session still present: {retired}")

    legacy_navigation = (settings_source_dir / "LegacySettingsNavigation.kt").read_text(
        encoding="utf-8"
    )
    require(
        legacy_navigation,
        (
            'const val themeRoutePath = "Home/Keyboard/KeyboardAppearance/ThemeCatalog"',
            'const val routePathExtra = "modern_settings_route_path"',
            "const val repositoryUrl =",
            '"https://github.com/huaxianyan/ComebackGooglePinyinInput"',
            "fun repositoryIntent(): Intent = Intent(Intent.ACTION_VIEW, Uri.parse(repositoryUrl))",
        ),
        "legacy specialized settings navigation",
    )

    # The custom-theme wizard is Compose now, both halves of it: creating from a
    # picture and re-editing an existing theme were two legacy activities and are
    # one wizard here. The result extra names stay the legacy ones because they
    # are the contract with the slot bridge in the primary DEX.
    theme_builder = (settings_source_dir / "ModernThemeBuilderActivity.kt").read_text(
        encoding="utf-8"
    )
    require(
        theme_builder,
        (
            "class ModernThemeBuilderActivity : ComponentActivity()",
            "ActivityResultContracts.GetContent()",
            'const val EXTRA_TARGET = "target_user_image_theme_file_name"',
            'const val RESULT_NEW_NAME = "intent_extra_key_new_theme_file_name"',
            'const val RESULT_DELETED_NAME = "intent_extra_key_deleted_theme_file_name"',
            "ThemeBuilderBridge.openPackage(target)",
            "ThemeBuilderBridge.packageImage(pkg)",
            # The theme's own name is part of the package the legacy wizard
            # wrote, and the legacy editor carried it across an edit. Nothing
            # reads it back, which is exactly why it is easy to drop.
            "ThemeBuilderBridge.packageTitle(pkg)",
            "ThemeBuilderBridge.setTitle(built, resolved)",
            "ThemeBuilderBridge.defaultTitle(this)",
        ),
        "compose custom theme wizard host",
    )

    theme_builder_screen = (settings_source_dir / "CustomThemeBuilderScreen.kt").read_text(
        encoding="utf-8"
    )
    require(
        theme_builder_screen,
        (
            "internal fun themeCropGeometry(",
            "internal data class ThemeCropGeometry(",
            "internal enum class ThemeBuilderStep { Crop, Brightness }",
            # The crop is stored in units of the preview ratio and the centre in
            # source pixels, which is what the legacy page wrote and the legacy
            # editor read back.
            "ThemeBuilderBridge.setCropScale(model, scale / previewRatio)",
            "ThemeBuilderBridge.setCropCenter(",
            "ThemeBuilderBridge.setRects(",
            "ThemeBuilderBridge.setTransparency(model, transparency)",
            "detectTransformGestures",
            "writePackage(context, model)?.let(onSave)",
            # The host draws edge to edge, so the wizard has to keep its own
            # controls out of the system bars. Without this the instruction line
            # sits under the status bar and NEXT sits under the navigation bar,
            # which is where the device pass found it.
            "windowInsetsPadding(WindowInsets.safeDrawing)",
            # A draw scope paints onto the window's canvas without clipping, so
            # the picture - scaled to cover the crop window and therefore taller
            # and wider than the container - covers the instruction line above it
            # unless the canvas clips itself. Found on the device: the picture's
            # top edge landed 341px above the canvas.
            "clipRect {",
            # The picture follows the finger. Dragging is the one gesture whose
            # direction cannot be checked without a device, and the sign is easy
            # to get backwards because the legacy page subtracts its deltas and
            # a Compose pan is measured the other way round.
            "nextCenter.x + pan.x,",
            "nextCenter.y + pan.y,",
            # The gesture handler must only report gestures. A pointerInput block
            # is installed once and is not restarted when the framing changes,
            # so any framing arithmetic done inside it reads values frozen at
            # install time - which on the device turned a 600px drag into a 4px
            # one, the last event's delta and nothing else.
            "onGesture = { centroid, pan, zoom ->",
            "onGesture(centroid, pan, zoom)",
        ),
        "compose custom theme wizard",
    )
    for stale in ("onTransform(nextScale, nextCenter)", "onTransform: (Float, Offset) -> Unit"):
        if stale in theme_builder_screen:
            raise RuntimeError(
                f"the crop gesture handler must not do the framing arithmetic itself: {stale}"
            )

    theme_builder_bridge = (settings_source_dir / "ThemeBuilderBridge.kt").read_text(
        encoding="utf-8"
    )
    require(
        theme_builder_bridge,
        (
            "internal object ThemeBuilderBridge",
            'const val KEY_CROPPING_SCALE = "__cropping_scale"',
            'const val KEY_CROPPING_CENTER_X = "__cropping_rect_center_x"',
            'const val KEY_CROPPING_CENTER_Y = "__cropping_rect_center_y"',
            'const val KEY_OVERLAY_TRANSPARENCY = "__overlay_transparency"',
            # The obfuscated members share names across types, so every lookup
            # has to match the type as well as the name.
            "private fun findField(instance: Any, name: String, fieldType: Class<*>): Field?",
            "private fun findFieldType(owner: Class<*>, name: String, fieldType: Class<*>): Field?",
            "private fun findMethod(",
            # A new theme is named in the app's own format, and the index is the
            # first one no existing package has taken - the loop the legacy
            # builder ran. Dropping it produces a package whose metadata has no
            # title, which is what the device pass found.
            'private const val TITLE_FORMAT_RESOURCE = "user_theme_name_format"',
            "fun defaultTitle(context: Context): String",
            "fun packageTitle(pkg: Any): String?",
            "fun setTitle(model: Any, title: String)",
        ),
        "custom theme engine bridge",
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

    dictionary_operations_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("DictionaryOperationsStateTest.kt")
    ).read_text(encoding="utf-8")
    require(
        dictionary_operations_test,
        (
            "challengeRequiresExactlyFourDigits",
            "inputIsNumericAndBoundedAndOnlyExactMatchConfirms",
            "confirmedOperationCannotBeDismissedOrStartedTwice",
            "cancelAndCompletionDiscardChallengeAndInput",
            "restoredActivityCanReflectPrimaryDexTaskStateWithoutReopeningDialog",
        ),
        "dictionary operations state tests",
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
            "fun applyTheme(themeValue: String)",
            "fun assignThemeSlot(slot: ThemeSelectionSlot, themeValue: String)",
            "fun assignThemeSlotFollowingSystem(",
            "fun applyCustomTheme(fileName: String)",
            "preferences.edit().putString(contract.key, contract.valueAt(index)).apply()",
        ),
        "staged legacy settings repository",
    )
    expected_write_counts = {
        "putBoolean(": 6,
        "putFloat(": 1,
        "putString(": 6,
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
            'f"-PhostVersionName={args.version_name}"',
            'f"-PhostVersionCode={args.version_code}"',
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
            'hostVersionName = providers.gradleProperty("hostVersionName")',
            'hostVersionCode = providers.gradleProperty("hostVersionCode")',
            "versionCode = hostVersionCode.get()",
            "versionName = hostVersionName.get()",
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
            '->queryIntentActivities(',
            'Ljava/util/List;->isEmpty()Z',
            'preference/SettingsActivity;->finish()V',
        ),
        "API-35 modern settings route",
    )
    # The keyboard's own theme shortcut, the first-run theme preview and the
    # legacy settings page all open the old theme selector. On the API levels
    # the Compose page serves, that Activity hands them to it instead, opening
    # on the theme page so the shortcut still lands where the selector would
    # have put it. The route is a path because the Compose hierarchy is a
    # stack: back walks up through the pages that normally lead there.
    require(
        patch_script,
        (
            "preference/ThemeSelectorActivity;->getPackageName()Ljava/lang/String;",
            "preference/ThemeSelectorActivity;->startActivity(Landroid/content/Intent;)V",
            "preference/ThemeSelectorActivity;->finish()V",
            'const-string v1, \\"modern_settings_route_path\\"',
            'const-string v2, \\"Home/Keyboard/KeyboardAppearance/ThemeCatalog\\"',
            ":theme_selector_legacy",
        ),
        "legacy theme page redirect",
    )
    # The two sides of that redirect cannot share a constant across the DEX
    # boundary, so the literal is checked on both sides rather than written once.
    # The patch script carries it inside escaped quotes, which is why the bare
    # path is what is looked for.
    for source, label in (
        (patch_script, "scripts/apply_patches.py"),
        (kotlin_text, "the Compose settings module"),
    ):
        if "Home/Keyboard/KeyboardAppearance/ThemeCatalog" not in source:
            raise RuntimeError(f"theme shortcut route path missing from {label}")
    for forbidden_legacy_dictionary_route in (
        "onOpenLegacyDictionaryOperations",
        '"modern_settings_use_legacy"',
        '"PREFERENCE_FRAGMENT"',
    ):
        if forbidden_legacy_dictionary_route in kotlin_text:
            raise RuntimeError(
                "modern dictionary UI must not navigate to the legacy page: "
                + forbidden_legacy_dictionary_route
            )

    # The licence page is Compose now. It reads the packaged raw pair itself, so
    # nothing in this module may open the legacy licences activity any more.
    if "UnquantumLicenseMenuActivity" in kotlin_text:
        raise RuntimeError("the licence page must not open the legacy licences activity")

    # The custom-theme wizard is Compose now. Its two legacy activities are the
    # last thing this module opened that drew its own UI, so nothing in it may
    # name either of them any more. Matched on a word boundary because this
    # module's own replacement is `ModernThemeBuilderActivity`, which contains
    # the legacy name as a substring - a plain `in` test would flag the fix
    # itself and make the assertion unpassable.
    for retired in ("ThemeBuilderActivity", "ThemeEditorActivity"):
        if re.search(rf"(?<![A-Za-z0-9_]){retired}(?![A-Za-z0-9_])", kotlin_text):
            raise RuntimeError(f"the custom theme wizard must not open the legacy {retired}")

    # The first-run redirect lives in the patch script and in its own helper,
    # which is where the primary DEX names the Compose host from.
    for literal in (
        "FirstRunRoutingCompat;->redirectToModernGuide",
        "FirstRunRoutingCompat;->consumeRedirect",
        "FirstRunRoutingCompat.smali",
    ):
        if literal not in patch_script:
            raise RuntimeError(f"first-run redirect missing from the patch script: {literal}")

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
            # The strings have to be in the DEX that ships, not only in the
            # patch script that writes them. The decoded tree carries the
            # primary DEX alone, so the secondary DEX - where the Compose
            # Activity lives - is only reachable from here.
            dex_bytes = b"".join(
                archive.read(entry)
                for entry in archive.namelist()
                if entry.endswith(".dex")
            )
        for literal in (
            # The keyboard shortcut's redirect, and the route it passes.
            b"Home/Keyboard/KeyboardAppearance/ThemeCatalog",
            b"modern_settings_route_path",
            b"modernsettings.compose.ModernSettingsActivity",
            # The custom-theme lifecycle the sheet's two buttons call into.
            b"deleteUserTheme",
            b"applyCustomThemeEditResult",
            b"target_user_image_theme_file_name",
            b"intent_extra_key_no_delete_button",
            # The exit spring the sheet copies onto its own hide, and the two
            # accessors it goes through - neither is reachable from Kotlin.
            b"leaveTheWayItArrived",
            b"getShowMotionSpec",
            b"setHideMotionSpec",
        ):
            if literal not in dex_bytes:
                raise RuntimeError(
                    "shipped DEX is missing " + literal.decode("ascii")
                )
        # A probe that reads the sheet's real animation specs back was used to
        # find the stiffness difference and must never ship: it logs on every
        # hide and would tell a user's logcat which spring the sheet uses.
        for retired in (b"ThemeSheetProbe", b"probeSheet"):
            if retired in dex_bytes:
                raise RuntimeError(
                    "temporary sheet probe still shipped in DEX: "
                    + retired.decode("ascii")
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
                "ModernFirstRunActivity",
                "ModernThemeBuilderActivity",
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
        # The Compose runtime must not install a process entry point in the
        # legacy process. The prepared manifest names these components only to
        # have the merger drop them, so a `tools:node="remove"` marker is the
        # guard and not the violation; checking the bare name would flag the
        # guard itself. Remove the marked elements first, then look.
        guarded_manifest = re.sub(
            r'<[a-z]+[^>]*tools:node="remove"[^>]*/>', "", manifest_text
        )
        for forbidden in (
            "androidx.startup.InitializationProvider",
            "androidx.profileinstaller.ProfileInstallReceiver",
            "android:appComponentFactory=",
            "android.permission.QUERY_ALL_PACKAGES",
        ):
            if forbidden in guarded_manifest:
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
            (
                "ThemeSettingsInsetsCompat;->attachSelector(Landroid/app/Activity;)V",
                "SystemAutoThemeCompat;->disable(Landroid/content/Context;)V",
                "SystemAutoThemeCompat;->reconcileCustomThemeEdit(Landroid/content/Context;Landroid/content/Intent;)V",
                "SystemAutoThemeCompat;->captureFixedTheme(Landroid/content/Context;)V",
                # The redirect has to survive into the DEX, not just into the
                # patch script: it is the only thing that stops the keyboard's
                # theme shortcut from opening this page on the API levels the
                # Compose settings page serves.
                "modernsettings.compose.ModernSettingsActivity",
                '"modern_settings_route_path"',
                '"Home/Keyboard/KeyboardAppearance/ThemeCatalog"',
                ":theme_selector_legacy",
            ),
            "theme selector Insets, automatic-mode hooks and Compose redirect",
        )
        theme_insets_helper = decoded / (
            "smali/com/google/android/inputmethod/pinyin/"
            "ThemeSettingsInsetsCompat$SystemBarsListener.smali"
        )
        if not theme_insets_helper.is_file():
            raise RuntimeError("theme selector system-bar Insets helper is missing")

        auto_theme_helper = decoded / (
            "smali/com/google/android/inputmethod/pinyin/SystemAutoThemeCompat.smali"
        )
        require(
            auto_theme_helper.read_text(encoding="utf-8"),
            (
                '"compat_system_auto_keyboard_theme"',
                '"compat_theme_light_keyboard"',
                '"compat_theme_dark_keyboard"',
                '"compat_theme_fixed_keyboard"',
                ".method public static captureFixedTheme(Landroid/content/Context;)V",
                ".method public static reconcileCustomThemeEdit(Landroid/content/Context;Landroid/content/Intent;)V",
                ".method public static applyCustomThemeEditResult(Landroid/content/Context;Landroid/content/Intent;)V",
                ".method public static deleteUserTheme(Landroid/content/Context;Ljava/lang/String;)Z",
                ".method private static repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V",
                ".method private static defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;",
                ".method private static customThemeName(Ljava/lang/String;)Ljava/lang/String;",
                ".method public static applyOnCreate(Landroid/content/Context;)Z",
                '"baq"',
            ),
            "primary-DEX System Auto theme-slot helper",
        )
        for retired in (
            '"compat_theme_selection_slot"',
            ".method public static beginSelection(",
            ".method public static finishSelection(",
        ):
            if retired in auto_theme_helper.read_text(encoding="utf-8"):
                raise RuntimeError(
                    f"retired theme selection session still shipped in DEX: {retired}"
                )
        require(
            auto_theme_helper.read_text(encoding="utf-8"),
            (
                '"compat_system_dynamic_color_theme"',
                '"compat_theme_dynamic_keyboard"',
                '"compat_theme_dynamic_additional"',
                '"compat_theme_dynamic_signature"',
                '"dynamic_theme.zip"',
                '"theme/"',
                '"style_sheet_material_"',
                '"system_surface"',
                '"system_primary_container"',
                '"system_outline_variant"',
                ".method public static setDynamicEnabled(Landroid/content/Context;Z)V",
                ".method public static isDynamicEnabled(Landroid/content/Context;)Z",
                ".method public static supportsDynamicColor()Z",
                ".method public static applyOnKeyboardShown(Landroid/content/Context;)Z",
                ".method public static rewriteStyleSheetColors([BLjava/util/Map;)[B",
                ".method private static isSelectableSlot(Ljava/lang/String;)Z",
                ".method private static buildDynamicThemePackage(Landroid/content/Context;ZLjava/util/Map;)Z",
            ),
            "primary-DEX dynamic-color theme-slot helper",
        )
        # The generated slot is switch-only. If it ever became "selectable" the
        # picker could open it and the selection session would pause the very
        # slot it was meant to edit.
        #
        # Split on the declaration, not on the bare signature: the first match
        # in the file is a call site, and a call site sits in some unrelated
        # method whose body would be checked instead. The positive assertions
        # below make a wrong region fail loudly rather than pass silently.
        selectable_body = auto_theme_helper.read_text(encoding="utf-8").split(
            ".method private static isSelectableSlot(Ljava/lang/String;)Z", 1,
        )[1].split(".end method", 1)[0]
        for literal in ('"light"', '"dark"', '"fixed"'):
            if literal not in selectable_body:
                raise RuntimeError(
                    "isSelectableSlot body looks wrong; expected " + literal
                )
        if '"dynamic"' in selectable_body:
            raise RuntimeError("the generated slot must never be selectable in the picker")
        google_ime = decoded / (
            "smali/com/google/android/apps/inputmethod/libs/framework/core/"
            "GoogleInputMethodService.smali"
        )
        google_ime_text = google_ime.read_text(encoding="utf-8")
        require(
            google_ime_text,
            (
                "SystemAutoThemeCompat;->applyOnCreate(Landroid/content/Context;)Z",
                "SystemAutoThemeCompat;->applyIfEnabled(Landroid/content/Context;Landroid/content/res/Configuration;)Z",
                "move-result v9",
                "SystemAutoThemeCompat;->logInputViewRebuild(Landroid/content/Context;)V",
                "SystemAutoThemeCompat;->applyOnKeyboardShown(Landroid/content/Context;)Z",
                "move-result v7",
                ":system_auto_theme_shown_done",
                "GoogleInputMethodService;->c()V",
            ),
            "IME System Auto configuration hooks",
        )
        if google_ime_text.count(
            "SystemAutoThemeCompat;->logInputViewRebuild(Landroid/content/Context;)V"
        ) != 3:
            raise RuntimeError(
                "both configuration exits and the keyboard-popup hook must rebuild "
                "an updated auto theme"
            )

        operations_helper = decoded / (
            "smali/com/google/android/inputmethod/pinyin/DictionaryOperationsCompat.smali"
        )
        operations_delegate = decoded / (
            "smali/com/google/android/inputmethod/pinyin/"
            "DictionaryOperationsCompat$ControllerDelegate.smali"
        )
        require(
            operations_helper.read_text(encoding="utf-8"),
            (
                'const-string v0, "android.permission.READ_CONTACTS"',
                'const-string v1, "import_user_contacts"',
                "new-instance v1, Lbdz;",
                "Lbdz;->startClearUserDict()V",
                "clearInProgress:Z",
                "pendingClearResult:Ljava/lang/Boolean;",
                "Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;",
            ),
            "primary-DEX contact and clear bridge",
        )
        require(
            operations_delegate.read_text(encoding="utf-8"),
            (
                "IDictionarySyncControllerDelegate;",
                "DictionaryOperationsCompat;->notifyClearFinished(Lbdz;Z)V",
            ),
            "primary-DEX clear controller delegate",
        )
        legacy_dictionary_fragment = decoded / (
            "smali/com/google/android/apps/inputmethod/pinyin/preference/"
            "DictionarySettingsFragment.smali"
        )
        if not legacy_dictionary_fragment.is_file():
            raise RuntimeError("legacy dictionary settings must remain for API 17-34")

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
                "->queryIntentActivities(",
                "Ljava/util/List;->isEmpty()Z",
                "SettingsActivity;->finish()V",
            ),
            "primary-DEX API-35 settings route",
        )
        if "Lcom/google/android/inputmethod/pinyin/modernsettings/compose/ModernSettingsActivity;" in settings_activity_text:
            raise RuntimeError("primary DEX must reference the modern Activity by string only")
        if "Landroid/content/Intent;->resolveActivity(" in settings_activity_text:
            raise RuntimeError(
                "explicit modern settings Intent must query the installed manifest; "
                "resolveActivity() merely echoes an explicit ComponentName"
            )
        compose_activities = list(
            decoded.glob(
                "smali_classes*/com/google/android/inputmethod/pinyin/modernsettings/compose/"
                "ModernSettingsActivity.smali"
            )
        )
        # A tree produced by decoding the original APK carries the primary DEX
        # only; the Compose classes arrive as a secondary DEX during the host
        # build and are never written back here. The count is therefore checked
        # only when the tree has secondary DEX directories at all, and the
        # shipped APK is where the Activity is verified otherwise.
        secondary_dex_directories = list(decoded.glob("smali_classes*"))
        if secondary_dex_directories and len(compose_activities) != 1:
            raise RuntimeError(
                f"expected one Compose activity in secondary DEX, found {compose_activities}"
            )

    print("official Compose Material 3 settings runtime verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
