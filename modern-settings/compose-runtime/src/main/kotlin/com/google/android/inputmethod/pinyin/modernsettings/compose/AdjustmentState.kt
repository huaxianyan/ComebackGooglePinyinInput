package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Pure state model for a nullable system-default adjustment. */
sealed interface AdjustmentEditorState {
    data object SystemDefault : AdjustmentEditorState
    data class EditingDraft(val value: Int, val touched: Boolean) : AdjustmentEditorState
    data class Explicit(val value: Int) : AdjustmentEditorState
}

/** Pure reducer; persistence and previews are deliberately outside this type. */
object AdjustmentStateReducer {
    fun fromResolved(setting: ResolvedSetting<Int>): AdjustmentEditorState = when (setting) {
        is ResolvedSetting.SystemDefault -> AdjustmentEditorState.SystemDefault
        is ResolvedSetting.Explicit -> AdjustmentEditorState.Explicit(validate(setting.value))
    }

    fun startCustom(state: AdjustmentEditorState): AdjustmentEditorState.EditingDraft {
        require(state is AdjustmentEditorState.SystemDefault)
        return AdjustmentEditorState.EditingDraft(value = 0, touched = false)
    }

    fun updateDraft(
        state: AdjustmentEditorState,
        value: Int,
    ): AdjustmentEditorState.EditingDraft {
        require(state is AdjustmentEditorState.EditingDraft)
        return AdjustmentEditorState.EditingDraft(validate(value), touched = true)
    }

    fun cancelDraft(state: AdjustmentEditorState): AdjustmentEditorState.SystemDefault {
        require(state is AdjustmentEditorState.EditingDraft)
        return AdjustmentEditorState.SystemDefault
    }

    fun applyDraft(state: AdjustmentEditorState): AdjustmentEditorState.Explicit {
        require(state is AdjustmentEditorState.EditingDraft && state.touched)
        return AdjustmentEditorState.Explicit(validate(state.value))
    }

    fun updateExplicit(
        state: AdjustmentEditorState,
        value: Int,
    ): AdjustmentEditorState.Explicit {
        require(state is AdjustmentEditorState.Explicit)
        return AdjustmentEditorState.Explicit(validate(value))
    }

    fun restoreDefault(state: AdjustmentEditorState): AdjustmentEditorState.SystemDefault {
        require(state is AdjustmentEditorState.Explicit)
        return AdjustmentEditorState.SystemDefault
    }

    fun isInteractive(state: AdjustmentEditorState, dependencyEnabled: Boolean): Boolean =
        dependencyEnabled && state !is AdjustmentEditorState.SystemDefault

    private fun validate(value: Int): Int {
        require(value in 0..100)
        return value
    }
}
