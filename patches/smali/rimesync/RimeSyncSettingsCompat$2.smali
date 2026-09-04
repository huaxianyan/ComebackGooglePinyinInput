.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->saveConfigurationAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$deviceDirectory:Ljava/lang/String;

.field final synthetic val$snapshotFile:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 104
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;->val$deviceDirectory:Ljava/lang/String;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;->val$snapshotFile:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 106
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;->val$deviceDirectory:Ljava/lang/String;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$2;->val$snapshotFile:Ljava/lang/String;

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 108
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$000(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 109
    const-string v2, "rime_sync_root_uri"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 110
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v3, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 112
    :try_start_0
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-lez v4, :cond_0

    .line 114
    :try_start_1
    new-instance v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    .line 115
    invoke-static {v2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    invoke-direct {v4, p1, v5, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V

    .line 116
    invoke-static {v3, v2, v0, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 119
    goto :goto_0

    .line 117
    :catch_0
    move-exception p1

    .line 118
    :try_start_2
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;

    invoke-direct {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;-><init>(Ljava/lang/Throwable;)V

    throw v0

    .line 121
    :cond_0
    :goto_0
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "rime_sync_device_directory"

    iget-object v4, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->deviceDirectoryName:Ljava/lang/String;

    .line 122
    invoke-interface {v1, v2, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "rime_sync_snapshot_file"

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;->snapshotFileName:Ljava/lang/String;

    .line 124
    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 126
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 128
    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 129
    nop

    .line 130
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1

    return-object p1

    .line 128
    :catchall_0
    move-exception p1

    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 129
    throw p1
.end method
