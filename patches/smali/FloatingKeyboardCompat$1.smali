.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 125
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 128
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$002(Z)Z

    .line 129
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$100()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$200()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$300()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$400()Landroid/view/View;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 130
    :cond_0
    const/high16 v0, 0x3f000000    # 0.5f

    const-wide/16 v1, 0x140

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$500(FJ)V

    .line 131
    return-void

    .line 129
    :cond_1
    :goto_0
    return-void
.end method
