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
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;
    }
.end annotation


# static fields
.field public static final PREVIEW_STAGE_GOOGLE_EXPORT:I = 0x7

.field public static final PREVIEW_STAGE_RIME_MERGE:I = 0x6

.field public static final PREVIEW_STAGE_SESSION_PLAN:I = 0x8

.field public static final PREVIEW_STAGE_SOURCE_CLOSE:I = 0x5

.field public static final PREVIEW_STAGE_SOURCE_DATABASE:I = 0x4

.field public static final PREVIEW_STAGE_SOURCE_LIST:I = 0x1

.field public static final PREVIEW_STAGE_SOURCE_OPEN:I = 0x2

.field public static final PREVIEW_STAGE_SOURCE_PARSE:I = 0x3


# instance fields
.field private final configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

.field private final context:Landroid/content/Context;

.field private final engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

.field private final safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

.field private final stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V
    .locals 0

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 30
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    if-eqz p4, :cond_0

    if-eqz p5, :cond_0

    .line 34
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    .line 35
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 36
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    .line 37
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    .line 38
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 39
    return-void

    .line 32
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

    .line 328
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;

    .line 329
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->apply(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;)V

    .line 330
    goto :goto_0

    .line 331
    :cond_0
    return-void
.end method

.method private buildSession(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 241
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->loadMergedSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object p1

    .line 244
    if-eqz p2, :cond_0

    .line 245
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object v0

    goto :goto_0

    .line 246
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->readPresence(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object v0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 249
    :goto_0
    nop

    .line 252
    if-eqz p2, :cond_1

    .line 253
    :try_start_1
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->translationEntries(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/util/Map;

    move-result-object v1

    goto :goto_1

    .line 254
    :cond_1
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->translationEntriesForPreview(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/util/Map;

    move-result-object v1

    .line 255
    :goto_1
    if-eqz p2, :cond_2

    .line 256
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    .line 257
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->baselineLookup()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;

    move-result-object p2

    .line 256
    invoke-static {v1, v0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->build(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    move-result-object p2

    goto :goto_2

    .line 259
    :cond_2
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    .line 260
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->baselineLookup()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;

    move-result-object p2

    .line 259
    invoke-static {v1, v0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->buildPreview(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    move-result-object p2
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 264
    :goto_2
    nop

    .line 265
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)V

    return-object v0

    .line 262
    :catch_0
    move-exception p1

    .line 263
    new-instance p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;

    const/16 v0, 0x8

    invoke-direct {p2, v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;-><init>(ILjava/io/IOException;)V

    throw p2

    .line 247
    :catch_1
    move-exception p1

    .line 248
    new-instance p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;

    const/4 v0, 0x7

    invoke-direct {p2, v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;-><init>(ILjava/io/IOException;)V

    throw p2
.end method

.method private loadMergedSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 272
    const/4 v0, 0x1

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listSnapshots()Ljava/util/List;

    move-result-object v1
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_3

    .line 275
    nop

    .line 276
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 278
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    .line 280
    const/4 v4, 0x5

    :try_start_1
    new-instance v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;

    iget-object v6, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->deviceDirectoryName:Ljava/lang/String;

    iget-boolean v7, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->bridgeOwned:Z

    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    .line 281
    invoke-virtual {v8, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v3

    invoke-direct {v5, v6, v7, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;-><init>(Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)V

    .line 280
    invoke-interface {v2, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 294
    nop

    .line 295
    goto :goto_0

    .line 292
    :catch_0
    move-exception p1

    .line 293
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;

    invoke-direct {v0, v4, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;-><init>(ILjava/io/IOException;)V

    throw v0

    .line 282
    :catch_1
    move-exception p1

    .line 283
    nop

    .line 284
    iget v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;->kind:I

    const/4 v2, 0x2

    if-eq v1, v0, :cond_1

    .line 286
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;->kind:I

    const/4 v1, 0x3

    if-eq v0, v2, :cond_0

    .line 288
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;->kind:I

    if-ne v0, v1, :cond_2

    .line 289
    const/4 v4, 0x4

    goto :goto_1

    .line 287
    :cond_0
    const/4 v4, 0x3

    goto :goto_1

    .line 285
    :cond_1
    const/4 v4, 0x2

    .line 291
    :cond_2
    :goto_1
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;

    invoke-direct {v0, v4, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;-><init>(ILjava/io/IOException;)V

    throw v0

    .line 297
    :cond_3
    :try_start_2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-static {v2, v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->merge(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object p1
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    return-object p1

    .line 298
    :catch_2
    move-exception p1

    .line 299
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;

    const/4 v1, 0x6

    invoke-direct {v0, v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;-><init>(ILjava/io/IOException;)V

    throw v0

    .line 273
    :catch_3
    move-exception p1

    .line 274
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;

    invoke-direct {v1, v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;-><init>(ILjava/io/IOException;)V

    goto :goto_3

    :goto_2
    throw v1

    :goto_3
    goto :goto_2
.end method

.method private requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 3

    .line 334
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 335
    if-eqz v0, :cond_0

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    .line 336
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    .line 337
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 340
    return-object v0

    .line 338
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime synchronization profile does not match"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private stage(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)J
    .locals 8

    .line 304
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->beginStage()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;

    move-result-object v1

    .line 305
    nop

    .line 307
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

    .line 308
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->key:Ljava/lang/String;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iget-object v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    iget v5, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextRimeAbsCount:I

    invoke-virtual {v1, v2, v3, v4, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->putBaseline(Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 310
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v2, v3, :cond_0

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v2, v3, :cond_1

    .line 312
    :cond_0
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    iget-object v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    iget-object v5, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    iget-object v6, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    iget v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeCommitValue:I

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    invoke-virtual {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->putOperation(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;)V

    .line 316
    :cond_1
    goto :goto_0

    .line 317
    :cond_2
    iget-wide v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->generation:J

    .line 318
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->finish()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 319
    nop

    .line 320
    nop

    .line 322
    nop

    .line 320
    return-wide v2

    .line 322
    :catchall_0
    move-exception v0

    move-object p1, v0

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->close()V

    .line 323
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

    .line 55
    if-eqz p1, :cond_4

    .line 58
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 59
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v1, :cond_3

    .line 63
    const/4 v1, 0x1

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->buildSession(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;

    move-result-object v1

    .line 64
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->confirmationToken:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 67
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->requiresDeletionConfirmation()Z

    move-result p1

    if-eqz p1, :cond_1

    if-eqz p2, :cond_0

    goto :goto_0

    .line 68
    :cond_0
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;

    iget-object p2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    invoke-direct {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;-><init>(II)V

    throw p1

    .line 71
    :cond_1
    :goto_0
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stage(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)J

    move-result-wide v3

    .line 74
    :try_start_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    .line 75
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleChanges()Ljava/util/List;

    move-result-object v2

    .line 74
    invoke-static {p1, p2, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->apply(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    move-result-object p1
    :try_end_0
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_0 .. :try_end_0} :catch_5
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException; {:try_start_0 .. :try_end_0} :catch_4
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/OutOfMemoryError; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 94
    nop

    .line 95
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleApplied()V

    .line 96
    iget-object p2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeChanges()Ljava/util/List;

    move-result-object v2

    invoke-static {p2, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->applyRimeChanges(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/util/List;)V

    .line 97
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-virtual {p2, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->publish(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/lang/String;)V

    .line 98
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markSnapshotPublished()V

    .line 99
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {p2, v3, v4, v5, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->commitStage(JJ)V

    .line 100
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

    .line 91
    :catch_0
    move-exception v0

    move-object p1, v0

    .line 92
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v0, 0x4

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 93
    throw p1

    .line 88
    :catch_1
    move-exception v0

    move-object p1, v0

    .line 89
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v0, 0x3

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 90
    throw p1

    .line 85
    :catch_2
    move-exception v0

    move-object p1, v0

    .line 86
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v0, 0x2

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 87
    throw p1

    .line 82
    :catch_3
    move-exception v0

    move-object p1, v0

    .line 83
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 84
    throw p1

    .line 79
    :catch_4
    move-exception v0

    move-object p1, v0

    .line 80
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeRejectedEntriesFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 81
    throw p1

    .line 76
    :catch_5
    move-exception v0

    move-object p1, v0

    .line 77
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {p2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 78
    throw p1

    .line 65
    :cond_2
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException;

    invoke-direct {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException;-><init>()V

    throw p1

    .line 60
    :cond_3
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p2, "unfinished Rime synchronization must be recovered before execution"

    invoke-direct {p1, p2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 56
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

    .line 43
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 44
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v1, :cond_0

    .line 48
    const/4 v1, 0x0

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->buildSession(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;

    move-result-object v0

    .line 49
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    invoke-direct {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)V

    return-object v1

    .line 45
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

    .line 161
    move-object/from16 v1, p0

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 162
    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v2, :cond_0

    .line 163
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

    .line 165
    :cond_0
    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_2

    iget-boolean v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    if-nez v2, :cond_1

    goto :goto_0

    .line 167
    :cond_1
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    invoke-direct {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;-><init>(I)V

    throw v2

    .line 169
    :cond_2
    :goto_0
    iget-wide v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    const-wide/16 v6, 0x1

    add-long v9, v4, v6

    .line 170
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->pendingOperations()Ljava/util/List;

    move-result-object v2

    .line 171
    nop

    .line 172
    nop

    .line 173
    nop

    .line 174
    nop

    .line 175
    nop

    .line 176
    iget v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v5, 0x3

    const/4 v6, 0x2

    const/4 v7, 0x0

    if-ne v4, v3, :cond_7

    .line 177
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 179
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

    .line 180
    iget-object v12, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v12, v13, :cond_3

    goto :goto_1

    .line 181
    :cond_3
    new-instance v12, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v13, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    iget-object v14, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    iget-object v15, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v12, v13, v14, v15}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    invoke-interface {v0, v12}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 183
    iget-object v12, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v12, v13, :cond_4

    add-int/lit8 v4, v4, 0x1

    .line 184
    :cond_4
    iget-object v11, v11, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v11, v12, :cond_5

    add-int/lit8 v8, v8, 0x1

    .line 185
    :cond_5
    goto :goto_1

    .line 187
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

    .line 207
    nop

    .line 208
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleApplied()V

    .line 209
    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    move v11, v4

    move v12, v8

    goto :goto_2

    .line 204
    :catch_0
    move-exception v0

    .line 205
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    const/4 v3, 0x4

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 206
    throw v0

    .line 201
    :catch_1
    move-exception v0

    .line 202
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 203
    throw v0

    .line 198
    :catch_2
    move-exception v0

    .line 199
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 200
    throw v0

    .line 195
    :catch_3
    move-exception v0

    .line 196
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 197
    throw v0

    .line 192
    :catch_4
    move-exception v0

    .line 193
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeRejectedEntriesFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 194
    throw v0

    .line 189
    :catch_5
    move-exception v0

    .line 190
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 191
    throw v0

    .line 176
    :cond_7
    const/4 v11, 0x0

    const/4 v12, 0x0

    .line 211
    :goto_2
    iget v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-ne v3, v6, :cond_d

    .line 212
    invoke-direct {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->loadMergedSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v3

    .line 213
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 215
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

    .line 216
    iget-object v14, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v14, v15, :cond_8

    goto :goto_3

    .line 217
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

    .line 220
    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v2, v5, :cond_9

    add-int/lit8 v7, v7, 0x1

    .line 221
    :cond_9
    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v2, v5, :cond_a

    add-int/lit8 v6, v18, 0x1

    goto :goto_4

    :cond_a
    move/from16 v6, v18

    .line 222
    :goto_4
    iget-object v2, v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v2, v5, :cond_b

    .line 223
    add-int/lit8 v8, v8, 0x1

    .line 225
    :cond_b
    move-object/from16 v2, v17

    const/4 v5, 0x3

    goto :goto_3

    .line 226
    :cond_c
    move/from16 v18, v6

    invoke-static {v3, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->applyRimeChanges(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/util/List;)V

    .line 227
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->safStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-virtual {v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->publish(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/lang/String;)V

    .line 228
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markSnapshotPublished()V

    .line 229
    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    move v13, v7

    move v15, v8

    move/from16 v14, v18

    goto :goto_5

    .line 211
    :cond_d
    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    .line 231
    :goto_5
    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x3

    if-ne v0, v2, :cond_e

    .line 234
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v0, v9, v10, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->commitStage(JJ)V

    .line 235
    new-instance v8, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    const/16 v16, 0x1

    invoke-direct/range {v8 .. v16}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;-><init>(JIIIIIZ)V

    return-object v8

    .line 232
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

    .line 107
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->requireProfile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 108
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

    .line 113
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->pendingOperations()Ljava/util/List;

    move-result-object v0

    .line 114
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 116
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    .line 117
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-eq v3, v4, :cond_0

    .line 118
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v3, v4, v5, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    invoke-interface {v1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 121
    :cond_0
    goto :goto_0

    .line 122
    :cond_1
    nop

    .line 124
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

    .line 136
    const/4 v2, 0x0

    goto :goto_1

    .line 133
    :catch_0
    move-exception v1

    .line 134
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 135
    throw v1

    .line 130
    :catch_1
    move-exception v0

    .line 131
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 132
    throw v0

    .line 127
    :catch_2
    move-exception v0

    .line 128
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 129
    throw v0

    .line 125
    :catch_3
    move-exception v2

    .line 126
    nop

    .line 136
    nop

    .line 137
    :goto_1
    if-nez v2, :cond_2

    .line 138
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleApplied()V

    .line 139
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->recover()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v0

    return-object v0

    .line 141
    :cond_2
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->verifyRecordedRejectedEntries(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 143
    :try_start_1
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->context:Landroid/content/Context;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->engineFactory:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v3, v4, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recoverKeepingRejected(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_1
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_1 .. :try_end_1} :catch_6
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException; {:try_start_1 .. :try_end_1} :catch_5
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_4

    .line 154
    nop

    .line 155
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->markGoogleAppliedWithRimeOnly(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 156
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->recover()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v0

    return-object v0

    .line 151
    :catch_4
    move-exception v1

    .line 152
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 153
    throw v1

    .line 148
    :catch_5
    move-exception v0

    .line 149
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    invoke-virtual {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativeOperationFailure(I)V

    .line 150
    throw v0

    .line 145
    :catch_6
    move-exception v0

    .line 146
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V

    .line 147
    throw v0

    .line 111
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
