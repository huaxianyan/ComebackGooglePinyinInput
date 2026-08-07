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
    screen = next((project / "compose-runtime/src/main/kotlin").rglob("ComposeSettingsPrototypeActivity.kt"))
    screen_text = screen.read_text(encoding="utf-8")
    require(
        screen_text,
        (
            "import androidx.compose.material3.Slider",
            "import androidx.compose.material3.Switch",
            "import androidx.compose.material3.TopAppBar",
            "class ComposeSettingsPrototypeActivity : ComponentActivity()",
            "repository = LegacySettingsRepository(this)",
            "snapshot = repository.readSliderSnapshot()",
            "ReadOnlySettingsScreen(it)",
            "override fun onResume()",
            "SystemDefaultRow",
            'label = { Text("系统默认") }',
            "snapshot.keyboardHeightLabel",
            "snapshot.slideSensitivityLabel",
            "按键音已关闭，启用后使用系统默认音量",
            "按键振动已关闭，启用后使用系统默认时长",
            "enabled = false",
            "setContent {",
        ),
        "official Compose Material 3 prototype",
    )
    for forbidden in ("android.widget.SeekBar", "onDraw(", "Md3SliderView"):
        if forbidden in screen_text:
            raise RuntimeError(f"modern settings must not simulate Slider: {forbidden}")

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
        ),
        "audited Slider persistence contracts",
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
            "fun readSliderSnapshot()",
        ),
        "read-only legacy settings repository",
    )
    if ".edit()" in repository_text or "SharedPreferences.Editor" in repository_text:
        raise RuntimeError("initial settings repository stage must remain read-only")

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
            ),
            "combined host manifest",
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
