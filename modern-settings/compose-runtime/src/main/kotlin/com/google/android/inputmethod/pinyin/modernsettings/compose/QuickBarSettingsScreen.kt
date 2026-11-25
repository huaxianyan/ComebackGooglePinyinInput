package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
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
 * Toolbar shortcut list: switch each one on or off, and move it up or down.
 *
 * The order on this screen is the order on the keyboard, so a change is written straight to the
 * shared preferences file the input method service reads.
 */
@Composable
internal fun QuickBarSettingsScreen(onNavigateBack: () -> Unit) {
    val context = LocalContext.current
    var entries by remember { mutableStateOf(QuickBarSetting.entries(context)) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.modern_settings_quick_bar_title)) },
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
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier.padding(innerPadding),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            items(entries, key = { it.id }) { entry ->
                val label = stringResource(entry.labelRes)
                ListItem(
                    headlineContent = { Text(label) },
                    // A switched-off shortcut keeps its place in the list: turning it back on should
                    // not send it to the end.
                    supportingContent = if (entry.enabled) null else {
                        { Text(stringResource(R.string.modern_settings_quick_bar_hidden)) }
                    },
                    leadingContent = {
                        Switch(
                            checked = entry.enabled,
                            onCheckedChange = { checked ->
                                entries = QuickBarSetting.setEnabled(context, entry.id, checked)
                            },
                        )
                    },
                    trailingContent = {
                        Row(
                            horizontalArrangement = Arrangement.spacedBy(4.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            val index = entries.indexOfFirst { it.id == entry.id }
                            IconButton(
                                onClick = {
                                    entries = QuickBarSetting.move(context, entry.id, up = true)
                                },
                                enabled = index > 0,
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.KeyboardArrowUp,
                                    contentDescription = stringResource(
                                        R.string.modern_settings_quick_bar_move_up,
                                        label,
                                    ),
                                )
                            }
                            IconButton(
                                onClick = {
                                    entries = QuickBarSetting.move(context, entry.id, up = false)
                                },
                                enabled = index < entries.lastIndex,
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.KeyboardArrowDown,
                                    contentDescription = stringResource(
                                        R.string.modern_settings_quick_bar_move_down,
                                        label,
                                    ),
                                )
                            }
                        }
                    },
                    colors = androidx.compose.material3.ListItemDefaults.colors(),
                )
            }
            item {
                Text(
                    text = stringResource(R.string.modern_settings_quick_bar_summary),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp),
                )
            }
        }
    }
}
