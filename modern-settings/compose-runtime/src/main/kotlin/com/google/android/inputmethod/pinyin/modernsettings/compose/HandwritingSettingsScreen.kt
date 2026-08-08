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

internal fun androidx.compose.foundation.lazy.LazyListScope.handwritingSettingsItems(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
    millisecondsText: (Int) -> String,
) {
    item {
        DiscreteSettingsSlider(
            title = legacyString(
                "setting_handwriting_timeout_title",
                R.string.modern_settings_handwriting_timeout_title,
            ),
            value = snapshot.handwritingTimeoutIndex.toFloat(),
            valueText = handwritingTimeoutText(
                snapshot.handwritingTimeoutIndex,
                snapshot.handwritingTimeoutLabels,
                millisecondsText,
            ),
            valueTextForIndex = { index ->
                handwritingTimeoutText(
                    index,
                    snapshot.handwritingTimeoutLabels,
                    millisecondsText,
                )
            },
            maximumIndex = SliderSettingContracts.handwritingTimeout.values.lastIndex,
            editable = true,
            onValueCommit = actions.onHandwritingTimeoutChange,
        )
    }
    item {
        DiscreteSettingsSlider(
            title = legacyString(
                "setting_handwriting_stroke_width_title",
                R.string.modern_settings_handwriting_stroke_width_title,
            ),
            value = snapshot.handwritingStrokeWidthIndex.toFloat(),
            valueText = handwritingStrokeWidthText(
                snapshot.handwritingStrokeWidthIndex,
                snapshot.handwritingStrokeWidthLabels,
            ),
            valueTextForIndex = { index ->
                handwritingStrokeWidthText(
                    index,
                    snapshot.handwritingStrokeWidthLabels,
                )
            },
            maximumIndex = SliderSettingContracts.handwritingStrokeWidth.values.lastIndex,
            editable = true,
            onValueCommit = actions.onHandwritingStrokeWidthChange,
        )
    }
}
