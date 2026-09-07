.class Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->load(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 36
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLoaded(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;)V
    .locals 3

    .line 38
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;->summary:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;->details:Ljava/lang/String;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;->onLoaded(Ljava/lang/String;)V

    .line 39
    return-void
.end method
