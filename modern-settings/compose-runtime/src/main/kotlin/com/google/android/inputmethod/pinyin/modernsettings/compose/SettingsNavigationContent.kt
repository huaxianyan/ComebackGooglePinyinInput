package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.activity.compose.PredictiveBackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.SeekableTransitionState
import androidx.compose.animation.core.rememberTransition
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.platform.LocalLayoutDirection
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.isActive

private enum class SettingsBackPhase { Idle, Gesture, Settling }
internal val LocalSettingsNavigationActive = compositionLocalOf { true }

/** One renderer/lifetime for normal navigation, Back buttons and predictive Back. */
@Composable
internal fun <T : Any> SettingsNavigationContent(
    state: T,
    previous: T?,
    onNavigateBack: () -> Unit,
    direction: (T, T) -> SettingsNavigationDirection,
    content: @Composable (T) -> Unit,
) {
    val active = LocalSettingsNavigationActive.current
    val motion = rememberSettingsMotion()
    val layoutDirection = LocalLayoutDirection.current
    val latestState by rememberUpdatedState(state)
    val transitionState = remember { SeekableTransitionState(state) }
    val transition = rememberTransition(transitionState, label = "settings-navigation")
    var backPhase by remember { mutableStateOf(SettingsBackPhase.Idle) }
    LaunchedEffect(state, backPhase) {
        if (backPhase != SettingsBackPhase.Gesture) {
            transitionState.animateTo(state)
            backPhase = SettingsBackPhase.Idle
        }
    }
    PredictiveBackHandler(enabled = active && previous != null) { progress ->
        val origin = state
        val destination = previous ?: return@PredictiveBackHandler
        backPhase = SettingsBackPhase.Gesture
        try {
            transitionState.snapTo(origin)
            progress.collect { transitionState.seekTo(it.progress, destination) }
            transitionState.animateTo(destination)
            if (latestState == origin) onNavigateBack()
        } catch (cancelled: CancellationException) {
            if (!currentCoroutineContext().isActive) throw cancelled
            transitionState.animateTo(origin)
        } finally {
            backPhase = SettingsBackPhase.Settling
        }
    }
    transition.AnimatedContent(
        modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.surface).clipToBounds(),
        transitionSpec = { motion.transition(direction(initialState, targetState), layoutDirection) },
    ) { target ->
        CompositionLocalProvider(LocalSettingsNavigationActive provides (active && target == state)) {
            content(target)
        }
    }
}
