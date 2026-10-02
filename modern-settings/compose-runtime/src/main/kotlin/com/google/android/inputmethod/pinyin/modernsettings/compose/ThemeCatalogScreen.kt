package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.annotation.StringRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp

/**
 * Read-only theme inventory.
 *
 * It reports what the package actually holds and which theme each slot points
 * at. Nothing on this screen writes: picking a theme still goes through the
 * legacy selector, which owns the two-preference write and the slot capture
 * that has to happen with it.
 *
 * Tapping a row only moves the preview. It starts on the theme the keyboard is
 * using, so the first thing on screen is what the user already sees.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun ThemeCatalogScreen(
    snapshot: SettingsSnapshot,
    onNavigateBack: () -> Unit,
) {
    val catalog = snapshot.themeCatalog
    val context = LocalContext.current
    var previewValue by remember { mutableStateOf(catalog.activeValue) }
    val slotLabelsByValue: Map<String, List<String>> = catalog.slots
        .mapNotNull { value ->
            value.entry?.let { entry ->
                entry.value to context.getString(slotTitle(value.slot))
            }
        }
        .groupBy({ it.first }, { it.second })
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
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding),
        ) {
            ThemePreview(themeValue = previewValue)
            LazyColumn(modifier = Modifier.weight(1f)) {
                item(key = "theme_catalog_slots_header") {
                    SectionTitle(stringResource(R.string.modern_settings_theme_catalog_in_use))
                }
                items(
                    items = catalog.slots.filter {
                        it.slot != ThemeSlotKey.Dynamic || snapshot.capabilities.dynamicColorVisible
                    },
                    key = { "theme_catalog_slot_" + it.slot.persistedValue },
                ) { value ->
                    val label = value.entry?.name ?: context.getString(
                        if (value.additional.isEmpty()) {
                            R.string.modern_settings_theme_catalog_unset
                        } else {
                            R.string.modern_settings_theme_catalog_unresolved
                        },
                    )
                    ListItem(
                        headlineContent = {
                            Text(
                                stringResource(slotTitle(value.slot)),
                                modifier = Modifier.padding(start = 8.dp),
                            )
                        },
                        supportingContent = {
                            Text(
                                label,
                                modifier = Modifier.padding(start = 8.dp),
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        },
                    )
                }
                item(key = "theme_catalog_builtin_header") {
                    SectionTitle(stringResource(R.string.modern_settings_theme_catalog_builtin))
                }
                items(catalog.builtin, key = { "theme_catalog_builtin_" + it.value }) { entry ->
                    ThemeCatalogEntryRow(
                        entry = entry,
                        slotLabels = slotLabelsByValue[entry.value],
                        previewing = entry.value == previewValue,
                        onPreview = { previewValue = entry.value },
                    )
                }
                item(key = "theme_catalog_custom_header") {
                    SectionTitle(stringResource(R.string.modern_settings_theme_catalog_custom))
                }
                if (catalog.user.isEmpty()) {
                    item(key = "theme_catalog_custom_empty") {
                        ListItem(
                            headlineContent = {
                                Text(
                                    stringResource(
                                        R.string.modern_settings_theme_catalog_no_custom,
                                    ),
                                    modifier = Modifier.padding(start = 8.dp),
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                )
                            },
                        )
                    }
                } else {
                    items(catalog.user, key = { "theme_catalog_custom_" + it.value }) { entry ->
                        ThemeCatalogEntryRow(
                            entry = entry,
                            slotLabels = slotLabelsByValue[entry.value],
                            previewing = entry.value == previewValue,
                            onPreview = { previewValue = entry.value },
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun ThemeCatalogEntryRow(
    entry: ThemeEntry,
    slotLabels: List<String>?,
    previewing: Boolean,
    onPreview: () -> Unit,
) {
    ListItem(
        modifier = Modifier.clickable(onClick = onPreview),
        headlineContent = {
            Text(
                entry.name,
                modifier = Modifier.padding(start = 8.dp),
                color = if (previewing) MaterialTheme.colorScheme.primary else Color.Unspecified,
            )
        },
        supportingContent = slotLabels?.takeIf { it.isNotEmpty() }?.let { labels ->
            {
                Text(
                    labels.joinToString(separator = " · "),
                    modifier = Modifier.padding(start = 8.dp),
                    color = MaterialTheme.colorScheme.primary,
                )
            }
        },
    )
}

@StringRes
private fun slotTitle(slot: ThemeSlotKey): Int = when (slot) {
    ThemeSlotKey.Light -> R.string.modern_settings_light_mode_theme_title
    ThemeSlotKey.Dark -> R.string.modern_settings_dark_mode_theme_title
    ThemeSlotKey.Fixed -> R.string.modern_settings_fixed_theme_title
    ThemeSlotKey.Dynamic -> R.string.modern_settings_dynamic_color_title
}
