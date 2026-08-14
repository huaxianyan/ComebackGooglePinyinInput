.class public final Lcom/google/android/inputmethod/pinyin/InlineAutofillFeedbackCompat;
.super Ljava/lang/Object;

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static perform(Landroid/view/View;)V
    .locals 3

    if-eqz p0, :done

    new-instance v0, Laue;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Laue;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    invoke-virtual {v0, p0, v2}, Laue;->a(Landroid/view/View;Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;)V

    invoke-virtual {v0}, Laue;->a()V

    :done
    return-void
.end method
