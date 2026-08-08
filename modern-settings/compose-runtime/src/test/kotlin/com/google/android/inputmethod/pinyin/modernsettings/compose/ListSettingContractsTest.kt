package com.google.android.inputmethod.pinyin.modernsettings.compose

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class ListSettingContractsTest {
    private val contract = ListSettingContracts.pinyinScheme

    @Test
    fun oneHandedModePreservesExactLegacyKeyDefaultAndOrder() {
        val oneHandedMode = ListSettingContracts.oneHandedMode
        assertEquals("one_handed_mode", oneHandedMode.key)
        assertEquals("0", oneHandedMode.defaultValue)
        assertEquals(listOf("0", "1", "2"), oneHandedMode.values)
        assertEquals(0, oneHandedMode.indexOf(null))
    }

    @Test
    fun pinyinSchemePreservesExactLegacyKeyDefaultAndOrder() {
        assertEquals("pinyin_scheme", contract.key)
        assertEquals("quanpin", contract.defaultValue)
        assertEquals(
            listOf(
                "quanpin",
                "shuangpin_ms",
                "shuangpin_ziguang",
                "shuangpin_jiajia",
                "shuangpin_abc",
                "shuangpin_ziranma",
                "shuangpin_flypy",
            ),
            contract.values,
        )
    }

    @Test
    fun absentValueUsesFullPinyinDefault() {
        assertEquals(0, contract.indexOf(null))
    }

    @Test
    fun unsupportedValueAndIndexAreRejected() {
        assertFailsWith<IllegalArgumentException> { contract.indexOf("unknown") }
        assertFailsWith<IllegalArgumentException> { contract.valueAt(-1) }
        assertFailsWith<IllegalArgumentException> { contract.valueAt(contract.values.size) }
    }
}
