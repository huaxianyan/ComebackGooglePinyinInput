package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertIs

class SliderSettingContractsTest {
    @Test
    fun absentVolumeIsDistinctFromExplicitZero() {
        val absent = SliderSettingContracts.resolveVolume(false, 0f, -1f)
        val zero = SliderSettingContracts.resolveVolume(true, 0f, -1f)

        assertEquals(-1f, assertIs<ResolvedSetting.SystemDefault<Float>>(absent).effectiveValue)
        assertEquals(0f, assertIs<ResolvedSetting.Explicit<Float>>(zero).value)
    }

    @Test
    fun volumeProgressRetainsExactLegacyHundredStepMapping() {
        assertEquals(0f, SliderSettingContracts.encodeVolumePercent(0))
        assertEquals(0.37f, SliderSettingContracts.encodeVolumePercent(37))
        assertEquals(1f, SliderSettingContracts.encodeVolumePercent(100))
        assertEquals(0, SliderSettingContracts.volumePercent(0f))
        assertEquals(37, SliderSettingContracts.volumePercent(0.37f))
        assertEquals(100, SliderSettingContracts.volumePercent(1f))
        assertFailsWith<IllegalArgumentException> {
            SliderSettingContracts.encodeVolumePercent(-1)
        }
        assertFailsWith<IllegalArgumentException> {
            SliderSettingContracts.encodeVolumePercent(101)
        }
    }

    @Test
    fun absentVibrationIsDistinctFromEncodedZero() {
        val absent = SliderSettingContracts.resolveVibration(false, null, -1)
        val zero = SliderSettingContracts.resolveVibration(true, "0", -1)

        assertEquals(-1, assertIs<ResolvedSetting.SystemDefault<Int>>(absent).effectiveValue)
        assertEquals(0, assertIs<ResolvedSetting.Explicit<Int>>(zero).value)
    }

    @Test
    fun vibrationPositiveValuesRetainOriginalPlusOneEncoding() {
        assertEquals("2", SliderSettingContracts.encodeVibration(1))
        assertEquals("9", SliderSettingContracts.encodeVibration(8))
        assertEquals(8, assertIs<ResolvedSetting.Explicit<Int>>(
            SliderSettingContracts.resolveVibration(true, "9", -1)
        ).value)
    }

    @Test
    fun enumeratedSlidersUseExactOriginalOrderAndDefaults() {
        assertEquals(2, SliderSettingContracts.keyboardHeight.indexOf(null))
        assertEquals(4, SliderSettingContracts.keyboardHeight.indexOf("1.1"))
        assertEquals(2, SliderSettingContracts.keyboardHeight.indexOf("invalid"))

        assertEquals(2, SliderSettingContracts.slideSensitivity.indexOf(null))
        assertEquals("0.5", SliderSettingContracts.slideSensitivity.valueAt(4))

        assertEquals(3, SliderSettingContracts.handwritingTimeout.indexOf(null))
        assertEquals("100", SliderSettingContracts.handwritingTimeout.valueAt(6))

        assertEquals(3, SliderSettingContracts.handwritingStrokeWidth.indexOf(null))
        assertEquals("2", SliderSettingContracts.handwritingStrokeWidth.valueAt(6))
    }

    @Test
    fun stagedEnumeratedWritesAcceptOnlyExactInRangeValues() {
        assertEquals("0.9", SliderSettingContracts.keyboardHeight.valueAt(0))
        assertEquals("1.1", SliderSettingContracts.keyboardHeight.valueAt(4))
        assertEquals("3.0", SliderSettingContracts.slideSensitivity.valueAt(0))
        assertEquals("0.5", SliderSettingContracts.slideSensitivity.valueAt(4))
        assertEquals("3000", SliderSettingContracts.handwritingTimeout.valueAt(0))
        assertEquals("100", SliderSettingContracts.handwritingTimeout.valueAt(6))
        assertEquals("0.4", SliderSettingContracts.handwritingStrokeWidth.valueAt(0))
        assertEquals("2", SliderSettingContracts.handwritingStrokeWidth.valueAt(6))
        assertFailsWith<IndexOutOfBoundsException> {
            SliderSettingContracts.keyboardHeight.valueAt(-1)
        }
        assertFailsWith<IndexOutOfBoundsException> {
            SliderSettingContracts.slideSensitivity.valueAt(5)
        }
        assertFailsWith<IndexOutOfBoundsException> {
            SliderSettingContracts.handwritingTimeout.valueAt(7)
        }
        assertFailsWith<IndexOutOfBoundsException> {
            SliderSettingContracts.handwritingStrokeWidth.valueAt(7)
        }
    }

    @Test
    fun deviceDefaultsUseOriginalRegexAndFirstMatchSemantics() {
        val entries = arrayOf(
            "MODEL=Pixel.*:BRAND=google,8",
            "MODEL=Pixel 10 Pro,9",
            ",5",
        )
        val device = mapOf(
            "MODEL" to "Pixel 10 Pro",
            "BRAND" to "google",
            "HARDWARE" to "blazer",
            "MANUFACTURER" to "Google",
        )

        assertEquals("8", LegacySettingsRepository.selectDeviceOverride(entries, device, "-1"))
        assertEquals(
            "5",
            LegacySettingsRepository.selectDeviceOverride(
                entries,
                device + ("MODEL" to "Other"),
                "-1",
            ),
        )
        assertEquals(
            "-1",
            LegacySettingsRepository.selectDeviceOverride(emptyArray(), device, "-1"),
        )
    }

    @Test
    fun longPressAbsentDefaultIsDistinctFromExplicitThreeHundred() {
        val absent = SliderSettingContracts.resolveLongPress(false, null)
        val explicit = SliderSettingContracts.resolveLongPress(true, "300")

        assertEquals(300, assertIs<DefaultableSetting.Default<Int>>(absent).value)
        assertEquals(300, assertIs<DefaultableSetting.Explicit<Int>>(explicit).value)
        assertEquals("100", SliderSettingContracts.encodeLongPress(100))
        assertEquals("700", SliderSettingContracts.encodeLongPress(700))
        assertFailsWith<IllegalArgumentException> {
            SliderSettingContracts.encodeLongPress(305)
        }
        assertFailsWith<IllegalArgumentException> {
            SliderSettingContracts.resolveLongPress(true, "701")
        }
    }

    @Test
    fun longPressMappingIsExactly100To700InTenMillisecondSteps() {
        assertEquals(0, SliderSettingContracts.longPressProgress(100))
        assertEquals(20, SliderSettingContracts.longPressProgress(300))
        assertEquals(60, SliderSettingContracts.longPressProgress(700))
        assertEquals(100, SliderSettingContracts.longPressMilliseconds(0))
        assertEquals(300, SliderSettingContracts.longPressMilliseconds(20))
        assertEquals(700, SliderSettingContracts.longPressMilliseconds(60))
    }
}
