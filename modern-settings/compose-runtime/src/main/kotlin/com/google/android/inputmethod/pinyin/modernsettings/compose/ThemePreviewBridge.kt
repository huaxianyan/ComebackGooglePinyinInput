package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.SharedPreferences
import android.graphics.drawable.Drawable
import java.lang.reflect.InvocationHandler
import java.lang.reflect.Proxy

/**
 * Reflection bridge to the engine's keyboard preview renderer.
 *
 * The legacy selector does not draw a preview out of resources. It builds the
 * renderer with the theme's style sheet already applied, so reusing that class
 * is the only way to get a picture that matches the theme a user will end up
 * with. Everything here is reflection, because this module compiles against no
 * part of the packaged APK: the obfuscated names are the only handle available.
 *
 * `scripts/verify_theme_preview_bridge.py` asserts that every symbol named here
 * still exists in the decoded APK, so an upstream rename fails the build instead
 * of failing at runtime.
 *
 * Two calls must happen on the main thread. The renderer asserts it, and throws
 * `IllegalThreadStateException` when violated.
 */
internal object ThemePreviewBridge {

    /** `baq`: the theme descriptor the renderer consumes. */
    private const val DESCRIPTOR_CLASS = "baq"

    /** `bck`: the `IKeyboardTheme` implementation built from a descriptor. */
    private const val THEME_CLASS = "bck"

    /** `bbb`: context wrapper that swaps in the theme-aware layout inflater. */
    private const val WRAPPED_CONTEXT_CLASS = "bbb"

    /** `ats`: holder of the fixed `KeyboardViewDef$Type` array. */
    private const val VIEW_DEF_HOLDER_CLASS = "ats"

    private const val RENDERER_CLASS =
        "com.google.android.apps.inputmethod.libs.framework.keyboard.KeyboardPreviewRenderer"

    private const val THEME_INTERFACE =
        "com.google.android.apps.inputmethod.libs.framework.keyboard.IKeyboardTheme"

    private const val CANCELER_INTERFACE =
        "com.google.android.apps.inputmethod.libs.framework.keyboard.KeyboardPreviewRenderer\$KeyboardPreviewRequestCanceler"

    private const val RECEIVER_INTERFACE =
        "com.google.android.apps.inputmethod.libs.framework.keyboard.KeyboardPreviewRenderer\$KeyboardPreviewReceiver"

    private const val REQUEST_METHOD = "a"
    private const val RECEIVER_METHOD = "onKeyboardPreviewReady"
    private const val CANCEL_METHOD = "cancelRequest"

    /**
     * Legacy preference keys, which are the values of the matching `R.string`
     * entries. Both carry forced values written by the application on start, so
     * the renderer never hits its "please set" guard.
     */
    private const val PREVIEW_BUNDLES_KEY = "preview_input_bundles_xml_id"
    private const val PREVIEW_LAYOUT_KEY = "preview_keyboard_layout"

    /** The scale the legacy selector passes. Previews are drawn at half size. */
    private const val PREVIEW_SCALE = 0.5f

    /** Cancels a preview request that has not finished yet. */
    fun interface Canceler {
        fun cancel()
    }

    /**
     * Reports whether a preview can be requested at all.
     *
     * False means the packaged renderer is missing, or the two forced
     * preferences are absent. Either way the caller should fall back to a
     * text-only row rather than showing an empty frame.
     */
    fun isAvailable(context: Context): Boolean =
        runCatching {
            Class.forName(RENDERER_CLASS)
            val preferences = preferences(context)
            preferences.getInt(PREVIEW_BUNDLES_KEY, 0) != 0 &&
                !preferences.getString(PREVIEW_LAYOUT_KEY, "").isNullOrEmpty()
        }.getOrDefault(false)

    /**
     * Renders [themeValue] and hands the drawable to [onReady] on the main
     * thread.
     *
     * Returns a handle that cancels a still-pending request, or `null` when the
     * renderer answered synchronously out of its cache. Failures are swallowed:
     * a preview is decoration, and must never take the settings screen down.
     */
    fun render(
        context: Context,
        themeValue: String,
        onReady: (Drawable) -> Unit,
    ): Canceler? {
        if (themeValue.isEmpty()) return null
        val preferences = preferences(context)
        val bundlesXmlId = preferences.getInt(PREVIEW_BUNDLES_KEY, 0)
        val layoutName = preferences.getString(PREVIEW_LAYOUT_KEY, "").orEmpty()
        if (bundlesXmlId == 0 || layoutName.isEmpty()) return null
        return runCatching {
            requestPreview(context, themeValue, bundlesXmlId, layoutName, onReady)
        }.getOrNull()
    }

    private fun requestPreview(
        context: Context,
        themeValue: String,
        bundlesXmlId: Int,
        layoutName: String,
        onReady: (Drawable) -> Unit,
    ): Canceler? {
        val descriptorClass = Class.forName(DESCRIPTOR_CLASS)
        val descriptor = descriptorClass
            .getMethod("a", Context::class.java, String::class.java)
            .invoke(null, context, themeValue)

        val themeInterface = Class.forName(THEME_INTERFACE)
        val theme = Class.forName(THEME_CLASS)
            .getConstructor(
                Context::class.java,
                descriptorClass,
                Boolean::class.javaPrimitiveType,
            )
            .newInstance(context, descriptor, false)

        val viewDefs = Class.forName(VIEW_DEF_HOLDER_CLASS).getField("a").get(null)
        val wrappedContext = Class.forName(WRAPPED_CONTEXT_CLASS)
            .getConstructor(Context::class.java)
            .newInstance(context)

        val rendererClass = Class.forName(RENDERER_CLASS)
        val renderer = rendererClass
            .getConstructor(
                Context::class.java,
                themeInterface,
                viewDefs.javaClass,
                Float::class.javaPrimitiveType,
            )
            .newInstance(wrappedContext, theme, viewDefs, PREVIEW_SCALE)

        val receiverInterface = Class.forName(RECEIVER_INTERFACE)
        val receiver = Proxy.newProxyInstance(
            receiverInterface.classLoader,
            arrayOf(receiverInterface),
            previewReceiver(onReady),
        )

        val handle = rendererClass
            .getMethod(
                REQUEST_METHOD,
                Int::class.javaPrimitiveType,
                String::class.java,
                receiverInterface,
            )
            .invoke(renderer, bundlesXmlId, layoutName, receiver)
            ?: return null

        val cancelMethod = Class.forName(CANCELER_INTERFACE).getMethod(CANCEL_METHOD)
        return Canceler { runCatching { cancelMethod.invoke(handle) } }
    }

    private fun previewReceiver(onReady: (Drawable) -> Unit) =
        InvocationHandler { _, method, args ->
            if (method.name == RECEIVER_METHOD) {
                (args?.getOrNull(1) as? Drawable)?.let(onReady)
            }
            null
        }

    private fun preferences(context: Context): SharedPreferences {
        val app = context.applicationContext
        return app.getSharedPreferences(
            "${app.packageName}_preferences",
            Context.MODE_PRIVATE,
        )
    }
}
