.class Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;
.super Ljava/lang/Object;
.source "InlineAutofillCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->handleResponse(Landroid/content/Context;Landroid/view/inputmethod/InlineSuggestionsResponse;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callbackGeneration:I

.field final synthetic val$moduleReference:Ljava/lang/ref/WeakReference;


# direct methods
.method constructor <init>(ILjava/lang/ref/WeakReference;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 250
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;->val$callbackGeneration:I

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;->val$moduleReference:Ljava/lang/ref/WeakReference;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 253
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;->val$callbackGeneration:I

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$3;->val$moduleReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->access$100(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;)V

    .line 254
    return-void
.end method
