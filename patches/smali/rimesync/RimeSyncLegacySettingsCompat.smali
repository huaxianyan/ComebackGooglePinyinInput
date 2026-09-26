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

.field private static final DOCUMENTS_FALLBACK:Ljava/lang/String; = "primary:Documents"

.field private static final EXTERNAL_STORAGE_AUTHORITY:Ljava/lang/String; = "com.android.externalstorage.documents"

.field private static final KEY_AUTO_ENABLED:Ljava/lang/String; = "rime_sync_auto_enabled"

.field private static final KEY_AUTO_INTERVAL:Ljava/lang/String; = "rime_sync_auto_interval_hours"

.field private static final KEY_DEVICE:Ljava/lang/String; = "rime_sync_device"

.field private static final KEY_NOW:Ljava/lang/String; = "rime_sync_now"

.field private static final KEY_RESET:Ljava/lang/String; = "rime_sync_reset"

.field private static final KEY_ROOT:Ljava/lang/String; = "rime_sync_root"

.field private static final KEY_SNAPSHOT:Ljava/lang/String; = "rime_sync_snapshot_file"

.field private static final KEY_STATUS:Ljava/lang/String; = "rime_sync_current_status"

.field private static final PROBE_DEVICE_NAME:Ljava/lang/String; = "probe"

.field private static final REQUEST_TREE:I = 0x6b02


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 50
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$400(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->describeRoot(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$700(I)Ljava/lang/String;
    .locals 0

    .line 35
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->errorName(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    .locals 0

    .line 35
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$900(Ljava/lang/String;)Z
    .locals 0

    .line 35
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->isValidSnapshot(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static bind(Landroid/preference/PreferenceFragment;)V
    .locals 3

    .line 56
    if-eqz p0, :cond_2

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 57
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 58
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    .line 59
    if-eqz v1, :cond_1

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->destroy()V

    .line 60
    :cond_1
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;-><init>(Landroid/preference/PreferenceFragment;)V

    .line 61
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v2, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 62
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->bind()V

    .line 63
    monitor-exit v0

    .line 64
    return-void

    .line 63
    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    .line 56
    :cond_2
    :goto_0
    return-void
.end method

.method private static describeRoot(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 6

    .line 159
    invoke-virtual {p1}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object v0

    .line 160
    const-string v1, "com.android.externalstorage.documents"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const-string v2, ""

    const/4 v3, 0x0

    if-eqz v1, :cond_4

    .line 162
    :try_start_0
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p1

    .line 163
    const/16 v1, 0x3a

    invoke-virtual {p1, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    .line 164
    if-gez v1, :cond_0

    move-object v4, p1

    goto :goto_0

    :cond_0
    invoke-virtual {p1, v3, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    .line 165
    :goto_0
    const/4 v5, 0x1

    if-gez v1, :cond_1

    move-object p1, v2

    goto :goto_1

    :cond_1
    add-int/2addr v1, v5

    invoke-virtual {p1, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    .line 166
    :goto_1
    const-string v1, "primary"

    invoke-virtual {v1, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 167
    const-string v1, "rime_sync_root_internal"

    new-array v4, v3, [Ljava/lang/Object;

    invoke-static {p0, v1, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    goto :goto_2

    .line 168
    :cond_2
    const-string v1, "rime_sync_root_removable"

    new-array v5, v5, [Ljava/lang/Object;

    aput-object v4, v5, v3

    invoke-static {p0, v1, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    .line 169
    :goto_2
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v4

    if-nez v4, :cond_3

    :goto_3
    goto :goto_4

    :cond_3
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, "/"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_3

    :goto_4
    return-object v1

    .line 170
    :catch_0
    move-exception p1

    .line 174
    :cond_4
    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    .line 175
    if-nez v0, :cond_5

    move-object v0, v2

    :cond_5
    invoke-virtual {p1, v0, v3}, Landroid/content/pm/PackageManager;->resolveContentProvider(Ljava/lang/String;I)Landroid/content/pm/ProviderInfo;

    move-result-object p1

    .line 176
    if-eqz p1, :cond_6

    .line 177
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/content/pm/ProviderInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;

    move-result-object p1

    .line 178
    if-eqz p1, :cond_6

    invoke-interface {p1}, Ljava/lang/CharSequence;->length()I

    move-result v0

    if-lez v0, :cond_6

    invoke-interface {p1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    return-object p0

    .line 181
    :cond_6
    goto :goto_5

    .line 180
    :catch_1
    move-exception p1

    .line 182
    :goto_5
    const-string p1, "rime_sync_root_selected"

    new-array v0, v3, [Ljava/lang/Object;

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static errorName(I)Ljava/lang/String;
    .locals 0

    .line 108
    packed-switch p0, :pswitch_data_0

    .line 144
    :pswitch_0
    const-string p0, "rime_sync_error_failed"

    return-object p0

    .line 142
    :pswitch_1
    const-string p0, "rime_sync_error_bridge_missing"

    return-object p0

    .line 140
    :pswitch_2
    const-string p0, "rime_sync_error_directory_identity"

    return-object p0

    .line 138
    :pswitch_3
    const-string p0, "rime_sync_error_session_plan"

    return-object p0

    .line 136
    :pswitch_4
    const-string p0, "rime_sync_error_google_export"

    return-object p0

    .line 134
    :pswitch_5
    const-string p0, "rime_sync_error_rime_merge"

    return-object p0

    .line 132
    :pswitch_6
    const-string p0, "rime_sync_error_source_close"

    return-object p0

    .line 130
    :pswitch_7
    const-string p0, "rime_sync_error_source_database"

    return-object p0

    .line 128
    :pswitch_8
    const-string p0, "rime_sync_error_source_parse"

    return-object p0

    .line 126
    :pswitch_9
    const-string p0, "rime_sync_error_source_open"

    return-object p0

    .line 124
    :pswitch_a
    const-string p0, "rime_sync_error_source_list"

    return-object p0

    .line 122
    :pswitch_b
    const-string p0, "rime_sync_error_native_persistence"

    return-object p0

    .line 120
    :pswitch_c
    const-string p0, "rime_sync_error_capacity"

    return-object p0

    .line 118
    :pswitch_d
    const-string p0, "rime_sync_error_confirmation"

    return-object p0

    .line 116
    :pswitch_e
    const-string p0, "rime_sync_error_preview_changed"

    return-object p0

    .line 114
    :pswitch_f
    const-string p0, "rime_sync_error_in_progress"

    return-object p0

    .line 112
    :pswitch_10
    const-string p0, "rime_sync_error_location"

    return-object p0

    .line 110
    :pswitch_11
    const-string p0, "rime_sync_error_configuration"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_0
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public static handleActivityResult(Landroid/preference/PreferenceFragment;IILandroid/content/Intent;)Z
    .locals 1

    .line 69
    const/16 v0, 0x6b02

    if-eq p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 71
    :cond_0
    sget-object p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter p1

    :try_start_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 72
    if-eqz p0, :cond_1

    invoke-virtual {p0, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->onTreeResult(ILandroid/content/Intent;)V

    .line 73
    :cond_1
    const/4 p0, 0x1

    return p0

    .line 71
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static handleRequestPermissionsResult(Landroid/preference/PreferenceFragment;I[Ljava/lang/String;[I)Z
    .locals 0

    .line 78
    const/4 p0, 0x0

    return p0
.end method

.method private static isValidSnapshot(Ljava/lang/String;)Z
    .locals 2

    .line 151
    :try_start_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    const-string v1, "probe"

    invoke-direct {v0, v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    .line 152
    const/4 p0, 0x1

    return p0

    .line 153
    :catch_0
    move-exception p0

    .line 154
    const/4 p0, 0x0

    return p0
.end method

.method public static refresh(Landroid/preference/PreferenceFragment;)V
    .locals 2

    .line 83
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

    .line 84
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 85
    :cond_0
    return-void

    .line 83
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

    .line 95
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 96
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    .line 95
    const-string v2, "string"

    invoke-virtual {v0, p1, v2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    .line 97
    if-nez v0, :cond_0

    return-object p1

    .line 98
    :cond_0
    array-length p1, p2

    if-nez p1, :cond_1

    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 99
    :cond_1
    invoke-virtual {p0, v0, p2}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static toast(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 103
    if-nez p0, :cond_0

    return-void

    .line 104
    :cond_0
    const/4 v0, 0x0

    new-array v1, v0, [Ljava/lang/Object;

    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->text(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 105
    return-void
.end method

.method public static unbind(Landroid/preference/PreferenceFragment;)V
    .locals 2

    .line 88
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 89
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    .line 90
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->destroy()V

    .line 91
    :cond_0
    monitor-exit v0

    .line 92
    return-void

    .line 91
    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
