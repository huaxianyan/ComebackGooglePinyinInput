package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.graphics.drawable.Drawable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
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

    /** `bdc`: the grid cell kinds, each carrying the layout it inflates. */
    private const val CARD_KIND_CLASS = "bdc"

    /** The layout id field on a cell kind. */
    private const val CARD_LAYOUT_FIELD = "layoutResourceId"

    /** `bdc.CANDIDATE`: a cell for one theme. */
    private const val CARD_KIND_THEME = "CANDIDATE"

    /** The card root, which draws the tick over the theme in use. */
    private const val CARD_CLASS =
        "com.google.android.apps.inputmethod.libs.theme.preference.CheckableFrameLayout"

    private const val CARD_CHECK_METHOD = "setChecked"

    /**
     * Tags on the parts of the sample layout the swatch keeps.
     *
     * The layout is the legacy selector's, so the tags are the legacy engine's
     * own selectors rather than anything added here. The body is the one whose
     * background carries the keyboard's body colour; the other two carry the
     * lighter accents the swatch shows on top of it.
     */
    private const val BODY_TAG = ".keyboard-body-area"
    private const val SPACE_TAG = ".space_bar"
    private const val ACTION_ICON_TAG = ".background-icon.for-action-key.for-preview"
    private const val KEYBOARD_BACKGROUND_TAG = ".keyboard-background.for-preview"

    private val KEPT_TAGS = setOf(SPACE_TAG, ACTION_ICON_TAG, KEYBOARD_BACKGROUND_TAG)

    /**
     * `gc`: resolves the key-border flag the renderer reads.
     *
     * The flag has a system-property fallback, so the stored value and the
     * effective value are not the same thing. Reading through this class is
     * what keeps the switch agreeing with the picture next to it.
     */
    private const val BORDER_STATE_CLASS = "gc"

    /** `gc.c(Context)`: the key-border flag as the renderer sees it. */
    private const val BORDER_STATE_METHOD = "c"

    /** The preference behind that flag. It carries no forced value. */
    private const val KEY_BORDER_KEY = "enable_key_border"

    /** `baq.a(Context)`: the theme descriptor actually in effect. */
    private const val DESCRIPTOR_FACTORY = "a"

    /**
     * The field on that descriptor holding the theme value.
     *
     * `baq.a` holds a legacy base-theme name; `baq.b` holds the theme package
     * value, empty only when the engine itself has no theme.
     */
    private const val DESCRIPTOR_VALUE_FIELD = "b"

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

    /**
     * Builds one grid cell: the theme's colours as a flat swatch.
     *
     * The legacy sample layout draws a keyboard cut down to a stamp, which at
     * tile size reads as a smudge of keys rather than as a colour. So the swatch
     * keeps only the three parts that carry the theme's palette and drops the
     * rest:
     *
     * * the body view's background becomes the whole tile, giving the keyboard's
     *   own body colour;
     * * the space bar stays, giving the lighter accent that sits on top of it;
     * * the action-key icon stays, giving the theme's accent dot;
     * * the header strip and the flat placeholder are hidden, and the keyboard
     *   background view is kept so a theme built from a picture still shows it.
     *
     * Returns `null` when the cell cannot be built, so the caller can leave the
     * slot empty rather than show a broken card.
     */
    fun inflateThemeSwatch(context: Context, themeValue: String): View? = runCatching {
        val card = inflateCard(context, themeValue)
        // The layout is a `CheckableFrameLayout` wrapping the included preview,
        // so the parts live one level down.
        val container = card.getChildAt(0) as? ViewGroup ?: card
        // The included preview is a fixed 128x92 dip, which is not the tile's
        // size. Left as-is it overflows the card, and the parts anchored to its
        // bottom edge - the space bar and the accent dot - end up hanging past
        // the tile and get clipped away. Stretching it to the card puts them
        // back inside.
        container.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT,
        )
        val body = container.findViewWithTag<View>(BODY_TAG)
        card.background = body?.background?.constantState?.newDrawable()
        for (index in 0 until container.childCount) {
            val child = container.getChildAt(index)
            val tag = child.tag as? String
            when {
                tag == null || tag !in KEPT_TAGS -> child.visibility = View.GONE
                // A full-bleed background, so it stretches with the container.
                tag == KEYBOARD_BACKGROUND_TAG -> child.layoutParams =
                    FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.MATCH_PARENT,
                    )
            }
        }
        card
    }.getOrNull()

    /** Draws or clears the tick the cell for the theme in use shows. */
    fun markSelected(card: View, selected: Boolean) {
        runCatching {
            val cardClass = Class.forName(CARD_CLASS)
            if (cardClass.isInstance(card)) {
                cardClass
                    .getMethod(CARD_CHECK_METHOD, Boolean::class.javaPrimitiveType)
                    .invoke(card, selected)
            }
        }
    }

    /**
     * The theme the keyboard is actually using.
     *
     * Not the stored preference: the stored value is empty on a device that has
     * never picked a theme, while the engine still draws something. The engine
     * resolves that through `baq.a(Context)`, so this reads the same call the
     * legacy selector opens its preview with.
     *
     * `null` when even the engine has nothing to say, which leaves the caller
     * to fall back rather than render a guess.
     */
    fun activeThemeValue(context: Context): String? = runCatching {
        val descriptor = Class.forName(DESCRIPTOR_CLASS)
            .getMethod(DESCRIPTOR_FACTORY, Context::class.java)
            .invoke(null, context)
        descriptor.javaClass.getField(DESCRIPTOR_VALUE_FIELD).get(descriptor) as? String
    }.getOrNull()?.takeIf { it.isNotEmpty() }

    /**
     * Whether the keyboard draws a border around each key.
     *
     * Read through the engine rather than from the preference, because the
     * preference has a system-property fallback and the renderer applies that
     * fallback. Reading the stored value alone would let the switch disagree
     * with the picture beside it.
     */
    fun keyBorderEnabled(context: Context): Boolean = runCatching {
        Class.forName(BORDER_STATE_CLASS)
            .getMethod(BORDER_STATE_METHOD, Context::class.java)
            .invoke(null, context) as? Boolean ?: false
    }.getOrDefault(false)

    /**
     * Turns the key border on or off.
     *
     * This one is a plain preference with no forced value and no slot behind
     * it, so it can be written on its own, ahead of the theme write path.
     */
    fun setKeyBorderEnabled(context: Context, enabled: Boolean) {
        runCatching {
            val facade = facade(context) ?: return
            facade.javaClass
                .getMethod(
                    PREFERENCES_ACCESSOR,
                    String::class.java,
                    Boolean::class.javaPrimitiveType,
                )
                .invoke(facade, KEY_BORDER_KEY, enabled)
        }
    }

    private fun inflateCard(context: Context, themeValue: String): ViewGroup {
        val cardContext = appliedContext(context, themeValue)
        val layoutId = Class.forName(CARD_KIND_CLASS)
            .getField(CARD_KIND_THEME)
            .get(null)
            .let { constant -> constant.javaClass.getField(CARD_LAYOUT_FIELD).getInt(constant) }
        return LayoutInflater.from(cardContext).inflate(layoutId, null, false) as ViewGroup
    }

    /**
     * A context with [themeValue] applied on top of it.
     *
     * The extra boolean is the key-border flag: the renderer leaves it to the
     * engine, but the grid passes `false`, because a card the size of a stamp
     * would just look noisy with borders on.
     */
    private fun appliedContext(context: Context, themeValue: String): Context {
        val descriptorClass = Class.forName(DESCRIPTOR_CLASS)
        val descriptor = descriptorClass
            .getMethod(DESCRIPTOR_FACTORY, Context::class.java, String::class.java)
            .invoke(null, context, themeValue)
        val wrapped = Class.forName(WRAPPED_CONTEXT_CLASS)
            .getConstructor(Context::class.java)
            .newInstance(context) as Context
        val theme = Class.forName(THEME_CLASS)
            .getConstructor(
                Context::class.java,
                descriptorClass,
                Boolean::class.javaPrimitiveType,
                Boolean::class.javaPrimitiveType,
            )
            .newInstance(wrapped, descriptor, false, false)
        theme.javaClass
            .getMethod("applyToContext", Context::class.java)
            .invoke(theme, wrapped)
        return wrapped
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
            .getMethod(DESCRIPTOR_FACTORY, Context::class.java, String::class.java)
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
