.class public final Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;
.super Ljava/lang/Object;
.source "InlineAutofillCompat.java"


# static fields
.field private static final API_R:I = 0x1e

.field private static final HEADER_HEIGHT_RES_ID:I = 0x7f0d00a9

.field private static final MAX_CHIP_WIDTH_DP:F = 240.0f

.field private static final MIN_CHIP_WIDTH_DP:F = 48.0f

.field private static final PRESENTATION_COUNT:I = 0x3

.field private static generation:I


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized clear()V
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 70
    :try_start_0
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 71
    monitor-exit v0

    return-void

    .line 69
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method public static declared-synchronized createRequest(Landroid/content/Context;Landroid/os/Bundle;)Landroid/view/inputmethod/InlineSuggestionsRequest;
    .locals 4

    const-class p1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter p1

    .line 35
    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :cond_3

    if-nez p0, :cond_0

    goto :goto_2

    .line 38
    :cond_0
    sget v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    sput v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 40
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    .line 41
    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 42
    const v2, 0x7f0d00a9

    invoke-virtual {p0, v2}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0

    .line 43
    iget v2, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v3, 0x42400000    # 48.0f

    mul-float v2, v2, v3

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 44
    iget v2, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v3, 0x43700000    # 240.0f

    mul-float v2, v2, v3

    .line 45
    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 44
    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 46
    iget v3, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    if-lez v3, :cond_1

    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    goto :goto_0

    :cond_1
    move v0, v2

    .line 47
    :goto_0
    invoke-static {v2, v0}, Ljava/lang/Math;->min(II)I

    move-result v0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 49
    new-instance v2, Landroid/util/Size;

    invoke-direct {v2, v1, p0}, Landroid/util/Size;-><init>(II)V

    .line 50
    new-instance v1, Landroid/util/Size;

    invoke-direct {v1, v0, p0}, Landroid/util/Size;-><init>(II)V

    .line 51
    new-instance p0, Landroid/widget/inline/InlinePresentationSpec$Builder;

    invoke-direct {p0, v2, v1}, Landroid/widget/inline/InlinePresentationSpec$Builder;-><init>(Landroid/util/Size;Landroid/util/Size;)V

    .line 52
    invoke-virtual {p0}, Landroid/widget/inline/InlinePresentationSpec$Builder;->build()Landroid/widget/inline/InlinePresentationSpec;

    move-result-object p0

    .line 53
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x3

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 55
    const/4 v2, 0x0

    :goto_1
    if-ge v2, v1, :cond_2

    .line 56
    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 55
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 58
    :cond_2
    new-instance p0, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;

    invoke-direct {p0, v0}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;-><init>(Ljava/util/List;)V

    .line 59
    invoke-virtual {p0, v1}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;->setMaxSuggestionCount(I)Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;

    move-result-object p0

    .line 60
    invoke-virtual {p0}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;->build()Landroid/view/inputmethod/InlineSuggestionsRequest;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 58
    monitor-exit p1

    return-object p0

    .line 36
    :cond_3
    :goto_2
    monitor-exit p1

    const/4 p0, 0x0

    return-object p0

    .line 34
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_4

    :goto_3
    throw p0

    :goto_4
    goto :goto_3
.end method

.method public static declared-synchronized handleResponse(Landroid/view/inputmethod/InlineSuggestionsResponse;)Z
    .locals 1

    const-class p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter p0

    .line 64
    :try_start_0
    sget v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 66
    monitor-exit p0

    const/4 p0, 0x0

    return p0

    .line 63
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method
