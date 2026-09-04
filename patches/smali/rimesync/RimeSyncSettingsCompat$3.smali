.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->acceptRootAsync(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$label:Ljava/lang/String;

.field final synthetic val$root:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/net/Uri;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 137
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$root:Landroid/net/Uri;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$label:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 139
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$200(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;

    move-result-object v0

    .line 142
    :try_start_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$root:Landroid/net/Uri;

    invoke-direct {v1, p1, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;)V

    .line 143
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listSnapshots()Ljava/util/List;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 146
    nop

    .line 147
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 149
    :try_start_1
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$root:Landroid/net/Uri;

    invoke-virtual {v3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncConfiguration;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 153
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 154
    nop

    .line 155
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$000(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$root:Landroid/net/Uri;

    .line 156
    invoke-virtual {v1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "rime_sync_root_uri"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 157
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$label:Ljava/lang/String;

    if-nez v1, :cond_0

    const-string v1, ""

    goto :goto_0

    :cond_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$3;->val$label:Ljava/lang/String;

    :goto_0
    const-string v2, "rime_sync_root_label"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 158
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 159
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1

    return-object p1

    .line 153
    :catchall_0
    move-exception p1

    goto :goto_1

    .line 150
    :catch_0
    move-exception p1

    .line 151
    :try_start_2
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;

    invoke-direct {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;-><init>(Ljava/lang/Throwable;)V

    throw v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 153
    :goto_1
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 154
    throw p1

    .line 144
    :catch_1
    move-exception p1

    .line 145
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;

    invoke-direct {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException;-><init>(Ljava/lang/Throwable;)V

    throw v0
.end method
