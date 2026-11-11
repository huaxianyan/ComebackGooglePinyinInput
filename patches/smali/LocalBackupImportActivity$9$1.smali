.class Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;
.super Ljava/lang/Object;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;

.field final synthetic val$text:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 105
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;->val$text:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 107
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;->val$app:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9$1;->val$text:Ljava/lang/String;

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 108
    return-void
.end method
