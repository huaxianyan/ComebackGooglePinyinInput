.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;
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

    .line 159
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 162
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$302(Z)Z

    .line 163
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$400()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$500()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$600()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$700()Landroid/view/View;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 164
    :cond_0
    const/high16 v0, 0x3f000000    # 0.5f

    const-wide/16 v1, 0x140

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$800(FJ)V

    .line 165
    return-void

    .line 163
    :cond_1
    :goto_0
    return-void
.end method
