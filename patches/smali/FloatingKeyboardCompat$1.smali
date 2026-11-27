.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;
.super Landroid/view/ViewOutlineProvider;
.source "FloatingKeyboardCompat.java"


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

    .line 98
    invoke-direct {p0}, Landroid/view/ViewOutlineProvider;-><init>()V

    return-void
.end method


# virtual methods
.method public getOutline(Landroid/view/View;Landroid/graphics/Outline;)V
    .locals 6

    .line 101
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v3

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v4

    .line 102
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$000(Landroid/view/View;)F

    move-result p1

    const/high16 v0, 0x41400000    # 12.0f

    mul-float v5, p1, v0

    .line 101
    const/4 v1, 0x0

    const/4 v2, 0x0

    move-object v0, p2

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Outline;->setRoundRect(IIIIF)V

    .line 103
    return-void
.end method
