.class Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;
.super Ljava/lang/Object;
.source "HeaderActionSlot.java"

# interfaces
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->syncClipboardDividers(Landroid/view/View;Landroid/view/View;Landroid/view/View;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$candidateRoot:Landroid/view/View;

.field final synthetic val$left:Landroid/view/View;

.field final synthetic val$right:Landroid/view/View;

.field final synthetic val$source:Landroid/widget/ImageView;


# direct methods
.method constructor <init>(Landroid/view/View;Landroid/widget/ImageView;Landroid/view/View;Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 181
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$candidateRoot:Landroid/view/View;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$left:Landroid/view/View;

    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$right:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPreDraw()Z
    .locals 4

    .line 183
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$candidateRoot:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 184
    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 185
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getWidth()I

    move-result v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    invoke-virtual {v1}, Landroid/widget/ImageView;->getPaddingLeft()I

    move-result v1

    sub-int/2addr v0, v1

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    .line 186
    invoke-virtual {v1}, Landroid/widget/ImageView;->getPaddingRight()I

    move-result v1

    sub-int/2addr v0, v1

    .line 187
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    invoke-virtual {v1}, Landroid/widget/ImageView;->getHeight()I

    move-result v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    invoke-virtual {v2}, Landroid/widget/ImageView;->getPaddingTop()I

    move-result v2

    sub-int/2addr v1, v2

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$source:Landroid/widget/ImageView;

    .line 188
    invoke-virtual {v2}, Landroid/widget/ImageView;->getPaddingBottom()I

    move-result v2

    sub-int/2addr v1, v2

    .line 189
    if-lez v0, :cond_2

    if-lez v1, :cond_2

    .line 190
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$candidateRoot:Landroid/view/View;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$left:Landroid/view/View;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$right:Landroid/view/View;

    const/4 v3, 0x0

    invoke-static {v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->access$000(Landroid/view/View;Landroid/view/View;Landroid/view/View;Z)V

    .line 191
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$left:Landroid/view/View;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$left:Landroid/view/View;

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 192
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$right:Landroid/view/View;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;->val$right:Landroid/view/View;

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 194
    :cond_2
    const/4 v0, 0x1

    return v0
.end method
