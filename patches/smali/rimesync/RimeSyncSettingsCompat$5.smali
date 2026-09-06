.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->runAutomaticAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 160
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

    .line 162
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    .line 163
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget-boolean v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v1, :cond_0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1

    return-object p1

    .line 164
    :cond_0
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureKind:I

    if-eqz v1, :cond_1

    .line 165
    const/16 p1, 0x8

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1

    return-object p1

    .line 167
    :cond_1
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$200(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    move-result-object v1

    .line 169
    :try_start_0
    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->phase:I

    if-eqz v0, :cond_2

    .line 170
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->recover()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v0

    .line 171
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->completed(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 179
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 171
    return-object p1

    .line 173
    :cond_2
    :try_start_1
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->preview()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;

    move-result-object v0

    .line 174
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    move-result-object v2

    iget-boolean v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v2, :cond_3

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 179
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 174
    return-object p1

    .line 175
    :cond_3
    :try_start_2
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->confirmationToken:Ljava/lang/String;

    const/4 v3, 0x1

    invoke-virtual {v2, v0, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->execute(Ljava/lang/String;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v0

    .line 177
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->completed(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 179
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 177
    return-object p1

    .line 179
    :catchall_0
    move-exception p1

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 180
    throw p1
.end method
