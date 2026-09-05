.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->deliver(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;

.field final synthetic val$result:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 391
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;->val$callback:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;->val$result:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 393
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;->val$callback:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$14;->val$result:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;->onFinished(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    .line 394
    return-void
.end method
