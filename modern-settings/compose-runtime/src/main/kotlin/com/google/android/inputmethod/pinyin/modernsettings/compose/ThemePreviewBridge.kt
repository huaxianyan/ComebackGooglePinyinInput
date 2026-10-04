package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.graphics.drawable.Drawable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import java.lang.reflect.InvocationHandler
import java.lang.reflect.Method
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
 *
 * Every lookup goes through [engineMethod] rather than `Class.getMethod`,
 * because the engine overloads by return type. `gc` declares both
 * `c(Context): File` and `c(Context): boolean`, and the preference facade
 * declares a boolean getter and a boolean setter under the same name and
 * parameters. `getMethod` matches on name and parameters alone, so it returns
 * whichever the runtime lists first, and a wrong pick throws
 * `ClassCastException` inside a `runCatching`, which reads as "false" rather
 * than as a failure. Naming the return type is the only way to ask for the one
 * that was meant.
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
     *
     * This class also declares `c(Context)` returning a `File`, which is why
     * the read below has to name the return type: `getMethod` cannot tell the
     * two apart, and picking the `File` one made the switch report `false` for
     * every setting while the renderer, which resolves the call statically, drew
     * borders.
     */
    private const val BORDER_STATE_CLASS = "gc"

    /** `gc.c(Context)`: the key-border flag as the renderer sees it. */
    private const val BORDER_STATE_METHOD = "c"

    /** The preference behind that flag. It carries no forced value. */
    private const val KEY_BORDER_KEY = "enable_key_border"

    /**
     * The compatibility bridge that builds the generated palette package.
     *
     * Unlike everything else here it is not an upstream class: this project
     * adds it, so `scripts/verify_theme_preview_bridge.py` checks the method
     * against the smali the build injects rather than against the original APK.
     */
    private const val DYNAMIC_PREPARE_CLASS =
        "com.google.android.inputmethod.pinyin.SystemAutoThemeCompat"

    /** Builds that package, without switching the mode on. */
    private const val DYNAMIC_PREPARE_METHOD = "prepareDynamicTheme"

    /** `baq.a(Context)`: the theme descriptor actually in effect. */
    private const val DESCRIPTOR_FACTORY = "a"

    /** The field on that descriptor holding the legacy base-theme name. */
    private const val DESCRIPTOR_BASE_FIELD = "a"

    /** `gc`: resolves a theme value to a package, and validates one. */
    private const val RESOLVER_CLASS = "gc"

    /** `gc.a(Context, String)`: the value as a package, or `null`. */
    private const val RESOLVER_RESOLVE_METHOD = "a"

    /** `gc.b(Context, String)`: the check the default path runs first. */
    private const val RESOLVER_VALIDATE_METHOD = "b"

    /**
     * `bbc`: the layout inflater the theme application step insists on.
     *
     * `applyToContext` looks the inflater up by name and gives up on the whole
     * package when it is not this type, which is a silent failure.
     */
    private const val THEMED_INFLATER_CLASS = "bbc"

    private const val THEME_PACKAGE_INTERFACE =
        "com.google.android.apps.inputmethod.libs.theme.core.ThemePackage"

    private const val STYLE_SHEET_CLASS =
        "com.google.android.apps.inputmethod.libs.theme.proto.nano.StyleSheetProto\$StyleSheet"

    private const val STYLE_RULE_CLASS =
        "com.google.android.apps.inputmethod.libs.theme.proto.nano.StyleSheetProto\$StyleRule"

    private const val CUSTOM_PROPERTY_CLASS =
        "com.google.android.apps.inputmethod.libs.theme.proto.nano.StyleSheetProto\$a"


    /** The wrapper the renderer puts between its caller and the theme step. */
    private const val CONTEXT_THEME_WRAPPER_CLASS = "android.view.ContextThemeWrapper"

    /** The call the renderer makes on that wrapper before applying the theme. */
    private const val APPLY_OVERRIDE_METHOD = "applyOverrideConfiguration"

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
     * Primitive `Class` handles, which reflection insists on and Kotlin types as
     * nullable. `Void.TYPE` is used inline where it is needed; these two are
     * named because they appear more than once.
     */
    private val BOOLEAN_TYPE = Boolean::class.javaPrimitiveType!!
    private val INT_TYPE = Int::class.javaPrimitiveType!!

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
     * Renders [themeValue] with [keyBorder] and hands the drawable to [onReady]
     * on the main thread.
     *
     * The border is a parameter rather than something the renderer resolves for
     * itself. Left to itself it reads the preference, which is a whole-sheet
     * value: a sheet opened while the preference said one thing would draw that
     * while the switch beside it said another, and the two could drift apart
     * between the read and the render. Passing it makes the switch the single
     * source for the picture next to it.
     *
     * Returns a handle that cancels a still-pending request, or `null` when the
     * renderer answered synchronously out of its cache. Failures are swallowed:
     * a preview is decoration, and must never take the settings screen down.
     */
    fun render(
        context: Context,
        themeValue: String,
        keyBorder: Boolean,
        onReady: (Drawable) -> Unit,
    ): Canceler? {
        if (themeValue.isEmpty()) return null
        val bundlesXmlId = bundlesXmlId(context)
        val layoutName = layoutName(context)
        if (bundlesXmlId == 0 || layoutName.isEmpty()) return null
        return runCatching {
            requestPreview(context, themeValue, keyBorder, bundlesXmlId, layoutName, onReady)
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
     *
     * The read names its return type: `gc` also has a `c(Context)` that returns
     * a `File`, and resolving to that one is silent - the cast fails inside the
     * `runCatching` and the switch reports `false` no matter what is stored.
     */
    fun keyBorderEnabled(context: Context): Boolean = runCatching {
        engineMethod(
            BORDER_STATE_CLASS,
            BORDER_STATE_METHOD,
            BOOLEAN_TYPE,
            Context::class.java,
        ).invoke(null, context) as? Boolean ?: false
    }.getOrDefault(false)

    /**
     * Turns the key border on or off.
     *
     * This one is a plain preference with no forced value and no slot behind
     * it, so it can be written on its own, ahead of the theme write path.
     *
     * The return type is named here too, and this is the overload pair that
     * makes it necessary: the facade declares `a(String, boolean)` returning the
     * stored value *and* `a(String, boolean)` returning nothing, so a lookup by
     * name and parameters alone can land on the getter and turn the write into
     * a read whose result is thrown away.
     */
    fun setKeyBorderEnabled(context: Context, enabled: Boolean) {
        runCatching {
            val facade = facade(context) ?: return
            engineMethod(
                PREFERENCES_CLASS,
                PREFERENCES_ACCESSOR,
                Void.TYPE,
                String::class.java,
                BOOLEAN_TYPE,
            ).invoke(facade, KEY_BORDER_KEY, enabled)
        }
    }

    /**
     * Builds the generated-palette package and returns the value it is
     * addressed by, or `null` when there is no palette to build from.
     *
     * The mode has no package until something generates one, and the tile that
     * offers it has to draw a palette before the mode is switched on. Building
     * the package leaves the theme in use alone: the caller gets something to
     * render, not a changed setting. Once built, asking again is a no-op.
     */
    fun prepareDynamicTheme(context: Context): String? = runCatching {
        Class.forName(DYNAMIC_PREPARE_CLASS)
            .getMethod(DYNAMIC_PREPARE_METHOD, Context::class.java)
            .invoke(null, context) as? String
    }.getOrNull()?.takeIf { it.isNotEmpty() }


    private fun inflateCard(context: Context, themeValue: String): ViewGroup =
        inflateCardIn(appliedContext(context, themeValue))

    private fun inflateCardIn(cardContext: Context): ViewGroup {
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
        keyBorder: Boolean,
        bundlesXmlId: Int,
        layoutName: String,
        onReady: (Drawable) -> Unit,
    ): Canceler? {
        val descriptorClass = Class.forName(DESCRIPTOR_CLASS)
        val descriptor = descriptorClass
            .getMethod(DESCRIPTOR_FACTORY, Context::class.java, String::class.java)
            .invoke(null, context, themeValue)

        val themeInterface = Class.forName(THEME_INTERFACE)
        // The four-argument constructor, so the key border is what the caller
        // asked for rather than what `gc.c` would resolve. The three-argument
        // one fills that slot in from the preference itself, which is the value
        // a sheet is not allowed to disagree with its own switch about.
        val theme = Class.forName(THEME_CLASS)
            .getConstructor(
                Context::class.java,
                descriptorClass,
                Boolean::class.javaPrimitiveType,
                Boolean::class.javaPrimitiveType,
            )
            .newInstance(context, descriptor, false, keyBorder)

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
        return engineMethod(
            PREFERENCES_CLASS,
            PREFERENCES_ACCESSOR,
            INT_TYPE,
            String::class.java,
            INT_TYPE,
        ).invoke(facade, key, fallback) as? Int ?: fallback
    }

    private fun readString(context: Context, key: String, fallback: String): String {
        val facade = facade(context) ?: return fallback
        return engineMethod(
            PREFERENCES_CLASS,
            PREFERENCES_ACCESSOR,
            String::class.java,
            String::class.java,
            String::class.java,
        ).invoke(facade, key, fallback) as? String ?: fallback
    }

    /**
     * A method on [className] picked out by name, parameters **and** return
     * type.
     *
     * `Class.getMethod` matches on name and parameters alone. The engine
     * overloads by return type, so for several of the calls above that is not
     * enough to name one method: the facade has a boolean getter and a boolean
     * setter under the same name, and `gc` has two `c(Context)` - one returning
     * a `File` and one returning a boolean. `getMethod` hands back whichever the
     * runtime lists first, and a wrong pick is not a crash: the cast fails
     * inside the caller's `runCatching` and the caller takes its fallback. The
     * key-border switch read `false` for every setting that way, while the
     * renderer - whose call the compiler resolves - drew borders.
     *
     * Throws when nothing matches, which the callers' `runCatching` turns into
     * the same fallback a wrong pick used to produce.
     */
    private fun engineMethod(
        className: String,
        methodName: String,
        returnType: Class<*>,
        vararg parameterTypes: Class<*>,
    ): Method = Class.forName(className).methods.firstOrNull { candidate ->
        candidate.name == methodName &&
            candidate.returnType == returnType &&
            candidate.parameterTypes.size == parameterTypes.size &&
            candidate.parameterTypes.indices.all { index ->
                candidate.parameterTypes[index] == parameterTypes[index]
            }
    } ?: throw NoSuchMethodException("$className.$methodName")

    /**
     * The preference facade, which is a singleton behind a static factory.
     *
     * The factory shares its name and parameter list with two other methods on
     * the same class, one returning a `Context` and one returning nothing, so
     * the return type is what names it.
     */
    private fun facade(context: Context): Any? =
        engineMethod(
            PREFERENCES_CLASS,
            PREFERENCES_ACCESSOR,
            Class.forName(PREFERENCES_CLASS),
            Context::class.java,
        ).invoke(null, context)
}
