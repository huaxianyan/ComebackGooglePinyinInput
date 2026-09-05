.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;
    }
.end annotation


# static fields
.field private static final BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static final DEFAULT_SNAPSHOT_FILE:Ljava/lang/String; = "pinyin_simp.userdb.txt"

.field public static final ERROR_CAPACITY_EXCEEDED:I = 0x6

.field public static final ERROR_CONFIGURATION_REQUIRED:I = 0x1

.field public static final ERROR_DELETION_CONFIRMATION_REQUIRED:I = 0x5

.field public static final ERROR_LOCATION_UNAVAILABLE:I = 0x2

.field public static final ERROR_NATIVE_PERSISTENCE:I = 0x8

.field public static final ERROR_NONE:I = 0x0

.field public static final ERROR_OPERATION_FAILED:I = 0x7

.field public static final ERROR_OPERATION_IN_PROGRESS:I = 0x3

.field public static final ERROR_PREVIEW_CHANGED:I = 0x4

.field public static final ERROR_PREVIEW_GOOGLE_EXPORT:I = 0xf

.field public static final ERROR_PREVIEW_RIME_MERGE:I = 0xe

.field public static final ERROR_PREVIEW_SESSION_PLAN:I = 0x10

.field public static final ERROR_PREVIEW_SOURCE_CLOSE:I = 0xd

.field public static final ERROR_PREVIEW_SOURCE_DATABASE:I = 0xc

.field public static final ERROR_PREVIEW_SOURCE_LIST:I = 0x9

.field public static final ERROR_PREVIEW_SOURCE_OPEN:I = 0xa

.field public static final ERROR_PREVIEW_SOURCE_PARSE:I = 0xb

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field private static final KEY_DEVICE_DIRECTORY:Ljava/lang/String; = "rime_sync_device_directory"

.field private static final KEY_ROOT_LABEL:Ljava/lang/String; = "rime_sync_root_label"

.field private static final KEY_ROOT_URI:Ljava/lang/String; = "rime_sync_root_uri"

.field private static final KEY_SNAPSHOT_FILE:Ljava/lang/String; = "rime_sync_snapshot_file"

.field private static final MAIN:Landroid/os/Handler;

.field public static final NATIVE_FAILURE_DATA:I = 0xa

.field public static final NATIVE_FAILURE_DUPLICATE:I = 0x5

.field public static final NATIVE_FAILURE_EXPORT:I = 0x9

.field public static final NATIVE_FAILURE_INSERT:I = 0x6

.field public static final NATIVE_FAILURE_IO:I = 0x2

.field public static final NATIVE_FAILURE_MEMORY:I = 0x3

.field public static final NATIVE_FAILURE_NONE:I = 0x0

.field public static final NATIVE_FAILURE_PERSIST:I = 0x7

.field public static final NATIVE_FAILURE_PERSISTENCE:I = 0x1

.field public static final NATIVE_FAILURE_REBUILD:I = 0x8

.field public static final NATIVE_FAILURE_RUNTIME:I = 0x4

.field public static final NATIVE_FAILURE_STALE:I = 0xb

.field private static final PREFERENCES:Ljava/lang/String; = "rime_dictionary_sync_preferences"

.field private static final PROTOCOL_VERSION:I = 0x1


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 57
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    .line 58
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    .line 59
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 61
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static acceptRootAsync(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 204
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$6;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$6;-><init>(Landroid/net/Uri;Ljava/lang/String;)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 233
    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 0

    .line 15
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->coordinator(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$200(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 15
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$400(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$500(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$600(I)I
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->previewError(I)I

    move-result p0

    return p0
.end method

.method static synthetic access$700()Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    .line 15
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method private static configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;
    .locals 4

    .line 434
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 435
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 436
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v1

    .line 437
    const-string v2, "rime_sync_snapshot_file"

    const-string v3, "pinyin_simp.userdb.txt"

    invoke-interface {p0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 435
    return-object v0
.end method

.method public static configureAutomaticAsync(Landroid/content/Context;ZILcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 0

    .line 112
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->intervalMillis(I)J

    .line 113
    if-nez p1, :cond_0

    .line 114
    const/4 p1, 0x0

    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->configure(Landroid/content/Context;ZI)Z

    .line 115
    sget-object p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;

    invoke-direct {p2, p3, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Landroid/content/Context;)V

    invoke-interface {p1, p2}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 120
    return-void

    .line 122
    :cond_0
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;

    invoke-direct {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;-><init>(I)V

    invoke-static {p0, p3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 134
    return-void
.end method

.method private static configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 427
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    if-nez v0, :cond_0

    .line 428
    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeUserId()Ljava/lang/String;

    move-result-object p3

    goto :goto_0

    :cond_0
    const/4 p3, 0x0

    .line 429
    :goto_0
    const/4 v0, 0x1

    invoke-virtual {p0, p1, p2, v0, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->configure(Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;ILjava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object p0

    return-object p0
.end method

.method private static coordinator(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 399
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 400
    const-string v1, "rime_sync_root_uri"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 401
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-eqz v1, :cond_0

    .line 404
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object v7

    .line 405
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 406
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v6, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 410
    :try_start_0
    new-instance v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    invoke-direct {v5, p0, v1, v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 413
    nop

    .line 414
    :try_start_1
    invoke-static {v6, v0, v7, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    .line 415
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncEngineFactoryProvider;->get(Landroid/content/Context;)Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    move-result-object v4

    .line 416
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    move-object v3, p0

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;-><init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V

    invoke-direct {v0, v6, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;)V

    return-object v0

    .line 418
    :catch_0
    move-exception v0

    move-object p0, v0

    goto :goto_0

    .line 411
    :catch_1
    move-exception v0

    move-object p0, v0

    .line 412
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;-><init>(Ljava/lang/Throwable;)V

    throw v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 419
    :goto_0
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 420
    throw p0

    .line 402
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime synchronization root is required"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 2

    .line 391
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 396
    return-void
.end method

.method private static deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 2

    .line 441
    const-string v0, "rime_sync_device_directory"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 442
    const-string v1, ""

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 444
    :cond_0
    sget-object p0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->defaultDeviceName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static executeAsync(Landroid/content/Context;Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 251
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;-><init>(Ljava/lang/String;Z)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 263
    return-void
.end method

.method private static hasPersistedAccess(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 3

    .line 452
    const/4 v0, 0x0

    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_0

    goto :goto_2

    .line 455
    :cond_0
    :try_start_0
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 457
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/ContentResolver;->getPersistedUriPermissions()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/UriPermission;

    .line 458
    invoke-virtual {v1}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {p1, v2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 459
    invoke-virtual {v1}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v1, :cond_1

    const/4 p0, 0x1

    return p0

    .line 460
    :cond_1
    goto :goto_0

    .line 462
    :cond_2
    goto :goto_1

    .line 461
    :catch_0
    move-exception p0

    .line 463
    :goto_1
    return v0

    .line 452
    :cond_3
    :goto_2
    return v0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 448
    const-string v0, "rime_dictionary_sync_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static previewAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 236
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$7;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$7;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 247
    return-void
.end method

.method private static previewError(I)I
    .locals 2

    .line 363
    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    .line 364
    const/16 p0, 0x9

    return p0

    .line 366
    :cond_0
    const/4 v0, 0x2

    if-ne p0, v0, :cond_1

    .line 367
    const/16 p0, 0xa

    return p0

    .line 369
    :cond_1
    const/4 v0, 0x3

    if-ne p0, v0, :cond_2

    .line 370
    const/16 p0, 0xb

    return p0

    .line 372
    :cond_2
    const/4 v0, 0x4

    if-ne p0, v0, :cond_3

    .line 373
    const/16 p0, 0xc

    return p0

    .line 375
    :cond_3
    const/4 v0, 0x5

    if-ne p0, v0, :cond_4

    .line 376
    const/16 p0, 0xd

    return p0

    .line 378
    :cond_4
    const/4 v0, 0x6

    if-ne p0, v0, :cond_5

    .line 379
    const/16 p0, 0xe

    return p0

    .line 381
    :cond_5
    const/4 v0, 0x7

    if-ne p0, v0, :cond_6

    .line 382
    const/16 p0, 0xf

    return p0

    .line 384
    :cond_6
    const/16 v1, 0x8

    if-ne p0, v1, :cond_7

    .line 385
    const/16 p0, 0x10

    return p0

    .line 387
    :cond_7
    return v0
.end method

.method public static read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;
    .locals 16

    .line 68
    invoke-virtual/range {p0 .. p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 69
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 70
    const-string v2, "rime_sync_root_uri"

    const-string v3, ""

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 71
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v4

    .line 72
    const-string v5, "rime_sync_snapshot_file"

    const-string v6, "pinyin_simp.userdb.txt"

    invoke-interface {v0, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 73
    nop

    .line 74
    nop

    .line 75
    nop

    .line 76
    nop

    .line 77
    nop

    .line 78
    nop

    .line 79
    nop

    .line 80
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v6, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 82
    :try_start_0
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v7

    .line 83
    if-eqz v7, :cond_0

    .line 84
    iget-wide v8, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->lastSuccess:J

    .line 85
    iget v10, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    .line 86
    iget v11, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeExpectedCount:I

    .line 87
    iget v12, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeActualCount:I

    .line 88
    iget v13, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    .line 89
    iget-boolean v14, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    .line 90
    iget v7, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move v15, v7

    move-wide v7, v8

    move v9, v10

    goto :goto_0

    .line 83
    :cond_0
    const-wide/16 v8, 0x0

    const/4 v10, 0x0

    move-wide v7, v8

    const/4 v9, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    .line 93
    :goto_0
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 94
    nop

    .line 95
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    const-string v10, "rime_sync_root_label"

    invoke-interface {v0, v10, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 96
    move-object v0, v6

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->hasPersistedAccess(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v6

    sget-object v10, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 97
    invoke-virtual {v10}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v10

    invoke-direct/range {v0 .. v15}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJIZIIIZI)V

    .line 95
    return-object v0

    .line 93
    :catchall_0
    move-exception v0

    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 94
    throw v0
.end method

.method public static readAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 102
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$1;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$1;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 108
    return-void
.end method

.method public static recoverAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 266
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 277
    return-void
.end method

.method public static recoverKeepingRejectedAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 281
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$10;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$10;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 293
    return-void
.end method

.method public static resetBaselineAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 296
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$11;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$11;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 309
    return-void
.end method

.method public static runAutomaticAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 137
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 160
    return-void
.end method

.method public static saveConfigurationAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 165
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 200
    return-void
.end method

.method private static submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V
    .locals 3

    .line 313
    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    .line 316
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 317
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-nez v0, :cond_0

    .line 318
    sget-object p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$12;

    invoke-direct {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$12;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Landroid/content/Context;)V

    invoke-interface {p2, v0}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 323
    return-void

    .line 325
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$13;

    invoke-direct {v1, p2, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$13;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 360
    return-void

    .line 314
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Rime synchronization callback is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
