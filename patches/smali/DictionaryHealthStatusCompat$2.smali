.class Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->loadSnapshot(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;

.field final synthetic val$context:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 46
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$SnapshotCallback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 48
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->access$000(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;

    move-result-object v0

    .line 49
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->access$100()Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$2;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 52
    return-void
.end method
