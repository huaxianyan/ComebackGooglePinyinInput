.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;
.super Ljava/lang/Object;
.source "HeaderPlatformOwners.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;
    .locals 2

    .line 11
    nop

    .line 12
    :goto_0
    const/4 v0, 0x0

    if-eqz p0, :cond_3

    .line 13
    instance-of v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    if-eqz v1, :cond_0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    return-object p0

    .line 14
    :cond_0
    instance-of v1, p0, Landroid/content/ContextWrapper;

    if-nez v1, :cond_1

    return-object v0

    .line 15
    :cond_1
    move-object v1, p0

    check-cast v1, Landroid/content/ContextWrapper;

    invoke-virtual {v1}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;

    move-result-object v1

    .line 16
    if-ne v1, p0, :cond_2

    return-object v0

    .line 17
    :cond_2
    nop

    .line 18
    move-object p0, v1

    goto :goto_0

    .line 19
    :cond_3
    return-object v0
.end method
