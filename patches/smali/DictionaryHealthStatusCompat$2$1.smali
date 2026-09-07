.class Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;

.field final synthetic val$snapshot:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 49
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;->val$snapshot:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 50
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;->val$snapshot:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;->onLoaded(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;)V

    return-void
.end method
