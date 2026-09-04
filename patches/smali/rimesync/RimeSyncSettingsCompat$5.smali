.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->executeAsync(Landroid/content/Context;Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$confirmationToken:Ljava/lang/String;

.field final synthetic val$deletionConfirmed:Z


# direct methods
.method constructor <init>(Ljava/lang/String;Z)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 188
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;->val$confirmationToken:Ljava/lang/String;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;->val$deletionConfirmed:Z

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

    .line 190
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$300(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;

    move-result-object v0

    .line 192
    :try_start_0
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;->val$confirmationToken:Ljava/lang/String;

    iget-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$5;->val$deletionConfirmed:Z

    invoke-virtual {v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;->execute(Ljava/lang/String;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;

    move-result-object v1

    .line 194
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->completed(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 196
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 194
    return-object p1

    .line 196
    :catchall_0
    move-exception p1

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->close()V

    .line 197
    throw p1
.end method
