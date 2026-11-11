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

    .line 45
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

    .line 245
    invoke-static {p4, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->acceptsSnapshot(II)Z

    move-result p5

    if-nez p5, :cond_0

    return-void

    .line 246
    :cond_0
    invoke-static {p1, p0, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entries(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Landroid/content/Context;Ljava/lang/Object;)Ljava/util/List;

    move-result-object p3

    .line 247
    if-eqz p3, :cond_3

    invoke-interface {p3}, Ljava/util/List;->isEmpty()Z

    move-result p5

    if-eqz p5, :cond_1

    goto :goto_0

    .line 251
    :cond_1
    invoke-static {p4, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->of(ILjava/util/List;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object p3

    .line 252
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->snapshots()Ljava/util/List;

    move-result-object p4

    .line 253
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p5

    invoke-interface {p5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p5

    .line 255
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v0

    .line 254
    const-string p0, "known_dictionary_file_size"

    invoke-interface {p5, p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 256
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 257
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

    .line 258
    invoke-static {p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J

    move-result-wide v0

    cmp-long p0, p4, v0

    if-nez p0, :cond_2

    .line 259
    return-void

    .line 261
    :cond_2
    invoke-virtual {p1, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->write(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    .line 262
    return-void

    .line 248
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

    .line 249
    return-void
.end method

.method private static engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;
    .locals 6

    .line 330
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

    .line 331
    invoke-virtual {p1, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v1, v2, [Ljava/lang/Object;

    aput-object p0, v1, v5

    invoke-virtual {p1, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 332
    instance-of p1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p1, :cond_0

    move-object v0, p0

    :cond_0
    return-object v0

    .line 333
    :catchall_0
    move-exception p0

    .line 334
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

    .line 312
    :try_start_0
    check-cast p2, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 313
    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p1

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    .line 314
    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p1

    .line 315
    new-instance p2, Ljava/util/ArrayList;

    .line 316
    invoke-interface {p1}, Ljava/util/Collection;->size()I

    move-result v0

    invoke-direct {p2, v0}, Ljava/util/ArrayList;-><init>(I)V

    .line 317
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 318
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->count:I

    invoke-direct {v1, v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;I)V

    invoke-interface {p2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 320
    goto :goto_0

    .line 321
    :cond_0
    return-object p2

    .line 322
    :catchall_0
    move-exception p1

    .line 323
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

    .line 324
    const/4 p0, 0x0

    return-object p0
.end method

.method private static entriesCouldStillBeOnDisk(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Landroid/content/SharedPreferences;II)Ljava/lang/Boolean;
    .locals 5

    .line 233
    const-string v0, "known_dictionary_file_size"

    const-wide/16 v1, 0x0

    invoke-interface {p2, v0, v1, v2}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v3

    .line 234
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide p0

    .line 235
    cmp-long p2, v3, v1

    if-lez p2, :cond_3

    cmp-long p2, p0, v1

    if-gtz p2, :cond_0

    goto :goto_1

    .line 236
    :cond_0
    if-gtz p3, :cond_1

    sget-object p0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p0

    .line 237
    :cond_1
    int-to-long p2, p3

    mul-long v3, v3, p2

    int-to-long p2, p4

    div-long/2addr v3, p2

    .line 238
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

    .line 235
    :cond_3
    :goto_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static forget(Landroid/content/Context;)V
    .locals 8

    .line 209
    if-nez p0, :cond_0

    return-void

    .line 210
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    .line 211
    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v0

    .line 212
    :goto_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_1
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    .line 213
    new-instance v5, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-direct {v5, p0, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 214
    new-instance v6, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;

    invoke-direct {v6, p0, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->forget()V

    .line 215
    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 216
    const-string v5, "dictionary_file_high_water"

    const-wide/16 v6, 0x0

    invoke-interface {v4, v5, v6, v7}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 217
    const-string v5, "known_entry_count"

    invoke-interface {v4, v5, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 218
    const-string v5, "collapsed_strikes"

    invoke-interface {v4, v5, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 219
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 212
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 221
    :cond_2
    return-void
.end method

.method private static protectFile(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 8

    .line 184
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 185
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;

    invoke-direct {v1, p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 186
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->read()[B

    move-result-object p0

    .line 187
    const-wide/16 v2, 0x0

    if-nez p0, :cond_0

    move-wide v4, v2

    goto :goto_0

    :cond_0
    array-length p2, p0

    int-to-long v4, p2

    .line 188
    :goto_0
    const-string p2, "dictionary_file_high_water"

    invoke-interface {v0, p2, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v2

    .line 190
    cmp-long v6, v4, v2

    if-lez v6, :cond_1

    .line 191
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 192
    invoke-interface {v0, p2, v4, v5}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 193
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 195
    :cond_1
    invoke-static {v4, v5, v2, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isFileCollapsed(JJ)Z

    move-result p2

    if-nez p2, :cond_2

    .line 196
    invoke-virtual {v1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->keep([B)Z

    .line 197
    return-void

    .line 199
    :cond_2
    const-wide/16 v6, 0x2

    div-long/2addr v2, v6

    invoke-virtual {v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->newestAtLeast(J)[B

    move-result-object p0

    .line 200
    if-eqz p0, :cond_3

    invoke-virtual {v1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->restore([B)Z

    move-result p2

    if-eqz p2, :cond_3

    .line 201
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

    const-string p2, " \u5b57\u8282"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 202
    return-void

    .line 204
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

    .line 205
    return-void
.end method

.method private static readableCount(Landroid/content/Context;Ljava/lang/Object;)I
    .locals 0

    .line 302
    :try_start_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->readPresence(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 304
    :catchall_0
    move-exception p0

    .line 305
    const/4 p0, -0x1

    return p0
.end method

.method public static readableEntryCount(Landroid/content/Context;)I
    .locals 2

    .line 49
    const/4 v0, -0x1

    if-nez p0, :cond_0

    return v0

    .line 50
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 51
    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v1

    .line 52
    :goto_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;

    move-result-object v1

    .line 53
    if-nez v1, :cond_2

    goto :goto_1

    :cond_2
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v0

    :goto_1
    return v0
.end method

.method private static record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    .locals 2

    .line 347
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 348
    const-string v0, "last_note"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 349
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-string p1, "last_check_at"

    invoke-interface {p0, p1, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 350
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 351
    return-void
.end method

.method private static repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V
    .locals 9

    .line 268
    invoke-virtual {p1, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->newestRepairable(I)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    move-result-object v0

    .line 269
    if-nez v0, :cond_0

    .line 270
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

    .line 271
    return-void

    .line 273
    :cond_0
    new-instance p4, Ljava/util/ArrayList;

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    .line 275
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-direct {p4, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 276
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

    .line 277
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->code:Ljava/lang/String;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->phrase:Ljava/lang/String;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->count:I

    invoke-static {v3, v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->addition(Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    move-result-object v2

    invoke-interface {p4, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 279
    goto :goto_0

    .line 280
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->saveLock()Ljava/lang/Object;

    move-result-object v1

    .line 281
    if-nez v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    :cond_2
    monitor-enter v1

    .line 283
    :try_start_0
    move-object v2, p3

    check-cast v2, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, v2, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 288
    nop

    .line 289
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 290
    invoke-static {p0, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v7

    .line 291
    invoke-static {v7, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result p4

    if-eqz p4, :cond_3

    .line 292
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

    .line 293
    return-void

    .line 295
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

    .line 296
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    const-string v0, "collapsed_strikes"

    const/4 v1, 0x0

    invoke-interface {p4, v0, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 297
    move-object v3, p0

    move-object v4, p1

    move-object v5, p2

    move-object v6, p3

    move v8, p5

    invoke-static/range {v3 .. v8}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 298
    return-void

    .line 285
    :catchall_0
    move-exception v0

    move-object v4, p1

    move-object p0, v0

    .line 286
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

    .line 287
    monitor-exit v1

    return-void

    .line 289
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

    .line 58
    if-nez p0, :cond_0

    return-void

    .line 59
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 60
    if-nez p0, :cond_1

    return-void

    .line 61
    :cond_1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 62
    sget-object v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->preferencesName:Ljava/lang/String;

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 63
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

    .line 64
    const-string v5, "last_debug"

    invoke-interface {v2, v5, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 65
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 66
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    move-result-object v2

    array-length v4, v2

    :goto_0
    if-ge v3, v4, :cond_4

    aget-object v5, v2, v3

    .line 67
    new-instance v6, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-direct {v6, p0, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 68
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

    .line 70
    goto :goto_1

    .line 74
    :cond_2
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v7

    invoke-interface {v7}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    .line 75
    invoke-interface {v7, v10, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    .line 76
    invoke-interface {v7}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 77
    sget-object v7, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/Map;

    invoke-interface {v7, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Long;

    .line 78
    if-eqz v7, :cond_3

    invoke-virtual {v7}, Ljava/lang/Long;->longValue()J

    move-result-wide v7

    sub-long v7, v0, v7

    const-wide/32 v9, 0x1d4c0

    cmp-long v11, v7, v9

    if-gez v11, :cond_3

    goto :goto_1

    .line 79
    :cond_3
    sget-object v7, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/Map;

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    invoke-interface {v7, v5, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 80
    new-instance v7, Ljava/lang/Thread;

    new-instance v8, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;

    invoke-direct {v8, v6, p0, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;-><init>(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    const-string v5, "dictionary-safety"

    invoke-direct {v7, v8, v5}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 101
    const/4 v5, 0x1

    invoke-virtual {v7, v5}, Ljava/lang/Thread;->setPriority(I)V

    .line 102
    invoke-virtual {v7}, Ljava/lang/Thread;->start()V

    .line 66
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 104
    :cond_4
    return-void
.end method

.method private static runOnce(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 13

    .line 108
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->protectFile(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 109
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;

    move-result-object v3

    .line 110
    if-nez v3, :cond_0

    .line 111
    const-string p0, "\u5f15\u64ce\u5c1a\u672a\u5c31\u7eea\uff0c\u672c\u6b21\u8df3\u8fc7"

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 112
    return-void

    .line 114
    :cond_0
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v4

    .line 115
    if-gez v4, :cond_1

    .line 116
    const-string p0, "\u6682\u65f6\u8bfb\u4e0d\u51fa\u6761\u76ee\u6570\uff0c\u672c\u6b21\u8df3\u8fc7"

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 117
    return-void

    .line 120
    :cond_1
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 121
    nop

    .line 122
    const-string v1, "known_entry_count"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v5

    .line 121
    invoke-static {v5, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->nextKnownCount(II)I

    move-result v5

    .line 123
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    invoke-interface {v6, v1, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    invoke-interface {v6}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 125
    invoke-static {v4, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v6

    const/4 v7, 0x1

    const-string v8, "collapsed_strikes"

    if-nez v6, :cond_2

    .line 126
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v8, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 127
    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    invoke-static/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 128
    move-object p0, v1

    invoke-virtual {p0, v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 129
    return-void

    .line 131
    :cond_2
    move-object v2, v0

    move-object v0, p0

    move-object p0, p1

    move-object p1, v2

    move-object v2, p2

    const/4 p2, 0x0

    invoke-static {v0, v2, p1, v4, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entriesCouldStillBeOnDisk(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Landroid/content/SharedPreferences;II)Ljava/lang/Boolean;

    move-result-object v6

    .line 133
    const-string v9, " \u6761\u964d\u5230 "

    const-string v10, "\u8bcd\u6761\u6570\u4ece "

    const-wide/16 v11, 0x0

    if-nez v6, :cond_4

    .line 136
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v0

    .line 137
    cmp-long p2, v0, v11

    if-lez p2, :cond_3

    .line 138
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 139
    const-string p2, "known_dictionary_file_size"

    invoke-interface {p1, p2, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 141
    :cond_3
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " \u6761\uff0c\u7f3a\u5c11\u6587\u4ef6\u5927\u5c0f\u57fa\u7ebf"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 142
    return-void

    .line 144
    :cond_4
    invoke-virtual {v6}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v6

    if-nez v6, :cond_5

    .line 148
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 149
    invoke-interface {p1, v8, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 150
    invoke-interface {p1, v1, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 151
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 152
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u8bcd\u6761\u6570\u964d\u5230 "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " \u6761\uff0c\u6587\u4ef6\u540c\u6b65\u53d8\u5c0f\uff0c\u6309\u5220\u9664\u5904\u7406"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 153
    move v5, v4

    move-object v1, p0

    invoke-static/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 154
    invoke-virtual {v1, v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 155
    return-void

    .line 158
    :cond_5
    move-object v1, p0

    invoke-interface {p1, v8, p2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    add-int/2addr p0, v7

    .line 159
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2, v8, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 160
    const/4 p2, 0x2

    if-ge p0, p2, :cond_6

    .line 161
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " \u6761\uff0c\u7b49\u5f85\u590d\u6838"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 162
    return-void

    .line 164
    :cond_6
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    const-string p0, "last_repair_at"

    invoke-interface {p1, p0, v11, v12}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v8

    sub-long/2addr v6, v8

    const-wide/32 v8, 0x5265c00

    cmp-long p2, v6, v8

    if-gez p2, :cond_7

    .line 166
    return-void

    .line 168
    :cond_7
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 169
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    invoke-interface {p1, p0, v6, v7}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 170
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 171
    invoke-static/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 172
    return-void
.end method

.method private static saveLock()Ljava/lang/Object;
    .locals 3

    .line 340
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

    .line 341
    :catchall_0
    move-exception v1

    .line 342
    return-object v0
.end method
