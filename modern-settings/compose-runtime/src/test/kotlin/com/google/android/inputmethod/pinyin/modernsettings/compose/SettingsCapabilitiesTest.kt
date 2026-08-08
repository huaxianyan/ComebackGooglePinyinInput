package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class SettingsCapabilitiesTest {
    @Test
    fun enabledGoogleVoiceSubtypeIsAvailable() {
        assertTrue(
            SettingsCapabilityResolver.hasEnabledGoogleVoiceSubtype(
                listOf(
                    EnabledImeCapability(
                        packageName = "com.google.android.inputmethod.latin",
                        subtypeModes = listOf("keyboard", "voice"),
                    )
                )
            )
        )
    }

    @Test
    fun packagePrefixModeAndEnabledListMustMatchExactly() {
        assertFalse(
            SettingsCapabilityResolver.hasEnabledGoogleVoiceSubtype(
                listOf(
                    EnabledImeCapability("org.example.voice", listOf("voice")),
                    EnabledImeCapability("com.google.androidish.ime", listOf("keyboard")),
                    EnabledImeCapability("com.google.android.ime", listOf("Voice")),
                )
            )
        )
    }

    @Test
    fun emptyEnabledInputMethodListIsUnavailable() {
        assertFalse(SettingsCapabilityResolver.hasEnabledGoogleVoiceSubtype(emptyList()))
    }

    @Test
    fun ownImeWithMultipleEnabledSubtypesOffersSwitching() {
        assertTrue(
            SettingsCapabilityResolver.hasSettingsActivitySwitchTarget(
                applicationPackageName = "com.example.pinyin",
                inputMethods = listOf(
                    EnabledImeCapability(
                        "com.example.pinyin",
                        listOf("keyboard", "keyboard"),
                    )
                ),
            )
        )
    }

    @Test
    fun otherGoogleImeRequiresANonAuxiliaryEnabledSubtype() {
        assertFalse(
            SettingsCapabilityResolver.hasSettingsActivitySwitchTarget(
                applicationPackageName = "com.example.pinyin",
                inputMethods = listOf(
                    EnabledImeCapability(
                        "com.google.android.inputmethod.voice",
                        listOf("voice"),
                        listOf(true),
                    )
                ),
            )
        )
        assertTrue(
            SettingsCapabilityResolver.hasSettingsActivitySwitchTarget(
                applicationPackageName = "com.example.pinyin",
                inputMethods = listOf(
                    EnabledImeCapability(
                        "com.google.android.inputmethod.latin",
                        listOf("keyboard"),
                        listOf(false),
                    )
                ),
            )
        )
    }

    @Test
    fun nonGoogleOtherImeDoesNotSatisfyLegacyFallback() {
        assertFalse(
            SettingsCapabilityResolver.hasSettingsActivitySwitchTarget(
                applicationPackageName = "com.example.pinyin",
                inputMethods = listOf(
                    EnabledImeCapability("org.example.keyboard", listOf("keyboard"))
                ),
            )
        )
    }
}
