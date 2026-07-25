.class Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


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

.field final synthetic val$context:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V
    .registers 3

    .line 30
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 32
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;->val$context:Landroid/content/Context;

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->inspect(Landroid/content/Context;)Ljava/lang/String;
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->access$000(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 33
    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->access$100()Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$1;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 36
    return-void
.end method
