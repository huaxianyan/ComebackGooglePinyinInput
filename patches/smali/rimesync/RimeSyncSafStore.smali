.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;
.super Ljava/lang/Object;
.source "RimeSyncSafStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;
    }
.end annotation


# static fields
.field private static final MIME_DIRECTORY:Ljava/lang/String; = "vnd.android.document/directory"

.field public static final SNAPSHOT_READ_CLOSE:I = 0x4

.field public static final SNAPSHOT_READ_DATABASE:I = 0x3

.field public static final SNAPSHOT_READ_OPEN:I = 0x1

.field public static final SNAPSHOT_READ_PARSE:I = 0x2

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

    .line 31
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

    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :cond_2

    .line 45
    const-string v0, "Rime synchronization root is invalid"

    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    if-eqz p3, :cond_1

    .line 46
    invoke-static {p2}, Landroid/provider/DocumentsContract;->isTreeUri(Landroid/net/Uri;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 49
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->context:Landroid/content/Context;

    .line 50
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->context:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    .line 51
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    .line 52
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 54
    :try_start_0
    invoke-static {p2}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 57
    nop

    .line 58
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->hasPersistedReadWriteAccess()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 61
    return-void

    .line 59
    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Rime synchronization root permission is unavailable"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 55
    :catch_0
    move-exception p1

    .line 56
    new-instance p2, Ljava/io/IOException;

    invoke-direct {p2, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2

    .line 47
    :cond_1
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 43
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

    .line 264
    const-string v0, "Bridge temporary snapshot was not created"

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    const-string v2, "text/plain"

    invoke-static {v1, p1, v2, p2}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 266
    if-eqz p1, :cond_0

    .line 267
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 268
    return-object p1

    .line 266
    :cond_0
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 269
    :catch_0
    move-exception p1

    .line 270
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

    .line 287
    const-string v0, "Rime snapshot cleanup failed"

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-static {v1, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 292
    nop

    .line 293
    return-void

    .line 288
    :cond_0
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 290
    :catch_0
    move-exception p1

    .line 291
    new-instance v1, Ljava/io/IOException;

    invoke-direct {v1, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method private deleteQuietly(Landroid/net/Uri;)V
    .locals 1

    .line 297
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-static {v0, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 299
    goto :goto_0

    .line 298
    :catch_0
    move-exception p1

    .line 300
    :goto_0
    return-void
.end method

.method private documentUri(Ljava/lang/String;)Landroid/net/Uri;
    .locals 1

    .line 348
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

    .line 210
    const-string v0, "Bridge device directory could not be created"

    const-string v1, "vnd.android.document/directory"

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v2

    .line 211
    if-eqz v2, :cond_0

    return-object v2

    .line 212
    :cond_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    .line 215
    :try_start_0
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-static {v3, v2, v1, v4}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 219
    nop

    .line 220
    if-eqz v2, :cond_2

    .line 221
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-direct {p0, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 222
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-direct {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 224
    if-eqz v0, :cond_1

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 227
    return-object v0

    .line 225
    :cond_1
    new-instance v0, Ljava/io/IOException;

    const-string v1, "created Bridge device directory is not a direct child"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 220
    :cond_2
    new-instance v1, Ljava/io/IOException;

    invoke-direct {v1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 217
    :catch_0
    move-exception v1

    .line 218
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

    .line 304
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listChildren(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object p1

    return-object p1
.end method

.method private hasPersistedReadWriteAccess()Z
    .locals 4

    .line 369
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

    .line 370
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    invoke-virtual {v1}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v1}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 371
    invoke-virtual {v1}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v1, :cond_0

    const/4 v0, 0x1

    return v0

    .line 372
    :cond_0
    goto :goto_0

    .line 374
    :cond_1
    goto :goto_1

    .line 373
    :catch_0
    move-exception v0

    .line 375
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

    .line 319
    const-string v1, "Rime directory could not be listed"

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 320
    nop

    .line 322
    const/4 v2, 0x0

    :try_start_0
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootTree:Landroid/net/Uri;

    invoke-static {v3, p1}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    .line 324
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

    .line 329
    if-eqz v2, :cond_3

    .line 330
    :goto_0
    invoke-interface {v2}, Landroid/database/Cursor;->moveToNext()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 331
    invoke-interface {v2, v3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    .line 332
    invoke-interface {v2, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 333
    invoke-interface {v2, v11}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 334
    if-eqz p1, :cond_0

    if-eqz v4, :cond_0

    if-eqz v5, :cond_0

    .line 337
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    invoke-direct {v6, p1, v4, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 338
    goto :goto_0

    .line 335
    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string v0, "Rime directory contains incomplete metadata"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 342
    :cond_1
    if-eqz v2, :cond_2

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 344
    :cond_2
    return-object v0

    .line 329
    :cond_3
    :try_start_1
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 342
    :catchall_0
    move-exception v0

    move-object p1, v0

    goto :goto_1

    .line 339
    :catch_0
    move-exception v0

    move-object p1, v0

    .line 340
    :try_start_2
    new-instance v0, Ljava/io/IOException;

    invoke-direct {v0, v1, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 342
    :goto_1
    if-eqz v2, :cond_4

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 343
    :cond_4
    goto :goto_3

    :goto_2
    throw p1

    :goto_3
    goto :goto_2
.end method

.method private previousName()Ljava/lang/String;
    .locals 2

    .line 379
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

    .line 231
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listChildren(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    .line 232
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 233
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->previousName()Ljava/lang/String;

    move-result-object v1

    invoke-static {p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->uniqueNamed(Ljava/util/List;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v1

    .line 234
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    .line 235
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

    .line 236
    const-string v4, ".partial"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_0

    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    .line 237
    const-string v4, ".partial.txt"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 238
    :cond_0
    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->deleteQuietly(Landroid/net/Uri;)V

    .line 240
    :cond_1
    goto :goto_0

    .line 241
    :cond_2
    if-nez v0, :cond_3

    if-eqz v1, :cond_3

    .line 242
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    goto :goto_1

    .line 243
    :cond_3
    if-eqz v0, :cond_4

    if-eqz v1, :cond_4

    .line 244
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->delete(Landroid/net/Uri;)V

    .line 246
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

    .line 276
    const-string v0, "Rime snapshot rename failed"

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    invoke-static {v1, p1, p2}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 277
    if-eqz p1, :cond_0

    .line 278
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 279
    return-object p1

    .line 277
    :cond_0
    new-instance p1, Ljava/io/IOException;

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 280
    :catch_0
    move-exception p1

    .line 281
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

    .line 309
    nop

    .line 310
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

    .line 311
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    goto :goto_0

    .line 312
    :cond_0
    if-nez v0, :cond_1

    .line 313
    nop

    .line 314
    move-object v0, v1

    goto :goto_0

    .line 312
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "duplicate Rime document name"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 315
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

    .line 352
    nop

    .line 354
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

    .line 357
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

    .line 363
    if-eqz v1, :cond_0

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 365
    :cond_0
    return-void

    .line 358
    :cond_1
    :try_start_1
    new-instance p1, Ljava/io/IOException;

    const-string p2, "document provider changed the requested Rime name"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 363
    :catchall_0
    move-exception v0

    move-object p1, v0

    goto :goto_0

    .line 360
    :catch_0
    move-exception v0

    move-object p1, v0

    .line 361
    :try_start_2
    new-instance p2, Ljava/io/IOException;

    const-string v0, "Rime document identity could not be verified"

    invoke-direct {p2, v0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 363
    :goto_0
    if-eqz v1, :cond_2

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 364
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

    .line 249
    nop

    .line 250
    nop

    .line 252
    const/4 v0, 0x0

    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    const-string v2, "w"

    invoke-virtual {v1, p1, v2}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 253
    if-eqz p1, :cond_0

    .line 254
    :try_start_1
    new-instance v1, Ljava/io/OutputStreamWriter;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, p1, v2}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;Ljava/nio/charset/Charset;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 255
    :try_start_2
    invoke-virtual {p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->write(Ljava/io/Writer;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 257
    invoke-virtual {v1}, Ljava/io/OutputStreamWriter;->close()V

    .line 260
    return-void

    .line 257
    :catchall_0
    move-exception p2

    move-object v0, v1

    goto :goto_0

    :catchall_1
    move-exception p2

    goto :goto_0

    .line 253
    :cond_0
    :try_start_3
    new-instance p2, Ljava/io/IOException;

    const-string v1, "Bridge snapshot could not be written"

    invoke-direct {p2, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 257
    :catchall_2
    move-exception p2

    move-object p1, v0

    :goto_0
    if-nez v0, :cond_1

    .line 258
    if-eqz p1, :cond_2

    invoke-virtual {p1}, Ljava/io/OutputStream;->close()V

    goto :goto_1

    .line 257
    :cond_1
    invoke-virtual {v0}, Ljava/io/OutputStreamWriter;->close()V

    .line 259
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

    .line 65
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    .line 66
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 67
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

    .line 68
    const-string v3, "vnd.android.document/directory"

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    goto :goto_0

    .line 69
    :cond_0
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v3, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v3

    .line 71
    if-eqz v3, :cond_1

    .line 72
    new-instance v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    .line 73
    invoke-direct {p0, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v6, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    .line 74
    invoke-virtual {v6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    invoke-direct {v4, v5, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;-><init>(Ljava/lang/String;Landroid/net/Uri;Z)V

    .line 72
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 76
    :cond_1
    goto :goto_0

    .line 77
    :cond_2
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)V

    invoke-static {v0, v1}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 82
    return-object v0
.end method

.method public publish(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Ljava/lang/String;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 150
    if-eqz p1, :cond_6

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->databaseName:Ljava/lang/String;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->dbName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 151
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object v0

    const-string v1, "user_id"

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 154
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->ensureBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 155
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverPublishedFile(Ljava/lang/String;)V

    .line 156
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

    .line 157
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

    .line 158
    iget-object v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->createFile(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    .line 159
    nop

    .line 161
    :try_start_0
    invoke-direct {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->writeSnapshot(Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)V

    .line 162
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    const/4 v4, 0x1

    invoke-direct {p1, v3, v2, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;-><init>(Ljava/lang/String;Landroid/net/Uri;Z)V

    .line 164
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object p1

    .line 165
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->metadata()Ljava/util/Map;

    move-result-object p1

    invoke-interface {p1, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 169
    iget-object p1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object p1

    .line 171
    iget-object p2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->previousName()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object p2

    .line 172
    if-eqz p2, :cond_0

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    invoke-direct {p0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->delete(Landroid/net/Uri;)V

    .line 173
    :cond_0
    const/4 p2, 0x0

    if-eqz p1, :cond_1

    .line 174
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

    .line 173
    :cond_1
    move-object p1, p2

    .line 178
    :goto_0
    :try_start_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 179
    nop

    .line 186
    nop

    .line 187
    :try_start_2
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->verifyDisplayName(Landroid/net/Uri;Ljava/lang/String;)V

    .line 188
    if-eqz p1, :cond_2

    .line 189
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->delete(Landroid/net/Uri;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 190
    nop

    .line 193
    :cond_2
    nop

    .line 195
    return-void

    .line 193
    :catchall_0
    move-exception p1

    move-object v2, p2

    goto :goto_1

    .line 180
    :catch_0
    move-exception p2

    .line 181
    if-eqz p1, :cond_3

    .line 182
    :try_start_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rename(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    .line 183
    nop

    .line 185
    :cond_3
    throw p2

    .line 166
    :cond_4
    new-instance p1, Ljava/io/IOException;

    const-string p2, "published Bridge snapshot changed during validation"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 193
    :catchall_1
    move-exception p1

    :goto_1
    if-eqz v2, :cond_5

    invoke-direct {p0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->deleteQuietly(Landroid/net/Uri;)V

    .line 194
    :cond_5
    throw p1

    .line 152
    :cond_6
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Bridge snapshot identity is invalid"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 98
    nop

    .line 99
    nop

    .line 102
    const/4 v0, 0x1

    const/4 v1, 0x0

    :try_start_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->resolver:Landroid/content/ContentResolver;

    iget-object v3, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->uri:Landroid/net/Uri;

    invoke-virtual {v2, v3}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v2
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_4
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_3
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 107
    nop

    .line 108
    if-eqz v2, :cond_0

    .line 111
    :try_start_1
    new-instance v0, Ljava/io/InputStreamReader;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v2, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 114
    :try_start_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->read(Ljava/io/Reader;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v1
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 117
    nop

    .line 119
    :try_start_3
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-boolean p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->bridgeOwned:Z

    invoke-static {v1, v3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->normalizeSnapshotDatabase(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Z)V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 123
    nop

    .line 125
    :try_start_4
    invoke-virtual {v0}, Ljava/io/Reader;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 128
    nop

    .line 129
    nop

    .line 130
    nop

    .line 131
    nop

    .line 133
    nop

    .line 138
    nop

    .line 131
    return-object v1

    .line 126
    :catch_0
    move-exception p1

    .line 127
    :try_start_5
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;

    const/4 v3, 0x4

    invoke-direct {v1, v3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;-><init>(ILjava/lang/Throwable;)V

    throw v1

    .line 121
    :catch_1
    move-exception p1

    .line 122
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;

    const/4 v3, 0x3

    invoke-direct {v1, v3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;-><init>(ILjava/lang/Throwable;)V

    throw v1

    .line 133
    :catchall_0
    move-exception p1

    move-object v1, v0

    goto :goto_0

    .line 115
    :catch_2
    move-exception p1

    .line 116
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;

    const/4 v3, 0x2

    invoke-direct {v1, v3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;-><init>(ILjava/lang/Throwable;)V

    throw v1
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 133
    :catchall_1
    move-exception p1

    goto :goto_0

    .line 109
    :cond_0
    :try_start_6
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;

    invoke-direct {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;-><init>(ILjava/lang/Throwable;)V

    throw p1
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    .line 133
    :catchall_2
    move-exception p1

    move-object v2, v1

    goto :goto_0

    .line 105
    :catch_3
    move-exception p1

    .line 106
    :try_start_7
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;

    invoke-direct {v2, v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;-><init>(ILjava/lang/Throwable;)V

    throw v2

    .line 103
    :catch_4
    move-exception p1

    .line 104
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;

    invoke-direct {v2, v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;-><init>(ILjava/lang/Throwable;)V

    throw v2
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_2

    .line 133
    :goto_0
    if-nez v1, :cond_1

    .line 138
    if-eqz v2, :cond_2

    .line 140
    :try_start_8
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_5

    .line 142
    goto :goto_2

    .line 141
    :catch_5
    move-exception v0

    goto :goto_2

    .line 135
    :cond_1
    :try_start_9
    invoke-virtual {v1}, Ljava/io/Reader;->close()V
    :try_end_9
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_6

    .line 137
    :goto_1
    goto :goto_2

    .line 136
    :catch_6
    move-exception v0

    goto :goto_1

    .line 144
    :cond_2
    :goto_2
    goto :goto_4

    :goto_3
    throw p1

    :goto_4
    goto :goto_3
.end method

.method public recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 199
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->rootDocumentId:Ljava/lang/String;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 201
    if-nez v0, :cond_0

    const/4 v0, 0x0

    return-object v0

    .line 202
    :cond_0
    const-string v1, "vnd.android.document/directory"

    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 205
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverPublishedFile(Ljava/lang/String;)V

    .line 206
    return-object v0

    .line 203
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

    .line 87
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeDirectory()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 88
    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 89
    :cond_0
    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    invoke-direct {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->findUniqueChild(Ljava/lang/String;Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;

    move-result-object v0

    .line 91
    if-nez v0, :cond_1

    return-object v1

    .line 92
    :cond_1
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->configuration:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    .line 93
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->documentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const/4 v3, 0x1

    invoke-direct {v1, v2, v0, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;-><init>(Ljava/lang/String;Landroid/net/Uri;Z)V

    .line 92
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->readSnapshot(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    move-result-object v0

    .line 94
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;->recoverBridgeUserId(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
