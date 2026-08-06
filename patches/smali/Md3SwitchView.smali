.class public final Lcom/google/android/inputmethod/pinyin/Md3SwitchView;
.super Landroid/view/View;
.source "Md3SwitchView.java"

# interfaces
.implements Landroid/widget/Checkable;

# instance fields
.field private checked:Z
.field private position:F
.field private animator:Landroid/animation/ValueAnimator;
.field private final trackPaint:Landroid/graphics/Paint;
.field private final thumbPaint:Landroid/graphics/Paint;
.field private primary:I
.field private onPrimary:I
.field private surfaceContainerHigh:I
.field private outline:I
.field private outlineVariant:I

# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v0, Landroid/graphics/Paint;
    const/4 p1, 0x1
    invoke-direct {v0, p1}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->trackPaint:Landroid/graphics/Paint;

    new-instance v0, Landroid/graphics/Paint;
    invoke-direct {v0, p1}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->thumbPaint:Landroid/graphics/Paint;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->loadColors()V
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    invoke-direct {p0, p1, p2}, Landroid/view/View;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    new-instance v0, Landroid/graphics/Paint;
    const/4 p2, 0x1
    invoke-direct {v0, p2}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->trackPaint:Landroid/graphics/Paint;

    new-instance v0, Landroid/graphics/Paint;
    invoke-direct {v0, p2}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->thumbPaint:Landroid/graphics/Paint;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->loadColors()V
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 1

    invoke-direct {p0, p1, p2, p3}, Landroid/view/View;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    new-instance v0, Landroid/graphics/Paint;
    const/4 p1, 0x1
    invoke-direct {v0, p1}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->trackPaint:Landroid/graphics/Paint;

    new-instance v0, Landroid/graphics/Paint;
    invoke-direct {v0, p1}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->thumbPaint:Landroid/graphics/Paint;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->loadColors()V
    return-void
.end method

.method private resolveColor(Ljava/lang/String;)I
    .locals 4

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->getContext()Landroid/content/Context;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v1

    const-string v2, "color"
    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, p1, v2, v3}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result p1

    if-eqz p1, :missing
    invoke-virtual {v1, p1}, Landroid/content/res/Resources;->getColor(I)I
    move-result p1
    return p1

    :missing
    const/4 p1, 0x0
    return p1
.end method

.method private logState(Ljava/lang/String;)V
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    const-string p1, " id="
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {p0}, Ljava/lang/System;->identityHashCode(Ljava/lang/Object;)I
    move-result p1
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string p1, " laid="
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->isLaidOut()Z
    move-result p1
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string p1, " attached="
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->isAttachedToWindow()Z
    move-result p1
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string p1, " shown="
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->isShown()Z
    move-result p1
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string p1, " checked="
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string p1, " position="
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->position:F
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "GooglePinyinMd3Switch"
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

.method private loadColors()V
    .locals 1

    const-string v0, "settings_md3_on_surface_variant"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->resolveColor(Ljava/lang/String;)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->primary:I

    const-string v0, "settings_md3_surface"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->resolveColor(Ljava/lang/String;)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->onPrimary:I

    const-string v0, "settings_md3_surface_container_high"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->resolveColor(Ljava/lang/String;)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->surfaceContainerHigh:I

    const-string v0, "settings_md3_outline"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->resolveColor(Ljava/lang/String;)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->outline:I

    const-string v0, "settings_md3_outline_variant"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->resolveColor(Ljava/lang/String;)I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->outlineVariant:I

    return-void
.end method

# virtual methods
.method public isChecked()Z
    .locals 1
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    return v0
.end method

.method public setChecked(Z)V
    .locals 6

    const-string v0, "setChecked"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    if-eq v0, p1, :same
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z

    if-eqz p1, :off
    const/high16 v0, 0x3f800000    # 1.0f
    goto :target
    :off
    const/4 v0, 0x0
    int-to-float v0, v0

    :target
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->isLaidOut()Z
    move-result v1
    if-eqz v1, :snap
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->isAttachedToWindow()Z
    move-result v1
    if-eqz v1, :snap

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->animator:Landroid/animation/ValueAnimator;
    if-eqz v1, :new_animator
    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->cancel()V

    :new_animator
    const/4 v1, 0x2
    new-array v1, v1, [F
    const/4 v2, 0x0
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->position:F
    aput v3, v1, v2
    const/4 v2, 0x1
    aput v0, v1, v2
    invoke-static {v1}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;
    move-result-object v1
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->animator:Landroid/animation/ValueAnimator;

    const-wide/16 v2, 0xc8
    invoke-virtual {v1, v2, v3}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;
    move-result-object v2

    new-instance v2, Landroid/view/animation/DecelerateInterpolator;
    invoke-direct {v2}, Landroid/view/animation/DecelerateInterpolator;-><init>()V
    invoke-virtual {v1, v2}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    new-instance v2, Lcom/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener;
    invoke-direct {v2, p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener;-><init>(Lcom/google/android/inputmethod/pinyin/Md3SwitchView;)V
    invoke-virtual {v1, v2}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V
    const-string v2, "animate"
    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V
    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->start()V
    goto :done

    :snap
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->position:F
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->invalidate()V
    const-string v1, "snap"
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V
    goto :done

    :same
    const-string v0, "same"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V

    :done
    return-void
.end method

.method static synthetic updatePosition(Lcom/google/android/inputmethod/pinyin/Md3SwitchView;F)V
    .locals 0
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->position:F
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->invalidate()V
    const-string p1, "frame"
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V
    return-void
.end method

.method protected onAttachedToWindow()V
    .locals 1
    invoke-super {p0}, Landroid/view/View;->onAttachedToWindow()V
    const-string v0, "attached"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V
    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 1
    const-string v0, "detached"
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->logState(Ljava/lang/String;)V
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->animator:Landroid/animation/ValueAnimator;
    if-eqz v0, :super_call
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V
    const/4 v0, 0x0
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->animator:Landroid/animation/ValueAnimator;
    :super_call
    invoke-super {p0}, Landroid/view/View;->onDetachedFromWindow()V
    return-void
.end method

.method public toggle()V
    .locals 1
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    xor-int/lit8 v0, v0, 0x1
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->setChecked(Z)V
    return-void
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 12

    invoke-super {p0, p1}, Landroid/view/View;->onDraw(Landroid/graphics/Canvas;)V

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->getWidth()I
    move-result v1
    int-to-float v1, v1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->getHeight()I
    move-result v2
    int-to-float v2, v2

    const/high16 v3, 0x42000000    # 32.0f
    mul-float v3, v3, v0
    sub-float v4, v2, v3
    const/high16 v5, 0x40000000    # 2.0f
    div-float v4, v4, v5
    add-float v6, v4, v3

    const/high16 v7, 0x41800000    # 16.0f
    mul-float v7, v7, v0

    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->trackPaint:Landroid/graphics/Paint;
    sget-object v9, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;
    invoke-virtual {v8, v9}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->isEnabled()Z
    move-result v9
    if-eqz v9, :disabled_track
    iget-boolean v10, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    if-eqz v10, :unchecked_track
    iget v10, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->primary:I
    goto :track_color

    :unchecked_track
    iget v10, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->surfaceContainerHigh:I
    goto :track_color

    :disabled_track
    iget v10, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->surfaceContainerHigh:I

    :track_color
    invoke-virtual {v8, v10}, Landroid/graphics/Paint;->setColor(I)V
    new-instance v10, Landroid/graphics/RectF;
    const/4 v11, 0x0
    int-to-float v11, v11
    invoke-direct {v10, v11, v4, v1, v6}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v10, v7, v7, v8}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    iget-boolean v10, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    if-nez v10, :thumb

    sget-object v10, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;
    invoke-virtual {v8, v10}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    const/high16 v10, 0x40000000    # 2.0f
    mul-float v10, v10, v0
    invoke-virtual {v8, v10}, Landroid/graphics/Paint;->setStrokeWidth(F)V
    if-eqz v9, :disabled_outline
    iget v11, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->outline:I
    goto :outline_color
    :disabled_outline
    iget v11, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->outlineVariant:I
    :outline_color
    invoke-virtual {v8, v11}, Landroid/graphics/Paint;->setColor(I)V
    const/high16 v11, 0x3f800000    # 1.0f
    mul-float v11, v11, v0
    add-float/2addr v4, v11
    sub-float/2addr v6, v11
    sub-float v3, v1, v11
    sub-float/2addr v7, v11
    new-instance v10, Landroid/graphics/RectF;
    invoke-direct {v10, v11, v4, v3, v6}, Landroid/graphics/RectF;-><init>(FFFF)V
    invoke-virtual {p1, v10, v7, v7, v8}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    :thumb
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->thumbPaint:Landroid/graphics/Paint;
    sget-object v5, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;
    invoke-virtual {v4, v5}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    const/high16 v6, 0x41800000    # 16.0f
    mul-float v6, v6, v0
    const/high16 v7, 0x42000000    # 32.0f
    mul-float v7, v7, v0
    sub-float v7, v1, v7
    iget v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->position:F
    mul-float v7, v7, v8
    add-float/2addr v6, v7

    const/high16 v7, 0x41000000    # 8.0f
    const/high16 v10, 0x40800000    # 4.0f
    mul-float v10, v10, v8
    add-float/2addr v7, v10
    mul-float v7, v7, v0

    iget-boolean v5, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->checked:Z
    if-eqz v5, :thumb_off
    iget v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->onPrimary:I
    goto :draw_thumb

    :thumb_off
    if-eqz v9, :thumb_disabled
    iget v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->outline:I
    goto :draw_thumb
    :thumb_disabled
    iget v8, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->outlineVariant:I

    :draw_thumb
    invoke-virtual {v4, v8}, Landroid/graphics/Paint;->setColor(I)V
    const/high16 v8, 0x40000000    # 2.0f
    div-float/2addr v2, v8
    invoke-virtual {p1, v6, v2, v7, v4}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V
    return-void
.end method
