.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;
.super Ljava/lang/Object;
.source "HeaderSessionController.java"


# instance fields
.field private activeToken:J

.field private generation:J


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public declared-synchronized getActiveToken()J
    .locals 2

    monitor-enter p0

    .line 21
    :try_start_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->activeToken:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-wide v0

    .line 21
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized invalidate()V
    .locals 7

    monitor-enter p0

    .line 16
    const-wide/16 v0, 0x0

    :try_start_0
    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->activeToken:J

    .line 17
    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    const-wide/16 v4, 0x1

    add-long/2addr v2, v4

    iput-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    .line 18
    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    cmp-long v6, v2, v0

    if-gtz v6, :cond_0

    iput-wide v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 19
    :cond_0
    monitor-exit p0

    return-void

    .line 15
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized isActive(J)Z
    .locals 3

    monitor-enter p0

    .line 23
    const-wide/16 v0, 0x0

    cmp-long v2, p1, v0

    if-lez v2, :cond_0

    :try_start_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->activeToken:J

    cmp-long v2, p1, v0

    if-nez v2, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    .line 23
    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1

    .line 23
    :cond_0
    const/4 p1, 0x0

    :goto_0
    monitor-exit p0

    return p1
.end method

.method public declared-synchronized startSession()J
    .locals 7

    monitor-enter p0

    .line 9
    :try_start_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    .line 10
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    const-wide/16 v4, 0x0

    cmp-long v6, v0, v4

    if-gtz v6, :cond_0

    iput-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    .line 11
    :cond_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->generation:J

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->activeToken:J

    .line 12
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->activeToken:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-wide v0

    .line 8
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method
