package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class DictionaryOperationsStateTest {
    @Test
    fun challengeRequiresExactlyFourDigits() {
        assertFailsWith<IllegalArgumentException> { DictionaryClearStateReducer.open("123") }
        assertFailsWith<IllegalArgumentException> { DictionaryClearStateReducer.open("12a4") }

        val opened = DictionaryClearStateReducer.open("0042")
        assertTrue(opened.confirmationVisible)
        assertEquals("0042", opened.challenge)
        assertFalse(DictionaryClearStateReducer.canConfirm(opened))
    }

    @Test
    fun inputIsNumericAndBoundedAndOnlyExactMatchConfirms() {
        val opened = DictionaryClearStateReducer.open("0042")
        val filtered = DictionaryClearStateReducer.updateInput(opened, "0a0429")

        assertEquals("0042", filtered.input)
        assertTrue(DictionaryClearStateReducer.canConfirm(filtered))
    }

    @Test
    fun confirmedOperationCannotBeDismissedOrStartedTwice() {
        val confirmed = DictionaryClearStateReducer.updateInput(
            DictionaryClearStateReducer.open("1234"),
            "1234",
        )
        val started = DictionaryClearStateReducer.start(confirmed)

        assertTrue(started.inProgress)
        assertFalse(started.confirmationVisible)
        assertFailsWith<IllegalArgumentException> { DictionaryClearStateReducer.dismiss(started) }
        assertFailsWith<IllegalArgumentException> { DictionaryClearStateReducer.start(started) }
    }

    @Test
    fun cancelAndCompletionDiscardChallengeAndInput() {
        val entered = DictionaryClearStateReducer.updateInput(
            DictionaryClearStateReducer.open("9876"),
            "98",
        )
        assertEquals(DictionaryClearState(), DictionaryClearStateReducer.dismiss(entered))
        assertEquals(DictionaryClearState(), DictionaryClearStateReducer.complete())
    }

    @Test
    fun restoredActivityCanReflectPrimaryDexTaskStateWithoutReopeningDialog() {
        assertEquals(
            DictionaryClearState(inProgress = true),
            DictionaryClearStateReducer.observeInProgress(true),
        )
        assertEquals(DictionaryClearState(), DictionaryClearStateReducer.observeInProgress(false))
    }
}
