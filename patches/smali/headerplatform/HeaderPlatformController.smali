.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;
.super Ljava/lang/Object;
.source "HeaderPlatformController.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;


# instance fields
.field private activeHeaderToken:J

.field private final arbiter:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;

.field private final contributions:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;",
            ">;"
        }
    .end annotation
.end field

.field private currentCandidateTextColor:Ljava/lang/Integer;

.field private headerGeneration:J

.field private initialized:Z

.field private listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

.field private final modules:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;",
            ">;"
        }
    .end annotation
.end field

.field private nativeCandidatesActive:Z

.field private renderGeneration:J

.field private final sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 10
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    .line 11
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->arbiter:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;

    .line 12
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->modules:Ljava/util/Map;

    .line 14
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    .line 22
    const-wide/16 v0, 0x1

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    return-void
.end method

.method private dispatchPlan()V
    .locals 17

    .line 200
    move-object/from16 v0, p0

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    if-nez v1, :cond_0

    return-void

    .line 201
    :cond_0
    iget-wide v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 202
    iget-wide v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    const-wide/16 v5, 0x0

    cmp-long v7, v1, v5

    if-gtz v7, :cond_1

    iput-wide v3, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 203
    :cond_1
    iget-object v8, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->arbiter:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v9

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    .line 204
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->getActiveToken()J

    move-result-wide v10

    iget-wide v12, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    iget-boolean v14, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->nativeCandidatesActive:Z

    iget-wide v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 203
    move-wide v15, v1

    invoke-virtual/range {v8 .. v16}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;->resolve(Ljava/util/Collection;JJZJ)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    move-result-object v1

    .line 206
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    invoke-interface {v2, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;->onHeaderRenderPlanChanged(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V

    .line 207
    return-void
.end method

.method private ensureInitialized()V
    .locals 2

    .line 196
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z

    if-eqz v0, :cond_0

    .line 197
    return-void

    .line 196
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Header platform is not initialized"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private key(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 192
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private snapshotModules()Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;",
            ">;"
        }
    .end annotation

    .line 188
    new-instance v0, Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->modules:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method


# virtual methods
.method public declared-synchronized bindHost(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;Ljava/lang/Integer;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;
    .locals 7

    monitor-enter p0

    .line 50
    :try_start_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->ensureInitialized()V

    .line 51
    if-eqz p1, :cond_4

    .line 52
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->unbindHost(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;)V

    .line 53
    :cond_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->headerGeneration:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->headerGeneration:J

    .line 54
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->headerGeneration:J

    const-wide/16 v4, 0x0

    cmp-long v6, v0, v4

    if-gtz v6, :cond_1

    iput-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->headerGeneration:J

    .line 55
    :cond_1
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->headerGeneration:J

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    .line 56
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->currentCandidateTextColor:Ljava/lang/Integer;

    .line 57
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 58
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    cmp-long p2, v0, v4

    if-gtz p2, :cond_2

    iput-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 59
    :cond_2
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    .line 60
    new-instance p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    invoke-direct {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;-><init>(J)V

    .line 61
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    invoke-interface {v0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onHeaderAvailable(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;)V

    goto :goto_0

    .line 62
    :cond_3
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 63
    monitor-exit p0

    return-object p1

    .line 51
    :cond_4
    :try_start_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "listener must not be null"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 49
    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :goto_1
    throw p1

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized destroy()V
    .locals 2

    monitor-enter p0

    .line 132
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    monitor-exit p0

    return-void

    .line 133
    :cond_0
    :try_start_1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->finishInput()V

    .line 134
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->unbindHost(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;)V

    .line 135
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    invoke-interface {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onDetach()V

    goto :goto_0

    .line 136
    :cond_2
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 137
    monitor-exit p0

    return-void

    .line 131
    :catchall_0
    move-exception v0

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_2

    :goto_1
    throw v0

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized finishInput()V
    .locals 5

    monitor-enter p0

    .line 120
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    monitor-exit p0

    return-void

    .line 121
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->getActiveToken()J

    move-result-wide v0

    .line 122
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->invalidate()V

    .line 123
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->clear()V

    .line 124
    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->nativeCandidatesActive:Z

    .line 125
    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-lez v4, :cond_1

    .line 126
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    invoke-interface {v3, v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onFinishInput(J)V

    goto :goto_0

    .line 128
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 129
    monitor-exit p0

    return-void

    .line 119
    :catchall_0
    move-exception v0

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_2

    :goto_1
    throw v0

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized getCurrentCandidateTextColor()Ljava/lang/Integer;
    .locals 1

    monitor-enter p0

    .line 151
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->currentCandidateTextColor:Ljava/lang/Integer;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    .line 151
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized getCurrentHeaderToken()J
    .locals 2

    monitor-enter p0

    .line 146
    :try_start_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-wide v0

    .line 146
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized getCurrentSessionToken()J
    .locals 2

    monitor-enter p0

    .line 141
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->getActiveToken()J

    move-result-wide v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-wide v0

    .line 141
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;
    .locals 1

    monitor-enter p0

    .line 38
    if-nez p1, :cond_0

    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->modules:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    monitor-exit p0

    return-object p1

    .line 38
    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized initialize()V
    .locals 2

    monitor-enter p0

    .line 42
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    monitor-exit p0

    return-void

    .line 43
    :cond_0
    const/4 v0, 0x1

    :try_start_1
    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z

    .line 44
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    invoke-interface {v1, p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onAttach(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 45
    :cond_1
    monitor-exit p0

    return-void

    .line 41
    :catchall_0
    move-exception v0

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_2

    :goto_1
    throw v0

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized onThemeChanged(J)V
    .locals 7

    monitor-enter p0

    .line 112
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    monitor-exit p0

    return-void

    .line 113
    :cond_0
    :try_start_1
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 114
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    const-wide/16 v4, 0x0

    cmp-long v6, v0, v4

    if-gtz v6, :cond_1

    iput-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->renderGeneration:J

    .line 115
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    invoke-interface {v1, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onThemeChanged(J)V

    goto :goto_0

    .line 116
    :cond_2
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 117
    monitor-exit p0

    return-void

    .line 111
    :catchall_0
    move-exception p1

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_2

    :goto_1
    throw p1

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized publish(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z
    .locals 6

    monitor-enter p0

    .line 156
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    if-eqz p1, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    .line 157
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getSessionToken()J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->isActive(J)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 158
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getHeaderToken()J

    move-result-wide v2

    iget-wide v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    cmp-long v0, v2, v4

    if-nez v0, :cond_2

    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    const-wide/16 v4, 0x0

    cmp-long v0, v2, v4

    if-gtz v0, :cond_0

    goto :goto_0

    .line 160
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->modules:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getModuleId()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_1

    monitor-exit p0

    return v1

    .line 161
    :cond_1
    :try_start_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getModuleId()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getStableId()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->key(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 162
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 163
    monitor-exit p0

    const/4 p1, 0x1

    return p1

    .line 159
    :cond_2
    :goto_0
    monitor-exit p0

    return v1

    .line 155
    :catchall_0
    move-exception p1

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p1
.end method

.method public declared-synchronized register(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;)V
    .locals 3

    monitor-enter p0

    .line 25
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z

    if-nez v0, :cond_2

    .line 26
    if-eqz p1, :cond_1

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->getModuleId()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 27
    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->getModuleId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_1

    .line 30
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->modules:Ljava/util/Map;

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->getModuleId()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 33
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->modules:Ljava/util/Map;

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->getModuleId()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 34
    monitor-exit p0

    return-void

    .line 31
    :cond_0
    :try_start_1
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "duplicate moduleId: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->getModuleId()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 28
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "module and moduleId must not be empty"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 25
    :cond_2
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "modules must be registered before init"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 24
    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized setNativeCandidateState(ZZ)V
    .locals 3

    monitor-enter p0

    .line 98
    :try_start_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->initialized:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    monitor-exit p0

    return-void

    .line 99
    :cond_0
    :try_start_1
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->nativeCandidatesActive:Z

    .line 100
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    .line 101
    instance-of v2, v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateAware;

    if-eqz v2, :cond_1

    .line 102
    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateAware;

    invoke-interface {v1, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateAware;->onNativeCandidateStateChanged(ZZ)V

    goto :goto_1

    .line 105
    :cond_1
    invoke-interface {v1, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onNativeCandidateStateChanged(Z)V

    .line 107
    :goto_1
    goto :goto_0

    .line 108
    :cond_2
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 109
    monitor-exit p0

    return-void

    .line 97
    :catchall_0
    move-exception p1

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_3

    :goto_2
    throw p1

    :goto_3
    goto :goto_2
.end method

.method public declared-synchronized setNativeCandidatesActive(Z)V
    .locals 1

    monitor-enter p0

    .line 94
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->setNativeCandidateState(ZZ)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 95
    monitor-exit p0

    return-void

    .line 93
    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized startInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;)J
    .locals 4

    monitor-enter p0

    .line 80
    :try_start_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->ensureInitialized()V

    .line 81
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 82
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->nativeCandidatesActive:Z

    .line 83
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->sessions:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderSessionController;->startSession()J

    move-result-wide v0

    .line 84
    if-nez p1, :cond_0

    .line 85
    const/4 p1, 0x0

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->from(Landroid/view/inputmethod/EditorInfo;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;

    move-result-object p1

    goto :goto_0

    :cond_0
    nop

    .line 86
    :goto_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    .line 87
    invoke-interface {v3, p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onStartInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;J)V

    .line 88
    goto :goto_1

    .line 89
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 90
    monitor-exit p0

    return-wide v0

    .line 79
    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_3

    :goto_2
    throw p1

    :goto_3
    goto :goto_2
.end method

.method public declared-synchronized unbindHost(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;)V
    .locals 4

    monitor-enter p0

    .line 68
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    if-eq v0, p1, :cond_0

    goto :goto_1

    .line 69
    :cond_0
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    .line 70
    const-wide/16 v2, 0x0

    iput-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->activeHeaderToken:J

    .line 71
    const/4 p1, 0x0

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->currentCandidateTextColor:Ljava/lang/Integer;

    .line 72
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->clear()V

    .line 73
    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->nativeCandidatesActive:Z

    .line 74
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->snapshotModules()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    invoke-interface {v3, v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;->onHeaderUnavailable(J)V

    goto :goto_0

    .line 75
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->idle()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;->onHeaderRenderPlanChanged(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V

    .line 76
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->listener:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 77
    monitor-exit p0

    return-void

    .line 68
    :cond_2
    :goto_1
    monitor-exit p0

    return-void

    .line 67
    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_3

    :goto_2
    throw p1

    :goto_3
    goto :goto_2
.end method

.method public declared-synchronized withdraw(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    monitor-enter p0

    .line 168
    if-eqz p1, :cond_2

    if-nez p2, :cond_0

    goto :goto_0

    .line 169
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->key(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_1

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 170
    :cond_1
    monitor-exit p0

    return-void

    .line 167
    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1

    .line 168
    :cond_2
    :goto_0
    monitor-exit p0

    return-void
.end method

.method public declared-synchronized withdrawModule(Ljava/lang/String;)V
    .locals 4

    monitor-enter p0

    .line 174
    if-nez p1, :cond_0

    monitor-exit p0

    return-void

    .line 175
    :cond_0
    nop

    .line 176
    :try_start_0
    new-instance v0, Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 177
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 178
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 179
    invoke-virtual {v2, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 180
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->contributions:Ljava/util/Map;

    invoke-interface {v1, v2}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 181
    const/4 v1, 0x1

    .line 183
    :cond_1
    goto :goto_0

    .line 184
    :cond_2
    if-eqz v1, :cond_3

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->dispatchPlan()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 185
    :cond_3
    monitor-exit p0

    return-void

    .line 173
    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :goto_1
    throw p1

    :goto_2
    goto :goto_1
.end method
