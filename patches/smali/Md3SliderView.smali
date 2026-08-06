.class public final Lcom/google/android/inputmethod/pinyin/Md3SliderView;
.super Landroid/widget/SeekBar;

.field private final paint:Landroid/graphics/Paint;
.field private density:F
.field private activeColor:I
.field private inactiveColor:I
.field private stateColor:I

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

    const-string v0, "settings_md3_primary"
    const v1, -0xf4a830
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I

    const-string v0, "settings_md3_outline_variant"
    const v1, -0x3b3a30
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->inactiveColor:I

    const-string v0, "settings_md3_slider_state_layer"
    const v1, 0x1f0b57d0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->resolveColor(Landroid/content/Context;Ljava/lang/String;I)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->stateColor:I

    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setThumb(Landroid/graphics/drawable/Drawable;)V

    new-instance v0, Landroid/graphics/drawable/ColorDrawable;
    const/4 v1, 0x0
    invoke-direct {v0, v1}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->setProgressDrawable(Landroid/graphics/drawable/Drawable;)V

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->density:F
    const/high16 v1, 0x41200000    # 10.0f
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

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->density:F
    mul-float v5, v4, v3

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

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v7
    const/4 v8, 0x1
    if-ne v7, v8, :ltr
    sub-float v6, v0, v6
    move v7, v0
    move v0, v1
    move v1, v7
    goto :positioned
    :ltr
    add-float/2addr v6, v1
    :positioned

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->paint:Landroid/graphics/Paint;
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->isEnabled()Z
    move-result v8
    if-eqz v8, :disabled
    const/16 v8, 0xff
    goto :alpha
    :disabled
    const/16 v8, 0x61
    :alpha
    invoke-virtual {v7, v8}, Landroid/graphics/Paint;->setAlpha(I)V

    iget v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->inactiveColor:I
    invoke-virtual {v7, v8}, Landroid/graphics/Paint;->setColor(I)V
    sub-float v10, v2, v5
    add-float v11, v2, v5
    new-instance v12, Landroid/graphics/RectF;
    invoke-direct {v12, v0, v10, v1, v11}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v12, v5, v5, v7}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    iget v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-virtual {v7, v8}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->getLayoutDirection()I
    move-result v8
    const/4 v9, 0x1
    if-ne v8, v9, :active_ltr
    new-instance v12, Landroid/graphics/RectF;
    invoke-direct {v12, v6, v10, v1, v11}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v12, v5, v5, v7}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    goto :halo
    :active_ltr
    new-instance v12, Landroid/graphics/RectF;
    invoke-direct {v12, v0, v10, v6, v11}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v12, v5, v5, v7}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    :halo
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->isPressed()Z
    move-result v0
    if-eqz v0, :thumb
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->stateColor:I
    invoke-virtual {v7, v0}, Landroid/graphics/Paint;->setColor(I)V
    const/high16 v0, 0x41a00000    # 20.0f
    mul-float/2addr v0, v4
    invoke-virtual {p1, v6, v2, v0, v7}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    :thumb
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->activeColor:I
    invoke-virtual {v7, v0}, Landroid/graphics/Paint;->setColor(I)V
    const/high16 v0, 0x41200000    # 10.0f
    mul-float/2addr v0, v4
    invoke-virtual {p1, v6, v2, v0, v7}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    const/16 v0, 0xff
    invoke-virtual {v7, v0}, Landroid/graphics/Paint;->setAlpha(I)V
    return-void
.end method
