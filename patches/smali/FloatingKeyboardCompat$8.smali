.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;
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

    .line 1380
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$view:Landroid/view/View;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$decor:Landroid/view/View;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$area:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 6

    .line 1383
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1902(Ljava/lang/Runnable;)Ljava/lang/Runnable;

    .line 1384
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2000()Z

    move-result v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$view:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_1

    .line 1385
    :cond_0
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2002(Z)Z

    .line 1386
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2100()F

    move-result v1

    const/4 v2, 0x0

    cmpl-float v1, v1, v2

    if-lez v1, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2100()F

    move-result v1

    goto :goto_0

    :cond_1
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$view:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v1

    .line 1387
    :goto_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$decor:Landroid/view/View;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$area:Landroid/view/View;

    invoke-static {v2, v3, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2200(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1388
    if-nez v2, :cond_2

    return-void

    .line 1389
    :cond_2
    const/4 v3, 0x1

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$402(Z)Z

    .line 1392
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2400()F

    move-result v4

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2302(F)F

    .line 1393
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2600()F

    move-result v4

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2502(F)F

    .line 1394
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$area:Landroid/view/View;

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$decor:Landroid/view/View;

    invoke-static {v4, v5, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2800(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2702(F)F

    .line 1395
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$area:Landroid/view/View;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$decor:Landroid/view/View;

    invoke-static {v3, v4, v1, v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2800(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2902(F)F

    .line 1396
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;->val$view:Landroid/view/View;

    invoke-virtual {v1, v0}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 1397
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1100()V

    .line 1398
    return-void

    .line 1384
    :cond_3
    :goto_1
    return-void
.end method
