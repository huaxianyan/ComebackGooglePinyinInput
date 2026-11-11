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
.field private static final ENGLISH_DICTIONARY:Ljava/lang/String; = "personal/Personal.en.dict"

.field public static final HEALTH_ERROR:I = 0x2

.field public static final HEALTH_NOTICE:I = 0x1

.field public static final HEALTH_OK:I = 0x0

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field private static final LAST_CHINESE_ENTRIES:Ljava/lang/String; = "last_chinese_entries"

.field private static final MAIN:Landroid/os/Handler;

.field private static final PREFS:Ljava/lang/String; = "dictionary_health_preferences"


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 28
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;

    .line 29
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 32
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;
    .locals 0

    .line 18
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->inspect(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100()Landroid/os/Handler;
    .locals 1

    .line 18
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method private static describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;
    .locals 2

    .line 193
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

    .line 190
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

.method private static entryCount(Landroid/content/Context;Ljava/lang/String;)I
    .locals 6

    .line 135
    const/4 v0, -0x1

    :try_start_0
    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    const-string v1, "a"

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/Class;

    const-class v4, Landroid/content/Context;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    .line 136
    invoke-virtual {p1, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v1, v2, [Ljava/lang/Object;

    aput-object p0, v1, v5

    const/4 v2, 0x0

    invoke-virtual {p1, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    .line 137
    instance-of v1, p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    if-nez v1, :cond_0

    return v0

    .line 138
    :cond_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->readPresence(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 140
    :catchall_0
    move-exception p0

    .line 141
    return v0
.end method

.method private static files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;
    .locals 1

    .line 178
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    invoke-direct {v0, p0, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Ljava/io/File;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object p0

    return-object p0
.end method

.method private static files(Ljava/io/File;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;
    .locals 16

    .line 182
    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    .line 183
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "_bak"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 184
    new-instance v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->exists()Z

    move-result v2

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-eqz v2, :cond_0

    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->canRead()Z

    move-result v2

    if-eqz v2, :cond_0

    goto :goto_0

    :cond_0
    const/4 v4, 0x0

    :goto_0
    const/4 v2, 0x1

    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->exists()Z

    move-result v6

    const-wide/16 v7, 0x0

    if-eqz v6, :cond_1

    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->length()J

    move-result-wide v9

    goto :goto_1

    :cond_1
    move-wide v9, v7

    .line 185
    :goto_1
    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->exists()Z

    move-result v6

    if-eqz v6, :cond_2

    invoke-virtual/range {p0 .. p0}, Ljava/io/File;->lastModified()J

    move-result-wide v11

    goto :goto_2

    :cond_2
    move-wide v11, v7

    .line 186
    :goto_2
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v6

    if-eqz v6, :cond_3

    invoke-virtual {v1}, Ljava/io/File;->canRead()Z

    move-result v6

    if-eqz v6, :cond_3

    goto :goto_3

    :cond_3
    const/4 v2, 0x0

    :goto_3
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v5

    if-eqz v5, :cond_4

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v7

    :cond_4
    new-instance v1, Ljava/io/File;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "_tmp"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v1, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 187
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v1

    new-instance v5, Ljava/io/File;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, "_unreadable"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v5, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/File;->exists()Z

    move-result v13

    move-wide v5, v9

    move v9, v2

    move-wide v14, v11

    move v12, v1

    move-wide v10, v7

    move-wide v7, v14

    invoke-direct/range {v3 .. v13}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;-><init>(ZJJZJZZ)V

    .line 184
    return-object v3
.end method

.method private static formatBytes(J)Ljava/lang/String;
    .locals 6

    .line 196
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

    .line 197
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

    .line 198
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
    .locals 15

    .line 69
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->request(Landroid/content/Context;)V

    .line 71
    const/4 v0, 0x2

    :try_start_0
    const-string v1, "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "sSaveLock"

    .line 73
    invoke-virtual {v1, v2}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 74
    if-eqz v1, :cond_12

    .line 75
    monitor-enter v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 76
    :try_start_1
    const-string v2, "user_dict_3_3"

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Landroid/content/Context;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object v2

    .line 77
    new-instance v3, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    const-string v5, "personal/Personal.en.dict"

    invoke-direct {v3, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->files(Ljava/io/File;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;

    move-result-object v3

    .line 78
    const-string v4, "bdt"

    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->nativeReadable(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v4

    .line 79
    const-string v5, "agb"

    invoke-static {p0, v5}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->nativeReadable(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v5

    .line 80
    const-string v6, "bdt"

    invoke-static {p0, v6}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->entryCount(Landroid/content/Context;Ljava/lang/String;)I

    move-result v6

    .line 81
    const-string v7, "dictionary_health_preferences"

    const/4 v8, 0x0

    invoke-virtual {p0, v7, v8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v7

    .line 82
    const-string v9, "last_chinese_entries"

    invoke-interface {v7, v9, v8}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v9

    .line 83
    const/4 v10, 0x1

    if-ltz v6, :cond_0

    if-lez v9, :cond_0

    mul-int/lit8 v11, v6, 0x2

    if-ge v11, v9, :cond_0

    const/4 v11, 0x1

    goto :goto_0

    :cond_0
    const/4 v11, 0x0

    .line 84
    :goto_0
    nop

    .line 85
    const-string v12, "\u4e2d\u6587\u8bcd\u5e93\u53ef\u8bfb\u53d6\uff0c\u82f1\u6587\u8bcd\u5e93\u53ef\u8bfb\u53d6"

    .line 86
    if-eqz v4, :cond_7

    if-nez v5, :cond_1

    goto :goto_3

    .line 89
    :cond_1
    if-eqz v11, :cond_2

    .line 90
    nop

    .line 91
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "\u4e2d\u6587\u8bcd\u6761\u4ece "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v11

    const-string v12, " \u6761\u51cf\u5c11\u5230 "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v11

    const-string v12, " \u6761\uff0c\u8bf7\u5c3d\u5feb\u5bfc\u5165\u5907\u4efd\u6216\u91cd\u65b0\u5efa\u7acb\u540c\u6b65\u72b6\u6001\uff0c\u6062\u590d\u524d\u4e0d\u8981\u6e05\u9664\u7528\u6237\u8bcd\u5178"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    const/4 v11, 0x2

    goto :goto_4

    .line 93
    :cond_2
    iget-boolean v11, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-nez v11, :cond_6

    iget-boolean v11, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v11, :cond_3

    goto :goto_2

    .line 96
    :cond_3
    iget-boolean v11, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-nez v11, :cond_5

    iget-boolean v11, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v11, :cond_4

    goto :goto_1

    :cond_4
    const/4 v11, 0x0

    goto :goto_4

    .line 97
    :cond_5
    :goto_1
    nop

    .line 98
    const-string v12, "\u8bcd\u5e93\u53ef\u8bfb\u53d6\uff0c\u53d1\u73b0\u4e0a\u6b21\u4fdd\u5b58\u7684\u4e34\u65f6\u6587\u4ef6\uff0c\u8bf7\u7a0d\u540e\u91cd\u65b0\u68c0\u67e5"

    const/4 v11, 0x1

    goto :goto_4

    .line 94
    :cond_6
    :goto_2
    nop

    .line 95
    const-string v12, "\u8bcd\u5e93\u53ef\u8bfb\u53d6\uff0c\u4fdd\u7559\u4e86\u6b64\u524d\u7684\u5f02\u5e38\u6587\u4ef6\uff0c\u5efa\u8bae\u5148\u5907\u4efd\u5f53\u524d\u8bcd\u5e93"

    const/4 v11, 0x1

    goto :goto_4

    .line 87
    :cond_7
    :goto_3
    nop

    .line 88
    const-string v12, "\u8bcd\u5e93\u68c0\u67e5\u672a\u5b8c\u6210\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5"

    const/4 v11, 0x2

    .line 100
    :goto_4
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    .line 101
    const-string v14, "\u4e2d\u6587\u8bcd\u5e93\uff1a"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v14

    if-eqz v4, :cond_8

    const-string v4, "\u53ef\u8bfb\u53d6"

    goto :goto_5

    :cond_8
    const-string v4, "\u6682\u65f6\u65e0\u6cd5\u786e\u8ba4"

    :goto_5
    invoke-virtual {v14, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v14, "\n\u82f1\u6587\u8bcd\u5e93\uff1a"

    .line 102
    invoke-virtual {v4, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-eqz v5, :cond_9

    const-string v5, "\u53ef\u8bfb\u53d6"

    goto :goto_6

    :cond_9
    const-string v5, "\u6682\u65f6\u65e0\u6cd5\u786e\u8ba4"

    :goto_6
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 103
    const-string v4, "\n\u4e2d\u6587\u8bcd\u6761\uff1a"

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 104
    if-ltz v6, :cond_a

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v14, " \u6761"

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    goto :goto_7

    :cond_a
    const-string v5, "\u6682\u65f6\u65e0\u6cd5\u7edf\u8ba1"

    :goto_7
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 105
    if-lez v9, :cond_b

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "\uff08\u6b64\u524d\u6700\u9ad8 "

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v14, " \u6761\uff09"

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    goto :goto_8

    :cond_b
    const-string v5, ""

    :goto_8
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 106
    const-string v4, "\n\u4e2d\u6587\u6587\u4ef6\uff1a"

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u82f1\u6587\u6587\u4ef6\uff1a"

    .line 107
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeMain(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 108
    const-string v4, "\n\u4e0a\u6b21\u4fdd\u5b58\u526f\u672c\uff1a\u4e2d\u6587 "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\uff0c\u82f1\u6587 "

    .line 109
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->describeBackup(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 110
    const-string v4, "\n\u4fdd\u7559\u7684\u5f02\u5e38\u6587\u4ef6\uff1a"

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 111
    iget-boolean v5, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v5, :cond_c

    const/4 v5, 0x1

    goto :goto_9

    :cond_c
    const/4 v5, 0x0

    :goto_9
    iget-boolean v14, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    if-eqz v14, :cond_d

    const/4 v14, 0x1

    goto :goto_a

    :cond_d
    const/4 v14, 0x0

    :goto_a
    add-int/2addr v5, v14

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " \u4e2a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 112
    const-string v4, "\n\u672a\u5b8c\u6210\u4fdd\u5b58\u7684\u6587\u4ef6\uff1a"

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 113
    iget-boolean v5, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v5, :cond_e

    const/4 v5, 0x1

    goto :goto_b

    :cond_e
    const/4 v5, 0x0

    :goto_b
    iget-boolean v14, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    if-eqz v14, :cond_f

    const/4 v8, 0x1

    :cond_f
    add-int/2addr v5, v8

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " \u4e2a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 114
    iget-wide v4, v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    iget-wide v2, v3, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    invoke-static {v4, v5, v2, v3}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v2

    .line 115
    const-wide/16 v4, 0x0

    cmp-long v8, v2, v4

    if-lez v8, :cond_10

    .line 116
    const-string v4, "\n\u8bcd\u5e93\u6587\u4ef6\u6700\u8fd1\u66f4\u65b0\uff1a"

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 117
    invoke-static {p0}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v5

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/16 v5, 0x20

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 118
    invoke-static {p0}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object p0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 122
    :cond_10
    if-le v6, v9, :cond_11

    .line 123
    invoke-interface {v7}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v2, "last_chinese_entries"

    invoke-interface {p0, v2, v6}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 125
    :cond_11
    new-instance p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v11, v12, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    monitor-exit v1

    return-object p0

    .line 126
    :catchall_0
    move-exception p0

    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    throw p0

    .line 74
    :cond_12
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v1, "dictionary lock unavailable"

    invoke-direct {p0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 127
    :catchall_1
    move-exception p0

    .line 128
    new-instance p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    const-string v1, "\u6682\u65f6\u65e0\u6cd5\u68c0\u67e5\u8bcd\u5e93\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5"

    const-string v2, ""

    invoke-direct {p0, v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    return-object p0
.end method

.method public static load(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V
    .locals 1

    .line 45
    if-eqz p0, :cond_1

    if-nez p1, :cond_0

    goto :goto_0

    .line 46
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;

    invoke-direct {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->loadSnapshot(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V

    .line 51
    return-void

    .line 45
    :cond_1
    :goto_0
    return-void
.end method

.method public static loadSnapshot(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V
    .locals 2

    .line 54
    if-eqz p0, :cond_1

    if-nez p1, :cond_0

    goto :goto_0

    .line 55
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 56
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 64
    return-void

    .line 54
    :cond_1
    :goto_0
    return-void
.end method

.method private static nativeReadable(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 9

    .line 146
    const-string v0, "close"

    const-string v1, "com.google.android.apps.inputmethod.libs.hmm.MutableDictionaryAccessorInterface"

    .line 148
    const/4 v2, 0x0

    const/4 v3, 0x0

    :try_start_0
    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 149
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

    .line 150
    const-string p1, "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory$MutableDictionaryType"

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    .line 153
    const-class v4, Ljava/lang/Enum;

    invoke-virtual {p1, v4}, Ljava/lang/Class;->asSubclass(Ljava/lang/Class;)Ljava/lang/Class;

    move-result-object v4

    const-string v6, "USER_DICTIONARY"

    invoke-static {v4, v6}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v4

    .line 155
    const-string v6, "com.google.android.apps.inputmethod.libs.hmm.AbstractHmmEngineFactory"

    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    .line 157
    const-string v7, "createMutableDictionaryAccessor"

    new-array v8, v5, [Ljava/lang/Class;

    aput-object p1, v8, v2

    invoke-virtual {v6, v7, v8}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    .line 158
    new-array v6, v5, [Ljava/lang/Object;

    aput-object v4, v6, v2

    invoke-virtual {p1, p0, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 159
    if-nez v3, :cond_1

    .line 168
    if-eqz v3, :cond_0

    .line 170
    :try_start_1
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Class;

    .line 171
    invoke-virtual {p0, v0, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 172
    :catchall_0
    move-exception p0

    :goto_0
    nop

    .line 159
    :cond_0
    return v2

    .line 160
    :cond_1
    :try_start_2
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    .line 163
    const-string p1, "getDictionaryCount"

    new-array v4, v2, [Ljava/lang/Class;

    invoke-virtual {p0, p1, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 164
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

    .line 168
    :goto_1
    if-eqz v3, :cond_3

    .line 170
    :try_start_3
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Class;

    .line 171
    invoke-virtual {p0, v0, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    .line 172
    :catchall_1
    move-exception p0

    :goto_2
    nop

    .line 164
    :cond_3
    return v5

    .line 165
    :catchall_2
    move-exception p0

    .line 166
    nop

    .line 168
    if-eqz v3, :cond_4

    .line 170
    :try_start_4
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Class;

    .line 171
    invoke-virtual {p0, v0, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array p1, v2, [Ljava/lang/Object;

    invoke-virtual {p0, v3, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_3

    goto :goto_3

    .line 172
    :catchall_3
    move-exception p0

    :goto_3
    nop

    .line 166
    :cond_4
    return v2
.end method
