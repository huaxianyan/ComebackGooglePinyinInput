.class public final Lcom/google/android/inputmethod/pinyin/Md3SliderView;
.super Landroid/widget/SeekBar;

.field private final paint:Landroid/graphics/Paint;
.field private density:F
.field private activeColor:I
.field private inactiveColor:I
.field private interaction:F
.field private animator:Landroid/animation/ValueAnimator;

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 2

    invoke-direct {p0, p1, p2}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    new-instance v0, Landroid/graphics/Paint;
    const/4 v1, 0x1
    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v0, v0, Landroid/util/DisplayMetrics;->density:F
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->density:F

    const-string v0, "settings_md3_on_surface_variant"
    const v1, -0xbbb8b1
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I

    const-string v0, "settings_md3_outline_variant"
    const v1, -0x3b3930
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->inactiveColor:I

    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setThumb(Landroid/graphics/drawable/Drawable;)V

    new-instance v0, Landroid/graphics/drawable/ColorDrawable;
    const/4 v1, 0x0
    invoke-direct {v0, v1}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setProgressDrawable(Landroid/graphics/drawable/Drawable;)V

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->density:F
    const/high16 v1, 0x41a00000    # 20.0f
    mul-float/2addr v0, v1
    float-to-int v0, v0
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setPadding(IIII)V

    return-void
.end method

.method private static resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    .locals 3

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    const-string v1, "color"
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    if-eqz v1, :fallback
    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getColor(I)I
    move-result p2
    :fallback
    return p2
.end method

.method private animateInteraction(F)V
    .locals 5

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animator:Landroid/animation/ValueAnimator;
    if-eqz v0, :create
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    :create
    const/4 v0, 0x2
    new-array v0, v0, [F
    const/4 v1, 0x0
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->interaction:F
    aput v2, v0, v1
    const/4 v1, 0x1
    aput p1, v0, v1
    invoke-static {v0}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;
    move-result-object v0
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animator:Landroid/animation/ValueAnimator;

    const-wide/16 v1, 0x96
    invoke-virtual {v0, v1, v2}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;
    new-instance v1, Landroid/view/animation/DecelerateInterpolator;
    invoke-direct {v1}, Landroid/view/animation/DecelerateInterpolator;-><init>()V
    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V
    new-instance v1, Lcom/google/android/inputmethod/pinyin/Md3SliderView$InteractionUpdateListener;
    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView$InteractionUpdateListener;-><init>(Lcom/google/android/inputmethod/pinyin/Md3SliderView;)V
    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->start()V
    return-void
.end method

.method public updateInteraction(F)V
    .locals 0
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->interaction:F
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->invalidate()V
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0
    if-nez v0, :release
    const/high16 v1, 0x3f800000    # 1.0f
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animateInteraction(F)V
    goto :dispatch

    :release
    const/4 v1, 0x1
    if-eq v0, v1, :animate_release
    const/4 v1, 0x3
    if-ne v0, v1, :dispatch
    :animate_release
    const/4 v1, 0x0
    int-to-float v1, v1
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animateInteraction(F)V

    :dispatch
    invoke-super {p0, p1}, Landroid/widget/SeekBar;->onTouchEvent(Landroid/view/MotionEvent;)Z
    move-result v0
    return v0
.end method

.method protected onDetachedFromWindow()V
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animator:Landroid/animation/ValueAnimator;
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V
    :done
    invoke-super {p0}, Landroid/widget/SeekBar;->onDetachedFromWindow()V
    return-void
.end method

.method private setEnabledColor(Landroid/graphics/Paint;I)V
    .locals 1
    invoke-virtual {p1, p2}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->isEnabled()Z
    move-result v0
    if-eqz v0, :disabled
    const/16 v0, 0xff
    goto :apply
    :disabled
    const/16 v0, 0x61
    :apply
    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setAlpha(I)V
    return-void
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 14

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getWidth()I
    move-result v0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getPaddingRight()I
    move-result v1
    sub-int/2addr v0, v1
    int-to-float v0, v0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getPaddingLeft()I
    move-result v1
    int-to-float v1, v1

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getHeight()I
    move-result v2
    int-to-float v2, v2
    const/high16 v3, 0x40000000    # 2.0f
    div-float/2addr v2, v3

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->density:F
    const/high16 v4, 0x41000000    # 8.0f
    mul-float v4, v4, v3
    const/high16 v5, 0x40c00000    # 6.0f
    mul-float v5, v5, v3

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getMax()I
    move-result v6
    if-lez v6, :zero
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getProgress()I
    move-result v7
    int-to-float v7, v7
    int-to-float v6, v6
    div-float/2addr v7, v6
    goto :fraction
    :zero
    const/4 v7, 0x0
    int-to-float v7, v7
    :fraction

    sub-float v6, v0, v1
    mul-float/2addr v6, v7
    add-float/2addr v6, v1

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v7
    const/4 v8, 0x1
    if-ne v7, v8, :direction_done
    add-float v7, v0, v1
    sub-float v6, v7, v6
    :direction_done

    iget v7, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->interaction:F
    const/high16 v8, 0x40000000    # 2.0f
    mul-float v8, v8, v3
    const/high16 v9, 0x3f800000    # 1.0f
    mul-float/2addr v7, v9
    mul-float v9, v3, v7
    sub-float/2addr v8, v9

    add-float v9, v5, v8
    sub-float v10, v6, v9
    add-float v11, v6, v9
    sub-float v12, v2, v4
    add-float v13, v2, v4

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->paint:Landroid/graphics/Paint;
    iget v9, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->inactiveColor:I
    invoke-direct {p0, v5, v9}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setEnabledColor(Landroid/graphics/Paint;I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v9
    const/4 v7, 0x1
    if-ne v9, v7, :inactive_ltr
    cmpg-float v9, v1, v10
    if-gez v9, :active
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v1, v12, v10, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    goto :active
    :inactive_ltr
    cmpg-float v9, v11, v0
    if-gez v9, :active
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v11, v12, v0, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    :active
    iget v9, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-direct {p0, v5, v9}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setEnabledColor(Landroid/graphics/Paint;I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v9
    const/4 v7, 0x1
    if-ne v9, v7, :active_ltr
    cmpg-float v9, v11, v0
    if-gez v9, :state
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v11, v12, v0, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    goto :state
    :active_ltr
    cmpg-float v9, v1, v10
    if-gez v9, :state
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v1, v12, v10, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    :state
    iget v9, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->interaction:F
    const/4 v7, 0x0
    int-to-float v7, v7
    cmpl-float v7, v9, v7
    if-lez v7, :handle
    iget v7, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-virtual {v5, v7}, Landroid/graphics/Paint;->setColor(I)V
    const/high16 v7, 0x41f80000    # 31.0f
    mul-float/2addr v9, v7
    float-to-int v9, v9
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setAlpha(I)V
    const/high16 v9, 0x41a00000    # 20.0f
    mul-float/2addr v9, v3
    invoke-virtual {p1, v6, v2, v9, v5}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    :handle
    iget v9, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-direct {p0, v5, v9}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setEnabledColor(Landroid/graphics/Paint;I)V
    sub-float v7, v6, v8
    add-float v9, v6, v8
    const/high16 v4, 0x41b00000    # 22.0f
    mul-float/2addr v4, v3
    sub-float v10, v2, v4
    add-float v11, v2, v4
    new-instance v4, Landroid/graphics/RectF;
    invoke-direct {v4, v7, v10, v9, v11}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v4, v8, v8, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    const/16 v4, 0xff
    invoke-virtual {v5, v4}, Landroid/graphics/Paint;->setAlpha(I)V
    return-void
.end method
