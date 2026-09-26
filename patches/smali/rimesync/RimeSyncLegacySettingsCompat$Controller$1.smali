.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;
.super Ljava/lang/Object;
.source "RimeSyncLegacySettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

.field final synthetic val$generation:I


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 319
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->val$generation:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFinished(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 2

    .line 321
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->val$generation:I

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)I

    move-result v1

    if-ne v0, v1, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$200(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)Landroid/preference/PreferenceFragment;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 322
    :cond_0
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$302(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 323
    :cond_1
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyState()V

    .line 324
    return-void

    .line 321
    :cond_2
    :goto_0
    return-void
.end method
