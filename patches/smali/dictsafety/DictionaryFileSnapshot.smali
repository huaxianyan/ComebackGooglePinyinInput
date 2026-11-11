.class final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;
.super Ljava/lang/Object;
.source "DictionaryFileSnapshot.java"


# static fields
.field private static final KEEP:I = 0x3

.field private static final PREFIX:Ljava/lang/String; = "file-"

.field private static final SUFFIX:Ljava/lang/String; = ".gz"


# instance fields
.field private final context:Landroid/content/Context;

.field private final kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 0

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 36
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->context:Landroid/content/Context;

    .line 37
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    .line 38
    return-void
.end method

.method private static closeQuietly(Ljava/io/Closeable;)V
    .locals 0

    .line 182
    if-nez p0, :cond_0

    return-void

    .line 184
    :cond_0
    :try_start_0
    invoke-interface {p0}, Ljava/io/Closeable;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 187
    goto :goto_0

    .line 185
    :catch_0
    move-exception p0

    .line 188
    :goto_0
    return-void
.end method

.method private directory()Ljava/io/File;
    .locals 3

    .line 41
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->directoryName:Ljava/lang/String;

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 42
    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    move-result v1

    if-nez v1, :cond_0

    const/4 v0, 0x0

    return-object v0

    .line 43
    :cond_0
    return-object v0
.end method

.method private load(Ljava/io/File;)[B
    .locals 5

    .line 166
    nop

    .line 168
    const/4 v0, 0x0

    :try_start_0
    new-instance v1, Ljava/util/zip/GZIPInputStream;

    new-instance v2, Ljava/io/FileInputStream;

    invoke-direct {v2, p1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v1, v2}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 169
    :try_start_1
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 170
    const/16 v2, 0x2000

    new-array v2, v2, [B

    .line 172
    :goto_0
    invoke-virtual {v1, v2}, Ljava/io/InputStream;->read([B)I

    move-result v3

    const/4 v4, -0x1

    if-eq v3, v4, :cond_0

    const/4 v4, 0x0

    invoke-virtual {p1, v2, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 173
    :cond_0
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 177
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 173
    return-object p1

    .line 177
    :catchall_0
    move-exception p1

    move-object v0, v1

    goto :goto_1

    .line 174
    :catch_0
    move-exception p1

    goto :goto_2

    .line 177
    :catchall_1
    move-exception p1

    :goto_1
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 178
    throw p1

    .line 174
    :catch_1
    move-exception p1

    move-object v1, v0

    .line 175
    :goto_2
    nop

    .line 177
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 175
    return-object v0
.end method

.method private prune()V
    .locals 3

    .line 159
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->snapshots()Ljava/util/List;

    move-result-object v0

    .line 160
    const/4 v1, 0x3

    :goto_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_0

    .line 161
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/io/File;

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    .line 160
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 163
    :cond_0
    return-void
.end method

.method private sizeOf(Ljava/io/File;)J
    .locals 5

    .line 129
    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p1

    .line 130
    const-string v0, "file-"

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x2d

    invoke-virtual {p1, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v1

    .line 131
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    const-wide/16 v3, 0x0

    if-gt v1, v2, :cond_0

    return-wide v3

    .line 133
    :cond_0
    :try_start_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v0

    .line 134
    :catch_0
    move-exception p1

    .line 135
    return-wide v3
.end method

.method private snapshots()Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/io/File;",
            ">;"
        }
    .end annotation

    .line 140
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->directory()Ljava/io/File;

    move-result-object v0

    .line 141
    if-nez v0, :cond_0

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    return-object v0

    .line 142
    :cond_0
    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    .line 143
    if-nez v0, :cond_1

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    return-object v0

    .line 144
    :cond_1
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 145
    array-length v2, v0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_3

    aget-object v4, v0, v3

    .line 146
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, "file-"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, ".gz"

    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    .line 147
    invoke-interface {v1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 145
    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 150
    :cond_3
    new-instance v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot$1;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot$1;-><init>(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;)V

    invoke-static {v1, v0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 155
    return-object v1
.end method


# virtual methods
.method forget()V
    .locals 2

    .line 125
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->snapshots()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    goto :goto_0

    .line 126
    :cond_0
    return-void
.end method

.method keep([B)Z
    .locals 7

    .line 67
    const/4 v0, 0x0

    if-eqz p1, :cond_3

    array-length v1, p1

    if-nez v1, :cond_0

    goto/16 :goto_2

    .line 68
    :cond_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->directory()Ljava/io/File;

    move-result-object v1

    .line 69
    if-nez v1, :cond_1

    return v0

    .line 70
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->snapshots()Ljava/util/List;

    move-result-object v2

    .line 71
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v3

    const/4 v4, 0x1

    if-nez v3, :cond_2

    .line 72
    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/io/File;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->load(Ljava/io/File;)[B

    move-result-object v2

    .line 73
    if-eqz v2, :cond_2

    invoke-static {v2, p1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v2

    if-eqz v2, :cond_2

    return v4

    .line 75
    :cond_2
    new-instance v2, Ljava/io/File;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "file-"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    array-length v5, p1

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "-"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 76
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {v3, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, ".gz"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 77
    nop

    .line 78
    nop

    .line 80
    const/4 v1, 0x0

    :try_start_0
    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 81
    :try_start_1
    new-instance v5, Ljava/util/zip/GZIPOutputStream;

    invoke-direct {v5, v3}, Ljava/util/zip/GZIPOutputStream;-><init>(Ljava/io/OutputStream;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 82
    :try_start_2
    invoke-virtual {v5, p1}, Ljava/util/zip/GZIPOutputStream;->write([B)V

    .line 83
    invoke-virtual {v5}, Ljava/util/zip/GZIPOutputStream;->finish()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 88
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 89
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 90
    nop

    .line 91
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->prune()V

    .line 92
    return v4

    .line 88
    :catchall_0
    move-exception p1

    move-object v1, v5

    goto :goto_1

    .line 84
    :catch_0
    move-exception p1

    move-object v1, v5

    goto :goto_0

    :catch_1
    move-exception p1

    goto :goto_0

    .line 88
    :catchall_1
    move-exception p1

    move-object v3, v1

    goto :goto_1

    .line 84
    :catch_2
    move-exception p1

    move-object v3, v1

    .line 85
    :goto_0
    :try_start_3
    invoke-virtual {v2}, Ljava/io/File;->delete()Z
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 86
    nop

    .line 88
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 89
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 86
    return v0

    .line 88
    :catchall_2
    move-exception p1

    :goto_1
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 89
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 90
    throw p1

    .line 67
    :cond_3
    :goto_2
    return v0
.end method

.method newestAtLeast(J)[B
    .locals 5

    .line 97
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->snapshots()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/io/File;

    .line 98
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->sizeOf(Ljava/io/File;)J

    move-result-wide v2

    .line 99
    cmp-long v4, v2, p1

    if-gez v4, :cond_0

    goto :goto_0

    .line 100
    :cond_0
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->load(Ljava/io/File;)[B

    move-result-object v1

    .line 101
    if-eqz v1, :cond_1

    return-object v1

    .line 102
    :cond_1
    goto :goto_0

    .line 103
    :cond_2
    const/4 p1, 0x0

    return-object p1
.end method

.method read()[B
    .locals 6

    .line 48
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->fileName:Ljava/lang/String;

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 49
    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    return-object v2

    .line 50
    :cond_0
    nop

    .line 52
    :try_start_0
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 53
    :try_start_1
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v4

    long-to-int v0, v4

    invoke-direct {v3, v0}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 54
    const/16 v0, 0x2000

    new-array v0, v0, [B

    .line 56
    :goto_0
    invoke-virtual {v1, v0}, Ljava/io/InputStream;->read([B)I

    move-result v4

    const/4 v5, -0x1

    if-eq v4, v5, :cond_1

    const/4 v5, 0x0

    invoke-virtual {v3, v0, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 57
    :cond_1
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 61
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 57
    return-object v0

    .line 61
    :catchall_0
    move-exception v0

    move-object v2, v1

    goto :goto_1

    .line 58
    :catch_0
    move-exception v0

    goto :goto_2

    .line 61
    :catchall_1
    move-exception v0

    :goto_1
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 62
    throw v0

    .line 58
    :catch_1
    move-exception v0

    move-object v1, v2

    .line 59
    :goto_2
    nop

    .line 61
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 59
    return-object v2
.end method

.method restore([B)Z
    .locals 4

    .line 108
    const/4 v0, 0x0

    if-eqz p1, :cond_1

    array-length v1, p1

    if-nez v1, :cond_0

    goto :goto_2

    .line 109
    :cond_0
    new-instance v1, Ljava/io/File;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->context:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->fileName:Ljava/lang/String;

    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 110
    nop

    .line 112
    const/4 v2, 0x0

    :try_start_0
    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 113
    :try_start_1
    invoke-virtual {v3, p1}, Ljava/io/FileOutputStream;->write([B)V

    .line 114
    invoke-virtual {v3}, Ljava/io/FileOutputStream;->getFD()Ljava/io/FileDescriptor;

    move-result-object p1

    invoke-virtual {p1}, Ljava/io/FileDescriptor;->sync()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 115
    nop

    .line 119
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 115
    const/4 p1, 0x1

    return p1

    .line 119
    :catchall_0
    move-exception p1

    move-object v2, v3

    goto :goto_0

    .line 116
    :catch_0
    move-exception p1

    move-object v2, v3

    goto :goto_1

    .line 119
    :catchall_1
    move-exception p1

    :goto_0
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 120
    throw p1

    .line 116
    :catch_1
    move-exception p1

    .line 117
    :goto_1
    nop

    .line 119
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->closeQuietly(Ljava/io/Closeable;)V

    .line 117
    return v0

    .line 108
    :cond_1
    :goto_2
    return v0
.end method
