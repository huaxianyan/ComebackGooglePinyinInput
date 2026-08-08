package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.view.inputmethod.InputMethodManager

data class SettingsCapabilities(
    val popupOnKeypressVisible: Boolean,
    val voiceInputVisible: Boolean,
    val oneHandedModeVisible: Boolean,
)

internal data class EnabledImeCapability(
    val packageName: String,
    val subtypeModes: List<String>,
)

object SettingsCapabilityResolver {
    fun resolve(context: Context): SettingsCapabilities {
        val resources = context.resources
        val isTabletId = resources.getIdentifier("is_tablet", "bool", context.packageName)
        val isTablet = isTabletId != 0 && resources.getBoolean(isTabletId)
        return SettingsCapabilities(
            popupOnKeypressVisible = !isTablet,
            voiceInputVisible = hasEnabledGoogleVoiceSubtype(context),
            oneHandedModeVisible = !isTablet,
        )
    }

    internal fun hasEnabledGoogleVoiceSubtype(
        inputMethods: Iterable<EnabledImeCapability>,
    ): Boolean = inputMethods.any { inputMethod ->
        inputMethod.packageName.startsWith("com.google.android") &&
            inputMethod.subtypeModes.any { it == "voice" }
    }

    private fun hasEnabledGoogleVoiceSubtype(context: Context): Boolean = try {
        val manager = context.getSystemService(Context.INPUT_METHOD_SERVICE)
            as InputMethodManager
        hasEnabledGoogleVoiceSubtype(
            manager.enabledInputMethodList.map { inputMethod ->
                EnabledImeCapability(
                    packageName = inputMethod.component.packageName,
                    subtypeModes = manager.getEnabledInputMethodSubtypeList(
                        inputMethod,
                        true,
                    ).map { it.mode },
                )
            }
        )
    } catch (_: Exception) {
        false
    }
}
