.class final Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;
.super Ljava/lang/Object;
.source "EdgeToEdgeCompat.java"

# interfaces
.implements Landroid/view/View$OnApplyWindowInsetsListener;

# instance fields
.field private bottomFrame:Landroid/view/View;
.field private final root:Landroid/view/View;

# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;->root:Landroid/view/View;
    return-void
.end method

# virtual methods
.method public onApplyWindowInsets(Landroid/view/View;Landroid/view/WindowInsets;)Landroid/view/WindowInsets;
    .locals 7

    # Public navigationBars is a cold-start fallback. The framework's stable
    # bottom IME surface can be taller in gesture mode, so use its measured
    # public View geometry when it is a bottom-aligned, full-width, non-root
    # candidate. Never accept a full-root transition container.
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->getNavigationBarBottomInset(Landroid/view/View;)I
    move-result v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;->root:Landroid/view/View;
    invoke-virtual {v1}, Landroid/view/View;->getRootView()Landroid/view/View;
    move-result-object v3

    instance-of v2, v3, Landroid/view/ViewGroup;
    if-eqz v2, :use_remembered_height

    move-object v4, v3
    check-cast v4, Landroid/view/ViewGroup;
    invoke-virtual {v4}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    if-lez v2, :use_remembered_height

    add-int/lit8 v2, v2, -0x1
    invoke-virtual {v4, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v4

    invoke-virtual {v4}, Landroid/view/View;->isLaidOut()Z
    move-result v2
    if-eqz v2, :use_remembered_height

    invoke-virtual {v4}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :use_remembered_height

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I
    move-result v6
    if-ge v2, v6, :use_remembered_height

    invoke-virtual {v4}, Landroid/view/View;->getBottom()I
    move-result v5
    if-ne v5, v6, :use_remembered_height

    invoke-virtual {v4}, Landroid/view/View;->getWidth()I
    move-result v5
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I
    move-result v6
    if-ne v5, v6, :use_remembered_height

    move v0, v2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->rememberStableNavigationHeight(I)V
    goto :resolved_height

    :use_remembered_height
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->stableNavigationHeightOr(I)I
    move-result v0

    :resolved_height
    if-lez v0, :done

    # Keep all owned geometry inside InputView. The native keyboard area keeps
    # its own measured height and is shifted above a dedicated, non-interactive
    # bottom sibling. No DecorView child is added, removed or reparented.
    const v2, 0x7f0f0153
    invoke-virtual {v1, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v2
    if-eqz v2, :done

    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v3
    instance-of v4, v3, Landroid/view/ViewGroup$MarginLayoutParams;
    if-eqz v4, :input_parent

    check-cast v3, Landroid/view/ViewGroup$MarginLayoutParams;
    iget v4, v3, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I
    if-eq v4, v0, :input_parent
    iput v0, v3, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I
    invoke-virtual {v2, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :input_parent
    instance-of v3, v1, Landroid/view/ViewGroup;
    if-eqz v3, :done
    move-object v3, v1
    check-cast v3, Landroid/view/ViewGroup;

    const-string v5, "ime-navigation-frame"
    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v4
    if-nez v4, :reuse_frame

    invoke-virtual {v1}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v6
    new-instance v4, Landroid/view/View;
    invoke-direct {v4, v6}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const/4 v5, 0x2
    invoke-virtual {v4, v5}, Landroid/view/View;->setImportantForAccessibility(I)V
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/view/View;->setClickable(Z)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setFocusable(Z)V

    new-instance v6, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v5, -0x1
    const/16 v3, 0x50
    invoke-direct {v6, v5, v0, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V
    move-object v3, v1
    check-cast v3, Landroid/view/ViewGroup;
    const/4 v5, 0x0
    invoke-virtual {v3, v4, v5, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    :reuse_frame
    iput-object v4, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;->bottomFrame:Landroid/view/View;
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v3
    if-eqz v3, :background
    iget v5, v3, Landroid/view/ViewGroup$LayoutParams;->height:I
    if-eq v5, v0, :background
    iput v0, v3, Landroid/view/ViewGroup$LayoutParams;->height:I
    invoke-virtual {v4, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :background
    # Resolve normal, expanded-candidate and image surfaces only after both
    # keyboard-area and owned bottom-frame geometry are stable.
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->syncNow(Landroid/view/View;)V

    :done
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->refreshNavigationBarTheme()V

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->suppressNavigationBarContrast(Landroid/view/View;)V

    return-object p2
.end method
