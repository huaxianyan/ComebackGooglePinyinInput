package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp

/** One library of the packaged third-party licence list. */
internal data class PackagedLicense(
    val name: String,
    val text: String,
)

private const val LICENCE_METADATA_RESOURCE = "third_party_license_metadata"
private const val LICENCE_BODY_RESOURCE = "third_party_licenses"

/**
 * Reads the licence list the APK already ships.
 *
 * The two raw resources are the platform's own licence format: a metadata file
 * of `<start>:<length> <name>` lines and one body file the offsets point into.
 * The lengths are byte counts, so the body stays a [ByteArray] and the name is
 * decoded per slice rather than splitting the whole file as text first.
 *
 * This page replaces the legacy activity's presentation, not its data. Reading
 * the packaged pair keeps the entries and the wording the same ones that
 * activity showed, and keeps the list working when the app is installed
 * without network access.
 *
 * An unreadable or missing pair returns an empty list rather than throwing.
 * The only caller renders that as a short notice; a licence page is not worth
 * taking the settings screen down for.
 */
internal fun readPackagedLicenses(context: Context): List<PackagedLicense> {
    val resources = context.resources
    val packageName = context.packageName
    val metadataId = resources.getIdentifier(LICENCE_METADATA_RESOURCE, "raw", packageName)
    val bodyId = resources.getIdentifier(LICENCE_BODY_RESOURCE, "raw", packageName)
    if (metadataId == 0 || bodyId == 0) return emptyList()
    val body = runCatching {
        resources.openRawResource(bodyId).use { it.readBytes() }
    }.getOrNull() ?: return emptyList()
    val metadata = runCatching {
        resources.openRawResource(metadataId).use { it.readBytes().toString(Charsets.UTF_8) }
    }.getOrNull() ?: return emptyList()
    return metadata.lineSequence()
        .mapNotNull { line -> parseLicenseLine(line, body) }
        .toList()
}

/**
 * Turns one metadata line into an entry, or null when the line cannot be used.
 *
 * The list is packaged data that this module does not produce, so a malformed
 * line is dropped rather than allowed to take the page down; the rest of the
 * list is still worth showing.
 */
internal fun parseLicenseLine(line: String, body: ByteArray): PackagedLicense? {
    val trimmed = line.trim()
    if (trimmed.isEmpty()) return null
    val separator = trimmed.indexOf(' ')
    if (separator <= 0) return null
    val range = trimmed.substring(0, separator)
    val name = trimmed.substring(separator + 1).trim()
    val colon = range.indexOf(':')
    if (colon <= 0 || name.isEmpty()) return null
    val start = range.substring(0, colon).toIntOrNull() ?: return null
    val length = range.substring(colon + 1).toIntOrNull() ?: return null
    if (start < 0 || length <= 0 || start + length > body.size) return null
    return PackagedLicense(name, String(body, start, length, Charsets.UTF_8))
}

/**
 * The open-source licence list, one row per library, with the text behind it.
 *
 * The list and the text are two pages of this one destination rather than two
 * routes: the text belongs to a row, and back from it should land on the list
 * rather than climb out of the settings hierarchy. That is also why the
 * selection is saved state - the text is a scroll position the user can be
 * returned to after the screen is rebuilt.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun LicensesScreen(
    onNavigateBack: () -> Unit,
) {
    val context = LocalContext.current
    val licenses = remember(context) { readPackagedLicenses(context) }
    var openedIndex by rememberSaveable { mutableIntStateOf(-1) }
    val opened = licenses.getOrNull(openedIndex)

    if (opened != null) {
        BackHandler { openedIndex = -1 }
        LicenseTextPage(license = opened, onNavigateBack = { openedIndex = -1 })
        return
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.modern_settings_licenses_title)) },
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
        if (licenses.isEmpty()) {
            Text(
                text = stringResource(R.string.modern_settings_licenses_unavailable),
                modifier = Modifier
                    .padding(innerPadding)
                    .padding(horizontal = 24.dp, vertical = 16.dp),
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodyMedium,
            )
            return@Scaffold
        }
        LazyColumn(
            modifier = Modifier.padding(innerPadding),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            itemsIndexed(licenses) { index, license ->
                SettingsActionRow(
                    title = license.name,
                    onClick = { openedIndex = index },
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun LicenseTextPage(
    license: PackagedLicense,
    onNavigateBack: () -> Unit,
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(license.name) },
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
        Text(
            text = license.text,
            modifier = Modifier
                .padding(innerPadding)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp, vertical = 16.dp),
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            style = MaterialTheme.typography.bodySmall,
        )
    }
}
