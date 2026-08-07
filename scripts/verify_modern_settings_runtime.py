#!/usr/bin/env python3
"""Verify the source-built Compose Material 3 host and optional decoded APK."""

from __future__ import annotations

import argparse
from pathlib import Path


def require(text: str, fragments: tuple[str, ...], label: str) -> None:
    missing = [fragment for fragment in fragments if fragment not in text]
    if missing:
        raise RuntimeError(f"{label} is incomplete: {missing}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", type=Path, default=Path("modern-settings"))
    parser.add_argument("--decoded", type=Path)
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
            "minSdk = 23",
        ),
        "Compose runtime dependencies",
    )
    kotlin_root = project / "compose-runtime/src/main/kotlin"
    kotlin_files = tuple(kotlin_root.rglob("*.kt"))
    kotlin_text = "\n".join(path.read_text(encoding="utf-8") for path in kotlin_files)
    activity_text = next(
        kotlin_root.rglob("ComposeSettingsPrototypeActivity.kt")
    ).read_text(encoding="utf-8")
    require(
        activity_text,
        (
            "class ComposeSettingsPrototypeActivity : ComponentActivity()",
            "SettingsController(",
            "SettingsPreviewEffects(this)",
            "SettingsScreen(",
            "override fun onResume()",
            "snapshot = controller.read()",
            "setContent {",
        ),
        "guarded Compose settings activity",
    )
    require(
        kotlin_text,
        (
            "import androidx.compose.material3.Slider",
            "import androidx.compose.material3.Switch",
            "import androidx.compose.material3.TopAppBar",
            "data class SettingsActions(",
            "fun SettingsScreen(",
            "fun DefaultAwareAdjustment(",
            "SystemDefaultAdjustment(",
            "AdjustmentStateReducer.startCustom",
            "AdjustmentStateReducer.applyDraft",
            "AdjustmentStateReducer.cancelDraft",
            "AdjustmentStateReducer.restoreDefault",
            "rememberSaveable(title, resolvedKey, stateSaver = adjustmentStateSaver)",
            "previewEffects.previewVolume(percent)",
            "previewEffects.previewVibration(milliseconds)",
            "snapshot.keyboardHeightLabels::get",
            "snapshot.slideSensitivityLabels::get",
            "actions.onHandwritingTimeoutChange",
            "actions.onHandwritingStrokeWidthChange",
            "snapshot.handwritingTimeoutLabels",
            "snapshot.handwritingStrokeWidthLabels",
            "WindowInsets.safeGestures.only(WindowInsetsSides.Horizontal)",
            "displayedValue.roundToInt()",
            "stringResource(R.string.modern_settings_set_custom)",
            "stringResource(R.string.modern_settings_use_system_default)",
        ),
        "official Compose Material 3 settings modules",
    )
    for forbidden in ("android.widget.SeekBar", "onDraw(", "Md3SliderView"):
        if forbidden in kotlin_text:
            raise RuntimeError(f"modern settings must not simulate Slider: {forbidden}")
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
        ),
        "audited Slider persistence contracts",
    )

    require(
        kotlin_text,
        (
            "sealed interface AdjustmentEditorState",
            "data object SystemDefault",
            "data class EditingDraft(val value: Int, val touched: Boolean)",
            "data class Explicit(val value: Int)",
            "require(state is AdjustmentEditorState.EditingDraft && state.touched)",
            "dependencyEnabled && state !is AdjustmentEditorState.SystemDefault",
        ),
        "pure adjustment state reducer",
    )
    adjustment_test = next(
        (project / "compose-runtime/src/test/kotlin").rglob("AdjustmentStateTest.kt")
    ).read_text(encoding="utf-8")
    require(
        adjustment_test,
        (
            "untouchedDraftCannotBecomeExplicitZero",
            "touchedDraftCanApplyExplicitZeroWithoutCollapsingToDefault",
            "cancelDiscardsDraftAndRestoreReturnsToDefault",
            "dependencyDisableRetainsExplicitValueButBlocksInteraction",
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
            '"entries_keyboard_height_ratio"',
            '"entries_keyboard_slide_sensitivity_ratio"',
            "keyboardHeightLabels: List<String>",
            "slideSensitivityLabels: List<String>",
            "handwritingTimeoutLabels: List<String>",
            "handwritingStrokeWidthLabels: List<String>",
            "fun readSliderSnapshot()",
            "fun setSoundEnabled(enabled: Boolean)",
            "fun setVibrationEnabled(enabled: Boolean)",
            "fun setVolumePercent(percent: Int)",
            "fun restoreVolumeDefault()",
            "fun setVibrationDuration(milliseconds: Int)",
            "fun restoreVibrationDefault()",
            "fun setKeyboardHeightIndex(index: Int)",
            "fun setSlideSensitivityIndex(index: Int)",
            "fun setHandwritingTimeoutIndex(index: Int)",
            "fun setHandwritingStrokeWidthIndex(index: Int)",
            "preferences.edit().putString(contract.key, contract.valueAt(index)).apply()",
        ),
        "staged legacy settings repository",
    )
    expected_write_counts = {
        "putBoolean(": 2,
        "putFloat(": 1,
        "putString(": 2,
        ".remove(": 2,
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
        ),
        "reconstructed host build",
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
        ),
        "guarded legacy manifest",
    )

    if args.decoded is not None:
        decoded = args.decoded
        manifest_text = (decoded / "AndroidManifest.xml").read_text(encoding="utf-8")
        require(
            manifest_text,
            (
                "com.google.android.apps.inputmethod.pinyin.PinyinApp",
                "com.google.android.inputmethod.pinyin.PinyinIME",
                "ComposeSettingsPrototypeActivity",
                'android:enabled="@bool/modern_settings_runtime_enabled"',
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
        ):
            if forbidden in manifest_text:
                raise RuntimeError(f"unguarded AndroidX process entry point: {forbidden}")

        legacy_ime = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
        if not legacy_ime.is_file():
            raise RuntimeError("legacy IME must remain in primary classes.dex")
        compose_activities = list(
            decoded.glob(
                "smali_classes*/com/google/android/inputmethod/pinyin/modernsettings/compose/"
                "ComposeSettingsPrototypeActivity.smali"
            )
        )
        if len(compose_activities) != 1:
            raise RuntimeError(f"expected one Compose activity in secondary DEX, found {compose_activities}")

    print("official Compose Material 3 settings runtime verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
