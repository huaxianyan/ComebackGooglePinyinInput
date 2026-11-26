.class Lcom/google/android/inputmethod/pinyin/FloatingCardShadow$1;
.super Landroid/view/ViewOutlineProvider;
.source "FloatingCardShadow.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;)V
    .locals 0

    .line 22
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow$1;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-direct {p0}, Landroid/view/ViewOutlineProvider;-><init>()V

    return-void
.end method


# virtual methods
.method public getOutline(Landroid/view/View;Landroid/graphics/Outline;)V
    .locals 2

    .line 25
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 26
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 27
    if-lez v0, :cond_1

    if-gtz p1, :cond_0

    goto :goto_0

    .line 31
    :cond_0
    const/4 v1, 0x0

    invoke-virtual {p2, v1, v1, v0, p1}, Landroid/graphics/Outline;->setRect(IIII)V

    .line 32
    return-void

    .line 28
    :cond_1
    :goto_0
    invoke-virtual {p2}, Landroid/graphics/Outline;->setEmpty()V

    .line 29
    return-void
.end method
