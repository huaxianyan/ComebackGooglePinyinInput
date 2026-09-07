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

    .line 602
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 603
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    .line 604
    iput-wide p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->generation:J

    .line 605
    invoke-virtual {p4}, [B->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->hashSalt:[B

    .line 606
    return-void
.end method

.method private ensureOpen()V
    .locals 2

    .line 657
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->closed:Z

    if-nez v0, :cond_0

    .line 658
    return-void

    .line 657
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime synchronization stage is closed"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public close()V
    .locals 1

    .line 651
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 652
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->closed:Z

    .line 653
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 654
    return-void
.end method

.method public finish()V
    .locals 5

    .line 643
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->ensureOpen()V

    .line 644
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    .line 645
    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v2, v3, v4

    aput-object v2, v3, v1

    .line 644
    const-string v1, "UPDATE profile SET phase=? WHERE id=?"

    invoke-virtual {v0, v1, v3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 646
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V

    .line 647
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->close()V

    .line 648
    return-void
.end method

.method public putBaseline(Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 1

    .line 610
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->hashSalt:[B

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$100([BLjava/lang/String;)[B

    move-result-object p1

    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->putBaseline([BLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 612
    return-void
.end method

.method public putBaseline([BLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 2

    .line 616
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->ensureOpen()V

    .line 617
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$400([B)V

    .line 618
    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    if-ltz p4, :cond_0

    .line 621
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 622
    const-string v1, "key_hash"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 623
    const-string p1, "history"

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->name()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 624
    const-string p1, "google_projection"

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->name()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 625
    const-string p1, "rime_abs_count"

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 626
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p2, 0x0

    const/4 p3, 0x5

    const-string p4, "staged_baseline"

    invoke-virtual {p1, p4, p2, v0, p3}, Landroid/database/sqlite/SQLiteDatabase;->insertWithOnConflict(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;I)J

    .line 628
    return-void

    .line 619
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "staged baseline is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public putOperation(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;)V
    .locals 3

    .line 631
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->ensureOpen()V

    .line 632
    if-eqz p1, :cond_0

    .line 633
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 634
    const-string v1, "code"

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 635
    const-string v1, "phrase"

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 636
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->name()Ljava/lang/String;

    move-result-object v1

    const-string v2, "google_action"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 637
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->name()Ljava/lang/String;

    move-result-object v1

    const-string v2, "rime_action"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 638
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeCommitValue:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v1, "rime_commit_value"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 639
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;->db:Landroid/database/sqlite/SQLiteDatabase;

    const-string v1, "pending_operation"

    const/4 v2, 0x0

    invoke-virtual {p1, v1, v2, v0}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    .line 640
    return-void

    .line 632
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "operation is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
