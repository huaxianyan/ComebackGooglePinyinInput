package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Persisted identity remains distinct even when system-default and explicit zero share a position. */
sealed interface AdjustmentEditorState {
    data object SystemDefault : AdjustmentEditorState
    data class Explicit(val value: Int) : AdjustmentEditorState
}

data class AdjustmentInteractionState(
    val persisted: AdjustmentEditorState,
    val displayedValue: Int,
    val touched: Boolean = false,
)

/** Pure reducer; persistence and one-shot previews remain outside this type. */
object AdjustmentStateReducer {
    fun fromResolved(setting: ResolvedSetting<Int>): AdjustmentInteractionState = when (setting) {
        is ResolvedSetting.SystemDefault -> AdjustmentInteractionState(
            persisted = AdjustmentEditorState.SystemDefault,
            displayedValue = 0,
        )
        is ResolvedSetting.Explicit -> AdjustmentInteractionState(
            persisted = AdjustmentEditorState.Explicit(validate(setting.value)),
            displayedValue = setting.value,
        )
    }

    fun update(
        state: AdjustmentInteractionState,
        value: Int,
    ): AdjustmentInteractionState = state.copy(
        displayedValue = validate(value),
        touched = true,
    )

    fun commit(state: AdjustmentInteractionState): AdjustmentInteractionState {
        require(state.touched)
        val value = validate(state.displayedValue)
        return AdjustmentInteractionState(
            persisted = AdjustmentEditorState.Explicit(value),
            displayedValue = value,
        )
    }

    fun restoreDefault(state: AdjustmentInteractionState): AdjustmentInteractionState {
        require(canRestoreDefault(state))
        return AdjustmentInteractionState(
            persisted = AdjustmentEditorState.SystemDefault,
            displayedValue = 0,
        )
    }

    fun canRestoreDefault(state: AdjustmentInteractionState): Boolean =
        state.touched || state.persisted is AdjustmentEditorState.Explicit

    fun isInteractive(dependencyEnabled: Boolean): Boolean = dependencyEnabled

    private fun validate(value: Int): Int {
        require(value in 0..100)
        return value
    }
}
