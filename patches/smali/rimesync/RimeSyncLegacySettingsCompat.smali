.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;
.super Ljava/lang/Object;
.source "RimeSyncLegacySettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;
    }
.end annotation


# static fields
.field private static final CONTROLLERS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/preference/PreferenceFragment;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;",
            ">;"
        }
    .end annotation
.end field

.field private static final KEY_AUTO_ENABLED:Ljava/lang/String; = "rime_sync_auto_enabled"

.field private static final KEY_AUTO_INTERVAL:Ljava/lang/String; = "rime_sync_auto_interval_hours"

.field private static final KEY_DEVICE:Ljava/lang/String; = "rime_sync_device"

.field private static final KEY_NOW:Ljava/lang/String; = "rime_sync_now"

.field private static final KEY_RESET:Ljava/lang/String; = "rime_sync_reset"

.field private static final KEY_ROOT:Ljava/lang/String; = "rime_sync_root"

.field private static final KEY_SNAPSHOT:Ljava/lang/String; = "rime_sync_snapshot_file"

.field private static final KEY_STATUS:Ljava/lang/String; = "rime_sync_current_status"

.field private static final REQUEST_TREE:I = 0x6b02


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 35
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    .locals 0

    .line 23
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static bind(Landroid/preference/PreferenceFragment;)V
    .locals 3

    .line 41
    if-eqz p0, :cond_2

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 42
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 43
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    .line 44
    if-eqz v1, :cond_1

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->destroy()V

    .line 45
    :cond_1
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;-><init>(Landroid/preference/PreferenceFragment;)V

    .line 46
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v2, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 47
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->bind()V

    .line 48
    monitor-exit v0

    .line 49
    return-void

    .line 48
    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    .line 41
    :cond_2
    :goto_0
    return-void
.end method

.method public static handleActivityResult(Landroid/preference/PreferenceFragment;IILandroid/content/Intent;)Z
    .locals 0

    .line 54
    const/16 p0, 0x6b02

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public static handleRequestPermissionsResult(Landroid/preference/PreferenceFragment;I[Ljava/lang/String;[I)Z
    .locals 0

    .line 59
    const/4 p0, 0x0

    return p0
.end method

.method public static refresh(Landroid/preference/PreferenceFragment;)V
    .locals 2

    .line 64
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 65
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 66
    :cond_0
    return-void

    .line 64
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private static varargs text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    .locals 3

    .line 76
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 77
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    .line 76
    const-string v2, "string"

    invoke-virtual {v0, p1, v2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    .line 78
    if-nez v0, :cond_0

    return-object p1

    .line 79
    :cond_0
    array-length p1, p2

    if-nez p1, :cond_1

    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 80
    :cond_1
    invoke-virtual {p0, v0, p2}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static unbind(Landroid/preference/PreferenceFragment;)V
    .locals 2

    .line 69
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 70
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    .line 71
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->destroy()V

    .line 72
    :cond_0
    monitor-exit v0

    .line 73
    return-void

    .line 72
    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
