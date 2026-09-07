.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.super Landroid/database/sqlite/SQLiteOpenHelper;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$IdentityConflictException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;
    }
.end annotation


# static fields
.field private static final DATABASE_NAME:Ljava/lang/String; = "rime_dictionary_sync.db"

.field private static final DATABASE_VERSION:I = 0x4

.field public static final NATIVE_FAILURE_IO:I = 0x2

.field public static final NATIVE_FAILURE_MEMORY:I = 0x3

.field public static final NATIVE_FAILURE_NONE:I = 0x0

.field public static final NATIVE_FAILURE_PERSISTENCE:I = 0x1

.field public static final NATIVE_FAILURE_RUNTIME:I = 0x4

.field public static final PHASE_GOOGLE_APPLIED:I = 0x2

.field public static final PHASE_IDLE:I = 0x0

.field public static final PHASE_PLANNED:I = 0x1

.field public static final PHASE_SNAPSHOT_PUBLISHED:I = 0x3

.field private static final PROFILE_ID:I = 0x1

.field private static final UTF_8:Ljava/nio/charset/Charset;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 24
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 3

    .line 38
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const/4 v0, 0x0

    const/4 v1, 0x4

    const-string v2, "rime_dictionary_sync.db"

    invoke-direct {p0, p1, v2, v0, v1}, Landroid/database/sqlite/SQLiteOpenHelper;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase$CursorFactory;I)V

    .line 39
    return-void
.end method

.method static synthetic access$100([BLjava/lang/String;)[B
    .locals 0

    .line 20
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$200([BI[B)I
    .locals 0

    .line 20
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->findHash([BI[B)I

    move-result p0

    return p0
.end method

.method static synthetic access$400([B)V
    .locals 0

    .line 20
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    return-void
.end method

.method private static clearNativeFailureAndSetGoogleApplied(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 5

    .line 371
    nop

    .line 376
    const/4 v0, 0x2

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v1, v0, v4

    aput-object v3, v0, v2

    .line 371
    const-string v1, "UPDATE profile SET phase=?, native_expected_count=0, native_actual_count=0, native_missing_count=0, native_failure_fingerprint=NULL, native_failure_repeated=0, native_failure_kind=0 WHERE id=?"

    invoke-virtual {p0, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 377
    return-void
.end method

.method private static clearSyncData(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 2

    .line 432
    const-string v0, "pending_operation"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 433
    const-string v0, "staged_baseline"

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 434
    const-string v0, "baseline"

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 435
    const-string v0, "profile"

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 436
    return-void
.end method

.method private static compareHash([BI[B)I
    .locals 4

    .line 561
    const/4 v0, 0x0

    const/4 v1, 0x0

    :goto_0
    const/16 v2, 0x20

    if-ge v1, v2, :cond_2

    .line 562
    add-int v2, p1, v1

    aget-byte v2, p0, v2

    and-int/lit16 v2, v2, 0xff

    .line 563
    aget-byte v3, p2, v1

    and-int/lit16 v3, v3, 0xff

    .line 564
    if-eq v2, v3, :cond_1

    if-ge v2, v3, :cond_0

    const/4 p0, -0x1

    goto :goto_1

    :cond_0
    const/4 p0, 0x1

    :goto_1
    return p0

    .line 561
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 566
    :cond_2
    return v0
.end method

.method private static findHash([BI[B)I
    .locals 3

    .line 548
    nop

    .line 549
    add-int/lit8 p1, p1, -0x1

    const/4 v0, 0x0

    .line 550
    :goto_0
    if-gt v0, p1, :cond_2

    .line 551
    add-int v1, v0, p1

    ushr-int/lit8 v1, v1, 0x1

    .line 552
    mul-int/lit8 v2, v1, 0x20

    invoke-static {p0, v2, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->compareHash([BI[B)I

    move-result v2

    .line 553
    if-gez v2, :cond_0

    add-int/lit8 v1, v1, 0x1

    move v0, v1

    goto :goto_1

    .line 554
    :cond_0
    if-lez v2, :cond_1

    add-int/lit8 v1, v1, -0x1

    move p1, v1

    .line 556
    :goto_1
    goto :goto_0

    .line 555
    :cond_1
    return v1

    .line 557
    :cond_2
    const/4 p0, -0x1

    return p0
.end method

.method private static hex([B)Ljava/lang/String;
    .locals 6

    .line 541
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    .line 542
    new-instance v0, Ljava/lang/StringBuilder;

    array-length v1, p0

    mul-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 543
    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_0

    aget-byte v4, p0, v3

    and-int/lit16 v4, v4, 0xff

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x1

    new-array v5, v5, [Ljava/lang/Object;

    aput-object v4, v5, v2

    const-string v4, "%02X"

    invoke-static {v4, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 544
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static keyHash([BLjava/lang/String;)[B
    .locals 1

    .line 524
    if-eqz p1, :cond_0

    .line 526
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 527
    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->update([B)V

    .line 528
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, p0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 529
    :catch_0
    move-exception p0

    .line 530
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "SHA-256 is unavailable"

    invoke-direct {p1, v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p1

    .line 524
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "canonical key is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static nativeFailureFingerprint([BLcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)[B
    .locals 5

    .line 500
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 501
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->missingKeys:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 502
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "missing\u0000"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 503
    goto :goto_0

    .line 504
    :cond_0
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->unexpectedKeys:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 505
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "unexpected\u0000"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 506
    goto :goto_1

    .line 507
    :cond_1
    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 509
    :try_start_0
    const-string p0, "SHA-256"

    invoke-static {p0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p0

    .line 510
    iget v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->expectedNativeCount:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update([B)V

    .line 511
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update(B)V

    .line 512
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->actualNativeCount:I

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/security/MessageDigest;->update([B)V

    .line 513
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 514
    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update(B)V

    .line 515
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update([B)V

    .line 516
    goto :goto_2

    .line 517
    :cond_2
    invoke-virtual {p0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 518
    :catch_0
    move-exception p0

    .line 519
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "SHA-256 is unavailable"

    invoke-direct {p1, v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_4

    :goto_3
    throw p1

    :goto_4
    goto :goto_3
.end method

.method private static nativeRejectedFingerprint([BLjava/util/List;)[B
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)[B"
        }
    .end annotation

    .line 480
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 481
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 482
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "rejected\u0000"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 483
    goto :goto_0

    .line 484
    :cond_0
    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 486
    :try_start_0
    const-string p0, "SHA-256"

    invoke-static {p0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p0

    .line 487
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/security/MessageDigest;->update([B)V

    .line 488
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 489
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update(B)V

    .line 490
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update([B)V

    .line 491
    goto :goto_1

    .line 492
    :cond_1
    invoke-virtual {p0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 493
    :catch_0
    move-exception p0

    .line 494
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "SHA-256 is unavailable"

    invoke-direct {p1, v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_3

    :goto_2
    throw p1

    :goto_3
    goto :goto_2
.end method

.method private static profileValues(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Landroid/content/ContentValues;
    .locals 3

    .line 439
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 440
    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 441
    const-string v1, "root_uri"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->rootUri:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 442
    const-string v1, "device_dir"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 443
    const-string v1, "snapshot_file"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 444
    const-string v1, "bridge_user_id"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 445
    const-string v1, "hash_salt"

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 446
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->protocolVersion:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "protocol_version"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 447
    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "generation"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 448
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "phase"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 449
    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->lastSuccess:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "last_success"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 450
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeExpectedCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_expected_count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 451
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeActualCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_actual_count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 452
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_missing_count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 453
    const-string v1, "native_failure_fingerprint"

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 454
    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_failure_repeated"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 455
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const-string v1, "native_failure_kind"

    invoke-virtual {v0, v1, p0}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 456
    return-object v0
.end method

.method private static readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 22

    .line 460
    const/16 v0, 0xf

    new-array v3, v0, [Ljava/lang/String;

    const/4 v0, 0x0

    const-string v1, "root_uri"

    aput-object v1, v3, v0

    const/4 v9, 0x1

    const-string v1, "device_dir"

    aput-object v1, v3, v9

    const/4 v10, 0x2

    const-string v1, "snapshot_file"

    aput-object v1, v3, v10

    const/4 v11, 0x3

    const-string v1, "bridge_user_id"

    aput-object v1, v3, v11

    const/4 v12, 0x4

    const-string v1, "hash_salt"

    aput-object v1, v3, v12

    const/4 v13, 0x5

    const-string v1, "protocol_version"

    aput-object v1, v3, v13

    const/4 v14, 0x6

    const-string v1, "generation"

    aput-object v1, v3, v14

    const/4 v15, 0x7

    const-string v1, "phase"

    aput-object v1, v3, v15

    const/16 v1, 0x8

    const-string v2, "last_success"

    aput-object v2, v3, v1

    const/16 v2, 0x9

    const-string v4, "native_expected_count"

    aput-object v4, v3, v2

    const/16 v4, 0xa

    const-string v5, "native_actual_count"

    aput-object v5, v3, v4

    const/16 v5, 0xb

    const-string v6, "native_missing_count"

    aput-object v6, v3, v5

    const/16 v6, 0xc

    const-string v7, "native_failure_fingerprint"

    aput-object v7, v3, v6

    const/16 v7, 0xd

    const-string v8, "native_failure_repeated"

    aput-object v8, v3, v7

    const/16 v8, 0xe

    const-string v16, "native_failure_kind"

    aput-object v16, v3, v8

    .line 466
    invoke-static {v9}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v16

    const/16 v17, 0xb

    new-array v5, v9, [Ljava/lang/String;

    aput-object v16, v5, v0

    .line 460
    const/16 v16, 0x9

    const-string v2, "profile"

    const/16 v18, 0xa

    const-string v4, "id=?"

    const/16 v19, 0xc

    const/4 v6, 0x0

    const/16 v20, 0xd

    const/4 v7, 0x0

    const/16 v21, 0xe

    const/4 v8, 0x0

    move-object/from16 v1, p0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 468
    :try_start_0
    invoke-interface {v1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v2, :cond_0

    .line 475
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 468
    const/4 v0, 0x0

    return-object v0

    .line 469
    :cond_0
    :try_start_1
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    invoke-interface {v1, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 470
    invoke-interface {v1, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v6

    invoke-interface {v1, v12}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v7

    invoke-interface {v1, v13}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    invoke-interface {v1, v14}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v10

    .line 471
    invoke-interface {v1, v15}, Landroid/database/Cursor;->getInt(I)I

    move-result v12

    const/16 v13, 0x8

    invoke-interface {v1, v13}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v13

    const/16 v15, 0x9

    invoke-interface {v1, v15}, Landroid/database/Cursor;->getInt(I)I

    move-result v15

    const/16 v0, 0xa

    invoke-interface {v1, v0}, Landroid/database/Cursor;->getInt(I)I

    move-result v0

    .line 472
    const/16 v9, 0xb

    invoke-interface {v1, v9}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    move/from16 p0, v0

    const/16 v0, 0xc

    invoke-interface {v1, v0}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v0

    move-object/from16 v18, v0

    const/16 v0, 0xd

    invoke-interface {v1, v0}, Landroid/database/Cursor;->getInt(I)I

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    .line 473
    :goto_0
    move/from16 v16, v0

    const/16 v0, 0xe

    invoke-interface {v1, v0}, Landroid/database/Cursor;->getInt(I)I

    move-result v19

    move-object/from16 v17, v18

    move/from16 v18, v16

    move/from16 v16, v9

    move-wide v9, v10

    move v11, v12

    move-wide v12, v13

    move v14, v15

    move/from16 v15, p0

    invoke-direct/range {v2 .. v19}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[BIJIJIII[BZI)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 475
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 469
    return-object v2

    .line 475
    :catchall_0
    move-exception v0

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 476
    throw v0
.end method

.method private static requireHash([B)V
    .locals 1

    .line 535
    if-eqz p0, :cond_0

    array-length p0, p0

    const/16 v0, 0x20

    if-ne p0, v0, :cond_0

    .line 538
    return-void

    .line 536
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime synchronization key hash is invalid"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private requirePhase(I)V
    .locals 1

    .line 420
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 421
    if-eqz v0, :cond_0

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-ne v0, p1, :cond_0

    .line 424
    return-void

    .line 422
    :cond_0
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "unexpected Rime synchronization phase"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private setPhase(I)V
    .locals 5

    .line 427
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 428
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object p1, v3, v4

    aput-object v2, v3, v1

    .line 427
    const-string p1, "UPDATE profile SET phase=? WHERE id=?"

    invoke-virtual {v0, p1, v3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 429
    return-void
.end method


# virtual methods
.method public declared-synchronized baseline([B)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;
    .locals 4

    monitor-enter p0

    .line 164
    :try_start_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    .line 165
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "SELECT history, google_projection, rime_abs_count FROM baseline WHERE key_hash=X\'"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 167
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "\'"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 165
    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->rawQuery(Ljava/lang/String;[Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 169
    :try_start_1
    invoke-interface {p1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 170
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;

    invoke-interface {p1, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-result-object v1

    .line 171
    const/4 v2, 0x1

    invoke-interface {p1, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-result-object v2

    .line 172
    const/4 v3, 0x2

    invoke-interface {p1, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    invoke-direct {v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    goto :goto_0

    .line 173
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-direct {v0, v2, v3, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_0
    nop

    .line 176
    :try_start_2
    invoke-interface {p1}, Landroid/database/Cursor;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 169
    monitor-exit p0

    return-object v0

    .line 176
    :catchall_0
    move-exception v0

    :try_start_3
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    .line 177
    throw v0

    .line 163
    :catchall_1
    move-exception p1

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    throw p1
.end method

.method public declared-synchronized baselineLookup()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;
    .locals 24

    monitor-enter p0

    .line 190
    :try_start_0
    invoke-virtual/range {p0 .. p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 191
    if-eqz v0, :cond_1

    .line 192
    invoke-virtual/range {p0 .. p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    const-string v2, "baseline"

    const/4 v3, 0x4

    new-array v3, v3, [Ljava/lang/String;

    const-string v4, "key_hash"

    const/4 v9, 0x0

    aput-object v4, v3, v9

    const-string v4, "history"

    const/4 v10, 0x1

    aput-object v4, v3, v10

    const-string v4, "google_projection"

    const/4 v11, 0x2

    aput-object v4, v3, v11

    const-string v4, "rime_abs_count"

    const/4 v12, 0x3

    aput-object v4, v3, v12

    const-string v8, "key_hash"

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 195
    invoke-interface {v1}, Landroid/database/Cursor;->getCount()I

    move-result v2

    .line 196
    mul-int/lit8 v3, v2, 0x20

    new-array v15, v3, [B

    .line 197
    new-array v3, v2, [B

    .line 198
    new-array v4, v2, [B

    .line 199
    new-array v5, v2, [I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 200
    const/4 v6, 0x0

    .line 202
    :goto_0
    :try_start_1
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v7

    if-eqz v7, :cond_0

    .line 203
    invoke-interface {v1, v9}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v7

    .line 204
    invoke-static {v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    .line 205
    mul-int/lit8 v8, v6, 0x20

    const/16 v13, 0x20

    invoke-static {v7, v9, v15, v8, v13}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 206
    nop

    .line 207
    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    .line 206
    invoke-static {v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-result-object v7

    .line 207
    invoke-virtual {v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->ordinal()I

    move-result v7

    int-to-byte v7, v7

    aput-byte v7, v3, v6

    .line 208
    nop

    .line 209
    invoke-interface {v1, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    .line 208
    invoke-static {v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-result-object v7

    .line 209
    invoke-virtual {v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->ordinal()I

    move-result v7

    int-to-byte v7, v7

    aput-byte v7, v4, v6

    .line 210
    invoke-interface {v1, v12}, Landroid/database/Cursor;->getInt(I)I

    move-result v7

    aput v7, v5, v6
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 211
    add-int/lit8 v6, v6, 0x1

    .line 212
    goto :goto_0

    .line 214
    :cond_0
    :try_start_2
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 215
    nop

    .line 216
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-virtual {v0}, [B->clone()Ljava/lang/Object;

    move-result-object v0

    move-object/from16 v17, v0

    check-cast v17, [B

    .line 217
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-direct {v0, v1, v6, v9}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 220
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-result-object v19

    .line 222
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-result-object v21

    .line 223
    new-instance v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;

    move-object/from16 v14, p0

    move-object/from16 v18, v0

    move/from16 v16, v2

    move-object/from16 v20, v3

    move-object/from16 v22, v4

    move-object/from16 v23, v5

    invoke-direct/range {v13 .. v23}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;[BI[BLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;[B[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;[B[I)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    monitor-exit p0

    return-object v13

    .line 214
    :catchall_0
    move-exception v0

    :try_start_3
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 215
    throw v0

    .line 191
    :cond_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime profile is not configured"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 189
    :catchall_1
    move-exception v0

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    :goto_1
    throw v0

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized beginStage()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;
    .locals 7

    monitor-enter p0

    .line 234
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 235
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 236
    if-eqz v1, :cond_1

    .line 237
    iget v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v2, :cond_0

    .line 240
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    .line 241
    const-string v2, "staged_baseline"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 242
    const-string v2, "pending_operation"

    invoke-virtual {v0, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 243
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;

    iget-wide v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    const-wide/16 v5, 0x1

    add-long/2addr v3, v5

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    invoke-direct {v2, v0, v3, v4, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Stage;-><init>(Landroid/database/sqlite/SQLiteDatabase;J[B)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v2

    .line 238
    :cond_0
    :try_start_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "an unfinished Rime synchronization must be recovered"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 236
    :cond_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime profile is not configured"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 233
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized commitStage(JJ)V
    .locals 6

    monitor-enter p0

    .line 385
    const/4 v0, 0x3

    :try_start_0
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requirePhase(I)V

    .line 386
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 387
    if-eqz v1, :cond_0

    iget-wide v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    cmp-long v3, p1, v1

    if-nez v3, :cond_0

    .line 390
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    .line 391
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 393
    :try_start_1
    const-string v2, "baseline"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 394
    const-string v2, "INSERT INTO baseline(key_hash, history, google_projection, rime_abs_count) SELECT key_hash, history, google_projection, rime_abs_count FROM staged_baseline"

    invoke-virtual {v1, v2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 397
    const-string v2, "staged_baseline"

    invoke-virtual {v1, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 398
    const-string v2, "pending_operation"

    invoke-virtual {v1, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 399
    const-string v2, "UPDATE profile SET generation=?, phase=?, last_success=? WHERE id=?"

    .line 400
    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    const/4 p2, 0x0

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-static {p3, p4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p3

    const/4 p4, 0x1

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x4

    new-array v5, v5, [Ljava/lang/Object;

    aput-object p1, v5, p2

    aput-object v3, v5, p4

    const/4 p1, 0x2

    aput-object p3, v5, p1

    aput-object v4, v5, v0

    .line 399
    invoke-virtual {v1, v2, v5}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 401
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 403
    :try_start_2
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 404
    nop

    .line 405
    monitor-exit p0

    return-void

    .line 403
    :catchall_0
    move-exception p1

    :try_start_3
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 404
    throw p1

    .line 388
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime synchronization generation is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 384
    :catchall_1
    move-exception p1

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    throw p1
.end method

.method public declared-synchronized configure(Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 19

    move-object/from16 v1, p1

    move-object/from16 v0, p2

    move/from16 v6, p3

    move-object/from16 v2, p4

    monitor-enter p0

    .line 94
    if-eqz v1, :cond_9

    :try_start_0
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    if-eqz v3, :cond_9

    if-eqz v0, :cond_9

    if-lez v6, :cond_9

    .line 98
    invoke-virtual/range {p0 .. p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v3

    .line 99
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v4

    .line 100
    if-eqz v4, :cond_4

    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    iget-object v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    .line 101
    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4

    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    iget-object v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    .line 102
    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4

    iget v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->protocolVersion:I

    if-ne v5, v6, :cond_4

    .line 104
    if-eqz v2, :cond_1

    iget-object v0, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    .line 105
    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 106
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$IdentityConflictException;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$IdentityConflictException;-><init>()V

    throw v0

    .line 108
    :cond_1
    :goto_0
    iget-object v0, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->rootUri:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    if-eqz v0, :cond_2

    monitor-exit p0

    return-object v4

    .line 109
    :cond_2
    :try_start_1
    iget v0, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v0, :cond_3

    .line 115
    const-string v0, "UPDATE profile SET root_uri=? WHERE id=?"

    .line 116
    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Object;

    const/4 v6, 0x0

    aput-object v1, v5, v6

    aput-object v4, v5, v2

    .line 115
    invoke-virtual {v3, v0, v5}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 117
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    monitor-exit p0

    return-object v0

    .line 110
    :cond_3
    :try_start_2
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "unfinished Rime synchronization must be recovered before relocation"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 119
    :cond_4
    if-eqz v4, :cond_6

    iget v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v4, :cond_5

    goto :goto_1

    .line 120
    :cond_5
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "unfinished Rime synchronization must be recovered before reconfiguration"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 123
    :cond_6
    :goto_1
    const/16 v4, 0x20

    new-array v5, v4, [B

    .line 124
    new-instance v4, Ljava/security/SecureRandom;

    invoke-direct {v4}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v4, v5}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 125
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v4
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    .line 126
    if-eqz v2, :cond_8

    .line 128
    :try_start_3
    invoke-static {v2}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v4

    .line 129
    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_7

    .line 132
    nop

    .line 136
    move-object v4, v2

    goto :goto_2

    .line 130
    :cond_7
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "non-canonical UUID"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 133
    :catch_0
    move-exception v0

    .line 134
    :try_start_4
    new-instance v1, Ljava/lang/IllegalArgumentException;

    const-string v2, "recovered Bridge snapshot identity is invalid"

    invoke-direct {v1, v2, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1

    .line 138
    :cond_8
    :goto_2
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-object v7, v2

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    const/16 v16, 0x0

    const/16 v17, 0x0

    move-object v9, v3

    move-object v3, v0

    move-object v0, v7

    const-wide/16 v7, 0x0

    move-object v10, v9

    const/4 v9, 0x0

    move-object v12, v10

    const-wide/16 v10, 0x0

    move-object v13, v12

    const/4 v12, 0x0

    move-object v14, v13

    const/4 v13, 0x0

    move-object v15, v14

    const/4 v14, 0x0

    move-object/from16 v18, v15

    const/4 v15, 0x0

    move-object/from16 p2, v18

    invoke-direct/range {v0 .. v17}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[BIJIJIII[BZI)V

    .line 142
    invoke-virtual/range {p2 .. p2}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    .line 144
    :try_start_5
    invoke-static/range {p2 .. p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->clearSyncData(Landroid/database/sqlite/SQLiteDatabase;)V

    .line 145
    const-string v1, "profile"

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profileValues(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Landroid/content/ContentValues;

    move-result-object v2
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    const/4 v3, 0x0

    move-object/from16 v12, p2

    :try_start_6
    invoke-virtual {v12, v1, v3, v2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    .line 146
    invoke-virtual {v12}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    .line 148
    :try_start_7
    invoke-virtual {v12}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_2

    .line 149
    nop

    .line 150
    monitor-exit p0

    return-object v0

    .line 148
    :catchall_0
    move-exception v0

    goto :goto_3

    :catchall_1
    move-exception v0

    move-object/from16 v12, p2

    :goto_3
    :try_start_8
    invoke-virtual {v12}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 149
    throw v0

    .line 96
    :cond_9
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Rime synchronization profile is invalid"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 93
    :catchall_2
    move-exception v0

    monitor-exit p0
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_2

    throw v0
.end method

.method public keyHash(Ljava/lang/String;)[B
    .locals 1

    .line 182
    if-eqz p1, :cond_1

    .line 183
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 184
    if-eqz v0, :cond_0

    .line 185
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object p1

    return-object p1

    .line 184
    :cond_0
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Rime profile is not configured"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 182
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "canonical key is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public declared-synchronized markGoogleApplied()V
    .locals 1

    monitor-enter p0

    .line 341
    const/4 v0, 0x1

    :try_start_0
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requirePhase(I)V

    .line 342
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->clearNativeFailureAndSetGoogleApplied(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 343
    monitor-exit p0

    return-void

    .line 340
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized markGoogleAppliedWithRimeOnly(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V
    .locals 7

    monitor-enter p0

    .line 348
    :try_start_0
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->verifyRecordedRejectedEntries(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 349
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 350
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 351
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 353
    :try_start_1
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    .line 354
    const-string v3, "google_projection"

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->name()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 355
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedKeys:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 356
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v4

    invoke-static {v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object v3

    .line 357
    const-string v4, "staged_baseline"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "key_hash=X\'"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 358
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "\'"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 357
    const/4 v5, 0x0

    invoke-virtual {v0, v4, v2, v3, v5}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v3

    .line 359
    const/4 v4, 0x1

    if-ne v3, v4, :cond_0

    .line 362
    goto :goto_0

    .line 360
    :cond_0
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v1, "rejected entry is absent from staged baseline"

    invoke-direct {p1, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 363
    :cond_1
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->clearNativeFailureAndSetGoogleApplied(Landroid/database/sqlite/SQLiteDatabase;)V

    .line 364
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 366
    :try_start_2
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 367
    nop

    .line 368
    monitor-exit p0

    return-void

    .line 366
    :catchall_0
    move-exception p1

    :try_start_3
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 367
    throw p1

    .line 347
    :catchall_1
    move-exception p1

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    :goto_1
    throw p1

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized markSnapshotPublished()V
    .locals 1

    monitor-enter p0

    .line 380
    const/4 v0, 0x2

    :try_start_0
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requirePhase(I)V

    .line 381
    const/4 v0, 0x3

    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->setPhase(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 382
    monitor-exit p0

    return-void

    .line 379
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public onCreate(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 1

    .line 42
    const-string v0, "CREATE TABLE profile (id INTEGER PRIMARY KEY, root_uri TEXT NOT NULL, device_dir TEXT NOT NULL, snapshot_file TEXT NOT NULL, bridge_user_id TEXT NOT NULL, hash_salt BLOB NOT NULL, protocol_version INTEGER NOT NULL, generation INTEGER NOT NULL, phase INTEGER NOT NULL, last_success INTEGER NOT NULL, native_expected_count INTEGER NOT NULL DEFAULT 0, native_actual_count INTEGER NOT NULL DEFAULT 0, native_missing_count INTEGER NOT NULL DEFAULT 0, native_failure_fingerprint BLOB, native_failure_repeated INTEGER NOT NULL DEFAULT 0, native_failure_kind INTEGER NOT NULL DEFAULT 0)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 53
    const-string v0, "CREATE TABLE baseline (key_hash BLOB PRIMARY KEY, history TEXT NOT NULL, google_projection TEXT NOT NULL, rime_abs_count INTEGER NOT NULL)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 55
    const-string v0, "CREATE TABLE staged_baseline (key_hash BLOB PRIMARY KEY, history TEXT NOT NULL, google_projection TEXT NOT NULL, rime_abs_count INTEGER NOT NULL)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 58
    const-string v0, "CREATE TABLE pending_operation (sequence INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT NOT NULL, phrase TEXT NOT NULL, google_action TEXT NOT NULL, rime_action TEXT NOT NULL, rime_commit_value INTEGER NOT NULL)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 61
    return-void
.end method

.method public onUpgrade(Landroid/database/sqlite/SQLiteDatabase;II)V
    .locals 1

    .line 64
    const/4 v0, 0x1

    if-lt p2, v0, :cond_3

    const/4 v0, 0x4

    if-ne p3, v0, :cond_3

    .line 68
    const/4 p3, 0x2

    if-ge p2, p3, :cond_0

    .line 69
    const-string p3, "ALTER TABLE profile ADD COLUMN native_expected_count INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 71
    const-string p3, "ALTER TABLE profile ADD COLUMN native_actual_count INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 73
    const-string p3, "ALTER TABLE profile ADD COLUMN native_missing_count INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 75
    const-string p3, "ALTER TABLE profile ADD COLUMN native_failure_fingerprint BLOB"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 76
    const-string p3, "ALTER TABLE profile ADD COLUMN native_failure_repeated INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 79
    :cond_0
    const/4 p3, 0x3

    if-ge p2, p3, :cond_1

    .line 80
    const-string p3, "ALTER TABLE profile ADD COLUMN native_failure_kind INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 83
    :cond_1
    if-ge p2, v0, :cond_2

    .line 84
    const-string p2, "ALTER TABLE baseline ADD COLUMN google_projection TEXT NOT NULL DEFAULT \'SUPPORTED\'"

    invoke-virtual {p1, p2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 86
    const-string p2, "ALTER TABLE staged_baseline ADD COLUMN google_projection TEXT NOT NULL DEFAULT \'SUPPORTED\'"

    invoke-virtual {p1, p2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 89
    :cond_2
    return-void

    .line 65
    :cond_3
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p2, "Rime synchronization state requires an explicit migration"

    invoke-direct {p1, p2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public declared-synchronized pendingOperations()Ljava/util/List;
    .locals 14
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;",
            ">;"
        }
    .end annotation

    monitor-enter p0

    .line 247
    :try_start_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 248
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    const-string v2, "pending_operation"

    const/4 v3, 0x5

    new-array v3, v3, [Ljava/lang/String;

    const-string v4, "code"

    const/4 v9, 0x0

    aput-object v4, v3, v9

    const-string v4, "phrase"

    const/4 v10, 0x1

    aput-object v4, v3, v10

    const-string v4, "google_action"

    const/4 v11, 0x2

    aput-object v4, v3, v11

    const-string v4, "rime_action"

    const/4 v12, 0x3

    aput-object v4, v3, v12

    const-string v4, "rime_commit_value"

    const/4 v13, 0x4

    aput-object v4, v3, v13

    const-string v8, "sequence"

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 252
    :goto_0
    :try_start_1
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 253
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 254
    invoke-interface {v1, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    move-result-object v6

    .line 255
    invoke-interface {v1, v12}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    move-result-object v7

    .line 256
    invoke-interface {v1, v13}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    invoke-direct/range {v3 .. v8}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    .line 253
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 259
    :cond_0
    :try_start_2
    invoke-interface {v1}, Landroid/database/Cursor;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 260
    nop

    .line 261
    monitor-exit p0

    return-object v0

    .line 259
    :catchall_0
    move-exception v0

    :try_start_3
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 260
    throw v0

    .line 246
    :catchall_1
    move-exception v0

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    :goto_1
    throw v0

    :goto_2
    goto :goto_1
.end method

.method public declared-synchronized profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 1

    monitor-enter p0

    .line 160
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    .line 160
    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public declared-synchronized recordNativeOperationFailure(I)V
    .locals 8

    monitor-enter p0

    .line 324
    const/4 v0, 0x2

    if-lt p1, v0, :cond_3

    const/16 v1, 0xb

    if-gt p1, v1, :cond_3

    .line 328
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 329
    if-eqz v1, :cond_2

    iget v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_2

    .line 332
    iget v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    const/4 v2, 0x0

    if-ne v1, p1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    .line 333
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v4

    const-string v5, "UPDATE profile SET native_expected_count=0, native_actual_count=0, native_missing_count=0, native_failure_fingerprint=NULL, native_failure_repeated=?, native_failure_kind=? WHERE id=?"

    .line 337
    if-eqz v1, :cond_1

    const/4 v1, 0x1

    goto :goto_1

    :cond_1
    const/4 v1, 0x0

    :goto_1
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    const/4 v7, 0x3

    new-array v7, v7, [Ljava/lang/Object;

    aput-object v1, v7, v2

    aput-object p1, v7, v3

    aput-object v6, v7, v0

    .line 333
    invoke-virtual {v4, v5, v7}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 338
    monitor-exit p0

    return-void

    .line 330
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native failure requires a planned synchronization"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 326
    :cond_3
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native failure kind is invalid"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 323
    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized recordNativePersistenceFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)V
    .locals 11

    monitor-enter p0

    .line 267
    if-eqz p1, :cond_3

    .line 268
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 269
    if-eqz v0, :cond_2

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x1

    if-ne v1, v2, :cond_2

    .line 272
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->nativeFailureFingerprint([BLcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)[B

    move-result-object v1

    .line 273
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v3

    const/4 v4, 0x0

    if-eqz v3, :cond_0

    .line 274
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 275
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v3

    const-string v5, "UPDATE profile SET native_expected_count=?, native_actual_count=?, native_missing_count=?, native_failure_fingerprint=?, native_failure_repeated=?, native_failure_kind=? WHERE id=?"

    iget v6, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->expectedNativeCount:I

    .line 279
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    iget v7, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->actualNativeCount:I

    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->missingCount:I

    .line 280
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    goto :goto_1

    :cond_1
    const/4 v0, 0x0

    :goto_1
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    .line 281
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    const/4 v10, 0x7

    new-array v10, v10, [Ljava/lang/Object;

    aput-object v6, v10, v4

    aput-object v7, v10, v2

    const/4 v2, 0x2

    aput-object p1, v10, v2

    const/4 p1, 0x3

    aput-object v1, v10, p1

    const/4 p1, 0x4

    aput-object v0, v10, p1

    const/4 p1, 0x5

    aput-object v8, v10, p1

    const/4 p1, 0x6

    aput-object v9, v10, p1

    .line 275
    invoke-virtual {v3, v5, v10}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 282
    monitor-exit p0

    return-void

    .line 270
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native failure requires a planned synchronization"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 266
    :catchall_0
    move-exception p1

    goto :goto_2

    .line 267
    :cond_3
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native failure is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 266
    :goto_2
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized recordNativeRejectedEntriesFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V
    .locals 9

    monitor-enter p0

    .line 287
    if-eqz p1, :cond_3

    .line 288
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 289
    if-eqz v0, :cond_2

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x1

    if-ne v1, v2, :cond_2

    .line 292
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    iget-object v3, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedKeys:Ljava/util/List;

    invoke-static {v1, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->nativeRejectedFingerprint([BLjava/util/List;)[B

    move-result-object v1

    .line 293
    iget v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    const/4 v4, 0x6

    const/4 v5, 0x0

    if-ne v3, v4, :cond_0

    .line 295
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v3

    if-eqz v3, :cond_0

    .line 296
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 297
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v3

    const-string v6, "UPDATE profile SET native_expected_count=0, native_actual_count=0, native_missing_count=?, native_failure_fingerprint=?, native_failure_repeated=?, native_failure_kind=? WHERE id=?"

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedCount:I

    .line 301
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    goto :goto_1

    :cond_1
    const/4 v0, 0x0

    :goto_1
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    .line 302
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    const/4 v8, 0x5

    new-array v8, v8, [Ljava/lang/Object;

    aput-object p1, v8, v5

    aput-object v1, v8, v2

    const/4 p1, 0x2

    aput-object v0, v8, p1

    const/4 p1, 0x3

    aput-object v4, v8, p1

    const/4 p1, 0x4

    aput-object v7, v8, p1

    .line 297
    invoke-virtual {v3, v6, v8}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 303
    monitor-exit p0

    return-void

    .line 290
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native rejection requires a planned synchronization"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 286
    :catchall_0
    move-exception p1

    goto :goto_2

    .line 287
    :cond_3
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native rejection is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 286
    :goto_2
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized resetBaseline()V
    .locals 5

    monitor-enter p0

    .line 408
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 409
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 410
    if-nez v1, :cond_0

    monitor-exit p0

    return-void

    .line 411
    :cond_0
    :try_start_1
    iget v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v1, :cond_1

    .line 414
    const-string v1, "baseline"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2, v2}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 415
    const-string v1, "UPDATE profile SET generation=0, last_success=0 WHERE id=?"

    .line 416
    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    .line 415
    invoke-virtual {v0, v1, v2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 417
    monitor-exit p0

    return-void

    .line 412
    :cond_1
    :try_start_2
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "unfinished Rime synchronization cannot be reset"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 407
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v0
.end method

.method public declared-synchronized verifyRecordedRejectedEntries(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V
    .locals 4

    monitor-enter p0

    .line 308
    if-eqz p1, :cond_2

    .line 309
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 310
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    .line 311
    :cond_0
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedKeys:Ljava/util/List;

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->nativeRejectedFingerprint([BLjava/util/List;)[B

    move-result-object v1

    .line 312
    :goto_0
    if-eqz v0, :cond_1

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_1

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    const/4 v3, 0x6

    if-ne v2, v3, :cond_1

    iget-boolean v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    if-eqz v2, :cond_1

    iget v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedCount:I

    if-ne v2, p1, :cond_1

    .line 316
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object p1

    if-eqz p1, :cond_1

    .line 317
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object p1

    invoke-static {p1, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p1, :cond_1

    .line 320
    monitor-exit p0

    return-void

    .line 318
    :cond_1
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native rejected entry set changed"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 307
    :catchall_0
    move-exception p1

    goto :goto_1

    .line 308
    :cond_2
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native rejection is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 307
    :goto_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method
