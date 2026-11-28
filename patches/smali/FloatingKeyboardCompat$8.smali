.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;


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

    .line 1018
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDone()V
    .locals 2

    .line 1036
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$700()Landroid/view/View;

    move-result-object v0

    .line 1037
    if-nez v0, :cond_0

    return-void

    .line 1038
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2200(Landroid/view/View;Landroid/view/View;)V

    .line 1039
    return-void
.end method

.method public onDrag(FFZ)V
    .locals 0

    .line 1021
    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1900(FFZ)V

    .line 1022
    return-void
.end method

.method public onReset()V
    .locals 0

    .line 1031
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2100()V

    .line 1032
    return-void
.end method

.method public onScale(IFFZ)V
    .locals 0

    .line 1026
    invoke-static {p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$2000(IFFZ)V

    .line 1027
    return-void
.end method
