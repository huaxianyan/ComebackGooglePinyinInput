.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->syncFloatingToolbar(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$bar:Landroid/view/View;

.field final synthetic val$hide:Z


# direct methods
.method constructor <init>(Landroid/view/View;Z)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 417
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;->val$bar:Landroid/view/View;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;->val$hide:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 7

    .line 420
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;->val$bar:Landroid/view/View;

    check-cast v0, Landroid/view/ViewGroup;

    .line 421
    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;->val$hide:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    const/16 v1, 0x8

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    .line 422
    :goto_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1100()[I

    move-result-object v3

    array-length v4, v3

    :goto_1
    if-ge v2, v4, :cond_3

    aget v5, v3, v2

    .line 423
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v6

    if-gt v6, v5, :cond_1

    goto :goto_2

    .line 424
    :cond_1
    invoke-virtual {v0, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    .line 425
    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I

    move-result v6

    if-eq v6, v1, :cond_2

    invoke-virtual {v5, v1}, Landroid/view/View;->setVisibility(I)V

    .line 422
    :cond_2
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 427
    :cond_3
    return-void
.end method
