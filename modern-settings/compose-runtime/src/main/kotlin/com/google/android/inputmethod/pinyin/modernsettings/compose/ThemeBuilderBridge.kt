package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Rect
import android.os.Build
import java.io.File
import java.lang.reflect.Field
import java.text.DateFormat
import java.util.Date

/**
 * The legacy custom-theme package engine, reached by reflection.
 *
 * Building a theme out of a picture is not a UI problem: the legacy wizard's
 * two pages only ever collect a crop rectangle and one transparency value, and
 * everything else - decoding the picture at a workable size, writing the style
 * sheet, zipping the package - is done by [BUILDER] and its helpers. Those
 * helpers live in the primary DEX under obfuscated one-letter names in the
 * default package, so this module cannot compile against them and reaches them
 * the same way it reaches the rest of the legacy surface.
 *
 * The model object ([BUILDER]) is the contract worth keeping: the crop
 * arithmetic the legacy pages performed is reproduced on the Compose side (see
 * [CustomThemeBuilderScreen]), but the result is handed to the same object in
 * the same units, so the package written here is the package the legacy wizard
 * would have written.
 *
 * Two things about this class are easy to get wrong:
 *
 * * Its fields are obfuscated and several share a name. `a` is at once the
 *   transparency, the sample size, the source bitmap, a rectangle, the byte
 *   source, a weak reference and the title. Java's `getField(name)` would pick
 *   one of them arbitrarily, so every lookup here matches name *and* type.
 * * Two of the metrics helpers are both `a(Context)` and differ only in what
 *   they return. Method lookup therefore matches the return type as well.
 *
 * Everything returns null or a fallback instead of throwing. A missing engine
 * has to degrade to "this screen cannot open", not to a crash on the way in.
 */
internal object ThemeBuilderBridge {
    private const val BYTE_SOURCE = "cac"
    private const val BUILDER = "bai"
    private const val UTILITIES = "gc"
    private const val PACKAGE = "bbl"
    private const val METRICS = "ats"

    /** The keyboard part names the metrics helper expects as an enum array. */
    private const val VIEW_TYPE =
        "com.google.android.apps.inputmethod.libs.framework.core.metadata.KeyboardViewDef\$Type"

    private const val STYLE_SHEET_PROTO =
        "com.google.android.apps.inputmethod.libs.theme.proto.nano.StyleSheetProto\$StyleSheet"

    private const val METADATA_PROTO =
        "com.google.android.apps.inputmethod.libs.theme.proto.nano" +
            ".ThemePackageProto\$ThemePackageMetadata"

    /** The string a new theme's name is built from, resolved by name. */
    private const val TITLE_FORMAT_RESOURCE = "user_theme_name_format"

    /** How far the legacy builder counted before giving up on a free name. */
    private const val MAX_TITLE_INDEX = 1000

    /** The style key the builder writes the crop scale under. */
    const val KEY_CROPPING_SCALE = "__cropping_scale"

    /** The style keys the builder writes the crop centre under. */
    const val KEY_CROPPING_CENTER_X = "__cropping_rect_center_x"
    const val KEY_CROPPING_CENTER_Y = "__cropping_rect_center_y"

    /** The style key the builder writes the overlay transparency under. */
    const val KEY_OVERLAY_TRANSPARENCY = "__overlay_transparency"

    private val classCache = HashMap<String, Class<*>?>()

    private fun type(name: String): Class<*>? = classCache.getOrPut(name) {
        runCatching { Class.forName(name) }.getOrNull()
    }

    /** True when the engine is present, i.e. this is not an apktool-only build. */
    val available: Boolean
        get() = type(BUILDER) != null && type(BYTE_SOURCE) != null

    /**
     * The legacy model for one picture, or null when the engine is missing or
     * the picture cannot be read.
     *
     * The bytes are handed over undecoded on purpose: the model computes its own
     * downscale factor from the encoded header, which is the same path the
     * legacy wizard took after decoding and re-encoding the picked image. Doing
     * it here avoids a second encode and keeps the original quality.
     */
    fun newModel(imageBytes: ByteArray): Any? {
        val source = newByteSource(imageBytes) ?: return null
        val builderType = type(BUILDER) ?: return null
        return runCatching {
            builderType.getConstructor(type(BYTE_SOURCE)).newInstance(source)
        }.getOrNull()
    }

    private fun newByteSource(bytes: ByteArray): Any? {
        val sourceType = type(BYTE_SOURCE) ?: return null
        return runCatching {
            findMethod(sourceType, "a", type(BYTE_SOURCE), ByteArray::class.java)
                ?.invoke(null, bytes)
        }.getOrNull()
    }

    /** The decoded source bitmap, downsampled by the model's own factor. */
    fun sourceBitmap(model: Any): Bitmap? = runCatching {
        findMethod(model.javaClass, "a", Bitmap::class.java)?.invoke(model) as? Bitmap
    }.getOrNull()

    /**
     * The overlay transparency, 0 (no overlay) to 1 (fully opaque overlay).
     *
     * This is the value the brightness slider edits; the legacy page called it
     * brightness because a darker overlay reads as a darker keyboard.
     */
    fun transparency(model: Any): Float =
        floatField(model, "a") ?: DEFAULT_TRANSPARENCY

    fun setTransparency(model: Any, value: Float) {
        // The legacy setter asserts the range, so clamp rather than let a
        // gesture push it out and trip the assertion.
        setFloatField(model, "a", value.coerceIn(0f, 1f))
    }

    /** The crop scale, in units of the preview ratio - see the screen's own notes. */
    fun cropScale(model: Any): Float = floatField(model, "b") ?: 0f

    fun setCropScale(model: Any, value: Float) {
        setFloatField(model, "b", value)
    }

    /** The crop centre, in source bitmap pixels. */
    fun cropCenter(model: Any): Pair<Float, Float> =
        (floatField(model, "c") ?: 0f) to (floatField(model, "d") ?: 0f)

    fun setCropCenter(model: Any, x: Float, y: Float) {
        setFloatField(model, "c", x)
        setFloatField(model, "d", y)
    }

    /**
     * Hands the two crop rectangles to the model.
     *
     * [background] is the strip the package uses for the keyboard background and
     * has its top pinned to the image's own top; [thumbnail] is the real crop
     * the selector's grid renders. The legacy NEXT button built both from the
     * same left/right/bottom and only differed in that pin, which is why they
     * are separate parameters rather than one rectangle.
     */
    fun setRects(model: Any, background: Rect, thumbnail: Rect) {
        runCatching {
            findMethod(
                model.javaClass,
                "a",
                Void.TYPE,
                Rect::class.java,
                Rect::class.java,
            )?.invoke(model, background, thumbnail)
        }
    }

    /** Writes the package, returning false when the engine refused. */
    fun writePackage(model: Any, target: File): Boolean = runCatching {
        findMethod(model.javaClass, "a", java.lang.Boolean.TYPE, File::class.java)
            ?.invoke(model, target) as? Boolean
    }.getOrDefault(false) == true

    /** A fresh, non-colliding package file in the app's own files directory. */
    fun newThemeFile(context: Context): File? {
        val utilities = type(UTILITIES) ?: return null
        return runCatching {
            findMethod(utilities, "b", File::class.java, Context::class.java)
                ?.invoke(null, context) as? File
        }.getOrNull()
    }

    /**
     * The name a brand-new theme gets.
     *
     * Nothing in the app reads a user theme's name back - not the grid, not the
     * preview sheet - but the legacy builder wrote one and the legacy editor
     * copied it forward, so a package without it is not a package the wizard
     * this replaces would have produced. The format is the app's own
     * `user_theme_name_format`, and the index is the first one no existing
     * package has taken, which is exactly the loop the legacy builder ran.
     *
     * Returns an empty string when the format is missing, which is the legacy
     * builder's own answer once it has tried every index.
     */
    fun defaultTitle(context: Context): String = runCatching {
        val resources = context.resources
        val id = resources.getIdentifier(
            TITLE_FORMAT_RESOURCE,
            "string",
            context.packageName,
        )
        if (id == 0) return@runCatching ""
        val format = resources.getString(id)
        @Suppress("DEPRECATION")
        val locale = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            resources.configuration.locales[0]
        } else {
            resources.configuration.locale
        }
        val date = DateFormat.getDateInstance(DateFormat.MEDIUM, locale).format(Date())
        val taken = existingTitles(context)
        for (index in 1..MAX_TITLE_INDEX) {
            val candidate = String.format(locale, format, index, date)
            if (candidate !in taken) return@runCatching candidate
        }
        ""
    }.getOrDefault("")

    /**
     * The name inside an opened package, so re-editing keeps it.
     *
     * The legacy editor read the package's own metadata and wrote it back onto
     * its model; without that step a re-edited theme would silently lose the
     * name it was created with.
     */
    fun packageTitle(pkg: Any): String? = runCatching {
        val metadataType = type(METADATA_PROTO) ?: return@runCatching null
        val metadata = findMethod(pkg.javaClass, "getMetadata", metadataType)
            ?.invoke(pkg) ?: return@runCatching null
        // The metadata declares `a` six times over - an int, a string, a
        // boolean and three arrays - and field lookup by name alone is a coin
        // flip between them. `Class.getField` is no better: it matches on the
        // name and leaves the type to chance.
        findFieldType(metadataType, "a", String::class.java)?.get(metadata) as? String
    }.getOrNull()

    /**
     * Sets the model's title, the field the package writer copies into the
     * metadata.
     *
     * `bai.a` is declared seven times over with seven types; the string one is
     * the title, and the lookup matches on type so it cannot pick another.
     */
    fun setTitle(model: Any, title: String) {
        runCatching {
            findField(model, "a", String::class.java)?.set(model, title)
        }
    }

    /** Every title already in use, which is what a new one has to avoid. */
    private fun existingTitles(context: Context): Set<String> {
        val utilities = type(UTILITIES) ?: return emptySet()
        val files = runCatching {
            findMethod(utilities, "a", Array<File>::class.java, Context::class.java)
                ?.invoke(null, context) as? Array<*>
        }.getOrNull() ?: return emptySet()
        return files.mapNotNull { entry ->
            (entry as? File)?.let(::openPackage)?.let(::packageTitle)
        }.toSet()
    }

    /**
     * Opens an existing package so its picture and settings can be re-edited.
     *
     * Returns null when the file is not a package this build can read; the
     * caller then falls back to asking for a new picture instead of opening a
     * wizard on a blank canvas.
     */
    fun openPackage(file: File): Any? {
        val packageType = type(PACKAGE) ?: return null
        return runCatching {
            findMethod(packageType, "a", packageType, File::class.java)?.invoke(null, file)
        }.getOrNull()
    }

    /**
     * The picture inside an existing package, preferring the un-cropped original.
     *
     * A theme built by the legacy wizard stores both the strip it cropped for
     * the keyboard background and the whole picture it started from. Re-editing
     * wants the second: cropping from the first would only ever shrink the
     * usable area.
     */
    fun packageImage(pkg: Any): ByteArray? {
        val sourceType = type(BYTE_SOURCE) ?: return null
        for (entry in arrayOf("original_cropping", "background")) {
            val bytes = runCatching {
                val source = findMethod(pkg.javaClass, "a", sourceType, String::class.java)
                    ?.invoke(pkg, entry) ?: return@runCatching null
                findMethod(sourceType, "a", ByteArray::class.java)?.invoke(source) as? ByteArray
            }.getOrNull()
            if (bytes != null && bytes.isNotEmpty()) return bytes
        }
        return null
    }

    /**
     * Reads one value out of a package's style sheet.
     *
     * The chain is the legacy editor's own: flatten the package's style rules
     * into a map keyed by property name, then ask the model's reader for one key
     * with a fallback. Returns [fallback] at the first missing link, which is
     * what a package written by an older build or a different tool looks like.
     */
    fun styleValue(pkg: Any, key: String, fallback: Float): Float = runCatching {
        val sheetType = type(STYLE_SHEET_PROTO) ?: return@runCatching fallback
        val sheet = sheetType.getConstructor().newInstance()
        val filled = findMethod(
            pkg.javaClass,
            "getStyleSheet",
            sheetType,
            Set::class.java,
            sheetType,
        )?.invoke(pkg, emptySet<Any>(), sheet) ?: return@runCatching fallback
        val rules = sheetType.getField("a").get(filled) as? Array<*> ?: return@runCatching fallback
        val utilities = type(UTILITIES) ?: return@runCatching fallback
        val map = findMethod(utilities, "a", Map::class.java, rules.javaClass)
            ?.invoke(null, rules) ?: return@runCatching fallback
        val builderType = type(BUILDER) ?: return@runCatching fallback
        findMethod(
            builderType,
            "a",
            java.lang.Float.TYPE,
            Map::class.java,
            String::class.java,
            java.lang.Float.TYPE,
        )?.invoke(null, map, key, fallback) as? Float ?: fallback
    }.getOrDefault(fallback)

    /**
     * The keyboard's width in pixels, which is the display width.
     *
     * Two helpers share this name and differ only in their return type; the
     * float one is a scale factor, so the lookup has to name `int`.
     */
    fun keyboardWidth(context: Context): Int = runCatching {
        val metrics = type(METRICS) ?: return@runCatching 0
        findMethod(metrics, "a", java.lang.Integer.TYPE, Context::class.java)
            ?.invoke(null, context) as? Int ?: 0
    }.getOrDefault(0)

    /** The keyboard's height in pixels, header and body together. */
    fun keyboardHeight(context: Context): Int = runCatching {
        val metrics = type(METRICS) ?: return@runCatching 0
        val viewType = type(VIEW_TYPE) ?: return@runCatching 0
        val parts = java.lang.reflect.Array.newInstance(viewType, 2)
        for ((index, name) in arrayOf("HEADER", "BODY").withIndex()) {
            val constant = viewType.enumConstants
                ?.firstOrNull { (it as Enum<*>).name == name }
                ?: return@runCatching 0
            java.lang.reflect.Array.set(parts, index, constant)
        }
        findMethod(metrics, "b", java.lang.Integer.TYPE, Context::class.java, parts.javaClass)
            ?.invoke(null, context, parts) as? Int ?: 0
    }.getOrDefault(0)

    /**
     * The share of the screen width the keyboard preview occupies, 0..1.
     *
     * A resource rather than a constant: the landscape build uses a different
     * value, and the legacy crop window derived its width from it, so the crop
     * the user gets here matches the one the wizard would have produced in the
     * same orientation.
     */
    fun previewRatio(context: Context): Float = runCatching {
        val resources = context.resources
        val id = resources.getIdentifier(
            PREVIEW_RATIO_RESOURCE,
            "integer",
            context.packageName,
        )
        if (id == 0) return@runCatching DEFAULT_PREVIEW_RATIO
        resources.getInteger(id) / 100f
    }.getOrDefault(DEFAULT_PREVIEW_RATIO)

    private const val PREVIEW_RATIO_RESOURCE = "keyboard_preview_size_ratio_in_percent"

    /** The model's own starting transparency, for a picture that has no history. */
    const val DEFAULT_TRANSPARENCY = 0.4f

    private const val DEFAULT_PREVIEW_RATIO = 0.8f

    /**
     * Finds one obfuscated method by name, parameter types *and* return type.
     *
     * The return type is not optional here either: `ats` declares `a(Context)`
     * twice, once returning a float scale and once returning the width in
     * pixels, and `Class.getMethod` matches on name and parameters alone. Picking
     * the wrong one does not throw - the result is cast, fails, and is swallowed
     * by the surrounding `runCatching`, leaving the caller on a default value
     * forever.
     */
    private fun findMethod(
        owner: Class<*>,
        name: String,
        returnType: Class<*>?,
        vararg parameters: Class<*>,
    ): java.lang.reflect.Method? {
        var current: Class<*>? = owner
        while (current != null) {
            for (method in current.declaredMethods) {
                if (method.name != name) continue
                if (returnType != null && method.returnType != returnType) continue
                if (!method.parameterTypes.contentEquals(parameters)) continue
                method.isAccessible = true
                return method
            }
            current = current.superclass
        }
        return null
    }

    /**
     * Finds one obfuscated field by name and type.
     *
     * The type is not optional. `bai` declares `a` seven times over with seven
     * different types, so a name-only lookup is a coin flip between the
     * transparency, the sample size, the bitmap and the title.
     */
    private fun findField(instance: Any, name: String, fieldType: Class<*>): Field? =
        findFieldType(instance.javaClass, name, fieldType)

    /** [findField] for a class that has not been instantiated yet. */
    private fun findFieldType(owner: Class<*>, name: String, fieldType: Class<*>): Field? {
        var current: Class<*>? = owner
        while (current != null) {
            for (field in current.declaredFields) {
                if (field.name == name && field.type == fieldType) {
                    field.isAccessible = true
                    return field
                }
            }
            current = current.superclass
        }
        return null
    }

    private fun floatField(instance: Any, name: String): Float? = runCatching {
        findField(instance, name, java.lang.Float.TYPE)?.getFloat(instance)
    }.getOrNull()

    private fun setFloatField(instance: Any, name: String, value: Float) {
        runCatching {
            findField(instance, name, java.lang.Float.TYPE)?.setFloat(instance, value)
        }
    }
}
