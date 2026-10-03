package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
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

    /**
     * `amx`: the preference facade the whole application reads through.
     *
     * The two preferences below are never written to disk. The application
     * pushes them into an in-memory forced-value map while starting up, and the
     * facade answers from that map before it ever consults `SharedPreferences`.
     * Reading `SharedPreferences` directly therefore yields nothing at all,
     * which is why the first build of this preview disabled itself on a device
     * where the legacy selector renders perfectly well.
     */
    private const val PREFERENCES_CLASS = "amx"

    /** `amx.a`: overloaded accessor, for the facade and for both read types. */
    private const val PREFERENCES_ACCESSOR = "a"

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
     * entries. Both carry forced values, so the renderer never hits the guard
     * that asks the caller to set them.
     */
    private const val PREVIEW_BUNDLES_KEY = "preview_input_bundles_xml_id"
    private const val PREVIEW_LAYOUT_KEY = "preview_keyboard_layout"

    /**
     * Scale the renderer rasterises at.
     *
     * The legacy selector passes `0.5f` because it shows the result at half
     * size. The renderer measures the keyboard as exactly the screen width, so
     * at `1.0f` the bitmap comes out at the size the real keyboard occupies.
     * Rendering at `0.5f` and letting the view stretch it back up doubles the
     * resampling, which is what softened every hairline in the first build.
     */
    private const val PREVIEW_SCALE = 1.0f

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
            bundlesXmlId(context) != 0 && layoutName(context).isNotEmpty()
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
        val bundlesXmlId = bundlesXmlId(context)
        val layoutName = layoutName(context)
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

    /**
     * The input-bundle XML the preview renders, as an `R.xml` id.
     *
     * Forced values win over anything on disk, exactly as they do for the
     * legacy selector, so the two agree on what the preview shows.
     */
    private fun bundlesXmlId(context: Context): Int =
        readInt(context, PREVIEW_BUNDLES_KEY, 0)

    /** The layout inside that bundle, for example `zh_cn_pinyin_qwerty`. */
    private fun layoutName(context: Context): String =
        readString(context, PREVIEW_LAYOUT_KEY, "")

    private fun readInt(context: Context, key: String, fallback: Int): Int {
        val facade = facade(context) ?: return fallback
        return facade.javaClass
            .getMethod(
                PREFERENCES_ACCESSOR,
                String::class.java,
                Int::class.javaPrimitiveType,
            )
            .invoke(facade, key, fallback) as? Int ?: fallback
    }

    private fun readString(context: Context, key: String, fallback: String): String {
        val facade = facade(context) ?: return fallback
        return facade.javaClass
            .getMethod(
                PREFERENCES_ACCESSOR,
                String::class.java,
                String::class.java,
            )
            .invoke(facade, key, fallback) as? String ?: fallback
    }

    private fun facade(context: Context): Any? =
        Class.forName(PREFERENCES_CLASS)
            .getMethod(PREFERENCES_ACCESSOR, Context::class.java)
            .invoke(null, context)
}
