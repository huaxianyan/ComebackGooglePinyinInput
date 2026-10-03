package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.view.View
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.graphics.drawscope.clipRect
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView

/** Corner radius every tile on the theme page shares. */
private val TileShape = RoundedCornerShape(12.dp)

/**
 * One theme tile.
 *
 * The picture inside is the theme's own palette drawn flat: the keyboard's body
 * colour, the space bar's lighter accent and the action key's accent dot. It is
 * not a picture of the keyboard, because at tile size a keyboard reads as a
 * smudge of keys rather than as a colour. A theme the packaged layouts cannot
 * draw falls back to a flat surface rather than an empty hole.
 *
 * [label] is the caption the Defaults row needs to tell its four modes apart.
 * Themes in the other sections carry no caption, because the picture says it.
 */
@Composable
internal fun ThemeTile(
    themeValue: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
) {
    Column(modifier = modifier.fillMaxWidth()) {
        ThemeSwatchSurface(
            themeValue = themeValue,
            selected = selected,
            onClick = onClick,
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(THEME_CELL_ASPECT),
        )
        TileLabel(text = label, selected = selected)
    }
}

/**
 * The tile for dynamic colour.
 *
 * Drawn here rather than from a theme package, because there is no package to
 * read until the mode is switched on: the compatibility bridge writes the
 * palette out of the system colours the first time it is enabled. Showing the
 * swatch of a package that does not exist yet is what made this tile come out
 * dark and wrong, so it shows the mode's symbol instead, the way Gboard does.
 */
@Composable
internal fun DynamicColorTile(
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(THEME_CELL_ASPECT)
                .clip(TileShape)
                .background(MaterialTheme.colorScheme.surfaceVariant)
                .clickable(onClick = onClick),
            contentAlignment = Alignment.Center,
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    // `surface` rather than another container tone: the two
                    // container tones can resolve to the same colour under a
                    // dynamic palette, which left the circle invisible.
                    .background(MaterialTheme.colorScheme.surface),
                contentAlignment = Alignment.Center,
            ) {
                Icon(
                    imageVector = Icons.Filled.Check,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.size(24.dp),
                )
            }
        }
        TileLabel(text = label, selected = selected)
    }
}

/** The caption under a tile, or nothing when the tile carries none. */
@Composable
private fun TileLabel(text: String?, selected: Boolean) {
    if (text == null) return
    Text(
        text = text,
        style = MaterialTheme.typography.bodyMedium,
        color = if (selected) {
            MaterialTheme.colorScheme.onSurface
        } else {
            MaterialTheme.colorScheme.onSurfaceVariant
        },
        textAlign = TextAlign.Center,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis,
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 6.dp),
    )
}

/**
 * The tile that adds a theme of your own.
 *
 * Drawn here rather than inflated, because it is not a theme: there is nothing
 * for the legacy sample layouts to render.
 */
@Composable
internal fun AddThemeTile(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(THEME_CELL_ASPECT)
                .clip(TileShape)
                .border(1.dp, MaterialTheme.colorScheme.outline, TileShape)
                .clickable(onClick = onClick),
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                imageVector = Icons.Filled.Add,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.height(28.dp),
            )
        }
        TileLabel(text = label, selected = false)
    }
}

/**
 * The tile for following the system light or dark mode.
 *
 * Two themes in one frame, split down the middle: the light one on the left,
 * the dark one on the right. That is the whole point of the mode, and a single
 * theme's picture could not show it.
 */
@Composable
internal fun SplitThemeTile(
    lightValue: String,
    darkValue: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(THEME_CELL_ASPECT)
                .clip(TileShape)
                .clickable(onClick = onClick),
        ) {
            // Both swatches are drawn at the full tile size and stacked, each
            // clipped to its own half. Sizing them to half the tile instead
            // would put a second space bar and a second accent dot inside each
            // half; clipping keeps the one of each that the mode's tile shows.
            SplitHalf(
                themeValue = lightValue,
                selected = selected,
                leftHalf = true,
                modifier = Modifier.fillMaxSize(),
            )
            SplitHalf(
                themeValue = darkValue,
                selected = selected,
                leftHalf = false,
                modifier = Modifier.fillMaxSize(),
            )
        }
        TileLabel(text = label, selected = selected)
    }
}

/**
 * Half of [SplitThemeTile].
 *
 * The clip happens while drawing rather than through a smaller layout box,
 * because the swatch has to be laid out at the full tile size for its space bar
 * and accent dot to land where they do on the single tiles. A layout box of half
 * the width would also change what the swatch measures, which is not something
 * this composable can control from the outside.
 */
@Composable
private fun SplitHalf(
    themeValue: String,
    selected: Boolean,
    leftHalf: Boolean,
    modifier: Modifier = Modifier,
) {
    val context = LocalContext.current
    AndroidView(
        factory = {
            ThemePreviewBridge.inflateThemeSwatch(context, themeValue)
                ?: View(context)
        },
        update = { card -> ThemePreviewBridge.markSelected(card, selected) },
        modifier = modifier.clipToHalf(leftHalf),
    )
}

/** Keeps only the left or the right half of whatever is drawn. */
private fun Modifier.clipToHalf(left: Boolean): Modifier = drawWithContent {
    val half = size.width / 2f
    clipRect(
        left = if (left) 0f else half,
        top = 0f,
        right = if (left) half else size.width,
        bottom = size.height,
    ) {
        this@drawWithContent.drawContent()
    }
}

/**
 * The flat swatch for one theme.
 *
 * Keyed on the value because the inflated view is fixed once built: a new theme
 * has to mean a new view, even if the grid reuses the slot.
 */
@Composable
private fun ThemeSwatchSurface(
    themeValue: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val context = LocalContext.current
    val currentOnClick by rememberUpdatedState(onClick)
    key(themeValue) {
        AndroidView(
            factory = {
                val swatch = ThemePreviewBridge.inflateThemeSwatch(context, themeValue)
                    ?: View(context)
                swatch.setOnClickListener { currentOnClick() }
                swatch
            },
            update = { swatch -> ThemePreviewBridge.markSelected(swatch, selected) },
            modifier = modifier
                .clip(TileShape)
                .background(MaterialTheme.colorScheme.surfaceVariant),
        )
    }
}
