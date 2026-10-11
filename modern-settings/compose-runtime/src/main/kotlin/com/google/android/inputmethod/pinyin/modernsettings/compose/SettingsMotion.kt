package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.animation.ContentTransform
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.LayoutDirection
import kotlin.math.abs
import kotlin.math.roundToInt

/** Activity-like layering inspired by Pixel Text's Apache-2.0 navigation.
 * Values live in settings_motion.xml and also drive framework Activity motion.
 */
internal class SettingsMotion(
    private val foreground: Int,
    private val background: Int,
    private val fade: Int,
    private val backgroundFadeDelay: Int,
    private val foregroundFadeDelay: Int,
    private val foregroundOffset: Float,
    private val backgroundOffset: Float,
    private val entryScale: Float,
    private val exitScale: Float,
    private val backgroundScale: Float,
) {
    fun transition(direction: SettingsNavigationDirection, layout: LayoutDirection): ContentTransform {
        if (direction == SettingsNavigationDirection.None) {
            return EnterTransition.None togetherWith ExitTransition.None
        }
        val sign = if (layout == LayoutDirection.Ltr) 1 else -1
        val returning = direction == SettingsNavigationDirection.Backward
        val incomingDuration = if (returning) background else foreground
        val outgoingDuration = if (returning) foreground else background
        val incomingOffset = if (returning) -abs(backgroundOffset) else abs(foregroundOffset)
        val outgoingOffset = if (returning) abs(foregroundOffset) else -abs(backgroundOffset)
        val transform = (
            slideInHorizontally(tween(incomingDuration, easing = FastOutSlowInEasing)) {
                (it * incomingOffset * sign).roundToInt()
            } + fadeIn(tween(fade)) + scaleIn(
                initialScale = if (returning) backgroundScale else entryScale,
                animationSpec = tween(incomingDuration, easing = FastOutSlowInEasing),
            )
        ) togetherWith (
            slideOutHorizontally(tween(outgoingDuration, easing = FastOutSlowInEasing)) {
                (it * outgoingOffset * sign).roundToInt()
            } + fadeOut(tween(fade, delayMillis = if (returning) foregroundFadeDelay else backgroundFadeDelay)) +
                scaleOut(
                    targetScale = if (returning) exitScale else backgroundScale,
                    animationSpec = tween(outgoingDuration, easing = FastOutSlowInEasing),
                )
        )
        transform.targetContentZIndex = if (returning) -1f else 1f
        return transform
    }
}

@Composable
internal fun rememberSettingsMotion(): SettingsMotion {
    val context = LocalContext.current
    val configuration = LocalConfiguration.current
    return remember(context, configuration) {
        val r = context.resources
        SettingsMotion(
            r.getInteger(R.integer.settings_motion_foreground_duration),
            r.getInteger(R.integer.settings_motion_background_duration),
            r.getInteger(R.integer.settings_motion_fade_duration),
            r.getInteger(R.integer.settings_motion_background_fade_delay),
            r.getInteger(R.integer.settings_motion_foreground_fade_delay),
            r.getFraction(R.fraction.settings_motion_foreground_offset, 1, 1),
            r.getFraction(R.fraction.settings_motion_background_offset, 1, 1),
            r.getFraction(R.fraction.settings_motion_foreground_entry_scale, 1, 1),
            r.getFraction(R.fraction.settings_motion_foreground_exit_scale, 1, 1),
            r.getFraction(R.fraction.settings_motion_background_scale, 1, 1),
        )
    }
}
