package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.os.Handler
import android.os.Looper
import android.widget.ImageView
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
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
 * [renderKey] is any value that should force a fresh render without changing
 * the theme: the key-border switch uses it, because the renderer reads that
 * preference itself and would otherwise answer from a picture it already drew.
 *
 * Nothing is drawn when the renderer is unavailable or no theme is given. A
 * preview is decoration, so the inventory stays readable without it instead of
 * reserving space for an empty frame.
 */
@Composable
internal fun ThemePreview(
    themeValue: String,
    modifier: Modifier = Modifier,
    renderKey: Any = Unit,
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

    LaunchedEffect(themeValue, renderKey) {
        canceler?.cancel()
        canceler = null
        imageView.setImageDrawable(null)
        canceler = ThemePreviewBridge.render(context, themeValue) { drawable ->
            mainHandler.post { imageView.setImageDrawable(drawable) }
        }
    }

    DisposableEffect(themeValue, renderKey) {
        onDispose {
            canceler?.cancel()
            canceler = null
        }
    }

    AndroidView(
        factory = { imageView },
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = 120.dp)
            .padding(horizontal = 16.dp),
    )
}
