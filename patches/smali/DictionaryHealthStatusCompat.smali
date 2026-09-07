.class public final Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;,
        Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;,
        Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;,
        Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;
    }
.end annotation


# static fields
.field public static final HEALTH_ERROR:I = 0x2

.field public static final HEALTH_NOTICE:I = 0x1

.field public static final HEALTH_OK:I

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field private static final MAIN:Landroid/os/Handler;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 20
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;

    .line 21
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;
    .locals 0

    .line 14
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->inspect(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100()Landroid/os/Handler;
    .locals 1

    .line 14
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method private static describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;
    .locals 2

    .line 148
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->backup:Z

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->backupBytes:J

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->formatBytes(J)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "\u65e0"

    :goto_0
    return-object p0
.end method

.method private static describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;
    .locals 2

    .line 145
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->main:Z

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->mainBytes:J

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->formatBytes(J)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "\u5c1a\u65e0\u53ef\u8bfb\u53d6\u7684\u6587\u4ef6"

    :goto_0
    return-object p0
.end method

.method private static files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;
    .locals 17

    .line 136
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-virtual/range {p0 .. p1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v2

    .line 137
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

    .line 138
    new-instance v4, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v5

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-eqz v5, :cond_0

    invoke-virtual {v2}, Ljava/io/File;->canRead()Z

    move-result v5

    if-eqz v5, :cond_0

    const/4 v5, 0x1

    goto :goto_0

    :cond_0
    const/4 v5, 0x0

    :goto_0
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v8

    const-wide/16 v9, 0x0

    if-eqz v8, :cond_1

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v11

    goto :goto_1

    :cond_1
    move-wide v11, v9

    .line 139
    :goto_1
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v8

    if-eqz v8, :cond_2

    invoke-virtual {v2}, Ljava/io/File;->lastModified()J

    move-result-wide v13

    goto :goto_2

    :cond_2
    move-wide v13, v9

    .line 140
    :goto_2
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-virtual {v3}, Ljava/io/File;->canRead()Z

    move-result v2

    if-eqz v2, :cond_3

    goto :goto_3

    :cond_3
    const/4 v6, 0x0

    :goto_3
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v9

    :cond_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "_tmp"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 141
    invoke-virtual {v0, v2}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, "_unreadable"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 142
    invoke-virtual {v0, v1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    move-wide v15, v9

    move v10, v6

    move-wide v6, v11

    move-wide v11, v15

    move-wide v8, v13

    move v14, v0

    move v13, v2

    invoke-direct/range {v4 .. v14}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;-><init>(ZJJZJZZ)V

    .line 138
    return-object v4
.end method

.method private static formatBytes(J)Ljava/lang/String;
    .locals 6

    .line 151
    const-wide/16 v0, 0x400

    cmp-long v2, p0, v0

    if-gez v2, :cond_0

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

    .line 152
    :cond_0
    const-wide/32 v0, 0x100000

    const/4 v2, 0x0

    const/4 v3, 0x1

    cmp-long v4, p0, v0

    if-gez v4, :cond_1

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

    .line 153
    :cond_1
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

.method private static inspect(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;
    .locals 12

    .line 58
    const/4 v0, 0x2

    :try_start_0
    const-string v1, "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "sSaveLock"

    .line 60
    invoke-virtual {v1, v2}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 61
    if-eqz v1, :cond_d

    .line 62
    monitor-enter v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 63
    :try_start_1
    const-string v2, "user_dict_3_3"

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object v2

    .line 64
    const-string v3, "user_dict_3_3_english"

    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object v3

    .line 65
    const-string v4, "bdt"

    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->nativeReadable(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v4

    .line 66
    const-string v5, "agb"

    invoke-static {p0, v5}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->nativeReadable(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v5

    .line 67
    nop

    .line 68
    const-string v6, "\u4e2d\u6587\u8bcd\u5e93\u53ef\u8bfb\u53d6\uff0c\u82f1\u6587\u8bcd\u5e93\u53ef\u8bfb\u53d6"

    .line 69
    const/4 v7, 0x0

    const/4 v8, 0x1

    if-eqz v4, :cond_5

    if-nez v5, :cond_0

    goto :goto_2

    .line 72
    :cond_0
    iget-boolean v9, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-nez v9, :cond_4

    iget-boolean v9, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v9, :cond_1

    goto :goto_1

    .line 75
    :cond_1
    iget-boolean v9, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-nez v9, :cond_3

    iget-boolean v9, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v9, :cond_2

    goto :goto_0

    :cond_2
    const/4 v9, 0x0

    goto :goto_3

    .line 76
    :cond_3
    :goto_0
    nop

    .line 77
    const-string v6, "\u8bcd\u5e93\u53ef\u8bfb\u53d6\uff0c\u53d1\u73b0\u4e0a\u6b21\u4fdd\u5b58\u7684\u4e34\u65f6\u6587\u4ef6\uff0c\u8bf7\u7a0d\u540e\u91cd\u65b0\u68c0\u67e5"

    const/4 v9, 0x1

    goto :goto_3

    .line 73
    :cond_4
    :goto_1
    nop

    .line 74
    const-string v6, "\u8bcd\u5e93\u53ef\u8bfb\u53d6\uff0c\u4fdd\u7559\u4e86\u6b64\u524d\u7684\u5f02\u5e38\u6587\u4ef6\uff0c\u5efa\u8bae\u5148\u5907\u4efd\u5f53\u524d\u8bcd\u5e93"

    const/4 v9, 0x1

    goto :goto_3

    .line 70
    :cond_5
    :goto_2
    nop

    .line 71
    const-string v6, "\u8bcd\u5e93\u68c0\u67e5\u672a\u5b8c\u6210\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5"

    const/4 v9, 0x2

    .line 79
    :goto_3
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    .line 80
    const-string v11, "\u4e2d\u6587\u8bcd\u5e93\uff1a"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    if-eqz v4, :cond_6

    const-string v4, "\u53ef\u8bfb\u53d6"

    goto :goto_4

    :cond_6
    const-string v4, "\u6682\u65f6\u65e0\u6cd5\u786e\u8ba4"

    :goto_4
    invoke-virtual {v11, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v11, "\n\u82f1\u6587\u8bcd\u5e93\uff1a"

    .line 81
    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-eqz v5, :cond_7

    const-string v5, "\u53ef\u8bfb\u53d6"

    goto :goto_5

    :cond_7
    const-string v5, "\u6682\u65f6\u65e0\u6cd5\u786e\u8ba4"

    :goto_5
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 82
    const-string v4, "\n\u4e2d\u6587\u6587\u4ef6\uff1a"

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u82f1\u6587\u6587\u4ef6\uff1a"

    .line 83
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 84
    const-string v4, "\n\u4e0a\u6b21\u4fdd\u5b58\u526f\u672c\uff1a\u4e2d\u6587 "

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\uff0c\u82f1\u6587 "

    .line 85
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 86
    const-string v4, "\n\u4fdd\u7559\u7684\u5f02\u5e38\u6587\u4ef6\uff1a"

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 87
    iget-boolean v5, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v5, :cond_8

    const/4 v5, 0x1

    goto :goto_6

    :cond_8
    const/4 v5, 0x0

    :goto_6
    iget-boolean v11, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v11, :cond_9

    const/4 v11, 0x1

    goto :goto_7

    :cond_9
    const/4 v11, 0x0

    :goto_7
    add-int/2addr v5, v11

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " \u4e2a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 88
    const-string v4, "\n\u672a\u5b8c\u6210\u4fdd\u5b58\u7684\u6587\u4ef6\uff1a"

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 89
    iget-boolean v5, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v5, :cond_a

    const/4 v5, 0x1

    goto :goto_8

    :cond_a
    const/4 v5, 0x0

    :goto_8
    iget-boolean v11, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v11, :cond_b

    const/4 v7, 0x1

    :cond_b
    add-int/2addr v5, v7

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " \u4e2a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 90
    iget-wide v4, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    iget-wide v2, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    invoke-static {v4, v5, v2, v3}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v2

    .line 91
    const-wide/16 v4, 0x0

    cmp-long v7, v2, v4

    if-lez v7, :cond_c

    .line 92
    const-string v4, "\n\u8bcd\u5e93\u6587\u4ef6\u6700\u8fd1\u66f4\u65b0\uff1a"

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 93
    invoke-static {p0}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v5

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    invoke-virtual {v5, v7}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/16 v5, 0x20

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 94
    invoke-static {p0}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object p0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 96
    :cond_c
    new-instance p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v9, v6, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    monitor-exit v1

    return-object p0

    .line 97
    :catchall_0
    move-exception p0

    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    throw p0

    .line 61
    :cond_d
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v1, "dictionary lock unavailable"

    invoke-direct {p0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 98
    :catchall_1
    move-exception p0

    .line 99
    new-instance p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    const-string v1, "\u6682\u65f6\u65e0\u6cd5\u68c0\u67e5\u8bcd\u5e93\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5"

    const-string v2, ""

    invoke-direct {p0, v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    return-object p0
.end method

.method public static load(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V
    .locals 1

    .line 35
    if-eqz p0, :cond_1

    if-nez p1, :cond_0

    goto :goto_0

    .line 36
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;

    invoke-direct {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->loadSnapshot(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V

    .line 41
    return-void

    .line 35
    :cond_1
    :goto_0
    return-void
.end method

.method public static loadSnapshot(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V
    .locals 2

    .line 44
    if-eqz p0, :cond_1

    if-nez p1, :cond_0

    goto :goto_0

    .line 45
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 46
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 54
    return-void

    .line 44
    :cond_1
    :goto_0
    return-void
.end method

.method private static nativeReadable(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 9

    .line 104
    const-string v0, "close"

    const-string v1, "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface"

    .line 106
    const/4 v2, 0x0

    const/4 v3, 0x0

    :try_start_0
    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 107
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

    .line 108
    const-string p1, "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory$MutableDictionaryType"

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 111
    const-class v4, Ljava/lang/Enum;

    invoke-virtual {p1, v4}, Ljava/lang/Class;->asSubclass(Ljava/lang/Class;)Ljava/lang/Class;

    move-result-object v4

    const-string v6, "USER_DICTIONARY"

    invoke-static {v4, v6}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v4

    .line 113
    const-string v6, "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory"

    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    .line 115
    const-string v7, "createMutableDictionaryAccessor"

    new-array v8, v5, [Ljava/lang/Class;

    aput-object p1, v8, v2

    invoke-virtual {v6, v7, v8}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    .line 116
    new-array v6, v5, [Ljava/lang/Object;

    aput-object v4, v6, v2

    invoke-virtual {p1, p0, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 117
    if-nez v3, :cond_1

    .line 126
    if-eqz v3, :cond_0

    .line 128
    :try_start_1
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Class;

    .line 129
    invoke-virtual {p0, v0, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 130
    :catchall_0
    move-exception p0

    :goto_0
    nop

    .line 117
    :cond_0
    return v2

    .line 118
    :cond_1
    :try_start_2
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    .line 121
    const-string p1, "getDictionaryCount"

    new-array v4, v2, [Ljava/lang/Class;

    invoke-virtual {p0, p1, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 122
    instance-of p1, p0, Ljava/lang/Integer;

    if-eqz p1, :cond_2

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    if-ltz p0, :cond_2

    goto :goto_1

    :cond_2
    const/4 v5, 0x0

    .line 126
    :goto_1
    if-eqz v3, :cond_3

    .line 128
    :try_start_3
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Class;

    .line 129
    invoke-virtual {p0, v0, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    .line 130
    :catchall_1
    move-exception p0

    :goto_2
    nop

    .line 122
    :cond_3
    return v5

    .line 123
    :catchall_2
    move-exception p0

    .line 124
    nop

    .line 126
    if-eqz v3, :cond_4

    .line 128
    :try_start_4
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Class;

    .line 129
    invoke-virtual {p0, v0, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_3

    goto :goto_3

    .line 130
    :catchall_3
    move-exception p0

    :goto_3
    nop

    .line 124
    :cond_4
    return v2
.end method
