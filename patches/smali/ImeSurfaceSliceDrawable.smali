.class public final Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
.super Landroid/graphics/drawable/Drawable;
.source "ImeSurfaceSliceDrawable.java"

# Draws one clipped slice of a Drawable laid out in a shared logical surface.
# The source bitmap/drawable is never inspected or copied as image content.
.implements Landroid/graphics/drawable/Drawable$Callback;

.field public final offsetY:I
.field public final overlay:Landroid/graphics/drawable/Drawable;
.field public final overlay2:Landroid/graphics/drawable/Drawable;
.field public final source:Landroid/graphics/drawable/Drawable;
.field public final totalHeight:I

.method public constructor <init>(Landroid/graphics/drawable/Drawable;II)V
    .locals 1

    const/4 v0, 0x0
    invoke-direct {p0, p1, v0, p2, p3}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    return-void
.end method

.method public constructor <init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    .locals 6

    move-object v0, p0
    move-object v1, p1
    move-object v2, p2
    const/4 v3, 0x0
    move v4, p3
    move v5, p4
    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    return-void
.end method

.method public constructor <init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    .locals 0

    invoke-direct {p0}, Landroid/graphics/drawable/Drawable;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay:Landroid/graphics/drawable/Drawable;
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay2:Landroid/graphics/drawable/Drawable;
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->offsetY:I
    iput p5, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->totalHeight:I
    invoke-virtual {p1, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
    if-eqz p2, :overlay2_callback
    invoke-virtual {p2, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
    :overlay2_callback
    if-eqz p3, :done
    invoke-virtual {p3, p0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
    :done
    return-void
.end method

.method public draw(Landroid/graphics/Canvas;)V
    .locals 7

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->getBounds()Landroid/graphics/Rect;
    move-result-object v0
    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I
    move-result v1
    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I
    move-result v2
    if-lez v1, :done
    if-lez v2, :done

    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I
    move-result v3
    const/4 v4, 0x0
    invoke-virtual {p1, v4, v4, v1, v2}, Landroid/graphics/Canvas;->clipRect(IIII)Z
    iget v5, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->offsetY:I
    neg-int v5, v5
    int-to-float v5, v5
    const/4 v6, 0x0
    int-to-float v6, v6
    invoke-virtual {p1, v6, v5}, Landroid/graphics/Canvas;->translate(FF)V

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    iget v6, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->totalHeight:I
    invoke-virtual {v5, v4, v4, v1, v6}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V
    invoke-virtual {v5, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V
    invoke-virtual {p1, v3}, Landroid/graphics/Canvas;->restoreToCount(I)V

    # Image themes apply their user-selected shadow as a separate native body
    # surface. Composite that overlay locally after drawing the shared image.
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay:Landroid/graphics/drawable/Drawable;
    if-eqz v5, :overlay2
    invoke-virtual {v5, v4, v4, v1, v2}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V
    invoke-virtual {v5, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    :overlay2
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay2:Landroid/graphics/drawable/Drawable;
    if-eqz v5, :done
    invoke-virtual {v5, v4, v4, v1, v2}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V
    invoke-virtual {v5, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    :done
    return-void
.end method

.method public getOpacity()I
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getOpacity()I
    move-result v0
    return v0
.end method

.method public isStateful()Z
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->isStateful()Z
    move-result v0
    return v0
.end method

.method protected onStateChange([I)Z
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setState([I)Z
    move-result v0
    return v0
.end method

.method protected onLevelChange(I)Z
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setLevel(I)Z
    move-result v0
    return v0
.end method

.method public setAlpha(I)V
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay:Landroid/graphics/drawable/Drawable;
    if-eqz v0, :alpha_overlay2
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V
    :alpha_overlay2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay2:Landroid/graphics/drawable/Drawable;
    if-eqz v0, :done
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V
    :done
    return-void
.end method

.method public setColorFilter(Landroid/graphics/ColorFilter;)V
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay:Landroid/graphics/drawable/Drawable;
    if-eqz v0, :filter_overlay2
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V
    :filter_overlay2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay2:Landroid/graphics/drawable/Drawable;
    if-eqz v0, :done
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V
    :done
    return-void
.end method

.method public invalidateDrawable(Landroid/graphics/drawable/Drawable;)V
    .locals 0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->invalidateSelf()V
    return-void
.end method

.method public scheduleDrawable(Landroid/graphics/drawable/Drawable;Ljava/lang/Runnable;J)V
    .locals 0
    invoke-virtual {p0, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->scheduleSelf(Ljava/lang/Runnable;J)V
    return-void
.end method

.method public unscheduleDrawable(Landroid/graphics/drawable/Drawable;Ljava/lang/Runnable;)V
    .locals 0
    invoke-virtual {p0, p2}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->unscheduleSelf(Ljava/lang/Runnable;)V
    return-void
.end method
