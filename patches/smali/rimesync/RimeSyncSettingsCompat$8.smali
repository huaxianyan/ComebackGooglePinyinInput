.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$8;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->resetBaselineAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 225
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 1

    .line 227
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-direct {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;-><init>(Landroid/content/Context;)V

    .line 229
    :try_start_0
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->resetBaseline()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 231
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 232
    nop

    .line 233
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object p1

    return-object p1

    .line 231
    :catchall_0
    move-exception p1

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 232
    throw p1
.end method
