.class public final Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;
.super Ljava/lang/Object;
.source "InlineAutofillCompat.java"


# static fields
.field private static final API_R:I = 0x1e

.field private static final ATTR_COLOR_LABEL_CANDIDATE:I = 0x7f010066

.field private static final DIAGNOSTIC_TAG:Ljava/lang/String; = "HeaderPlatformAudit"

.field private static final HEADER_HEIGHT_RES_ID:I = 0x7f0d00a9

.field private static final ID_CANDIDATE_LABEL:I = 0x7f0f0183

.field private static final INFLATION_TIMEOUT_MS:J = 0x4b0L

.field private static final LAYOUT_SOFTKEY_CANDIDATE:I = 0x7f040171

.field private static final MAIN_HANDLER:Landroid/os/Handler;

.field private static final MAX_CHIP_WIDTH_DP:F = 240.0f

.field private static final MIN_CHIP_WIDTH_DP:F = 48.0f

.field private static final PRESENTATION_COUNT:I = 0x3

.field private static final RAIL_WIDTH_RES_ID:I = 0x7f0d0206

.field private static final REMOTE_CLIPPER:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

.field private static activeInputSession:Z

.field private static activeRequestCandidateTextColor:Ljava/lang/Integer;

.field private static completedInflations:[Z

.field private static generation:I

.field private static pendingCount:I

.field private static pendingHeaderToken:J

.field private static pendingModule:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;",
            ">;"
        }
    .end annotation
.end field

.field private static pendingSessionToken:J

.field private static pendingViews:[Landroid/view/View;

.field private static published:Z

.field private static timeout:Ljava/lang/Runnable;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 56
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    .line 57
    new-instance v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$1;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$1;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->REMOTE_CLIPPER:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 76
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static declared-synchronized acceptInflated(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;ILandroid/view/View;)V
    .locals 6

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 262
    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->isCurrentLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)Z

    move-result v1

    if-eqz v1, :cond_7

    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-nez v1, :cond_7

    if-ltz p2, :cond_7

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    array-length v1, v1

    if-ge p2, v1, :cond_7

    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    aget-boolean v1, v1, p2

    if-eqz v1, :cond_0

    goto/16 :goto_5

    .line 266
    :cond_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    const/4 v2, 0x1

    aput-boolean v2, v1, p2

    .line 267
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    aput-object p3, v1, p2

    .line 268
    if-nez p3, :cond_1

    const/4 v1, 0x0

    goto :goto_0

    :cond_1
    invoke-virtual {p3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    .line 269
    :goto_0
    const-string v3, "HeaderPlatformAudit"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "inline inflate callback index="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v4, " view="

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    if-eqz p3, :cond_2

    move v4, v2

    goto :goto_1

    :cond_2
    const/4 v4, 0x0

    :goto_1
    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v4, " size="

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    .line 271
    if-nez p3, :cond_3

    const-string v4, "none"

    goto :goto_2

    :cond_3
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p3}, Landroid/view/View;->getWidth()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "x"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {p3}, Landroid/view/View;->getHeight()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    :goto_2
    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v4, " measured="

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    .line 272
    if-nez p3, :cond_4

    const-string p3, "none"

    goto :goto_3

    .line 273
    :cond_4
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p3}, Landroid/view/View;->getMeasuredWidth()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "x"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {p3}, Landroid/view/View;->getMeasuredHeight()I

    move-result p3

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    :goto_3
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, " lp="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    .line 274
    if-nez v1, :cond_5

    const-string p3, "none"

    goto :goto_4

    :cond_5
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    iget v4, v1, Landroid/view/ViewGroup$LayoutParams;->width:I

    invoke-virtual {p3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string v4, "x"

    invoke-virtual {p3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    iget v1, v1, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    :goto_4
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 269
    invoke-static {v3, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 275
    sget p2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    sub-int/2addr p2, v2

    sput p2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 276
    sget p2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    if-nez p2, :cond_6

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->publishLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 277
    :cond_6
    monitor-exit v0

    return-void

    .line 264
    :cond_7
    :goto_5
    monitor-exit v0

    return-void

    .line 261
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method static synthetic access$000(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;ILandroid/view/View;)V
    .locals 0

    .line 43
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->acceptInflated(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;ILandroid/view/View;)V

    return-void
.end method

.method static synthetic access$100(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V
    .locals 0

    .line 43
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->publishPartial(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V

    return-void
.end method

.method public static applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V
    .locals 0

    .line 351
    if-eqz p0, :cond_0

    .line 352
    invoke-virtual {p0, p1}, Landroid/view/View;->setClipBounds(Landroid/graphics/Rect;)V

    .line 354
    :cond_0
    return-void
.end method

.method private static cancelPendingLocked()V
    .locals 3

    .line 328
    sget-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 329
    sget-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 330
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    .line 332
    :cond_0
    const/4 v0, 0x0

    sput v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 333
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    .line 334
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    .line 335
    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingModule:Ljava/lang/ref/WeakReference;

    .line 336
    const-wide/16 v1, 0x0

    sput-wide v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingSessionToken:J

    .line 337
    sput-wide v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHeaderToken:J

    .line 338
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    .line 339
    return-void
.end method

.method public static declared-synchronized clear()V
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 391
    :try_start_0
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 392
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    .line 393
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeRequestCandidateTextColor:Ljava/lang/Integer;

    .line 394
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 395
    monitor-exit v0

    return-void

    .line 390
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method public static declared-synchronized createRequest(Landroid/content/Context;Landroid/os/Bundle;)Landroid/view/inputmethod/InlineSuggestionsRequest;
    .locals 12

    const-class p1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter p1

    .line 87
    const/4 v0, 0x0

    if-nez p0, :cond_0

    .line 88
    :try_start_0
    const-string p0, "HeaderPlatformAudit"

    const-string v1, "inline request rejected api/context"

    invoke-static {p0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 89
    monitor-exit p1

    return-object v0

    .line 91
    :cond_0
    :try_start_1
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 92
    sput-boolean v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    .line 93
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 94
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->findModule(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    move-result-object v1

    .line 95
    const-string v3, "HeaderPlatformAudit"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "inline request generation="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    sget v5, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " module="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/4 v5, 0x0

    if-eqz v1, :cond_1

    move v6, v2

    goto :goto_0

    :cond_1
    move v6, v5

    :goto_0
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " session="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-eqz v1, :cond_2

    .line 97
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailable()Z

    move-result v6

    if-eqz v6, :cond_2

    move v6, v2

    goto :goto_1

    :cond_2
    move v6, v5

    :goto_1
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " header="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-eqz v1, :cond_3

    .line 98
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->getHeaderToken()J

    move-result-wide v6

    const-wide/16 v8, 0x0

    cmp-long v6, v6, v8

    if-lez v6, :cond_3

    move v6, v2

    goto :goto_2

    :cond_3
    move v6, v5

    :goto_2
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 95
    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 99
    if-eqz v1, :cond_4

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->clearRemoteViews()V

    .line 101
    :cond_4
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    .line 102
    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v4

    .line 103
    const v6, 0x7f0d00a9

    invoke-virtual {v3, v6}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v6

    .line 104
    iget v7, v4, Landroid/util/DisplayMetrics;->density:F

    const/high16 v8, 0x42400000    # 48.0f

    mul-float/2addr v7, v8

    invoke-static {v7}, Ljava/lang/Math;->round(F)I

    move-result v7

    invoke-static {v2, v7}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 105
    iget v7, v4, Landroid/util/DisplayMetrics;->density:F

    const/high16 v8, 0x43700000    # 240.0f

    mul-float/2addr v7, v8

    .line 106
    invoke-static {v7}, Ljava/lang/Math;->round(F)I

    move-result v7

    .line 105
    invoke-static {v2, v7}, Ljava/lang/Math;->max(II)I

    move-result v7

    .line 107
    const v8, 0x7f0d0206

    invoke-virtual {v3, v8}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v8

    .line 108
    iget v9, v4, Landroid/util/DisplayMetrics;->widthPixels:I

    if-lez v9, :cond_5

    iget v9, v4, Landroid/util/DisplayMetrics;->widthPixels:I

    goto :goto_3

    :cond_5
    move v9, v7

    .line 109
    :goto_3
    mul-int/lit8 v8, v8, 0x2

    sub-int v8, v9, v8

    invoke-static {v2, v8}, Ljava/lang/Math;->max(II)I

    move-result v8

    .line 110
    invoke-static {v7, v8}, Ljava/lang/Math;->min(II)I

    move-result v7

    invoke-static {v2, v7}, Ljava/lang/Math;->max(II)I

    move-result v7

    .line 112
    new-instance v8, Landroid/util/Size;

    invoke-direct {v8, v2, v6}, Landroid/util/Size;-><init>(II)V

    .line 113
    new-instance v10, Landroid/util/Size;

    invoke-direct {v10, v7, v6}, Landroid/util/Size;-><init>(II)V

    .line 117
    if-nez v1, :cond_6

    .line 118
    goto :goto_4

    :cond_6
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->getCurrentCandidateTextColor()Ljava/lang/Integer;

    move-result-object v0

    .line 119
    :goto_4
    if-nez v0, :cond_7

    .line 120
    const v0, 0x7f010066

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->resolveKeyboardThemeCandidateColor(Landroid/content/Context;I)Ljava/lang/Integer;

    move-result-object v0

    .line 123
    :cond_7
    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeRequestCandidateTextColor:Ljava/lang/Integer;

    .line 124
    const-string p0, "HeaderPlatformAudit"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "inline request geometry orientation="

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 125
    invoke-virtual {v3}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v11

    iget v11, v11, Landroid/content/res/Configuration;->orientation:I

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v11, " night="

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 126
    invoke-virtual {v3}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v3

    iget v3, v3, Landroid/content/res/Configuration;->uiMode:I

    and-int/lit8 v3, v3, 0x30

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " screen="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, "x"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v3, v4, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " specMin="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " specMax="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 124
    invoke-static {p0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 134
    new-instance p0, Landroidx/autofill/inline/common/ViewStyle$Builder;

    invoke-direct {p0}, Landroidx/autofill/inline/common/ViewStyle$Builder;-><init>()V

    .line 135
    invoke-virtual {p0, v5}, Landroidx/autofill/inline/common/ViewStyle$Builder;->setBackgroundColor(I)Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;

    move-result-object p0

    check-cast p0, Landroidx/autofill/inline/common/ViewStyle$Builder;

    .line 136
    invoke-virtual {p0, v5, v5, v5, v5}, Landroidx/autofill/inline/common/ViewStyle$Builder;->setPadding(IIII)Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;

    move-result-object p0

    check-cast p0, Landroidx/autofill/inline/common/ViewStyle$Builder;

    .line 137
    invoke-virtual {p0, v5, v5, v5, v5}, Landroidx/autofill/inline/common/ViewStyle$Builder;->setLayoutMargin(IIII)Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;

    move-result-object p0

    check-cast p0, Landroidx/autofill/inline/common/ViewStyle$Builder;

    .line 138
    invoke-virtual {p0}, Landroidx/autofill/inline/common/ViewStyle$Builder;->build()Landroidx/autofill/inline/common/ViewStyle;

    move-result-object p0

    .line 143
    new-instance v1, Landroidx/autofill/inline/common/TextViewStyle$Builder;

    invoke-direct {v1}, Landroidx/autofill/inline/common/TextViewStyle$Builder;-><init>()V

    .line 144
    new-instance v2, Landroidx/autofill/inline/common/TextViewStyle$Builder;

    invoke-direct {v2}, Landroidx/autofill/inline/common/TextViewStyle$Builder;-><init>()V

    .line 145
    if-eqz v0, :cond_8

    .line 146
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 147
    invoke-virtual {v1, v0}, Landroidx/autofill/inline/common/TextViewStyle$Builder;->setTextColor(I)Landroidx/autofill/inline/common/TextViewStyle$Builder;

    .line 148
    invoke-virtual {v2, v0}, Landroidx/autofill/inline/common/TextViewStyle$Builder;->setTextColor(I)Landroidx/autofill/inline/common/TextViewStyle$Builder;

    .line 150
    :cond_8
    invoke-virtual {v1}, Landroidx/autofill/inline/common/TextViewStyle$Builder;->build()Landroidx/autofill/inline/common/TextViewStyle;

    move-result-object v0

    .line 151
    invoke-virtual {v2}, Landroidx/autofill/inline/common/TextViewStyle$Builder;->build()Landroidx/autofill/inline/common/TextViewStyle;

    move-result-object v1

    .line 152
    invoke-static {}, Landroidx/autofill/inline/UiVersions;->newStylesBuilder()Landroidx/autofill/inline/UiVersions$StylesBuilder;

    move-result-object v2

    .line 153
    invoke-static {}, Landroidx/autofill/inline/v1/InlineSuggestionUi;->newStyleBuilder()Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;

    move-result-object v3

    .line 154
    invoke-virtual {v3, p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->setChipStyle(Landroidx/autofill/inline/common/ViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;

    move-result-object v3

    .line 155
    invoke-virtual {v3, p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->setSingleIconChipStyle(Landroidx/autofill/inline/common/ViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;

    move-result-object p0

    .line 156
    invoke-virtual {p0, v0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->setTitleStyle(Landroidx/autofill/inline/common/TextViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;

    move-result-object p0

    .line 157
    invoke-virtual {p0, v1}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->setSubtitleStyle(Landroidx/autofill/inline/common/TextViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;

    move-result-object p0

    .line 158
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->build()Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;

    move-result-object p0

    .line 153
    invoke-virtual {v2, p0}, Landroidx/autofill/inline/UiVersions$StylesBuilder;->addStyle(Landroidx/autofill/inline/UiVersions$Style;)Landroidx/autofill/inline/UiVersions$StylesBuilder;

    move-result-object p0

    .line 159
    invoke-virtual {p0}, Landroidx/autofill/inline/UiVersions$StylesBuilder;->build()Landroid/os/Bundle;

    move-result-object p0

    .line 160
    new-instance v0, Landroid/widget/inline/InlinePresentationSpec$Builder;

    invoke-direct {v0, v8, v10}, Landroid/widget/inline/InlinePresentationSpec$Builder;-><init>(Landroid/util/Size;Landroid/util/Size;)V

    .line 161
    invoke-virtual {v0, p0}, Landroid/widget/inline/InlinePresentationSpec$Builder;->setStyle(Landroid/os/Bundle;)Landroid/widget/inline/InlinePresentationSpec$Builder;

    move-result-object p0

    .line 162
    invoke-virtual {p0}, Landroid/widget/inline/InlinePresentationSpec$Builder;->build()Landroid/widget/inline/InlinePresentationSpec;

    move-result-object p0

    .line 163
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x3

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 165
    nop

    :goto_5
    if-ge v5, v1, :cond_9

    .line 166
    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 165
    add-int/lit8 v5, v5, 0x1

    goto :goto_5

    .line 168
    :cond_9
    new-instance p0, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;

    invoke-direct {p0, v0}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;-><init>(Ljava/util/List;)V

    .line 169
    invoke-virtual {p0, v1}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;->setMaxSuggestionCount(I)Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;

    move-result-object p0

    .line 170
    invoke-virtual {p0}, Landroid/view/inputmethod/InlineSuggestionsRequest$Builder;->build()Landroid/view/inputmethod/InlineSuggestionsRequest;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 168
    monitor-exit p1

    return-object p0

    .line 86
    :goto_6
    :try_start_2
    monitor-exit p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0

    :catchall_0
    move-exception p0

    goto :goto_6
.end method

.method private static findModule(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;
    .locals 2

    .line 342
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object p0

    .line 343
    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 344
    :cond_0
    invoke-interface {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object p0

    const-string v1, "inline-autofill"

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    move-result-object p0

    .line 346
    instance-of v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    if-eqz v1, :cond_1

    .line 347
    move-object v0, p0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    goto :goto_0

    :cond_1
    nop

    .line 346
    :goto_0
    return-object v0
.end method

.method public static declared-synchronized handleResponse(Landroid/content/Context;Landroid/view/inputmethod/InlineSuggestionsResponse;)Z
    .locals 12

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 175
    :try_start_0
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_b

    if-eqz p0, :cond_b

    if-nez p1, :cond_0

    goto/16 :goto_7

    .line 180
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->findModule(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    move-result-object v1

    .line 181
    const/4 v3, 0x1

    if-eqz v1, :cond_9

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailable()Z

    move-result v4

    if-nez v4, :cond_1

    goto/16 :goto_5

    .line 186
    :cond_1
    invoke-virtual {p1}, Landroid/view/inputmethod/InlineSuggestionsResponse;->getInlineSuggestions()Ljava/util/List;

    move-result-object p1

    .line 187
    if-nez p1, :cond_2

    move v4, v2

    goto :goto_0

    :cond_2
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v4

    const/4 v5, 0x3

    invoke-static {v5, v4}, Ljava/lang/Math;->min(II)I

    move-result v4

    .line 188
    :goto_0
    if-nez v4, :cond_5

    .line 195
    const-string p0, "HeaderPlatformAudit"

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "inline empty response pending="

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget-object v4, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    if-eqz v4, :cond_3

    move v4, v3

    goto :goto_1

    :cond_3
    move v4, v2

    :goto_1
    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v4, " published="

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget-boolean v4, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 197
    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    if-nez p0, :cond_4

    .line 198
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->clearRemoteViews()V

    .line 199
    sput-boolean v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 201
    :cond_4
    monitor-exit v0

    return v3

    .line 204
    :cond_5
    :try_start_1
    sget v5, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    add-int/2addr v5, v3

    sput v5, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 205
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 206
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->clearRemoteViews()V

    .line 207
    const-string v5, "HeaderPlatformAudit"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "inline response accepted count="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " generation="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " header="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    .line 208
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->getHeaderToken()J

    move-result-wide v7

    const-wide/16 v9, 0x0

    cmp-long v7, v7, v9

    if-lez v7, :cond_6

    move v7, v3

    goto :goto_2

    :cond_6
    move v7, v2

    :goto_2
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 207
    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 209
    sget v5, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 210
    new-instance v6, Ljava/lang/ref/WeakReference;

    invoke-direct {v6, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    .line 212
    sput v4, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 213
    new-array v7, v4, [Landroid/view/View;

    sput-object v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    .line 214
    new-array v7, v4, [Z

    sput-object v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    .line 215
    sput-object v6, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingModule:Ljava/lang/ref/WeakReference;

    .line 216
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->getSessionToken()J

    move-result-wide v7

    sput-wide v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingSessionToken:J

    .line 217
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->getHeaderToken()J

    move-result-wide v7

    sput-wide v7, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHeaderToken:J

    .line 218
    sput-boolean v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    .line 219
    invoke-virtual {p0}, Landroid/content/Context;->getMainExecutor()Ljava/util/concurrent/Executor;

    move-result-object v1

    .line 225
    new-instance v7, Landroid/util/Size;

    const/4 v8, -0x2

    invoke-direct {v7, v8, v8}, Landroid/util/Size;-><init>(II)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 228
    nop

    :goto_3
    if-ge v2, v4, :cond_7

    .line 229
    nop

    .line 231
    :try_start_2
    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/view/inputmethod/InlineSuggestion;

    new-instance v9, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;

    invoke-direct {v9, v5, v6, v2}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;-><init>(ILjava/lang/ref/WeakReference;I)V

    invoke-virtual {v8, p0, v7, v1, v9}, Landroid/view/inputmethod/InlineSuggestion;->inflate(Landroid/content/Context;Landroid/util/Size;Ljava/util/concurrent/Executor;Ljava/util/function/Consumer;)V
    :try_end_2
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 245
    goto :goto_4

    .line 241
    :catch_0
    move-exception v8

    .line 242
    :try_start_3
    const-string v9, "HeaderPlatformAudit"

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "inline inflate threw index="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, " type="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    .line 243
    invoke-virtual {v8}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 242
    invoke-static {v9, v8}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 244
    invoke-virtual {v6}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    const/4 v9, 0x0

    invoke-static {v5, v8, v2, v9}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->acceptInflated(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;ILandroid/view/View;)V

    .line 228
    :goto_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 248
    :cond_7
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-nez p0, :cond_8

    .line 249
    new-instance p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;

    invoke-direct {p0, v5, v6}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;-><init>(ILjava/lang/ref/WeakReference;)V

    sput-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    .line 255
    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    const-wide/16 v1, 0x4b0

    invoke-virtual {p0, p1, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 257
    :cond_8
    monitor-exit v0

    return v3

    .line 182
    :cond_9
    :goto_5
    :try_start_4
    const-string p0, "HeaderPlatformAudit"

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "inline response rejected module/session module="

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    if-eqz v1, :cond_a

    goto :goto_6

    :cond_a
    move v3, v2

    :goto_6
    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 184
    monitor-exit v0

    return v2

    .line 176
    :cond_b
    :goto_7
    :try_start_5
    const-string p0, "HeaderPlatformAudit"

    const-string p1, "inline response rejected active/context/response"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 177
    monitor-exit v0

    return v2

    .line 174
    :catchall_0
    move-exception p0

    :try_start_6
    monitor-exit v0
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    throw p0
.end method

.method private static isCurrentLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)Z
    .locals 2

    .line 288
    sget v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    if-ne p0, v0, :cond_0

    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    if-eqz p0, :cond_0

    if-eqz p1, :cond_0

    sget-wide v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingSessionToken:J

    .line 291
    invoke-virtual {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailableFor(J)Z

    move-result p0

    if-eqz p0, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingModule:Ljava/lang/ref/WeakReference;

    if-eqz p0, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingModule:Ljava/lang/ref/WeakReference;

    .line 293
    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    if-ne p0, p1, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 288
    :goto_0
    return p0
.end method

.method private static publishLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V
    .locals 8

    .line 299
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->isCurrentLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)Z

    move-result p0

    const-string v0, "HeaderPlatformAudit"

    if-eqz p0, :cond_6

    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-eqz p0, :cond_0

    goto/16 :goto_3

    .line 303
    :cond_0
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    .line 304
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    .line 305
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->MAIN_HANDLER:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    invoke-virtual {v1, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 306
    sput-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->timeout:Ljava/lang/Runnable;

    .line 308
    :cond_1
    new-instance v1, Ljava/util/ArrayList;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    array-length v3, v3

    invoke-direct {v1, v3}, Ljava/util/ArrayList;-><init>(I)V

    .line 309
    sget-object v3, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    array-length v4, v3

    const/4 v5, 0x0

    move v6, v5

    :goto_0
    if-ge v6, v4, :cond_3

    aget-object v7, v3, v6

    if-eqz v7, :cond_2

    invoke-virtual {v1, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_2
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 310
    :cond_3
    sput-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingViews:[Landroid/view/View;

    .line 311
    sput-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->completedInflations:[Z

    .line 312
    sput-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingModule:Ljava/lang/ref/WeakReference;

    .line 313
    const-wide/16 v2, 0x0

    sput-wide v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingSessionToken:J

    .line 314
    sput-wide v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingHeaderToken:J

    .line 315
    sput v5, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->pendingCount:I

    .line 316
    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_4

    .line 317
    const-string p0, "inline publish empty"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 318
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->clearRemoteViews()V

    goto :goto_2

    .line 320
    :cond_4
    sget-object v4, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->REMOTE_CLIPPER:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    sget-object v6, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeRequestCandidateTextColor:Ljava/lang/Integer;

    invoke-virtual {p1, v1, v4, v6}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->setRemoteViews(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;Ljava/lang/Integer;)Z

    move-result v4

    .line 322
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "inline publish views="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v6, " accepted="

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, " header="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 323
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->getHeaderToken()J

    move-result-wide v6

    cmp-long p1, v6, v2

    if-lez p1, :cond_5

    goto :goto_1

    :cond_5
    move p0, v5

    :goto_1
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 322
    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 325
    :goto_2
    return-void

    .line 300
    :cond_6
    :goto_3
    const-string p0, "inline publish skipped stale/published"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 301
    return-void
.end method

.method private static declared-synchronized publishPartial(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 281
    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->isCurrentLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)Z

    move-result v1

    if-eqz v1, :cond_0

    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->published:Z

    if-nez v1, :cond_0

    .line 282
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->publishLocked(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 284
    :cond_0
    monitor-exit v0

    return-void

    .line 280
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private static resolveKeyboardThemeCandidateColor(Landroid/content/Context;I)Ljava/lang/Integer;
    .locals 5

    .line 358
    nop

    .line 359
    instance-of v0, p0, Lcom/google/android/inputmethod/pinyin/PinyinIME;

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-eqz v0, :cond_1

    .line 364
    move-object v0, p0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/PinyinIME;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/PinyinIME;->a()Lcom/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme;

    move-result-object v0

    .line 365
    if-eqz v0, :cond_1

    .line 366
    new-instance v3, Landroid/view/ContextThemeWrapper;

    invoke-direct {v3, p0, v2}, Landroid/view/ContextThemeWrapper;-><init>(Landroid/content/Context;I)V

    .line 367
    invoke-virtual {v3}, Landroid/view/ContextThemeWrapper;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v4

    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object p0

    invoke-virtual {v4, p0}, Landroid/content/res/Resources$Theme;->setTo(Landroid/content/res/Resources$Theme;)V

    .line 368
    invoke-interface {v0, v3}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme;->applyToContext(Landroid/content/Context;)V

    .line 369
    nop

    .line 373
    invoke-static {v3}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p0

    const v0, 0x7f040171

    invoke-virtual {p0, v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p0

    .line 375
    const v0, 0x7f0f0183

    invoke-virtual {p0, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    .line 376
    instance-of v0, p0, Landroid/widget/TextView;

    if-eqz v0, :cond_0

    .line 377
    check-cast p0, Landroid/widget/TextView;

    invoke-virtual {p0}, Landroid/widget/TextView;->getCurrentTextColor()I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0

    .line 376
    :cond_0
    move-object p0, v3

    .line 381
    :cond_1
    filled-new-array {p1}, [I

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/content/Context;->obtainStyledAttributes([I)Landroid/content/res/TypedArray;

    move-result-object p0

    .line 383
    :try_start_0
    invoke-virtual {p0, v2}, Landroid/content/res/TypedArray;->getColorStateList(I)Landroid/content/res/ColorStateList;

    move-result-object p1

    .line 384
    if-nez p1, :cond_2

    :goto_0
    goto :goto_1

    :cond_2
    invoke-virtual {p1}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 386
    :goto_1
    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    .line 384
    return-object v1

    .line 386
    :catchall_0
    move-exception p1

    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    .line 387
    throw p1
.end method

.method public static declared-synchronized startInputSession()V
    .locals 4

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;

    monitor-enter v0

    .line 79
    :try_start_0
    sget v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    sput v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    .line 80
    sput-boolean v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->activeInputSession:Z

    .line 81
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->cancelPendingLocked()V

    .line 82
    const-string v1, "HeaderPlatformAudit"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "inline session started generation="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget v3, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->generation:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 83
    monitor-exit v0

    return-void

    .line 78
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method
