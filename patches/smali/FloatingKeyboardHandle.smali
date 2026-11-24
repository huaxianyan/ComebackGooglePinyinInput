.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;
.super Landroid/view/View;
.source "FloatingKeyboardHandle.java"


# instance fields
.field private barCenterFromBottom:F

.field private final density:F

.field private final paint:Landroid/graphics/Paint;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    .line 24
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 18
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->paint:Landroid/graphics/Paint;

    .line 21
    const/high16 v0, -0x40800000    # -1.0f

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->barCenterFromBottom:F

    .line 25
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p1

    iget p1, p1, Landroid/util/DisplayMetrics;->density:F

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    .line 28
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->paint:Landroid/graphics/Paint;

    const v0, -0x3d372e

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setColor(I)V

    .line 29
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setClickable(Z)V

    .line 30
    return-void
.end method


# virtual methods
.method public heightPx()I
    .locals 2

    .line 34
    const/high16 v0, 0x41a00000    # 20.0f

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    return v0
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 12

    .line 50
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const v1, 0x3e6147ae    # 0.22f

    mul-float v0, v0, v1

    const/high16 v1, 0x42700000    # 60.0f

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    mul-float v2, v2, v1

    invoke-static {v0, v2}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 51
    const/high16 v1, 0x40c00000    # 6.0f

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    mul-float v2, v2, v1

    .line 52
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getWidth()I

    move-result v1

    int-to-float v1, v1

    sub-float/2addr v1, v0

    const/high16 v3, 0x40000000    # 2.0f

    div-float v5, v1, v3

    .line 53
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->barCenterFromBottom:F

    const/4 v4, 0x0

    cmpl-float v1, v1, v4

    if-ltz v1, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getHeight()I

    move-result v1

    int-to-float v1, v1

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->barCenterFromBottom:F

    sub-float/2addr v1, v4

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v3

    .line 54
    :goto_0
    div-float v9, v2, v3

    sub-float v6, v1, v9

    .line 55
    add-float v7, v5, v0

    add-float v8, v6, v2

    iget-object v11, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->paint:Landroid/graphics/Paint;

    move v10, v9

    move-object v4, p1

    invoke-virtual/range {v4 .. v11}, Landroid/graphics/Canvas;->drawRoundRect(FFFFFFLandroid/graphics/Paint;)V

    .line 63
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 67
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result p1

    return p1
.end method

.method public setBarCenterFromBottom(F)V
    .locals 2

    .line 43
    const/4 v0, 0x0

    cmpg-float v0, p1, v0

    if-ltz v0, :cond_1

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->barCenterFromBottom:F

    sub-float v0, p1, v0

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    const/high16 v1, 0x3f000000    # 0.5f

    cmpg-float v0, v0, v1

    if-gez v0, :cond_0

    goto :goto_0

    .line 44
    :cond_0
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->barCenterFromBottom:F

    .line 45
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->invalidate()V

    .line 46
    return-void

    .line 43
    :cond_1
    :goto_0
    return-void
.end method
