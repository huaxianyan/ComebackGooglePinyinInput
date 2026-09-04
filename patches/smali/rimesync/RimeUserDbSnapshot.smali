.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
.super Ljava/lang/Object;
.source "RimeUserDbSnapshot.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;
    }
.end annotation


# static fields
.field public static final DESCRIPTION:Ljava/lang/String; = "# Rime user dictionary"


# instance fields
.field private final entries:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;",
            ">;"
        }
    .end annotation
.end field

.field private final metadata:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 18
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    .line 19
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    return-void
.end method

.method static synthetic access$200(ILjava/lang/String;)Ljava/io/IOException;
    .locals 0

    .line 15
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->formatError(ILjava/lang/String;)Ljava/io/IOException;

    move-result-object p0

    return-object p0
.end method

.method private static empty(Ljava/lang/String;)Z
    .locals 0

    .line 158
    if-eqz p0, :cond_1

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    if-nez p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private static formatError(ILjava/lang/String;)Ljava/io/IOException;
    .locals 3

    .line 176
    new-instance v0, Ljava/io/IOException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Rime snapshot line "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v1, ": "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    return-object v0
.end method

.method private static magnitude(I)J
    .locals 2

    .line 172
    const/high16 v0, -0x80000000

    if-ne p0, v0, :cond_0

    const-wide v0, 0x80000000L

    goto :goto_0

    :cond_0
    int-to-long v0, p0

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(J)J

    move-result-wide v0

    :goto_0
    return-wide v0
.end method

.method public static read(Ljava/io/Reader;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 22
    instance-of v0, p0, Ljava/io/BufferedReader;

    if-eqz v0, :cond_0

    .line 23
    check-cast p0, Ljava/io/BufferedReader;

    goto :goto_0

    :cond_0
    new-instance v0, Ljava/io/BufferedReader;

    invoke-direct {v0, p0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    move-object p0, v0

    .line 24
    :goto_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;-><init>()V

    .line 26
    nop

    .line 27
    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    .line 28
    :cond_1
    :goto_1
    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_8

    .line 29
    const/4 v5, 0x1

    add-int/2addr v3, v5

    .line 30
    if-ne v3, v5, :cond_2

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6

    if-lez v6, :cond_2

    invoke-virtual {v4, v1}, Ljava/lang/String;->charAt(I)C

    move-result v6

    const v7, 0xfeff

    if-ne v6, v7, :cond_2

    .line 31
    invoke-virtual {v4, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    .line 33
    :cond_2
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6

    if-nez v6, :cond_3

    goto :goto_1

    .line 34
    :cond_3
    const-string v6, "#@/"

    invoke-virtual {v4, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    const/4 v7, 0x3

    if-eqz v6, :cond_5

    .line 35
    const/16 v6, 0x9

    invoke-virtual {v4, v6}, Ljava/lang/String;->indexOf(I)I

    move-result v6

    .line 36
    if-le v6, v7, :cond_4

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v8

    sub-int/2addr v8, v5

    if-eq v6, v8, :cond_4

    .line 39
    iget-object v5, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    invoke-virtual {v4, v7, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v7

    add-int/lit8 v6, v6, 0x1

    invoke-virtual {v4, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v5, v7, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 40
    goto :goto_1

    .line 37
    :cond_4
    const-string p0, "invalid metadata"

    invoke-static {v3, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->formatError(ILjava/lang/String;)Ljava/io/IOException;

    move-result-object p0

    throw p0

    .line 40
    :cond_5
    invoke-virtual {v4, v1}, Ljava/lang/String;->charAt(I)C

    move-result v6

    const/16 v8, 0x23

    if-ne v6, v8, :cond_6

    .line 41
    const-string v6, "# Rime user dictionary"

    invoke-virtual {v6, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    const/4 v2, 0x1

    goto :goto_1

    .line 43
    :cond_6
    const-string v6, "\\t"

    const/4 v8, -0x1

    invoke-virtual {v4, v6, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v4

    .line 44
    array-length v6, v4

    if-ne v6, v7, :cond_7

    aget-object v6, v4, v1

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v6

    if-eqz v6, :cond_7

    aget-object v6, v4, v5

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v6

    if-eqz v6, :cond_7

    .line 47
    aget-object v6, v4, v1

    aget-object v5, v4, v5

    const/4 v7, 0x2

    aget-object v4, v4, v7

    invoke-static {v6, v5, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->access$000(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    move-result-object v4

    .line 48
    iget-object v5, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->key()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v5, v6, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 49
    goto/16 :goto_1

    .line 45
    :cond_7
    const-string p0, "invalid entry columns"

    invoke-static {v3, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->formatError(ILjava/lang/String;)Ljava/io/IOException;

    move-result-object p0

    throw p0

    .line 51
    :cond_8
    if-eqz v2, :cond_9

    .line 52
    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->validateMetadata()V

    .line 53
    return-object v0

    .line 51
    :cond_9
    new-instance p0, Ljava/io/IOException;

    const-string v0, "missing Rime user dictionary header"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_3

    :goto_2
    throw p0

    :goto_3
    goto :goto_2
.end method

.method private validateMetadata()V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 148
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v1, "db_type"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    const-string v1, "userdb"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 151
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v1, "db_name"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->empty(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v1, "user_id"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->empty(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 154
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->tick()J

    .line 155
    return-void

    .line 152
    :cond_0
    new-instance v0, Ljava/io/IOException;

    const-string v1, "missing Rime snapshot identity"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 149
    :cond_1
    new-instance v0, Ljava/io/IOException;

    const-string v1, "snapshot is not a Rime userdb"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private writeMetadata(Ljava/io/BufferedWriter;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 162
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    invoke-interface {v0, p2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 163
    if-eqz v0, :cond_0

    .line 164
    const-string v1, "#@/"

    invoke-virtual {p1, v1}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 165
    invoke-virtual {p1, p2}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 166
    const/16 p2, 0x9

    invoke-virtual {p1, p2}, Ljava/io/BufferedWriter;->write(I)V

    .line 167
    invoke-virtual {p1, v0}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 168
    invoke-virtual {p1}, Ljava/io/BufferedWriter;->newLine()V

    .line 169
    return-void

    .line 163
    :cond_0
    new-instance p1, Ljava/io/IOException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "missing Rime metadata: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method public dbName()Ljava/lang/String;
    .locals 2

    .line 113
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v1, "db_name"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    return-object v0
.end method

.method public entries()Ljava/util/Map;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;",
            ">;"
        }
    .end annotation

    .line 129
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-static {v0}, Ljava/util/Collections;->unmodifiableMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    return-object v0
.end method

.method public mergeFrom(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Z)V
    .locals 22
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 83
    move-object/from16 v0, p0

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->dbName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual/range {p1 .. p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->dbName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 86
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->tick()J

    move-result-wide v1

    .line 87
    invoke-virtual/range {p1 .. p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->tick()J

    move-result-wide v3

    .line 88
    invoke-static {v1, v2, v3, v4}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v11

    .line 89
    move-object/from16 v5, p1

    iget-object v5, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-interface {v5}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v13

    :goto_0
    invoke-interface {v13}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_3

    invoke-interface {v13}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 90
    invoke-static {v5, v3, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;J)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    move-result-object v6

    .line 91
    iget-object v7, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->key()Ljava/lang/String;

    move-result-object v8

    invoke-interface {v7, v8}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 92
    if-nez v7, :cond_0

    new-instance v14, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    iget-object v15, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    iget-object v7, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    const-wide/16 v18, 0x0

    const-wide/16 v20, 0x0

    const/16 v17, 0x0

    move-object/from16 v16, v7

    invoke-direct/range {v14 .. v21}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;IDJ)V

    move-object v7, v14

    .line 93
    :cond_0
    invoke-static {v7, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;J)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    move-result-object v7

    .line 94
    iget v8, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    .line 95
    iget v9, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    invoke-static {v9}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->magnitude(I)J

    move-result-wide v9

    .line 96
    iget v14, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    invoke-static {v14}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->magnitude(I)J

    move-result-wide v14

    .line 97
    cmp-long v16, v9, v14

    if-ltz v16, :cond_1

    if-eqz p2, :cond_2

    cmp-long v16, v9, v14

    if-nez v16, :cond_2

    iget v9, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    if-gez v9, :cond_2

    iget v9, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    if-ltz v9, :cond_2

    .line 100
    :cond_1
    iget v8, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    .line 102
    :cond_2
    iget-object v14, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->key()Ljava/lang/String;

    move-result-object v15

    new-instance v9, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    iget-object v10, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    iget-object v5, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    move-wide/from16 v16, v1

    iget-wide v1, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->dee:D

    iget-wide v6, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->dee:D

    .line 106
    invoke-static {v1, v2, v6, v7}, Ljava/lang/Math;->max(DD)D

    move-result-wide v1

    move-object v7, v5

    move-object v5, v9

    move-object v6, v10

    move-wide v9, v1

    invoke-direct/range {v5 .. v12}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;IDJ)V

    .line 102
    invoke-interface {v14, v15, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 108
    move-wide/from16 v1, v16

    goto :goto_0

    .line 109
    :cond_3
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v2, "tick"

    invoke-static {v11, v12}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 110
    return-void

    .line 84
    :cond_4
    new-instance v1, Ljava/io/IOException;

    const-string v2, "Rime dictionary name mismatch"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_2

    :goto_1
    throw v1

    :goto_2
    goto :goto_1
.end method

.method public metadata()Ljava/util/Map;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 125
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    invoke-static {v0}, Ljava/util/Collections;->unmodifiableMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    return-object v0
.end method

.method public put(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;)V
    .locals 2

    .line 140
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->key()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 141
    return-void
.end method

.method public putMetadata(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    .line 133
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_0

    .line 136
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    invoke-interface {v0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 137
    return-void

    .line 134
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "metadata must not be empty"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method remove(Ljava/lang/String;)V
    .locals 1

    .line 144
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 145
    return-void
.end method

.method public tick()J
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 118
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v1, "tick"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v0

    .line 119
    :catch_0
    move-exception v0

    .line 120
    new-instance v1, Ljava/io/IOException;

    const-string v2, "invalid Rime tick"

    invoke-direct {v1, v2, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method public write(Ljava/io/Writer;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 57
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->validateMetadata()V

    .line 58
    instance-of v0, p1, Ljava/io/BufferedWriter;

    if-eqz v0, :cond_0

    .line 59
    check-cast p1, Ljava/io/BufferedWriter;

    goto :goto_0

    :cond_0
    new-instance v0, Ljava/io/BufferedWriter;

    invoke-direct {v0, p1}, Ljava/io/BufferedWriter;-><init>(Ljava/io/Writer;)V

    move-object p1, v0

    .line 60
    :goto_0
    const-string v0, "# Rime user dictionary"

    invoke-virtual {p1, v0}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 61
    invoke-virtual {p1}, Ljava/io/BufferedWriter;->newLine()V

    .line 62
    const-string v0, "db_name"

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->writeMetadata(Ljava/io/BufferedWriter;Ljava/lang/String;)V

    .line 63
    const-string v0, "db_type"

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->writeMetadata(Ljava/io/BufferedWriter;Ljava/lang/String;)V

    .line 64
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata:Ljava/util/Map;

    const-string v1, "rime_version"

    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-direct {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->writeMetadata(Ljava/io/BufferedWriter;Ljava/lang/String;)V

    .line 65
    :cond_1
    const-string v0, "tick"

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->writeMetadata(Ljava/io/BufferedWriter;Ljava/lang/String;)V

    .line 66
    const-string v0, "user_id"

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->writeMetadata(Ljava/io/BufferedWriter;Ljava/lang/String;)V

    .line 67
    new-instance v0, Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 68
    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 69
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 70
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->entries:Ljava/util/Map;

    invoke-interface {v2, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 71
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 72
    const/16 v2, 0x9

    invoke-virtual {p1, v2}, Ljava/io/BufferedWriter;->write(I)V

    .line 73
    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    invoke-virtual {p1, v3}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 74
    invoke-virtual {p1, v2}, Ljava/io/BufferedWriter;->write(I)V

    .line 75
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->pack()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 76
    invoke-virtual {p1}, Ljava/io/BufferedWriter;->newLine()V

    .line 77
    goto :goto_1

    .line 78
    :cond_2
    invoke-virtual {p1}, Ljava/io/BufferedWriter;->flush()V

    .line 79
    return-void
.end method
