package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class LicensesTest {
    private val body = "0123456789abcdefghij".toByteArray(Charsets.UTF_8)

    @Test
    fun sliceIsTakenFromTheByteOffsetsTheLineNames() {
        val entry = parseLicenseLine("3:4 latinime", body)

        assertEquals("latinime", entry?.name)
        assertEquals("3456", entry?.text)
    }

    @Test
    fun nameKeepsItsOwnSpaces() {
        val entry = parseLicenseLine("0:5 Eigen 3", body)

        assertEquals("Eigen 3", entry?.name)
    }

    @Test
    fun unusableLinesAreDroppedRatherThanThrown() {
        assertNull(parseLicenseLine("", body))
        assertNull(parseLicenseLine("latinime", body))
        assertNull(parseLicenseLine("3 latinime", body))
        assertNull(parseLicenseLine(":4 latinime", body))
        assertNull(parseLicenseLine("3: latinime", body))
        assertNull(parseLicenseLine("3:4 ", body))
        assertNull(parseLicenseLine("0:0 latinime", body))
        // The slice would run past the end of the body.
        assertNull(parseLicenseLine("18:4 latinime", body))
    }
}
