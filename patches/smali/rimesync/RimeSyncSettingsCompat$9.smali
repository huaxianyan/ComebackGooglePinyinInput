.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->submit(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;

.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$operation:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 256
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$operation:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$callback:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 260
    const/4 v0, 0x7

    const/16 v1, 0x8

    :try_start_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$operation:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-interface {v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Operation;->run(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0
    :try_end_0
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException; {:try_start_0 .. :try_end_0} :catch_a
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException; {:try_start_0 .. :try_end_0} :catch_9
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException; {:try_start_0 .. :try_end_0} :catch_8
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException; {:try_start_0 .. :try_end_0} :catch_7
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$RejectedEntriesException; {:try_start_0 .. :try_end_0} :catch_6
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PersistenceVerificationException; {:try_start_0 .. :try_end_0} :catch_5
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException; {:try_start_0 .. :try_end_0} :catch_4
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$LocationException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto/16 :goto_0

    .line 284
    :catchall_0
    move-exception v1

    .line 285
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto/16 :goto_1

    .line 282
    :catch_0
    move-exception v1

    .line 283
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto/16 :goto_0

    .line 280
    :catch_1
    move-exception v0

    .line 281
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    const/4 v1, 0x2

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto/16 :goto_0

    .line 278
    :catch_2
    move-exception v0

    .line 279
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    const/4 v1, 0x3

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 276
    :catch_3
    move-exception v0

    .line 277
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 274
    :catch_4
    move-exception v0

    .line 275
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 272
    :catch_5
    move-exception v0

    .line 273
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 270
    :catch_6
    move-exception v0

    .line 271
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 268
    :catch_7
    move-exception v0

    .line 269
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    const/4 v1, 0x6

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 266
    :catch_8
    move-exception v0

    .line 267
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    const/4 v1, 0x4

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 263
    :catch_9
    move-exception v0

    .line 264
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v0

    const/4 v1, 0x5

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    goto :goto_0

    .line 261
    :catch_a
    move-exception v0

    .line 262
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v1

    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;->stage:I

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$400(I)I

    move-result v0

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    .line 286
    :goto_0
    nop

    .line 287
    :goto_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$500()Ljava/util/concurrent/atomic/AtomicBoolean;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 288
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$callback:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$9;->val$context:Landroid/content/Context;

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->withSettings(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->access$600(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    .line 289
    return-void
.end method
