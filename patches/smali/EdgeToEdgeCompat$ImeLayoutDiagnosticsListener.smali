.class final Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeLayoutDiagnosticsListener;
.super Ljava/lang/Object;
.source "EdgeToEdgeCompat.java"

# interfaces
.implements Landroid/view/View$OnLayoutChangeListener;


# direct methods
.method constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLayoutChange(Landroid/view/View;IIIIIIII)V
    .locals 3

    const-string v0, "layoutTop"

    invoke-static {v0, p3}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->logImeGeometry(Ljava/lang/String;I)V

    const-string v0, "layoutBottom"

    invoke-static {v0, p5}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->logImeGeometry(Ljava/lang/String;I)V

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p2

    const-string p3, "layoutHeight"

    invoke-static {p3, p2}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->logImeGeometry(Ljava/lang/String;I)V

    const/4 p2, 0x2

    new-array p2, p2, [I

    invoke-virtual {p1, p2}, Landroid/view/View;->getLocationInWindow([I)V

    const/4 p3, 0x1

    aget p2, p2, p3

    const-string p3, "locationInWindowY"

    invoke-static {p3, p2}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->logImeGeometry(Ljava/lang/String;I)V

    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    instance-of p2, p1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz p2, :done

    check-cast p1, Landroid/view/ViewGroup$MarginLayoutParams;

    iget p1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    const-string p2, "layoutBottomMargin"

    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->logImeGeometry(Ljava/lang/String;I)V

    :done
    return-void
.end method
