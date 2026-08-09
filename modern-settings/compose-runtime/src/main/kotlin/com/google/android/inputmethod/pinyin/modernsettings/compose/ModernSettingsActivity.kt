package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.Manifest
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.LayoutDirection
import java.util.Locale
import java.util.Random

/** API-35+-guarded host for the staged official Compose Material 3 settings runtime. */
class ModernSettingsActivity : ComponentActivity() {
    private enum class TreePurpose { Location, Enable, Import }

    private lateinit var controller: SettingsController
    private lateinit var dictionaryRepository: LegacyDictionarySettingsRepository
    private var snapshot by mutableStateOf<SettingsSnapshot?>(null)
    private var dictionarySnapshot by mutableStateOf<DictionarySettingsSnapshot?>(null)
    private var dictionaryHealth by mutableStateOf(DictionaryHealthState())
    private var dictionaryImport by mutableStateOf(DictionaryImportState())
    private var dictionaryClear by mutableStateOf(DictionaryClearState())
    private var dictionaryClearCallback: Any? = null
    private var treePurpose = TreePurpose.Location
    private val mainHandler = Handler(Looper.getMainLooper())
    private val backupRefresh = object : Runnable {
        override fun run() {
            if (!::dictionaryRepository.isInitialized) return
            val current = dictionaryRepository.read()
            dictionarySnapshot = current
            if (current.backupInProgress) mainHandler.postDelayed(this, 500L)
        }
    }
    private val contactsPermission = registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) { granted ->
        if (granted) {
            dictionaryRepository.setContactSuggestionsEnabled(true)
        } else {
            dictionaryRepository.setContactSuggestionsEnabled(false)
            Toast.makeText(
                this,
                R.string.modern_settings_dictionary_contacts_permission_denied,
                Toast.LENGTH_SHORT,
            ).show()
        }
        dictionarySnapshot = dictionaryRepository.read()
    }
    private val treePicker = registerForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
        if (uri == null) {
            dictionarySnapshot = dictionaryRepository.read()
            return@registerForActivityResult
        }
        val completedPurpose = treePurpose
        dictionaryRepository.acceptTreeAsync(
            uri = uri,
            enableAfterSelection = completedPurpose == TreePurpose.Enable,
        ) { error ->
            if (error != null) {
                Toast.makeText(this, error, Toast.LENGTH_LONG).show()
            } else {
                Toast.makeText(
                    this,
                    R.string.modern_settings_dictionary_location_saved,
                    Toast.LENGTH_SHORT,
                ).show()
                if (completedPurpose == TreePurpose.Import) openDictionaryImport()
            }
            refreshDictionaryUntilIdle()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        controller = SettingsController(
            LegacySettingsRepository(this),
            SettingsPreviewEffects(this),
        )
        dictionaryRepository = LegacyDictionarySettingsRepository(this)
        dictionaryClear = when {
            savedInstanceState?.getBoolean(CLEAR_IN_PROGRESS_KEY, false) == true ->
                DictionaryClearStateReducer.observeInProgress(true)
            savedInstanceState?.getBoolean(CLEAR_DIALOG_VISIBLE_KEY, false) == true ->
                DictionaryClearState(
                    confirmationVisible = true,
                    challenge = savedInstanceState.getString(CLEAR_CHALLENGE_KEY).orEmpty(),
                    input = savedInstanceState.getString(CLEAR_INPUT_KEY).orEmpty(),
                ).takeIf { it.challenge.length == 4 && it.challenge.all(Char::isDigit) }
                    ?: DictionaryClearState()
            else -> DictionaryClearState()
        }
        dictionaryClearCallback = dictionaryRepository.attachClearCallback(
            onStarted = {
                runOnUiThread {
                    dictionaryClear = DictionaryClearStateReducer.observeInProgress(true)
                    dictionarySnapshot = dictionaryRepository.read()
                }
            },
            onFinished = { success ->
                runOnUiThread {
                    dictionaryClear = DictionaryClearStateReducer.complete()
                    dictionarySnapshot = dictionaryRepository.read()
                    refreshDictionaryHealth()
                    Toast.makeText(
                        this,
                        if (success) R.string.modern_settings_dictionary_clear_success
                        else R.string.modern_settings_dictionary_clear_error,
                        Toast.LENGTH_LONG,
                    ).show()
                }
            },
        )
        setContent {
            ModernSettingsTheme {
                snapshot?.let { settings ->
                    dictionarySnapshot?.let { dictionary ->
                    SettingsScreen(
                        snapshot = settings,
                        dictionarySnapshot = dictionary,
                        dictionaryHealth = dictionaryHealth,
                        dictionaryImport = dictionaryImport,
                        dictionaryClear = dictionaryClear,
                        actions = SettingsActions(
                            onOpenThemeSelector = {
                                startActivity(
                                    LegacySettingsNavigation.themeSelectorIntent(this)
                                )
                            },
                            onOpenTerms = {
                                startActivity(LegacySettingsNavigation.legacyWebIntent(this, "tos_url"))
                            },
                            onOpenPrivacyPolicy = {
                                startActivity(
                                    LegacySettingsNavigation.legacyWebIntent(this, "privacy_url"),
                                )
                            },
                            onOpenLicenses = {
                                startActivity(LegacySettingsNavigation.licensesIntent(this))
                            },
                            onRefreshDictionaryHealth = ::refreshDictionaryHealth,
                            onAutomaticBackupEnabledChange = { enabled ->
                                if (!enabled) {
                                    dictionaryRepository.disableAutomaticBackup()
                                    dictionarySnapshot = dictionaryRepository.read()
                                } else if (dictionaryRepository.read().locationAccessible) {
                                    dictionaryRepository.enableAutomaticBackup()
                                    refreshDictionaryUntilIdle()
                                } else {
                                    treePurpose = TreePurpose.Enable
                                    treePicker.launch(null)
                                }
                            },
                            onChooseBackupLocation = {
                                treePurpose = TreePurpose.Location
                                treePicker.launch(null)
                            },
                            onBackupIntervalChange = { index ->
                                dictionaryRepository.setInterval(index)
                                dictionarySnapshot = dictionaryRepository.read()
                            },
                            onBackupRetentionChange = { index ->
                                dictionaryRepository.setRetention(index)
                                dictionarySnapshot = dictionaryRepository.read()
                            },
                            onBackupNow = {
                                dictionaryRepository.requestBackup()
                                refreshDictionaryUntilIdle()
                            },
                            onImportBackup = {
                                if (dictionaryRepository.read().locationAccessible) {
                                    openDictionaryImport()
                                } else {
                                    treePurpose = TreePurpose.Import
                                    treePicker.launch(null)
                                }
                            },
                            onDismissImportBackup = {
                                dictionaryImport = DictionaryImportStateReducer.close()
                            },
                            onSelectImportBackup = { entry ->
                                dictionaryImport = DictionaryImportStateReducer.select(
                                    dictionaryImport,
                                    entry,
                                )
                            },
                            onCancelImportConfirmation = {
                                dictionaryImport = DictionaryImportStateReducer.cancelConfirmation(
                                    dictionaryImport,
                                )
                            },
                            onConfirmImportBackup = {
                                dictionaryImport.selected?.let(dictionaryRepository::importBackup)
                                dictionaryImport = DictionaryImportStateReducer.close()
                            },
                            onShortcutsEnabledChange = { enabled ->
                                dictionaryRepository.setShortcutsEnabled(enabled)
                                dictionarySnapshot = dictionaryRepository.read()
                            },
                            onOpenShortcutEditor = dictionaryRepository::openShortcutEditor,
                            onContactSuggestionsEnabledChange = { enabled ->
                                if (!enabled) {
                                    dictionaryRepository.setContactSuggestionsEnabled(false)
                                    dictionarySnapshot = dictionaryRepository.read()
                                } else if (dictionaryRepository.read().contactsPermissionGranted) {
                                    dictionaryRepository.setContactSuggestionsEnabled(true)
                                    dictionarySnapshot = dictionaryRepository.read()
                                } else {
                                    contactsPermission.launch(Manifest.permission.READ_CONTACTS)
                                }
                            },
                            onOpenClearDictionaryConfirmation = {
                                val challenge = String.format(
                                    Locale.ROOT,
                                    "%04d",
                                    Random().nextInt(10_000),
                                )
                                dictionaryClear = DictionaryClearStateReducer.open(challenge)
                            },
                            onClearDictionaryInputChange = { input ->
                                dictionaryClear = DictionaryClearStateReducer.updateInput(
                                    dictionaryClear,
                                    input,
                                )
                            },
                            onDismissClearDictionaryConfirmation = {
                                dictionaryClear = DictionaryClearStateReducer.dismiss(dictionaryClear)
                            },
                            onConfirmClearDictionary = {
                                val startedState = DictionaryClearStateReducer.start(dictionaryClear)
                                val callback = dictionaryClearCallback
                                if (callback != null && dictionaryRepository.startClear(callback)) {
                                    dictionaryClear = startedState
                                    dictionarySnapshot = dictionaryRepository.read()
                                } else {
                                    dictionaryClear = DictionaryClearStateReducer.complete()
                                    Toast.makeText(
                                        this,
                                        R.string.modern_settings_dictionary_clear_error,
                                        Toast.LENGTH_LONG,
                                    ).show()
                                }
                            },
                            onLauncherIconVisibleChange = { visible ->
                                snapshot = controller.setLauncherIconVisible(visible)
                            },
                            onSoundEnabledChange = { enabled ->
                                snapshot = controller.setSoundEnabled(enabled)
                            },
                            onVolumeCommit = { percent ->
                                snapshot = controller.setVolumePercent(percent)
                            },
                            onVolumeDefault = {
                                snapshot = controller.restoreVolumeDefault()
                            },
                            onVibrationEnabledChange = { enabled ->
                                snapshot = controller.setVibrationEnabled(enabled)
                            },
                            onOneHandedModeChange = { index ->
                                snapshot = controller.setOneHandedModeIndex(index)
                            },
                            onPinyinSchemeChange = { index ->
                                snapshot = controller.setPinyinSchemeIndex(index)
                            },
                            onGestureInputEnabledChange = { enabled ->
                                snapshot = controller.setGestureInputEnabled(enabled)
                            },
                            onBooleanChange = { contract, enabled ->
                                snapshot = controller.setBoolean(contract, enabled)
                            },
                            onVibrationCommit = { milliseconds ->
                                snapshot = controller.setVibrationDuration(milliseconds)
                            },
                            onVibrationDefault = {
                                snapshot = controller.restoreVibrationDefault()
                            },
                            onKeyboardHeightChange = { index ->
                                snapshot = controller.setKeyboardHeightIndex(index)
                            },
                            onSlideSensitivityChange = { index ->
                                snapshot = controller.setSlideSensitivityIndex(index)
                            },
                            onLongPressDelayChange = { milliseconds ->
                                snapshot = controller.setLongPressDelay(milliseconds)
                            },
                            onLongPressDefault = {
                                snapshot = controller.restoreLongPressDefault()
                            },
                            onHandwritingTimeoutChange = { index ->
                                snapshot = controller.setHandwritingTimeoutIndex(index)
                            },
                            onHandwritingStrokeWidthChange = { index ->
                                snapshot = controller.setHandwritingStrokeWidthIndex(index)
                            },
                        ),
                    )
                    }
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        snapshot = controller.read()
        if (dictionaryRepository.isClearInProgress()) {
            dictionaryClear = DictionaryClearStateReducer.observeInProgress(true)
        } else if (dictionaryClear.inProgress) {
            // The process was recreated after the legacy task disappeared. Never retry a
            // destructive operation implicitly; report an unknown/failed completion and refresh.
            dictionaryClear = DictionaryClearStateReducer.complete()
            refreshDictionaryHealth()
            Toast.makeText(
                this,
                R.string.modern_settings_dictionary_clear_error,
                Toast.LENGTH_LONG,
            ).show()
        }
        refreshDictionaryUntilIdle()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putBoolean(CLEAR_DIALOG_VISIBLE_KEY, dictionaryClear.confirmationVisible)
        outState.putBoolean(CLEAR_IN_PROGRESS_KEY, dictionaryClear.inProgress)
        if (dictionaryClear.confirmationVisible) {
            outState.putString(CLEAR_CHALLENGE_KEY, dictionaryClear.challenge)
            outState.putString(CLEAR_INPUT_KEY, dictionaryClear.input)
        }
    }

    override fun onDestroy() {
        mainHandler.removeCallbacks(backupRefresh)
        dictionaryRepository.detachClearCallback(dictionaryClearCallback)
        dictionaryClearCallback = null
        super.onDestroy()
    }

    private fun refreshDictionaryHealth() {
        val started = DictionaryHealthStateReducer.start(dictionaryHealth)
        if (started == dictionaryHealth) return
        dictionaryHealth = started
        dictionaryRepository.loadHealth { result ->
            runOnUiThread {
                dictionaryHealth = DictionaryHealthStateReducer.complete(
                    dictionaryHealth,
                    result,
                )
            }
        }
    }

    private fun refreshDictionaryUntilIdle() {
        mainHandler.removeCallbacks(backupRefresh)
        backupRefresh.run()
    }

    private fun openDictionaryImport() {
        dictionaryImport = DictionaryImportStateReducer.open()
        dictionaryRepository.loadImportBackups { entries ->
            runOnUiThread {
                if (!isFinishing && !isDestroyed && dictionaryImport.visible) {
                    dictionaryImport = DictionaryImportStateReducer.loaded(entries)
                }
            }
        }
    }

    private companion object {
        const val CLEAR_DIALOG_VISIBLE_KEY = "modern_dictionary_clear_dialog_visible"
        const val CLEAR_IN_PROGRESS_KEY = "modern_dictionary_clear_in_progress"
        const val CLEAR_CHALLENGE_KEY = "modern_dictionary_clear_challenge"
        const val CLEAR_INPUT_KEY = "modern_dictionary_clear_input"
    }
}

@Composable
private fun ModernSettingsTheme(content: @Composable () -> Unit) {
    val context = LocalContext.current
    val dark = (context.resources.configuration.uiMode and 0x30) == 0x20
    val colors = when {
        Build.VERSION.SDK_INT >= 31 && dark -> dynamicDarkColorScheme(context)
        Build.VERSION.SDK_INT >= 31 -> dynamicLightColorScheme(context)
        dark -> darkColorScheme()
        else -> lightColorScheme()
    }
    val layoutDirection = modernSettingsLayoutDirection(
        context.resources.configuration.layoutDirection,
    )
    CompositionLocalProvider(LocalLayoutDirection provides layoutDirection) {
        MaterialTheme(colorScheme = colors, content = content)
    }
}

internal fun modernSettingsLayoutDirection(configurationLayoutDirection: Int): LayoutDirection =
    if (configurationLayoutDirection == View.LAYOUT_DIRECTION_RTL) {
        LayoutDirection.Rtl
    } else {
        LayoutDirection.Ltr
    }
