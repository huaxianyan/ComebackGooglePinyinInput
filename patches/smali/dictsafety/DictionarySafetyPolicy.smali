.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;
.super Ljava/lang/Object;
.source "DictionarySafetyPolicy.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static acceptsSnapshot(II)Z
    .locals 1

    .line 31
    if-gtz p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 32
    :cond_0
    const/4 v0, 0x1

    if-gtz p1, :cond_1

    return v0

    .line 33
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result p0

    xor-int/2addr p0, v0

    return p0
.end method

.method public static canRepairWith(II)Z
    .locals 0

    .line 38
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->acceptsSnapshot(II)Z

    move-result p0

    return p0
.end method

.method public static isCollapsed(II)Z
    .locals 5

    .line 19
    const/4 v0, 0x0

    if-gez p0, :cond_0

    return v0

    .line 20
    :cond_0
    if-gtz p1, :cond_1

    return v0

    .line 21
    :cond_1
    int-to-long v1, p0

    const-wide/16 v3, 0x2

    mul-long v1, v1, v3

    int-to-long p0, p1

    cmp-long v3, v1, p0

    if-gez v3, :cond_2

    const/4 v0, 0x1

    :cond_2
    return v0
.end method

.method public static nextKnownCount(II)I
    .locals 1

    .line 26
    const/4 v0, 0x0

    invoke-static {p1, v0}, Ljava/lang/Math;->max(II)I

    move-result p1

    invoke-static {p0, p1}, Ljava/lang/Math;->max(II)I

    move-result p0

    return p0
.end method
