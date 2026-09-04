.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;
.super Ljava/lang/Object;
.source "RimeSyncSafStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;
    }
.end annotation


# static fields
.field private static final MIME_DIRECTORY:Ljava/lang/String; = "vnd.android.document/directory"

.field private static final UTF_8:Ljava/nio/charset/Charset;


# instance fields
.field private final configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

.field private final context:Landroid/content/Context;

.field private final resolver:Landroid/content/ContentResolver;

.field private final rootDocumentId:Ljava/lang/String;

.field private final rootTree:Landroid/net/Uri;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 26
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 37
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_2

    .line 40
    const-string v0, "Rime synchronization root is invalid"

    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    if-eqz p3, :cond_1

    .line 41
    invoke-static {p2}, Landroid/provider/DocumentsContract;->isTreeUri(Landroid/net/Uri;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 44
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->context:Landroid/content/Context;

    .line 45
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->context:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    .line 46
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    .line 47
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 49
    :try_start_0
    invoke-static {p2}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 52
    nop

    .line 53
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->hasPersistedReadWriteAccess()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 56
    return-void

    .line 54
    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Rime synchronization root permission is unavailable"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 50
    :catch_0
    move-exception p1

    .line 51
    new-instance p2, Ljava/io/IOException;

    invoke-direct {p2, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2

    .line 42
    :cond_1
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 38
    :cond_2
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Rime synchronization requires Android 5.0 or later"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private createFile(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 227
    const-string v0, "Bridge temporary snapshot was not created"

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    const-string v2, "text/plain"

    invoke-static {v1, p1, v2, p2}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 229
    if-eqz p1, :cond_0

    .line 230
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 231
    return-object p1

    .line 229
    :cond_0
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 232
    :catch_0
    move-exception p1

    .line 233
    new-instance p2, Ljava/io/IOException;

    invoke-direct {p2, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2
.end method

.method private delete(Landroid/net/Uri;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 250
    const-string v0, "Rime snapshot cleanup failed"

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-static {v1, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 255
    nop

    .line 256
    return-void

    .line 251
    :cond_0
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 253
    :catch_0
    move-exception p1

    .line 254
    new-instance v1, Ljava/io/IOException;

    invoke-direct {v1, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method private deleteQuietly(Landroid/net/Uri;)V
    .locals 1

    .line 260
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-static {v0, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 262
    goto :goto_0

    .line 261
    :catch_0
    move-exception p1

    .line 263
    :goto_0
    return-void
.end method

.method private documentUri(Ljava/lang/String;)Landroid/net/Uri;
    .locals 1

    .line 311
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    invoke-static {v0, p1}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    return-object p1
.end method

.method private ensureBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 173
    const-string v0, "Bridge device directory could not be created"

    const-string v1, "vnd.android.document/directory"

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v2

    .line 174
    if-eqz v2, :cond_0

    return-object v2

    .line 175
    :cond_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    .line 178
    :try_start_0
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-static {v3, v2, v1, v4}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 182
    nop

    .line 183
    if-eqz v2, :cond_2

    .line 184
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-direct {p0, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 185
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-direct {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 187
    if-eqz v0, :cond_1

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 190
    return-object v0

    .line 188
    :cond_1
    new-instance v0, Ljava/io/IOException;

    const-string v1, "created Bridge device directory is not a direct child"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 183
    :cond_2
    new-instance v1, Ljava/io/IOException;

    invoke-direct {v1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 180
    :catch_0
    move-exception v1

    .line 181
    new-instance v2, Ljava/io/IOException;

    invoke-direct {v2, v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v2
.end method

.method private findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 267
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listChildren(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object p1

    return-object p1
.end method

.method private hasPersistedReadWriteAccess()Z
    .locals 4

    .line 332
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-virtual {v0}, Landroid/content/ContentResolver;->getPersistedUriPermissions()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/UriPermission;

    .line 333
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    invoke-virtual {v1}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v1}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 334
    invoke-virtual {v1}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v1, :cond_0

    const/4 v0, 0x1

    return v0

    .line 335
    :cond_0
    goto :goto_0

    .line 337
    :cond_1
    goto :goto_1

    .line 336
    :catch_0
    move-exception v0

    .line 338
    :goto_1
    const/4 v0, 0x0

    return v0
.end method

.method private listChildren(Ljava/lang/String;)Ljava/util/List;
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 282
    const-string v1, "Rime directory could not be listed"

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 283
    nop

    .line 285
    const/4 v2, 0x0

    :try_start_0
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    invoke-static {v3, p1}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    .line 287
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    const/4 p1, 0x3

    new-array v6, p1, [Ljava/lang/String;

    const-string p1, "document_id"

    const/4 v3, 0x0

    aput-object p1, v6, v3

    const-string p1, "_display_name"

    const/4 v10, 0x1

    aput-object p1, v6, v10

    const-string p1, "mime_type"

    const/4 v11, 0x2

    aput-object p1, v6, v11

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v7, 0x0

    invoke-virtual/range {v4 .. v9}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2

    .line 292
    if-eqz v2, :cond_3

    .line 293
    :goto_0
    invoke-interface {v2}, Landroid/database/Cursor;->moveToNext()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 294
    invoke-interface {v2, v3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    .line 295
    invoke-interface {v2, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 296
    invoke-interface {v2, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 297
    if-eqz p1, :cond_0

    if-eqz v4, :cond_0

    if-eqz v5, :cond_0

    .line 300
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    invoke-direct {v6, p1, v4, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 301
    goto :goto_0

    .line 298
    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string v0, "Rime directory contains incomplete metadata"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 305
    :cond_1
    if-eqz v2, :cond_2

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 307
    :cond_2
    return-object v0

    .line 292
    :cond_3
    :try_start_1
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 305
    :catchall_0
    move-exception v0

    move-object p1, v0

    goto :goto_1

    .line 302
    :catch_0
    move-exception v0

    move-object p1, v0

    .line 303
    :try_start_2
    new-instance v0, Ljava/io/IOException;

    invoke-direct {v0, v1, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 305
    :goto_1
    if-eqz v2, :cond_4

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 306
    :cond_4
    goto :goto_3

    :goto_2
    throw p1

    :goto_3
    goto :goto_2
.end method

.method private previousName()Ljava/lang/String;
    .locals 2

    .line 342
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ".bridge-previous.txt"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private recoverPublishedFile(Ljava/lang/String;)V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 194
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listChildren(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    .line 195
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 196
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->previousName()Ljava/lang/String;

    move-result-object v1

    invoke-static {p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v1

    .line 197
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    .line 198
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "."

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v5, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ".bridge-"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    .line 199
    const-string v4, ".partial"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_0

    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    .line 200
    const-string v4, ".partial.txt"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 201
    :cond_0
    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->deleteQuietly(Landroid/net/Uri;)V

    .line 203
    :cond_1
    goto :goto_0

    .line 204
    :cond_2
    if-nez v0, :cond_3

    if-eqz v1, :cond_3

    .line 205
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    goto :goto_1

    .line 206
    :cond_3
    if-eqz v0, :cond_4

    if-eqz v1, :cond_4

    .line 207
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->delete(Landroid/net/Uri;)V

    .line 209
    :cond_4
    :goto_1
    return-void
.end method

.method private rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 239
    const-string v0, "Rime snapshot rename failed"

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-static {v1, p1, p2}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 240
    if-eqz p1, :cond_0

    .line 241
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 242
    return-object p1

    .line 240
    :cond_0
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 243
    :catch_0
    move-exception p1

    .line 244
    new-instance p2, Ljava/io/IOException;

    invoke-direct {p2, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2
.end method

.method private static uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 272
    nop

    .line 273
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/4 v0, 0x0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    .line 274
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    goto :goto_0

    .line 275
    :cond_0
    if-nez v0, :cond_1

    .line 276
    nop

    .line 277
    move-object v0, v1

    goto :goto_0

    .line 275
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "duplicate Rime document name"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 278
    :cond_2
    return-object v0
.end method

.method private verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 315
    nop

    .line 317
    const/4 v1, 0x0

    :try_start_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    const/4 v0, 0x1

    new-array v4, v0, [Ljava/lang/String;

    const-string v0, "_display_name"

    const/4 v8, 0x0

    aput-object v0, v4, v8

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v5, 0x0

    move-object v3, p1

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 320
    if-eqz v1, :cond_1

    invoke-interface {v1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-interface {v1, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p1, :cond_1

    .line 326
    if-eqz v1, :cond_0

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 328
    :cond_0
    return-void

    .line 321
    :cond_1
    :try_start_1
    new-instance p1, Ljava/io/IOException;

    const-string p2, "document provider changed the requested Rime name"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 326
    :catchall_0
    move-exception v0

    move-object p1, v0

    goto :goto_0

    .line 323
    :catch_0
    move-exception v0

    move-object p1, v0

    .line 324
    :try_start_2
    new-instance p2, Ljava/io/IOException;

    const-string v0, "Rime document identity could not be verified"

    invoke-direct {p2, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 326
    :goto_0
    if-eqz v1, :cond_2

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 327
    :cond_2
    throw p1
.end method

.method private writeSnapshot(Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 212
    nop

    .line 213
    nop

    .line 215
    const/4 v0, 0x0

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    const-string v2, "w"

    invoke-virtual {v1, p1, v2}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 216
    if-eqz p1, :cond_0

    .line 217
    :try_start_1
    new-instance v1, Ljava/io/OutputStreamWriter;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, p1, v2}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;Ljava/nio/charset/Charset;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 218
    :try_start_2
    invoke-virtual {p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->write(Ljava/io/Writer;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 220
    invoke-virtual {v1}, Ljava/io/OutputStreamWriter;->close()V

    .line 223
    return-void

    .line 220
    :catchall_0
    move-exception p2

    move-object v0, v1

    goto :goto_0

    :catchall_1
    move-exception p2

    goto :goto_0

    .line 216
    :cond_0
    :try_start_3
    new-instance p2, Ljava/io/IOException;

    const-string v1, "Bridge snapshot could not be written"

    invoke-direct {p2, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 220
    :catchall_2
    move-exception p2

    move-object p1, v0

    :goto_0
    if-nez v0, :cond_1

    .line 221
    if-eqz p1, :cond_2

    invoke-virtual {p1}, Ljava/io/OutputStream;->close()V

    goto :goto_1

    .line 220
    :cond_1
    invoke-virtual {v0}, Ljava/io/OutputStreamWriter;->close()V

    .line 222
    :cond_2
    :goto_1
    throw p2
.end method


# virtual methods
.method public listSnapshots()Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 60
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    .line 61
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 62
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listChildren(Ljava/lang/String;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    .line 63
    const-string v3, "vnd.android.document/directory"

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    goto :goto_0

    .line 64
    :cond_0
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v3, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v3

    .line 66
    if-eqz v3, :cond_1

    .line 67
    new-instance v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    .line 68
    invoke-direct {p0, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v6, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    .line 69
    invoke-virtual {v6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    invoke-direct {v4, v5, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;-><init>(Ljava/lang/String;Landroid/net/Uri;Z)V

    .line 67
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 71
    :cond_1
    goto :goto_0

    .line 72
    :cond_2
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)V

    invoke-static {v0, v1}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 77
    return-object v0
.end method

.method public publish(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/lang/String;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 113
    if-eqz p1, :cond_6

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->databaseName:Ljava/lang/String;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->dbName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 114
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object v0

    const-string v1, "user_id"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 117
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->ensureBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 118
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverPublishedFile(Ljava/lang/String;)V

    .line 119
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ".bridge-"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 120
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v3

    invoke-virtual {v3}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ".partial.txt"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 121
    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->createFile(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    .line 122
    nop

    .line 124
    :try_start_0
    invoke-direct {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->writeSnapshot(Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)V

    .line 125
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    const/4 v4, 0x1

    invoke-direct {p1, v3, v2, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;-><init>(Ljava/lang/String;Landroid/net/Uri;Z)V

    .line 127
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object p1

    .line 128
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object p1

    invoke-interface {p1, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 132
    iget-object p1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object p1

    .line 134
    iget-object p2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->previousName()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object p2

    .line 135
    if-eqz p2, :cond_0

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    invoke-direct {p0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->delete(Landroid/net/Uri;)V

    .line 136
    :cond_0
    const/4 p2, 0x0

    if-eqz p1, :cond_1

    .line 137
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->previousName()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    goto :goto_0

    .line 136
    :cond_1
    move-object p1, p2

    .line 141
    :goto_0
    :try_start_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 142
    nop

    .line 149
    nop

    .line 150
    :try_start_2
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 151
    if-eqz p1, :cond_2

    .line 152
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->delete(Landroid/net/Uri;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 153
    nop

    .line 156
    :cond_2
    nop

    .line 158
    return-void

    .line 156
    :catchall_0
    move-exception p1

    move-object v2, p2

    goto :goto_1

    .line 143
    :catch_0
    move-exception p2

    .line 144
    if-eqz p1, :cond_3

    .line 145
    :try_start_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    .line 146
    nop

    .line 148
    :cond_3
    throw p2

    .line 129
    :cond_4
    new-instance p1, Ljava/io/IOException;

    const-string p2, "published Bridge snapshot changed during validation"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 156
    :catchall_1
    move-exception p1

    :goto_1
    if-eqz v2, :cond_5

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->deleteQuietly(Landroid/net/Uri;)V

    .line 157
    :cond_5
    throw p1

    .line 115
    :cond_6
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Bridge snapshot identity is invalid"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 93
    nop

    .line 94
    nop

    .line 96
    const/4 v0, 0x0

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->uri:Landroid/net/Uri;

    invoke-virtual {v1, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 97
    if-eqz p1, :cond_1

    .line 98
    :try_start_1
    new-instance v1, Ljava/io/InputStreamReader;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, p1, v2}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 99
    :try_start_2
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->read(Ljava/io/Reader;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v0

    .line 100
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->databaseName:Ljava/lang/String;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->dbName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v2, :cond_0

    .line 103
    nop

    .line 105
    invoke-virtual {v1}, Ljava/io/Reader;->close()V

    .line 103
    return-object v0

    .line 101
    :cond_0
    :try_start_3
    new-instance v0, Ljava/io/IOException;

    const-string v2, "Rime snapshot database name does not match its file"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 105
    :catchall_0
    move-exception v0

    goto :goto_0

    :catchall_1
    move-exception v1

    move-object v4, v1

    move-object v1, v0

    move-object v0, v4

    goto :goto_0

    .line 97
    :cond_1
    :try_start_4
    new-instance v1, Ljava/io/IOException;

    const-string v2, "Rime snapshot could not be opened"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v1
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 105
    :catchall_2
    move-exception p1

    move-object v1, v0

    move-object v0, p1

    move-object p1, v1

    :goto_0
    if-nez v1, :cond_2

    .line 106
    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ljava/io/InputStream;->close()V

    goto :goto_1

    .line 105
    :cond_2
    invoke-virtual {v1}, Ljava/io/Reader;->close()V

    .line 107
    :cond_3
    :goto_1
    throw v0
.end method

.method public recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 162
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 164
    if-nez v0, :cond_0

    const/4 v0, 0x0

    return-object v0

    .line 165
    :cond_0
    const-string v1, "vnd.android.document/directory"

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 168
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverPublishedFile(Ljava/lang/String;)V

    .line 169
    return-object v0

    .line 166
    :cond_1
    new-instance v0, Ljava/io/IOException;

    const-string v1, "configured Bridge device name is not a directory"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public recoverBridgeUserId()Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 82
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 83
    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 84
    :cond_0
    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 86
    if-nez v0, :cond_1

    return-object v1

    .line 87
    :cond_1
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    .line 88
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const/4 v3, 0x1

    invoke-direct {v1, v2, v0, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;-><init>(Ljava/lang/String;Landroid/net/Uri;Z)V

    .line 87
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v0

    .line 89
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->recoverBridgeUserId(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
