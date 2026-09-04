.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.super Ljava/lang/Object;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;
    }
.end annotation


# instance fields
.field private final configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

.field private final context:Landroid/content/Context;

.field private final engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

.field private final safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

.field private final stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 20
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    if-eqz p4, :cond_0

    if-eqz p5, :cond_0

    .line 24
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    .line 25
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 26
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    .line 27
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    .line 28
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 29
    return-void

    .line 22
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime synchronization coordinator is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private static applyRimeChanges(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 275
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;

    .line 276
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->apply(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;)V

    .line 277
    goto :goto_0

    .line 278
    :cond_0
    return-void
.end method

.method private buildSession(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 230
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->loadMergedSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object p1

    .line 231
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 232
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object v0

    .line 233
    nop

    .line 234
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->translationEntries(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/util/Map;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    .line 235
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->baselineLookup()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;

    move-result-object v2

    .line 233
    invoke-static {v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->build(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    move-result-object v0

    .line 236
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;

    invoke-direct {v1, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)V

    return-object v1
.end method

.method private loadMergedSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 241
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 243
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listSnapshots()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    .line 244
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->deviceDirectoryName:Ljava/lang/String;

    iget-boolean v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->bridgeOwned:Z

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    .line 245
    invoke-virtual {v6, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v2

    invoke-direct {v3, v4, v5, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;-><init>(Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)V

    .line 244
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 246
    goto :goto_0

    .line 247
    :cond_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-static {v0, v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->merge(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object p1

    return-object p1
.end method

.method private requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 3

    .line 281
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 282
    if-eqz v0, :cond_0

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    .line 283
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    .line 284
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 287
    return-object v0

    .line 285
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime synchronization profile does not match"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private stage(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)J
    .locals 8

    .line 251
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->beginStage()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;

    move-result-object v1

    .line 252
    nop

    .line 254
    :try_start_0
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->entries:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;

    .line 255
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->key:Ljava/lang/String;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iget-object v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    iget v5, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextRimeAbsCount:I

    invoke-virtual {v1, v2, v3, v4, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->putBaseline(Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 257
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v2, v3, :cond_0

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v2, v3, :cond_1

    .line 259
    :cond_0
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    iget-object v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    iget-object v5, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    iget-object v6, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    iget v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeCommitValue:I

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    invoke-virtual {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->putOperation(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;)V

    .line 263
    :cond_1
    goto :goto_0

    .line 264
    :cond_2
    iget-wide v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->generation:J

    .line 265
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->finish()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 266
    nop

    .line 267
    nop

    .line 269
    nop

    .line 267
    return-wide v2

    .line 269
    :catchall_0
    move-exception v0

    move-object p1, v0

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->close()V

    .line 270
    goto :goto_2

    :goto_1
    throw p1

    :goto_2
    goto :goto_1
.end method


# virtual methods
.method public execute(Ljava/lang/String;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 45
    if-eqz p1, :cond_4

    .line 48
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 49
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v1, :cond_3

    .line 53
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->buildSession(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;

    move-result-object v1

    .line 54
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->confirmationToken:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 57
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->requiresDeletionConfirmation()Z

    move-result p1

    if-eqz p1, :cond_1

    if-eqz p2, :cond_0

    goto :goto_0

    .line 58
    :cond_0
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;

    iget-object p2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    invoke-direct {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;-><init>(II)V

    throw p1

    .line 61
    :cond_1
    :goto_0
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stage(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)J

    move-result-wide v3

    .line 64
    :try_start_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    .line 65
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleChanges()Ljava/util/List;

    move-result-object v2

    .line 64
    invoke-static {p1, p2, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->apply(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    move-result-object p1
    :try_end_0
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_0 .. :try_end_0} :catch_5
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException; {:try_start_0 .. :try_end_0} :catch_4
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/OutOfMemoryError; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 84
    nop

    .line 85
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleApplied()V

    .line 86
    iget-object p2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeChanges()Ljava/util/List;

    move-result-object v2

    invoke-static {p2, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->applyRimeChanges(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/util/List;)V

    .line 87
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-virtual {p2, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->publish(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/lang/String;)V

    .line 88
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markSnapshotPublished()V

    .line 89
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {p2, v3, v4, v5, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->commitStage(JJ)V

    .line 90
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    iget v5, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;->addedCount:I

    iget v6, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;->deletedCount:I

    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget v7, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeAdditionCount:I

    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget v8, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget v9, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeResurrectionCount:I

    const/4 v10, 0x0

    invoke-direct/range {v2 .. v10}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;-><init>(JIIIIIZ)V

    return-object v2

    .line 81
    :catch_0
    move-exception v0

    move-object p1, v0

    .line 82
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v0, 0x4

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 83
    throw p1

    .line 78
    :catch_1
    move-exception v0

    move-object p1, v0

    .line 79
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v0, 0x3

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 80
    throw p1

    .line 75
    :catch_2
    move-exception v0

    move-object p1, v0

    .line 76
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v0, 0x2

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 77
    throw p1

    .line 72
    :catch_3
    move-exception v0

    move-object p1, v0

    .line 73
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 74
    throw p1

    .line 69
    :catch_4
    move-exception v0

    move-object p1, v0

    .line 70
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeRejectedEntriesFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 71
    throw p1

    .line 66
    :catch_5
    move-exception v0

    move-object p1, v0

    .line 67
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 68
    throw p1

    .line 55
    :cond_2
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException;

    invoke-direct {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException;-><init>()V

    throw p1

    .line 50
    :cond_3
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p2, "unfinished Rime synchronization must be recovered before execution"

    invoke-direct {p1, p2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 46
    :cond_4
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime synchronization confirmation is required"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public preview()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 33
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 34
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v1, :cond_0

    .line 38
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->buildSession(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;

    move-result-object v0

    .line 39
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-direct {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)V

    return-object v1

    .line 35
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "unfinished Rime synchronization must be recovered before preview"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public recover()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;
    .locals 19
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 151
    move-object/from16 v1, p0

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 152
    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v2, :cond_0

    .line 153
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    iget-wide v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    const/4 v10, 0x0

    const/4 v11, 0x1

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    invoke-direct/range {v3 .. v11}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;-><init>(JIIIIIZ)V

    return-object v3

    .line 155
    :cond_0
    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_2

    iget-boolean v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    if-nez v2, :cond_1

    goto :goto_0

    .line 157
    :cond_1
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    invoke-direct {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;-><init>(I)V

    throw v2

    .line 159
    :cond_2
    :goto_0
    iget-wide v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    const-wide/16 v6, 0x1

    add-long v9, v4, v6

    .line 160
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->pendingOperations()Ljava/util/List;

    move-result-object v2

    .line 161
    nop

    .line 162
    nop

    .line 163
    nop

    .line 164
    nop

    .line 165
    nop

    .line 166
    iget v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v5, 0x3

    const/4 v6, 0x2

    const/4 v7, 0x0

    if-ne v4, v3, :cond_7

    .line 167
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 169
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v8, 0x0

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v11

    if-eqz v11, :cond_6

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    .line 170
    iget-object v12, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v12, v13, :cond_3

    goto :goto_1

    .line 171
    :cond_3
    new-instance v12, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v13, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    iget-object v14, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    iget-object v15, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v12, v13, v14, v15}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    invoke-interface {v0, v12}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 173
    iget-object v12, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v12, v13, :cond_4

    add-int/lit8 v4, v4, 0x1

    .line 174
    :cond_4
    iget-object v11, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v11, v12, :cond_5

    add-int/lit8 v8, v8, 0x1

    .line 175
    :cond_5
    goto :goto_1

    .line 177
    :cond_6
    :try_start_0
    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v11, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v3, v11, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_0
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_0 .. :try_end_0} :catch_5
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException; {:try_start_0 .. :try_end_0} :catch_4
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/OutOfMemoryError; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 197
    nop

    .line 198
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleApplied()V

    .line 199
    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    move v11, v4

    move v12, v8

    goto :goto_2

    .line 194
    :catch_0
    move-exception v0

    .line 195
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v3, 0x4

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 196
    throw v0

    .line 191
    :catch_1
    move-exception v0

    .line 192
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 193
    throw v0

    .line 188
    :catch_2
    move-exception v0

    .line 189
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 190
    throw v0

    .line 185
    :catch_3
    move-exception v0

    .line 186
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 187
    throw v0

    .line 182
    :catch_4
    move-exception v0

    .line 183
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeRejectedEntriesFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 184
    throw v0

    .line 179
    :catch_5
    move-exception v0

    .line 180
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 181
    throw v0

    .line 166
    :cond_7
    const/4 v11, 0x0

    const/4 v12, 0x0

    .line 201
    :goto_2
    iget v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-ne v3, v6, :cond_d

    .line 202
    invoke-direct {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->loadMergedSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v3

    .line 203
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 205
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    const/4 v6, 0x0

    const/4 v8, 0x0

    :goto_3
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v13

    if-eqz v13, :cond_c

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    .line 206
    iget-object v14, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v14, v15, :cond_8

    goto :goto_3

    .line 207
    :cond_8
    new-instance v14, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;

    iget-object v15, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    iget-object v5, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    move-object/from16 v17, v2

    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    move/from16 v18, v6

    iget v6, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeCommitValue:I

    invoke-direct {v14, v15, v5, v2, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    invoke-interface {v4, v14}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 210
    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v2, v5, :cond_9

    add-int/lit8 v7, v7, 0x1

    .line 211
    :cond_9
    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v2, v5, :cond_a

    add-int/lit8 v6, v18, 0x1

    goto :goto_4

    :cond_a
    move/from16 v6, v18

    .line 212
    :goto_4
    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v2, v5, :cond_b

    .line 213
    add-int/lit8 v8, v8, 0x1

    .line 215
    :cond_b
    move-object/from16 v2, v17

    const/4 v5, 0x3

    goto :goto_3

    .line 216
    :cond_c
    move/from16 v18, v6

    invoke-static {v3, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->applyRimeChanges(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/util/List;)V

    .line 217
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-virtual {v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->publish(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/lang/String;)V

    .line 218
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markSnapshotPublished()V

    .line 219
    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    move v13, v7

    move v15, v8

    move/from16 v14, v18

    goto :goto_5

    .line 201
    :cond_d
    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    .line 221
    :goto_5
    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x3

    if-ne v0, v2, :cond_e

    .line 224
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v0, v9, v10, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->commitStage(JJ)V

    .line 225
    new-instance v8, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    const/16 v16, 0x1

    invoke-direct/range {v8 .. v16}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;-><init>(JIIIIIZ)V

    return-object v8

    .line 222
    :cond_e
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v2, "Rime synchronization recovery phase is invalid"

    invoke-direct {v0, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    goto :goto_7

    :goto_6
    throw v0

    :goto_7
    goto :goto_6
.end method

.method public recoverKeepingRejected()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 97
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 98
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x1

    if-ne v1, v2, :cond_3

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    const/4 v2, 0x6

    if-ne v1, v2, :cond_3

    iget-boolean v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    if-eqz v1, :cond_3

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    if-lez v0, :cond_3

    .line 103
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->pendingOperations()Ljava/util/List;

    move-result-object v0

    .line 104
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 106
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    .line 107
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-eq v3, v4, :cond_0

    .line 108
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v3, v4, v5, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    invoke-interface {v1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 111
    :cond_0
    goto :goto_0

    .line 112
    :cond_1
    nop

    .line 114
    const/4 v0, 0x2

    :try_start_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v2, v3, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_0
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 126
    const/4 v2, 0x0

    goto :goto_1

    .line 123
    :catch_0
    move-exception v1

    .line 124
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 125
    throw v1

    .line 120
    :catch_1
    move-exception v0

    .line 121
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 122
    throw v0

    .line 117
    :catch_2
    move-exception v0

    .line 118
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 119
    throw v0

    .line 115
    :catch_3
    move-exception v2

    .line 116
    nop

    .line 126
    nop

    .line 127
    :goto_1
    if-nez v2, :cond_2

    .line 128
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleApplied()V

    .line 129
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->recover()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v0

    return-object v0

    .line 131
    :cond_2
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->verifyRecordedRejectedEntries(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 133
    :try_start_1
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v3, v4, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recoverKeepingRejected(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_1
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_1 .. :try_end_1} :catch_6
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException; {:try_start_1 .. :try_end_1} :catch_5
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_4

    .line 144
    nop

    .line 145
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleAppliedWithRimeOnly(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 146
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->recover()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v0

    return-object v0

    .line 141
    :catch_4
    move-exception v1

    .line 142
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 143
    throw v1

    .line 138
    :catch_5
    move-exception v0

    .line 139
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 140
    throw v0

    .line 135
    :catch_6
    move-exception v0

    .line 136
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 137
    throw v0

    .line 101
    :cond_3
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime-only continuation is unavailable"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    goto :goto_3

    :goto_2
    throw v0

    :goto_3
    goto :goto_2
.end method
