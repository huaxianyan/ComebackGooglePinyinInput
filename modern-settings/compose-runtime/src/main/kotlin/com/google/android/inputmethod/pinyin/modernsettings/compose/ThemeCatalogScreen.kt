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
import androidx.compose.runtime.LaunchedEffect
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
 * that theme rather than somewhere else on the screen. A tile whose theme is
 * really a pair - the one that follows the system - hands the sheet both halves,
 * so the sheet shows what the tile shows rather than half of it.
 *
 * The Colours section leaves out the two packaged presets, because the Defaults
 * row above it is where they belong and drawing them twice on one page would
 * make the page look like it offered four light themes.
 *
 * Nothing here changes which theme is in use on its own. Three things do, and
 * all three go through the sheet: apply commits whatever the sheet is showing -
 * a theme, or the mode the tile stands for - and the two assign buttons point a
 * half of the follow-the-system mode at a theme. The key-border switch in the
 * sheet also writes, but it is not a theme, and the generated palette package
 * the dynamic-colour tile needs is built ahead of any tap - building it leaves
 * the mode alone, so the tile can be previewed before the mode is switched on.
 *
 * The add tile leaves the page entirely: it opens the legacy builder, which is
 * where a theme is made from a picture, and the theme it returns is applied on
 * the way back. That is the one write that does not go through the sheet,
 * because it is not about a theme already on the page.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun ThemeCatalogScreen(
    snapshot: SettingsSnapshot,
    onNavigateBack: () -> Unit,
    onApplyTheme: (String) -> Unit,
    onAssignThemeSlot: (ThemeSelectionSlot, String) -> Unit,
    onFollowSystemEnabledChange: (Boolean) -> Unit,
    onDynamicColorEnabledChange: (Boolean) -> Unit,
    onAddTheme: () -> Unit,
) {
    val catalog = snapshot.themeCatalog
    val context = LocalContext.current
    var subject by remember { mutableStateOf<ThemePreviewSubject?>(null) }
    var colorsExpanded by remember { mutableStateOf(true) }
    // The stored value is empty on a device that never picked a theme, while
    // the keyboard still draws one. The engine resolves that, so ask it.
    val activeValue = remember(context, catalog.activeValue) {
        ThemePreviewBridge.activeThemeValue(context) ?: catalog.activeValue
    }
    val lightPreset = catalog.builtin.firstOrNull { it.value == LIGHT_PRESET_VALUE }
    val darkPreset = catalog.builtin.firstOrNull { it.value == DARK_PRESET_VALUE }
    // The pair the follow-the-system mode actually swaps between. It is not the
    // two packaged presets: those are only what the bridge seeds the slots with
    // on a device that has never chosen, and the slots are what the keyboard
    // reads. Showing the presets here would draw a pair the keyboard is not
    // using as soon as the user assigns their own to either slot.
    val lightSlotValue = catalog.slots
        .firstOrNull { it.slot == ThemeSlotKey.Light }
        ?.entry
        ?.value
    val darkSlotValue = catalog.slots
        .firstOrNull { it.slot == ThemeSlotKey.Dark }
        ?.entry
        ?.value
    val fixedValue = catalog.slots
        .firstOrNull { it.slot == ThemeSlotKey.Fixed }
        ?.additional
        .orEmpty()
    val dynamicColor = snapshot.dynamicColorEnabled
    val systemAuto = snapshot.systemAutoThemeEnabled
    val fixedInUse = !dynamicColor && !systemAuto
    // The Colours section, minus the pair the Defaults row already shows. They
    // are the same two packaged themes, so leaving them in both places would
    // draw the same tiles twice on one page.
    val colorEntries = remember(catalog.builtin) {
        catalog.builtin.filterNot {
            it.value == LIGHT_PRESET_VALUE || it.value == DARK_PRESET_VALUE
        }
    }
    // The palette package does not exist until something builds one, and the
    // tile has to show a palette before the mode is switched on. Building it is
    // not a theme change - it only writes the package file - so the mode stays
    // where it was and the tile can still be previewed. Deferred out of
    // composition because building the package reads assets and writes a file.
    var dynamicValue by remember { mutableStateOf<String?>(null) }
    LaunchedEffect(context, snapshot.capabilities.dynamicColorVisible) {
        dynamicValue = if (snapshot.capabilities.dynamicColorVisible) {
            ThemePreviewBridge.prepareDynamicTheme(context)
        } else {
            null
        }
    }

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
                    onClick = onAddTheme,
                    label = stringResource(R.string.modern_settings_theme_catalog_add),
                )
            }
            items(catalog.user, key = { "theme_user_" + it.value }) { entry ->
                ThemeTile(
                    themeValue = entry.value,
                    selected = entry.value == activeValue,
                    onClick = { subject = ThemePreviewSubject(entry.value) },
                )
            }

            themeSection(R.string.modern_settings_theme_catalog_section_default)
            if (snapshot.capabilities.dynamicColorVisible) {
                item(key = "theme_mode_dynamic") {
                    DynamicColorTile(
                        themeValue = dynamicValue,
                        selected = dynamicColor,
                        onClick = {
                            dynamicValue?.let {
                                subject = ThemePreviewSubject(
                                    themeValue = it,
                                    mode = ThemePreviewMode.Dynamic,
                                )
                            }
                        },
                        label = stringResource(R.string.modern_settings_dynamic_color_title),
                    )
                }
            }
            if (lightPreset != null && darkPreset != null) {
                item(key = "theme_mode_auto") {
                    SplitThemeTile(
                        lightValue = lightSlotValue ?: lightPreset.value,
                        darkValue = darkSlotValue ?: darkPreset.value,
                        selected = systemAuto,
                        // Both halves, because the mode is the pair. The tile
                        // shows the two themes it swaps between, so the sheet
                        // that opens from it has to as well - and both come
                        // from the slots, so the pair shown is the pair the
                        // keyboard would use rather than the packaged default.
                        onClick = {
                            subject = ThemePreviewSubject(
                                themeValue = lightSlotValue ?: lightPreset.value,
                                pairedValue = darkSlotValue ?: darkPreset.value,
                                mode = ThemePreviewMode.FollowSystem,
                            )
                        },
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
                        onClick = { subject = ThemePreviewSubject(lightPreset.value) },
                        label = stringResource(R.string.modern_settings_theme_default_light),
                    )
                }
            }
            if (darkPreset != null) {
                item(key = "theme_mode_dark") {
                    ThemeTile(
                        themeValue = darkPreset.value,
                        selected = fixedInUse && fixedValue == DARK_PRESET_VALUE,
                        onClick = { subject = ThemePreviewSubject(darkPreset.value) },
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
                // Without the two presets, which the Defaults row above already
                // offers. They are packaged colours, so they belong in this
                // list by their value; they are also the pair the light and
                // dark modes are defined as, and showing the same two tiles
                // twice on one page invites the reader to wonder what differs.
                items(colorEntries, key = { "theme_builtin_" + it.value }) { entry ->
                    ThemeTile(
                        themeValue = entry.value,
                        selected = entry.value == activeValue,
                        onClick = { subject = ThemePreviewSubject(entry.value) },
                    )
                }
            }
        }
    }

    subject?.let { shown ->
        // A slot is only read while the follow-the-system mode is on, so this
        // is also what the assign buttons are enabled by. It is asked per slot
        // even though both answers are the same today: the rule is stated per
        // slot, and the sheet takes one flag per button so that stays visible.
        val lightSelectable = ThemeSettingRules.canSelect(
            ThemeSelectionSlot.Light,
            followThemeEnabled = systemAuto,
            dynamicColorEnabled = dynamicColor,
        )
        val darkSelectable = ThemeSettingRules.canSelect(
            ThemeSelectionSlot.Dark,
            followThemeEnabled = systemAuto,
            dynamicColorEnabled = dynamicColor,
        )
        // The second half of a paired subject is the dark one, which is the
        // order the previews are drawn in. A single theme has no second half,
        // so both assign buttons point at the one theme on screen.
        val darkValue = shown.pairedValue ?: shown.themeValue
        ThemePreviewSheet(
            subject = shown,
            actions = ThemePreviewActions(
                // Applying a tile that offers a mode switches that mode on. The
                // theme drawn on the tile is what the mode resolves to, not
                // what the button offers, so applying it as a fixed theme would
                // pin one half of the pair - and for the generated palette it
                // would turn the mode off, which is the opposite of the tile.
                apply = {
                    when (shown.mode) {
                        ThemePreviewMode.Dynamic -> onDynamicColorEnabledChange(true)
                        ThemePreviewMode.FollowSystem -> onFollowSystemEnabledChange(true)
                        null -> onApplyTheme(shown.themeValue)
                    }
                    subject = null
                },
                assignLight = {
                    onAssignThemeSlot(ThemeSelectionSlot.Light, shown.themeValue)
                    subject = null
                },
                assignDark = {
                    onAssignThemeSlot(ThemeSelectionSlot.Dark, darkValue)
                    subject = null
                },
                assignLightEnabled = lightSelectable,
                assignDarkEnabled = darkSelectable,
            ),
            onDismiss = { subject = null },
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
 * engine itself would pick. The Colours section filters both out, so the row
 * above is the only place they appear.
 * `scripts/verify_theme_preview_bridge.py` checks them against `strings.xml`.
 */
internal const val LIGHT_PRESET_VALUE =
    "assets:theme_package_metadata_google_blue_light.binarypb"
internal const val DARK_PRESET_VALUE =
    "assets:theme_package_metadata_google_blue_dark.binarypb"
