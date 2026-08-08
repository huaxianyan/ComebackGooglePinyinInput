package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.LocalContext

/** API-35+-guarded host for the staged official Compose Material 3 settings runtime. */
class ComposeSettingsPrototypeActivity : ComponentActivity() {
    private lateinit var controller: SettingsController
    private var snapshot by mutableStateOf<SettingsSnapshot?>(null)

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        controller = SettingsController(
            LegacySettingsRepository(this),
            SettingsPreviewEffects(this),
        )
        setContent {
            ModernSettingsTheme {
                snapshot?.let {
                    SettingsScreen(
                        snapshot = it,
                        actions = SettingsActions(
                            onOpenThemeSelector = {
                                startActivity(
                                    LegacySettingsNavigation.themeSelectorIntent(this)
                                )
                            },
                            onLauncherIconVisibleChange = { visible ->
                                snapshot = controller.setLauncherIconVisible(visible)
                            },
                            onSoundEnabledChange = { enabled ->
                                snapshot = controller.setSoundEnabled(enabled)
                            },
                            onVolumeCommit = { percent ->
                                snapshot = controller.setVolumePercent(percent)
                            },
                            onVolumeDefault = {
                                snapshot = controller.restoreVolumeDefault()
                            },
                            onVibrationEnabledChange = { enabled ->
                                snapshot = controller.setVibrationEnabled(enabled)
                            },
                            onOneHandedModeChange = { index ->
                                snapshot = controller.setOneHandedModeIndex(index)
                            },
                            onPinyinSchemeChange = { index ->
                                snapshot = controller.setPinyinSchemeIndex(index)
                            },
                            onGestureInputEnabledChange = { enabled ->
                                snapshot = controller.setGestureInputEnabled(enabled)
                            },
                            onBooleanChange = { contract, enabled ->
                                snapshot = controller.setBoolean(contract, enabled)
                            },
                            onVibrationCommit = { milliseconds ->
                                snapshot = controller.setVibrationDuration(milliseconds)
                            },
                            onVibrationDefault = {
                                snapshot = controller.restoreVibrationDefault()
                            },
                            onKeyboardHeightChange = { index ->
                                snapshot = controller.setKeyboardHeightIndex(index)
                            },
                            onSlideSensitivityChange = { index ->
                                snapshot = controller.setSlideSensitivityIndex(index)
                            },
                            onLongPressDelayChange = { milliseconds ->
                                snapshot = controller.setLongPressDelay(milliseconds)
                            },
                            onLongPressDefault = {
                                snapshot = controller.restoreLongPressDefault()
                            },
                            onHandwritingTimeoutChange = { index ->
                                snapshot = controller.setHandwritingTimeoutIndex(index)
                            },
                            onHandwritingStrokeWidthChange = { index ->
                                snapshot = controller.setHandwritingStrokeWidthIndex(index)
                            },
                        ),
                    )
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        snapshot = controller.read()
    }
}

@Composable
private fun ModernSettingsTheme(content: @Composable () -> Unit) {
    val context = LocalContext.current
    val dark = (context.resources.configuration.uiMode and 0x30) == 0x20
    val colors = when {
        Build.VERSION.SDK_INT >= 31 && dark -> dynamicDarkColorScheme(context)
        Build.VERSION.SDK_INT >= 31 -> dynamicLightColorScheme(context)
        dark -> darkColorScheme()
        else -> lightColorScheme()
    }
    MaterialTheme(colorScheme = colors, content = content)
}
