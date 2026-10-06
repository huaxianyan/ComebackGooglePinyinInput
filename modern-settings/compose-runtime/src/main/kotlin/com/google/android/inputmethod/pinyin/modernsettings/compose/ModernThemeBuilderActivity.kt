package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import java.io.File

/**
 * The Compose host for the custom-theme wizard.
 *
 * A second activity rather than a route of [ModernSettingsActivity]: the wizard
 * is a full-screen gesture surface, and it opens over a picture picker that
 * takes over the screen anyway. Putting it inside the settings hierarchy would
 * mean a route whose back behaviour is nothing like its neighbours'.
 *
 * It serves both halves of the legacy pair - the builder that creates a theme
 * from a picture and the editor that replaces the picture of an existing one -
 * because they are the same wizard. The only difference is where the picture
 * comes from and what is reported back:
 *
 * * no target extra: ask for a picture, and report the package written;
 * * a target extra: re-edit that package, and report the package written *and*
 *   the one removed, which is the pair the legacy editor reported and the pair
 *   the slot bridge reads.
 *
 * The result extra names are the legacy ones on purpose. They are the contract
 * between this activity and `SystemAutoThemeCompat`, which turns the pair into
 * the slot writes, so they are not this module's to rename.
 */
class ModernThemeBuilderActivity : ComponentActivity() {
    private var model by mutableStateOf<Any?>(null)
    private var bitmap by mutableStateOf<Bitmap?>(null)
    private var failure by mutableStateOf(false)
    private var editTarget: File? = null
    private var initialTransparency = ThemeBuilderBridge.DEFAULT_TRANSPARENCY
    private var initialCropScale = 0f
    private var initialCropCenter = 0f to 0f

    private val picker = registerForActivityResult(ActivityResultContracts.GetContent()) { uri ->
        if (uri == null) {
            // A cancelled picker is a cancelled wizard: there is nothing to go
            // back to, so leave rather than sit on an empty screen.
            setResult(Activity.RESULT_CANCELED)
            finish()
            return@registerForActivityResult
        }
        val bytes = readBytes(uri)
        if (bytes == null) failure = true else start(bytes)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        editTarget = intent?.getStringExtra(EXTRA_TARGET)
            ?.takeIf { it.isNotEmpty() }
            ?.let(::File)
        if (savedInstanceState != null && model != null) {
            setContent { Wizard() }
            return
        }
        if (!ThemeBuilderBridge.available) {
            failure = true
            setContent { Wizard() }
            return
        }
        val target = editTarget
        if (target == null) {
            picker.launch(IMAGE_TYPE)
        } else {
            val bytes = reopen(target)
            if (bytes == null) failure = true else start(bytes)
        }
    }

    private fun reopen(target: File): ByteArray? {
        val pkg = ThemeBuilderBridge.openPackage(target) ?: return null
        val bytes = ThemeBuilderBridge.packageImage(pkg) ?: return null
        // The previous framing is restored so that re-editing a theme does not
        // silently discard the crop and the brightness the user chose last time.
        initialTransparency = ThemeBuilderBridge.styleValue(
            pkg,
            ThemeBuilderBridge.KEY_OVERLAY_TRANSPARENCY,
            ThemeBuilderBridge.DEFAULT_TRANSPARENCY,
        )
        initialCropScale = ThemeBuilderBridge.styleValue(
            pkg,
            ThemeBuilderBridge.KEY_CROPPING_SCALE,
            0f,
        )
        initialCropCenter = ThemeBuilderBridge.styleValue(
            pkg,
            ThemeBuilderBridge.KEY_CROPPING_CENTER_X,
            0f,
        ) to ThemeBuilderBridge.styleValue(
            pkg,
            ThemeBuilderBridge.KEY_CROPPING_CENTER_Y,
            0f,
        )
        return bytes
    }

    private fun start(bytes: ByteArray) {
        val built = ThemeBuilderBridge.newModel(bytes)
        val decoded = built?.let(ThemeBuilderBridge::sourceBitmap)
        if (built == null || decoded == null) {
            failure = true
            setContent { Wizard() }
            return
        }
        model = built
        bitmap = decoded
        setContent { Wizard() }
    }

    @androidx.compose.runtime.Composable
    private fun Wizard() {
        ModernSettingsTheme {
            val current = model
            val picture = bitmap
            if (current == null || picture == null) {
                FailureNotice()
                return@ModernSettingsTheme
            }
            val keyboardWidth = ThemeBuilderBridge.keyboardWidth(this).coerceAtLeast(1)
            val keyboardHeight = ThemeBuilderBridge.keyboardHeight(this)
            CustomThemeBuilderScreen(
                context = this,
                model = current,
                bitmap = picture,
                previewRatio = ThemeBuilderBridge.previewRatio(this),
                keyboardAspect = keyboardHeight.toFloat() / keyboardWidth,
                initialTransparency = initialTransparency,
                initialCropScale = initialCropScale,
                initialCropCenter = initialCropCenter,
                onCancel = {
                    setResult(Activity.RESULT_CANCELED)
                    finish()
                },
                onSave = ::complete,
            )
        }
    }

    @androidx.compose.runtime.Composable
    private fun FailureNotice() {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Text(
                text = androidx.compose.ui.res.stringResource(
                    if (failure) R.string.modern_theme_builder_error_load
                    else R.string.modern_theme_builder_error_write,
                ),
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface,
            )
        }
    }

    /**
     * Reports the package that was written, and in edit mode the one it replaced.
     *
     * The removed name is only reported once the file is really gone, which is
     * the legacy editor's own rule: the bridge repoints slots off that name, and
     * a name that still has a package behind it would leave the theme list with
     * two entries for one theme.
     */
    private fun complete(newName: String) {
        val data = Intent().putExtra(RESULT_NEW_NAME, newName)
        val replaced = editTarget
        if (replaced != null && replaced.name.isNotEmpty() && replaced.delete()) {
            data.putExtra(RESULT_DELETED_NAME, replaced.name)
        }
        setResult(Activity.RESULT_OK, data)
        finish()
    }

    private fun readBytes(uri: Uri): ByteArray? = runCatching {
        contentResolver.openInputStream(uri)?.use { stream ->
            val bytes = stream.readBytes()
            bytes.takeIf { it.size <= MAX_IMAGE_BYTES }
        }
    }.getOrNull()

    companion object {
        /** The package to re-edit, as an absolute path. Absent means "create". */
        const val EXTRA_TARGET = "target_user_image_theme_file_name"

        /** The bare name of the package this activity wrote. */
        const val RESULT_NEW_NAME = "intent_extra_key_new_theme_file_name"

        /** The bare name of the package it removed, when it removed one. */
        const val RESULT_DELETED_NAME = "intent_extra_key_deleted_theme_file_name"

        private const val IMAGE_TYPE = "image/*"

        /**
         * A ceiling on the picked picture, well above any phone camera output.
         *
         * The engine downsamples what it is given, so the only thing this
         * prevents is reading a file so large that holding it in memory once is
         * itself the problem.
         */
        private const val MAX_IMAGE_BYTES = 48 * 1024 * 1024

        /**
         * The intent that opens the wizard.
         *
         * [target] is the package to re-edit; leaving it out asks for a new
         * picture. The class is named explicitly rather than resolved, the same
         * way every other Compose host in this module is reached.
         */
        fun intent(context: Context, target: File? = null): Intent =
            Intent()
                .setClassName(context, ModernThemeBuilderActivity::class.java.name)
                .apply { if (target != null) putExtra(EXTRA_TARGET, target.absolutePath) }
    }
}
