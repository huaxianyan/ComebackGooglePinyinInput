.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleHandle(Landroid/view/View;Landroid/view/View;F)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$area:Landroid/view/View;

.field final synthetic val$decor:Landroid/view/View;

.field final synthetic val$factor:F


# direct methods
.method constructor <init>(Landroid/view/View;Landroid/view/View;F)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 311
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$decor:Landroid/view/View;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$area:Landroid/view/View;

    iput p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$factor:F

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 314
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$decor:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 315
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$900()V

    .line 316
    return-void

    .line 320
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$area:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->isAttachedToWindow()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$decor:Landroid/view/View;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1000(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$area:Landroid/view/View;

    if-eq v0, v1, :cond_1

    goto :goto_0

    .line 321
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$decor:Landroid/view/View;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$area:Landroid/view/View;

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$factor:F

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1100(Landroid/view/View;Landroid/view/View;F)V

    .line 322
    return-void

    .line 320
    :cond_2
    :goto_0
    return-void
.end method
