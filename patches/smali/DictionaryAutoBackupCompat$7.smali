.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$force:Z

.field final synthetic val$message:Ljava/lang/String;


# direct methods
.method constructor <init>(ZLandroid/content/Context;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 599
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;->val$force:Z

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;->val$context:Landroid/content/Context;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;->val$message:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 601
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 602
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;->val$force:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;->val$message:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1500(Landroid/content/Context;Ljava/lang/String;)V

    .line 603
    :cond_0
    return-void
.end method
