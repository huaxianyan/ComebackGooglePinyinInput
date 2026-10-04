package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.os.Handler
import android.os.Looper
import android.widget.ImageView
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView

/**
 * Renders the keyboard a theme would produce.
 *
 * The picture comes from the engine renderer through [ThemePreviewBridge], so it
 * matches what the theme actually looks like rather than approximating it.
 *
 * [keyBorder] is both a render input and the reason a render has to be repeated:
 * the renderer draws the border the caller asks for, so changing it is a change
 * of subject even though the theme has not moved. A change to it redraws in
 * place - the picture already on screen stays until the new one is ready - so
 * toggling the switch does not blank and resize the sheet on every tap.
 *
 * Nothing is drawn when the renderer is unavailable or no theme is given. A
 * preview is decoration, so the inventory stays readable without it instead of
 * reserving space for an empty frame.
 *
 * No page padding is baked in: the sheet decides how wide the preview is, and
 * the modes that show a pair put two of these side by side inside one padded
 * row.
 */
@Composable
internal fun ThemePreview(
    themeValue: String,
    modifier: Modifier = Modifier,
    keyBorder: Boolean = false,
) {
    val context = LocalContext.current
    val available = remember(context) { ThemePreviewBridge.isAvailable(context) }
    if (!available || themeValue.isEmpty()) return

    val imageView = remember(context) {
        ImageView(context).apply {
            scaleType = ImageView.ScaleType.FIT_CENTER
            adjustViewBounds = true
        }
    }
    val mainHandler = remember { Handler(Looper.getMainLooper()) }
    var canceler by remember { mutableStateOf<ThemePreviewBridge.Canceler?>(null) }

    LaunchedEffect(themeValue, keyBorder) {
        // A different theme means the picture on screen belongs to a theme that
        // is no longer the subject, so it goes. The key-border switch keeps the
        // same theme, and clearing there is what made the sheet flash: with
        // `adjustViewBounds` and no picture, the view collapses to its minimum
        // height, so every toggle resized the sheet and grew it back. Holding
        // the old picture until the new one arrives keeps the layout still.
        if (imageView.tag != themeValue) {
            imageView.setImageDrawable(null)
        }
        canceler?.cancel()
        canceler = ThemePreviewBridge.render(context, themeValue, keyBorder) { drawable ->
            mainHandler.post {
                // Recorded on delivery, not on request, so a render that never
                // answers cannot leave the view marked as showing this theme.
                imageView.tag = themeValue
                imageView.setImageDrawable(drawable)
            }
        }
    }

    // Keyed on nothing on purpose. Keyed on the render inputs it would dispose
    // on every toggle and cancel the request the effect above had just started,
    // which is the other half of the flashing.
    DisposableEffect(Unit) {
        onDispose {
            canceler?.cancel()
            canceler = null
        }
    }

    AndroidView(
        factory = { imageView },
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = 120.dp),
    )
}
