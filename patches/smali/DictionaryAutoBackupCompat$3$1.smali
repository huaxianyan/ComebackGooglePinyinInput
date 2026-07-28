.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

.field final synthetic val$entries:Ljava/util/List;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;Ljava/util/List;)V
    .registers 3

    .line 313
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;->val$entries:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 314
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3$1;->val$entries:Ljava/util/List;

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;->onBackupListLoaded(Ljava/util/List;)V

    return-void
.end method
