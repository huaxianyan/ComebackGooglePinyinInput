.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;
.super Ljava/lang/Object;
.source "DictionarySafetyGuard.java"


# static fields
.field private static final BUSY:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private static final BUSY_TIMEOUT_MS:J = 0x1d4c0L

.field private static final CHECK_INTERVAL_MS:J = 0x1499700L

.field private static final REPAIR_INTERVAL_MS:J = 0x5265c00L

.field private static final REPAIR_LOCK:Ljava/lang/Object;

.field private static final SAMPLE_INTERVAL_MS:J = 0x7530L

.field private static final SAVE_JOURNAL_LIMIT:I = 0xc

.field private static final SAVE_LOCK_CLASS:Ljava/lang/String; = "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

.field private static final SAVE_LOCK_FIELD:Ljava/lang/String; = "sSaveLock"

.field private static final STRIKES_BEFORE_REPAIR:I = 0x2


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 35
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/Map;

    .line 43
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 49
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 0

    .line 24
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->runOnce(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    .locals 0

    .line 24
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$200()Ljava/util/Map;
    .locals 1

    .line 24
    sget-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/Map;

    return-object v0
.end method

.method private static capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V
    .locals 2

    .line 358
    invoke-static {p4, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->acceptsSnapshot(II)Z

    move-result p5

    if-nez p5, :cond_0

    return-void

    .line 359
    :cond_0
    invoke-static {p1, p0, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entries(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Landroid/content/Context;Ljava/lang/Object;)Ljava/util/List;

    move-result-object p3

    .line 360
    if-eqz p3, :cond_3

    invoke-interface {p3}, Ljava/util/List;->isEmpty()Z

    move-result p5

    if-eqz p5, :cond_1

    goto :goto_0

    .line 364
    :cond_1
    invoke-static {p4, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->of(ILjava/util/List;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object p3

    .line 365
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->snapshots()Ljava/util/List;

    move-result-object p4

    .line 366
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p5

    invoke-interface {p5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p5

    .line 368
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v0

    .line 367
    const-string p0, "known_dictionary_file_size"

    invoke-interface {p5, p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 369
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 370
    invoke-interface {p4}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_2

    const/4 p0, 0x0

    invoke-interface {p4, p0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J

    move-result-wide p4

    .line 371
    invoke-static {p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J

    move-result-wide v0

    cmp-long p0, p4, v0

    if-nez p0, :cond_2

    .line 372
    return-void

    .line 374
    :cond_2
    invoke-virtual {p1, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->write(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    .line 375
    return-void

    .line 361
    :cond_3
    :goto_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u8bcd\u6761\u660e\u7ec6\u6682\u65f6\u8bfb\u4e0d\u51fa\uff08\u8ba1\u6570 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, " \u6761\uff09\uff0c\u672c\u6b21\u8df3\u8fc7\u5feb\u7167"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 362
    return-void
.end method

.method private static engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;
    .locals 6

    .line 443
    const/4 v0, 0x0

    :try_start_0
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->engineFactoryClass:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    const-string v1, "a"

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/Class;

    const-class v4, Landroid/content/Context;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    .line 444
    invoke-virtual {p1, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v1, v2, [Ljava/lang/Object;

    aput-object p0, v1, v5

    invoke-virtual {p1, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 445
    instance-of p1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p1, :cond_0

    move-object v0, p0

    :cond_0
    return-object v0

    .line 446
    :catchall_0
    move-exception p0

    .line 447
    return-object v0
.end method

.method private static entries(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Landroid/content/Context;Ljava/lang/Object;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;",
            "Landroid/content/Context;",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;",
            ">;"
        }
    .end annotation

    .line 425
    :try_start_0
    check-cast p2, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 426
    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p1

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    .line 427
    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p1

    .line 428
    new-instance p2, Ljava/util/ArrayList;

    .line 429
    invoke-interface {p1}, Ljava/util/Collection;->size()I

    move-result v0

    invoke-direct {p2, v0}, Ljava/util/ArrayList;-><init>(I)V

    .line 430
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 431
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->count:I

    invoke-direct {v1, v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;I)V

    invoke-interface {p2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 433
    goto :goto_0

    .line 434
    :cond_0
    return-object p2

    .line 435
    :catchall_0
    move-exception p1

    .line 436
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u8bfb\u53d6\u8bcd\u6761\u5931\u8d25\uff1a"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 437
    const/4 p0, 0x0

    return-object p0
.end method

.method private static entriesCouldStillBeOnDisk(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Landroid/content/SharedPreferences;II)Ljava/lang/Boolean;
    .locals 5

    .line 346
    const-string v0, "known_dictionary_file_size"

    const-wide/16 v1, 0x0

    invoke-interface {p2, v0, v1, v2}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v3

    .line 347
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide p0

    .line 348
    cmp-long p2, v3, v1

    if-lez p2, :cond_3

    cmp-long p2, p0, v1

    if-gtz p2, :cond_0

    goto :goto_1

    .line 349
    :cond_0
    if-gtz p3, :cond_1

    sget-object p0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p0

    .line 350
    :cond_1
    int-to-long p2, p3

    mul-long v3, v3, p2

    int-to-long p2, p4

    div-long/2addr v3, p2

    .line 351
    const-wide/16 p2, 0x2

    mul-long v3, v3, p2

    cmp-long p2, p0, v3

    if-lez p2, :cond_2

    const/4 p0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    :goto_0
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0

    .line 348
    :cond_3
    :goto_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static forget(Landroid/content/Context;)V
    .locals 8

    .line 322
    if-nez p0, :cond_0

    return-void

    .line 323
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    .line 324
    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v0

    .line 325
    :goto_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_1
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    .line 326
    new-instance v5, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-direct {v5, p0, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 327
    new-instance v6, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;

    invoke-direct {v6, p0, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->forget()V

    .line 328
    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 329
    const-string v5, "dictionary_file_high_water"

    const-wide/16 v6, 0x0

    invoke-interface {v4, v5, v6, v7}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 330
    const-string v5, "known_entry_count"

    invoke-interface {v4, v5, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 331
    const-string v5, "collapsed_strikes"

    invoke-interface {v4, v5, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 332
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 325
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 334
    :cond_2
    return-void
.end method

.method private static formatSize(J)Ljava/lang/String;
    .locals 3

    .line 147
    const-wide/16 v0, 0x400

    cmp-long v2, p0, v0

    if-gez v2, :cond_0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " \u5b57\u8282"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 148
    :cond_0
    long-to-double p0, p0

    const-wide/high16 v0, 0x4090000000000000L    # 1024.0

    invoke-static {p0, p1}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr p0, v0

    invoke-static {p0, p1}, Ljava/lang/Math;->round(D)J

    move-result-wide p0

    .line 149
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " KB"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static lastRepairNote(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    .line 107
    const-string v0, ""

    if-nez p0, :cond_0

    return-object v0

    .line 108
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 109
    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v1

    .line 110
    :goto_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-direct {v1, p0, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 111
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "last_note"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 112
    const-string v1, "\u8bcd\u5e93\u6587\u4ef6\u4ece"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    move-object v0, p0

    :cond_2
    return-object v0
.end method

.method private static markCollapse(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    .locals 3

    .line 87
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, " journal="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 89
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "save_journal"

    const-string v2, ""

    invoke-interface {p0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 88
    const-string p1, "last_debug"

    invoke-interface {v0, p1, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 90
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 91
    return-void
.end method

.method private static protectFile(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Z
    .locals 8

    .line 294
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 295
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;

    invoke-direct {v1, p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 296
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->read()[B

    move-result-object p0

    .line 297
    const-wide/16 v2, 0x0

    if-nez p0, :cond_0

    move-wide v4, v2

    goto :goto_0

    :cond_0
    array-length p2, p0

    int-to-long v4, p2

    .line 298
    :goto_0
    const-string p2, "dictionary_file_high_water"

    invoke-interface {v0, p2, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v2

    .line 300
    cmp-long v6, v4, v2

    if-lez v6, :cond_1

    .line 301
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 302
    invoke-interface {v0, p2, v4, v5}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 303
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 305
    :cond_1
    invoke-static {v4, v5, v2, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isFileCollapsed(JJ)Z

    move-result p2

    const/4 v0, 0x0

    if-nez p2, :cond_2

    .line 306
    invoke-virtual {v1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->keep([B)Z

    .line 307
    return v0

    .line 309
    :cond_2
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "file-collapsed "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, "/"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->markCollapse(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 310
    const-wide/16 v6, 0x2

    div-long/2addr v2, v6

    invoke-virtual {v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->newestAtLeast(J)[B

    move-result-object p0

    .line 311
    if-eqz p0, :cond_3

    invoke-virtual {v1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->restore([B)Z

    move-result p2

    if-eqz p2, :cond_3

    .line 312
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u8bcd\u5e93\u6587\u4ef6\u4ece "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, " \u5b57\u8282\u6062\u590d\u5230 "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    array-length p0, p0

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, " \u5b57\u8282\uff0c\u91cd\u542f\u8f93\u5165\u6cd5\u540e\u751f\u6548"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 314
    const/4 p0, 0x1

    return p0

    .line 316
    :cond_3
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u8bcd\u5e93\u6587\u4ef6\u53ea\u5269 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, " \u5b57\u8282\uff0c\u6682\u65f6\u6ca1\u6709\u53ef\u7528\u7684\u5b8c\u6574\u526f\u672c"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 317
    return v0
.end method

.method private static readableCount(Landroid/content/Context;Ljava/lang/Object;)I
    .locals 0

    .line 415
    :try_start_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->readPresence(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 417
    :catchall_0
    move-exception p0

    .line 418
    const/4 p0, -0x1

    return p0
.end method

.method public static readableEntryCount(Landroid/content/Context;)I
    .locals 2

    .line 95
    const/4 v0, -0x1

    if-nez p0, :cond_0

    return v0

    .line 96
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 97
    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v1

    .line 98
    :goto_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;

    move-result-object v1

    .line 99
    if-nez v1, :cond_2

    goto :goto_1

    :cond_2
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v0

    :goto_1
    return v0
.end method

.method public static recentSaveSizes(Landroid/content/Context;)Ljava/lang/String;
    .locals 7

    .line 120
    const-string v0, ""

    if-nez p0, :cond_0

    return-object v0

    .line 121
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 122
    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v1

    .line 123
    :goto_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-direct {v1, p0, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 124
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "save_journal"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 125
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_2

    return-object v0

    .line 126
    :cond_2
    const-string v0, ";"

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 127
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 128
    array-length v1, p0

    add-int/lit8 v1, v1, -0x5

    const/4 v2, 0x0

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    :goto_1
    array-length v2, p0

    if-ge v1, v2, :cond_7

    .line 129
    aget-object v2, p0, v1

    const/16 v3, 0x3a

    invoke-virtual {v2, v3}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    .line 130
    aget-object v3, p0, v1

    const/16 v4, 0x2f

    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(I)I

    move-result v3

    .line 131
    if-ltz v2, :cond_6

    if-ge v3, v2, :cond_3

    goto :goto_2

    .line 134
    :cond_3
    :try_start_0
    aget-object v4, p0, v1

    add-int/lit8 v2, v2, 0x1

    invoke-virtual {v4, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    .line 137
    nop

    .line 139
    const-wide/16 v4, 0x0

    cmp-long v6, v2, v4

    if-gtz v6, :cond_4

    goto :goto_2

    .line 140
    :cond_4
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    if-lez v4, :cond_5

    const-string v4, "\u3001"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 141
    :cond_5
    invoke-static {v2, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->formatSize(J)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_2

    .line 135
    :catch_0
    move-exception v2

    .line 136
    nop

    .line 128
    :cond_6
    :goto_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 143
    :cond_7
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    .locals 2

    .line 460
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 461
    const-string v0, "last_note"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 462
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-string p1, "last_check_at"

    invoke-interface {p0, p1, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 463
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 464
    return-void
.end method

.method private static repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V
    .locals 9

    .line 381
    invoke-virtual {p1, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->newestRepairable(I)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    move-result-object v0

    .line 382
    if-nez v0, :cond_0

    .line 383
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u8bcd\u6761\u6570\u964d\u5230 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, " \u6761\uff0c\u4f46\u6ca1\u6709\u53ef\u7528\u7684\u5b89\u5168\u5feb\u7167"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 384
    return-void

    .line 386
    :cond_0
    new-instance p4, Ljava/util/ArrayList;

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    .line 388
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-direct {p4, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 389
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;

    .line 390
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->code:Ljava/lang/String;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->phrase:Ljava/lang/String;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->count:I

    invoke-static {v3, v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->addition(Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    move-result-object v2

    invoke-interface {p4, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 392
    goto :goto_0

    .line 393
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->saveLock()Ljava/lang/Object;

    move-result-object v1

    .line 394
    if-nez v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    :cond_2
    monitor-enter v1

    .line 396
    :try_start_0
    move-object v2, p3

    check-cast v2, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, v2, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 401
    nop

    .line 402
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 403
    invoke-static {p0, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v7

    .line 404
    invoke-static {v7, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result p4

    if-eqz p4, :cond_3

    .line 405
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u6062\u590d\u540e\u4ecd\u53ea\u6709 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, " \u6761\uff0c\u5feb\u7167 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object p2, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->file:Ljava/io/File;

    invoke-virtual {p2}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 406
    return-void

    .line 408
    :cond_3
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u5df2\u4ece\u5b89\u5168\u5feb\u7167\u6062\u590d\uff0c\u8bcd\u6761\u6570\u56de\u5230 "

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p4

    const-string v0, " \u6761"

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-static {p1, p4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 409
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    const-string v0, "collapsed_strikes"

    const/4 v1, 0x0

    invoke-interface {p4, v0, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 410
    move-object v3, p0

    move-object v4, p1

    move-object v5, p2

    move-object v6, p3

    move v8, p5

    invoke-static/range {v3 .. v8}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 411
    return-void

    .line 398
    :catchall_0
    move-exception v0

    move-object v4, p1

    move-object p0, v0

    .line 399
    :try_start_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u6062\u590d\u672a\u5b8c\u6210\uff1a"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v4, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 400
    monitor-exit v1

    return-void

    .line 402
    :catchall_1
    move-exception v0

    move-object p0, v0

    monitor-exit v1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method public static request(Landroid/content/Context;)V
    .locals 13

    .line 154
    if-nez p0, :cond_0

    return-void

    .line 155
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 156
    if-nez p0, :cond_1

    return-void

    .line 157
    :cond_1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 158
    sget-object v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->preferencesName:Ljava/lang/String;

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 159
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "request-entered "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 160
    const-string v5, "last_debug"

    invoke-interface {v2, v5, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 161
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 162
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    move-result-object v2

    array-length v4, v2

    :goto_0
    if-ge v3, v4, :cond_4

    aget-object v5, v2, v3

    .line 163
    new-instance v6, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-direct {v6, p0, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 164
    invoke-static {p0, v6, v5, v0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->sampleSave(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;J)V

    .line 165
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v7

    const-wide/16 v8, 0x0

    const-string v10, "last_check_at"

    invoke-interface {v7, v10, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v7

    sub-long v7, v0, v7

    const-wide/32 v11, 0x1499700

    cmp-long v9, v7, v11

    if-gez v9, :cond_2

    .line 167
    goto :goto_1

    .line 171
    :cond_2
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v7

    invoke-interface {v7}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    .line 172
    invoke-interface {v7, v10, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    .line 173
    invoke-interface {v7}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 174
    sget-object v7, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/Map;

    invoke-interface {v7, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Long;

    .line 175
    if-eqz v7, :cond_3

    invoke-virtual {v7}, Ljava/lang/Long;->longValue()J

    move-result-wide v7

    sub-long v7, v0, v7

    const-wide/32 v9, 0x1d4c0

    cmp-long v11, v7, v9

    if-gez v11, :cond_3

    goto :goto_1

    .line 176
    :cond_3
    sget-object v7, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/Map;

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    invoke-interface {v7, v5, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 177
    new-instance v7, Ljava/lang/Thread;

    new-instance v8, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;

    invoke-direct {v8, v6, p0, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;-><init>(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    const-string v5, "dictionary-safety"

    invoke-direct {v7, v8, v5}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 205
    const/4 v5, 0x1

    invoke-virtual {v7, v5}, Ljava/lang/Thread;->setPriority(I)V

    .line 206
    invoke-virtual {v7}, Ljava/lang/Thread;->start()V

    .line 162
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 208
    :cond_4
    return-void
.end method

.method private static runOnce(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 13

    .line 212
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->protectFile(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 216
    return-void

    .line 218
    :cond_0
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;

    move-result-object v4

    .line 219
    if-nez v4, :cond_1

    .line 220
    const-string p0, "\u5f15\u64ce\u5c1a\u672a\u5c31\u7eea\uff0c\u672c\u6b21\u8df3\u8fc7"

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 221
    return-void

    .line 223
    :cond_1
    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v5

    .line 224
    if-gez v5, :cond_2

    .line 225
    const-string p0, "\u6682\u65f6\u8bfb\u4e0d\u51fa\u6761\u76ee\u6570\uff0c\u672c\u6b21\u8df3\u8fc7"

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 226
    return-void

    .line 229
    :cond_2
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 230
    nop

    .line 231
    const-string v1, "known_entry_count"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v3

    .line 230
    invoke-static {v3, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->nextKnownCount(II)I

    move-result v6

    .line 232
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    invoke-interface {v3, v1, v6}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 234
    invoke-static {v5, v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v3

    const/4 v7, 0x1

    const-string v8, "collapsed_strikes"

    if-nez v3, :cond_3

    .line 235
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v8, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 236
    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    invoke-static/range {v1 .. v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 237
    move-object p0, v2

    invoke-virtual {p0, v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 238
    return-void

    .line 240
    :cond_3
    move-object v3, v1

    move-object v1, p0

    move-object p0, p1

    move-object p1, v3

    move-object v3, p2

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "count-collapsed "

    invoke-virtual {p2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v9, "/"

    invoke-virtual {p2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->markCollapse(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 241
    invoke-static {v1, v3, v0, v5, v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entriesCouldStillBeOnDisk(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Landroid/content/SharedPreferences;II)Ljava/lang/Boolean;

    move-result-object p2

    .line 243
    const-string v9, " \u6761\u964d\u5230 "

    const-string v10, "\u8bcd\u6761\u6570\u4ece "

    const-wide/16 v11, 0x0

    if-nez p2, :cond_5

    .line 246
    invoke-static {v1, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide p1

    .line 247
    cmp-long v1, p1, v11

    if-lez v1, :cond_4

    .line 248
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 249
    const-string v1, "known_dictionary_file_size"

    invoke-interface {v0, v1, p1, p2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 251
    :cond_4
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " \u6761\uff0c\u7f3a\u5c11\u6587\u4ef6\u5927\u5c0f\u57fa\u7ebf"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 252
    return-void

    .line 254
    :cond_5
    invoke-virtual {p2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p2

    if-nez p2, :cond_6

    .line 258
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 259
    invoke-interface {p2, v8, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 260
    invoke-interface {p2, p1, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 261
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 262
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u8bcd\u6761\u6570\u964d\u5230 "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " \u6761\uff0c\u6587\u4ef6\u540c\u6b65\u53d8\u5c0f\uff0c\u6309\u5220\u9664\u5904\u7406"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 263
    move v6, v5

    move-object v2, p0

    invoke-static/range {v1 .. v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 264
    invoke-virtual {p0, v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 265
    return-void

    .line 268
    :cond_6
    invoke-interface {v0, v8, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p1

    add-int/2addr p1, v7

    .line 269
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2, v8, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 270
    const/4 p2, 0x2

    if-ge p1, p2, :cond_7

    .line 271
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " \u6761\uff0c\u7b49\u5f85\u590d\u6838"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 272
    return-void

    .line 274
    :cond_7
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    const-string v2, "last_repair_at"

    invoke-interface {v0, v2, v11, v12}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v7

    sub-long/2addr p1, v7

    const-wide/32 v7, 0x5265c00

    cmp-long v9, p1, v7

    if-gez v9, :cond_8

    .line 276
    return-void

    .line 278
    :cond_8
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 279
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    invoke-interface {p1, v2, v7, v8}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 280
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 281
    move-object v2, p0

    invoke-static/range {v1 .. v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 282
    return-void
.end method

.method private static sampleSave(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;J)V
    .locals 9

    .line 57
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v0

    .line 58
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->backupDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v2

    .line 59
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, "/"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 60
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p2

    const-string v0, "save_journal"

    const-string v1, ""

    invoke-interface {p2, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 61
    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    const/4 v3, 0x0

    const/16 v4, 0x3b

    if-nez v2, :cond_1

    .line 62
    invoke-virtual {p2, v4}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v2

    add-int/lit8 v2, v2, 0x1

    invoke-virtual {p2, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    .line 63
    const/16 v5, 0x3a

    invoke-virtual {v2, v5}, Ljava/lang/String;->indexOf(I)I

    move-result v5

    .line 64
    invoke-virtual {v2, p0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_1

    if-lez v5, :cond_1

    .line 66
    :try_start_0
    invoke-virtual {v2, v3, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v5
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    sub-long v5, p3, v5

    const-wide/16 v7, 0x7530

    cmp-long v2, v5, v7

    if-gez v2, :cond_0

    return-void

    .line 69
    :cond_0
    goto :goto_0

    .line 67
    :catch_0
    move-exception v2

    .line 72
    :cond_1
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 73
    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    const-string v6, ";"

    if-eqz v5, :cond_2

    goto :goto_1

    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ":"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 74
    invoke-virtual {p0, v6}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 75
    array-length p2, p0

    add-int/lit8 p2, p2, -0xc

    invoke-static {v3, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    :goto_2
    array-length p3, p0

    if-ge p2, p3, :cond_4

    .line 77
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result p3

    if-lez p3, :cond_3

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 78
    :cond_3
    aget-object p3, p0, p2

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 76
    add-int/lit8 p2, p2, 0x1

    goto :goto_2

    .line 80
    :cond_4
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 81
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 82
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 83
    return-void
.end method

.method private static saveLock()Ljava/lang/Object;
    .locals 3

    .line 453
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "sSaveLock"

    invoke-virtual {v1, v2}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v0

    .line 454
    :catchall_0
    move-exception v1

    .line 455
    return-object v0
.end method
