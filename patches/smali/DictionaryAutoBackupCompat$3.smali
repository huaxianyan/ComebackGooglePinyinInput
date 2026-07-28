.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackupsAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;

.field final synthetic val$context:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V
    .registers 3

    .line 310
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 312
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->val$context:Landroid/content/Context;

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listConfiguredBackups(Landroid/content/Context;)Ljava/util/List;
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1200(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    .line 313
    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1300()Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;Ljava/util/List;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 316
    return-void
.end method
