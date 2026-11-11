.class public final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;
    }
.end annotation


# static fields
.field private static final CR:Ljava/lang/String;

.field private static final DAY_MS:J = 0x5265c00L

.field static final EXTERNAL_STORAGE_AUTHORITY:Ljava/lang/String; = "com.android.externalstorage.documents"

.field private static final FINAL_SUFFIX:Ljava/lang/String; = ".txt"

.field private static final HOUR_MS:J = 0x36ee80L

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field static final KEY_BACKUP_NOW:Ljava/lang/String; = "dictionary_auto_backup_now"

.field static final KEY_ENABLED:Ljava/lang/String; = "dictionary_auto_backup_enabled"

.field static final KEY_FAILURES:Ljava/lang/String; = "dictionary_auto_backup_consecutive_failures"

.field static final KEY_HIGH_WATER_ENTRY_COUNT:Ljava/lang/String; = "dictionary_auto_backup_high_water_entry_count"

.field static final KEY_IMPORT_BACKUP:Ljava/lang/String; = "dictionary_auto_backup_import"

.field static final KEY_INTERVAL:Ljava/lang/String; = "dictionary_auto_backup_interval_days"

.field static final KEY_KEPT_WHILE_COLLAPSED:Ljava/lang/String; = "dictionary_auto_backup_kept_while_collapsed"

.field static final KEY_LAST_ATTEMPT:Ljava/lang/String; = "dictionary_auto_backup_last_attempt_time"

.field static final KEY_LAST_ENTRY_COUNT:Ljava/lang/String; = "dictionary_auto_backup_last_entry_count"

.field static final KEY_LAST_ERROR:Ljava/lang/String; = "dictionary_auto_backup_last_error"

.field static final KEY_LAST_SHA256:Ljava/lang/String; = "dictionary_auto_backup_last_sha256"

.field static final KEY_LAST_STATUS:Ljava/lang/String; = "dictionary_auto_backup_last_status"

.field static final KEY_LAST_SUCCESS:Ljava/lang/String; = "dictionary_auto_backup_last_success_time"

.field static final KEY_LAST_URI:Ljava/lang/String; = "dictionary_auto_backup_last_document_uri"

.field static final KEY_RETENTION:Ljava/lang/String; = "dictionary_auto_backup_retention_count"

.field static final KEY_TREE_LABEL:Ljava/lang/String; = "dictionary_auto_backup_tree_label"

.field static final KEY_TREE_URI:Ljava/lang/String; = "dictionary_auto_backup_tree_uri"

.field private static final MAIN:Landroid/os/Handler;

.field private static final NEWLINE:Ljava/lang/String;

.field private static final PARTIAL_MAX_AGE_MS:J = 0x5265c00L

.field private static final PARTIAL_SUFFIX:Ljava/lang/String; = ".txt.partial"

.field private static final PREFIX:Ljava/lang/String; = "google-pinyin-user-dictionary-"

.field static final PREFS:Ljava/lang/String; = "dictionary_local_backup_preferences"

.field private static sInProgress:Z


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 67
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    .line 68
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    .line 344
    const/16 v0, 0xa

    invoke-static {v0}, Ljava/lang/Character;->toString(C)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->NEWLINE:Ljava/lang/String;

    .line 345
    const/16 v0, 0xd

    invoke-static {v0}, Ljava/lang/Character;->toString(C)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->CR:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 71
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Landroid/net/Uri;Z)V
    .locals 0

    .line 37
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .locals 0

    .line 37
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1000(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .locals 0

    .line 37
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1100()Ljava/util/concurrent/ExecutorService;
    .locals 1

    .line 37
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-object v0
.end method

.method static synthetic access$1200(Landroid/content/Context;)Ljava/util/List;
    .locals 0

    .line 37
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listConfiguredBackups(Landroid/content/Context;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1300()Landroid/os/Handler;
    .locals 1

    .line 37
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic access$1400(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 37
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1500(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    .line 37
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$400(Landroid/content/Context;Landroid/net/Uri;)V
    .locals 0

    .line 37
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    return-void
.end method

.method static synthetic access$700(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    .line 37
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static clamp(IIII)I
    .locals 0

    .line 625
    if-lt p0, p1, :cond_0

    if-le p0, p2, :cond_1

    :cond_0
    move p0, p3

    :cond_1
    return p0
.end method

.method private static cleanupOldPartials(Landroid/content/Context;Landroid/net/Uri;)V
    .locals 13

    .line 478
    nop

    .line 480
    const/4 v1, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 481
    nop

    .line 482
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    .line 481
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    .line 483
    const/4 p0, 0x3

    new-array v4, p0, [Ljava/lang/String;

    const-string p0, "document_id"

    const/4 v8, 0x0

    aput-object p0, v4, v8

    const-string p0, "_display_name"

    const/4 v9, 0x1

    aput-object p0, v4, v9

    const-string p0, "last_modified"

    const/4 v10, 0x2

    aput-object p0, v4, v10

    .line 488
    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v5, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 489
    if-nez v1, :cond_1

    .line 505
    if-eqz v1, :cond_0

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 489
    :cond_0
    return-void

    .line 490
    :cond_1
    :try_start_1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    .line 491
    :goto_0
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0

    if-eqz p0, :cond_4

    .line 492
    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 493
    invoke-interface {v1, v10}, Landroid/database/Cursor;->isNull(I)Z

    move-result v0

    const-wide/16 v5, 0x0

    if-eqz v0, :cond_2

    move-wide v11, v5

    goto :goto_1

    :cond_2
    invoke-interface {v1, v10}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v11

    .line 494
    :goto_1
    if-eqz p0, :cond_3

    const-string v0, "google-pinyin-user-dictionary-"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    const-string v0, ".txt.partial"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_3

    cmp-long p0, v11, v5

    if-lez p0, :cond_3

    cmp-long p0, v3, v11

    if-ltz p0, :cond_3

    sub-long v5, v3, v11

    const-wide/32 v11, 0x5265c00

    cmp-long p0, v5, v11

    if-ltz p0, :cond_3

    .line 497
    nop

    .line 498
    invoke-interface {v1, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 497
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 499
    :try_start_2
    invoke-static {v2, p0}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 500
    :goto_2
    goto :goto_3

    :catchall_0
    move-exception v0

    goto :goto_2

    .line 502
    :cond_3
    :goto_3
    goto :goto_0

    .line 505
    :cond_4
    if-eqz v1, :cond_5

    goto :goto_4

    .line 503
    :catchall_1
    move-exception v0

    .line 505
    if-eqz v1, :cond_5

    :goto_4
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 507
    :cond_5
    return-void
.end method

.method private static countEntries([B)I
    .locals 8

    .line 351
    const/4 v0, 0x0

    :try_start_0
    new-instance v1, Ljava/lang/String;

    const-string v2, "UTF-16LE"

    invoke-direct {v1, p0, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    .line 354
    nop

    .line 355
    nop

    .line 356
    const/4 p0, 0x0

    const/4 v2, 0x0

    .line 357
    :goto_0
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    if-ge p0, v3, :cond_6

    .line 358
    sget-object v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v1, v3, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v3

    .line 359
    if-gez v3, :cond_0

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    .line 360
    :cond_0
    invoke-virtual {v1, p0, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    sget-object v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->CR:Ljava/lang/String;

    const-string v5, ""

    invoke-virtual {p0, v4, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    .line 361
    add-int/lit8 v3, v3, 0x1

    .line 362
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_5

    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v4

    const v5, 0xfeff

    if-eq v4, v5, :cond_5

    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v4

    const/16 v5, 0x23

    if-ne v4, v5, :cond_1

    goto :goto_2

    .line 363
    :cond_1
    nop

    .line 364
    const/4 v4, 0x0

    const/4 v5, 0x0

    :goto_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v6

    if-ge v4, v6, :cond_3

    .line 365
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v6

    const/16 v7, 0x9

    if-ne v6, v7, :cond_2

    add-int/lit8 v5, v5, 0x1

    .line 364
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 367
    :cond_3
    const/4 p0, 0x2

    if-lt v5, p0, :cond_4

    add-int/lit8 v2, v2, 0x1

    .line 368
    :cond_4
    move p0, v3

    goto :goto_0

    .line 357
    :cond_5
    :goto_2
    move p0, v3

    goto :goto_0

    .line 369
    :cond_6
    return v2

    .line 352
    :catch_0
    move-exception p0

    .line 353
    return v0
.end method

.method private static deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V
    .locals 0

    .line 608
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-static {p0, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 609
    :catchall_0
    move-exception p0

    :goto_0
    nop

    .line 610
    return-void
.end method

.method private static describe(Ljava/lang/Throwable;)Ljava/lang/String;
    .locals 3

    .line 583
    if-nez p0, :cond_0

    const-string p0, ""

    return-object p0

    .line 584
    :cond_0
    invoke-virtual {p0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v0

    .line 585
    invoke-virtual {p0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object p0

    .line 586
    const/4 v1, 0x0

    if-eqz p0, :cond_1

    array-length v2, p0

    if-lez v2, :cond_1

    .line 587
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " @ "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    aget-object p0, p0, v1

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 589
    :cond_1
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p0

    const/16 v2, 0x12c

    if-le p0, v2, :cond_2

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    :cond_2
    return-object v0
.end method

.method private static enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .locals 15

    .line 216
    const-string v6, "a"

    :try_start_0
    const-string v0, "aib"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    .line 217
    const/4 v8, 0x0

    new-array v0, v8, [Ljava/lang/Class;

    invoke-virtual {v7, v6, v0}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v8, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    .line 218
    const-string v0, "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v10

    .line 220
    const-string v0, "beg"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 221
    const/4 v11, 0x3

    new-array v1, v11, [Ljava/lang/Class;

    const-class v2, Landroid/content/Context;

    aput-object v2, v1, v8

    const-class v2, Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;

    const/4 v12, 0x1

    aput-object v2, v1, v12

    const-class v2, Landroid/net/Uri;

    const/4 v13, 0x2

    aput-object v2, v1, v13

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v14

    .line 223
    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    move-object v1, p0

    move-object/from16 v2, p1

    move-object/from16 v3, p2

    move-object/from16 v4, p3

    move/from16 v5, p4

    :try_start_1
    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;-><init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 224
    new-array v2, v11, [Ljava/lang/Object;

    aput-object p0, v2, v8

    aput-object v0, v2, v12

    aput-object v3, v2, v13

    invoke-virtual {v14, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 225
    new-array v2, v11, [Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    aput-object v4, v2, v8

    aput-object v10, v2, v12

    sget-object v4, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v4, v2, v13

    invoke-virtual {v7, v6, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    .line 227
    const-wide/16 v4, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    new-array v5, v11, [Ljava/lang/Object;

    const-string v6, "user_dict_auto_backup"

    aput-object v6, v5, v8

    aput-object v0, v5, v12

    aput-object v4, v5, v13

    invoke-virtual {v2, v9, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 231
    goto :goto_1

    .line 228
    :catchall_0
    move-exception v0

    goto :goto_0

    :catchall_1
    move-exception v0

    move-object/from16 v3, p2

    .line 229
    :goto_0
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 230
    const-string v2, "\u65e0\u6cd5\u542f\u52a8\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa"

    move/from16 v5, p4

    invoke-static {p0, v5, v2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 232
    :goto_1
    return-void
.end method

.method private static failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V
    .locals 5

    .line 179
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 180
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_attempt_time"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    invoke-interface {v1, v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 181
    const-string v2, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 182
    const-string v2, "dictionary_auto_backup_consecutive_failures"

    const/4 v3, 0x0

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 183
    if-eqz p1, :cond_0

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 184
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 185
    return-void
.end method

.method private static finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .locals 9

    .line 273
    const-string v0, "dictionary_auto_backup_high_water_entry_count"

    const-string v1, "dictionary_auto_backup_last_status"

    :try_start_0
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;

    move-result-object v2

    .line 274
    iget v3, v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;->entryCount:I

    if-nez v3, :cond_0

    .line 277
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 278
    const-string p1, "\u5f15\u64ce\u6682\u65f6\u8bfb\u4e0d\u5230\u8bcd\u6761\uff0c\u672c\u6b21\u6ca1\u6709\u751f\u6210\u5907\u4efd"

    const/4 p3, 0x0

    invoke-static {p0, p4, p1, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 279
    return-void

    .line 281
    :cond_0
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;->sha256:Ljava/lang/String;

    .line 282
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    invoke-static {v4, p2, p3}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p3

    .line 284
    if-eqz p3, :cond_2

    .line 285
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    .line 286
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v6

    .line 287
    invoke-interface {v6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    const-string v8, "dictionary_auto_backup_last_success_time"

    invoke-interface {v7, v8, v4, v5}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v5, "\u5907\u4efd\u6210\u529f"

    .line 288
    invoke-interface {v4, v1, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v5, "dictionary_auto_backup_last_document_uri"

    .line 289
    invoke-virtual {p3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-interface {v4, v5, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v4, "dictionary_auto_backup_last_sha256"

    .line 290
    invoke-interface {p3, v4, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v3, "dictionary_auto_backup_last_entry_count"

    iget v4, v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;->entryCount:I

    .line 291
    invoke-interface {p3, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    .line 293
    const/4 v3, 0x0

    invoke-interface {v6, v0, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;->entryCount:I

    .line 292
    invoke-static {v4, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    invoke-interface {p3, v0, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v0, "dictionary_auto_backup_consecutive_failures"

    .line 294
    invoke-interface {p3, v0, v3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 295
    const-string p3, "dictionary_auto_backup_retention_count"

    .line 296
    const/16 v0, 0xa

    invoke-interface {v6, p3, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p3

    const/4 v2, 0x1

    const/16 v3, 0x64

    invoke-static {p3, v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result p3

    .line 295
    invoke-static {p0, p1, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->rotate(Landroid/content/Context;Landroid/net/Uri;I)Z

    move-result p1

    .line 297
    if-nez p1, :cond_1

    .line 298
    invoke-interface {v6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string p3, "\u5907\u4efd\u6210\u529f\uff0c\u4f46\u65e7\u7248\u672c\u6e05\u7406\u5931\u8d25"

    invoke-interface {p1, v1, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 300
    :cond_1
    invoke-static {p0, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishSuccess(Landroid/content/Context;Z)V

    .line 304
    goto :goto_0

    .line 284
    :cond_2
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p3, "renameDocument returned null"

    invoke-direct {p1, p3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 301
    :catchall_0
    move-exception p1

    .line 302
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 303
    const-string p2, "\u5907\u4efd\u6821\u9a8c\u6216\u53d1\u5e03\u5931\u8d25"

    invoke-static {p0, p4, p2, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 305
    :goto_0
    return-void
.end method

.method private static finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    .locals 4

    .line 594
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 595
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_error"

    .line 596
    invoke-static {p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->describe(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object p3

    invoke-interface {v1, v2, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v1, "dictionary_auto_backup_consecutive_failures"

    const-string v2, "dictionary_auto_backup_consecutive_failures"

    .line 597
    const/4 v3, 0x0

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    invoke-interface {p3, v1, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 598
    const-class p3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter p3

    :try_start_0
    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit p3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 599
    sget-object p3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;

    invoke-direct {v0, p1, p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;-><init>(ZLandroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {p3, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 605
    return-void

    .line 598
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit p3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private static finishSuccess(Landroid/content/Context;Z)V
    .locals 2

    .line 573
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    const/4 v1, 0x0

    :try_start_0
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 574
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;

    invoke-direct {v1, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;-><init>(ZLandroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 580
    return-void

    .line 573
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method static hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z
    .locals 3

    .line 97
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isSupportedTree(Landroid/net/Uri;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 99
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/ContentResolver;->getPersistedUriPermissions()Ljava/util/List;

    move-result-object p0

    .line 100
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/UriPermission;

    .line 101
    invoke-virtual {v0}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {p1, v2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v0}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 102
    invoke-virtual {v0}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v0, :cond_1

    .line 103
    const/4 p0, 0x1

    return p0

    .line 105
    :cond_1
    goto :goto_0

    .line 107
    :cond_2
    goto :goto_1

    .line 106
    :catch_0
    move-exception p0

    .line 108
    :goto_1
    return v1
.end method

.method public static isInProgress()Z
    .locals 2

    .line 78
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    .line 79
    :try_start_0
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit v0

    return v1

    .line 80
    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method static isSupportedTree(Landroid/net/Uri;)Z
    .locals 3

    .line 84
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-lt v0, v1, :cond_1

    if-eqz p0, :cond_1

    .line 85
    invoke-virtual {p0}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object v0

    const-string v1, "content"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 86
    invoke-virtual {p0}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 90
    :cond_0
    :try_start_0
    invoke-static {p0}, Landroid/provider/DocumentsContract;->isTreeUri(Landroid/net/Uri;)Z

    move-result p0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    .line 91
    :catch_0
    move-exception p0

    .line 92
    return v2

    .line 87
    :cond_1
    :goto_0
    return v2
.end method

.method private static keepWholeWindow(Landroid/content/SharedPreferences;)Z
    .locals 4

    .line 466
    const-string v0, "dictionary_auto_backup_last_entry_count"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 467
    const-string v2, "dictionary_auto_backup_high_water_entry_count"

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v2

    .line 468
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v0

    .line 469
    const-string v2, "dictionary_auto_backup_kept_while_collapsed"

    if-eqz v0, :cond_0

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    if-nez v3, :cond_0

    .line 470
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x1

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    goto :goto_0

    .line 471
    :cond_0
    if-nez v0, :cond_1

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 472
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 474
    :cond_1
    :goto_0
    return v0
.end method

.method private static listBackups(Landroid/content/Context;Landroid/net/Uri;)Ljava/util/List;
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Landroid/net/Uri;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 402
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 403
    nop

    .line 405
    nop

    .line 406
    const/4 v1, 0x0

    :try_start_0
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v2

    .line 405
    invoke-static {p1, v2}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    .line 407
    const/4 v2, 0x2

    new-array v5, v2, [Ljava/lang/String;

    const-string v2, "document_id"

    const/4 v9, 0x0

    aput-object v2, v5, v9

    const-string v2, "_display_name"

    const/4 v10, 0x1

    aput-object v2, v5, v10

    .line 411
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v6, 0x0

    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 412
    if-eqz v1, :cond_3

    .line 413
    :goto_0
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0

    if-eqz p0, :cond_1

    .line 414
    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 415
    if-eqz p0, :cond_0

    const-string v2, "google-pinyin-user-dictionary-"

    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v2, ".txt"

    invoke-virtual {p0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v2, ".txt.partial"

    .line 416
    invoke-virtual {p0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 417
    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    .line 418
    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-static {p1, v3}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-direct {v2, p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 417
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 420
    :cond_0
    goto :goto_0

    .line 422
    :cond_1
    if-eqz v1, :cond_2

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 424
    :cond_2
    new-instance p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;-><init>()V

    invoke-static {v0, p0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 429
    return-object v0

    .line 412
    :cond_3
    :try_start_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "backup directory query failed"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 422
    :catchall_0
    move-exception v0

    move-object p0, v0

    if-eqz v1, :cond_4

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 423
    :cond_4
    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method public static listBackupsAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V
    .locals 2

    .line 377
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 378
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 386
    return-void
.end method

.method private static listConfiguredBackups(Landroid/content/Context;)Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;",
            ">;"
        }
    .end annotation

    .line 389
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 390
    const-string v1, "dictionary_auto_backup_tree_uri"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 391
    if-eqz v0, :cond_2

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_0

    goto :goto_0

    .line 393
    :cond_0
    :try_start_0
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 394
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_1

    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0

    .line 395
    :cond_1
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;Landroid/net/Uri;)Ljava/util/List;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object p0

    .line 396
    :catchall_0
    move-exception p0

    .line 397
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0

    .line 391
    :cond_2
    :goto_0
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0
.end method

.method static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 74
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "dictionary_local_backup_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V
    .locals 8

    .line 189
    nop

    .line 191
    const/4 v1, 0x0

    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->cleanupOldPartials(Landroid/content/Context;Landroid/net/Uri;)V

    .line 192
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v2, "yyyy-MM-dd_HH-mm-ss-SSS"

    sget-object v3, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v0, v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v2, Ljava/util/Date;

    invoke-direct {v2}, Ljava/util/Date;-><init>()V

    .line 193
    invoke-virtual {v0, v2}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    .line 194
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "google-pinyin-user-dictionary-"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ".txt"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 195
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ".partial"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 196
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v2

    .line 197
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const-string v4, "text/plain"

    invoke-static {v3, v2, v4, v0}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 199
    if-eqz v5, :cond_0

    .line 200
    nop

    .line 201
    nop

    .line 202
    :try_start_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-object v3, p0

    move-object v4, p1

    move v7, p2

    :try_start_2
    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;-><init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 210
    goto :goto_2

    .line 207
    :catchall_0
    move-exception v0

    move-object v3, p0

    move v7, p2

    :goto_0
    move-object p0, v0

    move-object v1, v5

    goto :goto_1

    .line 199
    :cond_0
    move-object v3, p0

    move v7, p2

    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "createDocument returned null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 207
    :catchall_1
    move-exception v0

    goto :goto_0

    :catchall_2
    move-exception v0

    move-object v3, p0

    move v7, p2

    move-object p0, v0

    .line 208
    :goto_1
    if-eqz v1, :cond_1

    invoke-static {v3, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 209
    :cond_1
    const-string p1, "\u65e0\u6cd5\u5728\u6240\u9009\u5907\u4efd\u76ee\u5f55\u521b\u5efa\u6587\u4ef6"

    invoke-static {v3, v7, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 211
    :goto_2
    return-void
.end method

.method public static request(Landroid/content/Context;Z)V
    .locals 14

    .line 112
    if-nez p0, :cond_0

    return-void

    .line 113
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 114
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 115
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 118
    const-class v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v3

    .line 119
    :try_start_0
    sget-boolean v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    if-eqz v4, :cond_2

    .line 120
    if-eqz p1, :cond_1

    const-string p1, "\u7528\u6237\u8bcd\u5178\u5907\u4efd\u6b63\u5728\u8fdb\u884c"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 121
    :cond_1
    monitor-exit v3

    return-void

    .line 123
    :cond_2
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x15

    if-ge v4, v5, :cond_4

    .line 124
    if-eqz p1, :cond_3

    const-string p1, "\u81ea\u5b9a\u4e49\u76ee\u5f55\u5907\u4efd\u9700\u8981 Android 5.0 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 125
    :cond_3
    monitor-exit v3

    return-void

    .line 127
    :cond_4
    const/4 v4, 0x0

    if-nez p1, :cond_5

    const-string v5, "dictionary_auto_backup_enabled"

    invoke-interface {v0, v5, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v5

    if-nez v5, :cond_5

    monitor-exit v3

    return-void

    .line 128
    :cond_5
    if-nez p1, :cond_6

    .line 129
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableEntryCount(Landroid/content/Context;)I

    move-result v5

    const-string v6, "dictionary_auto_backup_high_water_entry_count"

    .line 130
    invoke-interface {v0, v6, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    .line 128
    invoke-static {v5, v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v5

    if-eqz v5, :cond_6

    .line 133
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "dictionary_auto_backup_last_status"

    const-string v0, "\u8bcd\u6761\u6570\u6bd4\u5f80\u5e74\u5c11\uff0c\u672c\u6b21\u672a\u81ea\u52a8\u5907\u4efd"

    .line 134
    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 135
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 136
    monitor-exit v3

    return-void

    .line 138
    :cond_6
    const/4 v5, 0x1

    if-nez p1, :cond_a

    .line 139
    const-string v6, "dictionary_auto_backup_interval_days"

    const/4 v7, 0x7

    invoke-interface {v0, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    const/16 v8, 0x16d

    invoke-static {v6, v5, v8, v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result v6

    .line 140
    const-string v7, "dictionary_auto_backup_last_success_time"

    const-wide/16 v8, 0x0

    invoke-interface {v0, v7, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v10

    .line 141
    cmp-long v7, v10, v8

    if-lez v7, :cond_8

    cmp-long v7, v1, v10

    if-ltz v7, :cond_8

    sub-long v10, v1, v10

    int-to-long v6, v6

    const-wide/32 v12, 0x5265c00

    mul-long v6, v6, v12

    cmp-long v12, v10, v6

    if-ltz v12, :cond_7

    goto :goto_0

    :cond_7
    const/4 v6, 0x0

    goto :goto_1

    :cond_8
    :goto_0
    const/4 v6, 0x1

    .line 143
    :goto_1
    if-nez v6, :cond_9

    monitor-exit v3

    return-void

    .line 144
    :cond_9
    const-string v6, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v6, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v6

    .line 145
    cmp-long v10, v6, v8

    if-lez v10, :cond_a

    cmp-long v8, v1, v6

    if-ltz v8, :cond_a

    sub-long v6, v1, v6

    const-wide/32 v8, 0x36ee80

    cmp-long v10, v6, v8

    if-gez v10, :cond_a

    const-string v6, "dictionary_auto_backup_consecutive_failures"

    .line 146
    invoke-interface {v0, v6, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    if-lez v4, :cond_a

    .line 147
    monitor-exit v3

    return-void

    .line 150
    :cond_a
    const-string v4, "dictionary_auto_backup_tree_uri"

    const/4 v6, 0x0

    invoke-interface {v0, v4, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 151
    if-eqz v4, :cond_d

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v6, :cond_b

    goto :goto_2

    .line 156
    :cond_b
    :try_start_1
    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 160
    nop

    .line 161
    :try_start_2
    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v6

    if-nez v6, :cond_c

    .line 162
    const-string v0, "\u5907\u4efd\u548c\u5bfc\u5165\u4f4d\u7f6e\u4e0d\u53ef\u8bbf\u95ee\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 163
    monitor-exit v3

    return-void

    .line 165
    :cond_c
    sput-boolean v5, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    .line 166
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v5, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v5, v1, v2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_last_status"

    const-string v2, "\u6b63\u5728\u5907\u4efd"

    .line 167
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 168
    monitor-exit v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 170
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 171
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;

    invoke-direct {v1, p0, v4, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;-><init>(Landroid/content/Context;Landroid/net/Uri;Z)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 176
    return-void

    .line 157
    :catch_0
    move-exception v0

    .line 158
    :try_start_3
    const-string v0, "\u5907\u4efd\u548c\u5bfc\u5165\u4f4d\u7f6e\u65e0\u6548"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 159
    monitor-exit v3

    return-void

    .line 152
    :cond_d
    :goto_2
    const-string v0, "\u672a\u9009\u62e9\u5907\u4efd\u548c\u5bfc\u5165\u4f4d\u7f6e"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 153
    monitor-exit v3

    return-void

    .line 168
    :catchall_0
    move-exception p0

    monitor-exit v3
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    throw p0
.end method

.method private static rotate(Landroid/content/Context;Landroid/net/Uri;I)Z
    .locals 3

    .line 441
    nop

    .line 443
    const/4 v0, 0x0

    :try_start_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 444
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->keepWholeWindow(Landroid/content/SharedPreferences;)Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    return v2

    .line 445
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;Landroid/net/Uri;)Ljava/util/List;

    move-result-object p1

    .line 446
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 447
    nop

    :goto_0
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    if-ge p2, v1, :cond_2

    .line 449
    :try_start_1
    invoke-interface {p1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->uri:Landroid/net/Uri;

    invoke-static {p0, v1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-nez v1, :cond_1

    const/4 v2, 0x0

    .line 452
    :cond_1
    goto :goto_1

    .line 450
    :catchall_0
    move-exception v1

    .line 451
    const/4 v2, 0x0

    .line 447
    :goto_1
    add-int/lit8 p2, p2, 0x1

    goto :goto_0

    .line 456
    :cond_2
    move v0, v2

    goto :goto_2

    .line 454
    :catchall_1
    move-exception p0

    .line 455
    nop

    .line 457
    :goto_2
    return v0
.end method

.method private static showToast(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 613
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-ne v0, v1, :cond_0

    .line 614
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 616
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$8;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$8;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 622
    :goto_0
    return-void
.end method

.method private static treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;
    .locals 1

    .line 568
    nop

    .line 569
    invoke-static {p0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    .line 568
    invoke-static {p0, v0}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private static validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 319
    nop

    .line 320
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 322
    const/4 v1, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    .line 323
    if-eqz v1, :cond_6

    .line 324
    const/16 p0, 0x2000

    new-array p0, p0, [B

    .line 326
    :goto_0
    invoke-virtual {v1, p0}, Ljava/io/InputStream;->read([B)I

    move-result p1

    const/4 v2, -0x1

    const/4 v3, 0x0

    if-eq p1, v2, :cond_0

    invoke-virtual {v0, p0, v3, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 328
    :cond_0
    if-eqz v1, :cond_1

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 330
    :cond_1
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 331
    nop

    .line 332
    const-string p1, "\ufeff# User dictionary for Google Pinyin Input\n"

    const-string v0, "UTF-16LE"

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    .line 333
    array-length v0, p0

    array-length v1, p1

    if-lt v0, v1, :cond_5

    .line 334
    const/4 v0, 0x0

    :goto_1
    array-length v1, p1

    if-ge v0, v1, :cond_3

    .line 335
    aget-byte v1, p0, v0

    aget-byte v2, p1, v0

    if-ne v1, v2, :cond_2

    .line 334
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 335
    :cond_2
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "invalid backup header"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 337
    :cond_3
    const-string p1, "SHA-256"

    invoke-static {p1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p1

    .line 338
    invoke-virtual {p1, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p1

    .line 339
    new-instance v0, Ljava/lang/StringBuilder;

    array-length v1, p1

    mul-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 340
    array-length v1, p1

    const/4 v2, 0x0

    :goto_2
    if-ge v2, v1, :cond_4

    aget-byte v4, p1, v2

    sget-object v5, Ljava/util/Locale;->US:Ljava/util/Locale;

    and-int/lit16 v4, v4, 0xff

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v6, 0x1

    new-array v6, v6, [Ljava/lang/Object;

    aput-object v4, v6, v3

    const-string v4, "%02x"

    invoke-static {v5, v4, v6}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 341
    :cond_4
    new-instance p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->countEntries([B)I

    move-result p0

    invoke-direct {p1, v0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;-><init>(Ljava/lang/String;I)V

    return-object p1

    .line 333
    :cond_5
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "backup too short"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 323
    :cond_6
    :try_start_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "openInputStream returned null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 328
    :catchall_0
    move-exception p0

    if-eqz v1, :cond_7

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 329
    :cond_7
    goto :goto_4

    :goto_3
    throw p0

    :goto_4
    goto :goto_3
.end method

.method private static validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 7

    .line 529
    const-string v0, ".tmp"

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isSupportedTree(Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string p0, "\u8bf7\u9009\u62e9\u7cfb\u7edf\u76ee\u5f55\u9009\u62e9\u5668\u63d0\u4f9b\u7684\u6587\u4ef6\u5939"

    return-object p0

    .line 530
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_1

    const-string p0, "\u672a\u83b7\u5f97\u6240\u9009\u76ee\u5f55\u7684\u6301\u4e45\u8bfb\u5199\u6743\u9650"

    return-object p0

    .line 531
    :cond_1
    nop

    .line 532
    nop

    .line 534
    const/4 v1, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 535
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object p1

    .line 536
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v3

    invoke-virtual {v3}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v3

    .line 537
    const-string v4, "text/plain"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, ".google-pinyin-backup-test-"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, p1, v4, v5}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_3

    .line 539
    if-nez p1, :cond_3

    :try_start_1
    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u521b\u5efa\u5907\u4efd\u6587\u4ef6"
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 562
    if-eqz p1, :cond_2

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 563
    :cond_2
    nop

    .line 539
    return-object v0

    .line 540
    :cond_3
    :try_start_2
    const-string v4, "w"

    invoke-virtual {v2, p1, v4}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object v4

    .line 541
    if-nez v4, :cond_5

    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5199\u5165\u5907\u4efd\u6587\u4ef6"
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    .line 562
    if-eqz p1, :cond_4

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 563
    :cond_4
    nop

    .line 541
    return-object v0

    .line 542
    :cond_5
    const/4 v5, 0x3

    :try_start_3
    new-array v5, v5, [B

    fill-array-data v5, :array_0

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    .line 543
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V

    .line 544
    invoke-virtual {v2, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v4

    .line 545
    if-eqz v4, :cond_c

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x47

    if-ne v5, v6, :cond_c

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x50

    if-ne v5, v6, :cond_c

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x49

    if-eq v5, v6, :cond_6

    goto :goto_0

    .line 549
    :cond_6
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 550
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, ".google-pinyin-backup-test-renamed-"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, p1, v0}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 552
    if-nez v0, :cond_9

    :try_start_4
    const-string v1, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5b89\u5168\u53d1\u5e03\u5907\u4efd\u6587\u4ef6"
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 562
    if-eqz p1, :cond_7

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 563
    :cond_7
    if-eqz v0, :cond_8

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 552
    :cond_8
    return-object v1

    .line 559
    :catchall_0
    move-exception v1

    goto :goto_1

    .line 553
    :cond_9
    nop

    .line 554
    :try_start_5
    invoke-static {v2, v0}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_b

    .line 555
    const-string p1, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5220\u9664\u65e7\u5907\u4efd\u7248\u672c"
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    .line 562
    nop

    .line 563
    if-eqz v0, :cond_a

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 555
    :cond_a
    return-object p1

    .line 557
    :cond_b
    nop

    .line 558
    nop

    .line 562
    nop

    .line 563
    nop

    .line 558
    return-object v1

    .line 559
    :catchall_1
    move-exception p1

    goto :goto_2

    .line 546
    :cond_c
    :goto_0
    if-eqz v4, :cond_d

    :try_start_6
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 547
    :cond_d
    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u53ef\u9760\u8bfb\u53d6\u5907\u4efd\u6587\u4ef6"
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    .line 562
    if-eqz p1, :cond_e

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 563
    :cond_e
    nop

    .line 547
    return-object v0

    .line 559
    :catchall_2
    move-exception v0

    move-object v0, v1

    :goto_1
    move-object v1, p1

    goto :goto_2

    :catchall_3
    move-exception p1

    move-object v0, v1

    .line 560
    :goto_2
    :try_start_7
    const-string p1, "\u6240\u9009\u5b58\u50a8\u4f4d\u7f6e\u4e0d\u652f\u6301\u5b89\u5168\u81ea\u52a8\u5907\u4efd"
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_4

    .line 562
    if-eqz v1, :cond_f

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 563
    :cond_f
    if-eqz v0, :cond_10

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 560
    :cond_10
    return-object p1

    .line 562
    :catchall_4
    move-exception p1

    if-eqz v1, :cond_11

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 563
    :cond_11
    if-eqz v0, :cond_12

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 564
    :cond_12
    throw p1

    :array_0
    .array-data 1
        0x47t
        0x50t
        0x49t
    .end array-data
.end method

.method static validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V
    .locals 2

    .line 515
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 516
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;

    invoke-direct {v1, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 526
    return-void
.end method
