.class public final Lcom/google/android/inputmethod/pinyin/Md3SliderView;
.super Landroid/widget/SeekBar;

.field private final paint:Landroid/graphics/Paint;
.field private density:F
.field private activeColor:I
.field private inactiveColor:I
.field private surfaceColor:I
.field private interaction:F
.field private animator:Landroid/animation/ValueAnimator;
.field private listener:Landroid/widget/SeekBar$OnSeekBarChangeListener;

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

    const-string v0, "settings_md3_surface"
    const v1, -0x60601
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->surfaceColor:I

    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setThumb(Landroid/graphics/drawable/Drawable;)V

    new-instance v0, Landroid/graphics/drawable/ColorDrawable;
    const/4 v1, 0x0
    invoke-direct {v0, v1}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setProgressDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setForeground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setStateListAnimator(Landroid/animation/StateListAnimator;)V

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

.method public setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V
    .locals 0
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->listener:Landroid/widget/SeekBar$OnSeekBarChangeListener;
    return-void
.end method

.method public declared-synchronized setProgress(I)V
    .locals 2
    invoke-super {p0, p1}, Landroid/widget/SeekBar;->setProgress(I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getProgress()I
    move-result v0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->listener:Landroid/widget/SeekBar$OnSeekBarChangeListener;
    if-eqz v1, :redraw
    const/4 p1, 0x0
    invoke-interface {v1, p0, v0, p1}, Landroid/widget/SeekBar$OnSeekBarChangeListener;->onProgressChanged(Landroid/widget/SeekBar;IZ)V
    :redraw
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->invalidate()V
    return-void
.end method

.method private updateFromTouch(Landroid/view/MotionEvent;)V
    .locals 8
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F
    move-result v0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getPaddingLeft()I
    move-result v1
    int-to-float v1, v1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getWidth()I
    move-result v2
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getPaddingRight()I
    move-result v3
    sub-int/2addr v2, v3
    int-to-float v2, v2
    invoke-static {v0, v1}, Ljava/lang/Math;->max(FF)F
    move-result v0
    invoke-static {v0, v2}, Ljava/lang/Math;->min(FF)F
    move-result v0
    sub-float/2addr v0, v1
    sub-float v3, v2, v1
    div-float/2addr v0, v3
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v3
    const/4 v4, 0x1
    if-ne v3, v4, :scale
    const/high16 v3, 0x3f800000    # 1.0f
    sub-float v0, v3, v0
    :scale
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getMax()I
    move-result v3
    int-to-float v4, v3
    mul-float/2addr v0, v4
    invoke-static {v0}, Ljava/lang/Math;->round(F)I
    move-result v3
    invoke-super {p0, v3}, Landroid/widget/SeekBar;->setProgress(I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getProgress()I
    move-result v3
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->listener:Landroid/widget/SeekBar$OnSeekBarChangeListener;
    if-eqz v4, :redraw
    const/4 v5, 0x1
    invoke-interface {v4, p0, v3, v5}, Landroid/widget/SeekBar$OnSeekBarChangeListener;->onProgressChanged(Landroid/widget/SeekBar;IZ)V
    :redraw
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->invalidate()V
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->isEnabled()Z
    move-result v0
    if-nez v0, :enabled
    const/4 v0, 0x0
    return v0
    :enabled
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0
    if-nez v0, :move
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getParent()Landroid/view/ViewParent;
    move-result-object v1
    if-eqz v1, :start
    const/4 v2, 0x1
    invoke-interface {v1, v2}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V
    :start
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->listener:Landroid/widget/SeekBar$OnSeekBarChangeListener;
    if-eqz v1, :animate_press
    invoke-interface {v1, p0}, Landroid/widget/SeekBar$OnSeekBarChangeListener;->onStartTrackingTouch(Landroid/widget/SeekBar;)V
    :animate_press
    const/high16 v1, 0x3f800000    # 1.0f
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animateInteraction(F)V
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->updateFromTouch(Landroid/view/MotionEvent;)V
    const/4 v0, 0x1
    return v0
    :move
    const/4 v1, 0x2
    if-ne v0, v1, :release
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->updateFromTouch(Landroid/view/MotionEvent;)V
    const/4 v0, 0x1
    return v0
    :release
    const/4 v1, 0x1
    if-eq v0, v1, :finish_with_value
    const/4 v1, 0x3
    if-ne v0, v1, :handled
    goto :finish
    :finish_with_value
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->updateFromTouch(Landroid/view/MotionEvent;)V
    :finish
    const/4 v1, 0x0
    int-to-float v1, v1
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animateInteraction(F)V
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->listener:Landroid/widget/SeekBar$OnSeekBarChangeListener;
    if-eqz v1, :allow_parent
    invoke-interface {v1, p0}, Landroid/widget/SeekBar$OnSeekBarChangeListener;->onStopTrackingTouch(Landroid/widget/SeekBar;)V
    :allow_parent
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getParent()Landroid/view/ViewParent;
    move-result-object v1
    if-eqz v1, :handled
    const/4 v2, 0x0
    invoke-interface {v1, v2}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V
    :handled
    const/4 v0, 0x1
    return v0
.end method

.method public setEnabled(Z)V
    .locals 2
    invoke-super {p0, p1}, Landroid/widget/SeekBar;->setEnabled(Z)V
    if-nez p1, :done
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->animator:Landroid/animation/ValueAnimator;
    if-eqz v0, :clear
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V
    :clear
    const/4 v0, 0x0
    int-to-float v0, v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->interaction:F
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->invalidate()V
    :done
    return-void
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

.method private drawIndicators(Landroid/graphics/Canvas;FFF)V
    .locals 8

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getMax()I
    move-result v0
    if-lez v0, :done
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->paint:Landroid/graphics/Paint;
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->density:F
    const/high16 v3, 0x40000000    # 2.0f
    mul-float/2addr v2, v3
    const/16 v3, 0xa
    if-gt v0, v3, :continuous

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getProgress()I
    move-result v4
    const/4 v3, 0x0
    :tick_loop
    if-gt v3, v0, :done
    int-to-float v5, v3
    int-to-float v6, v0
    div-float/2addr v5, v6
    sub-float v6, p3, p2
    mul-float/2addr v5, v6
    add-float/2addr v5, p2
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v6
    const/4 v7, 0x1
    if-ne v6, v7, :tick_color
    add-float v6, p2, p3
    sub-float v5, v6, v5
    :tick_color
    if-le v3, v4, :active_tick
    iget v6, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    goto :paint_tick
    :active_tick
    iget v6, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->surfaceColor:I
    :paint_tick
    invoke-direct {p0, v1, v6}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setEnabledColor(Landroid/graphics/Paint;I)V
    invoke-virtual {p1, v5, p4, v2, v1}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V
    add-int/lit8 v3, v3, 0x1
    goto :tick_loop

    :continuous
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-direct {p0, v1, v3}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setEnabledColor(Landroid/graphics/Paint;I)V
    move v5, p3
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v3
    const/4 v4, 0x1
    if-ne v3, v4, :draw_stop
    move v5, p2
    :draw_stop
    invoke-virtual {p1, v5, p4, v2, v1}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    :done
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
    sub-float v9, v1, v4
    cmpg-float v7, v9, v10
    if-gez v7, :active
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v9, v12, v10, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    sub-float v9, v10, v4
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v9, v12, v10, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v5}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V
    goto :active
    :inactive_ltr
    add-float v9, v0, v4
    cmpg-float v7, v11, v9
    if-gez v7, :active
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v11, v12, v9, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    add-float v9, v11, v4
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v11, v12, v9, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v5}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    :active
    iget v9, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-direct {p0, v5, v9}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setEnabledColor(Landroid/graphics/Paint;I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v9
    const/4 v7, 0x1
    if-ne v9, v7, :active_ltr
    add-float v9, v0, v4
    cmpg-float v7, v11, v9
    if-gez v7, :state
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v11, v12, v9, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    add-float v9, v11, v4
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v11, v12, v9, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v5}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V
    goto :state
    :active_ltr
    sub-float v9, v1, v4
    cmpg-float v7, v9, v10
    if-gez v7, :state
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v9, v12, v10, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v4, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    sub-float v9, v10, v4
    new-instance v7, Landroid/graphics/RectF;
    invoke-direct {v7, v9, v12, v10, v13}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v7, v5}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    :state
    invoke-direct {p0, p1, v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->drawIndicators(Landroid/graphics/Canvas;FFF)V

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
