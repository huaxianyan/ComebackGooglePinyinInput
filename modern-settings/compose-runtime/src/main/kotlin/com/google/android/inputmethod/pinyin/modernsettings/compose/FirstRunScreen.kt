package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Button
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

/** What the two system-owned setup steps currently report. */
internal data class FirstRunSetupState(
    val imeEnabled: Boolean = false,
    val imeSelected: Boolean = false,
) {
    val canFinish: Boolean get() = imeEnabled && imeSelected
}

/**
 * Reads the two states the guide gates on, from the same sources the legacy page read.
 *
 * Enabling is "this package appears in the enabled input method list"; selecting
 * is "the default input method is this package's own". Both come from the
 * framework rather than from anything this app stores, because both are owned
 * by the system and can change while the guide is in the background - which is
 * exactly what happens when the user leaves for the settings screen and comes
 * back.
 */
internal fun readFirstRunSetupState(context: Context): FirstRunSetupState {
    val packageName = context.packageName
    val own = context.getSystemService(InputMethodManager::class.java)
        ?.enabledInputMethodList
        ?.firstOrNull { it.packageName == packageName }
        ?: return FirstRunSetupState()
    val current = Settings.Secure.getString(
        context.contentResolver,
        Settings.Secure.DEFAULT_INPUT_METHOD,
    )
    return FirstRunSetupState(
        imeEnabled = true,
        imeSelected = own.id == current,
    )
}

/**
 * The first-run guide: enable the keyboard, select it, finish.
 *
 * One page rather than a pager, because the two steps are two independent
 * system states and neither is a page the user reads before the other - the
 * second cannot be satisfied until the first is, and the finish button cannot
 * be pressed until both are. A pager would put a Next between two things that
 * already have an order the system enforces.
 *
 * The states are handed in rather than read here: they change when the user
 * returns from a system screen, and the activity is what sees that happen.
 * Nothing on this page writes to the system; the two step buttons open
 * framework screens and the guide re-reads the result afterwards.
 */
@Composable
internal fun FirstRunScreen(
    state: FirstRunSetupState,
    onOpenInputMethodSettings: () -> Unit,
    onOpenInputMethodPicker: () -> Unit,
    onFinish: () -> Unit,
) {
    val context = LocalContext.current
    val logoId = remember(context) {
        context.resources.getIdentifier(
            FIRST_RUN_LOGO_RESOURCE,
            "drawable",
            context.packageName,
        )
    }
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.surface,
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp, vertical = 40.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            if (logoId != 0) {
                Image(
                    painter = painterResource(logoId),
                    contentDescription = null,
                    modifier = Modifier.size(72.dp),
                )
            }
            Text(
                text = legacyString(
                    "first_run_single_page_title",
                    R.string.modern_first_run_title,
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 24.dp),
                color = MaterialTheme.colorScheme.onSurface,
                style = MaterialTheme.typography.headlineSmall,
                textAlign = TextAlign.Center,
            )
            Text(
                text = legacyString(
                    "first_run_single_page_description",
                    R.string.modern_first_run_description,
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 12.dp),
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodyLarge,
                textAlign = TextAlign.Center,
            )
            FirstRunStepCard(
                number = 1,
                numberDescription = legacyString(
                    "first_run_single_enable_step",
                    R.string.modern_first_run_enable_step,
                ),
                title = legacyString(
                    "first_run_single_enable_title",
                    R.string.modern_first_run_enable_title,
                ),
                summary = legacyString(
                    "first_run_single_enable_summary",
                    R.string.modern_first_run_enable_summary,
                ),
                actionLabel = legacyString(
                    "first_run_enable_hint",
                    R.string.modern_first_run_enable_action,
                ),
                completed = state.imeEnabled,
                actionEnabled = true,
                onAction = onOpenInputMethodSettings,
                modifier = Modifier.padding(top = 32.dp),
            )
            FirstRunStepCard(
                number = 2,
                numberDescription = legacyString(
                    "first_run_single_select_step",
                    R.string.modern_first_run_select_step,
                ),
                title = legacyString(
                    "first_run_single_select_title",
                    R.string.modern_first_run_select_title,
                ),
                summary = legacyString(
                    "first_run_single_select_summary",
                    R.string.modern_first_run_select_summary,
                ),
                actionLabel = legacyString(
                    "first_run_select_input_method_hint",
                    R.string.modern_first_run_select_action,
                ),
                completed = state.imeSelected,
                // Selecting is only meaningful once the keyboard is enabled:
                // the picker cannot offer a keyboard the system does not have.
                actionEnabled = state.imeEnabled,
                onAction = onOpenInputMethodPicker,
                modifier = Modifier.padding(top = 16.dp),
            )
            Button(
                onClick = onFinish,
                enabled = state.canFinish,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 24.dp),
            ) {
                Text(
                    legacyString(
                        "first_run_single_finish",
                        R.string.modern_first_run_finish,
                    ),
                )
            }
        }
    }
}

@Composable
private fun FirstRunStepCard(
    number: Int,
    numberDescription: String,
    title: String,
    summary: String,
    actionLabel: String,
    completed: Boolean,
    actionEnabled: Boolean,
    onAction: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Surface(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        color = MaterialTheme.colorScheme.surfaceVariant,
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(
                    modifier = Modifier
                        .size(40.dp)
                        .background(MaterialTheme.colorScheme.primaryContainer, CircleShape)
                        // The step number is announced as its own label rather
                        // than read out as a bare digit ahead of the title.
                        .semantics { contentDescription = numberDescription },
                    contentAlignment = Alignment.Center,
                ) {
                    Text(
                        text = number.toString(),
                        color = MaterialTheme.colorScheme.onPrimaryContainer,
                        style = MaterialTheme.typography.titleMedium,
                    )
                }
                Spacer(Modifier.width(16.dp))
                Column {
                    Text(
                        text = title,
                        color = MaterialTheme.colorScheme.onSurface,
                        style = MaterialTheme.typography.titleMedium,
                    )
                    Text(
                        text = summary,
                        modifier = Modifier.padding(top = 4.dp),
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        style = MaterialTheme.typography.bodyMedium,
                    )
                }
            }
            if (completed) {
                // The step is done, so the button is replaced rather than
                // disabled: leaving a dead button next to a finished step reads
                // as something the user still has to do.
                Row(
                    modifier = Modifier
                        .align(Alignment.End)
                        .padding(top = 16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    Icon(
                        imageVector = Icons.Filled.Check,
                        contentDescription = null,
                        modifier = Modifier.size(24.dp),
                        tint = MaterialTheme.colorScheme.onPrimaryContainer,
                    )
                    Text(
                        text = legacyString(
                            "first_run_setup_done_hint",
                            R.string.modern_first_run_done,
                        ),
                        modifier = Modifier.padding(start = 8.dp),
                        color = MaterialTheme.colorScheme.onSurface,
                        style = MaterialTheme.typography.titleSmall,
                    )
                }
            } else {
                FilledTonalButton(
                    onClick = onAction,
                    enabled = actionEnabled,
                    modifier = Modifier
                        .align(Alignment.End)
                        .padding(top = 16.dp),
                ) {
                    Text(actionLabel)
                }
            }
        }
    }
}

private const val FIRST_RUN_LOGO_RESOURCE = "ic_first_run_page_app_logo_alia"
