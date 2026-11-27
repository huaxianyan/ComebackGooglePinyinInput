.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;
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

    .line 660
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 663
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1302(Z)Z

    .line 664
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$700()Landroid/view/View;

    move-result-object v0

    .line 665
    if-nez v0, :cond_0

    return-void

    .line 666
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1400(Landroid/view/View;Landroid/view/View;)V

    .line 667
    return-void
.end method
