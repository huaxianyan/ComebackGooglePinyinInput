.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;
.super Ljava/lang/Object;
.source "DictionarySafetyGuard.java"


# static fields
.field private static final CHECK_INTERVAL_MS:J = 0x1499700L

.field private static final ENGINE_FACTORY_CLASS:Ljava/lang/String; = "bdt"

.field private static final REPAIR_INTERVAL_MS:J = 0x5265c00L

.field private static final REPAIR_LOCK:Ljava/lang/Object;

.field private static final RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static final SAVE_LOCK_CLASS:Ljava/lang/String; = "com.google.android.apps.inputmethod.libs.hmm.SaveDictionaryTask"

.field private static final SAVE_LOCK_FIELD:Ljava/lang/String; = "sSaveLock"

.field private static final STRIKES_BEFORE_REPAIR:I = 0x2


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 35
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 36
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;)V
    .locals 0

    .line 24
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->runOnce(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;)V

    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    .locals 0

    .line 24
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$200()Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    .line 24
    sget-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method private static capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/Object;II)V
    .locals 2

    .line 108
    invoke-static {p3, p4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->acceptsSnapshot(II)Z

    move-result p4

    if-nez p4, :cond_0

    return-void

    .line 109
    :cond_0
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->entries(Landroid/content/Context;Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    .line 110
    if-eqz p0, :cond_3

    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_1

    goto :goto_0

    .line 111
    :cond_1
    invoke-static {p3, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->of(ILjava/util/List;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object p0

    .line 112
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->snapshots()Ljava/util/List;

    move-result-object p2

    .line 113
    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result p3

    if-nez p3, :cond_2

    const/4 p3, 0x0

    invoke-interface {p2, p3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J

    move-result-wide p2

    .line 114
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J

    move-result-wide v0

    cmp-long p4, p2, v0

    if-nez p4, :cond_2

    .line 115
    return-void

    .line 117
    :cond_2
    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->write(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    .line 118
    return-void

    .line 110
    :cond_3
    :goto_0
    return-void
.end method

.method private static engineFactory(Landroid/content/Context;)Ljava/lang/Object;
    .locals 7

    .line 183
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "bdt"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "a"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    .line 184
    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v3, [Ljava/lang/Object;

    aput-object p0, v2, v6

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 185
    instance-of v1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_0

    move-object v0, p0

    :cond_0
    return-object v0

    .line 186
    :catchall_0
    move-exception p0

    .line 187
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

    .line 166
    :try_start_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    .line 167
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    .line 168
    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    .line 169
    new-instance p1, Ljava/util/ArrayList;

    .line 170
    invoke-interface {p0}, Ljava/util/Collection;->size()I

    move-result v0

    invoke-direct {p1, v0}, Ljava/util/ArrayList;-><init>(I)V

    .line 171
    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 172
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->count:I

    invoke-direct {v1, v2, v3, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;I)V

    invoke-interface {p1, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 174
    goto :goto_0

    .line 175
    :cond_0
    return-object p1

    .line 176
    :catchall_0
    move-exception p0

    .line 177
    const/4 p0, 0x0

    return-object p0
.end method

.method private static readableCount(Landroid/content/Context;Ljava/lang/Object;)I
    .locals 0

    .line 157
    :try_start_0
    check-cast p1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->readPresence(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 159
    :catchall_0
    move-exception p0

    .line 160
    const/4 p0, -0x1

    return p0
.end method

.method private static record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    .locals 2

    .line 200
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 201
    const-string v0, "last_note"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 202
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-string p1, "last_check_at"

    invoke-interface {p0, p1, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 203
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 204
    return-void
.end method

.method private static repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/Object;II)V
    .locals 5

    .line 123
    invoke-virtual {p1, p4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->newestRepairable(I)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    move-result-object v0

    .line 124
    if-nez v0, :cond_0

    .line 125
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u8bcd\u6761\u6570\u964d\u5230 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, " \u6761\uff0c\u4f46\u6ca1\u6709\u53ef\u7528\u7684\u5b89\u5168\u5feb\u7167"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 126
    return-void

    .line 128
    :cond_0
    new-instance p3, Ljava/util/ArrayList;

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    .line 130
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-direct {p3, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 131
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

    .line 132
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->code:Ljava/lang/String;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->phrase:Ljava/lang/String;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot$Entry;->count:I

    invoke-static {v3, v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->addition(Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    move-result-object v2

    invoke-interface {p3, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 134
    goto :goto_0

    .line 135
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->saveLock()Ljava/lang/Object;

    move-result-object v1

    .line 136
    if-nez v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->REPAIR_LOCK:Ljava/lang/Object;

    :cond_2
    monitor-enter v1

    .line 138
    :try_start_0
    move-object v2, p2

    check-cast v2, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {p0, v2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 143
    nop

    .line 144
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 145
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result p3

    .line 146
    invoke-static {p3, p4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 147
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u6062\u590d\u540e\u4ecd\u53ea\u6709 "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

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

    .line 148
    return-void

    .line 150
    :cond_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5df2\u4ece\u5b89\u5168\u5feb\u7167\u6062\u590d\uff0c\u8bcd\u6761\u6570\u56de\u5230 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u6761"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 151
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "collapsed_strikes"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 152
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/Object;II)V

    .line 153
    return-void

    .line 140
    :catchall_0
    move-exception p0

    .line 141
    :try_start_2
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "\u6062\u590d\u672a\u5b8c\u6210\uff1a"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 142
    monitor-exit v1

    return-void

    .line 144
    :catchall_1
    move-exception p0

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
    .locals 7

    .line 42
    if-nez p0, :cond_0

    return-void

    .line 43
    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 44
    if-nez p0, :cond_1

    return-void

    .line 45
    :cond_1
    new-instance v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;-><init>(Landroid/content/Context;)V

    .line 46
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 47
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v3

    const-string v4, "last_check_at"

    const-wide/16 v5, 0x0

    invoke-interface {v3, v4, v5, v6}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v3

    sub-long/2addr v1, v3

    const-wide/32 v3, 0x1499700

    cmp-long v5, v1, v3

    if-gez v5, :cond_2

    .line 49
    return-void

    .line 51
    :cond_2
    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->RUNNING:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v3}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v1

    if-nez v1, :cond_3

    return-void

    .line 52
    :cond_3
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;)V

    const-string p0, "dictionary-safety"

    invoke-direct {v1, v2, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 67
    invoke-virtual {v1, v3}, Ljava/lang/Thread;->setPriority(I)V

    .line 68
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 69
    return-void
.end method

.method private static runOnce(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;)V
    .locals 10

    .line 72
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->engineFactory(Landroid/content/Context;)Ljava/lang/Object;

    move-result-object v0

    .line 73
    if-nez v0, :cond_0

    return-void

    .line 74
    :cond_0
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->readableCount(Landroid/content/Context;Ljava/lang/Object;)I

    move-result v1

    .line 75
    if-gez v1, :cond_1

    return-void

    .line 77
    :cond_1
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v2

    .line 78
    nop

    .line 79
    const-string v3, "known_entry_count"

    const/4 v4, 0x0

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v5

    .line 78
    invoke-static {v5, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->nextKnownCount(II)I

    move-result v5

    .line 80
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    invoke-interface {v6, v3, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 82
    invoke-static {v1, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->isCollapsed(II)Z

    move-result v3

    const/4 v6, 0x1

    const-string v7, "collapsed_strikes"

    if-nez v3, :cond_2

    .line 83
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2, v7, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 84
    invoke-static {p0, p1, v0, v1, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->capture(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/Object;II)V

    .line 85
    invoke-virtual {p1, v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->rotate(Z)V

    .line 86
    return-void

    .line 89
    :cond_2
    invoke-interface {v2, v7, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v3

    add-int/2addr v3, v6

    .line 90
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    invoke-interface {v4, v7, v3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 91
    const/4 v4, 0x2

    if-ge v3, v4, :cond_3

    .line 92
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u8bcd\u6761\u6570\u4ece "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, " \u6761\u964d\u5230 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, " \u6761\uff0c\u7b49\u5f85\u590d\u6838"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->record(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V

    .line 93
    return-void

    .line 95
    :cond_3
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    const-wide/16 v6, 0x0

    const-string v8, "last_repair_at"

    invoke-interface {v2, v8, v6, v7}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v6

    sub-long/2addr v3, v6

    const-wide/32 v6, 0x5265c00

    cmp-long v9, v3, v6

    if-gez v9, :cond_4

    .line 97
    return-void

    .line 99
    :cond_4
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 100
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    invoke-interface {v2, v8, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 101
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 102
    invoke-static {p0, p1, v0, v1, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->repair(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/Object;II)V

    .line 103
    return-void
.end method

.method private static saveLock()Ljava/lang/Object;
    .locals 3

    .line 193
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

    .line 194
    :catchall_0
    move-exception v1

    .line 195
    return-object v0
.end method
