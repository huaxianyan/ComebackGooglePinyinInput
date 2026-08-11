.class public final Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;
.super Ljava/lang/Object;
.source "InlineAutofillCompat.java"


# static fields
.field private static final API_R:I = 0x1e

.field private static final HEADER_HEIGHT_RES_ID:I = 0x7f0d00a9

.field private static final INFLATION_TIMEOUT_MS:J = 0x4b0L

.field private static final MAIN_HANDLER:Landroid/os/Handler;

.field private static final MAX_CHIP_WIDTH_DP:F = 240.0f

.field private static final MIN_CHIP_WIDTH_DP:F = 48.0f

.field private static final PRESENTATION_COUNT:I = 0x3

.field private static activeInputSession:Z

.field private static completedInflations:[Z

.field private static generation:I

.field private static pendingCount:I

.field private static pendingHost:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;",
            ">;"
        }
    .end annotation
.end field

.field private static pendingViews:[Landroid/view/View;

.field private static published:Z

.field private static timeout:Ljava/lang/Runnable;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 34
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static declared-synchronized acceptInflated(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;ILandroid/view/View;)V
    .locals 3

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 148
    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->isCurrentLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)Z

    move-result v1

    if-eqz v1, :cond_2

    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-nez v1, :cond_2

    if-ltz p2, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    array-length v1, v1

    if-ge p2, v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    aget-boolean v1, v1, p2

    if-eqz v1, :cond_0

    goto :goto_0

    .line 152
    :cond_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    const/4 v2, 0x1

    aput-boolean v2, v1, p2

    .line 153
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    aput-object p3, v1, p2

    .line 154
    sget p2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    sub-int/2addr p2, v2

    sput p2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 155
    sget p2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    if-nez p2, :cond_1

    .line 156
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->publishLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 158
    :cond_1
    monitor-exit v0

    return-void

    .line 150
    :cond_2
    :goto_0
    monitor-exit v0

    return-void

    .line 147
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method static synthetic access$000(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;ILandroid/view/View;)V
    .locals 0

    .line 26
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->acceptInflated(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;ILandroid/view/View;)V

    return-void
.end method

.method static synthetic access$100(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    .locals 0

    .line 26
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->publishPartial(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V

    return-void
.end method

.method public static applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 2

    .line 216
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :cond_0

    if-eqz p0, :cond_0

    .line 217
    invoke-virtual {p0, p1}, Landroid/view/View;->setClipBounds(Landroid/graphics/Rect;)V

    .line 219
    :cond_0
    return-void
.end method

.method private static cancelPendingLocked()V
    .locals 3

    .line 204
    sget-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 205
    sget-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 206
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    .line 208
    :cond_0
    const/4 v0, 0x0

    sput v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 209
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    .line 210
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    .line 211
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHost:Ljava/lang/ref/WeakReference;

    .line 212
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    .line 213
    return-void
.end method

.method public static declared-synchronized clear()V
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 222
    :try_start_0
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 223
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    .line 224
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 225
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearAllHosts()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 226
    monitor-exit v0

    return-void

    .line 221
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

    .line 55
    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :cond_3

    if-nez p0, :cond_0

    goto/16 :goto_2

    .line 58
    :cond_0
    sget v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    sput v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 59
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    .line 60
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 61
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearAllHosts()V

    .line 63
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    .line 64
    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 65
    const v2, 0x7f0d00a9

    invoke-virtual {p0, v2}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0

    .line 66
    iget v2, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v3, 0x42400000    # 48.0f

    mul-float v2, v2, v3

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 67
    iget v2, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v3, 0x43700000    # 240.0f

    mul-float v2, v2, v3

    .line 68
    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 67
    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 69
    iget v3, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    if-lez v3, :cond_1

    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    goto :goto_0

    :cond_1
    move v0, v2

    .line 70
    :goto_0
    invoke-static {v2, v0}, Ljava/lang/Math;->min(II)I

    move-result v0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 72
    new-instance v2, Landroid/util/Size;

    invoke-direct {v2, v1, p0}, Landroid/util/Size;-><init>(II)V

    .line 73
    new-instance v1, Landroid/util/Size;

    invoke-direct {v1, v0, p0}, Landroid/util/Size;-><init>(II)V

    .line 74
    new-instance p0, Landroid/widget/inline/InlinePresentationSpec$Builder;

    invoke-direct {p0, v2, v1}, Landroid/widget/inline/InlinePresentationSpec$Builder;-><init>(Landroid/util/Size;Landroid/util/Size;)V

    .line 75
    invoke-virtual {p0}, Landroid/widget/inline/InlinePresentationSpec$Builder;->build()Landroid/widget/inline/InlinePresentationSpec;

    move-result-object p0

    .line 76
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x3

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 78
    const/4 v2, 0x0

    :goto_1
    if-ge v2, v1, :cond_2

    .line 79
    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 78
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 81
    :cond_2
    new-instance p0, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;

    invoke-direct {p0, v0}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;-><init>(Ljava/util/List;)V

    .line 82
    invoke-virtual {p0, v1}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;->setMaxSuggestionCount(I)Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;

    move-result-object p0

    .line 83
    invoke-virtual {p0}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;->build()Landroid/view/inputmethod/InlineSuggestionsRequest;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 81
    monitor-exit p1

    return-object p0

    .line 56
    :cond_3
    :goto_2
    monitor-exit p1

    const/4 p0, 0x0

    return-object p0

    .line 54
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
    .locals 12

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 87
    :try_start_0
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 88
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 89
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearAllHosts()V

    .line 90
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    const/4 v3, 0x0

    if-eqz v1, :cond_6

    if-nez p0, :cond_0

    goto/16 :goto_3

    .line 94
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->findCurrentHost()Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 95
    if-nez v1, :cond_1

    .line 96
    monitor-exit v0

    return v3

    .line 98
    :cond_1
    :try_start_1
    invoke-virtual {p0}, Landroid/view/inputmethod/InlineSuggestionsResponse;->getInlineSuggestions()Ljava/util/List;

    move-result-object p0

    .line 99
    if-nez p0, :cond_2

    const/4 v4, 0x0

    goto :goto_0

    :cond_2
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v4

    const/4 v5, 0x3

    invoke-static {v5, v4}, Ljava/lang/Math;->min(II)I

    move-result v4
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 100
    :goto_0
    if-nez v4, :cond_3

    .line 101
    monitor-exit v0

    return v2

    .line 104
    :cond_3
    :try_start_2
    sget v5, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 105
    new-instance v6, Ljava/lang/ref/WeakReference;

    invoke-direct {v6, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    .line 107
    sput v4, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 108
    new-array v7, v4, [Landroid/view/View;

    sput-object v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    .line 109
    new-array v7, v4, [Z

    sput-object v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    .line 110
    sput-object v6, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHost:Ljava/lang/ref/WeakReference;

    .line 111
    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    .line 112
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getContext()Landroid/content/Context;

    move-result-object v7

    invoke-virtual {v7}, Landroid/content/Context;->getMainExecutor()Ljava/util/concurrent/Executor;

    move-result-object v7

    .line 113
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getResources()Landroid/content/res/Resources;

    move-result-object v8

    const v9, 0x7f0d00a9

    invoke-virtual {v8, v9}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v8

    .line 114
    new-instance v9, Landroid/util/Size;

    const/4 v10, -0x2

    invoke-direct {v9, v10, v8}, Landroid/util/Size;-><init>(II)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 116
    nop

    :goto_1
    if-ge v3, v4, :cond_4

    .line 117
    nop

    .line 119
    :try_start_3
    invoke-interface {p0, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/view/inputmethod/InlineSuggestion;

    .line 120
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getContext()Landroid/content/Context;

    move-result-object v10

    new-instance v11, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$1;

    invoke-direct {v11, v5, v6, v3}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$1;-><init>(ILjava/lang/ref/WeakReference;I)V

    .line 119
    invoke-virtual {v8, v10, v9, v7, v11}, Landroid/view/inputmethod/InlineSuggestion;->inflate(Landroid/content/Context;Landroid/util/Size;Ljava/util/concurrent/Executor;Ljava/util/function/Consumer;)V
    :try_end_3
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 131
    goto :goto_2

    .line 129
    :catch_0
    move-exception v8

    .line 130
    :try_start_4
    invoke-virtual {v6}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    const/4 v10, 0x0

    invoke-static {v5, v8, v3, v10}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->acceptInflated(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;ILandroid/view/View;)V

    .line 116
    :goto_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 134
    :cond_4
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-nez p0, :cond_5

    .line 135
    new-instance p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;

    invoke-direct {p0, v5, v6}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;-><init>(ILjava/lang/ref/WeakReference;)V

    sput-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    .line 141
    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    const-wide/16 v3, 0x4b0

    invoke-virtual {p0, v1, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 143
    :cond_5
    monitor-exit v0

    return v2

    .line 91
    :cond_6
    :goto_3
    monitor-exit v0

    return v3

    .line 86
    :catchall_0
    move-exception p0

    :try_start_5
    monitor-exit v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    goto :goto_5

    :goto_4
    throw p0

    :goto_5
    goto :goto_4
.end method

.method private static isCurrentLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)Z
    .locals 1

    .line 168
    sget v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    if-ne p0, v0, :cond_0

    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    if-eqz p0, :cond_0

    if-eqz p1, :cond_0

    .line 171
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->isAvailable()Z

    move-result p0

    if-eqz p0, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHost:Ljava/lang/ref/WeakReference;

    if-eqz p0, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHost:Ljava/lang/ref/WeakReference;

    .line 173
    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    if-ne p0, p1, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 168
    :goto_0
    return p0
.end method

.method private static publishLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    .locals 6

    .line 178
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->isCurrentLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)Z

    move-result p0

    if-eqz p0, :cond_5

    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-eqz p0, :cond_0

    goto :goto_2

    .line 181
    :cond_0
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    .line 182
    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    const/4 v0, 0x0

    if-eqz p0, :cond_1

    .line 183
    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    invoke-virtual {p0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 184
    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    .line 186
    :cond_1
    new-instance p0, Ljava/util/ArrayList;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    array-length v1, v1

    invoke-direct {p0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 187
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    array-length v2, v1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, v1, v4

    .line 188
    if-eqz v5, :cond_2

    .line 189
    invoke-virtual {p0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 187
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 192
    :cond_3
    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    .line 193
    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    .line 194
    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHost:Ljava/lang/ref/WeakReference;

    .line 195
    sput v3, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 196
    invoke-virtual {p0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 197
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearInlineViews()V

    goto :goto_1

    .line 199
    :cond_4
    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setInlineViews(Ljava/util/List;)V

    .line 201
    :goto_1
    return-void

    .line 179
    :cond_5
    :goto_2
    return-void
.end method

.method private static declared-synchronized publishPartial(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 162
    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->isCurrentLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)Z

    move-result v1

    if-eqz v1, :cond_0

    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-nez v1, :cond_0

    .line 163
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->publishLocked(ILcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 165
    :cond_0
    monitor-exit v0

    return-void

    .line 161
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static declared-synchronized startInputSession()V
    .locals 3

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 47
    :try_start_0
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 48
    sput-boolean v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    .line 49
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 50
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearAllHosts()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 51
    monitor-exit v0

    return-void

    .line 46
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method
