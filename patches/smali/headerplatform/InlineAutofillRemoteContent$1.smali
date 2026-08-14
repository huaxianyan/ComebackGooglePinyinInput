.class Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$1;
.super Ljava/lang/Object;
.source "InlineAutofillRemoteContent.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;)V
    .locals 0

    .line 65
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$1;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 67
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillFeedbackCompat;->perform(Landroid/view/View;)V

    .line 68
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$1;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent$1;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;)I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;->access$100(Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;I)V

    .line 69
    return-void
.end method
