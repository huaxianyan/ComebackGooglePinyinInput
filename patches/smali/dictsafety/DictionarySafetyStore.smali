.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;
.super Ljava/lang/Object;
.source "DictionarySafetyStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;
    }
.end annotation


# static fields
.field private static final DIRECTORY:Ljava/lang/String; = "dictionary-safety"

.field static final KEY_KNOWN_COUNT:Ljava/lang/String; = "known_entry_count"

.field static final KEY_KNOWN_FILE_SIZE:Ljava/lang/String; = "known_dictionary_file_size"

.field static final KEY_LAST_CHECK:Ljava/lang/String; = "last_check_at"

.field static final KEY_LAST_REPAIR:Ljava/lang/String; = "last_repair_at"

.field static final KEY_NOTE:Ljava/lang/String; = "last_note"

.field static final KEY_STRIKES:Ljava/lang/String; = "collapsed_strikes"

.field private static final PARTIAL_SUFFIX:Ljava/lang/String; = ".partial"

.field private static final PREFIX:Ljava/lang/String; = "snapshot-"

.field static final PREFS:Ljava/lang/String; = "dictionary_safety"

.field private static final RETAINED_SNAPSHOTS:I = 0x3

.field private static final SUFFIX:Ljava/lang/String; = ".txt.gz"

.field private static final UTF_8:Ljava/nio/charset/Charset;


# instance fields
.field private final context:Landroid/content/Context;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 52
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    .line 56
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 57
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->context:Landroid/content/Context;

    .line 58
    return-void
.end method

.method private static delete(Ljava/io/File;)V
    .locals 1

    .line 186
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    .line 187
    :cond_0
    return-void
.end method

.method private directory()Ljava/io/File;
    .locals 3

    .line 65
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "dictionary-safety"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 66
    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    move-result v1

    if-nez v1, :cond_0

    const/4 v0, 0x0

    return-object v0

    .line 67
    :cond_0
    return-object v0
.end method

.method public static fingerprint(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)J
    .locals 3

    .line 143
    new-instance v0, Ljava/util/zip/CRC32;

    invoke-direct {v0}, Ljava/util/zip/CRC32;-><init>()V

    .line 144
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->totalEntryCount:I

    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    invoke-static {v1, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->serialize(ILjava/util/List;)Ljava/lang/String;

    move-result-object p0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->UTF_8:Ljava/nio/charset/Charset;

    .line 145
    invoke-virtual {p0, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    .line 146
    const/4 v1, 0x0

    array-length v2, p0

    invoke-virtual {v0, p0, v1, v2}, Ljava/util/zip/CRC32;->update([BII)V

    .line 147
    invoke-virtual {v0}, Ljava/util/zip/CRC32;->getValue()J

    move-result-wide v0

    return-wide v0
.end method

.method public static mainDictionarySize(Landroid/content/Context;)J
    .locals 2

    .line 43
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    const-string v1, "user_dict_3_3"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 44
    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result p0

    if-eqz p0, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v0

    goto :goto_0

    :cond_0
    const-wide/16 v0, 0x0

    :goto_0
    return-wide v0
.end method

.method private static read(Ljava/io/File;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;
    .locals 6

    .line 161
    nop

    .line 163
    const/4 v0, 0x0

    :try_start_0
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_3
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 164
    :try_start_1
    new-instance p0, Ljava/util/zip/GZIPInputStream;

    invoke-direct {p0, v1}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V

    .line 165
    new-instance v2, Ljava/io/InputStreamReader;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v2, p0, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V

    .line 166
    new-instance p0, Ljava/lang/StringBuilder;

    const/high16 v3, 0x10000

    invoke-direct {p0, v3}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 167
    const/16 v3, 0x2000

    new-array v3, v3, [C

    .line 169
    :goto_0
    invoke-virtual {v2, v3}, Ljava/io/Reader;->read([C)I

    move-result v4

    const/4 v5, -0x1

    if-eq v4, v5, :cond_0

    const/4 v5, 0x0

    invoke-virtual {p0, v3, v5, v4}, Ljava/lang/StringBuilder;->append([CII)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 170
    :cond_0
    invoke-virtual {v2}, Ljava/io/Reader;->close()V

    .line 171
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->parse(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object p0
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 175
    nop

    .line 177
    :try_start_2
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    .line 180
    goto :goto_1

    .line 178
    :catch_0
    move-exception v0

    .line 171
    :goto_1
    return-object p0

    .line 175
    :catchall_0
    move-exception p0

    move-object v0, v1

    goto :goto_2

    .line 172
    :catch_1
    move-exception p0

    goto :goto_4

    .line 175
    :catchall_1
    move-exception p0

    :goto_2
    if-eqz v0, :cond_1

    .line 177
    :try_start_3
    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_2

    .line 180
    goto :goto_3

    .line 178
    :catch_2
    move-exception v0

    .line 182
    :cond_1
    :goto_3
    throw p0

    .line 172
    :catch_3
    move-exception p0

    move-object v1, v0

    .line 173
    :goto_4
    nop

    .line 175
    if-eqz v1, :cond_2

    .line 177
    :try_start_4
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_4

    .line 180
    goto :goto_5

    .line 178
    :catch_4
    move-exception p0

    .line 173
    :cond_2
    :goto_5
    return-object v0
.end method

.method private static writeCompressed(Ljava/io/File;Ljava/lang/String;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 151
    new-instance v0, Ljava/io/OutputStreamWriter;

    new-instance v1, Ljava/util/zip/GZIPOutputStream;

    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, p0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v1, v2}, Ljava/util/zip/GZIPOutputStream;-><init>(Ljava/io/OutputStream;)V

    sget-object p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, p0}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;Ljava/nio/charset/Charset;)V

    .line 154
    :try_start_0
    invoke-virtual {v0, p1}, Ljava/io/Writer;->write(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 156
    invoke-virtual {v0}, Ljava/io/Writer;->close()V

    .line 157
    nop

    .line 158
    return-void

    .line 156
    :catchall_0
    move-exception p0

    invoke-virtual {v0}, Ljava/io/Writer;->close()V

    .line 157
    throw p0
.end method


# virtual methods
.method public newestRepairable(I)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;
    .locals 3

    .line 93
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->snapshots()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    .line 94
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->totalEntryCount:I

    invoke-static {v2, p1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyPolicy;->canRepairWith(II)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 96
    return-object v1

    .line 98
    :cond_0
    goto :goto_0

    .line 99
    :cond_1
    const/4 p1, 0x0

    return-object p1
.end method

.method public preferences()Landroid/content/SharedPreferences;
    .locals 3

    .line 61
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->context:Landroid/content/Context;

    const-string v1, "dictionary_safety"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    return-object v0
.end method

.method public rotate(Z)V
    .locals 3

    .line 131
    if-nez p1, :cond_0

    return-void

    .line 132
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->snapshots()Ljava/util/List;

    move-result-object p1

    .line 133
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x3

    if-gt v0, v1, :cond_1

    return-void

    .line 134
    :cond_1
    nop

    :goto_0
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 135
    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    .line 136
    const/4 v2, 0x0

    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    if-ne v0, v2, :cond_2

    goto :goto_1

    .line 137
    :cond_2
    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->file:Ljava/io/File;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->delete(Ljava/io/File;)V

    .line 134
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 139
    :cond_3
    return-void
.end method

.method public snapshots()Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;",
            ">;"
        }
    .end annotation

    .line 72
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->directory()Ljava/io/File;

    move-result-object v0

    .line 73
    if-nez v0, :cond_0

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    return-object v0

    .line 74
    :cond_0
    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    .line 75
    if-nez v0, :cond_1

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    return-object v0

    .line 76
    :cond_1
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 77
    array-length v2, v0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_5

    aget-object v4, v0, v3

    .line 78
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, "snapshot-"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_4

    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, ".txt.gz"

    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_2

    goto :goto_1

    .line 79
    :cond_2
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->read(Ljava/io/File;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object v5

    .line 80
    if-nez v5, :cond_3

    goto :goto_1

    .line 81
    :cond_3
    new-instance v6, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    invoke-direct {v6, v4, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;-><init>(Ljava/io/File;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)V

    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 77
    :cond_4
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 83
    :cond_5
    new-instance v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$1;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$1;-><init>(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;)V

    invoke-static {v1, v0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 88
    return-object v1
.end method

.method public write(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;
    .locals 7

    .line 104
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->directory()Ljava/io/File;

    move-result-object v0

    .line 105
    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 106
    :cond_0
    iget v2, p1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->totalEntryCount:I

    iget-object v3, p1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    invoke-static {v2, v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->serialize(ILjava/util/List;)Ljava/lang/String;

    move-result-object v2

    .line 108
    new-instance v3, Ljava/io/File;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "snapshot-"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 109
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {v4, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ".txt.gz"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v0, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 110
    new-instance v4, Ljava/io/File;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ".partial"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v0, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 112
    :try_start_0
    invoke-static {v4, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->writeCompressed(Ljava/io/File;Ljava/lang/String;)V

    .line 113
    invoke-virtual {v4, v3}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 114
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->delete(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 115
    return-object v1

    .line 120
    :cond_1
    nop

    .line 121
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->read(Ljava/io/File;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    move-result-object v0

    .line 122
    if-eqz v0, :cond_3

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;->entries:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    if-eq v2, p1, :cond_2

    goto :goto_0

    .line 126
    :cond_2
    new-instance p1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;

    invoke-direct {p1, v3, v0}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;-><init>(Ljava/io/File;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)V

    return-object p1

    .line 123
    :cond_3
    :goto_0
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->delete(Ljava/io/File;)V

    .line 124
    return-object v1

    .line 117
    :catch_0
    move-exception p1

    .line 118
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->delete(Ljava/io/File;)V

    .line 119
    return-object v1
.end method
