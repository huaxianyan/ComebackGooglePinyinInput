.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;
.super Ljava/lang/Object;
.source "DictionarySafetyGuard.java"


# static fields
.field private static final BUSY:Ljava/util/concurrent/ConcurrentHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap<",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private static final CHECK_INTERVAL_MS:J = 0x1499700L

.field private static final REPAIR_INTERVAL_MS:J = 0x5265c00L

.field private static final REPAIR_LOCK:Ljava/lang/Object;

.field private static final RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static final SAVE_LOCK_CLASS:Ljava/lang/String; = "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

.field private static final SAVE_LOCK_FIELD:Ljava/lang/String; = "sSaveLock"

.field private static final STRIKES_BEFORE_REPAIR:I = 0x2

.field private static final busy:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 34
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 36
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/concurrent/ConcurrentHashMap;

    .line 37
    sget-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->BUSY:Ljava/util/concurrent/ConcurrentHashMap;

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->busy:Ljava/util/Map;

    .line 38
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 40
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
    sget-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->busy:Ljava/util/Map;

    return-object v0
.end method

.method static synthetic access$300()Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    .line 24
    sget-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method private static capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V
    .locals 2

    .line 172
    invoke-static {p4, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->acceptsSnapshot(II)Z

    move-result p5

    if-nez p5, :cond_0

    return-void

    .line 173
    :cond_0
    invoke-static {p0, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entries(Landroid/content/Context;Ljava/lang/Object;)Ljava/util/List;

    move-result-object p3

    .line 174
    if-eqz p3, :cond_3

    invoke-interface {p3}, Ljava/util/List;->isEmpty()Z

    move-result p5

    if-eqz p5, :cond_1

    goto :goto_0

    .line 175
    :cond_1
    invoke-static {p4, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->of(ILjava/util/List;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object p3

    .line 176
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->snapshots()Ljava/util/List;

    move-result-object p4

    .line 177
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p5

    invoke-interface {p5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p5

    .line 179
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v0

    .line 178
    const-string p0, "known_dictionary_file_size"

    invoke-interface {p5, p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 180
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 181
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

    .line 182
    invoke-static {p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J

    move-result-wide v0

    cmp-long p0, p4, v0

    if-nez p0, :cond_2

    .line 183
    return-void

    .line 185
    :cond_2
    invoke-virtual {p1, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->write(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    .line 186
    return-void

    .line 174
    :cond_3
    :goto_0
    return-void
.end method

.method private static engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;
    .locals 6

    .line 252
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

    .line 253
    invoke-virtual {p1, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v1, v2, [Ljava/lang/Object;

    aput-object p0, v1, v5

    invoke-virtual {p1, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 254
    instance-of p1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p1, :cond_0

    move-object v0, p0

    :cond_0
    return-object v0

    .line 255
    :catchall_0
    move-exception p0

    .line 256
    return-object v0
.end method

.method private static entries(Landroid/content/Context;Ljava/lang/Object;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;",
            ">;"
        }
    .end annotation

    .line 235
    :try_start_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 236
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    .line 237
    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    .line 238
    new-instance p1, Ljava/util/ArrayList;

    .line 239
    invoke-interface {p0}, Ljava/util/Collection;->size()I

    move-result v0

    invoke-direct {p1, v0}, Ljava/util/ArrayList;-><init>(I)V

    .line 240
    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 241
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->count:I

    invoke-direct {v1, v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;I)V

    invoke-interface {p1, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 243
    goto :goto_0

    .line 244
    :cond_0
    return-object p1

    .line 245
    :catchall_0
    move-exception p0

    .line 246
    const/4 p0, 0x0

    return-object p0
.end method

.method private static entriesCouldStillBeOnDisk(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Landroid/content/SharedPreferences;II)Ljava/lang/Boolean;
    .locals 5

    .line 160
    const-string v0, "known_dictionary_file_size"

    const-wide/16 v1, 0x0

    invoke-interface {p2, v0, v1, v2}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v3

    .line 161
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide p0

    .line 162
    cmp-long p2, v3, v1

    if-lez p2, :cond_3

    cmp-long p2, p0, v1

    if-gtz p2, :cond_0

    goto :goto_1

    .line 163
    :cond_0
    if-gtz p3, :cond_1

    sget-object p0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p0

    .line 164
    :cond_1
    int-to-long p2, p3

    mul-long v3, v3, p2

    int-to-long p2, p4

    div-long/2addr v3, p2

    .line 165
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

    .line 162
    :cond_3
    :goto_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private static readableCount(Landroid/content/Context;Ljava/lang/Object;)I
    .locals 0

    .line 226
    :try_start_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->readPresence(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 228
    :catchall_0
    move-exception p0

    .line 229
    const/4 p0, -0x1

    return p0
.end method

.method public static readableEntryCount(Landroid/content/Context;)I
    .locals 2

    .line 44
    const/4 v0, -0x1

    if-nez p0, :cond_0

    return v0

    .line 45
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 46
    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    move-object p0, v1

    .line 47
    :goto_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;

    move-result-object v1

    .line 48
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

    .line 269
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 270
    const-string v0, "last_note"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 271
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-string p1, "last_check_at"

    invoke-interface {p0, p1, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 272
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 273
    return-void
.end method

.method private static repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V
    .locals 9

    .line 192
    invoke-virtual {p1, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->newestRepairable(I)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    move-result-object v0

    .line 193
    if-nez v0, :cond_0

    .line 194
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

    .line 195
    return-void

    .line 197
    :cond_0
    new-instance p4, Ljava/util/ArrayList;

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    .line 199
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-direct {p4, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 200
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

    .line 201
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->code:Ljava/lang/String;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->phrase:Ljava/lang/String;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->count:I

    invoke-static {v3, v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->addition(Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    move-result-object v2

    invoke-interface {p4, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 203
    goto :goto_0

    .line 204
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->saveLock()Ljava/lang/Object;

    move-result-object v1

    .line 205
    if-nez v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    :cond_2
    monitor-enter v1

    .line 207
    :try_start_0
    move-object v2, p3

    check-cast v2, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, v2, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 212
    nop

    .line 213
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 214
    invoke-static {p0, p3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v7

    .line 215
    invoke-static {v7, p5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result p4

    if-eqz p4, :cond_3

    .line 216
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

    .line 217
    return-void

    .line 219
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

    .line 220
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    const-string v0, "collapsed_strikes"

    const/4 v1, 0x0

    invoke-interface {p4, v0, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 221
    move-object v3, p0

    move-object v4, p1

    move-object v5, p2

    move-object v6, p3

    move v8, p5

    invoke-static/range {v3 .. v8}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 222
    return-void

    .line 209
    :catchall_0
    move-exception v0

    move-object v4, p1

    move-object p0, v0

    .line 210
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

    .line 211
    monitor-exit v1

    return-void

    .line 213
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

    .line 53
    if-nez p0, :cond_0

    return-void

    .line 54
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 55
    if-nez p0, :cond_1

    return-void

    .line 56
    :cond_1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 57
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    move-result-object v2

    array-length v3, v2

    const/4 v4, 0x0

    const/4 v5, 0x0

    :goto_0
    if-ge v5, v3, :cond_5

    aget-object v6, v2, v5

    .line 58
    new-instance v7, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-direct {v7, p0, v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    .line 59
    invoke-virtual {v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v8

    const-string v9, "last_check_at"

    const-wide/16 v10, 0x0

    invoke-interface {v8, v9, v10, v11}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v8

    sub-long v8, v0, v8

    const-wide/32 v10, 0x1499700

    cmp-long v12, v8, v10

    if-gez v12, :cond_2

    .line 61
    goto :goto_1

    .line 63
    :cond_2
    sget-object v8, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v9, 0x1

    invoke-virtual {v8, v4, v9}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v8

    if-nez v8, :cond_3

    return-void

    .line 64
    :cond_3
    sget-object v8, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    sget-object v10, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->busy:Ljava/util/Map;

    sget-object v11, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-interface {v10, v6, v11}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    invoke-virtual {v8, v10}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_4

    .line 65
    sget-object v6, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v6, v4}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 66
    goto :goto_1

    .line 68
    :cond_4
    new-instance v8, Ljava/lang/Thread;

    new-instance v10, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;

    invoke-direct {v10, p0, v7, v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V

    const-string v6, "dictionary-safety"

    invoke-direct {v8, v10, v6}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 84
    invoke-virtual {v8, v9}, Ljava/lang/Thread;->setPriority(I)V

    .line 85
    invoke-virtual {v8}, Ljava/lang/Thread;->start()V

    .line 57
    :goto_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 87
    :cond_5
    return-void
.end method

.method private static runOnce(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 13

    .line 91
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)Ljava/lang/Object;

    move-result-object v3

    .line 92
    if-nez v3, :cond_0

    return-void

    .line 93
    :cond_0
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v4

    .line 94
    if-gez v4, :cond_1

    return-void

    .line 96
    :cond_1
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 97
    nop

    .line 98
    const-string v1, "known_entry_count"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v5

    .line 97
    invoke-static {v5, v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->nextKnownCount(II)I

    move-result v5

    .line 99
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    invoke-interface {v6, v1, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    invoke-interface {v6}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 101
    invoke-static {v4, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v6

    const/4 v7, 0x1

    const-string v8, "collapsed_strikes"

    if-nez v6, :cond_2

    .line 102
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v8, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 103
    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    invoke-static/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 104
    move-object p0, v1

    invoke-virtual {p0, v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 105
    return-void

    .line 107
    :cond_2
    move-object v2, v0

    move-object v0, p0

    move-object p0, p1

    move-object p1, v2

    move-object v2, p2

    const/4 p2, 0x0

    invoke-static {v0, v2, p1, v4, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entriesCouldStillBeOnDisk(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Landroid/content/SharedPreferences;II)Ljava/lang/Boolean;

    move-result-object v6

    .line 109
    const-string v9, " \u6761\u964d\u5230 "

    const-string v10, "\u8bcd\u6761\u6570\u4ece "

    const-wide/16 v11, 0x0

    if-nez v6, :cond_4

    .line 112
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->mainDictionarySize(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)J

    move-result-wide v0

    .line 113
    cmp-long p2, v0, v11

    if-lez p2, :cond_3

    .line 114
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 115
    const-string p2, "known_dictionary_file_size"

    invoke-interface {p1, p2, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 117
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

    .line 118
    return-void

    .line 120
    :cond_4
    invoke-virtual {v6}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v6

    if-nez v6, :cond_5

    .line 124
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 125
    invoke-interface {p1, v8, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 126
    invoke-interface {p1, v1, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 127
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 128
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

    .line 129
    move v5, v4

    move-object v1, p0

    invoke-static/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 130
    invoke-virtual {v1, v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 131
    return-void

    .line 134
    :cond_5
    move-object v1, p0

    invoke-interface {p1, v8, p2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    add-int/2addr p0, v7

    .line 135
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2, v8, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 136
    const/4 p2, 0x2

    if-ge p0, p2, :cond_6

    .line 137
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

    .line 138
    return-void

    .line 140
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

    .line 142
    return-void

    .line 144
    :cond_7
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 145
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    invoke-interface {p1, p0, v6, v7}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 146
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 147
    invoke-static/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;Ljava/lang/Object;II)V

    .line 148
    return-void
.end method

.method private static saveLock()Ljava/lang/Object;
    .locals 3

    .line 262
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

    .line 263
    :catchall_0
    move-exception v1

    .line 264
    return-object v0
.end method
