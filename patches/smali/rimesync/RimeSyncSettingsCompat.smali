.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;,
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

    .line 49
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    .line 50
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    .line 51
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static acceptRootAsync(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 137
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;-><init>(Landroid/net/Uri;Ljava/lang/String;)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 162
    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
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

.method static synthetic access$200(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$300(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;
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

.method static synthetic access$400()Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    .line 15
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method static synthetic access$500(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 0

    .line 15
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    return-void
.end method

.method private static configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;
    .locals 4

    .line 322
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 323
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 324
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v1

    .line 325
    const-string v2, "rime_sync_snapshot_file"

    const-string v3, "pinyin_simp.userdb.txt"

    invoke-interface {p0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 323
    return-object v0
.end method

.method private static configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 315
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    if-nez v0, :cond_0

    .line 316
    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeUserId()Ljava/lang/String;

    move-result-object p3

    goto :goto_0

    :cond_0
    const/4 p3, 0x0

    .line 317
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

    .line 292
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 293
    const-string v1, "rime_sync_root_uri"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 294
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-eqz v1, :cond_0

    .line 297
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object v7

    .line 298
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 299
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v6, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 301
    :try_start_0
    new-instance v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    invoke-direct {v5, p0, v1, v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V

    .line 302
    invoke-static {v6, v0, v7, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    .line 303
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncEngineFactoryProvider;->get(Landroid/content/Context;)Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    move-result-object v4

    .line 304
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    move-object v3, p0

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;-><init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V

    invoke-direct {v0, v6, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 306
    :catch_0
    move-exception v0

    move-object p0, v0

    .line 307
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 308
    throw p0

    .line 295
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime synchronization root is required"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 2

    .line 284
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$10;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$10;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 289
    return-void
.end method

.method private static deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 2

    .line 329
    const-string v0, "rime_sync_device_directory"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 330
    const-string v1, ""

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 332
    :cond_0
    sget-object p0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->defaultDeviceName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static executeAsync(Landroid/content/Context;Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 180
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;-><init>(Ljava/lang/String;Z)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 192
    return-void
.end method

.method private static hasPersistedAccess(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 3

    .line 340
    const/4 v0, 0x0

    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_0

    goto :goto_2

    .line 343
    :cond_0
    :try_start_0
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 345
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

    .line 346
    invoke-virtual {v1}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {p1, v2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 347
    invoke-virtual {v1}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v1, :cond_1

    const/4 p0, 0x1

    return p0

    .line 348
    :cond_1
    goto :goto_0

    .line 350
    :cond_2
    goto :goto_1

    .line 349
    :catch_0
    move-exception p0

    .line 351
    :goto_1
    return v0

    .line 340
    :cond_3
    :goto_2
    return v0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 336
    const-string v0, "rime_dictionary_sync_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static previewAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 165
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 176
    return-void
.end method

.method public static read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;
    .locals 19

    .line 60
    invoke-virtual/range {p0 .. p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    .line 61
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 62
    const-string v2, "rime_sync_root_uri"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 63
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v7

    .line 64
    const-string v2, "rime_sync_snapshot_file"

    const-string v4, "pinyin_simp.userdb.txt"

    invoke-interface {v1, v2, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 65
    nop

    .line 66
    nop

    .line 67
    nop

    .line 68
    nop

    .line 69
    nop

    .line 70
    nop

    .line 71
    nop

    .line 72
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 74
    :try_start_0
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v4

    .line 75
    if-eqz v4, :cond_0

    .line 76
    iget-wide v9, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->lastSuccess:J

    .line 77
    iget v6, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    .line 78
    iget v11, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeExpectedCount:I

    .line 79
    iget v12, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeActualCount:I

    .line 80
    iget v13, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    .line 81
    iget-boolean v14, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    .line 82
    iget v4, v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move/from16 v18, v4

    move v15, v12

    move/from16 v16, v13

    move/from16 v17, v14

    move v12, v6

    move v14, v11

    move-wide v10, v9

    goto :goto_0

    .line 75
    :cond_0
    const-wide/16 v9, 0x0

    const/4 v6, 0x0

    const/4 v12, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    const/16 v16, 0x0

    const/16 v17, 0x0

    const/16 v18, 0x0

    move-wide v10, v9

    .line 85
    :goto_0
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 86
    nop

    .line 87
    new-instance v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    const-string v2, "rime_sync_root_label"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 88
    invoke-static {v0, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->hasPersistedAccess(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v9

    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 89
    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v13

    invoke-direct/range {v4 .. v18}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJIZIIIZI)V

    .line 87
    return-object v4

    .line 85
    :catchall_0
    move-exception v0

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 86
    throw v0
.end method

.method public static readAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 94
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$1;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$1;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 99
    return-void
.end method

.method public static recoverAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 195
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$6;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$6;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 206
    return-void
.end method

.method public static recoverKeepingRejectedAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 210
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$7;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$7;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 222
    return-void
.end method

.method public static resetBaselineAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 225
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 236
    return-void
.end method

.method public static saveConfigurationAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 104
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 133
    return-void
.end method

.method private static submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V
    .locals 3

    .line 240
    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    .line 243
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 244
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-nez v0, :cond_0

    .line 245
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p0

    const/4 p2, 0x3

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    .line 246
    return-void

    .line 248
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;

    invoke-direct {v1, p2, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 281
    return-void

    .line 241
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Rime synchronization callback is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
