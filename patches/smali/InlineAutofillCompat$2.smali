.class Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;
.super Ljava/lang/Object;
.source "InlineAutofillCompat.java"

# interfaces
.implements Ljava/util/function/Consumer;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->handleResponse(Landroid/content/Context;Landroid/view/inputmethod/InlineSuggestionsResponse;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/function/Consumer<",
        "Landroid/widget/inline/InlineContentView;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic val$callbackGeneration:I

.field final synthetic val$index:I

.field final synthetic val$moduleReference:Ljava/lang/ref/WeakReference;


# direct methods
.method constructor <init>(ILjava/lang/ref/WeakReference;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 235
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->val$callbackGeneration:I

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->val$moduleReference:Ljava/lang/ref/WeakReference;

    iput p3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public accept(Landroid/widget/inline/InlineContentView;)V
    .locals 3

    .line 238
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->val$callbackGeneration:I

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->val$moduleReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->val$index:I

    invoke-static {v0, v1, v2, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->access$000(ILcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;ILandroid/view/View;)V

    .line 239
    return-void
.end method

.method public bridge synthetic accept(Ljava/lang/Object;)V
    .locals 0

    .line 235
    check-cast p1, Landroid/widget/inline/InlineContentView;

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat$2;->accept(Landroid/widget/inline/InlineContentView;)V

    return-void
.end method
