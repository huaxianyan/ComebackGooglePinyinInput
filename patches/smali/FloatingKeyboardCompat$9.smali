.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditMode(Landroid/view/View;Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 822
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onEditDone()V
    .locals 2

    .line 840
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$700()Landroid/view/View;

    move-result-object v0

    .line 841
    if-nez v0, :cond_0

    return-void

    .line 842
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1900(Landroid/view/View;Landroid/view/View;)V

    .line 843
    return-void
.end method

.method public onEditDrag(FFZ)V
    .locals 0

    .line 825
    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1600(FFZ)V

    .line 826
    return-void
.end method

.method public onEditReset()V
    .locals 0

    .line 835
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1800()V

    .line 836
    return-void
.end method

.method public onEditScale(IFFZ)V
    .locals 0

    .line 830
    invoke-static {p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1700(IFFZ)V

    .line 831
    return-void
.end method
