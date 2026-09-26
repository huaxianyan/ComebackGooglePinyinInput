.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;
.super Ljava/lang/Object;
.source "RimeSyncLegacySettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronize()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V
    .locals 0

    .line 494
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFinished(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 3

    .line 496
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$500(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)Landroid/content/Context;

    move-result-object v0

    .line 497
    if-eqz v0, :cond_5

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$200(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)Landroid/preference/PreferenceFragment;

    move-result-object v1

    if-nez v1, :cond_0

    goto :goto_0

    .line 498
    :cond_0
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$302(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 499
    :cond_1
    iget-boolean v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success:Z

    if-nez v1, :cond_3

    .line 501
    iget v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->errorCode:I

    const/16 v2, 0x13

    if-ne v1, v2, :cond_2

    .line 503
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$1200(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    .line 504
    return-void

    .line 506
    :cond_2
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->errorCode:I

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$700(I)Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$000(Landroid/content/Context;Ljava/lang/String;)V

    .line 507
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyState()V

    .line 508
    return-void

    .line 510
    :cond_3
    iget-boolean v1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->preview:Z

    if-eqz v1, :cond_4

    .line 511
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyState()V

    .line 512
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$1300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    .line 513
    return-void

    .line 515
    :cond_4
    const-string p1, "rime_sync_success"

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$000(Landroid/content/Context;Ljava/lang/String;)V

    .line 516
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyState()V

    .line 517
    return-void

    .line 497
    :cond_5
    :goto_0
    return-void
.end method
