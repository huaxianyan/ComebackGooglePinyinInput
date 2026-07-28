.class public final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
    }
.end annotation


# static fields
.field private static final DAY_MS:J = 0x5265c00L

.field static final EXTERNAL_STORAGE_AUTHORITY:Ljava/lang/String; = "com.android.externalstorage.documents"

.field private static final FINAL_SUFFIX:Ljava/lang/String; = ".txt"

.field private static final HOUR_MS:J = 0x36ee80L

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field static final KEY_BACKUP_NOW:Ljava/lang/String; = "dictionary_auto_backup_now"

.field static final KEY_ENABLED:Ljava/lang/String; = "dictionary_auto_backup_enabled"

.field static final KEY_FAILURES:Ljava/lang/String; = "dictionary_auto_backup_consecutive_failures"

.field static final KEY_IMPORT_BACKUP:Ljava/lang/String; = "dictionary_auto_backup_import"

.field static final KEY_INTERVAL:Ljava/lang/String; = "dictionary_auto_backup_interval_days"

.field static final KEY_LAST_ATTEMPT:Ljava/lang/String; = "dictionary_auto_backup_last_attempt_time"

.field static final KEY_LAST_SHA256:Ljava/lang/String; = "dictionary_auto_backup_last_sha256"

.field static final KEY_LAST_STATUS:Ljava/lang/String; = "dictionary_auto_backup_last_status"

.field static final KEY_LAST_SUCCESS:Ljava/lang/String; = "dictionary_auto_backup_last_success_time"

.field static final KEY_LAST_URI:Ljava/lang/String; = "dictionary_auto_backup_last_document_uri"

.field static final KEY_RETENTION:Ljava/lang/String; = "dictionary_auto_backup_retention_count"

.field static final KEY_TREE_LABEL:Ljava/lang/String; = "dictionary_auto_backup_tree_label"

.field static final KEY_TREE_URI:Ljava/lang/String; = "dictionary_auto_backup_tree_uri"

.field private static final MAIN:Landroid/os/Handler;

.field private static final PARTIAL_MAX_AGE_MS:J = 0x5265c00L

.field private static final PARTIAL_SUFFIX:Ljava/lang/String; = ".txt.partial"

.field private static final PREFIX:Ljava/lang/String; = "google-pinyin-user-dictionary-"

.field static final PREFS:Ljava/lang/String; = "dictionary_local_backup_preferences"

.field private static sInProgress:Z


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 59
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    .line 60
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 63
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 3

    .line 35
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 5

    .line 35
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1000(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 5

    .line 35
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1100()Ljava/util/concurrent/ExecutorService;
    .registers 1

    .line 35
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-object v0
.end method

.method static synthetic access$1200(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 2

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1300()Landroid/os/Handler;
    .registers 1

    .line 35
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic access$1400(Landroid/content/Context;Ljava/lang/String;)V
    .registers 2

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$400(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 2

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    return-void
.end method

.method static synthetic access$700(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    .registers 4

    .line 35
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static clamp(IIII)I
    .registers 4

    .line 500
    if-lt p0, p1, :cond_4

    if-le p0, p2, :cond_5

    :cond_4
    move p0, p3

    :cond_5
    return p0
.end method

.method private static cleanupOldPartials(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 15

    .line 364
    nop

    .line 366
    const/4 v1, 0x0

    :try_start_2
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 367
    nop

    .line 368
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    .line 367
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    .line 369
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

    .line 374
    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v5, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1
    :try_end_28
    .catchall {:try_start_2 .. :try_end_28} :catchall_82

    .line 375
    if-nez v1, :cond_30

    .line 391
    if-eqz v1, :cond_2f

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 375
    :cond_2f
    return-void

    .line 376
    :cond_30
    :try_start_30
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    .line 377
    :goto_34
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0

    if-eqz p0, :cond_7f

    .line 378
    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 379
    invoke-interface {v1, v10}, Landroid/database/Cursor;->isNull(I)Z

    move-result v0

    const-wide/16 v5, 0x0

    if-eqz v0, :cond_48

    move-wide v11, v5

    goto :goto_4c

    :cond_48
    invoke-interface {v1, v10}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v11

    .line 380
    :goto_4c
    if-eqz p0, :cond_7e

    const-string v0, "google-pinyin-user-dictionary-"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_7e

    const-string v0, ".txt.partial"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_7e

    cmp-long p0, v11, v5

    if-lez p0, :cond_7e

    cmp-long p0, v3, v11

    if-ltz p0, :cond_7e

    sub-long v5, v3, v11

    const-wide/32 v11, 0x5265c00

    cmp-long p0, v5, v11

    if-ltz p0, :cond_7e

    .line 383
    nop

    .line 384
    invoke-interface {v1, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 383
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0
    :try_end_78
    .catchall {:try_start_30 .. :try_end_78} :catchall_82

    .line 385
    :try_start_78
    invoke-static {v2, p0}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_7b
    .catchall {:try_start_78 .. :try_end_7b} :catchall_7c

    .line 386
    :goto_7b
    goto :goto_7e

    :catchall_7c
    move-exception v0

    goto :goto_7b

    .line 388
    :cond_7e
    :goto_7e
    goto :goto_34

    .line 391
    :cond_7f
    if-eqz v1, :cond_88

    goto :goto_85

    .line 389
    :catchall_82
    move-exception v0

    .line 391
    if-eqz v1, :cond_88

    :goto_85
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 393
    :cond_88
    return-void
.end method

.method private static deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 2

    .line 483
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-static {p0, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_8

    goto :goto_9

    .line 484
    :catchall_8
    move-exception p0

    :goto_9
    nop

    .line 485
    return-void
.end method

.method private static enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 20

    .line 189
    const-string v6, "a"

    :try_start_2
    const-string v0, "aib"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    .line 190
    const/4 v8, 0x0

    new-array v0, v8, [Ljava/lang/Class;

    invoke-virtual {v7, v6, v0}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v8, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    .line 191
    const-string v0, "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v10

    .line 193
    const-string v0, "beg"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 194
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

    .line 196
    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
    :try_end_39
    .catchall {:try_start_2 .. :try_end_39} :catchall_77

    move-object v1, p0

    move-object/from16 v2, p1

    move-object/from16 v3, p2

    move-object/from16 v4, p3

    move/from16 v5, p4

    :try_start_42
    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;-><init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 197
    new-array v2, v11, [Ljava/lang/Object;

    aput-object p0, v2, v8

    aput-object v0, v2, v12

    aput-object v3, v2, v13

    invoke-virtual {v14, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 198
    new-array v2, v11, [Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    aput-object v4, v2, v8

    aput-object v10, v2, v12

    sget-object v4, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v4, v2, v13

    invoke-virtual {v7, v6, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    .line 200
    const-wide/16 v4, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    new-array v5, v11, [Ljava/lang/Object;

    const-string v6, "user_dict_auto_backup"

    aput-object v6, v5, v8

    aput-object v0, v5, v12

    aput-object v4, v5, v13

    invoke-virtual {v2, v9, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_74
    .catchall {:try_start_42 .. :try_end_74} :catchall_75

    .line 204
    goto :goto_84

    .line 201
    :catchall_75
    move-exception v0

    goto :goto_7a

    :catchall_77
    move-exception v0

    move-object/from16 v3, p2

    .line 202
    :goto_7a
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 203
    const-string v2, "\u65e0\u6cd5\u542f\u52a8\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa"

    move/from16 v5, p4

    invoke-static {p0, v5, v2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 205
    :goto_84
    return-void
.end method

.method private static failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V
    .registers 8

    .line 152
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 153
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_attempt_time"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    invoke-interface {v1, v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 154
    const-string v2, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 155
    const-string v2, "dictionary_auto_backup_consecutive_failures"

    const/4 v3, 0x0

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 156
    if-eqz p1, :cond_2d

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 157
    :cond_2d
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 158
    return-void
.end method

.method private static finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 12

    .line 246
    const-string v0, "dictionary_auto_backup_last_status"

    :try_start_2
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    .line 247
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-static {v2, p2, p3}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p3

    .line 249
    if-eqz p3, :cond_68

    .line 250
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 251
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    .line 252
    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    const-string v6, "dictionary_auto_backup_last_success_time"

    invoke-interface {v5, v6, v2, v3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "\u5907\u4efd\u6210\u529f"

    .line 253
    invoke-interface {v2, v0, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "dictionary_auto_backup_last_document_uri"

    .line 254
    invoke-virtual {p3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-interface {v2, v3, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v2, "dictionary_auto_backup_last_sha256"

    .line 255
    invoke-interface {p3, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v1, "dictionary_auto_backup_consecutive_failures"

    .line 256
    const/4 v2, 0x0

    invoke-interface {p3, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 257
    const-string p3, "dictionary_auto_backup_retention_count"

    .line 258
    const/16 v1, 0xa

    invoke-interface {v4, p3, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p3

    const/4 v2, 0x1

    const/16 v3, 0x64

    invoke-static {p3, v2, v3, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result p3

    .line 257
    invoke-static {p0, p1, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->rotate(Landroid/content/Context;Landroid/net/Uri;I)Z

    move-result p1

    .line 259
    if-nez p1, :cond_64

    .line 260
    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string p3, "\u5907\u4efd\u6210\u529f\uff0c\u4f46\u65e7\u7248\u672c\u6e05\u7406\u5931\u8d25"

    invoke-interface {p1, v0, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 262
    :cond_64
    invoke-static {p0, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishSuccess(Landroid/content/Context;Z)V

    .line 266
    goto :goto_79

    .line 249
    :cond_68
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p3, "renameDocument returned null"

    invoke-direct {p1, p3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_70
    .catchall {:try_start_2 .. :try_end_70} :catchall_70

    .line 263
    :catchall_70
    move-exception p1

    .line 264
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 265
    const-string p2, "\u672c\u5730\u5907\u4efd\u6821\u9a8c\u6216\u53d1\u5e03\u5931\u8d25"

    invoke-static {p0, p4, p2, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 267
    :goto_79
    return-void
.end method

.method private static finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    .registers 8

    .line 470
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p3

    .line 471
    invoke-interface {p3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_last_status"

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_consecutive_failures"

    const-string v2, "dictionary_auto_backup_consecutive_failures"

    .line 472
    const/4 v3, 0x0

    invoke-interface {p3, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p3

    add-int/lit8 p3, p3, 0x1

    invoke-interface {v0, v1, p3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 473
    const-class p3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter p3

    :try_start_23
    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit p3
    :try_end_26
    .catchall {:try_start_23 .. :try_end_26} :catchall_31

    .line 474
    sget-object p3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;

    invoke-direct {v0, p1, p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;-><init>(ZLandroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {p3, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 480
    return-void

    .line 473
    :catchall_31
    move-exception p0

    :try_start_32
    monitor-exit p3
    :try_end_33
    .catchall {:try_start_32 .. :try_end_33} :catchall_31

    throw p0
.end method

.method private static finishSuccess(Landroid/content/Context;Z)V
    .registers 4

    .line 459
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    const/4 v1, 0x0

    :try_start_4
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit v0
    :try_end_7
    .catchall {:try_start_4 .. :try_end_7} :catchall_12

    .line 460
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;

    invoke-direct {v1, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;-><init>(ZLandroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 466
    return-void

    .line 459
    :catchall_12
    move-exception p0

    :try_start_13
    monitor-exit v0
    :try_end_14
    .catchall {:try_start_13 .. :try_end_14} :catchall_12

    throw p0
.end method

.method static hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 5

    .line 80
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-lt v0, v1, :cond_42

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isLocalTree(Landroid/net/Uri;)Z

    move-result v0

    if-nez v0, :cond_e

    goto :goto_42

    .line 82
    :cond_e
    :try_start_e
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/ContentResolver;->getPersistedUriPermissions()Ljava/util/List;

    move-result-object p0

    .line 83
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_1a
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3f

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/UriPermission;

    .line 84
    invoke-virtual {v0}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {p1, v1}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3e

    invoke-virtual {v0}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v1

    if-eqz v1, :cond_3e

    .line 85
    invoke-virtual {v0}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v0
    :try_end_3a
    .catch Ljava/lang/RuntimeException; {:try_start_e .. :try_end_3a} :catch_40

    if-eqz v0, :cond_3e

    .line 86
    const/4 p0, 0x1

    return p0

    .line 88
    :cond_3e
    goto :goto_1a

    .line 90
    :cond_3f
    goto :goto_41

    .line 89
    :catch_40
    move-exception p0

    .line 91
    :goto_41
    return v2

    .line 80
    :cond_42
    :goto_42
    return v2
.end method

.method public static isInProgress()Z
    .registers 2

    .line 70
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    .line 71
    :try_start_3
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit v0

    return v1

    .line 72
    :catchall_7
    move-exception v1

    monitor-exit v0
    :try_end_9
    .catchall {:try_start_3 .. :try_end_9} :catchall_7

    throw v1
.end method

.method static isLocalTree(Landroid/net/Uri;)Z
    .registers 2

    .line 76
    if-eqz p0, :cond_10

    const-string v0, "com.android.externalstorage.documents"

    invoke-virtual {p0}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_10

    const/4 p0, 0x1

    goto :goto_11

    :cond_10
    const/4 p0, 0x0

    :goto_11
    return p0
.end method

.method static listBackups(Landroid/content/Context;)Ljava/util/List;
    .registers 4
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

    .line 296
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 297
    const-string v1, "dictionary_auto_backup_tree_uri"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 298
    if-eqz v0, :cond_30

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_14

    goto :goto_30

    .line 300
    :cond_14
    :try_start_14
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 301
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_24

    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0

    .line 302
    :cond_24
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;Landroid/net/Uri;)Ljava/util/List;

    move-result-object p0
    :try_end_28
    .catchall {:try_start_14 .. :try_end_28} :catchall_29

    return-object p0

    .line 303
    :catchall_29
    move-exception p0

    .line 304
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0

    .line 298
    :cond_30
    :goto_30
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0
.end method

.method private static listBackups(Landroid/content/Context;Landroid/net/Uri;)Ljava/util/List;
    .registers 13
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

    .line 309
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 310
    nop

    .line 312
    nop

    .line 313
    const/4 v1, 0x0

    :try_start_8
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v2

    .line 312
    invoke-static {p1, v2}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    .line 314
    const/4 v2, 0x2

    new-array v5, v2, [Ljava/lang/String;

    const-string v2, "document_id"

    const/4 v9, 0x0

    aput-object v2, v5, v9

    const-string v2, "_display_name"

    const/4 v10, 0x1

    aput-object v2, v5, v10

    .line 318
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v6, 0x0

    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 319
    if-eqz v1, :cond_6d

    .line 320
    :goto_2a
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0

    if-eqz p0, :cond_5f

    .line 321
    invoke-interface {v1, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 322
    if-eqz p0, :cond_5e

    const-string v2, "google-pinyin-user-dictionary-"

    invoke-virtual {p0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_5e

    const-string v2, ".txt"

    invoke-virtual {p0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_5e

    const-string v2, ".txt.partial"

    .line 323
    invoke-virtual {p0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_5e

    .line 324
    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    .line 325
    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-static {p1, v3}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-direct {v2, p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 324
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_5e
    .catchall {:try_start_8 .. :try_end_5e} :catchall_75

    .line 327
    :cond_5e
    goto :goto_2a

    .line 329
    :cond_5f
    if-eqz v1, :cond_64

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 331
    :cond_64
    new-instance p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;-><init>()V

    invoke-static {v0, p0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 336
    return-object v0

    .line 319
    :cond_6d
    :try_start_6d
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "backup directory query failed"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_75
    .catchall {:try_start_6d .. :try_end_75} :catchall_75

    .line 329
    :catchall_75
    move-exception v0

    move-object p0, v0

    if-eqz v1, :cond_7c

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 330
    :cond_7c
    goto :goto_7e

    :goto_7d
    throw p0

    :goto_7e
    goto :goto_7d
.end method

.method static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .registers 3

    .line 66
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "dictionary_local_backup_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 11

    .line 162
    nop

    .line 164
    const/4 v1, 0x0

    :try_start_2
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->cleanupOldPartials(Landroid/content/Context;Landroid/net/Uri;)V

    .line 165
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v2, "yyyy-MM-dd_HH-mm-ss-SSS"

    sget-object v3, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v0, v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v2, Ljava/util/Date;

    invoke-direct {v2}, Ljava/util/Date;-><init>()V

    .line 166
    invoke-virtual {v0, v2}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    .line 167
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

    .line 168
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ".partial"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 169
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v2

    .line 170
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const-string v4, "text/plain"

    invoke-static {v3, v2, v4, v0}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5
    :try_end_51
    .catchall {:try_start_2 .. :try_end_51} :catchall_75

    .line 172
    if-eqz v5, :cond_69

    .line 173
    nop

    .line 174
    nop

    .line 175
    :try_start_55
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;
    :try_end_59
    .catchall {:try_start_55 .. :try_end_59} :catchall_63

    move-object v3, p0

    move-object v4, p1

    move v7, p2

    :try_start_5c
    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;-><init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 183
    goto :goto_83

    .line 180
    :catchall_63
    move-exception v0

    move-object v3, p0

    move v7, p2

    :goto_66
    move-object p0, v0

    move-object v1, v5

    goto :goto_79

    .line 172
    :cond_69
    move-object v3, p0

    move v7, p2

    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "createDocument returned null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_73
    .catchall {:try_start_5c .. :try_end_73} :catchall_73

    .line 180
    :catchall_73
    move-exception v0

    goto :goto_66

    :catchall_75
    move-exception v0

    move-object v3, p0

    move v7, p2

    move-object p0, v0

    .line 181
    :goto_79
    if-eqz v1, :cond_7e

    invoke-static {v3, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 182
    :cond_7e
    const-string p1, "\u65e0\u6cd5\u5728\u672c\u5730\u5907\u4efd\u76ee\u5f55\u521b\u5efa\u6587\u4ef6"

    invoke-static {v3, v7, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 184
    :goto_83
    return-void
.end method

.method public static request(Landroid/content/Context;Z)V
    .registers 16

    .line 95
    if-nez p0, :cond_3

    return-void

    .line 96
    :cond_3
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 97
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 98
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 101
    const-class v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v3

    .line 102
    :try_start_12
    sget-boolean v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    if-eqz v4, :cond_1f

    .line 103
    if-eqz p1, :cond_1d

    const-string p1, "\u672c\u5730\u8bcd\u5178\u5907\u4efd\u6b63\u5728\u8fdb\u884c"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 104
    :cond_1d
    monitor-exit v3

    return-void

    .line 106
    :cond_1f
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x15

    if-ge v4, v5, :cond_2e

    .line 107
    if-eqz p1, :cond_2c

    const-string p1, "\u672c\u5730\u81ea\u52a8\u5907\u4efd\u9700\u8981 Android 5.0 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 108
    :cond_2c
    monitor-exit v3

    return-void

    .line 110
    :cond_2e
    const/4 v4, 0x0

    if-nez p1, :cond_3b

    const-string v5, "dictionary_auto_backup_enabled"

    invoke-interface {v0, v5, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v5

    if-nez v5, :cond_3b

    monitor-exit v3

    return-void

    .line 111
    :cond_3b
    const/4 v5, 0x1

    if-nez p1, :cond_90

    .line 112
    const-string v6, "dictionary_auto_backup_interval_days"

    const/4 v7, 0x7

    invoke-interface {v0, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    const/16 v8, 0x16d

    invoke-static {v6, v5, v8, v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result v6

    .line 113
    const-string v7, "dictionary_auto_backup_last_success_time"

    const-wide/16 v8, 0x0

    invoke-interface {v0, v7, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v10

    .line 114
    cmp-long v7, v10, v8

    if-lez v7, :cond_6a

    cmp-long v7, v1, v10

    if-ltz v7, :cond_6a

    sub-long v10, v1, v10

    int-to-long v6, v6

    const-wide/32 v12, 0x5265c00

    mul-long v6, v6, v12

    cmp-long v12, v10, v6

    if-ltz v12, :cond_68

    goto :goto_6a

    :cond_68
    const/4 v6, 0x0

    goto :goto_6b

    :cond_6a
    :goto_6a
    const/4 v6, 0x1

    .line 116
    :goto_6b
    if-nez v6, :cond_6f

    monitor-exit v3

    return-void

    .line 117
    :cond_6f
    const-string v6, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v6, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v6

    .line 118
    cmp-long v10, v6, v8

    if-lez v10, :cond_90

    cmp-long v8, v1, v6

    if-ltz v8, :cond_90

    sub-long v6, v1, v6

    const-wide/32 v8, 0x36ee80

    cmp-long v10, v6, v8

    if-gez v10, :cond_90

    const-string v6, "dictionary_auto_backup_consecutive_failures"

    .line 119
    invoke-interface {v0, v6, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    if-lez v4, :cond_90

    .line 120
    monitor-exit v3

    return-void

    .line 123
    :cond_90
    const-string v4, "dictionary_auto_backup_tree_uri"

    const/4 v6, 0x0

    invoke-interface {v0, v4, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 124
    if-eqz v4, :cond_e0

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6
    :try_end_9d
    .catchall {:try_start_12 .. :try_end_9d} :catchall_e7

    if-nez v6, :cond_a0

    goto :goto_e0

    .line 129
    :cond_a0
    :try_start_a0
    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4
    :try_end_a4
    .catch Ljava/lang/RuntimeException; {:try_start_a0 .. :try_end_a4} :catch_d8
    .catchall {:try_start_a0 .. :try_end_a4} :catchall_e7

    .line 133
    nop

    .line 134
    :try_start_a5
    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v6

    if-nez v6, :cond_b2

    .line 135
    const-string v0, "\u5907\u4efd\u548c\u5bfc\u5165\u4f4d\u7f6e\u4e0d\u53ef\u8bbf\u95ee\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 136
    monitor-exit v3

    return-void

    .line 138
    :cond_b2
    sput-boolean v5, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    .line 139
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v5, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v5, v1, v2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_last_status"

    const-string v2, "\u6b63\u5728\u5907\u4efd"

    .line 140
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 141
    monitor-exit v3
    :try_end_ca
    .catchall {:try_start_a5 .. :try_end_ca} :catchall_e7

    .line 143
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 144
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;

    invoke-direct {v1, p0, v4, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;-><init>(Landroid/content/Context;Landroid/net/Uri;Z)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 149
    return-void

    .line 130
    :catch_d8
    move-exception v0

    .line 131
    :try_start_d9
    const-string v0, "\u5907\u4efd\u548c\u5bfc\u5165\u4f4d\u7f6e\u65e0\u6548"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 132
    monitor-exit v3

    return-void

    .line 125
    :cond_e0
    :goto_e0
    const-string v0, "\u672a\u9009\u62e9\u5907\u4efd\u548c\u5bfc\u5165\u4f4d\u7f6e"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 126
    monitor-exit v3

    return-void

    .line 141
    :catchall_e7
    move-exception p0

    monitor-exit v3
    :try_end_e9
    .catchall {:try_start_d9 .. :try_end_e9} :catchall_e7

    throw p0
.end method

.method private static rotate(Landroid/content/Context;Landroid/net/Uri;I)Z
    .registers 6

    .line 346
    nop

    .line 348
    const/4 v0, 0x0

    :try_start_2
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;Landroid/net/Uri;)Ljava/util/List;

    move-result-object p1

    .line 349
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 350
    const/4 v1, 0x1

    :goto_b
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v2
    :try_end_f
    .catchall {:try_start_2 .. :try_end_f} :catchall_28

    if-ge p2, v2, :cond_26

    .line 352
    :try_start_11
    invoke-interface {p1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->uri:Landroid/net/Uri;

    invoke-static {p0, v2}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result v2
    :try_end_1d
    .catchall {:try_start_11 .. :try_end_1d} :catchall_21

    if-nez v2, :cond_20

    const/4 v1, 0x0

    .line 355
    :cond_20
    goto :goto_23

    .line 353
    :catchall_21
    move-exception v1

    .line 354
    const/4 v1, 0x0

    .line 350
    :goto_23
    add-int/lit8 p2, p2, 0x1

    goto :goto_b

    .line 359
    :cond_26
    move v0, v1

    goto :goto_2a

    .line 357
    :catchall_28
    move-exception p0

    .line 358
    nop

    .line 360
    :goto_2a
    return v0
.end method

.method private static showToast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 488
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-ne v0, v1, :cond_13

    .line 489
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    goto :goto_1d

    .line 491
    :cond_13
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 497
    :goto_1d
    return-void
.end method

.method private static treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;
    .registers 2

    .line 454
    nop

    .line 455
    invoke-static {p0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    .line 454
    invoke-static {p0, v0}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private static validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 270
    nop

    .line 271
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 273
    const/4 v1, 0x0

    :try_start_7
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    .line 274
    if-eqz v1, :cond_8a

    .line 275
    const/16 p0, 0x2000

    new-array p0, p0, [B

    .line 277
    :goto_15
    invoke-virtual {v1, p0}, Ljava/io/InputStream;->read([B)I

    move-result p1

    const/4 v2, -0x1

    const/4 v3, 0x0

    if-eq p1, v2, :cond_21

    invoke-virtual {v0, p0, v3, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_20
    .catchall {:try_start_7 .. :try_end_20} :catchall_92

    goto :goto_15

    .line 279
    :cond_21
    if-eqz v1, :cond_26

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 281
    :cond_26
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 282
    nop

    .line 283
    const-string p1, "\ufeff# User dictionary for Google Pinyin Input\n"

    const-string v0, "UTF-16LE"

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    .line 284
    array-length v0, p0

    array-length v1, p1

    if-lt v0, v1, :cond_82

    .line 285
    const/4 v0, 0x0

    :goto_38
    array-length v1, p1

    if-ge v0, v1, :cond_4c

    .line 286
    aget-byte v1, p0, v0

    aget-byte v2, p1, v0

    if-ne v1, v2, :cond_44

    .line 285
    add-int/lit8 v0, v0, 0x1

    goto :goto_38

    .line 286
    :cond_44
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "invalid backup header"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 288
    :cond_4c
    const-string p1, "SHA-256"

    invoke-static {p1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p1

    .line 289
    invoke-virtual {p1, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0

    .line 290
    new-instance p1, Ljava/lang/StringBuilder;

    array-length v0, p0

    mul-int/lit8 v0, v0, 0x2

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 291
    array-length v0, p0

    const/4 v1, 0x0

    :goto_60
    if-ge v1, v0, :cond_7d

    aget-byte v2, p0, v1

    sget-object v4, Ljava/util/Locale;->US:Ljava/util/Locale;

    and-int/lit16 v2, v2, 0xff

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v5, 0x1

    new-array v5, v5, [Ljava/lang/Object;

    aput-object v2, v5, v3

    const-string v2, "%02x"

    invoke-static {v4, v2, v5}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_60

    .line 292
    :cond_7d
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 284
    :cond_82
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "backup too short"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 274
    :cond_8a
    :try_start_8a
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "openInputStream returned null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_92
    .catchall {:try_start_8a .. :try_end_92} :catchall_92

    .line 279
    :catchall_92
    move-exception p0

    if-eqz v1, :cond_98

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 280
    :cond_98
    goto :goto_9a

    :goto_99
    throw p0

    :goto_9a
    goto :goto_99
.end method

.method private static validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 9

    .line 415
    const-string v0, ".tmp"

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isLocalTree(Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_b

    const-string p0, "\u8bf7\u9009\u62e9\u8bbe\u5907\u5185\u90e8\u5b58\u50a8\u6216\u672c\u673a SD \u5361\u76ee\u5f55"

    return-object p0

    .line 416
    :cond_b
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_14

    const-string p0, "\u672a\u83b7\u5f97\u672c\u5730\u76ee\u5f55\u7684\u8bfb\u5199\u6743\u9650"

    return-object p0

    .line 417
    :cond_14
    nop

    .line 418
    nop

    .line 420
    const/4 v1, 0x0

    :try_start_17
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 421
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object p1

    .line 422
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v3

    invoke-virtual {v3}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v3

    .line 423
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
    :try_end_44
    .catchall {:try_start_17 .. :try_end_44} :catchall_e3

    .line 425
    if-nez p1, :cond_4f

    :try_start_46
    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u521b\u5efa\u5907\u4efd\u6587\u4ef6"
    :try_end_48
    .catchall {:try_start_46 .. :try_end_48} :catchall_df

    .line 448
    if-eqz p1, :cond_4d

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 449
    :cond_4d
    nop

    .line 425
    return-object v0

    .line 426
    :cond_4f
    :try_start_4f
    const-string v4, "w"

    invoke-virtual {v2, p1, v4}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object v4

    .line 427
    if-nez v4, :cond_60

    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5199\u5165\u5907\u4efd\u6587\u4ef6"
    :try_end_59
    .catchall {:try_start_4f .. :try_end_59} :catchall_df

    .line 448
    if-eqz p1, :cond_5e

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 449
    :cond_5e
    nop

    .line 427
    return-object v0

    .line 428
    :cond_60
    const/4 v5, 0x3

    :try_start_61
    new-array v5, v5, [B

    fill-array-data v5, :array_fe

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    .line 429
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V

    .line 430
    invoke-virtual {v2, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v4

    .line 431
    if-eqz v4, :cond_d1

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x47

    if-ne v5, v6, :cond_d1

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x50

    if-ne v5, v6, :cond_d1

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x49

    if-eq v5, v6, :cond_8b

    goto :goto_d1

    .line 435
    :cond_8b
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 436
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
    :try_end_a9
    .catchall {:try_start_61 .. :try_end_a9} :catchall_df

    .line 438
    if-nez v0, :cond_ba

    :try_start_ab
    const-string v1, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5b89\u5168\u53d1\u5e03\u5907\u4efd\u6587\u4ef6"
    :try_end_ad
    .catchall {:try_start_ab .. :try_end_ad} :catchall_b8

    .line 448
    if-eqz p1, :cond_b2

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 449
    :cond_b2
    if-eqz v0, :cond_b7

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 438
    :cond_b7
    return-object v1

    .line 445
    :catchall_b8
    move-exception v1

    goto :goto_e1

    .line 439
    :cond_ba
    nop

    .line 440
    :try_start_bb
    invoke-static {v2, v0}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_ca

    .line 441
    const-string p1, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5220\u9664\u65e7\u5907\u4efd\u7248\u672c"
    :try_end_c3
    .catchall {:try_start_bb .. :try_end_c3} :catchall_cf

    .line 448
    nop

    .line 449
    if-eqz v0, :cond_c9

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 441
    :cond_c9
    return-object p1

    .line 443
    :cond_ca
    nop

    .line 444
    nop

    .line 448
    nop

    .line 449
    nop

    .line 444
    return-object v1

    .line 445
    :catchall_cf
    move-exception p1

    goto :goto_e5

    .line 432
    :cond_d1
    :goto_d1
    if-eqz v4, :cond_d6

    :try_start_d3
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 433
    :cond_d6
    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u53ef\u9760\u8bfb\u53d6\u5907\u4efd\u6587\u4ef6"
    :try_end_d8
    .catchall {:try_start_d3 .. :try_end_d8} :catchall_df

    .line 448
    if-eqz p1, :cond_dd

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 449
    :cond_dd
    nop

    .line 433
    return-object v0

    .line 445
    :catchall_df
    move-exception v0

    move-object v0, v1

    :goto_e1
    move-object v1, p1

    goto :goto_e5

    :catchall_e3
    move-exception p1

    move-object v0, v1

    .line 446
    :goto_e5
    :try_start_e5
    const-string p1, "\u8be5\u672c\u5730\u76ee\u5f55\u4e0d\u652f\u6301\u5b89\u5168\u81ea\u52a8\u5907\u4efd"
    :try_end_e7
    .catchall {:try_start_e5 .. :try_end_e7} :catchall_f2

    .line 448
    if-eqz v1, :cond_ec

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 449
    :cond_ec
    if-eqz v0, :cond_f1

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 446
    :cond_f1
    return-object p1

    .line 448
    :catchall_f2
    move-exception p1

    if-eqz v1, :cond_f8

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 449
    :cond_f8
    if-eqz v0, :cond_fd

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 450
    :cond_fd
    throw p1

    :array_fe
    .array-data 1
        0x47t
        0x50t
        0x49t
    .end array-data
.end method

.method static validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V
    .registers 5

    .line 401
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 402
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    invoke-direct {v1, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 412
    return-void
.end method
