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
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;
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

.field private static final LISTENERS:Ljava/util/concurrent/CopyOnWriteArraySet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/CopyOnWriteArraySet<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;",
            ">;"
        }
    .end annotation
.end field

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

.field private static final STATE_CHANGED:Ljava/lang/Runnable;


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

    .line 60
    new-instance v0, Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-direct {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->LISTENERS:Ljava/util/concurrent/CopyOnWriteArraySet;

    .line 62
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$1;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$1;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->STATE_CHANGED:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 78
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static acceptRootAsync(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 227
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$7;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$7;-><init>(Landroid/net/Uri;Ljava/lang/String;)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 256
    return-void
.end method

.method static synthetic access$000()Ljava/util/concurrent/CopyOnWriteArraySet;
    .locals 1

    .line 15
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->LISTENERS:Ljava/util/concurrent/CopyOnWriteArraySet;

    return-object v0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 0

    .line 15
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    return-void
.end method

.method static synthetic access$200(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;
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

.method static synthetic access$300(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$400(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
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

.method static synthetic access$500(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$600(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$700(I)I
    .locals 0

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->previewError(I)I

    move-result p0

    return p0
.end method

.method static synthetic access$800()Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    .line 15
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method public static addStateListener(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;)V
    .locals 1

    .line 70
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->LISTENERS:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0, p0}, Ljava/util/concurrent/CopyOnWriteArraySet;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;
    .locals 4

    .line 458
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 459
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    .line 460
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v1

    .line 461
    const-string v2, "rime_sync_snapshot_file"

    const-string v3, "pinyin_simp.userdb.txt"

    invoke-interface {p0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 459
    return-object v0
.end method

.method public static configureAutomaticAsync(Landroid/content/Context;ZILcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 0

    .line 135
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->intervalMillis(I)J

    .line 136
    if-nez p1, :cond_0

    .line 137
    const/4 p1, 0x0

    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->configure(Landroid/content/Context;ZI)Z

    .line 138
    sget-object p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;

    invoke-direct {p2, p3, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Landroid/content/Context;)V

    invoke-interface {p1, p2}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 143
    return-void

    .line 145
    :cond_0
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;

    invoke-direct {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;-><init>(I)V

    invoke-static {p0, p3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 157
    return-void
.end method

.method private static configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 451
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v0

    if-nez v0, :cond_0

    .line 452
    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->recoverBridgeUserId()Ljava/lang/String;

    move-result-object p3

    goto :goto_0

    :cond_0
    const/4 p3, 0x0

    .line 453
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

    .line 423
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 424
    const-string v1, "rime_sync_root_uri"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 425
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-eqz v1, :cond_0

    .line 428
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configuration(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object v7

    .line 429
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 430
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v6, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 434
    :try_start_0
    new-instance v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    invoke-direct {v5, p0, v1, v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 437
    nop

    .line 438
    :try_start_1
    invoke-static {v6, v0, v7, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configureState(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    .line 439
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncEngineFactoryProvider;->get(Landroid/content/Context;)Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    move-result-object v4

    .line 440
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    move-object v3, p0

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;-><init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V

    invoke-direct {v0, v6, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;)V

    return-object v0

    .line 442
    :catch_0
    move-exception v0

    move-object p0, v0

    goto :goto_0

    .line 435
    :catch_1
    move-exception v0

    move-object p0, v0

    .line 436
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;-><init>(Ljava/lang/Throwable;)V

    throw v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 443
    :goto_0
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 444
    throw p0

    .line 426
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime synchronization root is required"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 2

    .line 415
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$15;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$15;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 420
    return-void
.end method

.method private static deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 2

    .line 465
    const-string v0, "rime_sync_device_directory"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 466
    const-string v1, ""

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 468
    :cond_0
    sget-object p0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->defaultDeviceName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static executeAsync(Landroid/content/Context;Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 274
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;-><init>(Ljava/lang/String;Z)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 286
    return-void
.end method

.method private static hasPersistedAccess(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 3

    .line 476
    const/4 v0, 0x0

    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_0

    goto :goto_2

    .line 479
    :cond_0
    :try_start_0
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 481
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

    .line 482
    invoke-virtual {v1}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {p1, v2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 483
    invoke-virtual {v1}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v1, :cond_1

    const/4 p0, 0x1

    return p0

    .line 484
    :cond_1
    goto :goto_0

    .line 486
    :cond_2
    goto :goto_1

    .line 485
    :catch_0
    move-exception p0

    .line 487
    :goto_1
    return v0

    .line 476
    :cond_3
    :goto_2
    return v0
.end method

.method static declared-synchronized notifyStateChanged()V
    .locals 3

    const-class v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;

    monitor-enter v0

    .line 74
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->STATE_CHANGED:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 75
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->MAIN:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->STATE_CHANGED:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 76
    monitor-exit v0

    return-void

    .line 73
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 472
    const-string v0, "rime_dictionary_sync_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static previewAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 259
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 270
    return-void
.end method

.method private static previewError(I)I
    .locals 2

    .line 387
    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    .line 388
    const/16 p0, 0x9

    return p0

    .line 390
    :cond_0
    const/4 v0, 0x2

    if-ne p0, v0, :cond_1

    .line 391
    const/16 p0, 0xa

    return p0

    .line 393
    :cond_1
    const/4 v0, 0x3

    if-ne p0, v0, :cond_2

    .line 394
    const/16 p0, 0xb

    return p0

    .line 396
    :cond_2
    const/4 v0, 0x4

    if-ne p0, v0, :cond_3

    .line 397
    const/16 p0, 0xc

    return p0

    .line 399
    :cond_3
    const/4 v0, 0x5

    if-ne p0, v0, :cond_4

    .line 400
    const/16 p0, 0xd

    return p0

    .line 402
    :cond_4
    const/4 v0, 0x6

    if-ne p0, v0, :cond_5

    .line 403
    const/16 p0, 0xe

    return p0

    .line 405
    :cond_5
    const/4 v0, 0x7

    if-ne p0, v0, :cond_6

    .line 406
    const/16 p0, 0xf

    return p0

    .line 408
    :cond_6
    const/16 v1, 0x8

    if-ne p0, v1, :cond_7

    .line 409
    const/16 p0, 0x10

    return p0

    .line 411
    :cond_7
    return v0
.end method

.method public static read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;
    .locals 16

    .line 85
    invoke-virtual/range {p0 .. p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 86
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 87
    const-string v2, "rime_sync_root_uri"

    const-string v3, ""

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 88
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deviceName(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v4

    .line 89
    const-string v5, "rime_sync_snapshot_file"

    const-string v6, "pinyin_simp.userdb.txt"

    invoke-interface {v0, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 90
    nop

    .line 91
    nop

    .line 92
    nop

    .line 93
    nop

    .line 94
    nop

    .line 95
    nop

    .line 96
    nop

    .line 97
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v6, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 99
    :try_start_0
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->profile()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;

    move-result-object v7

    .line 100
    if-eqz v7, :cond_0

    .line 101
    iget-wide v8, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->lastSuccess:J

    .line 102
    iget v10, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    .line 103
    iget v11, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeExpectedCount:I

    .line 104
    iget v12, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeActualCount:I

    .line 105
    iget v13, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    .line 106
    iget-boolean v14, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    .line 107
    iget v7, v7, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move v15, v7

    move-wide v7, v8

    move v9, v10

    goto :goto_0

    .line 100
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

    .line 110
    :goto_0
    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 111
    nop

    .line 112
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    const-string v10, "rime_sync_root_label"

    invoke-interface {v0, v10, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 113
    move-object v0, v6

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->hasPersistedAccess(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v6

    sget-object v10, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 114
    invoke-virtual {v10}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v10

    invoke-direct/range {v0 .. v15}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJIZIIIZI)V

    .line 112
    return-object v0

    .line 110
    :catchall_0
    move-exception v0

    invoke-virtual {v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 111
    throw v0
.end method

.method public static readAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 2

    .line 119
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 121
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 131
    return-void
.end method

.method public static recoverAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 289
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$10;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$10;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 300
    return-void
.end method

.method public static recoverKeepingRejectedAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 304
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$11;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$11;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 316
    return-void
.end method

.method public static removeStateListener(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;)V
    .locals 1

    .line 71
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->LISTENERS:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0, p0}, Ljava/util/concurrent/CopyOnWriteArraySet;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public static resetBaselineAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 319
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$12;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$12;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 332
    return-void
.end method

.method public static runAutomaticAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 160
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;-><init>()V

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 183
    return-void
.end method

.method public static saveConfigurationAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 1

    .line 188
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$6;

    invoke-direct {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$6;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p0, p3, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V

    .line 223
    return-void
.end method

.method private static submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V
    .locals 3

    .line 336
    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    .line 339
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 340
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->BUSY:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-nez v0, :cond_0

    .line 341
    sget-object p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$13;

    invoke-direct {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$13;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Landroid/content/Context;)V

    invoke-interface {p2, v0}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 346
    return-void

    .line 348
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;

    invoke-direct {v1, p2, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 384
    return-void

    .line 337
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Rime synchronization callback is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
