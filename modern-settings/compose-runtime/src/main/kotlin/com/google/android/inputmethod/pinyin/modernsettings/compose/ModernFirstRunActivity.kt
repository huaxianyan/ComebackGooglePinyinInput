package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Intent
import android.database.ContentObserver
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue

/**
 * The Compose host for the first-run guide.
 *
 * A second activity rather than a route of [ModernSettingsActivity]: the guide
 * is not part of the settings hierarchy. It opens before the keyboard is
 * enabled, back from it leaves to the home screen rather than to a settings
 * page, and finishing it opens settings as a new task. None of that is what the
 * settings route stack does, and bending that stack to fit would put a page
 * above the settings home that back then has to skip.
 *
 * The legacy [PinyinFirstRunActivity] still owns the launch gate - it decides
 * whether a guide is due at all, and discards a late singleTask intent - and
 * hands the guide over to this activity on every supported version. The
 * completion marker, the launch claim and the legacy-key migration all stay in
 * [FirstRunStateBridge], so both hosts read and write one state.
 */
class ModernFirstRunActivity : ComponentActivity() {
    private var setupState by mutableStateOf(FirstRunSetupState())
    private val inputMethodObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
        override fun onChange(selfChange: Boolean) = refreshSetupState()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        FirstRunStateBridge.activityCreated()
        // A late singleTask intent after completion must be discarded silently.
        // Showing the settings screen instead would behave like a second Home
        // press and can open a third-party launcher's app drawer.
        if (FirstRunStateBridge.isComplete(this)) {
            finishAndRemoveTask()
            return
        }
        setContent {
            ModernSettingsTheme {
                BackHandler { exitToHome() }
                FirstRunScreen(
                    state = setupState,
                    onOpenInputMethodSettings = ::openInputMethodSettings,
                    onOpenInputMethodPicker = ::openInputMethodPicker,
                    onFinish = ::finishGuide,
                )
            }
        }
    }

    override fun onStart() {
        super.onStart()
        // The system picker can change the default while this Activity remains
        // resumed. Observe the actual setting instead of relying on re-entry.
        contentResolver.registerContentObserver(
            Settings.Secure.getUriFor(Settings.Secure.DEFAULT_INPUT_METHOD),
            false,
            inputMethodObserver,
        )
    }

    override fun onResume() {
        super.onResume()
        refreshSetupState()
    }

    override fun onStop() {
        contentResolver.unregisterContentObserver(inputMethodObserver)
        super.onStop()
    }

    private fun refreshSetupState() {
        setupState = readFirstRunSetupState(this)
    }

    override fun onDestroy() {
        FirstRunStateBridge.activityDestroyed(this)
        super.onDestroy()
    }

    private fun openInputMethodSettings() {
        startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
    }

    private fun openInputMethodPicker() {
        getSystemService(InputMethodManager::class.java)?.showInputMethodPicker()
    }

    /**
     * Records completion, then opens settings.
     *
     * The order matters: the marker is committed synchronously first, so the
     * IME starting up in the same window cannot enqueue the guide again. The
     * legacy settings activity is named as a string because it lives in the
     * primary DEX; on every supported version it redirects to the
     * Compose settings screen on its own.
     */
    private fun finishGuide() {
        FirstRunStateBridge.complete(this)
        startActivity(Intent().setClassName(this, LEGACY_SETTINGS_ACTIVITY))
        finish()
    }

    /** Leaves the way the legacy guide left: home, and the guide's task removed. */
    private fun exitToHome() {
        startActivity(
            Intent(Intent.ACTION_MAIN)
                .addCategory(Intent.CATEGORY_HOME)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP),
        )
        finishAndRemoveTask()
    }
}

private const val LEGACY_SETTINGS_ACTIVITY =
    "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity"
