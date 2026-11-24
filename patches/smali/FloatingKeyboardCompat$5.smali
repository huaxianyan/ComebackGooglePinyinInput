.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;
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

    .line 615
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onEditDone()V
    .locals 2

    .line 633
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$400()Landroid/view/View;

    move-result-object v0

    .line 634
    if-nez v0, :cond_0

    return-void

    .line 635
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1400(Landroid/view/View;Landroid/view/View;)V

    .line 636
    return-void
.end method

.method public onEditDrag(FFZ)V
    .locals 0

    .line 618
    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1100(FFZ)V

    .line 619
    return-void
.end method

.method public onEditReset()V
    .locals 0

    .line 628
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1300()V

    .line 629
    return-void
.end method

.method public onEditScale(IFFZ)V
    .locals 0

    .line 623
    invoke-static {p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1200(IFFZ)V

    .line 624
    return-void
.end method
