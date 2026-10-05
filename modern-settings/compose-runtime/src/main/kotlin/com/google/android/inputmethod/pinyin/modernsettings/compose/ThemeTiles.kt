package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.view.View
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
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

/** Width of the hairline every theme tile carries. */
private val TileBorderWidth = 1.dp

/**
 * The hairline that marks where a theme tile ends.
 *
 * A palette taken from the system - which is what the dynamic mode is, by
 * definition - is derived from the very surface the tile is drawn on, so its
 * body colour lands on the page colour and the tile has no visible edge at all.
 * Every other palette can do the same by accident. The line is what says the
 * picture stops here, so a tile reads as a tile rather than as a patch of the
 * page behind it.
 *
 * Laid over the content rather than under it, because the swatch is opaque and
 * full-bleed: a border drawn first would never be seen. `outlineVariant` rather
 * than `outline` because this is an edge, not a control - it has to be there
 * without competing with the palette inside it.
 *
 * Carries no click handling of its own, so a tap passes through it to whatever
 * the tile put underneath.
 */
@Composable
private fun BoxScope.TileBorder() {
    Box(
        modifier = Modifier
            .matchParentSize()
            .border(TileBorderWidth, MaterialTheme.colorScheme.outlineVariant, TileShape),
    )
}

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
 * Once the palette package exists this is an ordinary swatch, drawn down the
 * same path as every other tile, because the mode produces an ordinary theme:
 * the keyboard's own body colour with the space bar and the accent dot on top.
 * Showing a symbol instead was a guess at what the mode would look like, and a
 * wrong one - the palette is what the tile is for.
 *
 * The tick is not drawn here either. A check in the tile's resting state reads
 * as "already on", so selection is left to the same indicator the other tiles
 * use, which only appears when the mode is the one in effect.
 *
 * [themeValue] is null only when the platform has no palette to build from, in
 * which case the tile falls back to a flat surface rather than an empty hole.
 */
@Composable
internal fun DynamicColorTile(
    themeValue: String?,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
) {
    if (themeValue != null) {
        ThemeTile(
            themeValue = themeValue,
            selected = selected,
            onClick = onClick,
            modifier = modifier,
            label = label,
        )
        return
    }
    Column(modifier = modifier.fillMaxWidth()) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(THEME_CELL_ASPECT)
                .clip(TileShape)
                .background(MaterialTheme.colorScheme.surfaceVariant)
                .clickable(onClick = onClick),
        ) {
            TileBorder()
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
            TileBorder()
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
 *
 * Keyed on the value for the same reason [ThemeSwatchSurface] is: the inflated
 * card is fixed once built, and `AndroidView`'s factory runs only on the first
 * composition. Without the key a slot the user repoints would keep drawing the
 * theme the page was opened with, which is what made assigning a light or dark
 * theme look like it had not taken - the assignment had landed, and the half
 * showing it had not been rebuilt.
 */
@Composable
private fun SplitHalf(
    themeValue: String,
    selected: Boolean,
    leftHalf: Boolean,
    modifier: Modifier = Modifier,
) {
    val context = LocalContext.current
    key(themeValue) {
        AndroidView(
            factory = {
                ThemePreviewBridge.inflateThemeSwatch(context, themeValue)
                    ?: View(context)
            },
            update = { card -> ThemePreviewBridge.markSelected(card, selected) },
            modifier = modifier.clipToHalf(leftHalf),
        )
    }
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
 *
 * The card sits in a box rather than carrying the size itself. The card is
 * opaque and full-bleed, so the hairline has to be drawn over it; that means a
 * box that draws the card and then the edge, and the box is what takes the
 * tile's size.
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
        Box(
            modifier = modifier
                .clip(TileShape)
                .background(MaterialTheme.colorScheme.surfaceVariant),
        ) {
            AndroidView(
                factory = {
                    val swatch = ThemePreviewBridge.inflateThemeSwatch(context, themeValue)
                        ?: View(context)
                    swatch.setOnClickListener { currentOnClick() }
                    swatch
                },
                update = { swatch -> ThemePreviewBridge.markSelected(swatch, selected) },
                modifier = Modifier.fillMaxSize(),
            )
            TileBorder()
        }
    }
}
