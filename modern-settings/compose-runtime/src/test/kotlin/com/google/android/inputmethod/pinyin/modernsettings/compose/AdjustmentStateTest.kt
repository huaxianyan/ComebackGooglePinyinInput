package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertIs
import kotlin.test.assertTrue

class AdjustmentStateTest {
    @Test
    fun untouchedDraftCannotBecomeExplicitZero() {
        val draft = AdjustmentStateReducer.startCustom(AdjustmentEditorState.SystemDefault)

        assertEquals(0, draft.value)
        assertFalse(draft.touched)
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.applyDraft(draft)
        }
    }

    @Test
    fun touchedDraftCanApplyExplicitZeroWithoutCollapsingToDefault() {
        val draft = AdjustmentStateReducer.updateDraft(
            AdjustmentStateReducer.startCustom(AdjustmentEditorState.SystemDefault),
            0,
        )
        val applied = AdjustmentStateReducer.applyDraft(draft)

        assertEquals(0, applied.value)
        assertIs<AdjustmentEditorState.Explicit>(applied)
    }

    @Test
    fun cancelDiscardsDraftAndRestoreReturnsToDefault() {
        val draft = AdjustmentStateReducer.updateDraft(
            AdjustmentStateReducer.startCustom(AdjustmentEditorState.SystemDefault),
            42,
        )
        assertIs<AdjustmentEditorState.SystemDefault>(
            AdjustmentStateReducer.cancelDraft(draft)
        )

        val explicit = AdjustmentStateReducer.applyDraft(draft)
        assertIs<AdjustmentEditorState.SystemDefault>(
            AdjustmentStateReducer.restoreDefault(explicit)
        )
    }

    @Test
    fun dependencyDisableRetainsExplicitValueButBlocksInteraction() {
        val explicit = AdjustmentEditorState.Explicit(37)

        assertFalse(AdjustmentStateReducer.isInteractive(explicit, dependencyEnabled = false))
        assertTrue(AdjustmentStateReducer.isInteractive(explicit, dependencyEnabled = true))
        assertEquals(37, explicit.value)
    }

    @Test
    fun reducerRejectsOutOfRangeValuesAndInvalidTransitions() {
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.updateDraft(
                AdjustmentEditorState.EditingDraft(0, false),
                101,
            )
        }
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.startCustom(AdjustmentEditorState.Explicit(50))
        }
        assertFailsWith<IllegalArgumentException> {
            AdjustmentStateReducer.restoreDefault(AdjustmentEditorState.SystemDefault)
        }
    }
}
