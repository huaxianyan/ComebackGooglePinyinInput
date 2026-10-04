package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.foundation.clickable
import androidx.compose.ui.unit.dp

/**
 * What a tile asks the sheet to show.
 *
 * Most tiles are one theme and fill in only [themeValue]. The mode that follows
 * the system is a pair: it is two themes with a rule for picking between them,
 * and previewing only the light half would show it as a fixed light theme,
 * which is the one thing it is not. [pairedValue] carries the second half.
 */
internal data class ThemePreviewSubject(
    val themeValue: String,
    val pairedValue: String? = null,
)

/**
 * What tapping a theme tile opens.
 *
 * The preview is here rather than pinned to the top of the page because it is
 * about one theme: the tile you tapped is the one being shown.
 *
 * A paired subject puts the two previews side by side, light on the left and
 * dark on the right - the same reading order the tile that opens it uses, and
 * the same order the keyboard itself switches between.
 *
 * The key-border switch works, and redraws the preview when it changes. The
 * three theme buttons do not: applying a theme and assigning one to a slot are
 * the write path, which lands on its own. They are disabled rather than left
 * looking live, so a tap that did nothing cannot be mistaken for a failure.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun ThemePreviewSheet(
    subject: ThemePreviewSubject,
    onDismiss: () -> Unit,
) {
    val context = LocalContext.current
    // Without this the sheet opens at its partially expanded height, where the
    // preview is cut off, and the first back press only collapses it to that
    // height instead of dismissing it. There is nothing below the fold to scroll
    // to, so the half-open state is never useful here.
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    // The switch and the picture are the same value on purpose: it is read once
    // here and then handed to the renderer, rather than the renderer resolving
    // the preference for itself. Two lookups of one setting is how the two came
    // to disagree - the switch read it through a reflective call that was
    // landing on the wrong overload and answering `false` for everything, while
    // the renderer resolved the same call at compile time and drew borders.
    var keyBorder by remember(context) {
        mutableStateOf(ThemePreviewBridge.keyBorderEnabled(context))
    }

    ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = sheetState,
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 24.dp),
        ) {
            PreviewRow(subject = subject, keyBorder = keyBorder)
            KeyBorderRow(
                checked = keyBorder,
                onCheckedChange = { enabled ->
                    keyBorder = enabled
                    ThemePreviewBridge.setKeyBorderEnabled(context, enabled)
                },
            )
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .padding(top = 4.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                OutlinedButton(
                    onClick = {},
                    enabled = false,
                    modifier = Modifier.weight(1f),
                ) {
                    Text(
                        text = stringResource(R.string.modern_settings_theme_assign_light),
                        maxLines = 1,
                        style = MaterialTheme.typography.labelLarge,
                    )
                }
                OutlinedButton(
                    onClick = {},
                    enabled = false,
                    modifier = Modifier.weight(1f),
                ) {
                    Text(
                        text = stringResource(R.string.modern_settings_theme_assign_dark),
                        maxLines = 1,
                        style = MaterialTheme.typography.labelLarge,
                    )
                }
            }
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .padding(top = 8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                TextButton(
                    onClick = onDismiss,
                    modifier = Modifier.weight(1f),
                ) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
                Button(
                    onClick = {},
                    enabled = false,
                    modifier = Modifier.weight(1f),
                ) {
                    Text(stringResource(R.string.modern_settings_apply))
                }
            }
        }
    }
}

/**
 * The picture, or the pair of pictures.
 *
 * Both halves get the same width, so neither theme is shown as the important
 * one. Stacking them instead would make the sheet tall enough to crowd the
 * switch and the buttons off the bottom on a short screen, and the two are
 * meant to be read against each other, which side by side does better.
 */
@Composable
private fun PreviewRow(
    subject: ThemePreviewSubject,
    keyBorder: Boolean,
) {
    val paired = subject.pairedValue
    if (paired == null) {
        ThemePreview(
            themeValue = subject.themeValue,
            keyBorder = keyBorder,
            modifier = Modifier.padding(horizontal = 16.dp),
        )
        return
    }
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        ThemePreview(
            themeValue = subject.themeValue,
            keyBorder = keyBorder,
            modifier = Modifier.weight(1f),
        )
        ThemePreview(
            themeValue = paired,
            keyBorder = keyBorder,
            modifier = Modifier.weight(1f),
        )
    }
}

/** The switch that decides whether the keyboard draws a border around each key. */
@Composable
private fun KeyBorderRow(
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(role = Role.Switch) { onCheckedChange(!checked) }
            .padding(horizontal = 24.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            text = stringResource(R.string.modern_settings_theme_key_border),
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurface,
        )
        Switch(checked = checked, onCheckedChange = onCheckedChange)
    }
}
