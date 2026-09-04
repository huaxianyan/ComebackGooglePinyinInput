.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.super Landroid/database/sqlite/SQLiteOpenHelper;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;,
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

    .line 26
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 3

    .line 40
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    const/4 v0, 0x0

    const/4 v1, 0x4

    const-string v2, "rime_dictionary_sync.db"

    invoke-direct {p0, p1, v2, v0, v1}, Landroid/database/sqlite/SQLiteOpenHelper;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase$CursorFactory;I)V

    .line 41
    return-void
.end method

.method static synthetic access$100([BLjava/lang/String;)[B
    .locals 0

    .line 22
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$200([B)Ljava/lang/String;
    .locals 0

    .line 22
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$400([B)V
    .locals 0

    .line 22
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    return-void
.end method

.method private static clearNativeFailureAndSetGoogleApplied(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 5

    .line 342
    nop

    .line 347
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

    .line 342
    const-string v1, "UPDATE profile SET phase=?, native_expected_count=0, native_actual_count=0, native_missing_count=0, native_failure_fingerprint=NULL, native_failure_repeated=0, native_failure_kind=0 WHERE id=?"

    invoke-virtual {p0, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 348
    return-void
.end method

.method private static clearSyncData(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 2

    .line 403
    const-string v0, "pending_operation"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 404
    const-string v0, "staged_baseline"

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 405
    const-string v0, "baseline"

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 406
    const-string v0, "profile"

    invoke-virtual {p0, v0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 407
    return-void
.end method

.method private static hex([B)Ljava/lang/String;
    .locals 6

    .line 512
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    .line 513
    new-instance v0, Ljava/lang/StringBuilder;

    array-length v1, p0

    mul-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 514
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

    .line 515
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static keyHash([BLjava/lang/String;)[B
    .locals 1

    .line 495
    if-eqz p1, :cond_0

    .line 497
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 498
    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->update([B)V

    .line 499
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, p0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 500
    :catch_0
    move-exception p0

    .line 501
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "SHA-256 is unavailable"

    invoke-direct {p1, v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p1

    .line 495
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "canonical key is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static nativeFailureFingerprint([BLcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)[B
    .locals 5

    .line 471
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 472
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

    .line 473
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

    .line 474
    goto :goto_0

    .line 475
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

    .line 476
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

    .line 477
    goto :goto_1

    .line 478
    :cond_1
    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 480
    :try_start_0
    const-string p0, "SHA-256"

    invoke-static {p0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p0

    .line 481
    iget v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->expectedNativeCount:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update([B)V

    .line 482
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update(B)V

    .line 483
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->actualNativeCount:I

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/security/MessageDigest;->update([B)V

    .line 484
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 485
    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update(B)V

    .line 486
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update([B)V

    .line 487
    goto :goto_2

    .line 488
    :cond_2
    invoke-virtual {p0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 489
    :catch_0
    move-exception p0

    .line 490
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

    .line 451
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 452
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 453
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

    .line 454
    goto :goto_0

    .line 455
    :cond_0
    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 457
    :try_start_0
    const-string p0, "SHA-256"

    invoke-static {p0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p0

    .line 458
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/security/MessageDigest;->update([B)V

    .line 459
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 460
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Ljava/security/MessageDigest;->update(B)V

    .line 461
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update([B)V

    .line 462
    goto :goto_1

    .line 463
    :cond_1
    invoke-virtual {p0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 464
    :catch_0
    move-exception p0

    .line 465
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

    .line 410
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 411
    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 412
    const-string v1, "root_uri"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->rootUri:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 413
    const-string v1, "device_dir"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 414
    const-string v1, "snapshot_file"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 415
    const-string v1, "bridge_user_id"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 416
    const-string v1, "hash_salt"

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 417
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->protocolVersion:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "protocol_version"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 418
    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "generation"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 419
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "phase"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 420
    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->lastSuccess:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "last_success"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 421
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeExpectedCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_expected_count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 422
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeActualCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_actual_count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 423
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_missing_count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 424
    const-string v1, "native_failure_fingerprint"

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 425
    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "native_failure_repeated"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 426
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const-string v1, "native_failure_kind"

    invoke-virtual {v0, v1, p0}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 427
    return-object v0
.end method

.method private static readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 22

    .line 431
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

    .line 437
    invoke-static {v9}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v16

    const/16 v17, 0xb

    new-array v5, v9, [Ljava/lang/String;

    aput-object v16, v5, v0

    .line 431
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

    .line 439
    :try_start_0
    invoke-interface {v1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v2, :cond_0

    .line 446
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 439
    const/4 v0, 0x0

    return-object v0

    .line 440
    :cond_0
    :try_start_1
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    invoke-interface {v1, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 441
    invoke-interface {v1, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v6

    invoke-interface {v1, v12}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v7

    invoke-interface {v1, v13}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    invoke-interface {v1, v14}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v10

    .line 442
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

    .line 443
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

    .line 444
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

    .line 446
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 440
    return-object v2

    .line 446
    :catchall_0
    move-exception v0

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 447
    throw v0
.end method

.method private static requireHash([B)V
    .locals 1

    .line 506
    if-eqz p0, :cond_0

    array-length p0, p0

    const/16 v0, 0x20

    if-ne p0, v0, :cond_0

    .line 509
    return-void

    .line 507
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime synchronization key hash is invalid"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private requirePhase(I)V
    .locals 1

    .line 391
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 392
    if-eqz v0, :cond_0

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-ne v0, p1, :cond_0

    .line 395
    return-void

    .line 393
    :cond_0
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "unexpected Rime synchronization phase"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private setPhase(I)V
    .locals 5

    .line 398
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 399
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

    .line 398
    const-string p1, "UPDATE profile SET phase=? WHERE id=?"

    invoke-virtual {v0, p1, v3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 400
    return-void
.end method


# virtual methods
.method public declared-synchronized baseline([B)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;
    .locals 4

    monitor-enter p0

    .line 147
    :try_start_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requireHash([B)V

    .line 148
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "SELECT history, google_projection, rime_abs_count FROM baseline WHERE key_hash=X\'"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 150
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "\'"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 148
    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->rawQuery(Ljava/lang/String;[Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 152
    :try_start_1
    invoke-interface {p1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 153
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;

    invoke-interface {p1, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-result-object v1

    .line 154
    const/4 v2, 0x1

    invoke-interface {p1, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-result-object v2

    .line 155
    const/4 v3, 0x2

    invoke-interface {p1, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    invoke-direct {v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    goto :goto_0

    .line 156
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-direct {v0, v2, v3, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_0
    nop

    .line 159
    :try_start_2
    invoke-interface {p1}, Landroid/database/Cursor;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 152
    monitor-exit p0

    return-object v0

    .line 159
    :catchall_0
    move-exception v0

    :try_start_3
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    .line 160
    throw v0

    .line 146
    :catchall_1
    move-exception p1

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    throw p1
.end method

.method public declared-synchronized baselineLookup()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;
    .locals 14

    monitor-enter p0

    .line 173
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 174
    if-eqz v0, :cond_1

    .line 175
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 177
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v2

    const-string v3, "baseline"

    const/4 v4, 0x4

    new-array v4, v4, [Ljava/lang/String;

    const-string v5, "key_hash"

    const/4 v10, 0x0

    aput-object v5, v4, v10

    const-string v5, "history"

    const/4 v11, 0x1

    aput-object v5, v4, v11

    const-string v5, "google_projection"

    const/4 v12, 0x2

    aput-object v5, v4, v12

    const-string v5, "rime_abs_count"

    const/4 v13, 0x3

    aput-object v5, v4, v13

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    invoke-virtual/range {v2 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 181
    :goto_0
    :try_start_1
    invoke-interface {v2}, Landroid/database/Cursor;->moveToNext()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 182
    invoke-interface {v2, v10}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v3

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    .line 183
    invoke-interface {v2, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-result-object v5

    .line 184
    invoke-interface {v2, v12}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-result-object v6

    .line 185
    invoke-interface {v2, v13}, Landroid/database/Cursor;->getInt(I)I

    move-result v7

    invoke-direct {v4, v5, v6, v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 182
    invoke-interface {v1, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 188
    :cond_0
    :try_start_2
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 189
    nop

    .line 190
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-virtual {v0}, [B->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [B

    .line 191
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;

    invoke-direct {v2, p0, v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/util/Map;[B)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    monitor-exit p0

    return-object v2

    .line 188
    :catchall_0
    move-exception v0

    :try_start_3
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 189
    throw v0

    .line 174
    :cond_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime profile is not configured"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 172
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

    .line 205
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 206
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 207
    if-eqz v1, :cond_1

    .line 208
    iget v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v2, :cond_0

    .line 211
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    .line 212
    const-string v2, "staged_baseline"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 213
    const-string v2, "pending_operation"

    invoke-virtual {v0, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 214
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

    .line 209
    :cond_0
    :try_start_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "an unfinished Rime synchronization must be recovered"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 207
    :cond_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Rime profile is not configured"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 204
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

    .line 356
    const/4 v0, 0x3

    :try_start_0
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requirePhase(I)V

    .line 357
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 358
    if-eqz v1, :cond_0

    iget-wide v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    cmp-long v3, p1, v1

    if-nez v3, :cond_0

    .line 361
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    .line 362
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 364
    :try_start_1
    const-string v2, "baseline"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 365
    const-string v2, "INSERT INTO baseline(key_hash, history, google_projection, rime_abs_count) SELECT key_hash, history, google_projection, rime_abs_count FROM staged_baseline"

    invoke-virtual {v1, v2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 368
    const-string v2, "staged_baseline"

    invoke-virtual {v1, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 369
    const-string v2, "pending_operation"

    invoke-virtual {v1, v2, v3, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 370
    const-string v2, "UPDATE profile SET generation=?, phase=?, last_success=? WHERE id=?"

    .line 371
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

    .line 370
    invoke-virtual {v1, v2, v5}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 372
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 374
    :try_start_2
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 375
    nop

    .line 376
    monitor-exit p0

    return-void

    .line 374
    :catchall_0
    move-exception p1

    :try_start_3
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 375
    throw p1

    .line 359
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime synchronization generation is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 355
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

    .line 96
    if-eqz v1, :cond_5

    :try_start_0
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    if-eqz v3, :cond_5

    if-eqz v0, :cond_5

    if-lez v6, :cond_5

    .line 100
    invoke-virtual/range {p0 .. p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v3

    .line 101
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v4

    .line 102
    if-eqz v4, :cond_0

    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->rootUri:Ljava/lang/String;

    invoke-virtual {v5, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    iget-object v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    .line 103
    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    iget-object v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    .line 104
    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    iget v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->protocolVersion:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    if-ne v5, v6, :cond_0

    .line 106
    monitor-exit p0

    return-object v4

    .line 108
    :cond_0
    if-eqz v4, :cond_2

    :try_start_1
    iget v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v5, :cond_1

    goto :goto_0

    .line 109
    :cond_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "unfinished Rime synchronization must be recovered before reconfiguration"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 112
    :cond_2
    :goto_0
    const/16 v5, 0x20

    new-array v5, v5, [B

    .line 113
    new-instance v7, Ljava/security/SecureRandom;

    invoke-direct {v7}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v7, v5}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 114
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v7

    invoke-virtual {v7}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v7
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 115
    if-nez v4, :cond_4

    if-eqz v2, :cond_4

    .line 117
    :try_start_2
    invoke-static {v2}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v4

    .line 118
    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 121
    nop

    .line 125
    move-object v4, v2

    goto :goto_1

    .line 119
    :cond_3
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "non-canonical UUID"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_2
    .catch Ljava/lang/IllegalArgumentException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    .line 122
    :catch_0
    move-exception v0

    .line 123
    :try_start_3
    new-instance v1, Ljava/lang/IllegalArgumentException;

    const-string v2, "recovered Bridge snapshot identity is invalid"

    invoke-direct {v1, v2, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1

    .line 127
    :cond_4
    move-object v4, v7

    :goto_1
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

    .line 131
    invoke-virtual/range {p2 .. p2}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 133
    :try_start_4
    invoke-static/range {p2 .. p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->clearSyncData(Landroid/database/sqlite/SQLiteDatabase;)V

    .line 134
    const-string v1, "profile"

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profileValues(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)Landroid/content/ContentValues;

    move-result-object v2
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    const/4 v3, 0x0

    move-object/from16 v12, p2

    :try_start_5
    invoke-virtual {v12, v1, v3, v2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    .line 135
    invoke-virtual {v12}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 137
    :try_start_6
    invoke-virtual {v12}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    .line 138
    nop

    .line 139
    monitor-exit p0

    return-object v0

    .line 137
    :catchall_0
    move-exception v0

    goto :goto_2

    :catchall_1
    move-exception v0

    move-object/from16 v12, p2

    :goto_2
    :try_start_7
    invoke-virtual {v12}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 138
    throw v0

    .line 98
    :cond_5
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Rime synchronization profile is invalid"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 95
    :catchall_2
    move-exception v0

    monitor-exit p0
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_2

    throw v0
.end method

.method public keyHash(Ljava/lang/String;)[B
    .locals 1

    .line 165
    if-eqz p1, :cond_1

    .line 166
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 167
    if-eqz v0, :cond_0

    .line 168
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object p1

    return-object p1

    .line 167
    :cond_0
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Rime profile is not configured"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 165
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "canonical key is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public declared-synchronized markGoogleApplied()V
    .locals 1

    monitor-enter p0

    .line 312
    const/4 v0, 0x1

    :try_start_0
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requirePhase(I)V

    .line 313
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->clearNativeFailureAndSetGoogleApplied(Landroid/database/sqlite/SQLiteDatabase;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 314
    monitor-exit p0

    return-void

    .line 311
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

    .line 319
    :try_start_0
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->verifyRecordedRejectedEntries(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V

    .line 320
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 321
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 322
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 324
    :try_start_1
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    .line 325
    const-string v3, "google_projection"

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->name()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 326
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

    .line 327
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v4

    invoke-static {v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->keyHash([BLjava/lang/String;)[B

    move-result-object v3

    .line 328
    const-string v4, "staged_baseline"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "key_hash=X\'"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 329
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->hex([B)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "\'"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 328
    const/4 v5, 0x0

    invoke-virtual {v0, v4, v2, v3, v5}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v3

    .line 330
    const/4 v4, 0x1

    if-ne v3, v4, :cond_0

    .line 333
    goto :goto_0

    .line 331
    :cond_0
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v1, "rejected entry is absent from staged baseline"

    invoke-direct {p1, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 334
    :cond_1
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->clearNativeFailureAndSetGoogleApplied(Landroid/database/sqlite/SQLiteDatabase;)V

    .line 335
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 337
    :try_start_2
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 338
    nop

    .line 339
    monitor-exit p0

    return-void

    .line 337
    :catchall_0
    move-exception p1

    :try_start_3
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 338
    throw p1

    .line 318
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

    .line 351
    const/4 v0, 0x2

    :try_start_0
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->requirePhase(I)V

    .line 352
    const/4 v0, 0x3

    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->setPhase(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 353
    monitor-exit p0

    return-void

    .line 350
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

    .line 44
    const-string v0, "CREATE TABLE profile (id INTEGER PRIMARY KEY, root_uri TEXT NOT NULL, device_dir TEXT NOT NULL, snapshot_file TEXT NOT NULL, bridge_user_id TEXT NOT NULL, hash_salt BLOB NOT NULL, protocol_version INTEGER NOT NULL, generation INTEGER NOT NULL, phase INTEGER NOT NULL, last_success INTEGER NOT NULL, native_expected_count INTEGER NOT NULL DEFAULT 0, native_actual_count INTEGER NOT NULL DEFAULT 0, native_missing_count INTEGER NOT NULL DEFAULT 0, native_failure_fingerprint BLOB, native_failure_repeated INTEGER NOT NULL DEFAULT 0, native_failure_kind INTEGER NOT NULL DEFAULT 0)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 55
    const-string v0, "CREATE TABLE baseline (key_hash BLOB PRIMARY KEY, history TEXT NOT NULL, google_projection TEXT NOT NULL, rime_abs_count INTEGER NOT NULL)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 57
    const-string v0, "CREATE TABLE staged_baseline (key_hash BLOB PRIMARY KEY, history TEXT NOT NULL, google_projection TEXT NOT NULL, rime_abs_count INTEGER NOT NULL)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 60
    const-string v0, "CREATE TABLE pending_operation (sequence INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT NOT NULL, phrase TEXT NOT NULL, google_action TEXT NOT NULL, rime_action TEXT NOT NULL, rime_commit_value INTEGER NOT NULL)"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 63
    return-void
.end method

.method public onUpgrade(Landroid/database/sqlite/SQLiteDatabase;II)V
    .locals 1

    .line 66
    const/4 v0, 0x1

    if-lt p2, v0, :cond_3

    const/4 v0, 0x4

    if-ne p3, v0, :cond_3

    .line 70
    const/4 p3, 0x2

    if-ge p2, p3, :cond_0

    .line 71
    const-string p3, "ALTER TABLE profile ADD COLUMN native_expected_count INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 73
    const-string p3, "ALTER TABLE profile ADD COLUMN native_actual_count INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 75
    const-string p3, "ALTER TABLE profile ADD COLUMN native_missing_count INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 77
    const-string p3, "ALTER TABLE profile ADD COLUMN native_failure_fingerprint BLOB"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 78
    const-string p3, "ALTER TABLE profile ADD COLUMN native_failure_repeated INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 81
    :cond_0
    const/4 p3, 0x3

    if-ge p2, p3, :cond_1

    .line 82
    const-string p3, "ALTER TABLE profile ADD COLUMN native_failure_kind INTEGER NOT NULL DEFAULT 0"

    invoke-virtual {p1, p3}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 85
    :cond_1
    if-ge p2, v0, :cond_2

    .line 86
    const-string p2, "ALTER TABLE baseline ADD COLUMN google_projection TEXT NOT NULL DEFAULT \'SUPPORTED\'"

    invoke-virtual {p1, p2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 88
    const-string p2, "ALTER TABLE staged_baseline ADD COLUMN google_projection TEXT NOT NULL DEFAULT \'SUPPORTED\'"

    invoke-virtual {p1, p2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 91
    :cond_2
    return-void

    .line 67
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

    .line 218
    :try_start_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 219
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

    .line 223
    :goto_0
    :try_start_1
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 224
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;

    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 225
    invoke-interface {v1, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    move-result-object v6

    .line 226
    invoke-interface {v1, v12}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    move-result-object v7

    .line 227
    invoke-interface {v1, v13}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    invoke-direct/range {v3 .. v8}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    .line 224
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 230
    :cond_0
    :try_start_2
    invoke-interface {v1}, Landroid/database/Cursor;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 231
    nop

    .line 232
    monitor-exit p0

    return-object v0

    .line 230
    :catchall_0
    move-exception v0

    :try_start_3
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 231
    throw v0

    .line 217
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

    .line 143
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    .line 143
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

    .line 295
    const/4 v0, 0x2

    if-lt p1, v0, :cond_3

    const/16 v1, 0xb

    if-gt p1, v1, :cond_3

    .line 299
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1

    .line 300
    if-eqz v1, :cond_2

    iget v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_2

    .line 303
    iget v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    const/4 v2, 0x0

    if-ne v1, p1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    .line 304
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v4

    const-string v5, "UPDATE profile SET native_expected_count=0, native_actual_count=0, native_missing_count=0, native_failure_fingerprint=NULL, native_failure_repeated=?, native_failure_kind=? WHERE id=?"

    .line 308
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

    .line 304
    invoke-virtual {v4, v5, v7}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 309
    monitor-exit p0

    return-void

    .line 301
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native failure requires a planned synchronization"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 297
    :cond_3
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native failure kind is invalid"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 294
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

    .line 238
    if-eqz p1, :cond_3

    .line 239
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 240
    if-eqz v0, :cond_2

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x1

    if-ne v1, v2, :cond_2

    .line 243
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->nativeFailureFingerprint([BLcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;)[B

    move-result-object v1

    .line 244
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v3

    const/4 v4, 0x0

    if-eqz v3, :cond_0

    .line 245
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 246
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v3

    const-string v5, "UPDATE profile SET native_expected_count=?, native_actual_count=?, native_missing_count=?, native_failure_fingerprint=?, native_failure_repeated=?, native_failure_kind=? WHERE id=?"

    iget v6, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->expectedNativeCount:I

    .line 250
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    iget v7, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->actualNativeCount:I

    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;->missingCount:I

    .line 251
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

    .line 252
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

    .line 246
    invoke-virtual {v3, v5, v10}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 253
    monitor-exit p0

    return-void

    .line 241
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native failure requires a planned synchronization"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 237
    :catchall_0
    move-exception p1

    goto :goto_2

    .line 238
    :cond_3
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native failure is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 237
    :goto_2
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized recordNativeRejectedEntriesFailure(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)V
    .locals 9

    monitor-enter p0

    .line 258
    if-eqz p1, :cond_3

    .line 259
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 260
    if-eqz v0, :cond_2

    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    const/4 v2, 0x1

    if-ne v1, v2, :cond_2

    .line 263
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    iget-object v3, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedKeys:Ljava/util/List;

    invoke-static {v1, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->nativeRejectedFingerprint([BLjava/util/List;)[B

    move-result-object v1

    .line 264
    iget v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    const/4 v4, 0x6

    const/4 v5, 0x0

    if-ne v3, v4, :cond_0

    .line 266
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v3

    if-eqz v3, :cond_0

    .line 267
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v0

    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 268
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v3

    const-string v6, "UPDATE profile SET native_expected_count=0, native_actual_count=0, native_missing_count=?, native_failure_fingerprint=?, native_failure_repeated=?, native_failure_kind=? WHERE id=?"

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedCount:I

    .line 272
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

    .line 273
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

    .line 268
    invoke-virtual {v3, v6, v8}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 274
    monitor-exit p0

    return-void

    .line 261
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native rejection requires a planned synchronization"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 257
    :catchall_0
    move-exception p1

    goto :goto_2

    .line 258
    :cond_3
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native rejection is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 257
    :goto_2
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public declared-synchronized resetBaseline()V
    .locals 5

    monitor-enter p0

    .line 379
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    .line 380
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->readProfile(Landroid/database/sqlite/SQLiteDatabase;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 381
    if-nez v1, :cond_0

    monitor-exit p0

    return-void

    .line 382
    :cond_0
    :try_start_1
    iget v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    if-nez v1, :cond_1

    .line 385
    const-string v1, "baseline"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2, v2}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 386
    const-string v1, "UPDATE profile SET generation=0, last_success=0 WHERE id=?"

    .line 387
    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    .line 386
    invoke-virtual {v0, v1, v2}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 388
    monitor-exit p0

    return-void

    .line 383
    :cond_1
    :try_start_2
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "unfinished Rime synchronization cannot be reset"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 378
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

    .line 279
    if-eqz p1, :cond_2

    .line 280
    :try_start_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    .line 281
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    .line 282
    :cond_0
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object v1

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedKeys:Ljava/util/List;

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->nativeRejectedFingerprint([BLjava/util/List;)[B

    move-result-object v1

    .line 283
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

    .line 287
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object p1

    if-eqz p1, :cond_1

    .line 288
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B

    move-result-object p1

    invoke-static {p1, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p1, :cond_1

    .line 291
    monitor-exit p0

    return-void

    .line 289
    :cond_1
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "Native rejected entry set changed"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 278
    :catchall_0
    move-exception p1

    goto :goto_1

    .line 279
    :cond_2
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "Native rejection is required"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 278
    :goto_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method
