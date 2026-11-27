.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;
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

    .line 850
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onEditDone()V
    .locals 2

    .line 868
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$700()Landroid/view/View;

    move-result-object v0

    .line 869
    if-nez v0, :cond_0

    return-void

    .line 870
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1800(Landroid/view/View;Landroid/view/View;)V

    .line 871
    return-void
.end method

.method public onEditDrag(FFZ)V
    .locals 0

    .line 853
    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1500(FFZ)V

    .line 854
    return-void
.end method

.method public onEditReset()V
    .locals 0

    .line 863
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1700()V

    .line 864
    return-void
.end method

.method public onEditScale(IFFZ)V
    .locals 0

    .line 858
    invoke-static {p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1600(IFFZ)V

    .line 859
    return-void
.end method
