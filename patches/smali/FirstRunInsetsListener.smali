.class public final Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;
.super Ljava/lang/Object;
.source "FirstRunInsetsListener.java"

# interfaces
.implements Landroid/view/View$OnApplyWindowInsetsListener;

# instance fields
.field private final view:Landroid/view/View;
.field private final baseLeft:I
.field private final baseTop:I
.field private final baseRight:I
.field private final baseBottom:I

# direct methods
.method public constructor <init>(Landroid/view/View;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->view:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseLeft:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingTop()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseTop:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseRight:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseBottom:I

    return-void
.end method

# virtual methods
.method public onApplyWindowInsets(Landroid/view/View;Landroid/view/WindowInsets;)Landroid/view/WindowInsets;
    .locals 7

    invoke-static {}, Landroid/view/WindowInsets$Type;->systemBars()I

    move-result v0

    invoke-static {}, Landroid/view/WindowInsets$Type;->displayCutout()I

    move-result v1

    or-int/2addr v0, v1

    invoke-virtual {p2, v0}, Landroid/view/WindowInsets;->getInsetsIgnoringVisibility(I)Landroid/graphics/Insets;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->view:Landroid/view/View;

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseLeft:I

    iget v3, v0, Landroid/graphics/Insets;->left:I

    add-int/2addr v2, v3

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseTop:I

    iget v4, v0, Landroid/graphics/Insets;->top:I

    add-int/2addr v3, v4

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseRight:I

    iget v5, v0, Landroid/graphics/Insets;->right:I

    add-int/2addr v4, v5

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunInsetsListener;->baseBottom:I

    iget v6, v0, Landroid/graphics/Insets;->bottom:I

    add-int/2addr v5, v6

    invoke-virtual {v1, v2, v3, v4, v5}, Landroid/view/View;->setPadding(IIII)V

    return-object p2
.end method
