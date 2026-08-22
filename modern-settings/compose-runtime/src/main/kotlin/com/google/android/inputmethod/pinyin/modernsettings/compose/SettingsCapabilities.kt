package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.os.Build
import android.os.Vibrator
import android.view.inputmethod.InputMethodManager

data class SettingsCapabilities(
    val popupOnKeypressVisible: Boolean,
    val voiceInputVisible: Boolean,
    val vibrationControlsVisible: Boolean,
    val oneHandedModeVisible: Boolean,
    val emojiSwitchKeyVisible: Boolean,
    val inputMethodSwitchingAvailable: Boolean,
)

internal data class EnabledImeCapability(
    val packageName: String,
    val subtypeModes: List<String>,
    val subtypeAuxiliary: List<Boolean> = List(subtypeModes.size) { false },
) {
    init {
        require(subtypeModes.size == subtypeAuxiliary.size)
    }
}

object SettingsCapabilityResolver {
    fun resolve(context: Context): SettingsCapabilities {
        val resources = context.resources
        val isTabletId = resources.getIdentifier("is_tablet", "bool", context.packageName)
        val isTablet = isTabletId != 0 && resources.getBoolean(isTabletId)
        val inputMethods = enabledInputMethods(context)
        val vibratorService = context.getSystemService(Vibrator::class.java)
        return SettingsCapabilities(
            popupOnKeypressVisible = !isTablet,
            voiceInputVisible = hasEnabledVoiceSubtype(inputMethods),
            vibrationControlsVisible = vibrationControlsVisible(
                serviceIsVibrator = vibratorService != null,
                hasVibrator = vibratorService?.hasVibrator() == true,
            ),
            oneHandedModeVisible = !isTablet,
            emojiSwitchKeyVisible = Build.VERSION.SDK_INT >= 19 && !isTablet,
            inputMethodSwitchingAvailable = hasSettingsActivitySwitchTarget(
                applicationPackageName = context.packageName,
                inputMethods = inputMethods,
            ),
        )
    }

    internal fun vibrationControlsVisible(
        serviceIsVibrator: Boolean,
        hasVibrator: Boolean,
    ): Boolean = serviceIsVibrator && hasVibrator

    internal fun hasEnabledGoogleVoiceSubtype(
        inputMethods: Iterable<EnabledImeCapability>,
    ): Boolean = inputMethods.any { inputMethod ->
        inputMethod.packageName.startsWith("com.google.android") &&
            inputMethod.subtypeModes.any { it == "voice" }
    }

    internal fun hasEnabledVoiceSubtype(
        inputMethods: Iterable<EnabledImeCapability>,
    ): Boolean = inputMethods.any { inputMethod ->
        inputMethod.subtypeModes.any { it == "voice" }
    }

    internal fun hasSettingsActivitySwitchTarget(
        applicationPackageName: String,
        inputMethods: Iterable<EnabledImeCapability>,
    ): Boolean {
        val methods = inputMethods.toList()
        val ownMethod = methods.firstOrNull { it.packageName == applicationPackageName }
        if (ownMethod != null && ownMethod.subtypeModes.size > 1) return true
        return methods.any { method ->
            method.packageName != applicationPackageName &&
                method.packageName.startsWith("com.google.") &&
                method.subtypeAuxiliary.any { auxiliary -> !auxiliary }
        }
    }

    private fun enabledInputMethods(context: Context): List<EnabledImeCapability> = try {
        val manager = context.getSystemService(Context.INPUT_METHOD_SERVICE)
            as InputMethodManager
        manager.enabledInputMethodList.map { inputMethod ->
            val subtypes = manager.getEnabledInputMethodSubtypeList(inputMethod, true)
            EnabledImeCapability(
                packageName = inputMethod.component.packageName,
                subtypeModes = subtypes.map { it.mode },
                subtypeAuxiliary = subtypes.map { it.isAuxiliary },
            )
        }
    } catch (_: Exception) {
        emptyList()
    }
}
