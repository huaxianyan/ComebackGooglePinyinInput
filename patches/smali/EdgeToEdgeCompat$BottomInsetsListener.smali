.class final Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;
.super Ljava/lang/Object;
.source "EdgeToEdgeCompat.java"

# interfaces
.implements Landroid/view/View$OnApplyWindowInsetsListener;


# instance fields
.field private final baseBottom:I

.field private final baseHeight:I

.field private final baseLeft:I

.field private final baseRight:I

.field private final baseTop:I

.field private final expandHeight:Z

.field private final view:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;Z)V
    .locals 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->view:Landroid/view/View;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->expandHeight:Z

    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseLeft:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingTop()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseTop:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseRight:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseBottom:I

    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    if-eqz v0, :cond_0

    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    goto :goto_0

    :cond_0
    const/4 v1, -0x1

    :goto_0
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseHeight:I

    return-void
.end method


# virtual methods
.method public onApplyWindowInsets(Landroid/view/View;Landroid/view/WindowInsets;)Landroid/view/WindowInsets;
    .locals 6

    invoke-virtual {p2}, Landroid/view/WindowInsets;->getSystemWindowInsetBottom()I

    move-result v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->view:Landroid/view/View;

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseLeft:I

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseTop:I

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseRight:I

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseBottom:I

    add-int/2addr v5, v0

    invoke-virtual {v1, v2, v3, v4, v5}, Landroid/view/View;->setPadding(IIII)V

    iget-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->expandHeight:Z

    if-eqz v2, :cond_1

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;->baseHeight:I

    if-gez v2, :cond_0

    goto :cond_1

    :cond_0
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    if-eqz v3, :cond_1

    add-int/2addr v2, v0

    iput v2, v3, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {v1, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_1
    return-object p2
.end method
