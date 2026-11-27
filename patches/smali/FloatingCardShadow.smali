.class final Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;
.super Landroid/view/View;
.source "FloatingCardShadow.java"


# instance fields
.field private final inset:F

.field private final paint:Landroid/graphics/Paint;

.field private final radius:F

.field private final ring:Landroid/graphics/Path;


# direct methods
.method constructor <init>(Landroid/content/Context;F)V
    .locals 4

    .line 31
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 25
    new-instance p1, Landroid/graphics/Paint;

    const/4 v0, 0x1

    invoke-direct {p1, v0}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    .line 26
    new-instance p1, Landroid/graphics/Path;

    invoke-direct {p1}, Landroid/graphics/Path;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    .line 32
    const/high16 p1, 0x41100000    # 9.0f

    mul-float p1, p1, p2

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->radius:F

    .line 35
    const/high16 p1, 0x41500000    # 13.0f

    mul-float p1, p1, p2

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    .line 36
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 39
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    const/high16 v1, 0x1000000

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 40
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    sget-object v1, Landroid/graphics/Path$FillType;->EVEN_ODD:Landroid/graphics/Path$FillType;

    invoke-virtual {p1, v1}, Landroid/graphics/Path;->setFillType(Landroid/graphics/Path$FillType;)V

    .line 42
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->radius:F

    const/high16 v2, 0x40000000    # 2.0f

    mul-float p2, p2, v2

    const/high16 v2, 0x40000000    # 2.0f

    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, p2, v2}, Landroid/graphics/Paint;->setShadowLayer(FFFI)V

    .line 43
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setWillNotDraw(Z)V

    .line 44
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setClickable(Z)V

    .line 45
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setFocusable(Z)V

    .line 46
    const/4 p1, 0x2

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setImportantForAccessibility(I)V

    .line 47
    const/4 p1, 0x0

    invoke-virtual {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayerType(ILandroid/graphics/Paint;)V

    .line 48
    return-void
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 13

    .line 57
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getWidth()I

    move-result v0

    .line 58
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getHeight()I

    move-result v1

    .line 59
    int-to-float v5, v0

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    const/high16 v2, 0x40000000    # 2.0f

    mul-float v0, v0, v2

    cmpg-float v0, v5, v0

    if-lez v0, :cond_1

    int-to-float v6, v1

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    mul-float v0, v0, v2

    cmpg-float v0, v6, v0

    if-gtz v0, :cond_0

    goto :goto_0

    .line 63
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 64
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    const/4 v4, 0x0

    sget-object v7, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    const/4 v3, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Path;->addRect(FFFFLandroid/graphics/Path$Direction;)V

    .line 65
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget v8, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    iget v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    sub-float v10, v5, v0

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    sub-float v11, v6, v0

    sget-object v12, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual/range {v7 .. v12}, Landroid/graphics/Path;->addRect(FFFFLandroid/graphics/Path$Direction;)V

    .line 66
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 67
    return-void

    .line 59
    :cond_1
    :goto_0
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 52
    const/4 p1, 0x0

    return p1
.end method
