.class Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;

.field final synthetic val$summary:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;Ljava/lang/String;)V
    .registers 3

    .line 33
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;->val$summary:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 34
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;->val$summary:Ljava/lang/String;

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;->onLoaded(Ljava/lang/String;)V

    return-void
.end method
