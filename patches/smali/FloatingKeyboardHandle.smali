.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;
.super Landroid/view/View;
.source "FloatingKeyboardHandle.java"


# instance fields
.field private final density:F

.field private final paint:Landroid/graphics/Paint;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    .line 22
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 18
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->paint:Landroid/graphics/Paint;

    .line 23
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p1

    iget p1, p1, Landroid/util/DisplayMetrics;->density:F

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    .line 25
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->paint:Landroid/graphics/Paint;

    const v0, -0x667f7f80

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setColor(I)V

    .line 26
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setClickable(Z)V

    .line 27
    return-void
.end method


# virtual methods
.method public heightPx()I
    .locals 2

    .line 31
    const/high16 v0, 0x41900000    # 18.0f

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    return v0
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 12

    .line 36
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const v1, 0x3e3851ec    # 0.18f

    mul-float v0, v0, v1

    const/high16 v1, 0x42600000    # 56.0f

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    mul-float v2, v2, v1

    invoke-static {v0, v2}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 37
    const/high16 v1, 0x40800000    # 4.0f

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->density:F

    mul-float v2, v2, v1

    .line 38
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getWidth()I

    move-result v1

    int-to-float v1, v1

    sub-float/2addr v1, v0

    const/high16 v3, 0x40000000    # 2.0f

    div-float v5, v1, v3

    .line 39
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getHeight()I

    move-result v1

    int-to-float v1, v1

    sub-float/2addr v1, v2

    div-float v6, v1, v3

    .line 40
    add-float v7, v5, v0

    add-float v8, v6, v2

    div-float v9, v2, v3

    iget-object v11, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->paint:Landroid/graphics/Paint;

    move v10, v9

    move-object v4, p1

    invoke-virtual/range {v4 .. v11}, Landroid/graphics/Canvas;->drawRoundRect(FFFFFFLandroid/graphics/Paint;)V

    .line 48
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 52
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result p1

    return p1
.end method
