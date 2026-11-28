.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$area:Landroid/view/View;

.field final synthetic val$decor:Landroid/view/View;

.field final synthetic val$view:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1425
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$view:Landroid/view/View;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$decor:Landroid/view/View;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$area:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 1428
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2302(Ljava/lang/Runnable;)Ljava/lang/Runnable;

    .line 1429
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2400()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$view:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 1430
    :cond_0
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2402(Z)Z

    .line 1431
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$view:Landroid/view/View;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$decor:Landroid/view/View;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$area:Landroid/view/View;

    invoke-static {v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2500(Landroid/view/View;Landroid/view/View;Landroid/view/View;)Z

    move-result v1

    if-nez v1, :cond_1

    return-void

    .line 1432
    :cond_1
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;->val$view:Landroid/view/View;

    invoke-virtual {v1, v0}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 1433
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1300()V

    .line 1434
    return-void

    .line 1429
    :cond_2
    :goto_0
    return-void
.end method
