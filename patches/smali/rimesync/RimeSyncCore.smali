.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;
.super Ljava/lang/Object;
.source "RimeSyncCore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;
    }
.end annotation


# static fields
.field public static final NEW_ENTRY_DEE:D = 1.0E-8


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static apply(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;)V
    .locals 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 121
    if-eqz p0, :cond_7

    if-eqz p1, :cond_7

    .line 124
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->code:Ljava/lang/String;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizeCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 125
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->phrase:Ljava/lang/String;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizePhrase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 126
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->translationEntries(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/util/Map;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const/16 v4, 0x9

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    .line 127
    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 128
    :goto_0
    const-wide v4, 0x3e45798ee2308c3aL    # 1.0E-8

    if-nez v0, :cond_1

    move-wide v6, v4

    goto :goto_1

    :cond_1
    iget-wide v6, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->dee:D

    .line 129
    :goto_1
    const-wide/16 v8, 0x0

    if-nez v0, :cond_2

    move-wide v10, v8

    goto :goto_2

    :cond_2
    iget-wide v10, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->tick:J

    .line 131
    :goto_2
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v1, v12, :cond_3

    .line 132
    nop

    .line 133
    nop

    .line 134
    const/4 p1, 0x0

    move-wide v5, v4

    move-wide v7, v8

    const/4 v4, 0x0

    goto :goto_4

    .line 135
    :cond_3
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v1, v4, :cond_5

    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v1, v4, :cond_4

    goto :goto_3

    .line 139
    :cond_4
    return-void

    .line 137
    :cond_5
    :goto_3
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->commitValue:I

    move v4, p1

    move-wide v5, v6

    move-wide v7, v10

    .line 141
    :goto_4
    if-eqz v0, :cond_6

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->key()Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v9, " \t"

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_6

    .line 142
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->key()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->remove(Ljava/lang/String;)V

    .line 144
    :cond_6
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    invoke-direct/range {v1 .. v8}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;IDJ)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->put(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;)V

    .line 145
    return-void

    .line 122
    :cond_7
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Rime change is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static merge(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;",
            ">;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;",
            "Ljava/lang/String;",
            ")",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 39
    if-eqz p0, :cond_7

    if-eqz p1, :cond_7

    if-eqz p2, :cond_7

    .line 40
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_7

    .line 43
    nop

    .line 44
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 45
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/4 v1, 0x0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const-string v3, "user_id"

    if-eqz v2, :cond_3

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;

    .line 46
    iget-boolean v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->bridgeOwned:Z

    if-eqz v4, :cond_2

    .line 47
    if-nez v1, :cond_1

    .line 48
    iget-object v1, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object v1

    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 51
    iget-object v1, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    goto :goto_1

    .line 49
    :cond_0
    new-instance p0, Ljava/io/IOException;

    const-string p1, "Bridge snapshot user identity changed"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 47
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "multiple Bridge snapshots were found"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 53
    :cond_2
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 55
    :goto_1
    goto :goto_0

    .line 56
    :cond_3
    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 57
    const/4 p0, 0x1

    const-string v2, "google-pinyin-bridge"

    const-string v4, "rime_version"

    if-nez v1, :cond_4

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_4

    .line 58
    const/4 p1, 0x0

    invoke-interface {v0, p1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;

    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    .line 59
    invoke-virtual {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->mergeFromEmpty(Z)V

    .line 60
    invoke-virtual {v1, v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 61
    invoke-virtual {v1, v3, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2

    .line 62
    :cond_4
    if-nez v1, :cond_5

    .line 63
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;-><init>()V

    .line 64
    const-string v5, "db_name"

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->databaseName:Ljava/lang/String;

    invoke-virtual {v1, v5, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 65
    const-string p1, "db_type"

    const-string v5, "userdb"

    invoke-virtual {v1, p1, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 66
    invoke-virtual {v1, v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 67
    const-string p1, "tick"

    const-string v2, "0"

    invoke-virtual {v1, p1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 68
    invoke-virtual {v1, v3, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 70
    :cond_5
    :goto_2
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_3
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_6

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    invoke-virtual {v1, v0, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->mergeFrom(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Z)V

    goto :goto_3

    .line 71
    :cond_6
    invoke-virtual {v1, v3, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->putMetadata(Ljava/lang/String;Ljava/lang/String;)V

    .line 72
    return-object v1

    .line 41
    :cond_7
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Rime merge identity is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_5

    :goto_4
    throw p0

    :goto_5
    goto :goto_4
.end method

.method private static normalizeCode(Ljava/lang/String;)Ljava/lang/String;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 148
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 149
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_5

    .line 150
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 151
    nop

    .line 152
    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-ge v2, v4, :cond_4

    .line 153
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v4

    .line 154
    invoke-static {v4}, Ljava/lang/Character;->isWhitespace(C)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 155
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_0

    const/4 v3, 0x1

    goto :goto_1

    :cond_0
    const/4 v3, 0x0

    goto :goto_1

    .line 157
    :cond_1
    const/16 v5, 0x61

    if-lt v4, v5, :cond_3

    const/16 v5, 0x7a

    if-gt v4, v5, :cond_3

    .line 160
    if-eqz v3, :cond_2

    const/16 v3, 0x20

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 161
    :cond_2
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 162
    const/4 v3, 0x0

    .line 152
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 158
    :cond_3
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Rime entry code is not supported"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 165
    :cond_4
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 149
    :cond_5
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Rime entry has an empty code"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_3

    :goto_2
    throw p0

    :goto_3
    goto :goto_2
.end method

.method private static normalizePhrase(Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 169
    sget-object v0, Ljava/text/Normalizer$Form;->NFC:Ljava/text/Normalizer$Form;

    invoke-static {p0, v0}, Ljava/text/Normalizer;->normalize(Ljava/lang/CharSequence;Ljava/text/Normalizer$Form;)Ljava/lang/String;

    move-result-object p0

    .line 170
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 173
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 174
    invoke-virtual {p0, v0}, Ljava/lang/String;->codePointAt(I)I

    move-result v1

    .line 175
    invoke-static {v1}, Ljava/lang/Character;->isISOControl(I)Z

    move-result v2

    if-nez v2, :cond_0

    .line 178
    invoke-static {v1}, Ljava/lang/Character;->charCount(I)I

    move-result v1

    add-int/2addr v0, v1

    .line 179
    goto :goto_0

    .line 176
    :cond_0
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Rime phrase contains a control character"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 180
    :cond_1
    return-object p0

    .line 171
    :cond_2
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Rime phrase is empty or has surrounding whitespace"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method public static recoverBridgeUserId(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 22
    if-eqz p0, :cond_1

    .line 23
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object v0

    const-string v1, "rime_version"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    const-string v1, "google-pinyin-bridge"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 26
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object p0

    const-string v0, "user_id"

    invoke-interface {p0, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    .line 28
    if-eqz p0, :cond_0

    :try_start_0
    invoke-static {p0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 33
    nop

    .line 34
    return-object p0

    .line 29
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "non-canonical UUID"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    .line 31
    :catch_0
    move-exception p0

    .line 32
    new-instance v0, Ljava/io/IOException;

    const-string v1, "existing Bridge snapshot identity is invalid"

    invoke-direct {v0, v1, p0}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v0

    .line 24
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string v0, "existing device snapshot is not a Google Pinyin Bridge"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static translationEntries(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/util/Map;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 78
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 79
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries()Ljava/util/Map;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 80
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizePhrase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 81
    const/4 v3, 0x0

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->codePointCount(II)I

    move-result v3

    const/4 v4, 0x2

    if-ge v3, v4, :cond_0

    goto :goto_0

    .line 82
    :cond_0
    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizeCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 83
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/16 v5, 0x9

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 84
    new-instance v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    invoke-direct {v5, v4, v3, v2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;)V

    invoke-interface {v0, v4, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    .line 86
    if-nez v1, :cond_1

    .line 87
    goto :goto_0

    .line 86
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string v0, "duplicate normalized Rime entry"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 88
    :cond_2
    return-object v0
.end method

.method static translationEntriesForPreview(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/util/Map;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 94
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 95
    nop

    .line 96
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->takeEntriesForPreview()Ljava/util/Map;

    move-result-object p0

    .line 97
    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    .line 99
    :goto_0
    :try_start_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 100
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 101
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizePhrase(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 102
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v4

    const/4 v5, 0x0

    invoke-virtual {v3, v5, v4}, Ljava/lang/String;->codePointCount(II)I

    move-result v4

    const/4 v5, 0x2

    if-lt v4, v5, :cond_1

    .line 103
    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizeCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 104
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/16 v5, 0x9

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 105
    new-instance v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    invoke-direct {v4, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;-><init>(I)V

    invoke-interface {v0, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    .line 107
    if-nez v2, :cond_0

    goto :goto_1

    .line 108
    :cond_0
    new-instance v0, Ljava/io/IOException;

    const-string v1, "duplicate normalized Rime entry"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 111
    :cond_1
    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->remove()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 112
    goto :goto_0

    .line 114
    :cond_2
    invoke-interface {p0}, Ljava/util/Map;->clear()V

    .line 115
    nop

    .line 116
    return-object v0

    .line 114
    :catchall_0
    move-exception v0

    invoke-interface {p0}, Ljava/util/Map;->clear()V

    .line 115
    goto :goto_3

    :goto_2
    throw v0

    :goto_3
    goto :goto_2
.end method
