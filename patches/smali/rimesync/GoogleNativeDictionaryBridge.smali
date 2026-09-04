.class public final Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;
.super Ljava/lang/Object;
.source "GoogleNativeDictionaryBridge.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;,
        Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;
    }
.end annotation


# static fields
.field public static final FAILURE_DATA:I = 0xa

.field public static final FAILURE_DUPLICATE:I = 0x5

.field public static final FAILURE_EXPORT:I = 0x9

.field public static final FAILURE_INSERT:I = 0x6

.field public static final FAILURE_PERSIST:I = 0x7

.field public static final FAILURE_REBUILD:I = 0x8

.field public static final FAILURE_STALE:I = 0xb

.field private static final NEW_ENTRY_COUNT:I = 0x1

.field private static final PINYIN_LANGUAGE_ID:I = 0x10

.field public static final USER_DICTIONARY_CAPACITY:I = 0x7a120


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$200(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 22
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizeCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$300(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 22
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizePhrase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static apply(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;)",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 65
    nop

    .line 66
    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object v0

    .line 65
    const/4 v1, 0x0

    invoke-static {p0, p1, p2, v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->applyInternal(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;ZLjava/util/Set;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    move-result-object p0

    return-object p0
.end method

.method private static applyInternal(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;ZLjava/util/Set;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;Z",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 88
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->requireArguments(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V

    .line 89
    if-eqz p2, :cond_e

    .line 90
    sget-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;

    monitor-enter v0

    .line 91
    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->open(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 93
    :try_start_1
    invoke-virtual {v1}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->duplicateDictionary()Z

    move-result v2

    if-eqz v2, :cond_c

    .line 97
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->snapshot(Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object v2

    .line 98
    invoke-static {v2, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->prepare(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Ljava/util/List;Z)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;

    move-result-object p2

    .line 100
    invoke-interface {p4}, Ljava/util/Set;->isEmpty()Z

    move-result p3

    if-nez p3, :cond_3

    .line 101
    new-instance p3, Ljava/util/ArrayList;

    invoke-direct {p3}, Ljava/util/ArrayList;-><init>()V

    .line 102
    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    .line 103
    iget-object v4, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_1

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    .line 104
    iget-object v6, v5, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->key:Ljava/lang/String;

    invoke-interface {v3, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 105
    iget-object v6, v5, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->key:Ljava/lang/String;

    invoke-interface {p4, v6}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 106
    invoke-interface {p3, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 108
    :cond_0
    goto :goto_0

    .line 109
    :cond_1
    invoke-interface {v3, p4}, Ljava/util/Set;->containsAll(Ljava/util/Collection;)Z

    move-result p4

    if-eqz p4, :cond_2

    .line 113
    new-instance p4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    invoke-direct {p4, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;-><init>(Ljava/util/List;Ljava/util/List;)V

    move-object p2, p4

    goto :goto_1

    .line 110
    :cond_2
    const-string p0, "rejected Google entries changed before continuation"

    const/16 p1, 0xb

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0

    .line 115
    :cond_3
    :goto_1
    iget-object p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    invoke-interface {p3}, Ljava/util/List;->isEmpty()Z

    move-result p3

    if-eqz p3, :cond_5

    iget-object p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {p3}, Ljava/util/List;->isEmpty()Z

    move-result p3

    if-eqz p3, :cond_5

    .line 116
    new-instance p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    iget p1, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    const/4 p2, 0x0

    invoke-direct {p0, p1, p2, p2, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;-><init>(IIIZ)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 150
    if-eqz v1, :cond_4

    :try_start_2
    invoke-virtual {v1}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V

    :cond_4
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 116
    return-object p0

    .line 118
    :cond_5
    :try_start_3
    iget p3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    iget-object p4, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    .line 119
    invoke-interface {p4}, Ljava/util/List;->size()I

    move-result p4

    sub-int/2addr p3, p4

    iget-object p4, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {p4}, Ljava/util/List;->size()I

    move-result p4

    add-int/2addr p3, p4

    .line 120
    const p4, 0x7a120

    if-gt p3, p4, :cond_b

    .line 124
    iget-object p4, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    invoke-interface {p4}, Ljava/util/List;->isEmpty()Z

    move-result p4

    if-nez p4, :cond_6

    .line 125
    iget-object p4, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    invoke-static {v1, v2, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->rebuildWithoutDeletedEntries(Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Ljava/util/List;)V

    .line 127
    :cond_6
    new-instance p4, Ljava/util/ArrayList;

    invoke-direct {p4}, Ljava/util/ArrayList;-><init>()V

    .line 128
    iget-object v3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_2
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_8

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    .line 129
    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->code:Ljava/lang/String;

    iget-object v6, v4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->phrase:Ljava/lang/String;

    invoke-static {v5, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->newEntry(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    move-result-object v5

    invoke-virtual {v1, v5}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->insertOrUpdate(Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)Z

    move-result v5

    if-nez v5, :cond_7

    .line 130
    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->key:Ljava/lang/String;

    invoke-interface {p4, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 132
    :cond_7
    goto :goto_2

    .line 133
    :cond_8
    invoke-interface {p4}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_a

    .line 136
    invoke-virtual {v1}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->persist()Z

    move-result p4

    if-eqz p4, :cond_9

    .line 140
    sget-object p4, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;->USER_DICTIONARY:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;

    invoke-virtual {p1, p4}, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;->notifyMutableDictionaryDataChanged(Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)V

    .line 142
    invoke-virtual {v1}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V

    .line 143
    nop

    .line 144
    const/4 v1, 0x0

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p0

    .line 145
    invoke-static {v2, p0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->verifyPersisted(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;)V

    .line 146
    new-instance p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    iget-object p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    .line 147
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    const/4 p4, 0x1

    invoke-direct {p0, p3, p1, p2, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;-><init>(IIIZ)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 150
    :try_start_4
    monitor-exit v0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 146
    return-object p0

    .line 137
    :cond_9
    :try_start_5
    const-string p0, "Google user dictionary persistence failed"

    const/4 p1, 0x7

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0

    .line 134
    :cond_a
    new-instance p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;

    invoke-direct {p0, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;-><init>(Ljava/util/List;)V

    throw p0

    .line 121
    :cond_b
    new-instance p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;

    iget p1, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    iget-object p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    .line 122
    invoke-interface {p3}, Ljava/util/List;->size()I

    move-result p3

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    invoke-direct {p0, p1, p3, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;-><init>(III)V

    throw p0

    .line 94
    :cond_c
    const-string p0, "Google user dictionary could not be duplicated"

    const/4 p1, 0x5

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 150
    :catchall_0
    move-exception p0

    if-eqz v1, :cond_d

    :try_start_6
    invoke-virtual {v1}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V

    .line 151
    :cond_d
    throw p0

    .line 152
    :catchall_1
    move-exception p0

    monitor-exit v0
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    throw p0

    .line 89
    :cond_e
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Google changes are required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_4

    :goto_3
    throw p0

    :goto_4
    goto :goto_3
.end method

.method private static canonicalEntry(Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 258
    const/4 v1, 0x0

    if-eqz p0, :cond_5

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->tokens:[Ljava/lang/String;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->tokens:[Ljava/lang/String;

    array-length v0, v0

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->languageIds:[I

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->languageIds:[I

    array-length v0, v0

    iget-object v2, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->tokens:[Ljava/lang/String;

    array-length v2, v2

    if-ne v0, v2, :cond_5

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->value:Ljava/lang/String;

    if-nez v0, :cond_0

    goto :goto_1

    .line 266
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->value:Ljava/lang/String;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizePhrase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_1

    .line 269
    nop

    .line 270
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v2, 0x0

    invoke-virtual {v5, v2, v0}, Ljava/lang/String;->codePointCount(II)I

    move-result v0

    const/4 v3, 0x2

    if-ge v0, v3, :cond_1

    return-object v1

    .line 271
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 272
    nop

    :goto_0
    iget-object v3, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->tokens:[Ljava/lang/String;

    array-length v3, v3

    if-ge v2, v3, :cond_4

    .line 273
    iget-object v3, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->languageIds:[I

    aget v3, v3, v2

    const/16 v4, 0x10

    if-eq v3, v4, :cond_2

    return-object v1

    .line 276
    :cond_2
    :try_start_1
    iget-object v3, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->tokens:[Ljava/lang/String;

    aget-object v3, v3, v2

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizeToken(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_0

    .line 279
    nop

    .line 280
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    if-lez v4, :cond_3

    const/16 v4, 0x20

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 281
    :cond_3
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 272
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 277
    :catch_0
    move-exception v0

    .line 278
    return-object v1

    .line 283
    :cond_4
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 284
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const/16 v1, 0x9

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    iget v6, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->count:I

    move-object v7, p0

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)V

    return-object v2

    .line 267
    :catch_1
    move-exception v0

    .line 268
    return-object v1

    .line 262
    :cond_5
    :goto_1
    return-object v1
.end method

.method private static nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;
    .locals 1

    .line 350
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;-><init>(ILjava/lang/String;)V

    return-object v0
.end method

.method private static newEntry(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;
    .locals 8

    .line 289
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizeCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 290
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizePhrase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 291
    const-string p1, " "

    invoke-virtual {p0, p1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 292
    array-length p0, v1

    new-array v2, p0, [I

    .line 293
    const/4 p1, 0x0

    :goto_0
    if-ge p1, p0, :cond_0

    .line 294
    const/16 v0, 0x10

    aput v0, v2, p1

    .line 293
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 296
    :cond_0
    new-instance v0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    const/4 v6, 0x1

    const/4 v7, 0x0

    const/4 v4, 0x1

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v7}, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;-><init>([Ljava/lang/String;[ILjava/lang/String;IZZI)V

    return-object v0
.end method

.method private static normalizeCode(Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 302
    if-eqz p0, :cond_6

    .line 303
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 304
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_5

    .line 307
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 308
    nop

    .line 309
    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-ge v2, v4, :cond_4

    .line 310
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v4

    .line 311
    invoke-static {v4}, Ljava/lang/Character;->isWhitespace(C)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 312
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_0

    const/4 v3, 0x1

    goto :goto_1

    :cond_0
    const/4 v3, 0x0

    goto :goto_1

    .line 314
    :cond_1
    const/16 v5, 0x61

    if-lt v4, v5, :cond_3

    const/16 v5, 0x7a

    if-gt v4, v5, :cond_3

    .line 317
    if-eqz v3, :cond_2

    const/16 v3, 0x20

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 318
    :cond_2
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 319
    const/4 v3, 0x0

    .line 309
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 315
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google pinyin is not supported"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 322
    :cond_4
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 305
    :cond_5
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google pinyin is empty"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 302
    :cond_6
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google pinyin is required"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_3

    :goto_2
    throw p0

    :goto_3
    goto :goto_2
.end method

.method private static normalizePhrase(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 334
    if-eqz p0, :cond_3

    .line 335
    sget-object v0, Ljava/text/Normalizer$Form;->NFC:Ljava/text/Normalizer$Form;

    invoke-static {p0, v0}, Ljava/text/Normalizer;->normalize(Ljava/lang/CharSequence;Ljava/text/Normalizer$Form;)Ljava/lang/String;

    move-result-object p0

    .line 336
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 339
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 340
    invoke-virtual {p0, v0}, Ljava/lang/String;->codePointAt(I)I

    move-result v1

    .line 341
    invoke-static {v1}, Ljava/lang/Character;->isISOControl(I)Z

    move-result v2

    if-nez v2, :cond_0

    .line 344
    invoke-static {v1}, Ljava/lang/Character;->charCount(I)I

    move-result v1

    add-int/2addr v0, v1

    .line 345
    goto :goto_0

    .line 342
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google phrase contains a control character"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 346
    :cond_1
    return-object p0

    .line 337
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google phrase has invalid whitespace"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 334
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google phrase is required"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method private static normalizeToken(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 326
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->normalizeCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 327
    const/16 v0, 0x20

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-gez v0, :cond_0

    .line 330
    return-object p0

    .line 328
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Google pinyin token contains a separator"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static open(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;
    .locals 2

    .line 194
    new-instance v0, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;

    sget-object v1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;->USER_DICTIONARY:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;

    invoke-direct {v0, p0, p1, v1}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;-><init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)V

    return-object v0
.end method

.method private static prepare(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Ljava/util/List;Z)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;Z)",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 221
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 222
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    .line 223
    if-eqz v1, :cond_1

    .line 224
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->code:Ljava/lang/String;

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->phrase:Ljava/lang/String;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v2, v3, v4, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    .line 225
    iget-object v1, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->key:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_0

    .line 228
    goto :goto_0

    .line 226
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "duplicate Google change"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 223
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Google change is null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 229
    :cond_2
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 230
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 231
    invoke-interface {v0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_9

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    .line 232
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->key:Ljava/lang/String;

    invoke-interface {v3, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 233
    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const-string v6, "Google synchronization preview is stale"

    const/16 v7, 0xb

    if-ne v4, v5, :cond_5

    .line 234
    if-nez v3, :cond_4

    .line 235
    if-eqz p2, :cond_3

    goto :goto_2

    .line 236
    :cond_3
    invoke-static {v7, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0

    .line 240
    :cond_4
    invoke-interface {p1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 242
    :cond_5
    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v4, v5, :cond_8

    .line 243
    if-eqz v3, :cond_7

    .line 244
    if-eqz p2, :cond_6

    goto :goto_2

    .line 245
    :cond_6
    invoke-static {v7, v6}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0

    .line 249
    :cond_7
    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 252
    :cond_8
    :goto_2
    goto :goto_1

    .line 253
    :cond_9
    new-instance p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;

    invoke-direct {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;-><init>(Ljava/util/List;Ljava/util/List;)V

    return-object p0
.end method

.method public static read(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 43
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->requireArguments(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V

    .line 44
    sget-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;

    monitor-enter v0

    .line 45
    :try_start_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->open(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 47
    :try_start_1
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->duplicateDictionary()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 51
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->snapshot(Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    move-result-object p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 53
    :try_start_2
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 51
    return-object p1

    .line 48
    :cond_0
    :try_start_3
    const-string p1, "Google user dictionary could not be duplicated"

    const/4 v1, 0x5

    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p1

    throw p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 53
    :catchall_0
    move-exception p1

    :try_start_4
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V

    .line 54
    throw p1

    .line 55
    :catchall_1
    move-exception p0

    monitor-exit v0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    throw p0
.end method

.method private static rebuildWithoutDeletedEntries(Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Ljava/util/List;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 176
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    .line 177
    invoke-static {v0}, Ljava/util/Collections;->newSetFromMap(Ljava/util/Map;)Ljava/util/Set;

    move-result-object v0

    .line 179
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->access$100(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;)Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 180
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->clearAllEntries()Z

    move-result p2

    const/16 v1, 0x8

    if-eqz p2, :cond_4

    .line 184
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_3

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    .line 185
    invoke-interface {v0, p2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_2

    invoke-virtual {p0, p2}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->insertOrUpdate(Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)Z

    move-result p2

    if-eqz p2, :cond_1

    goto :goto_2

    .line 186
    :cond_1
    const-string p0, "Google user dictionary rebuild failed"

    invoke-static {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0

    .line 189
    :cond_2
    :goto_2
    goto :goto_1

    .line 190
    :cond_3
    return-void

    .line 181
    :cond_4
    const-string p0, "Google user dictionary rebuild could not start"

    invoke-static {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    goto :goto_4

    :goto_3
    throw p0

    :goto_4
    goto :goto_3
.end method

.method public static recover(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;)",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 72
    nop

    .line 73
    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object v0

    .line 72
    const/4 v1, 0x1

    invoke-static {p0, p1, p2, v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->applyInternal(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;ZLjava/util/Set;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    move-result-object p0

    return-object p0
.end method

.method public static recoverKeepingRejected(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;",
            ")",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 80
    if-eqz p3, :cond_0

    .line 81
    new-instance v0, Ljava/util/HashSet;

    iget-object p3, p3, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException;->rejectedKeys:Ljava/util/List;

    invoke-direct {v0, p3}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    const/4 p3, 0x1

    invoke-static {p0, p1, p2, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->applyInternal(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Ljava/util/List;ZLjava/util/Set;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;

    move-result-object p0

    return-object p0

    .line 80
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "rejected entries are required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static requireArguments(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V
    .locals 0

    .line 355
    if-eqz p0, :cond_0

    if-eqz p1, :cond_0

    .line 358
    return-void

    .line 356
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Google dictionary context and factory are required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static snapshot(Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 199
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->getAllEntries()[Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    move-result-object v0

    .line 200
    if-eqz v0, :cond_3

    .line 204
    new-instance v1, Ljava/util/LinkedHashMap;

    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    .line 205
    array-length v2, v0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, v0, v3

    .line 206
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->canonicalEntry(Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    move-result-object v4

    .line 207
    if-nez v4, :cond_0

    goto :goto_1

    .line 208
    :cond_0
    iget-object v5, v4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->key:Ljava/lang/String;

    invoke-interface {v1, v5, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 209
    if-nez v4, :cond_1

    .line 205
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 210
    :cond_1
    const/16 p0, 0xa

    const-string v0, "Google user dictionary has a duplicate normalized key"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    throw p0

    .line 214
    :cond_2
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->getDictionaryCount()I

    move-result p0

    .line 215
    array-length v2, v0

    invoke-static {v2, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    .line 216
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;

    invoke-virtual {v0}, [Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/Object;

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-direct {v2, p0, v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;-><init>(ILjava/util/Map;Ljava/util/List;)V

    return-object v2

    .line 201
    :cond_3
    const/16 p0, 0x9

    const-string v0, "Google user dictionary export failed"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->nativeFailure(ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;

    move-result-object p0

    goto :goto_3

    :goto_2
    throw p0

    :goto_3
    goto :goto_2
.end method

.method private static verifyPersisted(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 157
    new-instance v0, Ljava/util/HashSet;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 158
    iget-object v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->key:Ljava/lang/String;

    invoke-interface {v0, v2}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    goto :goto_0

    .line 159
    :cond_0
    iget-object v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;->key:Ljava/lang/String;

    invoke-interface {v0, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 160
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    iget-object v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    .line 161
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    sub-int/2addr p0, v1

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    add-int/2addr p0, p2

    .line 162
    new-instance p2, Ljava/util/HashSet;

    invoke-direct {p2, v0}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 163
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {p2, v1}, Ljava/util/Set;->removeAll(Ljava/util/Collection;)Z

    .line 164
    new-instance v1, Ljava/util/HashSet;

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 165
    invoke-interface {v1, v0}, Ljava/util/Set;->removeAll(Ljava/util/Collection;)Z

    .line 166
    invoke-interface {p2}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {v1}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 167
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-ne v0, p0, :cond_2

    .line 172
    return-void

    .line 168
    :cond_2
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;

    .line 169
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-direct {v0, p0, p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException;-><init>(IILjava/util/Set;Ljava/util/Set;)V

    goto :goto_3

    :goto_2
    throw v0

    :goto_3
    goto :goto_2
.end method
