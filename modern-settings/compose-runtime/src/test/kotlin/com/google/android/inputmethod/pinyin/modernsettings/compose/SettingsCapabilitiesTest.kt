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
}
