.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->onTaskFinished(ZLjava/lang/Object;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

.field final synthetic val$success:Z


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;Z)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 255
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->val$success:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 257
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->val$success:Z

    if-nez v0, :cond_1

    .line 258
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$400(Landroid/content/Context;Landroid/net/Uri;)V

    .line 259
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$500(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Z

    move-result v1

    .line 260
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$600(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)I

    move-result v2

    if-nez v2, :cond_0

    const-string v2, "\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa\u5931\u8d25"

    goto :goto_0

    .line 261
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa\u5931\u8d25\uff08"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$600(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\uff09"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_0
    nop

    .line 259
    const/4 v3, 0x0

    invoke-static {v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$700(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 262
    return-void

    .line 264
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$800(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$900(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Ljava/lang/String;

    move-result-object v3

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$500(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Z

    move-result v4

    invoke-static {v0, v1, v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1000(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 265
    return-void
.end method
