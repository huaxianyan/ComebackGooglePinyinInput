package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Test
import kotlin.test.assertEquals
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
    fun longPressMappingIsExactly100To700InTenMillisecondSteps() {
        assertEquals(0, SliderSettingContracts.longPressProgress(100))
        assertEquals(20, SliderSettingContracts.longPressProgress(300))
        assertEquals(60, SliderSettingContracts.longPressProgress(700))
        assertEquals(100, SliderSettingContracts.longPressMilliseconds(0))
        assertEquals(300, SliderSettingContracts.longPressMilliseconds(20))
        assertEquals(700, SliderSettingContracts.longPressMilliseconds(60))
    }
}
