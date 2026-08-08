package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.activity.compose.BackHandler
import androidx.annotation.StringRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

internal fun androidx.compose.foundation.lazy.LazyListScope.homeSettingsItems(
    navigateTo: (SettingsRoute) -> Unit,
) {
        item {
            Text(
                text = stringResource(R.string.modern_settings_stage_summary),
                modifier = Modifier.padding(horizontal = 24.dp, vertical = 12.dp),
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodyMedium,
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_home_input_title),
                supporting = stringResource(R.string.modern_settings_home_input_summary),
                onClick = { navigateTo(SettingsRoute.Input) },
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_home_keyboard_title),
                supporting = stringResource(R.string.modern_settings_home_keyboard_summary),
                onClick = { navigateTo(SettingsRoute.Keyboard) },
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_home_dictionary_title),
                supporting = stringResource(R.string.modern_settings_home_dictionary_summary),
                onClick = { navigateTo(SettingsRoute.Dictionary) },
            )
        }
        item {
            SettingsNavigationRow(
                title = stringResource(R.string.modern_settings_home_other_title),
                supporting = stringResource(R.string.modern_settings_home_other_summary),
                onClick = { navigateTo(SettingsRoute.Other) },
            )
        }
}

internal fun androidx.compose.foundation.lazy.LazyListScope.otherSettingsItems(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
) {
    item {
        SettingsSwitchRow(
            title = legacyString(
                "setting_show_launcher_icon_title",
                R.string.modern_settings_launcher_icon_title,
            ),
            supporting = legacyString(
                "setting_show_launcher_icon_summary",
                R.string.modern_settings_launcher_icon_summary,
            ),
            checked = snapshot.launcherIcon.value,
            onCheckedChange = actions.onLauncherIconVisibleChange,
        )
    }
}

internal fun androidx.compose.foundation.lazy.LazyListScope.pendingSpecializedSettingsItems() {
    item {
        Text(
            text = stringResource(R.string.modern_settings_specialized_page_pending),
            modifier = Modifier.padding(horizontal = 24.dp, vertical = 16.dp),
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            style = MaterialTheme.typography.bodyMedium,
        )
    }
}
