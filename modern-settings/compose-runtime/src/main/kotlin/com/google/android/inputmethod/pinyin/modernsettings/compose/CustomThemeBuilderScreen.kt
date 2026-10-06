package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Rect as AndroidRect
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.FilterQuality
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

/**
 * The geometry of the crop window, and the two conversions that matter.
 *
 * Kept apart from the composable so it can be checked without a device: these
 * numbers decide which part of the picture ends up in the theme package, and
 * getting them wrong still produces a working theme that frames the picture
 * differently from the wizard it replaces.
 *
 * All of it is the legacy crop page's own arithmetic. The window is the
 * keyboard's own shape at [previewRatio] of the container width, the minimum
 * scale is the one that makes the picture cover that window, and the picture is
 * placed so that `viewX = centre.x + (bitmapX - width / 2) * scale`.
 */
internal data class ThemeCropGeometry(
    val window: Rect,
    val minScale: Float,
    val initialScale: Float,
) {
    /** The placement that makes the picture cover [window] without gaps. */
    fun clampCenter(
        x: Float,
        y: Float,
        scale: Float,
        bitmapWidth: Float,
        bitmapHeight: Float,
    ): Offset {
        val halfWidth = bitmapWidth * scale / 2f
        val halfHeight = bitmapHeight * scale / 2f
        return Offset(
            x.coerceIn(window.right - halfWidth, window.left + halfWidth),
            y.coerceIn(window.bottom - halfHeight, window.top + halfHeight),
        )
    }

    /**
     * The placement a previously saved theme should open at.
     *
     * The inverse of [sourceRect] plus the scale conversion, which is how the
     * legacy crop page restored the framing of a theme being re-edited. Without
     * it, editing a theme would silently throw away the crop and brightness the
     * user chose the first time and start them from the picture's fit.
     */
    fun seed(
        cropScale: Float,
        cropCenterX: Float,
        cropCenterY: Float,
        bitmapWidth: Float,
        bitmapHeight: Float,
        previewRatio: Float,
    ): Pair<Float, Offset> {
        val containerWidth = window.left * 2f + window.width
        val containerHeight = window.top * 2f + window.height
        val scale = max(minScale, cropScale * previewRatio)
        val x = containerWidth / 2f - (cropCenterX - bitmapWidth / 2f) * scale
        val y = containerHeight / 2f - (cropCenterY - bitmapHeight / 2f) * scale
        return scale to clampCenter(x, y, scale, bitmapWidth, bitmapHeight)
    }

    /**
     * The source rectangle the window currently frames.
     *
     * Inverts the placement above: a point at `viewX` sits at
     * `(viewX - centre.x) / scale + width / 2` in the picture. The result is
     * clamped to the picture, because the model asserts that whatever it is
     * given lies inside it and half a pixel of float error is enough to land an
     * edge on -1 or on width + 1.
     */
    fun sourceRect(
        scale: Float,
        center: Offset,
        bitmapWidth: Int,
        bitmapHeight: Int,
    ): Rect {
        val width = bitmapWidth.toFloat()
        val height = bitmapHeight.toFloat()
        return Rect(
            (window.left / scale - center.x / scale + width / 2f).coerceIn(0f, width),
            (window.top / scale - center.y / scale + height / 2f).coerceIn(0f, height),
            (window.right / scale - center.x / scale + width / 2f).coerceIn(0f, width),
            (window.bottom / scale - center.y / scale + height / 2f).coerceIn(0f, height),
        )
    }
}

/**
 * Builds the crop geometry for one container and picture.
 *
 * [keyboardAspect] is the keyboard's height over its width. The window is
 * derived from it rather than hard-coded because that is what the legacy page
 * did: the frame the user sees is the keyboard's shape, so what they frame is
 * what the keyboard will show.
 */
internal fun themeCropGeometry(
    containerWidth: Int,
    containerHeight: Int,
    bitmapWidth: Int,
    bitmapHeight: Int,
    previewRatio: Float,
    keyboardAspect: Float,
): ThemeCropGeometry {
    val windowWidth = (containerWidth * previewRatio).roundToInt()
    val windowHeight = (windowWidth * keyboardAspect).roundToInt()
    val left = (containerWidth - windowWidth) / 2f
    val top = (containerHeight - windowHeight) / 2f
    val window = Rect(left, top, left + windowWidth, top + windowHeight)
    if (bitmapWidth <= 0 || bitmapHeight <= 0) {
        return ThemeCropGeometry(window, minScale = 1f, initialScale = 1f)
    }
    val minScale = max(
        windowWidth.toFloat() / bitmapWidth,
        windowHeight.toFloat() / bitmapHeight,
    )
    val fitScale = min(
        containerWidth.toFloat() / bitmapWidth,
        containerHeight.toFloat() / bitmapHeight,
    )
    return ThemeCropGeometry(
        window = window,
        minScale = minScale,
        initialScale = max(minScale, fitScale),
    )
}

/** The crop window and the brightness slider, in that order. */
internal enum class ThemeBuilderStep { Crop, Brightness }

/**
 * The custom-theme wizard: frame the picture, then set how dark the keyboard is.
 *
 * Two steps rather than two screens, because the second is only meaningful once
 * the first has decided what the keyboard background will be. The legacy wizard
 * used a pager for the same reason.
 *
 * The picture arrives already decoded by the model, and the crop and the
 * transparency are written back into that same model, so what gets saved is the
 * package the legacy wizard would have written. Nothing here knows the package
 * format, and nothing here touches the file system - [onSave] is handed the
 * name of the package the model wrote.
 */
@Composable
internal fun CustomThemeBuilderScreen(
    context: Context,
    model: Any,
    bitmap: Bitmap,
    previewRatio: Float,
    keyboardAspect: Float,
    initialTransparency: Float,
    initialCropScale: Float,
    initialCropCenter: Pair<Float, Float>,
    onCancel: () -> Unit,
    onSave: (String) -> Unit,
) {
    var step by remember { mutableStateOf(ThemeBuilderStep.Crop) }
    var scale by remember { mutableFloatStateOf(0f) }
    var center by remember { mutableStateOf(Offset.Zero) }
    var geometry by remember { mutableStateOf<ThemeCropGeometry?>(null) }
    var cropRect by remember { mutableStateOf<AndroidRect?>(null) }
    var transparency by remember { mutableFloatStateOf(initialTransparency) }
    val image = remember(bitmap) { bitmap.asImageBitmap() }
    val bitmapWidth = bitmap.width
    val bitmapHeight = bitmap.height

    Column(modifier = Modifier.fillMaxSize()) {
        Text(
            text = stringResource(
                when (step) {
                    ThemeBuilderStep.Crop -> R.string.modern_theme_builder_crop_instruction
                    ThemeBuilderStep.Brightness ->
                        R.string.modern_theme_builder_brightness_instruction
                },
            ),
            modifier = Modifier.padding(horizontal = 24.dp, vertical = 12.dp),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        when (step) {
            ThemeBuilderStep.Crop -> CropStep(
                image = image,
                bitmapWidth = bitmapWidth,
                bitmapHeight = bitmapHeight,
                previewRatio = previewRatio,
                keyboardAspect = keyboardAspect,
                scale = scale,
                center = center,
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f),
                onGeometry = { fresh ->
                    // Seeded once the container is measured, and again if the
                    // container's shape changed under it - a rotation, since this
                    // activity handles its own configuration changes. Re-seeding
                    // on every layout pass would undo the framing the user just
                    // chose.
                    if (geometry == null || geometry?.window?.size != fresh.window.size) {
                        val seeded = if (initialCropScale > 0f) {
                            fresh.seed(
                                cropScale = initialCropScale,
                                cropCenterX = initialCropCenter.first,
                                cropCenterY = initialCropCenter.second,
                                bitmapWidth = bitmapWidth.toFloat(),
                                bitmapHeight = bitmapHeight.toFloat(),
                                previewRatio = previewRatio,
                            )
                        } else {
                            fresh.initialScale to Offset(
                                fresh.window.center.x,
                                fresh.window.center.y,
                            )
                        }
                        scale = seeded.first
                        center = seeded.second
                        geometry = fresh
                    }
                },
                onTransform = { newScale, newCenter ->
                    scale = newScale
                    center = newCenter
                },
            )

            ThemeBuilderStep.Brightness -> BrightnessStep(
                image = image,
                cropRect = cropRect,
                transparency = transparency,
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f),
            )
        }
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.End,
        ) {
            if (step == ThemeBuilderStep.Brightness) {
                Slider(
                    value = transparency * 100f,
                    onValueChange = { percent ->
                        transparency = percent / 100f
                        ThemeBuilderBridge.setTransparency(model, transparency)
                    },
                    valueRange = 0f..100f,
                    modifier = Modifier.weight(1f),
                )
                Text(
                    text = stringResource(
                        R.string.modern_theme_builder_brightness_value,
                        (transparency * 100f).roundToInt(),
                    ),
                    modifier = Modifier.padding(start = 16.dp),
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurface,
                )
            } else {
                TextButton(onClick = onCancel) {
                    Text(stringResource(R.string.modern_theme_builder_cancel))
                }
            }
        }
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp, vertical = 12.dp),
            horizontalArrangement = Arrangement.End,
        ) {
            when (step) {
                ThemeBuilderStep.Crop -> Button(
                    onClick = {
                        geometry?.let { current ->
                            val framed = current.sourceRect(scale, center, bitmapWidth, bitmapHeight)
                            // Truncated rather than rounded, because that is what
                            // the legacy page's int casts did and the centre it
                            // stored came from those same integers.
                            val rect = AndroidRect(
                                framed.left.toInt(),
                                framed.top.toInt(),
                                framed.right.toInt(),
                                framed.bottom.toInt(),
                            )
                            // The scale is stored in units of the preview ratio,
                            // which is how the legacy page wrote it and how the
                            // legacy editor reads it back.
                            ThemeBuilderBridge.setCropScale(model, scale / previewRatio)
                            ThemeBuilderBridge.setCropCenter(
                                model,
                                ((rect.left + rect.right) / 2).toFloat(),
                                ((rect.top + rect.bottom) / 2).toFloat(),
                            )
                            ThemeBuilderBridge.setRects(
                                model,
                                // The background strip is the crop extended up to
                                // the picture's top edge; the thumbnail is the
                                // crop itself. Both share three of their edges.
                                AndroidRect(rect.left, 0, rect.right, rect.bottom),
                                rect,
                            )
                            cropRect = rect
                        }
                        step = ThemeBuilderStep.Brightness
                    },
                    enabled = geometry != null,
                ) {
                    Text(stringResource(R.string.modern_theme_builder_next))
                }

                ThemeBuilderStep.Brightness -> {
                    TextButton(onClick = { step = ThemeBuilderStep.Crop }) {
                        Text(stringResource(R.string.modern_theme_builder_back))
                    }
                    Button(
                        onClick = {
                            writePackage(context, model)?.let(onSave) ?: onCancel()
                        },
                        modifier = Modifier.padding(start = 12.dp),
                    ) {
                        Text(stringResource(R.string.modern_theme_builder_save))
                    }
                }
            }
        }
    }
}

/**
 * Writes the package and returns its bare name, or null when the write failed.
 *
 * The name is the whole result the caller acts on: it is what the settings page
 * turns into a theme value. Nothing else about the package crosses this line,
 * which is also what keeps the format inside the legacy engine.
 */
internal fun writePackage(context: Context, model: Any): String? {
    val target = ThemeBuilderBridge.newThemeFile(context) ?: return null
    if (!ThemeBuilderBridge.writePackage(model, target)) return null
    return target.name
}

@Composable
private fun CropStep(
    image: ImageBitmap,
    bitmapWidth: Int,
    bitmapHeight: Int,
    previewRatio: Float,
    keyboardAspect: Float,
    scale: Float,
    center: Offset,
    modifier: Modifier,
    onGeometry: (ThemeCropGeometry) -> Unit,
    onTransform: (Float, Offset) -> Unit,
) {
    BoxWithConstraints(modifier = modifier.background(Color.Black)) {
        val width = constraints.maxWidth
        val height = constraints.maxHeight
        val geometry = remember(width, height, bitmapWidth, bitmapHeight, previewRatio) {
            themeCropGeometry(
                containerWidth = width,
                containerHeight = height,
                bitmapWidth = bitmapWidth,
                bitmapHeight = bitmapHeight,
                previewRatio = previewRatio,
                keyboardAspect = keyboardAspect,
            )
        }
        LaunchedEffect(geometry) { onGeometry(geometry) }
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .pointerInput(bitmapWidth, bitmapHeight, geometry) {
                    detectTransformGestures { centroid, pan, zoom, _ ->
                        var nextScale = scale
                        var nextCenter = center
                        if (zoom != 1f && scale > 0f) {
                            // Zoom about the gesture's own focus point, the way
                            // the legacy page did; the clamp below then pulls the
                            // picture back if that pushed an edge inside the
                            // window.
                            nextScale = max(geometry.minScale, scale * zoom)
                            val ratio = nextScale / scale
                            val translateX = center.x - scale * bitmapWidth / 2f
                            val translateY = center.y - scale * bitmapHeight / 2f
                            nextCenter = Offset(
                                centroid.x + (translateX - centroid.x) * ratio +
                                    bitmapWidth * nextScale / 2f,
                                centroid.y + (translateY - centroid.y) * ratio +
                                    bitmapHeight * nextScale / 2f,
                            )
                        }
                        nextCenter = geometry.clampCenter(
                            nextCenter.x - pan.x,
                            nextCenter.y - pan.y,
                            nextScale,
                            bitmapWidth.toFloat(),
                            bitmapHeight.toFloat(),
                        )
                        onTransform(nextScale, nextCenter)
                    }
                },
        ) {
            if (scale <= 0f) return@Canvas
            drawImage(
                image = image,
                dstOffset = IntOffset(
                    (center.x - scale * bitmapWidth / 2f).roundToInt(),
                    (center.y - scale * bitmapHeight / 2f).roundToInt(),
                ),
                dstSize = IntSize(
                    (bitmapWidth * scale).roundToInt(),
                    (bitmapHeight * scale).roundToInt(),
                ),
                filterQuality = FilterQuality.Medium,
            )
            val window = geometry.window
            val scrim = Color.Black.copy(alpha = 0.6f)
            drawRect(scrim, topLeft = Offset.Zero, size = Size(size.width, window.top))
            drawRect(
                scrim,
                topLeft = Offset(0f, window.bottom),
                size = Size(size.width, size.height - window.bottom),
            )
            drawRect(scrim, topLeft = Offset(0f, window.top), size = Size(window.left, window.height))
            drawRect(
                scrim,
                topLeft = Offset(window.right, window.top),
                size = Size(size.width - window.right, window.height),
            )
            drawRect(
                color = Color.White,
                topLeft = Offset(window.left, window.top),
                size = Size(window.width, window.height),
                style = Stroke(width = 2.dp.toPx()),
            )
        }
    }
}

/**
 * What the keyboard will look like with the picture behind it.
 *
 * The two black bands are the legacy preview's: the candidate strip darkens at
 * 0.7 of the transparency and the key area at the full value, which is exactly
 * what the package's style sheet says once the theme is applied. The preview is
 * therefore the applied result rather than an approximation of it.
 */
@Composable
private fun BrightnessStep(
    image: ImageBitmap,
    cropRect: AndroidRect?,
    transparency: Float,
    modifier: Modifier,
) {
    Box(modifier = modifier, contentAlignment = Alignment.Center) {
        if (cropRect == null || cropRect.width() <= 0 || cropRect.height() <= 0) return@Box
        Canvas(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(cropRect.width().toFloat() / cropRect.height()),
        ) {
            drawImage(
                image = image,
                srcOffset = IntOffset(cropRect.left, cropRect.top),
                srcSize = IntSize(cropRect.width(), cropRect.height()),
                dstOffset = IntOffset.Zero,
                dstSize = IntSize(size.width.roundToInt(), size.height.roundToInt()),
                filterQuality = FilterQuality.Medium,
            )
            val header = size.height * HEADER_SHARE
            drawRect(
                color = Color.Black.copy(alpha = 1f - 0.7f * transparency),
                size = Size(size.width, header),
            )
            drawRect(
                color = Color.Black.copy(alpha = 1f - transparency),
                topLeft = Offset(0f, header),
                size = Size(size.width, size.height - header),
            )
        }
    }
}

/** How much of the keyboard the candidate strip takes, for the preview only. */
private const val HEADER_SHARE = 0.35f
