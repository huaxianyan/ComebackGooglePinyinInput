package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.annotation.StringRes
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyGridScope
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp

/**
 * Theme picker, laid out the way Gboard lays its own out.
 *
 * Three sections rather than one long run of tiles: the themes you made, the
 * four modes the keyboard can be in, and the packaged colours. The split into
 * sections is the point, so each one is titled even when it holds a single row.
 *
 * Tapping a tile opens [ThemePreviewSheet] instead of moving a preview pinned
 * to the top of the page. The preview is about one theme, so it belongs next to
 * that theme rather than somewhere else on the screen.
 *
 * Nothing here writes yet. The mode tiles read state and the sheet's assign
 * buttons are inert until the theme write path lands; the key-border switch in
 * the sheet is the one control that already works, because it is a plain
 * preference with no slot behind it.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun ThemeCatalogScreen(
    snapshot: SettingsSnapshot,
    onNavigateBack: () -> Unit,
) {
    val catalog = snapshot.themeCatalog
    val context = LocalContext.current
    var sheetValue by remember { mutableStateOf<String?>(null) }
    var colorsExpanded by remember { mutableStateOf(true) }
    // The stored value is empty on a device that never picked a theme, while
    // the keyboard still draws one. The engine resolves that, so ask it.
    val activeValue = remember(context, catalog.activeValue) {
        ThemePreviewBridge.activeThemeValue(context) ?: catalog.activeValue
    }
    val lightPreset = catalog.builtin.firstOrNull { it.value == LIGHT_PRESET_VALUE }
    val darkPreset = catalog.builtin.firstOrNull { it.value == DARK_PRESET_VALUE }
    val fixedValue = catalog.slots
        .firstOrNull { it.slot == ThemeSlotKey.Fixed }
        ?.additional
        .orEmpty()
    val dynamicColor = snapshot.dynamicColorEnabled
    val systemAuto = snapshot.systemAutoThemeEnabled
    val fixedInUse = !dynamicColor && !systemAuto

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.modern_settings_theme_catalog_title)) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = stringResource(
                                R.string.modern_settings_navigate_back,
                            ),
                        )
                    }
                },
            )
        },
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyVerticalGrid(
            columns = GridCells.Fixed(THEME_GRID_COLUMNS),
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding),
            contentPadding = PaddingValues(
                start = 16.dp,
                end = 16.dp,
                top = 4.dp,
                bottom = 32.dp,
            ),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            themeSection(R.string.modern_settings_theme_catalog_section_mine)
            item(key = "theme_add") {
                AddThemeTile(
                    onClick = {},
                    label = stringResource(R.string.modern_settings_theme_catalog_add),
                )
            }
            items(catalog.user, key = { "theme_user_" + it.value }) { entry ->
                ThemeTile(
                    themeValue = entry.value,
                    selected = entry.value == activeValue,
                    onClick = { sheetValue = entry.value },
                )
            }

            themeSection(R.string.modern_settings_theme_catalog_section_default)
            if (snapshot.capabilities.dynamicColorVisible) {
                item(key = "theme_mode_dynamic") {
                    DynamicColorTile(
                        selected = dynamicColor,
                        // The mode has no package to preview until it is turned
                        // on, and turning it on is the write path. Left inert
                        // rather than opening a sheet on a theme that does not
                        // exist yet.
                        onClick = {},
                        label = stringResource(R.string.modern_settings_dynamic_color_title),
                    )
                }
            }
            if (lightPreset != null && darkPreset != null) {
                item(key = "theme_mode_auto") {
                    SplitThemeTile(
                        lightValue = lightPreset.value,
                        darkValue = darkPreset.value,
                        selected = systemAuto,
                        onClick = { sheetValue = lightPreset.value },
                        label = stringResource(R.string.modern_settings_system_auto_theme_title),
                    )
                }
            }
            if (lightPreset != null) {
                item(key = "theme_mode_light") {
                    ThemeTile(
                        themeValue = lightPreset.value,
                        // An unset fixed theme resolves to the packaged light
                        // default, which is what the keyboard is showing, so it
                        // reads as the one in use rather than as nothing.
                        selected = fixedInUse &&
                            (fixedValue.isEmpty() || fixedValue == LIGHT_PRESET_VALUE),
                        onClick = { sheetValue = lightPreset.value },
                        label = stringResource(R.string.modern_settings_theme_default_light),
                    )
                }
            }
            if (darkPreset != null) {
                item(key = "theme_mode_dark") {
                    ThemeTile(
                        themeValue = darkPreset.value,
                        selected = fixedInUse && fixedValue == DARK_PRESET_VALUE,
                        onClick = { sheetValue = darkPreset.value },
                        label = stringResource(R.string.modern_settings_theme_default_dark),
                    )
                }
            }

            themeSection(
                R.string.modern_settings_theme_catalog_section_color,
                expanded = colorsExpanded,
                onToggle = { colorsExpanded = !colorsExpanded },
            )
            if (colorsExpanded) {
                items(catalog.builtin, key = { "theme_builtin_" + it.value }) { entry ->
                    ThemeTile(
                        themeValue = entry.value,
                        selected = entry.value == activeValue,
                        onClick = { sheetValue = entry.value },
                    )
                }
            }
        }
    }

    sheetValue?.let { value ->
        ThemePreviewSheet(
            themeValue = value,
            onDismiss = { sheetValue = null },
        )
    }
}

/**
 * A section heading, spanning the full width of the grid.
 *
 * [expanded] turns the heading into a disclosure control. Gboard collapses the
 * long sections and leaves the short ones open, which is what the caller does
 * by passing `null` for the sections that stay open.
 */
private fun LazyGridScope.themeSection(
    @StringRes title: Int,
    expanded: Boolean? = null,
    onToggle: (() -> Unit)? = null,
) {
    item(
        key = "theme_section_" + title,
        span = { GridItemSpan(maxLineSpan) },
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 12.dp, bottom = 2.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                text = stringResource(title),
                style = MaterialTheme.typography.titleSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.weight(1f),
            )
            if (expanded != null && onToggle != null) {
                IconButton(onClick = onToggle) {
                    Icon(
                        imageVector = if (expanded) {
                            Icons.Filled.KeyboardArrowUp
                        } else {
                            Icons.Filled.KeyboardArrowDown
                        },
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
        }
    }
}

/** How many tiles sit side by side, matching the layout this replaces. */
private const val THEME_GRID_COLUMNS = 3

/**
 * The proportions the legacy sample layout is drawn at.
 *
 * Only the width follows the column; the height is derived from these, so a
 * tile keeps the shape the legacy layout was designed for instead of
 * stretching. Both numbers are `@dimen/theme_selector_candidate_width` and
 * `_height`; `scripts/verify_theme_preview_bridge.py` fails if they drift.
 */
internal const val THEME_CELL_WIDTH_DP = 128
internal const val THEME_CELL_HEIGHT_DP = 92

/** Width over height, so a tile can size itself from the column alone. */
internal val THEME_CELL_ASPECT = THEME_CELL_WIDTH_DP.toFloat() / THEME_CELL_HEIGHT_DP

/**
 * The two packaged presets the Defaults row offers.
 *
 * These are the values of `pref_entry_additional_keyboard_theme_google_blue_light`
 * and `_dark`: the pair the keyboard falls back to when nothing is stored, and
 * the third and fourth entries of the packaged list. Naming them here rather
 * than reusing the first two entries keeps the Defaults row showing the pair the
 * engine itself would pick.
 * `scripts/verify_theme_preview_bridge.py` checks them against `strings.xml`.
 */
internal const val LIGHT_PRESET_VALUE =
    "assets:theme_package_metadata_google_blue_light.binarypb"
internal const val DARK_PRESET_VALUE =
    "assets:theme_package_metadata_google_blue_dark.binarypb"
