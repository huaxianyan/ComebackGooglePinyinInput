.class final Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;
.super Ljava/lang/Object;
.source "InlineAutofillRemoteContent.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
.implements Landroid/view/View$OnLayoutChangeListener;
.implements Ljava/lang/Runnable;


# static fields
.field private static final NEXT_DESCRIPTION_RES_ID:I = 0x7f1101ff

.field private static final PREVIOUS_DESCRIPTION_RES_ID:I = 0x7f110200

.field private static final RAIL_WIDTH_RES_ID:I = 0x7f0d0206


# instance fields
.field private final candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

.field private final childRect:Landroid/graphics/Rect;

.field private final clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

.field private currentIndex:I

.field private final hostRect:Landroid/graphics/Rect;

.field private final leadingInset:I

.field private final nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

.field private final previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

.field private final railWidth:I

.field private released:Z

.field private final root:Landroid/widget/FrameLayout;

.field private final trailingInset:I

.field private final views:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)V
    .locals 4

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 28
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    .line 29
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->hostRect:Landroid/graphics/Rect;

    .line 30
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    .line 40
    if-eqz p3, :cond_1

    .line 41
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->getClipper()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    .line 42
    new-instance v0, Landroid/widget/FrameLayout;

    invoke-direct {v0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    .line 43
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setClipChildren(Z)V

    .line 44
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setClipToPadding(Z)V

    .line 45
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setSaveEnabled(Z)V

    .line 46
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v2, 0x7f0d0206

    invoke-virtual {v0, v2}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v0

    .line 49
    invoke-interface {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;->createCandidateChromeSlot()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    move-result-object v2

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    .line 52
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getSeparator()Landroid/view/View;

    move-result-object v2

    const/16 v3, 0x8

    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    .line 53
    sget-object v2, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->PREVIOUS:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    invoke-interface {p3, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;->createActionChromeSlot(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    move-result-object v2

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    .line 54
    sget-object v2, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->NEXT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    invoke-interface {p3, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;->createActionChromeSlot(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    move-result-object p3

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    .line 55
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRailWidth()I

    move-result p3

    if-lez p3, :cond_0

    .line 56
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRailWidth()I

    move-result v0

    goto :goto_0

    :cond_0
    nop

    :goto_0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->railWidth:I

    .line 57
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getLeadingInset()I

    move-result p3

    iput p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->leadingInset:I

    .line 58
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getTrailingInset()I

    move-result p3

    iput p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->trailingInset:I

    .line 59
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->getViews()Ljava/util/List;

    move-result-object v2

    invoke-direct {p0, p1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->centerParams(Landroid/content/Context;Ljava/util/List;)Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v2

    invoke-virtual {p3, v0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 60
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    const v2, 0x800003

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->leadingInset:I

    invoke-direct {p0, v2, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->railParams(II)Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v2

    invoke-virtual {p3, v0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 61
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    const v2, 0x800005

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->trailingInset:I

    invoke-direct {p0, v2, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->railParams(II)Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v2

    invoke-virtual {p3, v0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 62
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p3

    .line 63
    const v0, 0x7f110200

    invoke-virtual {p1, v0}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v0

    .line 62
    invoke-virtual {p3, v0}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 64
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p3

    const v0, 0x7f1101ff

    invoke-virtual {p1, v0}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object p1

    invoke-virtual {p3, p1}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 65
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p1

    new-instance p3, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$1;

    invoke-direct {p3, p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$1;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;)V

    invoke-virtual {p1, p3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 71
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p1

    new-instance p3, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$2;

    invoke-direct {p3, p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$2;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;)V

    invoke-virtual {p1, p3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 77
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->getViews()Ljava/util/List;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->mount(Ljava/util/List;)V

    .line 78
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 79
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->showIndex(I)V

    .line 80
    return-void

    .line 40
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "chrome factory is missing"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;)I
    .locals 0

    .line 18
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    return p0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;I)V
    .locals 0

    .line 18
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->showIndex(I)V

    return-void
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;Landroid/view/View;)V
    .locals 0

    .line 18
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->onRemoteSuggestionClick(Landroid/view/View;)V

    return-void
.end method

.method private centerParams(Landroid/content/Context;Ljava/util/List;)Landroid/widget/FrameLayout$LayoutParams;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;)",
            "Landroid/widget/FrameLayout$LayoutParams;"
        }
    .end annotation

    .line 205
    nop

    .line 206
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p1

    iget p1, p1, Landroid/util/DisplayMetrics;->density:F

    const/high16 v0, 0x43700000    # 240.0f

    mul-float p1, p1, v0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    .line 205
    const/4 v0, 0x1

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    .line 207
    nop

    .line 208
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    const/4 v0, 0x0

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 209
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    .line 210
    if-eqz v1, :cond_0

    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-le v2, v0, :cond_0

    iget v0, v1, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 211
    :cond_0
    goto :goto_0

    .line 212
    :cond_1
    if-gtz v0, :cond_2

    goto :goto_1

    :cond_2
    move p1, v0

    .line 213
    :goto_1
    new-instance p2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v0, -0x1

    const/16 v1, 0x11

    invoke-direct {p2, p1, v0, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    return-object p2
.end method

.method private mount(Ljava/util/List;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 113
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getContentHost()Landroid/widget/FrameLayout;

    move-result-object v0

    .line 114
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 115
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    .line 116
    instance-of v3, v2, Landroid/view/ViewGroup;

    if-eqz v3, :cond_0

    check-cast v2, Landroid/view/ViewGroup;

    invoke-virtual {v2, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 117
    :cond_0
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    .line 118
    const/4 v3, -0x1

    if-eqz v2, :cond_1

    iget v4, v2, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-lez v4, :cond_1

    .line 119
    iget v4, v2, Landroid/view/ViewGroup$LayoutParams;->width:I

    goto :goto_1

    :cond_1
    const/4 v4, -0x1

    .line 120
    :goto_1
    if-eqz v2, :cond_2

    iget v5, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-lez v5, :cond_2

    .line 121
    iget v3, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    goto :goto_2

    :cond_2
    nop

    .line 122
    :goto_2
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v5, 0x11

    invoke-direct {v2, v4, v3, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 124
    invoke-virtual {v0, v1, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 125
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 129
    new-instance v2, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$3;

    invoke-direct {v2, p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$3;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 134
    goto :goto_0

    .line 135
    :cond_3
    return-void
.end method

.method private onRemoteSuggestionClick(Landroid/view/View;)V
    .locals 2

    .line 138
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->released:Z

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getVisibility()I

    move-result v0

    if-nez v0, :cond_1

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    if-ltz v0, :cond_1

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    .line 139
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    .line 140
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p1, :cond_1

    invoke-virtual {p1}, Landroid/view/View;->isEnabled()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 141
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 142
    :cond_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillFeedbackCompat;->perform(Landroid/view/View;)V

    .line 143
    return-void

    .line 141
    :cond_1
    :goto_0
    return-void
.end method

.method private railParams(II)Landroid/widget/FrameLayout$LayoutParams;
    .locals 3

    .line 218
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->railWidth:I

    const/4 v2, -0x1

    invoke-direct {v0, v1, v2, p1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 220
    const v1, 0x800003

    if-ne p1, v1, :cond_0

    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    goto :goto_0

    .line 221
    :cond_0
    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->rightMargin:I

    .line 222
    :goto_0
    return-object v0
.end method

.method private showIndex(I)V
    .locals 6

    .line 146
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->released:Z

    if-nez v0, :cond_8

    if-ltz p1, :cond_8

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lt p1, v0, :cond_0

    goto/16 :goto_5

    .line 147
    :cond_0
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    .line 148
    new-instance p1, Landroid/graphics/Rect;

    const/4 v0, 0x0

    invoke-direct {p1, v0, v0, v0, v0}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 149
    const/4 v1, 0x0

    :goto_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    const/4 v3, 0x1

    if-ge v1, v2, :cond_5

    .line 150
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 151
    iget v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    if-ne v1, v4, :cond_1

    goto :goto_1

    :cond_1
    const/4 v3, 0x0

    .line 152
    :goto_1
    const/4 v4, 0x0

    invoke-virtual {v2, v4}, Landroid/view/View;->setTranslationX(F)V

    .line 153
    const/4 v4, 0x4

    if-eqz v3, :cond_2

    const/4 v5, 0x0

    goto :goto_2

    :cond_2
    const/4 v5, 0x4

    :goto_2
    invoke-virtual {v2, v5}, Landroid/view/View;->setVisibility(I)V

    .line 154
    invoke-virtual {v2, v3}, Landroid/view/View;->setEnabled(Z)V

    .line 155
    if-eqz v3, :cond_3

    .line 156
    const/4 v4, 0x0

    goto :goto_3

    .line 157
    :cond_3
    nop

    .line 155
    :goto_3
    invoke-virtual {v2, v4}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 158
    if-nez v3, :cond_4

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    invoke-interface {v3, v2, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;->applyClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 149
    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 163
    :cond_5
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    .line 164
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    .line 165
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    if-lez v1, :cond_6

    const/4 v1, 0x1

    goto :goto_4

    :cond_6
    const/4 v1, 0x0

    :goto_4
    invoke-virtual {p1, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->setEnabled(Z)V

    .line 166
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    add-int/2addr v1, v3

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    if-ge v1, v2, :cond_7

    const/4 v0, 0x1

    :cond_7
    invoke-virtual {p1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->setEnabled(Z)V

    .line 167
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout;->post(Ljava/lang/Runnable;)Z

    .line 168
    return-void

    .line 146
    :cond_8
    :goto_5
    return-void
.end method

.method private updateRemoteClip()V
    .locals 7

    .line 171
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getContentHost()Landroid/widget/FrameLayout;

    move-result-object v0

    .line 172
    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->released:Z

    if-nez v1, :cond_4

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_4

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v1}, Landroid/widget/FrameLayout;->getVisibility()I

    move-result v1

    if-nez v1, :cond_4

    .line 173
    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v1

    if-lez v1, :cond_4

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v1

    if-gtz v1, :cond_0

    goto/16 :goto_2

    .line 174
    :cond_0
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v2, v3, :cond_3

    .line 175
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    .line 176
    iget v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->currentIndex:I

    if-eq v2, v4, :cond_1

    .line 177
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    new-instance v5, Landroid/graphics/Rect;

    invoke-direct {v5, v1, v1, v1, v1}, Landroid/graphics/Rect;-><init>(IIII)V

    invoke-interface {v4, v3, v5}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;->applyClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 178
    goto/16 :goto_1

    .line 187
    :cond_1
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->hostRect:Landroid/graphics/Rect;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v5

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v6

    invoke-virtual {v4, v1, v1, v5, v6}, Landroid/graphics/Rect;->set(IIII)V

    .line 188
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->hostRect:Landroid/graphics/Rect;

    invoke-virtual {v4, v5}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 189
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    invoke-virtual {v0, v3, v4}, Landroid/widget/FrameLayout;->offsetRectIntoDescendantCoords(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 190
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v6

    invoke-virtual {v4, v1, v1, v5, v6}, Landroid/graphics/Rect;->intersect(IIII)Z

    move-result v4

    if-nez v4, :cond_2

    .line 191
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    invoke-virtual {v4, v1, v1, v1, v1}, Landroid/graphics/Rect;->set(IIII)V

    .line 193
    :cond_2
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "inline layout index="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " root="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    .line 194
    invoke-virtual {v5}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "x"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v6}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " host="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 195
    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " child="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 196
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " local="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 197
    invoke-virtual {v3}, Landroid/view/View;->getLeft()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ","

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Landroid/view/View;->getTop()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " clip="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    iget v6, v6, Landroid/graphics/Rect;->left:I

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    iget v6, v6, Landroid/graphics/Rect;->top:I

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    iget v6, v6, Landroid/graphics/Rect;->right:I

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->bottom:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 193
    const-string v5, "HeaderPlatformAudit"

    invoke-static {v5, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 200
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    new-instance v5, Landroid/graphics/Rect;

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->childRect:Landroid/graphics/Rect;

    invoke-direct {v5, v6}, Landroid/graphics/Rect;-><init>(Landroid/graphics/Rect;)V

    invoke-interface {v4, v3, v5}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;->applyClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 174
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_0

    .line 202
    :cond_3
    return-void

    .line 173
    :cond_4
    :goto_2
    return-void
.end method


# virtual methods
.method public getView()Landroid/view/View;
    .locals 1

    .line 82
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    return-object v0
.end method

.method public onLayoutChange(Landroid/view/View;IIIIIIII)V
    .locals 0

    .line 107
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->updateRemoteClip()V

    .line 108
    return-void
.end method

.method public release()V
    .locals 5

    .line 86
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->released:Z

    if-eqz v0, :cond_0

    return-void

    .line 87
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->released:Z

    .line 88
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v1, p0}, Landroid/widget/FrameLayout;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 89
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v1, p0}, Landroid/widget/FrameLayout;->removeOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 90
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 91
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    const/4 v4, 0x0

    invoke-interface {v3, v2, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;->applyClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 92
    invoke-virtual {v2, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 93
    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setTranslationX(F)V

    .line 94
    invoke-virtual {v2, v0}, Landroid/view/View;->setEnabled(Z)V

    .line 95
    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 96
    goto :goto_0

    .line 97
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->candidateSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->clear()V

    .line 98
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->previousSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->clear()V

    .line 99
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->nextSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->clear()V

    .line 100
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->views:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 101
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->root:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->removeAllViews()V

    .line 102
    return-void
.end method

.method public run()V
    .locals 0

    .line 110
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->updateRemoteClip()V

    return-void
.end method
