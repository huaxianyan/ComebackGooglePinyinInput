.class Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;
.super Ljava/lang/Object;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->startNativeImport(Landroid/content/Context;Landroid/net/Uri;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$app:Landroid/content/Context;

.field final synthetic val$uri:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 87
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$app:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$uri:Landroid/net/Uri;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 7

    .line 91
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$app:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$uri:Landroid/net/Uri;

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->access$100(Landroid/content/Context;Landroid/net/Uri;)[B

    move-result-object v0

    .line 92
    const-string v1, "bdt"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "a"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    .line 93
    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$app:Landroid/content/Context;

    new-array v3, v3, [Ljava/lang/Object;

    aput-object v2, v3, v6

    const/4 v2, 0x0

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 94
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$app:Landroid/content/Context;

    check-cast v1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;

    invoke-static {v2, v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;->importBackup(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;[B)I

    move-result v0

    .line 96
    if-lez v0, :cond_0

    .line 97
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5df2\u5bfc\u5165 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u6761\u8bcd\u6761"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 98
    :cond_0
    const-string v0, "\u5907\u4efd\u91cc\u6ca1\u6709\u53ef\u5bfc\u5165\u7684\u8bcd\u6761"

    .line 99
    :goto_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$app:Landroid/content/Context;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->request(Landroid/content/Context;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 103
    goto :goto_1

    .line 100
    :catchall_0
    move-exception v0

    .line 101
    const-string v1, "PinyinImport"

    const-string v2, "backup import failed"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 102
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5bfc\u5165\u672a\u5b8c\u6210\uff1a"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 104
    :goto_1
    nop

    .line 105
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v2, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 110
    return-void
.end method
