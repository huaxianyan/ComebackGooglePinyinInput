package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.compose.ui.geometry.Offset
import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * The crop geometry, checked against the numbers the legacy wizard produced.
 *
 * This is the one part of the wizard that can be checked without a device, and
 * the part most likely to be wrong in a way that still looks plausible: a crop
 * that frames the wrong region produces a working theme that simply does not
 * match what the frame on screen showed.
 */
class ThemeCropGeometryTest {
    private val geometry = themeCropGeometry(
        containerWidth = 1000,
        containerHeight = 2000,
        bitmapWidth = 2000,
        bitmapHeight = 1000,
        previewRatio = 0.8f,
        keyboardAspect = 0.5f,
    )

    @Test
    fun windowIsTheKeyboardShapeAtThePreviewShareOfTheWidth() {
        // 80% of 1000 wide, and half as tall as it is wide, centred.
        assertEquals(100f, geometry.window.left, 0.01f)
        assertEquals(800f, geometry.window.top, 0.01f)
        assertEquals(900f, geometry.window.right, 0.01f)
        assertEquals(1200f, geometry.window.bottom, 0.01f)
    }

    @Test
    fun minimumScaleIsTheOneThatCoversTheWindow() {
        // 800/2000 and 400/1000 are both 0.4, so the picture covers the window
        // exactly at 0.4 and anything less would leave a gap.
        assertEquals(0.4f, geometry.minScale, 0.001f)
        // The picture also fits inside the container at 0.5, which is larger,
        // so that is where it opens.
        assertEquals(0.5f, geometry.initialScale, 0.001f)
    }

    @Test
    fun theOpenPlacementFramesTheWindowCentredOnThePicture() {
        val rect = geometry.sourceRect(
            scale = geometry.initialScale,
            center = Offset(geometry.window.center.x, geometry.window.center.y),
            bitmapWidth = 2000,
            bitmapHeight = 1000,
        )

        assertEquals(200f, rect.left, 0.01f)
        assertEquals(100f, rect.top, 0.01f)
        assertEquals(1800f, rect.right, 0.01f)
        assertEquals(900f, rect.bottom, 0.01f)
    }

    @Test
    fun theFramedRegionKeepsTheWindowShape() {
        val rect = geometry.sourceRect(
            scale = 0.7f,
            center = geometry.clampCenter(400f, 900f, 0.7f, 2000f, 1000f),
            bitmapWidth = 2000,
            bitmapHeight = 1000,
        )

        assertEquals(
            geometry.window.width / geometry.window.height,
            rect.width / rect.height,
            0.01f,
        )
    }

    @Test
    fun thePictureCannotBeDraggedOffTheWindow() {
        // Far past every edge: the clamp has to pull it back to the last
        // placement where the window is still covered.
        val clamped = geometry.clampCenter(100_000f, 100_000f, 0.5f, 2000f, 1000f)

        assertEquals(600f, clamped.x, 0.01f)
        assertEquals(1050f, clamped.y, 0.01f)
    }

    @Test
    fun aSavedFramingIsRestoredExactly() {
        // What the NEXT button would have stored for the centred placement.
        val rect = geometry.sourceRect(
            scale = 0.5f,
            center = Offset(500f, 1000f),
            bitmapWidth = 2000,
            bitmapHeight = 1000,
        )
        val storedScale = 0.5f / 0.8f
        val storedCenterX = (rect.left + rect.right) / 2f
        val storedCenterY = (rect.top + rect.bottom) / 2f

        val (scale, center) = geometry.seed(
            cropScale = storedScale,
            cropCenterX = storedCenterX,
            cropCenterY = storedCenterY,
            bitmapWidth = 2000f,
            bitmapHeight = 1000f,
            previewRatio = 0.8f,
        )

        assertEquals(0.5f, scale, 0.001f)
        assertEquals(500f, center.x, 0.01f)
        assertEquals(1000f, center.y, 0.01f)
    }

    @Test
    fun aPictureSmallerThanTheWindowIsScaledUpToCoverIt() {
        val small = themeCropGeometry(
            containerWidth = 1000,
            containerHeight = 2000,
            bitmapWidth = 100,
            bitmapHeight = 100,
            previewRatio = 0.8f,
            keyboardAspect = 0.5f,
        )

        // 800/100 = 8 on the width, 400/100 = 4 on the height, so covering takes
        // the larger; fitting would have used the smaller and left a gap.
        assertEquals(8f, small.minScale, 0.001f)
        assertEquals(8f, small.initialScale, 0.001f)
    }
}
