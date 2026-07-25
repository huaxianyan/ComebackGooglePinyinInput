.class public final Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;,
        Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;
    }
.end annotation


# static fields
.field private static final CHINESE:Ljava/lang/String; = "user_dict_3_3"

.field private static final ENGLISH:Ljava/lang/String; = "user_dict_3_3_english"

.field private static final FALLBACK_LOCK:Ljava/lang/Object;

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field private static final MAIN:Landroid/os/Handler;


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 18
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;

    .line 19
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->IO:Ljava/util/concurrent/ExecutorService;

    .line 20
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->FALLBACK_LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;)Ljava/lang/String;
    .registers 1

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->inspect(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100()Landroid/os/Handler;
    .registers 1

    .line 15
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method private static describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;
    .registers 4

    .line 150
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->backup:Z

    if-nez v0, :cond_7

    const-string p0, "\u65e0"

    return-object p0

    .line 151
    :cond_7
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u6709\uff08"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->backupBytes:J

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->formatBytes(J)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;
    .registers 3

    .line 145
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->main:Z

    if-nez v0, :cond_7

    const-string p0, "\u5c1a\u672a\u843d\u76d8"

    return-object p0

    .line 146
    :cond_7
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->mainBytes:J

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->formatBytes(J)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static describeSidecars(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;
    .registers 4

    .line 155
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    iget-boolean v1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    add-int/2addr v0, v1

    .line 156
    iget-boolean p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    iget-boolean p1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    add-int/2addr p0, p1

    .line 157
    if-nez v0, :cond_11

    if-nez p0, :cond_11

    const-string p0, "\u65e0 _tmp / _unreadable"

    return-object p0

    .line 158
    :cond_11
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "_tmp "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " \u4e2a\uff1b_unreadable "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " \u4e2a"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static dictionaryLock()Ljava/lang/Object;
    .registers 2

    .line 91
    :try_start_0
    const-string v0, "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 93
    const-string v1, "sSaveLock"

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 94
    if-nez v0, :cond_15

    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->FALLBACK_LOCK:Ljava/lang/Object;
    :try_end_15
    .catchall {:try_start_0 .. :try_end_15} :catchall_16

    :cond_15
    return-object v0

    .line 95
    :catchall_16
    move-exception v0

    .line 96
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->FALLBACK_LOCK:Ljava/lang/Object;

    return-object v0
.end method

.method private static files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;
    .registers 20

    .line 134
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-virtual/range {p0 .. p1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v2

    .line 135
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "_bak"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v3

    .line 136
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "_tmp"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v4

    .line 137
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v5, "_unreadable"

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    .line 138
    new-instance v5, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v1

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-eqz v1, :cond_5e

    invoke-virtual {v2}, Ljava/io/File;->canRead()Z

    move-result v1

    if-eqz v1, :cond_5e

    goto :goto_5f

    :cond_5e
    const/4 v6, 0x0

    :goto_5f
    const/4 v1, 0x1

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v8

    const-wide/16 v9, 0x0

    if-eqz v8, :cond_6d

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v11

    goto :goto_6e

    :cond_6d
    move-wide v11, v9

    .line 139
    :goto_6e
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v8

    if-eqz v8, :cond_79

    invoke-virtual {v2}, Ljava/io/File;->lastModified()J

    move-result-wide v13

    goto :goto_7a

    :cond_79
    move-wide v13, v9

    .line 140
    :goto_7a
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_87

    invoke-virtual {v3}, Ljava/io/File;->canRead()Z

    move-result v2

    if-eqz v2, :cond_87

    goto :goto_88

    :cond_87
    const/4 v1, 0x0

    :goto_88
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_92

    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v9

    .line 141
    :cond_92
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v2

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v15

    move-wide v7, v11

    move v11, v1

    move-wide/from16 v16, v13

    move v14, v2

    move-wide v12, v9

    move-wide/from16 v9, v16

    invoke-direct/range {v5 .. v15}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;-><init>(ZJJZJZZ)V

    .line 138
    return-object v5
.end method

.method private static formatBytes(J)Ljava/lang/String;
    .registers 8

    .line 162
    const-wide/16 v0, 0x400

    cmp-long v2, p0, v0

    if-gez v2, :cond_1a

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " B"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 163
    :cond_1a
    const-wide/32 v0, 0x100000

    const/4 v2, 0x0

    const/4 v3, 0x1

    cmp-long v4, p0, v0

    if-gez v4, :cond_3b

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    long-to-double p0, p0

    const-wide/high16 v4, 0x4090000000000000L    # 1024.0

    invoke-static {p0, p1}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr p0, v4

    invoke-static {p0, p1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    new-array p1, v3, [Ljava/lang/Object;

    aput-object p0, p1, v2

    const-string p0, "%.1f KB"

    invoke-static {v0, p0, p1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 164
    :cond_3b
    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    long-to-double p0, p0

    const-wide/high16 v4, 0x4130000000000000L    # 1048576.0

    invoke-static {p0, p1}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr p0, v4

    invoke-static {p0, p1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    new-array p1, v3, [Ljava/lang/Object;

    aput-object p0, p1, v2

    const-string p0, "%.2f MB"

    invoke-static {v0, p0, p1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static inspect(Landroid/content/Context;)Ljava/lang/String;
    .registers 11

    .line 47
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->dictionaryLock()Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 48
    :try_start_5
    const-string v1, "user_dict_3_3"

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object v1

    .line 49
    const-string v2, "user_dict_3_3_english"

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object v2

    .line 50
    const-string v3, "bdt"

    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->nativeEntryCount(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v3

    .line 51
    const-string v4, "agb"

    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->nativeEntryCount(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v4

    .line 52
    monitor-exit v0
    :try_end_1e
    .catchall {:try_start_5 .. :try_end_1e} :catchall_14a

    .line 54
    const/4 v0, 0x1

    const/4 v5, 0x0

    if-eqz v3, :cond_26

    if-eqz v4, :cond_26

    const/4 v6, 0x1

    goto :goto_27

    :cond_26
    const/4 v6, 0x0

    .line 55
    :goto_27
    iget-boolean v7, v1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-nez v7, :cond_32

    iget-boolean v7, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v7, :cond_30

    goto :goto_32

    :cond_30
    const/4 v7, 0x0

    goto :goto_33

    :cond_32
    :goto_32
    const/4 v7, 0x1

    .line 56
    :goto_33
    iget-boolean v8, v1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-nez v8, :cond_3d

    iget-boolean v8, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v8, :cond_3c

    goto :goto_3d

    :cond_3c
    const/4 v0, 0x0

    .line 58
    :cond_3d
    :goto_3d
    if-eqz v7, :cond_42

    const-string v0, "\u9700\u6ce8\u610f\uff1a\u53d1\u73b0\u4e0d\u53ef\u8bfb\u6062\u590d\u5f52\u6863\uff0c\u5efa\u8bae\u7acb\u5373\u5907\u4efd"

    goto :goto_4e

    .line 59
    :cond_42
    if-eqz v0, :cond_47

    const-string v0, "\u9700\u590d\u67e5\uff1a\u53d1\u73b0\u672a\u5b8c\u6210\u7684\u4e34\u65f6\u6587\u4ef6\uff0c\u5efa\u8bae\u91cd\u542f\u540e\u518d\u67e5\u770b"

    goto :goto_4e

    .line 60
    :cond_47
    if-eqz v6, :cond_4c

    const-string v0, "\u6b63\u5e38\uff1a\u4e2d\u6587\u548c\u82f1\u6587\u7528\u6237\u8bcd\u5e93\u5747\u53ef\u8bfb\u53d6"

    goto :goto_4e

    .line 61
    :cond_4c
    const-string v0, "\u90e8\u5206\u72b6\u6001\u65e0\u6cd5\u8bfb\u53d6\uff1b\u6587\u4ef6\u4fe1\u606f\u5982\u4e0b"

    .line 63
    :goto_4e
    new-instance v5, Ljava/lang/StringBuilder;

    const/16 v7, 0x100

    invoke-direct {v5, v7}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 64
    const-string v7, "\u72b6\u6001\uff1a"

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 65
    if-eqz v6, :cond_89

    .line 66
    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v6, v0

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v8, v0

    add-long/2addr v6, v8

    .line 67
    const-string v0, "\n\u8bcd\u6761\uff1a\u4e2d\u6587 "

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "\uff1b\u82f1\u6587 "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 68
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "\uff1b\u5408\u8ba1 "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    .line 69
    goto :goto_c9

    .line 70
    :cond_89
    const-string v0, "\n\u8bcd\u6761\uff1a"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 71
    if-nez v3, :cond_93

    const-string v0, "\u4e2d\u6587\u65e0\u6cd5\u8bfb\u53d6"

    goto :goto_a6

    :cond_93
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u4e2d\u6587 "

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_a6
    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 72
    const-string v0, "\uff1b"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 73
    if-nez v4, :cond_b3

    const-string v0, "\u82f1\u6587\u65e0\u6cd5\u8bfb\u53d6"

    goto :goto_c6

    :cond_b3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u82f1\u6587 "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_c6
    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 75
    :goto_c9
    const-string v0, "\n\u4e3b\u6587\u4ef6\uff1a\u4e2d\u6587 "

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "\uff1b\u82f1\u6587 "

    .line 76
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 77
    const-string v0, "\n\u6eda\u52a8\u526f\u672c\uff1a\u4e2d\u6587 "

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "\uff1b\u82f1\u6587 "

    .line 78
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 79
    const-string v0, "\n\u6062\u590d\u65c1\u8def\uff1a"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeSidecars(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 80
    iget-wide v0, v1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    iget-wide v2, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v0

    .line 81
    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-lez v4, :cond_145

    .line 82
    const-string v2, "\n\u6700\u8fd1\u843d\u76d8\uff1a"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 83
    invoke-static {p0}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v3

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const/16 v3, 0x20

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 84
    invoke-static {p0}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object p0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 86
    :cond_145
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 52
    :catchall_14a
    move-exception p0

    :try_start_14b
    monitor-exit v0
    :try_end_14c
    .catchall {:try_start_14b .. :try_end_14c} :catchall_14a

    throw p0
.end method

.method public static load(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V
    .registers 4

    .line 28
    if-eqz p0, :cond_14

    if-nez p1, :cond_5

    goto :goto_14

    .line 29
    :cond_5
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 30
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 38
    return-void

    .line 28
    :cond_14
    :goto_14
    return-void
.end method

.method private static nativeEntryCount(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;
    .registers 11

    .line 101
    const-string v0, "close"

    const-string v1, "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface"

    .line 103
    const/4 v2, 0x0

    const/4 v3, 0x0

    :try_start_6
    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 104
    const-string v4, "a"

    const/4 v5, 0x1

    new-array v6, v5, [Ljava/lang/Class;

    const-class v7, Landroid/content/Context;

    aput-object v7, v6, v2

    invoke-virtual {p1, v4, v6}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v4, v5, [Ljava/lang/Object;

    aput-object p0, v4, v2

    invoke-virtual {p1, v3, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 105
    const-string p1, "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory$MutableDictionaryType"

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 108
    const-class v4, Ljava/lang/Enum;

    invoke-virtual {p1, v4}, Ljava/lang/Class;->asSubclass(Ljava/lang/Class;)Ljava/lang/Class;

    move-result-object v4

    const-string v6, "USER_DICTIONARY"

    invoke-static {v4, v6}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v4

    .line 110
    const-string v6, "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory"

    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    .line 112
    const-string v7, "createMutableDictionaryAccessor"

    new-array v8, v5, [Ljava/lang/Class;

    aput-object p1, v8, v2

    invoke-virtual {v6, v7, v8}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    .line 113
    new-array v5, v5, [Ljava/lang/Object;

    aput-object v4, v5, v2

    invoke-virtual {p1, p0, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_49
    .catchall {:try_start_6 .. :try_end_49} :catchall_9b

    .line 114
    if-nez p0, :cond_60

    .line 123
    if-eqz p0, :cond_5f

    .line 125
    :try_start_4d
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 127
    new-array v1, v2, [Ljava/lang/Class;

    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v0, v2, [Ljava/lang/Object;

    invoke-virtual {p1, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_5c
    .catchall {:try_start_4d .. :try_end_5c} :catchall_5d

    goto :goto_5e

    .line 128
    :catchall_5d
    move-exception p0

    :goto_5e
    nop

    .line 114
    :cond_5f
    return-object v3

    .line 115
    :cond_60
    :try_start_60
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 117
    const-string v4, "getDictionarySize"

    new-array v5, v2, [Ljava/lang/Class;

    invoke-virtual {p1, v4, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v4, v2, [Ljava/lang/Object;

    invoke-virtual {p1, p0, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    .line 118
    instance-of v4, p1, Ljava/lang/Integer;

    if-eqz v4, :cond_83

    move-object v4, p1

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    if-ltz v4, :cond_83

    .line 119
    check-cast p1, Ljava/lang/Integer;
    :try_end_81
    .catchall {:try_start_60 .. :try_end_81} :catchall_99

    move-object v3, p1

    goto :goto_84

    :cond_83
    nop

    .line 123
    :goto_84
    if-eqz p0, :cond_98

    .line 125
    :try_start_86
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 127
    new-array v1, v2, [Ljava/lang/Class;

    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v0, v2, [Ljava/lang/Object;

    invoke-virtual {p1, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_95
    .catchall {:try_start_86 .. :try_end_95} :catchall_96

    goto :goto_97

    .line 128
    :catchall_96
    move-exception p0

    :goto_97
    nop

    .line 118
    :cond_98
    return-object v3

    .line 120
    :catchall_99
    move-exception p1

    goto :goto_9d

    :catchall_9b
    move-exception p0

    move-object p0, v3

    .line 121
    :goto_9d
    nop

    .line 123
    if-eqz p0, :cond_b2

    .line 125
    :try_start_a0
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 127
    new-array v1, v2, [Ljava/lang/Class;

    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v0, v2, [Ljava/lang/Object;

    invoke-virtual {p1, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_af
    .catchall {:try_start_a0 .. :try_end_af} :catchall_b0

    goto :goto_b1

    .line 128
    :catchall_b0
    move-exception p0

    :goto_b1
    nop

    .line 121
    :cond_b2
    return-object v3
.end method
