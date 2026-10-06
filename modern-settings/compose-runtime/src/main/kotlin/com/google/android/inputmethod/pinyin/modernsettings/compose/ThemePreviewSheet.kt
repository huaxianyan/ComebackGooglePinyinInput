package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
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
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.foundation.clickable
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

/**
 * The two modes a tile can stand for instead of a single theme.
 *
 * Both are drawn as one or two theme previews, so neither can be told from a
 * plain theme by looking at the picture. What differs is what applying it
 * means: the theme on screen is not what the tile offers, the mode is. Without
 * this the sheet would apply the light half of the follow-the-system pair as a
 * fixed theme, which is the one thing that tile does not mean.
 */
internal enum class ThemePreviewMode {
    /** The palette generated from the wallpaper. */
    Dynamic,

    /** The two themes the slots hold, picked by the system's light/dark mode. */
    FollowSystem,
}

/**
 * What a tile asks the sheet to show.
 *
 * Most tiles are one theme and fill in only [themeValue]. The mode that follows
 * the system is a pair: it is two themes with a rule for picking between them,
 * and previewing only the light half would show it as a fixed light theme,
 * which is the one thing it is not. [pairedValue] carries the second half.
 *
 * [mode] is set only by the tiles that offer a mode rather than a theme, and it
 * is what the sheet's apply button reads to decide whether it is choosing a
 * theme or switching one on.
 *
 * [userMade] says whether this is a theme the user built. By the time a value
 * reaches the sheet, a packaged theme and a custom one are the same kind of
 * string, and only the section it was tapped in knows which it is - so the
 * screen says so here rather than the sheet re-deriving it from the prefix.
 */
internal data class ThemePreviewSubject(
    val themeValue: String,
    val pairedValue: String? = null,
    val mode: ThemePreviewMode? = null,
    val userMade: Boolean = false,
)

/**
 * What the sheet's buttons do.
 *
 * The sheet does not decide any of this. Which theme an assign button writes
 * depends on whether the subject is a pair, and whether the two assign buttons
 * can be pressed depends on whether the subject has a slot to write at all -
 * both of which the screen knows and the sheet does not. Passing the answers in
 * keeps the sheet a picture and a set of buttons.
 *
 * [assignLightEnabled] and [assignDarkEnabled] are separate rather than one
 * flag because the rule that produces them is stated per slot; today it
 * answers the same for both, and folding them together here would hide that.
 *
 * [assignEnablesFollowSystem] is true while the two buttons are live and the
 * mode they write to is still off, because pressing either one is what turns it
 * on. The sheet says so rather than leaving the user to find out: a button that
 * quietly switches a second setting is worth one line of warning.
 *
 * [editTheme] and [deleteTheme] are null for everything that is not a theme the
 * user made, and the sheet draws no buttons at all in that case. A flag beside
 * a callback would let the two disagree; a null callback cannot be pressed and
 * is what "there is no button here" already means.
 */
internal data class ThemePreviewActions(
    val apply: () -> Unit,
    val assignLight: () -> Unit,
    val assignDark: () -> Unit,
    val assignLightEnabled: Boolean,
    val assignDarkEnabled: Boolean,
    val assignEnablesFollowSystem: Boolean,
    val editTheme: (() -> Unit)? = null,
    val deleteTheme: (() -> Unit)? = null,
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
 * three theme buttons write: apply makes the subject the theme in use, and the
 * two assign buttons point one half of the follow-the-system mode at it. The
 * assign pair is live for every subject that has a slot to write, and pressing
 * one turns that mode on if it is off, because a slot is not read in any other
 * mode - [ThemePreviewActions.assignEnablesFollowSystem] is what the caption
 * above the pair is drawn from, so the switch is never a silent one.
 *
 * A theme the user made also carries its two own actions in the top right
 * corner, which is where the app this replaces puts them: edit, and delete.
 * They are about the package rather than about which theme is in use, so they
 * sit apart from the buttons below rather than in that row.
 *
 * Every way out of the sheet animates, including the six buttons. The caller
 * closes the sheet by clearing its subject, and clearing it takes the sheet out
 * of the tree on the same frame, so a button that called its action directly
 * would make the sheet vanish rather than leave. Tapping the scrim does not
 * have that problem - Material 3 hides the sheet before it reports the
 * dismissal - so the buttons borrow the same hide and only run their action
 * once the sheet is gone.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun ThemePreviewSheet(
    subject: ThemePreviewSubject,
    actions: ThemePreviewActions,
    onDismiss: () -> Unit,
) {
    val context = LocalContext.current
    // Without this the sheet opens at its partially expanded height, where the
    // preview is cut off, and the first back press only collapses it to that
    // height instead of dismissing it. There is nothing below the fold to scroll
    // to, so the half-open state is never useful here.
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    val scope = rememberCoroutineScope()
    // Every button that closes the sheet hides it first. Setting the subject to
    // null takes the sheet out of the tree on the same frame, and a sheet that
    // is removed is not animated out - only the scrim, whose dismissal Material
    // 3 routes through a hide of its own, gets an exit. Sending the buttons
    // through the same hide is what gives them the same exit as the scrim.
    var dismissing by remember { mutableStateOf(false) }
    fun dismissThen(action: () -> Unit) {
        // The hide takes a few frames, and a second tap inside it would run the
        // action twice - for the editor that is a second editor on the stack.
        if (dismissing) return
        dismissing = true
        scope.launch { sheetState.hide() }.invokeOnCompletion {
            // Still visible means the hide was cut short by something else
            // closing the sheet, which has already done this action's job.
            if (!sheetState.isVisible) action()
        }
    }
    // The same for an action that may not exist. A null stays null, which is
    // what "this theme has no such button" already means.
    fun closingAction(action: (() -> Unit)?): (() -> Unit)? {
        if (action == null) return null
        return { dismissThen(action) }
    }
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
            ThemeActionsRow(
                edit = closingAction(actions.editTheme),
                delete = closingAction(actions.deleteTheme),
            )
            PreviewRow(subject = subject, keyBorder = keyBorder)
            KeyBorderRow(
                checked = keyBorder,
                onCheckedChange = { enabled ->
                    keyBorder = enabled
                    ThemePreviewBridge.setKeyBorderEnabled(context, enabled)
                },
            )
            if (actions.assignEnablesFollowSystem) {
                Text(
                    text = stringResource(
                        R.string.modern_settings_theme_assign_enables_follow_system,
                    ),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp)
                        .padding(top = 12.dp),
                )
            }
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .padding(top = 4.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                OutlinedButton(
                    onClick = { dismissThen(actions.assignLight) },
                    enabled = actions.assignLightEnabled,
                    modifier = Modifier.weight(1f),
                ) {
                    Text(
                        text = stringResource(R.string.modern_settings_theme_assign_light),
                        maxLines = 1,
                        style = MaterialTheme.typography.labelLarge,
                    )
                }
                OutlinedButton(
                    onClick = { dismissThen(actions.assignDark) },
                    enabled = actions.assignDarkEnabled,
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
                    onClick = { dismissThen(onDismiss) },
                    modifier = Modifier.weight(1f),
                ) {
                    Text(stringResource(R.string.modern_settings_cancel))
                }
                Button(
                    onClick = { dismissThen(actions.apply) },
                    modifier = Modifier.weight(1f),
                ) {
                    Text(stringResource(R.string.modern_settings_apply))
                }
            }
        }
    }
}

/**
 * The two actions a theme the user made carries, or nothing.
 *
 * Drawn above the preview rather than beside the apply button: apply and the
 * assign pair are about which theme the keyboard uses, and these two are about
 * the package itself, so putting them in one row would read as four ways to
 * pick a theme.
 *
 * Both buttons are shown whenever either action is: a theme that can be edited
 * can also be removed, so the pair is drawn together and the corner either has
 * both or neither.
 */
@Composable
private fun ThemeActionsRow(
    edit: (() -> Unit)?,
    delete: (() -> Unit)?,
) {
    if (edit == null && delete == null) return
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 12.dp)
            .padding(top = 4.dp),
        horizontalArrangement = Arrangement.End,
        verticalAlignment = Alignment.CenterVertically,
    ) {
        if (edit != null) {
            IconButton(onClick = edit) {
                Icon(
                    imageVector = Icons.Filled.Edit,
                    contentDescription = stringResource(R.string.modern_settings_theme_edit),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
        if (delete != null) {
            IconButton(onClick = delete) {
                Icon(
                    imageVector = Icons.Filled.Delete,
                    contentDescription = stringResource(R.string.modern_settings_theme_delete),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant,
                )
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
