.class Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$1;
.super Ljava/lang/Object;
.source "InlineAutofillCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 58
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public applyClip(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 0

    .line 61
    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 62
    return-void
.end method
