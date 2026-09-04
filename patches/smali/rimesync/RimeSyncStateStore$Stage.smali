.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;
.super Ljava/lang/Object;
.source "RimeSyncStateStore.java"

# interfaces
.implements Ljava/io/Closeable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Stage"
.end annotation


# instance fields
.field private closed:Z

.field private final db:Landroid/database/sqlite/SQLiteDatabase;

.field public final generation:J

.field private final hashSalt:[B


# direct methods
.method constructor <init>(Landroid/database/sqlite/SQLiteDatabase;J[B)V
    .locals 0

    .line 524
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 525
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    .line 526
    iput-wide p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->generation:J

    .line 527
    invoke-virtual {p4}, [B->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->hashSalt:[B

    .line 528
    return-void
.end method

.method private ensureOpen()V
    .locals 2

    .line 579
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->closed:Z

    if-nez v0, :cond_0

    .line 580
    return-void

    .line 579
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime synchronization stage is closed"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public close()V
    .locals 1

    .line 573
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 574
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->closed:Z

    .line 575
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 576
    return-void
.end method

.method public finish()V
    .locals 5

    .line 565
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->ensureOpen()V

    .line 566
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    .line 567
    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v2, v3, v4

    aput-object v2, v3, v1

    .line 566
    const-string v1, "UPDATE profile SET phase=? WHERE id=?"

    invoke-virtual {v0, v1, v3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 568
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V

    .line 569
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->close()V

    .line 570
    return-void
.end method

.method public putBaseline(Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 1

    .line 532
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->hashSalt:[B

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$100([BLjava/lang/String;)[B

    move-result-object p1

    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->putBaseline([BLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 534
    return-void
.end method

.method public putBaseline([BLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 2

    .line 538
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->ensureOpen()V

    .line 539
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$400([B)V

    .line 540
    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    if-ltz p4, :cond_0

    .line 543
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 544
    const-string v1, "key_hash"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 545
    const-string p1, "history"

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->name()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 546
    const-string p1, "google_projection"

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->name()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 547
    const-string p1, "rime_abs_count"

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 548
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p2, 0x0

    const/4 p3, 0x5

    const-string p4, "staged_baseline"

    invoke-virtual {p1, p4, p2, v0, p3}, Landroid/database/sqlite/SQLiteDatabase;->insertWithOnConflict(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;I)J

    .line 550
    return-void

    .line 541
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "staged baseline is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public putOperation(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;)V
    .locals 3

    .line 553
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->ensureOpen()V

    .line 554
    if-eqz p1, :cond_0

    .line 555
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 556
    const-string v1, "code"

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 557
    const-string v1, "phrase"

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 558
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->name()Ljava/lang/String;

    move-result-object v1

    const-string v2, "google_action"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 559
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->name()Ljava/lang/String;

    move-result-object v1

    const-string v2, "rime_action"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 560
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeCommitValue:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v1, "rime_commit_value"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 561
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    const-string v1, "pending_operation"

    const/4 v2, 0x0

    invoke-virtual {p1, v1, v2, v0}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    .line 562
    return-void

    .line 554
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "operation is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
