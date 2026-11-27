.class final Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;
.super Landroid/view/View;
.source "FloatingCardShadow.java"


# static fields
.field static final INSET_DP:F = 10.0f


# instance fields
.field private final inner:F

.field private final inset:F

.field private final paint:Landroid/graphics/Paint;

.field private final radius:F

.field private final ring:Landroid/graphics/Path;


# direct methods
.method constructor <init>(Landroid/content/Context;F)V
    .locals 4

    .line 37
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 30
    new-instance p1, Landroid/graphics/Paint;

    const/4 v0, 0x1

    invoke-direct {p1, v0}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    .line 31
    new-instance p1, Landroid/graphics/Path;

    invoke-direct {p1}, Landroid/graphics/Path;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    .line 38
    const/high16 p1, 0x40e00000    # 7.0f

    mul-float p1, p1, p2

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->radius:F

    .line 39
    const/high16 p1, 0x41400000    # 12.0f

    mul-float p1, p1, p2

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inner:F

    .line 42
    const/high16 p1, 0x41200000    # 10.0f

    mul-float p1, p1, p2

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    .line 43
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 46
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    const/high16 v1, 0x1000000

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 47
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    sget-object v1, Landroid/graphics/Path$FillType;->EVEN_ODD:Landroid/graphics/Path$FillType;

    invoke-virtual {p1, v1}, Landroid/graphics/Path;->setFillType(Landroid/graphics/Path$FillType;)V

    .line 49
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->radius:F

    const/high16 v2, 0x40000000    # 2.0f

    mul-float p2, p2, v2

    const/high16 v2, 0x33000000

    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, p2, v2}, Landroid/graphics/Paint;->setShadowLayer(FFFI)V

    .line 50
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setWillNotDraw(Z)V

    .line 51
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setClickable(Z)V

    .line 52
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setFocusable(Z)V

    .line 53
    const/4 p1, 0x2

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setImportantForAccessibility(I)V

    .line 54
    const/4 p1, 0x0

    invoke-virtual {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayerType(ILandroid/graphics/Paint;)V

    .line 55
    return-void
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 16

    .line 64
    move-object/from16 v0, p0

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getWidth()I

    move-result v1

    .line 65
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getHeight()I

    move-result v2

    .line 66
    int-to-float v6, v1

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    const/high16 v3, 0x40000000    # 2.0f

    mul-float v1, v1, v3

    cmpg-float v1, v6, v1

    if-lez v1, :cond_1

    int-to-float v7, v2

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    mul-float v1, v1, v3

    cmpg-float v1, v7, v1

    if-gtz v1, :cond_0

    goto :goto_0

    .line 70
    :cond_0
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    invoke-virtual {v1}, Landroid/graphics/Path;->reset()V

    .line 72
    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inner:F

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    add-float v8, v1, v2

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inner:F

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    add-float v9, v1, v2

    sget-object v10, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    const/4 v4, 0x0

    const/4 v5, 0x0

    invoke-virtual/range {v3 .. v10}, Landroid/graphics/Path;->addRoundRect(FFFFFFLandroid/graphics/Path$Direction;)V

    .line 74
    iget-object v8, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget v9, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    iget v10, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    sub-float v11, v6, v1

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    sub-float v12, v7, v1

    iget v13, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inner:F

    iget v14, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inner:F

    sget-object v15, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual/range {v8 .. v15}, Landroid/graphics/Path;->addRoundRect(FFFFFFLandroid/graphics/Path$Direction;)V

    .line 76
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    move-object/from16 v3, p1

    invoke-virtual {v3, v1, v2}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 77
    return-void

    .line 66
    :cond_1
    :goto_0
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 59
    const/4 p1, 0x0

    return p1
.end method
