.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;
.super Ljava/lang/Object;
.source "HeaderVisualSlot.java"


# static fields
.field private static final ID_CANDIDATE_SEPARATOR:I = 0x7f0f0013

.field private static final ID_DELETABLE_LABEL:I = 0x7f0f0185

.field private static final ID_LABEL:I = 0x7f0f0183

.field private static final ID_ORDINAL_LABEL:I = 0x7f0f0187


# instance fields
.field private final candidateLabelColors:Landroid/content/res/ColorStateList;

.field private final candidateLabelCurrentColor:Ljava/lang/Integer;

.field private final contentHost:Landroid/widget/FrameLayout;

.field private final railSeparator:Landroid/view/View;

.field private final root:Landroid/view/View;

.field private final separator:Landroid/view/View;


# direct methods
.method public constructor <init>(Landroid/view/View;)V
    .locals 7

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 25
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_4

    .line 28
    const v0, 0x7f0f0183

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 29
    instance-of v1, v0, Landroid/widget/TextView;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 30
    move-object v3, v0

    check-cast v3, Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v3

    goto :goto_0

    :cond_0
    move-object v3, v2

    :goto_0
    iput-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->candidateLabelColors:Landroid/content/res/ColorStateList;

    .line 31
    if-eqz v1, :cond_1

    .line 32
    move-object v1, v0

    check-cast v1, Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getCurrentTextColor()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    goto :goto_1

    :cond_1
    move-object v1, v2

    :goto_1
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->candidateLabelCurrentColor:Ljava/lang/Integer;

    .line 33
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->hideSemanticView(Landroid/view/View;)V

    .line 34
    const v0, 0x7f0f0185

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->hideSemanticView(Landroid/view/View;)V

    .line 35
    const v0, 0x7f0f0187

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->hideSemanticView(Landroid/view/View;)V

    .line 36
    const v0, 0x7f0f0013

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->separator:Landroid/view/View;

    .line 37
    const-string v0, "compat_clipboard_right_separator"

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->railSeparator:Landroid/view/View;

    .line 38
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->separator:Landroid/view/View;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->railSeparator:Landroid/view/View;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->separator:Landroid/view/View;

    .line 39
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 42
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->separator:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 43
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    .line 44
    instance-of v3, v1, Landroid/view/ViewGroup;

    if-eqz v3, :cond_2

    .line 47
    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 48
    new-instance v1, Landroid/widget/FrameLayout;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-direct {v1, v3}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 49
    invoke-virtual {p1}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v3

    .line 50
    invoke-virtual {p1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 51
    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 52
    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I

    move-result v3

    invoke-virtual {p1}, Landroid/view/View;->getPaddingTop()I

    move-result v4

    .line 53
    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I

    move-result v5

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result v6

    .line 52
    invoke-virtual {v1, v3, v4, v5, v6}, Landroid/widget/FrameLayout;->setPadding(IIII)V

    .line 54
    invoke-virtual {p1}, Landroid/view/View;->getMinimumWidth()I

    move-result v3

    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setMinimumWidth(I)V

    .line 55
    invoke-virtual {p1}, Landroid/view/View;->getMinimumHeight()I

    move-result v3

    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setMinimumHeight(I)V

    .line 56
    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setClipChildren(Z)V

    .line 57
    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setClipToPadding(Z)V

    .line 58
    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x1

    invoke-direct {v4, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v0, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 60
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->root:Landroid/view/View;

    .line 61
    new-instance v1, Landroid/widget/FrameLayout;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-direct {v1, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    .line 62
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    invoke-virtual {p1, v3}, Landroid/widget/FrameLayout;->setClipChildren(Z)V

    .line 63
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    invoke-virtual {p1, v3}, Landroid/widget/FrameLayout;->setClipToPadding(Z)V

    .line 64
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Landroid/widget/FrameLayout;->setSaveEnabled(Z)V

    .line 65
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    new-instance v1, Landroid/view/ViewGroup$LayoutParams;

    invoke-direct {v1, v5, v5}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p1, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 67
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->separator:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->bringToFront()V

    .line 68
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->root:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 69
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->root:Landroid/view/View;

    const/4 v0, 0x2

    invoke-virtual {p1, v0}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 70
    return-void

    .line 45
    :cond_2
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "native Candidate content owner is missing"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 40
    :cond_3
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "native Candidate separator/content parent is missing"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 26
    :cond_4
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "native slot root must be a ViewGroup"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private static hideSemanticView(Landroid/view/View;)V
    .locals 1

    .line 84
    if-nez p0, :cond_0

    return-void

    .line 85
    :cond_0
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 86
    const/4 v0, 0x4

    invoke-virtual {p0, v0}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 87
    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    .line 88
    return-void
.end method


# virtual methods
.method public clear()V
    .locals 1

    .line 80
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->removeAllViews()V

    .line 81
    return-void
.end method

.method public getCandidateLabelColors()Landroid/content/res/ColorStateList;
    .locals 1

    .line 76
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->candidateLabelColors:Landroid/content/res/ColorStateList;

    return-object v0
.end method

.method public getCandidateLabelCurrentColor()Ljava/lang/Integer;
    .locals 1

    .line 77
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->candidateLabelCurrentColor:Ljava/lang/Integer;

    return-object v0
.end method

.method public getContentHost()Landroid/widget/FrameLayout;
    .locals 1

    .line 73
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->contentHost:Landroid/widget/FrameLayout;

    return-object v0
.end method

.method public getRailSeparator()Landroid/view/View;
    .locals 1

    .line 75
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->railSeparator:Landroid/view/View;

    return-object v0
.end method

.method public getRoot()Landroid/view/View;
    .locals 1

    .line 72
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->root:Landroid/view/View;

    return-object v0
.end method

.method public getSeparator()Landroid/view/View;
    .locals 1

    .line 74
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->separator:Landroid/view/View;

    return-object v0
.end method
