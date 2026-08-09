package com.google.android.inputmethod.pinyin.modernsettings.compose

/** Transient presentation state; the destructive operation remains in primary DEX. */
data class DictionaryClearState(
    val confirmationVisible: Boolean = false,
    val challenge: String = "",
    val input: String = "",
    val inProgress: Boolean = false,
)

internal object DictionaryClearStateReducer {
    fun open(challenge: String): DictionaryClearState {
        require(challenge.length == 4 && challenge.all(Char::isDigit))
        return DictionaryClearState(
            confirmationVisible = true,
            challenge = challenge,
        )
    }

    fun updateInput(state: DictionaryClearState, input: String): DictionaryClearState {
        require(state.confirmationVisible && !state.inProgress)
        return state.copy(input = input.filter(Char::isDigit).take(4))
    }

    fun canConfirm(state: DictionaryClearState): Boolean =
        state.confirmationVisible && !state.inProgress && state.input == state.challenge

    fun dismiss(state: DictionaryClearState): DictionaryClearState {
        require(!state.inProgress)
        return DictionaryClearState()
    }

    fun start(state: DictionaryClearState): DictionaryClearState {
        require(canConfirm(state))
        return DictionaryClearState(inProgress = true)
    }

    fun observeInProgress(inProgress: Boolean): DictionaryClearState =
        DictionaryClearState(inProgress = inProgress)

    fun complete(): DictionaryClearState = DictionaryClearState()
}
