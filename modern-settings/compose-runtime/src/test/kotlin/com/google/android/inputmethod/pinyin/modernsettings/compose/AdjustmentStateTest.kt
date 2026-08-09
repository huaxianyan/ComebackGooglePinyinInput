package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertIs
import kotlin.test.assertTrue

class AdjustmentStateTest {
    @Test
    fun systemDefaultUsesLeftmostDisplayWithoutBecomingExplicitZero() {
        val state = AdjustmentStateReducer.fromResolved(
            ResolvedSetting.SystemDefault(effectiveValue = 73),
        )

        assertEquals(0, state.displayedValue)
        assertFalse(state.touched)
        assertIs<AdjustmentEditorState.SystemDefault>(state.persisted)
        assertFalse(AdjustmentStateReducer.canRestoreDefault(state))
    }

    @Test
    fun touchingLeftmostPositionCanCommitExplicitZero() {
        val defaultState = AdjustmentStateReducer.fromResolved(
            ResolvedSetting.SystemDefault(effectiveValue = 73),
        )
        val touched = AdjustmentStateReducer.update(defaultState, 0)
        val committed = AdjustmentStateReducer.commit(touched)

        assertEquals(0, committed.displayedValue)
        assertFalse(committed.touched)
        assertEquals(0, assertIs<AdjustmentEditorState.Explicit>(committed.persisted).value)
        assertTrue(AdjustmentStateReducer.canRestoreDefault(committed))
    }

    @Test
    fun dragUpdatesTransientValueAndReleaseCommitsIt() {
        val initial = AdjustmentStateReducer.fromResolved(
            ResolvedSetting.Explicit(18),
        )
        val dragged = AdjustmentStateReducer.update(initial, 42)

        assertEquals(42, dragged.displayedValue)
        assertTrue(dragged.touched)
        assertEquals(18, assertIs<AdjustmentEditorState.Explicit>(dragged.persisted).value)

        val committed = AdjustmentStateReducer.commit(dragged)
        assertEquals(42, assertIs<AdjustmentEditorState.Explicit>(committed.persisted).value)
        assertFalse(committed.touched)
    }

    @Test
    fun restoreDeletesCustomIdentityAndReturnsDisplayToLeftmost() {
        val explicit = AdjustmentStateReducer.fromResolved(
            ResolvedSetting.Explicit(37),
        )
        val restored = AdjustmentStateReducer.restoreDefault(explicit)

        assertIs<AdjustmentEditorState.SystemDefault>(restored.persisted)
        assertEquals(0, restored.displayedValue)
        assertFalse(restored.touched)
        assertFalse(AdjustmentStateReducer.canRestoreDefault(restored))
    }

    @Test
    fun dependencyOnlyControlsInteractivityWithoutChangingState() {
        val explicit = AdjustmentStateReducer.fromResolved(
            ResolvedSetting.Explicit(37),
        )

        assertFalse(AdjustmentStateReducer.isInteractive(dependencyEnabled = false))
        assertTrue(AdjustmentStateReducer.isInteractive(dependencyEnabled = true))
        assertEquals(37, explicit.displayedValue)
    }

    @Test
    fun reducerRejectsOutOfRangeAndUntouchedCommitOrRestore() {
        val defaultState = AdjustmentStateReducer.fromResolved(
            ResolvedSetting.SystemDefault(effectiveValue = 50),
        )
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.update(defaultState, 101)
        }
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.commit(defaultState)
        }
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.restoreDefault(defaultState)
        }
    }
}
