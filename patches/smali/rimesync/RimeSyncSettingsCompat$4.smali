.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$4;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->previewAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 165
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 167
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$300(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    move-result-object v0

    .line 169
    :try_start_0
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->preview()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;

    move-result-object v1

    .line 170
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->preview(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 172
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 170
    return-object p1

    .line 172
    :catchall_0
    move-exception p1

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 173
    throw p1
.end method
