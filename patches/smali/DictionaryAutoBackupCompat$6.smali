.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishSuccess(Landroid/content/Context;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$force:Z


# direct methods
.method constructor <init>(ZLandroid/content/Context;)V
    .registers 3

    .line 485
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$force:Z

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 487
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 488
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$force:Z

    if-eqz v0, :cond_e

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;->val$context:Landroid/content/Context;

    const-string v1, "\u7528\u6237\u8bcd\u5178\u5907\u4efd\u6210\u529f"

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1500(Landroid/content/Context;Ljava/lang/String;)V

    .line 489
    :cond_e
    return-void
.end method
